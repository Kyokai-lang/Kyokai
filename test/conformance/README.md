# Kyokai Conformance Scaffold

This directory is the future executable evidence home for accepted Kyokai behavior. It is intentionally separate from inherited Austral fixtures under `test-programs/`. A file in this directory contributes to a conformance claim only when its fixture metadata names the accepted contract, source files, edition, expected stage, target assumptions, and expected result.

The first lanes will be materialized as their runners land:

| Lane | Initial purpose |
| --- | --- |
| `lexer/` | Accepted and rejected UTF-8, comments, identifiers, literals, operators, and reserved words. |
| `parser/` | Accepted and rejected `.kyo` / `.kai` grammar forms plus source spans. |
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

Host-level OCaml tests remain under `test/`. Minimized replay fixtures will live under `test/replay/` once the runner schema is implemented. The runner must report implementation-gated cases separately from passes; skipped work is not conformance evidence.

## Prototype Host Tests

`test/KyokaiSourceFileTest.ml`, `test/KyokaiSourceTextTest.ml`, and
`test/KyokaiLexicalTokenTest.ml` are host-side prototype tests. They establish scaffold
behavior for source roles, the source-byte contract, and an isolated lexical-token
layer. They are not Kyokai conformance evidence until the scanner is
wired into the Kyokai frontend and the public lexer fixture lanes exist.
