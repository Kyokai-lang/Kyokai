#!/usr/bin/env python3
# kyokai:prooftrace id=TOOL-SPEC-CLAUSE-EXTRACTION
"""Create the review baseline for the legacy accepted-decision registry.

This program discovers inventory, source anchors, and candidate vocabulary.  Its
output is not extraction evidence until a reviewer checks the static TOML and
the independent clause checker accepts it.  It refuses to overwrite that audit
record unless --force is given.
"""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
TRACE = ROOT / "kyokaispec/src/project/02-decision-traceability.md"
ACCEPTED = ROOT / "kyokaidecided.md"
OUTPUT = ROOT / "kyokaispec/extraction/pre-d558.toml"

CATEGORIES = (
    "syntax-api", "static", "dynamic", "ownership", "borrow", "capability",
    "failure", "artifact", "diagnostic", "compatibility", "target", "example",
    "illegal-form", "conformance",
)
STOP_WORDS = {
    "about", "after", "again", "against", "because", "before", "between",
    "cannot", "complete", "explicit", "first", "from", "have", "instead",
    "keeps", "kyokai", "language", "must", "ordinary", "remain", "requires",
    "rules", "same", "separate", "through", "under", "where", "which", "with",
}


def decision_key(decision_id: str) -> tuple[int, str]:
    match = re.fullmatch(r"D(\d+)([a-z]?)", decision_id)
    assert match is not None
    return (int(match.group(1)), match.group(2))


def expand_ids(text: str) -> list[str]:
    result: list[str] = []
    for token in re.findall(r"D\d+[a-z]?(?:-D?\d+)?", text.replace("–", "-")):
        interval = re.fullmatch(r"D(\d+)-D?(\d+)", token)
        if interval:
            result.extend(f"D{number}" for number in range(int(interval[1]), int(interval[2]) + 1))
        else:
            result.append(token)
    return result


def accepted_ids() -> set[str]:
    """Return the accepted pre-D558 inventory without trusting traceability."""
    result: set[str] = set()
    for line in ACCEPTED.read_text(encoding="utf-8").splitlines():
        is_decision_heading = re.match(r"^#{2,6} D\d", line) is not None
        is_accepted_marker = "[STAGE:" in line or "[DECIDED:" in line
        if not (is_decision_heading or is_accepted_marker):
            continue
        result.update(
            decision_id
            for decision_id in expand_ids(line)
            if decision_key(decision_id)[0] < 558
        )
    return result


def trace_rows() -> tuple[list[str], dict[str, tuple[str, str, str]]]:
    rows: list[tuple[str, str, str]] = []
    for line in TRACE.read_text(encoding="utf-8").splitlines():
        if not line.startswith("| D"):
            continue
        cells = [cell.strip() for cell in line[2:-2].split(" | ", 2)]
        if len(cells) != 3:
            continue
        rows.append((cells[0], cells[1], cells[2]))

    traced = {
            decision_id
            for cell, _, _ in rows
            for decision_id in expand_ids(cell)
            if decision_key(decision_id)[0] < 558
    }
    required = sorted(accepted_ids() | traced, key=decision_key)
    canonical: dict[str, tuple[str, str, str]] = {}
    for decision_id in required:
        candidates = [row for row in rows if decision_id in expand_ids(row[0])]
        if not candidates:
            raise SystemExit(
                f"accepted decision {decision_id} has no canonical traceability row"
            )
        exact = [row for row in candidates if row[0] == decision_id]
        selected = exact[0] if exact else min(candidates, key=lambda row: len(expand_ids(row[0])))
        canonical[decision_id] = selected
    return required, canonical


def source_locations(
    required: list[str], rows: dict[str, tuple[str, str, str]]
) -> dict[str, tuple[str, str]]:
    text = ACCEPTED.read_text(encoding="utf-8")
    headings: list[tuple[str, list[str]]] = []
    stages: list[tuple[str, list[str], int]] = []
    mentions: list[tuple[str, list[str], int]] = []
    for number, line in enumerate(text.splitlines(), start=1):
        heading = re.match(r"^(#{2,6}) (D\d+[a-z]?(?:-D?\d+)?):", line)
        if heading:
            headings.append((line, expand_ids(heading[2])))
        if "[STAGE:" in line or "[DECIDED:" in line:
            stages.append((line.strip(), expand_ids(line), number))
        elif number > 90 and not line.startswith("|") and expand_ids(line):
            mentions.append((line.strip(), expand_ids(line), number))

    result: dict[str, tuple[str, str]] = {}
    source_overrides = {
        "D119": ("source_heading", "### D292: Explicit Error Conversion And Structured Fatal Payloads"),
    }
    for decision_id in required:
        if decision_id in source_overrides:
            result[decision_id] = source_overrides[decision_id]
            continue
        heading_candidates = [(line, ids) for line, ids in headings if decision_id in ids]
        if heading_candidates:
            line, _ = min(heading_candidates, key=lambda item: len(item[1]))
            result[decision_id] = ("source_heading", line)
            continue
        stage_candidates = [item for item in stages if decision_id in item[1]]
        if not stage_candidates:
            grouped_ids = expand_ids(rows[decision_id][0])
            stage_candidates = [item for item in stages if set(grouped_ids) & set(item[1])]
        if stage_candidates:
            line, _, _ = min(stage_candidates, key=lambda item: (len(item[1]), -item[2]))
        else:
            mention_candidates = [item for item in mentions if decision_id in item[1]]
            if not mention_candidates:
                raise SystemExit(f"no accepted source unit found for {decision_id}")
            line, _, _ = min(mention_candidates, key=lambda item: (len(item[1]), -len(item[0]), item[2]))
        result[decision_id] = ("source_anchor", line)
    return result


def destination_paths(cell: str) -> list[str]:
    result: list[str] = []
    for raw in re.findall(r"`([^`]+)`", cell):
        candidates = [Path(raw), Path("kyokaispec/src") / raw]
        for candidate in candidates:
            resolved = ROOT / candidate
            if resolved.is_file():
                value = candidate.as_posix()
                if value not in result:
                    result.append(value)
                break
    return result


def categories_for(decision_id: str, destinations: list[str], summary: str) -> list[str]:
    overrides = {
        "D1": ["syntax-api", "static", "diagnostic", "compatibility", "conformance"],
        "D5": ["compatibility", "conformance"],
        "D145": ["conformance"],
        "D147": ["compatibility", "conformance"],
        "D510": ["artifact", "compatibility", "target", "conformance"],
        "D513": ["artifact", "compatibility", "target", "conformance"],
        "D514": ["artifact", "compatibility", "conformance"],
        "D519": ["artifact", "compatibility", "target", "conformance"],
        "D523": ["artifact", "diagnostic", "compatibility", "conformance"],
    }
    if decision_id in overrides:
        return overrides[decision_id]
    joined = " ".join(destinations) + " " + summary.lower()
    chosen = {"conformance"}
    if any(piece in joined for piece in ("language/02-", "language/03-", "language/05-", "language/09-", "language/10-", "language/18-", "syntax", "keyword", "command", "api")):
        chosen.update(("syntax-api", "static", "diagnostic", "illegal-form", "example"))
    if any(piece in joined for piece in ("language/06-", "language/07-", "language/08-", "language/11-", "language/12-", "type", "generic", "pattern", "compile", "checker", "borrow", "linear")):
        chosen.update(("static", "diagnostic", "illegal-form"))
    if any(piece in joined for piece in ("language/09-", "language/10-", "language/13-", "language/15-", "language/16-", "language/17-", "runtime", "evaluation", "control-flow", "concurrency", "failure", "cleanup", "blocking")):
        chosen.update(("dynamic", "failure", "diagnostic"))
    if any(piece in joined for piece in ("owner", "linear", "move", "consume", "resource")):
        chosen.add("ownership")
    if any(piece in joined for piece in ("borrow", "region", "reborrow", "reference")):
        chosen.add("borrow")
    if any(piece in joined for piece in ("language/14-", "language/16-", "capabil", "authority", "permission", "unsafe")):
        chosen.add("capability")
    if "language/16-" in joined:
        chosen.update(("syntax-api", "static", "ownership", "borrow", "artifact", "compatibility", "target", "example", "illegal-form"))
    if "language/17-" in joined:
        chosen.update(("static", "artifact", "compatibility", "target", "illegal-form"))
    if "language/19-" in joined:
        chosen.update(("example", "diagnostic", "illegal-form"))
    if "toolchain/" in joined:
        chosen.update(("syntax-api", "dynamic", "failure", "artifact", "diagnostic", "compatibility", "target", "example", "illegal-form"))
    if "stdlib/" in joined:
        chosen.update(("syntax-api", "dynamic", "failure", "artifact", "diagnostic", "compatibility", "target", "example", "illegal-form"))
    if any(piece in joined for piece in ("project/", "artifact", ".koi", "manifest", "package", "document")):
        chosen.update(("artifact", "diagnostic", "compatibility"))
    if any(piece in joined for piece in ("target", "platform", "abi", "compiler", "backend", "host")):
        chosen.add("target")
    return [category for category in CATEGORIES if category in chosen]


def required_terms(decision_id: str, destinations: list[str], summary: str) -> list[str]:
    body = "\n".join((ROOT / path).read_text(encoding="utf-8") for path in destinations)
    overrides = {
        "D383": ["kyokai vendor", "vendored"],
        "D419": ["ASCII", "confusingly close"],
        "D510": ["docs/", "website/"],
    }
    if decision_id in overrides:
        missing = [term for term in overrides[decision_id] if term not in body]
        if missing:
            raise SystemExit(f"missing required-term override for {decision_id}: {missing}")
        return overrides[decision_id]
    candidates: list[str] = []
    candidates.extend(re.findall(r"`([^`\n]{2,80})`", summary))
    words = re.findall(r"[A-Za-z][A-Za-z0-9_.-]{4,}", summary)
    candidates.extend(word for word in words if word.lower() not in STOP_WORDS)
    result: list[str] = []
    for candidate in candidates:
        if candidate in body and candidate not in result:
            result.append(candidate)
        if len(result) == 2:
            break
    if not result:
        raise SystemExit(f"no destination vocabulary shared with summary: {summary}")
    return result


def proof_impact(destinations: list[str]) -> str:
    semantic_language = re.compile(r"kyokaispec/src/language/(?:0[2-9]|1[0-8])-")
    if any(semantic_language.search(path) for path in destinations):
        return "MODEL_AFFECTING"
    if any("kyokaispec/src/toolchain/" in path or "kyokaispec/src/stdlib/" in path for path in destinations):
        return "MAPPING_ONLY"
    return "NO_SEMANTIC_IMPACT"


def quoted(value: str) -> str:
    return json.dumps(value, ensure_ascii=False)


def render() -> str:
    required, rows = trace_rows()
    sources = source_locations(required, rows)
    lines = [
        "schema_version = 1",
        'registry_id = "KYOKAI-EXTRACT-PRE-D558"',
        'accepted_source = "kyokaidecided.md"',
        'traceability_view = "kyokaispec/src/project/02-decision-traceability.md"',
        'generated_review = "kyokaispec/extraction/pre-d558-review.md"',
        "required_decisions = [" + ", ".join(quoted(item) for item in required) + "]",
        "",
        "[policy]",
        'batch_label = "Pre-D558 Accepted Range"',
        'clause_id_shape = "<decision>.<obligation-category>"',
        "accepted_inventory_before = 558",
        "categories = [" + ", ".join(quoted(item) for item in CATEGORIES) + "]",
        'default_not_applicable_reason = "The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source and owning contract family."',
        'maturity_result = "SPEC_EXTRACTED"',
        'maturity_exclusions = ["implementation", "conformance", "admission", "service readiness", "workload evidence", "proof"]',
        'evidence_links = ["kyokaispec/extraction/pre-d558.toml", "kyokaispec/extraction/pre-d558-review.md", "kyokaispec/src/project/02-decision-traceability.md"]',
        'maturity_lines = ["Every accepted pre-D558 decision independently discovered from the accepted source is clause-complete or has a checked supersession edge and a canonical trace row. Together with the D558-D625 and D627-D635 registries, this closes Gate A through the current accepted boundary. It does not claim implementation, conformance, admission, service readiness, workload evidence, or proof."]',
        "",
        "[review]",
        'reviewer = "Rikona Kurasaki / Mjoyufull; closure audit executed by Codex"',
        'review_class = "lead-maintainer-directed-extraction"',
        'reviewed_revision = "working tree accepted through D635"',
        'accepted_cutoff = "all accepted decisions before D558"',
        'date = "2026-07-20"',
        'basis = "The lead maintainer directed Gate-A closure. This static registry freezes the independently discovered legacy accepted inventory, canonical grouped rows, accepted-source units, applicable clause classes, normative destinations, exact vocabulary, supersession edges, and review identity. The independent checker rejects accepted decisions without trace rows, missing inventory, stale sources, absent destinations, vocabulary drift, unresolved supersession, and stale public projections."',
        "",
        "[[projection]]",
        'kind = "traceability"',
        'path = "kyokaispec/src/project/02-decision-traceability.md"',
        'required_terms = ["| D1 |", "| D557 |", "pre-d558.toml"]',
        "",
        "[[projection]]",
        'kind = "maturity"',
        'path = "kyokaidecided.md"',
        'required_terms = ["Gate A is closed", "pre-d558.toml"]',
        "",
        "[[projection]]",
        'kind = "maturity"',
        'path = "Kyokaishape.md"',
        'required_terms = ["Gate A is closed through D635", "checked pre-D558"]',
        "",
        "[[projection]]",
        'kind = "gate"',
        'path = "phase.md"',
        'required_terms = ["Gate A: Plan-To-Spec Closure | Closed", "[x] Gate A: Plan-To-Spec Closure"]',
        'forbidden_terms = ["Gate A remains open for the accepted range before D558", "Open for the pre-D558 accepted range"]',
    ]

    superseded = {
        "D4": ("D530-D536", "D530-D536 replace the former direct-LLVM plan with one admitted generated-C backend and target-toolchain model."),
        "D382": ("D537", "D537 replaces the two-source-file module model with one `.kyo` source and a derived `.koi` interface."),
        "D425": ("D615", "D615 replaces the former rustup-shaped Kyokai manager with standalone Bleedring distribution installation."),
    }
    for decision_id in required:
        trace_cell, destination_cell, summary = rows[decision_id]
        lines.extend(["", "[[decision]]", f"id = {quoted(decision_id)}"])
        if trace_cell != decision_id:
            lines.append(f"trace_cell = {quoted(trace_cell)}")
        if decision_id in superseded:
            replacement, reason = superseded[decision_id]
            lines.extend([
                'state = "superseded"',
                f"superseded_by = {quoted(replacement)}",
                f"supersession_reason = {quoted(reason)}",
            ])
            continue
        destinations = destination_paths(destination_cell)
        if not destinations:
            raise SystemExit(f"no concrete destination for {decision_id}: {destination_cell}")
        source_field, source_value = sources[decision_id]
        lines.extend([
            'state = "complete"',
            f"{source_field} = {quoted(source_value)}",
            "categories = [" + ", ".join(quoted(item) for item in categories_for(decision_id, destinations, summary)) + "]",
            "destinations = [" + ", ".join(quoted(item) for item in destinations) + "]",
            "required_terms = [" + ", ".join(quoted(item) for item in required_terms(decision_id, destinations, summary)) + "]",
            f"proof_impact = {quoted(proof_impact(destinations))}",
        ])
        if decision_id == "D537":
            patterns = (r'(?m)^backend\s*=\s*"(?:llvm|cranelift|qbe)"$',)
            lines.append(
                "forbidden_active_patterns = ["
                + ", ".join(quoted(pattern) for pattern in patterns)
                + "]"
            )
    return "\n".join(lines) + "\n"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--force", action="store_true")
    args = parser.parse_args()
    if OUTPUT.exists() and not args.force:
        raise SystemExit(f"refusing to overwrite reviewed registry: {OUTPUT.relative_to(ROOT)}")
    OUTPUT.write_text(render(), encoding="utf-8")
    print(f"wrote review baseline {OUTPUT.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
