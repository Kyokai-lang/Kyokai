# Kyokai Conformance Scaffold

This directory is the executable-evidence home for accepted Kyokai behavior. It is intentionally separate from inherited Austral fixtures under `test-programs/`. A file in this directory contributes to a conformance claim only when its fixture metadata names the accepted contract, source files, edition, expected stage, target assumptions, and expected result.

> D537-D539 status: the active parser and module fixtures use one `.kyo` source per module, per-declaration visibility, and `opaque` representation markers. Retired `.kai` input is rejection material, not an accepted source role. These implementation-gated fixtures remain supporting evidence until the public conformance gate is met.

The conformance lanes are:

| Lane | Initial purpose |
| --- | --- |
| `lexer/` | Accepted and rejected UTF-8, comments, identifiers, literals, operators, and reserved words. |
| `parser/` | Accepted and rejected single-file `.kyo` grammar forms plus source spans, visibility, and opacity. |
| `modules/` | File roles, imports, visibility, body-only restrictions, and cycle diagnostics. |
| `typing/` | Inference, nominal typing, generics, typeclasses, and ambiguity rejection. |
| `linearity/` | Ownership, movement, cleanup, branch joins, loops, and early release. |
| `borrows/` | Immutable borrows, mutable borrows, reborrows, suspension, escape rejection, and diagnostics. |
| `elaboration/` | Ordered lowering, implicit-completion records, tautology checks, and source origins. |
| `contracts/` | Preconditions, postconditions, panic, TPOE, and defined runtime-failure payloads. |
| `capabilities/` | Explicit authority, denial paths, safe wrappers, and audit facts. |
| `unsafe/` | Unsafe contracts, raw primitive gates, ABI wrappers, and audit coverage. |
| `runtime/` | Defined execution, fatal behavior, cleanup, and target-sensitive runtime contracts. |
| `backend/` | Generated-C inspection, sanitizer runs, and later shared C/LLVM behavior. |
| `diagnostics/` | Stable diagnostic IDs, spans, related facts, explain entries, and checked fixes. |
| `koi/` | Deterministic `.koi` structure, verification, printing, diffs, and compatibility. |
| `toolchain/` | CLI, manifests, outputs, caches, docs, formatter, LSP, audit, and replay behavior. |
| `packages/` | Workspace resolution, lockfiles, vendoring, index metadata, and package docs. |

Host-level OCaml tests remain under `test/`. Minimized replay fixtures belong under `test/replay/` once the runner schema is implemented. The runner must report implementation-gated cases separately from passes; skipped work is not conformance evidence.

`SCHEMA.md` records the required fixture metadata. The lane directories now exist as scaffold homes, but no lane claims conformance status until a runner consumes that metadata and reports results.

Initial `implementation-gated` fixture packs exist for parser source skeletons, parser span preservation, parser function signature summaries, parser record summaries, parser union summaries, inherited lexical rejection, package source discovery, executable-entry validation, generated `.koi` rejection, module-name/path mismatch, and workspace package graph plus lockfile rendering. They define expected public behavior for the conformance runner but are not pass/fail evidence yet.

`make check-conformance-fixtures` validates fixture metadata, lane placement, input paths, status labels, and ProofTrace references. It is a metadata checker, not an execution runner.

`make run-conformance-fixtures` first runs the metadata checker, then executes the current implementation-gated parser, module, and package fixture scaffolds through the Dune-built compiler-stage frontend/package runner. The runner compares `expected_outcome`, `expected_stage`, `expected_code`, and `expected_facts` against the implementation result, then reports `implementation-gated` passes as supporting evidence only. They are not Kyokai conformance passes because the public `kyokai check` command, full diagnostic-code catalog, full semantic frontend, type checker, linearity checker, runtime execution, and release conformance reporter are not wired yet.

## Prototype Host Tests

`test/host/frontend/KyokaiSourceFileTest.ml`, `test/host/frontend/KyokaiSourceTextTest.ml`,
`test/host/frontend/KyokaiLexicalTokenTest.ml`, `test/host/frontend/KyokaiSurfaceParserTest.ml`, and
`test/host/frontend/KyokaiPackageSourceTest.ml` are host-side prototype tests. They establish scaffold
behavior for source roles, the source-byte contract, an isolated lexical-token
layer, source-file skeleton parsing with function signature, record, and union
summaries, and manifest-rooted package source discovery.
They are not Kyokai conformance evidence until the frontend is wired to the
Kyokai loader and public fixture lanes are executed by a conformance runner.
