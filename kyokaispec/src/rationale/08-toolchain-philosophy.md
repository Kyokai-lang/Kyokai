# Toolchain Philosophy

[Rikona Kurasaki / Mjoyufull]
> ProofTrace: SPEC-RATIONALE-08-TOOLCHAIN-PHILOSOPHY
> Covers: This chapter is registered in the public ProofTrace evidence graph; registration does not claim implementation, conformance, or theorem completion.

A language specification does not settle what its builds, packages, diagnostics, formatted source, or published artifacts mean. Kyokai specifies those toolchain contracts rather than leaving them to implementation custom.

> Trace: D26, D78, D86, D155
> Covers: The toolchain spec is normative and shares the same public source-of-truth discipline as the language spec.

## One Tool, One Semantic Engine

`kyokai init`, `new`, `build`, `check`, `test`, `fmt`, `doc`, `lsp`, `audit`, `explain`, `fix`, `eval`, `repl`, health commands, and package commands all sit around the same manifest and compiler model. The compiler is the linter. The LSP is not a second opinion with different semantics. Formatting does not rewrite meaning.

> Trace: D25-D29, D148, D222, D266-D268
> Covers: Official tools share the compiler engine and preserve semantic consistency.

Diagnostics are part of the contract. Codes, spans, severity, suggestions, explanation pages, safe fixes, JSON output, ordering, and suppression policy matter because people build editors, CI, tests, and habits around them.

> Trace: D29, D225, D267
> Covers: Diagnostics have stable machine-readable and human-facing behavior.

## Packages And Reproducibility

Kyokai uses manifests, workspaces, lockfiles, pinned Git revisions, exact dependency identity, target specs, and `.koi` artifacts because reproducibility is a language trust problem, not just a build-system feature. If two builds mean the same thing, the inputs that decide that fact should be named.

> Trace: D51, D78-D80, D83, D105, D149, D264-D265
> Covers: Package resolution, target selection, build output layout, and `.koi` compatibility are explicit and reproducible.

The official package index is discovery, not a gatekeeper. It can point to packages, docs, versions, metadata, and advisories, and daily commands can search, explain, graph, and vendor those dependencies, but source revisions and lockfiles remain the reproducible truth.

> Trace: D221, D223-D224, D244, D269
> Covers: The package index does not replace pinned source identity or lockfile meaning.

## Artifacts And Interfaces

`.koi` is the checked interface artifact, not a pretty source dump and not an opaque cache. It records the public and internal interface facts downstream tools need: declarations, types, contracts, docs, unsafe audit metadata, imports, hashes, target identity, and compatibility data.

> Trace: D79, D265
> Covers: `.koi` has a concrete KBI-1 artifact format and compatibility contract.

Build outputs and caches are separate because human-inspectable products and disposable compiler machinery have different purposes. `kyokai-out/` is where selected artifacts live. `.kyokai-cache/` is where the toolchain can remember work without becoming part of source meaning.

> Trace: D144, D264
> Covers: Output/cache layout separates products from disposable incremental state.

## Audit And Release Honesty

`kyokai audit` reports dependency, unsafe, FFI, capability, native library, generated-source, license, reproducibility, and API risk facts. It does not bless a program by magic; it gives the review the map it needs.

> Trace: D150, D218, D245
> Covers: Audit tooling surfaces risk metadata without changing semantics or granting authority.

Releases carry compatibility classifications, checksums, provenance, setup metadata, OCI images where provided, and target support notes. Editions remain separate from package SemVer because source meaning and package version communication are not the same thing.

> Trace: D105, D157, D223, D225
> Covers: Release and compatibility policy distinguishes editions, SemVer, and artifact provenance.

## Tooling That Shows Its Work

[Rikona Kurasaki / Mjoyufull]
Strict languages fail when the tools only say no. Kyokai's compiler, Analysis Server, `explain`, and checked fix lanes expose ownership states, branch joins, cleanup obligations, capability flow, `.koi` facts, generated provenance, target selection, cache identity, and lowered forms. A repair is automatic only when one explicit checked edit is correct. Ambiguous repairs remain visible choices.

The command line follows the same rule. Human output has recognizable lanes. JSON and JSON-lines output carry schema versions. Network actions are explicit. Prompts disappear in machine mode. Generated C, source maps, docs caches, audit reports, and provenance have named artifact homes. The toolchain is not a second language; it is the place where the first language becomes inspectable under pressure.

> Trace: D396, D474, D488, D503-D505, D509, D515-D516, D525
> Covers: CLI, Analysis Server, fixes, generated artifacts, and docs caches expose compiler facts without changing source semantics.
