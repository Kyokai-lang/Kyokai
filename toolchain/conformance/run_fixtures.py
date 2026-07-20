#!/usr/bin/env python3
# Part of the Kyokai project.
#
# SPDX-License-Identifier: GPL-3.0-or-later

# kyokai:prooftrace id=TOOL-CONFORMANCE-FIXTURE-RUNNER
"""Execute implementation-gated Kyokai fixtures through the internal CLI.

This adapter follows the command boundary recorded by Phase 3 fixture metadata.
It does not make implementation-gated fixtures public conformance passes.
"""

from __future__ import annotations

import argparse
import subprocess
import sys
import tomllib
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
FIXTURE_ROOT = ROOT / "test" / "conformance"
KYOKAI = ROOT / "kyokai"


def load_toml(path: Path) -> dict:
    with path.open("rb") as handle:
        return tomllib.load(handle)


def fixture_paths() -> list[Path]:
    return sorted(FIXTURE_ROOT.glob("*/*/fixture.toml"))


def run_probe(fixture_id: str, fixture_dir: Path) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        [
            str(KYOKAI),
            "internal",
            "conformance-fixture",
            fixture_id,
            "--fixture-root",
            str(fixture_dir),
        ],
        cwd=ROOT,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        check=False,
    )


def print_probe_output(result: subprocess.CompletedProcess[str]) -> None:
    if result.stdout:
        print(result.stdout, end="")
    if result.stderr:
        print(result.stderr, end="", file=sys.stderr)


def run_all() -> None:
    paths = fixture_paths()
    if not paths:
        print("conformance-runner: error: no fixture metadata files found", file=sys.stderr)
        raise SystemExit(1)

    executed = 0
    skipped = 0
    failures: list[str] = []

    for path in paths:
        data = load_toml(path)
        fixture_id = data.get("id", path.parent.name)
        status = data.get("status")
        if status not in {"active", "implementation-gated"}:
            skipped += 1
            print(f"conformance-runner: skip {fixture_id}: status {status}")
            continue

        executed += 1
        result = run_probe(fixture_id, path.parent)
        if result.returncode == 0:
            evidence = "implementation-gated" if status == "implementation-gated" else "active"
            print(f"conformance-runner: {evidence} pass {fixture_id}")
        else:
            print_probe_output(result)
            failures.append(fixture_id)
            print(f"conformance-runner: fail {fixture_id}", file=sys.stderr)

    if failures:
        print(
            "conformance-runner: failed fixtures: " + ", ".join(failures),
            file=sys.stderr,
        )
        raise SystemExit(1)

    print(
        f"conformance-runner: executed {executed} fixtures; skipped {skipped}; "
        "implementation-gated passes are supporting evidence only"
    )


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true", help="execute supported Phase 3 fixtures")
    args = parser.parse_args()
    if not args.check:
        parser.error("expected --check")
    run_all()


if __name__ == "__main__":
    main()
