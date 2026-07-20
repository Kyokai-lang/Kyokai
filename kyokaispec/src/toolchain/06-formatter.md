# Formatter

[Rikona Kurasaki / Mjoyufull]
> ProofTrace: SPEC-TOOLCHAIN-06-FORMATTER
> Covers: This chapter is registered in the public ProofTrace evidence graph; registration does not claim implementation, conformance, or theorem completion.

Kyokai has one official source format. The formatter applies it deterministically and without changing source meaning.

> Trace: D25
> Covers: Kyokai has an official formatter with one deterministic style.

## Contract

`kyokai fmt` formats `.kyo` source files. It is deterministic, idempotent, zero-configuration, and parse-preserving. Running it twice on the same source must produce byte-identical output the second time. Formatting must not change program semantics, module identity, comments' attachment to declarations, documentation comments' meaning, or diagnostic suppression scope.

> Trace: D25, D29, D52, D83, D442-D443
> Covers: Formatting is stable, semantic-preserving, and safe to automate.

The formatter must parse the source according to the package edition when a manifest context is available. If no manifest context is available, it may use the current default edition only for standalone file formatting, and it must report which edition was used in verbose or JSON mode.

> Trace: D25, D105
> Covers: Formatting is edition-aware and reports standalone assumptions.

A file with parse errors is not formatted by default. The formatter emits diagnostics and leaves the file unchanged. A workspace or package enables partial recovery with `fmt.recover_partial = true`. Recovery formats parser-confirmed subtrees, leaves invalid ranges byte-for-byte unchanged, reports every untouched range, and marks the result noncanonical. CLI recovery writes files only with explicit `--write-partial`; otherwise it prints a preview or returns LSP workspace edits. `kyokai fmt --check` remains strict unless its manifest policy explicitly admits partial formatting for that command.

> Trace: D25, D29
> Covers: The formatter does not guess through invalid syntax by default.

## Style Rules

The official style uses 4-space indentation, spaces instead of tabs for indentation, LF line endings, UTF-8 source, and a 100-column preferred line width. The 100-column rule is a formatter target, not a parser rule; long literals, long URLs in comments, and unbreakable identifiers may exceed it.

> Trace: D25, D63
> Covers: Core formatting width, indentation, encoding, and line-ending policy are fixed.

The formatter owns whitespace around operators, delimiters, declarations, blocks, parameter lists, type arguments, `where` clauses, contract clauses, and terminators. It preserves blank lines only where they separate meaningful groups; multiple blank lines are collapsed according to the official style.

> Trace: D25
> Covers: Whitespace layout is formatter-owned.

The formatter must preserve ordinary comments and documentation comments. It may move a comment only when the comment remains attached to the same syntax node or trivia position by the formatter's documented attachment rules. It must not reflow code examples inside documentation comments. A documentation-format mode is absent from this specification revision; a later revision must define one before a conforming formatter exposes it.

> Trace: D25, D218
> Covers: Formatting preserves comment and documentation meaning.

The formatter preserves import order unless workspace or package policy sets `fmt.sort_imports = true`. The enabled policy applies the deterministic grouping and byte-stable ordering rule defined below. Import sorting never changes visibility, lookup, shadowing, comment attachment, or import meaning.

> Trace: D25, D78, D214
> Covers: Import order is preserved because conflict semantics do not depend on order.

## Modes

| Mode | Behavior | Trace |
| --- | --- | --- |
| `kyokai fmt` | Format selected package or workspace files in place. | D25, D78 |
| `kyokai fmt --check` | Report files that would change and exit nonzero when any change is needed. | D25, D225 |
| `kyokai fmt --stdin --filename <path>` | Read one file from stdin, infer context from filename when possible, write formatted source to stdout. | D25, D105 |
| `kyokai fmt --diff` | Print a deterministic textual diff instead of editing files. | D25, D83 |
| `kyokai fmt --write-partial` | Write parser-confirmed subtree formatting only when `fmt.recover_partial = true`; leave invalid ranges byte-for-byte unchanged and report noncanonical output. | D443 |
| `kyokai fmt --format json` | Emit machine-readable file status and diagnostics. | D25, D29 |

> Trace: D25, D29, D78, D83, D105, D225
> Covers: Formatter modes are specified for local use, CI, editor integration, and scripts.

`--check` must not write files. `--diff` must not write files. `--stdin` must not read or write project files except for manifest discovery if a filename is provided and the command needs edition context.

> Trace: D25, D83
> Covers: Formatter modes have clear filesystem effects.

## File Selection

In package scope, `kyokai fmt` selects all `.kyo` files under the package module root and any explicitly declared generated-source outputs currently present when the generation chapter marks them formatter-owned. In workspace scope, it selects member packages in deterministic package-name order.

> Trace: D25, D78, D83
> Covers: Formatter file selection follows package/workspace/module roots deterministically.

Files outside module roots are not formatted unless passed explicitly by path. Explicit paths must still use a recognized Kyokai source extension. Additional source-like extensions are absent from this specification revision and cannot be introduced by formatter configuration alone.

> Trace: D25, D52, D78
> Covers: Formatter discovery does not wander through unrelated repository files.

## No Semantic Rewrites

The formatter must not insert missing imports, rename bindings, expand implicit completions, lower sugar, reorder declarations, choose pattern forms, simplify expressions, change numeric literal bases, change string literal families, or apply compiler suggestions. Those are compiler or refactoring actions, not formatting.

> Trace: D25, D29, D87, D238
> Covers: Formatting is not semantic rewriting or refactoring.

If a formatting choice would obscure a language boundary, the boundary wins. Terminators such as `qed;`, `build;`, `fi;`, `od;`, `esac;`, `seal;`, `audit;`, `mon;`, and `drop;` remain visually attached to the construct they close.

> Trace: D9, D25
> Covers: Formatter style preserves Kyokai's visible boundary syntax.

## Formatting Owns Layout Only

[Rikona Kurasaki / Mjoyufull]
The formatter owns layout, not semantics. Its single canonical style removes review disputes about indentation, wrapping, import grouping, and `where`-clause layout while preserving tokens and source meaning under the formatter contract.

> Trace: D25
> Covers: Kyokai formatting removes style noise without touching semantics.

## Import Sorting And Broken-Code Recovery

The default formatter preserves import order. A workspace or package enables sorting with `fmt.sort_imports = true`. Sorting groups imports by standard library, same workspace, external package, and target-gated imports. Within each group, it sorts by canonical package path and imported item name using byte-stable ordering. It preserves comment attachment and never changes visibility, lookup, shadowing, or import meaning.

Formatting parse-invalid source is off by default. A workspace or package enables `fmt.recover_partial = true`; CLI file writes additionally require `--write-partial`. Recovery formats only parser-confirmed subtrees, leaves unknown spans byte-for-byte unchanged, prints every untouched span, and reports that output is not canonical until the file parses successfully. `fmt --check` fails for recovery output.

> Trace: D442-D443, D482
> Covers: Canonical import sorting and opt-in noncanonical parse-error subtree recovery are explicit formatter policies.

## Terminator And Layout Discipline

The formatter canonically aligns each accepted opener with its specific
terminator, expands dense nesting vertically, and applies deterministic line
breaking and indentation. It does not replace terminators, insert braces,
rewrite control flow, extract helpers, or perform another semantic refactor.

`drop;` is formatted and paired only as the terminator of a lexical borrow
scope. Formatter and semantic-highlighting tests cover nested immutable and
mutable borrows, early scope endings, nearby domain cleanup calls, and
monochrome output. The spelling never means destruction.

`kyokai check`, not the formatter, owns excessive-nesting and related quality
lints. The Analysis Server may offer checked helper extraction with the normal
preimage and safety records.

> Trace: D604-D605
> Covers: The non-brace terminator system receives strong visual structure without granting the formatter semantic authority.
