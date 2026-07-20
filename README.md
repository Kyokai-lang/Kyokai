# Kyokai

Kyokai is a systems programming language forked from Austral and built around explicit resource ownership, linear types, capability-based authority, and defined failure behavior.

Kyokai is currently in early public development. The accepted language shape and initial normative Kyokai spec have been extracted, while the compiler implementation is still being brought up from the inherited Austral codebase.

## Current Status

| Area | Status |
| --- | --- |
| Accepted language shape | Present in `kyokaidecided.md`. |
| Live public D-points | Carried by PRs/MRs or held temporarily in `Kyokaishape.md`; that file also keeps the decision index and archive. |
| Normative Kyokai spec | Active under `kyokaispec/`; accepted shape not yet fully extracted remains in `kyokaidecided.md`. |
| Compiler | Kyokai source/frontend boundary is active in `compiler/`; later passes still use classified Austral bootstrap code in `lib/`. |
| Standard library | Inherited Austral stdlib, being redesigned/admitted under Kyokai rules. |
| Roadmap | `phase.md`. |
| Code standards | `CODE_STANDARDS.md`. |
| Project workflow | `PROJECT_STANDARDS.md`. |

Inherited Austral examples, commands, docs, and spec files may still exist while the fork is being converted. Treat accepted Kyokai shape and written Kyokai spec text as the language authority, not stale inherited prose.

## Core Direction

Kyokai keeps Austral's most important safety ideas and pushes them toward a production systems language:

- linear ownership for resources
- capability-based authority instead of ambient global access
- no language-level undefined behavior
- explicit allocation, blocking, cleanup, and FFI boundaries
- TPOE for contract violations
- safe native standard-library implementations where practical
- explicit compiler/spec/test traceability

## Source-Of-Truth Order

1. `kyokaispec/` once a Kyokai rule is written there.
2. `kyokaidecided.md` for accepted Kyokai shape not yet spec-extracted.
3. Public PRs/MRs carrying live D-point proposals and final wording.
4. `Kyokaishape.md` for public temporary holding, active-proposal tracking, and index/archive material when a D-point does not live directly in a PR/MR.
5. Issues and discussions as motivation or pre-proposal material.
6. `phase.md` for implementation order only.

`phase.md` is not a language spec. It records ordering, gates, and status.

## Repository Map

| Path | Purpose |
| --- | --- |
| `compiler/` | Active Kyokai compiler source, including the Phase 3 frontend and package source loader. |
| `lib/` | Classified inherited OCaml bootstrap passes; not an owner for new Kyokai compiler code. |
| `toolchain/` | Bootstrap CLI support, fixture execution, identity checks, ProofTrace, and spec integrity tools. |
| `standard/` | Current inherited standard-library tree. |
| `test/` | Unit-level compiler tests. |
| `test-programs/` | End-to-end compiler tests inherited from Austral. |
| `kyokaispec/` | Normative Kyokai specification source and generated outputs. |
| `kyokaidecided.md` | Accepted Kyokai shape and maturity tracker. |
| `Kyokaishape.md` | Public temporary holding area, active-proposal tracker, decision index, and historical archive. |
| `phase.md` | Implementation/proof roadmap. |
| `CODE_STANDARDS.md` | Mandatory code standards. |
| `PROJECT_STANDARDS.md` | Public project workflow. |
| `docs/contributing/spec-writing.md` | Public guide for D-point/spec prose. |
| `docs/infrastructure/services.md` | Public service/infrastructure ownership board. |

## Building the current bootstrap compiler

The installed bootstrap executable is named `kyokai`. It exposes version output
and explicitly internal Phase 3 frontend probes. The accepted public `check`,
build, run, and other toolchain commands are not claimed by those probes.

With Nix:

```bash
nix-shell
make
```

Without Nix, install OCaml, Dune, and opam dependencies, then run:

```bash
opam install --deps-only -y .
make
```

Run tests with:

```bash
./run-tests.sh
```

Run the Phase 3 source boundary directly with:

```bash
./kyokai internal frontend-check path/to/package-or-workspace
./kyokai internal conformance-fixture parser.accepted-source-skeleton
```

Build the inherited standard library with:

```bash
cd standard
make
```

## Spec Workspace

`kyokaispec/` is intentionally kept inside this repository so spec text, compiler changes, tests, and phase tracking can move together.

The spec source is published by building HTML/PDF from `kyokaispec/` and deploying only generated artifacts to a `gh-pages` branch or generated-docs path. The source remains in the main monorepo by default. Under the D514 repository split, Kyokai keeps one main monorepo and separates only independently deployed or independently governed services such as the package index, generated package-doc mirror, and showcase when that separation becomes operationally necessary.

## License

Kyokai follows a split license boundary:

- compiler and toolchain code: `GPL-3.0-or-later`
- runtime, standard library, startup code, compiler support library, target-side helpers, and compiler-emitted target helper code: `GPL-3.0-or-later WITH GCC-exception-3.1`

The runtime exception keeps ordinary Kyokai target programs under the program author's chosen license when they merely use the Kyokai runtime, standard library, or exception-covered target helpers through the normal compilation/linking process.

See `LICENSE`, `COPYING`, and `COPYING.RUNTIME` for details.

Inherited Austral files may still carry Apache-2.0 WITH LLVM-exception notices. Preserve those notices unless the file is replaced or relicensed by the relevant copyright holder.
