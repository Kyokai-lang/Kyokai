#!/usr/bin/env python3
# kyokai:prooftrace id=TOOL-PHASE3-IDENTITY-CHECK
"""Check the Phase 3 fork-identity and implementation-ownership boundary."""

from __future__ import annotations

import fnmatch
import pathlib
import sys
import tomllib


ROOT = pathlib.Path(__file__).resolve().parents[2]
SOURCE_SUFFIXES = {".ml", ".mli", ".mll", ".mly"}
SEMANTIC_DISPOSITIONS = {"RETAIN", "ADAPT", "REPLACE", "DELETE"}
IMPLEMENTATION_DISPOSITIONS = {
    "KEEP_BOOTSTRAP",
    "WRAP",
    "REIMPLEMENT_IN_KYOKAI",
    "REMOVE",
}


def read(relative: str) -> str:
    return (ROOT / relative).read_text(encoding="utf-8")


def require(condition: bool, message: str, failures: list[str]) -> None:
    if not condition:
        failures.append(message)


def check_transition_inventory(failures: list[str]) -> None:
    inventory_path = ROOT / "docs/compiler-transition-inventory.toml"
    inventory = tomllib.loads(inventory_path.read_text(encoding="utf-8"))
    families = inventory.get("family", [])
    require(bool(families), "transition inventory has no module families", failures)

    for family in families:
        require(
            family.get("semantic") in SEMANTIC_DISPOSITIONS,
            f"invalid semantic disposition in family {family.get('name')!r}",
            failures,
        )
        require(
            family.get("implementation") in IMPLEMENTATION_DISPOSITIONS,
            f"invalid implementation disposition in family {family.get('name')!r}",
            failures,
        )

    inherited_sources = sorted(
        path.relative_to(ROOT).as_posix()
        for path in (ROOT / "lib").iterdir()
        if path.is_file() and path.suffix in SOURCE_SUFFIXES
    )
    for source in inherited_sources:
        owners = [
            family["name"]
            for family in families
            if any(fnmatch.fnmatchcase(source, pattern) for pattern in family["paths"])
        ]
        require(
            len(owners) == 1,
            f"{source} must match exactly one transition family; matched {owners}",
            failures,
        )


def check_fixture_commands(failures: list[str]) -> None:
    for fixture in sorted((ROOT / "test/conformance").rglob("fixture.toml")):
        metadata = tomllib.loads(fixture.read_text(encoding="utf-8"))
        command = metadata.get("command", "")
        require(
            command.startswith("kyokai internal conformance-fixture "),
            f"{fixture.relative_to(ROOT)} uses a non-Phase-3 fixture command: {command!r}",
            failures,
        )


def main() -> int:
    failures: list[str] = []

    require("(name kyokai)" in read("dune-project"), "dune project is not named kyokai", failures)
    require("(name kyokai)" in read("bin/dune"), "public executable is not named kyokai", failures)
    require("(name austral)" not in read("bin/dune"), "bin/dune still exposes austral", failures)
    require("BIN := kyokai" in read("Makefile"), "Makefile binary identity is not kyokai", failures)
    require('pname = "kyokai"' in read("flake.nix"), "flake package identity is not kyokai", failures)
    require((ROOT / "kyokai.opam").is_file(), "kyokai.opam is missing", failures)
    require(not (ROOT / "austral.opam").exists(), "austral.opam remains at the public package boundary", failures)
    require(not (ROOT / "bin/austral.ml").exists(), "legacy Austral entry remains in bin/", failures)
    require(not (ROOT / "lib/compiler").exists(), "active Kyokai compiler code remains under lib/compiler", failures)
    require((ROOT / "compiler/frontend/KyokaiFrontend.ml").is_file(), "Phase 3 frontend owner is missing", failures)
    require((ROOT / "editor/README.md").is_file(), "editor boundary is not classified", failures)
    require(
        "The self-host entry threshold has not been met" in read("phase.md"),
        "the public D592a self-host entry state is missing",
        failures,
    )

    check_transition_inventory(failures)
    check_fixture_commands(failures)

    if failures:
        for failure in failures:
            print(f"phase3-identity: FAIL: {failure}", file=sys.stderr)
        return 1

    print("phase3-identity: Kyokai identity, fixture commands, and transition ownership are consistent")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
