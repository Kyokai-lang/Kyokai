#!/usr/bin/env python3
# kyokai:prooftrace id=TOOL-SPEC-CLAUSE-EXTRACTION
"""Validate clause-level extraction evidence and render its review sheet."""

from __future__ import annotations

import argparse
import hashlib
import re
import sys
import tomllib
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
REGISTRY = ROOT / "kyokaispec/extraction/d558-d625.toml"
REPORT = ROOT / "kyokaispec/extraction/d558-d625-review.md"
ACCEPTED = ROOT / "kyokaidecided.md"
TRACEABILITY = ROOT / "kyokaispec/src/project/02-decision-traceability.md"

CATEGORIES = (
    "syntax-api",
    "static",
    "dynamic",
    "ownership",
    "borrow",
    "capability",
    "failure",
    "artifact",
    "diagnostic",
    "compatibility",
    "target",
    "example",
    "illegal-form",
    "conformance",
)
LIVE_STATES = {"complete"}
ALL_STATES = LIVE_STATES | {"superseded"}
PROOF_IMPACTS = {"MODEL_AFFECTING", "MAPPING_ONLY", "NO_SEMANTIC_IMPACT"}
PROJECTION_KINDS = {"traceability", "maturity", "gate"}
DECISION_RE = re.compile(r"^D(?:\d+|\d+[a-z])$")


class Errors:
    def __init__(self) -> None:
        self.items: list[str] = []

    def add(self, message: str) -> None:
        self.items.append(message)

    def finish(self) -> None:
        if not self.items:
            return
        for item in self.items:
            print(f"clause-extraction: error: {item}", file=sys.stderr)
        raise SystemExit(1)


def decision_sort_key(decision_id: str) -> tuple[int, str]:
    match = re.fullmatch(r"D(\d+)([a-z]?)", decision_id)
    if match is None:
        return (10**9, decision_id)
    return (int(match.group(1)), match.group(2))


def expand_decision_ids(text: str) -> set[str]:
    result: set[str] = set()
    for token in re.findall(r"D\d+[a-z]?(?:-D?\d+)?", text.replace("–", "-")):
        interval = re.fullmatch(r"D(\d+)-D?(\d+)", token)
        if interval:
            result.update(f"D{number}" for number in range(int(interval[1]), int(interval[2]) + 1))
        else:
            result.add(token)
    return result


def accepted_decision_ids_before(text: str, upper_bound: int) -> set[str]:
    """Discover accepted IDs without consulting the traceability projection."""
    result: set[str] = set()
    for line in text.splitlines():
        is_decision_heading = re.match(r"^#{2,6} D\d", line) is not None
        is_accepted_marker = "[STAGE:" in line or "[DECIDED:" in line
        if not (is_decision_heading or is_accepted_marker):
            continue
        for decision_id in expand_decision_ids(line):
            if decision_sort_key(decision_id)[0] < upper_bound:
                result.add(decision_id)
    return result


def read_registry() -> dict:
    with REGISTRY.open("rb") as handle:
        return tomllib.load(handle)


def extract_heading_section(text: str, heading: str) -> tuple[int, int, str] | None:
    lines = text.splitlines(keepends=True)
    starts = [index for index, line in enumerate(lines) if line.rstrip("\n") == heading]
    if len(starts) != 1:
        return None
    start = starts[0]
    level = len(heading) - len(heading.lstrip("#"))
    end = len(lines)
    for index in range(start + 1, len(lines)):
        candidate = lines[index]
        if not candidate.startswith("#"):
            continue
        candidate_level = len(candidate) - len(candidate.lstrip("#"))
        if candidate_level <= level:
            end = index
            break
    return (start + 1, end, "".join(lines[start:end]))


def extract_anchor_section(text: str, anchor: str) -> tuple[int, int, str] | None:
    """Return the smallest stable paragraph or list item containing a legacy anchor."""
    lines = text.splitlines(keepends=True)
    matches = [index for index, line in enumerate(lines) if anchor in line]
    if len(matches) != 1:
        return None
    pivot = matches[0]
    start = pivot
    while start > 0:
        previous = lines[start - 1]
        if not previous.strip() or previous.startswith("#"):
            break
        if previous.startswith("- "):
            start -= 1
            break
        start -= 1
    end = pivot + 1
    while end < len(lines):
        candidate = lines[end]
        if not candidate.strip() or candidate.startswith("#") or candidate.startswith("- "):
            break
        end += 1
    return (start + 1, end, "".join(lines[start:end]))


def validate_relative_path(errors: Errors, decision_id: str, raw: str) -> Path | None:
    path = Path(raw)
    if path.is_absolute() or ".." in path.parts:
        errors.add(f"{decision_id}: destination must be repository-relative: {raw}")
        return None
    resolved = ROOT / path
    if not resolved.is_file() and resolved != REPORT:
        errors.add(f"{decision_id}: destination does not exist: {raw}")
        return None
    return resolved


def trace_row_count(trace_text: str, trace_cell: str) -> int:
    pattern = re.compile(rf"^\| {re.escape(trace_cell)} \|", re.MULTILINE)
    return len(pattern.findall(trace_text))


def validate_registry(data: dict) -> tuple[list[dict], dict[str, tuple[int, int, str]]]:
    errors = Errors()
    if data.get("schema_version") != 1:
        errors.add("schema_version must be 1")

    review = data.get("review", {})
    for field in ("reviewer", "review_class", "reviewed_revision", "accepted_cutoff", "date", "basis"):
        if not review.get(field):
            errors.add(f"review.{field} is required")
    if review.get("review_class") != "lead-maintainer-directed-extraction":
        errors.add("review.review_class must state lead-maintainer-directed-extraction")

    evidence_links = data.get("policy", {}).get("evidence_links", [])
    if not evidence_links:
        errors.add("policy.evidence_links is required for every expanded clause")
    for raw in evidence_links:
        validate_relative_path(errors, "policy.evidence_links", raw)

    projections = data.get("projection", [])
    projection_kinds = {item.get("kind") for item in projections}
    missing_projection_kinds = PROJECTION_KINDS - projection_kinds
    if missing_projection_kinds:
        errors.add(
            "checked projections must cover traceability, maturity, and Gate A: "
            f"missing={sorted(missing_projection_kinds)}"
        )
    for index, projection in enumerate(projections, start=1):
        label = f"projection[{index}]"
        kind = projection.get("kind")
        if kind not in PROJECTION_KINDS:
            errors.add(f"{label}: invalid kind {kind!r}")
        raw_path = projection.get("path", "")
        path = validate_relative_path(errors, label, raw_path)
        required_terms = projection.get("required_terms", [])
        if not required_terms:
            errors.add(f"{label}: required_terms is empty")
        if path is None:
            continue
        projection_text = path.read_text(encoding="utf-8")
        for term in required_terms:
            if term not in projection_text:
                errors.add(f"{label}: required projection term is absent: {term!r}")
        for term in projection.get("forbidden_terms", []):
            if term in projection_text:
                errors.add(f"{label}: stale projection term remains: {term!r}")

    required = data.get("required_decisions", [])
    decisions = data.get("decision", [])
    ids = [item.get("id", "") for item in decisions]
    if len(ids) != len(set(ids)):
        errors.add("decision IDs must be unique")
    if set(ids) != set(required):
        errors.add(
            "required_decisions and [[decision]] IDs differ: "
            f"missing={sorted(set(required) - set(ids), key=decision_sort_key)}, "
            f"extra={sorted(set(ids) - set(required), key=decision_sort_key)}"
        )

    accepted_text = ACCEPTED.read_text(encoding="utf-8")
    accepted_inventory_before = data.get("policy", {}).get("accepted_inventory_before")
    if accepted_inventory_before is not None:
        if not isinstance(accepted_inventory_before, int) or accepted_inventory_before < 1:
            errors.add("policy.accepted_inventory_before must be a positive integer")
        else:
            discovered = accepted_decision_ids_before(
                accepted_text, accepted_inventory_before
            )
            missing_accepted = discovered - set(required)
            if missing_accepted:
                errors.add(
                    "accepted-source decisions are absent from required_decisions: "
                    f"{sorted(missing_accepted, key=decision_sort_key)}"
                )
    trace_text = TRACEABILITY.read_text(encoding="utf-8")
    sections: dict[str, tuple[int, int, str]] = {}
    seen_clause_ids: set[str] = set()
    rejection_check_count = 0

    for item in decisions:
        decision_id = item.get("id", "<missing-id>")
        if not DECISION_RE.fullmatch(decision_id):
            errors.add(f"{decision_id}: invalid decision ID")
        state = item.get("state")
        if state not in ALL_STATES:
            errors.add(f"{decision_id}: invalid state {state!r}")
        trace_cell = item.get("trace_cell", decision_id)
        if decision_id not in expand_decision_ids(trace_cell):
            errors.add(f"{decision_id}: trace_cell does not name the decision: {trace_cell!r}")
        if trace_row_count(trace_text, trace_cell) != 1:
            errors.add(
                f"{decision_id}: traceability must contain exactly one canonical row "
                f"for cell {trace_cell!r}"
            )

        if state == "superseded":
            if not item.get("superseded_by") or not item.get("supersession_reason"):
                errors.add(f"{decision_id}: superseded entries need an edge and reason")
            continue

        heading = item.get("source_heading")
        anchor = item.get("source_anchor")
        if bool(heading) == bool(anchor):
            errors.add(f"{decision_id}: exactly one of source_heading/source_anchor is required")
            continue
        section = (
            extract_heading_section(accepted_text, heading)
            if heading
            else extract_anchor_section(accepted_text, anchor)
        )
        if section is None:
            source_name = heading if heading else anchor
            errors.add(f"{decision_id}: accepted source is absent or ambiguous: {source_name}")
        else:
            sections[decision_id] = section

        categories = item.get("categories", [])
        if not categories:
            errors.add(f"{decision_id}: at least one applicable obligation category is required")
        invalid_categories = sorted(set(categories) - set(CATEGORIES))
        if invalid_categories:
            errors.add(f"{decision_id}: invalid categories: {invalid_categories}")
        if len(categories) != len(set(categories)):
            errors.add(f"{decision_id}: categories must be unique")
        not_applicable_reason = item.get(
            "not_applicable_reason", data.get("policy", {}).get("default_not_applicable_reason")
        )
        if not not_applicable_reason:
            errors.add(f"{decision_id}: omitted categories need not_applicable_reason")
        for category in CATEGORIES:
            clause_id = f"{decision_id}.{category}"
            if clause_id in seen_clause_ids:
                errors.add(f"duplicate expanded clause ID {clause_id}")
            seen_clause_ids.add(clause_id)

        if item.get("proof_impact") not in PROOF_IMPACTS:
            errors.add(f"{decision_id}: invalid proof_impact {item.get('proof_impact')!r}")
        destinations = item.get("destinations", [])
        if not destinations:
            errors.add(f"{decision_id}: complete entries need destinations")
        destination_text = ""
        for raw in destinations:
            destination = validate_relative_path(errors, decision_id, raw)
            if destination is not None:
                destination_text += "\n" + destination.read_text(encoding="utf-8")
        terms = item.get("required_terms", [])
        if not terms:
            errors.add(f"{decision_id}: exact-name checks need required_terms")
        for term in terms:
            if term not in destination_text:
                errors.add(f"{decision_id}: required term is absent from destinations: {term!r}")
        rejection_check_count += len(item.get("forbidden_active_patterns", []))
        for pattern in item.get("forbidden_active_patterns", []):
            if re.search(pattern, destination_text, flags=re.MULTILINE):
                errors.add(f"{decision_id}: rejected active pattern still occurs: {pattern!r}")

    if rejection_check_count == 0:
        errors.add("the batch needs at least one rejected-alternative active-pattern check")

    errors.finish()
    return (sorted(decisions, key=lambda item: decision_sort_key(item["id"])), sections)


def render_report(data: dict, decisions: list[dict], sections: dict[str, tuple[int, int, str]]) -> str:
    review = data["review"]
    batch_label = data.get("policy", {}).get(
        "batch_label", data.get("registry_id", "Decision Batch")
    )
    lines = [
        f"# {batch_label} Clause Extraction Review",
        "",
        f"This file is generated from `{REGISTRY.relative_to(ROOT)}` by",
        "`toolchain/spec/check_clause_extraction.py`. Do not edit it manually.",
        "",
        "The checker verifies inventory closure, accepted-source identity, destination",
        "existence, exact-name tripwires, supersession edges, and trace-row coverage.",
        "It does not replace semantic review or claim implementation, conformance,",
        "admission, operational readiness, or proof.",
        "",
        f"Review class: `{review['review_class']}`.",
        f"Reviewer: {review['reviewer']}.",
        f"Review date: `{review['date']}`.",
        f"Accepted cutoff: `{review['accepted_cutoff']}`.",
        f"Reviewed revision: `{review['reviewed_revision']}`.",
        "",
        review["basis"],
        "",
        "## Checked Projections",
        "",
        "The registry also checks the public traceability, maturity, and Gate-A",
        "views named below. A stale projection fails the same check as a stale",
        "generated review.",
        "",
        "| Kind | Path | Checked terms |",
        "| --- | --- | ---: |",
    ]
    for projection in data["projection"]:
        lines.append(
            f"| `{projection['kind']}` | `{projection['path']}` | "
            f"{len(projection['required_terms'])} |"
        )
    lines.extend([
        "",
        "## Decision Summary",
        "",
        "| Decision | State | Live clauses | Source lines | Source SHA-256 | Proof impact |",
        "| --- | --- | ---: | --- | --- | --- |",
    ])
    for item in decisions:
        decision_id = item["id"]
        if item["state"] == "superseded":
            lines.append(
                f"| `{decision_id}` | `superseded` by `{item['superseded_by']}` | 0 | n/a | n/a | "
                "`NO_SEMANTIC_IMPACT` |"
            )
            continue
        start, end, source = sections[decision_id]
        digest = hashlib.sha256(source.encode("utf-8")).hexdigest()
        lines.append(
            f"| `{decision_id}` | `complete` | {len(item['categories'])} | "
            f"`{start}-{end}` | `{digest}` | `{item['proof_impact']}` |"
        )

    for item in decisions:
        decision_id = item["id"]
        lines.extend(["", f"## {decision_id}", ""])
        if item["state"] == "superseded":
            lines.extend(
                [
                    f"State: `superseded` by `{item['superseded_by']}`.",
                    "",
                    item["supersession_reason"],
                ]
            )
            continue
        start, end, source = sections[decision_id]
        digest = hashlib.sha256(source.encode("utf-8")).hexdigest()
        source_name = item.get("source_heading") or item["source_anchor"]
        source_kind = "heading" if item.get("source_heading") else "anchor"
        lines.extend(
            [
                f"Accepted source {source_kind}: `{source_name}` at "
                f"`kyokaidecided.md:{start}-{end}`.",
                "",
                f"Accepted-source SHA-256: `{digest}`.",
                "",
                "Destinations: " + ", ".join(f"`{path}`" for path in item["destinations"]) + ".",
                "",
                f"Proof impact: `{item['proof_impact']}`.",
                "",
                "| Clause ID | Obligation | Extraction state | Evidence |",
                "| --- | --- | --- | --- |",
            ]
        )
        applicable = set(item["categories"])
        for category in CATEGORIES:
            if category in applicable:
                state = "complete"
                evidence = (
                    "accepted digest; destinations; exact-name/rejection tripwires; "
                    "maintainer-directed review; "
                    + ", ".join(f"`{path}`" for path in data["policy"]["evidence_links"])
                )
            else:
                state = "not-applicable-with-reason"
                evidence = item.get(
                    "not_applicable_reason", data["policy"]["default_not_applicable_reason"]
                )
            lines.append(f"| `{decision_id}.{category}` | `{category}` | `{state}` | {evidence} |")
    maturity_lines = data.get("policy", {}).get("maturity_lines")
    if not maturity_lines:
        maturity_lines = [
            f"Every required {batch_label} decision, including sub-decisions, is either",
            "clause-complete or recorded as superseded. The batch satisfies D577's",
            "clause-evidence condition for `SPEC_EXTRACTED`. This result does not close",
            "the earlier Gate-A audit or upgrade any implementation, conformance,",
            "admission, service, workload, or proof state.",
        ]
    lines.extend(
        [
            "",
            "## Maturity Result",
            "",
            *maturity_lines,
            "",
        ]
    )
    return "\n".join(lines)


def main() -> None:
    global REGISTRY, REPORT
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    parser.add_argument("--registry", default="kyokaispec/extraction/d558-d625.toml")
    parser.add_argument("--report", default="kyokaispec/extraction/d558-d625-review.md")
    args = parser.parse_args()

    REGISTRY = ROOT / args.registry
    REPORT = ROOT / args.report

    data = read_registry()
    decisions, sections = validate_registry(data)
    rendered = render_report(data, decisions, sections)
    if args.write:
        REPORT.write_text(rendered, encoding="utf-8")
        print(f"wrote {REPORT.relative_to(ROOT)}")
        return
    if not REPORT.exists() or REPORT.read_text(encoding="utf-8") != rendered:
        print(
            "clause-extraction: error: generated review is missing or stale; run "
            "python3 toolchain/spec/check_clause_extraction.py --write "
            f"--registry {args.registry} --report {args.report}",
            file=sys.stderr,
        )
        raise SystemExit(1)
    print("clause-extraction: registry and generated review are current")


if __name__ == "__main__":
    main()
