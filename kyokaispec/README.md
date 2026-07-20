# Kyokai Specification Workspace

This directory is the home of one assembled Kyokai specification. Its source tree separates language semantics, toolchain contracts, standard-library contracts, rationale, and official-project evidence so that their authority is visible without publishing disconnected specifications.

The living development specification is version `0.1.0` and is unreleased.
`spec-version.toml` records its independent specification identity and accepted
D-point cutoff. A released snapshot will replace the working-tree source marker
with exact immutable source and knowledge-manifest identities.

The current extracted Kyokai chapters live under:

| Directory | Role |
| --- | --- |
| `src/language/` | Normative language rules: syntax, types, ownership, evaluation, contracts, capabilities, concurrency, unsafe/FFI, layout, built-ins, and examples. |
| `src/toolchain/` | Normative toolchain rules: manifests, packages, `.koi`, CLI, profiles, diagnostics, formatting, tests, docs, LSP, audit, reproducibility, package index, releases, generation, capability deny policy, migration, foreign adapters, packaging, browser/mobile tooling, and deployment plans. |
| `src/stdlib/` | Normative standard-library contract rules: admission, API contract fields, allocators, containers, text/paths, collections, iterators, math, I/O, concurrency, crypto, transitional FFI tracking, and application/platform integration contracts. |
| `src/rationale/` | Non-normative rationale with attribution. These chapters explain why rules exist; they do not replace the normative chapters. |
| `src/project/` | Official-project governance, clause extraction and traceability, formalization/review evidence, project licensing, admission/change control, and reference workloads. These rules govern Kyokai's own project claims, not the meaning of an independent Kyokai program. |
| `src/appendices/` | Austral lineage and source-material replacement references. |

## Source-Of-Truth Order

1. `kyokaispec/src/language/`, `kyokaispec/src/toolchain/`, and `kyokaispec/src/stdlib/` for their stated conformance surfaces; `kyokaispec/src/project/` for official-project process and evidence claims.
2. `../kyokaidecided.md` for accepted Kyokai shape not yet spec-extracted.
3. `../Kyokaishape.md` as the public temporary holding area and decision/index/archive ledger for D-points without a better canonical PR/MR home.
4. Linked public discussions, issues, and PRs.
5. `../phase.md` for implementation/proof order only.

The old inherited Austral chapter files have been removed from the active build after their Kyokai replacements were extracted. Austral remains source material and lineage, but current Kyokai rules live in the Kyokai chapters listed above. See `src/appendices/c-austral-differences.md` for the replacement map.

## Status

| Area | Status | Notes |
| --- | --- | --- |
| Kyokai spec structure | Extracted through Phase 15 | The chapter families listed above are present and included by the build. |
| Kyokai language spec text | Extracted | `src/language/00-introduction.md` through `src/language/19-examples.md`. |
| Kyokai toolchain spec text | Extracted | `src/toolchain/00-toolchain-overview.md` through `src/toolchain/13-application-integration-and-deployment.md`. |
| Kyokai stdlib contract spec | Extracted | `src/stdlib/00-stdlib-overview.md` through `src/stdlib/12-application-integration-contracts.md`. |
| Rationale rewrite | Extracted | `src/rationale/00-rationale-index.md` through `src/rationale/09-backend-choice.md`. |
| Project contract and evidence | Extracted | `src/project/00-project-boundary.md` through `src/project/06-reference-products-and-workloads.md`. |
| Pre-D558 clause evidence | Checked | `extraction/pre-d558.toml` freezes 573 accepted decisions, including canonical grouped rows and supersession edges; `extraction/pre-d558-review.md` is generated and checked. |
| D558-D625 clause evidence | Checked | `extraction/d558-d625.toml` is the source registry; `extraction/d558-d625-review.md` is generated and checked. |
| D627-D635 clause evidence | Checked | `extraction/d627-d635.toml` is the source registry; `extraction/d627-d635-review.md` is generated and checked. Corpus/provider/registry/release implementation evidence remains separate. |
| Austral source material | Replaced in active spec tree | Replacements are indexed in `src/appendices/c-austral-differences.md`; Borretti's Austral wording is credited when directly used. |
| Compiler/source conformance | Not yet verified as Kyokai implementation | `SPEC_COMPILER_TRACE.md` separates extracted spec text from inherited Austral compiler evidence and implementation gaps. |
| Formal proof | Roadmap extracted; claim status remains evidence-specific | `src/project/03-formalization-roadmap.md` records proof scope and review obligations without turning them into language semantics. |

## Building The Extracted Specification

To verify the source list used by the build:

```bash
make check-sources
```

From the repository root, contributors and CI run the complete focused
specification-integrity lane with:

```bash
make check-spec-integrity
```

The author performs extraction by writing the clauses and evidence records.
The Git check verifies those records and rejects stale generated views; it does
not accept decisions, supply missing semantics, or replace reviewer judgment.

`check-sources` also verifies that the pre-D558, D558-D625, and D627-D635
clause registries and generated review sheets are current. To run that check directly from this
directory:

```bash
make check-clause-extraction
```

To generate the default HTML output from the extracted Kyokai chapter tree:

```bash
make
```

To build both HTML and PDF, install a Pandoc-supported PDF engine such as `pdflatex` and run:

```bash
make all
```

To build only the PDF, use:

```bash
make pdf
```

If your PDF engine is not `pdflatex`, pass it explicitly:

```bash
make pdf PDF_ENGINE=xelatex
```

To remove generated output:

```bash
make clean
```

The generated `spec.pdf` and `spec.html` are build products. The source-of-truth text remains the Markdown files under `src/`.

## License

The specification prose keeps the GNU Free Documentation License 1.3-or-later documentation license from the inherited spec tree, with no Invariant Sections, no Front-Cover Texts, and no Back-Cover Texts. See `COPYING`, `src/appendix-a.md`, and `src/project/04-project-licensing.md`.

This documentation license is separate from the Kyokai code license boundary recorded in `../kyokaidecided.md` and `src/project/04-project-licensing.md`.
