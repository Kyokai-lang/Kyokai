#!/usr/bin/env python3
# Part of the Kyokai project.
#
# SPDX-License-Identifier: GPL-3.0-or-later

# kyokai:prooftrace id=TOOL-CONFORMANCE-FIXTURE-CHECKER
"""Validate Kyokai conformance fixture metadata.

This checker validates fixture shape only. It does not execute compiler commands
and does not convert implementation-gated fixtures into conformance evidence.
"""

from __future__ import annotations

import argparse
import sys
import tomllib
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
FIXTURE_ROOT = ROOT / "test" / "conformance"
PROOFTRACE_REGISTRY = ROOT / "kyokaiproofstatus.toml"

REQUIRED_FIELDS = {
    "id",
    "lane",
    "status",
    "spec",
    "edition",
    "inputs",
    "command",
    "expect",
    "expected_outcome",
    "expected_stage",
    "expected_code",
    "expected_facts",
    "targets",
    "prooftrace",
}

VALID_STATUSES = {"active", "implementation-gated", "spec-gated", "historical"}
VALID_EXPECTED_OUTCOMES = {"accept", "reject", "run", "artifact"}


class Errors:
    def __init__(self) -> None:
        self.items: list[str] = []

    def add(self, message: str) -> None:
        self.items.append(message)

    def finish(self) -> None:
        if not self.items:
            return
        for item in self.items:
            print(f"conformance-fixtures: error: {item}", file=sys.stderr)
        raise SystemExit(1)


def load_toml(path: Path) -> dict:
    with path.open("rb") as handle:
        return tomllib.load(handle)


def prooftrace_ids() -> set[str]:
    data = load_toml(PROOFTRACE_REGISTRY)
    ids = set(data.get("spec_chapters", {}).values())
    ids.update(record["id"] for record in data.get("records", []))
    return ids


def fixture_paths() -> list[Path]:
    return sorted(FIXTURE_ROOT.glob("*/*/fixture.toml"))


def validate_fixture(errors: Errors, known_prooftrace: set[str], path: Path) -> None:
    try:
        data = load_toml(path)
    except tomllib.TOMLDecodeError as error:
        errors.add(f"{path.relative_to(ROOT)}: invalid TOML: {error}")
        return

    missing = REQUIRED_FIELDS.difference(data)
    for field in sorted(missing):
        errors.add(f"{path.relative_to(ROOT)}: missing required field {field}")

    fixture_id = data.get("id", path.parent.name)
    lane = data.get("lane")
    if lane != path.parent.parent.name:
        errors.add(f"{fixture_id}: lane must match parent directory {path.parent.parent.name!r}")

    status = data.get("status")
    if status not in VALID_STATUSES:
        errors.add(f"{fixture_id}: invalid status {status!r}")

    inputs = data.get("inputs")
    if not isinstance(inputs, list) or not inputs:
        errors.add(f"{fixture_id}: inputs must be a non-empty array")
    elif not all(isinstance(item, str) and item for item in inputs):
        errors.add(f"{fixture_id}: every input must be a non-empty string")
    else:
        for item in inputs:
            input_path = Path(item)
            if input_path.is_absolute() or ".." in input_path.parts:
                errors.add(f"{fixture_id}: input path must stay inside the fixture: {item}")
            elif not (path.parent / input_path).exists():
                errors.add(f"{fixture_id}: input path does not exist: {item}")

    prooftrace = data.get("prooftrace")
    if prooftrace not in known_prooftrace:
        errors.add(f"{fixture_id}: unknown ProofTrace id {prooftrace!r}")

    expected_outcome = data.get("expected_outcome")
    if expected_outcome not in VALID_EXPECTED_OUTCOMES:
        errors.add(f"{fixture_id}: invalid expected_outcome {expected_outcome!r}")

    expected_facts = data.get("expected_facts")
    if not isinstance(expected_facts, list):
        errors.add(f"{fixture_id}: expected_facts must be an array")
    elif not all(isinstance(item, str) and item for item in expected_facts):
        errors.add(f"{fixture_id}: every expected_facts item must be a non-empty string")

    for field in (
        "id",
        "spec",
        "edition",
        "command",
        "expect",
        "expected_stage",
        "expected_code",
        "targets",
    ):
        value = data.get(field)
        if not isinstance(value, str) or not value.strip():
            errors.add(f"{fixture_id}: {field} must be a non-empty string")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true", help="validate conformance fixture metadata")
    args = parser.parse_args()
    if not args.check:
        parser.error("expected --check")

    errors = Errors()
    known_prooftrace = prooftrace_ids()
    paths = fixture_paths()
    if not paths:
        errors.add("no conformance fixture metadata files found")
    for path in paths:
        validate_fixture(errors, known_prooftrace, path)
    errors.finish()
    print(f"conformance-fixtures: validated {len(paths)} fixtures")


if __name__ == "__main__":
    main()
