# Compiler Pipeline Inventory

This inventory records the inherited Austral bootstrap compiler as it exists while Kyokai frontend bring-up begins. It is an implementation map, not a language specification and not a conformance claim. Kyokai behavior is defined by `kyokaispec/`.

## Current Entry Boundary

| Boundary | Current path | Current role | Kyokai migration pressure |
| --- | --- | --- | --- |
| Executable entry | `bin/austral.ml` | Starts the inherited CLI. | Add the `kyokai` public entry only when its command behavior can be labeled honestly. Keep inherited execution available while bootstrap fixtures migrate. |
| CLI parsing | `lib/CliUtil.ml`, `lib/CliParser.ml` | Parses the inherited whole-program `compile` command. | Replace inherited `.aui` / `.aum` arguments with manifest-driven `.kyo` / `.kai` discovery and direct-compiler source roles. |
| CLI execution | `lib/CliEngine.ml` | Reads source files, selects typecheck, executable, or generated-C mode, and invokes the compiler pipeline. | Split stable `kyokai` commands from temporary bootstrap-only compiler entry paths. Do not present inherited command behavior as full toolchain conformance. |
| Kyokai source-role scaffold | `lib/KyokaiSourceFile.ml` | Classifies `.kyo` interface paths, `.kai` body paths, and rejected `.koi` artifact paths, then selects role-gated source-byte preparation for later frontend entry wiring. It deliberately defines no public CLI encoding for a source set. | Wire executable-target discovery and the Kyokai loader only after parser start symbols exist. |
| Kyokai source-byte scaffold | `lib/KyokaiSourceText.ml` | Isolated validation for UTF-8, BOM rejection, LF/CRLF and bare-CR handling, Unicode-scalar diagnostic columns, and executable-entry shebang gating. | Connect executable-target discovery and loader invocation before parser wiring. |
| Kyokai lexical-token scaffold | `lib/KyokaiLexicalToken.ml` | Isolated host-side scanner for Kyokai source-byte errors, comments, identifiers, keywords, punctuation, numeric-token boundaries, literal families, spans, and inherited-form rejections. It consumes prepared source while preserving shebang-adjusted original offsets when requested. It is not wired into `Lexer.mll`. | Add exhaustive lexer fixtures, then introduce deliberate parser start symbols and diagnostic records before loader wiring. |

## Current Compiler Pipeline

| Order | Boundary | Current path | Current input and output | Kyokai pressure |
| ---: | --- | --- | --- | --- |
| 1 | Parse interface and body | `lib/ParserInterface.ml`, `lib/Lexer.mll`, `lib/Parser.mly` | Inherited source text becomes separate concrete interface and body trees. | Implement Kyokai lexical rules, `.kyo` / `.kai` start symbols, source spans, comments, literals, terminators, and negative rejection fixtures. |
| 2 | Insert inherited pervasive imports | `lib/Compiler.ml`, `lib/BuiltIn.ml` | The inherited pipeline inserts `Austral.Pervasive` imports before combination. | Remove hidden-prelude assumptions where Kyokai built-ins are language-level names. Preserve bootstrap built-ins until replacements exist. |
| 3 | Combine files | `lib/CombiningPass.ml` | Interface and body declarations become one combined module with inherited visibility behavior. | Implement Kyokai public, `internal`, private, body-only, and module-role rules without treating `.koi` as handwritten source. |
| 4 | Desugar inherited surface forms | `lib/DesugaringPass.ml` | Combined syntax is lowered before extraction. | Replace inherited lowering with the ordered D238 elaboration pipeline. Every accepted implicit completion must become an auditable node. |
| 5 | Extract declarations | `lib/ExtractionPass.ml`, `lib/Env.ml` | Declarations enter the environment and linked module representation. | Add deterministic module/package identity, visibility, import, and future `.koi` boundaries before deep typing work. |
| 6 | Type and resolve expressions | `lib/TypingPass.ml`, `lib/TypeCheckExpr.ml`, `lib/TypeSystem.ml`, `lib/TypeClasses.ml` | Linked declarations become typed syntax. | Implement Kyokai inference, generics, coherence, UFCS fallback, target guards, and explicit diagnostic facts only after frontend roles are stable. |
| 7 | Check linearity | `lib/LinearityCheck.ml`, `lib/DesugarBorrows.ml` | The inherited checker validates Austral-shaped movement and borrowing. | Keep this boundary separate from frontend scaffolding while Gate B remains open. Later adapt it to the accepted Kyokai checker state, cleanup, and borrow-elaboration rules. |
| 8 | Extract bodies and monomorphize | `lib/BodyExtractionPass.ml`, `lib/Monomorphize.ml`, `lib/ExportInstantiation.ml` | Typed declarations become monomorphic typed declarations and wrapper materialization inputs. | Align materialization with Kyokai `.koi`, deterministic artifact identity, and as-if monomorphization rules. |
| 9 | Generate and render C | `lib/CodeGen.ml`, `lib/CRenderer.ml`, `lib/prelude.c`, `lib/prelude.h` | Monomorphic typed declarations become C translation units plus runtime support. | Close backend undefined-behavior obligations before optimization or LLVM work. Preserve generated-C inspection as a first-class evidence lane. |

## Source-Span Reality

The inherited parser creates spans from lexer positions and several CST nodes retain locations. That is useful bootstrap material, but it is not yet evidence for Kyokai's required span preservation. Kyokai frontend work must test spans across `.kyo` and `.kai` parsing, diagnostics, inserted elaboration nodes, generated C source mapping, formatter edits, Analysis Server edits, and checked fixes.

## Proof Boundary

This inventory does not change `lambda_K-seq`, L1-L40, Theorem P, Theorem Q, or any Gate B claim. Frontend scaffolding must remain outside ownership-sensitive lowering until the maintained calculus has completed review.

## Pass Invariant Audit

The inherited pipeline is useful bootstrap material, but its type boundaries are not
Kyokai's target architecture. This table separates current OCaml facts from the D238
pipeline that must replace or split them.

| Current boundary | Current OCaml input | Current OCaml output | Span and diagnostic reality | D238 target boundary |
| --- | --- | --- | --- | --- |
| `ParserInterface.parse_module_int` | `string`, filename | `Cst.concrete_module_interface` | `Lexer.mll` updates `Lexing.position`; parse failures receive `Span.from_lexbuf`. CST coverage is inherited and incomplete for Kyokai span requirements. | Source bytes -> Kyokai tokens -> `.kyo` CST with byte/logical spans and file-role diagnostics. |
| `ParserInterface.parse_module_body` | `string`, filename | `Cst.concrete_module_body` | Same inherited lexer/parser path. Body-only acceptance is broader than the Kyokai package rule. | Source bytes -> Kyokai tokens -> `.kai` CST plus loader-owned body-only role check. |
| `Compiler.append_import_to_interface` / `append_import_to_body` | inherited CST | inherited CST with hidden `Austral.Pervasive` import | Hidden prelude insertion has no Kyokai source span. | Remove hidden prelude semantics. Language-level built-ins resolve explicitly; generated nodes retain an origin record. |
| `CombiningPass.combine` / `body_as_combined` | inherited interface/body CST | `Stages.Combined.combined_module` | Interface/body mismatch and inherited visibility errors occur here. | Module-role, visibility, import, and `.koi` boundaries become explicit checked inputs before semantic lowering. |
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
owns `.kyo` / `.kai` / `.koi` role and module-path errors. Later passes must not relabel
an earlier failure as a type, linearity, or backend problem.

The isolated `KyokaiSourceText` and `KyokaiLexicalToken` scaffolds currently
compose as a host-side frontend prefix. The lexical layer still implements only part of the
lexical row: C-family line-comment tokenization, ASCII identifier and keyword
classification, punctuation including `!=`, numeric boundary checks for `_`,
`0x`/`0b`/`0o`, suffixes, static-string/raw-string/code-point/byte literal tokenization, the closed
`@embedBytes` / `@embedText` comptime-builtin family, CRLF-aware host spans, and targeted rejection for selected inherited forms. Executable-target
discovery and inherited-loader wiring remain open. Exhaustive fixture coverage, parser
integration, and stable public diagnostic codes remain open and are
recorded as ProofTrace exclusions.
