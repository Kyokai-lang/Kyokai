#!/usr/bin/env python3
# kyokai:prooftrace id=TOOL-PROOFTRACE-CHECKER
"""Validate Kyokai ProofTrace metadata and render the public status board."""

from __future__ import annotations

import argparse
import re
import sys
import tomllib
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
REGISTRY = ROOT / "kyokaiproofstatus.toml"
STATUS_BOARD = ROOT / "kyokaiproofstatus.md"
PROOFTRACE_RE = re.compile(r"kyokai:prooftrace\s+id=([A-Z0-9][A-Z0-9-]*)")
SPEC_PROOFTRACE_RE = re.compile(r"^> ProofTrace: ([A-Z0-9][A-Z0-9-]*)$", re.MULTILINE)

SPEC_STATUSES = {"specified", "planned"}
IMPLEMENTATION_STATUSES = {"none", "planned", "inherited-bootstrap", "prototype", "implemented"}
CONFORMANCE_STATUSES = {"none", "planned", "conformance-backed"}
PROOF_STATUSES = {
    "intended-by-spec",
    "implemented-and-tested",
    "conformance-backed",
    "paper-proven",
    "mechanically-proven",
}


class Errors:
    def __init__(self) -> None:
        self.items: list[str] = []

    def add(self, message: str) -> None:
        self.items.append(message)

    def finish(self) -> None:
        if not self.items:
            return
        for item in self.items:
            print(f"prooftrace: error: {item}", file=sys.stderr)
        raise SystemExit(1)


def load_registry() -> dict:
    with REGISTRY.open("rb") as handle:
        return tomllib.load(handle)


def existing_or_pending(errors: Errors, record_id: str, field: str, values: list[str]) -> None:
    for value in values:
        if value == "pending":
            continue
        path = Path(value)
        if path.is_absolute() or ".." in path.parts:
            errors.add(f"{record_id}: {field} path must be repository-relative: {value}")
            continue
        if not (ROOT / path).exists():
            errors.add(f"{record_id}: {field} path does not exist: {value}")


def validate_record(errors: Errors, record: dict, closed_reasons: set[str]) -> None:
    record_id = record.get("id", "<missing-id>")
    for field in ("id", "kind", "scope", "owner", "spec_status", "implementation_status", "conformance_status", "proof_status", "proof_required"):
        if field not in record:
            errors.add(f"{record_id}: missing required field {field}")
    if record.get("spec_status") not in SPEC_STATUSES:
        errors.add(f"{record_id}: invalid spec_status {record.get('spec_status')!r}")
    if record.get("implementation_status") not in IMPLEMENTATION_STATUSES:
        errors.add(f"{record_id}: invalid implementation_status {record.get('implementation_status')!r}")
    if record.get("conformance_status") not in CONFORMANCE_STATUSES:
        errors.add(f"{record_id}: invalid conformance_status {record.get('conformance_status')!r}")
    if record.get("proof_status") not in PROOF_STATUSES:
        errors.add(f"{record_id}: invalid proof_status {record.get('proof_status')!r}")
    if not isinstance(record.get("proof_required"), bool):
        errors.add(f"{record_id}: proof_required must be true or false")
    if record.get("proof_required") is False:
        reason = record.get("reason")
        if reason not in closed_reasons:
            errors.add(f"{record_id}: proof_required=false needs a closed reason category, got {reason!r}")
    for field in ("spec_artifacts", "implementation_artifacts", "test_artifacts", "proof_artifacts"):
        existing_or_pending(errors, record_id, field, record.get(field, []))
    if record.get("proof_status") in {"paper-proven", "mechanically-proven"} and not record.get("proof_artifacts"):
        errors.add(f"{record_id}: {record.get('proof_status')} needs proof_artifacts")
    if record.get("conformance_status") == "conformance-backed" and not record.get("test_artifacts"):
        errors.add(f"{record_id}: conformance-backed needs test_artifacts")


def collect_spec_records(data: dict) -> list[dict]:
    defaults = data["defaults"]["spec_chapter"]
    records = []
    for path, record_id in sorted(data["spec_chapters"].items()):
        records.append(
            {
                "id": record_id,
                "kind": "spec-chapter",
                "scope": path,
                "owner": defaults["owner"],
                "spec_status": defaults["spec_status"],
                "implementation_status": defaults["implementation_status"],
                "conformance_status": defaults["conformance_status"],
                "proof_status": defaults["proof_status"],
                "proof_required": path not in data.get("spec_chapter_no_proof", {}),
                "reason": data.get("spec_chapter_no_proof", {}).get(path),
                "spec_artifacts": [path],
                "implementation_artifacts": [],
                "test_artifacts": [],
                "proof_artifacts": [],
                "exclusions": ["Chapter registration does not claim implementation, conformance, or theorem completion."],
            }
        )
    return records


def validate_spec_coverage(errors: Errors, spec_records: list[dict]) -> None:
    known = {record["id"]: record["scope"] for record in spec_records}
    traced_files = sorted((ROOT / "kyokaispec/src").rglob("*.md"))
    for path in traced_files:
        text = path.read_text(encoding="utf-8")
        if "> Trace:" not in text:
            continue
        relative = path.relative_to(ROOT).as_posix()
        visible_text = re.sub(r"```.*?```", "", text, flags=re.DOTALL)
        markers = SPEC_PROOFTRACE_RE.findall(visible_text)
        if len(markers) != 1:
            errors.add(f"{relative}: expected exactly one chapter ProofTrace marker, found {len(markers)}")
            continue
        marker = markers[0]
        if marker not in known:
            errors.add(f"{relative}: unknown chapter ProofTrace id {marker}")
        elif known[marker] != relative:
            errors.add(f"{relative}: ProofTrace id {marker} belongs to {known[marker]}")
    for record in spec_records:
        path = ROOT / record["scope"]
        if not path.exists():
            errors.add(f"{record['id']}: registered spec chapter does not exist: {record['scope']}")
        elif "> Trace:" not in path.read_text(encoding="utf-8"):
            errors.add(f"{record['id']}: registered spec chapter has no decision Trace block: {record['scope']}")


def validate_code_markers(errors: Errors, data: dict, known_ids: set[str]) -> None:
    required = set(data["policy"]["required_code_paths"])
    seen_required: set[str] = set()
    search_roots = [
        ROOT / "bin",
        ROOT / "compiler",
        ROOT / "lib",
        ROOT / "standard",
        ROOT / "test-programs",
        ROOT / "kyokaicalculus",
        ROOT / "toolchain",
    ]
    for search_root in search_roots:
        if not search_root.exists():
            continue
        for path in search_root.rglob("*"):
            if not path.is_file() or any(part in {".lake", "build"} for part in path.parts):
                continue
            try:
                text = path.read_text(encoding="utf-8")
            except UnicodeDecodeError:
                continue
            relative = path.relative_to(ROOT).as_posix()
            markers = PROOFTRACE_RE.findall(text)
            if relative in required and not markers:
                errors.add(f"{relative}: required boundary has no kyokai:prooftrace marker")
            if markers:
                seen_required.add(relative)
            for marker in markers:
                if marker not in known_ids:
                    errors.add(f"{relative}: unknown kyokai:prooftrace id {marker}")
    for missing in sorted(required - seen_required):
        if not (ROOT / missing).exists():
            errors.add(f"required code boundary does not exist: {missing}")


def render_board(data: dict, records: list[dict]) -> str:
    lines = [
        "# Kyokai ProofTrace Status",
        "",
        "This file is generated from `kyokaiproofstatus.toml`. Do not edit it manually.",
        "ProofTrace records keep specification, implementation, conformance, and proof state separate.",
        "A registered chapter or boundary does not imply that Kyokai implements or proves it.",
        "",
        f"Schema version: `{data['schema_version']}`.",
        "",
        "| ID | Kind | Scope | Spec | Implementation | Conformance | Proof | Proof Required | Owner |",
        "| --- | --- | --- | --- | --- | --- | --- | --- | --- |",
    ]
    for record in sorted(records, key=lambda item: item["id"]):
        lines.append(
            "| `{id}` | `{kind}` | `{scope}` | `{spec_status}` | `{implementation_status}` | "
            "`{conformance_status}` | `{proof_status}` | `{proof_required}` | `{owner}` |".format(
                **{**record, "proof_required": "yes" if record["proof_required"] else "no"}
            )
        )
    lines.extend(["", "## Boundary Details", ""])
    for record in sorted((item for item in records if item["kind"] != "spec-chapter"), key=lambda item: item["id"]):
        lines.extend(
            [
                f"### `{record['id']}`",
                "",
                f"Scope: {record['scope']}",
                "",
                f"Spec artifacts: {', '.join(f'`{item}`' for item in record.get('spec_artifacts', [])) or '`none`'}",
                "",
                f"Implementation artifacts: {', '.join(f'`{item}`' for item in record.get('implementation_artifacts', [])) or '`none`'}",
                "",
                f"Test artifacts: {', '.join(f'`{item}`' for item in record.get('test_artifacts', [])) or '`none`'}",
                "",
                f"Proof artifacts: {', '.join(f'`{item}`' for item in record.get('proof_artifacts', [])) or '`none`'}",
                "",
                f"No-proof reason: `{record.get('reason', 'not-applicable')}`",
                "",
                f"Exclusions: {' '.join(record.get('exclusions', ['None recorded.']))}",
                "",
            ]
        )
    return "\n".join(lines)


def main() -> None:
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--check", action="store_true", help="validate registry and generated board")
    mode.add_argument("--write", action="store_true", help="validate registry and rewrite generated board")
    args = parser.parse_args()

    data = load_registry()
    errors = Errors()
    if data.get("schema_version") != 1:
        errors.add(f"unsupported schema_version {data.get('schema_version')!r}")
    closed_reasons = set(data["policy"]["closed_nonproof_reasons"])
    for path, reason in data.get("spec_chapter_no_proof", {}).items():
        if path not in data["spec_chapters"]:
            errors.add(f"spec_chapter_no_proof has unknown chapter: {path}")
        if reason not in closed_reasons:
            errors.add(f"spec_chapter_no_proof has unknown reason for {path}: {reason}")
    spec_records = collect_spec_records(data)
    records = spec_records + data.get("records", [])
    known_ids: set[str] = set()
    for record in records:
        record_id = record.get("id", "<missing-id>")
        if record_id in known_ids:
            errors.add(f"duplicate ProofTrace id {record_id}")
        known_ids.add(record_id)
        validate_record(errors, record, closed_reasons)
    validate_spec_coverage(errors, spec_records)
    validate_code_markers(errors, data, known_ids)
    errors.finish()

    rendered = render_board(data, records)
    if args.write:
        STATUS_BOARD.write_text(rendered, encoding="utf-8")
    elif not STATUS_BOARD.exists() or STATUS_BOARD.read_text(encoding="utf-8") != rendered:
        print("prooftrace: error: kyokaiproofstatus.md is stale; run make proofstatus", file=sys.stderr)
        raise SystemExit(1)
    print(f"prooftrace: validated {len(records)} records")


if __name__ == "__main__":
    main()
