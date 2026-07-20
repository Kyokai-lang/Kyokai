# Compiler pipeline inventory

This document records the implementation boundary after Phase 3. It does not
define Kyokai semantics and it does not turn implementation-gated fixtures into
conformance evidence. The normative rules remain in `kyokaispec/`.

## Phase 3 source path

Kyokai source no longer enters the inherited Austral lexer, parser, interface
file parser, or combining pass. The active Phase 3 path is:

```text
kyokai internal frontend-check
  -> package/workspace manifest classification
  -> manifest-rooted .kyo discovery
  -> source-role and source-byte validation
  -> Kyokai lexer
  -> Kyokai surface AST parser
  -> structural control-flow validation
  -> local interface validation
  -> derived public/internal declaration surface
```

`compiler/frontend/KyokaiFrontend.ml` owns the composition from source text to
the checked Phase 3 result. `compiler/package/manifest/KyokaiPackageSource.ml`
owns paths, module identity, target-entry selection, and package/workspace
loading. The package loader calls the frontend directly. It does not call
`lib/ParserInterface.ml`, `lib/Lexer.mll`, `lib/Parser.mly`, or
`lib/CombiningPass.ml`.

The result is deliberately smaller than `kyokai check`. Resolution, complete
cross-module visibility, typing, elaboration, ownership, `.koi` production, and
lowering are later phases. The bootstrap command therefore exposes this path
under `kyokai internal frontend-check`; it does not borrow the public name
`kyokai check` before that command can satisfy its accepted contract.

## Active owner map

Every path in this table has one current owner and one D592a target-language
disposition. `REIMPLEMENT_IN_KYOKAI` means that the OCaml code is a bounded
bootstrap implementation, not the final toolchain language.

| Current path | Current owner | Phase 3 contract | Semantic disposition | Target-language disposition |
| --- | --- | --- | --- | --- |
| `bin/kyokai.ml` | bootstrap CLI entry | Kyokai identity, version output, and explicitly internal frontend/fixture probes | `RETAIN` | `REIMPLEMENT_IN_KYOKAI` |
| `toolchain/cli/version/` | CLI version boundary | One bootstrap version source for the public executable | `RETAIN` | `REIMPLEMENT_IN_KYOKAI` |
| `compiler/frontend/source/` | source boundary | `.kyo` role, retired/generated/inherited role rejection, UTF-8, newline, BOM, shebang, and stable source positions | `RETAIN` | `REIMPLEMENT_IN_KYOKAI` |
| `compiler/frontend/lexer/` | lexical boundary | Kyokai tokens and literals, contextual identifiers, word borrow operators, comments, and named inherited-form rejection | `RETAIN` | `REIMPLEMENT_IN_KYOKAI` |
| `compiler/frontend/ast/` | surface AST boundary | Span-carrying imports, declarations, types, expressions, patterns, and statements | `RETAIN` | `REIMPLEMENT_IN_KYOKAI` |
| `compiler/frontend/parser/` | grammar boundary | One-file module grammar and the Phase 3 surface forms represented by the AST | `RETAIN` | `REIMPLEMENT_IN_KYOKAI` |
| `compiler/frontend/semantic/` | phase-local structural checks | Context legality and local derived-interface visibility; no typing or ownership claim | `ADAPT` | `REIMPLEMENT_IN_KYOKAI` |
| `compiler/frontend/KyokaiFrontend.*` | frontend handoff | Sole Phase 3 composition point and derived-interface result | `RETAIN` | `REIMPLEMENT_IN_KYOKAI` |
| `compiler/package/manifest/` | package source loader | TOML subset, project-kind classification, manifest-rooted discovery, module/path identity, and entry selection | `ADAPT` | `REIMPLEMENT_IN_KYOKAI` |
| `compiler/package/resolver/` | Phase 4 resolver owner | Existing workspace-only scaffold; it is not part of the Phase 3 frontend claim | `ADAPT` | `REIMPLEMENT_IN_KYOKAI` |
| `compiler/package/lockfile/` | Phase 4 lockfile owner | Existing deterministic workspace scaffold; it is not a final lockfile implementation | `REPLACE` | `REIMPLEMENT_IN_KYOKAI` |
| `toolchain/conformance/` | evidence adapter | Runs implementation-gated fixtures through the active compiler stage and preserves claim labels | `RETAIN` | `REIMPLEMENT_IN_KYOKAI` |
| `test/host/frontend/` | host implementation tests | Positive, negative, span, structural-check, package-source, resolver, and lockfile tests | `RETAIN` | `REIMPLEMENT_IN_KYOKAI` |
| `test/conformance/` | public fixture corpus | Accepted/rejected inputs and expected stage facts; current Phase 3 executions remain supporting evidence | `RETAIN` | `REIMPLEMENT_IN_KYOKAI` |

`toolchain/identity/check_phase3_identity.py` verifies the package/binary
identity, public path registration, fixture command boundary, active frontend
location, and inherited-module transition coverage.

## Inherited compiler dispositions

The inherited compiler remains in `lib/` for bootstrap evidence and tests. It
is not the Kyokai source-language entry. The machine-checked family map is
`docs/compiler-transition-inventory.toml`; every `.ml`, `.mli`, `.mll`, and
`.mly` file directly under `lib/` must match exactly one family.

| Inherited family | Semantic disposition | Target-language disposition | Reason |
| --- | --- | --- | --- |
| Two-file lexer/parser/CST/combiner | `REPLACE` | `REMOVE` | Kyokai has one `.kyo` module source and a derived interface. |
| Hidden built-ins | `REPLACE` | `REIMPLEMENT_IN_KYOKAI` | Language built-ins and admitted libraries replace `Austral.Pervasive` insertion. |
| Public CLI and whole-program driver | `DELETE` or `REPLACE` | `REMOVE` | Their arguments, file roles, and pipeline are not Kyokai command semantics. |
| Surface/control lowering | `REPLACE` | `REIMPLEMENT_IN_KYOKAI` | D238 requires ordered elaboration and visible completion records. |
| Names, modules, and environments | `ADAPT` | `REIMPLEMENT_IN_KYOKAI` | The separation survives; package identity, visibility, imports, and `.koi` semantics change. |
| Types and typed IR | `ADAPT` | `REIMPLEMENT_IN_KYOKAI` | Nominal typing survives, while universes, inference, typeclasses, and elaboration change. |
| Linearity checker | `ADAPT` | `REIMPLEMENT_IN_KYOKAI` | Austral is prior art; Kyokai adds reviewed checker states, cleanup, capability, and calculus rules. |
| Materialization and generated C | `ADAPT` | `REIMPLEMENT_IN_KYOKAI` | Static materialization and generated C survive under deterministic artifact and no-UB contracts. |
| Diagnostics, source facts, and reporting | `ADAPT` | `REIMPLEMENT_IN_KYOKAI` | Source origins survive; stable codes and machine output replace inherited presentation. |
| General host utilities | `RETAIN` | `REIMPLEMENT_IN_KYOKAI` | Only implementation-independent algorithms survive. |

The old executable source is retained at
`toolchain/bootstrap/legacy/AustralBootstrapCli.ml` as licensed historical
bootstrap material. It is not built by `bin/dune` and is not installed.

## Span boundary

The source layer records byte offsets and line/column positions after UTF-8 and
newline validation. Tokens retain those spans. The surface AST retains spans on
imports, declarations, types where represented, expressions, patterns,
statements, and nested bodies. Host tests cover source-byte positions, CRLF,
Unicode-scalar columns, shebang-adjusted offsets, and nested parser spans.

Phase 3 does not claim span preservation through typing, inserted elaboration
nodes, `.koi`, generated C, formatter edits, Analysis Server edits, or checked
fixes. Those owners must extend the same source-origin chain in their phases.

## Diagnostic ownership

The earliest boundary that knows the violated rule owns the error:

| Boundary | Errors owned in Phase 3 |
| --- | --- |
| Source role | retired `.kai`, inherited `.aui`/`.aum`, handwritten `.koi`, empty or unsupported source path |
| Source bytes | malformed UTF-8, BOM, bare CR, and role-gated shebang |
| Lexer | invalid token/literal form, retired punctuation, identifier boundary, and reserved-word classification |
| Parser | illegal token sequence, missing terminator, malformed declaration/expression/pattern/statement, and rejected inherited grammar |
| Structural checks | control form outside its legal enclosing form and local interface visibility/opacity violation |
| Package loader | manifest/source discovery, containment, module-path identity, target selection, and entry-definition mismatch |

Stable released diagnostic codes belong to Phase 8. Phase 3 tests compare the
current typed error category and message facts without upgrading them to a
released diagnostic-code promise.

## Evidence boundary

The aggregate Dune host suite, fixture metadata checker, implementation-gated
stage runner, CLI identity checker, and direct internal CLI probes are Phase 3
implementation evidence. The fixture runner labels all current results as
supporting passes. Public conformance requires the later public-command,
diagnostic-code, bounded-execution, and report contracts.

This inventory does not change any `lambda_K-seq` claim. The Phase 3 frontend
stops before ownership-sensitive elaboration and checking.
