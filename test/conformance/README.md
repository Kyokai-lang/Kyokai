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
| `backend/` | Generated-C inspection, sanitizer runs, target contracts, source mapping, and admitted C-compiler agreement. |
| `diagnostics/` | Stable diagnostic IDs, spans, related facts, explain entries, and checked fixes. |
| `koi/` | Deterministic `.koi` structure, verification, printing, diffs, and compatibility. |
| `toolchain/` | CLI, manifests, outputs, caches, docs, formatter, LSP, audit, and replay behavior. |
| `packages/` | Workspace resolution, lockfiles, vendoring, index metadata, and package docs. |

Host-level OCaml tests remain under `test/`. Minimized replay fixtures belong under `test/replay/` once the runner schema is implemented. The runner must report implementation-gated cases separately from passes; skipped work is not conformance evidence.

`SCHEMA.md` records the required fixture metadata. The lane directories exist whether or not their implementation has started. No lane claims conformance status until the public runner, released diagnostic contract, and owning gate permit it.

Thirty-one `implementation-gated` fixtures cover the represented parser surface, span preservation, inherited-form rejection, package source discovery, executable-entry validation, generated `.koi` rejection, module-name/path checks, a local interface leak, and the workspace graph/lockfile precursor. Their internal executions are pass/fail implementation evidence, not public conformance results.

`make check-conformance-fixtures` validates fixture metadata, lane placement, input paths, status labels, and ProofTrace references. It is a metadata checker, not an execution runner.

`make run-conformance-fixtures` first checks metadata, then executes the parser, module, and package fixtures through `kyokai internal conformance-fixture`. That probe reaches the same `KyokaiFrontend` and package boundaries as the host tests. The runner compares `expected_outcome`, `expected_stage`, `expected_code`, and `expected_facts`, then reports `implementation-gated` passes separately. They are not Kyokai conformance passes because the public `kyokai check` contract, released diagnostic catalog, name/type/ownership pipeline, runtime/backend execution, and release conformance reporter are not implemented.

## Phase 3 Supporting Host Tests

`test/host/frontend/KyokaiSourceFileTest.ml`, `test/host/frontend/KyokaiSourceTextTest.ml`,
`test/host/frontend/KyokaiLexicalTokenTest.ml`, `test/host/frontend/KyokaiSurfaceParserTest.ml`,
`test/host/frontend/KyokaiFrontendTest.ml`, `test/host/frontend/KyokaiControlFlowValidationTest.ml`,
`test/host/frontend/KyokaiInterfaceValidationTest.ml`, and
`test/host/frontend/KyokaiPackageSourceTest.ml` exercise the active Phase 3 frontend path.
They establish implementation behavior for source roles and bytes, tokens, the surface AST,
phase-local semantic checks, derived interfaces, and manifest-rooted package loading. They are not
public conformance evidence.
