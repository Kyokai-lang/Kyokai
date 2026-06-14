# Compiler Pipeline Inventory

This inventory records the inherited Austral bootstrap compiler as it exists while Kyokai frontend bring-up begins. It is an implementation map, not a language specification and not a conformance claim. Kyokai behavior is defined by `kyokaispec/`.

## Current Entry Boundary

| Boundary | Current path | Current role | Kyokai migration pressure |
| --- | --- | --- | --- |
| Executable entry | `bin/austral.ml` | Starts the inherited CLI. | Add the `kyokai` public entry only when its command behavior can be labeled honestly. Keep inherited execution available while bootstrap fixtures migrate. |
| CLI parsing | `lib/CliUtil.ml`, `lib/CliParser.ml` | Parses the inherited whole-program `compile` command. | Replace inherited `.aui` / `.aum` arguments with manifest-driven single-file `.kyo` discovery. |
| CLI execution | `lib/CliEngine.ml` | Reads source files, selects typecheck, executable, or generated-C mode, and invokes the compiler pipeline. | Split stable `kyokai` commands from temporary bootstrap-only compiler entry paths. Do not present inherited command behavior as full toolchain conformance. |
| Kyokai source-file scaffold | `lib/compiler/frontend/source/KyokaiSourceFile.ml` | Accepts `.kyo` as the one handwritten source role, rejects retired `.kai`, inherited `.aui` / `.aum`, and handwritten `.koi`, then selects executable-entry source-byte preparation. | Preserve this file-role boundary when wiring the final frontend and diagnostic catalog. |
| Kyokai source-byte scaffold | `lib/compiler/frontend/source/KyokaiSourceText.ml` | Isolated validation for UTF-8, BOM rejection, LF/CRLF and bare-CR handling, Unicode-scalar diagnostic columns, and executable-entry shebang gating. | Connect executable-target discovery and loader invocation before parser wiring. |
| Kyokai lexical-token scaffold | `lib/compiler/frontend/lexer/KyokaiLexicalToken.ml` | Isolated host-side scanner for Kyokai source-byte errors, comments, identifiers, keywords, punctuation, numeric-token boundaries, literal families, spans, and inherited-form rejections. It consumes prepared source while preserving shebang-adjusted original offsets when requested. It is not wired into `Lexer.mll`. | Add exhaustive lexer fixtures, then introduce deliberate parser start symbols and diagnostic records before loader wiring. |
| Kyokai surface-parser scaffold | `lib/compiler/frontend/parser/KyokaiSurfaceParser.ml` | Parses the one-file module skeleton, declaration visibility and boundaries, structured constant/type-alias/function/record/bitrecord/union/typeclass/instance/generator summaries, generic parameter classifiers, borrow and function-pointer types, `where` obligations, associated-type and method surfaces, ordered contract-expression spans, declaration-guard spans, unresolved bare generic names, and unambiguous const-generic `Index` literals/arithmetic. Bodyless top-level generators are rejected. | Replace summary-only shapes with the final span-carrying AST, complete guard/contract/initializer/body and const-generic/comptime expression parsing, resolve argument kinds, add generator body/yield and foreign/unsafe-contract coverage, then retire the inherited parser path. |
| Kyokai interface-validation scaffold | `lib/compiler/frontend/semantic/KyokaiInterfaceValidation.ml` | Validates local public/internal type visibility through represented constant, alias, function, transparent record/union, typeclass-method, instance, and generator surfaces, omits opaque representation details from client-facing checks, and rejects private `opaque` declarations that create no external representation boundary. | Expand validation over final expression/contracts, imported names, evaluated target guards, coherence, and resolved package graphs before claiming complete semantic interface checking. |
| Kyokai package-source scaffold | `lib/compiler/package/manifest/KyokaiPackageSource.ml` | Parses the Phase 3 package-manifest subset and dependency entries; selects executable targets; discovers one `.kyo` source per logical module; rejects retired `.kai`, generated `.koi`, and inherited `.aui` / `.aum`; checks canonical containment and module declarations; validates the local derived interface; derives the public/`internal` declaration surface that later `.koi` production consumes; verifies the selected entry definition; applies shebang policy to the selected source; and loads explicit workspace members. | Expand resolver lanes, lockfile modes, workspace profile inheritance, inherited loader handoff, final AST integration, cross-module interface validation, and public conformance before claiming package/source conformance. |
| Prototype conformance fixture runner | `toolchain/conformance/run_fixtures.py`, `toolchain/conformance/stage_runner/KyokaiConformanceStageLib.ml` | Executes the current implementation-gated parser, module, interface-validation, and package fixture scaffolds through a Dune-built compiler-stage probe. It reports supporting passes separately from conformance-backed evidence. | Expand compiler-stage semantic result and diagnostic-code matching, then move fixture status to active only when the accepted public-command/compiler-stage evidence contract is satisfied. |

## Current Compiler Pipeline

| Order | Boundary | Current path | Current input and output | Kyokai pressure |
| ---: | --- | --- | --- | --- |
| 1 | Parse inherited interface and body | `lib/ParserInterface.ml`, `lib/Lexer.mll`, `lib/Parser.mly` | Inherited source text becomes separate concrete interface and body trees. | Replace this path with Kyokai's one `.kyo` start symbol and final AST while preserving source spans and retired-form diagnostics. |
| 2 | Insert inherited pervasive imports | `lib/Compiler.ml`, `lib/BuiltIn.ml` | The inherited pipeline inserts `Austral.Pervasive` imports before combination. | Remove hidden-prelude assumptions where Kyokai built-ins are language-level names. Preserve bootstrap built-ins until replacements exist. |
| 3 | Combine inherited files | `lib/CombiningPass.ml` | Interface and body declarations become one combined module with inherited visibility behavior. | Retire this source-pair boundary for Kyokai; derive public/`internal` interface facts from the one source AST and keep private declarations local. |
| 4 | Desugar inherited surface forms | `lib/DesugaringPass.ml` | Combined syntax is lowered before extraction. | Replace inherited lowering with the ordered D238 elaboration pipeline. Every accepted implicit completion must become an auditable node. |
| 5 | Extract declarations | `lib/ExtractionPass.ml`, `lib/Env.ml` | Declarations enter the environment and linked module representation. | Add deterministic module/package identity, visibility, import, and future `.koi` boundaries before deep typing work. |
| 6 | Type and resolve expressions | `lib/TypingPass.ml`, `lib/TypeCheckExpr.ml`, `lib/TypeSystem.ml`, `lib/TypeClasses.ml` | Linked declarations become typed syntax. | Implement Kyokai inference, generics, coherence, UFCS fallback, target guards, and explicit diagnostic facts only after frontend roles are stable. |
| 7 | Check linearity | `lib/LinearityCheck.ml`, `lib/DesugarBorrows.ml` | The inherited checker validates Austral-shaped movement and borrowing. | Keep this boundary separate from frontend scaffolding while Gate B remains open. Later adapt it to the accepted Kyokai checker state, cleanup, and borrow-elaboration rules. |
| 8 | Extract bodies and monomorphize | `lib/BodyExtractionPass.ml`, `lib/Monomorphize.ml`, `lib/ExportInstantiation.ml` | Typed declarations become monomorphic typed declarations and wrapper materialization inputs. | Align materialization with Kyokai `.koi`, deterministic artifact identity, and as-if monomorphization rules. |
| 9 | Generate and render C | `lib/CodeGen.ml`, `lib/CRenderer.ml`, `lib/prelude.c`, `lib/prelude.h` | Monomorphic typed declarations become C translation units plus runtime support. | Close generated-C undefined-behavior obligations, split deterministic incremental units, and preserve generated-C inspection/source maps as first-class evidence. No direct LLVM migration path exists under D530. |

## Source-Span Reality

The inherited parser creates spans from lexer positions and several CST nodes retain locations. That is useful bootstrap material, but it is not yet evidence for Kyokai's required span preservation. Kyokai frontend work must test spans across single-file `.kyo` parsing, diagnostics, inserted elaboration nodes, generated C source mapping, formatter edits, Analysis Server edits, and checked fixes.

## Proof Boundary

This inventory does not change `lambda_K-seq`, L1-L40, Theorem P, Theorem Q, or any Gate B claim. Frontend scaffolding must remain outside ownership-sensitive lowering until the maintained calculus has completed review.

## Pass Invariant Audit

The inherited pipeline is useful bootstrap material, but its type boundaries are not
Kyokai's target architecture. This table separates current OCaml facts from the D238
pipeline that must replace or split them.

| Current boundary | Current OCaml input | Current OCaml output | Span and diagnostic reality | D238 target boundary |
| --- | --- | --- | --- | --- |
| `ParserInterface.parse_module_int` | `string`, filename | `Cst.concrete_module_interface` | `Lexer.mll` updates `Lexing.position`; parse failures receive `Span.from_lexbuf`. CST coverage is inherited and incomplete for Kyokai span requirements. | Source bytes -> Kyokai tokens -> one `.kyo` AST with byte/logical spans and declaration visibility. |
| `ParserInterface.parse_module_body` | `string`, filename | `Cst.concrete_module_body` | Same inherited lexer/parser path. This start symbol has no Kyokai source-role counterpart under D537. | Remove it from the Kyokai entry path; `.kai` receives a retired-extension diagnostic before parsing. |
| `Compiler.append_import_to_interface` / `append_import_to_body` | inherited CST | inherited CST with hidden `Austral.Pervasive` import | Hidden prelude insertion has no Kyokai source span. | Remove hidden prelude semantics. Language-level built-ins resolve explicitly; generated nodes retain an origin record. |
| `CombiningPass.combine` / `body_as_combined` | inherited interface/body CST | `Stages.Combined.combined_module` | Interface/body mismatch and inherited visibility errors occur here. | Replace source pairing with one-source normalization plus derived-interface extraction before semantic lowering. |
| `DesugaringPass.desugar` | `Stages.Combined.combined_module` | `Stages.SmallCombined.combined_module` | Inherited path/control/borrow rewriting is bundled together and is not a D238 completion registry. | Split CST normalization, name resolution, expected-type flow, tautological implicit-completion selection, explicit completion-node recording, and sugar lowering. |
| `ExtractionPass.extract` | small combined module plus file IDs | `Env.env`, `Stages.Linked.linked_module` | File IDs survive into environment state, but the inherited shape is not proof of end-to-end source-origin retention. | Preserve source origin through linked declarations and `.koi` facts. |
| `TypingPass.augment_module` | environment and linked module | `Stages.Tast.typed_module` | Type diagnostics use inherited error framing. | Produce typed Kyokai nodes with origin spans, completion IDs, and deterministic diagnostics. |
| `LinearityCheck.check_module_linearity` | typed module | validated typed module by side-effecting rejection | Ownership-sensitive inherited behavior remains bootstrap-only. | Consume typed elaboration facts only after Gate B review and Kyokai checker-state implementation. |
| `BodyExtractionPass.extract_bodies`, `Monomorphize.monomorphize` | environment and typed module | environment and `Stages.Mtast.mono_module` | Materialization is inherited and whole-program shaped. | Align with deterministic `.koi`, edition, target-contract, and as-if monomorphization identity. |
| `CodeGen.gen_module`, `CRenderer.render_unit` | monomorphic module | C AST and rendered C text | Generated C exists, but source mapping and UB closure are incomplete. | Emit inspectable generated C with Kyokai source mapping and Gate D evidence. |

## Diagnostic Ownership

Frontend diagnostics should be owned by the earliest boundary that can state the true
rule. The source-byte scanner owns malformed encoding, BOM, bare-CR, and role-gated
shebang errors. `KyokaiSourceText` now prototypes that isolated boundary, including
Unicode-scalar diagnostic columns while preserving original byte offsets. The lexical scanner owns inherited punctuation, invalid numeric token,
and ASCII-identifier errors. The parser owns token-sequence grammar errors. The loader
owns `.kyo`, retired `.kai`, generated `.koi`, and module-path errors. Later passes must not relabel
an earlier failure as a type, linearity, or backend problem.

The isolated `KyokaiSourceText`, `KyokaiLexicalToken`, `KyokaiSurfaceParser`,
and `KyokaiPackageSource` scaffolds currently compose as a host-side frontend prefix. `toolchain/conformance/run_fixtures.py` executes the current implementation-gated parser and module fixture packs through that prefix as supporting evidence only. The lexical layer still implements only part of the
lexical row: C-family line-comment tokenization, ASCII identifier and keyword
classification, punctuation including `!=`, numeric boundary checks for `_`,
`0x`/`0b`/`0o`, suffixes, static-string/raw-string/code-point/byte literal tokenization, the closed
`@embedBytes` / `@embedText` comptime-builtin family, CRLF-aware host spans, and targeted rejection for selected inherited forms. The package-source scaffold now owns the first manifest-rooted package source map: package manifests, explicit module roots, dependency syntax parsing, canonical containment rejection, logical module paths, one `.kyo` source per module, retired `.kai` rejection, derived public/`internal` interface facts, declaration-name verification, command-level executable-target selection, selected-target executable-entry validation, selected-target shebang policy, explicit workspace member loading without unlisted-package inference, and duplicate workspace package-name rejection. Git/index solving, remaining graph-changing lockfile modes, workspace profile inheritance, and inherited-loader wiring remain open. Exhaustive fixture coverage, parser
integration with the final AST, and stable public diagnostic codes remain open and are
recorded as ProofTrace exclusions.
