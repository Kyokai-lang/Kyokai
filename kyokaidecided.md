# Kyokai Decided Shape

**Kyokai** (境界, "boundary") — a systems programming language forked from Austral.

Linear types enforcing boundaries on resource ownership. Every resource explicitly created, explicitly used, explicitly destroyed. Nothing hidden. Nothing implicit. Nothing undefined.

This document is the public readable extraction of the shape Kyokai has already accepted. It is not the full normative spec. The eventual normative home is `kyokaispec/`; new public D-points normally live in PRs/MRs, with `Kyokaishape.md` serving as index/archive or temporary proposal storage.

---

## Table of Contents

0. [Maturity State Tracker](#maturity-state-tracker)
1. [Austral As It Stands](#1-austral-as-it-stands)
  - 1.1–1.5: Core Language, Compiler, Stdlib, Unfinished Work, Pain Points
  - 1.6: [Syntax Crimes Catalog](#16-syntax-crimes-catalog--the-full-evidence)
2. [What's Missing — The Full Gap Analysis](#2-whats-missing--the-full-gap-analysis)
3. [The Kyokai Philosophy](#3-the-kyokai-philosophy)
  - 3.1–3.3: Unbreakable Rules, Kyokai Additions, Changes from Austral
  - 3.4: [Readability Research — What Science Says](#34-readability-research--what-science-says)
  - 3.5: [Naming Convention Principles](#35-naming-convention-principles)
4. [Work Items — Prioritized by Hardness and Severity](#4-work-items--prioritized-by-hardness-and-severity)

For active public proposals and new D-points, see the relevant PR/MR; `Kyokaishape.md` is the index/archive when a point is not directly carried by a PR/MR.

## Maturity State Tracker

This tracker records how far accepted Kyokai shape has moved toward normative spec text, conformance tests, and implementation. It is not a roadmap and it does not reopen decided semantics. `phase.md` remains the implementation/proof ordering document.

Use the highest honest state that is currently true:

| State | Meaning | Evidence To Record Here |
| --- | --- | --- |
| `SHAPE_DECIDED` | The design point is decided in public accepted-shape docs. | D-point IDs, accepted-shape section, and any public thread/PR link if applicable. |
| `SPEC_EXTRACTED` | The rule has a normative home in the specification. | `kyokaispec/` path and short note on the covered rule scope. |
| `CALCULUS_DRAFTED` | The behavior is represented in `lambda_K` scope or explicitly excluded from it. | Calculus document path and whether the feature is included or explicitly out of scope. |
| `CALCULUS_PROVEN_PAPER` | The sequential core proof obligation is discharged at paper level. | Proof document path and theorem/scope name. |
| `PARSER_ACCEPTED` | Surface syntax is parsed into AST nodes with source spans. | Parser implementation path and positive/negative parser test path. |
| `ELABORATED_CORE` | Surface constructs lower through the D238 ordered pipeline. | Elaboration/lowering pass path and tests showing implicit completions/sugar exposure. |
| `CHECKED` | Name, type, borrow, linearity, capability, contract, and unsafe checks enforce the spec. | Checker implementation path and negative diagnostic/conformance test path. |
| `LOWERED_SAFE` | Backend output implements the checked semantics without backend UB. | Backend/runtime path plus UB-sensitive generated-code/runtime tests. |
| `CONFORMANCE_BACKED` | Behavior has executable tests and diagnostic goldens. | Conformance test path and diagnostic golden path if relevant. |
| `STDLIB_ADMITTED` | A stdlib API has its contract, edge cases, tests, and implementation policy. | Stdlib module path, admission/contract note, and edge-case test path. |
| `BOOTSTRAP_RELEASED` | The OCaml/Austral-derived compiler can compile practical Kyokai programs. | Release/build artifact path and workload/test path. |
| `SELF_HOSTING` | Important compiler components are written in Kyokai and built by Kyokai. | Self-hosting component path and bootstrap build instructions/test path. |
| `MECHANIZED_PROVEN` | The relevant core theorem is machine-checked. | Proof assistant artifact path and CI/build command. |

Current high-level tracker:

| Area | Key decisions | Current maturity | Spec home | Conformance | Implementation | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| Project identity, philosophy, and license boundary | D1, D5, D87, D143/D241, D263 | `SPEC_EXTRACTED` | `kyokaispec/src/language/00-introduction.md`, `kyokaispec/src/language/01-goals-and-non-goals.md`, `kyokaispec/src/rationale/00-rationale-index.md`, `kyokaispec/src/rationale/01-language-design.md`, `kyokaispec/src/appendices/a-license.md`, `kyokaispec/src/appendices/c-austral-differences.md`, and `kyokaispec/src/appendices/d-formalization-roadmap.md` for identity, self-contained fork scope, no-language-UB policy, inherited goals, attribution, rationale boundaries, license/provenance, Austral-difference indexing, inherited-file retirement status, and proof-roadmap scope | planned | partial docs/tooling metadata | Rationale and appendix extraction is present; implementation/proof maturity still requires conformance tests and the actual `lambda_K` paper proof. |
| Core syntax and declarations | D8-D18, D23-D24, D35-D43, D46, D47, D50, D54-D59, D61, D71-D72, D75-D76, D78, D98, D106, D109, D128, D135/D261, D138, D179, D205-D206, D210, D213-D214 | `SPEC_EXTRACTED` | `kyokaispec/src/language/02-lexical-syntax.md`, `kyokaispec/src/language/03-grammar.md`, `kyokaispec/src/language/04-modules-and-visibility.md`, `kyokaispec/src/language/05-declarations.md`, `kyokaispec/src/language/08-patterns.md`, `kyokaispec/src/language/09-expressions-and-evaluation.md`, `kyokaispec/src/language/10-statements-and-control-flow.md`, `kyokaispec/src/language/11-linearity-borrowing-and-regions.md`, `kyokaispec/src/language/18-built-ins.md`, `kyokaispec/src/language/19-examples.md` for lexical, grammar, module/import/visibility, declarations, patterns, expressions, evaluation, statements, control-flow, ownership-visible pattern/control-flow joins, protected built-ins, and current syntax examples | planned | inherited Austral parser only | Unsafe and broader toolchain contracts are extracted in their owning chapters. |
| Type system, ownership, borrows, and implicit completions | D6, D7a/D7b, D14, D24, D30/D30a, D34, D46, D72, D87, D104, D159, D188, D190, D192-D195, D213, D238-D240 | `SPEC_EXTRACTED` | `kyokaispec/src/language/06-type-system.md`, `kyokaispec/src/language/07-generics-and-typeclasses.md`, `kyokaispec/src/language/08-patterns.md`, `kyokaispec/src/language/09-expressions-and-evaluation.md`, `kyokaispec/src/language/11-linearity-borrowing-and-regions.md`, `kyokaispec/src/language/12-implicit-completions-and-elaboration.md`, `kyokaispec/src/language/18-built-ins.md`, `kyokaispec/src/language/19-examples.md` for universes, nominal identity, generics, typeclasses, inference, pattern movement, temporaries, checker states, regions, borrows, movement, built-in type families, and example applications | planned | inherited Austral checker only | Implementation still needs conformance tests and compiler work before checker maturity can move beyond spec extraction. |
| Closed-graph tautology and package coherence clarifications | D278-D279 | `SPEC_EXTRACTED` | `kyokaispec/src/language/07-generics-and-typeclasses.md`, `kyokaispec/src/language/12-implicit-completions-and-elaboration.md`, `kyokaispec/src/toolchain/02-module-resolution-and-koi.md` | planned | planned | Normative spec destinations are present; implementation and conformance remain planned. |
| Error handling, contracts, defer, panic/TPOE | D2, D2a/D2b, D15/D15a, D24, D53, D58, D84, D89, D111, D119, D121-D122, D124-D125, D129, D140, D142, D207, D233, D246, D253, D259-D260 | `SPEC_EXTRACTED` | `kyokaispec/src/language/03-grammar.md`, `kyokaispec/src/language/05-declarations.md`, `kyokaispec/src/language/08-patterns.md`, `kyokaispec/src/language/10-statements-and-control-flow.md`, `kyokaispec/src/language/11-linearity-borrowing-and-regions.md`, `kyokaispec/src/language/12-implicit-completions-and-elaboration.md`, `kyokaispec/src/language/13-contracts-and-runtime-failure.md`, `kyokaispec/src/language/18-built-ins.md`, `kyokaispec/src/language/19-examples.md` for contract syntax, function contract declaration placement, result/old scoping, fallible patterns, `Result`/`Optional` built-ins, `or` lowering, defer/errdefer path behavior, deferred checker states, panic/todo/unreachable behavior, TPOE, runtime-fatal, diagnostics, and examples | planned | inherited Austral behavior only | Implementation still needs conformance tests and runtime/compiler work before maturity can move beyond spec extraction. |
| Capabilities and authority | D20/D20a/D20b, D48/D162, D67, D85, D211-D212, D245, D248, D255-D256 | `SPEC_EXTRACTED` | `kyokaispec/src/language/04-modules-and-visibility.md`, `kyokaispec/src/language/05-declarations.md`, `kyokaispec/src/language/06-type-system.md`, `kyokaispec/src/language/14-capabilities-and-authority.md`, `kyokaispec/src/language/18-built-ins.md`, `kyokaispec/src/language/19-examples.md` for sealed capability declarations, root authority, acquire/derive/split/surrender, borrowing, task transfer, unsafe authority, FFI authority flow, tests/tools/plugins, dynamic loading, raw I/O broker patterns, startup built-ins, and capability examples | planned | inherited Austral capability shape only | Standard-library authority APIs and toolchain audit surfaces are extracted in their owning chapters. |
| FFI, unsafe, ABI, layout, and backend safety | D20/D242/D242a, D31, D42, D73, D80, D89, D113a/D113b, D139, D199, D228, D245, D250-D251, D257 | `SPEC_EXTRACTED` | `kyokaispec/src/language/05-declarations.md`, `kyokaispec/src/language/06-type-system.md`, `kyokaispec/src/language/09-expressions-and-evaluation.md`, `kyokaispec/src/language/11-linearity-borrowing-and-regions.md`, `kyokaispec/src/language/12-implicit-completions-and-elaboration.md`, `kyokaispec/src/language/13-contracts-and-runtime-failure.md`, `kyokaispec/src/language/14-capabilities-and-authority.md`, `kyokaispec/src/language/16-unsafe-ffi-and-abi.md`, `kyokaispec/src/language/17-memory-layout-and-backend-contract.md` for unsafe modules, unsafe contracts, raw FFI, explicit C ABI surface, callbacks, unwinding, dynamic loading/plugins, volatile/MMIO, inline assembly, layout classes, move/result placement, generated-C safety, LLVM lowering, debug/source mapping, and backend failure rules | planned | inherited C backend only | Implementation still needs safe Kyokai boundary wrappers, full ABI/backend tests, and UB-closure generated-code tests before maturity can move beyond spec extraction. |
| Concurrency, atomics, channels, poller, and signals | D3, D3a/D3b, D90-D95, D100-D101, D141, D146, D156, D164, D168, D183-D184, D212, D234-D237, D247-D248, D252, D256, D258 | `SPEC_EXTRACTED` | `kyokaispec/src/language/03-grammar.md`, `kyokaispec/src/language/11-linearity-borrowing-and-regions.md`, `kyokaispec/src/language/14-capabilities-and-authority.md`, `kyokaispec/src/language/15-concurrency.md`, `kyokaispec/src/language/18-built-ins.md`, `kyokaispec/src/language/19-examples.md` for task groups, spawn/capture/failure, SPSC channels, select, cancellation/deadlines, poller/event loops, signals, atomics, locks, task transfer, broker patterns, happens-before, recognized concurrency built-ins, and spawn examples | planned | planned | Implementation still needs conformance tests, runtime primitives, and backend atomic validation before maturity can move beyond spec extraction. |
| Standard library foundation and admission policy | D40, D40a, D44, D64, D67, D74, D77, D85, D102, D117, D146, D152, D171, D201, D220, D229-D232, D250-D251, D259-D260, D263 | `SPEC_EXTRACTED` | `kyokaispec/src/stdlib/00-stdlib-overview.md`, `kyokaispec/src/stdlib/01-admission-contracts.md`, `kyokaispec/src/stdlib/02-core-result-optional-display-error.md`, `kyokaispec/src/stdlib/03-allocators-and-memory-containers.md`, `kyokaispec/src/stdlib/04-text-bytes-paths-and-strings.md`, `kyokaispec/src/stdlib/05-collections.md`, `kyokaispec/src/stdlib/06-iterators-and-generators.md`, `kyokaispec/src/stdlib/07-math-and-numerics.md`, `kyokaispec/src/stdlib/08-io-files-env-process-time-random.md`, `kyokaispec/src/stdlib/09-concurrency-primitives.md`, `kyokaispec/src/stdlib/10-crypto-policy.md`, and `kyokaispec/src/stdlib/11-transitional-ffi-tracking.md` for stdlib admission, contract fields, pure-Kyokai implementation policy, transitional FFI tracking, allocators, containers, text/bytes/paths, collections, iterators/generators, numerics/math accuracy, capability-gated external-world APIs, concurrency primitives, crypto policy, and core formatting/error protocols; language chapters remain the syntax and built-in source for the same rules | planned | inherited Austral stdlib only | Implementation still needs admitted Kyokai stdlib modules, conformance tests, audit metadata, and transitional FFI records before maturity can move beyond spec extraction. |
| Concurrency and linear-stdlib critique cluster | D280-D290 | `SPEC_EXTRACTED` | `kyokaispec/src/language/07-generics-and-typeclasses.md`, `kyokaispec/src/language/08-patterns.md`, `kyokaispec/src/language/10-statements-and-control-flow.md`, `kyokaispec/src/language/11-linearity-borrowing-and-regions.md`, `kyokaispec/src/language/13-contracts-and-runtime-failure.md`, `kyokaispec/src/language/15-concurrency.md`, `kyokaispec/src/stdlib/05-collections.md`, `kyokaispec/src/stdlib/06-iterators-and-generators.md`, and stdlib admission docs | planned | planned | Normative spec destinations are present; implementation and conformance remain planned. |
| Usability, comptime, platform, FFI, and pinning critique cluster | D291-D301 | `SPEC_EXTRACTED` | `kyokaispec/src/language/05-declarations.md`, `kyokaispec/src/language/06-type-system.md`, `kyokaispec/src/language/13-contracts-and-runtime-failure.md`, `kyokaispec/src/language/16-unsafe-ffi-and-abi.md`, `kyokaispec/src/language/17-memory-layout-and-backend-contract.md`, `kyokaispec/src/language/18-built-ins.md`, `kyokaispec/src/toolchain/04-build-profiles-targets-linking.md`, `kyokaispec/src/toolchain/05-diagnostics.md`, `kyokaispec/src/toolchain/11-build-generation-and-playground.md`, `kyokaispec/src/stdlib/00-stdlib-overview.md`, `kyokaispec/src/stdlib/03-allocators-and-memory-containers.md`, `kyokaispec/src/stdlib/07-math-and-numerics.md`, and target/stdlib admission docs | planned | planned | Normative spec destinations are present; implementation and conformance remain planned. |
| Observability, analysis tooling, testing workflow, stdlib tiers, licensing boundary, public decision workflow, performance/cache identity, RIIK audit, capability attenuation, and KBI diffing | D302-D311 | `SPEC_EXTRACTED` | `kyokaispec/src/language/14-capabilities-and-authority.md`, `kyokaispec/src/toolchain/01-manifest-package-workspace.md`, `kyokaispec/src/toolchain/02-module-resolution-and-koi.md`, `kyokaispec/src/toolchain/04-build-profiles-targets-linking.md`, `kyokaispec/src/toolchain/05-diagnostics.md`, `kyokaispec/src/toolchain/07-testing-coverage-bench.md`, `kyokaispec/src/toolchain/08-docs-lsp-audit.md`, `kyokaispec/src/toolchain/09-reproducibility-incremental-builds.md`, `kyokaispec/src/toolchain/10-package-index-semver-releases-ci.md`, `kyokaispec/src/stdlib/00-stdlib-overview.md`, `kyokaispec/src/stdlib/01-admission-contracts.md`, `kyokaispec/src/stdlib/07-math-and-numerics.md`, `kyokaispec/src/stdlib/08-io-files-env-process-time-random.md`, `kyokaispec/src/stdlib/10-crypto-policy.md`, `kyokaispec/src/appendices/a-license.md`, `kyokaispec/src/appendices/b-decision-traceability.md`, `PROJECT_STANDARDS.md`, `Kyokaishape.md`, and `phase.md` | planned | planned | Normative spec destinations are present; implementation and conformance remain planned. |
| Proof-claim honesty, syntax/file-model closure, adoption docs, daily debug/span/docs rules, lock semantics, generic edge rules, proof-tooling boundary, CLI extensions, and target contract schema | D312-D313, D315-D321 | `SPEC_EXTRACTED` | `kyokaispec/src/language/01-goals-and-non-goals.md`, `kyokaispec/src/language/02-lexical-syntax.md`, `kyokaispec/src/language/03-grammar.md`, `kyokaispec/src/language/04-modules-and-visibility.md`, `kyokaispec/src/language/06-type-system.md`, `kyokaispec/src/language/07-generics-and-typeclasses.md`, `kyokaispec/src/language/11-linearity-borrowing-and-regions.md`, `kyokaispec/src/language/13-contracts-and-runtime-failure.md`, `kyokaispec/src/language/15-concurrency.md`, `kyokaispec/src/language/16-unsafe-ffi-and-abi.md`, `kyokaispec/src/language/18-built-ins.md`, `kyokaispec/src/toolchain/01-manifest-package-workspace.md`, `kyokaispec/src/toolchain/03-cli.md`, `kyokaispec/src/toolchain/04-build-profiles-targets-linking.md`, `kyokaispec/src/toolchain/08-docs-lsp-audit.md`, `kyokaispec/src/toolchain/10-package-index-semver-releases-ci.md`, `kyokaispec/src/stdlib/02-core-result-optional-display-error.md`, `kyokaispec/src/stdlib/04-text-bytes-paths-and-strings.md`, `kyokaispec/src/stdlib/09-concurrency-primitives.md`, `kyokaispec/src/appendices/d-formalization-roadmap.md`, `kyokailang/kyokai/kyokaicalculus/lambda_k_research.md`, and docs/examples | planned | planned | Normative spec destinations are present; implementation and conformance remain planned. |
| Granular critique closure: unsafe grammar, bit records, arenas, test generation, TLS, cancellation, backtraces, ABI, formatting, beginner scaffolds, workspace discovery, external diagnostics, embed builtins, builtin formatting identity, UFCS receiver exports, `Auto`, `Never`, and pattern legality | D322-D340 | `SPEC_EXTRACTED` | `kyokaispec/src/language/02-lexical-syntax.md`, `kyokaispec/src/language/03-grammar.md`, `kyokaispec/src/language/04-modules-and-visibility.md`, `kyokaispec/src/language/05-declarations.md`, `kyokaispec/src/language/06-type-system.md`, `kyokaispec/src/language/07-generics-and-typeclasses.md`, `kyokaispec/src/language/08-patterns.md`, `kyokaispec/src/language/09-expressions-and-evaluation.md`, `kyokaispec/src/language/10-statements-and-control-flow.md`, `kyokaispec/src/language/11-linearity-borrowing-and-regions.md`, `kyokaispec/src/language/13-contracts-and-runtime-failure.md`, `kyokaispec/src/language/14-capabilities-and-authority.md`, `kyokaispec/src/language/15-concurrency.md`, `kyokaispec/src/language/16-unsafe-ffi-and-abi.md`, `kyokaispec/src/language/17-memory-layout-and-backend-contract.md`, `kyokaispec/src/language/18-built-ins.md`, `kyokaispec/src/language/19-examples.md`, `kyokaispec/src/toolchain/01-manifest-package-workspace.md`, `kyokaispec/src/toolchain/02-module-resolution-and-koi.md`, `kyokaispec/src/toolchain/03-cli.md`, `kyokaispec/src/toolchain/05-diagnostics.md`, `kyokaispec/src/toolchain/07-testing-coverage-bench.md`, `kyokaispec/src/toolchain/08-docs-lsp-audit.md`, `kyokaispec/src/toolchain/11-build-generation-and-playground.md`, `kyokaispec/src/stdlib/01-admission-contracts.md`, `kyokaispec/src/stdlib/02-core-result-optional-display-error.md`, `kyokaispec/src/stdlib/03-allocators-and-memory-containers.md`, `kyokaispec/src/stdlib/08-io-files-env-process-time-random.md`, and `kyokaispec/src/stdlib/09-concurrency-primitives.md` | planned | planned | Normative spec destinations are present; implementation and conformance remain planned. |
| Second granular critique closure: range loops, split readiness waiting, runtime fatal surface, spans/dynamic loading, freestanding targets, compiler-owned capabilities, Result combinators, borrow checker tables, expected-type flow, callbacks, generation/audit schema, formatter, channels, memory model, safe unreachable, implicit completions, containers, TPOE taxonomy, comptime, typeclass coherence, generators, rendering, allocation failure, `.koi`/KBI schema, and arithmetic | D341-D365 | `SPEC_EXTRACTED` | `kyokaispec/src/language/05-declarations.md`, `kyokaispec/src/language/06-type-system.md`, `kyokaispec/src/language/07-generics-and-typeclasses.md`, `kyokaispec/src/language/08-patterns.md`, `kyokaispec/src/language/09-expressions-and-evaluation.md`, `kyokaispec/src/language/10-statements-and-control-flow.md`, `kyokaispec/src/language/11-linearity-borrowing-and-regions.md`, `kyokaispec/src/language/12-implicit-completions-and-elaboration.md`, `kyokaispec/src/language/13-contracts-and-runtime-failure.md`, `kyokaispec/src/language/14-capabilities-and-authority.md`, `kyokaispec/src/language/15-concurrency.md`, `kyokaispec/src/language/16-unsafe-ffi-and-abi.md`, `kyokaispec/src/language/17-memory-layout-and-backend-contract.md`, `kyokaispec/src/language/18-built-ins.md`, `kyokaispec/src/toolchain/01-manifest-package-workspace.md`, `kyokaispec/src/toolchain/02-module-resolution-and-koi.md`, `kyokaispec/src/toolchain/03-cli.md`, `kyokaispec/src/toolchain/04-build-profiles-targets-linking.md`, `kyokaispec/src/toolchain/05-diagnostics.md`, `kyokaispec/src/toolchain/06-formatter.md`, `kyokaispec/src/toolchain/08-docs-lsp-audit.md`, `kyokaispec/src/toolchain/09-reproducibility-incremental-builds.md`, `kyokaispec/src/toolchain/11-build-generation-and-playground.md`, `kyokaispec/src/stdlib/01-admission-contracts.md`, `kyokaispec/src/stdlib/02-core-result-optional-display-error.md`, `kyokaispec/src/stdlib/03-allocators-and-memory-containers.md`, `kyokaispec/src/stdlib/04-text-bytes-paths-and-strings.md`, `kyokaispec/src/stdlib/05-collections.md`, `kyokaispec/src/stdlib/06-iterators-and-generators.md`, `kyokaispec/src/stdlib/07-math-and-numerics.md`, `kyokaispec/src/stdlib/08-io-files-env-process-time-random.md`, and `kyokaispec/src/stdlib/09-concurrency-primitives.md` | planned | planned | Normative spec destinations are present; implementation and conformance remain planned. |
| External systems-language critique closure: maturity honesty, doc-comment strictness, terminator reaffirmation, named modulo APIs, literal ambiguity rejection, static text and text views, nominal return values, generational handles, universe reaffirmation, typeclass admission, borrow-model reaffirmation, defer diagnostics, propagation linting, failure hooks, capability bundles, module split reaffirmation, vendor-first package discipline, allocator-context rejection, collection syntax reaffirmation, UFCS reaffirmation, iterator-first generators, structured taskgroups, unsafe audit reaffirmation, file build constraints, essential CLI path, stdlib first slice, layout fact builtins, proof-scope reaffirmation, and license-boundary reaffirmation | D366-D395 | `SPEC_EXTRACTED` | `kyokaispec/src/language/01-goals-and-non-goals.md`, `kyokaispec/src/language/02-lexical-syntax.md`, `kyokaispec/src/language/03-grammar.md`, `kyokaispec/src/language/04-modules-and-visibility.md`, `kyokaispec/src/language/05-declarations.md`, `kyokaispec/src/language/06-type-system.md`, `kyokaispec/src/language/07-generics-and-typeclasses.md`, `kyokaispec/src/language/09-expressions-and-evaluation.md`, `kyokaispec/src/language/10-statements-and-control-flow.md`, `kyokaispec/src/language/11-linearity-borrowing-and-regions.md`, `kyokaispec/src/language/13-contracts-and-runtime-failure.md`, `kyokaispec/src/language/14-capabilities-and-authority.md`, `kyokaispec/src/language/15-concurrency.md`, `kyokaispec/src/language/16-unsafe-ffi-and-abi.md`, `kyokaispec/src/language/17-memory-layout-and-backend-contract.md`, `kyokaispec/src/language/18-built-ins.md`, `kyokaispec/src/toolchain/01-manifest-package-workspace.md`, `kyokaispec/src/toolchain/02-module-resolution-and-koi.md`, `kyokaispec/src/toolchain/03-cli.md`, `kyokaispec/src/toolchain/04-build-profiles-targets-linking.md`, `kyokaispec/src/toolchain/05-diagnostics.md`, `kyokaispec/src/toolchain/09-reproducibility-incremental-builds.md`, `kyokaispec/src/toolchain/10-package-index-semver-releases-ci.md`, `kyokaispec/src/toolchain/11-build-generation-and-playground.md`, `kyokaispec/src/stdlib/00-stdlib-overview.md`, `kyokaispec/src/stdlib/01-admission-contracts.md`, `kyokaispec/src/stdlib/03-allocators-and-memory-containers.md`, `kyokaispec/src/stdlib/04-text-bytes-paths-and-strings.md`, `kyokaispec/src/stdlib/05-collections.md`, `kyokaispec/src/stdlib/06-iterators-and-generators.md`, `kyokaispec/src/stdlib/07-math-and-numerics.md`, `kyokaispec/src/stdlib/08-io-files-env-process-time-random.md`, `kyokaispec/src/stdlib/09-concurrency-primitives.md`, `kyokaispec/src/appendices/a-license.md`, and `kyokaispec/src/appendices/d-formalization-roadmap.md` | planned | planned | Normative spec destinations are present; implementation and conformance remain planned. |
| Toolchain, package manager, diagnostics, formatter, docs, releases | D25-D29, D31, D51, D78-D80, D83, D86, D105, D137, D144, D148-D151a, D155, D157, D200, D218, D220-D226, D243-D245, D264-D270 | `SPEC_EXTRACTED` | `kyokaispec/src/toolchain/00-toolchain-overview.md`, `kyokaispec/src/toolchain/01-manifest-package-workspace.md`, `kyokaispec/src/toolchain/02-module-resolution-and-koi.md`, `kyokaispec/src/toolchain/03-cli.md`, `kyokaispec/src/toolchain/04-build-profiles-targets-linking.md`, `kyokaispec/src/toolchain/05-diagnostics.md`, `kyokaispec/src/toolchain/06-formatter.md`, `kyokaispec/src/toolchain/07-testing-coverage-bench.md`, `kyokaispec/src/toolchain/08-docs-lsp-audit.md`, `kyokaispec/src/toolchain/09-reproducibility-incremental-builds.md`, `kyokaispec/src/toolchain/10-package-index-semver-releases-ci.md`, `kyokaispec/src/toolchain/11-build-generation-and-playground.md` for CLI, project shape, artifacts, diagnostics, formatting, tests, docs, LSP, audit, reproducibility, package ecosystem, releases, generation, REPL/eval, playground contracts, build output/cache layout, concrete `.koi` artifact format, project creation, diagnostic explanation/fixing, toolchain health, package inspection/offline workflows, and property/fuzz daily-use controls | planned | inherited Austral CLI only | Implementation still needs compiler/package-manager/tooling work and conformance tests before maturity can move beyond spec extraction. |
| Toolchain privacy, feature instances, startup authority, paths, floats, hashing, OS errors, clocks, fatal redaction, native toolchains, generated-source provenance, executable examples, Unicode algorithms, env/args, atomic file updates, networking, test isolation, codecs, diagnostics, allocation-failure testing, behavior SemVer, process status, CPU dispatch, and package naming | D396-D419 | `SPEC_EXTRACTED` | `kyokaispec/src/language/02-lexical-syntax.md`, `kyokaispec/src/language/13-contracts-and-runtime-failure.md`, `kyokaispec/src/language/14-capabilities-and-authority.md`, `kyokaispec/src/language/16-unsafe-ffi-and-abi.md`, `kyokaispec/src/language/17-memory-layout-and-backend-contract.md`, `kyokaispec/src/language/18-built-ins.md`, `kyokaispec/src/language/19-examples.md`, `kyokaispec/src/toolchain/01-manifest-package-workspace.md`, `kyokaispec/src/toolchain/02-module-resolution-and-koi.md`, `kyokaispec/src/toolchain/03-cli.md`, `kyokaispec/src/toolchain/04-build-profiles-targets-linking.md`, `kyokaispec/src/toolchain/05-diagnostics.md`, `kyokaispec/src/toolchain/07-testing-coverage-bench.md`, `kyokaispec/src/toolchain/08-docs-lsp-audit.md`, `kyokaispec/src/toolchain/09-reproducibility-incremental-builds.md`, `kyokaispec/src/toolchain/10-package-index-semver-releases-ci.md`, `kyokaispec/src/toolchain/11-build-generation-and-playground.md`, `kyokaispec/src/stdlib/01-admission-contracts.md`, `kyokaispec/src/stdlib/02-core-result-optional-display-error.md`, `kyokaispec/src/stdlib/03-allocators-and-memory-containers.md`, `kyokaispec/src/stdlib/04-text-bytes-paths-and-strings.md`, `kyokaispec/src/stdlib/05-collections.md`, `kyokaispec/src/stdlib/07-math-and-numerics.md`, `kyokaispec/src/stdlib/08-io-files-env-process-time-random.md`, `kyokaispec/src/stdlib/09-concurrency-primitives.md`, and `kyokaispec/src/stdlib/10-crypto-policy.md` | planned | planned | Normative spec destinations are present; implementation and conformance remain planned. |
| Source encoding, randomness, terminal services, package artifacts, lockfiles, bleedring toolchain management, scratch execution, docs metadata, deprecation, caches, bindgen, and advisories | D420-D431 | `SPEC_EXTRACTED` | `kyokaispec/src/language/02-lexical-syntax.md`, `kyokaispec/src/language/14-capabilities-and-authority.md`, `kyokaispec/src/language/16-unsafe-ffi-and-abi.md`, `kyokaispec/src/language/19-examples.md`, `kyokaispec/src/toolchain/01-manifest-package-workspace.md`, `kyokaispec/src/toolchain/03-cli.md`, `kyokaispec/src/toolchain/04-build-profiles-targets-linking.md`, `kyokaispec/src/toolchain/05-diagnostics.md`, `kyokaispec/src/toolchain/08-docs-lsp-audit.md`, `kyokaispec/src/toolchain/09-reproducibility-incremental-builds.md`, `kyokaispec/src/toolchain/10-package-index-semver-releases-ci.md`, `kyokaispec/src/toolchain/11-build-generation-and-playground.md`, `kyokaispec/src/stdlib/04-text-bytes-paths-and-strings.md`, `kyokaispec/src/stdlib/08-io-files-env-process-time-random.md`, and `kyokaispec/src/stdlib/10-crypto-policy.md` | planned | planned | Normative spec destinations are present; implementation and conformance remain planned. |
| Integrated FFI/toolchain/concurrency/safety contracts: non-C ABI tables, import/package cycle bans, fixtures, SPSC broker discipline, multi-binary targets, edition-specific `.koi`, loop filtering rejection, C export wrappers, signal handlers, formatter recovery/localization, loader policy, compressed `.koi` transport, lock fairness, spawn-shareable registry, bench/property reports, LSP refactor safety, volatile/MMIO domain, failure taxonomy, inline asm, partial-error state, callback/TLS FFI, borrow/reborrow tables, unsafe instances, package provenance, authority ceilings, generational handles, embedded fatal hardware contracts, and generator sandboxing | D432-D465 | `SPEC_EXTRACTED` | `kyokaispec/src/language/04-modules-and-visibility.md`, `kyokaispec/src/language/06-type-system.md`, `kyokaispec/src/language/07-generics-and-typeclasses.md`, `kyokaispec/src/language/08-patterns.md`, `kyokaispec/src/language/10-statements-and-control-flow.md`, `kyokaispec/src/language/11-linearity-borrowing-and-regions.md`, `kyokaispec/src/language/12-implicit-completions-and-elaboration.md`, `kyokaispec/src/language/13-contracts-and-runtime-failure.md`, `kyokaispec/src/language/14-capabilities-and-authority.md`, `kyokaispec/src/language/15-concurrency.md`, `kyokaispec/src/language/16-unsafe-ffi-and-abi.md`, `kyokaispec/src/language/17-memory-layout-and-backend-contract.md`, `kyokaispec/src/toolchain/01-manifest-package-workspace.md`, `kyokaispec/src/toolchain/02-module-resolution-and-koi.md`, `kyokaispec/src/toolchain/03-cli.md`, `kyokaispec/src/toolchain/04-build-profiles-targets-linking.md`, `kyokaispec/src/toolchain/05-diagnostics.md`, `kyokaispec/src/toolchain/06-formatter.md`, `kyokaispec/src/toolchain/07-testing-coverage-bench.md`, `kyokaispec/src/toolchain/08-docs-lsp-audit.md`, `kyokaispec/src/toolchain/09-reproducibility-incremental-builds.md`, `kyokaispec/src/toolchain/10-package-index-semver-releases-ci.md`, `kyokaispec/src/toolchain/11-build-generation-and-playground.md`, `kyokaispec/src/stdlib/01-admission-contracts.md`, `kyokaispec/src/stdlib/02-core-result-optional-display-error.md`, `kyokaispec/src/stdlib/03-allocators-and-memory-containers.md`, `kyokaispec/src/stdlib/08-io-files-env-process-time-random.md`, and `kyokaispec/src/stdlib/09-concurrency-primitives.md` | planned | planned | Normative spec destinations are present; implementation and conformance remain planned. |
| Validated wrappers, compile-time configuration errors, task-transfer packaging rejection, parameter access syntax reaffirmation, conditional typeclass instances, channel backpressure, nested defer failure, poller/protocol state, compiler explain modes, hot reload tooling contract, string literal allocation, claim tiers, and public-doc slogan cleanup | D466-D478 | `SPEC_EXTRACTED` | `kyokaispec/src/language/01-goals-and-non-goals.md`, `kyokaispec/src/language/02-lexical-syntax.md`, `kyokaispec/src/language/05-declarations.md`, `kyokaispec/src/language/06-type-system.md`, `kyokaispec/src/language/07-generics-and-typeclasses.md`, `kyokaispec/src/language/09-expressions-and-evaluation.md`, `kyokaispec/src/language/10-statements-and-control-flow.md`, `kyokaispec/src/language/11-linearity-borrowing-and-regions.md`, `kyokaispec/src/language/13-contracts-and-runtime-failure.md`, `kyokaispec/src/language/15-concurrency.md`, `kyokaispec/src/language/16-unsafe-ffi-and-abi.md`, `kyokaispec/src/language/18-built-ins.md`, `kyokaispec/src/toolchain/03-cli.md`, `kyokaispec/src/toolchain/04-build-profiles-targets-linking.md`, `kyokaispec/src/toolchain/05-diagnostics.md`, `kyokaispec/src/toolchain/08-docs-lsp-audit.md`, `kyokaispec/src/toolchain/11-build-generation-and-playground.md`, `kyokaispec/src/stdlib/02-core-result-optional-display-error.md`, `kyokaispec/src/stdlib/04-text-bytes-paths-and-strings.md`, `kyokaispec/src/stdlib/08-io-files-env-process-time-random.md`, `kyokaispec/src/stdlib/09-concurrency-primitives.md`, `kyokaispec/src/appendices/b-decision-traceability.md`, and `kyokaispec/src/appendices/d-formalization-roadmap.md` | planned | planned | Normative spec destinations are present; implementation and conformance remain planned. |
| Modal wording, implementation-choice boundaries, full implementation conformance, proposal/search labels, policy selection, target-contract variation, specified nondeterminism, tooling-only assistance, tracked D-point dependencies, experimental absence, and modal audit process | D479-D487 | `SPEC_EXTRACTED` | `kyokaispec/src/language/01-goals-and-non-goals.md`, `kyokaispec/src/language/15-concurrency.md`, `kyokaispec/src/language/17-memory-layout-and-backend-contract.md`, `kyokaispec/src/toolchain/00-toolchain-overview.md`, `kyokaispec/src/toolchain/02-module-resolution-and-koi.md`, `kyokaispec/src/toolchain/03-cli.md`, `kyokaispec/src/toolchain/04-build-profiles-targets-linking.md`, `kyokaispec/src/toolchain/05-diagnostics.md`, `kyokaispec/src/toolchain/07-testing-coverage-bench.md`, `kyokaispec/src/toolchain/08-docs-lsp-audit.md`, `kyokaispec/src/toolchain/09-reproducibility-incremental-builds.md`, `kyokaispec/src/toolchain/10-package-index-semver-releases-ci.md`, `kyokaispec/src/stdlib/00-stdlib-overview.md`, `kyokaispec/src/stdlib/01-admission-contracts.md`, `kyokaispec/src/stdlib/05-collections.md`, `kyokaispec/src/stdlib/08-io-files-env-process-time-random.md`, and `kyokaispec/src/appendices/b-decision-traceability.md` | planned | planned | Extracted as clarification over existing shape; this is not a semantic reopening. |
| Strict-linearity pain-point closure: resource-flow refactors, sound prototyping, graph/slot-map patterns, recovery payloads, context bundles, callback invocation classes, linear test fixtures, branch-join diagnostics, hole-free collections, generic container universes, early release tooling, FFI wrapper kits, `build` expressions, and stdlib cold-start ladder | D488-D501 | `SPEC_EXTRACTED` | `kyokaispec/src/language/05-declarations.md`, `kyokaispec/src/language/09-expressions-and-evaluation.md`, `kyokaispec/src/language/10-statements-and-control-flow.md`, `kyokaispec/src/language/11-linearity-borrowing-and-regions.md`, `kyokaispec/src/language/13-contracts-and-runtime-failure.md`, `kyokaispec/src/language/14-capabilities-and-authority.md`, `kyokaispec/src/language/15-concurrency.md`, `kyokaispec/src/language/16-unsafe-ffi-and-abi.md`, `kyokaispec/src/language/17-memory-layout-and-backend-contract.md`, `kyokaispec/src/toolchain/03-cli.md`, `kyokaispec/src/toolchain/05-diagnostics.md`, `kyokaispec/src/toolchain/07-testing-coverage-bench.md`, `kyokaispec/src/toolchain/08-docs-lsp-audit.md`, `kyokaispec/src/toolchain/09-reproducibility-incremental-builds.md`, `kyokaispec/src/toolchain/11-build-generation-and-playground.md`, `kyokaispec/src/stdlib/00-stdlib-overview.md`, `kyokaispec/src/stdlib/01-admission-contracts.md`, `kyokaispec/src/stdlib/03-allocators-and-memory-containers.md`, `kyokaispec/src/stdlib/05-collections.md`, and `kyokaispec/src/stdlib/11-transitional-ffi-tracking.md` | planned | planned | Normative spec destinations are present; implementation and conformance remain planned. |
| Infrastructure, public docs, CLI output, Analysis Server, editor/debug bundles, showcase, PR/MR D-points, no-maybe docs, generated C/artifacts, docs/website layout, examples, compiler architecture, OSS infrastructure reuse, repo/org topology, package docs, local docs cache, repository-owned `kdocs/`, metadata-only docs indexing, numeric admission evidence, file-role diagnostics, community surfaces, web topology, website taxonomy, package badges, spec-writing guide, and service board | D502-D525 | `SPEC_EXTRACTED` | `kyokaispec/src/toolchain/01-manifest-package-workspace.md`, `kyokaispec/src/toolchain/03-cli.md`, `kyokaispec/src/toolchain/05-diagnostics.md`, `kyokaispec/src/toolchain/08-docs-lsp-audit.md`, `kyokaispec/src/toolchain/09-reproducibility-incremental-builds.md`, `kyokaispec/src/toolchain/10-package-index-semver-releases-ci.md`, `kyokaispec/src/toolchain/11-build-generation-and-playground.md`, `kyokaispec/src/stdlib/07-math-and-numerics.md`, `kyokaispec/src/stdlib/01-admission-contracts.md`, `kyokaispec/src/appendices/b-decision-traceability.md`, `PROJECT_STANDARDS.md`, `docs/contributing/spec-writing.md`, `docs/infrastructure/services.md`, website source, `examples/`, and phase/status docs | planned | planned | Normative toolchain destinations and public workflow/service records are present; website and service implementation remain planned. |
| Package-index trust and daily toolchain critique cluster | D272-D277 | `SPEC_EXTRACTED` | `kyokaispec/src/toolchain/01-manifest-package-workspace.md`, `kyokaispec/src/toolchain/03-cli.md`, `kyokaispec/src/toolchain/05-diagnostics.md`, `kyokaispec/src/toolchain/09-reproducibility-incremental-builds.md`, `kyokaispec/src/toolchain/10-package-index-semver-releases-ci.md`, `kyokaispec/src/toolchain/11-build-generation-and-playground.md` | planned | planned | Normative spec destinations are present; implementation and conformance remain planned. |
| Formal calculus and proof | D143/D241 | `SPEC_EXTRACTED` | `kyokaispec/src/appendices/d-formalization-roadmap.md` for proof scope, paper-proof obligations, exclusions, milestones, research-note status, and later mechanization plan | not applicable | research note exists | `lambda_K` paper proof is still not drafted; maturity has only moved from accepted shape to normative roadmap extraction. |

Update this tracker whenever a row moves to any higher maturity state from the shared `phase.md` maturity vocabulary. Do not mark maturity based on intent; mark only completed work with a path or concrete artifact.

---

## Accepted Shape Routing Record: D280-D290

This cluster records the accepted rules for generic task transfer, spawn failure, explicit high-concurrency I/O, `select`, cancellation safety, fatal cleanup, refutable linear patterns, iterator regions, linear collections, generic cleanup, and intentional discard. The normative specification chapters named in the tracker carry the extracted contracts.

### D280: Generic Task Transfer Classification

Generic task transfer is structural only when a type asks for that structural check. A generic user type is `task_local` by default. A generic user type declares `task_transfer structural` to request structural transfer classification. For such a type, the compiler computes transferability from stored fields after generic substitution. `Optional[T]`, `Box[T]`, `Buffer[T]`, and user wrappers are task-transferable only when their concrete stored fields are task-transferable.

Kyokai does not add user-written conditional transfer syntax such as `task_transfer when T: task_transfer`, and it does not add a Rust-style `Send`/`Sync` marker typeclass ecosystem. Opaque, unsafe-backed, target-backed, or foreign-backed types need an explicit unsafe transfer contract recorded in `.koi` before safe code may treat them as task-transferable. `.koi` records task classification facts for public and internal types that can cross package boundaries.

### D281: Spawn Failure And Capture Ownership

Spawn capture transfer is atomic at successful child-task creation. If `spawn` succeeds, captured linear values are consumed from the parent and owned by the child. If `spawn` fails before the child exists, captured linear values remain owned by the parent. A normal spawn failure result contains the spawn error, not a capture bundle. An implementation must reserve or allocate whatever it needs before consuming captures, or internally roll back capture consumption before reporting failure. No linear value may be considered consumed by a task that was not created.

### D282: Explicit Poller High-Concurrency Canon

Kyokai has 1:1 OS-thread tasks as the language task model. High-concurrency I/O uses explicit `Poller` APIs over platform readiness or completion mechanisms such as epoll, kqueue, IOCP, io_uring, WASI poll facilities, or target-specific equivalents. High-concurrency servers combine explicit Poller/event-loop APIs, bounded worker pools, channels, deadlines, cancellation tokens, and capability-gated I/O. The standard library and docs provide canonical examples for accept loops, connection state machines, timeout handling, backpressure, graceful shutdown, and handoff to worker pools.

No async/await, virtual-thread parking, hidden reactor, hidden executor, task migration, or M:N scheduler is part of Kyokai semantics. `glow`, `vibe`, and other slang async spellings are rejected as core syntax.

### D283: `select` With Poller Readiness

`select` waits on channel send/receive arms, deadline/cancellation arms, and Poller readiness tokens admitted by a closed standard-library `Selectable` surface. If exactly one arm is ready, that arm runs. If multiple arms are ready and no explicit fair mode is selected, the implementation may choose any ready arm; this choice is nondeterministic program behavior and must not be used for correctness. If an explicit fair mode is selected, the fairness contract named by that mode controls arm choice. If no arm is ready and a default arm exists, the default runs immediately. If no arm is ready and no default or deadline can progress, the task blocks according to the selected blocking contract. If all channel arms are closed and no Poller, deadline, or default arm can progress, `select` produces a structured exhaustion result, not a silent spin. Livelock and fairness diagnostics are tooling, not default semantics.

### D284: Cancellation Safety Classes

Blocking and cancellable APIs declare one cancellation-safety class: `NoEffectOnCancel`, `PartialProgress`, `ConsumesOnCancel`, or `UncancellableBlocking`. The class appears in the API contract and generated docs. `NoEffectOnCancel` means cancellation returns control without changing user-visible resource state. `PartialProgress` APIs state exactly which values, offsets, buffers, handles, or resources can have advanced. `ConsumesOnCancel` APIs state exactly which linear values are consumed and what recovery value is returned; if no recovery value exists, the API contract says so explicitly. `UncancellableBlocking` APIs state that cancellation is not observed until the operation returns or the target reports an interruption. POSIX `EINTR` and Windows cancellation behavior are target-contract facts, not hidden standard-library folklore. Tests for cancellable standard-library APIs include cancellation and interruption cases on targets whose contract exposes those events.

### D285: Fatal Cleanup Boundary

Kyokai separates normal cleanup from fatal termination. On normal scope exit and recoverable explicit cleanup paths, linear obligations must be consumed exactly once. On panic cleanup, registered `defer` actions run in the decided order. If a `defer` panics while panic cleanup is already running, execution escalates immediately to runtime-fatal. After runtime-fatal escalation, no further user defers are guaranteed to run.

TPOE and runtime-fatal termination do not promise user cleanup. The execution context is dead. Linear resources may be abandoned only because the execution context is being terminated; this is not normal linear consumption and cannot be observed as a valid continuation. External resources must document that fatal termination may skip cleanup. Freestanding targets define their fatal action: trap, halt, reset, or a target-specific fatal handler.

### D286: Refutable Patterns With Linear Scrutinees

Refutable pattern sugar lowers to an explicit core `case` before linearity checking. Every success and failure path must account for every linear payload in the scrutinee. A `while let` condition over an owned linear scrutinee is legal only if each iteration and the final failure path satisfy exact-use obligations. `break`, `continue`, `return`, and panic paths from inside the loop are checked against the current linear state and deferred cleanup state. Diagnostics name the unaccounted variant or payload path when a refutable pattern loses ownership.

### D287: Iterator Borrow Regions And Drain Cleanup

An iterator yields owned values or borrowed values according to its iterator item type. Borrowed item types carry a region tied to the iterator borrow or an explicitly named region from the iterator API. `for` creates a per-iteration borrow region for borrowed iteration. A yielded borrow cannot escape the loop body unless the iterator API exposes a named region that permits escape. Drain iterators over linear elements are themselves linear and must be exhausted, returned, or finalized by an explicit cleanup operation. Generators preserve suspended linear states and registered defers across yield points; abandonment follows the same explicit finalization rules as other linear iterators.

### D288: Linear Standard Collections And Raw Storage

Standard collections support `Linear` keys and values only when their admission record defines the full ownership contract for that collection. APIs that remove or replace entries return owned linear values or require an explicit cleanup callback or operation. Drain APIs over linear elements are linear and must be exhausted or finalized. Entry APIs state whether keys and values are moved, borrowed, replaced, or left in place on every success, failure, allocation-failure, cancellation, and panic-cleanup path. Collection internals use an audited standard raw-storage abstraction for uninitialized and partially initialized memory when they need such storage. That abstraction records initialization state and exposes safe wrappers before collection code outside the raw-storage module can use it. Every collection admission record documents invalidation, allocation, failure, cleanup, iteration order, and concurrency behavior.

### D289: `Cleanable[T]`

`Cleanable[T]` is a standard cleanup contract used by generic containers and drains. For `Free` types, `Cleanable[T]` is satisfied trivially and performs no hidden runtime action. For `Linear` types, `Cleanable[T]` requires an explicit implementation that consumes the value through a named cleanup operation. `Cleanable` is never run automatically at scope exit. Container APIs state when they require `Cleanable[T]` and when they return owned values instead. The compiler diagnostic set includes a missing-cleanup-contract diagnostic that suggests adding `Cleanable[T]` when a generic linear cleanup obligation cannot be discharged.

### D290: Narrow Generic Destruction And Intentional Free Discard

Kyokai does not run destructors automatically at scope exit and does not add a `drop` keyword for linear values. Domain-named cleanup remains the standard style, for example `closeFile(file)`, `destroyMutex(mutex)`, or `freeBuffer(buffer)`. Linear resources are consumed by explicit domain operations, explicit `defer` registrations, or explicit generic cleanup APIs. `Destroyable[T]` exists only as a manual generic cleanup contract. It is never auto-run by scope exit. `Cleanable[T]` uses `Destroyable[T]` only when a container or drain API explicitly requires that relationship in its contract.

`discard expr;` is allowed only for `Free` values and exists to silence must-use or ignored-result diagnostics with intent. `slay`, `yeet`, and other slang cleanup keywords are rejected as core syntax.

---

## Accepted Shape Routing Record: D291-D301

This cluster records the accepted rules for tuple pressure, local anonymous records, nominal record update, explicit error conversion, must-use diagnostics, numeric edge cases, bounded compile-time evaluation, macro rejection, asset embedding, tooling-only verification, no-macro codecs, WASM/WASI targets, cross-target platform contracts, direct C ABI FFI, and practical pinned construction. The normative specification chapters named in the tracker carry the extracted contracts.

### D291: Tuples, Local Anonymous Records, And Nominal `with` Update

Kyokai has no tuple syntax and no positional anonymous product types. Public APIs, exported signatures, `.kyo` declarations, and `.koi` artifacts use nominal named records for multi-value shapes. `Pair` and `Triple` are library records only if the standard library admits them; the parser, type checker, and `.koi` writer do not treat them specially.

Kyokai admits local anonymous named-field records inside function bodies for temporary multi-value results. These local anonymous records cannot appear in `.kyo` public APIs, `.koi` artifacts, typeclass instances, public record fields, exported constants, or cross-package artifact identity. They are resolved inside the declaring body before public interface generation.

Kyokai admits nominal `with` record update for named records only. The result type is the same nominal record type as the source record. For `Free` records, `with` copies or reuses unmentioned fields according to Free value rules. For `Linear` records, `with` consumes the old record, replaces listed fields, and forwards every unlisted field exactly once into the new record. A listed replacement field is evaluated before the new record is completed and is checked by the move/borrow rules for that field type. The old value of a replaced linear field is not silently destroyed; the final syntax must either move it to an explicit binding/cleanup path or reject the update. `with` does not introduce structural subtyping, row polymorphism, duck typing, or anonymous public record identity.

### D292: Explicit Error Conversion And Structured Fatal Payloads

Error conversion is never implicit. `or return as TargetError` invokes an explicit visible conversion through an `ErrorConvertible[SourceError, TargetError]` instance selected by typeclass resolution. If no visible coherent instance exists, the program is rejected. Without `as TargetError`, `or return` keeps exact existing error behavior and requires the enclosing return error type to match the source error type. Named error sets are syntax sugar for Kyokai union/error types, not a second runtime mechanism.

Error values expose source-chain or backtrace fields only when the error type or standard protocol explicitly declares those fields and construction provides them. Panic and TPOE payloads are structured diagnostic values governed by the fatal-diagnostic rules. Slang forms such as `yeet` and HTTP-status panic names are rejected.

### D293: `must_use` And Intentional Free Discard

Declarations may be marked `must_use` with an optional reason string. The standard `Result` type is must-use by default. Functions returning dangerous status, handles, builders, or security-sensitive values are marked must-use by their API contract when ignoring the value would hide failure, security state, ownership state, or required finalization. Ignoring a must-use value emits a diagnostic under the compiler-integrated lint system.

`discard expr;` explicitly acknowledges and silences discard diagnostics only for `Free` values. Linear values still cannot be discarded by `discard` unless consumed by a valid cleanup operation.

### D294: Numeric Edge Cases

`Int128` and `Nat128` are core integer types. Literal inference rejects generic literal overflow at compile time when the target type is known. Inclusive range loops where start equals end run exactly once. Range lowering must not overflow at `Index.max` or equivalent max values.

Safe Kyokai code cannot mutate a global floating-point rounding mode. Float literal patterns are illegal except through explicit predicate or named classification APIs such as `isNaN`, or exact named constants where specified. Unsafe or target-specific rounding/FPU controls are not safe Kyokai operations. Any such operation must live in an unsafe or capability-gated target API with an explicit target contract.

### D295: Bounded Comptime And Macro Rejection

Compile-time evaluation is deterministic value evaluation under the D202/D203 limits. It cannot perform ambient filesystem, network, process, clock, randomness, root-capability, or host-environment effects. Declaration guards may inspect only target, edition, feature, profile, and configuration facts admitted by the manifest and target contract.

Kyokai has no token macros, derive macros, hygienic source macros, procedural macros, AST macros, source-rewriting macros, or macro expansion phase. Compile-time evaluation cannot generate new types, declarations, functions, syntax, modules, typeclass instances, or `.koi` interface items.

Kyokai exposes only the closed compiler facts accepted by spec text as compile-time constants or built-ins: size, alignment, layout class, target facts, and public-interface metadata explicitly recorded in `.koi`. These facts are read-only. They are not a user reflection system and cannot enumerate private implementation details across module boundaries.

Generated code belongs in manifest-declared `[generate]` steps. Generators emit real `.kyo`/`.kai` source or generated artifacts with provenance recorded by the toolchain. Generated source is checked as source, not hidden expansion inside expressions or declarations.

### D296: Embedding, Static Assertions, And Tooling-Only Verification

`@embedBytes(path)` embeds the exact bytes of a file at compile time. `@embedText(path)` embeds the exact bytes of a file after validating that they are well-formed UTF-8 text. The path argument must be a compile-time string literal or compile-time constant string admitted by the compile-time evaluation rules. Embedded paths are resolved relative to the declaring source file's package root. The resolved path must stay inside the package or an explicitly declared generated-output root.

Missing files, unreadable files, directory paths, invalid UTF-8 for `@embedText`, and package-boundary escapes are compile-time errors. Embedded file contents and normalized relative paths participate in the reproducible build identity and in `.koi` provenance when the embedded value affects public interface shape or generated artifacts. Embedded values are immutable and grant no runtime filesystem capability.

`static_assert(expr, message)` evaluates `expr` at compile time. `expr` must produce `Bool`; `message` must be a compile-time string. Failure is a compile-time diagnostic. `static_assert` may inspect only deterministic compile-time inputs admitted by Kyokai's compile-time evaluation rules. `based`, `bless`, and other slang assertion names are rejected as core syntax.

Source-level SMT-backed `verify` syntax is rejected as Kyokai language semantics. The compiler is the verifier for Kyokai's static semantics: parsing, names, types, linearity, borrowing, capabilities, contracts that are statically checkable, compile-time evaluation, and target contract checks. `kyokai verify` is a tooling-only proof-analysis command. It reads source, `.koi`, contracts, `lambda_K` models, generated proof obligations, and solver backends. It does not make invalid Kyokai valid, does not replace the compiler, does not silently participate in type checking, and does not silently run during builds. Verification reports must state proof scope, assumptions, solver or proof backend, timeout policy, unknown/inconclusive behavior, and whether each obligation is proven, refuted, unknown, skipped, or out of scope.

### D297: Codecs, Schemas, Bindgen, And No Macros

Kyokai does not add derive macros, source macros, token macros, or unrestricted type reflection for codecs. Standard library and toolchain ergonomics use `Encode`, `Decode`, `Schema`, format-specific contracts, manifest-declared `[generate]` code generation, and `kyokai bindgen`.

Generated codec and binding files carry provenance. Unsafe bindings generated from C headers still require unsafe contracts for ownership, lifetime, callbacks, layout, failure, and target variance. External schema formats such as Protocol Buffers, FlatBuffers, and Cap'n Proto follow the same visible generated-source model.

### D298: WebAssembly/WASI Target

Kyokai remains a native systems language with multiple backend and target families. WebAssembly/WASI is an accepted target family under the target-tier system. A WASM/WASI target is usable only after its target record defines the same target-contract fields as native targets: pointer width, integer layout, endianness, stack behavior, panic/fatal behavior, import/linking model, allocator/runtime requirements, and available standard library modules.

WASI host resources map to explicit Kyokai capabilities. Preopened directories, clocks, random sources, sockets, environment, arguments, and process-like authority are not ambient. Host imports must be declared in the target/build contract or package manifest. Undeclared host authority is rejected. Threads, atomics, shared memory, dynamic loading, and filesystem behavior are available only when the selected WASM/WASI target contract says they are available. Browser WASM and WASI are separate target contracts. WASM-only Kyokai is rejected.

### D299: Platform Contracts And Cross-Target Parity

Every supported target tier must name its platform contract document or structured target record. Platform contracts include handle/file-descriptor authority, inheritance behavior, path model, environment/argument model, process spawning, time/random source availability, filesystem semantics, stack/guard behavior, signal or console-control behavior, callback thread rules, and cancellation/deadline interruption behavior.

POSIX targets must state how safe wrappers handle `EINTR`: retry, expose a typed cancellation/deadline/error case, or reject the wrapper as unavailable. Windows targets must state how Kyokai capabilities wrap HANDLE-like resources, security descriptors/ACL-sensitive authority, overlapped IO, console handles, and COM apartment/thread-affinity requirements when COM APIs are used. Foreign callback contracts must state which thread or executor may invoke the callback and which Kyokai values may cross that boundary.

Safe portable APIs expose only behavior guaranteed by the selected target contract. Target-specific APIs live behind target guards or platform modules. If a standard library or toolchain feature is accepted for one supported OS family, and equivalent primitives exist on another supported target, the feature must specify and implement the target contract for those targets before it is claimed portable. POSIX-only behavior cannot silently enter the portable standard library. Maintainers may merge target-specific implementation work before all target work is complete only when the API remains marked target-specific or unstable; before the API is marked stable or portable, maintainers must close the parity gap or explicitly remove the portability claim.

### D300: Direct C ABI FFI And Non-C Wrapper Policy

Kyokai's direct FFI target is the selected target's C ABI. Native Rust ABI interop, native Zig ABI interop, and native C++ ABI interop are rejected. Rust, Zig, and C++ may interoperate with Kyokai only through explicit C-compatible wrappers or explicit stable C-shaped ABI records.

C++ interop uses `extern "C"` wrappers, COM-like C-compatible vtables, or explicit ABI records. C++ exceptions, templates, object lifetime, and native name mangling do not cross the Kyokai FFI boundary directly. Rust interop uses `extern "C"` functions and `repr(C)`/C-compatible wrapper types only. Rust panics and Rust-native layout do not cross the Kyokai FFI boundary directly. Zig interop uses C ABI wrappers only. Zig-native calling or lowering details are not Kyokai foreign contracts.

`extern union` may represent C untagged unions only inside unsafe/FFI contracts. Reading a union arm requires an unsafe contract stating which arm is valid. C variadic functions are unsafe-only and require target ABI support. Safe wrappers must translate to typed Kyokai APIs. C macros are not imported as runtime declarations. Bindgen may translate simple constants, inline-like wrappers, or reject macros with diagnostics.

Foreign callbacks must state ownership, thread, lifetime, reentrancy, panic/unwind, and capability rules. Dynamic loading and plugin APIs must use ABI records with version fields, symbol names, calling conventions, layout hashes, and failure contracts. Arbitrary `transmute` remains unsafe. A safe byte-view/layout conversion is admitted only when the source bytes, alignment, size, initializedness, padding policy, provenance, and target validity predicate are all checked or guaranteed by a named API contract. Kyokai sum types have no implicit foreign ABI. Foreign tags and payloads are modeled with explicit extern records/unions and wrappers.

### D301: Pinning, Emplacement, Stack Storage, And Large Arrays

D89b remains the pinning baseline: address-stable source types are explicit pinned declarations, and stable heap storage uses `PinBox[T]` or other pinned containers accepted by their own explicit D-points. Compiler optimizations such as RVO/NRVO do not create source-level no-move guarantees. A pinned value may be constructed only through APIs that specify final storage before initialization begins.

In-place construction APIs for `PinBox`, ordinary `Box`, arenas, fixed buffers, and stack slots must specify storage ownership, initialization state, failure cleanup, and whether the resulting value is movable or pinned. In-place construction failure must not leak partially initialized linear fields; cleanup order and responsibility must be specified.

Projection from a pinned record to pinned fields is safe only for fields whose declaration and container rules preserve address stability. Moving a field out of a pinned value is illegal unless the field type or rule explicitly permits it. Large array initialization may use repeat/fill/build APIs only when element copying, cloning, moving, or generator evaluation is explicit and legal for the element type. Stack allocation APIs must state stack-size interaction, overflow failure mode, target support, and whether the allocation is statically or dynamically sized. Unsafe pinned abstractions still require audit contracts at the unsafe boundary.

---

## Accepted Shape Routing Record: D302-D311

This cluster records accepted shape for production observability, compiler-backed editor analysis, property/fuzz/bench workflow, standard-library tiers, the existing license boundary, public decision workflow, build-cache identity, RIIK audit discipline, capability attenuation, and `.koi`/KBI interface diffing. The normative specification chapters and workflow documents named in the tracker carry the extracted contracts.

### D302: Observability, Profiling, And Diagnostic Events

Kyokai programs do not emit telemetry automatically. Structured logging, tracing, metrics, profiling, allocator event capture, and diagnostic-event streams require explicit logger, tracer, metrics, profile, report, or event sinks. A sink is either an ordinary value passed to the API or a capability-bearing handle whose authority is visible in the function signature or object state. Hidden global telemetry, hidden network export, hidden profiling hooks, and silent release-build event capture are rejected.

The standard observability vocabulary contains `LogRecord`, `Span`, `SpanEvent`, `MetricPoint`, `DiagnosticEvent`, `ProfileSample`, and `AllocationEvent`. `LogRecord` contains severity, message or structured fields, module/target, source span when available, timestamp policy, and attached error/result context when supplied. `Span` and `SpanEvent` contain span identity, parent identity when present, name, module/target, timing data, structured fields, and explicit status/failure data. `MetricPoint` contains metric identity, kind, numeric value or distribution bucket, labels, unit, timestamp policy, and aggregation identity. `DiagnosticEvent` uses the same code, severity, span, category, and suggestion vocabulary as `kyokai check` and command-line JSON diagnostics. `ProfileSample` records profile kind, selected target, selected profile, selected backend, compiler compatibility class, sample counter or timestamp, frame data when available, and whether debug symbols, frame pointers, and source maps were enabled. `AllocationEvent` records allocator identity, allocation/deallocation/reallocation kind, size, alignment, result status, source span when available, and allocation-site metadata when instrumentation is enabled.

Trace context propagation is explicit. Context moves through values, through taskgroup inheritance rules written in the concurrency spec, or through declared framework APIs. Trace context is not ambient authority. Build profiles request debug symbols, frame pointers, profiling metadata, allocator instrumentation, coverage instrumentation, source maps, trace hooks, and profile report emission through explicit fields. Release profiles do not retain debug-only `debug` output, hidden telemetry, profiler hooks, allocator event capture, or trace hooks unless the profile explicitly opts in.

`cold`, `hot`, `likely`, and `unlikely` are optimization hints only. Ignoring them preserves accepted programs, runtime behavior, diagnostics meaning, `.koi`, public API compatibility, and type checking. These hints do not license unreachable-code assumptions, ownership changes, branch removal, contract weakening, or fatal-path elision. Machine-readable observability reports are written under `kyokai-out/<target>/<profile>/<backend>/<package>/reports/` unless the command explicitly sends them to stdout or another user-selected report path.

### D303: Analysis Server And Editor UX

Kyokai ships a first-party Analysis Server. `kyokai lsp` is the LSP frontend for that server, not a second analyzer. Other future protocol frontends read the same server facts. The server shares the compiler parser, resolver, type checker, linearity checker, borrow checker, capability checker, unsafe checker, implicit-completion registry, lowering pipeline, manifest reader, and `.koi` reader. Analysis diagnostics use the same diagnostic codes, severity meanings, spans, help text, and machine-readable categories as `kyokai check`.

The Analysis Server exposes semantic tokens or equivalent protocol metadata for moved values, consumed linear values, live immutable borrows, live mutable borrows, capability values, unsafe modules, unsafe contracts, generated source, public interface declarations, body-only declarations, selected target guards, and stale generated provenance. Inlay hints cover inferred types, inserted implicit completions, selected typeclass instances, selected receiver-module lookup, resolved target guards, capability flow, moved/consumed state, and generated import candidates.

The server exposes lowering views for parsed surface syntax, typed elaboration, implicit completions, desugarings, tautology inputs, and backend-relevant public interface facts. Interface/body sync reports missing body definitions, stale interface declarations, visibility drift, public API drift, `.koi` diff classifications, and stale generated-source provenance. Ownership diagrams, borrow timelines, capability-flow views, unsafe-audit views, package graph views, and SemVer-impact views are projections of compiler/toolchain facts, not separate semantics.

Code actions may add imports, qualify names, insert explicit completions, insert missing `defer` cleanup skeletons, navigate to unsafe audit contracts, apply machine-applicable fixes, and organize imports. A code action must not silently change runtime behavior, ownership transfer, capability authority, target selection, public API identity, unsafe boundary meaning, or `.koi` compatibility. Generated files expose source-origin metadata so rename, go-to-definition, diagnostics, SemVer checks, docs, and `.koi` provenance can trace back to generator inputs when that provenance exists.

### D304: Property Tests, Benchmarks, Fixtures, Fuzzing, And Replay

Kyokai testing recognizes `test`, `property`, `bench`, `fixture`, and `fuzz` artifacts in package metadata and command discovery. These are first-class toolchain concepts because stdlib admission, compiler conformance, RIIK, codec generation, FFI wrappers, math, collections, diagnostics, and packages need replayable evidence.

Property tests use typed `Gen[T]` generators, typed shrinkers, deterministic seeds, sample-count policy, failure classification, replay records, and minimized regression cases. A property failure prints the seed, shrink path or minimized case when available, source span, package/profile/target/backend identity, and a replay command. Regression cases promoted from failing property runs become ordinary package test artifacts with stable replay metadata.

Fuzz targets support byte-oriented inputs and structure-aware inputs. A structure-aware fuzz target defines the input decoder/generator and failure behavior explicitly. Fuzzing records corpus directories, crash directories, minimized reproducers, coverage mode when supported, dictionary/input-shape metadata when supplied, and deterministic replay commands. Coverage-aware property/fuzz integration is accepted, but coverage instrumentation must not change accepted source semantics, `.koi`, ownership checking, or diagnostics meaning.

Benchmarks define warmup, measurement count or duration, selected profile, target, backend, CPU/host metadata that affects interpretation, statistical report output, noise caveats, and optional profiling hooks. Fixtures that allocate or acquire linear resources declare setup, teardown, failure cleanup, fixture ownership, parallelism rules, and what happens when setup fails after partial acquisition. `kyokai test`, `kyokai bench`, and `kyokai fuzz` write user-visible reports under the standard `reports/` output tree and can emit machine-readable reports for CI.

### D305: Standard Library Tiers

The Kyokai standard library is tiered by stability and release obligation: `Core`, `Systems`, `Extended`, `Experimental`, and `Internal`. The tiers are public contract categories, not separate languages.

`Core` contains language-adjacent essentials required for ordinary checked programs: primitive protocols, `Result`, `Optional`, formatting contracts, basic containers, allocators, spans, iterators, and core diagnostics support. `Systems` contains stable systems APIs: files, paths, environment, process, time, random, networking when admitted, concurrency primitives, atomics, platform contracts, and FFI support wrappers. `Extended` contains useful batteries whose API shape is stable enough to ship but not required for every minimal toolchain profile. `Experimental` contains incubating APIs with explicit instability markers and no silent promotion to stable tiers. `Internal` contains implementation-support modules used by compiler, runtime, package manager, generated helpers, tests, or stdlib internals; it has no public compatibility promise unless a module is promoted by D-point and admission record.

GUI, graphics, hot reload, high-level application frameworks, and large domain libraries are rejected as `Core` language requirements. They may enter `Extended` or `Experimental` only through the same admission process as other official modules. Every stable `Core`, `Systems`, or `Extended` module has an admission record covering contract, failure modes, allocation behavior, authority/capability behavior, blocking/concurrency behavior, platform behavior, tests/oracles, fuzz/property plan when applicable, compatibility policy, and owner/maintenance status. Reserved package/index namespaces may host official extended packages without making them core language requirements. Promotion from `Experimental` to a stable tier requires an admission record and compatibility review; there is no silent promotion by age or popularity.

### D306: Licensing Boundary Explanation

D263 remains closed. Kyokai compiler, package manager, formatter, LSP, backends, build tools, and other toolchain source are GPL-3.0-or-later unless a file states a compatible stronger boundary. Kyokai runtime, standard library, target helpers, startup code, and target-linked support libraries use GPL-3.0-or-later WITH GCC Runtime Library Exception 3.1 unless a file states another project-approved compatible boundary.

Ordinary Kyokai user source code and resulting target programs are not forced under GPL merely because they are compiled by Kyokai or linked with exception-covered runtime, standard library, startup, or target-helper components through ordinary compilation/linking. Distributing modified Kyokai compiler, package manager, formatter, LSP, backend, or other toolchain source follows GPL-3.0-or-later obligations. Distributing modified exception-covered runtime/stdlib/target-helper source follows GPL-3.0-or-later WITH GCC Runtime Library Exception 3.1 obligations for those files. Project docs may explain this boundary, but must not present the project summary as legal advice.

### D307: Public Decision Workflow And Maturity Tracking

D-points are required for semantic, compatibility, stdlib public API, toolchain contract, runtime, unsafe/FFI/backend, package-index, governance, or release-shape changes. D-points are not required for typo fixes, behavior-preserving refactors, test-only additions, or bookkeeping. A D-point may start in `Kyokaishape.md`, a GitHub Discussion, a GitHub Issue, or a PR labeled `dpoint-needed` or `dpoint`. If a D-point starts outside `Kyokaishape.md`, `Kyokaishape.md` gets a tracker row linking the public thread/PR and naming the current owner/status.

A PR that changes accepted language/toolchain/stdlib behavior must either reference existing accepted shape/spec text or carry/point to the D-point final wording that accepts the new behavior. Acks count only after final wording exists. Final wording must include the exact semantics, illegal forms, interactions, spec target, and implementation/test/proof impact.

The normal public path is: proposal opens, shape is debated, final wording is written, community acks final wording, maintainer accepts, `kyokaidecided.md` is updated, `kyokaispec/` is updated when the spec home exists, and conformance/implementation status is tracked. The lead maintainer may close a point with an explicit `Lead YES` without waiting for the community ack count. `Lead YES` does not remove the requirement for final wording, traceability, and accepted-shape extraction. A solo-maintainer decision uses the same artifacts with fewer participants: final wording, maintainer acceptance, accepted-shape extraction, spec target, and phase/status update.

Every accepted D-point gets a reverse index entry mapping D-point ID to `kyokaidecided.md`, `kyokaispec/` path when extracted, test/conformance path when present, implementation path when present, and calculus/proof path when relevant. Status uses the maturity states defined in `Kyokaishape.md` or their direct successors. A status row may name target milestone, release gate, implementation phase/subphase, owner, and open blockers.

Language edition version, KBI/.koi version, package-index schema version, compiler compatibility class, and toolchain release version are distinct version axes. A source syntax/semantics change may require an edition bump even when KBI does not change. A public interface artifact format change requires a KBI/.koi version or compatibility-class update even when source syntax does not change. A package-index metadata schema change requires package-index schema versioning even when compiler semantics do not change. `phase.md` is a readable implementation/proof status board with phases, gates, percentages, blockers, and closed evidence. It orders work, but it must not become the normative source for semantics.

### D308: Performance, Cache Identity, Incremental Builds, And Stack Defaults

Kyokai does not promise normative wall-clock compile-time or runtime performance numbers, but an official toolchain that is chronically unusable for ordinary projects is a toolchain-quality failure. The local build cache is part of the official toolchain shape. Deleting it must not change accepted programs, diagnostics meaning, final artifacts, `.koi`, or runtime behavior.

Build identity inputs for cache reuse and artifact reproducibility include source contents, manifest contents, lockfile contents, selected features, selected profile, selected target, selected backend, compiler compatibility class, `.koi` inputs, generator inputs, admitted environment inputs, target records, codegen-affecting flags, debug/source-map policy, sanitizer policy, frame-pointer policy, LTO policy, target CPU/features, and profile-controlled instrumentation. Cache reuse is valid only when the recorded build identity matches the requested build identity and the cached content hash verifies.

Remote or shared artifact caches are accepted as cache-aside infrastructure. A toolchain is not required to contact a remote cache, but any fetched artifact must validate by content hash, build identity, package identity, target/profile/backend identity, and compiler compatibility class before use. Debug info path policy is explicit. Reproducible profiles support path remapping or normalized paths and record whether absolute paths are embedded.

Generated C backend flags are part of the backend contract. Flags that change language semantics or introduce backend undefined behavior are rejected unless explicitly modeled by an unsafe/target contract. Stack defaults, task stack defaults, guard-page behavior, overflow detection behavior, and per-target/profile overrides are explicit profile or target-contract fields. Incremental compilation may change build time only. It cannot change accepted programs, diagnostics meaning, `.koi` content, public interface diffing, generated source provenance, or runtime behavior. Failure to honor an explicitly requested profile/backend feature is a build error, not a silent downgrade. Cache metadata and timing/performance reports are user-visible reports when requested, not language semantics.

### D309: RIIK Unsafe Boundary And Stdlib Audit

RIIK does not mean "rewrite first, audit later". Stable stdlib modules are implemented in safe native Kyokai by default for pure data-structure, formatting, parsing, iterator, codec, and deterministic computation domains when the team understands the algorithm and can meet the admission evidence bar. FFI or existing mature libraries are used for OS boundaries, hardware interfaces, crypto primitives, libm-quality numerics, platform services, and other domains where correctness depends on external standards, side-channel review, target quirks, or mature upstream verification that Kyokai has not yet reproduced.

A stable stdlib module with unsafe internals identifies each unsafe primitive, invariant, caller obligation, failure mode, aliasing/provenance rule, cleanup rule, and the safe APIs that contain it. Collections and allocators isolate raw storage, initializedness, aliasing, growth, movement, panic/TPOE/failure cleanup, and partial-initialization logic behind small audited internal modules. Math APIs publish accuracy contracts, special-value behavior, target FPU assumptions, rounding assumptions, exception/flag policy, oracle/reference sources, and differential-test sources. Crypto APIs name external standards, test vectors, side-channel claims, key/secret cleanup behavior, randomness requirements, review requirements, and allowed implementation strategies before stable admission.

Transitional FFI modules carry replacement tracking and unsafe contracts. Replacing FFI with native Kyokai does not remove the admission requirement. Property tests, fuzzing, conformance vectors, differential tests, sanitizer runs where applicable, and audit reports are admission evidence, not optional decoration. `Unsafe_Module` use inside stdlib is tracked as part of public stdlib admission status.

### D310: Capability Attenuation And Resource Limits

Capability attenuation is a one-way operation from a stronger sealed capability value to a weaker sealed capability value according to a declared capability rule. An attenuation API names the stronger input capability, weaker output capability, allowed operations, lifetime relationship, thread-transfer classification, revocation/closure behavior when applicable, and failure behavior. A weaker capability exposes only the operations named by its capability type and contract.

Attenuation does not grant new authority, widen lifetime, widen thread-safety, widen target availability, bypass package policy, or bypass unsafe/capability restrictions. Attenuated capabilities remain sealed and unforgeable. Unsafe code cannot construct them except through approved internal constructors covered by D245/D255 and the capability module's audit contract.

Manifest boundary declarations state what external resources a package, generated tool, plugin, test, command, or build script expects. They are audit/policy inputs, not implicit function arguments. The compiler/toolchain must not synthesize runtime capabilities merely because a manifest names a resource. Capability graph/lattice documentation is accepted for review and audit, but source semantics are the explicit operations and types, not hidden algebra inference.

Resource-limit primitives such as semaphores, permits, rate limits, bounded task slots, and bounded connection slots are ordinary linear stdlib capabilities or synchronization objects with explicit acquire, release, try-acquire, deadline/cancellation, fairness, and failure contracts. WASI preopens, Capsicum-like narrowed descriptors, process handles, filesystem subtrees, network listeners, random sources, clocks, and plugin resources all flow through explicit capability values and attenuation APIs.

### D311: `.koi` KBI Sections, Provenance, And Interface Diffing

`.koi` is a versioned Kyokai Binary Interface / checked package interface artifact, not an opaque cache file. The KBI version identifies the artifact schema, canonical encoding rules, compatibility class, and minimum reader behavior. `.koi` sections have canonical encoding, canonical ordering, canonical string/path normalization, canonical integer encoding, and canonical hash rules.

Required sections include package identity, package version, source language edition, KBI version, compiler compatibility class, selected feature set, target-independent public interface, exported declarations, visibility, type/universe facts, typeclass definitions, typeclass instances, generic bodies/materialization metadata where needed, capability/interface contracts, unsafe/public audit metadata, docs metadata, dependency `.koi` digests, and provenance. Provenance records include source digests, manifest digest, lockfile digest when present, generator records, embedded-file digests when public artifacts depend on them, compiler compatibility class, selected profile-relevant public settings, selected features, and dependency `.koi` digests. Target-specific or backend-specific sections are allowed only when their target/backend identity is included in the section key and artifact hash.

`.koi diff` classifies interface changes as `breaking`, `additive-minor`, `patch-compatible`, or `unknown-manual-review`. Publishing to the official index fails if `.koi diff` detects a breaking public interface change without a major version bump or an explicit maintainer override record. Local builds and private indexes choose policy, but `kyokai semver-check`, `kyokai publish --dry-run`, and `kyokai koi diff` report the diff classification when requested.

Hash mismatch, non-canonical encoding, unsupported KBI version, unsupported compatibility class, incoherent instance/interface data, dependency digest mismatch, or malformed provenance is a hard error. `.koi` is consumed by compiler checking, package compatibility, docs, the Analysis Server, SemVer checks, reproducibility, binary cache identity, and audit tooling. It is not a dumping ground for private compiler query caches.

---

## Accepted Shape Routing Record: D312-D313 And D315-D321

This cluster closes accepted shape for proof-claim honesty, syntax/file-model closure, adoption documentation, daily debug/span/docs behavior, synchronization semantics, generic and closure edge rules, proof-tooling boundaries, daily CLI workflow extensions, and structured target contracts.

### D312: Formal Proof Scope And Future Mechanization

Kyokai labels claims as `intended-by-spec`, `implemented-and-tested`, `conformance-backed`, `paper-proven`, or `mechanically-proven`. Every safety claim names the feature scope and evidence tier. Public docs cannot say "proven safe" without naming what was proven, by what artifact, and what was excluded.

The first `lambda_K` paper proof covers the sequential core only: ownership, movement, exact linear use, borrowing, lexical region end, capabilities as values, checked failure, and defined terminal failure. It does not prove concurrency, FFI, backend correctness, standard-library algorithms, crypto, libm accuracy, package behavior, LSP behavior, formatter behavior, docs generation, or reproducible builds.

Data-race freedom claims distinguish safe Kyokai source, unsafe modules, foreign code, atomics, backend behavior, and target memory-model assumptions. Selective mechanized proof may begin before whole-language mechanization for high-risk surfaces: borrow/linearity core lemmas, atomics/happens-before fragments, backend lowering lemmas, unsafe stdlib kernels, and target ABI contracts. Each mechanized artifact names theorem scope, proof assistant, artifact path, theorem names, trusted base, assumptions, and excluded features.

### D313: Syntax Closure And Body-Only Modules

Kyokai keeps the accepted syntax direction for block terminators, `do`, semicolons, no tuples, `.kyo`/`.kai`, package/module resolution, and receiver-module lookup. Syntax complaints route to rationale, formatter, LSP, examples, interface sync, migration docs, and teaching material, not a syntax redesign.

A `.kyo` interface is required for public/importable interface declarations. A `.kai` body may exist without a paired public `.kyo` when the module is package-private, executable-internal, test-only, or otherwise not exporting a public interface. A body-only module does not publish public declarations into `.koi` except toolchain metadata needed for package/build identity.

Kyokai does not add global ADL, dependency-wide method search, or local import free-for-all. Receiver-module lookup stays narrow. Ceremony reduction happens through body-only/private modules, generated interface sync, formatter, LSP navigation, and examples.

### D315: Adoption Guides And Public Comparison Docs

Kyokai public documentation includes the normative spec plus audience-specific adoption guides. Required adoption material before serious public adoption includes C-to-Kyokai, Rust-to-Kyokai, Zig-to-Kyokai, Austral-to-Kyokai, an FFI cookbook, a capability/security guide, a linear resources guide, a high-concurrency Poller server example, an embedded/freestanding example, package/toolchain workflow docs, and RIIK stdlib design notes.

Comparison docs state where Kyokai is stricter, less ergonomic, more explicit, less mature, or intentionally different from prior art. Austral inheritance is explained inside Kyokai docs so readers do not need to read the Austral spec first. Examples state whether they are accepted, experimental, or aspirational when the implementation is not caught up. Guides link back to spec sections or accepted shape for normative detail.

### D316: Debug, Formatting, Spans, Docs, And Unicode Diagnostics

`debug expr;` uses ordinary `Displayable` formatting resolution. Stable Kyokai has no separate debug-rendering protocol. Adding one requires a new accepted D-point that defines protocol identity, lookup, `.koi` facts, formatting failure, and migration behavior. A missing formatter for `debug` reports a dedicated diagnostic naming `Displayable` and the expression type. `debug` does not consume linear values and obeys debug/profile stripping and purity rules.

`Span[T]` is the standard immutable borrowed view of contiguous elements. `SpanMut[T]` is the standard mutable borrowed view. Their ownership, aliasing, length, and invalidation contracts are normative. Their exact representation is not public ABI unless an ABI contract says so. Display of borrowed views is provided through ordinary library instances when element/display constraints are satisfied.

Documentation comments use one specified CommonMark-like profile with Kyokai code fences and intra-doc links defined by the docs toolchain. Source text is UTF-8, but identifiers remain within Kyokai's accepted ASCII identifier syntax. Non-ASCII identifier characters are rejected with a targeted diagnostic that distinguishes invalid identifier syntax from invalid source encoding. Standard rendering remains deterministic and locale-independent unless an explicit localization API is used.

### D317: Mutex, RwLock, Condvar, And Liveness Tooling

Standard `Mutex[T]` and `RwLock[T]` are non-reentrant. Reentrant locks require a distinct type and accepted D-point. Standard locks do not poison after panic/TPOE. TPOE is fatal, and recoverable poisoning is not Kyokai's default model.

Lock APIs include blocking, try, and deadline/timeout variants when target support exists. Lock guards are linear and must be explicitly consumed by unlock or another specified operation. Condition variables require exact rules for associated lock type, wait atomicity, spurious wake behavior, deadline behavior, and linear guard transfer.

The compiler does not guarantee general deadlock freedom. Tooling may provide best-effort lock-order, wait-graph, channel-graph, taskgroup, runtime trace, and liveness diagnostics. Such diagnostics are tooling facts unless a specific API contract says a deadlock condition is detected and reported at runtime.

### D318: Generic Variance, Nested Inference, And Closure Storage

User generic type constructors remain invariant. Only spec-named built-in borrow/view types get region-shortening coercions, and only when shortening cannot create mutation, lifetime, or linearity holes. Users cannot declare arbitrary variance annotations.

Nested generic inference follows the forward-only inference model: inference proceeds from explicit arguments, receiver/parameter positions, and already-known expected types only in the allowed direction. The compiler does not solve arbitrary global constraints. Diagnostics identify the generic parameter and expression that failed to provide the needed type or region information.

Closure literals have explicit capture lists and local storage by default. Converting a closure to an escaping/owning callable that requires heap or arena storage uses an explicit storage/allocator API and returns allocation failure explicitly. Closure environment layout is not public ABI unless a callable/FFI contract says so.

### D319: Proof Tooling Without Dependent Source Semantics

Kyokai rejects algebraic effect handlers, dependent types, arbitrary refinement types, finite range types, and user proof sections as core source-language features. Capabilities remain the built-in authority/effect boundary. Const generics remain compile-time values, not propositions.

Tooling may prove bounds, discharge checks, produce proof reports, guide optimization, and surface LSP facts. Those results do not change whether source type-checks. Stable Kyokai has no proof-result source-semantics lane and no profile where failure to prove changes source validity. Adding either surface requires a new accepted D-point that defines the exact proof artifact, trusted base, source rule, profile interaction, diagnostics, and fallback behavior. Under the accepted shape, failure to prove remains a tooling or optimization failure, not a source-language type error.

### D320: Examples, Local Install, CLI Extensions, And Migrations

Manifests declare examples as first-class package targets with names, roots, required features, supported profiles, supported targets, and docs visibility. `kyokai run --example <name>` builds and runs a selected example through ordinary package/profile/target rules.

`kyokai install --path <path>` installs executable targets into an explicit prefix or configured user tool directory and records package identity, source provenance, compiler compatibility class, target, profile, and features.

Kyokai supports external developer CLI extensions through executable discovery: unknown safe extension commands resolve to `kyokai-<name>` only from configured tool directories or `PATH` according to documented precedence. Built-in commands always win over external extensions unless the user explicitly invokes an extension namespace such as `kyokai ext <name>`. External extensions cannot shadow security-sensitive built-ins such as `build`, `check`, `test`, `publish`, `vendor`, `audit`, or `fix`.

External extensions never receive hidden project authority. The toolchain passes explicit args, a current workspace metadata path or JSON via stdin when requested, and declared capability/env access. Extensions that mutate manifests, lockfiles, source, cache, or output trees must run through declared command classes and audit/report their changes. `kyokai help <extension>` delegates help to the extension in a specified way. `kyokai extension list` reports discovered extensions, paths, trust source, and version/provenance when available.

`kyokai migrate --edition <edition>` produces a plan/diff first and writes only with an explicit write flag. Human-judgment migrations are reported as blockers, not guessed rewrites.

### D321: Structured Platform Contract Schema

Every supported target has a structured platform contract record. The record includes target triple, `Arch`, `Os`, `Abi`, libc/environment, support tier, pointer width, endianness, alignment/data-layout facts, calling conventions, object format, linker model, stack/guard behavior, atomic support, thread support, panic/fatal behavior, startup model, runtime requirements, and backend compatibility.

The record includes stdlib availability and platform behavior for IO, filesystem paths, env/args, process, time, random, networking, signals/console control, dynamic loading, WASI/host resources, and capability mappings. It also includes runtime hook ABI names such as `fatalHandler`: symbol name, calling convention, argument layout, return behavior, and whether returning is illegal.

The compiler, package manager, docs, Analysis Server/LSP, FFI checks, and stdlib admission consume the same target contract data. Unknown, unsupported, missing, or contradictory fields are build errors when required by the selected target/profile/API.

---

## Accepted Shape Routing Record: D322-D340

This cluster records accepted rules for unsafe contract grammar, `bitrecord` parsing, arena APIs, property generation, TLS, cancellation, backtraces, stable ABI, rich formatting, beginner scaffolds, workspace discovery, external tool diagnostics, asset embedding, builtin formatting lookup, UFCS receiver exports, `Auto` classification, closed `Never` lifting, and pattern legality. The normative chapters named in the maturity tracker carry the extracted contracts.

### D322: Unsafe Contract Grammar And Audit Coverage

Unsafe contracts are structured source declarations, not comments and not detached audit files. A module marked unsafe must contain at least one body-level declaration of the form `unsafe contract Name is ... audit;`. The contract body contains one or more coverage entries. Each coverage entry names a compiler-produced unsafe operation key and then states the safety facts for that operation in structured fields.

The compiler produces operation keys during parsing and elaboration for every unsafe facility used by the module. Operation key classes include foreign declaration, foreign call wrapper, callback registration, raw pointer read, raw pointer write, raw pointer-to-borrow conversion, volatile access, inline assembly block, dynamic library open, dynamic symbol lookup, raw signal handler, trusted capability acquisition, layout reinterpretation, target-specific intrinsic, and every unsafe primitive accepted by a closed D-point after D322. A key includes enough stable identity for diagnostics and audit output: operation class, source span, declaration or expression identity, target guard when present, and public wrapper exposure when present.

A `covers` entry must bind one operation key or an explicitly declared module-wide invariant. The entry's field vocabulary is closed. Accepted fields are `assumes`, `requires`, `preserves`, `forbids`, `maps_failure`, `owns`, `borrows`, `transfers`, `target`, `threading`, `lifetime`, `layout`, `reentrancy`, `cleanup`, `exports`, and `evidence`. Fields that do not apply are omitted. Free prose is allowed inside field values, but the field name itself must be known to the grammar and emitted in audit output. The `evidence` field accepts proof or verification material such as a `lambda_K` lemma, target ABI document, property/fuzz test suite, sanitizer run, model-checker result, or external standard reference. Evidence strengthens audit status but is not required for ordinary FFI.

The compiler rejects an unsafe operation with no matching coverage entry. The compiler rejects a coverage entry whose operation key matches no unsafe operation unless the entry is explicitly marked `module_invariant`. Multiple entries are allowed to cover one operation only when their coverage classes are disjoint or when an entry is explicitly marked `additional_invariant`. Unsafe contracts do not prove safety by themselves and do not weaken Kyokai's no-language-UB rule; they make the trusted boundary visible, structured, reviewable, and machine-discoverable.

Audit tooling groups reports by module, operation key, source span, contract name, target guard, safe wrapper, public API exposure, evidence status, and stale/missing coverage diagnostics. `.koi` records public unsafe/audit summaries for exported APIs that depend on unsafe contracts.

Rejected shapes: Kyokai does not accept prose-only safety comments as sufficient coverage, does not move primary unsafe contracts to external TOML/YAML files, and does not require full formal proof for every unsafe module.

### D323: `bitrecord` Grammar And Bit Access Semantics

`bitrecord` uses declaration syntax because it defines a nominal value type. Its terminator is `build;`, the same semantic terminator family used for type-building declarations such as records and unions. Kyokai does not add a special `bits;` terminator because the terminator marks declaration category, not low-level flavor.

The syntax is `bitrecord Name: Backing is ... build;`. `Backing` must be an unsigned fixed-width integer type accepted for the selected target, initially `Nat8`, `Nat16`, `Nat32`, `Nat64`, and any accepted wider unsigned fixed-width integer type. A `bitrecord` item is one of `field name: bit N;`, `field name: bits Hi..Lo;`, or `reserved bits Hi..Lo;`. Bit numbers are zero-based from the least-significant bit. Alternate bit numbering is rejected by this decision. Ranges are inclusive and must satisfy `Hi >= Lo` and `Hi < bit_width(Backing)`.

Field and reserved ranges must not overlap. A bit position not covered by a field or reserved declaration is a diagnostic in strict profiles and a formatter/lint finding in profiles that allow incomplete reserved masks. A single-bit field has type `Bool` unless the declaration explicitly requests a one-bit unsigned view type admitted by the integer rules. A multi-bit field has the smallest unsigned integer view that can represent the range width unless it declares an explicit unsigned view type of matching width.

Construction, field read, and field update lower to masks, shifts, and checked range operations. They never lower to C bitfields and never inherit C bitfield layout behavior. Bitrecord fields have no address and no borrow semantics. Taking `&value.field` or `&!value.field` is illegal. A `bitrecord` value has exactly the storage and alignment of its backing integer unless a separate ABI contract says the type is only a logical view.

`toBits(value)` returns the exact backing integer. `fromBits(bits)` preserves the backing integer exactly and does not validate reserved bits unless a named constructor or contract chooses to reject nonzero reserved bits. Endianness is not part of bit numbering. Serializing a `bitrecord` across byte boundaries uses the backing integer plus explicit endian conversion helpers.

Rejected shapes: Kyokai does not model bit fields with ordinary records plus annotations, does not use C bitfields, and does not require raw integer helper code for all register/protocol work.

### D324: Arena API, Region Coupling, And Bulk Reset

`Arena` is a first-class linear scoped allocation type, but it is not an ordinary `Allocator`. Ordinary allocators promise individually deallocatable storage. Arenas promise bulk lifetime management tied to a region. Treating an arena as an ordinary allocator is rejected because it lies about individual deallocation and makes escape bugs look like normal container use.

An `Arena` is constructed fallibly from an explicit parent allocator, platform allocation source, or target-provided allocation capability. Construction records parent identity, chunk policy, alignment policy, maximum growth policy when present, selected target constraints, and profile constraints. Arena allocation failure returns `AllocError`; it is not TPOE by default.

Safe arena allocation occurs only through an explicit borrow of the arena. Values produced by that allocation are arena-region-bound. The type of an arena-derived borrow or handle records that it cannot outlive the arena borrow region and cannot outlive the arena itself. Arena-backed values cannot be returned, stored in ordinary owning containers, sent to another task, or written into `.koi`-visible public state unless the API type exposes the required region relationship and the checker proves non-escape.

`reset` either consumes the arena or requires an exclusive mutable borrow of the arena and is legal only when no live arena-derived borrow or arena-owned handle exists. `destroy` consumes the arena and releases all arena storage; it is legal only when no safe references can remain live. The checker must reject reset/destroy while arena-derived values remain live. Diagnostics name the allocation site, the live derived value, and the reset/destroy attempt.

Arena-backed containers have separate admission records. Each arena-backed container states whether elements are bulk-abandoned, individually cleaned, or forbidden when `Linear`. A container that can hold `Linear` elements must provide an explicit cleanup strategy before arena reset or destroy can be safe. Ordinary `Buffer[T]`, `String`, and other individually deallocating containers do not silently accept `Arena` as an ordinary allocator.

Public APIs returning arena-region-bound values record that region dependency in `.koi` so downstream packages can check non-escape. Unsafe internals that implement arena chunks, raw storage, alignment, or partial initialization require unsafe contracts under D322.

### D325: Property Generators, Shrinking, And Fuzz Composition

Kyokai property testing has a typed library surface and a toolchain replay contract. `Gen[T]` is a deterministic generator value parameterized by an explicit seed stream and size/config record. `Shrink[T]` is a deterministic shrink relation or iterator that yields smaller or simpler candidate values for a failing `T`. Generator and shrinker behavior is deterministic for the same compiler compatibility class, package version, target-independent generator implementation, seed, size policy, and generator configuration.

A property test names its generators, shrinkers when not default, sample count, size policy, seed policy, target/profile/backend when relevant, and replay artifact path. A failing property records initial seed, generated value path, shrink path, minimized value when found, source span, target/profile/backend, dependency versions, and the exact replay command. A replay artifact is ordinary checked test input, not hidden global state.

The standard library provides built-in generator and shrinker instances for primitive integers, floats, `Bool`, `String`, `ByteBuf`/bytes, `Optional`, `Result`, arrays, spans through owned backing data, and admitted common collections. User generators are ordinary values. Their only allocation path is an explicit allocator/config API, and allocation failure is reported through the testing API rather than silently aborting.

Property testing and coverage-guided fuzzing are different engines. They share replay metadata, corpus promotion rules, minimization reporting, and failure artifact format. Structure-aware fuzzing uses an explicit `decodeFuzzInput(bytes) -> Result[T, DecodeError]` bridge before running a property over `T`. Coverage instrumentation never changes language semantics, ownership checking, `.koi`, diagnostics meaning, or whether a program type-checks.

Corpus promotion turns minimized property/fuzz failures into checked regression artifacts. RIIK/std-lib admission records state whether property/fuzz evidence is required for a module, and the presence of property tests never weakens the required language or unsafe-contract rules.

### D326: Thread-Local Storage And `TlsCapability`

Safe thread-local storage is a standard-library API, not a module-level declaration form and not ambient mutable global state. Creating a TLS key requires `TlsCapability` or a narrower derived capability. A target that does not declare TLS support rejects imports or uses of safe TLS APIs for that target.

`ThreadLocalKey[T]` is a handle to per-thread slots. The key handle itself is `Free` only when its representation carries no owned per-thread value. The stored per-thread values are owned by their thread-local slots. Storing a `Linear` value transfers ownership into the current thread's slot. Taking a value transfers ownership back out. Borrowing a stored value creates an ordinary borrow whose lifetime is bounded by the access operation and current thread.

The API surface includes `createKey`, `set`, `getBorrow`, `getBorrowMut` where exclusive access can be proven, `take`, `clear`, and `destroyKey` or exact equivalents. `getBorrowMut` is legal only when the TLS implementation can guarantee exclusive access for the current thread and no nested borrow is live. Recursive initialization, nested access, and destructor reentry are specified diagnostics or runtime errors according to the API contract; they are not left to platform folklore.

Destroying a key requires all per-thread slots to be empty, or it requires a `Cleanable[T]` cleanup contract and a specified runtime model for enumerating and cleaning slots. Thread exit behavior is explicit: stored values are taken and cleaned with `Cleanable[T]`, rejected at storage time if no cleanup path exists, or abandoned only during runtime-fatal process death where no continuation can observe the leak.

TLS values do not cross task/thread boundaries unless the API explicitly moves them and `T` satisfies the accepted task-transfer rules. TLS use appears in audit, docs, and Analysis Server/LSP output as ambient-looking state backed by explicit `TlsCapability` authority. Kyokai rejects safe `thread_local var` syntax and rejects macro-defined TLS globals.

### D327: Cancellation Source, Token, And Blocking Integration

Cancellation is cooperative. Kyokai does not kill OS threads, inject exceptions, unwind foreign frames, or silently interrupt arbitrary blocking calls. Cancellation authority and cancellation observation are separate values.

`CancellationSource` owns the authority to trigger cancellation. `CancellationToken` is the read-only observation handle passed to child tasks, blocking operations, Poller waits, channels, and library APIs that declare cancellation support. `CancellationSource` is the only safe value that can request cancellation for its associated token family. `CancellationToken` is `Free` when represented as a shareable read-only handle and cannot trigger cancellation.

`source.token()` produces observation tokens. `source.cancel()` is idempotent and records the cancelled state with the memory ordering required by the concurrency model. Cancelling wakes admitted cancellable operations associated with the token. A cancelled token remains cancelled. Creating child sources or linked tokens requires an explicit API that states propagation direction, ownership, cleanup, and cycle behavior.

Blocking APIs that accept a token state their cancellation-safety class from D284. A cancellable operation returns `Err(Cancelled)` only at specified cancellation points. If cancellation races with successful completion, the API contract states which result wins and what happens to ownership transfers. Cancellation is an ordinary structured exit for the affected operation and runs normal cleanup promised by that operation. Cancellation is not TPOE, not `panic`, and not runtime-fatal.

Plain blocking APIs without token/deadline variants are allowed to wait indefinitely. They are not magically cancellable. Target-specific cancellation behavior such as POSIX interruption or Windows cancellation is represented through the target contract and the specific API contract.

### D328: Backtrace Type, Capture Policy, And Error Attachment

`Backtrace` is an opaque `Free` standard-library/runtime type. It represents a captured stack trace or a structured reason why capture was unavailable. Capturing a backtrace is best-effort, can be expensive, and can depend on target, profile, debug info, frame-pointer policy, symbol availability, and runtime support. Capture failure is not TPOE.

Backtrace capture policy is controlled by explicit profile, CLI, environment, and target rules. The fatal runtime path, `panic`, TPOE reporting, and structured error APIs attach `Optional[Backtrace]` exactly when that policy says to attach it. A recoverable error carries a backtrace only when the error type or helper API explicitly stores it. Kyokai does not attach backtraces to all errors implicitly.

Rendering a backtrace is tooling/runtime work over an opaque value. Rendering symbolizes frames when debug/source maps are available, shows raw frame addresses when symbols are unavailable, and redacts or truncates according to profile/tool policy. Rendering a backtrace must not affect program semantics. Backtrace values are not stable ABI payloads unless wrapped in a separate stable diagnostic format.

Fatal payloads include fatal kind, diagnostic code, message, source span when available, `Optional[Backtrace]`, target/profile, and runtime phase. Freestanding fatal handlers receive `Optional[Backtrace]` only when the target/runtime contract provides capture support. The toolchain provides visualization, filtering, and source mapping over the captured value, and the runtime still carries the `Backtrace` value before any external tool sees the program.

### D329: Stable ABI Declarations And Kyokai-Native ABI Islands

Kyokai accepts `stable_abi` as an opt-in boundary feature for a constrained set of public layout types. It is not a promise for every public Kyokai type and it is not a freeze on ordinary source/interface evolution. Stable ABI creates deliberate ABI islands for plugins, dynamic loading, shared memory, long-lived binary data, and cross-version native boundaries.

Only layout-eligible public boundary types can be marked `stable_abi`. Eligible shapes include fixed-width integers and floats, stable ABI records with fully public field layout, stable ABI enum/union forms with specified tag layout, and approved pointer/handle forms whose ownership and lifetime contract is explicitly stated. Ineligible shapes include ordinary Kyokai unions with private representation, types containing compiler-private fields, closure/environment types, non-stable generic parameters, raw pointers without ABI contracts, target-dependent layout without target indexing, and values with hidden cleanup semantics.

`.koi` records the full stable ABI contract: type identity, ABI version, size, alignment, field order, field offsets, field types, padding policy when observable, tag layout for stable ABI unions/enums, calling convention when passed across an ABI boundary, endian assumptions when serialized, target constraints, and compatibility class. `.koi diff` treats stable ABI layout changes as breaking unless an explicit compatibility rule proves otherwise. A package cannot publish a stable ABI breaking change as a non-breaking SemVer update without an override record.

Non-`stable_abi` public types use ordinary Kyokai source/interface compatibility and `.koi` checking. They do not gain a stable binary layout promise by being public. Stable ABI does not make unsafe reinterpretation safe. Reading bytes as a stable ABI type still requires validation or an unsafe contract unless the API receives a typed value from a trusted ABI boundary.

This shape lets Kyokai move quickly in ordinary releases while making binary compatibility explicit where it matters. Rust-style "no stable native ABI" is rejected for Kyokai's plugin and long-lived boundary goals. Freezing all public records as stable ABI is also rejected because it would punish normal library evolution and optimization.

### D330: Rich Formatting Through Typed Format Specs

Kyokai keeps the string template language minimal and opinionated. `{}` remains the placeholder language. Expanding the string mini-language with width, radix, alignment, debug, precision, or locale syntax inside strings is rejected.

Rich formatting exists through ordinary typed values. The standard library provides `FormatSpec` and narrower spec records such as integer format, float format, radix, alignment, fill, width, precision, sign policy, alternate form, and equivalent accepted fields. A formatted argument is wrapped explicitly with an API such as `formatWith(value, spec)` or an accepted equivalent. This keeps formatting power in type-checked values instead of stringly syntax.

Formatting specs are `Free` values. Constant specs are validated at comptime. Non-constant specs are validated by ordinary construction APIs and return ordinary errors when construction can fail. Formatting to an owned string requires an explicit allocator and returns allocation failure. Formatting to a writer returns writer errors. No formatting API creates hidden allocation, hidden locale dependency, hidden terminal authority, or hidden I/O capability.

Locale-sensitive formatting is not part of the default formatting surface. Localization requires explicit locale APIs. Debug rendering remains separate from user display through the debug/rendering rules; rich display specs do not become reflection or automatic debug dumping.

### D331: Beginner Scaffolds Without Hidden Authority

Kyokai does not add hidden terminal, environment, allocator, clock, filesystem, network, random, or root authority for beginner examples. The language does not get a teaching dialect, example-only syntax, hidden prelude, or ambient I/O just to shorten hello world.

Beginner ergonomics come from generated real Kyokai code. `kyokai new` provides starter templates such as `cli-basic`, `cli-fallible`, `library`, `systems-tool`, `freestanding`, and target-specific variants when admitted. These templates generate ordinary Kyokai source that receives root authority where appropriate, derives narrower capabilities explicitly, passes allocators explicitly, handles fallible operations explicitly, and surrenders or destroys resources explicitly.

Standard helper functions are allowed to package common authority derivations, but their signatures show every capability, allocator, writer, or target resource they require. Tutorials begin from generated scaffold files and explain the authority values in order. Examples state whether they are accepted by the language, implemented by the current compiler, target-specific, or aspirational implementation work.

This keeps the explicit model intact while removing manual setup noise from the first project. New users see real Kyokai earlier, not a fake easier language that has to be unlearned afterward.

### D332: Workspace Root Discovery And Manifest Precedence

Kyokai workspace discovery is deterministic. Starting from the current working directory, the tool finds the nearest `kyokai.toml`. That manifest is the candidate package manifest unless it declares `[workspace]` and no `[package]`. The tool then walks upward looking for a `kyokai.toml` with `[workspace]`.

An enclosing workspace is active only if its member list includes the candidate package path under normalized path rules. If an enclosing workspace exists but does not list the package, the command reports a detached-package or nested-workspace diagnostic instead of silently choosing whichever manifest is nearest. Nested workspaces are errors unless the command explicitly selects one with `--manifest-path` or `--workspace-root`.

Kyokai allows root package workspaces only when the same manifest contains `[workspace]` and `[package]` and the workspace member rules explicitly include the root package, for example through `members = [".", ...]` or an exact equivalent accepted spelling. A manifest that combines `[workspace]` and `[package]` without making the root package membership explicit is rejected.

`--manifest-path` selects a package or workspace manifest explicitly and disables ambiguous upward guessing except for validation required by the selected manifest. The Analysis Server/LSP uses the same discovery algorithm and reports all active package/workspace roots.

### D333: External Tool Failure Diagnostics And Raw Output Policy

Every external tool invocation has a tool record: tool kind, executable identity, version when known, arguments after redaction, target/profile/backend, working directory, environment policy, input artifacts, output artifacts, and trust source. Tool kinds include C compiler, assembler, linker, archiver, debugger, profiler, target runner, generator, formatter helper, docs helper, package helper, and external CLI extension.

A failed external tool produces a Kyokai diagnostic category such as `backend-c`, `assembler`, `linker`, `archiver`, `debugger`, `profiler`, `runner`, `generator`, or `extension`. If source mapping exists, the primary diagnostic points to Kyokai source and generated C/assembly locations appear as secondary notes. If no source mapping exists, the diagnostic states that the error is external-tool-originated and points to the generated artifact or log path.

Raw stdout/stderr is preserved in a report/log artifact by default. Normal terminal output summarizes the failure. Verbose mode can print raw output inline. JSON diagnostics include external tool kind, exit status or signal, mapped spans, raw log path, generated artifact path, and whether the mapping is exact, approximate, or unavailable.

External raw-output presentation has four modes: `summary`, `inline`, `artifact_only`, and `json_only`. This presentation setting does not change whether raw logs are captured. A separate privacy/redaction mode suppresses or redacts raw-log capture, and diagnostics then state that evidence was intentionally not preserved. External CLI extensions use the same diagnostic wrapper and must label mutations, trust source, and authority requests.

### D334: Rejected Meme Kernels

`defer todo;`, `borrow ambient`, and `speculate { } or_else { }` are rejected as Kyokai source syntax. They do not enter the parser, type checker, or core language semantics.

Release-blocking TODO tracking belongs to toolchain metadata, lints, issue policy, CI gates, or manifest policy. It does not use cleanup syntax and does not affect ownership typing. Parameter-threading pain is addressed by explicit context records, capability bundles, generated scaffolds, LSP assists, and API design. Kyokai does not add implicit dependency injection, dynamic ambient lookup, or hidden call-stack state.

Optimistic execution and rollback belong to explicit library transaction APIs for domains that can actually roll back. A transaction API must represent every consumed value, failure mode, rollback obligation, and cleanup path through ordinary types and contracts. Kyokai does not add general rollback over arbitrary ownership.

### D335: Embedded Asset Builtins

Kyokai accepts two explicit asset embedding builtins: `@embedBytes(path_literal)` and `@embedText(path_literal)`. `@embedFile` is not the accepted final spelling because it does not say whether the result is bytes or validated text.

Both builtins are reserved comptime expression forms, not normal functions and not macros. The lexical grammar reserves `@` only for accepted comptime builtin names. Unknown `@name` forms are parse errors, not user identifiers. The argument must be a compile-time string literal. Dynamic path expressions are rejected.

Paths resolve relative to the package root by default. A path outside the package root is rejected unless a manifest-declared asset root explicitly grants it. Absolute paths are rejected in source packages. `..` segments and symlinks are normalized before root containment checks. Missing files, directories, symlink escapes, unreadable files, invalid text, and non-reproducible metadata produce distinct compile-time diagnostics.

`@embedBytes` returns immutable static bytes and performs no UTF-8 validation. `@embedText` validates UTF-8 at comptime and returns immutable static text according to the accepted text/string view model. Both forms contribute the embedded file digest, normalized path, package identity, and asset-root identity to build identity, incremental cache keys, package hashes, generated provenance, and `.koi` provenance when exposed through public constants. Neither form allocates at runtime.

### D336: Builtin Formatting Forms And Canonical Protocol Identity

`debug expr;` is a statement builtin form. It is not parsed as an identifier call. `format(alloc, template, args...)` is an expression builtin form with call-like syntax. `writeFmt(writer, template, args...)` is builtin-checked for template/argument matching and lowers to an ordinary canonical standard-library writer operation after elaboration.

Template checking uses canonical protocol identities recorded in the standard library and `.koi`, including the canonical `Kyokai.Format.Displayable` identity or its accepted final path. The compiler refers to that canonical identity without importing the unqualified name into user scope. This is compiler knowledge of a standard protocol, not a hidden prelude.

Implementing `Displayable` for a user type still requires importing or qualifying the typeclass under normal import rules. Using `debug`, `format`, or `writeFmt` on a type without an applicable display implementation is a type error whose diagnostic names the canonical protocol and suggests explicit imports only when the user is writing an implementation declaration.

The builtin names `debug`, `panic`, `todo`, `unreachable`, `format`, `writeFmt`, and accepted `@...` forms cannot be shadowed by local variables or imports. No formatting builtin creates hidden allocator, writer, terminal, or I/O authority.

### D337: Receiver-Callable Exports And UFCS Fallback

Receiver-module UFCS fallback remains narrow and explicit. A function is receiver-callable only if its declaration begins with the exact marker `receiver function`. Merely having a first parameter whose type matches the receiver is not enough.

The receiver-callable marker is legal only on exported functions whose first parameter is a borrow or value of the nominal receiver type, or on a built-in receiver family explicitly owned by the declaring module. By default, only the receiver type's defining module is allowed to export receiver-callable functions for that type. Extension methods from arbitrary dependency modules are rejected by this decision because they reopen hidden lookup and coherence problems.

Receiver-callable metadata is emitted into `.koi` with receiver type identity, function identity, first-parameter ownership/borrow mode, visibility, generic constraints, and package/module identity. UFCS resolution order is fixed: ordinary imported or unqualified lookup runs first. If no candidate exists, receiver-module fallback searches only the receiver type's defining module `.koi` receiver-callable exports for that receiver type.

Receiver fallback never searches arbitrary dependency modules, wildcard surfaces, or functions that merely match by first parameter. If fallback finds more than one applicable candidate after type checking, the call is ambiguous and rejected. If ordinary lookup finds a unique type-correct candidate, that candidate wins and fallback is not used. The marker does not change calling convention, ownership, side effects, capabilities, or typeclass selection. It grants dot-call eligibility only.

Kyokai does not add Rust-style `impl` blocks through this decision. Adding that model would require a separate D-point that reopens declaration ownership, coherence, docs, and `.koi` method surfaces.

### D338: `Auto` Classification And Explicit Allocator Dispatch

`Auto` classification is computed structurally after generic substitution. The classifier examines the instantiated declaration's stored fields, variant payloads, captured closure environment fields, and accepted built-in classification rules. An instantiated `Auto` type is `Linear` when any stored component is `Linear`; otherwise it is `Free`.

Const generic and value generic arguments do not directly contribute to `Auto` classification. They affect classification only when they select, size, or otherwise determine stored fields whose type classification is known through accepted rules. No user code, comptime reflection, solver, or arbitrary type-level function runs during classification.

Recursive `Auto` definitions are classified by a monotone fixed point over the declaration strongly connected component after substitution of known generic arguments. If any member requires `Linear`, dependent members become `Linear` through their fields. A cycle whose classification depends on an invalid, unbounded, or not-accepted type-level predicate is rejected with a classifier diagnostic.

The compiler caches classification results per instantiated declaration and records public classification rules or resolved facts in `.koi` so downstream packages do not recompute private implementation details incorrectly. `.koi` exposes enough dependency metadata for checking while respecting visibility of private fields according to the interface rules.

D82 rejects hidden typeclass dictionaries inserted for generic calls. It does not reject explicit runtime dispatch stored inside a named value such as an allocator handle when that handle's type, ownership, layout contract, and call surface are source-visible. Any allocator handle using function pointers, vtables, or equivalent dispatch is documented as explicit dynamic dispatch and must not be smuggled into generic typeclass resolution.

### D339: Closed `Never` Lifting Without General Variance

Kyokai has no general subtyping and no user-declared variance. User-defined generic type constructors are invariant. Kyokai does not add variance annotations or a subtype lattice through `Never`.

`Never` expressions coerce to any expected type only at expression typing sites accepted by the `Never` coercion rules. In addition, Kyokai has a closed intrinsic conversion table for `Never` lifting through accepted standard/built-in constructors. Initial intrinsic conversions are `Optional[Never] -> Optional[T]`, `Result[Never, E] -> Result[T, E]`, and `Result[T, Never] -> Result[T, E]` when the target type is known.

The intrinsic conversion table names constructor identity, parameter slot, source type, target type, ownership preconditions, and elaborated operation. The compiler elaborates each use into an explicit intrinsic conversion node. `.koi` records uses of intrinsic lifting or enough elaborated form for downstream tools to avoid inferring a hidden subtype relation.

Diagnostics call these operations closed `Never` lifting conversions. They must not describe user-defined covariance, general variance, or general subtype conversion. User-defined generic types cannot opt into this rule. Adding such a facility would require a separate D-point that reopens variance/conversion declarations.

This is intentionally a special case. It preserves `or return`, impossible-success/impossible-error ergonomics, and bottom-type usefulness without importing a broad metagame layer into Kyokai's nominal linear type system.

### D340: Pattern Legality And Diagnostics

Kyokai's pattern legality is table-driven. The spec contains a closed legal-pattern table by scrutinee category: union, record, integer, `Bool`, accepted char/text categories, enum-like zero-payload union, and catch-all. A pattern form not admitted for the scrutinee category is a type error, not parser behavior left to implementation choice.

Floating-point literal patterns are illegal. Floating values must be tested with explicit predicates or comparison code that names NaN behavior. This rejects the NaN equality footgun instead of pretending float literal patterns are ordinary structural matches.

`ignore` is a reserved contextual discard token only in pattern position. It does not bind and cannot be shadowed inside a pattern. `ignore` remains legal only where discarding is legal for the matched value. It cannot discard or hide a possibly linear payload. When a matched variant, field, or generic position can contain a `Linear` value, the pattern must bind that value explicitly and the selected arm must consume, move, borrow, or return it under ordinary linearity rules.

For a generic scrutinee `T: Type`, a catch-all pattern is exhaustive only in the syntactic coverage sense. It is legal only when the arm accounts for the possibly linear value. Generic exhaustiveness is conservative: only syntactically catch-all coverage is exhaustive unless a constraint names a concrete closed union family.

A normal identifier in pattern position binds unless the grammar identifies a constructor or qualified constructor. PascalCase names in pattern position are resolved through a fixed namespace order for constructors, types, and modules. If more than one interpretation is plausible or if a constructor is mistyped, diagnostics name the expected namespace and suggest qualification. Qualified constructor patterns use ordinary module qualification and do not trigger UFCS lookup.

---

## Accepted Shape Routing Record: D341-D365

This cluster records accepted rules for range-loop edge cases, split channel/readiness waiting, runtime-fatal payloads, span and dynamic-loading lifetimes, freestanding targets, compiler-owned capabilities, `Result` combinators, borrow-checker tables, expected-type flow, foreign callbacks, manifest generation/audit schema, formatter/migration behavior, channel contracts, memory model, safe `unreachable;`, implicit completion registry rules, container admission, TPOE taxonomy, comptime determinism, typeclass coherence, generator suspension, rendering protocols, allocation failure, `.koi`/KBI schema, and arithmetic contracts. The normative chapters named by each point carry the extracted contracts.

### D341: Range Loop Edge Cases, Inclusive Bounds, And Overflow-Free Iteration

Spec homes: kyokaispec/src/language/10-statements-and-control-flow.md, kyokaispec/src/language/18-built-ins.md.

1. `for i from A to B do Body od;` is an inclusive ascending integer range loop.
2. `A` is evaluated exactly once before `B`. Both bound expressions use normal Kyokai expression semantics, including TPOE for overflow inside the bound expressions themselves.
3. The loop variable type is the expected integer type from context or the smallest admitted integer type that can type both bounds under the literal/defaulting rules. If no single admitted integer type exists, the loop is a type error.
4. Bound values are converted to the loop variable type before iteration begins. A failed conversion is a compile-time diagnostic when statically known and TPOE or typed conversion failure according to the conversion API when runtime-dependent.
5. If `A > B`, the loop executes zero times. This decision accepts no descending syntax.
6. If `A == B`, the body executes exactly once with `i == A`.
7. Before each iteration, the current loop value is already known to be inside `[A, B]`.
8. After the body runs for current value `B`, the loop terminates immediately. The implementation must not compute `B + 1` as part of the source semantics.
9. After the body runs for a current value smaller than `B`, the implementation computes the next value using a checked successor operation whose precondition is `current < B`. Because `current < B`, the successor cannot overflow for a well-typed fixed-width integer range.
10. `break` exits the loop without computing another successor. `continue` proceeds to the same endpoint check that normal fallthrough uses; if current is `B`, it terminates without successor arithmetic.
11. The loop variable is immutable inside the loop body. Stable Kyokai has no mutable-loop-variable form. Taking a borrow of the loop variable follows Kyokai borrow rules and cannot survive the next iteration.
12. `for i from 0 to Index.max do ... od;` is accepted and does not TPOE from hidden loop arithmetic.
13. Any arithmetic written in `Body` still follows D365 checked arithmetic. The range-loop rule does not weaken user-written overflow checks.
14. Step sizes, descending ranges, half-open ranges, and iterator sugar are not accepted by this point. Each requires its own endpoint-before-step rule before it enters Kyokai.
15. Diagnostics for unsupported descending syntax say that D341 accepts inclusive ascending ranges only and suggest explicit `while` when the programmer needs a custom direction.


### D342: select, Readiness Waiting, Fairness Non-Guarantee, And Starvation Diagnostics

Spec homes: kyokaispec/src/language/15-concurrency.md, kyokaispec/src/stdlib/09-concurrency-primitives.md, kyokaispec/src/toolchain/05-diagnostics.md.

1. `select ... pick;` is the channel-selection construct. Its admitted arms are channel send, channel receive, channel close-observation, deadline, cancellation-token observation, and default arms accepted by the channel/concurrency spec.
2. `wait ... wake;` is the readiness-wait construct. Its admitted arms are Poller readiness tokens, timer/deadline tokens, cancellation-token observation, signal/process readiness tokens accepted by target contracts, and default arms accepted by the Poller spec.
3. `select` does not directly wait on raw file descriptors, sockets, OS handles, or Poller backend handles. Such resources must be represented by channel operations or by `wait` readiness tokens.
4. `wait` does not send or receive channel messages directly. Channel endpoints can expose explicit readiness tokens only through a standard adapter whose ownership and close behavior is specified; the adapter does not transfer the message itself.
5. Every admitted arm kind has a table entry naming readiness, ownership transfer point, blocking behavior, cancellation behavior, deadline behavior, close/shutdown behavior, cleanup obligations, and target availability.
6. If exactly one arm is ready, that arm is selected.
7. If multiple arms are ready, Kyokai guarantees no fixed source-order priority unless the programmer selects an explicit biased/fair mode. The default mode does not promise starvation freedom.
8. The selected arm's ownership transfer occurs at the arm-specific transfer point named in the table. An unselected send arm must leave the message owned by the sender; an unselected receive arm must not consume a message.
9. Cancellation and deadline arms are readiness arms. If they win, the operation returns the typed cancellation/deadline result named by the construct, not `panic`, not TPOE, and not hidden unwinding.
10. Target contracts record Poller backend behavior such as edge-triggered or level-triggered readiness, descriptor classes, signal wake support, and spurious wake policy. Target contracts cannot weaken Kyokai ownership transfer rules.
11. LSP/lints warn on obvious starvation patterns such as fixed biased loops with always-ready arms. The warning is advisory and never changes semantics.
12. `select` and `wait` lower to separate elaboration nodes so the Analysis Server can explain channel choice separately from external readiness waiting.


### D343: Runtime-Fatal Surface: Backtrace Policy, Stack Size, ExitCode, And Fatal Hooks

Spec homes: kyokaispec/src/language/13-contracts-and-runtime-failure.md, kyokaispec/src/language/18-built-ins.md, kyokaispec/src/toolchain/04-build-profiles-targets-linking.md.

1. Kyokai defines four terminal categories: normal exit, explicit `panic`, TPOE contract violation, and runtime-fatal/internal failure.
2. Normal hosted program termination returns `ExitCode`. `ExitCode` is a public standard type with a portable success value, a portable failure value, and target-specific integer mapping recorded in the target contract.
3. Hosted `main` signatures are a closed accepted set. The initial accepted set is `main(root: RootCapability): ExitCode` and any already accepted fallible startup shape recorded by the startup D-points. Other signatures are diagnostics.
4. `panic` is explicit programmer-requested abnormal termination. TPOE is a contract-violation termination. Runtime-fatal is runtime/toolchain support failure such as stack overflow, fatal allocation during an unreturnable runtime path, corrupted runtime invariant, or target fatal hook failure.
5. Backtrace capture policy is resolved in this order: explicit CLI flag, profile setting, environment variable only when the selected profile permits runtime environment override, then target default.
6. The accepted public control names are CLI `--backtrace=<off|short|full>`, profile key `panic_backtrace = "off"|"short"|"full"`, and hosted environment variable `KYOKAI_BACKTRACE=0|1|short|full` when environment override is enabled.
7. A reproducible profile disables environment backtrace override by default. In that profile, `KYOKAI_BACKTRACE` is ignored and diagnostics say the profile rejected runtime override.
8. Fatal payloads include terminal category, diagnostic code, message, source span when available, `Optional[Backtrace]`, target triple, profile, backend, runtime phase, and exit mapping when hosted.
9. Stack overflow is runtime-fatal. Hosted target contracts state the detection class: guard page, stack probes, explicit bounds checks, OS signal/trap mediation, or unavailable. Freestanding target contracts state the same in freestanding terms.
10. Default main stack assumption, task stack default, minimum stack, maximum configured stack, guard size, and overflow action are target/profile fields.
11. `spawn` stack configuration is available only on targets whose target contract exposes configurable task stacks. A bad stack-size request returns a typed spawn/config error; it is never silently rounded into a different request.
12. Freestanding fatal hooks are non-returning. Their ABI receives terminal category, diagnostic code, payload pointer/length or static message pointer/length, `Optional[Backtrace]` when supported, and target/runtime context allowed by the target contract.
13. Fatal hooks cannot allocate or perform capability-requiring I/O unless those capabilities are passed explicitly or the target contract declares a fixed runtime sink such as a board debug UART.
14. Returning from a fatal hook is runtime-fatal escalation on hosted targets and trap/halt/reset according to freestanding target contract.
15. Tooling reports all configured fatal/backtrace/stack fields through `kyokai doctor --target` and profile inspection.


### D344: Span, SpanMut, Buffer Views, Dynamic Loading Handles, And Symbol Lifetimes

Spec homes: kyokaispec/src/stdlib/04-text-bytes-paths-and-strings.md, kyokaispec/src/language/16-unsafe-ffi-and-abi.md, kyokaispec/src/stdlib/08-io-files-env-process-time-random.md.

1. `Span[T, R]` is the canonical read-only borrowed contiguous view of initialized elements of type `T` in region `R`. The anonymous spelling `Span[T]` uses the same anonymous-region rule as other common borrows.
2. `SpanMut[T, R]` is the canonical exclusive mutable borrowed contiguous view of initialized storage or explicitly declared initialization-capable storage in region `R`.
3. A span value contains view identity, base address, length, element type identity, mutability, initialization state, and region dependency. Source code observes it through safe APIs, not by reading raw fields.
4. `Span` and `SpanMut` descriptors are `Free` only as non-owning borrow descriptors. Copying a descriptor does not copy elements, does not extend the region, and does not weaken aliasing rules.
5. `Span[T]` allows shared reads. `SpanMut[T]` allows exclusive mutation. `SpanMut[T]` can be temporarily reborrowed as `Span[T]` under the accepted mutable-to-shared reborrow rule.
6. Bounds-checked indexing of spans is TPOE on out-of-bounds unless an API returns a checked `Optional`/`Result` view.
7. Viewing `Linear` elements never copies, clones, drops, or destroys them. APIs over `Span[LinearT]` must state whether they only observe, move out, initialize, overwrite, or consume elements. A generic span API that cannot satisfy linearity for `T: Type` must constrain `T: Free` or expose the linear operation explicitly.
8. `SpanMut` over possibly-uninitialized storage is not the same type as `SpanMut[T]` over initialized `T`. Initialization-capable views use a separate admitted type or state marker and cannot be read until initialized.
9. Public APIs returning spans record the region dependency in `.koi`. A span cannot be stored into a longer-lived owner, returned without its region relationship, or sent to another task unless its source region and task-transfer rules permit it.
10. `DynLibrary` is a `Linear` handle acquired through a dynamic-loading capability and target contract. `openDynLibrary` returns `Result[DynLibrary, DynLoadError]`.
11. `DynLibrary` is target-gated. On targets without dynamic loading, importing the API is a compile-time target-contract error.
12. `lookupSymbol(lib: &[DynLibrary, R], name: Span[Nat8, R2])` returns an untyped `Symbol[R]` whose lifetime is tied to the borrow of `lib`. The symbol cannot outlive the borrowed library handle.
13. `closeDynLibrary(lib: DynLibrary)` consumes the library and is legal only when no safe `Symbol` or typed wrapper borrowed from it remains live.
14. Converting `Symbol[R]` to a typed callable value is unsafe unless a wrapper contract proves symbol name, calling convention, argument layout, return layout, ownership transfer, thread-safety, reentrancy, lifetime, and failure behavior.
15. A typed dynamic symbol wrapper that escapes the library borrow must own or share a `DynLibrary` lifetime handle explicitly; safe code never gets a bare function pointer detached from the library lifetime.
16. `.koi` records public dynamic-loading APIs, stable ABI dependencies, unsafe audit summaries, target guards, and symbol wrapper contracts.


### D345: Freestanding Target Contract, Runtime Shims, Interrupt Boundaries, And No-OS Capability Surface

Spec homes: kyokaispec/src/toolchain/04-build-profiles-targets-linking.md, kyokaispec/src/language/13-contracts-and-runtime-failure.md, kyokaispec/src/language/16-unsafe-ffi-and-abi.md.

1. A target contract with `hosted = false` is freestanding. It must name architecture, ABI, object format, linker model, startup symbol, entry signature, stack model, fatal action, atomic availability, volatile/MMIO policy, interrupt support, allocator availability, and runtime helper requirements.
2. Freestanding targets provide no filesystem, environment, process, terminal, networking, wall clock, dynamic loading, random source, or heap capability by default.
3. `RootCapability` on freestanding is target-defined. It can be absent, board-supplied, split into sealed hardware capabilities, or provided by a runtime package. The compiler enforces the chosen entry signature from the target contract.
4. Heap allocation is unavailable unless the program imports or defines an allocator accepted for the target. Standard APIs requiring allocation are unavailable until an allocator is passed explicitly.
5. Startup code is explicit. The toolchain records whether startup is supplied by Kyokai runtime, board package, user object file, linker script, or external boot environment.
6. Interrupt handlers are not normal functions. They require an accepted interrupt ABI wrapper with target contract fields for register save/restore, nesting, reentrancy, stack selection, allowed calls, allocation policy, blocking policy, panic/TPOE action, and capability access.
7. Safe interrupt handler bodies cannot allocate, block, acquire root authority, take non-interrupt-safe locks, or call APIs lacking interrupt-safety admission.
8. Volatile/MMIO access is unsafe or capability-gated and requires D322 unsafe contracts naming address range, width, alignment, ordering, side effects, and target device contract.
9. Atomics are available only for widths/orderings declared by the target. Unsupported atomic operations are compile-time target errors, not runtime fallbacks that change memory semantics.
10. Stack overflow detection can be guard-page, probe, explicit check, hardware trap, or unavailable. The target contract states which. When detection is unavailable, safe source still cannot rely on backend undefined behavior; the target is marked with that diagnostic limitation.
11. Freestanding fatal action is one of trap, halt, reset, call non-returning hook, or target-specific action recorded in the target contract.
12. Hosted-only stdlib modules are compile-time errors on freestanding. Freestanding-compatible modules carry admission records saying which target capabilities they require.
13. Conformance for freestanding can be compile-only, emulator-backed, simulator-backed, hardware-backed, or proof/audit-backed. Each target tier records which evidence class it has.
14. `kyokai doctor --target` prints the freestanding contract and refuses to call it hosted-compatible.


### D346: Root Capability Derivation, Splitting, Surrender, And Authority API Surface

Spec homes: kyokaispec/src/language/14-capabilities-and-authority.md, kyokaispec/src/stdlib/08-io-files-env-process-time-random.md.

1. A `capability` declaration is a compiler-recognized sealed nominal `Linear` type. Its constructors are not user-callable unless declared as capability derivation functions in the defining module and accepted by the compiler's capability rules.
2. `RootCapability` is available only through accepted startup entry signatures. User source cannot construct, clone, default-initialize, deserialize, embed, reflect, or transmute a root capability in safe code.
3. Capability derivation is an explicit function or method declared by the capability-owning module. The signature states whether it borrows, mutably borrows, or consumes the stronger capability and what weaker capability it returns.
4. Deriving a weaker capability never grants authority not present in the stronger capability. It can narrow path roots, network address ranges, environment variable names, process-spawn rights, dynamic-loading rights, random-source rights, clock rights, or target/device ranges.
5. Splitting root authority uses explicit derivation APIs. Repeated derivation from a borrowed root is allowed only for capabilities whose declaration says the operation is duplicable in authority but not duplicating a linear resource. Otherwise derivation consumes or mutably borrows according to its signature.
6. `surrender`, `close`, `destroy`, or a domain-specific consuming operation ends a capability value's authority according to its contract. Linear checking enforces exactly-once consumption.
7. Capability values can be borrowed to perform operations without surrendering authority. Borrowing does not clone authority and cannot outlive the capability value.
8. Capability values are `task_transfer` only when their declaration or target contract says the underlying authority can safely move across tasks. Task-local OS handles remain task-local.
9. Unsafe code cannot forge a capability from raw bits. Unsafe internals of the capability-owning module can construct capability representations only under D322 unsafe contracts and only for the authority surface that module owns.
10. The standard library contains modules such as filesystem, terminal, environment, process, network, clock, random, dynamic loading, and target/device authority. Those modules use compiler-recognized capability declarations; they do not define the capability system itself.
11. `.koi` records capability declarations, derivation signatures, attenuation relationships, task-transfer classification, target guards, and public APIs requiring each capability.
12. Capability docs and audit output show the authority graph as a compiler/tool projection. The graph is explanatory; source semantics are the declared sealed types and explicit functions.


### D347: Result Combinators, Callable Ownership, Error Sources, And Ignored-Result Interaction

Spec homes: kyokaispec/src/stdlib/02-core-result-optional-display-error.md, kyokaispec/src/language/09-expressions-and-evaluation.md.

1. `Result[T, E]` is the standard recoverable-error carrier for operations that can succeed with `T` or fail with `E`.
2. `Result` is `must_use` by default. Ignoring a `Result` is a diagnostic unless the value is explicitly consumed by `discardResult`, matched, returned, propagated, logged through an accepted API that consumes it, or otherwise handled by a named operation.
3. Core combinators include `isOk`, `isErr`, `ok`, `err`, `map`, `mapErr`, `andThen`, `orElse`, `unwrapOr`, `unwrapOrElse`, `inspect`, and `inspectErr` or accepted final names.
4. A combinator that applies a callable states whether the callable is borrowed, consumed once, or stored. The default callable argument for `map`/`andThen` is consumed exactly once only on the branch where it is invoked.
5. If a callable captures `Linear` values, branch-sensitive linearity rules decide whether the capture is consumed, returned, or remains live. A combinator cannot silently drop an unused linear capture.
6. `map` transforms `Ok(T)` into `Ok(U)` and leaves `Err(E)` unchanged. `mapErr` transforms `Err(E)` into `Err(F)` and leaves `Ok(T)` unchanged.
7. `andThen` consumes `Ok(T)` through a callable returning `Result[U, E2]` and propagates `Err(E)` according to the declared error conversion or exact error type rule.
8. Error-source/chaining helpers are typed. Kyokai does not use erased exception objects, hidden stack unwinding, or ambient global error state.
9. Formatting a `Result` requires display/debug implementations for the rendered branch and follows D330/D362 allocation/writer failure rules.
10. `.koi` records public `Result` signatures, must-use status, and combinator generic constraints.


### D348: Borrow Checker State Transition Table, Partial Moves, And Linear Diagnostics

Spec homes: kyokaispec/src/language/11-linearity-borrowing-and-regions.md, kyokaispec/src/toolchain/05-diagnostics.md.

1. The checker runs after D238 elaboration and D239 implicit completions. It checks the explicit elaborated form, not unexpanded surface sugar.
2. Each local linear binding has a state: `Live`, `SharedBorrowed(n)`, `MutBorrowed`, `PartiallyMoved(field-set)`, `Moved`, `Consumed`, or `PendingLoopConsumption`.
3. `Live` means the whole value is available for move, borrow, field projection, or final consumption.
4. `SharedBorrowed(n)` means one or more immutable borrows are live. Additional immutable borrows can be created; moving, consuming, mutable borrowing, and mutating the value are illegal.
5. `MutBorrowed` means one exclusive mutable borrow is live. Shared borrowing, another mutable borrow, moving, consuming, and direct mutation outside the borrow are illegal.
6. `PartiallyMoved(field-set)` means one or more fields of a record/variant payload have moved out. The remaining fields keep their own states. The parent value cannot be used as a whole until the moved fields are reinitialized where the type permits reinitialization.
7. `Moved` means ownership has transferred and the binding cannot be used except where a legal reinitialization rule exists.
8. `Consumed` means the value has been passed to a consuming operation, returned, destroyed, surrendered, or otherwise used exactly once.
9. `PendingLoopConsumption` records attempted consumption inside a loop for a value defined outside the loop; the checker rejects unless the loop construct proves exactly-once consumption on every possible iteration/exit path, which plain loop forms do not prove.
10. Borrow creation records source binding, borrow mode, region, source span, and parent projection path when borrowing a field.
11. Borrow end returns the source state to the previous live/partial state only when no derived reborrow remains live.
12. Auto-reborrow inserts temporary borrow states with source spans pointing to the call site and to the accepted implicit completion rule.
13. Pattern matching over linear values must bind or consume every linear payload on every selected arm. A wildcard/`ignore` cannot hide a live linear payload.
14. `defer` and `errdefer` register deferred consuming operations in the control-flow graph. The checker verifies that each deferred path consumes exactly the values it owns and that no path consumes the same value twice.
15. `break`, `continue`, `return`, `panic`, TPOE sites, and `unreachable` are control-flow exits. Every live linear obligation must be consumed, returned, transferred into a registered cleanup path, or proven unreachable according to the terminal category rules.
16. Diagnostics name the binding, current state, previous state-changing span, attempted illegal operation, and suggested legal action when one exists.
17. The Analysis Server exposes these states so users can see moved, borrowed, consumed, and partially moved values directly.


### D349: Literal Inference, Nested Generic Calls, Expected-Type Flow, And Elaboration Order

Spec homes: kyokaispec/src/language/07-generics-and-typeclasses.md, kyokaispec/src/language/09-expressions-and-evaluation.md, kyokaispec/src/language/12-implicit-completions-and-elaboration.md.

1. Kyokai uses local expected-type flow. It does not perform Hindley-Milner inference, global bidirectional inference across declarations, or solver-driven guesswork.
2. Every expression is checked in one of two modes: `synthesize` produces a type from the expression itself; `check(ExpectedType)` checks the expression against a known expected type.
3. Expected type flows from variable annotations, function parameter types, return type annotations, record field declarations, union constructor payload types, array element type/context, typeclass method signatures, explicit generic arguments, and assignment/update targets.
4. Function call checking first resolves the callee identity and any explicit generic arguments. Then argument expressions are checked left-to-right against parameter expected types after generic substitution.
5. Nested generic calls do not let an inner call infer an outer generic by solving backwards through arbitrary return types. If the expected type of the inner expression is known from the outer parameter, it is used; otherwise the inner expression must synthesize a unique type.
6. Integer literals can be checked against an expected integer type. Without expected type, they use the accepted default integer literal rule. Out-of-range literals are compile-time diagnostics.
7. Float literals can be checked against an expected float type. Without expected type, they use the accepted default float literal rule. NaN/Inf literal policy follows D294.
8. `Never` uses D339 closed lifting only after the target expected type is known. It does not create a general subtype relation.
9. Implicit completions run after name resolution and before borrow/linearity checking, in the fixed D238 pipeline. Each inserted completion records its source, target type, and rule ID.
10. Typeclass instance selection occurs only after concrete type arguments and constraints are known enough to choose a unique coherent instance. Ambiguous instance selection is a type error.
11. Expected-type flow never inserts allocation, capability acquisition, blocking, cleanup, or control flow. If an ergonomic operation would need one of those effects, it must be explicit source or an accepted explicit completion with its own D-point.
12. `.koi` records enough generic parameter, constraint, defaulting, and elaboration metadata for downstream package checking to reproduce the same type decisions.
13. Diagnostics show the local expected-type edge that failed: source expression, expected type source, synthesized type when any, and the missing annotation or explicit generic argument needed to continue.


### D350: Foreign Callback Thread Affinity, Reentry, And Capability Transfer

Spec homes: kyokaispec/src/language/16-unsafe-ffi-and-abi.md, kyokaispec/src/language/15-concurrency.md, kyokaispec/src/language/14-capabilities-and-authority.md.

1. A foreign callback registration is an unsafe operation covered by D322.
2. The callback contract states calling convention, argument layout, return layout, lifetime of the registration, unregister operation, thread or executor that can invoke it, reentry policy, panic/TPOE behavior, and ownership transfer rules for every value crossing the boundary.
3. Kyokai values captured by a callback must be `Free`, pinned with an explicit lifetime owner, or moved into a linear registration handle whose cleanup unregisters the callback exactly once.
4. Linear capabilities cannot cross into foreign callback state unless the registration handle owns them and the unsafe contract states when the foreign side can invoke, release, or return authority.
5. A callback invoked on an unknown foreign thread cannot touch task-local Kyokai state, non-thread-transfer values, TLS without target support, or capabilities not declared callback-safe.
6. Reentrant callbacks are rejected by default. A wrapper accepting reentry must state which Kyokai APIs are reentry-safe and how nested borrow/capability access is prevented.
7. Callback panic/TPOE cannot unwind into foreign frames. The wrapper catches no exception; it terminates or reports through the registered fatal/error path according to the callback contract.
8. Unregister consumes the registration handle. It is legal only when no callback invocation is active, or the contract states the synchronization protocol that waits for active invocations.
9. `.koi` records exported callback wrappers, unsafe contract summaries, target guards, and capability/thread-transfer requirements.

Example shape:

unsafe contract PosixSignalRegistration is
  covers raw_signal_handler install_sigint
    assumes "handler is invoked by target signal machinery"
    forbids "allocation, blocking, capability acquisition, non-async-signal-safe calls"
    transfers "no Kyokai Linear value crosses into handler"
    maps_failure "registration failure returns Result error"
  audit;


### D351: Manifest [generate], [audit], Tool Inputs, And Reproducible External Commands

Spec homes: kyokaispec/src/toolchain/01-manifest-package-workspace.md, kyokaispec/src/toolchain/11-build-generation-and-playground.md, kyokaispec/src/toolchain/08-docs-lsp-audit.md.

1. Kyokai has no build-script DSL, no `build.kai` auto-execution, and no package code execution during dependency resolution.
2. `kyokai.toml` contains declarative `[generate]` entries. Each entry has name, command, args, declared inputs, declared outputs, working directory policy, environment policy, target/profile applicability, dependency ordering, and trust/source classification.
3. Commands are external executables or first-party Kyokai tool subcommands. They are not interpreted by a Kyokai-specific scripting language.
4. Inputs can be source files, schema files, asset roots, target contract facts, profile facts, lockfile facts, or generated outputs from earlier declared steps. Undeclared input reads are diagnosed when detected and treated as reproducibility violations.
5. Outputs must live in declared generated directories or declared source-controlled paths. Generated files carry provenance metadata tying them to generator name, command identity, input hashes, output hashes, target/profile, and compiler compatibility class.
6. `[audit]` declares package audit policy: unsafe modules, FFI modules, generated-code trust, external command trust, capability requirements, allowed generated output roots, and required reports.
7. Generator environment is closed by default. Environment variables are passed only when named in the manifest or target/profile contract.
8. Generator failure produces D333 external-tool diagnostics with raw logs captured according to raw-output policy.
9. Generator outputs are checked as real `.kyo`/`.kai`/asset files. They are not hidden compiler expansions.
10. Build identity includes generator command identity, declared inputs, selected target/profile/backend, environment inputs, generator version when known, generated output hashes, and provenance records.
11. `kyokai generate` runs generation explicitly. `kyokai build` runs required generation only when the manifest says generated outputs are build prerequisites and the user/profile policy allows generation.
12. Package publishing rejects undeclared generated outputs, missing provenance, path escapes, or generator dependencies not represented in the lockfile/tool policy.


### D352: Formatter Canonical Style, Terminator-Aware Editing, And kyokai migrate Command Surface

Spec homes: kyokaispec/src/toolchain/03-cli.md, kyokaispec/src/toolchain/06-formatter.md, kyokaispec/src/language/02-lexical-syntax.md.

1. `kyokai fmt` uses the same lexer, parser, concrete syntax tree, comments, doc comments, source spans, and token classification as the compiler front end.
2. Formatting is canonical. Kyokai does not expose broad style knobs for brace placement, keyword case, terminator spelling, indentation family, import grouping philosophy, or expression layout philosophy.
3. Allowed formatter configuration is limited to mechanical environment needs such as max line width, newline style, file include/exclude lists, generated-file policy, and check/write mode.
4. The formatter preserves semantics. Formatting a valid file and then parsing it must produce an equivalent syntax tree and equivalent elaboration inputs.
5. The formatter is terminator-aware: `qed`, `build`, `spec`, `drop`, `seal`, `mon`, `pick`, `join`, `audit`, `fi`, `od`, and accepted final terminators are formatted according to their construct identity.
6. The formatter is comment-aware and doc-comment-aware. It can reflow documentation only under documented doc formatting mode; normal code formatting does not rewrite prose unexpectedly.
7. `kyokai fmt --check` exits nonzero when formatting differs and prints stable diagnostics/paths.
8. `kyokai fmt --write` writes only selected files and refuses to write generated or vendored files unless the command policy allows it.
9. `kyokai migrate --edition E` is a compiler-assisted source migration command. It parses, resolves, and applies only accepted machine-applicable migrations for the selected edition.
10. `kyokai migrate` produces a plan/diff by default. It writes only with an explicit write flag. Human-judgment migrations are reported as blockers.
11. Formatter, migration, diagnostics, LSP fixes, and parser recovery share source edit machinery inside the monorepo so Kyokai does not duplicate style or rewrite logic across tools.
12. External formatter plugins are rejected for canonical Kyokai source. External tools can format generated non-Kyokai assets only through declared tool commands.


### D353: Channel Capacity, Close Semantics, Message Cleanup, And Backpressure Contracts

Spec homes: kyokaispec/src/language/15-concurrency.md, kyokaispec/src/stdlib/09-concurrency-primitives.md.

1. Kyokai's stable channel primitive is SPSC. D436 keeps MPSC, MPMC, and broadcast endpoints out of the core and Tier-1 primitive set; fan-in, fan-out, and pub/sub use explicit broker tasks over SPSC channels.
2. A channel has two linear endpoints: `Sender[T]` and `Receiver[T]`. Endpoint cloning is rejected unless a different channel family explicitly accepts cloneable endpoints.
3. Capacity is explicit at construction: rendezvous capacity `0`, bounded capacity `N`, or a separately admitted fixed/static capacity. Unbounded channels are rejected by this decision.
4. `send(sender, value)` blocks until space/receiver readiness according to the operation contract. On success, ownership of `value` transfers into the channel. On failure or cancellation before transfer, the result returns ownership of `value` to the caller.
5. `trySend(sender, value)` never blocks. It returns success with transferred ownership, or `Err(Full(value))`, `Err(Closed(value))`, or the accepted equivalent preserving ownership.
6. `receive(receiver)` blocks until a value, close/exhaustion, cancellation, or deadline according to the operation contract. On success, ownership of the message transfers to the receiver.
7. `tryReceive(receiver)` never blocks and returns value, empty, closed/exhausted, or equivalent typed result.
8. Closing the sender consumes or mutably changes the sender endpoint according to the API. It prevents new sends and allows the receiver to drain buffered messages.
9. Closing/destroying the receiver requires a cleanup policy for buffered messages. If `T` is `Linear`, the API must either return/drain all messages, consume them through an explicit cleanup function, or reject destruction while messages remain.
10. Dropping either endpoint silently is impossible because endpoints are linear. Endpoint cleanup is a consuming operation.
11. Backpressure is capacity-defined. A full bounded channel blocks `send` or returns `Full(value)` in nonblocking form; it does not allocate hidden extra storage.
12. Cancellation/deadline-aware operations are separate names or explicit parameters. Cancellation points and transfer races follow D327.
13. `select` over channel operations uses D342 channel `select` rules. Unselected send arms retain message ownership.
14. `.koi` records channel endpoint types, capacity family, task-transfer classification, and public APIs exposing channels.
15. Diagnostics for failed linear channel use name endpoint state, message ownership state, close/drain obligation, and failed operation.


### D354: Safe Memory Model, Atomics, Data-Race Definition, And Backend Mapping

Spec homes: kyokaispec/src/language/15-concurrency.md, kyokaispec/src/language/17-memory-layout-and-backend-contract.md, kyokaispec/src/stdlib/09-concurrency-primitives.md.

1. Safe Kyokai code has no data races. A data race is two conflicting accesses to the same memory location from different tasks/threads, at least one write, without a Kyokai happens-before edge or accepted atomic operation.
2. Mutable access requires unique ownership or an exclusive mutable borrow. Such values cannot be shared across tasks unless moved through an accepted transfer mechanism.
3. Shared mutable state requires an accepted synchronization primitive such as `Mutex`, `RwLock`, channel transfer, atomic type, task join, or target-specific primitive with an admission record.
4. Atomic operations are available only through typed atomic values. Supported widths, alignments, and operations are target-contract facts.
5. Memory orderings are a closed enum: `Relaxed`, `Acquire`, `Release`, `AcqRel`, and `SeqCst`, plus any separately accepted target-specific ordering. Invalid ordering/operation combinations are compile-time errors when statically known.
6. Happens-before edges include task start after successful spawn capture, task join completion, channel send-to-receive transfer, mutex unlock-to-lock, rwlock release-to-acquire, release/acquire atomic synchronization, and explicit fences accepted by the atomics API.
7. Safe non-atomic shared mutable access that would race is rejected by type/borrow/task-transfer checking. It does not become backend UB.
8. Unsafe code that performs raw shared mutation must have an unsafe contract naming synchronization, aliasing, provenance, target memory model, and why safe callers cannot observe a race.
9. Backend lowering must preserve Kyokai atomic ordering and synchronization semantics for C and LLVM backends. It cannot weaken orderings, rely on LLVM poison, rely on C undefined behavior, or erase synchronization required by Kyokai semantics.
10. Atomics over non-`Free` or non-bitwise-stable types are rejected unless a separate atomic wrapper contract is accepted.
11. Volatile/MMIO is not synchronization. It has target/device side-effect semantics and requires volatile/MMIO contracts separate from atomics.
12. Conformance includes litmus tests, generated-C/LLVM inspection where practical, sanitizer/thread tests for hosted targets, and target-contract compile tests for unsupported atomic widths.


### D355: unreachable, Optimizer Assumptions, Trap Lowering, And No-UB Backend Contract

Spec homes: kyokaispec/src/language/13-contracts-and-runtime-failure.md, kyokaispec/src/language/17-memory-layout-and-backend-contract.md, kyokaispec/src/language/18-built-ins.md.

1. `unreachable;` is a safe source statement/expression of type `Never`.
2. Reaching `unreachable;` at runtime triggers TPOE with diagnostic kind `UnreachableReached` and the source span.
3. `unreachable;` is not `panic`; it is a contract-violation terminal path because the programmer asserted the path cannot be reached.
4. Safe `unreachable;` never lowers directly to C undefined behavior, LLVM poison, a bare `__builtin_unreachable`, or an optimizer assumption without a preceding non-returning trap/fatal operation.
5. The backend lowering for safe `unreachable;` is `emit_tpoe_unreachable(span/payload); noreturn`. After that non-returning call/trap, the backend is allowed to emit its own unreachable marker only as dead-code marker after control is already terminated.
6. The compiler is allowed to remove an `unreachable;` branch only when its own accepted static analysis proves the branch cannot execute under Kyokai semantics.
7. `todo;` remains panic-category incomplete-code termination. `panic(...)` remains explicit panic. `unreachable;` remains TPOE. All three have type `Never` but different terminal categories.
8. An unsafe optimizer assumption form is not accepted by this D-point. Adding one requires a separate unsafe D-point and cannot affect safe `unreachable;`.
9. Diagnostics and coverage reports distinguish statically unreachable code, source `unreachable;`, and backend dead-code markers.
10. Conformance tests inspect generated C/LLVM for safe `unreachable;` lowering so no accepted safe program depends on backend UB.


### D356: Implicit Completion Registry Closure, Proof Obligations, And Spec Index

Spec homes: kyokaispec/src/language/12-implicit-completions-and-elaboration.md, kyokaispec/src/appendices/b-decision-traceability.md.

1. Kyokai has a closed compiler-maintained implicit completion registry.
2. Each registry entry has an ID, source pattern, required static context, inserted elaboration node, proof/evidence obligation, diagnostics label, `.koi` recording rule, and spec home.
3. Accepted completions include only those already accepted by D-points, such as auto-reborrow, mutable-to-shared temporary reborrow, implicit `Unit` return, accepted `Never` lifting, accepted receiver fallback, and accepted formatting/template completions.
4. A completion is legal only when it is uniquely determined by local static context.
5. A completion cannot introduce hidden allocation, hidden blocking, hidden capability acquisition, hidden cleanup, hidden I/O, hidden thread spawn, hidden dynamic loading, or hidden control flow beyond the explicit accepted elaboration.
6. The checker runs on elaborated nodes so linearity, borrowing, capability, contracts, unsafe, and backend-readiness checks see the inserted operation.
7. The Analysis Server can show every inserted completion with its registry ID and source span.
8. `.koi` records public-interface-affecting completions and enough elaborated form for downstream tools to reproduce compatibility checks.
9. Adding a completion requires a D-point and spec extraction before implementation is accepted.
10. The proof/calculus roadmap lists which completions are modeled in `lambda_K-seq`, which are surface-elaboration lemmas, and which are toolchain-only.


### D357: Stdlib Container API Completeness, Admission Tables, And Unsafe Storage Contracts

Spec homes: kyokaispec/src/stdlib/03-allocators-and-memory-containers.md, kyokaispec/src/stdlib/05-collections.md, kyokaispec/src/stdlib/01-admission-contracts.md.

1. Every stable container has an admission table covering ownership model, allocator use, failure behavior, initialization state, invalidation rules, iteration order, complexity, linear element behavior, concurrency classification, unsafe internals, and `.koi` public API identity.
2. Core container families include `Buffer`, fixed arrays, spans/views, deque/ring buffer, hash map/set, ordered map/set or sorted-buffer equivalent, string/text buffers, byte buffers, and arena-backed variants where accepted.
3. Every operation states whether it reads, moves, copies, initializes, overwrites, swaps, removes, drains, or destroys elements.
4. If `T: Linear`, removal/drain/destruction APIs must return elements, consume them through an explicit cleanup function, or statically reject the operation.
5. Reallocation invalidates spans/borrows/iterators according to a table. Safe code cannot retain invalidated views because borrow rules reject mutation while views are live.
6. Iterator APIs state whether the iterator borrows the container, consumes the container, or owns a snapshot. Linear iterators have exact cleanup obligations on early exit.
7. Allocation failure returns `AllocError` by default. No stable container silently aborts on normal growth failure unless admitted as a named fatal-on-OOM runtime-support path.
8. Unsafe storage internals are isolated behind small modules with D322 unsafe contracts for raw allocation, initializedness, pointer arithmetic, aliasing, movement, and partial cleanup.
9. Hash containers state hash algorithm policy, seed policy, determinism guarantees, DoS-resistance claims, iteration-order contract, and compatibility behavior.
10. Sorting/search APIs state stability, comparator contract, failure behavior, and behavior when comparator violates ordering requirements.
11. Container docs and LSP expose invalidation and linear cleanup rules directly.


### D358: TPOE Taxonomy, Trap Payloads, Runtime-Fatal Split, And Diagnostic Contract

Spec homes: kyokaispec/src/language/13-contracts-and-runtime-failure.md, kyokaispec/src/toolchain/05-diagnostics.md.

1. TPOE is the terminal category for contract violations in accepted safe Kyokai code.
2. Initial TPOE kinds include arithmetic overflow, division by zero, invalid shift count, bounds failure, failed `require`, failed `ensure`, failed `static_assert` during comptime, reached `unreachable`, invalid enum/tag observation detected by safe checks, and other accepted contract failures.
3. `panic` is a separate explicit abnormal termination category used by `panic` and `todo`.
4. Runtime-fatal is a separate internal/runtime/toolchain support category used for stack overflow, fatal runtime allocation where no return path exists, corrupted runtime invariant, fatal hook failure, and target fatal actions.
5. Recoverable failures use `Result`/`Optional`/domain result types and do not terminate by default.
6. TPOE payloads include kind, diagnostic code, message, source span, `Optional[Backtrace]` according to D328/D343, target/profile/backend, and runtime phase.
7. TPOE is not catchable inside the process and does not run user cleanup. The execution context is dead.
8. Linear resources can be abandoned only because the process/task context is terminating and no valid continuation can observe the abandonment.
9. Generated code must lower TPOE to a non-returning runtime path or target trap that preserves diagnostic payload as far as the target contract allows.
10. Freestanding targets state their TPOE action: trap, halt, reset, fatal hook, or target-specific action.
11. Diagnostics and docs must not call TPOE an exception, unwind, recoverable error, or panic unless the terminal category is actually `panic`.


### D359: Comptime Evaluation Semantics, Traps, Panics, Const Generics, And Determinism

Spec homes: kyokaispec/src/language/05-declarations.md, kyokaispec/src/language/09-expressions-and-evaluation.md, kyokaispec/src/toolchain/11-build-generation-and-playground.md.

1. Comptime evaluation is deterministic evaluation of accepted pure expression forms under D18/D202/D203 limits.
2. Comptime can evaluate literals, constants, pure arithmetic, pure boolean logic, pure constructors for comptime-admitted values, `static_assert`, target/profile/edition/feature facts, size/alignment/layout facts, and accepted asset embedding builtins.
3. Comptime cannot perform ambient filesystem reads except `@embedBytes`/`@embedText`, network access, process spawning, environment reads, wall-clock reads, randomness, root-capability acquisition, dynamic loading, thread spawning, blocking I/O, or unsafe operations not explicitly accepted for comptime.
4. Comptime cannot generate declarations, types, modules, syntax, typeclass instances, or `.koi` items. Generated code belongs to `[generate]`.
5. A comptime expression that would TPOE at runtime becomes a compile-time diagnostic with TPOE kind and source span.
6. `panic` during comptime is a compile-time diagnostic in the panic category. It does not run host unwinding into the compiler.
7. `unreachable;` reached during comptime is a compile-time TPOE diagnostic.
8. Const generic values must be comptime-evaluable, serializable into `.koi`, deterministic across hosts for the same target/profile/compiler compatibility class, and independent of host-local paths except normalized asset provenance.
9. Floating comptime evaluation follows the target-independent compile-time float rules accepted for Kyokai, or is rejected when a value would depend on target floating environment not modeled by the language.
10. Comptime budgets include step count, recursion depth, memory budget, and embedded asset byte budget. Exceeding a budget is a compile-time diagnostic, not silent fallback to runtime.
11. `.koi` records const generic values, target dependencies, comptime diagnostics that affect public interface, and asset provenance that affects public constants.


### D360: Typeclass Coherence Edge Cases, Generic Overlap, Unsafe Instances, And Link-Time Rejection

Spec homes: kyokaispec/src/language/07-generics-and-typeclasses.md, kyokaispec/src/toolchain/02-module-resolution-and-koi.md.

1. A typeclass instance identity is `(typeclass identity, receiver/concrete type identity or generic head, generic parameter pattern, constraint set, package identity, module identity)`.
2. Instance selection is coherent: for any fully known call site, at most one instance can apply.
3. Two instances overlap if there exists a substitution satisfying both instance heads and both constraint sets for the same typeclass target.
4. Overlap is rejected even if the current package has no call site that uses the overlapping substitution.
5. Constraint implication is conservative. If the compiler cannot prove two instances disjoint using accepted constraint forms, the instances overlap.
6. Orphan rules decide which package or module is allowed to declare an instance. Coherence rules decide whether the package graph can be accepted.
7. Initial orphan rule: an instance is legal only when the declaring package owns the typeclass or owns the receiver/concrete type. Built-in/std types and std typeclasses follow stdlib-owned exception records.
8. Unsafe instances are not exempt from coherence. The unsafe contract can justify semantic promises, not ambiguous selection.
9. Receiver-callable UFCS metadata does not create typeclass instances and does not participate in typeclass coherence except when an actual typeclass method call is resolved.
10. Built-in and stdlib instances are encoded in the same `.koi` instance table as user instances.
11. Dependency graph loading rejects conflicting instances before code generation and before monomorphization materializes bodies.
12. Diagnostics name both instance declarations, package paths, the unifying substitution when printable, the orphan rule involved, and the import/dependency edge that introduced the conflict.


### D361: Generator Borrow Capture, Suspension Regions, And Iterator Lifetime Checking

Spec homes: kyokaispec/src/language/11-linearity-borrowing-and-regions.md, kyokaispec/src/stdlib/06-iterators-and-generators.md.

1. A generator lowers to an explicit state-machine value whose environment fields are checked like record fields plus suspension-state rules.
2. Any borrow that can remain live across `yield` must come from a parameter, captured field, or external region recorded on the generator type.
3. A borrow created from a local temporary inside the generator body cannot live across `yield` unless the temporary itself is stored in the generator state and its region/lifetime relationship is representable.
4. Creating a generator from borrowed inputs produces a generator value whose type records those borrow dependencies, even when region names are inferred in surface syntax.
5. The generator value cannot outlive any captured borrow source.
6. `next` mutably borrows the generator state for the duration of the resume operation.
7. A yielded owned value transfers out according to the iterator/generator item contract. A yielded borrow is tied either to the `next` borrow of the generator or to an external region recorded on the generator type.
8. Moving a generator moves its suspended state only when all stored fields permit movement. Pinned generators require D301 pinning rules.
9. Destroying or draining a generator must consume or clean all stored linear fields on every suspension state.
10. `.koi` records public generator environment dependencies, yielded item type, borrow regions, cleanup obligations, and task-transfer classification.
11. Diagnostics name captured source, suspension point, generator value, and attempted escape.


### D362: Displayable For Borrows, Spans, Pointers, Debug Rendering, And UTF-8 Guarantees

Spec homes: kyokaispec/src/stdlib/02-core-result-optional-display-error.md, kyokaispec/src/stdlib/04-text-bytes-paths-and-strings.md, kyokaispec/src/language/18-built-ins.md.

1. `Displayable[T]` renders valid UTF-8 user-facing text.
2. `DebugRenderable[T]` or the accepted final debug protocol renders diagnostic/debug text. It can expose structure, type names, lengths, redacted addresses, and truncation markers.
3. A shared borrow `&[T]` is displayable when `T` or the referent type has an applicable `Displayable` implementation. Rendering delegates by shared borrow and does not move the referent.
4. A mutable borrow `&![T]` is displayable only through a temporary shared reborrow when Kyokai borrow rules allow it.
5. `Span[Char/Text]` and accepted text spans display as text. `Span[Nat8]` displays as bytes only through a bytes formatting policy, not as arbitrary UTF-8 unless validated.
6. Generic spans display only when their element type is displayable and the formatting API selects collection formatting with explicit length/depth policy.
7. Raw pointers, addresses, dynamic symbols, unsafe views, and capability internals are not `Displayable` by default. They render through debug/audit APIs that label rawness and apply redaction policy.
8. Formatting to a writer returns writer errors. Formatting to an owned string requires an allocator and returns allocation failure.
9. Debug/fatal rendering uses bounded buffers and can truncate, but truncation must be labeled.
10. No display/debug implementation consumes a linear value unless the API name and signature explicitly say it renders by consuming.
11. `debug expr;` uses debug rendering, not user display, unless the debug rule explicitly delegates to display for safe scalar text.


### D363: Allocation Failure Policy, Fallible APIs, OOM Boundaries, And Runtime-Fatal Allocation Sites

Spec homes: kyokaispec/src/stdlib/03-allocators-and-memory-containers.md, kyokaispec/src/language/13-contracts-and-runtime-failure.md, kyokaispec/src/stdlib/01-admission-contracts.md.

1. User-visible heap allocation returns `Result[..., AllocError]` or an API-specific error containing `AllocError`.
2. Containers, strings, buffers, maps, channels, arenas, formatting-to-string, generated owned reports, and property/fuzz generators use fallible allocation by default.
3. APIs that allocate must show allocator input unless they are using a statically owned/runtime-owned allocation source named by their contract.
4. Runtime-fatal allocation sites are limited to runtime bootstrap before user code can receive an error, fatal-report construction where no continuation exists, compiler support paths that cannot return into user code, and target-declared emergency paths.
5. Every runtime-fatal allocation site appears in a runtime allocation policy table with reason, phase, target behavior, fallback/truncation behavior, and test/audit evidence.
6. Fatal/debug reporting prefers static/stack/bounded buffers and truncation over heap allocation.
7. Freestanding targets have no heap unless an allocator is supplied by target runtime or user code.
8. Allocation failure never becomes null dereference, C UB, partial-initialization leak, hidden data loss, or silent downgrade.
9. Partial initialization cleanup for linear elements is mandatory in every fallible allocating API.
10. RIIK/std-lib admission includes OOM tests, cleanup tests, and allocator-behavior documentation.


### D364: .koi Serialization Schema, Generic Materialization Metadata, Provenance, And Compatibility Checks

Spec homes: kyokaispec/src/toolchain/02-module-resolution-and-koi.md, kyokaispec/src/toolchain/09-reproducibility-incremental-builds.md.

1. `.koi` is the canonical Kyokai Binary Interface artifact for package/module public interface facts and selected compiler-required metadata.
2. `.koi` uses one canonical sectioned binary encoding. Human-readable JSON/text is generated by `kyokai koi inspect`; it is not the authority.
3. The header contains magic `KOI`, KBI version, language edition, compiler compatibility class, package identity, module identity, target/profile constraints when interface-affecting, endian marker for the artifact encoding, and section table digest.
4. Required sections include string table, symbol table, exported names, type declarations, value declarations, generic declarations, constraints, typeclass declarations, instances, module imports, visibility, contracts, capability requirements, implicit completion records, stable ABI records, unsafe/audit summaries, const generic values, receiver-callable metadata, diagnostics metadata, and provenance.
5. Extension sections include docs summaries, source map summaries, analysis-server hints, generated-source provenance expansion, benchmark/test metadata that affects public docs, and tool-specific caches explicitly marked non-authoritative.
6. Each section has section ID, schema version, flags, byte length, canonical hash, required/extension bit, and compatibility policy.
7. Generic declarations record parameter kinds, universe constraints, const generic values, where clauses, typeclass constraints, associated type requirements, body materialization requirements, and monomorphization/cache identity inputs.
8. Generic bodies are not exposed beyond accepted interface rules. Downstream packages receive enough metadata for type checking, coherence, `.koi diff`, and materialization planning without violating visibility.
9. Const generic values are encoded canonically with type, value, target dependency, comptime provenance, and normalized asset provenance when involved.
10. Provenance records source file digest, normalized package-relative path, generated-file origin when any, generator identity, selected target/profile/backend when interface-affecting, and lockfile/package graph identity.
11. Host-local absolute paths are excluded unless explicitly remapped by reproducible profile policy. Non-reproducible path leakage is a build/report diagnostic.
12. Unknown required sections cause consumer rejection. Unknown extension sections are ignored only when the KBI version compatibility rule says they can be ignored.
13. `.koi diff` classifies changes as compatible, additive, breaking, target-restricted, feature-restricted, provenance-only, docs-only, or unknown-incompatible.
14. Stable ABI sections use D329 rules and make layout changes breaking unless an exact compatibility rule says otherwise.
15. The package manager, compiler, Analysis Server, docs, audit, semver checker, and build cache consume the same `.koi` parser.

Example inspection sketch:

koi KBI-1 package "example.math" module "Example.Math"
  requires edition "2026"
  exports value add: function(Nat32, Nat32) -> Nat32
  type Vec2: record stable_abi(size=8, align=4)
  generic Buffer[T: Type]: Auto materialization=downstream
  instance Displayable[Vec2] owner=example.math
  provenance source="src/Example/Math.kyo" digest="..."


### D365: Default Arithmetic, Checked/Wrapping/Saturating APIs, And Numeric Performance Contracts

Spec homes: kyokaispec/src/language/18-built-ins.md, kyokaispec/src/stdlib/07-math-and-numerics.md.

1. Default integer arithmetic in safe Kyokai is checked in every profile: debug, test, release, benchmark, and reproducible.
2. Checked failures include signed overflow, unsigned overflow, division by zero, remainder by zero, invalid shift count, negating the minimum signed value, and every arithmetic contract failure listed in the numeric operation table.
3. A checked arithmetic failure is TPOE, not panic, not recoverable error, and not backend UB.
4. Wrapping arithmetic is available only through explicit `wrapping*` operations.
5. Saturating arithmetic is available only through explicit `saturating*` operations.
6. Checked-result arithmetic is available through explicit `checked*` APIs returning `Optional` or `Result` according to the stdlib numeric contract.
7. Widening arithmetic, carry/borrow operations, mul-high, rotate, byte-swap, count-leading-zero, count-trailing-zero, and population-count APIs are provided for crypto, hashing, codecs, and big integer work without unsafe or FFI.
8. Shift operations distinguish checked shifts, wrapping/masked shifts when explicitly requested, and rotate operations. Default invalid shift count is TPOE.
9. Optimizers can remove arithmetic checks only when they prove the failure impossible under Kyokai semantics.
10. Backend lowering cannot use C signed overflow, invalid shifts, LLVM poison, or unchecked assumptions to implement safe arithmetic.
11. Unsafe target intrinsics for arithmetic exist only behind target gates and D322 unsafe contracts. They are not the semantics of safe arithmetic.
12. Numeric APIs publish performance notes without changing semantics. A faster wrapping operation is a different source operation, not a release-mode reinterpretation of `+`.
13. Conformance covers every integer width, including 128-bit integers where accepted, boundary values, cross-backend generated code, and sanitizer/execution tests where practical.

---

## Accepted Shape Routing Record: D366-D395

This cluster records the accepted results of a systems-language critique pass. It distinguishes accepted clarifications, already-answered concerns, and rejected surfaces that conflict with Kyokai's language direction. The normative specification, workflow, phase, and standard-library documents named in the tracker carry the extracted contracts.

### D366: User Joy, Honest Implicitness, And Lone-Programmer Goal Weight

D366 accepts no new language, tooling, or governance semantics. The critique is recorded as documentation pressure already covered by existing accepted shape. Public Kyokai wording must not claim zero implicitness. The accurate claim is that accepted implicit elaborations are compiler-recorded, inspectable, and bounded, while authority, allocation, cleanup, scheduler behavior, exception-like exits, and safe-code undefined behavior are not hidden.

### D367: Evidence-Tier Honesty For Spec, Compiler, Tests, And Maturity Rows

Kyokai maturity tracking separates decision state, spec state, implementation state, conformance state, and proof state. `SHAPE_DECIDED` and `SPEC_EXTRACTED` do not imply parser support, checker support, runtime support, conformance tests, proof, or release readiness.

A document cannot claim implemented, tested, proven, conformance-backed, or release-ready behavior without naming the implementation path, test/conformance path, proof artifact, or release artifact. Compiler behavior without accepted shape is inherited behavior or experimental behavior, not Kyokai semantics. Accepted shape without implementation remains Kyokai language intent, not compiler reality.

Kyokai does not cap the number of D-points. Critique intake merges repeats and rejects duplicate surfaces instead of hiding open questions behind a numeric limit.

### D368: Doc Comment Orphans And Diagnostic Style

A Kyokai doc comment must attach to a valid attachable item according to the lexical/doc grammar. A doc comment that cannot attach is a compile-time error, not a warning. The diagnostic must include the orphan doc-comment span, the reason attachment failed, and a help message explaining how to convert it to an ordinary comment or move it onto an attachable item.

### D369: Terminator Vocabulary, `qed`, And Display-Only Braces

Kyokai keeps the accepted terminator vocabulary. Source code does not accept brace-block aliases, `end;` replacement forms, or optional alternate block syntax. Official compiler, formatter, `.koi`, and spec behavior follow Kyokai terminators only.

Editor plugins, themes, folding modes, and local display overlays can render Kyokai source however a user wants, but those renderings are not Kyokai source, not formatter output, not copied into generated artifacts, and not a requirement on the Kyokai toolchain.

### D370: Modulo Semantics, Precedence Budget, And Operator Dialect Control

Kyokai does not add a `%%` operator. The `%` operator remains the checked truncating remainder operation with exact signed behavior in the numeric operation table. Division by zero and remainder by zero are TPOE in safe code.

Euclidean and floor division/modulo behavior is exposed only through separately named numeric APIs. Each admitted numeric API records its exact public name, signed-input behavior, zero-divisor behavior, overflow behavior, and checked-result form in the numeric admission table before stable release. Those APIs participate in D365 operation families: checked default behavior, explicit checked-result forms, and explicit wrapping or saturating forms only where that operation family defines a meaningful result.

Kyokai does not allow user-defined symbolic operators or package-defined operator precedence.

### D371: Numeric Literal Ambiguity, `Index`, And Common Numeric Helpers

Kyokai does not add a fallback integer type for genuinely ambiguous integer literals. An integer literal is accepted when its type is determined by expected type, suffix, local operator constraints, or other accepted literal-inference rules. If those rules leave more than one valid concrete numeric type, compilation fails and the diagnostic asks for a suffix, annotation, or explicit conversion.

`Index` remains a distinct integer type. Arithmetic and comparison between `Index` and other integer families require explicit conversion unless an accepted built-in operation states otherwise.

Safe arithmetic remains checked and profile-invariant under D365. Every admitted common numeric helper, including minimum, maximum, clamp, and absolute-value operations, is listed by its exact public name in the numeric API table with exact overflow and boundary behavior before stable release.

### D372: Static Text, Owning String, And Region-Bound Text Views

A Kyokai string literal denotes immutable compile-time UTF-8 text. Its type is `StaticString`; it is `Free` and performs no runtime allocation. Creating an owning `String` from literal/static text requires an explicit allocator-taking copy operation that returns allocation failure according to the string API contract.

Kyokai admits `TextView[R]`, a `Free` non-owning immutable UTF-8 text view tied to region `R`. `TextView[R]` owns no storage. Its lifetime is tied to static storage, a borrow of an owning `String`, a validated byte/text container borrow, or another API that states the source region. A `TextView[R]` cannot outlive its source region and cannot mutate the source.

Read-only text APIs prefer the view type. Owning `String` is used for mutation, ownership transfer, storage ownership, and APIs that explicitly need allocator-backed text. Map/set APIs can admit text-view keys only with equality, hashing, lifetime, invalidation, and storage rules in their collection admission records.

### D373: Multi-Return Sugar Without General Tuple Types

Kyokai does not add anonymous multiple return values, tuple return sugar, tuple types, tuple literals, or tuple destructuring. Functions return `Unit`, one named type, a nominal record/union, `Result`, `Optional`, or another accepted denotable type. Small aggregates that need multiple fields use nominal records with names. Recoverable failure uses `Result` unless a separate accepted D-point names a narrower domain-specific form.

### D374: Handle/Generation Pools As First-Class Graph Resource Pattern

Kyokai standard library admits generational handle and pool families. A handle is `Free`, copyable, comparable, and hashable when its fields satisfy the relevant protocols. It contains an index plus generation or equivalent stale-handle discriminator. The handle never owns the resource and never grants authority by itself.

Each admitted generational-handle family has one nominal `Linear` owner type. That owner owns storage and controls allocation, lookup, mutation, removal, cleanup, and generation changes. Lookup through a handle returns the failure type declared by that family's API contract. Stale handles, wrong-owner handles, removed entries, and generation mismatches are recoverable lookup failures, not UB.

Mutable access through a handle requires exclusive borrow of the owner or another accepted safe splitting rule. Capability-gated resources still require the relevant capability or capability-bearing owner; a copied handle cannot forge authority.

### D375: Default Universe For User Records And Linear Opt-In Pressure

D375 accepts no Free-by-default shift for user records. Kyokai keeps the accepted universe model from D30/D30a/D338. `Auto` remains the mechanism for generic/builtin universe-dependent classification. The compiler must not infer a broad Free default merely because a record appears to be plain data. Record universe diagnostics continue to report the accepted source of a type's Free/Linear/Auto classification.

### D376: Typeclass Surface Admission And Cleanup Contract Review

Every standard typeclass or compiler-recognized protocol requires the existing stdlib/language admission process. The admission record must state purpose, laws or invariants, compiler involvement, `.koi` representation, coherence behavior, diagnostics, and why plain functions do not suffice.

Kyokai does not adopt an arbitrary numeric cap for typeclasses. `Cleanable` and `Destroyable` are not merged by this decision. A merge requires a separate D-point with concrete API examples proving the current distinction harmful.

### D377: Borrow Strictness Modes And Mutable Borrow Elision

D377 accepts no new borrow rule, no new strict-borrow lint, and no mutable-borrow elision. Borrowing remains governed by D6/D7a/D7b/D72/D238-D240. Additional borrow diagnostics require a separate D-point with exact source forms and checker behavior.

### D378: Defer Locality, Bundled Cleanup, And TPOE Skip Diagnostics

Kyokai adds a `defer-distance` diagnostic for linear resources. After acquiring or initializing a linear resource, cleanup must be registered before unrelated side-effecting work unless ownership is immediately transferred, returned, stored in an owner that takes responsibility, or consumed. The diagnostic is a lint unless project policy raises it.

Kyokai accepts bundled defer grouping only as explicit LIFO cleanup registration. Each statement inside the bundle is checked with the same static and runtime rules as a single-statement `defer` body. The bundle cannot hide loops, conditionals, implicit destructor calls, or nonlocal control flow. Linear values consumed by bundled cleanup enter the same deferred checker states as single-statement defer.

When runtime diagnostics are enabled, a TPOE report must state that user defers are skipped on the TPOE path. Kyokai does not add `scope(exit)` as an alias.

### D379: Error Propagation Culture, `or return`, `errdefer`, And Propagation Lints

Kyokai keeps `or return` as accepted by D15a/D227. It is Kyokai's statement-level `Result` exit sugar, not Odin's removed value propagation experiment and not a general expression operator.

The compiler-integrated lint set includes `propagate-up`. It warns when a function repeatedly uses `or return` without adding context, mapping the error, locally handling a case, or documenting pass-through behavior. The lint is advisory by default and project-configurable.

`errdefer` remains limited to structured error exits: `return Err(...)` and `or return`. It never runs on panic, TPOE, runtime-fatal, normal success, `break`, or `continue`.

### D380: Failure Vocabulary, Assertion Surface, And Non-Recovering Hooks

Kyokai documentation and diagnostics expose a small explanatory failure map: recoverable value errors, programmer bug termination, contract/TPOE termination, and runtime-fatal termination. This map is explanatory; the precise terms `Result`, `panic`, `todo`, `require`, `ensure`, TPOE, `unreachable`, and runtime-fatal keep their accepted semantics.

Kyokai permits failure hooks for panic, TPOE, and runtime-fatal reporting. A hook receives read-only failure data, source location when available, and backtrace data according to policy. A hook cannot resume execution, cannot mark the failure handled, cannot run skipped user defers, cannot acquire new authority, and cannot allocate unless its API explicitly receives allocator authority. Termination continues after the hook returns or fails.

Kyokai does not merge `assert`, `require`, contracts, panic, TPOE, and runtime-fatal into one keyword family.

### D381: Capability Ceremony, Bundles, Scaffolds, And Ambient Authority Rejection

Kyokai does not add ambient capability mode, tutorial capability mode, or automatic capability parameter passing. Capability-gated operations receive authority through explicit parameters, stored fields, startup entrypoint values, or explicit capability bundle values.

Standard examples and scaffolds can define visible bundles such as CLI capability records. A bundle is a source-visible aggregate value whose fields name its authority. Passing a bundle is explicit authority flow and appears in source types and `.koi` when public.

The standard library capability set stays documented by authority tables. It is not collapsed to an arbitrary count.

### D382: Single-File Modules, `.koi` Artifacts, And Import Surface Simplicity

Kyokai does not add a public single-file module mode with embedded body sections. A public/importable module interface uses `.kyo`. A module body uses `.kai` when a body is needed. Accepted body-only `.kai` cases remain limited to the already decided non-public/internal/test shapes.

`.koi` remains a generated interface/build artifact and not higher authority than source. Import syntax remains governed by existing import and UFCS decisions; D382 accepts no new import form.

### D383: Network Dependencies, Vendoring, Index Authority, And Dependency Culture

Kyokai keeps network-capable package workflows, read-only package discovery, git/source dependencies, lockfiles, and package graph tooling as accepted shape. Network dependency resolution is explicit command/tool behavior, not an invisible side effect of parsing source.

Vendoring is a first-class reproducibility workflow and is the documented default workflow for serious builds, audits, long-lived products, and offline/release work. Vendored dependencies record source identity, content hash, lockfile identity, and provenance. The package index is discovery and metadata, not canonical source authority.

Kyokai does not require vendoring for every project and does not remove network dependencies. The tooling must make dependency source, transitive graph, content identity, license metadata when known, and vendor/cache state visible.

### D384: Context Object, Default Allocators, Temp Allocators, And Hidden-Parameter Rejection

Kyokai does not add implicit caller context, implicit allocator, implicit temp allocator, implicit logger, implicit random source, implicit assert handler, or hidden language calling-convention parameters.

Kyokai also does not add a broad generic `Context` record merely to reduce parameter count. Specific explicit bundle records are allowed only when an API family earns them through normal stdlib admission and the fields represent a real cohesive capability/allocator/tooling surface.

Allocator behavior remains governed by D44/D201/D250/D251: fresh owned allocation names its allocator or uses stored allocator identity according to the accepted storage-effect rules.

### D385: Builtin Slices, Free Maps, Dynamic Arrays, And Data-Oriented Layouts

Kyokai does not add builtin `map[K]V`, `[dynamic]T`, SoA/ECS syntax, or special Free-only owning collection syntax in this decision. Non-owning span and slice syntax remains the language-recognized view surface. Owning/growing collections remain standard-library types with explicit allocator, failure, invalidation, and cleanup contracts.

Data-oriented layouts belong in admitted stdlib containers or manifest-declared code generation with generated-source provenance, not macros or hidden compiler rewrites.

### D386: UFCS Resolution, Function Keyword Surface, And Receiver Sugar

Kyokai keeps D254/D337 UFCS exactly: receiver-call syntax resolves through source-visible declarations, explicit imports, and receiver-callable exports. There is no dependency-wide ADL and no orphan method soup.

D386 accepts no receiver declaration sugar and no callable keyword rename. Reversing the receiver-sugar rejection requires a new D-point with concrete justification, exact lowering, `.koi` identity, visibility, and diagnostics; no placeholder is accepted here.

### D387: Generators, Iterator-First APIs, Linear Captures, And Hidden Allocation

Kyokai's iterator protocol is the semantic base. A generator declaration lowers to a nominal iterator state-machine type. The lowered form exposes captured fields, suspension points, borrow regions, cleanup obligations, finalization behavior, and yielded item ownership to compiler dumps, diagnostics, `.koi` when public, and analysis tooling.

A generator cannot heap-allocate hidden state. If generator construction needs heap storage, the construction API must take an explicit allocator and return allocation failure. Linear captures require explicit move capture. Borrow captures record their source region and cannot outlive it. Abandoning a generator follows the accepted linear iterator finalization rules.

### D388: Taskgroup Discipline, Thin Threads, Select Limits, And Deadlock Tooling

Kyokai language `spawn` remains structured and requires `taskgroup` according to D252. D388 accepts no user-level unstructured spawn, no lint-only unstructured spawn, and no new raw-thread escape hatch.

Select-arm limits and deadlock tooling remain governed by their existing concurrency/tooling decisions. This D-point adds no new limit or stable lock prerequisite beyond those accepted surfaces.

### D389: Unsafe Contract Surface, Embed Alias, And Bindgen Boundary

Kyokai keeps `unsafe contract ... audit;` coverage as accepted by D245/D322. Plain `unsafe {}` blocks do not replace audit contracts. Unsafe operations must remain covered by source-level contracts with machine-readable coverage keys, caller obligations, invariants, and failure behavior.

`@embedBytes` and `@embedText` remain the accepted embed surface. D389 accepts no `#load` alias.

Bindgen, ABI scanners, header importers, and wrapper generators are tooling or manifest-declared generation steps. They do not become macros, do not execute implicitly during parsing, and do not make foreign declarations trusted without unsafe contracts and generated-source provenance.

### D390: Compile-Time `when`, File Build Constraints, And Tooling-Only Verification Boundary

Kyokai supports whole-file build constraints evaluated from explicit build inputs and the selected target contract before a file contributes declarations, body definitions, `.koi` facts, generated code, or semantic diagnostics. An excluded file is absent from semantic compilation. A requested tooling-only report can identify the exclusion reason, selected target facts, and build-constraint expression; that report cannot make the file contribute semantic facts.

Declaration-level `when` guards remain accepted. Body-level target branching remains rejected. Platform variance belongs in selected files, declaration guards, target-specific modules, or source-visible abstraction.

`kyokai verify` remains a tooling command. Ordinary `kyokai build` does not silently invoke SMT/proof tooling and does not make source valid or invalid based on solver results unless a separate accepted rule changes build policy.

### D391: Minimal CLI Path, Zero-Config Build, Human Diagnostics, And Cache-Off Mode

The essential Kyokai command tier is `check`, `build`, `run`, `test`, and `fmt`. Help output and first-week docs present this tier first. Other accepted commands remain available under analysis, package, release, audit, generation, docs, or advanced workflows.

`kyokai build .` and `kyokai run .` work for a single-file or unambiguous single-package directory without a manifest. The command reports the inferred package name, target, profile, backend, output path, cache path, and whether defaults were synthesized. A manifest is required for dependencies, multiple public modules, target-specific source sets, package metadata, generation steps, publishing, or non-default profiles.

Human diagnostics are primary. JSON diagnostics mirror the same codes, spans, notes, suggestions, and categories, but JSON schema design does not outrank human message quality.

`KYOKAI_CACHE=off` disables cache reads and cache writes for a command. Disabling cache cannot change accepted semantics, diagnostics meaning, final artifact identity, `.koi` content, or runtime behavior.

### D392: Standard Library First Slice, Transitional FFI Honesty, And One-Import Formatting

Kyokai's first stable standard-library implementation slice is tracked in `phase.md`, stdlib direction documents, and admission records. The slice includes core `Result`/`Optional`/error/display contracts, allocators, spans, text/bytes, formatting, paths, files, process/env arguments, time, random, math basics, the JSON/CBOR foundation, threads/tasks/sync basics, and test support.

Systems-tier modules can use libc, OS APIs, or mature external interfaces through unsafe contracts and transitional FFI tracking until native Kyokai implementations are admitted. This is the accepted OS/standards boundary, not a failure of RIIK.

A minimal formatting path must be reachable through one obvious import or a built-in recognized formatting surface. Formatting still exposes allocation and writer failure according to D330/D336/D362.

### D393: Layout Introspection Builtins, Profile Semantics, And C Backend Evidence

Kyokai admits compile-time layout fact builtins named `sizeOf(T)`, `alignOf(T)`, and `offsetOf(T, field)`. They are constant expressions available only when the selected target/backend contract defines the queried Kyokai layout. Querying an opaque, unsized, target-undefined, non-layout-stable, or forbidden representation is a compile-time error.

These builtins do not expose field iteration, type construction, runtime reflection, dynamic reflection, unsafe transmute permission, or layout mutation. Results are target-specific constants and are recorded in artifacts when they affect public ABI or `.koi` compatibility.

Release, debug, test, and benchmark profiles cannot change source arithmetic, pointer, layout, or ownership semantics. Backend smoke tests, generated-code checks, and no-UB evidence are required before backend maturity claims advance.

### D394: Proof Scope, Release Claims, And Unsafe/FFI Exclusion Honesty

D394 accepts no new proof, release, or calculus semantics. The critique is already answered by D143/D241/D312/D319 and current calculus direction. First proof scope, unsafe/FFI exclusions, verification-tool boundaries, and mechanization order remain unchanged.

### D395: Licensing Explanation, First-Run Disclosure, And Stdlib Relicensing Rejection

Kyokai keeps the D263/D306 licensing boundary. Source files continue to carry the project-required per-file license disclosure. The toolchain, runtime, standard library, startup, and helper-code license split remains unchanged.

D395 accepts no `kyokai new` first-run license prompt and no stdlib relicensing path. A license change requires a separate governance/legal decision with repository history, contributor permission, compatibility, and relicensing feasibility analysis.


## Accepted Shape Routing Record: D396-D419

### D396: Toolchain Telemetry, Network Contact, And Privacy Boundary

Kyokai tooling performs no telemetry collection, crash upload, source upload, package graph upload, timing upload, host fingerprint upload, or background network contact by default. Network behavior is a command contract, not an implementation convenience.

Commands are classified as `network-forbidden`, `network-capable`, or `network-required`. `kyokai check`, `build`, `run`, `test`, `fmt`, local `doc`, `lsp`, `fix`, `explain`, `--version`, and local `doctor` are network-forbidden. Stable Kyokai defines no command-specific network override for those local lanes. Package discovery, search, info, add, update, publish, explicit docs pulls, remote audit-feed refresh, and index synchronization are network-capable or network-required only because their command definitions name the remote source.

`--offline` forbids all network use and fails when required inputs are not already available through workspace packages, vendored sources, or verified local caches. Adding telemetry or crash upload requires a separate accepted D-point with schema, opt-in flow, redaction, retention, endpoint, local inspection, and disable behavior. No such telemetry exists in accepted Kyokai.

### D397: Dependency Feature Resolution, Target Features, Cache Deduplication, And Capability-Visible Package Surfaces

A dependency package instance is identified by package name, source revision or content hash, edition, target contract, semantic profile inputs, and exact feature set. Feature selection is not globally unified across the dependency graph. Two dependents can instantiate the same package revision with different feature sets, and those instances produce distinct `.koi` identities.

The compiler and package manager may share cache artifacts only after proving identical public `.koi`, identical backend-independent semantic facts, and compatible generated code inputs. Cache sharing cannot change diagnostics, audit output, build identity, or package graph reporting. Caches are keyed by package-instance identity, not only by package name.

A feature that enables public APIs, capability-requiring APIs, generated code, unsafe contracts, or target-specific behavior appears in `.koi`, lockfile metadata, package graph inspection, and audit output. `kyokai clean` removes selected cache state by default. `kyokai clean --outputs` removes selected outputs. `kyokai clean --all` removes both selected outputs and caches for the owner root. `kyokai clean --global` is separate and must show the global cache roots it will touch before removal.

### D398: Startup Authority Bundles Without Hidden Context

Hosted startup still mints root authority only at process entry. Kyokai accepts explicit startup authority bundle records for common app shapes, but rejects `CliApp`, `AppEnv`, hidden context passing, implicit dependency injection, and compiler-passed app state.

A startup bundle is an ordinary nominal value constructed visibly from `RootCapability` or narrower startup inputs. It is passed explicitly, stored explicitly, borrowed explicitly, and appears in public `.koi` when used in public APIs. Bundle fields are concrete authority values or borrowed views such as args, terminal streams, filesystem roots, environment authority, clock authority, random authority, process authority, network authority, cancellation/shutdown source, and allocator only when the admitted bundle contract includes it.

Libraries must take the narrow authority value they need rather than the whole startup bundle. Passing `RootCapability` into general library code is linted as overbroad authority unless the function is an explicit authority-construction boundary. Capabilities remain security authority, not ceremony to be papered over.

### D399: Path Semantics, Target-Native Paths, Unicode, Case, Symlinks, And Canonicalization

`Path` is a nominal target-native path value, not an alias for `String`. Target-specific path behavior is not implicitness; it is recorded target reality. The implicitness Kyokai rejects is pretending that all paths are portable UTF-8 strings.

Lexical path operations are pure and named as lexical operations. Filesystem-resolving operations require filesystem or directory authority and are named as resolving, canonicalizing, metadata-reading, opening, or link-following operations. No path equality, import identity, package identity, or cache identity uses implicit Unicode normalization, case folding, symlink resolution, or host-locale rules.

Target contracts record separator rules, root and device forms, case-sensitivity behavior, symlink support, invalid byte or code-unit behavior, canonicalization limits, and unsupported forms. Portable APIs operate on Kyokai's specified portable path subset. Target-specific APIs expose target-native facts explicitly.

### D400: Floating-Point Environment, NaN Policy, FMA, Rounding, And Reproducible Numerics

Safe Kyokai float semantics default to strict IEEE 754 binary32 and binary64 behavior. Safe code does not depend on ambient rounding modes, fast-math flags, hidden reassociation, hidden FMA contraction, hidden flush-to-zero, hidden denormal policy, signaling-NaN traps, or backend-specific exception flags.

Strict IEEE 754 behavior is the default language and stdlib correctness mode. An explicit optimized math API can name a relaxed policy in its own contract, but relaxed behavior cannot be silently selected by build profile. NaN payload bits are not portable semantic data unless a specific API states a target-bound payload contract.

Target contracts record denormal behavior, FMA availability, rounding-mode support, exception-flag exposure, libm or native math oracle tier, and backend lowering evidence. Strict APIs and conformance tests use the recorded target facts; unsupported strict behavior is a target rejection, not silent weakening.

### D401: Hashing, HashMap Order, Random Seeds, Determinism, And Reproducible Collections

Hashing is split into explicit lanes: randomized hash maps for collision-resistance, deterministic hash maps for reproducible tools and tests, ordered maps for stable iteration, and user-supplied hasher policies for specialized needs.

A default `HashMap` construction must name a hasher or seed policy or use a capability-derived randomized policy. A randomized construction path requires explicit random authority. A deterministic-hasher or deterministic-seed construction path exists for reproducible tools, tests, docs, package metadata, `.koi`, lockfiles, and generated artifacts. Ordered maps or sorted maps exist when stable visible iteration is part of the contract.

Hash-map iteration order is not a public stable order unless the type or API name says deterministic or ordered. Build artifacts, docs JSON, `.koi`, lockfiles, package metadata, audit reports, and spec examples cannot depend on randomized hash iteration.

### D402: OS Error Mapping, Raw Codes, Portable Categories, And Version Policy

Every OS error value preserves the operation, portable category, raw target code, target family, and available context such as path, process, socket, source span, or tool phase. Portable categories are versioned. Raw target information is never discarded.

Adding a portable category is compatible only when older tools can map it to an unknown or other-known category while preserving raw code and target family. Removing a category or changing its meaning is compatibility-breaking. Pattern matching over OS errors must acknowledge unknown or target-specific cases unless the selected target contract proves they cannot occur.

Diagnostics print portable category first and raw target detail second. Tool JSON carries stable category keys, raw target fields, operation keys, and schema version.

### D403: Time, Clocks, Sleep, Deadlines, Time Zones, And Testability

Clock authority is split by observable power. Wall-clock authority reads civil/system time and can move backward. Monotonic-clock authority reads monotonic instants and durations for deadlines. Sleep authority permits blocking delay and names its clock source. Time-zone data is explicit data, not ambient OS locale.

Deadlines use monotonic time unless the API name explicitly states wall-clock scheduling. Sleep APIs state overshoot behavior, interruption behavior, cancellation interaction, and target unsupportedness. Tests can inject fake wall and monotonic clocks through explicit fixtures without mutating global host time.

APIs that format, parse, or convert civil time state their time-zone database source, version, allocation behavior, and invalid/ambiguous local-time behavior. Capability requirements appear in stdlib contracts, docs, audit output, and `.koi` for public APIs.

### D404: Fatal Diagnostics, Crash Report Redaction, Secret Values, And Failure Hook Authority

Fatal diagnostics are local by default. Crash upload does not exist in accepted Kyokai. Programs and tools can choose an explicit crash-report policy such as none, local file, or custom handler when the relevant API admits it.

Secret-bearing values use `Secret[T]`, redacted environment/argument wrappers, or explicit redaction annotations in diagnostic payloads. Fatal reports must not print secret values, redacted env values, command args marked secret, raw tokens, private source snippets beyond configured limits, or arbitrary memory. Redaction happens before custom hooks receive payloads.

Custom failure hooks require explicit authority and receive read-only structured payloads. They cannot resume execution, cannot mark a failure handled, cannot acquire new authority, cannot run skipped user defers, and cannot allocate unless allocator authority is explicitly passed.

### D405: Native Toolchain Discovery, Linker Trust, `pkg-config`, Sysroots, And Host Leakage

Target toolchain configuration lists exact compiler, linker, archiver, sysroot, SDK, include roots, library roots, and allowed discovery providers. There is no language-level fallback guessing. Fallbacks such as `zig cc`, `clang`, and `gcc` are ordered explicitly by project or toolchain configuration, with required version/range, flags, target triple, sysroot, and rejection diagnostic.

`pkg-config` is allowed only when declared as a discovery provider. Its environment variables, sysroot behavior, package names, version constraints, queried fields, and captured output are recorded in build metadata. Host headers and libraries outside declared roots are rejected for reproducible builds.

Verbose build plans and `doctor` report selected external tools, paths, versions, sysroots, provider outputs, and target contracts without printing secrets. Discovery results that affect code generation, linking, `.koi`, generated code, or reproducibility become build identity inputs.

### D406: Generated Source Review Boundary, Provenance, `audit`, And `generate --check`

Generated `.kyo`, `.kai`, helper source, bindings, schemas, and tool artifacts carry generator name, generator version, config hash, input hashes, target/feature set, output hash, human-edit policy, and safety/audit classification. Generated files cannot be treated as ordinary human-authored source when provenance is missing.

`kyokai generate --check` verifies recorded provenance and either reruns generators or compares recorded output hashes according to the generation contract. Drift is a tool error. `kyokai audit` reports generated source, unsafe generated code, bindgen output, stale generation, missing provenance, hand-edited generated files, and generated safe wrappers.

Generated code does not create safe API by itself. Unsafe generated declarations remain unsafe or wrapper-only until unsafe contracts, safe wrappers, stdlib/package admission, and audit records exist. Checked-in generated files are allowed only when provenance is present and the policy says check-in is allowed.

### D407: Executable Spec Examples And PR-Based Public D-Point Workflow

Normative examples have explicit status labels: `conformance`, `illustrative`, `historical`, `aspirational`, or `negative`. `kyokai doc --check-examples` validates accepted examples against current syntax, imports, feature labels, target/capability requirements, and spec maturity. Historical or Austral-derived examples are visibly marked and cannot be used as current Kyokai conformance unless updated.

Public D-points normally live in pull requests or merge requests once they become real change proposals. `PROJECT_STANDARDS.md` owns the public D-point template. `Kyokaishape.md` is no longer the primary home for new D-point bodies; it can act as an index, archive, or migration ledger while active D-points live in public PR/MR threads.

After final acks or `Lead YES`, the PR/MR must update `kyokaidecided.md`, the relevant `kyokaispec/` text when the spec home exists, traceability, phase/status docs, and conformance or test plans before merge. Issues and discussions can motivate D-points, but the open D-point that changes language/toolchain/stdlib semantics is a PR/MR artifact with final wording and reviewable diffs.

### D408: Unicode Algorithms, Grapheme Boundaries, Case Mapping, Collation, And Version Pinning

`String` remains validated UTF-8 text. Kyokai does not add competing Unicode-string types for ordinary text. Algorithmic views and operations are explicit APIs: bytes, Unicode scalars, grapheme clusters, display width, normalization, case folding, case mapping, and collation.

The compiler, formatter, diagnostics, docs generator, package-name checker, and standard text APIs use pinned Unicode data versions recorded in toolchain version output and reproducibility metadata. Kyokai performs no implicit normalization, case folding, locale collation, or width calculation during equality, hashing, package resolution, import resolution, identifier lookup, or path handling unless a specific accepted rule says so.

Locale-sensitive APIs require explicit locale/data values or capability-bearing data sources. They do not consult ambient process locale. Package names, module names, identifiers, and stable tool keys use byte-for-byte or explicitly specified ASCII/canonical rules, not human collation.

### D409: Environment Variables, Process Arguments, Native Encoding, And Secret Handling

Process arguments and environment names/values are target-native nominal values such as `ArgText`, `EnvName`, and `EnvValue`, not aliases for `String`. UTF-8 conversion is explicit and named as strict, lossy, or target-rendered conversion.

Reading the current process environment requires `EnvCapability`; receiving startup args does not grant environment authority. Child process construction uses explicit environment builder modes: inherit none, inherit all, inherit selected, or set exact map. The selected mode appears in source or manifest/tool config.

Secret env and arg values are wrapped or marked at construction. Diagnostics render secrets as redacted structured fields and never call ordinary display directly on secret values. Target contracts define encoding, invalid-value behavior, NUL handling, Windows environment-name case behavior, Unix byte behavior, and child-process quoting rules.

### D410: Atomic File Updates, Temporary Files, Locks, Permissions, And TOCTOU Boundaries

Atomic file update APIs are admitted under filesystem/directory authority, not through a new random capability. Atomic replacement requires authority to the containing directory plus the required file create/write/replace authority.

The stdlib admits explicit temp file, temp directory, atomic write, replace file, no-follow open, and advisory lock APIs. Durability policy is explicit: best-effort, file-synced, file-and-directory-synced, or target-unsupported. Symlink-follow policy is explicit. Cross-filesystem replacement fails; it never silently copies and deletes as if that were atomic replacement.

File locks are advisory unless the target contract says otherwise. Lock lifetime is tied to a Linear lock guard. APIs that check metadata and then open/use a path either document TOCTOU exposure or use handle-relative/no-follow forms when target support exists.

### D411: Networking, DNS, Socket Addresses, TLS Hooks, And Capability-Gated Name Resolution

Kyokai networking is capability-gated and includes server/client socket, DNS, TLS, blocking, deadline, cancellation, and poller-backed contracts without async/await. Pure numeric address parsing requires no authority. DNS/name resolution requires `ResolverCapability`. Socket creation, connect, bind, listen, accept, send, receive, shutdown, and socket option changes require `NetworkCapability` or narrower connect/listen/socket authority.

Operations come in explicit families: blocking, try/nonblocking, deadline/until, and poller-backed. For operation verb `verb`, the public naming pattern is `verbBlocking`, `tryVerb`, `verbUntil(deadline)`, and `verbPoll(poller, token)`. The admitted socket verbs are `connect`, `accept`, `read`, `write`, `send`, and `receive`, producing names such as `connectBlocking`, `tryConnect`, `connectUntil(deadline)`, and `connectPoll(poller, token)`. Cancellation is cooperative through `CancellationToken` and poller readiness; Kyokai does not add hidden async runtimes or forced syscall interruption.

TLS is not implicit in sockets. TLS configuration uses explicit values for certificate store, verification policy, randomness, time, resolver/network authority, and failure behavior. Tests can inject fake resolvers and loopback-only network authority. Audit output reports packages and APIs that require resolver, outbound-connect, listener, raw-socket, TLS, or network authority.

### D412: Test Isolation, Parallelism, Fixtures, Capabilities, And Flake Control

Default tests run sandboxed: no ambient environment, network, process spawning, real clock, random source, broad filesystem access, or host terminal mutation except declared fixtures and grants. Tests declare grants in test metadata, source annotations accepted by the test spec, or manifest test profiles.

Integration tests can opt into host authority explicitly through named profiles or visible flags such as a final `--allow-host` equivalent. Active grants are shown in command output and CI logs. Parallel tests receive isolated temp directories, deterministic output capture, deterministic random/replay inputs when requested, and explicit fixture capabilities.

Host-dependent tests are labeled. The label affects scheduling and reporting but does not hide authority. Fixture cleanup, timeout, cancellation, and failure reporting are part of the test harness contract.

### D413: Structured Codecs, Canonical Encoding, Schema Evolution, And Resource Budgets

Kyokai admits strict structured codec profiles rather than a vague JSON parser. Toolchain JSON uses a strict UTF-8 I-JSON-like profile: no duplicate keys, bounded nesting, bounded strings/containers, deterministic object ordering for emitted canonical mode, and exact numeric policy.

User codec APIs expose named modes such as strict, permissive, streaming, and canonical. Every parser takes an allocator and resource budget or uses a stored allocator/budget admitted by its API contract. Duplicate-key behavior is explicit: reject, first, last, or collect by mode. Numeric behavior is exact integer, decimal, or float by API name and schema.

Generated codecs record schema version, generator provenance, budget defaults, unknown-field policy, canonicalization policy, and compatibility behavior. Hand-written codecs use the same public codec contracts.

### D414: Diagnostic Code Stability, Lint Compatibility, Suggestion Safety, And Tool Output SemVer

Diagnostic IDs are stable machine keys. Human message prose can improve without changing the ID. Diagnostic IDs have lifecycle states: active, deprecated alias, and removed with a tool-schema compatibility boundary.

Suggestions have safety classes: `note-only`, `manual`, `maybe-applicable`, `machine-applicable`, and `machine-applicable-safe`. `kyokai fix` applies only `machine-applicable-safe` suggestions by default. Suppressions bind to diagnostic ID plus optional scope, expiry, reason, and policy source.

JSON diagnostic schema is versioned separately from human text. Changing machine-readable diagnostic fields, suggestion classes, suppression behavior, or code meanings follows the tool-output compatibility rules.

### D415: Allocation Failure Injection, Resource Limits, And Deterministic OOM Testing

The stdlib admits test allocators such as counting, fail-nth, fail-by-size/class, leak-checking, limit, and high-water allocators. Failure schedules are deterministic and serializable into test replay records, including algorithm, seed/count, allocation class, site id, target, and harness version.

Allocator-aware stdlib tests must cover success, fail-first, fail-each-allocation, partial-initialization cleanup, and leak-check paths where applicable. Runtime-fatal allocation sites listed by allocation policy are tested separately and cannot be hidden inside fallible APIs.

The compiler does not silently inject allocation failures into ordinary program semantics. Failure injection is test/tool behavior through explicit allocator values or harness configuration. Diagnostics identify allocation site id, requested size/alignment, owning allocator, operation, and cleanup state.

### D416: SemVer For Behavior Contracts, Error Variants, Tool JSON, And Documentation Output

Public compatibility includes source signatures, visibility, typeclass instances, associated types, capability requirements, allocation behavior, blocking behavior, error/result variants, panic/TPOE/runtime-fatal cases, iteration/order guarantees, target availability, docs JSON, diagnostic JSON, and declared security/performance contracts when those facts are part of the public contract.

`.koi` records machine-readable compatibility facts for accepted surfaces that affect downstream checking, package publishing, SemVer tooling, docs, LSP, or audit output. Diff classes include source-breaking, ABI-breaking, behavior-contract-breaking, diagnostic/tool-output-breaking, additive-compatible, and documentation-only.

Publishing reports contract diff classes and rejects version numbers that understate the diff unless an explicit maintainer override records why. Bug fixes can be non-breaking only when previous behavior was outside the stated contract or is declared as a security/bug correction. Tool output schemas have their own compatibility versions.

### D417: Child Process Status, Termination Reason, Signals, Exit Codes, And Supervision Values

Starting a process returns spawn/setup errors separately from a successfully started `Linear` child process handle. Waiting for a child returns structured `ProcessStatus`, not a raw integer and not a parent `panic` or TPOE.

Process status distinguishes normal exit code, signal or host termination, core-dump flag when target exposes it, timeout kill, cancellation kill, exec failure reported after spawn where target semantics allow it, stopped/continued states when exposed, and target-unknown raw status. Raw target status is preserved for diagnostics.

Dropping or cleaning a live child requires an explicit policy: wait, terminate then wait, detach when target supports it, or error. Supervision APIs operate on structured status and never convert child failure into parent abnormal termination automatically. Target contracts state status capabilities, signal mapping, exit-code width/range, and unsupported states.

### D418: CPU Feature Detection, Runtime Dispatch, Portable SIMD, And Target Multiversioning

Compile-time CPU features are explicit target/profile inputs when required for generated code correctness. Runtime CPU feature detection returns explicit feature-set values and does not silently change source semantics.

Unsafe intrinsics require target-gated unsafe contracts unless wrapped by admitted safe APIs with portable fallback behavior. Safe accelerated APIs must declare dispatch policy, fallback semantics, feature probes, and reproducibility impact. A binary must not execute instructions outside its baseline target unless a runtime feature check selected that path.

Portable SIMD APIs use explicit vector types and lane semantics. Targets may lower portable vector operations to SIMD or scalar code without changing results unless the API opts into a relaxed float/numeric mode. Artifacts record baseline CPU, enabled compile-time features, runtime-dispatch tables, and accelerated object provenance when these affect codegen.

### D419: Package Names, Unicode Confusables, Normalization, Reserved Names, And Typosquat Policy

Public package names use a strict ASCII grammar. Unicode package names are rejected for public index packages. Canonical comparison is exact and recorded: case policy, separator policy, length limits, allowed characters, and reserved-name rules.

Names reserved for the standard library, official tools, examples, security advisories, project infrastructure, and official namespaces cannot be claimed by ordinary packages. Names colliding by canonical form are rejected. Names confusingly close to official or reserved names are rejected, not merely warned.

Typosquat similarity to ordinary third-party packages is an index/audit advisory only; it is not source semantics and is not proof of malice. Git/source dependencies outside the public index record exact URL, revision, and package manifest name. Tooling warns when a non-index package name would fail public index policy.


## Accepted Shape Routing Record: D420-D431

This cluster closes the third local ambiguity pass around source bytes, randomness, terminal behavior, package artifacts, lockfiles, toolchain installation, scratch execution, docs metadata, deprecation, caches, C binding generation, and advisories. These accepted rules are integrated into the normative `kyokaispec/` chapters named in the maturity tracker.

### D420: Source File Encoding, Shebangs, Newline Normalization, And Diagnostic Span Coordinates

`.kyo` and `.kai` files are UTF-8 byte sequences. Invalid UTF-8 is a lexical error before parsing. A leading UTF-8 BOM is rejected with a diagnostic that names the byte position and offers removal as the fix. Source decoding is never host-text-mode decoding and never depends on locale, editor settings, platform newline translation, or filesystem text attributes.

LF and CRLF terminate source lines. A CR byte not followed by LF is a lexical error. `kyokai fmt` writes LF. A missing final newline is accepted as source input, and `kyokai fmt` adds the final newline. Tabs are legal in comments and string/raw-string literal contents; indentation emitted by `fmt` uses spaces. Tabs outside admitted whitespace positions are rejected according to the lexical grammar.

A Unix shebang is accepted only as the first two bytes `#!` on line 1 of an executable entry source file in a command mode that accepts executable source. The shebang line is not tokenized as Kyokai source. It remains part of source hashes, source maps, reproducible provenance, and line numbering, so diagnostics after a shebang still report their original file lines.

Compiler spans, `.koi` source fingerprints, generated-source provenance, source maps, diagnostic JSON, formatter edits, docs examples, and LSP facts use the shared source-map algorithm. The canonical coordinate is byte offset in the original UTF-8 byte sequence plus derived line and column fields. Human diagnostic columns are render fields derived from the pinned Unicode/display-width algorithm and never replace byte offsets. Tool JSON carries byte offsets so editor/protocol encoding differences cannot change the compiler's source identity.

### D421: Randomness, Entropy, Deterministic PRNGs, Replay Seeds, And Crypto Boundaries

Kyokai splits randomness by authority and purpose. OS entropy access requires explicit entropy authority such as `EntropyCapability` or a narrower admitted random-source capability. Entropy APIs return ordinary `Result` values with target unsupported, temporarily unavailable, interrupted, permission, resource, and raw target error data mapped through the accepted OS-error policy. Entropy is environmental I/O, not a pure function.

Cryptographic random generation is exposed through admitted secure-random APIs whose names state security intent. A crypto RNG construction records entropy source, reseed policy, blocking/unavailable behavior, target support, audit status, algorithm identity, and failure behavior. APIs that create keys, nonces, session tokens, salts, or other secrets accept only crypto-grade RNG values or entropy-derived secure RNGs. Deterministic PRNGs do not satisfy crypto RNG requirements.

Deterministic PRNGs are separate named types. Their constructors take explicit seed values. Their contracts record algorithm name, algorithm version, state size, output-width behavior, endianness behavior, reproducibility scope, and output-sequence compatibility. PRNGs used by tests, fuzzing, package generation, docs examples, deterministic hash policies, or reproducible tools produce the same sequence for the same algorithm version, seed, target-independent inputs, and Kyokai compatibility class.

Distribution helpers state range bounds, rejection sampling, modulo-bias behavior, allocation, failure, and target effects. A range API is unbiased unless its name explicitly says biased. Fuzz/property/replay metadata records PRNG algorithm, algorithm version, seed, shrink path, target, profile, toolchain version, and any external entropy grant. Hash-map randomized seeding follows the accepted hashing policy and cannot silently consume crypto entropy in reproducible build, docs, package, `.koi`, or test replay modes.

No random API silently reads wall time, monotonic time, PID, thread ID, memory addresses, uninitialized memory, environment variables, or host process state as seed material. Freestanding and sandboxed targets without entropy state that absence in the target contract; importing entropy-required APIs for such targets is rejected unless the selected profile supplies an explicit entropy fixture or host grant.

### D422: Terminal Capability, TTY Detection, Color Policy, Raw Mode, Prompts, And Display Width

Terminal behavior is an explicit standard-library and toolchain service. `TerminalCapability` or a narrower terminal handle grants terminal authority. Byte-oriented stdout/stderr writers do not grant raw mode, echo control, prompts, cursor movement, color policy, terminal-size probing, pager use, or terminal mutation.

Terminal handles expose structured facts: interactive status, stdin/stdout/stderr terminal association, width and height availability, color support class, hyperlink support class, target console kind, raw/cbreak/no-echo support, alternate-screen support, cursor-control support, and unsupported-feature diagnostics. These facts are target and handle observations; they are not hidden global compiler assumptions.

Kyokai CLI color policy is exactly one of `auto`, `always`, `never`, or `machine`. `auto` reads declared terminal facts and accepted display-only environment policy inputs such as the no-color policy. `always` emits terminal styling only on human output streams. `never` emits plain human text. `machine` emits stable machine-readable output and forbids ANSI color, progress animation, cursor movement, and pager behavior. CI-stable commands use `machine` or explicit plain output.

Raw, cbreak, and no-echo modes are entered through Linear guard values. Constructing the guard records the prior terminal mode. Consuming the guard restores that prior mode through the specified cleanup operation. Normal returns, error returns, and registered cleanup paths consume the guard exactly once. TPOE and runtime-fatal follow the global fatal contract and do not promise user cleanup beyond target/runtime fatal handling.

Prompt APIs state echo policy, secret redaction, default value behavior, EOF behavior, cancellation behavior, non-interactive behavior, output stream, input stream, validation, and allocation. Secret prompts return secret-bearing values or redacted wrappers, not ordinary displayable text. Display-width APIs use the pinned Unicode data version and are separate from byte length, scalar count, grapheme count, and string length. Tool tests can inject terminal facts and color policy without mutating the real host terminal.

### D423: Canonical Package Source Artifacts, Archives, Compression, Checksums, And Content Identity

Kyokai source distribution uses a canonical package source artifact. Package identity for downloads, mirrors, vendoring, lockfiles, audits, and offline caches is the accepted content hash over the canonical source artifact representation, not whichever archive bytes a hosting provider returns.

Canonical source artifacts use deterministic path ordering, exact package-root prefix rules, the accepted path policy, normalized executable/read/write file modes, no host owner or group metadata, normalized timestamps, exact symlink policy, exact file-type allowlist, and exact metadata stripping. The package tool rejects absolute paths, parent-directory escapes, duplicate canonical paths, unsupported file types, unsupported symlink forms, device files, sockets, FIFOs outside an admitted target package rule, and paths that violate the canonical name policy.

Compression is transport unless an artifact kind explicitly defines compressed bytes as identity. The source-content hash is over canonical uncompressed content. Compressed artifact identity, when selected by an artifact kind, records compression algorithm, level, headers, dictionary, metadata policy, and compressed-byte hash. Package source hash algorithms are versioned by the toolchain/package-index schema. Hash migration records old and new hashes; old hashes remain readable for existing lockfiles under the compatibility policy.

Lockfiles record package identity, source identity, canonical source hash, original transport, resolved Git revision for Git sources, index or mirror provenance, artifact format version, and hash algorithm. Vendored directories include a vendor manifest recording canonical source hash, original source, vendoring tool version, local modification status, and vendor timestamp policy. Audit and package graph output print both source provenance and canonical content identity.

### D424: Lockfile Update Semantics, Resolver Determinism, Conflict Policy, And Offline Mode

`kyokai build`, `kyokai check`, `kyokai test`, `kyokai doc`, and `kyokai run` do not mutate `kyokai.lock` unless the command line selects an explicit lockfile update mode. Graph mutation is a command choice, not a side effect of compiling.

Lockfile modes are exact: `frozen`, `locked`, `update-selected`, `update-all`, `offline`, `repair`, and `explain-conflict`. `frozen` rejects a missing lockfile, stale lockfile, format drift, unresolved package graph, or any required lockfile write. `locked` uses the existing graph and rejects dependency resolution that needs graph changes. `update-selected` updates named packages and the minimal required transitive set. `update-all` resolves the whole graph under current manifests and policies. `offline` performs no network access and uses only workspace packages, vendored sources, and verified local caches. `repair` rewrites deterministic ordering/format without changing graph meaning. `explain-conflict` reports solver conflicts without writing a graph.

CI defaults to `frozen` when a lockfile exists. A command that requires network access fails under `offline` unless every required source, index record, advisory snapshot, and artifact is already present in verified local storage. Yanks do not break existing locked builds by themselves. Security blocks, minimum-safe-version policy, malicious-package records, and explicit audit policy are separate inputs that appear in audit output and policy diagnostics.

Lockfile formatting is deterministic and ordered by canonical package identity plus dependency edge information. Merge conflicts are resolved by rerunning the resolver from manifests plus the branch graph inputs; hand-edited conflicted lockfiles are not authoritative until `kyokai lock repair` validates graph identity, source hashes, resolver version, feature-resolution version, package artifact hashes, source provenance, and index metadata version. Resolver diagnostics include package, version or revision constraints, feature constraints, target constraints, yanks, advisories, and the minimal conflicting chain.

### D425: `bleedring` Toolchain Management, Toolchain Pins, Version Output, Install Roots, And Caches

Kyokai has a first-party toolchain manager named `bleedring`. The canonical user surface is `kyokai bleedring`. The bootstrap installer/proxy binary is `kyokaibleed`; after installation it delegates to `kyokai bleedring` and does not become a second package manager or a second build frontend.

`kyokai bleedring` owns install, list, default, pin, override, remove, update-index, run, component, target, cache, and doctor subcommands for Kyokai toolchains. Toolchains are installed into content-checked install roots separated from project outputs and package caches. A toolchain installation records compiler version, stdlib version, runtime version, resolver version, `.koi`/KBI format version, package-index schema version, target metadata version, bundled component versions, build profile, host triple, supported target triples, release channel, commit, tag, build date, clean/dirty source state, checksum, and signature/provenance record.

Toolchain selection order is exact: explicit CLI toolchain override, directory override, checked-in project toolchain file or manifest toolchain declaration, workspace toolchain declaration, user default selected by `bleedring`, then PATH fallback only for unmanaged legacy invocation without a stronger rule. A selected project pin can name an exact version, exact revision, exact release channel plus version, or exact toolchain manifest hash according to the release policy. A version range is accepted only for commands that explicitly perform resolution and write the resolved exact toolchain pin.

Build, check, test, doc, run, fmt, lsp, and audit never self-update the compiler, stdlib, resolver, package index client, or installed components. Installing, removing, updating, or switching toolchains is an explicit `kyokai bleedring` command or an external package-manager action. CI setup installs an exact requested toolchain and verifies checksum/signature before use.

`kyokai version --verbose` and `kyokai doctor` print the selected toolchain identity in a Hyprland-style full record: Kyokai version, branch, commit, clean/dirty state, build date, tag, commit count when available, release channel, compiler component version, stdlib version, runtime version, resolver version, formatter version, LSP version, docs generator version, package-index schema version, `.koi`/KBI version, target metadata version, host triple, selected target triple, enabled compile-time flags, installed components, external tool paths and versions when relevant, install root, global cache root, project cache root, and a version ABI string derived from the commit plus compatibility-critical component versions. The version ABI string is recorded in build provenance when it affects artifacts.

Global caches, package source caches, installed toolchain caches, and project build caches are separate roots. Build-result caches are partitioned by toolchain identity, target contract, backend, profile, feature set, cache-format version, and relevant policy values. `kyokai clean` subcommands name which roots they affect and show global roots before destructive global cleanup. Self-hosted bootstrap toolchains record stage identity so stage0, stage1, and stage2 artifacts cannot be confused.

### D426: REPL, `eval`, Playground, Scratch Execution, Sandbox Limits, And Persistence

`kyokai repl`, `kyokai eval`, executable documentation examples, playground runs, tutorial scratch runs, and compiler-explorer-style executions use the scratch-execution contract. Scratch execution is a temporary package/session with declared edition, target, backend, dependency set, module namespace, profile, and artifact policy. It is not a privileged language subset and not a hole in the capability model.

The default scratch profile grants no filesystem, environment, process, network, wall clock, monotonic clock, random source, terminal raw mode, host compiler, unsafe/FFI, package publish, or broad host authority. Grants are explicit command-line flags, manifest scratch-profile entries, or playground sandbox policy entries. Session startup and verbose output print active grants, target, resource limits, dependency set, and artifact cleanup policy.

A REPL session persists definitions as ordinary declarations inside the temporary package namespace. Imports, visibility, `.koi` facts, capability flow, linear ownership, borrow rules, defer rules, and package dependency rules are ordinary Kyokai rules. `eval` for compile-time expressions cannot observe runtime capabilities, host state, time, randomness, filesystem, network, or process authority. It uses the same compile-time evaluation limits and reproducibility rules as other compile-time evaluation.

Scratch execution enforces explicit CPU, memory, wall-time, output-size, file-count, process-spawn, network, and package-fetch limits. Limit exhaustion reports a structured tool/runtime status. It is not TPOE, not backend UB, and not a silent host kill presented as successful execution. Scratch artifacts are in-memory, temporary-directory, or named project-cache artifacts according to the selected policy; verbose output prints the location and cleanup rule. Web playground execution uses the same contract plus remote host disclosures and exact compiler/runtime/toolchain versions.

### D427: Doc Comments, API Metadata, Docs JSON, Stability Tags, And Deprecation Markers

Declaration doc comments attach only to the immediately following declaration. Module/file doc comments attach only to the containing module/file surface admitted by the lexical syntax. Doc comments cannot change type checking, visibility, ownership, borrowing, code generation, capability requirements, runtime behavior, or `.koi` semantics except by contributing documented metadata fields that tools consume.

Kyokai docs have prose plus a closed machine-readable tag set. The admitted tags cover parameters, return value, errors, capabilities, allocation, blocking, cancellation, TPOE, panic/runtime-fatal behavior, safety and unsafe contracts, examples, deprecation, replacement, stability, target availability, feature requirements, security notes, and audit notes. Unknown tags are `kyokai doc --check` diagnostics. Unknown tags never create semantics.

Executable examples inside docs carry status labels from the accepted example policy: conformance, illustrative, historical, aspirational, or negative. Doc tests compile and run only examples whose label and target/capability grants admit execution. Examples that require capabilities state those grants in docs metadata and test harness policy.

Deprecation metadata names the deprecated declaration or tool surface, since-version, reason, replacement when one exists, fix availability, fix safety class, lint code, and removal class. Docs JSON contains declarations, visibility, signatures, typeclass facts, contracts, capability facts, allocation/failure/blocking facts, docs tags, examples, deprecations, stability tags, target guards, source spans, and links under a versioned schema. LSP hover, docs HTML, semver-check, audit, and `kyokai fix` consume this single metadata model.

### D428: Deprecation, Migration, Edition Transitions, Removal Policy, And Compatibility Windows

Deprecation is accepted source/tool metadata attached to declarations, modules, typeclass instances, manifest keys, tool commands, command flags, diagnostic codes, docs JSON fields, or other public tool JSON fields. A deprecation record states since-version, reason, replacement, machine-fix availability, fix safety class, warning lint code, removal class, and compatibility axis.

Using a deprecated item emits the recorded diagnostic lint by default. Project lint policy can escalate deprecation lints to errors through explicit policy. Suppression records include diagnostic ID, scope, reason, expiry, and policy source. Human message prose can improve while the diagnostic ID remains stable under the diagnostic compatibility rule.

Deprecation alone does not make a breaking change non-breaking. Removing, changing, or weakening a public deprecated item follows the SemVer, edition, `.koi`/KBI, tool-output, and behavior-contract compatibility rules for that item kind. A deprecation with no replacement states that no replacement exists and records the reason removal is justified.

Edition migrations are explicit source-semantics modes. `kyokai fix --edition` assists migration by applying safe machine-applicable fixes and validating parse/type/format afterward. Build/check/test/doc/run never silently rewrite source or lockfiles as part of migration. Tool command, flag, diagnostic-code, and JSON-field deprecations include aliases only under the accepted compatibility rule, and aliases remain visible in docs JSON and release metadata.

### D429: Build Cache Keys, Eviction, Concurrent Access, Cache Poisoning, And Remote Cache Trust

Every build-result cache entry records cache-format version, toolchain identity, version ABI string when available, source/input hashes, manifest hashes, lockfile hash, package source hashes, target contract, backend, profile, feature set, generated-source provenance, selected policy values, admitted environment inputs, external tool identities, `.koi`/KBI version, package-index schema version, and output integrity hash. Cache hits are accepted only when every required key field matches exactly or through a compatibility rule named by the cache schema.

Cache writes use atomic file-update rules and content/integrity hashes. Partial writes, missing metadata, mismatched hashes, unknown cache-format versions, and stale generated-source provenance are never consumed. Cache corruption is a tool diagnostic and triggers rebuild from source when the required sources and tools are available. A corrupted cache entry is not silently trusted and is not reported as a successful cache hit.

Concurrent builds coordinate through explicit cache locks or content-addressed temporary paths. Lock acquisition, stale lock detection, unsupported locking, and lock timeout have stable diagnostics and fallback behavior. Eviction never deletes an entry held by an active build according to the cache-lock protocol. `kyokai clean` separates project outputs, project caches, package source caches, global caches, and installed toolchain caches.

`kyokai build --no-cache` and the accepted cache-off mode produce correct artifacts without reading build-result caches. They still read declared source inputs, installed toolchains, package sources, vendored sources, and lockfiles according to their separate controls. Remote cache use is disabled by default. Enabling a remote cache requires explicit configuration, trust policy, endpoint identity, integrity checks, provenance validation, target/toolchain/profile match, and policy recording in build metadata. Remote cache entries cannot introduce new source, authority, package graph, or toolchain facts.

### D430: Bindgen, Header Preprocessing, C Macro Modeling, Target Header Trust, And Generated FFI Provenance

C header translation is a manifest-declared generation step. It is not an implicit compiler phase and not an ambient host-header scan. The generation config records target triple, ABI, C frontend identity, frontend version, sysroot/SDK identity, include paths, defines, undefines, language standard, extension mode, allowlist, blocklist, macro policy, inline-function policy, source header hashes, transitive include hashes when captured, and selected native toolchain discovery facts.

Generated bindings record provenance in generated files, `.koi` metadata, audit metadata, and generation-check metadata. Provenance includes generator name, generator version, config hash, input headers, target, ABI, toolchain identity, source hashes, output hash, unsafe contract coverage, safe-wrapper coverage, and human-edit policy. Regeneration drift is detected by comparing provenance and content hashes; stale generated bindings fail `kyokai generate --check` or the selected generation-check mode.

Object-like C macros become Kyokai typed constants only when the generator proves a single target-specific constant value and type category under the selected preprocessing configuration. Function-like macros are rejected unless a separately accepted wrapper category models the macro as generated helper code with explicit unsafe or safe contract. Inline C functions are rejected, emitted as unsafe foreign shims, or generated as audited helper code according to explicit config. They are never silently translated into safe Kyokai.

Generated FFI declarations remain unsafe or wrapper-only until unsafe contracts and safe wrappers exist. Bindgen output alone does not create safe Kyokai APIs. Header translation cannot use ambient include paths, host SDKs, default compiler defines, or host libraries outside the selected target/toolchain contract. A package that wants host SDK bindings declares the SDK identity and target contract explicitly.

### D431: Security Advisories, Vulnerability Audit, Yank Interaction, Patch Policy, And Minimum Safe Versions

Kyokai defines a Kyokai Security Advisory schema, `KYSA`, as an OSV-compatible advisory document with Kyokai package identity extensions. Advisory records include advisory ID, package identity, source identity, affected version or revision ranges, patched ranges, severity, vulnerability category, publication timestamp, update timestamp, source URL, withdrawn/superseded status, exploit notes when present, migration notes when present, and machine-readable affected artifact kinds.

Yanks are append-only package-index metadata and are not vulnerability records. Advisories can reference yanked versions, but yanks, vulnerabilities, malicious-package blocks, license findings, unmaintained-package findings, unsafe-contract audit findings, and minimum-safe-version policy are distinct signals. The package manager does not treat one signal as a synonym for another.

`kyokai audit` evaluates the resolved lockfile graph against KYSA advisories, yanks, license policy, unsafe-contract audit findings, malicious-package policy records, unmaintained-package records, and organization policy. Audit output is human-readable and machine-readable under a versioned schema. It reports dependency path, package source, locked revision or version, artifact hash, advisory match, patched candidates, yank status, license status, unsafe/audit status, policy action, and exemption status.

Build/check/test do not silently contact advisory services. Advisory refresh is an explicit command or an explicitly configured CI/audit mode. Policy actions are exact: allow, warn, deny, deny-above-severity, deny-malicious, deny-unpatched, deny-yanked-new-resolution, and ignore-by-recorded-exemption. Exemptions record advisory ID or policy record ID, package identity, dependency path or scope, reason, actor, creation time, expiry, and review policy. Known malicious package or revision blocks can reject new resolution and can reject locked builds only when the selected audit/build policy says locked-build denial is active.


## Accepted Shape Routing Record: D432-D465

This cluster records integrated FFI, toolchain, concurrency, and safety surfaces that were previously phrased as open hooks after D420-D431. It is accepted shape and does not reopen earlier TPOE, capability, lint, formatter, package, or concurrency decisions. D455 follows D222: there is no separate `kyokai lint` command. D464 follows D358/D380: embedded fatal behavior is a target-contract clarification, not a new exception or cleanup model.

### D432: Non-`"C"` Foreign ABI Strings And Calling-Convention Admission

Kyokai admits foreign ABIs through a closed target-contract table. Foreign blocks use Kyokai block syntax:

```text
foreign "ABI_NAME" is
    ...
mon;
```

`"C"` is the portable baseline ABI for targets that admit FFI. `"system"` is admitted only on targets whose target contract maps it to an exact platform calling convention. Target-specific ABIs such as `stdcall`, `cdecl`, `win64`, `sysv64`, `aapcs`, or vendor ABIs are admitted only when the selected target contract lists them.

Each ABI table entry defines parameter passing, return passing, aggregate layout, varargs legality, callback legality, reentrancy class, and unwinding behavior. Foreign unwinding into Kyokai is rejected unless an ABI table entry explicitly admits an unwind boundary. Unknown ABI strings are compile-time errors. Adding an ABI string requires a D-point and a target-contract update.

### D433: Module Import Cycle Protocol

Kyokai module import graphs are acyclic. A module cannot import itself directly or indirectly through `.kyo`, `.kai`, generated interface artifacts, or re-export chains.

The compiler rejects cycles before type checking and emits a diagnostic that prints the complete cycle path. `.koi` artifacts never encode module cycle witnesses. A design that requires mutual module visibility must split shared declarations into a lower acyclic module or merge the mutually dependent declarations into one module.

### D434: Workspace Package Dependency Cycle-Breaking

Kyokai workspace and package dependency graphs are acyclic at package identity level. A package cannot depend on itself directly or indirectly through normal dependencies, dev dependencies, generated packages, tool packages, target-specific dependencies, or re-exported package surfaces.

The resolver rejects the workspace before build planning and prints the package cycle path. Cycle-breaking artifacts are not admitted. Shared code belongs in an acyclic lower package, and build tooling belongs in a tool package that does not import the package it generates for.

### D435: Linear-Aware Shared Test Fixtures

Kyokai test fixtures are explicit test-harness declarations with ownership class: `case`, `module`, or `workspace`.

A fixture that creates linear resources must return either a per-test owned value with statically checked cleanup, or a shared broker handle that leases fresh linear resources to each test case and reclaims them through an explicit teardown contract. Linear resources are not shared directly between parallel tests.

Shared fixtures are legal only when the shared value is Free immutable data, a compiler-admitted synchronized primitive, or a fixture broker whose lease/release protocol is recorded in test metadata. Fixture setup failure is a structured test failure. Contract violation inside fixture code remains TPOE, caught by the test harness as a failing test process according to the existing test-runner rules.

### D436: MPSC, MPMC, And Broadcast Channel Admission Or Permanent Rejection

Kyokai core concurrency admits SPSC channel endpoints only. MPSC, MPMC, and broadcast endpoints are rejected as core language primitives and rejected from the Tier-1 primitive stdlib channel set.

Fan-in, fan-out, and pub/sub are expressed through explicit broker tasks connected by SPSC channels, poller registration, and named queue policies. A broker type documents capacity, fairness, backpressure, cancellation, close behavior, and linear message ownership. User code does not receive a hidden shared channel endpoint that multiple producers or consumers mutate implicitly.

### D437: Multiple Runnable Binary Targets Per Package

A Kyokai package can declare multiple executable targets in the package manifest. Each executable target is a named build-graph node with root module, entrypoint, output name, profiles, target filters, generated-input dependencies, and startup capability bundle.

`kyokai build <target>` builds the named executable. `kyokai run <target>` runs the named executable. A package can mark exactly one executable as the default run target. Library-only packages declare no executable targets. Example/demo targets remain separate from production executables in audit, release metadata, and install policy.

### D438: Cross-Edition `.koi` Interface Normalization

`.koi` artifacts are edition-specific. A consumer loads a `.koi` artifact only when the artifact edition, KBI major version, target contract, and compatibility class match the consumer's declared requirements.

Cross-edition use is not implicit. A tool can generate a separate migration witness that records every semantic mapping from one edition to another. That witness is an audit artifact, not a normal `.koi` replacement. It cannot silently change ownership, capabilities, unsafe contracts, layout, failure behavior, or ABI. Mixed-edition workspaces rebuild package interfaces per edition boundary instead of pretending one `.koi` is version-agnostic.

### D439: Refutable And Filtering `for-in` Loops

`for Pattern in expr` requires an irrefutable pattern. Refutable patterns in `for-in` are compile-time errors.

Filtering iteration is expressed with explicit `case` inside the loop, `while let` forms that expose the matched value, or named iterator adapters whose ownership behavior and allocation behavior are part of their API contract. No loop form silently discards a linear payload on a non-matching pattern.

### D440: Kyokai-to-C Export Borrow Wrapper Patterns

C-exported Kyokai functions cannot expose Kyokai reference or borrow types in their exported ABI signature.

Admitted C-facing wrapper categories are opaque handle, pointer-length view, nullable pointer where the target ABI admits it, and by-value `extern record` values approved by the ABI table. Each exported wrapper has an unsafe export contract naming lifetime window, aliasing rule, invalidation operation, thread rule, reentrancy rule, and cleanup responsibility.

A pointer-length view does not transfer ownership. An opaque handle transfers only the authority stated by its constructor/export contract.

### D441: Raw User Signal Handler Unsafe Contract

Raw signal handlers and interrupt handlers are unsafe-only. Installing one requires an unsafe contract naming signal/interrupt set, handler symbol, target mask/priority rules, allowed memory operations, and reentrancy class.

Handler code cannot allocate, lock ordinary locks, call ordinary Kyokai APIs, consume linear values, run destructors, access non-signal-safe foreign APIs, or re-enter Kyokai except through target-contract-listed signal-safe bridge APIs.

The safe default surface is a `SignalWatcher`/poller integration that converts signals into ordinary events outside the raw handler. Embedded targets can admit ISR bridge APIs, but each bridge must name MMIO/atomic access width, allowed registers, and fatal behavior.

### D442: Import-Sorting Formatter Mode

Default `kyokai fmt` preserves import order. A workspace or package manifest can set `fmt.sort_imports = true`; when set, all tools use the same deterministic import sorting rule.

Sorting groups imports by standard library, same workspace, external package, and target-gated import group. Within each group, imports sort by canonical package path and imported item name using byte-stable ordering. Formatter output remains idempotent. LSP format-on-save follows the manifest setting only.

### D443: Formatter Parse-Error Subtree Recovery Mode

Default `kyokai fmt` requires a complete parse. Parse failure produces diagnostics and writes no file.

A workspace or package can enable `fmt.recover_partial = true` for editor workflows. In recovery mode the formatter formats only parse-valid subtrees and leaves invalid ranges byte-for-byte unchanged. CLI recovery writes files only with an explicit `--write-partial` flag; otherwise it prints a preview or returns LSP workspace edits. CI and `kyokai fmt --check` use strict mode unless the manifest explicitly admits partial formatting for that command.

### D444: Human Diagnostic Localization

Kyokai diagnostic identity is locale-independent. Diagnostic code, JSON field names, machine fix keys, category names, and conformance goldens use canonical English identifiers.

Human CLI rendering can be localized through explicit locale selection. Missing translations fall back to English. `kyokai explain CODE` always exposes canonical English normative text and can additionally render localized prose. Localization never changes compiler behavior, diagnostic identity, fix applicability, or test expectations.

### D445: Dynamic Linking Loader Policy

Dynamic linking is admitted only when the target contract admits it. Each binary target declares linked shared objects, expected soname/install-name/import-library identity, allowed runtime search roots, and whether system default search paths are allowed.

ELF targets record `RUNPATH`/`RPATH` policy explicitly. macOS targets record `install_name` and `@rpath` roots explicitly. Windows targets record import libraries, delay-load policy, and DLL search roots explicitly. Reproducible profiles reject ambient `LD_LIBRARY_PATH`, current-directory DLL search reliance, or host-discovered rpaths unless the manifest records the exact policy.

### D446: `.koi` Compressed Wrapper Format

KBI canonical bytes remain uncompressed for semantic hashing and compatibility checks.

A compressed `.koi` transport wrapper contains canonical KBI bytes plus wrapper version, compression algorithm ID, uncompressed length, compressed length, and hash of the uncompressed canonical bytes. Tools decompress, verify the canonical hash, then operate on the canonical bytes. Unknown compression algorithms and hash mismatches are hard errors. Compression never changes `.koi` identity.

### D447: `RwLock` Fairness And Writer-Starvation Policy

Kyokai Tier-1 `RwLock[T]` uses `FairQueue` semantics. Lock requests enter a FIFO fairness queue. Multiple readers acquire together only when no earlier writer is queued. Once a writer is queued, later readers do not bypass it.

Targets whose OS primitive cannot provide this behavior must implement the fairness layer in the Kyokai stdlib/runtime or reject Tier-1 `RwLock` admission for that target. `ReaderPreferring` and target-defined priority are rejected for the standard `RwLock`.

### D448: Spawn Immutable Capture Extensibility For Synchronized Primitives

Immutable spawn capture by shared reference is allowed only for types in the closed compiler/stdlib `SpawnShareable` registry.

Initial registry: immutable `Free` values, `Atomic[T]` for admitted atomic `T`, `Mutex[T]` with admitted lock contract, `RwLock[T]` with D447 fairness contract, and explicitly admitted SPSC channel endpoints whose transfer class allows shared observation. User code cannot implement `SpawnShareable`. Adding a new spawn-shareable primitive requires a D-point, stdlib admission record, `.koi` transfer fact, and conformance tests.

### D449: Benchmark And Property Statistical Methodology

`kyokai bench` emits versioned JSON with methodology profile, compiler/toolchain version, target contract hash, optimization profile, clock source, warmup count, sample count, run count, min/median/mean/stddev, confidence interval, outlier policy, allocation metrics when enabled, and environment fingerprint.

Comparisons are valid only when methodology profile, target contract, optimization profile, and clock class match. Mismatches produce warnings or CI failure depending on configured policy.

Property tests record generator version, seed, shrink trace, sample count, discard count, and failing corpus artifact. Replaying a property failure uses the recorded seed and shrink trace exactly.

### D450: LSP Rename And Refactor Safety Classes

Kyokai LSP rename returns a `WorkspaceEdit` plus Kyokai rename safety metadata.

Safety classes are `LocalPrivate`, `ModulePrivate`, `PackagePrivate`, `WorkspaceInternal`, and `PublicInterfaceChanging`. Public-interface renames require successful name resolution, visibility check, affected `.koi` diff, and user confirmation. Broken parse recovery allows local textual rename only when the symbol is fully resolved; unresolved symbols reject rename. Cross-package rename never applies edits until `kyokai check --affected` succeeds or the client requested dry-run.

### D451: Volatile-Legal Type Domain Expansion

Volatile operations apply only to the closed volatile-legal type domain.

Admitted volatile types are fixed-width integers, fixed-width floats only when the target contract admits volatile float access, `bitrecord` register types with explicit layout, and `extern record` MMIO blocks whose fields are themselves volatile-legal. Volatile access records width, alignment, endianness when target-visible, read/write permissions, and side-effect class.

Volatile is rejected for capabilities, borrows, linear resource handles, generic `T`, ordinary records, and synchronization. Atomic operations remain the synchronization surface.

### D452: Stdlib Domain `Result` Types Vs Global Failure Taxonomy

Every stdlib failure belongs to exactly one global failure category: `RecoverableResult`, `OptionalAbsence`, `ContractViolationTPOE`, `ProgrammerBugTPOE`, or `RuntimeFatal`.

Domain error types such as `IoError`, `PathError`, `ParseError`, `NetError`, and `ProcessError` are recoverable `Result` errors unless their API contract explicitly says the condition is a contract violation. Stdlib APIs document the category in `.kyo` contract fields. `kyokai audit` rejects stdlib APIs whose implementation path and documented failure category disagree.

### D453: Inline Assembly Constraint Language And Lowering Contract

Inline assembly is admitted only inside `pragma Unsafe_Module`.

An `asm` block declares target guard, template text, named operands, operand direction (`in`, `out`, `inout`, `lateout`), register class or explicit register, immediates, symbols, clobbers, memory effect class, flags effect class, stack effect, and fallthrough behavior.

Operands are used exactly according to their direction. Unused named operands are compile-time errors. The compiler validates target availability before lowering. A backend that cannot represent an admitted asm form rejects compilation. Inline asm never introduces backend UB into safe Kyokai; all unsafety is contained in the unsafe module contract.

### D454: Recoverable Errors, Partial Mutation, And Invariant Poisoning

Fallible mutating APIs declare an error-state class: `NoMutationOnErr`, `PartialProgressOnErr`, `ConsumesOnErr`, or `PoisonedOnErr`.

`NoMutationOnErr` guarantees observable state is unchanged. `PartialProgressOnErr` lists exactly which cursor, offset, buffer, handle, or state field can advance. `ConsumesOnErr` lists the linear resources consumed and the recovery values returned. `PoisonedOnErr` means the value remains owned but operations are restricted to inspection, repair, or destruction APIs named by the contract.

Callers cannot infer rollback from `Err`. Stdlib APIs with partial mutation expose that class in `.kyo` docs and `.koi` metadata.

### D455: Bug-vs-Recoverable Failure Classification And `Result` Abuse Diagnostics

Tier-1 stdlib APIs must not encode programmer bugs, violated preconditions, impossible internal states, or invariant corruption as ordinary recoverable `Result`.

Recoverable `Result` is reserved for expected environmental, input, protocol, resource, parse, filesystem, network, process, allocation, and domain failures. Contract violations use TPOE. Explicit programmer-requested abnormal termination uses `panic`. Runtime/toolchain support failure uses runtime-fatal.

The compiler-integrated diagnostic set includes `misclassified_failure` for APIs whose declared failure category disagrees with their implementation or docs. The existing D379 `propagate-up` diagnostic remains the propagation-context warning; D455 does not create a separate `kyokai lint` command.

Diagnostics are surfaced through the shared compiler/toolchain engine used by `kyokai check`, `kyokai build`, `kyokai test`, and LSP. Project policy in `kyokai.toml` can raise advisory diagnostics, but correctness violations remain compiler errors.

### D456: Foreign Callback Reentrancy And Kyokai Re-Entry Contracts

Every foreign callback contract declares a reentrancy class: `NonReentrant`, `ForeignReentrantOnly`, `KyokaiReentrant`, or `SignalReentrant`.

Safe wrappers default to `NonReentrant`. A wrapper admits reentrancy only when it proves no active borrow, lock guard, half-consumed linear value, or capability attenuation frame can be violated by callback entry. Reentrant callbacks can receive owned linear values only through an explicit transfer into the callback frame. Reentering Kyokai outside the declared class is unsafe-contract violation.

### D457: Foreign Thread-Local Error State And Concurrent FFI

FFI wrappers that translate foreign thread-local error state must snapshot that state on the same thread immediately after the foreign call returns and before any Kyokai yield, spawn, poll wait, callback dispatch, allocation helper, logging call, or second foreign call.

Wrapper contracts name the foreign error domain: `errno`, `GetLastError`, OpenSSL error queue, or another target/library-specific domain. Non-thread-safe foreign libraries require an explicit serialization capability or are rejected from safe wrappers. Bindgen records TLS error metadata in generated unsafe contracts.

### D457a: Stdlib Poller Integration For Foreign Event Sources

Kyokai stdlib provides first-party poller integration primitives for file descriptors, sockets, timers, process handles, and admitted foreign event sources.

The admitted shape is `Poller`, `PollRegistration`, deadline/cancellation tokens, and SPSC event delivery into broker tasks. Libraries do not define competing scheduler runtimes for ordinary networking. A foreign event source integrates by implementing an unsafe adapter contract that names readiness source, wake mechanism, cancellation behavior, ownership of registered handles, and TLS-error snapshot obligations.

This does not admit async/await, green-thread scheduling, Rayon-style parallel iterators, or hidden work-stealing as language semantics.

### D458: Free-Field Projection From Linear Records Under Active Borrows

A `Free` field can be projected from a `Linear` record without consuming the record only when the record definition marks the field as independently projectable or the compiler proves no cross-field invariant can be violated.

During an active mutable borrow of another field, projection of a `Free` field is legal only when the two fields are in disjoint field regions and the record has no declared invariant tying them together. Handle+payload records, capability-bearing records, and unsafe-backed records default to non-independent fields unless their admission record says otherwise.

### D459: Auto-Reborrow Suspension Across Control-Flow Joins

Auto-reborrow suspension across `if`, `case`, loop back-edges, `break`, `continue`, `return`, and error propagation is defined by a published elaboration table.

At every control-flow join, the checker computes active access paths. A suspended mutable borrow resumes only when exactly one mutable path to the referent exists and no shared path conflicts with it. If two branches produce incompatible borrow states, the program is rejected and the diagnostic names the join point and conflicting paths. Conformance tests include every table row.

### D460: Unsafe Module Typeclass Instance Forgery And Audit

Typeclass instances declared in unsafe modules are marked as unsafe-origin instances in `.koi`.

Coherence rules apply equally to safe and unsafe instances. Security-sensitive typeclasses, including equality, ordering, hashing, display, parsing, serialization, and capability/authority traits, require explicit instance admission for secret-bearing, capability-bearing, unsafe-backed, or foreign-backed types. `kyokai audit` reports unsafe-origin instances and rejects policy-denied instances at dependency admission.

### D461: Package Provenance Attestation And Transparency Log

Published Kyokai package versions are identified by canonical source archive hash plus package identity, version, edition, and manifest hash.

The public index maintains an append-only transparency log of published package hashes. Lockfiles record content hash, log inclusion proof, consistency checkpoint, publisher identity, and index identity. Clients verify lockfiles against cached or fetched log proofs before build. Mirrors are untrusted transport; they cannot change package bytes without hash/log failure.

Build provenance attestations record builder identity, toolchain version, inputs, generated outputs, and environment class. Attestations supplement the content log and do not replace it.

### D462: Manifest-Declared Authority Ceilings And Link-Time Confused-Deputy Checks

A package manifest can declare an authority ceiling listing the maximum capability families the package and its transitive dependencies are allowed to require.

`kyokai audit` computes capability requirements from `.koi` metadata and rejects a dependency graph that exceeds the root ceiling unless the root manifest explicitly elevates the ceiling with a recorded reason. Dependencies cannot raise the application ceiling. Diagnostics name the dependency path, required capability, and declaration that introduced it.

### D463: Generational Handles And Slot-Map Safety

Kyokai admits generational handles as a stdlib container pattern.

Safe generational handles are nominal values containing slot index and generation identity. Raw integer slot IDs are not admitted as safe authority-bearing handles. Freeing a slot invalidates all handles with the old generation. Reusing a slot increments generation according to the container's documented width and wrap policy.

Lookup with a stale handle returns a recoverable stale-handle error for checked APIs. Unchecked access APIs are unsafe or TPOE-on-contract-violation, never backend UB. Handles do not own the stored resource and do not bypass linear ownership of values removed from the container.

### D464: Freestanding And Embedded TPOE Resource Abandonment

D464 does not create a new failure mode. Freestanding and embedded Kyokai use the already accepted terminal categories: normal exit, explicit `panic`, TPOE contract violation, and runtime-fatal/internal failure.

On freestanding targets, TPOE keeps D358 semantics: it is non-catchable, does not run user defers, does not unwind, and does not resume. The selected target contract states the fatal action using the existing D358 target-action surface: trap, halt, reset, existing fatal hook, or target-specific fatal handler.

The purpose of D464 is only to make hardware consequences explicit. Drivers and MMIO/DMA APIs document which external hardware resources can remain active or externally observable after TPOE/runtime-fatal termination, because fatal termination is not normal linear cleanup. That documentation is part of the stdlib/API contract fields, not a new cleanup mechanism.

Recoverable embedded conditions, such as device timeout, busy peripheral, missing clock, denied register access, allocation failure, or unsupported target feature, use `Result`/`Optional` APIs where already appropriate. They are not TPOE unless the caller violated a stated contract. TPOE stays for contract violations; runtime-fatal stays for corrupted runtime/toolchain/target-support failure.

### D465: `[generate]` Sandbox, Capability Boundaries, And Build-Time Code Execution

`[generate]` steps run in a default-deny build sandbox.

Each generator declares command identity, tool package or executable target, input roots, output roots, environment variables, network authority, process-spawn authority, filesystem read/write grants, and target/toolchain dependencies. The generator receives no `RootCapability` and no ambient application authority.

The build rejects reads outside declared inputs and writes outside declared outputs when the host sandbox can enforce it. On hosts with weaker sandboxing, `kyokai audit` marks the build as weaker and CI policy can reject it. Generated outputs record generator config hash, input hashes, tool hash, output hashes, and sandbox authority in provenance metadata. Undeclared generator authority is a build error, not a warning.

## Accepted Shape Routing Record: D466-D478

This cluster records accepted rules for validated wrapper types, configuration diagnostics, rejected task-transfer packaging syntax, parameter access spelling, conditional typeclass instances, explicit channel backpressure, nested abnormal cleanup, non-transactional I/O protocol state, compiler explain modes, hot reload as a toolchain development service, string literal allocation identity, safety-claim tiers, and public-document slogan cleanup. The normative specification chapters named in the tracker carry the extracted contracts.

### D466: Validated Wrapper Types And Construction-Time Invariants

Kyokai admits validated wrapper types as nominal types with construction-time validation. A validated wrapper is a public nominal type whose raw representation is private to its defining module. Code outside the defining module cannot construct the value by writing the raw field directly.

A validated wrapper exposes at least one constructor with the shape `makeX(input...): Result[X, XValidationError]` or an equivalent named constructor recorded in `.koi`. Validation failure is a recoverable domain error. Validation failure is not TPOE, not `panic`, and not runtime-fatal. TPOE is used only when the caller violates a documented precondition of the validation API itself, such as passing an invalid borrowed view or violating an unsafe contract.

Validated wrappers do not implicitly convert to the underlying representation. Reading the underlying value requires a named borrowing or extraction API such as `asStaticText`, `asBytes`, `intoRaw`, or a domain-specific equivalent. `intoRaw` consumes the wrapper when returning an owned linear representation.

Validators are pure by default. A validator that reads files, uses locale data, allocates, consults randomness, performs I/O, or depends on target state declares the required capability and failure classes in its admission record. `.koi` records the public wrapper type, constructor names, error type, validator purity/effect class, underlying representation visibility, and extraction APIs.

Kyokai rejects a generic magic type such as `Constrained[T, Predicate]` as core language semantics. Libraries can define generic helper patterns, but the compiler does not treat arbitrary predicate types as proofs.

### D467: `compile_error` And Configuration-Guard Diagnostics

Kyokai admits `compile_error(message);` as a protected compile-time built-in. The argument type is `StaticString`. The built-in is legal at declaration scope and in compile-time-only declaration guard positions accepted by the `when` model. It is not a runtime expression and has no value.

When `compile_error(message);` is present in an active file or active declaration selected by `when`, compilation fails with stable diagnostic code `compile_error` and the exact source span of the built-in. The diagnostic includes the provided `StaticString` message. The compiler does not continue past this point as if the declaration exists.

When `compile_error(message);` is inside an inactive `when` branch or an excluded file, it is semantically absent and produces no diagnostic.

`compile_error` complements `static_assert`. `static_assert(condition, message);` is used when a deterministic compile-time boolean expression is checked. `compile_error(message);` is used when the selected configuration itself is unsupported and no boolean proof expression is needed.

Kyokai rejects token-pasting, macros, conditional token streams, body-level target branching, and build-script-generated diagnostics as part of this decision.

### D468: Task-Transfer Isolation Packaging Rejection

Kyokai rejects `recover`, `transfer package`, `isolate`, and equivalent task-transfer packaging syntax as core language semantics.

Task transfer is decided only by the accepted D280 rules: a type is `task_local` by default, declares `task_transfer structural` to request structural transfer classification, or provides an explicit unsafe transfer contract for opaque, foreign, target-backed, or unsafe-backed representations. A value cannot become task-transferable by entering a packaging block.

The compiler checks task transfer at the transfer point: `spawn`, channel transfer across task boundaries, or any other accepted task-transfer operation. The check consumes or borrows exactly as the operation specifies. External borrows, non-transferable fields, capability leaks, open poller registrations, raw foreign handles without transfer contracts, and non-transferable synchronized primitives produce compile-time diagnostics.

The Analysis Server and `kyokai explain --linearity` can emit a task-transfer graph report showing the rejected field path, borrow path, capability path, or unsafe-contract gap. That report is tooling-only and never changes whether the source type-checks.

Runtime borrow counting, reference-count uniqueness tests, and dynamic graph isolation are rejected as safe Kyokai task-transfer semantics.

### D469: Parameter Access Kinds On Functions And Methods

Kyokai rejects new parameter access keywords such as `let`, `read`, `inout`, `consume`, `sink`, `set`, and equivalent aliases in function and method signatures.

The accepted parameter access surface remains:

- an owned parameter consumes or receives ownership according to ordinary move/linearity rules;
- `&[T]` is an immutable borrow parameter;
- `&![T]` is an exclusive mutable borrow parameter;
- return values and named out-parameters use existing explicit result and borrow rules;
- method receiver access is expressed through the same owned, immutable-borrow, and mutable-borrow forms after UFCS/method desugaring.

The compiler, generated docs, Analysis Server, and `.koi` metadata classify each public parameter into derived documentation roles: `consume`, `read_borrow`, `mut_borrow`, `return_owned`, `return_borrow`, or `capability`. These roles are derived facts, not source syntax, and cannot change overload resolution, type checking, borrowing, or ownership.

A function signature that attempts to combine a rejected access keyword with Kyokai parameter syntax is a compile-time syntax error. Diagnostics explain the equivalent accepted Kyokai spelling.

### D470: Conditional Typeclass Instances And Specialization Witnesses

Kyokai admits conditional typeclass instances with explicit compile-time constraints.

An instance declaration can state constraints over type parameters, universes, layout facts, task-transfer facts, and typeclass witnesses. The instance is available only when those constraints are satisfied after generic substitution. `.koi` records the instance head, constraint list, exported methods, behavior contract, complexity contract, and any capability or allocation requirements.

Coherence is global over the selected package graph. For any concrete use site, exactly one visible instance can satisfy the requested typeclass and type arguments. Two instances whose constraints overlap for the same concrete type are rejected unless one is private and not visible to the same resolution context. Ambiguous conditional instances are compile-time errors.

Kyokai rejects behavior-changing specialization. A more constrained instance cannot silently override a less constrained instance for the same public typeclass behavior. Performance specialization is admitted only when it preserves the same observable behavior, same failure classes, same ownership effects, same capability requirements, and same public contract. Such specialization is an implementation choice, not a different instance visible to source semantics.

Public packages changing conditional instance availability or constraints treat that as a `.koi` and SemVer-relevant API change.

### D471: Channel Backpressure Policy

Kyokai bounded channels use explicit backpressure only.

A bounded channel has a declared capacity. When the channel is full, a blocking send operation blocks at the named send call, a nonblocking send operation returns a typed `Full(value)` result preserving ownership, and a deadline/cancellation-aware send returns the accepted timeout or cancellation result preserving ownership when transfer did not occur.

The runtime scheduler cannot silently mute, throttle, park, deprioritize, or delay a task because the task previously sent to a busy receiver unless the task is currently inside a documented blocking, waiting, deadline, cancellation, or poller operation.

Overload management is expressed with bounded capacities, broker tasks, worker pools, explicit queues, `trySend`, `sendBlocking`, deadline/cancellation variants, and `wait`/Poller integration. Hidden runtime backpressure is rejected as Kyokai language and stdlib semantics.

### D472: Panic-During-Defer And Nested Abnormal Exit

Kyokai defines abnormal-exit cleanup in three states: normal cleanup, panic cleanup, and runtime-fatal termination.

On normal structured scope exit, normal `return`, recoverable `Err` return, `break`, `continue`, and accepted panic initiation, eligible `defer` actions run in D2/D2a order. A `defer` action must satisfy ordinary linearity rules.

During panic cleanup, a `defer` action that completes normally allows cleanup to continue. A `defer` action that calls `panic`, reaches TPOE, triggers runtime-fatal, violates an unsafe contract, or fails in a way its cleanup contract classifies as nonrecoverable escalates immediately to runtime-fatal. After runtime-fatal escalation begins, no additional user `defer` actions run.

TPOE and runtime-fatal do not promise user cleanup. Linear values abandoned after runtime-fatal escalation are abandoned because the execution context is dead; that abandonment is not a normal consume operation and cannot be observed by safe continuation.

The compiler-integrated diagnostic `defer_may_fail` is emitted when a `defer` action calls an API whose contract admits recoverable failure or panic/TPOE without an explicit cleanup-failure policy. Project policy can raise this advisory diagnostic, but correctness violations remain compiler errors.

### D473: Poller/Select Protocol State And Non-Transactional I/O Composition

Kyokai stdlib I/O, Poller, and protocol APIs are non-transactional unless their contract explicitly states `NoMutationOnErr` or `NoEffectOnCancel`.

Every multi-step I/O or protocol API declares:

- state advancement class: `NoProgress`, `PartialProgress`, `StateAdvanced`, `ConsumesOnErr`, or `Poisoned`;
- cancellation class from D284;
- error-state class from D454;
- buffer state after success, error, timeout, cancellation, EOF, close, and protocol rejection;
- whether user-visible cursors, offsets, sequence numbers, handshake states, poller registrations, or deadlines advanced;
- whether secrets were written into buffers and which zeroization API consumes or mutates those buffers afterward.

Poller readiness is not proof that an operation will complete. Readiness tokens authorize attempting the operation under the target backend contract. The operation can still return would-block, interruption, partial progress, EOF, timeout, cancellation, target error, or protocol error according to its contract.

Edge-triggered, level-triggered, one-shot, completion-based, signal-wakeup, descriptor-close, spurious-wakeup, and rearm behavior are target-contract facts. Target contracts cannot weaken Kyokai ownership transfer, buffer-state, or linear cleanup rules.

Stdlib examples must show accept loops, read/write loops, TLS-like handshake loops, HTTP-like protocol loops, cancellation paths, timeout paths, and buffer reset/zeroize paths using the accepted state classes.

### D474: Compiler Explain Modes For Linearity, Defer, And Lowering

D474 does not create a second analysis system. It concretizes the accepted D303/D485 toolchain shape.

`kyokai explain` is a frontend over compiler-produced facts. It reads the same parser, resolver, type checker, linearity checker, borrow checker, capability checker, lowering pipeline, and `.koi` facts as `kyokai check`, `kyokai build`, LSP, and the Analysis Server.

Accepted explain modes are:

- `kyokai explain --linearity <span-or-symbol>`;
- `kyokai explain --borrows <span-or-symbol>`;
- `kyokai explain --defer <function-or-span>`;
- `kyokai explain --lowering <span-or-symbol>`;
- `kyokai explain --koi <symbol>`;
- `kyokai explain --diagnostic <code>`.

Explain output has human and versioned JSON forms. JSON output records compiler version, target, profile, backend, source spans, symbol identity, phase, and diagnostic codes. Explain output cannot make code valid, cannot suppress diagnostics, cannot change lowering, and cannot replace the spec.

### D475: Hot Reload Toolchain Development Service

Hot reload is admitted as a Kyokai toolchain development service, not as core language semantics.

The surface belongs to toolchain profiles, build generation, dynamic loading policy, and development runtimes. It is enabled only by an explicit profile field such as `toolchain.hot_reload = true` and only on targets whose target contract supports dynamic code replacement.

Hot reload requires an explicit `HotReloadCapability`. The capability is available only from development, test, or tool roots, not from ordinary production root capability.

Reloadable declarations must have stable `.koi` identity, stable ABI fingerprint, stable layout dependencies, stable capability requirements, and stable failure contract. The reload operation rejects changes to type layout, function ABI, typeclass instance identity, capability requirements, public `.koi` identity, active stack frames, task state, poller registrations, and linear resource ownership.

Reload changes code only. Linear state is closed and rebuilt explicitly by user code when needed. Failed reload returns a structured toolchain/runtime error.

### D476: Ordinary String Literal Storage And Allocator Identity

A source string literal `"..."` denotes non-allocating static program data. Evaluating a string literal does not call an allocator, does not acquire a capability, does not construct an owning linear `String`, and does not perform runtime I/O.

The literal expression type is `StaticString`. `StaticString` is a non-owning immutable view of compiler-emitted static bytes plus encoding metadata accepted by the text spec.

`literal.toStringIn(allocator)` constructs an owning linear `String` from `StaticString` literal or static text. It takes the destination allocator explicitly, returns `Result[String, AllocError]`, preserves UTF-8 validity from `StaticString`, and returns ownership of the new `String` allocation to the caller.

No contextual typing rule retargets `"..."` into an owning `String`. Function parameters that require owning `String` reject a bare literal and suggest the explicit allocator constructor. Public APIs exposing literal/static text facts record those facts in `.koi`.

### D477: Claim Taxonomy And Evidence Labels

Kyokai keeps the normative design contract: accepted safe Kyokai semantics contain no language-level undefined behavior. This statement applies to source programs that pass the safe Kyokai checker and do not cross unsafe, foreign, backend, target, or toolchain contracts incorrectly.

Kyokai documentation and tool output label safety claims by scope:

- `SafeCore`: single-task safe language semantics excluding FFI, unsafe modules, backend lowering bugs, target faults, and concurrency primitives;
- `SafeConcurrent`: SafeCore plus accepted task, channel, lock, atomic, poller, cancellation, and happens-before rules;
- `SafeFFIWrapped`: safe Kyokai wrappers over foreign or target APIs whose unsafe contracts and capability requirements are satisfied;
- `UnsafeModule`: code inside unsafe modules, inline asm, volatile/MMIO, raw pointers, raw callbacks, dynamic loading, foreign calls, and target intrinsics;
- `BackendConforming`: generated C/LLVM/native code has been checked against the backend contract for the selected target/profile.

Each tier has an evidence state: `designed`, `specified`, `mechanized`, `tested`, or `conformance_checked`. Evidence state is maturity tracking, not a different language semantic.

The compiler can print tier and evidence metadata in `kyokai doctor`, `kyokai audit`, build reports, and package audit output. The compiler must not imply that unsafe modules, incorrect foreign contracts, backend bugs, or target faults are covered by SafeCore.

Public docs replace vague slogans with tiered claims. They do not remove the zero-language-level-UB design contract.

### D478: Retire Obsolete Slogans In Public Docs

D478 adds no new language semantics.

D478 is a public-document cleanup rule. When an accepted D-point defines the precise rule, public docs must use that precise rule instead of slogans.

The banned slogan table includes:

- `no shared memory` is replaced by the D90/D354/D342/D353 accepted concurrency vocabulary;
- `unsafe only at syscalls` is replaced by the D20/D245/D453/D456/D499 unsafe and FFI surface;
- `no hidden allocation` is replaced by allocator/capability rules plus D120/D476 string-literal rules;
- `zero UB` is replaced by D73 plus D477 claim-tier wording;
- `no async` is replaced by D282/D342/D353/D473 explicit Poller/channel/wait story.

The concurrency rationale must list accepted happens-before sources. The unsafe/FFI rationale must list accepted unsafe surfaces. The goals chapter must use D477 tier labels after D477 is accepted.

Public documents state the precise rule directly. A D-point citation is supporting traceability, not a substitute for the rule text.

## Accepted Shape Routing Record: D479-D487

This cluster is a modal-wording clarification over existing accepted shape. It does not reopen D280-D478 or any earlier decision. It states how to read and rewrite words such as `may`, `should`, `optional`, `if provided`, `if admitted`, `implementation-defined`, `unspecified`, `where relevant`, `future`, and `later` when they appear in accepted Kyokai material.

### D479: Modal Vocabulary, Conformance Duties, And Hidden Implementation Choice

Normative Kyokai text uses direct obligation and rejection language for behavior: `must`, `is required to`, `is`, `rejects`, `is illegal`, and `does not`. `Should` has no normative force in accepted shape or the spec. If the behavior is required, spec extraction rewrites it as a requirement. If the wording is only rationale, it remains in rationale prose and cannot be cited as a language, stdlib, toolchain, package, or runtime rule.

`May` is legal in accepted shape only when the same rule falls into one of these closed categories: source permission, non-observable optimization under D480, target-contract variation under D483, policy-selected behavior under D482, tooling-only assistance under D485, or future/experimental/absent boundary under D486. `Optional`, `if provided`, `if admitted`, `if implemented`, and `where relevant` are illegal in normative text unless the same paragraph names the exact conformance tier, full-conformance rule, target guard, manifest/config switch, API admission record, or separate-D-point boundary.

Kyokai rejects `implementation-defined` and `unspecified` for observable safe-language behavior. A conforming implementation is correct only when every accepted behavior has one exact normative status: required, rejected, target-gated, policy-selected, tooling-only, experimental-only, or absent from accepted stable Kyokai pending a separate D-point. These statuses classify accepted text and proposal workflow; they do not license partial implementations to omit accepted stable surfaces. Private implementation choice is not a Kyokai semantic category.

### D480: Non-Observable Optimizations, Cache Sharing, Deduplication, And Backend Choice

A compiler, backend, package manager, or cache is permitted to share, deduplicate, scalarize, vectorize, fold, reuse, or skip work only when the transformation preserves every observable Kyokai fact. Observable facts include accepted program or rejection result, diagnostic code and primary span class, `.koi`/KBI contents, public and internal semantic facts visible to the current compilation, contract evaluation behavior, capability/unsafe/audit records, target contract identity, generated-source provenance, package/build identity, stable tool JSON, required debug/profiling identity for the active profile, and runtime behavior defined by the language or stdlib contract.

Timing, memory use, emitted instruction sequence, object-file section names, and cache hit rate are not language-observable unless the active benchmark, profile, debug, or reproducibility contract makes them observable. Identical-code folding, generic-body sharing, cache reuse, portable SIMD lowering, scalar fallback, and backend helper substitution require a proof or deterministic check that all semantic inputs match. If the implementation cannot prove the match, it must not share.

Cache keys include toolchain compatibility, target contract, profile, backend, edition, KBI major version, dependency identities and hashes, feature-set package instance, source/generator inputs, relevant environment/toolchain discovery facts, and selected policy values. A failed optimization precondition falls back to the non-shared conforming implementation, or rejects only when the user explicitly requested that optimization as a required build policy.

### D481: Full Implementation, Target-Gated Surfaces, And Proposal Labels

A conforming Kyokai implementation must implement the full accepted language, toolchain contract, and standard-library surface for the support tier it claims. A partial implementation must label itself partial, experimental, bootstrap-only, or non-conforming; it must not call itself a full Kyokai implementation.

Target-gated surfaces are not optional omissions. A target-gated surface is required exactly when the selected target contract declares the needed capability, OS family, ABI, hardware feature, host facility, or toolchain feature. If the selected target contract lacks the required fact for a target-gated surface, import or use fails with a stable diagnostic before lowering. That rejection is the conforming behavior for that target.

Compatibility-only surfaces are accepted Kyokai only when isolated in named compatibility modules with warnings or contract metadata. They are still implemented by a full implementation that claims the compatibility module tier. Experimental-only surfaces are not stable Kyokai. They are non-default, excluded from stable `.koi`, rejected by stable builds unless the project opts into the exact experiment, and do not count toward full conformance.

`Absent` is not an implementation availability class or implementation mode. It is a D-point, proposal, issue, PR/MR, or search label meaning the feature is rejected, pending outside accepted shape, or absent from stable Kyokai. Reversing absence requires a new D-point. `PROJECT_STANDARDS.md` owns the public labels/tags for `required`, `target-gated`, `compatibility-only`, `experimental-only`, `tooling-only`, `absent`, `rejected`, and `blocked-on-dpoint` so public git workflow can be searched without making `Kyokaishape.md` the primary public discussion surface. Spec text does not say `if Kyokai provides X`; it says whether `X` is required for full conformance, target-gated by named target facts, compatibility-only, tooling-only, experimental-only, or absent from accepted Kyokai.

### D482: Policy-Selected Behavior, Configuration Precedence, And Reproducibility Recording

Policy-selected behavior is valid only when the spec names the policy key, allowed values, default value, command-line flag if any, manifest/config location if any, environment variable if any, precedence order, and artifact/reproducibility effect. Default precedence is explicit CLI flag, command-specific config, package manifest, workspace config, user tool config, documented display-only environment variable, then tool default. A rule that uses another order must state it explicitly.

Policy values that affect build outputs, `.koi`, diagnostics JSON, package resolution, generated source, tests, audit reports, docs JSON, or cache keys are recorded in the build plan or relevant artifact metadata. Policy values that affect only human terminal rendering are not semantic build inputs, but the tool still documents them and exposes the effective value through verbose or diagnostic output when requested. Hidden host state is not a policy source unless a D-point explicitly admits that exact variable or host fact and states whether it is display-only or semantic. A policy request that cannot be honored fails explicitly when the user selected it as required; the tool does not silently use a different behavior.

### D483: Target-Contract Conditional Behavior And Platform Differences

Every target-dependent behavior accepted by Kyokai is represented in the selected target contract or in a target-specific module contract. The target contract records at least OS family, ABI family, filesystem semantics, path representation class, process/env/argument encoding class, clock availability, signal/event model, blocking interruption model, atomic support, CPU feature baseline, dynamic linking support, native toolchain requirements, freestanding fatal action, and capability families exposed by the host.

Portable APIs expose only behavior guaranteed by the target contract. If the target lacks the required fact, import or use is rejected with a stable diagnostic before lowering. Target-specific APIs are visibly target-guarded in source and `.koi` and cannot be mistaken for portable APIs. Backend lowering cannot silently change a target contract fact. If a backend cannot implement a required target fact, the build fails for that backend, target, and profile combination. Target variation is never `implementation-defined`; it is selected-target-defined and serialized into build identity, `.koi` compatibility facts, and relevant audit reports.

### D484: Specified Nondeterminism, Fairness, Scheduling, And Replay Boundaries

Kyokai does not use `unspecified` for observable safe behavior. Cases with multiple allowed outcomes are specified nondeterminism. A specified-nondeterministic rule states the event set, eligibility rule, allowed choices, forbidden assumptions, fairness/starvation contract if any, and whether deterministic or replay modes exist.

Default `select` does not promise source-order priority or starvation freedom. Explicit biased or fair modes have named contracts when admitted. Hash-based collection iteration order is not program logic; code requiring stable order uses ordered collections or deterministic hash APIs accepted for that purpose. Scheduler and OS readiness order are not source-visible ordering guarantees; happens-before remains governed by D90 synchronization sources. Test, fuzz, property, and benchmark tools that offer replay record the seed, schedule/order class, target, profile, timing parameters, and relevant policy values needed for that replay mode. Conformance tests for nondeterministic behavior assert membership in the allowed set or trace property, not one private implementation's ordering.

### D485: Tooling Assistance, Lints, Code Actions, Reports, And Nonsemantic Help

Tooling assistance never changes whether a source program is accepted unless an accepted compiler rule or explicit project/tool policy raises that diagnostic class to an error. Tooling outputs are classified as diagnostic, lint, audit finding, proof obligation, proof result, code action, formatter edit, docs check, package advisory, benchmark report, or trace report. Each class has stable IDs, severity rules, machine-readable JSON shape, and human rendering rules under D414 and D416.

Code actions are classified as note-only, manual, maybe-applicable, machine-applicable, or machine-applicable-safe. Automatic application uses only the accepted safe class by default and validates parse, type, and format results after edit. Proof and analysis reports state scope, assumptions, unknown/inconclusive results, target/profile/tool version, and whether the result is advisory or policy-blocking. LSP, docs, audit, and explain tools use compiler-produced facts or accepted `.koi` facts where available; they do not invent alternate semantics.

### D486: Future, Experimental, Separate-D-Point, And Absence Boundaries

`Future`, `later`, `possible`, `if demand warrants`, `separate D-point`, and similar wording never accepts language, stdlib, toolchain, package, or runtime behavior. A feature absent from `kyokaidecided.md` or `kyokaispec/` is absent from stable Kyokai, even if it appears in roadmap, rationale, critique, examples, or implementation experiments.

Accepted shape must not hand a semantic requirement to an unnamed, unopened, or untracked future D-point. If accepted text says another D-point is responsible for part of a rule, that D-point must already exist as an issue, discussion, PR/MR, or pending plan entry with an identifier and linkable title. A D-point with a semantic dependency cannot move into `kyokaidecided.md`, phase closure status, or spec extraction until all blocking dependencies are decided, explicitly rejected, or explicitly marked nonblocking with the exact reason.

When review discovers that accepted wording depends on a missing decision, a maintainer opens the missing D-point and ties it back to the original point before merge. The original point remains blocked on that dependency unless the dependent part is removed from accepted shape. Experimental features are non-default, explicitly named, excluded from stable package compatibility unless marked experimental, and rejected by stable builds unless the project opts into the exact experiment. Experimental `.koi` facts are marked experimental and cannot satisfy stable dependency requirements. Reversing a rejected or absent feature requires a new D-point with final wording and acceptance. Phase order can say when work happens; it cannot justify a wrong or weakened language shape and cannot make a planned feature accepted.

### D487: Accepted-Text Modal Audit And Spec-Extraction Rewrite Rule

Every spec-extraction PR/MR and every accepted-shape update runs a mechanical modal grep or lint over touched normative text for `may`, `should`, `optional`, `if provided`, `if admitted`, `if implemented`, `future`, `later`, `where relevant`, `unspecified`, `implementation-defined`, and equivalent phrasing. The lint is intentionally blunt. It can produce false positives, but no hit is ignored. Each hit is either rewritten away or classified in the review record.

Each hit is resolved as one of: required/rejected rewrite, source permission, D480 optimization, D481 full-conformance/target-gated rule, D482 policy choice, D483 target contract, D484 specified nondeterminism, D485 tooling-only assistance, D486 experimental/absent boundary, tracked D-point dependency, or rationale-only non-normative prose. Normative spec text states the applicable category locally so the reader does not need a separate planning source to understand the rule. `kyokai doc --check-examples` includes a modal-wording lint for public spec and accepted-shape files. Until that command is implemented, PR review runs the same mechanical lint and records every classification manually. A modal hit that cannot be classified without changing semantics becomes a new pending D-point, not a silent accepted rewrite.

## Accepted Shape Routing Record: D488-D501

This cluster closes the strict-linearity pain-point pass. It does not weaken Kyokai's linear, capability, no-hidden-effect, or no-language-UB rules. The accepted shape is tooling, stdlib/API convention, diagnostics, and narrow syntax where the syntax preserves explicit ownership.

### D488: Resource-Flow Refactoring, Constructor Migration, And Linear API Change Assists

Kyokai accepts first-party resource-flow refactor assists as tooling-only behavior.

`kyokai fix`, `kyokai explain`, and the Analysis Server expose compiler-backed refactor lanes for record field addition and removal, constructor argument changes, capability parameter changes, cleanup and `defer` insertion, total destructuring repair, branch-join repair, fixture-builder repair, public `.kyo` signature repair, `.koi`/KBI diff repair, downstream package call-site migration, and generated docs/examples migration.

Each assist reports source package, target/profile/config instance, changed public surface, affected constructors, affected patterns, affected branch joins, affected cleanup obligations, affected test fixtures, affected public interfaces, affected `.koi` facts, affected downstream packages, and whether the edit is safe to apply automatically.

A machine-applicable-safe edit is accepted only after parse, type, linearity, borrow, capability, contract, format, and selected target/config checks pass after application. When exactly one semantically correct explicit repair exists, the tool can produce a machine-applicable-safe workspace edit. When more than one repair is valid, the tool produces an ordered migration checklist and non-applied candidate edits.

No refactor assist inserts hidden cleanup, hidden allocation, hidden authority, hidden default field values, hidden branch behavior, or affine discard. All edits become explicit Kyokai source checked by the same compiler pipeline.

### D489: Sound Prototyping, Stubs, And Throwaway-Code Discipline

Stable Kyokai has no mode that permits unconsumed linear values, hidden cleanup, skipped capability checks, skipped borrow checks, skipped contract checks, or ignored `.koi` compatibility.

`todo;`, `panic(message)`, explicit test-fatal helpers, and recoverable `Result` stubs are the accepted unfinished-code surfaces. They follow the accepted failure taxonomy and do not consume unrelated live linear values.

Scratch tooling such as `kyokai new --scratch` and `kyokai test --scratch` is tooling-only. It generates explicit source: fixture builders, narrow capability bundles, explicit `defer` and `errdefer` skeletons, placeholder recovery records, and non-release manifest markers.

Release builds reject scratch-only modules and scratch package markers. Promotion requires removing the marker and passing the normal parse, type, linearity, capability, contract, and package checks. Commenting out cleanup remains a compile-time error when it leaves a linear value live. Tool repair suggestions are limited to explicit source shapes: move cleanup to `defer`, return the owned value, add a recovery payload, transfer ownership to a fixture, or consume through the named release operation.

### D490: Graphs, Cyclic Data, Slot Maps, And Ownership-Indexed Data Structures

Safe Kyokai graph-like data structures use explicit owners rather than ambient shared ownership. Accepted safe families are arena-owned graphs, generational slot maps, pinned intrusive collections, owner-record state machines, and domain-specific registries with nominal handles.

The owning container is `Linear` and owns node or edge storage. External references are `Free` nominal handles, generation-checked keys, or region-bound borrows. Safe handles are never raw integers.

Lookup through a handle returns the container's declared failure type for missing, stale, wrong-owner, removed, or wrong-generation handles. Handle failure is not undefined behavior.

Removing a node with linear payload returns the payload and incident linear resources, consumes them through a named teardown operation, or rejects until dependent edges and handles are resolved. Pinned intrusive structures require pinned node types, explicit owner APIs, and unsafe audit records for internal pointer invariants. Safe APIs never expose relocation, dangling traversal, or hole states.

`Rc`, `Arc`, tracing garbage collection, and safe shared mutable graph ownership remain rejected as the default graph solution.

### D491: Partial-Failure Recovery Payloads And Transactional Builder APIs

A fallible operation that consumes or partially transforms linear inputs declares its error-state class: no-mutate-on-error, partial-progress, consumes-on-error, or transactional-builder.

When failure leaves owned linear values alive, the error variant carries a named recovery payload record. Public APIs do not use anonymous tuples for recovery. Recovery payloads are `must_use`. Each field is a live ownership obligation that the caller consumes, retries, returns, or transfers.

Transactional builders expose `begin`, step/add operations, `commit`, and `abort`. `commit` consumes the builder and returns the completed value or a named failure/recovery payload. `abort` consumes the builder and performs the contract's explicit recovery behavior.

`errdefer` remains the local cleanup tool. Recovery payloads are required when ownership crosses the failing function boundary. `kyokai explain failure-flow` shows the owned-resource state before the failing operation, the recovery payload shape, and the caller obligations.

### D492: Read-Only Access, Context Passing, And Capability Bundle Ergonomics

Observation uses immutable borrows: a function that only observes a value accepts `&[T]` and returns only its computed result. Mutation uses `&![T]` with explicit borrow scope and accepted reborrow elaboration. Observation of a linear value does not consume and return that value.

Allocator, logger, clock, random, filesystem, network, terminal, process, audit, and cancellation authority are passed as explicit values or explicit nominal bundles. A bundle is source-visible nominal data. It has no ambient lookup, no implicit parameter passing, no hidden authority minting, and no hidden allocation.

Public APIs take the narrowest authority surface that satisfies the operation. Passing `RootCapability` or a broad app context into a leaf API is diagnosed as overbroad authority unless the API is an explicit authority-construction boundary.

`.koi`, docs, Analysis Server hover, and audit output record bundle fields and parameter roles: read borrow, mutable borrow, owned consume, returned ownership, and capability authority.

### D493: Callback Invocation Classes, Repeated Stateful Callbacks, And Linear Captures

Callable values are classified as `CallableRead`, `CallableMut`, `CallableOnce`, or `CallableState`.

`CallableRead` is repeatedly callable and captures only `Free` values by value or immutable borrows valid for each call. `CallableMut` is repeatedly callable through a unique mutable borrow of the callback value. It can mutate captured state. It cannot consume a captured linear field unless it replaces that field with a valid value before returning.

`CallableOnce` consumes the callback value when invoked. It is the class that consumes linear captures. `CallableState[S]` consumes state `S` and returns the next state or a named terminal result on each call. Event loops, protocol machines, and repeated linear-state callbacks use this class.

FFI callback wrappers name invocation class, reentrancy class, thread-affinity, userdata layout, cleanup path, and capability requirements. Repeated foreign callbacks cannot hide linear state behind an untyped shared pointer. `.koi` records public callback invocation classes.

### D494: Linear Test Fixtures, Assertion Failure, And Teardown Semantics

Assertion failure is panic-class test failure unless the assertion explicitly tests a TPOE contract. `defer` cleanup runs for assertion failure according to D2b. TPOE does not run user cleanup.

`Kyokai.Test` provides linear fixture handles and cleanup registration. Registering cleanup is source-visible and consumes or borrows exactly the fixture authority named by the API. Test cleanup actions run LIFO at test or subtest scope exit. They lower to checker-visible cleanup obligations and cannot leave live linear resources.

Parallel tests receive explicit isolated capability bundles. Fixture cleanup has no authority beyond its bundle. The Analysis Server inserts fixture cleanup skeletons and warns when setup acquires a linear resource before cleanup registration or transfer.

### D495: Branch Symmetry Diagnostics, Linear Join Tables, And Pass-Through Assistance

Every branch join computes a state table for each pre-branch linear binding: unconsumed, borrowed-read, borrowed-write, consumed, moved-to-state, returned, or diverged.

A join is legal only when every non-diverging branch leaves each binding in the same state or returns a named result/state value that accounts for ownership. Diagnostics show each branch, the first statement that changed each binding state, the expected state, and the mismatching state.

Analysis Server actions can move common cleanup after the join, introduce a named `NextState` or recovery record, split early-return arms, or generate a typestate record/union. No action inserts dummy destruction, hidden pass-through, hidden affine discard, or a hidden default value.

### D496: Hole-Free Linear Collections, Element Extraction, Replacement, And Drain APIs

Safe indexing of a collection containing `Linear` elements never moves the element out by value. It returns a borrow, mutable borrow, optional borrow, or result borrow according to the collection contract.

Moving a linear element out is legal only through named invariant-preserving APIs: `pop`, `removeAt`, `swapRemoveAt`, `replaceAt`, `takeOnly`, `drain`, `intoIter`, or an admitted domain-specific equivalent.

`replaceAt` returns the old value and leaves the slot initialized with the new value. Neither value is destroyed. `swapRemoveAt` declares order destruction. `removeAt` declares order preservation and shifting cost.

`drain` and `intoIter` consume the collection or create a linear drain token. A linear drain must be exhausted or explicitly finalized. Unsafe internals can track uninitialized slots only inside audited modules with initialized-length and capacity invariants. Safe APIs never reveal holes.

### D497: Generic Linearity Families, Container Universes, And Code-Size Controls

Generic containers declare universe behavior. `Auto` containers are `Free` only when every stored field or element is `Free`; otherwise they are `Linear`.

Operations declare preconditions. Borrowing lookup is available for all admitted element types. Copying lookup is available only for `Free` elements. Moving extraction is available only through D496 APIs. Discard or clear without returning elements is available only for `Free` elements or named consuming destroy operations.

`.koi` records operation preconditions: `T: Free`, `T: Linear`, `T: Hashable`, `T: TotalOrder`, `T: task_transfer`, pinning facts, invalidation facts, and capability/target requirements.

Materialization follows D82a/D82b. Deduplication is allowed only when observable semantic facts match. Code-size controls are toolchain policy and never change source semantics. Docs render separate operation tables for `Free`, `Linear`, pinned, target-gated, and capability-gated cases.

### D498: Early Resource Release, Lock Scope Hygiene, And Deadlock-Avoidance Tooling

Every admitted resource type documents at least one named consuming release operation or an accepted `defer` cleanup path.

Users shorten lifetime through lexical scopes, explicit release calls, ownership transfer, or `defer` placed inside the smallest owning scope.

Compiler-integrated warnings cover resource acquired far before cleanup registration, `defer` in long-running loops, lock guard live across blocking calls, lock guard live across `spawn`/`join`/`select`/`wait`, nested lock acquisition without declared order, and large buffers/arenas retained across unrelated blocking work.

These warnings do not prove liveness or deadlock freedom. They are diagnostics over explicit source. Lock-order metadata, when used, is explicit API/type metadata checked by tooling.

### D499: FFI Wrapper Kits, Unsafe Translation Layers, And Safe Boundary Admission

`kyokai bindgen` generates raw `foreign` declarations, extern records, constants, layout checks, target configuration facts, compile/link probes, and unsafe wrapper skeletons.

Generated bindings are unsafe-only until a safe-wrapper admission record exists. A safe-wrapper admission record states foreign library version range, headers, target triples, symbol set, compile/link flags, ownership, aliasing, lifetime, initialization, thread-safety, callback, allocator, error-state translation, capability, cleanup, provenance hash, and audit owner.

Capability-bearing foreign operations require explicit Kyokai capability parameters in the safe wrapper. Transitional stdlib FFI wrappers are tracked in `stdlib/11-transitional-ffi-tracking.md` with replacement or permanent-boundary criteria.

### D500: Definite Initialization, Multi-Line Construction, And Builder-Block Ergonomics

Safe Kyokai rejects general uninitialized local declarations such as `let x;`. A binding is introduced by a value expression, function result, initialized pattern, or accepted construction form.

The accepted construction form is the `build` expression:

```text
let value: T = build T do
    statements...
    produce expr;
build;
```

`produce expr;` exits the nearest enclosing `build` expression and yields `expr`. Every non-diverging path through the `build` body reaches exactly one `produce` of the declared result type.

`return` inside a `build` body exits the enclosing function and must satisfy the accepted linearity, `defer`, `errdefer`, and recovery rules. `produce` exits only the `build` expression. `break`, `continue`, `yield`, and generator suspension do not target `build`.

Every produced value is fully initialized before `produce`. Partial records, omitted fields, hidden defaults, and double initialization are rejected. Linear values acquired inside `build` are moved into the produced value, consumed visibly, returned in a named recovery payload, or rejected as live at block exit.

The `build` expression lowers before type, linearity, borrow, capability, and contract checking into explicit control-flow joins. The lowered form contains no hidden destructor, rollback, allocation, defaulting, or exception path.

### D501: Standard-Library Cold-Start Mitigation, Admission Ladder, And Canonical Utility Surface

Kyokai's stdlib is a batteries-included systems stdlib, not a tiny placeholder.

The roadmap has these admission tiers: Core Pure, Core Containers, Core Text/Bytes/Paths, Core IO/OS, Core Testing/Diagnostics, Core Networking, Core Codecs, Core Crypto Policy, and Extended Protocols.

Each tier has a public checklist covering modules, D85 contract fields, conformance tests, target-contract dependencies, transitional FFI status, unsafe-audit status, docs/examples, and tier-named proof obligations. Parser, codec, collection, numeric, allocator, networking, and protocol APIs add property or fuzz tests to that checklist.

Tier-1 usability requires admitted foundations for buffers, strings and text views, paths, files, environment and arguments, formatting, tests, JSON/CBOR foundation, sockets/DNS foundation, time, random, process, and common collections.

Pure algorithms prefer native Kyokai. Transitional FFI is allowed for system boundaries and protocols only with an admission record. `PROJECT_STANDARDS.md` requires new stdlib PRs to include the admission record, tests, docs, and transitional-FFI tracking when applicable.


## Accepted Shape Routing Record: D502-D525

This cluster records the accepted infrastructure, public documentation, CLI output, Analysis Server, website, package-docs, examples, compiler-architecture, and follow-up rules. Normative contracts are extracted into the specification chapters; workflow and infrastructure contracts are routed into the workflow documents, service board, and public contribution guide named in the tracker. D525 replaces the mandatory central package-doc artifact repository with repository-owned `kdocs/`, metadata-only index records, and direct retrieval from exact indexed revisions.

### D502: Spec Table Discipline And Public Contract Matrices

Kyokai spec chapters that define user-visible behavior include the applicable contract matrix. The matrix requirement is chapter-family specific rather than one universal table.

Language behavior tables list syntax, static semantics, ownership/linearity impact, borrow impact, capability impact, lowering phase, runtime behavior, failure category, diagnostics, `.koi` facts, examples, illegal forms, and related D-points.

Toolchain behavior tables list command/API surface, inputs, outputs, policy keys, target/profile/backend effects, cache/artifact effects, network authority, diagnostics, human output lanes, JSON schema version, reproducibility facts, prompts/interactivity, exit classifications, examples, and related D-points.

Standard-library behavior tables list module/API, ownership, allocation, capabilities, blocking, cancellation, failure, invalidation, complexity, determinism, target gates, unsafe/FFI status, tests/oracles, docs examples, and admission status.

A spec PR/MR that adds accepted behavior without the applicable table is incomplete. Rationale-only, historical-only, and workflow-only documents mark that role explicitly instead of silently skipping required behavioral fields.

### D503: CLI Output, Color, Prompt, And Human/Machine Report Contract

Official Kyokai commands expose human output and stable machine output. Machine output modes are `json` and `json-lines` with explicit schema versions. Human output is stable enough for users to recognize lanes, but scripts consume machine output.

The common CLI policy surface includes `--message-format=human|json|json-lines`, `--color=auto|always|never|machine`, `--verbose`, and `--quiet`, Each command's D502 matrix lists whether it accepts those shared flags and every command-specific restriction. A restriction absent from that matrix does not exist. `machine` color policy forbids ANSI styling, progress animation, cursor movement, pager behavior, and prompts.

Human output lanes are fixed: command header, selected toolchain, selected workspace/package, target/profile/backend, dependency resolution, authority or network use, progress, diagnostics, artifact paths, cache/provenance facts, suggestions, and next actions. A command omits an empty lane rather than printing filler.

Diagnostic output uses accepted diagnostic codes, spans, labels, severity, explanations, and fix IDs. A suggestion that corresponds to a code action uses the same fix ID in human output, JSON output, `kyokai fix`, and Analysis Server responses.

Color is display policy only. Color never carries the only copy of information. `NO_COLOR`, explicit CLI policy, and machine modes disable color according to D422.

Prompts are legal only for commands whose contract declares interactivity. `build`, `check`, `test`, `fmt --check`, `doc --check`, `fix --check`, `explain`, `audit`, and every CI or machine-output invocation are noninteractive. An interactive command prints the prompt reason, default action, authority/network consequence, and noninteractive flag that would select the same action.

Machine output records schema version, command, toolchain identity, workspace/package identity, target, profile, backend, policy values, diagnostics, artifact paths, cache facts, authority/network actions, fix IDs, and exit classification. Exit classifications distinguish success, diagnostics-failed, tool-usage error, target/toolchain unavailable, dependency/index failure, sandbox failure, internal compiler error, and interrupted execution.

### D504: Full Analysis Server Feature Surface

Kyokai's Analysis Server is a required first-party toolchain component once the editor protocol is shipped. `kyokai lsp` is a protocol frontend over that server, not a separate analyzer.

The feature surface is divided into lanes: navigation, editing, diagnostics, ownership, branch/defer, capability/audit, package/build, docs, lowering/debug, migration, and CI/eval.

Navigation includes completion, hover, go-to definition, go-to type, references, rename, document symbols, workspace symbols, call hierarchy, type hierarchy, implementation lookup, module/interface-body pairing, and generated-source origin navigation.

Editing includes formatter integration, organize imports, manifest-aware package edits, safe workspace edits, safe fix preview, resource-flow refactors, public signature migration, `.koi`/KBI diff migration, test skeleton generation, docs skeleton generation, and example/doc-test insertion.

Diagnostics include compiler-backed diagnostics, warning categories, explanation links, fix IDs, diagnostic provenance, stale generated-source reports, stale interface/body reports, target/profile guards, and JSON identity matching CLI output.

Ownership and branch/defer lanes expose moved values, consumed values, live immutable borrows, live mutable borrows, reborrow chains, branch-join tables, pass-through obligations, `defer`/`errdefer` obligations, drain/finalization obligations, partial-initialization state, builder-block state, task-transfer graphs, and early-release opportunities.

Capability/audit lanes expose required capabilities, capability flow, overbroad authority warnings, unsafe-origin instances, unsafe contracts, dependency authority trees, manifest ceilings, audit records, FFI boundary wrappers, and generated binding provenance.

Package/build/docs lanes expose workspace roots, package graph, lockfile/index/vendor facts, SemVer impact, docs metadata, generated package docs, `kdocs/` cache state, examples, and doc-test status.

Lowering/debug lanes expose `kyokai explain` views, parsed surface syntax, typed elaboration, implicit completions, lowered core, generated C, source maps, layout facts, `.koi`/KBI facts, and backend provenance.

Every feature is backed by compiler/toolchain facts. The Analysis Server never defines parsing, type checking, ownership, borrowing, capability, package, formatting, or target semantics that diverge from the compiler and toolchain spec.

### D505: Debugger, Editor, And Dev-Environment Setup Bundles

Kyokai ships official editor setup bundles for Neovim, VS Code-compatible clients, and Zed after the Analysis Server launch protocol is stable. Additional editor bundles are admitted through the same thin-client rule.

Each bundle starts the same Analysis Server binary, consumes the same diagnostic/fix/explain protocol, invokes the same formatter command, reads the same package/workspace discovery facts, and displays the same source-map/generated-code/debug artifacts.

Debug setup is based on the official source-map and generated-artifact contract. Editor clients can display Kyokai source, generated C, lowered core, `.koi`, layout facts, capability facts, selected toolchain, target, profile, backend, and provenance. These views are read-only unless a separate code action produces ordinary source edits.

Editor bundles are versioned against the toolchain and Analysis Server protocol. A bundle targeting an incompatible server version fails at startup with a diagnostic naming expected version, actual version, selected toolchain, and update command.

No editor plugin defines different parsing, type checking, formatting, linting, package resolution, ownership, borrowing, capability, target, or docs semantics.

### D506: `kyokai-showcase` And Ecosystem Discovery

Kyokai maintains `kyokai-showcase` as an editorial discovery surface separate from the package index. `Awesome-Kyokai` is not the official name.

Showcase entries are discovery entries. They do not imply package safety, official support, capability admission, stdlib admission, SemVer correctness, vulnerability status, audit status, or provenance strength.

Each entry records project name, repository, license, category, package/index link when present, generated-docs link when present, supported toolchain version, last checked date, status, maintainer-provided description, and whether it is official, community, experimental, educational, or archived.

Showcase ordering is editorial. Search ranking, security/advisory badges, provenance badges, docs-quality badges, compatibility badges, official/community labels, and showcase labels remain separate facts.

### D507: Public D-Point PR/MR Workflow And `Kyokaishape.md` Retirement Boundary

New public D-points normally live in PRs/MRs labeled `d-point` once they become concrete proposals. `dpoint-needed` marks a PR/MR that revealed the need for a D-point but does not yet carry final wording.

Issues and discussions collect motivation, critique, early alternatives, and user pressure. They do not become accepted shape by themselves.

A D-point PR/MR carries final wording, accepted-shape extraction, spec edits when the spec home exists, a conformance/test plan, phase/status updates, and implementation links when relevant.

`Kyokaishape.md` is no longer the normal home for new D-point bodies. It remains an index, archive, migration ledger, and temporary holding area for points without a PR/MR.

Public D-points state one explicit rule directly. When rejected alternatives matter for future review, describe them by behavior and rationale rather than by option letters. Accepted public docs never require readers to reconstruct a rule from a menu of alternatives.

A PR/MR that changes accepted semantics does not merge until `kyokaidecided.md`, the spec home or workflow-only destination, traceability, and phase/status rows are updated. `Lead YES` can close final wording directly; it does not skip exact final text, accepted-shape extraction, traceability, or status updates.

### D508: Spec Completeness Gate And No-Maybe Public Docs

Every accepted D-point has a public destination before implementation treats it as stable: normative language spec, normative toolchain spec, normative stdlib contract, workflow-only project standard, service/infrastructure record, or historical-only archive note.

Public docs do not use `if Kyokai provides`, `maybe`, `future`, unbounded `should`, unbounded `implementation-defined`, unbounded `unspecified`, or equivalent wording for accepted stable behavior. They state the rule, target gate, policy key, tooling-only boundary, experimental boundary, workflow-only boundary, or absence.

Compiler/source behavior that differs from `kyokaispec/` or `kyokaidecided.md` is a bug unless the behavior is behind a documented non-default experimental flag or branch-local prototype and excluded from stable Kyokai.

A semantic PR/MR does not merge until spec/docs/traceability/status updates land in the same diff or the PR explicitly records that the change is experimental-only and excluded from stable Kyokai.

### D509: Output Artifacts, Generated C, And Standalone Compiler Use

`kyokai-out/` has documented artifact lanes for final binaries/libraries, `.koi`, generated C, objects, docs, reports, source maps, diagnostics JSON, audit reports, and provenance.

Requested generated C is written under `kyokai-out/<target-triple>/<profile>/<backend>/<package-name>/c_output/` unless `--out-dir` selects a different output root under D264. Internal backend-generated C used only for compilation can remain in `.kyokai-cache/` and is disposable.

`--emit-c=single` writes one deterministic C translation unit per declared backend artifact boundary. Each backend contract declares whether that boundary is the final link unit or package, and the declaration is versioned with the generated-file schema. `--emit-c=split` writes deterministic split files plus source-map and provenance records. Manifest/profile policy can request the same modes.

Generated C output records source package, source revision or workspace identity, selected toolchain, target, profile, backend, `.koi`/KBI version, source-map file, generated-file schema, and whether the file is intended for inspection only or also participates in the target compile.

Direct compiler use is accepted through official commands that bypass package discovery only when all required inputs are explicit. Direct compiler mode uses the same parser, resolver, type checker, linearity checker, borrow checker, capability checker, backend contract, diagnostics, target contract, output layout, and provenance rules as `kyokai build`. It does not define alternate semantics.

### D510: Repository `docs/` And Website Source Layout

Kyokai keeps public documentation source in the main monorepo by default.

Doc families are separated by role: `kyokaispec/` for normative spec, `docs/guide/` for tutorial and book material, `docs/reference/` for non-normative quick references derived from the spec, `docs/stdlib/` for stdlib docs source hooks and generated-doc integration notes, `docs/toolchain/` for CLI/package/workflow guides, `docs/contributing/` for contribution process, `docs/infrastructure/` for service operations, and `website/` for public website source.

The official website renders or links the spec, accepted-shape/decided page, guides, toolchain docs, stdlib docs, examples, generated package docs, roadmap/status, security/advisories, package index, showcase, and governance/D-point pages.

Website prose that describes behavior links to `kyokaispec/` or `kyokaidecided.md`. Website prose is non-normative unless it embeds or quotes exact normative spec text.

Manual website-only copies of spec rules are rejected when generated inclusion or direct linking can represent the same rule.

### D511: Examples Directory, Example Taxonomy, And CI Coverage

Kyokai maintains an official `examples/` tree with `examples/demo/` for a tour-style runnable demo and `examples/all/` for aggregate compile/check coverage.

Example categories include basics, ownership, borrowing, capabilities, stdlib, allocators, text/formatting, files/paths, networking, concurrency brokers, poller loops, FFI wrappers, packages/workspaces, tests, diagnostics, generated C, and real-tool examples.

Each example declares status: accepted, experimental, implementation-pending, or archived. Accepted examples compile under CI for their declared target once implementation exists. Runnable accepted examples run in CI when their target/capability requirements are available.

Examples that require filesystem, network, terminal, process, unsafe/FFI, target-specific OS services, or external tools declare those requirements in metadata.

Examples are not the spec. An example demonstrating behavior links to the accepted D-point or spec section.

### D512: Compiler Repository Architecture And Review Boundaries

Kyokai's compiler architecture targets explicit ownership areas: source text, lexer/parser/CST, surface AST, name resolution/imports, package/workspace loading, type/universe checking, linearity/borrow checking, capability checking, contract checking, elaboration/lowering, typed core IR, `.koi`/KBI, diagnostics, formatter, Analysis Server facts, backend-independent IR, C backend, LLVM backend migration target, runtime support, stdlib admission tools, and CLI/toolchain commands.

Each area declares input invariants, output invariants, diagnostic/span obligations, and tests.

Review ownership follows these areas. A PR/MR crossing multiple areas states why the boundary crossing is required and which invariants connect the areas.

This architecture is a migration target. Inherited Austral code can be adapted incrementally, but new Kyokai work does not deepen inherited coupling.

### D513: Reusing Open-Source Website, Playground, Docs, And CI Infrastructure

Kyokai admits reuse, forks, and adaptations of OSS infrastructure for website, playground, docs hosting, package docs, CI helpers, static-site tooling, and generated-doc tooling when license compatibility, security model, maintenance burden, and Kyokai contract fit are reviewed.

Website structure can borrow Odin-style static language-site organization and deployment patterns. Playground infrastructure can borrow Rust Playground-style frontend/backend separation, container isolation, no-network sandboxing, resource limits, compile/run views, and generated-output views. Package-docs infrastructure can borrow Odin package-doc generation, pkg.go.dev module-derived docs, and docs.rs sandbox lessons while preserving Kyokai's Git-backed source identity and package-index model.

Infrastructure reuse never imports another language's package trust model, execution authority, registry semantics, documentation authority, release model, syntax, or branding.

A reused service receives a Kyokai adapter contract naming source of truth, input/output data, auth model, sandbox authority, generated artifacts, deployment owner, update policy, license obligations, and security review status.

Forked web, docs, playground, or CI code is tracked as infrastructure, not language semantics.

### D514: Monorepo, GitHub Organization, And Repository Split Policy

Kyokai moves under a GitHub organization as the public governance and discovery home. The current personal-profile repository can remain a transition mirror until the organization migration is complete.

The main Kyokai monorepo owns compiler, stdlib, runtime, toolchain, spec, docs source, website source, examples, tests, CI, official editor bundles, and project workflow while a single repository remains reviewable.

Separate repositories are admitted for package-doc/index data, package-index metadata when isolated permissions are required, and `kyokai-showcase`. Additional repository splits require a D-point or governance decision.

A repository split records source of truth, release coupling, CI coupling, issue ownership, docs sync, version compatibility, auth/secrets boundary, deployment owner, and archival/migration policy.

Manual mirroring of docs or generated website artifacts across repositories is rejected unless automation records source commit identity and generated-output identity.

### D515: Package Docs, Index Auth, Ownership Claims, And Derived Documentation Hosting

Package docs are derived from package source, `.koi`, manifests, doc comments, examples, target/profile facts, and admitted docs metadata. Source remains ordinary Git under the accepted dependency model; the package-docs service is not canonical package source hosting.

`kyokai doc` maintains a generated `kdocs/` directory at the package root. A standalone package therefore has `project-root/kdocs/`; a workspace repository has one `kdocs/` directory under each published member package root. `kdocs/` records package identity, repository URL, exact revision, checked tag when present, selected toolchain, docs schema, target/profile docs contexts, `.koi` digest, source-map/docs provenance, license, advisory state, generation command, generated-file digest tree, and deterministic search projection.

Public package-doc indexing is derived metadata. Package owners publish docs metadata through the same package-index PR/MR or signed automation path used for release metadata. Stable Kyokai admits no additional package-index ownership flow. Adding one requires a new accepted D-point that defines identity, authorization, revocation, recovery, audit, and migration behavior before use. Early Kyokai uses signed commits and reviewed metadata instead of requiring a custom login service.

The package index records ownership claims, repository reachability, source revision, version/tag, package-root path, `kdocs/manifest.toml` digest, docs-schema version, docs search projection, package-index identity, yanks/advisories, provenance, and generation status. A docs page can be verified, stale, missing, malformed, schema-incompatible, digest-mismatched, generated from a different target context, generated from an untrusted revision, or unavailable for direct browser rendering; the UI reports that state explicitly.

A generated docs host does not grant package trust, SemVer trust, vulnerability clearance, official support, or source authority.

### D516: Local Package Documentation Storage And Offline Docs Cache

`kyokai doc` writes generated project documentation to `<package-root>/kdocs/` by default for project-local documentation. When build-output documentation is requested through the D264 output-root policy, the toolchain writes docs under `kyokai-out/<target-triple>/<profile>/<backend>/<package-name>/doc/`.

`kyokai doc --open` renders local docs. `kyokai docs --pull <pkg>` fetches package docs metadata and docs artifacts for one package. `kyokai docs --pull all` fetches docs for the resolved dependency graph.

The local docs cache is keyed by package identity, version or revision, selected toolchain, target/profile docs context, `.koi` digest, docs schema version, feature-set package instance, and dependency graph identity.

The Analysis Server and `kyokai doc --open` read local generated docs first. They perform no network access unless the user invokes an explicit network-capable docs action under the toolchain network policy.

Remote package docs are repository-owned generated artifacts retrieved from exact indexed revisions. Any later Kyokai-operated mirror is cache-aside derived infrastructure only. Local docs generated from checked source and `.koi` facts remain authoritative for the checked workspace.

`kyokai clean docs` removes local generated docs and docs cache entries without removing source, manifest, or lockfile data.

### D525: Repository-Owned `kdocs/` And Central Metadata-Only Documentation Index

Every package published to the official Kyokai package index contains a generated `kdocs/` directory at that package's root in the exact indexed Git revision. A workspace repository containing several publishable packages contains one `kdocs/` directory under each published package root. `kdocs/` is a tracked publication artifact committed to the package repository. The official Kyokai infrastructure does not require a second upload of the full documentation tree.

`kdocs/manifest.toml` records package identity, package version, repository URL, exact source revision, package-root-relative path, docs-schema version, selected toolchain identity and compatibility class, `.koi` digest, selected target/profile documentation contexts, feature-set package instance, dependency-graph identity, source-link facts, license metadata, advisory state, generation command, generated-file digest tree, deterministic documentation-search projection digest, and active-content classification. The manifest and every indexed file path are package-root-relative canonical paths. Absolute paths, `..`, symlink escapes, mutable branch references, and files outside `kdocs/` are illegal.

`kyokai doc` generates `kdocs/`. `kyokai doc --check` verifies that checked package source, `kyokai.toml`, `.koi` facts, generated files, digests, docs metadata, and exact source revision agree. It exits unsuccessfully when `kdocs/` is absent, stale, malformed, generated from another package revision, or inconsistent with the package instance.

`kyokai publish --dry-run` validates the release record and staged publication `kdocs/` tree without creating index metadata. `kyokai publish` requires the published source tree, including `kdocs/`, to be committed and reachable at one exact Git revision before it generates a ready-to-submit package-index PR/MR payload. The payload records package identity, version, repository URL, exact Git revision, package-root path, source digest, `kdocs/manifest.toml` digest, docs-schema version, docs status, raw-file adapter class, and deterministic compact search projection. It does not upload package source, copy the full `kdocs/` tree into Kyokai infrastructure, or require a custom Kyokai account.

The official package index is the central documentation discovery index. The package repository at the exact indexed Git revision is the documentation storage location. The official website retrieves documentation files through a reviewed forge raw-file adapter, verifies recorded digests, and renders structured `kdocs/` data through the official renderer. Publisher-controlled HTML, scripts, stylesheets, executable content, and active embeds are not injected into the official Kyokai website origin. Pre-rendered HTML inside `kdocs/` is a package-hosted derived artifact; the official renderer does not treat it as trusted page markup.

`kyokai docs --pull <pkg>` fetches the package's exact indexed Git revision or verified `kdocs/` subtree, verifies recorded digests and schema compatibility, and stores the result in the local docs cache. `kyokai docs --pull all` performs the same operation for the resolved dependency graph. `kyokai doc --open` renders verified local documentation without network access. The Analysis Server performs no background docs fetch.

The official browser docs surface reports `verified`, `missing`, `stale`, `malformed`, `schema-incompatible`, `digest-mismatch`, `target-context-mismatch`, `untrusted-revision`, or `browser-render-unavailable` explicitly. An unsupported Git host does not make the package unavailable: toolchain retrieval through the pinned Git revision remains valid while the official browser surface reports `browser-render-unavailable` until a reviewed adapter exists.

`kyokai-package-docs` is absent from the required bootstrap repository set. A future docs mirror is cache-aside infrastructure only. Adding one requires a separate service decision defining storage budgets, retention, regeneration, active-content policy, failure states, and deployment ownership. A mirror never becomes package authority, publication authority, canonical documentation storage, or a package-publication requirement.

### D517: Numeric Stdlib Admission, Oracles, And Test-Vector Culture

D517 does not reopen whether Kyokai admits numeric and math APIs. It closes the evidence requirement for stable numeric stdlib admission.

Every stable numeric or math API has an admission record before stable admission. The record names algorithm source, license/provenance, special-case table, accepted rounding/error bound, NaN behavior, infinity behavior, signed-zero behavior, integer overflow/underflow behavior, target/FPU dependencies, oracle implementation, test-vector source, fuzz/property strategy, and proof/audit status.

Transitional FFI math wrappers are allowed only with a tracking record that states why native Kyokai is not admitted yet and what evidence replaces or retires the wrapper.

Generated docs include special-case and error-bound tables for stable math APIs.

### D518: File-Role Diagnostics For `.kyo`, `.kai`, And `.koi`

Diagnostics, docs, CLI output, Analysis Server hovers, and package/artifact reports name Kyokai file roles before or alongside extensions.

`.kyo` is an interface source file. `.kai` is a body/source implementation file. `.koi` is a compiled interface artifact.

A diagnostic involving one of these files states the role, expected location, whether it is source or generated, and the command or rule that produced or expected it.

The compiler rejects attempts to edit, import, parse, or use `.koi` as source with a diagnostic explaining that `.koi` is generated artifact input to the compiler/toolchain, not source code.

### D519: Official Forum, Discussions, And Community Support Surfaces

Kyokai's initial public discussion surfaces are GitHub issues and PRs/MRs. GitHub Discussions is the admitted initial support and pre-proposal venue. Its service record states whether the organization has enabled it; disabled service status means the venue is unavailable, not that another venue silently gains its role.

A forum, Matrix/Discord room, mailing list, or equivalent community venue is admitted only as support and pre-proposal infrastructure. It is not normative spec, accepted shape, package trust, vulnerability authority, release authority, or implementation authority.

A discussion that becomes a semantic, toolchain, stdlib, package-index, governance, or release-shape change must be converted into a D-point PR/MR under D507 before acceptance.

The website lists each official venue with purpose, moderation status, expected response scope, archival/searchability status, and authority boundary.

### D520: Public Web Service And Subdomain Topology

Kyokai public web services are role-separated even when initially served by one deployment.

Initial service roles are main website, normative spec/docs, decided-shape/governance, package index/search, generated package docs, playground/sandbox runner, advisories/security, releases/downloads, community/forum, and showcase.

Each role declares source repository/path, deployment target, deployment owner, auth model, data source, cache policy, privacy/logging policy, artifact identity, and authority class: normative, derived, editorial, interactive, or operational.

Suggested subdomain aliases are conventional deployment names, not language semantics: `www`, `docs`, `pkg`, `play`, `forum`, `security`, `releases`, and `showcase`. The selected deployment names are recorded in the service board; alias naming does not alter authority.

A service cannot become package source authority, accepted-shape authority, semantic authority, vulnerability authority, or execution authority unless a D-point explicitly gives it that role.

### D521: Website Page Taxonomy, Public Copy Sources, And OSS Theme/Content Borrowing

The Kyokai website page taxonomy includes home, install/`bleedring`, language tour, guide/book, spec, decided shape, stdlib docs, toolchain docs, examples/demo, package index, generated package docs, playground, community, governance/D-points, contributing/spec-writing, releases, security/advisories, roadmap/status, showcase, and news/blog.

Website copy that describes behavior links to spec or accepted shape and does not become normative by itself.

Borrowed OSS website code, themes, components, page structure, deployment workflow, or content require license compatibility, attribution, provenance notes, local modification notes, and removal of foreign branding/semantics.

Kyokai does not copy another language's package, registry, forum, playground, docs, release, or trust authority model merely because it reuses visual or infrastructure patterns.

### D522: Package Ranking, Search, Badges, And Trust Separation

Package search ranking, showcase curation, docs quality, provenance status, vulnerability/advisory status, compatibility status, official/support status, and deprecation/yank status are separate displayed facts.

Kyokai does not publish one combined trust score. A package can be popular and unsafe, well-documented and unaudited, official and deprecated, experimental and highly ranked in search, or community-maintained and strongly proven.

Search ranking inputs are documented. Security/advisory badges come from the advisory system. Provenance badges come from content/log verification. Docs-quality badges come from docs generation and docs checks. Official/community/showcase labels come from editorial policy.

`kyokai add`, `kyokai audit`, package-index UI, and package docs warnings use provenance, advisory, compatibility, and policy facts rather than showcase placement.

### D523: Public Spec-Writing And Accepted-Shape Authoring Guide

Kyokai provides a public spec-writing and accepted-shape authoring guide in `docs/contributing/spec-writing.md` and links it from `PROJECT_STANDARDS.md`.

The guide explains D-point anatomy, final-shape wording, rejected alternatives, modal-word rules, required contract tables, spec homes, examples, diagnostics, target gates, toolchain behavior, stdlib admission records, traceability, and PR/MR checklists.

The guide is self-contained and links the public sources contributors use.

A D-point PR/MR that asks contributors to write spec prose links this guide and identifies the specific spec chapter/table template required.

### D524: Public Infrastructure Work Board And Service Ownership Records

Kyokai maintains an infrastructure/service ownership board once more than one official public service exists.

Each service record names role, repository/path, owner, deployment target, source-of-truth input, generated artifacts, auth model, secrets policy, data retention, privacy/logging policy, backup/restore policy, incident contact, status, and relevant D-points.

The board distinguishes normative/spec services, derived docs/search services, interactive sandbox services, community services, release/security services, and editorial services.

Infrastructure status does not decide language semantics. A service that needs semantic, package, release, vulnerability, or execution authority must point to an accepted D-point and spec section.


## 1. Austral As It Stands

This section profiles the Austral base Kyokai is forked from. The main evidence is the inherited spec material now living under `kyokaispec/`, the current compiler source in `lib/`, Borretti's blog posts, and the upstream Austral compiler/tests where inherited behavior still matters.

### 1.1 Core Language Rules

Austral is defined by a small set of invariants that Kyokai **must preserve**:

**Type Universe System** (spec: `4.types.md`, lines 6–75):

- Every type belongs to exactly one of two **universes**: `Free` or `Linear`.
- `Free` types can be used any number of times (integers, booleans, records containing only Free types).
- `Linear` types must be used **exactly once** — not zero times, not two times. This is the foundation of resource safety.
- The `Auto` classifier lets generic types defer universe selection: `Box[Int32]` is `Free`, `Box[SomeLinearType]` is `Linear`.
- Linearity is **viral**: if a record contains a `Linear` field, the record itself becomes `Linear`. You cannot sneak a linear type into a free container.

**Reference: spec `4.types.md` lines 17–24**: "A type T is affine if: 1. It contains another affine type (structurally affine). 2. It is declared to be an affine type (declared affine)."

**Module System** (spec: `3.modules.md`, lines 1–98):

- Every module has two files: an **interface** (`.aui` in Austral, `**.kyo`** in Kyokai) and a **body** (`.aum` in Austral, `**.kai`** in Kyokai).
- The interface declares public API. The body provides implementations plus private declarations.
- Types can be **opaque** (importable but not constructible from outside), **public** (fully visible), or **private** (body-only).
- Modules that use FFI or unsafe operations must be marked with `pragma Unsafe_Module`.

**Reference: spec `3.modules.md` lines 6–11**: "The interface contains declarations that are importable by other modules, as well as an optional private section of declarations that are available within the module but not importable."

**Linearity Rules** (blog: `how-australs-linear-type-checker-works.md`, lines 88–571):

The linearity checker is ~600 lines of OCaml doing abstract interpretation. It enforces 11 rules:


| Rule | What It Enforces                                                            |
| ---- | --------------------------------------------------------------------------- |
| 1    | Variables of a linear type cannot appear zero times in their scope          |
| 2    | Values of a linear type cannot be silently discarded                        |
| 3    | Linear variables outside an `if` must be consumed in ALL branches or NONE   |
| 4    | Same as Rule 3 but for `case` statements                                    |
| 5    | Linear variables defined outside a loop cannot be consumed inside the loop  |
| 6    | Accessing a `Free` field of a `Linear` record doesn't count as consuming it |
| 7    | Every linear variable must be consumed before a `return` statement          |
| 8    | Borrowing cannot happen after consumption                                   |
| 9    | Same variable cannot be mutably borrowed multiple times in one expression   |
| 10   | A linear variable cannot be consumed inside a `borrow` that borrows it      |
| 11   | Cannot mutably borrow what's already mutably borrowed                       |


**Reference: blog `how-australs-linear-type-checker-works.md` lines 520–573**: The algorithm uses a state table mapping variable names to `(loop_depth, var_state)` where `var_state` is one of `Unconsumed | BorrowedRead | BorrowedWrite | Consumed`.

**Borrowing** (blog: `introducing-austral.md` lines 767–796):

- Two reference types: `&[T, R]` (immutable) and `&![T, R]` (mutable), parameterized by type and region.
- Shorthand syntax: `&x` and `&!x` create anonymous-region references that cannot escape the call site.
- General syntax: `borrow x as ref in R do ... end` gives the region a name.
- Regions exist only in their lexical scope — the type of an escaped reference literally cannot be written.

**Reference: blog `how-australs-linear-type-checker-works.md` lines 430–431**: "And the way Austral ensures that references do not outlive the thing they reference is very simple. There's no need to do sophisticated control flow analysis. There's no way to write the type of a reference outside the scope where that reference is defined."

**Capability-Based Security** (blog: `how-capabilities-work-austral.md`, lines 9–167):

- Capabilities are linear types representing unforgeable permission tokens.
- `RootCapability` is the base: only available as the first argument of the entrypoint. Cannot be created in userspace.
- Each capability type defines `acquire(root: &![RootCapability, R]): MyCapability` and `surrender(cap: MyCapability): Unit`.
- Because capabilities are linear, they cannot be duplicated. Because there's no global state, they can't be stashed.
- Because of opaque types + strict module encapsulation, capabilities cannot be forged.

**No Hidden Control Flow** (blog: `introducing-austral.md` lines 152–193 — "Anti-Features"):

- No garbage collection, no destructors, no exceptions, no stack unwinding.
- No implicit function calls, no implicit type conversions.
- No global state, no runtime reflection, no macros, no annotations.
- No type inference (types flow in one direction only).
- No operator precedence (all binary expressions deeper than one level must be parenthesized).
- No variable shadowing, no uninitialized variables, no pre/post increment.

**Error Handling** (spec rationale: `rationale/2.error-handling.md`, lines 1–532):

Austral categorizes errors following Sutter/Midori into 5 categories:

1. **Physical failure** — nothing can be done.
2. **Abstract machine corruption** (stack overflow) — terminate.
3. **Contract violations** (overflow, bounds, assertions) — **terminate program** (TPOE). This is the critical decision.
4. **Allocation failure** — return `Optional` type. Programmer must handle explicitly.
5. **Error conditions** ("file not found") — values + control flow.

**Why TPOE over exceptions**: The spec rationale dedicates 20+ pages to proving that RAII + destructors + unwinding is fundamentally flawed:

- **Double-throw problem** (`rationale/2.error-handling.md` lines 294–337): What happens when a destructor throws? C++ aborts. Rust ignores errors in `Drop`. Both are unsatisfactory.
- **Libraries can't rely on destructors** (`rationale/2.error-handling.md` lines 409–438): `panic=abort` vs `panic=unwind` is a compile-time toggle that the *application* decides, not the library.
- **Hidden control flow**: Destructor calls are inserted by the compiler invisibly. This violates Austral's visibility principle.
- **Affine types cannot force cleanup** (`rationale/2.error-handling.md` lines 326–337): With affine types, dropping without consuming triggers the destructor. The compiler won't force you to call `close()` — it'll just silently insert destructor calls. This is exactly the kind of hidden behavior Austral rejects.

**Why linear types over affine** (`rationale/3.resource-types.md` lines 1–243):

- Linear types **force** consumption. You MUST call `closeFile(f)`. The compiler won't silently clean up after you.
- This means every resource lifecycle is visible in source code. No surprise `Drop` calls.
- The tradeoff: you have to type more (thread values through, use borrowing). But the code is honest.

**Reference: `rationale/3.resource-types.md` lines 223–230**: "Austral takes the approach that a language should be simple enough that it can be understood entirely by a single person reading the specification. Consequently, a programmer should be able to read a brief set of linearity checker rules, and afterwards be able to write code without fighting the system."



### 2.3 Standard Library Gaps

This is the largest gap. Organized by what can be implemented **in pure Kyokai** (no unsafe, no FFI) vs what **requires unsafe internals**.

#### Pure Kyokai — No Unsafe Required

These can be implemented using only existing language features. The compiler already has everything needed.


| Module                            | What It Provides                                                                                                                                                                                  | Hardness                                                                                                                                                           |
| --------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `Kyokai.Math.Int`                 | `abs()`, `min()`, `max()`, `clamp()`, `gcd()`, `lcm()`, `isPowerOfTwo()`, `nextPowerOfTwo()`, `countLeadingZeros()`, `countTrailingZeros()`, `popcount()`, wrapping/saturating/checked arithmetic | 2/10 — pure integer arithmetic                                                                                                                                     |
| `Kyokai.Math.Float`               | `abs()`, `min()`, `max()`, `clamp()`, `isNan()`, `isInf()`, `isFinite()`, `floor()`, `ceil()`, `round()`, `trunc()` — all implementable via bit manipulation on IEEE 754                          | 4/10 — need to understand IEEE 754 bit layout                                                                                                                      |
| `Kyokai.Math.Trig`                | `sin()`, `cos()`, `tan()`, `asin()`, `acos()`, `atan()`, `atan2()` — Taylor/Chebyshev polynomial approximations. NOT wrapping libm. Pure computation.                                             | 6/10 — needs careful numerical analysis for precision. Reference: FDLIBM, Cephes, musl libm source. These are pure math — no syscalls, no state, just polynomials. |
| `Kyokai.Math.Exp`                 | `exp()`, `ln()`, `log2()`, `log10()`, `pow()`, `sqrt()` via Newton-Raphson and range reduction                                                                                                    | 6/10 — same as trig, pure computation                                                                                                                              |
| `Kyokai.Compare`                  | `PartialEquality`, `Equality`, `PartialOrder`, `TotalOrder` + instances for ALL builtin types. Currently only interfaces exist.                                                                   | 2/10 — mechanical                                                                                                                                                  |
| `Kyokai.Compare.Span`             | `spanEquals()`, `spanCompare()`, `spanStartsWith()`, `spanEndsWith()`, `spanContains()`, `spanFind()`, `spanFindLast()` for ordinary byte-oriented workloads                                     | 3/10 — pure byte comparison loops                                                                                                                                  |
| `Kyokai.String.Ops`               | String comparison, concatenation, slicing, searching, trimming, case conversion, all built on top of `Span` and `Buffer`                                                                          | 4/10 — builds on Compare.Span                                                                                                                                      |
| `Kyokai.String.Format`            | Generalized integer-to-string and float-to-string formatting.                                                                                                                                   | 5/10 — number formatting is surprisingly tricky (Dragonbox/Ryū for floats)                                                                                         |
| `Kyokai.Collections.SortedBuffer` | In-place sorting of `Buffer` contents. Quicksort, mergesort, insertion sort. Pure algorithms on existing `Buffer`.                                                                                | 3/10                                                                                                                                                               |
| `Kyokai.Collections.RingBuffer`   | Fixed-capacity ring buffer. Useful for I/O buffering.                                                                                                                                             | 3/10                                                                                                                                                               |
| `Kyokai.Collections.Deque`        | Double-ended queue built on ring buffer                                                                                                                                                           | 3/10                                                                                                                                                               |
| `Kyokai.Bits`                     | Bitwise utilities: `rotateLeft()`, `rotateRight()`, `byteSwap()`, `setBit()`, `clearBit()`, `testBit()`                                                                                           | 1/10                                                                                                                                                               |
| `Kyokai.Ascii`                    | `isDigit()`, `isAlpha()`, `isAlnum()`, `isSpace()`, `isUpper()`, `isLower()`, `toUpper()`, `toLower()`                                                                                            | 1/10                                                                                                                                                               |
| `Kyokai.Args`                     | Command-line argument parsing. Uses existing `argumentCount()` and `nthArgument()` builtins. Flag/option/positional parsing.                                                                      | 4/10                                                                                                                                                               |
| `Kyokai.Result`                   | `Result[T, E]` union type. `ok()`, `err()`, `isOk()`, `isErr()`, `unwrapOr()`, `map()`, `flatMap()` for explicit error propagation.                                                              | 2/10                                                                                                                                                               |
| `Kyokai.Optional`                 | Enhanced `Optional[T]` with `map()`, `flatMap()`, `unwrapOr()`, `isSome()`, `isNone()`                                                                                                            | 2/10                                                                                                                                                               |


**Why not wrap libm?** Functions like `sin()`, `cos()`, and `sqrt()` are pure mathematical computations. They take a number and return a number. No syscalls, no state, no side effects. There is no good language-design reason to call through C FFI for what is fundamentally polynomial evaluation and range reduction. FDLIBM (Freely Distributable LIBM) and musl's libm provide reference implementations that are well-tested, well-documented, and can be translated to Kyokai directly. The result is zero unsafe code for the core math library.

**Reference for pure math implementations**:

- FDLIBM source: `https://www.netlib.org/fdlibm/` — Sun Microsystems' reference math library, public domain.
- musl libc `src/math/` — each function is a standalone file, BSD-licensed.
- The Cephes mathematical library — Stephen Moshier's comprehensive implementation.

#### Requires Unsafe Internals — Thin Trust Boundary

These need C FFI or pointer arithmetic internally, but expose a safe linear API.


| Module                                                      | What It Provides                                                                                                                                             | Hardness             | Why Unsafe                                           |
| ----------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------------------- | ---------------------------------------------------- |
| `Kyokai.IO.File`                                            | File I/O: `open()`, `read()`, `write()`, `close()`, `seek()`, `stat()`.                                                                                      | 5/10                 | Syscalls (`open`, `read`, `write`, `close`, `fstat`) |
| `Kyokai.IO.Terminal`                                        | Terminal I/O with capability-secure API.                                                                                                                     | 4/10                 | `isatty()`, terminal ioctl                           |
| `Kyokai.IO.Stdin` / `Kyokai.IO.Stdout` / `Kyokai.IO.Stderr` | Standard streams with capability                                                                                                                             | 3/10                 | File descriptors 0/1/2                               |
| `Kyokai.IO.Dir`                                             | Directory operations: `openDir()`, `readDir()`, `closeDir()`, `mkdir()`, `rmdir()`                                                                           | 5/10                 | `opendir`, `readdir`, `closedir` syscalls            |
| `Kyokai.IO.Path`                                            | Path manipulation — this CAN be mostly pure (string operations on paths) with syscall for `realpath`/`stat`                                                  | 4/10                 | `realpath` needs syscall, rest is pure               |
| `Kyokai.Memory.Allocator`                                   | Allocator abstraction. Currently everything uses the default allocator. This would let users provide custom allocators to containers.                        | 7/10                 | `malloc`/`free`/`realloc`                            |
| `Kyokai.Env`                                                | Environment variable access: `getEnv()`, `setEnv()`                                                                                                          | 2/10                 | `getenv` syscall                                     |
| `Kyokai.Process`                                            | Process spawning: `fork()`, `exec()`, `waitpid()`, `pipe()`                                                                                                  | 7/10                 | All POSIX process syscalls                           |
| `Kyokai.Time`                                               | Monotonic and wall clock time: `now()`, `elapsed()`, `sleep()`                                                                                               | 4/10                 | `clock_gettime` syscall                              |
| `Kyokai.Random`                                             | Cryptographically secure RNG via `getrandom()` syscall, plus PRNG (xoshiro256) for non-crypto use. The PRNG itself is pure — only seeding needs the syscall. | 4/10                 | `getrandom` for seeding                              |
| `Kyokai.Net.Socket`                                         | TCP/UDP sockets: `socket()`, `bind()`, `listen()`, `accept()`, `connect()`, `send()`, `recv()`, `close()`                                                    | 8/10                 | All networking syscalls                              |
| `Kyokai.Net.DNS`                                            | DNS resolution: `getaddrinfo()`                                                                                                                              | 6/10                 | `getaddrinfo`                                        |
| `Kyokai.Collections.HashMap`                                | Hash map with linear keys/values. Needs internal pointer arithmetic for the hash table.                                                                      | 7/10                 | Internal array management, hashing                   |
| `Kyokai.Collections.HashSet`                                | Hash set built on HashMap                                                                                                                                    | 3/10 (after HashMap) | Delegates to HashMap                                 |


**POSIX-wrapper prior art**: Safe wrapper designs demonstrate that most `string.h` operations (`strlen`, `memcpy`, `memcmp`, `memset`) can be implemented as pure routines and that buffered I/O can be built safely on top of raw `read`/`write`. The unsafe boundary is narrower than expected: it is primarily the syscall interface itself.

---

## 3. The Kyokai Philosophy

Extending Austral while respecting its vision. These are the Kyokai invariants that go beyond Austral's.

### 3.1 Unbreakable Rules (carried from Austral)

1. **Zero undefined behavior** — this is the intended language contract. The spec aims to define behavior for every program the compiler accepts, and D143 commits the project to formalize that claim rather than leaving it as prose alone.
2. **No hidden control flow** — if it's not in source, it's not happening. No invisible destructors, no implicit copies, no hidden allocations.
3. **Compile-time safety checking with proof-oriented intent** — resource safety is enforced statically rather than by hidden runtime machinery. D143 commits the project to a paper proof for the sequential core before `v1.0`, followed by a later mechanized proof after self-hosting.
4. **Everything consumed** — every linear value must be explicitly consumed. The compiler will never silently clean up after you.
5. **No hidden or semantically significant implicitness** — the compiler may insert or complete an omitted operation only when the D87 tautology rule is satisfied; otherwise the programmer must write the operation explicitly.

### 3.2 Kyokai Additions

1. **Minimize unsafe to the absolute physical minimum** — if a function can be implemented in pure Kyokai, it WILL be. Math, string ops, sorting, data structures — no wrapping C when the algorithm is pure computation. Unsafe exists only at the syscall boundary and nowhere else.
2. **100% correct or it doesn't ship** — every module is verified against its specification. Every function has documented behavior for all inputs. Edge cases are handled, not hand-waved.
3. **No compromise on correctness for ergonomics** — we'll add syntax sugar (like `defer`) only when it preserves full visibility. If a feature would hide behavior, it doesn't get added.
4. **The Implicit-Operation Rule (Tautology Rule)** — Kyokai's philosophy is NOT "no implicit anything." It IS "no ambiguous, effectful, or semantically surprising implicitness." Specifically: **the compiler may insert or complete an omitted operation implicitly if and only if (1) it is uniquely determined by the static types and surrounding context, (2) all alternative programs are statically ill-typed, and (3) the implicit completion does not introduce any new control flow, allocation, or side effects beyond what the explicit program already implies.** This rule governs D7b (auto-reborrow), D8 (implicit Unit return), D12 (literal inference), D15 (`or return` sugar), D34 (auto-deref for fields), and D46 (let inference). If a proposed feature cannot satisfy all three conditions, it is not eligible for implicit treatment. **[STAGE: DECIDED_CORE_SEMANTICS | D87 → formal tautology rule for effect-neutral implicit completion]**

### 3.3 What Kyokai Changes From Austral

These are deliberate departures:

- `**Kyokai.`* namespace** instead of `Standard.`* — clean break, clearly different project. "Boundary" (境界) is the project identity — every type, resource, and capability has explicit boundaries. The namespace reflects that. **[STAGE: DECIDED_CORE_SEMANTICS | D1 → `Kyokai.` namespace break]**
- **Richer stdlib** — Austral's stdlib is intentionally minimal because Borretti was focused on the compiler. Kyokai's stdlib is the goal.
- **Kyokai uses copyleft for the toolchain and a runtime exception for target-linked runtime/stdlib code** — the compiler stays reciprocal, while programs built with Kyokai are not forced to adopt the compiler's GPL license merely because they link the Kyokai runtime, standard library, or compiler-emitted helper code.
**Rules**:
  1. Kyokai-owned compiler and toolchain source files are licensed under `GPL-3.0-or-later` unless a file has an explicitly stated compatible license notice.
  2. "Compiler and toolchain" includes the frontend, parser, resolver, type checker, linearity checker, capability checker, optimizer, C backend, LLVM backend migration target, package manager, formatter, LSP, documentation generator, test runner, conformance harness, and ordinary compiler support tools.
  3. Kyokai-owned runtime library, standard library, startup code, compiler support library, target-side panic/TPOE helpers, allocation/runtime shims, and compiler-emitted target helper code that may be linked, copied, embedded, or otherwise combined into user target programs are licensed under `GPL-3.0-or-later WITH GCC-exception-3.1`.
  4. Source files covered by the runtime exception must carry an SPDX notice of `SPDX-License-Identifier: GPL-3.0-or-later WITH GCC-exception-3.1` or an equivalent explicit notice naming GPLv3-or-later plus the GCC Runtime Library Exception 3.1.
  5. Compiler/toolchain-only source files must carry `SPDX-License-Identifier: GPL-3.0-or-later` or an equivalent explicit GPLv3-or-later notice.
  6. The repository must include the full GPLv3 license text and the full GCC Runtime Library Exception 3.1 text before any public source release that claims this license policy. Recommended paths are `COPYING` or `LICENSES/GPL-3.0-or-later.txt` for GPLv3 and `COPYING.RUNTIME` or `LICENSES/GCC-exception-3.1.txt` for the exception.
  7. A user's Kyokai source code and resulting target program are treated as independent modules for license-policy purposes when they merely use the Kyokai runtime, standard library, public interfaces, or exception-covered target helpers through the ordinary compilation/linking process.
  8. Such target programs may be distributed under terms chosen by the program's author, including non-GPL terms, subject to the user's own code and dependency licenses and the conditions of the runtime exception.
  9. The runtime exception does not relicense the Kyokai compiler, package manager, formatter, LSP, backend, or other toolchain source. Distributing modified Kyokai toolchain code still follows GPLv3-or-later.
  10. The runtime exception also does not allow taking Kyokai runtime or standard-library source code itself and distributing modified versions outside the GPLv3-or-later plus exception terms.
  11. Public release tooling must be able to distinguish compiler/toolchain files from target-linked runtime/stdlib/helper files so generated license manifests, source headers, packages, and binary distributions do not blur the boundary.
  12. Before a public legal release, the project must verify the exact notice text and file layout against the official GNU/FSF texts and SPDX identifiers. If legal review requires a Kyokai-specific runtime exception text because the official GCC exception text is GCC-specific, that review may replace the notice wording while preserving this decided intent: reciprocal Kyokai toolchain, permissive licensing freedom for user target programs linked with Kyokai runtime/stdlib code.
  **Why this fits Kyokai**: Kyokai wants an open compiler ecosystem without making commercial, proprietary, permissive, or differently copylefted Kyokai applications legally unusable. The license boundary mirrors the technical boundary: compiler/toolchain changes remain shared, while target programs remain the user's work unless they actually incorporate modified Kyokai runtime/stdlib code outside the exception.
  **[STAGE: DECIDED_CORE_SEMANTICS | D263 → compiler/toolchain `GPL-3.0-or-later`; runtime/stdlib/target helpers `GPL-3.0-or-later WITH GCC-exception-3.1`]**
- **Build output and cache layout are fixed by the toolchain contract** — `kyokai build` does not leave artifact locations to convention. A workspace build writes user-visible products under the workspace root by default; a standalone package build writes them under the package root by default. The default output root is `kyokai-out/`; the default disposable cache root is `.kyokai-cache/`.
**Rules**:
  1. The owner root is the workspace root for workspace builds and the package root for standalone package builds.
  2. User-visible build artifacts are written under `<out-root>/<target-triple>/<profile>/<backend>/<package-name>/`.
  3. Standard output subdirectories are `bin/`, `lib/`, `koi/`, `gen/`, `doc/`, `reports/`, and inspectable `obj/` when a profile or flag asks for object files as user-visible artifacts.
  4. Tool-private incremental state is written under `<cache-root>/<toolchain-compat>/<target-triple>/<profile>/<backend>/<package-name>/`.
  5. `--out-dir <path>` selects the user-visible output root for the command. `--cache-dir <path>` selects the disposable cache root for the command.
  6. `kyokai clean` removes cache state by default. `kyokai clean --outputs` removes output artifacts. `kyokai clean --all` removes both selected output and cache roots, but not source files, `kyokai.toml`, `kyokai.lock`, or package index/cache state outside the selected cache root.
  7. `kyokai run` executes from the output tree unless a target runner requires staging. Test/bench harness private state may live in the cache tree, while requested reports live under `reports/` or stdout.
  8. The output path is not a source semantic input. It becomes a build-identity input only when artifact contents record paths; reproducible profiles must use path remapping unless absolute path embedding is explicitly requested.
  **Why this fits Kyokai**: target/profile/backend/package facts already affect artifact identity, so the directory tree should say those facts out loud. Keeping `kyokai-out/` separate from `.kyokai-cache/` also keeps user-inspectable products separate from disposable compiler machinery.
  **[STAGE: DECIDED_CORE_SEMANTICS | D264 -> default `kyokai-out/` plus `.kyokai-cache/`; target/profile/backend/package output partition; explicit clean and override behavior]**
- **`.koi` has a concrete canonical artifact format** — `.koi` is not an opaque compiler cache and not a pretty source file. It is the canonical checked package interface artifact, stored as a structured binary container named Koi Binary Interface version 1 (`KBI-1`), with official inspection commands for humans and tools.
**Rules**:
  1. A `.koi` file begins with the magic bytes `KOI\n`, then fixed-width little-endian container version fields, section count, and section-table offset.
  2. The section table is sorted by numeric section id. Duplicate section ids are illegal. Unknown required sections are unsupported; unknown optional sections may be skipped but remain covered by artifact hashes.
  3. Required KBI-1 sections are `manifest`, `producer`, `target`, `sources`, `imports`, `declarations`, `types`, `typeclasses`, `instances`, `generics`, `contracts`, `unsafe_audit`, `docs`, and `hashes`.
  4. `.koi` represents the checked interface graph after parsing, name resolution, target selection, declaration-guard evaluation, type checking, typeclass checking, contract checking, capability checking, and unsafe-audit coverage checking for interface-affecting inputs.
  5. `.koi` does not preserve unchecked source syntax, private body declarations, comments except through doc metadata, or statement bodies except where generic materialization metadata is explicitly required.
  6. Public declarations are visible to downstream packages. Internal declarations may be present for same-package tooling and incremental checking but must be ignored outside the producing package. Private `.kai` declarations never become name-resolvable `.koi` declarations.
  7. Types are encoded as canonical typed graph nodes, not pretty-printed source strings. Typeclasses, instances, contracts, capabilities, unsafe audit data, and generic materialization metadata have explicit records and compatibility classes.
  8. A compiler may consume a `.koi` only when edition, KBI major version, target contract identity, backend/generic materialization compatibility class, required built-in/stdlib interface identity, dependency package identity, and dependency artifact hashes match the lockfile and compatibility table.
  9. `kyokai koi verify`, `kyokai koi print --format json|text`, and `kyokai koi diff` are official inspection commands. Derived print output is not a second artifact authority.
  10. Malformed structure, invalid UTF-8 strings, noncanonical ordering, hash mismatch, unsupported KBI major version, edition mismatch, target mismatch, dependency hash mismatch, missing required references, and visibility violations are rejection errors.
  **Why this fits Kyokai**: separate compilation needs rich metadata, but Kyokai's tooling also needs inspectability for docs, audit, SemVer, LSP, releases, and debugging. A canonical binary artifact with official inspection keeps one source of truth without reducing `.koi` to a compiler memory dump.
  **[STAGE: DECIDED_CORE_SEMANTICS | D265 -> canonical KBI-1 `.koi` binary container with required sections, explicit compatibility, and official verify/print/diff commands]**
- **Project creation commands are part of the toolchain contract** — a language that requires explicit package and module roots must not leave the first project layout to tutorial folklore. `kyokai init` and `kyokai new` create explicit manifests and source roots instead of relying on hidden defaults.
**Rules**:
  1. `kyokai init` creates a project in the current directory and refuses to overwrite an existing package/workspace by default.
  2. `kyokai new <path>` creates a new directory and initializes it from an official template.
  3. Official templates are `package`, `workspace`, `library`, `executable`, and `empty`.
  4. Generated package manifests include `[package]`, `version`, `edition`, and `[layout].module_root = "src"` unless the user explicitly chooses another valid relative module root.
  5. Workspace templates write `[workspace].members` and do not infer package membership from directory shape.
  6. Template expansion is deterministic for the same toolchain version and flags.
  7. The commands may create starter `.kyo`/`.kai`, test, doc, or CI files only through documented template behavior or explicit flags.
  8. Project creation commands do not resolve dependencies, contact package indexes, or run generated source. Stable `kyokai init` and `kyokai new` expose no flag that changes this rule.
  **Why this fits Kyokai**: daily use starts at project creation. If the first command hides layout policy, the whole explicit package model starts with a lie.
  **[STAGE: DECIDED_CORE_SEMANTICS | D266 -> `kyokai init` and `kyokai new` with deterministic templates and explicit layout]**
- **Diagnostic explanation and safe fix application are first-party daily tooling** — diagnostic codes matter only if users can ask what they mean, and automatic fixes matter only if they are bounded by the same compiler truth as the diagnostic.
**Rules**:
  1. Every released diagnostic code has a local explanation catalog entry shipped with the toolchain.
  2. `kyokai explain <code-or-category>` prints the installed toolchain's explanation for a diagnostic code, warning category, lint category, audit category, or exit status.
  3. The explanation includes meaning, common causes, repair patterns where known, related codes, and spec/doc anchors when available.
  4. Online documentation may mirror the catalog, but the installed local catalog is authoritative for codes emitted by that installed compiler.
  5. `kyokai fix` is separate from `kyokai fmt`: formatting changes layout; fixing applies compiler suggestions.
  6. `kyokai fix` applies only `machine-applicable-safe` suggestions by default. `machine-applicable` edits require explicit opt-in. `maybe-applicable`, `manual`, and `note-only` suggestions require explicit user action or remain advisory and must not be silently applied.
  7. Fix application rejects stale spans, overlapping edit sets not already merged by the diagnostic engine, and edits that fail parse/format validation.
  8. If validation fails, the command leaves original files unchanged or restores them before reporting failure.
  **Why this fits Kyokai**: linearity, borrowing, capabilities, and contracts will create unfamiliar errors. The compiler must teach the rule and apply only the repairs it can honestly prove.
  **[STAGE: DECIDED_CORE_SEMANTICS | D267 -> local diagnostic explanations plus checked `kyokai fix` for `machine-applicable-safe` suggestions by default]**
- **External tool failures are wrapped in Kyokai diagnostics without hiding raw details** — backend, C compiler, linker, debugger, profiler, and platform-tool failures are user-facing Kyokai toolchain events. They must not fall through as unexplained host-tool noise.
**Rules**:
  1. When the C backend, LLVM backend, assembler, linker, archiver, debugger, profiler, memory profiler, runner, or generated-code compilation fails, Kyokai emits a Kyokai diagnostic with a stable code or category.
  2. The diagnostic names the failing phase, selected target, backend, profile, tool path where known, process exit status or signal, and the command class that failed.
  3. Raw stdout, stderr, command arguments, and environment details that are safe to report are attached as diagnostic notes or machine-readable fields; they are not discarded.
  4. Structured output modes preserve the Kyokai diagnostic wrapper and include raw external-tool payloads in explicit fields.
  5. `kyokai debug` launches or prints a debugger plan for the selected executable using the selected target/profile/backend debug contract. It does not invent a separate build mode.
  6. `kyokai profile` and `kyokai memprofile` are official entry points for profiling and memory profiling workflows. When host support is unavailable, they fail with ordinary diagnostics and explain the missing tool or permission.
  7. Debug/profiling commands may delegate to host tools, but Kyokai remains responsible for the command plan, artifact selection, and diagnostics around that delegation.
  8. `kyokai eval` and `kyokai repl` start with no `RootCapability`. Filesystem, network, process, clock, randomness, and other external-world authority must be granted through explicit sandbox/profile options or capability injection rules.
  9. An eval or REPL session that receives sandbox capabilities reports those capabilities before execution and records them in structured session metadata where supported.
  **Why this fits Kyokai**: systems work touches host tools constantly, but Kyokai should still speak Kyokai when those tools fail. Eval also has to respect the capability story or it becomes a back door in the first tool users reach for.
  **[STAGE: DECIDED_CORE_SEMANTICS | D277 -> external tool errors wrapped as Kyokai diagnostics; official debug/profile/memprofile workflows; eval/repl start without root authority]**
- **Local toolchain health is inspectable through `--version` and `doctor`** — installation and target setup failures should not be discovered only after a long build reaches the linker.
**Rules**:
  1. `kyokai --version` works without a project and prints toolchain version, source/release identity, supported editions, diagnostic schema version, host triple, default backend, and KBI compatibility range.
  2. `kyokai doctor` works without a project and checks release provenance, checksum/signature status where available, host support, C/LLVM backend discovery, configured target tools, cache/output writability, package index access, and explicitly admitted environment variables.
  3. `doctor` reports findings as diagnostics and suggestions.
  4. `doctor` must not edit source files, manifests, lockfiles, or project output artifacts.
  5. A project-aware `doctor` mode may also inspect the selected manifest, target tables, lockfile freshness, and configured native dependencies, but it must say which project it inspected.
  **Why this fits Kyokai**: explicit build identity is useless if the tool cannot explain its own identity and host setup.
  **[STAGE: DECIDED_CORE_SEMANTICS | D268 -> `kyokai --version` and `kyokai doctor` as first-party toolchain identity and health commands]**
- **Package inspection and offline workflows are first-class read-only or explicit-write commands** — daily package work needs more than `add` and `update`, but those commands must not smuggle registry trust back into Kyokai.
**Rules**:
  1. `kyokai remove <name>` removes a direct dependency entry and updates the lockfile, while reporting if the dependency remains reachable transitively.
  2. `kyokai search` queries configured discovery indexes without editing manifests or lockfiles.
  3. `kyokai info` reports package metadata, source revision, license, docs, yanked/advisory state, public interface summary, and audit summary when known.
  4. `kyokai tree` prints the resolved dependency graph deterministically from the selected manifest/lockfile.
  5. `kyokai why <package>` explains dependency paths that cause a package to be present.
  6. `kyokai outdated` compares pinned dependencies against configured update policy and index metadata, reporting newer revisions, yanks, and advisories without editing files.
  7. `kyokai vendor` materializes exact locked dependency sources into an explicit vendor directory with metadata tying each source tree to package identity, source URL, revision, checksum where available, and lockfile identity.
  8. Offline builds may use vendored sources only when manifest, lockfile, and vendor metadata agree.
  **Why this fits Kyokai**: users need to inspect the dependency graph every day, but inspection and vendoring must preserve the pinned-source model instead of recreating a hidden registry.
  **[STAGE: DECIDED_CORE_SEMANTICS | D269 -> package remove/search/info/tree/why/outdated/vendor with read-only inspection and pinned offline identity]**
- **Property and fuzz testing have daily replay, corpus, and minimization controls** — committing to property testing and fuzzing is not enough if failures cannot be reproduced.
**Rules**:
  1. `kyokai test --seed <value>` fixes deterministic generator and fuzz seed behavior where the selected runner supports it.
  2. Property failure reports record the test name, seed, shrink path or minimized input where available, target, backend, profile, and toolchain version.
  3. `kyokai test --replay <id-or-file>` replays recorded property failures, fuzz crashes, or minimized reproducers.
  4. `kyokai test --fuzz` runs explicit fuzz targets under the ordinary test toolchain contract.
  5. `--corpus <path>` selects an explicit fuzz corpus directory.
  6. `--minimize <id-or-file>` minimizes a recorded failing input while preserving the failure category.
  7. `--list` lists discovered tests, and `--failed` reruns tests recorded as failed by a previous compatible report.
  8. Crash reproducers and minimized cases are user-visible report/corpus artifacts, not hidden cache facts.
  **Why this fits Kyokai**: a safety-focused language needs tests that can be rerun exactly when the compiler, stdlib, or backend changes. Randomness without replay is just theater.
  **[STAGE: DECIDED_CORE_SEMANTICS | D270 -> property/fuzz seed, replay, corpus, minimization, list, and failed-test rerun controls]**
- **Kyokai carries an explicit formalization roadmap instead of pretending prose alone closes the soundness story** — the project treats the core calculus as part of the language plan, not as optional future polish.
  **Rules**:
  1. Immediate spec wording uses "design goal", "language contract", or "intended invariant" where a property has not yet been discharged by a formal proof.
  2. Before `v1.0`, Kyokai MUST produce a paper proof for a small sequential core calculus (`λ_K` / `λ_K-seq`) covering the safety-critical ownership-and-borrowing core.
  3. That first calculus MUST define abstract syntax, typing judgments, small-step operational semantics, and a soundness theorem adapted to Kyokai's defined TPOE outcome rather than pretending checked failure does not exist.
  4. The first calculus deliberately excludes concurrency, FFI, and backend lowering; those remain later extensions after the sequential core is nailed down.
  5. Once Kyokai is being written in Kyokai and the project is self-hosting, the next formalization step is a proper mechanized proof in the easiest suitable proof assistant on Linux, with Coq the current likely first choice.
  6. The working research note for this effort is `kyokailang/kyokaicalculus/lambda_k_research.md`; that note is not itself the normative proof, but it records the current proof scope, theorem shape, and prior-art map.
  **Why this fits Kyokai**: zero-UB and ownership claims stay explicit, but the document stops bluffing about what has and has not yet been proven.
  **[STAGE: DECIDED_CORE_SEMANTICS | D143/D241 → phased formalization plan; paper proof for sequential `λ_K` before `v1.0`; `lambda_k_research.md` is the current research note; mechanized proof after self-hosting, likely in Coq]**
- `**defer` statement** — Zig-style scope-exit semantics. `defer destroyByteBuf(x);` appears at declaration point and runs when the enclosing scope exits. This matches Austral's linearity scope model — linear variables must be consumed before their scope exits, and scope-exit defer does exactly that. `errdefer action(value);` registers source-visible LIFO cleanup for structured error exits only: `return Err(...)` and `or return`. It does not run on panic, TPOE, runtime-fatal termination, normal success, `break`, or `continue`. **[STAGE: DECIDED_CORE_SEMANTICS | D2 → source-visible LIFO scope-exit cleanup]**
- **Concurrency: visible structured task groups, ownership-transfer channels, explicit synchronization, and explicit readiness waiting** — child tasks are scoped by `taskgroup`; SPSC channels transfer ownership; shared-memory code uses the accepted explicit atomics and lock APIs; cooperative cancellation, `select`, and `Poller` readiness APIs are source-visible. Kyokai adds no language-level `async`/`await`, no hidden scheduler, no unstructured `spawn`, and no implicit priority inheritance. **[STAGE: DECIDED_CORE_SEMANTICS | D3/D90/D282/D342/D353/D354 → structured tasks, ownership-transfer channels, explicit synchronization, and explicit Poller readiness]**
- **Kyokai tasks are 1:1 OS-thread executions, not green-thread or M:N runtime tasks** — structured concurrency does not hide a scheduler underneath the language's explicit task surface.
**Rules**:
  1. Every live child task created by `spawn` executes on one operating-system thread for the duration of that task's execution.
  2. Kyokai has no language-level M:N scheduler, no green-thread runtime, no virtual-thread layer, and no user-transparent task migration semantics.
  3. A blocking operation in a task blocks that task's OS thread unless a separate explicit API contract says otherwise.
  4. Foreign calls execute on the ordinary OS thread of the calling task. Kyokai does not insert a hidden scheduler boundary around FFI calls.
  5. An implementation may reuse OS-thread resources only after the previous task running on that thread has fully exited. Such reuse does not change rules 1 through 4 and does not create language-level M:N semantics.
  **Why this fits Kyokai**: concurrency remains auditable at the same level as ownership and capabilities, blocking behavior stays honest, and FFI-facing systems code does not inherit a second hidden execution model.
  **[STAGE: DECIDED_CORE_SEMANTICS | D164 → `spawn` is 1:1 with OS threads; no M:N/green-thread scheduler semantics]**
- **Spawned child tasks use explicit capture lists and cannot implicitly close over parent bindings** — Kyokai aligns child-task capture with D118's “capture lists carry information” rule instead of letting concurrency smuggle in ambient closure semantics.
**Syntax**:
  ```kyokai
  taskgroup do
      spawn [] do
          tick();
      od;

      spawn [&cfg, sender, &counter] do
          if cfg.enabled() then
              counter.fetchAdd(1, SeqCst);
              let _ : Unit := sendBlocking(&!sender, value) or return;
              closeSender(sender);
          fi;
      od;
  join;
  ```
  **Rules**:
  1. A spawned child task is written as `spawn [captures] do ... od;` inside a `taskgroup do ... join;` block.
  2. The capture list is mandatory. `spawn [] do ... od;` is the zero-capture form.
  3. `name` captures by value. If `name` has a `Free` type, the child receives its own value as of the spawn point and the parent may continue using its own binding. If `name` has a `Linear` type, ownership transfers to the child and the parent binding is consumed at the spawn point.
  4. `&name` captures by immutable borrow. This form is legal only when `name` has a `Free` type or belongs to the closed shared-access concurrency set: `Atomic[T]`, `Mutex[T]`, or `RwLock[T]`.
  5. Capability objects, files, sockets, terminal handles, and other ordinary `Linear` runtime handles do not gain shared-borrow spawn capture merely because they are effectful. Cross-task use of such values must happen by ownership transfer or through a separate explicit synchronization or broker abstraction.
  6. `&!name` capture is illegal in `spawn`.
  7. A `&name` capture creates a borrow whose lifetime lasts until that child task completes at the `join;` point of the enclosing task group. Ordinary borrow rules continue to apply in the parent during that interval.
  8. Because D3 is structured concurrency, the enclosing `taskgroup` may not complete until all child tasks spawned within that task group complete.
  9. `defer` and `errdefer` are same-task scope-exit constructs, not child tasks, and therefore do not use spawn-capture rules.
  **Why this fits Kyokai**: cross-task ownership transfer stays visible in source, shared-read captures stay explicit, and concurrency does not become the one place where the language secretly permits ambient closure behavior.
  **[STAGE: DECIDED_CORE_SEMANTICS | D88 → explicit spawn capture lists; by-value transfer for `Linear`, by-value copy for `Free`, shared `&` capture only for `Free`, `Atomic[T]`, `Mutex[T]`, and `RwLock[T]`; no `&!` capture]**
- **Task groups make structured joins visible instead of hiding them at an arbitrary `od;`** — Kyokai uses a named `taskgroup do ... join;` boundary so borrowing, task lifetime, and blocking behavior are explicit at the source level.
**Rules**:
  1. `spawn [captures] do ... od;` is legal only inside a `taskgroup do ... join;` block.
  2. `join;` is the blocking structured join point for that task group. Execution after `join;` begins only after every child task spawned directly in the group has completed.
  3. Child tasks may be spawned sequentially inside a task group; the group does not wait after each `spawn` statement.
  4. Nested `taskgroup` blocks are legal. A child task may contain its own task group, but the outer group observes only completion of the direct child task.
  5. A borrow captured by `&name` is considered live until the captured child task completes, and for parent-side checking it remains unavailable for conflicting use until the enclosing group reaches `join;`.
  6. The current statement-form `spawn` produces no join handle and no completion value. Values and recoverable errors cross task boundaries only through explicit channels or synchronization objects.
  7. `panic` and TPOE are not task values and are not recoverable at `join;`; they keep D84's process-level termination semantics.
  8. `join;` is a D9 semantic boundary terminator for a task group, not a reversed keyword form.
**Why this fits Kyokai**: the program still gets structured concurrency and borrow-safe child tasks, but the source shows exactly where the parent may block and where captured borrows become available again.
  **[STAGE: DECIDED_CORE_SEMANTICS | D252 → explicit `taskgroup do ... join;`; `join;` is the visible blocking structured join point; no join handles or task-result wrappers]**
- **Thread creation failure is explicit at the `spawn` site unless capacity was reserved before the task group** — OS thread creation is an environmental failure, not TPOE, and Kyokai does not pretend a child started when no child exists.
**Syntax**:
  ```kyokai
  taskgroup do
      spawn [sender] do
          runWorker(sender);
      od else err do
          closeSender(sender);
          return Err(ThreadSpawnFailed(err));
      fi;
  join;
  ```
**Rules**:
  1. Creating a child task may fail before the child begins execution, for example because the OS refuses to create another thread.
  2. Such failure is reported as `ThreadSpawnError`; it is not `panic`, TPOE, or a recoverable child-task result.
  3. If a `spawn` statement fails, the child body does not begin execution, no spawn-start happens-before edge is created, and no child is added to the enclosing task group.
  4. By-value captures transfer to the child only after task creation succeeds. On spawn failure, by-value captures remain available to the failure arm, including linear values that would have transferred on success.
  5. Borrow captures are not extended to a child on spawn failure because no child exists.
  6. A fallible `spawn` must either have an `else err do ... fi;` failure arm or occur inside a task group whose task capacity was explicitly reserved before entering the group.
  7. A task-capacity reservation API is an explicit fallible API. If reservation succeeds, spawn statements covered by that reservation do not individually need failure arms for thread creation failure; any other spawn failure not covered by the reservation remains explicit.
  8. `ThreadSpawnError` is a standard-library error type describing resource exhaustion, permission failure, target unsupportedness, or other implementation-defined OS refusal categories that the target contract exposes. It must not erase ownership state.
**Why this fits Kyokai**: resource exhaustion remains an ordinary explicit failure path, while linear ownership transfer remains exact: values move into a child only if a child actually starts.
  **[STAGE: DECIDED_CORE_SEMANTICS | D235 → fallible `spawn` with explicit failure arm or pre-reserved task capacity; no TPOE for OS thread exhaustion]**
- **Task-boundary transfer is declaration-controlled rather than inherited from `Linear` or expressed through Rust-style `Send`/`Sync` marker interfaces** — Kyokai keeps cross-task movement explicit without importing auto-trait machinery.
**Rules**:
  1. Kyokai has a declaration-level task-boundary classification with two outcomes: `task_transfer` and `task_local`.
  2. Built-in `Free` value types are `task_transfer` unless a specific built-in contract says otherwise.
  3. User-defined `Free` nominal types are `task_transfer` unless their declaration explicitly marks them `task_local`.
  4. User-defined `Linear`, capability, and runtime-handle nominal types must either declare `task_transfer` or `task_local`, or be covered by an explicit standard-library authority/handle contract that states the classification.
  5. `Linear` by itself does not imply task-transfer admissibility.
  6. A `task_local` value may not be captured by value into `spawn`, sent through a channel, or otherwise transferred to another task by safe code.
  7. Capabilities and raw I/O handles remain single-owner values. They may be transferred across tasks only when their own capability/handle contract admits owned task transfer.
  8. Shared cross-task capture by immutable borrow remains limited to `Free` values and the closed synchronized set `Atomic[T]`, `Mutex[T]`, and `RwLock[T]`, unless a later D-point adds another named synchronized primitive.
  9. Safe Kyokai does not provide user-implemented `Send` or `Sync` marker typeclasses, auto-traits, or structural inference for task-transfer or shared-task safety.
  10. If a thread-affine host resource needs cross-task access, safe code must use an explicit broker task, ownership transfer back to the owning task, or a separately specified synchronized wrapper whose contract names its interleaving and affinity rules.
**Surface examples**:
  ```kyokai
  record ByteBuffer: Linear, task_transfer is ... build;
  record GlContext: Linear, task_local is ... build;
  capability WindowServerCapability: task_local;
  ```
**Why this fits Kyokai**: the language answers the real soundness issue without turning task movement into an inferred trait folklore layer. Authority, ownership, and thread affinity stay attached to the type's explicit contract.
  **[STAGE: DECIDED_CORE_SEMANTICS | D248 → no Rust-style `Send`/`Sync`; task-boundary transfer is explicit declaration/contract metadata; thread-affine types are `task_local`]**
- **Child-task error propagation stays explicit and does not create a second recoverable task-failure taxonomy** — Kyokai keeps task boundaries honest: ordinary recoverable errors are just ordinary values, while `panic` and TPOE remain process-level termination.
**Rules**:
  1. The current statement-form `spawn [captures] do ... od;` does not itself yield a completion value to the parent.
  2. If a child task must communicate `T` or `Result[T, E]` to its parent or to sibling tasks, it does so through explicit channels or other explicitly passed synchronization objects defined by the language.
  3. A `Result[T, E]` that crosses a task boundary by such an explicit mechanism crosses unchanged as `Result[T, E]`. The language does not wrap `Err(E)` in `TaskError[E]`, `JoinError`, or any other implicit task-failure envelope.
  4. `Err(E)` crossing a task boundary is ordinary recoverable program data, not a runtime task failure category.
  5. `panic(message)` and TPOE are not task values and are not recoverable at a structured join point. Under D84 and D3a they terminate the whole process.
  6. A child task communicating `Err(E)` does not implicitly cancel siblings or force parent termination. Cancellation remains explicit under D91.
  **Why this fits Kyokai**: channels remain the visible transport mechanism, ordinary errors remain typed data, and the language refuses Rust-style join wrappers that would pretend process-fatal failure is just another recoverable branch.
  **[STAGE: DECIDED_CORE_SEMANTICS | D168 → task-boundary error propagation is explicit-value transport only; no implicit `TaskError` wrapper; `panic`/TPOE remain process termination]**
- **Channel capacity is always explicit at construction; Kyokai provides no default channel constructor** — every channel's capacity behavior, blocking discipline, and endpoint topology is visible at the construction site and in the operation names.
**Topology**: Kyokai channels are **single-producer, single-consumer (SPSC)**. `Sender[T]` and `Receiver[T]` are unique linear endpoints. They are not cloneable and cannot be split. Fan-in, fan-out, and broadcast topologies are expressed through explicit relay/broker tasks that compose SPSC channels — every connection is visible in source. MPSC, MPMC, and broadcast are not part of this decision; if they are needed later, they require their own design with explicit shared-ownership lifecycle semantics.
**Constructors**:
  ```kyokai
  record ChannelEndpoints[T: Type] is
      sender: Sender[T];
      receiver: Receiver[T];
  build;

  // Bounded: fixed capacity, backpressure via blocking
  function makeBoundedChannel[T: Type](capacity: Index): ChannelEndpoints[T];

  // Growable: requires an allocator, starts at initialCapacity, grows on demand
  function makeGrowableChannel[T: Type, A: Allocator](
      alloc: &![A], initialCapacity: Index
  ): ChannelEndpoints[T];
  ```
  **Why no bare `makeChannel[T]()`**: a channel's capacity is its most consequential property — it determines whether the program can OOM, whether it deadlocks, and what the backpressure behavior is. Hiding that behind a default violates the same principle as D44 (no hidden default allocator) and D74 (OOM is explicit). The programmer writes `makeBoundedChannel[Int32](64)` or `makeGrowableChannel[Int32](&!heap, 64)` and the construction site tells the full story.
  **Why `makeGrowableChannel` instead of `makeUnboundedChannel`**: the name signals "this thing allocates and grows" rather than "this thing has no limit." The allocator parameter makes the memory cost visible (D44). The `initialCapacity` parameter gives the programmer a sizing hint without hiding the growth behavior.
  **Why SPSC only**: MPSC requires cloneable senders, which means reference counting or shared ownership — both violate linearity. MPMC requires cloneable senders AND receivers. Broker tasks make topology explicit in source code: if you want 3 producers feeding one consumer, you spawn a broker with 3 receivers and one output channel. Every connection is visible. No hidden shared ownership.
  **Operation signatures**:
  ```kyokai
  // Blocking operations: the name says "Blocking" because the suspension point
  // must be visible at every call site (same principle as D11b naming conventions).
  // sendBlocking: mutable borrow of sender (you keep using it), value consumed (ownership transfers)
  // Returns Result because the receiver may be closed or (growable) allocation may fail
  function sendBlocking(sender: &![Sender[T]], value: T): Result[Unit, SendError[T]];

  // recvBlocking: returns Optional — None when channel is closed and drained
  function recvBlocking(receiver: &![Receiver[T]]): Optional[T];

  // Non-blocking variants — never suspend
  function trySend(sender: &![Sender[T]], value: T): Result[Unit, TrySendError[T]];
  function tryRecv(receiver: &![Receiver[T]]): Result[T, TryRecvError];

  // Explicit endpoint completion
  function closeSender(sender: Sender[T]): Unit;
  function closeReceiver[T: Free](receiver: Receiver[T]): Unit;
  function drain[T: Linear](receiver: Receiver[T]): DrainIterator[T];
  ```
  **Why `sendBlocking`/`recvBlocking` instead of `send`/`recv`**: Kyokai's rule is "if it's happening, it must be visible in source." A function that blocks the calling task is doing something important — hiding that behind a generic name `send` violates the same principle that D8 applies to return values and D11b applies to ownership. The blocking point is in the name. No effect system needed, no colored functions — just honest naming. This also leaves clean namespace space for future deadline-based variants (`sendUntil`, `recvUntil`) without ambiguity.
  **Error types**:
  ```kyokai
  // SendError returns the value to the caller — linear values are not leaked on failure
  union SendError[T: Type] is
      case Disconnected(value: T);   // receiver closed
      case AllocFailed(value: T);    // growable channel could not grow (D74)
  build;

  union TrySendError[T: Type] is
      case Full(value: T);           // bounded channel at capacity
      case Disconnected(value: T);   // receiver closed
      case AllocFailed(value: T);    // growable channel could not grow
  build;

  union TryRecvError is
      case Empty;                    // no value available right now
      case Disconnected;             // sender closed, channel drained
  build;
  ```
  **Blocking rules**:
  1. On a bounded channel, `sendBlocking` blocks until the channel has capacity or the receiver is closed.
  2. On a growable channel, `sendBlocking` attempts to grow the internal buffer. If the allocator returns `AllocError`, `sendBlocking` returns `Err(AllocFailed(value))` without blocking.
  3. `recvBlocking` blocks until a value is available or the channel is closed and drained.
  4. `trySend` and `tryRecv` never block.
  **Transfer ordering rules**:
  1. Each SPSC channel is FIFO. Successful sends are observed by receives in sender program order.
  2. `closeSender(sender)` never lets closure observation overtake earlier successful sends. The receiver must first drain every buffered value from sends that completed before the close, in FIFO order.
  3. A failed `trySend(Full(...))`, failed `sendBlocking(...)->Err(...)`, `tryRecv(Empty)`, or any other non-transferring channel result creates no cross-task ordering guarantee by itself.
  **Closure rules**:
  1. `Sender[T]` and `Receiver[T]` are `Linear`. Forgetting to close an endpoint is a compile-time linearity error.
  2. Closing the sender signals the receiver: subsequent `recvBlocking` calls drain any buffered values and then return `None`, and `tryRecv` returns `Disconnected` only after the same drain is complete.
  3. For `T: Free`, `closeReceiver(receiver)` is available. It closes the receiver immediately, discards any buffered `Free` values, and causes subsequent sender operations to return `Err(Disconnected(value))`.
  4. For `T: Linear`, `Receiver[T]` exposes no direct close/discard operation. The only completion path is `drain(receiver)`, which consumes the receiver and yields buffered and subsequently arriving values in FIFO order until the sender side is closed and the channel is empty.
  5. Exhausting the `DrainIterator[T]` completes receiver teardown for `T: Linear`. There is no second close step after the drain finishes.
  6. Abandoning a `DrainIterator[T]` before exhaustion is illegal for `T: Linear`, because doing so would abandon queued linear values.
  7. If the sender remains live and continues to hold the channel open, `drain(receiver)` may block indefinitely while waiting for eventual sender closure. That liveness obligation is explicit program behavior, not hidden cleanup.
  8. Sending on a known-closed channel (where the sender has already received `Err(Disconnected(...))` and ignores it) is ordinary error handling, not TPOE. TPOE applies only when specified by contract (e.g., the spec may define that using a sender endpoint after it has already been consumed is a linearity violation, which the compiler catches statically).
  **D84 termination interaction**:
  1. `panic(message)` terminates the whole process (D84 rule 2). There is no per-task panic recovery. `panic` runs `defer` cleanup in exiting scopes (D84 rule 3), which consumes linear channel endpoints through their deferred close. No special channel-unblocking logic is needed — the process is terminating.
  2. TPOE terminates the whole process immediately (D84 rule 4). No `defer` runs. No channel cleanup. The process is dead.
  3. There is no scenario where one task dies and another task continues. Structured concurrency means child tasks are joined before the parent scope exits; `panic` and TPOE terminate the whole process, not individual tasks.
  **Buffered values on channel teardown**:
  1. For `T: Free`, `closeReceiver(receiver)` may discard buffered values.
  2. For `T: Linear`, buffered values are never silently discarded by receiver teardown. They are yielded through `drain(receiver)` and must be consumed by user code.
  3. `panic` and TPOE remain process-level termination paths under D84. Kyokai does not define a continuing-program receiver-teardown shortcut that silently destroys buffered linear messages.
  **Why this fits Kyokai**: every aspect of channel behavior — capacity, allocation, blocking, closure, topology, error recovery, and termination interaction — is either visible in the source or follows mechanically from existing decided rules (D44, D74, D84, D2b). Nothing is hidden, nothing is defaulted, and the D84 termination contract is respected without exceptions. Blocking is in the name. Topology is in the type. Capacity is in the constructor.
  **[STAGE: DECIDED_CORE_SEMANTICS | D3a → SPSC channels; explicit bounded/growable constructors; `sendBlocking`/`recvBlocking` with visible blocking point; linear endpoints; D84-compliant process-level termination]**
- **Complex channel topologies are explicit broker tasks over SPSC channels, not new cloneable channel endpoint types** — Kyokai keeps the SPSC topology contract from D3a and standardizes the broker pattern as visible source structure rather than hidden shared ownership.
**Rules**:
  1. Kyokai does not add MPSC, MPMC, or broadcast channel endpoint types to the core channel model.
  2. `Sender[T]` and `Receiver[T]` remain unique linear endpoints. They are not cloneable, splitable, reference-counted, or implicitly shared.
  3. Fan-in, fan-out, work-queue, logging, and broadcast-like designs are expressed through explicit broker tasks that own the necessary SPSC endpoints and relay messages using ordinary channel operations and `select`.
  4. The standard library may provide broker helper functions or templates, but those helpers must construct, accept, and own visible SPSC endpoints. They do not create hidden MPSC/MPMC state.
  5. Broker helpers must document ordering, fairness or non-fairness, shutdown, backpressure, cancellation/deadline interaction, and linear-payload drain behavior.
  6. If a future design wants true MPSC, MPMC, or broadcast endpoints, it requires a separate D-point covering shared endpoint ownership, teardown, ordering, memory use, and task-transfer rules.
  **Why this fits Kyokai**: many-producer and broadcast workflows remain possible, but topology is still visible in source and the language does not smuggle `Arc`-style ownership into channels.
  **[STAGE: DECIDED_CORE_SEMANTICS | D236 → standard broker pattern over SPSC channels; no MPSC/MPMC/broadcast endpoint primitives]**
- **Linear receiver teardown is explicit drain, not close-and-discard** — Kyokai does not let a `Receiver[T]` for linear payloads silently abandon buffered values or synthesize hidden destruction behavior.
**Rules**:
  1. `Receiver[T]` where `T: Linear` does not expose `closeReceiver`.
  2. The only receiver-completion path for `T: Linear` is `drain(receiver): DrainIterator[T]`.
  3. `drain(receiver)` consumes the receiver and yields every buffered value in FIFO order, then any later values, until the sender side is closed and the channel is empty.
  4. Exhausting the drain iterator completes teardown. There is no second receiver-close operation after exhaustion.
  5. Abandoning the drain before exhaustion is illegal for `T: Linear`.
  6. `Receiver[T]` where `T: Free` may use `closeReceiver(receiver)` directly, and buffered `Free` values may be discarded.
  **Why this fits Kyokai**: linear messages remain explicit program obligations all the way through channel teardown. The language does not invent a cleanup exception at exactly the point where values are easiest to lose sight of.
  **[STAGE: DECIDED_CORE_SEMANTICS | D146 → `Receiver[T: Linear]` completes through explicit `drain`; `Receiver[T: Free]` may close directly and discard buffered values]**
- `**Atomic[T]` (along with `Mutex[T]` and `RwLock[T]`) is one of the closed set of language-defined types where shared access may change storage** — its operations are explicitly ordered and this property is stated by the spec, not derived from a general interior mutability mechanism. No other type outside this explicit concurrency set may exhibit this behavior. Atomics live in `Kyokai.Atomic` as a first-class standard library module. They are memory-ordering primitives for implementing lock-free data structures and cross-task observable state. They are not a coordination mechanism between tasks. Task coordination uses channels (D3/D3a).
**Type design**:
  ```kyokai
  // Atomic[T] is Linear — one owner (the scope that created it).
  // Child tasks access it through structured concurrency scope rules.
  // T is constrained to types with hardware atomic support.
  record Atomic[T: AtomicType] is
      // opaque internal representation
  build;

  // AtomicType: a typeclass constraining which types can be atomic.
  // Implementations: Int8, Int16, Int32, Int64, Nat8, Nat16, Nat32, Nat64, Index, Bool.
  // Not arbitrary T — only types with hardware atomic semantics.

  // No default ordering. Every operation names its ordering.
  union MemoryOrder is
      case Relaxed;
      case Acquire;
      case Release;
      case AcqRel;
      case SeqCst;
  build;

  // CAS result is a named union, not Result[T, T].
  // CAS failure is an expected algorithmic branch, not an error.
  union CompareExchangeResult[T: AtomicType] is
      case Exchanged(previous: T);   // CAS succeeded, previous value returned
      case Failed(observed: T);      // CAS failed, actual observed value returned
  build;
  ```
  **API**:
  ```kyokai
  function makeAtomic[T: AtomicType](initial: T): Atomic[T];

  function load(a: &[Atomic[T]], order: MemoryOrder): T;
  function store(a: &[Atomic[T]], value: T, order: MemoryOrder): Unit;

  function fetchAdd(a: &[Atomic[T]], value: T, order: MemoryOrder): T;
  function fetchSub(a: &[Atomic[T]], value: T, order: MemoryOrder): T;
  function fetchAnd(a: &[Atomic[T]], value: T, order: MemoryOrder): T;
  function fetchOr(a: &[Atomic[T]], value: T, order: MemoryOrder): T;
  function fetchXor(a: &[Atomic[T]], value: T, order: MemoryOrder): T;

  function compareExchange(
      a: &[Atomic[T]],
      expected: T,
      desired: T,
      successOrder: MemoryOrder,
      failureOrder: MemoryOrder
  ): CompareExchangeResult[T];

  function compareExchangeWeak(
      a: &[Atomic[T]],
      expected: T,
      desired: T,
      successOrder: MemoryOrder,
      failureOrder: MemoryOrder
  ): CompareExchangeResult[T];  // Failed(observed) may occur spuriously even when observed == expected

  function fence(order: MemoryOrder): Unit;
  ```
  **Ordering-argument validity rules**:
  1. Every `MemoryOrder` argument to `load`, `store`, read-modify-write operations, `compareExchange`, `compareExchangeWeak`, and `fence` must be a comptime-known `MemoryOrder` variant, not a runtime variable.
  2. `load` accepts only `Relaxed`, `Acquire`, or `SeqCst`.
  3. `store` accepts only `Relaxed`, `Release`, or `SeqCst`.
  4. Read-modify-write operations such as `fetchAdd`, `fetchSub`, `fetchAnd`, `fetchOr`, and `fetchXor` accept `Relaxed`, `Acquire`, `Release`, `AcqRel`, or `SeqCst`.
  5. `fence(Relaxed)` is illegal. Legal fence orders are `Acquire`, `Release`, `AcqRel`, and `SeqCst`.
  6. For `compareExchange` and `compareExchangeWeak`, `failureOrder` may only be `Relaxed`, `Acquire`, or `SeqCst`.
  7. For `compareExchange` and `compareExchangeWeak`, `failureOrder` must not be stronger than `successOrder`. The only legal `(successOrder, failureOrder)` pairs are:
     - `(Relaxed, Relaxed)`
     - `(Acquire, Relaxed)` and `(Acquire, Acquire)`
     - `(Release, Relaxed)`
     - `(AcqRel, Relaxed)` and `(AcqRel, Acquire)`
     - `(SeqCst, Relaxed)`, `(SeqCst, Acquire)`, and `(SeqCst, SeqCst)`
  **Why `Atomic[T]` is `Linear`**: atomics are shared-access values, but the *storage* must have a single owner. In structured concurrency, the parent scope owns the `Atomic[T]`. Child tasks access it because the parent scope outlives all children. When the scope exits and all children have joined, the atomic is solely the parent's again and can be consumed normally. This eliminates the need for reference-counting wrappers like Rust's `Arc<AtomicU64>`.
  **Why all operations take `&[Atomic[T]]`**: `Atomic[T]` (along with `Mutex[T]` and `RwLock[T]`) is part of a closed set of language-defined synchronized shared-mutation primitives. Its operations are explicitly ordered and are one of the only cases where shared access may change storage. The programmer sees `Atomic` in the type and `MemoryOrder` in every operation — there is no scenario where a reader is surprised by mutation. This is not a general interior mutability mechanism. Kyokai does not have `Cell`, `RefCell`, `UnsafeCell`, or any user-extensible way to mutate through `&[T]`. The compiler knows `Atomic[T]` is part of a specific type family with this property and does not generalize it. No other type, including future standard library types, may acquire this property without a new explicit decision point.
  **Why not a third borrow mode (`&@[T]` or similar)**: a third access mode that applies to exactly one type family is more machinery for the same semantics. The compiler still needs to know `Atomic[T]` is special — with `&@`, the specialness is "this is the only type that can be behind `&@`"; with the named exception, the specialness is "this is the only type where `&[T]` permits mutation." Same information, different encoding. Adding `&@` also creates pressure to generalize ("why not `&@` for mutexes? for concurrent data structures?"), while the closed exception explicitly says "this is `Atomic[T]` and nothing else, ever." Kyokai's reference syntax is already four operators (`&`, `&!`, `~`, `&~`); a fifth adds learning cost for one type family.
  **Why `CompareExchangeResult[T]` instead of `Result[T, T]`**: CAS failure is not an error — it is an expected algorithmic branch. Using `Result` makes it look like ordinary error propagation and tempts `or return` usage, which is wrong. `Exchanged(previous)` and `Failed(observed)` are self-documenting field names. `compareExchangeWeak` uses the same result type; `Failed(observed)` may occur spuriously even when `observed == expected`.
  **Why not FFI-only**: atomics are needed to implement the channel runtime itself. If atomics are FFI-only, the foundational concurrency primitive is outside the language. FFI has no linearity checking, no memory-ordering type safety, and no compiler visibility into what the operation does. Every program that needs a simple atomic counter would require a C shim file. This violates the Kyokai philosophy of "if it's commonly needed, provide it properly."
  **Why `Kyokai.Atomic` is not `pragma Unsafe_Module`**: atomics do not create memory unsafety. They create ordering complexity, but the operations themselves are safe — the hardware guarantees atomicity, and the explicit `MemoryOrder` argument makes the ordering choice visible in source. The module is safe standard library code.
  **C backend lowering rules**:
  1. On the C backend, `Atomic[T]` lowers through C11 `<stdatomic.h>` only.
  2. Generated C represents atomic storage as `_Atomic T` or the corresponding standard atomic typedef form.
  3. `load`, `store`, read-modify-write operations, compare-exchange operations, and fences lower to the matching `atomic_*_explicit` operations.
  4. The C backend must never lower safe atomic operations to plain reads/writes or to `volatile` accesses.
  5. The backend must ensure the generated storage representation satisfies the selected target/toolchain's C11 atomic alignment requirements. If a source-level combination would violate that contract, compilation fails for that target/backend path.
  6. Kyokai does not promise lock-free atomics for every admitted atomic type on every target. It promises the specified semantics.
  7. If the selected C backend target/toolchain contract cannot provide conforming C11 atomic semantics for the used `Atomic[T]` operations, the build fails rather than silently weakening the memory model.
  **Usage pattern**:
  ```kyokai
  import Kyokai.Atomic (Atomic, MemoryOrder, makeAtomic, load, store, fetchAdd, destroyAtomic);

  function doWork(): Unit is
      var counter: Atomic[Int32] := makeAtomic(0);
      defer destroyAtomic(counter);

      // child tasks access counter through structured concurrency scope
      taskgroup do
          spawn [&counter] do
              counter.fetchAdd(1, SeqCst);
          od;

          spawn [&counter] do
              let val: Int32 := counter.load(Acquire);
          od;
      join;

      // join point: all children done, counter is solely ours again
      let final: Int32 := counter.load(SeqCst);
  qed;
  ```
  **Why this fits Kyokai**: atomics are explicit, typed, ordering-annotated, and provided as a proper language-visible module. The `Linear` ownership + structured concurrency scope rules guarantee storage lifetime without reference counting. The shared-mutation property of `Atomic[T]` is stated directly in the spec as a closed, non-generalizable exception. The programmer always sees `Atomic` in the type name and `MemoryOrder` in every operation call — nothing is hidden.
  **[DECIDED: D3b/D141 → `Kyokai.Atomic` module; `Atomic[T]` is `Linear`; all operations take `&[Atomic[T]]` with explicit `MemoryOrder`; `Atomic[T]` is part of the closed set of types where shared access may change storage; `CompareExchangeResult[T]` for CAS; no general interior mutability; C backend lowers through C11 atomics only]**
- **Mutex and RwLock Primitives (Kyokai.Sync)** — explicit `Linear` synchronization primitives for shared-state concurrency, complementing channels (D3a) and atomics (D3b).
**Type design**:
  ```kyokai
  // 1. The Mutex is Linear (sole ownership)
  record Mutex[T: Type]: Linear is
      // opaque internal representation
  build;

  // 2. The Guard is Linear (must be explicitly consumed to unlock)
  record MutexGuard[T: Type]: Linear is
      // opaque internal representation
  build;

  record RwLock[T: Type]: Linear is ... build;
  record ReadGuard[T: Type]: Linear is ... build;
  record WriteGuard[T: Type]: Linear is ... build;
  ```
**Operations**:
  ```kyokai
  // Creation (No capability required)
  function makeMutex[T: Type](value: T): Mutex[T];

  // Locking takes an IMMUTABLE borrow of the Mutex (shared among tasks)
  function lockBlocking[T: Type](m: &[Mutex[T]]): MutexGuard[T];

  union TryLockError is case Locked; build;
  function tryLock[T: Type](m: &[Mutex[T]]): Result[MutexGuard[T], TryLockError];

  // Accessing the data requires mutably borrowing the Guard.
  function access[T: Type](guard: &![MutexGuard[T]]): &![T];

  // Unlocking consumes the Guard.
  function unlock[T: Type](guard: MutexGuard[T]): Unit;

  // Destruction consumes the Mutex and returns the inner data.
  function destroyMutex[T: Type](m: Mutex[T]): T;
  ```
  **Why `Mutex[T]` requires no capability**: capabilities represent unforgeable external OS authority. Memory synchronization is internal to the process and does not grant authority over the outside world.
  **Why locking takes `&[Mutex[T]]`**: Multiple child tasks capture immutable borrows (`&m`) under D88. `Mutex[T]` and `RwLock[T]` join `Atomic[T]` as the closed set of types where shared access permits interior mutability.
  **Why `MutexGuard[T]` is `Linear`**: it forces the programmer to explicitly call `unlock(guard)`. A forgotten unlock is a compile-time linearity error.
  **[STAGE: DECIDED_CORE_SEMANTICS | D100 → `Mutex[T]`/`RwLock[T]` with linear scoped guards; explicit `access` via guard; immutable borrow to lock; no capabilities required]**
- **Official concurrency guidance is ordered: channels first for coordination and ownership transfer, mutexes for truly shared mutable structures, atomics for narrow low-level synchronization only** — Kyokai exposes multiple concurrency primitives, but it does not leave their ordinary intended use as folklore.
**Guidance rules**:
  1. Channels are the default coordination mechanism for task-to-task communication, work pipelines, ownership transfer, shutdown signaling, and other explicit data-flow patterns.
  2. `Mutex[T]` and `RwLock[T]` are the recommended tool only when multiple tasks genuinely need shared access to one in-memory mutable structure and a broker-or-channel design would be materially worse.
  3. `Atomic[T]` is for simple flags, counters, sequence numbers, and low-level synchronization internals. It is not the default shared-state coordination tool.
  4. If more than one design is plausible, the default choice order is: channels first, mutex/rwlock second, atomics last.
**Why this fits Kyokai**: the language keeps one clear beginner-to-expert gradient for concurrency instead of pushing every user directly into low-level synchronization choices.
**[STAGE: DECIDED_CORE_SEMANTICS | D184 → official concurrency guidance: channels by default, mutexes/rwlocks for genuine shared mutable structures, atomics only for narrow low-level synchronization]**
- **Raw capability-bearing I/O surfaces are single-owner and are not secretly synchronized by the runtime** — Kyokai does not hide a mutex inside terminal/file/socket authority in order to make cross-task output "just work."
**Rules**:
  1. Safe production I/O operations that mutate externally visible stream state or advance handle state require a mutable borrow of the capability-bearing object or I/O handle being used.
  2. Raw terminal, file, socket, and similar capability-bearing I/O objects remain `Linear` and are not safe for concurrent shared use merely because they wrap OS resources.
  3. Safe Kyokai does not permit two live tasks to perform concurrent raw I/O through the same capability or handle object.
  4. The language and toolchain must not insert hidden mutexes into `TerminalCapability`, `File`, sockets, or other raw I/O capability surfaces in order to fabricate thread safety.
  5. If multi-task output to one destination is needed, the sanctioned default pattern is an explicit broker task that owns the destination and receives messages over channels.
  6. A separately designed synchronized writer abstraction may exist as its own explicit type with its own documented interleaving guarantees, but that is a different API surface from the raw capability-bearing one.
  7. Distinct handles may still refer to the same underlying OS resource. Any atomicity, file-offset-sharing, or interleaving guarantees across distinct handles must be documented per API and are not implied by capability linearity alone.
  **Why this fits Kyokai**: capability ownership remains honest, concurrency does not open a hidden runtime-synchronization exception, and programs that need shared-output policy must spell that policy explicitly in source.
  **[STAGE: DECIDED_CORE_SEMANTICS | D212 → raw capability-bearing I/O is exclusive by handle/capability; no hidden synchronization; shared multi-task output uses explicit broker or explicit synchronized wrapper types]**
- **Shared Ownership and Reference Counting** — formally rejected.
  **Why no `Rc[T]` or `Arc[T]`**: reference counting implies shared ownership, which fundamentally violates the linear type system's invariant that every resource has exactly one owner responsible for its destruction. In Kyokai, ownership is strictly single.
  **How to share data without reference counting**:
  1. Concurrent access is achieved through shared borrowing (`&[Mutex[T]]` or `&[Atomic[T]]`) managed by structured concurrency scopes (children cannot outlive parents).
  2. Sequential sharing transfers ownership entirely via channels.
  3. Graph data structures must use arenas (D96) or array indices.
  **[STAGE: DECIDED_CORE_SEMANTICS | D101 → formally reject `Rc[T]` and `Arc[T]`; structured scopes and `Mutex[T]` replace shared-ownership concurrency]**
- **Cooperative Cancellation and Deadlines** — preemption is banned because it violates linear resource cleanup (defers wouldn't run). All cancellation is cooperative.
  **Deadlines**: explicit variants `sendUntil` and `recvUntil` take a deadline and return `TimedOut` on failure.
  **Cancellation**: `CancellationToken` is a `Free` type (backed by an atomic) created by the parent and passed immutably `&[CancellationToken]` to child tasks. Children explicitly poll `token.isCancelled()`. Blocking operations optionally accept a token and wake up to return `Err(Cancelled)` if triggered.
  **Cleanup**: Cancellation is a structured exit, not TPOE. It runs all `defer` blocks normally.
  **[STAGE: DECIDED_CORE_SEMANTICS | D91 → cooperative cancellation only; `CancellationToken`; deadline-based blocking variants; runs `defer`]**
- **Rendezvous channels are a distinct explicit constructor rather than a magic capacity value** — synchronous handoff has meaningfully different blocking behavior from buffered channels, so Kyokai names it directly instead of smuggling it through `capacity = 0`.
**API**:
  ```kyokai
  function makeRendezvousChannel[T: Type](): ChannelEndpoints[T];
  ```
  **Rules**:
  1. `makeBoundedChannel[T](capacity)` requires `capacity >= 1`. `capacity = 0` is illegal for the bounded-channel constructor.
  2. A rendezvous channel has no internal element buffer and performs synchronous sender/receiver pairing.
  3. `sendBlocking(sender, value)` on a rendezvous channel blocks until a matching receive operation pairs with that send and takes ownership of `value`.
  4. `recvBlocking(receiver)` on a rendezvous channel blocks until a matching send operation pairs with it, or until the sender side is closed and no future pairing can occur.
  5. `trySend` on a rendezvous channel succeeds only when a receiver is already waiting; otherwise it returns the channel family's ordinary non-success send result without transferring ownership.
  6. `tryRecv` on a rendezvous channel succeeds only when a sender is already waiting; otherwise it returns the channel family's ordinary empty/non-ready receive result.
  7. Rendezvous channels still carry an explicit liveness obligation: if no matching peer ever arrives and no deadline/cancellation path is used, the blocking operation may wait indefinitely.
  8. Deadline and cancellation variants such as D91's `sendUntil` and `recvUntil` are the explicit way to bound that waiting behavior.
  **Why this fits Kyokai**: synchronous handoff remains available, but the program spells that stronger coordination contract at the constructor site instead of hiding it inside one numeric argument edge case.
  **[STAGE: DECIDED_CORE_SEMANTICS | D183 → explicit `makeRendezvousChannel`; bounded channels require capacity ≥ 1; rendezvous remains synchronous and liveness-explicit]**
- **Non-Blocking I/O and Poller Contract** — no hidden global event loop. I/O multiplexing uses an explicit, linear `Poller` API.
  **Types**: `Poller` is `Linear` and wraps the OS event queue (`epoll`/`kqueue`).
  **Capabilities**: Creating a `Poller` requires a `ProcessCapability` (or similar OS authority capability).
  **Registration**: Explicit `register(poller: &![Poller], handle: &![FileDescriptor], interest)` — requires mutable borrows of both the poller and the handle.
  **Waiting**: `wait(poller: &![Poller], eventsOut, deadline)` blocks the task until events occur. Portable semantics are level-triggered.
  **[STAGE: DECIDED_CORE_SEMANTICS | D93 → explicit `Linear` `Poller` API; requires capability to create; explicit registration and wait]**
- **The event-loop / reactor boundary is explicit library code over `Poller`, not a hidden runtime service** — Kyokai supports high-concurrency I/O without adding a global executor or invisible suspension points.
**Rules**:
  1. Kyokai has no hidden global reactor, hidden event loop, hidden executor, green-thread scheduler, or language-level async suspension.
  2. High-concurrency I/O is expressed through explicit `Poller` values and libraries built on top of them.
  3. An event loop is ordinary Kyokai code that owns or mutably borrows a `Poller`; it is not a language runtime service.
  4. Handles used with such an event loop must be explicitly registered with the `Poller` or with an explicitly specified equivalent readiness mechanism.
  5. Blocking behavior remains visible in API names and result types under D237; the reactor boundary does not silently turn plain blocking calls into cancellable or nonblocking calls.
**Why this fits Kyokai**: C10K-style I/O remains possible, but the program states where readiness is tracked and who owns the polling object.
  **[STAGE: DECIDED_CORE_SEMANTICS | D234 → explicit event loops over `Poller`; no hidden reactor, executor, or runtime suspension]**
- **Cancellation-aware blocking syscall wrappers use explicit readiness mechanisms; plain blocking calls may wait indefinitely** — Kyokai does not pretend an OS thread blocked in a synchronous syscall can be safely interrupted by hidden runtime magic.
**Rules**:
  1. Safe Kyokai blocking I/O APIs are split into plain blocking operations and cancellation/deadline-aware operations.
  2. A plain blocking operation such as `readBlocking` or `writeBlocking` may block the calling OS thread until the OS operation completes, fails, or the resource-specific close/error condition occurs. If the peer or device never becomes ready and no deadline/cancellation surface was requested, the operation may wait indefinitely.
  3. A cancellation-aware or deadline-aware blocking operation must make that extra exit path visible in the API name, parameters, or result type, for example through `readUntil`, `writeUntil`, `Cancelled`, or `TimedOut`.
  4. Cancellation-aware and deadline-aware I/O must be implemented through D93's `Poller`-compatible readiness path, or through an equivalently explicit target-specific readiness mechanism specified by the toolchain contract.
  5. Kyokai does not use asynchronous thread cancellation, hidden signal injection, hidden scheduler wakeups, stack unwinding, or forced foreign-frame interruption to cancel a blocked syscall.
  6. If an underlying OS syscall returns because of an ordinary host interruption such as POSIX `EINTR`, the safe wrapper either retries transparently when no Kyokai cancellation/deadline condition is active, or returns the explicitly documented Kyokai cancellation/deadline/error case when such a condition has been observed.
  7. Cancellation remains D91 cooperative cancellation. It is a structured ordinary exit, runs `defer` according to D2b, and is not TPOE or `panic`.
  **Why this fits Kyokai**: the source code tells the truth about liveness. `readBlocking` means the programmer chose an unbounded wait, while `readUntil`/deadline/cancellation APIs spell the bounded exit path and route it through the explicit `Poller` model instead of inventing preemptive cancellation.
  **[STAGE: DECIDED_CORE_SEMANTICS | D237 → cooperative cancellation only through Poller-backed or explicitly readiness-backed operations; plain blocking calls may wait indefinitely]**
- **Kyokai's concurrency surface excludes language-level async/await and futures** — structured tasks, channels, cancellation, atomics, `select`, and the explicit `Poller` are the whole concurrency model. High-concurrency I/O is expressed through library layers built on that substrate rather than by adding a second colored effect language.
**Rules**:
  1. The language defines no `async fn`, `await`, async blocks, async closures, async typeclass methods, `Future`-like core abstraction, or implicit executor/runtime model.
  2. There is no hidden global event loop. D93's `Poller` plus libraries built on top of it are the sanctioned path for multiplexed I/O.
  3. D198 `yield` remains generator-only suspension. It is not generalized into task suspension or async control flow.
  4. Cancellation remains exactly D91 cooperative cancellation for structured tasks. The language defines no second async-task cancellation model.
  5. If Kyokai ever adds a language-level async facility, it requires a new explicit D-point family covering suspension points, borrow/live-value rules across suspension, cleanup of suspended state, executor/runtime ownership, FFI interaction, and backend lowering. No such facility exists implicitly.
  **Why this fits Kyokai**: D3/D91/D93 already provide one explicit concurrency story. Adding async/await would introduce a competing second mechanism, colored control flow, and a runtime model the language has not otherwise chosen.
  **[STAGE: DECIDED_CORE_SEMANTICS | D156 → structured concurrency only; no language-level async/await/futures/executors; high-concurrency I/O layers build over the explicit `Poller`]**
- **Safe signal handling is notification-based and pollable; arbitrary Kyokai signal handlers do not exist** — POSIX signal-handler contexts are too restricted for ordinary Kyokai code, so the safe surface converts signals into explicit readiness notifications instead of pretending user callbacks are sound there.
**Rules**:
  1. Safe Kyokai provides no API to register an arbitrary Kyokai function as a signal handler.
  2. The runtime's actual signal-handler entrypoint is an internal tiny async-signal-safe shim only. It may perform only the minimal signal-safe notification work needed to wake the safe watcher path; it may not run user code, allocate, touch ordinary linear values, or perform non-signal-safe I/O.
  3. The safe surface is a capability-gated `SignalWatcher` type that exposes a pollable readiness source compatible with D93's `Poller`.
  4. `SignalWatcher` covers only catchable external signals such as termination, interrupt, hangup, and user-defined signals. Safe Kyokai does not expose synchronous fault signals such as `SIGSEGV`, `SIGBUS`, `SIGILL`, `SIGFPE`, or `SIGABRT` through this API.
  5. Synchronous fault signals cause runtime-fatal process termination; they are not translated into recoverable Kyokai values, cancellation, TPOE, or ordinary `panic`.
  6. `SIGPIPE` from safe I/O is translated into an explicit broken-pipe I/O result where the target platform permits that behavior; safe Kyokai I/O must not unexpectedly terminate the process merely because the default host disposition for `SIGPIPE` would do so.
  7. Signal claims are process-global and exclusive per signal number. Attempting to create a second safe watcher for a signal already claimed by another safe watcher fails explicitly, for example with `SignalInUse`.
  8. Delivery is notification-based, not "run the handler body now." Repeated identical signals may be coalesced before observation; one readiness observation means "at least one such signal arrived" rather than "exactly one arrival happened."
  9. Destroying a `SignalWatcher` consumes it, releases its process-global signal claim, and restores the previous signal disposition.
  10. Raw signal-handler registration remains an unsafe-only / FFI-only facility under D20 for code that must work directly at the POSIX boundary.
  **Why this fits Kyokai**: Unix signal support exists, but the unsafe kernel/C boundary stays explicit and the safe language surface remains poll-driven, capability-gated, and free of hidden control-flow injections.
  **[STAGE: DECIDED_CORE_SEMANTICS | D95/D256 → capability-gated `SignalWatcher`; no safe arbitrary signal handlers; raw registration stays unsafe-only; synchronous fault signals are runtime-fatal]**
- **Select / Multi-Channel Waiting**: multiplexing channel readiness requires a dedicated block so code can wait on several communication events without inventing hidden priority or polling folklore.
  **Syntax**:
  ```kyokai
  select
      when recvBlocking(&!rx1) as Some(val) do
          // handle val
      when recvBlocking(&!rx_shutdown) as Some(ignore) do
          // handle shutdown
      when timeout(deadline) do
          // handle timeout
  pick;
  ```
  **Why `pick;` as the terminator**: D9 requires block terminators to be either reversed keywords or semantic boundary words. Reversing `select` yields `tceles;`, which is unreadable. `pick;` is the right boundary word because the block picks one ready communication event. `esac;` remains for pattern matching only and is not reused here.
  **Rules**:
  1. A `select` block contains one or more `when` arms and may contain at most one `timeout(deadline)` arm.
  2. Each non-timeout arm names exactly one admitted blocking channel operation, together with any explicit result-pattern binding surface defined for that operation.
  3. `select` waits until at least one arm becomes ready.
  4. When one or more arms are ready, exactly one ready arm is chosen and exactly one arm body executes.
  5. If multiple arms are simultaneously ready, the language guarantees no fixed source-order priority. The implementation may choose any ready arm, but "first arm wins" is not part of the language semantics.
  6. A `timeout(deadline)` arm becomes ready when its deadline is reached before any other chosen arm completes.
  7. Any values, borrows, or ownership transfers associated with non-selected arms do not occur.
  8. If a selected arm transfers ownership, that transfer occurs exactly as though the selected blocking operation had been written alone.
  9. The same linear endpoint may not appear in multiple arms of one `select`.
  10. `select` is part of the core language concurrency model, not a library macro or toolchain convention.
  **Why this fits Kyokai**: the control-flow boundary is explicit, the terminator says what the construct does, and multiplexed waiting becomes part of the same auditable concurrency story as channels, cancellation, and polling.
  **[STAGE: DECIDED_CORE_SEMANTICS | D92/D258 -> `select ... when ... do ... pick;` block for multi-channel waiting with explicit non-priority selection semantics]**
- **Cross-task ordering follows a closed, language-level synchronization model** — Kyokai does not treat “whatever the backend thread library happened to do” as a specification.
**Rules**:
  1. Only the synchronization edges explicitly enumerated by D90a create language-level cross-task ordering.
  2. Under the current language design, those edges arise only from three primitive families: structured child-task boundaries, D3a channel transfer/closure observation, and D3b atomic/fence synchronization.
  3. Any cross-task interaction not covered by those edges provides no ordering guarantee, even if some hardware or backend happens to behave more strongly.
  **Why this fits Kyokai**: concurrency behavior becomes auditable in the same way ownership and failure behavior are auditable. If an ordering guarantee exists, the spec names it.
  **[STAGE: DECIDED_CORE_SEMANTICS | D90 → closed formal synchronization model for structured tasks, channels, and atomics/fences]**
- **Kyokai's happens-before inventory is explicit, closed, and minimum-complete for the currently decided concurrency primitives** — the language states the exact cross-task edges rather than gesturing at “C++-like” behavior and leaving the rest to folklore.
**HB edges**:
  1. **HB1: spawn-start** — the spawn point of `spawn [captures] do ... od;` happens-before the first operation of that child task.
  2. **HB2: child-finish / structured join** — the last operation of a child task happens-before the parent continues past that child task's structured join point.
  3. **HB3: channel value transfer** — a successful `sendBlocking(v)` or successful `trySend(v)` on an SPSC channel happens-before the successful `recvBlocking()` or `tryRecv()` that returns that same value `v`. Because D3a channels are FIFO, this matching receive is unique.
  4. **HB4: sender-close observation** — `closeSender(sender)` happens-before the receiver observes channel closure after drain, either by `recvBlocking()` returning `None` or by `tryRecv()` returning `Disconnected`.
  5. **HB5: release/acquire atomic synchronization** — an atomic write or successful read-modify-write operation with `Release`, `AcqRel`, or `SeqCst` semantics happens-before an atomic load or successful read-modify-write operation with `Acquire`, `AcqRel`, or `SeqCst` semantics on the same atomic location when the later operation reads a value from the earlier release sequence.
  6. **HB6: SeqCst total order** — all `SeqCst` atomic operations and `SeqCst` fences participate in one single total order consistent with each task's program order and each atomic location's modification order.
  7. **HB7: standard fence synchronization** — `fence` uses the ordinary acquire/release/seqcst fence semantics equivalent to C11/C++20: release-fence plus following atomic publication, acquire-fence plus prior atomic observation, and fence-to-fence synchronization through a shared atomic publication/observation pair all establish happens-before exactly as in that model.
**Side rules**:
  1. The seven HB edges above are the complete set of happens-before guarantees in Kyokai's current concurrency model.
  2. Failed channel operations, including `trySend(Full(...))`, `sendBlocking(...)->Err(...)`, and `tryRecv(Empty)`, create no happens-before edge.
  3. `Relaxed` atomic operations provide atomicity and per-location coherence only. They create no happens-before edge by themselves.
  4. The compiler, optimizer, and backend may reorder operations within a task as long as single-task semantics and the listed HB edges are preserved.
  5. Any future synchronization primitive must add its own happens-before edges explicitly before it becomes part of the sound safe-concurrency surface.
  6. Sequential consistency is available through explicit `SeqCst` operations and fences, but Kyokai does not force every atomic operation to be sequentially consistent. Lower-level orderings are admitted only through D3b's explicit `MemoryOrder` argument and D3b's operation-specific validity rules.
  **Why this fits Kyokai**: the memory-order story stays as conventional as necessary for correctness, while the language-specific edges for structured tasks and channels are stated just as explicitly as the ownership rules around them.
  **[STAGE: DECIDED_CORE_SEMANTICS | D90a/D247 → closed seven-edge happens-before inventory for structured tasks, channels, atomics, and fences; explicit full memory-order hierarchy, not SeqCst-only]**
- **Backend policy: C stays, LLVM becomes primary later, and the language is not constrained by “must lower nicely to portable C”** — Kyokai keeps C emission because it is valuable for bootstrap, inspectability, toolchain leverage, and bring-up on awkward targets, but the existence of the C backend does not get veto power over the language's long-term semantics or feature set.
**Rules**:
  1. Kyokai language semantics are backend-independent. No language rule is defined as "whatever the C backend does" or "whatever LLVM happens to do."
  2. The C backend remains a first-class backend for bootstrap, reference implementation work, inspectable output, and target bring-up. It is not a temporary embarrassment to be discarded as soon as LLVM exists.
  3. Once the compiler is being written in Kyokai and the project can afford deeper backend work, the LLVM backend becomes the primary optimizing production backend.
  4. LLVM is the planned long-term home for features whose best implementation depends on direct SSA-level control, richer optimization pipelines, better debug info, or first-class vector support.
  5. The language design is NOT limited to features that can be expressed as clean, maximally portable, human-maintainable ISO C source. A feature is judged first on whether it is right for Kyokai; backend support is then solved explicitly.
  6. If a backend/target pair cannot support some feature with the required language semantics, that limitation must be stated explicitly in the backend/target support contract rather than solved by silently weakening the language.
  7. The C backend may use explicit C toolchain facilities such as standard intrinsics, implementation-defined extensions, or generated helper code when needed, provided the selected toolchain contract is explicit and valid Kyokai programs do not rely on C undefined behavior.
  8. "Kyokai emits C" is a backend capability, not a promise that generated C is Kyokai's stable public interchange format or that every advanced feature must round-trip into pretty portable C suitable for direct hand-maintenance.
  9. Near-term engineering priority remains language completion and self-hosting progress, not trying to out-build LLVM immediately. Keeping the C backend healthy serves that priority; later LLVM work serves the performance and feature ceiling.
  **Why this fits Kyokai**: C keeps the language grounded and portable, while LLVM gives the project a clear path to advanced optimization and target features. The important line is explicit: C remains part of Kyokai, but C does not own Kyokai.
  **[STAGE: DECIDED_CORE_SEMANTICS | D4 → C retained as bootstrap/reference/portability backend; LLVM becomes the long-term primary optimizing backend after self-hosting; backend constraints do not define the language]**
- **Hard fork** — Kyokai is not Austral. Borretti's philosophy ("intentionally minimal") is different from Kyokai's goal ("production-ready systems language"). The compiler is ~12K lines of OCaml — manageable for a hard fork. Cherry-picking upstream bugfixes is still possible, but Kyokai is its own project with its own direction. **[STAGE: DECIDED_CORE_SEMANTICS | D5 → independent hard fork]**
- **Anonymous-by-default regions** — Kyokai makes `&[T]` a complete type meaning "borrow of T in an anonymous, scope-bounded region the compiler manages internally." There is no hidden slot, no elision rule, no inference — `&[T]` IS the type, the way `Int32` IS a 32-bit integer without anyone calling stack allocation "implicit." Named regions (`&[T, R]` with `generic [R: Region]`) remain available for the rare case where a return type references a region from an input parameter. Austral's own compiler already creates anonymous regions at expression level: `&x` in source calls `anonymous_region()` in `DesugarBorrows.ml` without the programmer naming anything. D6 extends this same principle from expressions to type signatures and removes repetitive `generic [R: Region]` headers from borrow-heavy code.
**Why named regions are not required for ordinary borrows**: Requiring named regions on every borrow forces every function that takes a borrow to declare `generic [R: Region]` — pure boilerplate that adds zero semantic information in 99% of cases. The region parameter is not a choice the programmer makes; it's compiler bookkeeping. Forcing it on every signature violates the readability research (section 3.4): eye-tracking shows boilerplate is wasted fixation time.
**Why this is not Rust-style elision**: Rust-style elision has the compiler apply rules to fill in blanks (`_`), which IS implicit — "what the person wrote down isn't what's happening." The anonymous-by-default form has no blanks to fill; the type is what you wrote.
**[STAGE: DECIDED_CORE_SEMANTICS | D6 → anonymous-by-default regions]**
- **Auto-reborrow**: when `out: &![T]` and a function expects `&![T]`, the compiler automatically inserts `&~` (reborrow). This is not hidden behavior - it follows the same tautology logic as D8 implicit `Unit` return. When a mutable reference is passed where a mutable reference is expected, exactly one valid operation exists.

  | Expression      | Meaning                                              | Valid? | Why                                                   |
  | --------------- | ---------------------------------------------------- | ------ | ----------------------------------------------------- |
  | `out` (consume) | Move the reference, can't use `out` again            | ❌      | You need `out` on the next line                       |
  | `&out`          | Immutable borrow of the reference itself             | ❌      | Wrong type - function expects `&![T]`, not `&[&![T]]` |
  | `&!out`         | New mutable borrow                                   | ❌      | `&!` takes owned values, not references               |
  | `&~out`         | Reborrow - new temporary reference from existing one | ✅      | Only valid option                                     |

  Since `&~` is the only thing that compiles, writing it explicitly adds zero bits of information. The complete borrow-insertion and read-reborrow table is:
  - `T` (owned) -> function expects `&![T]` -> compiler inserts `&!`
  - `T` (owned) -> function expects `&[T]` -> compiler inserts `&`
  - `&![T]` (mutable ref) -> function expects `&![T]` -> compiler inserts `&~`
  - `&![T]` (mutable ref) -> function expects `&[T]` -> compiler inserts a temporary immutable read reborrow of the referent
  - `&[T]` -> function expects `&![T]` is never legal

  Eliminates repeated `&~out` forwarding tokens in resource-heavy code. The programmer still sees the function signature declaring `&![T]` - mutability remains visible at the declaration site.
  **Why not keep explicit `&~` (Austral's approach)**: `&~` repeats information already encoded in the type system. When `out: &![ByteBuf]` and `appendByte` takes `&![ByteBuf]`, there is no second valid interpretation to distinguish.
  **Why not UFCS alone**: Pure UFCS without auto-reborrow provides near-zero benefit for repeated mutable-buffer operations. `(&~out).appendByte(27)` is the same character count as `appendByte(&~out, 27)` and just relocates the ceremony.
  **[DECIDED: D7b -> auto-reborrow, same logic as D8]**
- **Mutable-to-immutable borrow coercion is a read reborrow, not a subtype relation**: Kyokai allows `&![T]` where `&[T]` is expected, but this is specified as a temporary immutable reborrow of the referent rather than as general borrow subtyping.
  **Rules**:
  1. When an expression of type `&![T]` appears in a context expecting `&[T]`, the compiler may insert a temporary immutable reborrow of the referent.
  2. This is a coercion rule over expected-type positions, not a general subtype relation between `&![T]` and `&[T]`.
  3. The original mutable borrow remains suspended for the lifetime of the temporary immutable reborrow under the ordinary borrow rules.
  4. This coercion is legal in ordinary expected-type positions including call arguments, `let` initializers, return expressions, and branch/result type unification.
  5. `&[T]` to `&![T]` is never legal.
  6. No additional borrow coercions are implied beyond the explicit D7b/D187 table.
  **Why this fits Kyokai**: it captures the one obvious read-only interpretation programmers expect from Rust, Zig, and C++ style prior art, but it does so with a closed explicit coercion table instead of importing ambient variance or borrow subtyping machinery.
  **[STAGE: DECIDED_CORE_SEMANTICS | D187 -> mutable-to-immutable borrow coercion by temporary immutable read reborrow; not a subtype relation]**
- **UFCS dot syntax** — `expr.f(args)` is pure syntactic sugar for a call with `expr` as the first argument. The dot does not create virtual dispatch, implicit `self`, hidden allocation, or a second callable value model.
**What UFCS is**: Argument reordering plus explicit lookup. `out.appendByte(27)` lowers to a call whose first argument is `out`. The compiler first resolves `appendByte` through ordinary file-scope imports exactly as it would for `appendByte(out, 27)`. D254 adds one narrow fallback when ordinary lookup finds no candidate: receiver-module extension lookup over an explicit exported surface of the receiver type's defining module. There is no global method search, no dependency-wide ADL, no virtual dispatch, and no lookup based on arbitrary type signatures.
**What UFCS enables**: Subject-Verb-Object (SVO) ordering. Research (section 3.4) shows ~~80% of natural languages use SVO or SOV word order; Austral's `appendByte(&~~out, 27)` is VSO — the least common ordering. UFCS gives the programmer the choice to write SVO when it improves readability, while the function-call form remains valid for cases where VSO is clearer or where there's no natural subject.
**Where UFCS helps** (clear subject, repeated operations on same receiver):
  ```austral
  -- Before (VSO, with D6-E + D7b auto-reborrow + D12 integer inference):
  appendByte(out, 27);
  appendByte(out, '[');
  appendIndexDecimal(out, code);
  appendByte(out, 'm');

  -- After (SVO, with UFCS):
  out.appendByte(27);
  out.appendByte('[');
  out.appendIndexDecimal(code);
  out.appendByte('m');
  ```
  The SVO form makes it immediately clear that all four operations target `out`. The reader's eye tracks a vertical column of `out.` prefixes — the pattern is chunkable (section 3.4 finding: consistent shapes aid pattern recognition).
  **Where UFCS does NOT help** (no clear subject, multi-argument functions):
  ```austral
  -- These stay as regular function calls:
  writeAll(stdout_fd, &out);      -- neither argument is "the object"
  renderFetch(out, system_type, distro, kernel, ...);  -- 11 args, no natural subject
  ```
  **How a representative `ansi` helper looks with anonymous regions, UFCS, auto-reborrow, implicit `Unit` return, and literal typing (D6, D7a, D7b, D8, D12)**:
  ```austral
  -- Current Austral:
  generic [R: Region]
  function ansi(out: &![ByteBuf, R], code: Index): Unit is
      appendByte(&~out, 27 : Nat8);
      appendByte(&~out, '[');
      appendIndexDecimal(&~out, code);
      appendByte(&~out, 'm');
      return nil;
  end;
  ```
  ```kyokai
  // Kyokai:
  function ansi(out: &![ByteBuf], code: Index): Unit is
      out.appendByte(27);
      out.appendByte('[');
      out.appendIndexDecimal(code);
      out.appendByte('m');
  qed;
  ```
  8 lines → 6 lines. Every remaining token carries information. The generic header is gone (D6-E). The `&~` tokens are gone (D7b). The `: Nat8` annotations are gone (D12). The `return nil` is gone (D8). The SVO ordering is readable (D7a). Nothing is hidden — `out: &![ByteBuf]` in the signature says "mutable borrow," and every `.appendByte(27)` call is visibly resolved by ordinary imports or D254's explicit receiver-module fallback with `out` as first argument.
  **Parser implementation** (`Parser.mly`): Currently `PERIOD identifier` produces `CSlotAccessor` (field access, line 498). UFCS requires a new parse rule: when `PERIOD identifier argument_list` follows an `atomic_expression`, it produces a `CMethodCall` AST node that desugars to `CFuncall(identifier, expr :: args)` in the abstraction pass. The `path` grammar rule (line 488) needs extending to allow `path_rest` entries that include argument lists, distinguishing field access (`obj.field`) from UFCS calls (`obj.func(args)`) by the presence of parentheses.
  **[STAGE: DECIDED_CORE_SEMANTICS | D7a/D254 → UFCS argument reordering with ordinary lookup plus narrow receiver-module extension fallback]**
- **UFCS conflict handling is ordinary call conflict handling plus D254's narrow receiver-module fallback** — the dot form does not gain C++-style ADL, import-order priority, or global method search.
**Rules**:
  1. If ordinary imported-name lookup for `expr.f(args)` finds a unique candidate, the call lowers exactly as `f(expr, args)`.
  2. If ordinary imported-name lookup finds multiple candidates, the UFCS form is ambiguous and the compiler rejects it. The receiver-module fallback is not used to override an import collision.
  3. If ordinary imported-name lookup finds no candidate, D254 may search the receiver type's defining module for explicitly exported receiver-callable functions for that type.
  4. The programmer disambiguates with an ordinary qualified function call or with an explicit import rename. UFCS does not invent local method aliases or hidden precedence rules.
  5. UFCS does not override typeclass dispatch; receiver-module lookup is a name-resolution fallback for ordinary functions only.
  **Why this fits Kyokai**: the dot form stays honest call sugar while solving the repeated `length`/`isEmpty` import-collision problem without importing C++-style ADL folklore.
  **[STAGE: DECIDED_CORE_SEMANTICS | D110/D254 → UFCS ambiguity is ordinary call ambiguity; receiver-module lookup is a no-import fallback only]**
- **No pipeline operator** — Kyokai does not add `|>`. UFCS is the language's one built-in left-to-right call-chain surface, and a second spelling for the same first-argument flow would create needless style bifurcation.
**Rules**:
  1. `|>` is not part of Kyokai syntax.
  2. Left-to-right chaining is expressed with UFCS `expr.f(args)` when the underlying call shape is first-argument application.
  3. When a call does not fit UFCS naturally, the programmer writes the ordinary function-call form.
  **Why this fits Kyokai**: one visible left-to-right call style is enough, and Kyokai does not need a second pipeline surface that overlaps almost perfectly with UFCS.
  **[STAGE: DECIDED_CORE_SEMANTICS | D108 → reject `|>`; UFCS remains the sole built-in left-to-right chaining sugar]**
- **Implicit Unit return** — functions declared `: Unit` do not require `return nil;` at the end of their body. When execution reaches the end of a `: Unit` function, the function returns `Unit`. This is NOT implicit return of arbitrary expressions (like Rust's last-expression-is-return-value). It applies ONLY to `: Unit` functions, ONLY at the end of the function body, and ONLY because `Unit` has exactly ONE inhabitant (`nil`). `return nil` communicates zero bits of information — the function signature `: Unit` already declares there is nothing to return, and `nil` is the only value of type `Unit`. This is the same principle as auto-reborrow (D7b): when there is exactly one valid operation, requiring the programmer to write it explicitly is ceremony, not explicitness. Explicit early returns (`return nil;` or `return;` mid-function) remain required because they signal that control flow is leaving the function body early — that IS meaningful information. This removes repeated trailing `return nil;` lines from `Unit`-heavy code.
**Why not keep `return nil;` required (Austral's approach)**: `return nil` is a tautology in information theory — it states the only possible outcome. The function signature already makes the return type explicit. Requiring `return nil` is like requiring you to write `if true then ... end if` — technically more explicit, but the explicitness carries no information.
**Why not implicit return of expressions (Rust-style)**: Rust's `fn foo() -> i32 { 42 }` where the last expression is the return value is a DIFFERENT feature. That's implicit because the programmer chose not to write `return`. Kyokai's implicit Unit return is not a choice — there is only one value of type `Unit`, so there is nothing to choose. This distinction matters: Kyokai will NOT adopt Rust-style last-expression-as-return for non-Unit functions.
**[STAGE: DECIDED_CORE_SEMANTICS | D8 → implicit Unit return]**
- **Two-category block terminators** — Kyokai replaces Austral's generic `end X;` terminators with a system split into two categories, each with a clear rationale.
**Category 1: Pure Control Flow — Reversed Keywords (Algol 68 style).** For branching and looping, the closing keyword is the reverse spelling of the opening keyword. This is battle-tested from Algol 68 (the grandfather of Bash's `if/fi`, `case/esac`).

  | Construct     | Open               | Close   | Origin                   |
  | ------------- | ------------------ | ------- | ------------------------ |
  | Conditional   | `if ... then`      | `fi;`   | Algol 68                 |
  | Pattern match | `case ... of`      | `esac;` | Algol 68                 |
  | Loops         | `while/for ... do` | `od;`   | Algol 68 (`do` reversed) |

  `fi` closes the entire `if/else if/else` chain — one terminator for the whole construct, no nesting ambiguity:
  ```kyokai
  if ty != Linux then
      return;
  else if ty == Gentoo then
      gentooArt(out);
  else
      defaultArt(out);
  fi;
  ```
  Both `for` and `while` loops use `do` to open the body, so `od` closes both — the terminator matches the body-initiator, not the outer keyword:
  ```kyokai
  for i from 0 to 10 do
      out.appendByte(i);
  od;

  while running do
      poll();
  od;
  ```
  **Category 2: State & Boundaries — Semantic Boundary Words.** You can't reverse `module` (`eludom`) or `borrow` (`worrob`) — they look like typos. Instead, Kyokai uses terminators that describe what is happening at the boundary. Since Kyokai literally means "boundary" (境界), these terminators make the resource/scope lifecycle explicit.

  | Construct   | Open                  | Close    | Semantic meaning                                                                                                                                                                                               |
  | ----------- | --------------------- | -------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
  | Functions   | `function ... is`     | `qed;`   | "quod erat demonstrandum" — proof complete. Functions in Kyokai ARE proofs: the linearity checker proves every resource is consumed. 3 chars, completely unambiguous, no collision with any identifier.        |
  | Methods     | `method ... is`       | `qed;`   | Methods are functions. Same terminator.                                                                                                                                                                        |
  | Instances   | `instance ... is`     | `qed;`   | The MOST mathematically justified use — an instance is a **proof** (witness) that a type satisfies a typeclass contract.                                                                                       |
  | Type defs   | `record/union ... is` | `build;` | Type definition constructed. Both records and unions are type constructions at the compiler level — splitting them onto different terminators adds a rule to memorize for zero gain. 6 chars.                  |
  | Typeclasses | `typeclass ... is`    | `spec;`  | A typeclass declares a contract/specification, not an implementation. 5 chars, unambiguous.                                                                                                                    |
  | Borrows     | `borrow ... do`       | `drop;`  | The reference is dropped. `drop` is the established term in linear/affine type systems (Rust, etc.). 5 chars. `release` was considered but rejected — too natural a function name in resource management code. |
  | Modules     | `module body ... is`  | `seal;`  | The module's symbol table is sealed. 5 chars vs Austral's `end module body.` (16 chars).                                                                                                                       |
  | FFI blocks  | `foreign "C" is`      | `mon;`   | The foreign boundary is a gate/portal (`門`). `mon;` marks that the raw ABI gateway is now closed and keeps the FFI boundary visually distinct from proof bodies.                                              |

  **Full example showing both categories together:**
  ```kyokai
  module body Kyokai.Fetch is

      record ByteBuf is
          data: Address[Nat8];
          capacity: Index;
          size: Index;
      build;

      typeclass Serialize[T] is
          method serialize(val: &[T]): ByteBuf;
      spec;

      instance Serialize[Point] is
          method serialize(val: &[Point]): ByteBuf is
              let buf: ByteBuf := makeByteBuf(64);
              buf.appendByte(val.x);
              buf.appendByte(val.y);
              return buf;
          qed;
      qed;

      function ansi(out: &![ByteBuf], code: Index): Unit is
          out.appendByte(27);
          out.appendByte('[');
          out.appendIndexDecimal(code);
          out.appendByte('m');
      qed;

      function main(): ExitCode is
          var out: ByteBuf := makeByteBuf(16384);
          defer out.destroyByteBuf();

          if showHelp then
              out.appendHelp();
          else if showVersion then
              out.appendVersion();
          else
              fetchAndRender(out);
          fi;

          writeAll(stdout_fd, &out);
          return ExitSuccess();
      qed;

  seal;
  ```
  **Why not Austral's `end X;`**: `end if; end for; end if; end for; end;` is verbose boilerplate that carries information only when nesting is deep. Kyokai code is shallow by design (linear types prevent deep branching). The verbosity cost is paid on every construct; the readability benefit is collected only at deep nesting that almost never occurs.
  **Why not braces `{}`**: Braces work but are generic — `}` tells you nothing about what it closes. Kyokai's terminators are self-documenting: `fi` tells you an `if` ended, `qed` tells you a proof ended, `drop` tells you a borrow ended, and `mon` tells you a foreign gateway ended. This is strictly more informative than `}` at zero extra cost (most terminators are 2–5 chars).
  **Why not uniform `end;`**: Gets the worst of both worlds — verbose like Ada but uninformative like braces.
  **`build` keyword collision note**: `build` conflicts with the builder pattern (`buf.build()`). Convention: name builder-finalization functions `new` instead. This is already natural in Kyokai since constructors are just functions.
  **[STAGE: DECIDED_CORE_SEMANTICS | D9 → Two-category terminators: reversed keywords (`fi`/`od`/`esac`) + semantic boundary words (`qed`/`build`/`spec`/`drop`/`seal`/`mon`/`pick`/`join`/`audit`)]**
- **The D111 revisit keeps the existing terminator names intact; later D127 adds `mon;` for foreign blocks without renaming the already decided spellings** — borrow scopes continue to close with `drop;`, and Kyokai does not introduce synonym terminators for the existing constructs.
**Rules**:
  1. `drop;` remains the borrow-scope terminator.
  2. Kyokai does not add `unborrow` as a second borrow-scope terminator spelling.
  3. The terminator inventory now stands at `fi;`, `esac;`, `od;`, `qed;`, `build;`, `spec;`, `drop;`, `seal;`, `mon;`, `pick;`, `join;`, and `audit;` under the current language design.
  **Why this fits Kyokai**: the terminator system is already coherent, and renaming one piece would add churn without resolving any real semantic problem.
  **[STAGE: DECIDED_CORE_SEMANTICS | D111 → keep D9 unchanged; `drop` retained]**
- **Not-equal operator: `!=`** — Kyokai switches from Austral's `/=` (Ada/Haskell convention) to `!=` (C/Rust/Zig/Go/Python/JavaScript convention). `/=` is used by exactly two actively maintained languages (Haskell and Ada) and is visually ambiguous — it looks like "divide-equals" (Python's `/=` IS a divide-and-assign operator). `!=` is universally recognized; the cognitive cost of parsing it is zero. Trivial compiler change (lexer token swap).
**Why not keep `/=`**: Creates genuine confusion for programmers from Python/JavaScript/etc. where `/=` means divide-assign. Kyokai gains nothing from preserving Ada heritage in a symbol that 99% of programmers read incorrectly on first encounter.
**[STAGE: DECIDED_CORE_SEMANTICS | D10 → switch to `!=`]**
- **Keep `camelCase` naming** — Kyokai keeps Austral's naming convention: `camelCase` for functions/variables, `PascalCase` for types and modules. Research (Binkley et al. 2009) shows `camelCase` has slightly higher accuracy, and Sharif & Maletic (2010) shows `snake_case` is slightly faster on first fixation — but the difference is small; **consistency dominates both**. Changing from Austral's convention would force every existing Austral program to be rewritten for zero measurable benefit.
**Why not `snake_case`**: The research difference is negligible. Consistency matters more than convention choice. Austral is already consistent with `camelCase`. Migration cost is high, benefit is near-zero.
**[STAGE: DECIDED_CORE_SEMANTICS | D11a → keep `camelCase`]**
- **Ownership-signaling naming patterns** — Kyokai adopts Rust's API naming conventions (adapted to camelCase) as a mandatory convention for the standard library and recommended for user code. These patterns encode **cost, ownership, and allocator semantics** directly into function names, which is especially powerful in a linear type system where the most important question at any call site is "does this consume my resource, borrow it, or allocate a fresh owned result?"
**The rules**:
  1. `**as*`** (e.g., `asSpan`, `asBytes`): Free conversion. Borrows input (`&[T]`), returns a view or borrow. **No allocation, no ownership transfer.**
  2. `**to*In`** (e.g., `toStringIn`, `toBufferIn`): Expensive borrowing conversion. Borrows input (`&[T]`), takes an explicit destination allocator, and returns a new owned value. **Allocates memory, no ownership transfer.**
  3. `**into*`** (e.g., `intoBuffer`, `intoBytes`): Consuming conversion. Takes input by value (`T`), returns a new type. **Consumes the original resource, and is reserved for conversions that transfer/reuse storage or otherwise do not need a fresh destination allocator.**
  4. `**into*In`** (e.g., `intoBufferIn`, `intoStringIn`): Consuming conversion that still needs fresh destination allocation. Takes input by value plus an explicit destination allocator. **Consumes the source and allocates the result.**
  5. `**make*`** (e.g., `makeByteBuf`): Default constructor. Creates a new resource from scratch. (Austral already does this.)
  6. `**from*`** (e.g., `fromSpan`): Conversion constructor. Creates a new resource by copying/parsing another. If it allocates, the allocator must still be explicit per D201.
  7. **No `get` prefix**: Getters drop the `get` — `buf.length()` not `buf.getLength()`. Actions use verbs (`buf.clear()`).
  **Why this is a philosophical home run for Kyokai**: The language is literally named "Boundary" (境界) and focuses on strict resource management. Baking ownership boundaries into the VOCABULARY means the call site tells you the ownership story before you even read the signature. Combined with UFCS (D7a), it makes Kyokai code read as natural data pipelines: `string.asBytes().intoBuffer()`.
  **Enforcement: compiler warnings, not an external linter.** Kyokai's compiler already knows the function signatures — it knows whether a function takes `T` (consumes) vs `&[T]` (borrows). So the compiler can verify that names match behavior:
  - `into*` function whose first param is `&[T]` (not consuming) → **warning**: "function named `into*` should consume its first argument"
  - `as*` function that returns a `Linear` type (allocates) → **warning**: "function named `as*` should return a Free view, not allocate"
  - `to*In` function that does not take an explicit destination allocator → **warning**: "allocating borrowed conversion should use `...In` and take an explicit allocator"
  - `to*In` function that consumes its first argument → **warning**: "consuming function should be named `into*`/`into*In`, not `to*In`"
  - `into*` function that may allocate a fresh destination result → **warning**: "allocating consuming conversion should be named `into*In`"
  No external linter needed. The compiler IS the linter. This fits Kyokai's "one tool, the compiler" philosophy. These are warnings, not errors — the programmer can ignore them with good reason.
  **[DECIDED: D11b → Adopt ownership-signaling naming patterns, compiler-warned]**
- **Bidirectional integer literal inference** — when a numeric literal appears in a position where the expected type is known (function parameter, binary operator operand, variable initializer with explicit type annotation), the compiler infers the literal's type from context. `makeByteBuf(16384)` instead of `makeByteBuf(16384 : Index)`. This is NOT full type inference — it pushes a KNOWN type from a declaration into a literal. The type is visible in the function signature. Ambiguous cases (multiple valid types) still require explicit annotation.
**Why not keep fully explicit**: `(16384 : Index)` restates information already in the function signature. The parameter is declared `cap0: Index` — writing `: Index` again at the call site adds zero information. Same principle as D7b (auto-reborrow) and D8 (implicit Unit return): when there is exactly one valid interpretation, requiring the programmer to restate it is ceremony.
**[STAGE: DECIDED_CORE_SEMANTICS | D12 → bidirectional inference for literals]**
- **Numeric literals may use `_` separators as purely lexical readability markers** — Kyokai adopts the modern consensus spelling for large constants while keeping the lexer rules fully explicit.
**Rules**:
  1. `_` may appear only between two digits in the same digit run of an integer or floating literal.
  2. `_` may not appear at the start or end of a literal, immediately after a base prefix (`0x`, `0o`, `0b`), or adjacent to a decimal point or exponent marker.
  3. Separators do not affect the value; the lexer discards them after validation.
  4. Examples: `1_000_000`, `0xDEAD_BEEF`, `0b1010_0101`, `3.141_592`, `1.0e10_0`.
  **Why this fits Kyokai**: the feature is lexical only, universally understood by modern systems programmers, and adds no hidden semantics beyond clearer digit grouping.
  **[STAGE: DECIDED_CORE_SEMANTICS | D135 → `_` separators between digits in integer and floating literals under tight lexical rules]**
- **Numeric literal suffixes are explicit built-in literal typing, not C-style conversion folklore** — suffixes complement D12's contextual literal inference for constants whose expected type is not otherwise visible or where the type is part of the constant's meaning.
**Rules**:
  1. Integer literals may use exactly these suffixes: `i8`, `i16`, `i32`, `i64`, `n8`, `n16`, `n32`, `n64`, and `index`.
  2. The suffixes map respectively to `Int8`, `Int16`, `Int32`, `Int64`, `Nat8`, `Nat16`, `Nat32`, `Nat64`, and `Index`.
  3. Floating-point literals may use exactly `f32` and `f64`, mapping to `Float32` and `Float64`.
  4. A suffixed literal has the suffixed type before D12 contextual inference. Context may confirm that type, but it may not silently retarget the literal to another type.
  5. If the literal value is not representable in the suffixed type, compilation fails for the comptime-known literal.
  6. Literal suffixes do not create implicit numeric conversions, promotions, signedness changes, or C-style partial suffix composition.
  7. `_` digit separators from D135 remain lexical separators and may appear inside the digit run before the suffix, never inside the suffix itself.
  **Why this fits Kyokai**: the programmer can write compact fixed-width constants without restating a bulky annotation, but the suffix set is closed, readable, and has no hidden conversion behavior.
  **[STAGE: DECIDED_CORE_SEMANTICS | D261 → closed numeric literal suffix set for fixed-width integer, `Index`, and floating literals]**
- **Keep `do` in pattern matching** — Kyokai keeps Austral's `case x of when Foo do ... esac;` syntax with `do` instead of switching to `=>`. This keeps the symbol count low — `do` is a keyword (searchable, pronounceable, consistent with `for/while ... do`), while `=>` is a symbol that adds visual noise in a language already using `->` for something else. The `do` keyword is also already established in D9's terminator system (`do`/`od` for loops) — reusing it for `when` clauses maintains internal consistency.
**Why not `=>` (Ada convention)**: Even though Ada uses `=>`, Kyokai is not Ada. `=>` adds another symbol to memorize, and Kyokai already uses `->` (function return type arrow). Keeping `do` means one less symbol in the language. The `when Foo do` reads naturally as English: "when it's Foo, do this."
**Why not `match`**: `case`/`when` is already Austral's vocabulary. Changing the keyword gains nothing and breaks compatibility.
**[STAGE: DECIDED_CORE_SEMANTICS | D13 → Keep `do` in when-clauses]**
- **Keep reference/reborrow syntax** — Kyokai keeps Austral's reference operators unchanged: `&x` (immutable borrow), `&!x` (mutable borrow), `~x` (dereference), `&~x` (reborrow). The `~` vs `*` debate is cosmetic — changing it would affect 200+ occurrences for zero semantic benefit. With UFCS (D7a) and auto-reborrow (D7b) already decided, most `&~` occurrences are eliminated anyway (UFCS removes the explicit first argument, auto-reborrow handles the remaining cases). The few remaining explicit uses of `~` and `&~` are infrequent enough that the syntax choice is a non-issue.
**Why not change `~` to `*`**: Kyokai is not C and is not Rust. `~` is Austral's operator, it works, it's compositional (`&` + `~` = `&~`), and UFCS/auto-reborrow make it rare in practice. Changing it is churn for zero gain.
**[STAGE: DECIDED_CORE_SEMANTICS | D14 → Keep current reference/reborrow syntax]**
- **Two-layer error propagation** — Kyokai introduces a two-layer system for error handling on `Result[T, E]` types, solving the "arrow anti-pattern" (nested `case`/`esac`) without hiding any control flow or data construction.
**Layer 1: `let...else` (the foundation — 100% explicit)**
A diverging pattern match that flattens nesting by binding the success variant in the outer scope and requiring the else block to diverge (`return`, `break`, `continue`, or `panic`). Works for ANY two-variant union type (Result, Optional, custom unions).
  ```kyokai
  // Full form (multi-statement else block):
  let Ok(file) := openFile(path) else Err(e) do
      logError(e);
      return Err(e);
  fi;

  // Common form (single-statement):
  let Ok(file) := openFile(path) else Err(e) do return Err(e); fi;

  // Works for Optional too:
  let Some(value) := lookupTable(key) else None do return defaultResult; fi;
  ```
  Rules:
  1. **Two-variant limitation**: Valid ONLY for union types with exactly two variants.
  2. **Forced divergence**: The compiler enforces that the `else` block MUST diverge. If it doesn't, it's a compile error — not a lint, a hard error.
  3. **Zero magic**: The compiler does not implicitly cast errors, construct variants, or auto-return. The programmer writes everything.
  4. **Terminator**: `do`/`fi` — the `else` block is a conditional divergence (if pattern doesn't match → diverge), so `fi` (the conditional terminator from D9) closes it.
  5. **Scope**: The successfully matched variable (`file`, `value`) is bound in the OUTER scope after the `fi;`, not inside a nested block.
  **Layer 2: `or return` / `or break` / `or continue` (defined sugar)**
  Syntactic sugar with a PRECISE, TRACEABLE desugaring into the `let...else` form. The programmer opts into the sugar — it's never forced.
  ```kyokai
  // Sugar:
  let file: File := openFile(path) or return;
  let file: File := openFile(path) or return err => ConfigError.Io(err);
  // Desugars EXACTLY to:
  let Ok(file) := openFile(path) else Err(__e) do return Err(__e); fi;
  ```
  The `or` family:

  | Operator                    | Context                     | Desugaring                                        |
  | --------------------------- | --------------------------- | ------------------------------------------------- |
  | `or return`                 | Function returning `Result` | `else Err(e) do return Err(e); fi;`               |
  | `or return name => expr`    | Function returning `Result` | `else Err(name) do return Err(expr); fi;`         |
  | `or break`                  | Inside a loop               | `else Err(ignore) do break; fi;`                  |
  | `or continue`               | Inside a loop               | `else Err(ignore) do continue; fi;`               |

  Restrictions (statement-level only):
  - `or return` can ONLY appear at the end of a `let` binding statement.
  - NOT an expression-level operator — cannot appear inside subexpressions.
  - There is no implicit error conversion. A type change requires the explicit-binder form `or return name => expr`.
  - Grammar: `let ID : TYPE := EXPR or return ;` | `let ID : TYPE := EXPR or return ID => EXPR ;` | `let ID : TYPE := EXPR or break ;` | `let ID : TYPE := EXPR or continue ;`
  **Why `or return` hides `Err(e)` construction — and why it's acceptable:**
  `or return` implicitly constructs `Err(e)` in the function's return type. This IS implicit data construction. But by the D7b/D8 principle ("when there is exactly ONE valid interpretation, requiring the programmer to restate it is ceremony"), the `Err(e)` wrapping is the ONLY valid operation — there's nothing else to return. The `let...else` form exists as the escape hatch for when you need full control (logging, error mapping, cleanup).
  **Why two layers instead of just one:**
  1. `let...else` alone is verbose for the 90% case (simple propagation). 3 lines × 5 ops = 15 extra lines.
  2. `or return` alone has no escape hatch for complex error handling. You fall back to full `case`/`esac` (deeply nested).
  3. Together: three levels of control — `or return` (1 line, sugar), `let...else` (3 lines, fully explicit), `case`/`esac` (multi-branch). Each fills a gap.
  **Prior art:**
  - **Rust**: Has BOTH `?` (sugar) AND `let...else` (RFC 3137, stabilized 1.65). They coexist — proving even with sugar, the explicit form is wanted.
  - **Swift**: `guard let x = expr else { return }` — diverging pattern match since Swift 1.0, considered one of the language's best features.
  - **Odin**: the Odin design history tried prefix `try`, removed it because it "optimizes for typing not reading", replaced with suffix `or_return` — 350+ uses in `core:math/big` alone.
  - **Borretti**: "all potentially-throwing operations return union types. This can be made less onerous through syntactic sugar." He explicitly validated sugar for linear type systems.
  `**defer` vs `errdefer` patterns (prerequisite from D2):**
  ```kyokai
  // Pattern A: Acquire-Use-Release (use defer — consumed on ALL exits)
  function readConfig(path: Span[Nat8, Static]): Result[Config, IoError] is
      let file: File := openFile(path) or return;
      defer closeFile(file);
      let content: String := readAll(&file) or return;
      return Ok(parseConfig(&content));
  qed;

  // Pattern B: Build-and-Return (use errdefer — consumed on ERROR exits only)
  function openConfigFile(path: Span[Nat8, Static]): Result[File, IoError] is
      let file: File := openFile(path) or return;
      errdefer closeFile(file);
      validateMagicBytes(&file) or return;
      return Ok(file);  // file consumed here on happy path
  qed;
  ```
  The linearity checker records two cleanup-reservation facts layered over the D348 ownership state set: ordinary-cleanup reservation from `defer` (consumed on all eligible exits, borrows allowed) and error-exit cleanup reservation from `errdefer` (consumed on structured error exits only, must be explicitly discharged on the happy path). This is a D2 implementation detail that must be specified before D15 can work.
  **[STAGE: DECIDED_CORE_SEMANTICS | D15 → Two-layer error propagation: `let...else` base + `or return` sugar]**
- **`defer` and `errdefer` create explicit linearity-checker reservation facts, not hidden reference capture** — cleanup is registered where the programmer writes it, and the checker records which future exit path consumes the linear value. These reservation facts are layered over the D348 ownership state set.
**Rules**:
  1. `defer action(value);` registers a consuming scope-exit action immediately. Any linear value consumed by that deferred action gains an ordinary-cleanup reservation fact at the `defer` statement.
  2. A value with an ordinary-cleanup reservation may be borrowed under the ordinary borrow rules, but it may not be moved, consumed by another operation, reassigned, returned, sent, or registered in another consuming cleanup action.
  3. On every structured scope exit that runs ordinary cleanup, `defer` actions execute in reverse registration order.
  4. Deferred actions run after borrow scopes that were live in the body have ended. A deferred action may not capture or depend on a borrow whose lifetime does not reach the deferred action's execution point.
  5. `errdefer action(value);` registers a consuming cleanup action for structured error exits only. Any linear value consumed by that action gains an error-exit cleanup reservation fact at the `errdefer` statement.
  6. A value with an error-exit cleanup reservation may be borrowed under ordinary borrow rules. On the success path, the program must explicitly consume, move, return, or otherwise discharge the value before the scope exits.
  7. On a structured error exit, `errdefer` actions execute before ordinary `defer` actions from the same scope, with each category executing in reverse registration order.
  8. `errdefer` does not run on ordinary success completion, `break`, `continue`, `panic`, or TPOE. Its structured-error triggers are `return Err(value)` and `or return`.
  9. TPOE remains immediate hard termination under D84 and does not run user deferred actions.
**Why this fits Kyokai**: the programmer still writes every cleanup action explicitly, but the compiler gets exact states for values that have already been promised to future cleanup.
  **[STAGE: DECIDED_CORE_SEMANTICS | D246 → ordinary-cleanup and error-exit cleanup reservation facts layered over D348 ownership states; defer captures by immediate cleanup registration, not by late reference evaluation]**
- `**let...else` and the `or ...` sugars have exact typing and linearity rules** — Kyokai does not leave these control-flow forms to ad hoc checker special cases.
**Rules for `let...else`:**
  1. In `let P := E else Q do B fi;`, the scrutinee expression `E` is evaluated exactly once.
  2. `let...else` is legal only if `E` has a two-variant union type.
  3. The success pattern `P` must be refutable for the type of `E`. An irrefutable pattern makes the construct illegal.
  4. The success pattern `P` and else pattern `Q` must be exhaustive over the two variants of `E`'s type.
  5. The else block `B` must type-check as `Never`.
  6. An expression does not satisfy rule 5 merely because it may trigger TPOE at runtime. Potential contract failure is not the same thing as statically known divergence.
  7. Names bound by `P` enter scope only after `fi;`.
  8. Names bound by `Q` exist only inside the else block.
  9. All bindings introduced by `P` and `Q` obey D60's no-shadowing rule.
  **Linearity rules:**
  1. The union value produced by `E` is consumed exactly once by the pattern test.
  2. On the success path, any linear payload bound by `P` becomes the outer binding after `fi;` and must be consumed on that path in the ordinary way.
  3. On the else path, any linear payload bound by `Q` must be consumed inside `B`.
  4. Because `B` has type `Never`, there is no post-`fi` branch join that must reconcile else-path linear bindings with the success path.
  **Rules for `or return` / `or break` / `or continue`:**
  1. These are statement forms only. They may appear only at the end of a `let` binding statement.
  2. They are defined by exact desugaring, not by custom checker behavior.
  3. The `or ...` sugars apply only to `Result[T, E]`, not to arbitrary two-variant unions.
  4. Plain `or return` is legal only inside a function whose return type is `Result[U, E]` with the same error type `E`.
  5. `or return name => expr` is legal only inside a function whose return type is `Result[U, F]`, where the scrutinee has type `Result[T, E]`, `name` binds the inner error payload inside `expr`, and `expr` has type `F`.
  6. `or break` and `or continue` are legal only inside loop scopes.
  7. `or break` and `or continue` are legal only when the `Err` payload type is `Free`. If the error payload is `Linear`, the programmer must use `let...else` and explicitly consume that payload before `break` or `continue`.
  8. There is no implicit error conversion. Any type change on `or return` exists only because the programmer wrote an explicit mapping expression.
  9. For `errdefer` and error-path analysis, `or return` counts as a structured error exit because it is exact sugar over a `return Err(...)` path. `or break` and `or continue` do not count as error exits for `errdefer`; they are ordinary loop-control exits.
  **Exact desugarings:**
  ```kyokai
  let x: T := expr or return;
  ```
  desugars to:
  ```kyokai
  let Ok(x) := expr else Err(__e) do return Err(__e); fi;
  ```
  ```kyokai
  let x: T := expr or return err => mapError(err);
  ```
  desugars to:
  ```kyokai
  let Ok(x) := expr else Err(err) do return Err(mapError(err)); fi;
  ```
  ```kyokai
  let x: T := expr or break;
  ```
  desugars to:
  ```kyokai
  let Ok(x) := expr else Err(ignore) do break; fi;
  ```
  ```kyokai
  let x: T := expr or continue;
  ```
  desugars to:
  ```kyokai
  let Ok(x) := expr else Err(ignore) do continue; fi;
  ```
  **Why this fits Kyokai**: the user-facing forms stay compact, but the type checker, linearity checker, and defer/error-path behavior all follow one explicit set of rules with no hidden branch semantics.
  **[STAGE: DECIDED_CORE_SEMANTICS | D15a → exact typing, scope, desugaring, path-local linearity rules, and explicit-binder inline error mapping for `let...else` / `or ...`]**
- **Keep semicolons** — Semicolons stay. Borretti's argument is sound: semicolons provide redundancy that aids both reading and parser error recovery. `let x : T := f(a, b, c;` — the parser detects the missing `)` immediately at the `;`. Kyokai's statement-oriented, keyword-heavy syntax is complemented by semicolons, not hindered by them. Removing them would require grammar changes and introduce ambiguity risks for zero real benefit.
**Why not remove them**: The cognitive cost of typing `;` is negligible. The "modern feel" argument is aesthetic, not functional. Kyokai's syntax is already distinctive through its keywords and terminators (D9) — removing semicolons would not make it feel more modern, just more ambiguous.
**[STAGE: DECIDED_CORE_SEMANTICS | D16 → Keep semicolons]**
- **Compile-time evaluation: `constant` expressions + `comptime` call-site keyword** — Two tools for two jobs. `constant` declarations are extended to support arithmetic/bitwise expressions over other constants (emitted as C constant expressions — zero compiler cost). `static_assert(expr, "msg")` validates invariants at compile time (emitted as `_Static_assert`). For computed constants (lookup tables, precomputed arrays), the `comptime` keyword at the **call site** forces compile-time evaluation of any pure function over `Free` types. This is Zig's model, not Rust's: the programmer writes `comptime computeEscapeTable()`, making the phase determination explicit and visible in source. There is no `const fn` annotation on function definitions — a function is a function, and whether it runs at compile time or runtime is determined where it's called. Only `Free`-universe types are eligible for `comptime` evaluation (linear types represent runtime resources and cannot exist at compile time). Kyokai's existing `Free`/`Linear` universe distinction makes this check trivial — the compiler already knows which universe every type belongs to.
**Why `comptime` call-site, not `const fn` definition-site**: Rust's `const fn` creates implicit phase determination — the same function call silently evaluates at compile time in a `const` block and at runtime in a `let` block. Identical syntax, completely different execution. This violates Kyokai's principle: "if two programs look identical, they behave identically." The `comptime` keyword makes the phase visible, the same way `defer` makes scope-exit visible.
**Why both forms exist**: They serve different purposes and don't compete. `constant` handles simple named values (`constant PAGE_SIZE: Index := 4096;`). `comptime` handles computed values (`constant ESCAPE_TABLE: Array[Bool, 256] := comptime computeEscapeTable();`). Linear types make `comptime` simpler to implement than Rust's `const fn` was — there's no need for a "const-safe subset" analysis because the `Free`/`Linear` boundary already exists.
**Implementation**:
  ```kyokai
  // Simple constants:
  constant PAGE_SIZE: Index := 4096;
  constant MAX_HEADERS: Index := PAGE_SIZE * 2;
  static_assert(MAX_HEADERS >= 512, "Buffer too small");

  // Computed constants (comptime call-site keyword):
  function computeEscapeTable(): Array[Bool, 256] is
      // pure arithmetic over Free types, nothing special about this function
      ...
  qed;

  constant ESCAPE_TABLE: Array[Bool, 256] := comptime computeEscapeTable();

  // Same function, runtime — no ambiguity:
  let table: Array[Bool, 256] := computeEscapeTable();
  ```
  **`comptime` eligibility rules** — the full set is small and exhaustive:

  | Requirement                                                                                         | Why                                                                |
  | --------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------ |
  | All argument values must be compile-time known (literals, `constant`s, or other `comptime` results) | Can't evaluate what doesn't exist yet                              |
  | Return type must be `Free`                                                                          | Linear types are runtime resources                                 |
  | All parameter types must be `Free`                                                                  | Same reason                                                        |
  | Function body must not call FFI / use `pragma Unsafe_Module`                                        | Can't call `malloc` at compile time                                |
  | Called functions must themselves be comptime-eligible (transitive)                                  | If `f` calls `g` which calls `read()`, `f` isn't comptime-eligible |

  The check is **lazy** — the compiler doesn't analyze functions for comptime eligibility upfront. When someone writes `comptime f(x)`, the compiler _tries_ to evaluate it right there. If `f`'s body contains a non-const operation, the error points at the offending line inside `f`. If `x` is a runtime value, the error points at `x`. No upfront annotation burden. This is better than Rust's model where you find out at the definition site — in Kyokai you find out at the usage site when you actually need it.
  **Example diagnostic** (per D29 quality standards):
  ```
  error[KYO-E0042]: comptime argument must be a compile-time constant
    --> src/Escaper.kyo:14:32
     |
  14 | constant TABLE := comptime makeTable(userInput);
     |                                      ^^^^^^^^^
     |                                      `userInput` is a runtime variable
     |
     = note: all arguments to a `comptime` call must be literals, constants,
             or other `comptime` expressions
     = help: if you need this value at runtime, remove `comptime`
  ```
  **[STAGE: DECIDED_CORE_SEMANTICS | D18 → const expressions + `comptime` call-site keyword]**
- `**comptime` evaluation is deterministic, host-independent, and governed only by explicit compile-time inputs** — Kyokai does not allow compile-time execution to smuggle hidden host state into the language or the build result.
**Rules**:
  1. For a fixed source program, selected target triple, language edition, compiler version, and explicit build options, a `comptime` expression has exactly one language result or one compile-time error.
  2. `comptime` evaluation may depend only on explicit compile-time inputs such as literals, `constant` values, other `comptime` results, `target`, and other compile-time built-ins explicitly defined by the language.
  3. `comptime` evaluation may not observe or depend on filesystem contents, environment variables, wall-clock time, timezone, locale, randomness, network state, process state, thread scheduling, FFI, or runtime capabilities.
  4. Runtime allocators and runtime resources do not exist at `comptime`. Any compiler scratch allocation used to perform evaluation is an implementation detail and must not be observable in language semantics.
  5. Integer arithmetic, checks, and floating-point results in `comptime` follow the same target-visible language rules as ordinary execution, including D75 and D76. `comptime` does not use a separate host arithmetic model.
  6. The compiler may enforce an explicit deterministic evaluation budget to reject nonterminating or excessively costly `comptime` evaluation. Exhausting that budget is a compile-time error. If the budget is configurable, the configuration is an explicit build input.
  **Why this fits Kyokai**: explicit compile-time execution remains part of the reproducible language contract instead of becoming a side channel into host state or toolchain folklore.
  **[STAGE: DECIDED_CORE_SEMANTICS | D18a → deterministic, host-independent `comptime`; only explicit compile-time inputs; explicit deterministic evaluation budget allowed]**
- **`comptime` evaluation uses one deterministic step budget per evaluation root** — Kyokai defines the cost model in language terms instead of leaving "too much compile-time work" to implementation folklore.
**Rules**:
  1. Each top-level `comptime` evaluation root has one step budget.
  2. A top-level evaluation root is any one `constant` initializer, `static_assert` condition, `when` guard, or explicit `comptime` expression currently being evaluated.
  3. The default step budget is `1_000_000` steps.
  4. The budget may be changed only through an explicit build input such as `[comptime] step_limit = N` in `kyokai.toml`.
  5. Nested `comptime` calls, transitive constant forcing, and helper-function calls do not receive fresh budgets; they consume from the current root's budget.
  6. At minimum, each function entry, each loop iteration, each branch/arm selection, and each language-defined `comptime` builtin invocation consumes one step.
  7. Exhausting the step budget is a compile-time error.
  8. The diagnostic for budget exhaustion must identify the evaluation root, the configured limit, and the fact that the limit is configurable through explicit build inputs.
  9. Wall-clock time is not part of the language budget model.
  **Why this fits Kyokai**: the limit is deterministic, host-independent, and explicit, while still giving implementations a precise way to reject nonterminating or unreasonably expensive compile-time evaluation.
  **[STAGE: DECIDED_CORE_SEMANTICS | D202 → one deterministic step budget per top-level comptime evaluation root; default `1_000_000`; configurable only through explicit build inputs]**
- **Compiler scratch memory may be used during `comptime`, but it is not a language-visible allocator and does not make runtime owning containers available at compile time** — Kyokai allows implementations to evaluate compile-time programs efficiently without smuggling the runtime allocation model into the language.
**Rules**:
  1. During one top-level `comptime` evaluation root, the implementation may use transient scratch memory to perform evaluation.
  2. That scratch memory is an implementation resource, not a language value.
  3. Safe Kyokai code cannot name, store, borrow, pass, compare, or otherwise observe the identity of that scratch memory.
  4. Exhausting comptime scratch memory is a compile-time error.
  5. All scratch memory associated with one evaluation root is discarded when that root finishes, whether evaluation succeeds or fails.
  6. A successful `comptime` result must be a self-contained `Free` value with no dependency on scratch-memory addresses, allocator identity, or runtime resources.
  7. This decision does not make runtime allocators available at `comptime`.
  8. A function that requires an ordinary allocator parameter is not made comptime-eligible merely because the implementation uses scratch memory internally.
  9. Runtime owning `Linear` containers such as `Buffer[T]`, `String`, and other allocator-backed runtime resource types remain outside ordinary `comptime` values under D18, D165, and D204.
  **Why this fits Kyokai**: the implementation gets room to evaluate compile-time code, but the language still keeps runtime allocation and compile-time evaluation as separate explicit worlds.
  **[STAGE: DECIDED_CORE_SEMANTICS | D203 → transient comptime scratch memory is allowed as an implementation resource only; it is not a language-visible allocator and does not make runtime owning containers comptime-eligible]**
- **Const generics are first-class over `Index` values, but they remain a separate explicit mechanism rather than turning all generics into Zig-style comptime programming**: value-level type parameters exist for fixed-size data and other shape-bearing APIs without replacing the ordinary generic system.
**Syntax**:
  ```kyokai
  generic [N: Index]
  record FixedBuffer is
      data: Array[Nat8, N];
      len: Index;
  build;
  ```
  **Rules**:
  1. A generic parameter may be an `Index`-typed const parameter, written in the ordinary generic header as `N: Index`.
  2. Const-generic arguments are compile-time `Index` values and follow the ordinary D18, D18a, D202, and D203 comptime model.
  3. Type equality for const-generic instantiations uses evaluated value equality of the const arguments.
  4. Const arguments participate in monomorphization identity. Distinct evaluated const values produce distinct generic instantiations unless another explicit rule says they normalize to the same value.
  5. Const generics do not replace ordinary type parameters, typeclasses, or explicit `comptime` call-site evaluation. They are a distinct value-level generic facility.
  6. D188 defines the exact admitted argument forms, equality boundary, and in-scope use sites for this facility.
  **Why this fits Kyokai**: arrays, matrices, fixed buffers, and similar APIs need value-level shape parameters, but Kyokai still benefits from keeping compile-time evaluation and the generic system as separate explicit mechanisms.
  **[STAGE: DECIDED_CORE_SEMANTICS | D159 -> full `Index` const generics with deterministic comptime-evaluable arguments, value-based type equality, and monomorphization participation]**
- **Const generic parameters have one exact admitted expression and equality model**: Kyokai does not leave const-generic arguments half-specified or host-defined.
  **Syntax**:
  ```kyokai
  generic [T: Type, Rows: Index, Cols: Index]
  record Matrix is
      data: Array[T, Rows * Cols];
  build;
  ```
  **Rules**:
  1. Every const generic parameter has type `Index`.
  2. A const generic argument must be a compile-time expression whose type is exactly `Index`.
  3. Admitted const-generic argument forms are:
     - `Index` literals
     - named `constant` values of type `Index`
     - earlier const generic parameters
     - parenthesized `Index` expressions built from admitted inputs using ordinary deterministic comptime arithmetic
     - explicit `comptime` calls whose result type is `Index`
  4. Const generic arguments are evaluated using the ordinary D18, D18a, D202, and D203 comptime rules. There is no separate host-dependent const-evaluation model.
  5. Two instantiations of the same generic declaration are the same type iff each corresponding const argument evaluates to the same canonical `Index` value.
  6. Equality is by evaluated value, not by source spelling.
  7. Failure to evaluate a const argument, step-budget exhaustion, overflow or trap under Kyokai's ordinary numeric rules, or production of a non-`Index` result is a compile-time error.
  8. Const parameters are in scope as compile-time `Index` values throughout the declaration body, including nested type expressions and contracts.
  9. Const parameters may appear in type positions such as array lengths and other const-generic arguments.
  10. Const parameters participate in monomorphization identity exactly by their evaluated values.
  **Why this fits Kyokai**: it closes the real semantic holes around shape-bearing types while keeping the facility narrow, explicit, deterministic, and auditable.
  **[STAGE: DECIDED_CORE_SEMANTICS | D188 -> exact `Index` const-generic argument forms, value-equality rule, evaluation failure behavior, and in-scope use of const parameters]**
- **`StaticString` gives source literals and `comptime` text one distinct `Free` type without collapsing it into runtime `String`** — text literal evaluation allocates nothing and compile-time text metaprogramming does not imply a hidden runtime-string heap.
**Syntax**:
  ```kyokai
  constant banner: StaticString := static "Kyokai";
  constant full: StaticString := comptime concat(static "Kyo", static "kai");

  let msg: String := full.toStringIn(&!heap) or return;
  ```
  **Rules**:
  1. `StaticString` is a distinct text type from `String`. It represents immutable UTF-8 text backed by compiler-managed or program-static read-only storage and is a `Free` type.
  2. Plain escaped `"..."` literals and raw multiline literals produce `StaticString` in every context. They do not allocate and do not contextually become owning `String`.
  3. `static "..."` is an explicit equivalent spelling for a `StaticString` literal. It does not create a second literal type.
  4. `comptime` functions may take and return `StaticString` because it is `Free`.
  5. During compile-time evaluation, `StaticString` results live in compiler-managed memory. When materialized into the compiled program, they become embedded read-only data.
  6. There is no implicit conversion between `String` and `StaticString`.
  7. Converting `StaticString` to an owned runtime `String` is explicit and allocator-taking, for example `toStringIn(alloc) -> Result[String, AllocError]`.
  8. `StaticString` supports the ordinary explicit text operations needed for metaprogramming, including `length`, `isEmpty`, `slice`, `concat`, `startsWith`, `endsWith`, `find`, and `asBytes() -> Span[Nat8, Static]`.
  9. D18 does not imply general heap-style compile-time allocation of runtime `String` values. Compile-time text metaprogramming goes through `StaticString`, not hidden runtime-string construction.
  **Why this fits Kyokai**: compile-time string work becomes powerful enough for metaprogramming, format checking, and generated tables, while the boundary between static text and owned runtime text remains explicit.
  **[STAGE: DECIDED_CORE_SEMANTICS | D120 clarified by D420/D476 -> plain escaped, raw multiline, and explicit `static "..."` literals produce non-allocating `StaticString`; owning `String` requires explicit allocator-taking conversion]**
- **Conditional compilation: three-tier model with `when` declaration guards** — Three tools for three shapes of platform-specific code. **Tier 1 (whole-file)**: When a module is inherently platform-specific (syscall wrappers, renderer backends), use separate `.kai` body files sharing the same `.kyo` interface. Build system (C01) selects which to compile. **Tier 2 (`when` declaration guards)**: When only a few functions differ by platform, use `when` guards on the declaration signature: `function pageSize(): Index when target.os == Os.Linux is ... qed;`. A false `when` guard makes the declaration semantically absent from the current build. For alternate platform definitions of the same declaration in a selected shared module, exactly one definition must be active for the current target; overlapping active matches and zero active matches are both compile-time errors. `when` guards are **declaration-level only** — never inside function bodies. Body-level platform branching should extract into a `when`-guarded helper. **Tier 3 (typeclass abstraction)**: For large platform abstractions (renderer, windowing), use typeclasses. `typeclass Renderer[R: Linear]` with platform-specific instances. This is an existing language feature — no D19 work needed.
`**target` is a language-level built-in** — `target` is a compile-time constant record with four fields: `target.os` (`Os` enum), `target.arch` (`Arch` enum), `target.abi` (`Abi` enum), and `target.endianness` (`Endian` enum). All four are compile-time constants set by the build system or derived deterministically from the selected target, and they are evaluable by D18's comptime machinery. The `os`/`arch`/`abi` fields follow the LLVM target triple model (`arch-os-abi`), while `endianness` gives the target byte order explicitly for D117. The fields are built-in enums (not strings) — this is what makes exhaustiveness checking real, same as `case` on a sum type.
`**Os`, `Arch`, `Abi`, and `Endian` define target vocabulary, not an automatic cartesian product** — the set of legal target triples and their support guarantees is fixed explicitly by D80. An enum variant existing does not by itself make every `os/arch/abi` combination valid.
**Initial enum variants** (extendable — adding variants later is backward-compatible):

  | Enum   | Variants                                                          | Covers                                   |
  | ------ | ----------------------------------------------------------------- | ---------------------------------------- |
  | `Os`   | `Linux`, `Android`, `MacOS`, `FreeBSD`, `Windows`, `Freestanding` | Hosted targets + bare metal escape hatch |
  | `Arch` | `X86_64`, `Aarch64`, `Riscv64`                                    | Primary architectures                    |
  | `Abi`  | `Gnu`, `Musl`, `Bionic`, `Msvc`, `None`                           | libc / environment families              |
  | `Endian` | `Little`, `Big`                                                 | Target byte order                        |

  `**Abi.None` is explicit, not magic absence**: `Abi.None` means "no extra ABI/environment selector beyond the target's hosted default contract or the freestanding contract." It does **not** mean "no calling convention exists" or "no ABI rules apply."
  `**when` guards compose with D18**: The `when` condition is a comptime boolean expression over `target` fields. Guards can combine fields: `when target.os == Os.Linux and target.abi == Abi.Musl`. The compiler evaluates it using the same constant-evaluation machinery that evaluates `constant PAGE_SIZE := 4096 * 2`. Near-zero implementation cost after D18 ships.
  **Feature flags are module-level only**: Feature flags defined in `kyokai.toml` control which modules are compiled (Tier 1). You cannot use `when feature.http2` on a function declaration. If a feature needs to gate a single function, that function belongs in its own conditionally-included module.
  **No `All` target variant**: A declaration without a `when` guard exists on ALL platforms by default. That IS the "all" case. `when` guards restrict a declaration to specific platforms — absence of a guard means universal. An explicit `All` value would invert this (requiring opt-in to universality), which is backwards.
  **Implementation**:
  ```kyokai
  // Tier 2: declaration-level when guards
  function pageSize(): Index when target.os == Os.Linux is
      return 4096;
  qed;

  function pageSize(): Index when target.os == Os.MacOS is
      return 16384;
  qed;

  // Combined field guards:
  function defaultLibcPath(): String when target.os == Os.Linux and target.abi == Abi.Musl is
      return "/lib/ld-musl-x86_64.so.1";
  qed;

  function defaultLibcPath(): String when target.os == Os.Linux and target.abi == Abi.Gnu is
      return "/lib64/ld-linux-x86-64.so.2";
  qed;
  ```
  **[STAGE: DECIDED_CORE_SEMANTICS | D19 → Three-tier: whole-file + `when` guards + typeclass pattern]**
- **Tier selection and `when` guarding happen at explicit semantic phases** — Kyokai separates “not part of this build” from parser implementation strategy.
**Rules**:
  1. Tier 1 module and feature selection happens before module-graph construction for the current build configuration.
  2. A declaration whose `when` guard evaluates to `false` is semantically absent from the current build: it contributes no names, no types, no obligations, and no code.
  3. The language does not require a compiler to skip parsing excluded declarations; parser recovery and tooling strategy are implementation details.
  4. For a set of alternate `when`-guarded declarations of the same declaration name and signature, at most one may be active in a build. Multiple active matches are a compile-time error.
  5. In a selected shared module, zero active declarations for such an alternate set is also a compile-time error. If an API is intentionally absent on some targets, that absence must be modeled with Tier 1 module selection rather than with maybe-missing declarations inside a selected shared module.
  **Why this fits Kyokai**: target selection becomes part of program identity, false `when` branches are truly absent, and the spec stays explicit without dictating one parser architecture.
  **[STAGE: DECIDED_CORE_SEMANTICS | D19a → Tier 1 selection before module-graph construction; false `when` is semantically absent; overlap and zero-match are errors in selected shared modules]**
- **Inline platform branching inside function bodies is not part of Kyokai** — D19's three-tier model is the whole story: whole-file selection, declaration-level `when` guards, and typeclass abstraction.
**Rules**:
  1. Kyokai does not add `comptime case target.os of ...` or any other body-level target-selection construct.
  2. If a function body needs small target-specific differences, the code must extract those differences into helper declarations and place the target split on those declarations with `when`.
  3. If the target split is broad enough that helper extraction becomes unnatural, the code should use Tier 1 whole-file separation or Tier 3 typeclass abstraction instead.
  **Why this fits Kyokai**: platform boundaries stay at declaration and module boundaries, where they remain inspectable in APIs and build structure instead of becoming statement-level conditional worlds inside one function body.
  **[STAGE: DECIDED_CORE_SEMANTICS | D123 → keep D19's declaration/module/typeclass model; no body-level inline platform branching]**
- `**Result`/`Optional` are language-level built-in types, not library types** — D15's error propagation (`let...else`, `or return`) depends on `Result` and `Optional` the same way branching depends on `Bool`. If the language's own control flow constructs operate on these types, they're already type system primitives — treating them as library types is architectural fiction. `Result[T, E]`, `Optional[T]`, `Ok`, `Err`, `Some`, `None` are built-in constructors alongside `true`, `false`, `nil`. No module, no import, no prelude entry. They simply ARE the language.
`**Ok`/`Err`/`Some`/`None` are keywords** — same as `true`, `false`, `nil`. They cannot be shadowed or used as variable names. If `None` could be a variable name, `or return Err(e)` would become ambiguous when `Err` is shadowed. The cost is four reserved identifiers. The full keyword list: `true`, `false`, `nil`, `Ok`, `Err`, `Some`, `None`.
**Why not prelude**: A prelude is a hidden import. "Nothing hidden, nothing implicit" means if you can't see the import, it shouldn't exist. Making them built-in types eliminates the import entirely — there's nothing to import because they're not in a module.
**What IS and ISN'T built-in**:

  | Item                          | Classification                                  | Treatment                      |
  | ----------------------------- | ----------------------------------------------- | ------------------------------ |
  | `Result[T, E]`, `Ok`, `Err`   | Type system primitive (D15 depends on it)       | Language-level built-in        |
  | `Optional[T]`, `Some`, `None` | Type system primitive (nullability replacement) | Language-level built-in        |
  | `target`, `Os`, `Arch`, `Abi`, `Endian` | Compile-time constants + enums (D19/D117) | Language-level built-in        |
  | `Array[T, N]`                 | Container type (stdlib)                         | Explicit import — not built-in |
  | All stdlib functions          | Library code                                    | Explicit import                |
  | All I/O types                 | Capability-gated                                | Explicit import                |
  | All collections               | Data structures                                 | Explicit import                |

  **Built-in keywords**: `true`, `false`, `nil`, `Ok`, `Err`, `Some`, `None`.
  **Precedent**: Zig's `?T` (optional) and `T!E` (error union) are language-level constructs with no module backing them.
  **[STAGE: DECIDED_CORE_SEMANTICS | D24 → `Result`/`Optional`/`target` are language-level built-ins, no prelude expansion]**
- **FFI: `foreign "C"` blocks + `pragma Unsafe_Module` + `UnsafeCapability` + exact C-ABI surface** — Three mechanisms at three levels. `foreign "C" is ... mon;` blocks group raw foreign declarations, making the boundary visible. `pragma Unsafe_Module` marks a module as containing raw foreign-boundary code; safe modules cannot call raw foreign declarations. `UnsafeCapability` is a linear capability type that must be threaded to raw foreign call sites, creating an auditable type-level chain.
**Raw-call rule**: In Kyokai source, every declaration inside a `foreign` block is called as though it had an additional leading parameter of type `&![UnsafeCapability]`. That leading argument is part of Kyokai's safety contract and audit trail, not part of the foreign ABI; lowering erases it before the actual C call.
**Wrapper rule**: Safe APIs may wrap raw foreign declarations inside an unsafe module and translate them into ordinary Kyokai results and capabilities. Code that bypasses such wrappers must accept and thread `UnsafeCapability` explicitly.
**Type mapping** (every type crossing the FFI boundary has exactly one valid mapping):

  | Kyokai type         | C type               | Notes                                                                      |
  | ------------------- | -------------------- | -------------------------------------------------------------------------- |
  | `Address[T]`        | `T`* (nullable)      | Raw pointer. Free type.                                                    |
  | `Pointer[T]`        | `T`* (non-null)      | Non-null pointer. Free type. Trap on null.                                 |
  | `Int8`–`Int64`      | `int8_t`–`int64_t`   | Exact-width signed                                                         |
  | `Nat8`–`Nat64`      | `uint8_t`–`uint64_t` | Exact-width unsigned                                                       |
  | `Float32`/`Float64` | `float`/`double`     | IEEE 754                                                                   |
  | `Unit`              | `void` (return only) |                                                                            |
  | `Bool`              | `_Bool`              | Foreign APIs using integer booleans must spell an integer type explicitly. |

  **Additional ABI and failure-boundary rules**:
  1. `foreign "C"` uses the selected target's C ABI exactly.
  2. A record type may cross the boundary as a typed aggregate only if it is declared `extern record`.
  3. `extern type Name;` declares an opaque foreign type with unknown size and layout. An `extern type` may appear only behind pointers in foreign declarations and never by value.
  4. Arrays do not decay implicitly in foreign declarations. If the foreign ABI wants a pointer, the declaration must spell `Address[T]`, `Pointer[T]`, or another explicitly specified pointer-like form.
  5. Only `FnPtr(...)` may cross the foreign boundary as a typed bare callback. `Callable`, `CallableMut`, and `CallableOnce` do not cross FFI directly.
  6. Passing or returning unions by value is illegal. Untagged C unions remain outside Kyokai's typed FFI surface unless a separate decision specifies their ABI model.
  7. C varargs are not part of the FFI surface.
  8. Non-default calling conventions are not part of the FFI surface.
  9. Imported C symbols are never implicitly mangled. Any symbol renaming requires explicit FFI syntax.
  10. `errno` is foreign runtime state, not Kyokai semantics. Safe wrappers must translate it into explicit Kyokai results.
  11. A raw foreign call carries no implied guarantee about retry-safety, EINTR handling, allocation behavior, thread safety, or other foreign conventions unless the wrapper contract states those rules explicitly.
  12. Foreign code may not unwind, `longjmp`, or otherwise skip Kyokai frames. Doing so is an unsafe-boundary contract violation.
  13. Any foreign API that can call back into Kyokai must specify callback ABI, lifetime, reentrancy, and thread/termination rules explicitly.
  **FFI ownership and sum-type boundary rules**:
  1. Raw `foreign "C"` declarations may not take or return Kyokai `Linear` values by value.
  2. The raw foreign surface is limited to FFI-admitted `Free` scalars, raw address/pointer forms, `FnPtr`, `extern record`, and pointers to `extern type`.
  3. A safe wrapper may consume a linear Kyokai value before a foreign call only by explicitly decomposing it into FFI-legal raw parts inside a `pragma Unsafe_Module`.
  4. The module's `unsafe contract` must state whether ownership is retained by Kyokai, transferred to foreign code, borrowed only for the duration of the call, or returned through a named handle/result.
  5. Foreign code is never assumed to respect Kyokai linearity. Any retained pointer, callback, ownership handoff, destructor obligation, or aliasing promise must be represented by an explicit wrapper type and covered by an unsafe contract.
  6. Kyokai unions, `Optional`, `Result`, and other sum types have no implicit C ABI and may not cross raw FFI by value.
  7. C tagged-union APIs must be modeled with explicit ABI-shaped declarations: `extern record` for containing structs, integer/enum-like tags as explicit fixed-width values, and opaque/raw payload representation only where the target C ABI actually specifies it.
  8. Safe wrappers translate C ABI records, tags, error codes, and payload contracts into Kyokai unions only after validating the tag and payload contract.
  9. There is no implementation-defined compiler-generated tag/payload layout for FFI.
  **Implementation**:
  ```kyokai
  pragma Unsafe_Module;

  module body MyPosix is
      extern type FILE;

      foreign "C" is
          function c_open(path: Address[Nat8], flags: Int32): Int32;
          function c_fopen(path: Address[Nat8], mode: Address[Nat8]): Address[FILE];
      mon;

      function openFile(cap: &![UnsafeCapability], path: Address[Nat8]): Result[Int32, IoError] is
          let fd: Int32 := c_open(cap, path, 0);
          if fd < 0 then
              return Err(IoError.fromErrno());
          fi;
          return Ok(fd);
      qed;
  seal;
  ```
  **[STAGE: DECIDED_CORE_SEMANTICS | D20/D242/D242a → `foreign` blocks + `pragma Unsafe_Module` + `UnsafeCapability` + explicit ABI, failure, ownership-transfer, and sum-type boundary rules]**
- **Unsafe modules require source-level unsafe contracts tied to actual unsafe operations** — Kyokai's audit trail is not an informal review habit or a detached `SAFETY.md`; it is structured source metadata checked against the unsafe surface the module uses.
**Syntax shape**:
  ```kyokai
  pragma Unsafe_Module;

  unsafe contract MyPosix is
      covers foreign c_open;
      assumes c_open_abi_matches_target;
      preserves no_capability_forgery;
      maps errno_to IoError;
      forbids foreign_unwind;
  audit;
  ```
**Rules**:
  1. Every `pragma Unsafe_Module` must contain at least one `unsafe contract Name is ... audit;` block.
  2. An unsafe contract block is part of the module body source. It is not an external prose file and not an optional comment convention.
  3. The contract must enumerate each unsafe facility used by the module: `foreign` declarations, unsafe intrinsics, volatile operations, raw dynamic loading, raw signal handlers, raw pointer/address conversions, trusted capability acquisition, or any future unsafe primitive.
  4. For each covered facility, the contract states the preconditions assumed, the Kyokai invariants preserved, the failure mapping exposed to safe callers, and the safe wrapper exports or trusted constructors that rely on it.
  5. The compiler rejects an unsafe module when an unsafe operation is not covered by an unsafe contract entry.
  6. The compiler rejects an unsafe contract entry that names no unsafe operation in the module, unless it is explicitly marked as a module-wide invariant entry.
  7. Unsafe contracts are machine-discoverable audit metadata. Documentation tools, package audit tools, and compiler diagnostics must be able to list unsafe contracts and the operations they cover.
  8. An unsafe contract is not a formal proof and does not weaken D73. The unsafe operation's semantics remain the individually specified language/toolchain contract for that operation.
  9. Safe wrappers exported by an unsafe module must mention the unsafe contract entries they rely on, either directly in the wrapper's contract metadata or through a documented module-wide invariant entry.
**Why this fits Kyokai**: Austral already gates unsafe at module boundaries, and Kyokai already threads `UnsafeCapability`; this adds the missing auditable source link between each low-level escape hatch and the invariant it claims to preserve.
  **[STAGE: DECIDED_CORE_SEMANTICS | D245 → source-level `unsafe contract ... audit;` blocks required for `Unsafe_Module`; compiler checks coverage of unsafe operations]**
- **`result` is a contextual keyword scoped only to `ensure` clauses** — Kyokai keeps contract syntax readable without globally reserving one of the most common local variable names in ordinary code.
**Rules**:
  1. `result` has special meaning only while parsing and type-checking an `ensure` clause.
  2. Outside `ensure` clauses, `result` is an ordinary identifier and may be used anywhere an identifier is otherwise legal.
  3. The lexer does not need a globally reserved `result` token. Parser context is what gives `result` its contract meaning.
  4. This decision governs only name reservation and parsing. The ownership and observation semantics of `result` inside `ensure` remain governed by D53 and any later clarification decisions that mention `ensure result`.
  **Why this fits Kyokai**: `ensure result > 0` stays readable, while ordinary code keeps `let result := ...;` and similar names with zero ceremony.
  **[STAGE: DECIDED_CORE_SEMANTICS | D125 → `result` is contextual inside `ensure`; unreserved elsewhere]**
- **`foreign` blocks close with `mon;`** — the FFI boundary is a gate/portal, not a proof body. `mon` makes the raw boundary visually distinct while still keeping the terminator set small and memorable.
**Rules**:
  1. The only closing form for a foreign declaration block is `mon;`: `foreign "C" is ... mon;`.
  2. `mon` is reserved as a foreign-block terminator and is not reused to close any other construct.
  3. Grammar, formatting, examples, and tooling must treat `mon;` as the canonical foreign-block terminator.
  4. D9's semantic boundary terminator family therefore includes `qed;`, `build;`, `spec;`, `drop;`, `seal;`, `mon;`, `pick;`, `join;`, and `audit;`.
  **Why this fits Kyokai**: `mon` names the FFI boundary directly instead of overloading `qed` for a block that is about crossing a gateway, not finishing a proof body.
  **[STAGE: DECIDED_CORE_SEMANTICS | D127 → `foreign "C"` blocks close with `mon;`]**
- **Generic linear cleanup uses an explicit `Destroyable` typeclass; Kyokai never invents structural destruction for user-defined types** — generic code may destroy a `Linear` value only when the type explicitly supplies the cleanup behavior.
**Core typeclass**:
  ```kyokai
  typeclass Destroyable(T: Linear) is
      method destroy(self: T): Unit;
  spec;
  ```
  **Rules**:
  1. `Destroyable` lives in `Kyokai.Core` as a standard typeclass, not as a language primitive.
  2. `destroy(self: T)` is an ordinary consuming method. Its body may perform any explicit teardown required by the type before the value is considered fully consumed.
  3. The compiler does not auto-derive `Destroyable` instances for user-defined types and does not synthesize recursive field-by-field destruction as fallback behavior.
  4. Generic code that may need to consume stored, buffered, or deferred `T` values must require `T: Destroyable`. This includes buffered channels, generic containers, and consuming iterators.
  5. Types may still expose richer domain-specific consuming operations such as `close`, `flushAndClose`, `commit`, or `cancel`; `Destroyable.destroy` is the generic cleanup surface, not a ban on more precise APIs.
  6. Calling `destroy` is always explicit source code. Kyokai never inserts implicit `destroy` calls at scope exit, on ordinary linearity failure, or as hidden runtime cleanup.
  7. If a language feature introduces a generated type with a specified destroy operation, that generation must be part of that feature's explicit contract; it does not create a general auto-derivation rule for arbitrary user-defined types.
  **Why this fits Kyokai**: channels, containers, and iterators get a real generic cleanup contract without reintroducing the hidden destructor behavior Kyokai is explicitly rejecting.
  **[STAGE: DECIDED_CORE_SEMANTICS | D124 → explicit `Destroyable` typeclass in `Kyokai.Core`; no auto-derivation or implicit destruction]**
- **Raw dynamic library loading exists only as an explicit unsafe boundary facility** — Kyokai does not pretend `dlopen`/`dlsym` become safe merely by wrapping them in nicer names. Loading foreign code is OS authority, and typing a looked-up symbol is an unsafe claim about ABI reality.
**Rules**:
  1. Raw dynamic loading is available only in `pragma Unsafe_Module` code.
  2. Opening a dynamic library requires an explicit `DynamicLoadCapability` acquired from `RootCapability`.
  3. `DynLibrary` is a `Linear` handle. Opening returns `Result[DynLibrary, DynLoadError]`.
  4. Targets that do not support dynamic loading must reject acquisition of `DynamicLoadCapability` or return an explicit unsupported-target failure when opening is attempted. Kyokai does not invent fake dynamic-loading support on freestanding targets.
  5. Raw symbol lookup returns a raw symbol handle, not a typed callable/function value.
  6. Converting a raw symbol handle into a typed function pointer or typed data address is an unsafe operation that requires `UnsafeCapability`; the programmer is asserting that the requested type, calling convention, and ownership contract match reality.
  7. Any symbol-derived typed view is valid only while the originating `DynLibrary` remains loaded. Safe code must not obtain such typed views from the raw API.
  8. Closing a library consumes its `DynLibrary` handle. After close, all symbol handles and any typed views derived from them are invalid by contract.
  9. Loader-side foreign constructors, foreign destructors, and other loader-managed side effects are part of the foreign trust boundary, not safe Kyokai semantics.
  **Why this fits Kyokai**: the language exposes the OS facility honestly for runtimes, kernels, and advanced FFI users, but it refuses to blur "I found a symbol by name" into a safe type-checked operation.
  **[STAGE: DECIDED_CORE_SEMANTICS | D113a → raw dynamic library loading is an unsafe capability-gated boundary with linear library handles and unsafe typed symbol casts]**
- **Safe runtime extensibility uses verified Kyokai plugin contracts, not safe `dlsym`** — Kyokai's safe plugin story is a separate facility from raw dynamic loading. A safe plugin is a Kyokai-defined contract artifact whose compatibility, authority, and lifetime rules are checked explicitly at load time.
**Rules**:
  1. Safe plugin loading requires `DynamicLoadCapability`; loading code at runtime remains an explicit authority.
  2. A safe plugin artifact must carry a machine-readable contract descriptor that records at least: target contract, language edition, `.koi` format version, plugin ABI version, contract/interface hash, declared exported entry surface, and declared capability requirements.
  3. Loading succeeds only on exact compatibility with the host's expected plugin contract. There is no "close enough" ABI matching and no type-erased fallback.
  4. The safe plugin surface is closed and monomorphic. It does not use trait objects, existential values, or runtime type dictionaries forbidden by D82.
  5. `LoadedPlugin[C]` is a `Linear` handle parameterized by the expected contract `C`.
  6. Safe use of a plugin happens through a typed entry surface borrowed from `LoadedPlugin[C]`; the host does not obtain arbitrary raw symbol access from the safe API.
  7. Any plugin-defined value whose validity depends on the plugin remaining loaded must be represented as a plugin-tied type that cannot outlive the relevant `LoadedPlugin[...]` borrow/handle relation.
  8. Safe plugin loading grants no ambient authority. Any filesystem, process, network, TLS, terminal, or other effectful capability a plugin may use must cross the contract explicitly as a Kyokai capability parameter or capability-bearing object.
  9. Safe plugins do not rely on hidden module constructors. Initialization and shutdown are explicit contract entrypoints invoked by the loader as part of load/unload.
  10. Unloading consumes the `LoadedPlugin[...]` handle and is illegal while plugin-tied values or entry borrows derived from it are still live.
  **Why this fits Kyokai**: Kyokai gets a real safe plugin model, but the safety comes from explicit contract verification, explicit capability flow, and explicit lifetime ties rather than from pretending arbitrary foreign shared libraries are type-safe.
  **[DECIDED: D113b → safe plugins are verified Kyokai contract artifacts with exact compatibility checks, explicit init/shutdown, explicit capability flow, and linear loaded-plugin handles]**
- **Function pointers + standardized `Callable` typeclasses form the callback substrate** — `FnPtr(A): R` is the bare callback form for C interop and dispatch tables, while the `Callable` family is the shared substrate for stateful callbacks, whether written manually or through D118's explicit-capture closure literals.
**Standard Callable hierarchy** (maps to Kyokai's existing borrow model):

  | Typeclass            | Self parameter      | Captures              | Call count | Rust analogue |
  | -------------------- | ------------------- | --------------------- | ---------- | ------------- |
  | `Callable[A, R]`     | `&[Self]` (borrow)  | `Free`, read-only     | Many       | `Fn`          |
  | `CallableMut[A, R]`  | `&![Self]` (mutref) | `Free`, mutable       | Many       | `FnMut`       |
  | `CallableOnce[A, R]` | `Self` (consumed)   | `Linear` OK, one-shot | Once       | `FnOnce`      |

  **Fixed arity family**:
  1. Arity-1 callbacks use `Callable[A, R]`, `CallableMut[A, R]`, and `CallableOnce[A, R]`.
  2. Arity-2 through arity-4 callbacks use the matching `Callable2`/`Callable3`/`Callable4` family, with corresponding `CallableMut*` and `CallableOnce*` variants.
  3. Code that truly needs more than four callback parameters must use an explicit named record payload with the arity-1 family.
  **No implicit capture and no hidden closure machinery.** Capture sets remain a programmer choice, not a tautology, so they stay visible in source. D118 adds explicit-capture closure literals, but those literals still lower to this same `Callable` substrate rather than introducing implicit environment analysis or hidden heap semantics.
  **Why `Callable` typeclasses instead of per-callback typeclasses**: Parallel to D23 — `Equality` and `TotalOrder` exist as standard typeclasses rather than opening general operator overloading. `Callable`/`CallableOnce` exist as standard typeclasses rather than requiring a new typeclass per callback shape.
  **Implementation**:
  ```kyokai
  // Bare function pointer (Free, no captures):
  let cmp: FnPtr(&[Int32], &[Int32]): Int32 := &compareAscending;
  sort(buffer, cmp);

  // Stateful one-shot callback via CallableOnce:
  record ThresholdFilter is
      threshold: Int32;
  build

  instance CallableOnce[Int32, Bool] for ThresholdFilter is
      method callOnce(self: ThresholdFilter, arg: Int32): Bool is
          return arg > self.threshold;
      qed;
  qed;

  let filter: ThresholdFilter := ThresholdFilter { threshold: 42 };
  processItems(buffer, filter);  // filter consumed, linear enforced

  // Mutable stateful callback via CallableMut:
  record Counter is
      count: Int32;
  build

  instance CallableMut[Unit, Int32] for Counter is
      method callMut(self: &![Counter], arg: Unit): Int32 is
          self.count := self.count + 1;
          return self.count;
      qed;
  qed;

  // Two-argument callback via Callable2:
  instance Callable2[Int32, Int32, Bool] for LessThan is
      method call(self: &[LessThan], a: Int32, b: Int32): Bool is
          return a < b;
      qed;
  qed;
  ```
  **[STAGE: DECIDED_CORE_SEMANTICS | D21 → FnPtr + fixed callable-family substrate; explicit-capture closure literals are added separately in D118]**
- **Multi-argument callbacks use a fixed arity callable family, not anonymous inline callback-record syntax** — Kyokai extends the existing callback substrate by a small closed family instead of adding tuple packs, inline record type expressions, or compiler-invented anonymous product types.
**Rules**:
  1. The standard library provides `Callable[A, R]`, `Callable2[A, B, R]`, `Callable3[A, B, C, R]`, and `Callable4[A, B, C, D, R]`.
  2. The same arity family exists for mutable and one-shot callbacks: `CallableMut2`, `CallableMut3`, `CallableMut4`, and `CallableOnce2`, `CallableOnce3`, `CallableOnce4`.
  3. `FnPtr` follows the same arity model for bare function pointers.
  4. D118 closure literals lower to the family member matching the closure's parameter arity and D197-selected ownership mode.
  5. Kyokai does not add anonymous inline record syntax or tuple-like packs in callback type positions.
  6. Code that needs callback arity greater than four must package its arguments in an explicit named record and use the arity-1 callable family.
  **Why this fits Kyokai**: the callback surface grows only by a small closed family that matches the already-decided `FnPtr` model, while avoiding anonymous structural product syntax that would open a much larger design surface.
  **[STAGE: DECIDED_CORE_SEMANTICS | D126 → fixed `Callable`/`CallableMut`/`CallableOnce` arity family through 4 parameters; no inline callback-record syntax]**
- **Explicit-capture closure literals are built-in sugar over the `Callable` substrate** — Kyokai allows closure literals only when the capture set is written explicitly; the language does not infer or hide environment capture.
**Syntax**:
  ```kyokai
  let pred := fn [limit, &cfg] (x: Int32): Bool is
      return x < limit and cfg.isValid();
  qed;

  let pred2 := fn [limit, &cfg] (x: Int32): Bool => x < limit and cfg.isValid();
  ```
  **Rules**:
  1. A closure literal is introduced with `fn [captures] (params): Ret is ... qed;` or the one-expression shorthand `fn [captures] (params): Ret => expr`.
  2. The capture list is mandatory. `[]` is written explicitly for a zero-capture closure literal.
  3. Each capture entry states its mode explicitly: `name` for by-value capture, `&name` for immutable borrow capture, and `&!name` for mutable borrow capture.
  4. Kyokai performs no implicit environment capture and adds no hidden capture entries.
  5. Closure literals lower to the same D21/D126 callable-family substrate rather than introducing a separate runtime closure object model.
  6. Closure literals do not imply hidden heap allocation; any storage strategy must preserve the same explicit ownership and borrow semantics as the equivalent manual `Callable` implementation.
  7. The precise rule that determines which member of the `Callable` family a given closure literal implements is specified separately by D197.
  **Why this fits Kyokai**: callback ceremony drops sharply, but capture sets, borrow modes, and allocation visibility stay explicit instead of becoming compiler folklore.
  **[STAGE: DECIDED_CORE_SEMANTICS | D118 → explicit-capture closure literals in block and one-expression forms; no implicit capture; lowers to the D21 `Callable` substrate]**
- **Closure classification is determined by the strongest environment access the closure actually requires, with owned linear captures forcing one-shot semantics** — Kyokai keeps capture lists explicit, but it still classifies each closure into exactly one member of the D21/D126 callable family using closed rules instead of folklore.
**Rules**:
  1. Every closure literal lowers to a compiler-generated environment type containing exactly the listed captures plus an implementation of exactly one member of the callable family whose arity matches the closure parameter list.
  2. If any by-value capture has `Linear` type, the closure environment is `Linear` and the closure implements the appropriate-arity `CallableOnce` family member only.
  3. Otherwise, if the capture list contains any `&!name` entry, the closure implements the appropriate-arity `CallableMut` family member.
  4. Otherwise, if the body performs assignment to a by-value captured binding or takes/passes a mutable borrow derived from a by-value captured binding, the closure implements the appropriate-arity `CallableMut` family member.
  5. Otherwise, the closure implements the appropriate-arity `Callable` family member.
  6. A closure type is `Linear` iff it owns at least one by-value `Linear` capture. Otherwise the closure type is `Free`.
  7. Borrow captures `&name` and `&!name` are ordinary borrows tied to the lifetime of the closure value. The closure may not outlive those borrow regions.
  8. A borrow derived from a captured borrow may not escape beyond the ordinary lifetime of that captured borrow.
  9. A zero-capture closure is `Free` and implements `Callable`.
  10. The `CallableOnce` case dominates the other cases: if rule 2 applies, the closure does not also implement a `CallableMut` or `Callable` family member.
  **Why this fits Kyokai**: the capture list still carries the important source-level ownership information, but the callable-family choice now reflects the real environment access the closure body needs instead of a too-shallow syntactic guess.
  **[STAGE: DECIDED_CORE_SEMANTICS | D197 → closure lowers to one matching-arity D21/D126 callable family member; owned linear captures force `CallableOnce`; otherwise mutable environment use yields `CallableMut`; remaining cases use `Callable`]**
- **Named stackless pull generators are a first-class iterator declaration, not a general coroutine system** — Kyokai adds `generator` declarations with `yield`, but it keeps the feature in the D32 iteration world rather than turning it into hidden async control flow or opaque return types.
**Syntax**:
  ```kyokai
  generator Countdown(start: Int32): Int32 is
      var i: Int32 := start;
      while i > 0 do
          yield i;
          i := i - 1;
      od;
  qed;

  for n in makeCountdown(3) do
      debug n;
  od;
  ```
  **Rules**:
  1. `generator Name(params): Item is ... qed;` declares a nominal generator type `Name`.
  2. The declaration also defines a constructor function `makeName(params): Name`.
  3. `Name` implements D32's `Iterator` typeclass with associated `Item = Item`.
  4. `yield expr;` is a statement and is legal only inside a generator body. `expr` must have the generator's declared item type.
  5. Executing `yield expr;` suspends the generator and causes the current `next(&!gen)` call to return `Some(expr)`.
  6. Reaching the end of the generator body or executing bare `return;` completes the generator. Once completed, all later `next` calls return `None`.
  7. Generator iterators are fused by default.
  8. Generator values are `Linear` and single-consumer.
  9. `yield` is suspension, not scope exit. It does not run `defer` or `errdefer` for still-live suspended scopes.
  10. Every generator type gets a compiler-generated consuming `destroy(self: Name): Unit` operation for abandoning an incomplete generator value explicitly.
  11. Destroying an incomplete generator runs all currently pending ordinary `defer` actions for its suspended scopes in reverse registration order and does not run `errdefer`, because generator destruction is not an error exit.
  12. `yield` is illegal inside `defer` and `errdefer` bodies.
  13. A local borrow created inside the generator body may not remain live across a `yield`.
  14. A borrow stored across suspension must come from a parameter or previously stored generator-state field whose region outlives the generator value under the ordinary borrow rules; otherwise the program is ill-typed.
  15. Generators do not create concurrency, stackful coroutines, symmetric transfer, or opaque return types. They interact with callers only through the ordinary D32 `Iterator.next` protocol.
  **Why this fits Kyokai**: infinite streams, paginated traversal, and tree walking become ergonomic, but the feature remains explicit, single-consumer, iterator-shaped, and fully tied into the language's existing borrow and cleanup model.
  **[STAGE: DECIDED_CORE_SEMANTICS | D198 → named stackless `generator` declarations with `yield`; nominal linear iterator types; explicit destroy semantics for suspended state]**
- **Explicit package/workspace model with deterministic module resolution** — Kyokai uses a three-level project model: **module** (the thing imported in source), **package** (the unit defined by a `kyokai.toml` and the boundary for dependencies, artifacts, and D17 `internal` visibility), and **workspace** (an explicit manifest-defined collection of packages built together). Kyokai intentionally collapses Rust's crate/package split into one concept: **package**. There is no inferred project structure. The nearest ancestor containing `kyokai.toml` is the package root. A workspace exists only when a manifest explicitly declares `[workspace]`; a directory tree with several child packages is NOT automatically a workspace.
**Exact workspace syntax**: the workspace manifest uses an explicit member list, e.g.
  ```toml
  [workspace]
  members = [
      "packages/core",
      "packages/net",
      "packages/cli",
  ]
  ```
  **Workspace root may NOT also be a package**: a manifest is either a workspace manifest or a package manifest, never both. This avoids nearest-manifest ambiguity, root-level `src/` confusion, and lockfile confusion.
  **Intra-workspace dependencies are by package name, not by path**: paths belong in `[workspace].members`; dependencies should name the package identity:
  ```toml
  [package]
  name = "net"
  version = "0.1.0"

  [layout]
  module_root = "src"

  [dependencies]
  core = { workspace = "core" }
  pcre = { git = "https://github.com/kyokai/pcre", rev = "a1b2c3d4..." }
  ```
  Package names must therefore be unique within a workspace.
  **Package manifests declare the module root explicitly**: a package manifest must contain `[layout] module_root = "<relative-dir>"`. There is no implicit default module root. The path is interpreted relative to the package root, must be non-empty, must not be absolute, and must not escape the package root via `..`.
  **Lockfile rule**: a standalone package has `package-root/kyokai.lock`. A workspace has exactly one `workspace-root/kyokai.lock` covering all member packages. Member packages inside a workspace do not own separate lockfiles.
  **Module mapping rule**: `.` is always a directory separator in module names, with no exceptions. If `[layout] module_root = "src"`, then `import Foo` resolves to `src/Foo.kyo` + `src/Foo.kai`, and `import Foo.Bar` resolves to `src/Foo/Bar.kyo` + `src/Foo/Bar.kai`. There is no `mod.kyo`, no alternate dotted filename form like `src/Foo.Bar.kyo`, and no include-path search. One import path, one file pair.
  **Import scope rule**: imports are file-scope declarations only. They may appear at the top of a `.kyo` or `.kai` file, and selective symbol imports plus nicknames are allowed, but there are no function-local, block-local, or expression-local imports.
  **Prefix modules may coexist**: `Foo` and `Foo.Bar` are distinct logical modules and may both exist in the same package. That is not ambiguous because directory segments are path segments, not implicit module nesting. What is forbidden is multiple filesystem spellings resolving to the SAME logical module.
  **Why this fits Kyokai**: boundaries are declared rather than inferred, import resolution is purely mechanical, package identity is the correct unit for unsafe auditing and visibility, and tooling can answer "what am I building?" from the manifest without heuristics.
  **Why not infer workspaces from folder layout**: that would make project structure an ambient convention rather than part of the contract. If the workspace exists, it must be written down.
  **Why not make `internal` workspace-visible**: visibility should track the package boundary, not the accidental fact that two packages happen to live in the same repository.
  **[STAGE: DECIDED_CORE_SEMANTICS | D78 → explicit package/workspace model + exact manifest-declared module-root file mapping]**
- **`kyokai.toml` uses a fixed TOML schema with explicit workspace inheritance, target conditions, features, and generation capability declarations** — manifest syntax is not whatever a parser accepts today. The toolchain reads `kyokai.toml` as TOML 1.0.0 and rejects unknown semantic tables or ambiguous inheritance.
**Rules**:
  1. `kyokai.toml` is parsed as TOML 1.0.0. Future TOML changes are not automatically accepted unless Kyokai updates this rule.
  2. Workspace dependency inheritance is explicit: a workspace root may define shared dependency entries, and a member package may opt into one by name. The member manifest must still show that it is using the inherited dependency.
  3. A workspace-inherited dependency entry cannot silently override a member's direct dependency. If both exist for the same dependency name, the manifest must choose one spelling or compilation fails.
  4. Target-conditioned dependencies live in explicit target tables keyed by legal D80 target triples or by approved target predicates. Unknown triples, unsupported predicate keys, and overlapping target conditions that select incompatible dependencies are errors.
  5. Features are named optional dependency/configuration sets. A feature may enable optional dependencies, other features, or documented compile-time configuration values; it may not execute code.
  6. Feature names use the package-name character discipline unless a later D-point narrows them further. Feature resolution is deterministic, recorded in `kyokai.lock`, and included in reproducible build identity.
  7. Default features, if present, are named explicitly by the manifest. A dependency may request `default_features = false` only through documented manifest syntax, and the lockfile records the final selected feature set.
  8. `[generate]` steps are sandboxed records with declared command, inputs, outputs, environment allowlist, working directory, target/profile conditions, and capability requirements.
  9. Generation steps cannot receive ambient filesystem, process, network, or root authority. Any capability-like permission for generation is declared in the manifest and surfaced by `doctor`, `generate`, `build`, and `publish --dry-run`.
  10. Generated files must be declared as source-tree outputs or generated-output-tree artifacts. Hidden source injection into the compiler is illegal.
  **Why this fits Kyokai**: large real projects need feature flags, target-specific dependencies, and build generation, but Kyokai should make those knobs visible in one manifest instead of hiding behavior behind executable build scripts.
  **[STAGE: DECIDED_CORE_SEMANTICS | D276 -> TOML 1.0.0 manifest schema; explicit workspace inheritance; target-conditioned dependencies; optional-dependency features; sandboxed `[generate]`]**
- **Import collisions are errors at the import site, and selective imported names use explicit `as` renaming when disambiguation is needed** — Kyokai does not let import order silently choose winners, and D254's receiver-module UFCS fallback never repairs an ambiguous file scope.
**Rules**:
  1. A selective import may rename an introduced unqualified name with `as`, for example `import PkgA.Util (Hash as UtilHash);`.
  2. Collision checking happens after applying any explicit import renames.
  3. If two import declarations in the same file would introduce the same unqualified name after renaming, the file is ill-formed.
  4. Qualified module imports do not by themselves create unqualified-name collisions merely because the referenced modules happen to export the same member names.
  5. Wildcard imports remain illegal.
  6. Built-in language names such as `Ok`, `Err`, `Some`, `None`, `true`, and `false` may not be introduced or shadowed by imports.
  **Why this fits Kyokai**: file scope stays mechanically understandable, import order never changes meaning, and the programmer has one explicit escape hatch when two useful names would otherwise collide.
  **[STAGE: DECIDED_CORE_SEMANTICS | D214 → import collisions are import-site errors; selective imports use explicit `as` renaming; built-in names cannot be shadowed by imports]**
- **Import syntax has exactly three file-scope forms: qualified module import, qualified module alias, and selective unqualified member import** — Kyokai keeps imports explicit and readable without adding `open`-style namespace flooding.
**Syntax**:
  ```kyokai
  import Foo.Bar;
  import Foo.Bar as Bar;
  import Foo.Bar (baz, qux as localQux);
  ```
  **Rules**:
  1. `import Foo.Bar;` introduces the module name `Foo.Bar` for qualified access only.
  2. `import Foo.Bar as Bar;` introduces the same module for qualified access under the alias `Bar`.
  3. `import Foo.Bar (baz, qux as localQux);` introduces only the listed exported names unqualified into file scope, applying any per-name `as` rename before D214 collision checking.
  4. Selective imports name direct exports of the referenced module only. They do not recurse through other modules or create transitive namespace injection beyond the module's ordinary export surface.
  5. If code wants both qualified module access and selective unqualified names, it must write both import declarations explicitly.
  6. Wildcard imports are illegal.
  7. `open`, `using namespace`, and any other form that implicitly brings an entire module's exports into unqualified scope are illegal.
  8. Imports remain file-scope declarations only under D78.
  **Why this fits Kyokai**: module access stays legible at the import site, selective unqualified names remain explicit, and the language never needs a second "where did this name come from?" lookup model.
  **[STAGE: DECIDED_CORE_SEMANTICS | D179 → exact three-form import surface: qualified import, module alias, selective import with per-name `as`; no wildcard or `open`]**
- **UFCS receiver-module extension lookup is a narrow fallback, not C++ ADL or global method search** — Kyokai solves common names like `length` without making the entire dependency graph part of method resolution.
**Rules**:
  1. UFCS lookup has two phases: ordinary imported-name lookup first, then receiver-module extension lookup only if ordinary lookup finds no candidate.
  2. Ordinary imported-name lookup follows D179 and D214 exactly. A unique imported function wins; an import collision is an error and is not repaired by receiver lookup.
  3. Receiver-module extension lookup searches only the defining module of the receiver's nominal type, or the module that explicitly owns the relevant built-in/special form's receiver-callable surface.
  4. Receiver-module lookup considers only exported functions explicitly marked as receiver-callable for that receiver type. It does not consider every function whose first parameter happens to match.
  5. Receiver-module lookup is not global, not dependency-wide, not transitive through re-exports, not typeclass dispatch, and not based on arbitrary argument-dependent lookup.
  6. If receiver-module lookup finds zero candidates or more than one candidate after ordinary type checking, compilation fails.
  7. Qualified function calls and explicit import aliases remain the disambiguation mechanisms.
  **Why this fits Kyokai**: the programmer gets ergonomic `buf.length()` and `text.isEmpty()` without wildcard imports or alias spam, while the lookup boundary remains small enough for tooling and audits to explain.
  **[STAGE: DECIDED_CORE_SEMANTICS | D254 → type-directed UFCS only as explicit receiver-module extension lookup after ordinary lookup fails]**
- **Dependency model: workspace package references + git commits as identity, tags as checked labels** — Kyokai has exactly two dependency sources: another package in the same workspace, or an external Git repository. Workspace dependencies are named by package identity, not by filesystem path. External Git dependencies are pinned by commit hash. A Git tag may be included as a human-readable release label, but it is never the source of truth — `rev` is the source of truth. Branches are forbidden in manifests because they are moving targets and violate reproducibility.
**The allowed manifest shapes are**:
  ```toml
  [dependencies]
  core = { workspace = "core" }
  pcre = { git = "https://github.com/kyokai/pcre", rev = "a1b2c3d4..." }
  pcre = { git = "https://github.com/kyokai/pcre", tag = "v1.2.3", rev = "a1b2c3d4..." }
  ```
  **Rules**:
  1. Exactly one of `workspace` or `git` must appear.
  2. If `git` appears, `rev` is mandatory.
  3. `tag` is optional metadata. If present, the package manager must verify that the tag resolves to the declared `rev` when the dependency is added or updated.
  4. `branch` is illegal in `kyokai.toml`.
  5. Workspace dependency names refer to package names, not paths. Package names must therefore be unique within a workspace.
  6. The lockfile records the fully resolved dependency graph, including exact Git revisions.
  **Why not tag-only dependencies**: tags are human-friendly but not immutable enough to serve as the identity of a dependency.
  **Why not branches**: a branch name is a moving pointer; identical manifests could resolve to different code at different times.
  **Why workspace deps by name instead of path**: package identity should not depend on repository layout. Paths belong in `[workspace].members`; dependencies should name the package being depended on.
  **Why this fits Kyokai**: it is explicit, reproducible, auditable, and easy for tooling to validate.
  **[STAGE: DECIDED_CORE_SEMANTICS | D51 → workspace deps by name + git `rev` required + optional checked `tag`]**
- **Package yanks are append-only index metadata: existing lockfiles keep building, new resolution avoids withdrawn revisions** — yanking is withdrawal from new selection, not deletion or source mutation.
**Rules**:
  1. The official package index is append-only. A yank is an append-only metadata record marking a package version/revision as withdrawn for new dependency resolution.
  2. Yanking does not delete source, mutate source, rewrite tags, change artifact hashes, or alter the meaning of an existing lockfile.
  3. New dependency resolution must not select a yanked version unless the user explicitly opts into that exact yanked revision.
  4. Existing `kyokai.lock` files remain reproducible and may continue to resolve yanked entries.
  5. Yank metadata records package identity, version/revision identity, timestamp, actor identity according to the index trust model, and an optional reason or security advisory link.
  6. Tooling must surface yanked status during dependency resolution, update, audit, and lockfile reporting.
  7. If a yanked revision is also compromised in a way that should block even locked builds, that is a separate security-policy mechanism and must not be smuggled into yank semantics.
  **Why this fits Kyokai**: package resolution stays reproducible and append-only while giving the ecosystem a visible way to stop new projects from selecting known-bad releases.
  **[STAGE: DECIDED_CORE_SEMANTICS | D244 → append-only yanks ignored by new resolution but honored by existing lockfiles]**
- **The official package index is Git-hosted/static metadata over Git-hosted source, not crates.io-style central source hosting** — Kyokai keeps the D51 dependency identity model and adds the missing trust/discovery layer without making the project operate a full registry service at bootstrap.
**Rules**:
  1. Package source remains hosted in ordinary Git repositories. The official index records metadata about those repositories; it does not become mandatory source storage.
  2. A dependency resolved through an index still records source URL, exact Git `rev`, content hash, package identity, selected features, and lockfile identity. The index never replaces `rev` as the source of truth.
  3. The official index is representable as a normal Git repository or static file tree. Its records are append-only where history matters and are suitable for mirroring by static hosting.
  4. Canonical public package identity uses scoped names such as `@owner/name`. The index records owner identity, owner teams where supported, repository URL, declared versions/tags, exact revisions, content hashes, licenses, docs links, yanks, advisories, takedowns, and maintainer-transfer records.
  5. Bootstrap publishing may be implemented as reviewed index pull requests or signed metadata commits tied to existing forge identity. Token/API publishing, MFA, and automated owner management are allowed later, but they do not change package identity or dependency resolution semantics.
  6. Private indexes are additional configured Git/static index URLs with the same record schema. Private packages do not require the official index.
  7. Authenticated mirrors and source replacement must be explicit configuration. A mirror may provide index metadata or immutable source archives only when the lockfile identity and content hash match.
  8. Anti-squatting, legal takedown, name-dispute, owner-transfer, and security records are index metadata. They do not rewrite existing lockfile meaning.
  **Why this fits Kyokai**: a crates.io-shaped service would force Kyokai to operate auth, databases, artifact storage, CDN, moderation, takedowns, backups, and uptime before the language has an ecosystem. Static Git metadata gives Kyokai scoped identity and governance while preserving the already-decided Git-revision dependency model.
  **[STAGE: DECIDED_CORE_SEMANTICS | D272 -> Git-hosted/static package index; scoped names; signed append-only metadata; private indexes; source remains ordinary Git]**
- **Immutable package proxies are optional cache-aside infrastructure, not the package source of truth** — Kyokai may grow Go-style durability and performance infrastructure without turning the index into a central package host.
**Rules**:
  1. The toolchain may fetch immutable source archives from configured proxies or mirrors by content hash.
  2. A proxy entry is valid only when it matches the locked package identity, source URL, Git `rev`, and content hash.
  3. Proxies are cache-aside infrastructure: they improve availability and speed, but package identity remains the Git source plus exact revision and hash.
  4. A proxy is not required for bootstrap, for local development, or for private packages.
  5. If no proxy is configured or reachable, the toolchain may fetch from the declared Git source or use a valid `kyokai vendor` directory.
  6. A proxy must not silently serve different source for the same lockfile identity. Hash mismatch is a hard error.
  7. Proxy metadata, if present, is signed or hash-checked index metadata and is never trusted ahead of the lockfile.
  **Why this fits Kyokai**: production users need protection from disappearing repositories and rate limits, but v1 does not need a hosted archive empire. Content-addressed mirrors solve availability later without changing dependency meaning now.
  **[STAGE: DECIDED_CORE_SEMANTICS | D273 -> optional immutable cache/proxy by content hash; Git source identity unchanged; vendor/offline fallback remains valid]**
- **Package advisories and security holds are separate from yanks** — a yank controls ordinary new resolution; advisory and hold metadata controls security reporting and policy failure. Kyokai does not overload one word to mean withdrawal, malware response, embargo, CVE tracking, legal removal, and maintainer dispute handling.
**Rules**:
  1. The package index may contain typed advisory records for vulnerability, malware, compromised-credential, abandoned-package, legal-takedown, name-dispute, and maintainer-transfer cases.
  2. Advisory records name the package identity, affected version or revision ranges, fixed versions or fixed revisions when known, advisory kind, severity where known, timestamps, actor identity, and links to CVE, OSV, RustSec-style, or project-native advisory records where available.
  3. Embargo records may exist in restricted index metadata before public disclosure, but released public metadata must preserve append-only history once published.
  4. A security hold is stronger than a yank: it may cause `kyokai audit`, CI policy, update policy, publish validation, or an explicitly strict build policy to fail even when an existing lockfile remains reproducible.
  5. Security holds do not rewrite source, mutate lockfiles, or silently change dependency resolution. They report policy failure against the exact locked dependency graph.
  6. `kyokai audit` must report yanks, advisories, holds, affected ranges, fixed versions, and signed maintainer or project response notes when the configured index supplies them.
  7. Legal takedown and name-dispute metadata records visibility and governance state; it does not erase historical lockfile meaning or pretend the package never existed.
  8. Private indexes may define private advisory records, but those records must use the same structural fields so tooling can report them without a second security model.
  **Why this fits Kyokai**: yanks are about resolution. Security records are about trust, response, and policy. Keeping them separate lets builds remain reproducible while still letting serious projects fail CI on known-bad code.
  **[STAGE: DECIDED_CORE_SEMANTICS | D274 -> typed advisories, embargo metadata, security holds, CVE/OSV links, affected ranges, fixed revisions, and signed response notes]**
- **Package names have one canonical grammar** — Package names are stable manifest identities, not loose human labels. They appear in `[package].name`, `[dependencies]` workspace references, CLI package selection, lockfiles, and `.koi` artifacts, so the grammar must be fixed and toolable.
**Grammar**: a package name must match `^[a-z][a-z0-9-]{0,63}$`.
**Additional restrictions**:
  1. Only lowercase ASCII letters, ASCII digits, and `-` are allowed.
  2. `_`, `.`, whitespace, and uppercase letters are illegal.
  3. A name may not end in `-`.
  4. A name may not contain `--`.
  5. Names are compared byte-for-byte; there is no case folding or punctuation normalization.
  6. Names that collide with Windows reserved device names such as `con`, `prn`, `aux`, `nul`, `com1`-`com9`, and `lpt1`-`lpt9` are illegal.
  7. Package names must be unique within a workspace.
  **Why this fits Kyokai**: there is one legal spelling, one comparison rule, and no hidden normalization behavior. Tooling can validate names deterministically across platforms.
- **Official source file extensions are `.kyo` for interfaces and `.kai` for bodies** — These are the normative Kyokai source extensions. They are part of the language/toolchain contract, not just a temporary repository convention.
**Meaning**:
  1. `Foo.Bar` resolves to `Foo/Bar.kyo` for the interface and `Foo/Bar.kai` for the body under the package module root defined by D78.
  2. `.kyo` is the importable interface surface; `.kai` is the implementation body.
  3. Tooling, editors, docs, and build-system code should treat `.kyo`/`.kai` as the official Kyokai source pair.
  4. Austral's `.aui`/`.aum` extensions are not part of Kyokai.
  **Why this fits Kyokai**: the fork has its own stable identity, and D78's deterministic module mapping now has a formally settled filename contract.
  **[STAGE: DECIDED_CORE_SEMANTICS | D52 → `.kyo` interface + `.kai` body]**
- **Single intermediate visibility level: `internal` is package-visible, not workspace-visible** — Kyokai keeps the two-file interface/body model and adds exactly one new visibility level between public and private. A declaration in a `.kyo` interface with no visibility modifier is **public** and importable by dependent packages. A declaration in a `.kyo` interface prefixed with `internal` is **package-visible** and importable only by modules in the same package rooted at the nearest `kyokai.toml` (D78). A declaration that exists only in the `.kai` body is **private** and visible only inside that module body. This gives Kyokai the one missing capability Austral lacks: sharing helpers across sibling modules without turning them into public API.
`**internal` is legal only in interface files**: body-only declarations are already private, so `internal` in a `.kai` file is an error.
`**internal` is never widened by workspace membership**: two packages in the same workspace do not gain privileged access to each other. Workspace layout is a build concern, not a visibility rule.
**Types follow the same visibility split**: a type declared `internal` in the interface is visible only within the package. Whether that type is opaque or transparent is still determined by the type declaration form; `internal` changes WHO can name/use it, not whether its representation is exposed. Body-only types remain module-private.
**Typeclasses and instances follow the same rule**: an `internal typeclass` or `internal instance` exists only within the package. Instance resolution across package boundaries must ignore internal instances from dependencies.
**No re-export across a package boundary**: an internal declaration cannot be re-exported or surfaced as public API by another package-level mechanism.
**Artifacts and docs follow visibility**: `.koi` artifacts may record internal declarations for same-package checking, but generated public documentation and dependency import surfaces must exclude them by default.
**Why not Rust-style path visibility**: Kyokai has a package boundary and a module boundary. It does not need a third visibility system tied to nested module paths.
**Why not keep Austral's binary public/private split**: without `internal`, any shared helper becomes accidental public API. That is bad library hygiene and bad boundary design.
**[STAGE: DECIDED_CORE_SEMANTICS | D17 → `internal` keyword for package-level visibility]**
- `**.koi` artifacts are explicit interface contracts, not cache blobs** — Separate compilation in Kyokai is built around a real artifact contract. A `.koi` file is not "whatever the compiler happened to cache"; it is the checked interface product of a package, consumed by downstream compilation and tooling. Incremental caches may exist internally, but they are not the language/toolchain boundary.
**A `.koi` artifact records at least**: producing compiler version, language edition, `.koi` format version, target contract, package identity, the package's module set, hashes/fingerprints of interface inputs, visibility-marked declarations (`public` and `internal`), type definitions at their visible opacity level, typeclass definitions, legal instances, and any metadata required by the current generic materialization / instantiation decisions (D82a and D82b) for downstream type checking and code generation.
**Private declarations do not cross the boundary**: body-only `.kai` declarations that are not part of the package interface never appear in `.koi`.
**Visibility is preserved inside the artifact**: `internal` declarations may appear in `.koi` because same-package compilation and tooling need them, but import resolution from a different package must treat those entries as nonexistent.
**Compatibility is explicit**: a compiler may consume a `.koi` artifact only when the language edition, `.koi` format version, target contract, and any explicitly versioned generic/codegen contract all match exactly. The producing compiler version is recorded for provenance and diagnostics, but a compiler-version mismatch by itself is NOT automatically an incompatibility if the compatibility-class fields still match.
**Support is explicit too**: a compiler may reject `.koi` format versions it does not implement, even if the artifact was produced by another compiler binary from the same language edition family.
`**.koi` is a toolchain contract artifact**: `kyokai check`, separate compilation, documentation generation, and downstream package builds may depend on its format and semantics. That contract must not silently change under "cache implementation details."
**Why this fits Kyokai**: the interface boundary becomes inspectable, versioned, and auditable instead of implicit compiler state.
**[STAGE: DECIDED_CORE_SEMANTICS | D79 → `.koi` is a versioned per-package interface artifact contract]**
- **Language editions are explicit manifest-selected source-semantics modes** — an edition tells the parser, resolver, and edition-aware tools how to interpret source text. It is not a loose marketing version, and it does not weaken D79's exact `.koi` compatibility contract.
**Rules**:
  1. Every package manifest with a `[package]` table must declare exactly one edition field, written as `edition = "2026"` for the first Kyokai edition.
  2. The declared edition applies to every `.kyo` and `.kai` file in that package. A workspace may contain packages that declare different editions.
  3. An edition may change only source-language interpretation and source-facing tool behavior for code that opts into that edition. This includes grammar, reserved words, contextual keywords, name-resolution rules, desugaring rules, edition-gated default diagnostics, and other explicitly documented source-semantic choices.
  4. An edition must NOT silently reinterpret code that still declares an older edition. When a newer compiler supports an older edition, that older-edition source keeps its older-edition parsing and semantics.
  5. Moving a package to a newer edition is an explicit source rewrite step, not automatic reinterpretation. The toolchain provides `kyokai migrate --edition <edition>` for edition migration.
  6. The compiler, formatter, checker, documentation generator, and diagnostics are edition-aware. They must parse, format, analyze, and report each package according to that package's declared edition.
  7. Mixed-edition workspaces are legal as repository structure, but cross-edition compatibility is not implied. D79 still governs artifact compatibility, and D79 requires exact language-edition match for `.koi` consumption.
  8. Therefore, under the current design, a Kyokai package may not consume a `.koi` artifact from a different language edition. Any normalized cross-edition interface contract would require its own later explicit decision; it does not exist implicitly.
  9. The language edition is part of the reproducible-build identity under D83 and must be recorded in `.koi` artifacts under D79.
  **Why this fits Kyokai**: editions give the project room to evolve source syntax and defaults without ever making old code mean something new behind the programmer's back.
  **[STAGE: DECIDED_CORE_SEMANTICS | D105 → manifest-declared editions as source-semantics modes; mixed-edition workspaces allowed structurally, but `.koi` compatibility still requires exact edition match]**
- **Standard-library compatibility follows editions for source-semantics surfaces and SemVer for ordinary package-like API evolution** — D105 already owns language editions; the remaining stdlib rule is how `Kyokai.*` changes without surprising old source.
**Rules**:
  1. Language source-semantics changes are governed by D105 editions. Release cadence remains governed by D157.
  2. Standard-library APIs whose behavior is part of the language/core contract or automatically available with the toolchain may not make breaking source or semantic changes without an edition boundary or an explicitly named compatibility mode.
  3. Ordinary package-style standard-library modules may evolve by the D223 SemVer convention, with additive APIs and deprecations allowed without an edition.
  4. Removing or changing a public stdlib API that older-edition source may rely on requires either an edition-gated replacement path or an explicit compatibility shim whose behavior is documented.
  5. A `.koi` artifact records the exact language edition and stdlib/interface identity needed for downstream checking. No cross-edition compatibility is inferred.
  **Why this fits Kyokai**: editions stay the rare source-semantics boundary, while the larger standard library still gets a concrete compatibility policy instead of Python-style surprise breaks.
  **[STAGE: DECIDED_CORE_SEMANTICS | D243 → resolved by D105/D157 plus stdlib compatibility policy: edition-gated core breaks, SemVer for ordinary stdlib modules]**
- **Typeclass coherence is mandatory: one resolved program, one applicable instance** — Kyokai adopts explicit coherence and orphan rules so typeclass instance selection is deterministic, auditable, and independent of import order. In plain language: when the compiler resolves a typeclass call for a concrete type, there must be exactly one legal answer.
**Uniqueness rule**: for any fully resolved `(Typeclass, Type arguments)` pair visible at a call site, there must be exactly one applicable instance.
**Orphan rule**: an instance is legal only if the defining package owns the typeclass or owns at least one concrete head type named in the instance head. A third-party package may not implement a foreign typeclass for an entirely foreign type.
**No scoped orphan exceptions**: `internal` or private visibility does NOT relax the orphan rule. Kyokai does not permit package-scoped or module-scoped foreign-typeclass-on-foreign-type instances.
**Overlap is forbidden**: if two instances could both apply after substitution, the program is ill-formed even if one "looks more specific." Kyokai does not have implicit specialization precedence.
**Import order never matters**: adding or reordering imports must not change which instance is chosen.
**Local scope tricks are forbidden**: no function-local or block-local instance declarations, and no hidden "current instance" context.
**Blanket/generic instances are allowed only when they preserve uniqueness**: a generic instance is legal only if the compiler can still prove that no second instance can apply to the same fully resolved call.
**The sanctioned escape hatch is a wrapper/newtype**: if a package wants custom behavior for a foreign typeclass on a foreign type, it must introduce a local wrapper type and implement the instance for that wrapper. This keeps instance ownership explicit instead of making resolution depend on visibility scope.
**Why this fits Kyokai**: typeclass resolution remains part of the language contract, not a search heuristic. The programmer can audit which package owns which authority to define behavior.
**[STAGE: DECIDED_CORE_SEMANTICS | D81 → coherence + orphan rules + no overlap + no import-order dependence]**
- **Coherence diagnostics for overlapping instances must identify the actual overlap, not merely state that one exists** — once D81 rejects overlap, the minimum diagnostic contract must still tell the programmer which two instance declarations conflict and why.
**Rules**:
  1. Coherence and overlap checking consider all instances visible to the current build after package resolution.
  2. If two instances overlap, compilation fails even when one appears more specific than the other. Kyokai still has no implicit specialization precedence.
  3. The diagnostic must name the typeclass, both conflicting instance headers, and the package/module where each conflicting instance was defined.
  4. For generic overlap, the diagnostic must report at least one concrete witness substitution that demonstrates the conflict.
  5. For example, if `instance Destroyable(Container[T]) where T: Destroyable` overlaps `instance Destroyable(Container[SpecificType])`, the diagnostic should report that the overlap witness is `T = SpecificType`.
  **Why this fits Kyokai**: explicit coherence rules lose practical value if the failure mode collapses into folklore-grade "instance overlaps" messages. The programmer must be able to audit the exact conflicting behavior boundary.
  **[STAGE: DECIDED_CORE_SEMANTICS | D216 → overlap diagnostics name the conflicting instances, their defining packages/modules, and at least one overlap witness when generics are involved]**
- **Generic and typeclass dispatch is static; runtime dictionaries and trait objects are not part of Kyokai's language contract** — Instance resolution happens at compile time under D81. Generic calls and typeclass-dispatched calls do not become erased dynamic dispatch, hidden dictionary passing, or witness-table passing as part of the language semantics.
**No implicit runtime dictionaries**: generic calls do not gain hidden typeclass dictionary parameters, hidden witness tables, or trait-object-style runtime dispatch.
**No built-in erased trait objects**: code that wants runtime heterogeneity must use an explicit union or another explicitly chosen data representation rather than a `dyn Trait` analogue.
**Explicit runtime dispatch objects are a different category**: a runtime value/handle chosen explicitly in source code is ordinary program state, not a hidden typeclass dictionary just because its representation may contain function pointers.
**Code materialization is a separate decision family**: D82 fixes dispatch semantics only. The questions of how concrete bodies are materialized, where cross-package instantiations are emitted, and which deduplication optimizations are allowed are split into D82a and D82b.
**Why this fits Kyokai**: runtime behavior stays explicit and no hidden polymorphic machinery enters the calling convention, while compile-time and code-size strategy is forced into its own explicit decisions instead of being smuggled in as backend folklore.
**[STAGE: DECIDED_CORE_SEMANTICS | D82 → static generic/typeclass dispatch; no runtime dictionaries or trait objects]**
- **Typeclass coherence closes over package artifacts, and unsafe modules do not get orphan-instance powers** — D81's coherence rule is not just a source-file rule inside one compiler invocation. The checker must assemble the actual package graph, `.koi` instance metadata, imports, visibility, and generic constraints before accepting instance resolution.
**Rules**:
  1. An instance is legal only when the defining package owns the typeclass or owns at least one nominal type head in the instance head.
  2. Unsafe modules get no exception to the orphan rule. `unsafe` can admit low-level operations under audit; it cannot admit incoherent behavior into the package graph.
  3. Internal, private, test-only, or unsafe visibility does not allow a foreign typeclass for a fully foreign type across a package boundary.
  4. Generic instances are legal only when overlap checking can prove that no other visible legal instance may apply to the same concrete call after substitution.
  5. Associated-type bounds and associated-type equality constraints in `where` clauses participate in overlap and ambiguity checking. They are not decorative documentation.
  6. Recursive instance resolution must be rejected unless the compiler can prove a finite, well-founded resolution path under the accepted typeclass rules.
  7. `.koi` verification and package linking must reject conflicting instance metadata before downstream code can depend on either candidate.
  8. Diagnostics for a `.koi`-level conflict must name the conflicting packages, modules, instance headers, typeclass, and at least one overlap witness when generics are involved.
  **Why this fits Kyokai**: typeclass behavior is public package behavior. If package order, unsafe scope, or artifact loading order can change instance selection, the language has hidden semantics. Kyokai rejects that.
  **[STAGE: DECIDED_CORE_SEMANTICS | D279 -> Rust-style orphan boundary; unsafe modules get no coherence exception; `.koi` conflicts are hard errors]**
- **Allocator dispatch under D44 is explicit runtime state, not a D82 dictionary exception** — D82 bans hidden compiler-inserted dictionaries for generic and typeclass dispatch. It does not ban an allocator handle that the programmer explicitly chose, passed, and caused a container to store as part of its own runtime state.
**Rules**:
  1. D82's ban continues to apply to hidden generic/typeclass witness passing and trait-object-style dispatch.
  2. A container-stored allocator handle under D44 is ordinary runtime state chosen explicitly in source code at construction or other explicit allocator-taking boundaries.
  3. The runtime dispatch needed to call `allocate`, `deallocate`, and `reallocate` through that stored allocator handle is therefore not a language-level generic/typeclass dictionary and does not weaken D82.
  4. This ruling creates no ambient allocator default and no hidden allocator propagation. Allocator choice remains explicit at construction and fresh-allocation boundaries under D44 and D201.
  5. The standard library may offer allocator-specialized container families as ordinary library types if they are ever justified, but D44's value-level allocator model remains the canonical and sufficient language-facing model.
  **Why this fits Kyokai**: the language keeps D82's ban on hidden polymorphic machinery intact while also keeping D44 honest about allocator choice being explicit program data rather than compiler folklore.
  **[STAGE: DECIDED_CORE_SEMANTICS | D130 → D44 allocator handles are explicit runtime state, not a D82 runtime-dictionary exception]**
- **Reproducible builds are the default contract** — Given the same source contents, `kyokai.toml`, `kyokai.lock`, compiler version, language edition, target triple, and declared build options, Kyokai's specified primary artifacts must be bit-identical unless an output mode explicitly opts out. Reproducibility is not a best-effort quality-of-implementation goal; it is the default toolchain contract.
**The build identity includes**: package/workspace source contents, manifest contents, lockfile contents, enabled features, selected build profile, compiler version, language edition, target triple, and any explicit flags that the spec says affect code generation or artifact format.
**Forbidden hidden inputs**: timestamps, random seeds, filesystem traversal order, host locale, host timezone, unstable hash iteration order, and unrelated environment state must not change reproducible artifacts unless a mode explicitly says they are part of the output contract.
**Generated C, `.koi`, and final binaries/libraries all inherit this rule**: if Kyokai emits them as normative build products, they must obey the reproducibility contract.
**Path handling must be explicit**: if a build profile allows absolute source paths in debug information, that choice must be written down. Otherwise the toolchain must normalize or remap paths so build location does not perturb the artifact.
**Opting out must be explicit**: if a future profile or flag wants nondeterministic build IDs, embed timestamps, or include host-specific diagnostics, that must be an explicit documented mode, not default behavior.
**Why this fits Kyokai**: explicit languages should have explicit build identity. "Same inputs, same outputs" is the build-system form of "nothing hidden."
**[STAGE: DECIDED_CORE_SEMANTICS | D83 → reproducible by default, with explicit build identity]**
- **One `kyokai` binary, with explicit package/workspace/profile/target semantics** — Kyokai's toolchain surface is a single command-line binary named `kyokai`. The CLI is manifest-driven: the nearest relevant `kyokai.toml` determines whether the current scope is a standalone package or a workspace root (D78). The CLI does not guess hidden project structure beyond that manifest lookup.
**Core subcommands**: `build`, `run`, `check`, `test`, `fmt`, `doc`, `repl`, `eval`, `lsp`, `audit`, `init`, `new`, `add`, `update`, `remove`, `search`, `info`, `tree`, `why`, `outdated`, `vendor`, `login`, `logout`, `owner`, `yank`, `publish`, `clean`, `debug`, `profile`, and `memprofile`.
`**new` and `init` must write explicit layout information**: package manifests generated by toolchain commands must include the required `[layout] module_root = "src"` entry unless the user explicitly chooses a different relative module-root path at creation time.
**Package/workspace selection**:
  - If the current manifest is a package manifest, `build`, `check`, `doc`, and `test` operate on that package.
  - If the current manifest is a workspace manifest, `build`, `check`, `doc`, and `test` operate on all workspace members by default.
  - `-p` / `--package <name>` restricts the command to one workspace member.
  - `--workspace` forces whole-workspace scope when run from inside a member package.
  **Run semantics**:
  - `kyokai run` builds then executes a runnable package target.
  - If the selected scope contains more than one runnable package, `--package <name>` is required.
  - `kyokai run -- <args...>` passes subsequent arguments to the program being run.
  **Profile selection**:
  - `--profile <name>` selects a named build profile defined by D31.
  - `--release` is exact syntactic sugar for `--profile release`. It does not introduce hidden optimization behavior beyond the `release` profile written in the manifest.
  - If no profile is specified, the default profile for `build`, `run`, `check`, `test`, and `doc` is `debug`.
  **Target selection**:
  - `--target <arch-os-abi>` selects the compilation target triple.
  - `--backend <c|llvm>` selects the code generation backend. The package manifest may name a default backend in `[build].backend`; the CLI flag overrides it explicitly.
  - The selected triple must be one of Kyokai's legal D80 target triples. Unknown or illegal `os/arch/abi` combinations are a front-end error, not a late codegen surprise.
  - This determines the values of the language-level built-ins `target.arch`, `target.os`, and `target.abi` (D19), and selects the matching `[target.<triple>]` toolchain configuration from D31 and D149.
  - If the selected backend has no conforming toolchain configuration for the selected target, the build fails. There is no silent fallback to another backend.
  `**check` is not "build without honesty"**:
  - `kyokai check` performs parsing, name resolution, import resolution, type checking, linearity checking, instance resolution, and interface/artifact validation.
  - `check` may skip final code generation and linking, so codegen-only or link-only failures may still be discovered later by `build`.
  - The CLI must document this distinction explicitly; "fast feedback" is not a license for semantic ambiguity.
  `**add` follows D51 exactly**:
  - Adding an existing workspace package writes `{ workspace = "name" }`.
  - Adding an external Git dependency without an explicit pin is an error; the command must not silently choose the current default-branch HEAD.
  - `kyokai add --git <url> --rev <rev>` writes `{ git = "<url>", rev = "<rev>" }`.
  - `kyokai add --git <url> --tag <tag>` resolves the tag to a commit and writes both `tag` and `rev`.
  - If a future convenience flag such as `--head` exists, it must resolve HEAD immediately and write the resulting `rev`; the manifest still stores the immutable pin, not the moving reference.
  **Mutation commands are Kyokai-shaped, not a generic registry shell**:
  - `kyokai update` updates selected dependencies by resolving explicit package/index policy into new immutable `rev` pins and lockfile entries.
  - `kyokai remove` follows D269 and reports whether a removed direct dependency remains reachable transitively.
  - `kyokai login`, `kyokai logout`, `kyokai owner`, `kyokai yank`, and `kyokai publish` operate only against configured indexes that actually support those operations. Plain Git dependencies do not require index login.
  - `publish` validates manifest identity, version metadata, package ownership, source reachability, `.koi` production, docs generation, SemVer report, yanks/advisories state, and reproducible package metadata before submitting anything to an index.
  - Commands that mutate source files, manifests, lockfiles, package metadata, index records, vendor directories, or output/cache roots support `--dry-run` when meaningful.
  - Commands with nontrivial mutation plans support `--print-plan`, producing deterministic human-readable output by default and structured output when the global output format requests it.
  - `--dry-run` performs all validation and resolution possible without committing the mutation, and reports exactly which files, lockfile entries, index records, vendor paths, output roots, or cache roots would change.
  - `kyokai fix --dry-run` prints the edit plan and diagnostics without changing files. `kyokai clean --dry-run` prints the selected cache/output paths without deleting them. `kyokai publish --dry-run` performs local package validation without creating an index record.
  `**doc` follows visibility**: generated documentation includes public API by default and excludes `internal` declarations. An explicit package-internal documentation mode can include `internal` declarations; private `.kai`-only declarations remain excluded from public generated docs.
  **Verbosity must expose the resolved build plan**: `--verbose` prints the selected manifest root, workspace/package scope, target triple, backend name, profile name, resolved compiler/linker tools, and the exact additional flags applied from target/profile configuration.
  **Why this fits Kyokai**: one tool is simpler, but the important part is that its behavior is manifest-defined and inspectable rather than conventional or magical.
  **[STAGE: DECIDED_CORE_SEMANTICS | D26/D275 -> single `kyokai` binary with explicit scope/profile/target semantics plus bounded daily mutation commands, dry runs, and print-plan behavior]**
- **Build profiles and target/toolchain configuration live in `kyokai.toml`, not in folklore** — Kyokai exposes binary/output policy through explicit manifest tables rather than hard-wired release folklore. Profiles describe optimization/debug/strip/LTO/identical-code-folding policy. Target tables describe which backend tools and extra flags implement a particular target triple. Package build tables describe what artifact kind a package produces.
**Profile tables**:
  - Profiles are named using `[profile.<name>]`.
  - `debug` and `release` are conventional names, not magic compiler modes.
  - Custom profiles are allowed; if a custom profile omits a field, it may inherit from another named profile with `inherits = "<name>"`.
  - In a standalone package build, profile tables are read from that package manifest.
  - In a workspace build, profile tables are read from the workspace root manifest; member-package profile tables are ignored to avoid ambiguity.
  - The standardized profile policy surface includes at least `optimization`, `debug_info`, `strip`, `lto`, and `identical_code_folding`.
  **Target/toolchain tables**:
  - Toolchain selection lives in `[target.<triple>]`.
  - `<triple>` must be a legal D80 target triple. Manifest configuration may choose which legal targets it knows how to build for; it may not invent new triples outside the language/toolchain target matrix.
  - Supported common keys are:
    - `spec` — optional relative path to a reusable target-spec TOML file imported into this target table
    - `sysroot` — explicit sysroot or SDK root for this target
    - `linker` — linker or linker-driving command shared by backend paths unless overridden below
    - `archiver` — tool used to build static libraries when needed
    - `runner` — optional execution command for `kyokai run --target ...`
  - Backend-specific overrides live in `[target.<triple>.backend.<name>]`.
  - The standardized backend names are `c` and `llvm`.
  - Supported C-backend keys are:
    - `cc` — C compiler used for generated C compilation
    - `cflags` — extra C compiler flags
    - `ldflags` — extra linker flags for the C-backend path
  - Supported LLVM-backend keys are:
    - `ldflags` — extra linker flags for the LLVM-backend path
  - Common fields are inherited by backend-specific subtables unless overridden explicitly.
  - Per-target, per-profile overrides live in `[target.<triple>.profile.<name>]`.
  - Per-target, per-backend, per-profile overrides live in `[target.<triple>.backend.<name>.profile.<name>]`.
  **Package build table**:
  - Package output settings live in `[build]` in the package manifest.
  - `backend = "c" | "llvm"`
  - `output_type = "executable" | "static-lib" | "dynamic-lib"`
  - `link = "target-default" | "static" | "dynamic"`
  - `backend` is the manifest-declared default code generation backend for that package. CLI `--backend` overrides it explicitly.
  - `target-default` means "use the selected target/toolchain default behavior"; it is explicit, not implicit.
  - If `static` or `dynamic` is requested and the selected target/toolchain cannot honor that request, the build fails. There is no silent fallback.
  **Example**:
  ```toml
  [profile.debug]
  optimization = 0
  debug_info = true
  strip = false
  lto = false
  identical_code_folding = false

  [profile.release]
  optimization = 2
  debug_info = false
  strip = true
  lto = true
  identical_code_folding = true

  [profile.size]
  inherits = "release"
  optimization = 2
  strip = true
  lto = true
  identical_code_folding = true

  [target.x86_64-linux-gnu]
  sysroot = "/usr"
  linker = "clang"
  archiver = "ar"

  [target.x86_64-linux-gnu.backend.c]
  cc = "clang"
  cflags = []
  ldflags = []

  [target.x86_64-linux-gnu.backend.llvm]
  ldflags = []

  [target.x86_64-linux-musl]
  spec = "targets/x86_64-linux-musl.toml"

  [target.x86_64-linux-musl.backend.c.profile.release]
  cflags = ["-Os"]
  ldflags = []

  [build]
  backend = "c"
  output_type = "executable"
  link = "target-default"
  ```
  **Dead code elimination after H06**: once package-level separate compilation exists, dead stripping is primarily a section/linker/LTO story, not a "whole program compiler sees everything" story. Release builds should therefore emit/link in a way that supports dead-section elimination.
  **Why this fits Kyokai**: users can choose exact policy per target and per profile without undocumented `--release` assumptions, and the difference between `target.abi = Musl` and `cc = musl-gcc` stays explicit.
  **[STAGE: DECIDED_CORE_SEMANTICS | D31 → explicit manifest-defined profiles + target toolchains + package output settings]**
- **Build profiles do not weaken safe-language runtime checks** — Kyokai separates performance/debugging policy from safety semantics and does not let release mode silently turn contract violations into unchecked behavior.
**Rules**:
  1. Build profiles may change optimization settings, debug information, symbol emission, `debug` stripping behavior under D45, and default hosted backtrace policy under D170.
  2. Build profiles may NOT weaken, remove, or reinterpret safe-language overflow checks, bounds checks, contract checks, `unreachable;`, or any other TPOE-triggering rule defined by the language.
  3. The semantic behavior of safe Kyokai code is therefore profile-invariant with respect to these checks.
  4. If a programmer wants unchecked behavior, it must come from explicit unsafe or explicitly named unchecked operations, not from selecting a faster build profile.
  **Why this fits Kyokai**: release optimization remains a performance concern instead of becoming a second semantics mode that quietly changes the safety contract.
  **[STAGE: DECIDED_CORE_SEMANTICS | D185 → debug/release profiles may change diagnostics and optimization, but not safe-language runtime checks; unchecked behavior must be explicit]**
- **Legal target triples and support guarantees are explicit** — the `Os`, `Arch`, and `Abi` enums define Kyokai's target vocabulary, but the valid target set is not the cartesian product. Each legal `arch-os-abi` triple has an explicit support promise, and every unlisted combination is invalid.
**Support tiers**:
  - **Tier 1**: compiler, stdlib, tests, and CI must pass. Regressions on a Tier 1 target are release-blocking.
  - **Tier 2**: compiler and stdlib must build, and the maintained target smoke suite must pass before release. CI coverage may be reduced or periodic rather than per-change.
  - **Experimental**: the target triple is recognized and may have working compiler and stdlib support, but codegen, runtime support, tooling, and regression handling are best-effort.
  **Legal target matrix**:

  | Target triple               | Tier         | Notes                                                                               |
  | --------------------------- | ------------ | ----------------------------------------------------------------------------------- |
  | `x86_64-linux-gnu`          | Tier 1       | Primary hosted Linux/glibc target                                                   |
  | `x86_64-linux-musl`         | Tier 1       | Primary hosted Linux/musl target                                                    |
  | `x86_64-freebsd-none`       | Tier 1       | Primary BSD target                                                                  |
  | `x86_64-windows-msvc`       | Tier 1       | Primary Windows target                                                              |
  | `aarch64-linux-gnu`         | Tier 2       | Hosted ARM64 Linux                                                                  |
  | `aarch64-linux-musl`        | Tier 2       | Hosted ARM64 Linux with musl                                                        |
  | `aarch64-freebsd-none`      | Tier 2       | Hosted ARM64 BSD                                                                    |
  | `aarch64-windows-msvc`      | Tier 2       | Hosted ARM64 Windows                                                                |
  | `x86_64-freestanding-none`  | Tier 2       | x86_64 bare-metal / kernel-space target                                             |
  | `aarch64-freestanding-none` | Tier 2       | ARM64 bare-metal / kernel-space target                                              |
  | `x86_64-macos-none`         | Experimental | Recognized target, but below primary hosted targets until real test coverage exists |
  | `aarch64-macos-none`        | Experimental | Recognized target, but below primary hosted targets until real test coverage exists |
  | `x86_64-android-bionic`     | Experimental | Recognized Android target                                                           |
  | `aarch64-android-bionic`    | Experimental | Primary Android ABI shape, but still late bring-up                                  |
  | `riscv64-linux-gnu`         | Experimental | Hosted RISC-V Linux                                                                 |
  | `riscv64-linux-musl`        | Experimental | Hosted RISC-V Linux with musl                                                       |
  | `riscv64-freebsd-none`      | Experimental | Hosted RISC-V BSD                                                                   |
  | `riscv64-freestanding-none` | Experimental | Bare-metal RISC-V target                                                            |

  **Rules**:
  - Any `arch-os-abi` triple not listed in the legal target matrix is invalid and must be rejected explicitly before build planning, code generation, or linking.
  - Android is represented by `target.os = Os.Android` with `target.abi = Abi.Bionic`.
  - `Abi.None` means "no extra ABI/environment selector beyond the target's hosted or freestanding contract." It does not mean "no ABI exists."
  - If Kyokai later wants to recognize another target triple, that target must be added explicitly to this matrix; legality is never inferred from enum membership alone.
  **Why this fits Kyokai**: target support becomes an explicit contract rather than folklore. The language can expose `target.os`, `target.arch`, and `target.abi` without pretending every combination is real, and the toolchain can reject impossible or unsupported targets honestly and early.
  **[STAGE: DECIDED_CORE_SEMANTICS | D80 → explicit support-tier contract + legal target matrix; invalid triples rejected early]**
- **Local variable inference is allowed only when the initializer already determines the type** — Kyokai permits `let name := expr;` only for immutable local bindings whose initializer has one fully determined, denotable type without needing target typing from the left-hand side. This removes redundant repetition while keeping types mechanically obvious from the right-hand side.
**Rules**:
  1. `let name := expr;` is legal only if `expr` has exactly one known type before considering the omitted left-hand-side annotation.
  2. `var name: Type := expr;` still requires an explicit type. Mutable locals are always annotated.
  3. Ambiguous literals are not rescued by this rule. `let x := 5;` is illegal unless the literal's type is already fixed by the initializer expression itself.
  4. Polymorphic constructors or empty values that need target typing remain illegal without an explicit annotation.
  5. Pattern-binding forms keep using the type information from the matched expression; D46 does not add any new pattern-inference mechanism beyond that.
  **Examples**:
  - Legal: `let p := Point { x: 5, y: 10 };`
  - Legal: `let file := openConfig(path);` if `openConfig` already has a single concrete return type.
  - Illegal: `let x := 5;`
  - Illegal: `var x := makeThing();`
  - Illegal: `let xs := List.empty();`
  **Why this fits Kyokai**: the rule removes repeated type names when the initializer already says everything, but it does not introduce target-typed guessing or hidden coercions.
  **[STAGE: DECIDED_CORE_SEMANTICS | D46 → immutable `let :=` only when RHS already fixes one type]**
- **Assignment is a statement, never an expression** — `:=` performs mutation and yields no value. It cannot appear where an expression is required.
**Rules**:
  1. `a := b;` is a statement only.
  2. It yields nothing, not even `Unit`.
  3. It cannot be chained (`a := b := c` is illegal).
  4. It cannot appear in conditions, argument lists, return expressions, or any other expression position.
  5. If compound assignments are added later, they inherit the same statement-only rule.
  **Why this fits Kyokai**: mutation stays visually separate from value production, and the language permanently eliminates assignment-in-condition bugs.
  **[STAGE: DECIDED_CORE_SEMANTICS | D59 → assignment is statement-only and yields no value]**
- **No binding may shadow another binding that is still in scope** — Kyokai bans shadowing across local scopes, nested scopes, patterns, loops, and parameters. A new binding may reuse a name only after the earlier binding has gone out of scope.
**This applies to**: function parameters, local `let` bindings, local `var` bindings, pattern-bound names, `let...else` success bindings, loop variables, and any future binding form unless that form explicitly states otherwise.
**Rules**:
  1. If an identifier names any currently in-scope binding, introducing a new binding with that identifier is a compile-time error.
  2. Consuming a linear value does not end the binding's lexical scope. A consumed binding remains in scope until its enclosing block or scope ends.
  3. Therefore, a consumed binding's identifier cannot be rebound or shadowed in that same scope.
  4. Reuse of the same identifier after the old binding's lexical scope has ended is allowed.
  5. This is a name-resolution error, not a warning or style lint.
  **Why this fits Kyokai**: names refer to one thing at a time, and name resolution stays purely lexical instead of depending on dynamic linearity state such as "already consumed."
  **[STAGE: DECIDED_CORE_SEMANTICS | D60 → no shadowing of any still-in-scope binding]**
- **Module-level mutable state is banned** — Kyokai modules may define constants at module scope, but not mutable variables. There is no language-level notion of a user-defined mutable global.
**Rules**:
  1. `constant` declarations are allowed at module scope.
  2. `var` declarations are illegal at module scope.
  3. If a program needs shared mutable state, it must be represented explicitly as a value passed through capabilities, function parameters, or explicit references/borrows.
  4. The language does not treat "global singleton" patterns as a special case.
  **Why this fits Kyokai**: mutable ambient state undermines the capability model, weakens auditability, and hides dependencies that should be visible in function signatures and module imports.
  **[STAGE: DECIDED_CORE_SEMANTICS | D62 → no module-level mutable variables]**
- **Module-level constants are forced lazily, cached, and checked for dependency cycles across module boundaries** — Kyokai does not assign semantic meaning to the eager initialization order of pure constants.
**Rules**:
  1. Importing or compiling a module does not by itself force evaluation of every module-level `constant` in that module.
  2. A module-level constant is forced only when its value is needed to evaluate another constant, a `static_assert`, a `when` guard, a `comptime` expression, or generated code that depends on that constant's value.
  3. Each module-level constant has one of three evaluation states: `Unforced`, `Evaluating`, or `Evaluated`.
  4. Forcing an `Unforced` constant changes its state to `Evaluating`, then recursively forces its constant dependencies, then computes and caches its value, then changes its state to `Evaluated`.
  5. Forcing an already `Evaluated` constant reuses its cached value.
  6. Encountering a dependency on a constant already in state `Evaluating` is a constant-dependency cycle and is a compile-time error.
  7. The cycle diagnostic must report the dependency path forming the cycle.
  8. These rules apply across module boundaries exactly as they apply within one module.
  9. Because module-level constants are pure and may not observe ambient state, unrelated constants have no semantic evaluation order. An implementation may force them in any deterministic order, or not force them at all if they are never needed.
  **Why this fits Kyokai**: pure constants stay reproducible and explicit, cycles become precise compile-time errors, and the language does not invent a fake initialization-order story for values that are semantically just pure computations.
  **[STAGE: DECIDED_CORE_SEMANTICS | D215 → module-level constants are lazy, cached, and cycle-checked across modules; unrelated constants have no semantic evaluation order]**
- **Safe thread-local storage is keyed and capability-gated; ambient `thread_local var` does not exist in safe Kyokai** — Kyokai does allow per-thread mutable state, but only through explicit key objects and an explicit `TlsCapability`. Raw platform TLS remains available only at the unsafe boundary.
**Rules**:
  1. Safe Kyokai has no module-scope `thread_local var` declaration form.
  2. `TlsCapability` is an explicit capability acquired from `RootCapability`.
  3. Safe TLS keys are explicit values created through `TlsCapability`. `ThreadLocalKey[T]` is an opaque `Linear` key type.
  4. Safe TLS payload type `T` must be `Free`. Safe TLS may not store `Linear` values.
  5. Each `ThreadLocalKey[T]` denotes one per-thread slot family. For every thread, a newly created key's slot starts empty.
  6. Child threads do not inherit parent TLS slot values implicitly. New thread means empty slots unless user code writes values explicitly.
  7. Access to safe TLS requires both the relevant `TlsCapability` and a borrow of the relevant `ThreadLocalKey[T]`, so TLS effects are visible in function signatures and data flow.
  8. Safe TLS operations act only on the current thread's slot for that key. There is no API for directly reading or mutating another thread's slot.
  9. Setting a TLS slot value is explicit. Replacing or clearing a slot returns the old value explicitly if the API removes one.
  10. Borrowing a value inside a TLS slot yields an ordinary borrow tied to the borrow scope of the access operation; it may not escape that scope.
  11. Destroying a `ThreadLocalKey[T]` consumes the key. After destruction, all access through that key is invalid.
  12. If a thread exits while a safe TLS slot still contains a `Free` value, that value is discarded as ordinary `Free` state. Because `Linear` values are forbidden here, thread exit does not create hidden linear cleanup obligations.
  13. Raw platform TLS interop remains available only through `pragma Unsafe_Module` code and the unsafe boundary. It is a separate facility from safe keyed TLS.
  **Why this fits Kyokai**: thread-local state remains available for per-thread allocators, seeds, and scratch state, but the capability model stays intact because safe TLS access is explicit in signatures rather than hidden behind ambient module state.
  **[STAGE: DECIDED_CORE_SEMANTICS | D114 → safe TLS is keyed + `TlsCapability`; no ambient `thread_local var`; raw TLS interop remains unsafe-only]**
- **Comments are line comments; documentation comments are attached comments; block comments do not exist** — Kyokai uses C-family line comment syntax, but gives documentation comments explicit structural meaning.
**Syntax**:
  1. `//` starts a normal line comment.
  2. `///` starts a documentation comment attached to the declaration that immediately follows.
  3. `//!` starts a module/file documentation comment describing the containing file/module.
  **Rules**:
  1. `/* ... */` block comments are not part of the language.
  2. A `///` doc comment must be immediately followed by the declaration it documents; unattached doc comments are errors.
  3. A `//!` module doc comment must appear before the first non-doc token in the file.
  4. Public documentation tools read doc comments from `.kyo` interface files by default; comments in `.kai` bodies remain ordinary source comments unless a tool explicitly documents private/internal code.
  **Why this fits Kyokai**: line comments are familiar, doc comments are mechanically attached to declarations instead of being free-floating prose, and banning block comments keeps lexing and tooling simpler.
  **[STAGE: DECIDED_CORE_SEMANTICS | D63 → `//`, `///`, `//!`, and no block comments]**
- **`Type`, `Free`, and `Linear` are parameter constraints, while `Auto` is a declaration-site universe classifier** — Kyokai keeps these roles separate so generic APIs do not blur "what arguments may this parameter accept?" with "what universe does this instantiated type belong to?"
**Rules**:
  1. `T: Type` means `T` may be instantiated with either a `Free` type or a `Linear` type.
  2. `T: Free` means `T` may be instantiated only with a `Free` type.
  3. `T: Linear` means `T` may be instantiated only with a `Linear` type.
  4. Inside generic code, a value whose type parameter is constrained as `T: Type` must be treated conservatively. It may be moved, borrowed, stored, returned, and passed through explicit APIs, but it may not be implicitly copied or silently discarded.
  5. Inside generic code, a value whose type parameter is constrained as `T: Free` follows the ordinary free-value rules, including the language's ordinary copy/discard behavior for free values.
  6. Inside generic code, a value whose type parameter is constrained as `T: Linear` follows the ordinary linear-use rules.
  7. `Type`, `Free`, and `Linear` constrain type parameters only. They do NOT by themselves determine the universe of the enclosing generic type constructor.
  8. `Auto` is not a parameter constraint and may not appear where a type-parameter universe constraint is expected. `Auto` is used only at a type declaration site to say that the instantiated type's universe is chosen by the constructor's classification rule.
  **Examples**:
  - If `record Wrapper[T: Type]: Auto is ... build;`, then `Wrapper[Int32]` is `Free` while `Wrapper[File]` is `Linear`.
  - If `record HandleBox[T: Type]: Linear is ... build;`, then both `HandleBox[Int32]` and `HandleBox[File]` are `Linear`.
  - If `record CopyOnly[T: Free]: Free is ... build;`, then only `Free` arguments are legal and the resulting type is always `Free`.
  **Why this fits Kyokai**: generic constraints stay explicit, the line between "accepts any type" and "becomes linear when instantiated with a linear argument" remains visible, and the type checker gets one closed rule per concept instead of a muddy hybrid.
  **[STAGE: DECIDED_CORE_SEMANTICS | D195 → `Type`/`Free`/`Linear` are parameter constraints; `Auto` is a declaration-site classifier only]**
- **Phantom type parameters are allowed on nominal types, but Kyokai does not adopt a general zero-sized-type culture or a dedicated marker-field crutch** — type-level distinctions matter, but most Rust-style ZST machinery does not pull its weight in Kyokai.
**Rules**:
  1. A nominal type may declare a type parameter that is not represented in its runtime field layout.
  2. Such a phantom parameter still participates fully in type identity, generic instantiation, and instance resolution.
  3. Kyokai does not require or standardize a dedicated marker field or `Kyokai.Phantom[T]` helper type for phantom parameters.
  4. User-defined zero-field `record` declarations are illegal.
  5. Kyokai does not introduce a general user-defined zero-sized runtime-type facility beyond the language's already-decided zero-payload forms such as `Unit` and zero-field union cases.
  **Why this fits Kyokai**: useful type-level distinctions remain available without importing a broader ZST design culture that adds little value to Kyokai's systems-language surface.
  **[STAGE: DECIDED_CORE_SEMANTICS | D181 → phantom type parameters allowed without marker fields; no dedicated `Phantom` helper; user-defined zero-field records are illegal]**
- **Universe membership comes from each type constructor's declared classification rule, not from a blanket "all generic built-ins are Auto" shortcut** — Kyokai states the classification rule explicitly for each built-in or special type form so linearity never depends on folklore.
**Constructor classification rules**:
  1. A non-generic type declared `Free` is always `Free`.
  2. A non-generic type declared `Linear` is always `Linear`.
  3. A user-defined generic type declared `Auto` follows D338: after substitution it is `Linear` iff at least one stored field, stored union payload, or captured environment field is `Linear`; otherwise it is `Free`. Phantom and const arguments do not force `Linear` unless an accepted built-in rule says so or the argument selects, sizes, or otherwise determines a stored component. Built-in `Auto` constructors keep their closed constructor-specific rules.
  4. A generic type declared `Free` is always `Free`, regardless of its type arguments.
  5. A generic type declared `Linear` is always `Linear`, regardless of its type arguments.
**Language-defined and special-form table**:
  1. Always `Free`: `Unit`, `Bool`, `Never`, `StaticString`, all fixed-width integer types, all fixed-width floating-point types, `Index`, and the built-in target enums and other built-in enum-valued compile-time descriptors.
  2. Always `Free`: `FnPtr[...]`, `Address[T]`, `Pointer[T]`, immutable borrows `&[T]`, mutable borrows `&![T]`, and other borrow/view special forms whose purpose is observation or access rather than ownership.
  3. Always `Free`: `Vector[T, N]`, because D104 restricts the portable vector element domain to fixed-width scalars and masks that are themselves `Free`.
  4. `Auto`: `Optional[T]`, `Result[T, E]`, and `Array[T, N]`.
  5. Always `Linear`: owning and synchronization primitives whose declarations explicitly say so, including `String`, `Buffer[T]`, `Box[T]`, `PinBox[T]`, `Atomic[T]`, `Sender[T]`, `Receiver[T]`, `Mutex[T]`, `RwLock[T]`, capabilities, and other explicitly resource-owning runtime handle types.
  6. Ordinary user-defined and standard-library nominal types follow the universe marker on their own declarations: `Free`, `Linear`, or `Auto`.
  7. No type gains a universe from its name, intended use, or ABI shape. The declaration or special-form classification rule is the only source of truth.
  **Why this fits Kyokai**: the linearity checker gets a closed auditable rule set, `Auto` stays a precise mechanism instead of a catch-all slogan, and special cases like borrows, raw pointers, and function pointers stay visibly non-owning.
  **[STAGE: DECIDED_CORE_SEMANTICS | D194 refined by D338 → explicit constructor-by-constructor built-in rules plus structural stored-component classification for user-defined `Auto`; no blanket generic-argument shortcut]**
- **Type identity is recursive and nominal, not structural** — Kyokai does not equate types because they "look the same." Two fully resolved types are identical iff their canonical forms are identical under the language's nominal rules.
**Canonicalization**:
  1. Name resolution must identify the declaration referenced by every nominal type name.
  2. `type alias` names from D50 are expanded away.
  3. Surface sugar is desugared into the underlying type form.
  4. Associated-type projections from D33 are normalized when the governing instance is known.
**Identity rules after canonicalization**:
  1. Two primitive built-in types are identical iff they are the same built-in type.
  2. Two nominal user-declared types are identical iff they refer to the same package-qualified and module-qualified declaration.
  3. Two applications of the same type constructor are identical iff the constructor is the same and each corresponding type argument is identical.
  4. For type forms that carry compile-time value parameters, the corresponding value parameters must match under that type form's own equality rule.
  5. Two reference types are identical iff they have the same reference kind and identical referent type, plus identical explicit region arguments when the named-region form is used.
  6. Two associated-type projections are identical iff, after normalization through the selected instance, the resulting canonical types are identical.
  7. `type alias` introduces no new nominal identity.
  8. Structural coincidence does not create identity. Two records, unions, or function types with the same apparent shape are still different if they arise from different declarations or different constructors.
  9. ABI equality does not create type equality. A single-field record may have the same representation as its field type while still being a distinct nominal type.
**Explicit consequences**:
  1. `UserId` is not identical to `Nat64` merely because it has the same layout.
  2. `Result[Int32, IoError]` is identical only to the same constructor applied to identical arguments.
  3. Kyokai has no structural subtyping for records, unions, or function types.
  **Why this fits Kyokai**: nominal boundaries stay visible, aliases remain honest synonyms instead of stealth newtypes, and the core type-equality relation is fully specified for generics, associated types, and special type forms.
  **[STAGE: DECIDED_CORE_SEMANTICS | D190 → recursive nominal type identity after alias expansion, desugaring, and projection normalization]**
- **Recursive and mutually recursive nominal types are legal only when their fully expanded representation has finite size** — Kyokai allows recursion, but it does not bless any type by name or permit infinite inline layout cycles.
**Rules**:
  1. A nominal type may refer to itself directly or indirectly only if every cycle in the fully expanded layout-dependency graph passes through at least one indirection-bearing field.
  2. An indirection-bearing field is one whose representation stores a fixed-size handle, pointer, or borrow rather than embedding the full referent inline.
  3. Language-defined indirection-bearing forms include `Box[T]`, `PinBox[T]`, `Address[T]`, `Pointer[T]`, `&[T]`, and `&![T]`.
  4. Other type constructors break recursion only when their own layout rules explicitly state that their parameter is represented indirectly. No type gains recursion-breaking status from its name alone.
  5. Inline constructors such as ordinary records, unions, single-field wrappers, `Optional[T]`, `Result[T, E]`, arrays, and aliases do not by themselves break a recursive layout cycle.
  6. A recursive cycle composed entirely of inline edges is ill-formed and must be rejected as an infinite-size type.
  7. The recursion check runs after alias expansion and over the whole strongly connected declaration group involved in the cycle.
  8. Mutually recursive nominal types must be declared in one explicit same-module declaration group so the compiler can validate the whole strongly connected component together.
  9. The compile-time error for an illegal recursive layout must report at least one offending cycle and identify at least one legal indirection strategy.
  **Why this fits Kyokai**: recursive data structures stay available, but layout legality is mechanical, representation-based, and free of folklore such as “`Box` is magic because the compiler felt like it.”
  **[DECIDED: D160/D217 → recursive and mutually recursive nominal types are allowed only under a representation-based finite-layout rule; explicit same-module declaration groups; infinite inline cycles are ill-formed]**
- **Kyokai generics are rank-1 only** — the language does not allow nested universal quantifiers inside value-level type expressions.
**Rules**:
  1. Type parameters may be introduced only on declarations of functions, methods, types, unions, records, typeclasses, and instances.
  2. A type expression appearing in a parameter type, field type, return type, local binding type, associated type definition, or other value-level type position may not itself introduce a new universal quantifier.
  3. Kyokai therefore has no surface form equivalent to `forall T. ...` in value positions and no rank-2, rank-N, or impredicative polymorphism.
  4. A generic function may be referenced or passed only through an ordinary fully resolved callable type at the use site. Kyokai does not make "polymorphic function value" a separate first-class type form.
  **Why this fits Kyokai**: generic signatures stay readable, diagnostics stay local, and the type system avoids a major increase in abstraction complexity that would buy little for Kyokai's systems-language surface.
  **[STAGE: DECIDED_CORE_SEMANTICS | D192 → rank-1 generics only; no higher-rank or impredicative polymorphism]**
- **Kyokai has no existential types and no opaque return types** — the language does not hide an implementation type behind a typeclass bound or `impl Trait`-style surface.
**Rules**:
  1. A type position may not quantify existentially or hide a concrete implementation type behind a bound such as `some T: Trait`, `exists T`, `impl Trait`, or any equivalent construct.
  2. A function's return type must name a fully visible concrete type expression.
  3. Stored values likewise use fully visible types. Kyokai has no erased trait-object or existential container model.
  4. Heterogeneous collections and sum-shaped abstraction boundaries use explicit unions or other explicit nominal wrapper types.
  5. This rule is consistent with D82: Kyokai has no hidden runtime dictionaries, witness tables, or trait-object dispatch.
  **Why this fits Kyokai**: abstraction boundaries remain auditable, `.koi` interfaces stay explicit, and the language does not smuggle dynamic dispatch or representation hiding in through a second typing mechanism.
  **[STAGE: DECIDED_CORE_SEMANTICS | D193 → no existential types, no opaque return types, and no trait-object-style erased containers]**
- **Typeclasses may provide default method bodies, but associated types still do not have defaults** — Kyokai allows declaration-site method reuse without adding a second dispatch model.
**Rules**:
  1. A typeclass method may be declared either as a required signature or with a default body.
  2. Every instance must implement each method that lacks a default body.
  3. An instance may override any default method body by providing its own implementation.
  4. A default body may call other methods of the same typeclass and may refer to the typeclass's associated types.
  5. Associated types themselves still have no defaults.
  **Why this fits Kyokai**: common typeclass APIs can share ordinary derived behavior without changing D81 coherence or D82's static-dispatch model.
  **[STAGE: DECIDED_CORE_SEMANTICS | D182 → default method bodies are allowed in typeclasses; instances may override; associated types still have no defaults]**
- **Kyokai does not adopt a general variance system; instead it gives `Never` a closed, explicit lifting table for the built-in sum constructors that need it** — this preserves the narrow ergonomic benefit behind variance pressure without importing hidden subtyping machinery.
**Rules**:
  1. Kyokai has no general generic-subtyping relation beyond D191's expression-site `Never` coercion.
  2. User-defined generic nominal types are invariant in all type parameters.
  3. Kyokai defines a closed built-in `Never`-lifting rule for the following constructors only:
     - `Optional[Never]` coerces to `Optional[T]` for any `T`
     - `Result[Never, E]` coerces to `Result[T, E]` for any `T`
     - `Result[T, Never]` coerces to `Result[T, E]` for any `E`
  4. No other generic constructor gains automatic lifting or variance unless a later explicit decision adds it.
  5. This rule is a closed coercion table, not inferred variance and not a user-extensible annotation system.
  6. Borrow/reference coercions such as D187 are separate explicit rules and are not implied by D186.
  **Why this fits Kyokai**: the language gets the practical `Never` ergonomics it actually needs while keeping generic type relations explicit, closed, and mechanically auditable.
  **[STAGE: DECIDED_CORE_SEMANTICS | D186 → no general variance system; user-defined generics invariant; closed `Never`-lifting for `Optional` and `Result` only]**
- **Typeclasses may declare associated types, and associated types are the only built-in way to express "this secondary type is determined by the instance"** — Kyokai adopts Rust/Swift-style associated types and does not add Haskell-style functional dependencies.
**Syntax**:
  ```kyokai
  typeclass Iterable(Self: Type) is
      type Item;
      method next(iter: &![Self]): Optional[Self.Item];
  spec;

  instance Iterable(Buffer[Int32]) is
      type Item := Int32;
      method next(iter: &![Buffer[Int32]]): Optional[Int32] is
          // implementation
      qed;
  qed;
  ```
  **Rules**:
  1. Associated types may be declared only inside a `typeclass`.
  2. Every instance must define each associated type exactly once.
  3. A projected associated type is written as `Self.Item` or `T.Item`, where the receiver type parameter is constrained by the relevant typeclass.
  4. Once the instance is chosen, the associated type is fully determined; it is not a second free dispatch parameter.
  5. Associated types have no defaults.
  6. Functional dependencies, open type families, and any second mechanism for expressing the same relation are not part of Kyokai.
  **Why this fits Kyokai**: it keeps iterator, indexing, and operator typeclasses readable without forcing every call site to restate a secondary type parameter, and it gives the language one explicit mechanism instead of two overlapping ones.
  **[STAGE: DECIDED_CORE_SEMANTICS | D33 → associated types only; no functional dependencies]**
- **Conjunctive generic constraints use one explicit `where` surface**: Kyokai does not split "simple" and "complex" generic obligations across competing multi-bound syntaxes.
**Syntax**:
  ```kyokai
  function dedupKeys[T: Type](map: &[HashMap[T, Int32]]): Bool
  where
      T: Equality,
      T: Hashable
  is
      // implementation
  qed;

  function printAll[C: Iterable](iter: &[C]): Unit
  where
      C.Item: Displayable
  is
      // implementation
  qed;
  ```
  **Rules**:
  1. The `generic [...]` header declares generic parameters and may carry one inline classifier or baseline bound per parameter such as `T: Type`, `R: Region`, or `A: Allocator`.
  2. Any additional conjunctive typeclass obligations are written in a `where` clause.
  3. Multiple obligations on the same parameter are written as repeated entries in `where`, not as `T: Foo + Bar`.
  4. Associated-type constraints are also written in the same `where` clause surface.
  5. The `where` clause appears after the generic header and before `require`, `ensure`, and `is`.
  6. Bounds inside `where` are conjunctive. Order has no semantic meaning.
  7. Duplicate constraints are compile-time errors.
  **Why this fits Kyokai**: the parameter list keeps doing one job, while all extra obligations live in one visibly separate place that scales from one additional bound to associated-type constraints without inventing a second shorthand grammar.
  **[STAGE: DECIDED_CORE_SEMANTICS | D158 -> conjunctive generic bounds use a single `where` clause surface; no `+` bound syntax]**
- **The `where` clause has one closed grammar for non-header generic obligations**: Kyokai does not leave the associated-type and equality side of generic constraints open-ended.
**Syntax**:
  ```kyokai
  function printAll[C: Iterable](iter: &[C]): Unit
  where
      C.Item: Displayable
  is
      // implementation
  qed;

  function collectBytes[I: Iterable](iter: &[I]): Unit
  where
      I.Item == Nat8
  is
      // implementation
  qed;
  ```
  **Rules**:
  1. The `where` clause appears after the generic header and before `require`, `ensure`, and `is`.
  2. `where` obligations are comma-separated and purely conjunctive.
  3. The admitted obligation forms are `T: Trait`, `Projection: Trait`, and `Projection == TypeExpr`.
  4. `Projection` means an associated-type projection such as `C.Item`.
  5. `TypeExpr` is an ordinary type expression in the current generic scope.
  6. `T: Foo + Bar` syntax does not exist. Repeated obligations stay as repeated comma-separated `where` entries.
  7. Equality obligations are checked after ordinary canonicalization, alias expansion, and associated-type projection normalization under D190.
  8. Duplicate obligations are compile-time errors. Contradictory obligations are compile-time errors.
  9. Value-level predicates do not belong in `where`; they belong in contracts or other explicit compile-time checks.
  **Why this fits Kyokai**: one bounded grammar keeps generic obligations readable, scales to associated-type constraints, and avoids a second mini-language of open-ended generic logic.
  **[STAGE: DECIDED_CORE_SEMANTICS | D189 -> one closed `where` grammar for trait bounds, associated-type bounds, and associated-type equality constraints]**
- **There is no general `Cloneable` typeclass — deep duplication remains type-specific and allocator-visible rather than becoming a blanket generic promise** — Kyokai distinguishes ordinary `Free` copy semantics from explicit creation of fresh owned duplicates.
**Rules**:
  1. The standard library defines no `Cloneable[T]` typeclass and the language provides no implicit deep-copy hook.
  2. Ordinary copy/discard behavior for `Free` values remains exactly the universe rule from D195; it is not a user-extensible cloning mechanism.
  3. Any API that creates a fresh owned duplicate of existing data is explicit and type-specific.
  4. If producing the duplicate may allocate, the API must take an explicit destination allocator and use the `...In` naming pattern from D201, for example `cloneIn(&!alloc)`.
  5. Generic code may not assume it can duplicate arbitrary `T` values unless the caller explicitly supplies the duplication operation or the concrete type's API is named directly.
  6. Linear resource types do not gain a blanket duplication escape hatch through typeclass bounds.
  **Why this fits Kyokai**: duplication cost, allocation, and ownership effects stay visible in the API that actually performs them instead of being smuggled in as a generic convenience bound.
  **[STAGE: DECIDED_CORE_SEMANTICS | D176 → no general `Cloneable` typeclass; deep duplication remains explicit, type-specific, and allocator-taking when allocation is required]**
- **There is no `Default[T]` typeclass and no generic "fabricate a value from nothing" surface** — Kyokai does not normalize partially initialized or sentinel-driven generic programming into a language trait.
**Rules**:
  1. The standard library defines no `Default[T]` typeclass and no derive-like defaulting surface.
  2. Generic code may not demand an ambient zero, empty, or sentinel value for `T`.
  3. Empty, zero, or initial values are expressed through explicit constructors, builder APIs, named constants, or caller-supplied values/callbacks.
  4. Collection and buffer APIs that need element initialization must take the element value, initialization callback, or construction operation explicitly; they do not silently fill with `T.default()`.
  5. A zero bit pattern is not a language-level value-construction rule. If some concrete type supports zero-initialized construction, that fact must be exposed by an explicit API of that type.
  **Why this fits Kyokai**: generics stay honest about where values come from, and the language does not create a universal escape hatch for half-initialized states or magic empty values.
  **[STAGE: DECIDED_CORE_SEMANTICS | D177 → no `Default[T]`; generic code must use explicit constructors, constants, or caller-supplied initialization]**
- **Call-site generic type argument inference is argument-driven, forward-only, and local to the call** — Kyokai allows useful omission of explicit type arguments when the call's inputs already determine them, but it does not let return-type context or surrounding expression context silently solve generics from a distance.
**Rules**:
  1. If a call omits explicit type arguments, the compiler may infer them only from the receiver and explicit value arguments of that call after ordinary desugaring such as UFCS.
  2. Inference proceeds left to right through the desugared call argument list.
  3. Earlier arguments may constrain later arguments. Later arguments do not retroactively reinterpret earlier argument expressions.
  4. Expected return type, assignment target type, enclosing expression context, pattern context, and surrounding generic obligations do not participate in solving omitted type arguments.
  5. Literal typing under D12 may use type arguments already solved from earlier arguments in the same call.
  6. If argument-side information leaves any omitted type parameter unsolved or ambiguous, the call is a compile-time error and the programmer must supply explicit type arguments.
  7. This rule applies uniformly to ordinary function calls, UFCS calls, generic constructors, and typeclass method calls after desugaring.
  8. Assignment target type, `let` binding annotation, typed receiving parameter, enclosing match arm type, and any other expected-result context do not solve omitted type arguments.
  9. Therefore a call such as `let buf: Buffer[Int32] := Buffer.new(alloc);` is legal without explicit type arguments only when `alloc` and any earlier explicit call arguments already determine `Int32` under rules 1 through 7.
  **Why this fits Kyokai**: common ergonomic cases such as `buf.push(42)` work, but inference stays local, predictable, and free of hidden backward reasoning from the surrounding context.
  **[DECIDED: D209/D161 → forward-only, argument-driven, left-to-right generic type argument inference; no return-context, target-type, or surrounding-expression inference]**
- **Temporaries live for the statement that created them, and immutable borrows of rvalues are allowed only within that statement** — Kyokai makes temporary lifetime extension explicit and narrow enough that numeric code stays readable without allowing borrowed temporaries to leak into longer-lived state.
**Rules**:
  1. A temporary created while evaluating a statement lives until that statement completes, unless a more local rule is explicitly stated elsewhere in the language.
  2. Immutable borrowing of an rvalue temporary is allowed within that statement when the borrow is used immediately and does not escape.
  3. Mutable borrowing of an rvalue temporary is illegal.
  4. A borrow of a temporary may not escape the statement. It cannot be stored in a local, returned, captured into a longer-lived structure, or otherwise given a lifetime beyond the statement that created the temporary.
  5. String literals and other static literals may be borrowed as `Static` data because their storage duration is defined directly by the language.
  6. `defer` captures the values and borrows visible at registration time; it does not retroactively extend the lifetime of a temporary that would otherwise be illegal to borrow.
  **Examples**:
  - Legal: `let n := norm(a + b);`
  - Legal: `let y := (m * v) + w;`
  - Illegal: `let r := &(a + b);`
  - Illegal: `return &(m * v);`
  - Illegal: `foo(&!makeBuffer());`
  **Why this fits Kyokai**: the rule is simple enough to read mechanically, supports terse math-heavy expressions, and still forbids the hidden lifetime extension behavior that makes temporary borrowing hard to audit.
  **[STAGE: DECIDED_CORE_SEMANTICS | D72 → statement-scoped temporaries; immutable rvalue borrows may not escape]**
- **UFCS does not bypass D72's rvalue-temporary borrow ban** — dot syntax stays pure desugaring, so a mutating UFCS call on an rvalue is illegal for the same reason the equivalent ordinary call is illegal.
**Rules**:
  1. If `expr.f(args)` desugars to a call whose first parameter requires `&![T]`, `expr` may not be an rvalue temporary.
  2. Therefore `getBuffer().push(42)` is a compile-time error whenever `push` expects `&![Buffer[Int32]]`.
  3. The programmer must bind the rvalue to a local first before making the mutating call.
  4. UFCS on rvalues remains legal for consuming receivers (`self: T`) and immutable-borrow receivers (`&[T]`) when the ordinary D72 temporary rules are satisfied.
  **Why this fits Kyokai**: UFCS remains one exact rewrite rule, and D72 remains the single source of truth for temporary-borrow legality.
  **[STAGE: DECIDED_CORE_SEMANTICS | D213 → mutating UFCS calls on rvalue temporaries are type errors; bind first; consuming and immutable-borrow UFCS remain legal subject to D72]**
- **Surface sugar, implicit completions, and linearity checks run in one fixed semantic order** — Kyokai does not leave desugaring order to compiler folklore or let implicit operations interact differently depending on implementation details.
**Compiler semantic order**:
  1. Parse source into a surface AST. No implicit operations are inserted during parsing.
  2. Resolve modules, imports, visibility, and names enough to reject import/name ambiguity.
  3. Perform syntax-only lowering for constructs whose meaning does not depend on types, including block-form normalization and UFCS call-shape parsing into an unresolved call-with-receiver node.
  4. Type-check and elaborate expressions, resolving overloads, generic arguments, literal types, expected-type sites, pattern types, and D254 receiver-module UFCS lookup.
  5. Insert only the closed set of D87-approved implicit completions: auto-borrow, auto-reborrow, mutable-to-immutable read reborrow, one-level field auto-deref, implicit `Unit` fallthrough, `Never` expression-site coercion, literal typing, and approved `let :=` inference.
  6. Record every inserted implicit completion as an explicit elaboration node with its source span and rule id.
  7. Assemble the closed package graph needed for typeclass and interface facts: imports, visible instances, dependency `.koi` metadata, local instance declarations, and any typeclass-dependent declarations exposed by the selected target and feature set.
  8. Run the D239 tautology-check pass over the recorded elaboration nodes after that closed graph exists.
  9. Lower typed sugar such as `or return`, `let...else`, and `while let` into the checked core form while preserving the recorded ownership and pattern obligations.
  10. Run linearity, borrow, exhaustiveness, and capability checks on the elaborated core, not on the raw surface AST.
  11. Backend lowering starts only after these checks succeed.
  **Why this fits Kyokai**: programmers and compiler implementers can reason about one pipeline. Sugar becomes explicit before ownership checking, and every implicit completion is made auditable before backend lowering.
  **[STAGE: DECIDED_CORE_SEMANTICS | D238 → fixed syntax-lowering and typed-elaboration order before linearity]**
- **Every D87 implicit completion is recorded and checked by a mandatory tautology-check pass** — Kyokai's implicit-operation rule is a compiler invariant, not a style promise.
**Rules**:
  1. The compiler maintains a closed registry of all implicit completions admitted by D87.
  2. Each inserted completion records its rule id, source span, expected type or syntactic context, inserted core operation, and the source construct that required it.
  3. For each inserted completion, the tautology-check pass verifies that the operation is uniquely determined by the static types and surrounding context.
  4. The pass verifies that every alternative interpretation of the same source expression is statically ill-typed.
  5. The pass verifies that the insertion adds no allocation, side effect, blocking operation, capability use, or new control-flow edge beyond what the explicit source construct already implies.
  6. The pass runs after imports, target/feature selection, local instance discovery, dependency `.koi` loading, and typeclass coherence assembly, so typeclass-dependent completions are checked against the real closed dependency graph being compiled.
  7. If adding or updating a dependency introduces an instance, interface fact, target fact, or feature-selected declaration that makes a recorded completion no longer unique, the package is rejected at compile time.
  8. A compilation unit is rejected if any implicit insertion lacks a registry entry or fails one of the listed obligations.
  9. Adding a new implicit completion to Kyokai requires a new D-point or an explicit update to an existing D-point, plus a registry entry and conformance tests.
  **Why this fits Kyokai**: D87 becomes mechanically enforceable. The compiler cannot quietly grow new implicit behavior merely because an implementation shortcut was convenient.
  **[STAGE: DECIDED_CORE_SEMANTICS | D239/D278 → compiler-maintained implicit-completion registry plus mandatory tautology-check pass over the closed package/typeclass/.koi graph]**
- **Auto-reborrow and mutable-to-immutable read reborrow require a conformance matrix over the elaborated core** — the ergonomic removal of `&~` is allowed only because the compiler proves and tests that the explicit borrow core remains sound.
**Required conformance coverage**:
  1. Owned value to immutable borrow.
  2. Owned value to mutable borrow.
  3. Mutable reference to mutable reborrow.
  4. Mutable reference to immutable read reborrow.
  5. Rejection of immutable reference to mutable borrow.
  6. Nested calls where temporary reborrows end at the correct statement boundary.
  7. Rejection of overlapping mutable reborrows.
  8. Suspension of the original mutable borrow while a read reborrow is live.
  9. Interaction with UFCS after desugaring.
  10. Interaction with `or return`, `defer`, and early exits.
  11. Rejection of escaped temporaries or returned reborrowed references.
**Rules**:
  1. The linearity checker must see explicit elaborated borrow/reborrow nodes.
  2. Auto-reborrow may never be implemented as a post-linearity backend trick.
  3. These requirements are compiler/toolchain conformance obligations. They do not add syntax or call-site verbosity to user programs.
  **Why this fits Kyokai**: the surface program stays readable, while the proof burden moves to the compiler tests where it belongs.
  **[STAGE: DECIDED_CORE_SEMANTICS | D240 → mandatory conformance matrix for auto-reborrow and read-reborrow soundness]**
- **Kyokai has no language-level undefined behavior, and unsafe exists only as a tiny set of individually specified primitives** — the language does not expose a general “here be dragons” escape hatch whose semantics are left to backend folklore.
**Rules**:
  1. For every program the Kyokai compiler accepts, the language semantics define the outcome of every Kyokai operation in that program. There is no open-ended language-level UB category in either safe or unsafe Kyokai.
  2. `unsafe` does not mean “anything can happen.” It means the programmer is using an operation whose preconditions and effects are explicitly specified and whose misuse may trigger a specified failure mode such as TPOE or runtime-fatal termination.
  3. Unsafe memory operations are exposed only through individually specified intrinsics, primitives, or FFI wrappers. If an operation cannot yet be specified precisely, it is not part of Kyokai.
  4. Kyokai does not include a general `transmute`, general type punning primitive, arbitrary pointer-to-integer / integer-to-pointer roundtrip, or any other blanket reinterpretation escape hatch.
  5. Safe Kyokai code cannot observe uninitialized memory, violate alignment, forge references, or access storage through an incompatible representation.
  6. Any future primitive dealing with raw addresses, initialization state, byte copying, unaligned access, or representation reinterpretation must state its exact alignment, provenance, lifetime, and initialization rules in the language or toolchain spec before it ships.
  7. The C backend must preserve Kyokai semantics for valid Kyokai programs without relying on C undefined behavior. If the backend needs low-level implementation tricks, it must use C patterns whose behavior is defined under the selected toolchain contract.
  8. The FFI boundary is a trust boundary. Once control enters foreign code, Kyokai's no-UB guarantee applies only to the Kyokai side of the boundary and to foreign behavior that the wrapper contract explicitly models.
  **Why this fits Kyokai**: zero UB is one of the language's unbreakable rules. The only honest way to keep that rule is to keep unsafe tiny, explicit, and fully specified rather than importing the open-ended unsafe folklore of C-family systems languages.
  **[STAGE: DECIDED_CORE_SEMANTICS | D73 → no language-level UB; only individually specified unsafe primitives; FFI is the external trust boundary]**
- **The C backend is constrained by a defined generated-C contract, and UB avoidance is enforced by both code-generation rules and required compiler flags** — Kyokai does not trust backend folklore or host-optimizer luck as its safety story.
**Rules**:
  1. Ordinary generated C for valid Kyokai programs must stay within a defined C11-compatible subset unless the selected target toolchain contract explicitly admits a named extension or intrinsic family for that backend path.
  2. The selected C compiler family, version floor, required flags, and any admitted extension families are part of the target toolchain contract under D31, D80, and D86.
  3. The C backend must preserve D71 evaluation order explicitly. It may not rely on unspecified C expression evaluation order; when needed, it introduces temporaries and statement sequencing in generated C.
  4. Kyokai integer semantics must not be defined by host-C overflow behavior. Checked arithmetic lowers to explicit checks or checked intrinsics, and the resulting TPOE behavior comes from those checks rather than from `-fwrapv`.
  5. The C backend must not emit strict-aliasing violations. Representation reinterpretation, byte copying, and type punning use `memcpy`-style or equally defined patterns only.
  6. The C backend must not emit UB-producing shifts, division/modulo by zero, uninitialized reads, or misaligned typed accesses for valid Kyokai programs. If a Kyokai operation violates its own contract, the generated code must produce the Kyokai-specified failure behavior instead.
  7. For the GCC and Clang support contract, the required defensive flags include at least `-std=c11`, `-fwrapv`, `-fno-strict-aliasing`, and `-fno-delete-null-pointer-checks`.
  8. If the backend cannot emit conforming C for the selected source construct, target, backend path, and supported C toolchain contract, the build fails. It does not silently weaken Kyokai semantics.
  9. The toolchain may define an explicit extra-assurance C-backend profile using CompCert where target support and emitted-C subset compatibility exist. Such a profile is additional assurance, not the baseline requirement for every Kyokai target.
  **Why this fits Kyokai**: the zero-UB rule remains a real backend contract instead of dissolving into "probably okay on GCC/Clang," while C emission stays valuable for bootstrap and portability work.
  **[STAGE: DECIDED_CORE_SEMANTICS | D139 → C backend must emit UB-free C under an explicit supported-toolchain contract; GCC/Clang defensive flags are mandatory; CompCert may exist as an explicit extra-assurance profile]**
- **Lowering from elaborated Kyokai to any backend must preserve Kyokai outcomes without relying on backend undefined behavior** — backend IR, generated C, LLVM metadata, and optimization choices are implementation tools, not sources of language semantics.
**Rules**:
  1. Lowering from elaborated Kyokai into C, LLVM IR, or any later backend must preserve the source program's specified Kyokai outcomes.
  2. Backend undefined behavior, LLVM `poison`/`undef`, C signed overflow, invalid aliasing assumptions, unchecked trap-producing operations, or unreachable assumptions may not be used as the mechanism for implementing safe Kyokai semantics.
  3. TPOE and runtime-fatal paths lower to explicit no-return termination operations or checked branches whose existence cannot be optimized away by assuming the failed condition is impossible.
  4. The compiler may attach aliasing, lifetime, `noalias`, alignment, initialization, or non-null metadata only when justified by the elaborated borrow, linearity, and type model.
  5. If the compiler cannot justify stronger backend metadata for a construct, it must omit the metadata or fail the build rather than silently weakening Kyokai semantics.
  6. Surface constructs with specified desugarings must lower through the D238 elaboration pipeline before linearity, borrow, capability, and backend-lowering checks rely on them.
  7. Backend optimizations may remove redundant checks only after proving the removed failure path is unreachable under Kyokai semantics, not because the target backend would treat the failing case as undefined.
  **Why this fits Kyokai**: zero language-level UB is only meaningful if code generation cannot reintroduce UB as an optimizer assumption behind the user's back.
  **[STAGE: DECIDED_CORE_SEMANTICS | D228 → defined lowering contract: backend lowering preserves Kyokai semantics and cannot rely on backend UB]**
- **Volatile memory access exists as an unsafe operation-level primitive for MMIO and other externally observable memory, not as a general type qualifier and not as synchronization** — Kyokai chooses Rust-style explicit volatile operations rather than C/Zig-style volatile-in-the-type-system propagation.
**Rules**:
  1. `readVolatile(addr: Address[T]): T` and `writeVolatile(addr: Address[T], value: T): Unit` are unsafe built-in operations available only in `pragma Unsafe_Module` code.
  2. A volatile access is externally observable. The compiler may not elide it, merge it with another volatile access, or move another volatile access across it.
  3. Volatile is not synchronization. It creates no happens-before edges and does not replace atomics, fences, mutexes, or channels for inter-thread communication.
  4. The volatile-legal type domain is closed: fixed-width integer types, `Bool`, raw address/pointer-like machine values explicitly admitted by the FFI/memory model, and `extern record` / `packed record` aggregates whose fields are recursively volatile-legal.
  5. Ordinary `record`, `union`, borrow/reference, capability, and `Linear` resource types are not volatile-legal unless a separate decision admits them explicitly.
  6. Volatile operations require naturally aligned addresses for `T` unless a separately specified unaligned volatile primitive is used.
  7. If the address is invalid, misaligned, unmapped, or otherwise faults at the hardware/runtime level, the result is runtime-fatal termination, not language-level UB.
  8. The C backend lowers volatile operations through C `volatile` loads/stores for the admitted type domain. The LLVM backend lowers them through LLVM volatile load/store operations. Backend lowering must preserve the language contract in either case.
  9. Kyokai does not add a `volatile &[T]` or `volatile &![T]` reference kind. Volatile semantics belong to the access operation itself.
  **Why this fits Kyokai**: MMIO and other externally observed accesses are available where systems code needs them, but the language avoids infecting the entire type system with C-style volatile folklore or pretending volatile has synchronization meaning it does not actually have.
  **[STAGE: DECIDED_CORE_SEMANTICS | D94/D257 → unsafe operation-level volatile access only; explicit non-synchronization contract; closed volatile-legal type domain]**
- **Moves have as-if bytewise relocation semantics, and safe movable values may not depend on their own address** — Kyokai's move model is explicit and backend-independent rather than left to folklore about what "ownership transfer" means physically.
**Rules**:
  1. Moving a value has as-if bytewise relocation semantics: the destination receives the exact representation bytes of the source value, and the source location becomes logically dead immediately after the move.
  2. The language contract is the as-if rule, not a requirement that the backend literally emit a `memcpy` call at every move site.
  3. The compiler may optimize moves away, fuse them, lower them to hidden output pointers, or keep values in registers, provided observable behavior matches the as-if bytewise relocation model.
  4. Safe code may not define or construct ordinary movable values whose validity depends on the stable address of their own storage. Self-referential values are therefore banned in safe code.
  5. Unsafe code may construct self-referential structures using raw addresses, but ordinary safe move semantics still apply unless a separate rule provides stable-address indirection or a non-movable type property.
  6. The C backend must preserve this language contract using C patterns with defined behavior; struct assignment and `memcpy`-style lowering are implementation techniques, not the language definition.
  **Why this fits Kyokai**: the programmer gets an explicit physical model for moves without tying the language to one backend primitive spelling, and the self-referentiality ban follows directly from that model instead of being folklore.
  **[STAGE: DECIDED_CORE_SEMANTICS | D89 → as-if bytewise relocation semantics; safe self-referential values banned]**
- **Large return values use guaranteed direct result placement; no build profile may reintroduce a mandatory full-width return copy** — Kyokai treats this as part of the concrete value-semantics performance contract, not as optimizer luck.
**Rules**:
  1. If a function's return type has size greater than two machine words on the selected target, the implementation must use direct result placement semantics for that return.
  2. Under direct result placement semantics, the callee initializes storage that is already designated as the caller's final result object. The implementation must not require an additional full-width relocation of that completed result merely to hand it back to the caller.
  3. This guarantee is independent of optimization level, debug-vs-release profile, and backend choice.
  4. For return types of size two machine words or smaller, the implementation may use registers, direct result placement, or another equivalent lowering, provided D89's as-if move semantics are preserved.
  5. Direct result placement does not create a safe-language stable-address guarantee and does not weaken D89's ban on ordinary self-referential movable values. It is a calling/result-lowering rule, not a pinning rule.
  6. Backends may still eliminate intermediate temporaries, keep parts of a result in registers, or lower the calling convention however they like, so long as rules 1 through 5 hold.
  **Why this fits Kyokai**: large value returns stop depending on optimization folklore, but the rule adds no hidden control flow, allocation, or side effects. It only forbids wasteful lowerings that would contradict the explicit move model.
  **[STAGE: DECIDED_CORE_SEMANTICS | D199 → guaranteed direct result placement for return types larger than two machine words; no profile/backends may reintroduce a mandatory full-width return copy]**
- **Unsafe code may not hand a movable self-referential value directly to safe code; crossing the unsafe→safe boundary requires stable-address indirection** — the unsafe boundary contract closes the soundness hole created by D89's move model without pretending the compiler already enforces first-class pinning.
**Rules**:
  1. If unsafe code constructs a self-referential value whose internal validity depends on its storage address, that value MUST cross into safe code only through a stable-address indirection container.
  2. For this rule, a stable-address indirection container is an owning value whose own move does not relocate the pointee storage.
  3. `Box[T]` is such a container for purposes of this rule: moving a `Box[T]` never relocates the boxed `T` value.
  4. A stable-address indirection container used for this rule must not provide a safe operation that extracts the protected self-referential pointee by value in a way that would relocate it. Safe access is by borrow/reference to the pointee, not by moving the pointee back out.
  5. Returning or otherwise exposing a bare movable self-referential value from `pragma Unsafe_Module` to safe code is a violation of the unsafe contract.
  6. This rule is part of the unsafe boundary specification. The compiler does not currently prove it automatically.
  7. D89b separately defines Kyokai's first-class pinned-type model; D89a remains the minimum unsafe-boundary rule even when no declaration-site pinned type is involved.
  **Why this fits Kyokai**: the current soundness hole is closed with an explicit boundary rule that is simple to audit, and the needed container semantics are stated directly instead of being left implicit in the name `Box`.
  **[STAGE: DECIDED_CORE_SEMANTICS | D89a → stable-address indirection required across unsafe→safe self-reference boundary; `Box[T]` gives non-relocating pointee storage for this purpose; first-class pinned types are defined in D89b]**
- **Kyokai has explicit declaration-site pinned types and a dedicated pinned owner; ordinary `Box[T]` remains ordinary indirection** — address stability is opt-in, visible in the type declaration, and enforced by ordinary move-checking rules rather than hidden wrapper magic.
**Rules**:
  1. Kyokai adds a declaration-site `pinned` modifier on aggregate type declarations: `pinned record` and `pinned union`.
  2. A type declared `pinned` does not participate in ordinary move semantics. Any safe operation that would relocate a pinned value is a compile-time error.
  3. Relocation-forbidden operations include passing a pinned value by value, returning it by value, assigning it by value after initialization, swapping it by value, destructuring or pattern-moving it, extracting one of its fields by value, and storing it inline in storage whose safe operations may later relocate elements.
  4. Borrows of pinned values use the ordinary reference types `&[T]` and `&![T]`. Kyokai does not add a separate `Pin[&![T]]`, `Pin[Box[T]]`, or other wrapper-based borrow family.
  5. A type that contains a pinned field inline MUST itself be declared `pinned`.
  6. `Movable` is the intrinsic opposite of `pinned`: types are movable unless declared `pinned`. Generic code may perform by-value relocation only for `T: Movable`.
  7. Any standard-library or user-defined container whose safe operations may relocate stored elements MUST require `T: Movable` for inline storage. Pinned values may appear there only behind indirection or by borrow.
  8. Safe construction of a pinned value must place it directly into its final storage location. Safe code may not construct a pinned temporary and then rely on an implicit move into place.
  9. Kyokai provides `PinBox[T]` as an owning stable-address container for pinned values. Moving a `PinBox[T]` never relocates the pointee.
  10. `PinBox[T]` must construct and destroy the pointee in place and must not provide a safe operation that extracts the pointee by value.
  11. `Box[T]` remains ordinary owning indirection. It gives separate pointee storage, but it does not itself mean "pinned" and it does not silently add a non-movable language rule.
  12. An ordinary `Box[T]` API that moves the pointee out by value, such as `unbox`, is available only when `T: Movable`.
  13. D89a's unsafe-boundary rule remains in force independently: unsafe code may pass address-sensitive ordinary types into safe code only through stable-address indirection, and safe code must not move such protected pointees out by value.
  **Why this fits Kyokai**: both mechanisms exist, but they stay explicit. `Box[T]` keeps its ordinary physical meaning, while first-class non-movability becomes a declaration-site-visible rule set that is easy to audit and much simpler than Rust's `Pin<P>` wrapper layering.
  **[DECIDED: D89b → declaration-site `pinned` types plus `PinBox[T]`; plain `Box[T]` remains ordinary indirection; relocating generics and containers require `Movable`]**
- **Out-of-memory is an explicit resource failure in ordinary APIs, not a hidden abort and not ordinary TPOE** — Kyokai treats allocation failure as a first-class error case unless an API deliberately opts into a stronger contract with a clearly visible name.
**Rules**:
  1. Ordinary allocating standard-library APIs return `Result[..., AllocError]`.
  2. OOM is not ordinary TPOE by default, because allocation failure is a resource failure rather than a violated programmer contract.
  3. If the standard library provides fatal-on-OOM convenience operations, they must be explicitly named as such (`mustReserve`, `mustPush`, `mustCreate`, or equivalent) rather than silently serving as the default API surface.
  4. Explicit fatal-on-OOM convenience operations terminate through D84's runtime-fatal category, not through hidden abort behavior and not through ordinary contract-failure TPOE wording.
  5. Zero-sized allocation requests are legal. They return a stable non-null token suitable for later deallocation with the same allocator/layout contract, but not for ordinary dereference.
  6. Reallocation failure leaves the original allocation valid, owned by the caller, and unchanged.
  7. `AllocError` is for allocation failure under a valid request. Passing an invalid size, alignment, layout, or allocator object to a low-level allocation primitive is a contract violation and triggers TPOE unless that API explicitly says otherwise.
  **Why this fits Kyokai**: hidden abort-on-OOM violates “no hidden control flow,” while treating every allocation failure as TPOE confuses resource exhaustion with programmer error. Fallible-by-default APIs keep failure visible and auditable without weakening the runtime model.
  **[STAGE: DECIDED_CORE_SEMANTICS | D74 → `AllocError` by default; explicit named fatal variants only; zero-size and realloc-failure semantics specified]**
- **Operator overloading exists only through a fixed built-in family of operator typeclasses** — Kyokai allows math-friendly operator syntax for conventional arithmetic and comparison, but it does not allow custom operator tokens, custom precedence, or arbitrary syntax-level dispatch tricks.
**Built-in operator families**:
  1. Arithmetic operators `+`, binary `-`, `*`, `/`, and unary `-` map to fixed standard typeclasses such as `Add`, `Sub`, `Mul`, `Div`, and `Neg`.
  2. Comparison operators `==`, `!=`, `<`, `<=`, `>`, and `>=` map to the standard comparison typeclasses (`Equality` and `TotalOrder`).
  3. Indexing, assignment, boolean short-circuiting, borrow syntax, field access, and any future custom operator token are outside this decision and are not user-overloadable unless a separate decision explicitly adds them.
  **Typeclass shape**:
  ```kyokai
  typeclass Add(Lhs: Type, Rhs: Type) is
      type Output;
      method add(lhs: &[Lhs], rhs: &[Rhs]): Output;
  spec;
  ```
  **Rules**:
  1. Only the language-defined operator slots may be overloaded. Users cannot declare new operators or change precedence/fixity.
  2. Overloaded arithmetic operators dispatch through their fixed standard typeclasses and associated `Output` type.
  3. Overloaded arithmetic operators receive immutable borrows of their operands by default. They are read-only, non-consuming operations.
  4. Operations that mutate or consume values must use named functions or methods such as `addAssign`, `scaleInPlace`, or `intoProduct`; they do not hide behind symbolic operators.
  5. No implicit numeric conversions are introduced by operator overloading. Operand types must already match some legal instance.
  6. D81 coherence applies: for any concrete operand types, there must be exactly one applicable operator instance.
  7. Diagnostics for operator resolution failures must report the fixed operator family involved and the candidate operand/output types.
  **Why this fits Kyokai**: numeric and matrix code stays compact, but the set of operator meanings is closed, mechanically knowable, and tied to standard typeclasses rather than user-invented syntax.
  **[STAGE: DECIDED_CORE_SEMANTICS | D23 → fixed built-in operator typeclasses only]**
- **Kyokai defines multiple runtime termination categories, and each category has its own cleanup and diagnostic contract** — the language does not collapse ordinary exit, explicit `panic`, and contract-violation TPOE into one vague `abort`.
**Termination categories**:
  1. **Ordinary completion**: returning an `ExitCode` from `main` or falling off a `Unit`-returning scope is normal control flow, not a failure mode.
  2. `**panic(message)`**: explicit programmer-requested abnormal termination.
  3. **TPOE**: runtime contract-violation termination, including bounds failures, checked-arithmetic traps, failed `require`/`ensure`, invalid checked narrowing, and any other operation the language classifies as a contract violation.
  4. **Runtime-fatal/internal failure**: hard termination for failures outside the contract system, such as runtime corruption or impossible internal runtime/toolchain failures. This category exists so the spec does not pretend every fatal stop is user-visible TPOE.
  **Rules**:
  1. Ordinary completion runs the normal structured cleanup path for the scopes that exit.
  2. `panic(message)` terminates the whole process and is never recoverable inside Kyokai.
  3. `panic(message)` runs ordinary `defer` cleanup on the scopes it exits before terminating, but it does not become a catchable exception or unwinding mechanism.
  4. TPOE is immediate hard termination. User `defer` code does not run on TPOE.
  5. Runtime-fatal/internal failure follows the same hard-stop contract as TPOE unless a more specific runtime rule explicitly says otherwise.
  6. Neither `panic` nor TPOE may unwind across an FFI boundary. Crossing a foreign boundary with language-level unwinding is not part of Kyokai.
  7. `panic` and TPOE may emit a best-effort diagnostic message before termination, but stack trace format, debug metadata policy, and other diagnostic presentation details belong to the debugging/toolchain contract rather than the core language semantics.
  8. Program exit by `ExitCode` is semantically distinct from `panic` and TPOE even if an operating system ultimately represents all three outcomes with process exit codes.
  9. The exact numeric exit-code conventions for runtime-reserved failures belong to the toolchain/runtime contract, not the core language.
  **Why this fits Kyokai**: the programmer can tell the difference between an expected return, an explicit "stop now" request, and a contract failure that invalidates the current execution. The language stays explicit without drifting into exception-style recovery semantics.
  **[STAGE: DECIDED_CORE_SEMANTICS | D84 → explicit split between ordinary exit, `panic`, TPOE, and runtime-fatal termination]**
- **Fault isolation is process-supervision, not in-process catching of `panic` or TPOE** — Kyokai preserves D84's hard-stop semantics while still giving high-availability software an explicit architecture for isolating faulty work.
**Rules**:
  1. Kyokai provides no `catch panic`, `catch TPOE`, in-process panic recovery, task-level fault recovery, or ordinary structured-concurrency recovery from D84 fatal categories.
  2. A Kyokai task, OS thread, channel, `select`, `Poller`, or structured-concurrency scope is not a fault-isolation boundary.
  3. Malformed external input must be handled as ordinary data through parsing, validation, and `Result`, not by relying on contract failure and recovery.
  4. The standard fault-isolation mechanism for servers and other high-availability systems is supervised OS worker processes.
  5. A supervisor process may spawn workers through D178 `ProcessCapability`, communicate through explicit IPC/channel-like APIs, observe worker exit status, and restart workers according to an explicit policy.
  6. Capabilities do not cross into a worker implicitly. Any authority granted to a worker must be passed explicitly through worker configuration or the worker bootstrap/IPC protocol.
  7. Worker crash, `panic`, TPOE, runtime-fatal termination, or abnormal OS termination is reported to the supervisor as ordinary process-status data.
  8. Kyokai does not define in-process isolates in the core language. If in-process isolates are ever added, they require a separate D-point covering isolated heaps, capability membranes, FFI restrictions, resource limits, scheduler interaction, and termination semantics.
  **Why this fits Kyokai**: a contract failure means the current execution is invalid. The language should not fake recovery inside the same execution context; the honest boundary is another process with explicit authority and IPC.
  **[STAGE: DECIDED_CORE_SEMANTICS | D253 → no in-process catch for `panic`/TPOE; fault isolation uses supervised OS worker processes]**
- **Stack overflow is never language-level UB on a conforming Kyokai target; it is a defined runtime-fatal termination that must be detected before silent corruption on both hosted and freestanding targets** — Kyokai does not weaken its safety story at the exact boundary where systems targets are most vulnerable.
**Rules**:
  1. Safe Kyokai stack overflow is never language-level UB.
  2. Stack overflow enters D84's runtime-fatal/internal-failure category, not ordinary TPOE. It is an abstract-machine failure rather than a violated programmer contract.
  3. Hosted targets must guarantee detection before silent stack corruption. Guard pages alone are sufficient only when the target/runtime contract guarantees they cannot be skipped by large frame growth; otherwise stack probing or an equivalent mechanism is required.
  4. Freestanding targets must also guarantee detection before silent stack corruption. A conforming freestanding Kyokai target must provide an explicit stack-bounds contract that the runtime/toolchain can enforce.
  5. Stack-bound enforcement on freestanding targets is part of target conformance, not an optional safety flag. If a target configuration cannot provide the required enforcement, it is not a conforming safe Kyokai target.
  6. Runtime/toolchain mechanisms for this enforcement may include guard pages, stack probes, explicit bound checks, fixed-limit metadata, or any equivalent implementation technique, provided the observable language contract remains the same.
  7. The exact probe sequence, page size strategy, linker symbol names, and other implementation details belong to the toolchain/runtime contract, but they may not weaken rules 1 through 5.
  **Why this fits Kyokai**: the language keeps its zero-UB guarantee intact on embedded and hosted systems alike, while still leaving backend/runtime engineers freedom in how they implement the necessary checks.
  **[STAGE: DECIDED_CORE_SEMANTICS | D115/D262 → stack overflow is runtime-fatal, never UB; hosted and freestanding targets must detect before corruption using guard pages, probes, bounds checks, or equivalent enforcement]**
- **Program startup inputs are passed explicitly to `main`, not exposed through ambient global functions** — command-line arguments are ordinary program inputs and therefore belong in the entry-point signature instead of being readable from anywhere in the program.
**Syntax**:
  ```kyokai
  function main(root: RootCapability, args: &[Span[String]]): ExitCode is
      // ...
  qed;
  ```
  **Rules**:
  1. The program entry point receives the root capability and the command-line argument list explicitly.
  2. `args` is an immutable borrowed view of the argument vector supplied by the runtime.
  3. The argument list excludes the program name. It contains only the user-supplied command-line arguments.
  4. `ExitCode` is a standard library built-in union, not a raw integer:
    ```kyokai
     union ExitCode is
         case ExitSuccess;
         case ExitFailure(code: Int32);
     build;
    ```
  5. There are no global `argumentCount()` / `nthArgument()` built-ins in Kyokai.
  6. Any code below `main` can observe arguments only if `main` passes them onward explicitly.
  **Why this fits Kyokai**: command-line inputs stop being hidden global state, capability-based startup remains honest, and the program's external inputs are visible in the entry-point signature.
  **[STAGE: DECIDED_CORE_SEMANTICS | D48 → pass CLI arguments explicitly to `main`; no ambient argument globals]**
- **Hosted and freestanding targets both have explicit bootstrap contracts, and user code never constructs `RootCapability`** — startup is part of the language contract, not ambient folklore hiding behind a CRT.
**Rules**:
  1. `RootCapability` has no user-visible constructor. It is minted only by the target's language-defined bootstrap path.
  2. On hosted targets, the toolchain provides the ABI entry shim, gathers the hosted startup inputs required by the target contract, constructs the unique `RootCapability`, materializes `args`, and then calls `main(root, args)`.
  3. Hosted startup glue may be implemented with target-specific CRT or ABI machinery, but that machinery serves one fixed Kyokai startup contract rather than introducing a second ambient runtime semantics.
  4. `SystemAllocator` is not a hidden global and not an implicit extra parameter to `main`. Code obtains it explicitly from `RootCapability` or from another capability or handle whose derivation from the root is itself explicitly specified.
  5. If a target contract does not provide a process heap, the target must not pretend that `SystemAllocator` exists. Allocation availability is an explicit part of target conformance.
  6. On hosted targets, startup must either supply `main` with arguments representable under the language's argument/text contract or terminate before `main` in D84's runtime-fatal/internal-failure category. It may not fabricate lossy or ill-formed `String` values.
  7. On freestanding targets, the target contract defines the raw entry symbol and bootstrap sequence that first acquires the platform inputs and then enters ordinary Kyokai code with a minted `RootCapability`.
  8. After bootstrap hands control to ordinary Kyokai code, startup inputs and authority remain explicit parameters. Freestanding targets do not get ambient globals as a substitute for a hosted CRT.
  **Why this fits Kyokai**: authority has an auditable origin, startup behavior stops being implementation folklore, and freestanding support stays explicit without inventing a hidden general-purpose runtime.
  **[STAGE: DECIDED_CORE_SEMANTICS | D162 → explicit hosted bootstrap to `main(root, args)`; explicit freestanding bootstrap contract; `RootCapability` is minted only by startup; allocator availability is target-contract-defined]**
- **Authority tokens use sealed `capability` declarations and cannot be forged by unsafe modules** — Kyokai makes the unforgeability property explicit instead of relying on ordinary record opacity plus informal unsafe-module discipline.
**Syntax**:
  ```kyokai
  capability RootCapability;
  capability FileCapability;
  capability ProcessCapability;
  ```
**Rules**:
  1. A `capability` declaration defines a linear authority token type with no user-visible constructors, no record fields, and no literal form.
  2. Capability values may be minted only by the language-defined runtime bootstrap or by explicitly specified acquire, split, derive, or surrender/return operations that already require the appropriate parent capability.
  3. `pragma Unsafe_Module` does not grant permission to forge capabilities, bypass capability constructors, manufacture authority from raw bits, or construct a capability by layout knowledge.
  4. Capability construction, derivation, and destruction operations are part of each capability's documented authority contract and must state which parent authority they require.
  5. Unsafe modules may wrap foreign authority only by returning a capability through a specified trusted acquire/constructor path documented in that module's unsafe contract.
  6. A safe or unsafe module that needs new external authority must receive or derive the appropriate capability explicitly; no module may synthesize authority from absence.
  **Why this fits Kyokai**: capability-based security depends on authority tokens being unforgeable even at the unsafe boundary. Unsafe code can perform specified low-level operations, but it does not get to mint ambient authority outside the documented bootstrap/acquire chain.
  **[STAGE: DECIDED_CORE_SEMANTICS | D255 → first-class sealed `capability` declarations; unsafe code cannot construct capabilities directly]**
- `**panic(message)` is the built-in syntax for explicit programmer-requested abnormal termination** — it is not a synonym for TPOE and it is not a general-purpose `abort` primitive with ambiguous cleanup behavior.
**Rules**:
  1. `panic(message)` is a core-language construct, not an ordinary library function.
  2. It enters the `panic` termination category defined by D84.
  3. It is never recoverable inside Kyokai.
  4. It runs ordinary `defer` cleanup exactly as specified by D84 and D2b.
  5. It does not classify the stop as TPOE; manual programmer-requested termination and runtime contract failure remain different semantic categories.
  6. The message expression must be a string literal or a `String`.
  **Why this fits Kyokai**: the programmer writes an explicit stop request with explicit message text, but the language keeps that path semantically distinct from contract-violation hard failure.
  **[STAGE: DECIDED_CORE_SEMANTICS | D49 → `panic(message)` as built-in explicit abnormal termination]**
- **Hosted `panic` and TPOE have concrete abnormal-termination behavior, while freestanding targets route through an explicit fatal hook** — Kyokai fixes the observable stop path instead of leaving it to backend folklore.
**Rules**:
  1. On hosted targets, `panic`, TPOE, and runtime-fatal/internal failure perform a best-effort diagnostic write to `stderr` before invoking the hosted abnormal-termination primitive.
  2. The hosted diagnostic must preserve the termination category textually at minimum for `panic` versus `TPOE`. Runtime-fatal/internal failure may use its own distinct category label.
  3. Failure to emit the diagnostic does not change the termination path.
  4. After any cleanup already required by D84 has completed, hosted abnormal termination proceeds through the target's abnormal-termination primitive rather than through ordinary `ExitCode` return.
  5. On POSIX-like hosted targets, that abnormal-termination primitive is `abort()`.
  6. A non-POSIX hosted target may use an equivalent target-native abnormal-termination primitive only if it preserves D84's no-recovery, no-language-level-unwinding contract.
  7. TPOE does not unwind and does not run user `defer`; `panic` runs only the `defer` cleanup already required by D84 before the abnormal-termination primitive is invoked.
  8. On freestanding targets, `panic`, TPOE, and runtime-fatal/internal failure transfer control to the target's fatal-termination hook rather than assuming `stderr` or `abort()` exists.
  9. That freestanding fatal hook must be non-returning and must receive enough information to distinguish at least `panic` from `TPOE`, plus the diagnostic message text.
  10. Numeric exit-code conventions for these fatal paths remain toolchain/runtime policy under D84 rather than new core-language semantics.
  11. Backtrace capture and formatting remain governed by D170 and do not alter the concrete termination primitive defined here.
  **Why this fits Kyokai**: process-fatal paths become observable and portable at the semantic level without collapsing distinct failure categories into one vague “abort somehow” rule.
  **[STAGE: DECIDED_CORE_SEMANTICS | D163 → hosted fatal paths are best-effort `stderr` diagnostics plus abnormal termination; freestanding fatal paths go through a non-returning target hook carrying category + message]**
- **Freestanding fatal termination uses one compiler-known root-module hook with a fixed signature** — Kyokai gives bare-metal and kernel targets an explicit non-returning customization point without splitting fatal behavior across multiple ad hoc names or attributes.
**Syntax**:
  ```kyokai
  union FatalKind is
      case Panic;
      case Tpoe;
      case RuntimeFatal;
  build;

  function fatalHandler(kind: FatalKind, message: &[String], trace: Optional[Backtrace]): Never;
  ```
  **Rules**:
  1. `fatalHandler` is a reserved root-module hook name for freestanding executable targets.
  2. On freestanding targets, every fatal termination path from `panic`, TPOE, and runtime-fatal/internal failure transfers control to `fatalHandler`.
  3. `fatalHandler` must be non-returning.
  4. `kind` distinguishes at least `Panic`, `Tpoe`, and `RuntimeFatal`.
  5. `message` is the fatal diagnostic text prepared under D163.
  6. `trace` carries backtrace data when D170 says one exists on the current target and build; otherwise it is `None`.
  7. Missing `fatalHandler` on a freestanding executable target is a compile-time error.
  8. A `fatalHandler` declaration with the wrong signature is a compile-time error.
  9. Hosted targets do not consult `fatalHandler` for language-level fatal termination.
  10. Kyokai does not add a second handler name for TPOE versus panic. `FatalKind` is the explicit distinction surface.
  **Why this fits Kyokai**: freestanding targets get an explicit hook that can log over UART, halt, reset, or trap, but the language keeps one visible fatal path and one mechanically checkable signature.
  **[STAGE: DECIDED_CORE_SEMANTICS | D169 → reserved root-module `fatalHandler(kind, message, trace): Never` for freestanding fatal termination; missing or mismatched hook is a compile-time error]**
- **Backtrace policy is explicit, build-sensitive on hosted targets, and passed as data on freestanding targets** — Kyokai keeps fatal diagnostics useful without pretending every target has the same trace machinery or hiding policy inside unnamed runtime defaults.
**Rules**:
  1. Backtrace policy applies to `panic`, TPOE, and runtime-fatal/internal failure.
  2. On hosted debug builds, the runtime must attempt to capture and print a backtrace by default.
  3. On hosted test builds, the runtime must also attempt to capture and print a backtrace by default.
  4. On hosted release builds, the runtime attempts to capture and print a backtrace only when `KYOKAI_BACKTRACE=1`.
  5. If backtrace capture is unavailable or fails, termination still proceeds; only the trace is omitted.
  6. The base fatal diagnostic from D163 is emitted regardless of backtrace availability.
  7. `Backtrace` is an opaque runtime/toolchain-defined `Free` value type representing captured stack-trace data for a fatal event.
  8. On freestanding targets, there is no environment-variable-controlled backtrace policy.
  9. Freestanding targets communicate trace availability through the `trace: Optional[Backtrace]` argument passed to `fatalHandler`.
  10. If the freestanding target/runtime cannot produce a trace, it passes `None`.
  11. Textual rendering format, frame metadata policy, symbolization quality, and debugger integration belong to the toolchain/runtime spec under D86 rather than the core language.
  **Why this fits Kyokai**: hosted CLI behavior stays practical, freestanding behavior stays explicit, and the language avoids both silent trace folklore and fake promises that every target can symbolize a stack.
  **[STAGE: DECIDED_CORE_SEMANTICS | D170 → hosted debug/test builds attempt backtraces by default, hosted release is `KYOKAI_BACKTRACE=1`-gated, and freestanding targets pass trace data to `fatalHandler` as `Optional[Backtrace]`]**
- **`todo;` and `unreachable;` are built-in diverging statements with distinct failure categories** — Kyokai standardizes both developer stubs, but it does not blur them into one generic abort.
**Rules**:
  1. `todo;` has type `Never`.
  2. Executing `todo;` enters D84's `panic` category with a compiler-provided diagnostic message that includes source location.
  3. The compiler should warn on `todo;` in non-test code; profile policy may escalate that warning, but the runtime semantics remain an explicit `panic`.
  4. `unreachable;` has type `Never`.
  5. Executing `unreachable;` enters D84's TPOE category.
  6. `unreachable;` is not optimizer-only poison and not UB. If execution reaches it, the language-defined result is TPOE.
  7. `unreachable;` may inform control-flow analysis that the path is semantically impossible, but that analysis may not change rule 6.
  **Why this fits Kyokai**: unfinished code and impossible code paths get first-class spellings, while the language still keeps programmer-requested failure (`todo;`/`panic`) distinct from contract-violation failure (`unreachable;`/TPOE).
  **[STAGE: DECIDED_CORE_SEMANTICS | D121 → built-in `todo;` and `unreachable;` with explicit panic-vs-TPOE semantics]**
- **Deferred actions run in LIFO order within each lexical scope, filtered by the exit path that is actually being taken** — Kyokai treats `defer`/`errdefer` registration like a per-scope stack so cleanup order is mechanically predictable.
**Rules**:
  1. Each lexical scope maintains its own deferred-action stack.
  2. Entering a nested lexical scope creates a new deferred-action stack for that scope.
  3. Exiting a scope walks that scope's deferred-action stack in reverse source order.
  4. Only deferred actions whose trigger condition matches the current exit path run; ineligible deferred actions are skipped, not reordered.
  5. Inner-scope deferred actions always run before outer-scope deferred actions.
  **Why this fits Kyokai**: it matches the natural acquisition/release stack discipline, keeps resource lifetimes locally understandable, and stays explicit even when `defer` and `errdefer` coexist in the same scope.
  **[STAGE: DECIDED_CORE_SEMANTICS | D2a → LIFO per lexical scope, over all deferred actions eligible on the current exit path]**
- **The exit paths that run deferred actions are defined explicitly** — Kyokai does not leave "scope exit" as an implementation guess.
**Rules**:
  1. Ordinary `defer` actions run on ordinary scope completion and on every structured exit from the scope: normal fallthrough, `return`, `break`, `continue`, `or return`, `or break`, and `or continue`.
  2. Ordinary `defer` actions also run on `panic(message)`, because `panic` is explicit language-level abnormal control flow rather than a contract-failure trap.
  3. `errdefer` runs only on the structured error exits for that scope.
  4. The only structured error exits currently defined by the language are `return Err(value)` and `or return`, because `or return` is exact sugar for a `return Err(...)` path.
  5. `break`, `continue`, `or break`, `or continue`, normal fallthrough, successful `return`, and `panic(message)` are not `errdefer`-triggering exits.
  6. TPOE does not run user `defer` or `errdefer` code. TPOE is immediate hard termination.
  7. If leaving one scope also exits outer scopes, each exited scope applies these rules independently, using D2a's reverse-order rule within that scope.
  **Exit-path matrix**:
  | Exit path                         | `defer` | `errdefer` |
  | --------------------------------- | :-----: | :--------: |
  | Normal fallthrough                |   Yes   |     No     |
  | `return value` on success path    |   Yes   |     No     |
  | `return Err(value)`               |   Yes   |    Yes     |
  | `or return`                       |   Yes   |    Yes     |
  | `break` / `continue`              |   Yes   |     No     |
  | `or break` / `or continue`        |   Yes   |     No     |
  | `panic(message)`                  |   Yes   |     No     |
  | TPOE                              |    No   |     No     |
  **Example**:
  ```kyokai
  function readChecked(path: Span[Nat8, Static]): Result[Buffer[Nat8], IoError] is
      let file: File := openFile(path) or return;
      defer closeFile(file);
      let bytes: Buffer[Nat8] := readAll(&file) or return;
      errdefer bytes.destroy();
      validateMagicBytes(&bytes) or return;
      return Ok(bytes);
  qed;
  ```
  If `openFile(path) or return;` fails, nothing has been registered yet, so no deferred action runs. If `readAll(&file) or return;` fails, the `or return` exit runs `closeFile(file)` through ordinary `defer`. If `validateMagicBytes(&bytes) or return;` fails, the `or return` exit runs `bytes.destroy()` through `errdefer`, then runs `closeFile(file)` through ordinary `defer`. On the success path, `bytes` is moved into `Ok(bytes)`, so `errdefer bytes.destroy();` does not run, while `defer closeFile(file);` still does.
  **Why this fits Kyokai**: explicit abnormal termination (`panic`) still behaves like visible language control flow, while TPOE remains the hard contract-failure stop that does not execute user cleanup code.
  **[DECIDED: D2b → structured exits and `panic` run ordinary `defer`; TPOE runs no user deferred actions]**
- **Deferred bodies may not perform nonlocal structured control flow** — Kyokai does not let cleanup code replace or redirect the exit path that caused the cleanup to run.
**Rules**:
  1. A `defer` or `errdefer` body may use ordinary local control flow that stays entirely inside that deferred body, including `if`, `case`, and nested loops whose `break`/`continue` target those nested loops.
  2. A `defer` or `errdefer` body may not perform a nonlocal structured exit from the surrounding function or surrounding non-deferred scope.
  3. The banned nonlocal exits are `return`, `or return`, `break`, `or break`, `continue`, and `or continue` whenever they would leave the surrounding scope rather than an inner loop contained in the deferred body.
  4. Violating rule 3 is a compile-time error.
  5. `panic(message)` is legal inside a `defer` or `errdefer` body.
  **Why this fits Kyokai**: cleanup stays cleanup. The programmer can write local logic inside a deferred body, but the body cannot silently replace the outer control-flow path or corrupt the deferred-action stack.
  **[STAGE: DECIDED_CORE_SEMANTICS | D207 → deferred bodies allow only local control flow; nonlocal structured exits are illegal; `panic` remains legal]**
- `**Never` is a built-in bottom type for expressions that are statically known not to complete normally** — Kyokai does not leave diverging control-flow typing to compiler-only special cases.
**Rules**:
  1. `Never` has no values and no constructors.
  2. `return`, `break`, `continue`, and `panic(message)` have type `Never`.
  3. Any expression form that the language statically knows cannot complete normally also has type `Never`.
  4. `Never` may appear in user-written type positions, especially as a function return type for functions that never return normally.
  5. `Never` coerces to any other type for branch/type-join purposes.
  6. An expression does not become `Never` merely because it may trigger TPOE at runtime. Potential contract failure is not the same thing as statically known divergence.
  7. An expression that may trigger TPOE at runtime still has its ordinary result type for typing purposes; Kyokai does not track "may panic" or "may TPOE" in the type system.
  **Examples**:
  - `function fail(msg: String): Never is panic(msg); qed;`
  - `let x: Int32 := if ok then value else return;`
  - `let y: Float64 := parseRatio(s) or return;`
  **Why this fits Kyokai**: the type system states directly when control flow cannot continue, which makes `let...else`, `or return`, explicit `panic`, and no-return APIs type-check for principled reasons instead of checker magic.
  **[STAGE: DECIDED_CORE_SEMANTICS | D58 → built-in, denotable `Never` bottom type]**
- **`Never` coercion is an expression-site rule, not a general subtyping relation** — Kyokai uses `Never` to type-check statically diverging expressions where an ordinary value is expected, but it does not turn `Never` into a full subtype lattice that would silently rewrite enclosing generic types.
**Rules**:
  1. An expression of type `Never` may satisfy any expected type at that same expression site.
  2. This coercion applies only where the language is typing an expression against an immediate expected type or joining expression branches, including function return expressions, argument positions with known parameter types, `if` joins, `case` joins, `let ... else`, and `or return`.
  3. The coercion does not rewrite enclosing type constructors. `Optional[Never]`, `Result[Never, E]`, `Array[Never, N]`, and similar instantiated types remain ordinary distinct types rather than becoming universal subtypes.
  4. Kyokai therefore has no general subtype relation induced by `Never`. D186's variance rules, if any, are a separate question and are not inherited automatically from D58.
  5. `Never` in a user-written type position remains an ordinary denotable zero-inhabitant type under D58. The special rule here is only the expression-site coercion.
  **Why this fits Kyokai**: it solves the actual typing problem for diverging control flow without forcing the whole generic system to acquire hidden subtype and variance behavior.
  **[STAGE: DECIDED_CORE_SEMANTICS | D191 → `Never` coercion is expression-site only; no general subtyping and no automatic lifting through enclosing type constructors]**
- **Expression evaluation order is strict and uniform** — Kyokai evaluates subexpressions in source order instead of leaving sequencing to backend folklore or construct-specific exceptions.
**Rules**:
  1. Unary operators evaluate their operand first, then perform the operator.
  2. Binary operators evaluate the left operand, then the right operand, then perform the operator.
  3. D23 overloaded operators follow the same sequencing rule: both operands are evaluated exactly once, left to right, before the fixed operator-typeclass method is invoked.
  4. Function calls evaluate the callee expression first, then each argument from left to right, then perform the call.
  5. UFCS calls evaluate the receiver first, then the remaining arguments from left to right, then perform the call.
  6. Field access evaluates the base expression first.
  7. Indexing evaluates the container expression first, then the index expression, then performs bounds checking and element access.
  8. Record and array literal fields and elements evaluate in source order.
  9. `if`, `while`, and `case` evaluate their condition or scrutinee before any branch or body selection; only the selected branch/body is then evaluated.
  10. Assignment statements evaluate the assignee-place subexpressions from left to right, then evaluate the right-hand side, then perform the store.
  11. D15a's `let...else` scrutinee is evaluated exactly once before pattern testing; the language does not permit any desugaring that duplicates scrutinee evaluation.
  12. Short-circuiting `and` / `or` is the only ordinary conditional-evaluation exception.
  **Why this fits Kyokai**: the reader can predict exactly which side effects, borrows, checks, and possible TPOE points happen first by reading left to right. The rule is more explicit than Go's partial sequencing, cleaner than Rust's assignment special cases, and intentionally rejects the operand-order looseness found in Ada and C-family prior art.
  **[STAGE: DECIDED_CORE_SEMANTICS | D71 → strict left-to-right evaluation for all ordinary subexpressions and statement parts]**
- **Built-in integer arithmetic is exact-by-spec, checked by default, and free of implicit promotions** — Kyokai defines integer operators in terms of fixed-width concrete types and explicit trap behavior instead of inheriting C-family conversion rules.
**Rules**:
  1. Built-in signed integer types are two's-complement fixed-width integers. Unsigned integer types are fixed-width modulo-2^N integers used only where their declared type says so.
  2. There are no implicit promotions, no usual arithmetic conversions, and no mixed signed/unsigned operator rules.
  3. A built-in binary integer operator is legal only when both operands have the same concrete integer type after literal inference and any explicit conversions have already been applied.
  4. For `+`, binary `-`, `*`, and unary `-`, the language computes the exact mathematical result and produces that value only if it is representable in the concrete operand/result type; otherwise the operation triggers TPOE.
  5. Integer division truncates toward zero.
  6. Integer remainder is the truncating remainder and has the sign of the dividend.
  7. `x / 0`, `x % 0`, and `IntMin / -1` for a signed two's-complement type trigger TPOE.
  8. Comparisons on built-in integers compare values of the same concrete integer type only; cross-type comparison requires an explicit conversion first.
  9. Wrapping, saturating, overflow-reporting, and other non-default arithmetic policies exist only through explicitly named library APIs.
  10. No build profile, target setting, backend flag, or user-supplied toolchain flag may silently change these language-level semantics.
  **Why this fits Kyokai**: overflow becomes an explicit, portable part of the language contract and of D84's TPOE model, while the absence of promotions prevents the hidden type motion that makes C-family integer code error-prone.
  **[STAGE: DECIDED_CORE_SEMANTICS | D75 → no promotions; checked-by-default exact integer arithmetic with TPOE on overflow]**
- **Floating-point arithmetic follows a strict IEEE 754 language contract** — Kyokai does not merely "use the platform float"; it specifies the visible model that the backend must preserve.
**Rules**:
  1. `Float32` and `Float64` are IEEE 754 binary32 and binary64 respectively.
  2. The default rounding mode is round-to-nearest, ties-to-even.
  3. Arithmetic, conversion, and comparison results must be those of the IEEE 754 model for the declared operand/result types; the backend may not rely on excess precision as part of the portable language result.
  4. Subnormals and gradual underflow are part of the language contract. Flush-to-zero and denormals-are-zero behavior are not silently permitted.
  5. Signed zero is preserved and observable.
  6. Floating-point division by zero does not trigger TPOE solely because the divisor is zero; it yields the IEEE 754 result.
  7. Floating overflow, underflow, infinities, and NaNs follow IEEE 754 behavior rather than the integer TPOE model.
  8. Ordered comparisons involving NaN are false; `!=` involving NaN is true; ordinary float comparison is therefore a partial order, not a total order.
  9. NaN payload bits are outside the portable language contract. Portable Kyokai code may rely on the result being NaN, but not on a specific payload-propagation policy.
  10. User-visible mutation of the floating-point environment is not part of the language contract unless a separate decision adds it explicitly.
  11. The compiler, backend, and toolchain configuration may not silently enable fast-math, reassociation, excess-precision drift, or implicit FMA contraction that changes language-visible results.
  12. If the language later adds a relaxed or fast floating-point mode, that must be a separate explicit decision with separate syntax and semantics; it is not implied by optimization level or profile name.*
  **Why this fits Kyokai**: float behavior stays portable and auditable across the C backend, target triples, and profile settings. The language gets Java-style explicitness about the visible model without inheriting C's "whatever the toolchain did" semantics.
  **[STAGE: DECIDED_CORE_SEMANTICS | D76 → strict IEEE 754 binary32/binary64 model; portable NaN-ness but not payload bits]**
- **Standard-library floating-point math APIs must publish tested accuracy contracts without adding call-site tier types** — Kyokai requires numerical honesty as part of the API contract, but it does not make ordinary users carry accuracy parameters through every math call.
**Allowed contract forms**:
  1. `Exact`: the result is exact for every input in the documented domain.
  2. `CorrectlyRounded`: the result is the IEEE 754 correctly rounded result under D76's active rounding rule.
  3. `MaxUlp(n)`: the result is within `n` ULP of the mathematical real-number result over the documented input domain.
  4. `AbsError(bound)` or `RelError(bound)`: allowed only when ULP is not the right error statement for the function, and the input domain must be stated explicitly.
  5. `ImplementationDefinedAccuracy` is not an allowed contract for safe `Kyokai.Math` APIs.
**Rules**:
  1. Every public `Kyokai.Math` floating-point function must declare one of the allowed accuracy contracts in its API documentation and conformance metadata.
  2. Accuracy contracts do not change ordinary function signatures. `sin(x)` remains `sin(x)`, not `sin[Tier](x)`.
  3. Accuracy tiers are documentation, tests, admission criteria, and toolchain-doc metadata, not programmer-facing type parameters.
  4. Each function must document special-value behavior for `NaN`, infinities, signed zero, overflow, underflow, and domain boundaries under D76.
  5. A math implementation may not be admitted to the standard library until tests demonstrate the declared contract over the documented domain using reference implementations, high-precision oracles, exhaustive checks where feasible, and fuzzing where exhaustive checks are infeasible.
  **Why this fits Kyokai**: RIIK math stays pure Kyokai, but the rewrite must be numerically accountable. The programmer gets ordinary readable calls, while the standard library carries the explicit error bounds and tests that make those calls trustworthy.
  **[STAGE: DECIDED_CORE_SEMANTICS | D232 → math APIs publish tested accuracy contracts; no call-site numerical tier verbosity]**
- **Default numeric conversion uses a fixed UFCS-style conversion family; alternative conversion policies stay named** — Kyokai keeps numeric conversion concise without adopting Rust's overloaded `as`, C's cast syntax, or pseudo-constructor conversion forms.
**Syntax**:
  ```kyokai
  let a: Int64 := x.toInt64();
  let b: Int32 := y.toInt32();
  let c: Float32 := z.toFloat32();
  let d: Optional[Int32] := y.tryToInt32();
  let e: Int32 := y.truncateToInt32();
  let f: Int32 := y.saturatingToInt32();
  ```
  **Rules**:
  1. For built-in numeric target types only, `expr.toTargetType()` is the syntax for the default explicit numeric conversion.
  2. This conversion family is fixed by the language for built-in numeric conversions; it is not user-overloadable and does not automatically generalize to user-defined types.
  3. Integer-to-integer conversions using `toTargetType` preserve the numeric value if representable in the target type and otherwise trigger TPOE.
  4. Integer sign changes are checked by the same rule: converting a negative signed integer to an unsigned target, or any out-of-range value to any target, triggers TPOE.
  5. Float-to-integer conversion using `toTargetType` truncates toward zero and then checks the truncated value against the integer target range. NaN, infinity, and out-of-range results trigger TPOE.
  6. Integer-to-float and float-to-float conversion using `toTargetType` follow D76's IEEE 754 conversion rules for the target format. They do not TPOE solely because precision is lost during ordinary rounding to the target float format.
  7. Non-default conversion policies remain named APIs in the same family. At minimum, the language/library surface provides distinct named forms for fallible conversion (`tryToTargetType` style), truncating/wrapping conversion (`truncateToTargetType` style), and saturating conversion when the standard library chooses to provide it.
  8. There are no implicit numeric conversions.
  9. Rust-style `x as TargetType`, C-style `(TargetType)x`, and pseudo-constructor conversion syntax such as `TargetType(expr)` are not part of Kyokai.
**Why this fits Kyokai**: the default conversion stays short, but the spelling is visibly a conversion name rather than a pseudo-constructor or generic cast form. It aligns with UFCS, keeps alternative policies explicit, and avoids collapsing every conversion into one ambiguous operator.
**[STAGE: DECIDED_CORE_SEMANTICS | D37 → UFCS-style `x.toTargetType()` for default numeric conversion; named APIs for non-default policies]**
- **`Index` is a distinct concrete integer type, and cross-integer mixing remains explicit even at indexing and length boundaries** — Kyokai closes the last hole left by D75's fixed-width focus by stating exactly how `Index` interacts with the rest of the integer family.
**Rules**:
  1. `Index` is its own concrete integer type. It is not interchangeable with any `Int*` or `Nat*` type merely because a target may represent them with the same machine width.
  2. Built-in arithmetic and comparison over integer-like types, including `Index`, are legal only when both operands have the same concrete type after D12 literal inference and any explicit D37 conversions.
  3. `Int8 + Int32`, `Nat32 < Index`, and assignment or binding of an `Int*`/`Nat*` value to an `Index`-typed place without an explicit conversion are compile-time errors.
  4. Default explicit conversions between `Index` and the fixed-width integer families use D37's built-in conversion family such as `x.toIndex()`, `x.toNat64()`, or `x.toInt32()`.
  5. `toIndex()` succeeds only when the source numeric value is representable in `Index`; otherwise it triggers TPOE under D37's checked-conversion rule.
  6. Integer literals may still infer to `Index` under D12 when the expected type is known, so code such as `buf.length() + 1` remains legal when the literal has exactly one valid inferred type.
  7. Standard indexing, length, capacity, and other shape-bearing APIs use `Index` explicitly. Kyokai defines no ambient rule that "any integer-like type may be used as an index."
  **Why this fits Kyokai**: array sizes, lengths, and indexing stay honest about using a dedicated machine-sized domain, while arithmetic never quietly crosses nominal numeric boundaries behind the programmer's back.
  **[STAGE: DECIDED_CORE_SEMANTICS | D210 → `Index` is distinct; integer arithmetic/comparison require same concrete type including `Index`; cross-family use requires explicit D37 conversion]**
- `**String` means well-formed UTF-8 text, not “bytes by convention”** — Kyokai gives text a real language-level contract instead of treating human text and arbitrary bytes as the same thing.
**Rules**:
  1. `String` is an owned text type whose contents are always well-formed UTF-8.
  2. This UTF-8 validity guarantee applies on every construction path from raw bytes.
  3. `String` does not imply Unicode normalization. The language does not silently normalize to NFC, NFD, or any other normalization form.
  4. Text operations on `String` are defined against this UTF-8 contract; they do not treat `String` as an arbitrary byte buffer.
  5. The standard Unicode-oriented helpers use explicit names such as `codePointAt`, `codePointLen`, and `byteLen`; Kyokai does not use vague names like `charLen` for code-point-count APIs.
  6. Locale-sensitive behavior is not implicit in `String` operations.
  **Why this fits Kyokai**: if a value has type `String`, both the programmer and the compiler know it is valid text. Kyokai keeps text semantics explicit instead of inheriting the C/Go habit where “string” often really means “some bytes.”
  **[STAGE: DECIDED_CORE_SEMANTICS | D30 → `String` is guaranteed well-formed UTF-8 text; no implicit normalization or locale magic]**
- **Text and raw bytes are separate types with named, explicit bridges** — Kyokai does not collapse UTF-8 text, binary payloads, borrowed byte views, and fixed-size byte arrays into one universal “string” concept.
**Core split**:
  ```kyokai
  String          // owned UTF-8 text
  ByteBuf         // owned arbitrary bytes
  Span[Nat8]      // borrowed bytes
  Array[Nat8, N]  // fixed-size raw bytes
  ```
  **Conversions**:
  ```kyokai
  let text: Result[String, Utf8Error] := String.fromUtf8(rawBytes);
  let raw: ByteBuf := text.intoBytes();
  let bytes: Span[Nat8] := text.asBytes();
  ```
  **Rules**:
  1. Raw bytes live in `ByteBuf`, `Span[Nat8]`, `Array[Nat8, N]`, or future explicitly byte-oriented types, not in `String`.
  2. There is no implicit conversion between text and bytes.
  3. Any conversion from bytes to `String` that establishes UTF-8 validity is named and explicit.
  4. Any conversion from `String` to a borrowed byte view is named and explicit and must not silently allocate.
  5. Any conversion from `String` to an owned byte buffer is named and explicit and preserves the underlying UTF-8 byte sequence exactly.
  6. OS-facing and foreign-facing string boundaries are not silently treated as `String`; environment variables, C strings, paths, and similar native-text surfaces must define their own explicit conversion rules in their own decisions.
  **Why this fits Kyokai**: text and bytes are genuinely different concepts in systems code. Kyokai gives each concept its own type and makes every bridge between them visible.
  **[STAGE: DECIDED_CORE_SEMANTICS | D30a → explicit split between UTF-8 text and raw bytes; no implicit conversions]**
- **`String` reuses the owning byte-buffer storage discipline, but remains a distinct nominal UTF-8 text type** — Kyokai does not duplicate dynamic-container machinery for text, and it does not blur text into raw bytes just because the storage strategy is shared.
**Rules**:
  1. `String` is a `Linear`, owning text type.
  2. `String` is nominally distinct from raw byte containers and views. It is not an alias and not a transparent substitution for raw bytes in type checking.
  3. `String` uses the same storage discipline as Kyokai's owning contiguous byte-buffer containers: owned heap storage, explicit byte length, explicit capacity, and stored allocator identity under D44.
  4. The UTF-8 invariant from D30 applies to every live `String` value.
  5. Safe operations on `String` must preserve that UTF-8 invariant.
  6. Safe code may obtain an immutable borrowed byte view of a `String` through an explicit named operation such as `asBytes()`, but safe code may not obtain mutable raw-byte access that could violate the UTF-8 invariant.
  7. `StringBuilder` is the standard mutable construction path for incrementally built text; finishing a builder yields a `String`.
  8. Sharing the storage discipline with byte buffers does not automatically make all byte-buffer APIs part of the `String` surface.
  **Why this fits Kyokai**: the runtime only needs one owning contiguous-buffer model, but the type system still keeps "valid text" and "arbitrary bytes" separate.
  **[STAGE: DECIDED_CORE_SEMANTICS | D165 → `String` is a nominal `Linear` UTF-8 text type that reuses the owning byte-buffer storage discipline without collapsing into raw bytes]**
- **`String` has one exact runtime state model and no alternate safe representation class** — Kyokai fully fixes what an owning string stores instead of leaving representation folklore to the implementation.
**Rules**:
  1. The concrete runtime state of a `String` consists of exactly four logical components: data pointer, byte length, byte capacity, and allocator identity.
  2. `String` length counts bytes, not Unicode scalar values, grapheme clusters, or display columns.
  3. `String` has no small-string optimization, tagged inline variant, or other alternate safe-language representation class.
  4. Borrowing a `String` does not expose mutable access to those underlying bytes in safe code.
  5. The exact runtime state fixed here does not erase the nominal distinction from raw byte containers; `String` remains its own type even though the stored state is the same kind of owning buffer state.
  **Why this fits Kyokai**: the language gets an exact owning-text representation contract, while all text-vs-bytes semantics remain explicit at the type level.
  **[STAGE: DECIDED_CORE_SEMANTICS | D204 → exact `String` runtime state is pointer + byte length + byte capacity + allocator identity; no SSO or alternate safe representation]**
- **C NUL-terminated strings use dedicated interop types instead of “just use `String`” folklore** — Kyokai treats C strings as explicit FFI-boundary byte contracts with their own invariants rather than as ordinary text or naked pointers by convention.
**Core types**:
  ```kyokai
  CString  // owned C-string value
  CStr     // borrowed C-string view
  ```
  **Rules**:
  1. `CString` is an owned byte sequence that ends with exactly one trailing NUL byte and contains no interior NUL bytes.
  2. `CStr` is a borrowed view of a valid NUL-terminated byte sequence. It does not own storage and does not imply UTF-8 validity, Unicode semantics, or locale semantics.
  3. `CString` and `CStr` are distinct from `String`, `ByteBuf`, and `Span[Nat8]`. There is no implicit conversion between any of these types.
  4. Creating a `CString` from text or bytes is explicit and validating. The operation must reject interior NUL bytes, establish the trailing NUL byte, and obey D44's explicit allocator rules for owned allocation.
  5. Borrowing a `CStr` from a `CString` is explicit and allocation-free.
  6. Constructing a `CStr` directly from a raw foreign pointer is only legal at the unsafe boundary and only under an explicit contract that the pointed-to storage is alive, readable, and properly NUL-terminated.
  7. Raw `foreign "C"` declarations continue to spell C-string parameters with pointer types such as `Address[Nat8]` or `Pointer[Nat8]` under D20. `CString` and `CStr` are wrapper-side interop types that make the boundary explicit and validated.
  8. Safe wrapper APIs should prefer `&[CStr]` or another explicitly chosen C-string wrapper type over naked byte pointers when the contract is “valid NUL-terminated string”.
  **Why this fits Kyokai**: text stays text, bytes stay bytes, and the C-string boundary becomes an explicit validated contract instead of an ambient pointer convention inherited from C.
  **[STAGE: DECIDED_CORE_SEMANTICS | D68 → dedicated `CString` and `CStr` interop types; no implicit conversion from text/bytes; raw-pointer entry only at the unsafe boundary]**
- **Iteration is split cleanly between range syntax and a minimal iterable protocol** — Kyokai supports both numeric loops and collection loops, but does not import Rust's closure-heavy iterator ecosystem.
**Range syntax**:
  1. `for i from a to b do ... od;` is inclusive and iterates `i = a, a + 1, ..., b`.
  2. `for i from a below b do ... od;` is exclusive and iterates `i = a, a + 1, ..., b - 1`.
  3. `below` is the preferred form for 0-based indexing and length-bounded loops; Kyokai does not force `to (n - 1)` boilerplate for half-open ranges.
  **Iterable protocol**:
  ```kyokai
  typeclass Iterator(Iter: Type) is
      type Item;
      method next(iter: &![Iter]): Optional[Iter.Item];
  spec;

  typeclass Iterable(Self: Type) is
      type Iter;
      method iter(self: &[Self]): Self.Iter;
  spec;
  ```
  **Rules**:
  1. `for item in expr do ... od;` evaluates `expr` exactly once.
  2. If the resulting type implements `Iterator`, the loop uses that value directly as the iteration state.
  3. Otherwise, the resulting type must implement `Iterable`, and the loop creates an iterator by calling `iter`.
  4. If a type implements both `Iterator` and `Iterable`, the direct-`Iterator` path wins.
  5. In the direct-`Iterator` path, the loop consumes the iterator value into its private loop state. In the `Iterable` path, the iterator returned by `iter` is the private loop state.
  6. Iterators used by Kyokai's standard `for-in` protocol are fused by default: once `next` returns `None`, it must keep returning `None`.
  7. The base `for-in` form is for borrowing iteration over collections and direct iteration over iterator values. Mutable iteration and consuming iteration over collection-like types still use explicit named forms such as `iterMut()` and `intoIter()` that return iterator values implementing `Iterator`.
  8. If the compiler-generated loop state for `for-in` has a `Linear` type, that iterator type must implement `Destroyable` or have a feature-specified generated consuming `destroy` operation such as D198 generators.
  9. The `for-in` desugaring consumes a linear iterator exactly once on every loop exit path: normal exhaustion, `break`, `return`, `or return`, `panic` cleanup, and any other control-flow path that exits the loop scope.
  10. A linear `item` yielded into the loop body must be consumed by the ordinary linearity rules before the next iteration begins or before any exit from the loop body.
  11. The core iteration contract stops at `iter`, `next`, direct-iterator acceptance, linear-iterator finalization, and `for-in` desugaring. Iterator adapter APIs such as `map`, `filter`, `fold`, `collect`, `zip`, and `enumerate` are not part of D32; their existence, ownership model, allocation behavior, and callback surface are a separate decision point (D32a).
  **`for-in` desugaring**:
  ```kyokai
  // Iterable source:
  for item in collection do
      process(item);
  od;

  // Desugars to:
  var __iter := collection.iter();
  while true do
      case __iter.next() of
          when Some(item) do
              process(item);
          when None do
              break;
      esac;
  od;
  ```
  ```kyokai
  // Direct iterator source:
  for item in makeCountdown(3) do
      process(item);
  od;

  // Desugars to:
  var __iter := makeCountdown(3);
  while true do
      case __iter.next() of
          when Some(item) do
              process(item);
          when None do
              break;
      esac;
  od;
  ```
  **Why this fits Kyokai**: the language gets ergonomic `for-in` loops and user-extensible iteration without importing a giant hidden-adapter ecosystem, forcing range users to write `n - 1` everywhere, or leaking linear iterator state on early exit.
  **[STAGE: DECIDED_CORE_SEMANTICS | D32/D249 → dual range forms (`to` and `below`) + minimal `Iterable`/`Iterator` protocol, fused by default; linear iterators are consumed by the loop desugaring on every exit path]**
- **Records use brace-plus-colon construction, not call syntax** — Kyokai makes data construction visibly distinct from calls so that record literals remain obvious even with UFCS and named factory functions in the language.
**Syntax**:
  ```kyokai
  let p: Point := Point { x: 5, y: 10 };
  let r: Resource := Resource { id: 1, active: true };
  let q: Point := Point { x, y };
  ```
  **Rules**:
  1. Record construction is always written as `TypeName { field: expr, ... }`.
  2. Positional record construction does not exist.
  3. Every declared field must appear exactly once in a record construction expression. Duplicate fields are illegal.
  4. There is no partial construction, omitted-default filling, or hidden field initialization.
  5. Field order is semantically irrelevant, but field expressions are evaluated in source order per D71.
  6. Shorthand `TypeName { field }` is allowed only when a binding with the same name is already in scope, and it desugars exactly to `TypeName { field: field }`.
  7. Record construction syntax is distinct from function-call syntax. Parentheses remain for calls; braces remain for data construction.
  8. Anonymous record spread syntax and hidden default-filling are not part of Kyokai. The only standardized record-update form is D138's explicit `TypeName { ..., with source }`.
  **Why this fits Kyokai**: parens mean calls, braces mean construction, and the language does not blur data literals with functions or hidden default-filling behavior.
  **[STAGE: DECIDED_CORE_SEMANTICS | D35 → brace-plus-colon record construction `TypeName { field: expr }`; no positional or partial construction]**
- **Records also have an explicit type-led update form; omitted fields come only from a named source record, never from hidden defaults** — Kyokai reduces schema-change churn without introducing anonymous structural-update syntax or a second unrelated record grammar.
**Syntax**:
  ```kyokai
  let next: Point := Point { z: 0, with oldPoint };
  let moved: Job := Job { state: Done, with oldJob };
  ```
  **Rules**:
  1. The update form is `TypeName { field1: expr1, ..., with source }`.
  2. `with source` may appear at most once and must be the final item inside the braces.
  3. `source` must have exactly the same record type as `TypeName`.
  4. Fields written explicitly override the matching fields from `source`.
  5. After applying the explicit overrides, every field of the record must be supplied exactly once. Missing fields and duplicate fields are compile-time errors.
  6. For a `Free` record type, remaining fields are copied from `source` and `source` remains usable.
  7. For a `Linear` record type, `source` is consumed and every remaining field is moved from `source` into the new record.
  8. Kyokai does not add a separate `old with { ... }` or anonymous structural-update form. Record update remains visibly a `TypeName { ... }` construction.
  **Why this fits Kyokai**: the type stays visible at the construction site, move/copy behavior remains explicit, and omitted fields are never magical because the programmer names the exact source record supplying them.
  **[STAGE: DECIDED_CORE_SEMANTICS | D138 → explicit type-led record update `TypeName { ..., with source }`; `Free` copies remaining fields, `Linear` consumes and moves from source]**
- **Single-field records are Kyokai's nominal wrapper mechanism, and Kyokai adds a one-line declaration form for them instead of a separate `newtype` feature** — domain wrappers stay ordinary records rather than splitting into a second nominal-type construct.
**Syntax**:
  ```kyokai
  record UserId(value: Int64): Free;
  ```
  is exact sugar for:
  ```kyokai
  record UserId: Free is
      value: Int64;
  build;
  ```
  **Rules**:
  1. Kyokai has no dedicated `newtype` keyword or separate newtype declaration category.
  2. A one-line record declaration form is allowed for records with exactly one field.
  3. The one-line form preserves the same name, generics, universe annotation, and field type as the corresponding ordinary record declaration.
  4. Construction still uses ordinary record construction syntax: `UserId { value: 42 }`.
  5. D65's single-field paren form remains union-only and does not apply to records.
  6. D196 defines the precise transparent-wrapper representation guarantee for ordinary single-field records.
  **Why this fits Kyokai**: there is one nominal-wrapper mechanism, not two, and the only extra sugar added is declaration-site compression for the common single-field case.
  **[STAGE: DECIDED_CORE_SEMANTICS | D109 → no dedicated `newtype`; single-field records remain the wrapper mechanism; one-line single-field record declaration added]**
- **Ordinary single-field records have transparent wrapper representation inside Kyokai** — Kyokai's nominal wrappers are zero-cost in the language's own layout and calling model, but the guarantee is stated narrowly enough not to conflict with `extern record` and `packed record`.
**Rules**:
  1. This guarantee applies only to ordinary `record` declarations with exactly one field.
  2. For such a record `Wrapper`, `sizeOf(Wrapper)` equals `sizeOf(FieldType)`, `alignOf(Wrapper)` equals `alignOf(FieldType)`, and the sole field has offset `0`.
  3. Passing, returning, storing, and loading such a wrapper in Kyokai's own call/return and ordinary layout model must behave as though the wrapper had the same representation as its field type, with no hidden tag, padding-only wrapper shell, or extra indirection.
  4. The wrapper remains a distinct nominal type under D190. Representation equality does not create type equality, implicit conversion, or instance sharing.
  5. This guarantee does not apply to `packed record`, whose layout is governed by D42's packed rules.
  6. This guarantee does not apply to `extern record`, whose FFI layout and ABI are governed by D20a and D42.
  **Why this fits Kyokai**: single-field records stay the one wrapper mechanism, and they are guaranteed zero-cost without pretending foreign C structs or packed layouts obey the same rule.
  **[STAGE: DECIDED_CORE_SEMANTICS | D196 → ordinary single-field `record` wrappers are transparent in Kyokai layout/call ABI; still nominally distinct; excludes `extern record` and `packed record`]**
- **Record destructuring is total: destructuring a record consumes the whole record and binds its fields as independent values** — Kyokai does not adopt Rust-style partial-move record semantics.
**Rules**:
  1. Any record destructuring form (`let { ... } := record;` or a `case` arm that destructures a record) consumes the record value as a whole.
  2. Destructuring binds each mentioned field as a separate local binding; from that point on, the original record value no longer exists.
  3. There is no partial record destructuring that removes one field while leaving the original record alive.
  4. Each bound field keeps its own universe and linearity. Linear fields must still be consumed exactly once; Free fields may be ignored.
  5. Omitting a field or binding it to `ignore` is legal only when that field is `Free`. A linear field must be bound to a real name and explicitly consumed or explicitly destroyed through the ordinary APIs.
  6. If only one field is needed, the programmer still destructures the whole record and handles the remaining linear fields explicitly, often with `defer`.
  **Why this fits Kyokai**: the rule matches Austral's simple "destructure = consume" model, keeps linear resource flow visible, and avoids the extra complexity of partial-move state tracking.
  **[STAGE: DECIDED_CORE_SEMANTICS | D98 → total record destructuring; no partial moves; linear fields remain explicit]**
- **Field access through references uses `.` with one level of auto-deref** — Kyokai keeps member access uniform without importing unlimited deref chains or a separate `->` operator.
**Rules**:
  1. If `r` has type `&[Record]` or `&![Record]`, `r.field` is legal and means "dereference one reference level, then access `field`."
  2. This auto-deref applies to direct field access and field assignment places only. It does not add hidden method dispatch, typeclass lookup, or unlimited deref search.
  3. The auto-deref depth is exactly one level. If `rr` is a reference to a reference, `rr.field` is illegal; the programmer must write `(~rr).field` or another explicitly dereferenced form.
  4. `~` remains the explicit dereference operator for cases where the programmer wants to show the dereference directly.
  5. `->` is not part of Kyokai.
  **Why this fits Kyokai**: `.` remains the single member-access operator, field access through a reference is still mechanically obvious, and the language avoids Rust-style implicit deref chains.
  **[STAGE: DECIDED_CORE_SEMANTICS | D34 → one-level auto-deref for field access through `.`; no `->`]**
- **Pattern matching has no guard clauses** — Kyokai keeps `case` purely structural and leaves boolean filtering to `if`.
**Rules**:
  1. A `when` arm is written as `when Pattern do ...`; there is no `when Pattern if condition do` form.
  2. Conditions that refine a matched pattern are written with ordinary `if` / `else` inside the selected `when` body.
  3. Exhaustiveness checking is structural only. Guard conditions do not participate in the language's exhaustiveness model because guard syntax does not exist.
  **Why this fits Kyokai**: `case` destructures and `if` filters. The language keeps those concerns separate instead of weakening exhaustiveness with guard logic.
  **[STAGE: DECIDED_CORE_SEMANTICS | D38 → no pattern guards; use `if` inside `when`]**
- **`case` matching is exhaustive, supports nested structural patterns, and uses `ignore` as the discard pattern** — Kyokai does not restrict matching to one constructor layer, and it does not use `_` as a pattern token.
**Rules**:
  1. Every `case ... of ... esac;` must be exhaustive over the scrutinee type. A non-exhaustive `case` is a compile-time error.
  2. Patterns may nest through union constructors, record destructuring, and combinations of those forms to arbitrary finite depth.
  3. `case` arms are tested in source order. The first arm whose pattern matches is the arm that executes.
  4. `ignore` is the contextual discard pattern. It matches any value at that pattern position and introduces no binding.
  5. `_` is not a pattern token in Kyokai.
  6. Exhaustiveness and unreachable-arm checking are defined over these nested structural patterns; nesting does not disable compile-time coverage checking.
  **Why this fits Kyokai**: nested `Result`/`Optional` composition stays directly matchable, exhaustiveness remains mandatory, and the language avoids introducing symbolic wildcard punctuation for a single discard concept.
  **[STAGE: DECIDED_CORE_SEMANTICS | D205 → exhaustive nested structural patterns; `ignore` is the discard pattern; `_` is not a pattern token]**
- **`ignore` and omitted subpatterns are legal only at `Free` pattern positions** — Kyokai does not let discard syntax hide linear-resource destruction.
**Rules**:
  1. `ignore` may appear only at a pattern position whose matched value is `Free`.
  2. In record destructuring, omitting a field is exact sugar for matching that field with `ignore`; it is therefore legal only for `Free` fields.
  3. A catch-all arm written as `when ignore do ...` is illegal if any still-unmatched value that could reach that arm may contain a `Linear` payload.
  4. When a matched variant or field may contain a `Linear` value, the pattern must bind that value to an explicit name, and the selected arm must satisfy ordinary linearity by consuming it explicitly.
  **Why this fits Kyokai**: catch-all syntax stays available for ordinary `Free` data, while linear resources remain visible in the surface program instead of being silently discarded by pattern syntax.
  **[STAGE: DECIDED_CORE_SEMANTICS | D206 → `ignore` and omitted subpatterns are `Free`-only; linear payloads must bind explicit names]**
- `**while let` is explicit sugar for "re-evaluate, pattern-match, continue on match, break on mismatch"** — Kyokai admits this loop form because the desugaring is mechanical and the pattern is common in explicit, closure-free code.
**Syntax**:
  ```kyokai
  while let Some(item) := queue.dequeue() do
      process(item);
  od;
  ```
  **Rules**:
  1. `while let Pattern := expr do ... od;` re-evaluates `expr` once at the start of each iteration.
  2. If the value of `expr` matches `Pattern`, the pattern bindings enter scope for the loop body and that iteration runs.
  3. If the value of `expr` does not match `Pattern`, the loop terminates immediately.
  4. `Pattern` must be refutable. Irrefutable patterns are illegal in `while let`.
  5. Bound names from `Pattern` are scoped only to the loop body of the successful iteration.
  6. `while let` is general pattern sugar; it is not restricted to `Optional` or `Result`.
  **Desugaring**:
  ```kyokai
  // Source:
  while let Pattern := expr do
      body;
  od;

  // Desugars to:
  while true do
      case expr of
          when Pattern do
              body;
          when ignore do
              break;
      esac;
  od;
  ```
  **Why this fits Kyokai**: the syntax removes a common seven-line manual loop pattern without adding hidden semantics or special Optional-only behavior.
  **[STAGE: DECIDED_CORE_SEMANTICS | D39 → general refutable-pattern `while let` sugar with exact desugaring]**
- **Grammar whitespace is insignificant, trailing commas are widely permitted, and empty executable blocks are legal no-op blocks; formatting tools may not rewrite semantics** — Kyokai keeps the grammar permissive while leaving style enforcement to `kyokai fmt` and diagnostics.
**Rules**:
  1. Newlines are ordinary insignificant whitespace except where a token would otherwise be split illegally.
  2. Trailing commas are legal in all comma-delimited list forms of the language grammar.
  3. Empty executable blocks are legal and mean ordinary no-op execution of that block.
  4. `kyokai fmt` may enforce canonical formatting choices such as multiline trailing commas, but it may not change program semantics by inserting or removing executable statements.
  5. A lint or warning may diagnose suspicious empty blocks, but the grammar and runtime meaning remain as stated by rules 1 through 4.
  **Why this fits Kyokai**: parsing stays simple, source formatting stays deterministic, and tooling does not become a hidden semantic rewrite layer.
  **[STAGE: DECIDED_CORE_SEMANTICS | D180 → insignificant newlines; trailing commas allowed in all comma-delimited lists; empty executable blocks are legal no-op blocks; `fmt` may not rewrite semantics]**
- **Bitwise and bit-shift operations use explicit keyword operators** — Kyokai keeps bit manipulation readable without overloading `&` or relying on symbolic precedence folklore.
**Operators**:
  - `a band b`
  - `a bor b`
  - `a bxor b`
  - `bnot a`
  - `a shl n`
  - `a shr n`
  - `a rotl n`
  - `a rotr n`
  **Rules**:
  1. These operators are built-in for the concrete integer types only. They are not user-overloadable.
  2. `band`, `bor`, and `bxor` require both operands to have the same concrete integer type and return that same type.
  3. `bnot` takes one concrete integer operand and returns that same concrete integer type.
  4. `shl` and `shr` require a concrete integer left operand and an integer shift count. Negative counts trigger TPOE. Counts greater than or equal to the operand bit width trigger TPOE.
  5. `shl` shifts left within the operand's fixed bit width, zero-filling low bits and discarding high bits as part of the defined bitwise result.
  6. `shr` is a logical right shift for `Nat*` types and an arithmetic right shift for `Int*` types.
  7. `rotl` and `rotr` rotate within the operand's fixed bit width. Negative counts trigger TPOE. Non-negative counts are reduced modulo the bit width.
  8. There are no implicit promotions or hidden count conversions in these operators.
  9. Precedence and parenthesization for these operators are governed by D56's limited precedence rules.
  **Why this fits Kyokai**: the operators are readable, searchable, unambiguous with borrow syntax, and explicit about shift-count failure and rotation semantics.
  **[STAGE: DECIDED_CORE_SEMANTICS | D41 → keyword bitwise operators plus `rotl`/`rotr`; explicit shift-count semantics]**
- **Record layout is a closed, explicit type-level choice: `record`, `extern record`, and `packed record`** — Kyokai does not let the backend silently choose ordinary record layout, and it does not define the language's normal layout by appealing to the C backend. Ordinary records use a language-defined Kyokai layout. `extern record` is the explicit foreign-ABI form. `packed record` is the explicit byte-tight form. These are the only layout classes in the language; Kyokai does not adopt an open-ended `repr(...)` attribute system.
**Syntax**:
  ```kyokai
  record Point is
      x: Int32;
      y: Int32;
  build

  extern record Stat is
      size: Nat64;
      mode: Nat32;
  build

  packed record Header is
      tag: Nat8;
      length: Nat16;
  build
  ```
  **`record` (Kyokai layout)**:
  1. Fields remain in source order. The compiler never reorders fields.
  2. Each field starts at the smallest offset greater than or equal to the end of the previous field that satisfies that field type's alignment.
  3. Record alignment is the maximum alignment of its fields.
  4. Record size is rounded up to a multiple of the record alignment.
  5. User-specified over-alignment, under-alignment, bitfields, and hidden niche/layout optimizations are not part of the language.
  **`extern record` (target C ABI layout)**:
  1. `extern record` uses the selected target's C ABI layout rules for that field list and field order.
  2. Field order remains the source order written by the programmer; Kyokai does not reorder `extern record` fields.
  3. A record type may appear in a `foreign "C"` declaration only if it is an `extern record`.
  4. Every field of an `extern record` must itself be FFI-safe under D20/D20a. Otherwise the declaration is illegal.
  **`packed record` (byte-tight layout)**:
  1. Fields remain in source order with no implicit padding between fields.
  2. Packed record alignment is 1.
  3. Packed record size is the sum of field sizes.
  4. Reading or writing a packed field uses copy semantics, not reference semantics: the implementation must behave as though it copies bytes into or out of a properly aligned temporary of the field type.
  5. Taking `&field` or `&!field` of a packed field is illegal. Packed fields cannot produce borrows because that would create potentially misaligned references.
  6. `packed` does not imply bitfields, byte swapping, endianness conversion, or C ABI compatibility.
  **Mutual exclusion**:
  1. A record is exactly one of `record`, `extern record`, or `packed record`.
  2. `extern packed record` and any equivalent combination are illegal.
  3. If a foreign API requires a packed C struct, the boundary must use an explicit unsafe wrapper that marshals bytes or raw storage deliberately; Kyokai does not pretend that case is ordinary.
  **Layout introspection**:
  1. `sizeOf(T)`, `alignOf(T)`, and `offsetOf(T, field)` are comptime-only built-ins.
  2. They are written with the same visible phase marker as other compile-time evaluation:
  ```kyokai
  constant HEADER_SIZE: Index := comptime sizeOf(Header);
  constant HEADER_ALIGN: Index := comptime alignOf(Header);
  constant LENGTH_OFFSET: Index := comptime offsetOf(Header, length);
  ```
  1. These built-ins use the semantics of the record's declared layout class (`record`, `extern record`, or `packed record`), not backend guesses.
  **Why this fits Kyokai**: ordinary language layout is specified by the language, foreign layout is explicit at the type declaration, and packed layout is available without relying on backend folklore or a pile of ad hoc repr flags. The reader can see the layout contract directly from the type declaration.
  **[STAGE: DECIDED_CORE_SEMANTICS | D42 → closed record-layout system: language-defined `record`, explicit `extern record`, explicit `packed record`]**
- `**break` never carries a value and loops are not expressions** — Kyokai keeps loop control separate from value production.
**Rules**:
  1. `break` takes no operand.
  2. `for`, `while`, and `while let` are statements, not expressions, and do not produce values.
  3. To get a value out of loop control, code must use an explicit outer binding, `Optional`, `Result`, or another ordinary data structure rather than a loop-expression result.
  **Why this fits Kyokai**: the control-flow model stays uniform, there is no Rust-style special loop-expression case, and the source of an output value remains explicit in ordinary bindings.
  **[STAGE: DECIDED_CORE_SEMANTICS | D43 → no break-with-value; loops remain statements]**
- **Search ergonomics are solved with ordinary `Kyokai.Iter` helpers, not loop-expression results or dedicated search syntax** — Kyokai keeps D43's loop model intact and resolves the common "find the first matching element" pattern with library functions over the already-decided iterator and closure substrate.
**Rules**:
  1. D43 stands unchanged: loops remain statements, and `break` never carries a value.
  2. `Kyokai.Iter` provides ordinary search helpers such as `find` and `findIndex` in addition to D32a's other eager helpers and reductions.
  3. These helpers use the D21/D126 callback family and become lightweight in ordinary code through D118 explicit-capture closure literals.
  4. Kyokai does not add dedicated `find item in collection where ...` syntax.
  **Why this fits Kyokai**: the common search pattern becomes short without turning loops into a partial expression system or adding one-off syntax for a problem that the library surface already solves cleanly.
  **[STAGE: DECIDED_CORE_SEMANTICS | D128 → keep D43; provide ordinary `Kyokai.Iter` search helpers instead of break-with-value or dedicated search syntax]**
- **Loop labels are lexical loop names, and `break`/`continue` may target them explicitly** — nested-loop exits stay visible without inventing loop expressions or state-flag boilerplate.
**Syntax**:
  ```kyokai
  outer: for i from 0 below rows do
      inner: for j from 0 below cols do
          if shouldStop(i, j) then
              break outer;
          fi;
          if shouldSkipRow(i) then
              continue outer;
          fi;
      od;
  od;
  ```
  **Rules**:
  1. A loop statement may be prefixed with a label as `label: for ...` or `label: while ...`.
  2. Unlabeled `break;` and `continue;` still apply to the innermost enclosing loop.
  3. `break label;` and `continue label;` target the lexically named enclosing loop.
  4. The target must name an enclosing loop label in the current function body. Targeting a non-enclosing label or a non-loop construct is illegal.
  5. Two loop labels whose scopes overlap may not reuse the same label name.
  6. D43 remains unchanged: labeled `break` still carries no value and does not make loops expressions.
  **Why this fits Kyokai**: the control-flow jump is explicit in source, compiles to ordinary structured jumps, and avoids both hidden flags and alternate `break` spellings that attach punctuation semantics to the keyword itself.
  **[STAGE: DECIDED_CORE_SEMANTICS | D122 → lexical loop labels with `break label;` / `continue label;`]**
- **Kyokai has no tuple syntax or tuple types** — multi-value structure must be named explicitly, and positional helper records do not become language tuples by stealth.
**Rules**:
  1. The language has no tuple types, tuple literals, tuple destructuring, or positional multi-return syntax.
  2. Parentheses group expressions and delimit call arguments; they do not create tuple values.
  3. Functions that conceptually return multiple values must return a named record or another named type.
  4. Libraries may provide ordinary named record types such as `Pair` or `Triple`, but those are regular records, not special language tuples and not language sugar.
  5. Public APIs should prefer domain-named records whenever field roles matter. Positional helper records are for generic plumbing, not the default API style.
  6. The standard channel constructors follow this rule and return `ChannelEndpoints[T]` with named `sender` and `receiver` fields rather than `Pair[Sender[T], Receiver[T]]`.
  **Why this fits Kyokai**: multi-value data remains self-documenting instead of hiding meaning behind positions, while still allowing plain library records where the domain meaning really is just "first/second/third."
  **[DECIDED: D47/D131 → no tuples; `Pair`/`Triple` remain ordinary records, but public APIs prefer domain-named result types]**
- **Text, code-point, byte, and raw-string literals are distinct** — Kyokai gives each literal family one type and one clearly bounded meaning.
**Literal forms**:
  - `"..."` -> escaped `StaticString`
  - `"""..."""` -> raw multi-line `StaticString`
  - `'A'` -> `Nat32` Unicode code point literal
  - `b'A'` -> `Nat8` byte literal
  **Rules**:
  1. Ordinary escaped and raw multiline text literals produce `StaticString`; escaped literals process escapes and raw multiline literals do not.
  2. The standard escape family is `\\`, `\"`, `\'`, `\n`, `\r`, `\t`, `\0`, `\xNN`, and `\u{HEX...}`.
  3. Raw multi-line string literals process no escapes and preserve their contents exactly between the delimiters.
  4. A code-point literal must denote exactly one Unicode scalar value after escape processing. Surrogate code points are illegal.
  5. A byte literal must denote exactly one byte value after escape processing. Bare source characters in `b'...'` form must be ASCII; non-ASCII byte values require escapes such as `b'\xFF'`.
  6. There is no ambiguous C-style `char` literal family that changes meaning by platform or signedness.
  **Why this fits Kyokai**: systems code gets both raw bytes and Unicode text without inheriting C's `char` confusion or hidden encoding assumptions.
  **[STAGE: DECIDED_CORE_SEMANTICS | D54 → explicit string, raw-string, code-point, and byte literal families]**
- **Array literals use `[...]`, infer only their length, and stay explicit about element typing** — Kyokai treats array-literal size inference as counting, not as magical type deduction.
**Syntax**:
  ```kyokai
  let primes: Array[Int32, 3] := [2, 3, 5];
  let empty: Array[Nat8, 0] := [];
  ```
  **Rules**:
  1. `[e1, e2, ..., en]` constructs an `Array[T, N]` literal with `N` equal to the number of elements written.
  2. Array-literal elements are evaluated in source order per D71.
  3. The element type must resolve to one concrete type under the ordinary type rules and literal-inference rules; ambiguity is a compile-time error.
  4. There are no implicit promotions inside array literals.
  5. Bare `[]` is legal only when context already fixes the target type to `Array[T, 0]`; otherwise it is illegal because the element type is not known.
  6. Repeat syntax, spread syntax, and other array-construction shorthands are not part of Kyokai.
  **Why this fits Kyokai**: the length inference is purely mechanical, but the element type remains explicit or locally forced by ordinary typing rules.
  **[STAGE: DECIDED_CORE_SEMANTICS | D55 → `[e1, ...]` array literals with length inference only; empty literal needs `Array[T, 0]` context]**
- **Kyokai uses a small explicit precedence table instead of either full Austral-style parenthesization or a large C-family precedence ladder** — arithmetic stays readable while bitwise and mixed-operator code stays explicit.
**Precedence levels**:
  1. Postfix: field access `.`, call `(...)`, and indexing `[...]`
  2. Prefix: `&`, `&!`, `~`, unary `-`, `not`, `bnot`
  3. Multiplicative: `*`, `/`, `%`
  4. Additive and concatenation: `+`, binary `-`, `++`
  5. Comparison and equality: `<`, `<=`, `>`, `>=`, `=`, `!=`
  6. Boolean `and`
  7. Boolean `or`
  **Rules**:
  1. Operators at the same precedence level associate left-to-right unless another rule explicitly says otherwise.
  2. Comparison and equality operators do not chain. `a < b < c` and `a = b = c` are illegal without explicit restructuring.
  3. Bitwise and rotate operators (`band`, `bor`, `bxor`, `shl`, `shr`, `rotl`, `rotr`) do not mix implicitly with arithmetic, comparison, or boolean operators. Parentheses are required whenever they are nested with those other binary families.
  4. Different bitwise/shift/rotate operator names do not mix implicitly with one another either. `a band b bor c` and `a shl n shr m` require parentheses.
  5. Same-operator chaining such as `a + b + c`, `a * b * c`, or `a band b band c` is allowed and associates left-to-right.
  **Why this fits Kyokai**: ordinary numeric code does not drown in parentheses, but the operators most likely to cause precedence bugs still require the programmer to show grouping explicitly.
  **[STAGE: DECIDED_CORE_SEMANTICS | D56 → limited explicit precedence; bitwise/shift/rotate mixes require parentheses]**
- **Union construction follows the same visual distinction as record construction, with special cases only for arity one and arity zero** — Kyokai keeps variant syntax predictable without forcing verbose field names for the common `Some(x)` case.
**Forms**:
  - Multi-field variant: `RGB { red: 255, green: 0, blue: 0 }`
  - Single-field variant: `Some(42)`
  - Zero-field variant: `None`
  **Rules**:
  1. A multi-field variant is constructed with `VariantName { field: expr, ... }` and follows the same field rules as D35: every field exactly once, no partial construction, no hidden defaults, and source-order evaluation of field expressions.
  2. A variant with exactly one payload field is constructed with `VariantName(expr)`.
  3. A variant with no payload fields is written as the bare constructor name with no parentheses.
  4. `=>` is not part of variant construction syntax.
  **Why this fits Kyokai**: multi-field variants stay aligned with record construction, single-field variants stay ergonomic, and zero-field variants stop pretending to be nullary calls.
  **[STAGE: DECIDED_CORE_SEMANTICS | D65 → multi-field braces, single-field parens, zero-field bare constructor names]**
- **Indexing syntax is built-in surface sugar over a fixed language-defined indexing protocol family** — Kyokai allows `a[i]` and `a[i] := value` only through compiler-known `Indexable` / `IndexableMut` typeclasses, not through ad hoc name lookup or a special-case list hidden in the compiler.
**Protocol family**:
  ```kyokai
  typeclass Indexable(Self: Type, Idx: Type) is
      type Item;
      method index(self: &[Self], idx: Idx): &[Self.Item];
  spec;

  typeclass IndexableMut(Self: Type, Idx: Type) is
      type Item;
      method indexMut(self: &![Self], idx: Idx): &![Self.Item];
  spec;
  ```
  **Rules**:
  1. `a[i]` is legal only when the selected type implements `Indexable` for the type of `a` and the type of `i`.
  2. `a[i] := value` is legal only when the selected mutable place implements `IndexableMut`; the assignment writes through the returned mutable element borrow.
  3. Invalid indexing according to that type's indexing domain is a uniform language contract violation and triggers TPOE. Implementations may not silently return sentinel values, wrap indices, or choose a different fallback.
  4. Fallible or non-TPOE lookup must use an explicitly named API such as `get`, `tryGet`, or another ordinary function. `[]` is the total-or-TPOE surface only.
  5. The standard library provides `Indexable` / `IndexableMut` instances for arrays, fixed-size arrays, spans, buffers, and any other containers whose own decisions explicitly opt into this protocol family.
  6. `String` is not indexable with `[]` unless a future decision explicitly adds an instance; text indexing is intentionally not treated as ordinary random-access character lookup.
  **Why this fits Kyokai**: the language gets one explicit indexing mechanism instead of a magic whitelist or a loose naming convention, and every `[]` operation keeps the same visible TPOE contract.
  **[DECIDED: D36/D132 → built-in `[]` sugar over fixed `Indexable` / `IndexableMut` typeclasses with uniform TPOE indexing semantics]**
- **Slice syntax is built-in checked half-open sugar for span extraction on standard sequential containers** — Kyokai allows `a[i..j]` because it is the same closed, compiler-known container family as D36 indexing, and its safety contract is stated directly rather than hidden behind ad hoc helper calls.
**Rules**:
  1. Slice syntax is legal only on the same standard sequential container family and ordinary borrowed/mutable-borrowed forms that provide compiler-known sequential indexing under D36.
  2. `a[i..j]` denotes the half-open range beginning at `i` and ending just before `j`.
  3. `a[i..]` means from `i` to `length(a)`. `a[..j]` means from `0` to `j`. `a[..]` means the whole span view.
  4. The required bound relation is `i <= j <= length(a)` after omitted endpoints are filled in. Violation triggers TPOE.
  5. The language contract is this checked range relation, not a raw `j - i` arithmetic formulation.
  6. On an immutable source, the result is `Span[T]`. On a mutable source, the result is `SpanMut[T]`.
  7. `String` does not gain this syntax directly. Text-to-bytes bridging remains explicit through named operations such as `asBytes()`.
  **Why this fits Kyokai**: the everyday half-open slicing pattern becomes readable without weakening the closed-container model, and the bounds contract is explicit instead of being folklore inherited from another language.
  **[STAGE: DECIDED_CORE_SEMANTICS | D106 → built-in checked half-open slice syntax for standard sequential containers; direct bound relation, not `j - i` folklore]**
- **Human-readable formatting is standardized through `Displayable` plus a dedicated formatting-sink abstraction, not through raw byte-stream I/O** — Kyokai separates "render text" from "transport bytes" so display logic does not inherit low-level partial-write semantics.
**Core typeclasses**:
  ```kyokai
  typeclass FormatSink(S: Type) is
      type Error;
      method emitUtf8(out: &![S], chunk: &[Span[Nat8]]): Result[Unit, S.Error];
  spec;

  typeclass Displayable(T: Type) is
      method display[S: FormatSink](value: &[T], out: &![S]): Result[Unit, S.Error];
  spec;
  ```
  **Rules**:
  1. `Displayable` is the standard protocol for human-readable formatting.
  2. `FormatSink` is the rendering-target abstraction. Its `emitUtf8` contract is whole-chunk-or-error, not D66 partial-write semantics.
  3. The bytes passed to `emitUtf8` must encode valid UTF-8 text. Supplying invalid UTF-8 to a safe formatting sink is a contract violation and triggers TPOE.
  4. `StringBuilder` implements `FormatSink` with `Error = AllocError` and follows D74's explicit allocation-failure rules when growth is required.
  5. `Displayable` implementations may emit multiple chunks and may compose by calling `display` on nested fields.
  6. The standard library provides built-in `Displayable` instances for the language's primitive displayable types, including integers, floats, booleans, and strings.
  7. Formatting through `Displayable` is locale-independent and deterministic. The meaning of decimal separators, boolean text, and other standard textual forms does not vary by host locale.
  8. Generic APIs may require `T: Displayable` to render values in a type-safe way, and generic formatting infrastructure may require `S: FormatSink`.
  9. String-embedded placeholder syntax is not part of D40 itself; D40a defines the allocating interpolation path, and D102 defines the direct-to-stream non-allocating path.
  **Why this fits Kyokai**: the display protocol becomes reusable across allocating and non-allocating output paths, while the boundary between text rendering and byte-stream transport stays explicit instead of being hidden inside `Displayable`.
  **[STAGE: DECIDED_CORE_SEMANTICS | D40 → `Displayable` + `FormatSink`; rendering stays separate from raw stream transport; interpolation split to D40a/D102]**
- **Standard error reporting is a standalone diagnostic protocol, not a superclass of `Displayable` and not a requirement on all error payloads** — recoverable errors remain ordinary typed values, while generic logging/reporting gets one explicit optional surface.
**Core typeclass**:
  ```kyokai
  typeclass StandardError(E: Type) is
      method errorName(err: &[E]): StaticString;
      method writeError[S: FormatSink](err: &[E], out: &![S]): Result[Unit, S.Error];
  spec;
  ```
**Rules**:
  1. `StandardError` is optional. A type may be used as the `E` in `Result[T, E]` without implementing `StandardError`.
  2. `StandardError` does not extend `Displayable`, and `Displayable` does not imply `StandardError`.
  3. `errorName` returns a stable, non-localized diagnostic name suitable for logs, metrics, and terse messages.
  4. `writeError` emits human-readable diagnostic text through D40's `FormatSink` and must be deterministic and locale-independent unless a separate localization API is explicitly used.
  5. `StandardError` is for diagnostics, logs, and generic reporting only. It does not participate in ordinary error propagation, `or return`, `let...else`, or type conversion.
  6. Structured error causes/chains are not part of the base interface. If Kyokai adds causal error chains later, that requires a separate D-point covering ownership, allocation, and cycle rules.
**Why this fits Kyokai**: generic diagnostics become possible without making every error printable, importing Rust's trait inheritance shape, or pretending error causality is free.
  **[STAGE: DECIDED_CORE_SEMANTICS | D259 → standalone optional `StandardError` diagnostic typeclass; no `Displayable` inheritance and no base `source()` chain]**
- **I/O stream abstraction is byte-oriented, minimal, and layered** — Kyokai uses small `Readable`/`Writable` typeclasses for byte streams and puts convenience helpers on top instead of baking every policy into the core trait.
**Core typeclasses**:
  ```kyokai
  typeclass Readable(T: Type) is
      method read(stream: &![T], buf: &![SpanMut[Nat8]]): Result[Index, IoError];
  spec;

  typeclass Writable(T: Type) is
      method write(stream: &![T], buf: &[Span[Nat8]]): Result[Index, IoError];
      method flush(stream: &![T]): Result[Unit, IoError];
  spec;
  ```
  **Rules**:
  1. These stream traits are byte-oriented. Text decoding and text encoding wrappers live above them; they are not implicit parts of the core I/O contract.
  2. `Span[T]` is an immutable borrowed view of contiguous memory. `SpanMut[T]` is the mutable equivalent, providing a view of contiguous memory that allows modifying the elements. It is an alias for `&![Span[T]]` or a distinct type, depending on backend representation, but conceptually it represents a mutable slice.
  3. `read` may perform a partial read. `Ok(0)` means end-of-file or end-of-stream in the normal stream sense.
  4. `write` may perform a partial write. `Ok(n)` means exactly `n` bytes were accepted. `Ok(0)` means no bytes were accepted; `writeAll`-style helpers must treat repeated zero-byte success on non-empty input as a no-progress error rather than looping forever.
  5. I/O failure is reported through `Result[..., IoError]`, not through TPOE, unless a separate API explicitly states a TPOE contract.
  6. Convenience operations such as `readExact`, `writeAll`, and `copyAll` are ordinary library functions layered on top of these minimal traits.
  7. Buffered wrappers remain explicit adapter types; core `Readable`/`Writable` does not imply buffering.
  **Why this fits Kyokai**: the abstraction is strong enough for generic file/socket/memory-copy code, but still small, explicit, and aligned with the language's text-vs-bytes separation and result-based I/O error handling.
  **[STAGE: DECIDED_CORE_SEMANTICS | D66 → minimal byte-oriented `Readable`/`Writable` with explicit helpers and flush]**
- **Allocator choice is explicit, value-level, and never ambient** — Kyokai supports custom allocators without infecting every container type with an allocator parameter and without hiding allocation policy behind a global default.
**Core typeclass**:
  ```kyokai
  typeclass Allocator(A: Type) is
      method allocate(alloc: &![A], size: Index, align: Index): Result[Address[Nat8], AllocError];
      method deallocate(alloc: &![A], ptr: Address[Nat8], size: Index, align: Index): Unit;
      method reallocate(
          alloc: &![A],
          ptr: Address[Nat8],
          oldSize: Index,
          newSize: Index,
          align: Index
      ): Result[Address[Nat8], AllocError];
  spec;
  ```
  **Rules**:
  1. Core allocating APIs require an explicit allocator value at the construction site. Kyokai does not use an ambient global allocator as the silent default for dynamic containers.
  2. Allocators are ordinary values/capabilities, not container type parameters. `Buffer[T]` does not become `Buffer[T, A]`.
  3. Owning dynamic containers must store allocator identity as runtime state so that in-place growth, shrink, and destruction use the same allocator that created the storage.
  4. Operations that create a new owned container from existing data require an explicit destination allocator unless a more specific rule is stated. The standard naming pattern is `...In`, such as `cloneIn`, `concatIn`, or `collectIn`.
  5. Ordinary allocation failure is reported through `Result[..., AllocError]` by default, per D74. Fatal convenience forms are allowed only when their names make the policy explicit, such as `mustMakeByteBuf`.
  6. Kyokai's ordinary `Allocator` abstraction is for allocators that support individual deallocation and reallocation. Pool-style allocators fit here if they satisfy that contract.
  7. Pure bump/arena allocators are not standardized as ordinary general-purpose container allocators. D96 defines them separately as scoped non-escaping region allocators rather than as ordinary `Allocator` implementations.
  8. Kyokai does not define hidden allocator propagation rules such as "new containers use the left-hand operand's allocator". If an operation allocates a fresh owned result, the allocator choice must be explicit unless a narrower rule is written down.
  9. **Container destruction**: Containers store explicit allocator runtime state internally so that destruction and in-place growth use the same allocator choice that created the storage. This stored allocator state is part of the container's own runtime representation under D44/D130, not a borrow to ambient caller state and not a hidden typeclass dictionary. Arena-style scoped bulk allocators belong to D96 instead of this ordinary container-destruction path.
  10. Kyokai does not provide `Allocator.default()`, ambient allocator lookup, implicit lexical allocator context, or thread-local allocator selection.
  11. Deep call stacks that need allocation should pass an ordinary explicit context value containing the allocator and any other needed authority or policy. Such context values are user-visible parameters, not language-level implicit parameters.
  **Examples**:
  ```kyokai
  var heap := root.systemAllocator();

  let Ok(out) := heap.makeByteBuf(16384) else Err(ignore) do
      return ExitOutOfMemory();
  fi;
  defer out.destroy();

  let Ok(copy) := out.cloneIn(&!heap) else Err(ignore) do
      return ExitOutOfMemory();
  fi;
  defer copy.destroy();
  ```
  ```kyokai
  var heap := root.systemAllocator();

  var out := heap.mustMakeByteBuf(16384);
  defer out.destroy();
  ```
  **Why this fits Kyokai**: allocator policy remains visible in source, OOM behavior stays explicit, containers avoid viral allocator type parameters, and ordinary allocator-backed containers stay separate from D96's scoped arena model instead of quietly depending on hidden lifetime coupling.
  **[STAGE: DECIDED_CORE_SEMANTICS | D44/D250 → explicit value-level allocator choice; no hidden/default/thread-local allocator; ordinary `Allocator` for individually deallocatable storage only]**
- **Allocator participation in stdlib APIs is determined by the storage effect of the operation, and fresh owned results never silently inherit a destination allocator** — Kyokai makes allocation choice visible at the exact boundary where new owned storage may appear.
**Rules**:
  1. Operations that mutate an existing owning value in place use that value's stored allocator when they need to grow, shrink, or reallocate. They do not take a separate destination allocator parameter.
  2. Operations that return only borrowed views or other non-owning results do not take an allocator parameter and must not allocate.
  3. Operations that produce a fresh owned value from borrowed data, from iteration, or from multiple inputs require an explicit destination allocator unless a more specific rule states that the result reuses existing storage without fresh allocation.
  4. The standard naming pattern for rule 3 is `...In`, such as `cloneIn`, `toStringIn`, `concatIn`, and `collectIn`.
  5. Consuming conversions named `into*` may omit a destination allocator only when their contract guarantees that the result is formed by ownership transfer, storage reuse, or another non-allocating transformation.
  6. If a consuming conversion may need fresh destination allocation as part of ordinary successful execution, it must take an explicit destination allocator and use an allocator-explicit spelling such as `intoBytesIn`.
  7. Built-in allocating constructs that are not ordinary methods or library functions, such as `format(alloc, ...)`, still follow the same principle: destination allocation is explicit even when the surface does not use an `...In` suffix.
  8. Kyokai defines no hidden destination-allocator inheritance from the receiver, the left-hand operand, the current module, the current task, or any ambient default allocator.
  9. Standard-library documentation and `.kyo` interfaces must make each API's allocator behavior class obvious: in-place using stored allocator, non-allocating view/borrow, consuming storage-reuse conversion, or fresh-allocation-with-explicit-destination.
  10. Owning containers store allocator identity as ordinary runtime state chosen explicitly in source. This is not an existential type, not a trait object, not a hidden generic dictionary, and not a viral allocator type parameter.
  11. `Buffer[T]`, `String`, and ordinary owning containers remain parameterized by their element or domain types only. They do not become `Buffer[T, A]` or acquire default allocator type parameters.
  **Examples**:
  ```kyokai
  let text: String := bytes.toStringIn(&!heap) or return;
  let copy: Buffer[Nat8] := buf.cloneIn(&!heap) or return;
  let merged: Buffer[Nat8] := collectIn(&!heap, iter) or return;

  buf.push(byte) or return;           // uses buf's stored allocator if growth is needed
  let span := buf.asSpan();           // view only, no allocation
  let raw: ByteBuf := text.intoBytes(); // consuming storage transfer, no destination allocator
  ```
  **Why this fits Kyokai**: every fresh owned allocation site stays explicit, existing containers still mutate ergonomically through their stored allocator, and the naming surface now tells both the ownership story and the allocator story without hidden propagation rules.
  **[STAGE: DECIDED_CORE_SEMANTICS | D201/D251 → stdlib allocator participation follows storage effect; fresh owned results require explicit destination allocator; allocator identity is explicit runtime state, not type erasure or allocator type parameters]**
- **Arenas are a separate linear scoped-allocation model, not ordinary `Allocator` implementations** — Kyokai supports arena/bump-style bulk allocation safely, but only through the region system and only as an explicit non-escaping model rather than by pretending arena-backed ordinary containers are the same thing as heap-backed owned containers.
**Rules**:
  1. `Arena` is a `Linear` region allocator type distinct from D44's ordinary `Allocator` abstraction.
  2. Creating an arena is explicit and fallible. Any backing-storage allocation uses an ordinary allocator and therefore follows D74's `AllocError` rules unless an explicitly named fatal convenience API is chosen.
  3. Safe arena allocation occurs only through an explicit borrow of the arena. Arena-derived values and borrows are tied to that borrow region under D6; they cannot escape the borrow scope that produced them.
  4. Individual deallocation of arena allocations does not exist.
  5. Bulk free is explicit and consuming. Destroying an arena consumes it. Resetting an arena, if provided, also consumes the old arena state and returns a fresh empty arena state.
  6. Because bulk free consumes the arena, it is statically illegal while arena borrows or arena-derived values tied to the active borrow region remain live.
  7. Arenas do not implement the ordinary `Allocator` interface for `Buffer[T]`, `StringBuilder`, or other ordinary owning container types.
  8. If the standard library provides growable arena-local collection types, they are distinct arena-scoped types whose validity remains tied to the arena borrow/region. They are not secretly arena-backed ordinary owning containers.
  9. Moving data from arena-local storage into an ordinary owned container requires an explicit copy into an ordinary allocator-backed destination. There is no implicit escape or hidden promotion from arena-local storage to general owned storage.
  10. Unsafe code may still take raw addresses into arena storage, but safe code gets no escape hatch around the region/non-escape rules.
  **Why this fits Kyokai**: parsers, compilers, game loops, and batch pipelines get real bulk-allocation performance, but Kyokai keeps the lifetime story explicit by making arenas live inside the existing region model rather than hand-waving about "allocator lifetime" in ordinary owned containers.
  **[STAGE: DECIDED_CORE_SEMANTICS | D96 → arenas are separate linear region allocators; arena-derived values are non-escaping; bulk free/reset are explicit consuming operations]**
- **OS-native strings and paths are dedicated types, not UTF-8 `String` by convention** — filesystems and process boundaries are not uniformly UTF-8 across targets, so Kyokai models native text and paths explicitly instead of pretending `String` is the right type everywhere.
**Core types**:
  ```kyokai
  OsString   // owned platform-native text
  OsStr      // borrowed platform-native text view
  PathBuf    // owned path buffer wrapping OsString
  Path       // borrowed path view wrapping OsStr
  ```
  **Rules**:
  1. `OsString` is an owned platform-native string type and is not guaranteed UTF-8. `OsStr` is its borrowed view.
  2. `PathBuf` is the owned path type and wraps `OsString`. `Path` is the borrowed path-view type and wraps `OsStr`.
  3. On Unix-like targets, the platform-native representation is an arbitrary non-NUL byte sequence. On Windows, it is the platform's native wide-path representation. Safe Kyokai does not collapse those into one fake UTF-8 contract.
  4. Filesystem APIs accept borrowed `Path` values and return `PathBuf` values. They do not use `String` as the path type.
  5. Path operations are lexical only. The standard path surface includes operations such as `join`, `parent`, `fileName`, `extension`, `components`, `isAbsolute`, and `isRelative`.
  6. Path operations perform no implicit normalization, canonicalization, case-folding, separator rewriting, symlink resolution, or `.` / `..` collapse.
  7. Equality on `OsStr`, `OsString`, `Path`, and `PathBuf` is stored-representation equality, not filesystem identity.
  8. Conversion from `OsStr`/`Path` to `String` is explicit and fallible because the platform-native representation may not be valid UTF-8.
  9. Conversion from `String` to `OsString`/`PathBuf` is explicit and validating. It must reject interior NUL.
  10. There is no implicit conversion between `String` and OS-native string/path types in either direction.
  11. This decision does not silently settle argv, environment, process-title, or other OS-text boundaries. Those surfaces need their own explicit contracts; they must not inherit `String` merely because `OsString` now exists.
  **Why this fits Kyokai**: paths and native OS text stop being folklore carried by `String`, while the exact places where UTF-8 validity is or is not guaranteed remain visible in the type system.
  **[STAGE: DECIDED_CORE_SEMANTICS | D97 → dedicated `OsString`/`OsStr` + `PathBuf`/`Path`; lexical-only path ops; no implicit UTF-8/path conversion]**
- **Type aliases are explicit transparent synonyms, not new nominal types** — Kyokai allows aliasing existing types for ergonomics, but the syntax must say clearly that an alias does not create a new type identity.
**Syntax**:
  ```kyokai
  type alias FileDescriptor := Int32;
  type alias IoResult[T] := Result[T, IoError];
  ```
  **Rules**:
  1. `type alias Name := Target;` creates a transparent synonym for `Target`.
  2. An alias introduces no new nominal identity, no new ABI identity, and no separate typeclass/coherence identity.
  3. Alias and target type are identical for assignment, parameter passing, instance lookup, pattern typing, and foreign layout.
  4. Generic aliases are allowed.
  5. Cyclic aliases are illegal.
  6. If a programmer needs a semantically distinct domain type or invariant boundary, they must use a record/newtype rather than an alias.
  **Why this fits Kyokai**: the programmer writes exactly what they mean, aliases help FFI and library ergonomics, and the language does not pretend a pure synonym is a safety feature.
  **[STAGE: DECIDED_CORE_SEMANTICS | D50 → explicit `type alias` syntax for transparent synonyms only]**
- **Foreign integer constant domains and bitflags use explicit integer aliases plus named constants, not a separate language-level C-enum kind** — Kyokai keeps its own semantic enums as unions and models raw C-style integer domains honestly at the FFI edge.
**Syntax**:
  ```kyokai
  type alias OpenFlags := Int32;
  constant O_RDONLY: OpenFlags := 0;
  constant O_CLOEXEC: OpenFlags := 0x80000;
  ```
  **Rules**:
  1. When a foreign API exposes a named integer domain or bitflag set and its ABI representation is explicitly fixed, Kyokai models that raw surface as a `type alias` to the chosen integer type plus named `constant` declarations.
  2. This model does not create a closed set or a nominal type. Any value representable by the underlying integer type is also representable by the alias.
  3. Kyokai does not add a separate language-level “C enum” construct. Kyokai's semantic enums remain unions with exhaustive pattern matching.
  4. If safe Kyokai code wants a closed semantic domain, it must wrap or translate the raw integer form into a union or another nominal type.
  5. Kyokai never guesses the representation of a foreign `enum`. If the binding contract does not make the integer representation explicit, the API must go through a C shim or another separately specified mapping.
  6. Bitflag combination and testing use Kyokai's ordinary explicit bitwise operators from D41 on the chosen integer representation.
  **Why this fits Kyokai**: the raw boundary stays ABI-honest and explicit, while safe wrappers can still expose stronger domain semantics when the foreign API actually supports them.
  **[STAGE: DECIDED_CORE_SEMANTICS | D61 → foreign integer constant domains and bitflags use explicit integer aliases + constants; closed semantics belong in wrappers]**
- **Non-byte-aligned field layouts use `bitrecord`, not C-style bitfields** — Kyokai supports readable register and protocol definitions, but it defines them against explicit integer bit positions rather than backend-defined memory layout folklore.
**Syntax**:
  ```kyokai
  bitrecord TcpFlags: Nat16 is
      reserved bits 15..13;
      field dataOffset: bits 12..9;
      reserved bits 8..6;
      field urg: bit 5;
      field ack: bit 4;
      field psh: bit 3;
      field rst: bit 2;
      field syn: bit 1;
      field fin: bit 0;
  build;
  ```
  **Rules**:
  1. `bitrecord Name: NatN is ... build;` defines a nominal value type backed by exactly one fixed-width unsigned integer type: `Nat8`, `Nat16`, `Nat32`, or `Nat64`.
  2. Bit positions are numbered from `0` at the least-significant bit to `N - 1` at the most-significant bit of the backing integer value.
  3. `field name: bit k;` defines a one-bit boolean field. `field name: bits hi..lo;` defines an unsigned integer field over the inclusive range `hi` down to `lo`.
  4. Every bit of the backing integer must be covered exactly once by either a `field` declaration or a `reserved` declaration. Overlap, gaps, empty ranges, or out-of-range positions are compile-time errors.
  5. A `bitrecord` supports explicit raw conversion with `toBits(self)` and `fromBits(bits)`. `toBits` returns the backing integer exactly. `fromBits` preserves the backing integer exactly.
  6. Named construction is explicit and field-based: `TcpFlags { dataOffset: 5, urg: false, ack: true, ... }`. Every non-reserved field must be provided exactly once, and all reserved bits are set to zero by named construction.
  7. Projecting `value.field` copies the decoded field value out of the backing integer. One-bit fields have type `Bool`. Multi-bit fields have the backing integer type with the selected bit range shifted down so its least-significant field bit becomes bit `0`.
  8. Assigning a multi-bit field value through named construction is checked against the declared field width. If any non-zero bits would be truncated, the program is rejected at compile time for compile-time-known values and TPOE at runtime otherwise.
  9. Bitrecord fields have no address and no borrow semantics. Taking `&value.field` or `&!value.field` is illegal. A bitrecord does not expose C-style lvalue field overlays.
  10. `bitrecord` is distinct from D42's `record`, `extern record`, and `packed record` layout classes. When a `bitrecord` value is stored in memory, its storage is exactly the storage of its backing integer type.
  11. Endianness is handled separately by D117. Serializing or parsing a `bitrecord` across a byte boundary must go through the backing integer plus explicit endian conversion / byte-encoding helpers.
  12. The C backend lowers bitrecord access with masks, shifts, and equivalent helper code only. It never emits C bitfields as the semantic implementation strategy.
  **Why this fits Kyokai**: hardware headers and protocol words become readable without importing C's compiler-dependent bitfield rules or leaving truncation/layout behavior implicit.
  **[STAGE: DECIDED_CORE_SEMANTICS | D116 → explicit `bitrecord` values over fixed-width unsigned backing integers; masks/shifts only; no C-style or backend-defined bitfields]**
- **Endianness operations are explicit fixed-width integer transforms plus explicit byte encoding helpers** — Kyokai does not hide byte order in FFI, packed layout, or I/O boundaries; the programmer names the conversion and the exact bytes they want.
**Rules**:
  1. This decision applies only to the built-in fixed-width integer families such as `Int8`, `Int16`, `Int32`, `Int64`, `Nat8`, `Nat16`, `Nat32`, and `Nat64`. It does not apply to floats, records, unions, `String`, or target-dependent integer types such as `Index`.
  2. Every fixed-width integer type provides `swapBytes()`, `toBigEndian()`, `toLittleEndian()`, `fromBigEndian()`, and `fromLittleEndian()`.
  3. For one-byte integer types, all of these operations are identity operations.
  4. `swapBytes()` means unconditional byte reversal.
  5. `toBigEndian()` / `toLittleEndian()` and `fromBigEndian()` / `fromLittleEndian()` are defined in terms of `target.endianness`. On a target whose endianness already matches the requested form, the operation is a no-op; otherwise it is the corresponding byte swap.
  6. `target.endianness` is a language-level comptime constant of enum type `Endian` with variants `Endian.Little` and `Endian.Big`.
  7. The standard library also provides explicit byte-array encoding and decoding helpers for fixed-width integers, equivalent to `toBigEndianBytes()`, `toLittleEndianBytes()`, `fromBigEndianBytes(...)`, and `fromLittleEndianBytes(...)`, because value-level endianness transforms alone do not specify wire-format byte layout.
  8. Kyokai performs no automatic byte swapping in `packed record`, FFI boundaries, file I/O, network I/O, or containers. Any endianness conversion at those boundaries must be written explicitly.
  **Why this fits Kyokai**: network and file-format code gets the operations it actually needs, while byte order stays a named visible step instead of a backend- or platform-driven surprise.
  **[STAGE: DECIDED_CORE_SEMANTICS | D117/D260 → fixed-width integer endianness methods + explicit byte-array encode/decode helpers; no automatic boundary swapping]**
- `**debug` is a language-level built-in keyword for development-only console output; production console I/O requires `TerminalCapability`** — Kyokai splits console output into two completely separate mechanisms with different rules, different build behavior, and different philosophical status.
**Debug output — the `debug` keyword**:
  ```kyokai
  debug expr;    // built-in keyword — prints Displayable repr to stderr + newline
  debug "hello"; // string literal form
  debug x;       // any Displayable (D40) expression
  ```
  **Rules**:
  1. `debug expr;` is a language-level built-in construct, like `panic(message)` or `return expr`. It is not a function call, not a module import, and not UFCS.
  2. `expr` must satisfy `Displayable` (D40).
  3. Output goes to stderr.
  4. In release builds, the compiler strips `debug` statements entirely — no code is emitted.
  5. In debug and test builds, `debug` emits to stderr.
  6. The compiler emits a warning if `debug` appears in non-test code under release profile.
  7. `debug` does NOT require any capability, does NOT appear in the module's interface, and is NOT part of the program's observable behavior contract.
  8. `debug` is instrumentation — like a debugger breakpoint. It exists outside the capability model.
  9. **Linearity interaction**: `debug x;` immutably borrows `x` (`&[x]`) to pass to `Displayable`. It does NOT consume linear values. This is crucial because `debug` statements disappear in release builds; if they consumed values, release builds would fail linearity checks.
  10. In debug and test builds, `debug` formats through the same D40/D40a/D102 machinery and performs a best-effort stderr write. If stderr output fails, the failure is ignored and `debug` does not change program control flow.
  11. The operand of `debug expr;` is a debug-observation expression, not an unrestricted ordinary expression.
  12. A debug-observation expression may observe an already-existing value through local names, constants, literals, immutable field projection, immutable index/slice projection, and parenthesized composition of those forms.
  13. A debug-observation expression may not contain ordinary function calls, UFCS calls, constructors that allocate, arithmetic or comparison operations that may TPOE, assignment, `comptime`, `panic`, `return`, `break`, `continue`, `or ...`, `defer`, or any capability-using operation.
  14. If the programmer wants to debug a computed value, the computation must be bound in ordinary code first, and then that binding may be observed with `debug`.
  15. Formatting and best-effort stderr emission performed by the `debug` machinery are debug/test-profile instrumentation effects only; they may not affect ordinary program state, capability flow, or linear obligations.
  **Debug expression purity**: D233 closes the profile-equivalence hole in D45. Because release builds strip `debug`, the expression inside `debug` cannot be the only place where a value is consumed, a mutable borrow is created, a side effect happens, or a possible contract failure is introduced.
  **[STAGE: DECIDED_CORE_SEMANTICS | D233 → `debug` observes existing values only; no linear consumption, mutable borrow creation, ordinary side effects, or profile-dependent control flow]**
  **Production output — capability-gated**:
  ```kyokai
  function main(root: RootCapability, args: &[Span[String]]): ExitCode is
      let terminal: TerminalCapability := acquireTerminal(&!root);
      defer releaseTerminal(terminal);
      Io.writeLn(&!terminal, "Hello, world");
  qed;
  ```
  **Rules**:
  1. `Io.writeLn`, `Io.write`, and all production console output functions require `TerminalCapability`.
  2. `TerminalCapability` is acquired from `RootCapability` — the capability chain is explicit.
  3. This is ordinary capability-gated I/O, no different from file I/O or network I/O.
  **Build behavior**:

  | Build mode | `debug expr;`                                              | `Io.writeLn(...)`                             |
  | ---------- | ---------------------------------------------------------- | --------------------------------------------- |
  | Debug      | Available. Writes to stderr.                               | Available. Requires capability.               |
  | Release    | **Stripped** (calls removed). Compiler warning if present. | Available. Requires capability.               |
  | Test       | Available. Writes to stderr.                               | Available. Test runner provides capabilities. |

  **Why `debug` is a keyword, not `debug.print()` or `Debug.print()`**: `debug.print()` looks like module access (`Module.function()`), which would imply it's imported, has a module interface, and participates in the normal module system. It is none of those things. Making it a keyword puts it in the same syntactic category as `panic` — a built-in construct the compiler knows about and handles specially.
  **Why this is philosophically acceptable**: `debug` is explicitly NOT part of the program's intended behavior. It is development instrumentation. The `debug` keyword makes it visually distinct, the compiler warns about it, and release builds strip it. The capability model is not compromised because `debug` is defined as outside the model — the same way `panic` is outside normal control flow.
  **Why not full capability enforcement**: every language with capability-based I/O provides an escape hatch for debugging. Haskell has `Debug.Trace.trace`. Requiring `TerminalCapability` for ephemeral debug prints would force capability threading through every function just to add a temporary print statement. That is ceremony that impedes development for zero safety benefit — debug prints are ephemeral and stripped before shipping.
  **[STAGE: DECIDED_CORE_SEMANTICS | D45 → `debug` keyword for development-only output; production I/O via `TerminalCapability`; `debug` is stripped in release builds]**
- **The standard library follows the Rewrite-It-In-Kyokai (RIIK) principle: pure Kyokai implementations over FFI wrappers whenever mathematically and logically possible** — this is not a guideline; it is a design constraint that governs every standard library decision.
**Rules**:
  1. **Pure computation must be written in pure Kyokai.** This includes: math functions (H02, H03), string parsing (D69), sorting (M03), hashing (H04), cryptographic primitives, compression, encoding/decoding, data structure implementations, and any algorithm that takes inputs and produces outputs without interacting with the host OS.
  2. **OS interaction is the only legitimate use of FFI in the standard library.** This includes: syscalls, file I/O, networking, threading primitives, memory allocation (the allocator itself, not containers built on top), process spawning, and signal handling. These require FFI because they interact with the host kernel — there is no pure alternative.
  3. **Even FFI-allowed code must have a thin trust boundary.** The FFI call itself lives in a `pragma Unsafe_Module`. The public API exposed to safe Kyokai code must be a safe wrapper that enforces linearity, capability requirements, and error handling (D20/D20a/D20b). The unsafe surface is as small as possible.
  4. **Complex legacy protocols may use FFI transitionally.** External codebases like SQLite or TLS libraries may be wrapped via FFI initially. The long-term roadmap prioritizes pure Kyokai ports where feasible, but transitional FFI is acceptable when the alternative is no functionality.
  **Why this is a design constraint, not a preference**:
  1. **Safety**: every FFI call is an escape hatch from the linear type system, memory safety, and capability model. Pure Kyokai code is mechanically verified by the compiler. FFI code is trusted on faith.
  2. **Portability**: relying on `libc` or `libm` ties the language to the host OS's C implementation quirks. A pure Kyokai `sin()` behaves identically across all platforms.
  3. **Capability model**: FFI calls often hide global state or side effects (e.g., `errno`). Pure Kyokai implementations respect the capability model natively.
  4. **Reproducibility**: D83 (reproducible builds) is undermined if stdlib behavior depends on which `libm` version the host shipped.
  **Why this is already the operating principle**: H02 (math library) explicitly requires pure Kyokai implementations. H03 (trig/exponentials) explicitly requires pure implementations. D30/D30a (string encoding) define text handling in Kyokai terms, not as wrappers around `libc` string functions. D44 (allocator abstraction) wraps the syscall-level allocator but builds all container logic in pure Kyokai. The RIIK principle is already threaded through the plan — D64 formalizes it.
  **[STAGE: DECIDED_CORE_SEMANTICS | D64 → RIIK principle: pure Kyokai for computation, FFI only for OS interaction, thin trust boundaries on all FFI, transitional FFI for legacy protocols]**
- **Standard-library admission requires explicit correctness evidence before an API ships as `Kyokai.*`** — RIIK is not permission to rewrite hard domains casually; standard-library code must carry a stated contract and enough evidence to make that contract credible.
**Rules**:
  1. A public `Kyokai.*` API is admitted only with a written semantic contract, edge-case behavior, allocation/failure behavior, portability notes, and conformance tests.
  2. Algorithms with external standards, reference test vectors, or mature independent implementations must name the standard or oracle used for admission tests.
  3. Numerics, parsing, encodings, compression, cryptography, collections, and other correctness-sensitive domains require tests against an oracle or independent reference where one exists, plus fuzzing or property tests where input space makes exhaustive checking infeasible.
  4. Pure computation should be implemented in safe Kyokai unless the domain has a specific boundary reason to use unsafe or FFI.
  5. Unsafe or FFI-backed implementations require an unsafe contract and must expose a safe API whose behavior is fully specified.
  6. Legacy, insecure, or compatibility-only algorithms may exist only under explicitly named compatibility modules. They are not presented as preferred modern defaults.
  7. Documentation and conformance metadata must state the admitted contract clearly enough for `kyokai doc`, tests, and package audit tooling to surface it.
  **Why this fits Kyokai**: the standard library is part of the language's safety story, so its algorithms need explicit evidence rather than folklore trust.
  **[STAGE: DECIDED_CORE_SEMANTICS | D229 → stdlib admission requires contracts, edge-case rules, oracle/tests, and explicit legacy/compatibility boundaries]**
- **Transitional FFI is allowed for bootstrap and hard external boundaries, but it must be tracked and wrapped rather than normalized as the final shape of pure computation** — Kyokai can be pragmatic while still keeping RIIK as the destination for ordinary algorithms.
**Rules**:
  1. Bootstrap and transitional implementations may use FFI wrappers when the wrapped facility is an OS or hardware boundary, a mature external dependency needed before Kyokai can self-host, or a temporary bridge recorded in the implementation plan.
  2. Every transitional FFI wrapper must live in a `pragma Unsafe_Module`, have an unsafe contract, expose a safe Kyokai API when used by safe code, and document whether it is permanent boundary code or replacement-target bootstrap code.
  3. Pure computation should not remain FFI-backed once a correct native Kyokai implementation is available and admitted under D229, unless a separate decision justifies the exception.
  4. Transitional FFI does not relax D20, D64, D73, D242, D242a, or D245.
  5. The compiler, standard library, and toolchain may use OCaml, C, or other implementation languages during bootstrap, but the language design may not depend on those implementation-language escape hatches as user-visible semantics.
  **Why this fits Kyokai**: the project can reach self-hosting without pretending every temporary bridge is philosophically permanent.
  **[STAGE: DECIDED_CORE_SEMANTICS | D230 → transitional FFI allowed for bootstrap/external boundaries under unsafe contracts and replacement tracking]**
- **Cryptography in the standard library is standards-bound, test-vector-bound, and side-channel-explicit; Kyokai does not invent crypto** — crypto is admitted only with stronger evidence than ordinary pure algorithms, but it is not forced to remain FFI-only forever.
**Rules**:
  1. `Kyokai.Crypto` may include only named, modern, externally specified algorithms and protocols with published test vectors and documented security properties.
  2. The standard library must not invent novel cryptographic primitives, modes, protocols, padding schemes, key derivation schemes, or random constructions.
  3. A native Kyokai crypto implementation is admissible only when it has independent review appropriate to the primitive's risk, passes official test vectors, documents constant-time and side-channel claims, and has conformance tests that protect those claims where tooling can observe them.
  4. FFI-backed crypto is allowed and often preferred when wrapping a mature audited library, but the wrapper must state ownership, initialization, randomness, error, threading, version, algorithm-availability, and cleanup contracts.
  5. OS entropy acquisition remains an OS boundary and must use capability-gated APIs under the randomness contract.
  6. APIs must separate cryptographic and non-cryptographic use. Convenience speed-oriented RNGs, hashes, and checksums must not be presented as cryptographic primitives.
  7. Deprecated or compatibility-only crypto may exist only in explicitly named compatibility modules with warnings in contract metadata.
  **Why this fits Kyokai**: crypto needs more than pure-language memory safety. The language can still RIIK where justified, but only after the algorithm, tests, and side-channel contract are explicit.
  **[STAGE: DECIDED_CORE_SEMANTICS | D231 → stdlib crypto requires modern external specs, test vectors, side-channel contracts, and review; FFI allowed but not mandatory forever]**
- **Environment variables require `EnvCapability` — the environment is global mutable state and must be capability-gated** — reading environment variables can change program behavior based on external factors; modifying them affects child processes. Kyokai treats the process environment as external state that requires the same explicit capability discipline as the filesystem or network.
**API**:
  ```kyokai
  function getEnv(env: &![EnvCapability], key: &[String]): Optional[String];
  function setEnv(env: &![EnvCapability], key: &[String], value: &[String]): Result[Unit, EnvError];
  function removeEnv(env: &![EnvCapability], key: &[String]): Result[Unit, EnvError];
  ```
  **Rules**:
  1. `EnvCapability` is acquired from `RootCapability`, like all other capability types.
  2. `getEnv` returns `Optional[String]` — `None` if the variable is not set. No TPOE on missing variables.
  3. `setEnv` and `removeEnv` return `Result` because the OS may reject the operation.
  4. There is no global `getenv()` function. Any code that reads environment variables must receive `EnvCapability` explicitly.
  5. The capability is mutably borrowed (`&!`) because even reading the environment is observation of external mutable state.
  **Why this fits Kyokai**: the environment is hidden global state in every other systems language. Capability-gating it makes the dependency on external state visible in function signatures. If a function reads `$HOME`, its signature says so.
  **[STAGE: DECIDED_CORE_SEMANTICS | D67 → `EnvCapability` for all environment variable access; no ambient `getenv`]**
- **Filesystem access is capability-gated, path-typed, and free of ambient current-directory semantics** — Kyokai defines safe file and directory operations explicitly instead of inheriting a process-global cwd model from C and POSIX folklore.
**Core types**:
  ```kyokai
  record File is
      // opaque
  build;

  record Directory is
      // opaque
  build;

  union OpenMode is
      case ReadOnly;
      case WriteOnly;
      case ReadWrite;
      case Append;
  build;

  union SeekFrom is
      case FromStart(offset: Index);
      case FromCurrent(delta: Int64);
      case FromEnd(delta: Int64);
  build;

  union FileKind is
      case Regular;
      case Directory;
      case Symlink;
      case CharacterDevice;
      case BlockDevice;
      case Fifo;
      case Socket;
      case Other;
  build;

  record Metadata is
      kind: FileKind;
      size: Index;
  build;
  ```
  **Rules**:
  1. `FileCapability` is acquired explicitly from `RootCapability`.
  2. Safe filesystem APIs are capability-gated. There are no ambient global file or directory functions.
  3. Filesystem APIs take `Path` / `PathBuf`, not `String`.
  4. `File` and `Directory` are linear resource handles.
  5. `File` implements D66's `Readable` and `Writable` contracts when opened in a mode that permits those operations.
  6. `File` exposes explicit operations such as `seek`, `flush`, `sync`, and `metadata`; ordinary failures return `Result[..., IoError]`.
  7. Namespace operations such as opening files, creating files, renaming, removing files, creating directories, removing directories, and querying metadata are exposed through `FileCapability` and explicit `Directory` handles.
  8. Safe Kyokai does not rely on an ambient process current working directory for path resolution.
  9. Any operation on a relative path must name an explicit base `Directory` handle.
  10. Top-level `FileCapability` path operations therefore work on absolute paths only.
  11. If a hosted target exposes the process working directory, it does so only through an explicit capability-gated API returning a `Directory` handle.
  12. Filesystem errors are ordinary `IoError` results, not TPOE, unless some separate API explicitly states a stronger contract.
  **Why this fits Kyokai**: file authority stays explicit, path encoding stays honest through `Path`/`OsString`, and the language does not quietly reintroduce hidden process-global state through cwd-based resolution.
  **[STAGE: DECIDED_CORE_SEMANTICS | D171 → `FileCapability` plus explicit `File`/`Directory` handles, `Path`-typed APIs, no ambient cwd semantics, and ordinary `IoError` failures]**
- **Time splits into pure monotonic measurement values and capability-gated observable clock/sleep authority** — Kyokai keeps benchmarking and timeout arithmetic lightweight while still treating wall-clock observation and suspension as explicit external authority.
**Core types**:
  ```kyokai
  record Duration is
      // value type
  build;

  record Instant is
      // opaque monotonic timestamp
  build;

  record SystemTime is
      // opaque wall-clock timestamp
  build;
  ```
  **Rules**:
  1. `Duration` is a pure `Free` value type for elapsed-time quantities and arithmetic.
  2. `Instant` is an opaque monotonic timestamp type.
  3. Reading the monotonic clock is ungated: `monotonicNow(): Instant`.
  4. Arithmetic and comparison on `Instant` and `Duration` are pure and ungated.
  5. `SystemTime` is an opaque wall-clock timestamp type.
  6. `ClockCapability` is acquired explicitly from `RootCapability`.
  7. Reading wall-clock time requires `ClockCapability` and returns `Result[SystemTime, TimeError]`.
  8. Sleeping and other APIs that actually delay execution require `ClockCapability` and return `Result[Unit, TimeError]`.
  9. Calendar, timezone, and civil-time conversion APIs require `ClockCapability`.
  10. `Duration`, `Instant`, and `SystemTime` are ordinary values; capability requirements attach to the operations that observe or block on real time, not to storing or passing the values.
  11. `comptime` evaluation may not observe monotonic time, wall-clock time, timezone state, or sleep behavior.
  **Why this fits Kyokai**: monotonic measurement stays usable in ordinary code, while wall-clock and suspension authority remain explicit and capability-auditable.
  **[STAGE: DECIDED_CORE_SEMANTICS | D172 → ungated monotonic `Instant`/`Duration`; wall-clock, sleep, and calendar/timezone APIs require `ClockCapability`]**
- **Randomness is split between explicit entropy authority and explicit RNG state values** — Kyokai does not permit ambient global RNGs, hidden thread-local generators, or blurred crypto-versus-fast randomness surfaces.
**Core types**:
  ```kyokai
  record Seed256 is
      // opaque seed material
  build;

  record FastRng is
      // opaque deterministic fast RNG state
  build;

  record CryptoRng is
      // opaque cryptographic RNG state
  build;
  ```
  **Rules**:
  1. `EntropyCapability` is acquired explicitly from `RootCapability`.
  2. There is no ambient global RNG and no hidden thread-local safe RNG.
  3. OS entropy acquisition is capability-gated.
  4. Safe APIs provide explicit entropy-fill and seed-construction operations returning `Result[..., RandomError]` on ordinary failure.
  5. `FastRng` and `CryptoRng` are explicit mutable RNG-state values, not ambient services.
  6. RNG state values are linear so mutation stays explicit through `&!` operations.
  7. Constructing RNG state from explicit seed material requires no capability.
  8. Constructing or reseeding RNG state from OS entropy requires `EntropyCapability`.
  9. Fast non-cryptographic randomness and cryptographic randomness are distinct types, not a mode bit on one generic RNG surface.
  10. Once an RNG state value has been constructed, ordinary draw and fill operations on that state do not require `EntropyCapability`.
  11. The standard library includes both the explicit fast RNG surface and the explicit cryptographic RNG surface; Kyokai does not defer cryptographic randomness to FFI-only folklore.
  **Why this fits Kyokai**: entropy authority stays visible, deterministic replay remains possible through explicit seeds, and security-sensitive randomness is not confused with convenience PRNG state.
  **[STAGE: DECIDED_CORE_SEMANTICS | D173 → `EntropyCapability` gates OS entropy acquisition; explicit `FastRng` and `CryptoRng` state values; no ambient RNG]**
- **Child-process creation is capability-gated through `ProcessCapability` and uses explicit OS-native text and process-configuration types** — spawning a process is operating-system authority and must not smuggle in shell parsing or ambient process-global state.
**Core types**:
  ```kyokai
  record Process is
      // opaque child-process handle
  build;

  record ProcessConfig is
      // executable path, argv, environment mode, stdio config, working directory
  build;
  ```
  **API**:
  ```kyokai
  function spawn(proc: &![ProcessCapability], config: &[ProcessConfig]): Result[Process, ProcessError];
  ```
  **Rules**:
  1. `ProcessCapability` is acquired explicitly from `RootCapability`.
  2. Safe process APIs live in `Kyokai.Process` and require explicit `ProcessCapability`.
  3. The executable path is expressed with `Path`/`PathBuf`, not `String`.
  4. Argument and environment surfaces use `OsStr`/`OsString`-based types rather than `String` because process boundaries are OS-native text boundaries under D97.
  5. Safe spawning does not invoke a shell implicitly, does not parse one command string into argv, and does not perform shell expansion.
  6. The child working directory, environment behavior, and stdio behavior are explicit parts of `ProcessConfig`, not hidden ambient defaults. Any inheritance mode is spelled by an explicit configuration choice.
  7. `spawn` returns `Result[Process, ProcessError]` on ordinary OS failure, and `Process` is a linear handle.
  8. Waiting, signaling, piping, and stdio redirection are explicit `Kyokai.Process` APIs over `Process`, `File`, and related handle types; safe code does not gain raw `system()`-style string execution.
  **Why this fits Kyokai**: child-process creation is real authority, argv/env text stays encoding-honest, and the language rejects the most common source of process-launch ambiguity: invisible shell interpretation.
  **[STAGE: DECIDED_CORE_SEMANTICS | D178 → `ProcessCapability` gates safe process creation; executable paths use `Path`; args/env use OS-native text; no implicit shell]**
- **String-to-value parsing uses a `Parsable` typeclass returning `Result[T, ParseError]`** — parsing user input is inherently fallible. Malformed input is expected, not a contract violation, so TPOE is wrong here.
**API**:
  ```kyokai
  typeclass Parsable(T: Type) is
      method parse(s: &[String]): Result[T, ParseError];
  spec;

  // Standard implementations for built-in numeric types:
  // instance Parsable(Int32)
  // instance Parsable(Int64)
  // instance Parsable(Nat32)
  // instance Parsable(Float64)
  // etc.
  ```
  **Rules**:
  1. `parse` takes an immutable borrow of a `String` and returns `Result[T, ParseError]`.
  2. `ParseError` contains the failure reason (invalid format, overflow, empty input, etc.) and the position in the input where parsing failed.
  3. Standard implementations exist for all built-in numeric types.
  4. Parsing is exact: `"123abc".parse[Int32]()` fails rather than returning `123`. Partial parsing, if needed, is a separate API.
  5. Leading/trailing whitespace handling is explicitly specified per implementation rather than silently stripped.
  **Why this fits Kyokai**: parsing is the inverse of `Displayable` (D40). Both use typeclasses, both are explicit, and both have predictable behavior. The `Result` return makes error handling mandatory — you cannot ignore a parse failure.
  **[STAGE: DECIDED_CORE_SEMANTICS | D69 → `Parsable` typeclass with `Result[T, ParseError]`; standard implementations for numeric types]**
- **I/O is unbuffered by default; explicit `BufferedWriter[T]` and `BufferedReader[T]` wrappers provide buffering** — buffering hides memory allocations and flush timing. In a language where "if it's happening, it must be visible in source," hidden buffering violates the core principle.
**API**:
  ```kyokai
  // Unbuffered I/O is the default — every write is a syscall:
  Io.write(&!terminal, &data);  // one syscall per call

  // Buffered I/O wraps a Writable in an explicit buffer:
  let writer: BufferedWriter[File] := makeBufferedWriter(&!heap, file, 8192);
  defer writer.flush();          // explicit flush before teardown
  defer destroyBufferedWriter(writer);

  writer.write(&data);           // writes to buffer, not to OS
  writer.flush();                // explicit: pushes buffer to OS now
  ```
  **Rules**:
  1. Raw `Readable`/`Writable` (D66) operations are unbuffered — each call maps to one OS interaction.
  2. `BufferedWriter[T]` and `BufferedReader[T]` are explicit wrappers that add buffering over any `Writable` or `Readable`.
  3. `BufferedWriter[T]` and `BufferedReader[T]` are `Linear` — they own the internal buffer and must be explicitly flushed and destroyed.
  4. The buffer requires an allocator (D44) — `makeBufferedWriter(alloc, inner, bufferSize)`. The allocation is visible at construction.
  5. `flush()` is explicit. There is no implicit flush-on-newline, flush-on-full, or flush-on-scope-exit beyond what the programmer writes with `defer`.
  6. Destroying a `BufferedWriter` without flushing is a linearity error — the writer must be flushed before it can be consumed by the destructor.
  7. Capability surfaces do not smuggle in buffering. A terminal, file, or socket capability yields raw unbuffered stream authority; ergonomic helpers may construct a buffered wrapper only through an explicit API that names buffering, takes an allocator, and takes a buffer size, such as `term.bufferedWriter(&!heap, 8192)`.
  **Why this fits Kyokai**: Austral provides no adequate buffering abstraction for ordinary systems workloads. Kyokai provides one, but makes it explicit. The programmer sees the buffer size at construction, the allocator that backs it, and every flush point. No hidden allocations, no silent flushes, and no special capability-layer exception to the rule.
  **[DECIDED: D70/D133 → unbuffered by default; explicit `BufferedWriter[T]`/`BufferedReader[T]` wrappers only; capability APIs do not implicitly buffer]**
- **Functions may declare `require` preconditions and `ensure` postconditions as part of their signature; failed contracts are TPOE** — Design by Contract is the syntactic surface for the value contracts that linear types cannot express. Linear types enforce lifecycle contracts (resource creation, use, destruction) at compile time. `require`/`ensure` enforce value contracts (input ranges, output guarantees, domain restrictions) at runtime.
**Syntax**:
  ```kyokai
  function divide(a: Int32, b: Int32): Int32
      require b != 0;
      ensure result > 0;
  is
      return a / b;
  qed;

  function clamp(x: Int32, lo: Int32, hi: Int32): Int32
      require lo <= hi;
      ensure result >= lo;
      ensure result <= hi;
  is
      if x < lo then
          return lo;
      else if x > hi then
          return hi;
      fi;
      return x;
  qed;
  ```
  **Rules**:
  1. `require` clauses appear between the function signature and `is`. Each is a `Bool` expression evaluated at function entry. Failed `require` is TPOE (D84 rule 3).
  2. `ensure` clauses appear in the same position. Each is a `Bool` expression evaluated after the function body produces its return value but before the return value is delivered to the caller. Failed `ensure` is TPOE.
  3. In `ensure` context, `result` is the contextual keyword naming a read-only view of the function's return slot. It is not a second owned value.
  4. Semantically, `result` is an immutable borrow of the produced return value. It may be used only for pure observation and may not be moved, consumed, or mutably borrowed.
  5. For `: Unit` functions, `ensure` is allowed but `result` is not available.
  6. `require` and `ensure` are always checked. No build profile, optimization level, or compiler flag may strip or weaken them. They are language semantics, not debug assertions.
  7. `require` and `ensure` clauses appear in `.kyo` interface files and are part of the function's public contract. They are visible to callers, to documentation generators (M08), and to the compiler's diagnostic engine (D29).
  8. Multiple `require` and `ensure` clauses are allowed. They evaluate in source order. Each clause is independent — the first failure triggers TPOE.
  9. `old expr` is available in `ensure` clauses as specified by D129.
  10. `require`/`ensure` expressions must be pure — they may not call functions with side effects, mutate state, or consume linear values. They are observation-only.
  11. Every subexpression of a `require` or `ensure` clause uses the same value and arithmetic semantics as ordinary runtime code, including D75 overflow behavior.
  12. Overflow during contract evaluation triggers TPOE. It is not reinterpreted as "precondition false" or "postcondition false."
  13. There are no type-level `invariant` clauses. Contracts are per-function only. Type invariants interact badly with linearity — a mutable borrow that temporarily violates an invariant during mutation would TPOE mid-operation.
  **Why this fits Kyokai**: Borretti praised Design by Contract as a "mechanical process" for safety that is "independent of the skill of the programmer" but never implemented it in Austral. Kyokai closes this gap. `require`/`ensure` is the syntactic surface for TPOE — the contract is in the signature where it belongs, not buried in an `if` statement in the body. Combined with linear types (compile-time lifecycle contracts) and TPOE (runtime value contracts), Kyokai provides two complementary contract systems covering the full space of program correctness.
  **[DECIDED: D53/D140/D142 → `require`/`ensure` clauses on functions; `result` is a read-only postcondition view of the return slot; `old` for pure entry-state Free expressions; contracts always checked; ordinary arithmetic semantics apply inside contracts; no type invariants; contracts visible in `.kyo` interfaces]**
- **`old` snapshots pure entry-state expressions of `Free` data for use in `ensure` clauses** — Kyokai supports relational postconditions without violating linearity by restricting snapshots to values that are copyable and observable at function entry.
**Rules**:
  1. `old expr` is legal only inside an `ensure` clause.
  2. `expr` must be pure and must depend only on values that are available at function entry.
  3. Every value observed by `expr` must have `Free` universe type. If `expr` directly or indirectly observes a `Linear` value, the use of `old` is a compile-time error.
  4. Each distinct `old expr` is evaluated exactly once at function entry before any `require` clause is checked, and the `ensure` clause later observes that saved entry-state value.
  5. `old` may be applied to any qualifying pure entry-state expression, not only to bare parameter names.
  **Why this fits Kyokai**: common relational contracts such as "result is greater than the input" become expressible, while linear values remain uncopyable and the entry-state snapshot model stays fully explicit.
  **[STAGE: DECIDED_CORE_SEMANTICS | D129 → `old expr` in `ensure` for pure entry-state `Free` expressions only]**
- **Container mutation invalidation is mostly unrepresentable in safe code; remaining cases are specified per container** — the linear type system prevents the most dangerous invalidation scenarios statically. D77 formalizes what the borrow checker already does and fills the gap for unsafe internals.
**Rules**:
  1. The borrow checker prevents most invalidation statically: a mutable borrow `&![Container]` required for mutation excludes all immutable borrows `&[Container]`, element borrows `&[Element]`, and iterator borrows from coexisting. This is not a D77-specific rule — it is the borrow checker doing its job.
  2. Iterator objects that borrow the container immutably (`&[Container]`) prevent mutation for the duration of iteration. The programmer cannot call `push`, `remove`, or any `&![Container]` operation while an iterator is alive. This is a compile-time guarantee.
  3. Any operation that can reallocate internal storage (e.g., growing a `Vec` past capacity) invalidates all raw `Address[T]` values derived from the previous storage. This only matters in `pragma Unsafe_Module` code — safe code cannot obtain raw addresses from containers.
  4. Safe collection APIs prefer returning element borrows (`&[T]`) rather than raw addresses (`Address[T]`). The borrow system then prevents invalidation naturally.
  5. Each standard library collection must include an explicit invalidation table documenting which operations reallocate, which operations preserve element addresses, and what guarantees (if any) hold for `Address[T]` values across operations.
  6. The invalidation table is part of the D85 semantic contract for each collection and appears in the collection's documentation.
  **Why this fits Kyokai**: in most systems languages, iterator invalidation is a class of bugs discovered at runtime (C++) or prevented by the borrow checker with complex lifetime rules (Rust). Kyokai's simpler borrow model (`&[T]` / `&![T]` with no lifetime parameters in the common case) makes the most dangerous scenarios statically impossible, and D77 requires the remaining edge cases to be documented explicitly per container rather than left to programmer folklore.
  **[STAGE: DECIDED_CORE_SEMANTICS | D77 → borrow checker prevents most invalidation statically; remaining cases specified per container in D85 invalidation tables; safe APIs prefer borrows over raw addresses]**
- **The core language spec and a companion toolchain spec are separate normative documents** — Kyokai's specification is split into two documents, both normative, covering different domains of specified behavior.
**Core language spec** (the Kyokai spec under `kyokaispec/`, forked from inherited Austral spec material where useful):
  1. Syntax and grammar
  2. Type system (linear types, universes, borrowing, regions)
  3. Evaluation semantics (D71, D75, D76)
  4. Memory model (D73, D42)
  5. Control flow (`if`/`while`/`case`, `defer`, `panic`, TPOE)
  6. Module system (imports, visibility, interfaces/bodies)
  7. FFI rules (D20/D20a/D20b)
  8. Runtime termination contract (D84)
  9. Design by Contract semantics (D53)
  10. Built-in types, operators, and language-level constructs (`debug`, `panic`, `comptime`)
  **Companion toolchain spec** (new document):
  1. `kyokai.toml` manifest schema (D78, D31)
  2. Package resolution and workspace rules (D78)
  3. `.koi` artifact format (D79)
  4. Build profiles, target toolchains, and supported C-backend compiler contracts (D31, D80, D139, D141)
  5. Incremental and separate compilation behavior (D144)
  6. CLI tool subcommands and behavior (D26)
  7. Diagnostics JSON schema (D29)
  8. Formatter behavior (D25)
  9. LSP behavior (M07)
  10. Documentation generator behavior (M08)
  11. Test harness behavior (D28, D137)
  12. Target support tier contract (D80)
  13. Reproducible build requirements (D83)
  **Rules**:
  1. Both documents are normative. "Toolchain spec" does not mean "optional" or "implementation-defined."
  2. A topic must not be omitted merely because it "belongs to tooling" if user-visible behavior depends on it.
  3. The core language spec is the source of truth for what a conforming Kyokai compiler must accept and reject. The toolchain spec is the source of truth for what a conforming Kyokai toolchain must do beyond compilation.
  4. Accepted behavior belongs in the normative language or toolchain spec, not in informal notes or discussion artifacts.
  **Why this fits Kyokai**: the language is explicit about everything. The specification should be explicit about what it specifies. Mixing "what does `let` mean" with "what does `kyokai build --profile release` do" in one document creates a specification that is hard to reference and hard to implement against. Splitting them keeps both focused and both normative.
  **[STAGE: DECIDED_CORE_SEMANTICS | D86 → split into core language spec (syntax, types, evaluation, memory, control flow, FFI, runtime) and companion toolchain spec (manifest, packages, artifacts, CLI, diagnostics, formatter, LSP, testing, targets, reproducibility); both normative]**
- **Every standard library module must specify the same set of semantic contract fields** — "the language is explicit" is not enough if the standard library remains implicit. Each public API in the stdlib must document its behavior in a fixed set of categories so that programmers, documentation generators, and tooling can rely on uniform contract coverage.
**Required contract fields per API**:

  | Field                                        | What it specifies                                                                             | Example                                                                                                                         | Governing decision      |
  | -------------------------------------------- | --------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- | ----------------------- |
  | **Allocation behavior**                      | Whether the operation allocates, which allocator it uses, whether allocation can fail         | "Allocates via the provided `Allocator`; returns `AllocError` on failure"                                                       | D44, D74                |
  | **Capability requirements**                  | Which capabilities the operation requires                                                     | "Requires `TerminalCapability`" or "No capability required"                                                                     | D45, D67                |
  | **Ownership/borrowing behavior**             | Whether inputs are consumed, borrowed immutably, or borrowed mutably; what the caller retains | "Consumes `value` (linear move); borrows `sender` mutably"                                                                      | D11b naming conventions |
  | **Failure mode**                             | Which failure mechanism the operation uses                                                    | "`Result[T, ParseError]`", "`Optional[T]`", "TPOE on bounds violation", "`panic` on impossible state", "Cannot fail"            | D84, D53                |
  | **Complexity class**                         | Time and space complexity where relevant                                                      | "O(1) amortized, O(n) worst case on reallocation"                                                                               | —                       |
  | **Determinism / iteration-order guarantees** | Whether output depends on insertion order, hash seed, platform, etc.                          | "Iteration order matches insertion order" or "Iteration order is unspecified"                                                   | D83                     |
  | **Invalidation behavior**                    | Which operations invalidate borrows, iterators, views, or raw addresses                       | "Reallocation invalidates all `Address[T]` derived from previous storage"                                                       | D77                     |
  | **Concurrency behavior**                     | Whether the type is safe for cross-task access and under what conditions                      | "`Linear` — single owner, no cross-task sharing. Use channels to transfer." or "`Atomic[T]` — shared access via `&[Atomic[T]]`" | D3, D3a, D3b            |
  | **Platform-specific caveats**                | Any behavior that varies by target or OS                                                      | "On Linux, uses `epoll`; on other targets, uses `poll`"                                                                         | D80, D64                |

  **Rules**:
  1. Every public function, method, and typeclass instance in the standard library must specify all applicable fields from the table above.
  2. Fields that do not apply to a given API are explicitly marked "N/A" rather than omitted.
  3. These fields appear in `///` doc comments in `.kyo` interface files and are extracted by the documentation generator (M08).
  4. The contract fields are the documentation form of D53's `require`/`ensure` — where a contract can be expressed as a `require`/`ensure` clause, it should be. Where it cannot (e.g., complexity guarantees, iteration order), it is documented in the contract fields.
  5. The contract fields are part of the toolchain spec (D86) rather than the core language spec, because they govern library documentation requirements, not language semantics.
  6. User libraries are encouraged but not required to follow the same contract format.
**Why this fits Kyokai**: the standard library is the largest body of code most Kyokai programmers will interact with. If its behavior is documented ad-hoc — some functions mention allocation, some don't, some mention failure modes, some leave them implicit — then the library contradicts the language's core promise. Uniform contract fields make the stdlib as explicit as the language itself.
**[STAGE: DECIDED_CORE_SEMANTICS | D85 → every stdlib API specifies allocation, capabilities, ownership, failure mode, complexity, determinism, invalidation, concurrency, and platform caveats; fields appear in `.kyo` doc comments; part of toolchain spec (D86)]**
- **Kyokai does not grow a general effect system beyond capabilities, explicit control-flow typing, and explicit API contracts** — the language chooses one narrow effect-tracking mechanism and makes the rest visible through names and documentation rather than through a second type layer.
**Rules**:
  1. Kyokai has no general effect rows, checked exception system, algebraic-effect surface, or `async`-style effect coloring in function types.
  2. The type system tracks external authority through capability parameters and capability-bearing handle types only.
  3. The type system does not track divergence, non-termination, blocking, scheduler interaction, transitive allocation, or "may TPOE."
  4. D58's `Never` models only control-flow paths that are statically known not to complete normally. It is not a general effect marker.
  5. Effects not tracked in types must instead be surfaced through explicit API naming and explicit contract documentation. This includes at minimum capability requirements, allocation behavior, failure mode, blocking/concurrency behavior, and determinism where relevant.
  6. D85's contract fields and the companion toolchain spec under D86 are the normative place where these non-capability effect facts are made explicit for the standard library and toolchain surfaces.
  **Why this fits Kyokai**: the language keeps the one effect boundary it truly cares about in the type system, while refusing to smuggle a broad secondary effect calculus into signatures and generic constraints.
  **[STAGE: DECIDED_CORE_SEMANTICS | D211 → capabilities are the only built-in effect-tracking mechanism; divergence/allocation/blocking/TPOE are not type-tracked and must be surfaced by explicit naming and contracts]**
- **Kyokai has a backend-independent `asm` block syntax for inline assembly; it lives inside `pragma Unsafe_Module` and targets the instruction set, not the backend** — inline assembly is inherently unsafe and ISA-specific, but it should not be backend-specific. The syntax works with both the C backend (emitting `__asm__` in generated C) and the LLVM backend migration target (emitting LLVM inline asm constraints).
**Syntax**:
  ```kyokai
  // Only legal inside pragma Unsafe_Module
  asm(target.arch == x86_64,
      "syscall",
      out("rax") result,
      in("rax") sysNumber,
      in("rdi") arg1,
      in("rsi") arg2,
      clobber("rcx", "r11", "memory")
  );
  ```
  **Rules**:
  1. `asm(...)` is only legal inside `pragma Unsafe_Module`. Using it in safe code is a compile error.
  2. The first argument is a comptime `Bool` guard — typically `target.arch == x86_64` or similar (D19). If the guard is false, the block is not compiled. This prevents ISA-mismatch errors at compile time.
  3. The assembly string is a string literal in the target ISA's syntax (AT&T for x86, standard for ARM/RISC-V).
  4. Operand bindings use named forms: `in("reg") expr`, `out("reg") binding`, `inout("reg") binding`, `clobber("reg1", "reg2", ...)`.
  5. The C backend translates this to GCC-style `__asm__ volatile(...)` with appropriate constraints.
  6. The LLVM backend translates this to LLVM inline asm with appropriate constraints.
  7. The compiler does not attempt to understand or optimize assembly contents. It trusts the programmer's operand and clobber declarations.
  8. `asm` blocks do not participate in linearity checking — they are outside the safe language model. The surrounding unsafe module is responsible for correctness.
  **Why inline assembly is not deferred to FFI-only shim files**: D3b (atomics) proved that pushing core primitives to FFI loses type safety and compiler visibility. For the tiny number of functions that genuinely need inline asm (syscall wrappers, specific hardware instructions), a proper `asm` syntax is better than maintaining separate `.c` shim files. The syntax is designed once, works with both backends.
  **[STAGE: DECIDED_CORE_SEMANTICS | D22 → backend-independent `asm` block syntax; `pragma Unsafe_Module` only; comptime ISA guard; named operand bindings; C backend emits `__asm__`, LLVM backend emits LLVM inline asm]**
- **SIMD is a portable language feature with an explicit split between portable vectors and ISA-specific intrinsics** — Kyokai does not defer vector programming until the LLVM backend exists, and it does not define SIMD as "whatever intrinsics the current backend happens to expose."
**Core type**: `Vector[T, N]`, where `T` is a fixed-width integer type, a fixed-width floating-point type, or `Bool` for mask vectors, and `N` is a positive comptime lane count.
**Rules**:
  1. `Vector[T, N]` is a first-class value type. Lane numbering is explicit and stable: lane `0` is the first source-order lane and lane `N - 1` is the last.
  2. The portable SIMD contract is value-level and lane-wise. Arithmetic, bitwise, comparison, lane extraction/replacement, shuffles, and explicitly named reductions are defined in terms of the vector's abstract lanes, not in terms of a particular instruction selection strategy.
  3. A portable vector operation exists only when the corresponding scalar operation is already defined for `T`. Kyokai does not invent vector-only arithmetic rules that disagree with the scalar language.
  4. Conversion between `Vector[T, N]` and `Array[T, N]` is explicit and preserves lane order exactly. The portable core does not introduce hidden alignment requirements, aliasing rules, or address-taking semantics.
  5. Portable vector operations may lower to hardware SIMD, compiler vector extensions, generated helper code, or scalar code. All are conforming if the defined lane semantics are preserved.
  6. The C backend may implement the portable core with compiler intrinsics/extensions or scalarization. The LLVM backend may implement it with native vector IR. Backend choice does not change the language semantics.
  7. ISA-specific operations are separate from the portable core and live in explicit target-gated modules or declarations. Using them requires the selected target contract to declare the required ISA and CPU-feature baseline explicitly.
  8. If an ISA-specific intrinsic is unavailable for the selected backend, target, or declared CPU-feature baseline, compilation fails. ISA-specific operations may NOT silently scalarize or degrade into some other operation family.
  9. Runtime host CPU-feature detection is explicit library surface. If a program ships multiple ISA-specialized implementations, the dispatch between them must be written explicitly in source or through an explicit standard-library dispatch combinator. Kyokai performs no hidden auto-multiversioning.
  10. Any selected CPU-feature baseline used to enable ISA-specific modules is part of the target contract for D79/D83 purposes. It must be recorded explicitly so `.koi` compatibility and reproducible builds remain auditable.
  **Why this fits Kyokai**: performance-critical code gets a real portable vector model now, while backend-specific power stays honest, explicit, and separate from the language's semantic core.
  **[STAGE: DECIDED_CORE_SEMANTICS | D104 → portable `Vector[T, N]` core with explicit lane semantics; ISA-specific intrinsics are target-gated, explicit, and never silently scalarized]**
- `**kyokai fmt` is an opinionated, zero-configuration code formatter built into the `kyokai` CLI** — there is one canonical formatting style for Kyokai code. It is not configurable. All Kyokai code looks the same.
**Rules**:
  1. `kyokai fmt` formats all `.kyo` and `.kai` files in the project.
  2. The formatter has zero configuration. There are no `kyokai.toml` options for indent width, line length, brace style, or any other formatting preference.
  3. Output is deterministic — the same input always produces the same output, regardless of platform or compiler version.
  4. The formatter is idempotent — running it twice produces the same result as running it once.
  5. `kyokai fmt --check` exits with a non-zero status if any file would be changed, without modifying files. Suitable for CI.
  **Formatting choices** (part of the toolchain spec, D86):
  1. Indentation: 4 spaces. No tabs.
  2. Line length: 100 characters.
  3. No vertical alignment (breaks on rename refactors).
  4. Trailing commas required in multiline lists.
  5. One blank line between top-level declarations.
  6. No trailing whitespace.
  **Why zero configuration**: Go proved it. Python (Black) proved it. Zig proved it. Style debates are a solved problem — the solution is removing the debate. Kyokai already makes opinionated choices everywhere (explicit types, keywords over symbols, linear consumption). The formatter follows the same principle: one right way.
  **[STAGE: DECIDED_CORE_SEMANTICS | D25 → opinionated `kyokai fmt`; zero configuration; 4-space indent; 100-char line; deterministic and idempotent; part of toolchain spec (D86)]**
- **Debugging support uses `#line` directives in generated C for source-level debugging today; the LLVM backend will emit DWARF directly** — the C backend is the current reality and `#line` gives immediate GDB/LLDB support. The LLVM backend is the future and will emit proper debug info natively.
**C backend rules**:
  1. The C backend emits `#line N "path/to/File.kai"` directives in generated `.c` files, mapping generated C lines back to Kyokai source lines.
  2. When the programmer runs GDB or LLDB on the compiled binary, breakpoints, single-stepping, and stack traces show Kyokai source file names and line numbers.
  3. The `debug` profile (D31) compiles with `-g` (or equivalent) to include debug symbols.
  4. Variable names in generated C should preserve Kyokai variable names where possible for debugger inspection.
  **LLVM backend rules** (future):
  1. The LLVM backend will emit DWARF debug information directly, mapping LLVM IR to Kyokai source locations.
  2. This provides full source-level debugging without the C intermediary.
  3. The debug info format and level of detail are part of the toolchain spec (D86).
  **Why `#line` is sufficient for now**: `#line` is standardized C (ISO C99 §6.10.4). Every C compiler supports it. GCC and Clang both propagate `#line` information into DWARF debug info. This means Kyokai gets source-level debugging for free through the C backend — no custom debugger needed. It's not perfect (complex expressions may not map cleanly), but it's immediately useful.
  **[STAGE: DECIDED_CORE_SEMANTICS | D27 → C backend uses `#line` directives for source-level debugging; LLVM backend will emit DWARF directly; debug profile compiles with `-g`]**
- **Tests are inline `test` blocks in module bodies, discovered and run by `kyokai test`** — Zig-style co-located test blocks. Tests live with the code they test, have access to private declarations, and are excluded from production builds.
**Syntax**:
  ```kyokai
  module body Kyokai.Math.Int is
      function abs(x: Int32): Int32 is
          if x < 0 then return 0 - x; fi;
          return x;
      qed;

      test "abs of positive" is
          assert(abs(5) == 5);
      qed;

      test "abs of negative" is
          assert(abs(-5) == 5);
      qed;

      test "abs of zero" is
          assert(abs(0) == 0);
      qed;
  seal;
  ```
  **Rules**:
  1. `test "description" is ... qed;` blocks appear inside module bodies, at the same level as function declarations.
  2. Test blocks are compiled only when `kyokai test` is invoked. Normal `kyokai build` excludes them entirely — no test code in production binaries.
  3. Test blocks have access to the module's private declarations because they are inside the module body.
  4. Test blocks do not appear in `.kyo` interface files.
  5. Each test block runs independently. A failed assertion in one test does not prevent other tests from running.
  6. `kyokai test` discovers all `test` blocks in the project, compiles with tests included, runs each test, and reports pass/fail/skip with test names and source locations.
  7. `kyokai test "pattern"` filters tests by name substring.
  **Assertions** (built into `Kyokai.Test`, auto-available in test blocks):
  1. `assert(condition: Bool)` — TPOE if false.
  2. `assertEqual(left: T, right: T)` — TPOE if not equal. Requires `Equality` typeclass. Reports both values on failure.
  3. `assertErr(result: Result[T, E])` — TPOE if not `Err`.
  4. `assertOk(result: Result[T, E])` — TPOE if not `Ok`.
  5. Test assertion failure is caught by the test runner — it does not terminate the entire test suite (unlike ordinary TPOE). The test runner treats assertion failure as a test failure, reports it, and continues to the next test.
  **Why inline over separate files**: tests co-located with code are more likely to be written and maintained. Access to private declarations enables unit testing of internal functions without exposing them publicly. This is the Zig model, and it works.
  **[STAGE: DECIDED_CORE_SEMANTICS | D28 → inline `test` blocks in module bodies; `kyokai test` discovers and runs them; excluded from production builds; private access; `Kyokai.Test` assertions; part of toolchain spec (D86)]**
- **Tests request capabilities explicitly; there is no ambient test-only root or hidden harness power** — pure tests stay capability-free, while effectful tests must spell out that they want authority.
**Syntax**:
  ```kyokai
  test "pure arithmetic" is
      assert(add(2, 2) == 4);
  qed;

  test "reads env" with (root: RootCapability) is
      let env := root.env();
      let home := getEnv(&!env, "HOME");
      assert(home.isSome());
  qed;
  ```
  **Rules**:
  1. Pure tests use the ordinary form `test "description" is ... qed;` and receive no capabilities.
  2. A capability-using test must declare a `with` clause explicitly. The standardized authority-bearing form is `with (root: RootCapability)`.
  3. There is no ambient `root`, no implicit `TestCapability`, and no hidden test-only authority channel.
  4. The test runner constructs a fresh `RootCapability` for each individual test execution.
  5. The runner may realize this by subprocess-per-test or another harness strategy with equivalent semantics, but the contract remains "fresh root per test."
  6. A capability-using test derives `TerminalCapability`, `EnvCapability`, filesystem capabilities, and any other authority from `root` exactly as ordinary code derives them in `main`.
**Why this fits Kyokai**: integration tests stay practical, pure tests stay lightweight, and the capability model does not grow an invisible exception for test code.
**[STAGE: DECIDED_CORE_SEMANTICS | D137 → tests default to no capabilities; capability-using tests spell `with (root: RootCapability)`; runner provides a fresh root per test; no ambient test-only authority]**
- **`kyokai doc` is an official interface-driven documentation generator with first-class contract rendering and doc-test extraction** — Kyokai's doc surface is not an afterthought because the language already depends on explicit `///`, `//!`, `require`, `ensure`, and D85 contract fields.
**Rules**:
  1. `kyokai doc` is an official toolchain command.
  2. By default it reads package `.kyo` interface files plus module/file `//!` docs and generates documentation for the public interface surface only.
  3. `internal` declarations may be included only through an explicit package-internal documentation mode. Private `.kai`-only declarations are never part of public generated docs.
  4. Generated item pages must render at least: declaration signature, visibility, generic constraints, associated types, `require`/`ensure` clauses, and all applicable D85 contract fields.
  5. The official output formats are static HTML and machine-readable JSON.
  6. Cross-reference resolution is explicit and declaration-based. Local `[Name]` and qualified `[Module.Name]`-style symbol links resolve through the documented interface graph rather than through best-effort text search.
  7. `kyokai test --doc` extracts fenced `kyokai` code blocks from documentation comments and module docs under the toolchain's explicit doc-test rules.
  8. Doc-test snippets are ordinary Kyokai code, not a separate documentation mini-language.
  9. Capability-using doc examples remain bound by D137's explicit-authority rules. The documentation toolchain does not invent hidden authority for examples.
  **Why this fits Kyokai**: the interface file already carries the explicit semantic material. A real documentation generator makes that material visible without creating a second folklore channel for contracts and API behavior.
  **[STAGE: DECIDED_CORE_SEMANTICS | D218 → official `kyokai doc`; public-interface-driven HTML and JSON output; first-class rendering of contracts/contract fields; explicit doc-test extraction via `kyokai test --doc`]**
- **Coverage is a first-class toolchain feature, but it is reported in Kyokai source terms rather than backend artifact terms** — generated C or LLVM IR may implement the program, but the coverage contract belongs to the source language the programmer wrote.
**Rules**:
  1. `kyokai test --coverage` is an official toolchain mode.
  2. Coverage is reported against Kyokai source files and Kyokai source spans, not generated C, LLVM IR, or backend helper files.
  3. The toolchain must not count backend-generated scaffolding such as overflow-check lowering, helper wrappers, or other codegen artifacts as user-visible Kyokai coverage points.
  4. Minimum outputs are a terminal summary and LCOV export.
  5. HTML coverage reports are provided through an explicit report flag.
  6. Line or statement coverage is required.
  7. Branch coverage is defined over explicit Kyokai control-flow constructs such as `if`, `case`, loop conditions, `select`, and explicit short-circuit or sugar-defined control-flow sites when the toolchain can map them faithfully.
  8. By default coverage reports the current package's source and excludes dependencies and generated shims unless the user explicitly requests otherwise.
  9. If a backend/target combination cannot provide conforming Kyokai-source-level coverage for the requested mode, the toolchain must fail explicitly rather than emit misleading coverage data.
  **Why this fits Kyokai**: coverage remains auditable at the language boundary the programmer actually reasons about, and backend choice is prevented from changing what the tool claims was or was not exercised.
  **[STAGE: DECIDED_CORE_SEMANTICS | D219 → official `kyokai test --coverage`; Kyokai-source-level reporting only; LCOV plus HTML reporting; explicit failure when faithful source mapping cannot be provided]**
- **Benchmarking is standardized as `kyokai bench`, but benchmark discovery syntax remains a toolchain-spec detail rather than a new core-language block form** — Kyokai standardizes the benchmark workflow and minimum measurement behavior without pretending that microbenchmark methodology belongs in the core grammar.
  **Rules**:
  1. The reference toolchain MUST provide a `kyokai bench` entry point.
  2. Benchmark execution runs in a dedicated harness that includes an explicit warm-up phase before measured iterations.
  3. Measured execution uses repeated iterations rather than one-shot timings and reports aggregate results in both human-readable and machine-readable forms.
  4. Benchmark code is not pulled into ordinary `kyokai build` unless the chosen discovery mechanism explicitly includes it.
  5. Exact benchmark discovery syntax and output schema belong to the toolchain spec (D86), not to Kyokai core syntax. The language does not currently standardize a `bench ... qed;` block.
  **Why this fits Kyokai**: performance work gets a real first-class workflow, but the language surface avoids a fake symmetry where timing methodology is crammed into syntax just because tests use inline blocks.
  **[STAGE: DECIDED_CORE_SEMANTICS | D136 → standardize `kyokai bench` with warm-up, repeated measurements, and human/machine-readable output; discovery syntax stays toolchain-spec detail]**
- **Compiler diagnostics follow the Rust-quality model: source spans, underline markers, diagnostic codes, suggestions, and structured JSON output** — every diagnostic has a code, a source span, context lines, and optionally a suggested fix. Error messages are written for humans, structured output is available for tools.
**Every diagnostic MUST include**:
  1. **Severity**: `error` (compilation fails), `warning` (compilation succeeds), `note` (additional context).
  2. **Diagnostic code**: `KYO-E0001` for errors, `KYO-W0001` for warnings. Codes are stable across compiler versions.
  3. **Source span**: File path, start line:column, end line:column.
  4. **Source context**: 1-3 lines of source code with underline markers (`^^^`).
  5. **Message**: Human-readable description of the problem.
  6. **Suggestion** (optional): "did you mean X?" with the suggested fix.
  **Output modes**:
  1. **Terminal** (default): Colored output using ANSI codes. Respects `NO_COLOR` environment variable.
  2. **JSON** (`--diagnostics=json`): Machine-readable output for editor integration (LSP, M07).
  **Warning categories and suppression**:
  1. Warnings grouped by category: `naming` (D11b), `unused`, `linearity`, `style`.
  2. Per-project suppression in `kyokai.toml` `[warnings]` section.
  3. No per-line suppression comments (`// nolint`). If the compiler warns about it, fix it or suppress it project-wide.
  **Error recovery**: The compiler continues after the first error and reports as many independent errors as possible. Maximum error count before stopping is configurable (default: 20).
  **Example**:
  ```
  error[KYO-E0042]: linear variable `file` not consumed
    --> src/Fetch.kyo:42:9
     |
  42 |     let file: File := openFile(path);
     |         ^^^^ variable declared here
     |
     = note: linear variables must be consumed exactly once
     = help: consider adding `defer closeFile(file);` after the declaration
  ```
  **Why Rust-quality is the target**: Elm proved that good error messages change how people feel about a language. Rust proved it scales to a complex type system. Kyokai's linear type system will produce errors that are unfamiliar to most programmers — clear diagnostics with suggestions are essential for adoption. The diagnostic codes (`KYO-E0042`) enable `kyokai explain KYO-E0042` for detailed documentation of each error, which is especially important for linearity errors.
  **[STAGE: DECIDED_CORE_SEMANTICS | D29 → Rust-quality diagnostics; source spans; diagnostic codes; suggestions; JSON output; per-project warning suppression; no per-line suppression; part of toolchain spec (D86)]**
- **Iterator adapters are a minimal set of eager, allocation-explicit collection helpers and stateless iteration helpers — no lazy adapter chains** — Even with D118's explicit-capture closure literals, Kyokai rejects Rust-style lazy adapter stacks and instead provides explicit helpers that keep allocation, ownership, and control flow visible.
**Collection-building helpers** (eager, allocation-explicit):
  ```kyokai
  // mapInto: applies f to each element of source, pushes results into dest
  function mapInto[T, U, F](
      source: &[Span[T]], dest: &![Buffer[U]], f: F
  ): Unit
      where F: Callable[&[T], U];

  // filterInto: pushes elements satisfying predicate into dest
  function filterInto[T, F](
      source: &[Span[T]], dest: &![Buffer[T]], f: F
  ): Unit
      where F: Callable[&[T], Bool];
  ```
  **Search helpers** (no allocation, short-circuit on first match):
  ```kyokai
  function find[T, F](iter: &![Iterator[T]], predicate: F): Optional[T]
      where F: Callable[&[T], Bool];

  function findIndex[T, F](iter: &![Iterator[T]], predicate: F): Optional[Index]
      where F: Callable[&[T], Bool];
  ```
  **Iteration helpers** (no allocation, thin wrapper iterators):
  ```kyokai
  function enumerate[I: Iterator](iter: I): EnumerateIterator[I];
  function zip[A: Iterator, B: Iterator](a: A, b: B): ZipIterator[A, B];
  ```
  **Reduction helpers** (no allocation, consume the iterator):
  ```kyokai
  function fold[T, Acc, F](iter: &![Iterator[T]], initial: Acc, f: F): Acc
      where F: Callable2[Acc, T, Acc];

  function any[T, F](iter: &![Iterator[T]], predicate: F): Bool
      where F: Callable[&[T], Bool];

  function all[T, F](iter: &![Iterator[T]], predicate: F): Bool
      where F: Callable[&[T], Bool];

  function count[T](iter: &![Iterator[T]]): Index;
  ```
  **Rules**:
  1. No lazy adapters. All collection-building helpers are eager and take an explicit destination container.
  2. `mapInto`/`filterInto` take a `&![Buffer[U]]` destination — allocation is the caller's responsibility. There is no `collect()` that magically picks the right container type.
  3. `find` and `findIndex` are ordinary short-circuiting library helpers. They solve the common search pattern without making loops expression-typed and without introducing dedicated search syntax.
  4. `enumerate`/`zip` return thin wrapper iterators with no allocation. They satisfy `Iterator` and work with `for-in`.
  5. `fold`/`any`/`all`/`count` are reductions that consume the iterator.
  6. These are ordinary library functions in `Kyokai.Iter`, not typeclass methods on `Iterator`.
  7. Callbacks use the D21/D126 callable family — named functions, `FnPtr` values, or D118 closure literals lowered to the matching family member.
  8. For most transformations, an explicit `for` loop with `push` is the idiomatic Kyokai pattern. The helpers exist for cases where the loop body is a single function application or a straightforward search predicate.
  **Why no lazy adapters**: lazy adapters need closures to be ergonomic. Without closures, `map(filter(iter, isEvenFn), doubleFn)` is inside-out and unreadable. Explicit loops are clearer, and Kyokai's `for-in` + `while let` cover the iteration patterns that lazy adapters serve in other languages.
  **[STAGE: DECIDED_CORE_SEMANTICS | D32a → minimal eager helpers (`mapInto`, `filterInto`, `find`, `findIndex`) with explicit destinations where applicable; stateless iteration wrappers (`enumerate`, `zip`); reductions; no lazy adapters; callbacks via the D21/D126 callable family]**
- `**format` is the fallible allocating interpolation path, using comptime-checked `{}` placeholders only** — no width/radix/alignment mini-language. The format string is parsed at compile time to verify argument count and `Displayable` constraints.
**Syntax**:
  ```kyokai
  let msg := format(&!heap, "x = {}, y = {}", x, y) or return;

  // Comptime checks:
  // 1. Number of {} matches number of trailing arguments
  // 2. Each argument satisfies Displayable (D40)
  // 3. Mismatches are compile errors with KYO-E diagnostic codes
  ```
  **Rules**:
  1. `format(alloc, template, args...)` is a built-in construct (like `debug` and `panic`), not a library function. The compiler parses the template string at comptime.
  2. The template string uses `{}` as the only placeholder. No positional arguments (`{0}`), no format specifiers (`{:04x}`), no named arguments (`{name}`).
  3. Comptime validation: the number of `{}` placeholders must exactly match the number of trailing arguments. Each argument must satisfy `Displayable` (D40). Mismatches are compile errors.
  4. `format` requires an allocator (D44) because it produces a heap-allocated `String`, and it follows D74: allocation failure returns `Err(AllocError)` rather than terminating implicitly.
  5. `format` is specified in terms of the D40 sink model: create a `StringBuilder`, render through the shared formatting engine, then finish into a `String`. Intermediate partial builder state is not externally observable on failure.
  6. If the standard library provides a fatal-on-OOM convenience form, it must be explicitly named (for example `mustFormat`) and follow D74's runtime-fatal naming rule.
  7. For hex, padding, width, or alignment — use explicit named conversions: `x.toHex()`, `padLeft(s, 10, ' ')`. These are ordinary functions, not mini-language specifiers embedded in the format string.
  8. `{{` produces a literal `{` in output. `}}` produces a literal `}`. This is the only escape.
  9. Width, radix, alignment, and debug-representation mini-language extensions are absent from stable Kyokai. Admitting any extension requires an accepted D-point and corresponding spec change.
  **Why minimal**: every formatting specifier is a mini-language feature that must be parsed, validated, documented, and maintained. Rust's `format!` supports `{:>10.2}` — that's a significant embedded DSL. Kyokai's philosophy is "no hidden complexity." If you need formatted numeric output, the formatting function is named and visible in source (`x.toHex()`, `padLeft(...)`), not hidden inside a format string that only the compiler can parse.
  **[STAGE: DECIDED_CORE_SEMANTICS | D40a → built-in `format(alloc, template, args...) -> Result[String, AllocError]` with comptime-checked `{}` only; explicit D74-aligned allocation failure; richer DSL explicitly deferred]**
- **Non-allocating formatted output uses `writeFmt` over the same placeholder language, with explicit stream-failure semantics** — Kyokai provides a direct formatted-output path for streams without forcing an intermediate `String` allocation.
**Syntax**:
  ```kyokai
  writeFmt(&!stream, "x = {}, y = {}", x, y) or return;
  stream.writeFmt("x = {}, y = {}", x, y) or return;
  ```
  **Rules**:
  1. `writeFmt(&!stream, template, args...)` is a built-in construct for any `Writable` target. The UFCS spelling `stream.writeFmt(...)` is ordinary D7a sugar.
  2. `writeFmt` uses the same `{}` placeholder grammar, comptime placeholder-count validation, and `Displayable` constraints as D40a.
  3. `writeFmt` performs no whole-result allocation. It renders each argument through the D40 `Displayable` model and writes the resulting UTF-8 chunks directly to the target stream.
  4. `writeFmt` is specified through a transient formatting-sink adapter over the `Writable` target. That adapter uses `writeAll`-style behavior internally so `Displayable` implementations see whole-chunk-or-error semantics rather than D66 partial writes.
  5. `writeFmt` returns `Result[Unit, IoError]`. Any underlying write/flush failure is surfaced explicitly.
  6. `writeFmt` is non-transactional. If a failure occurs after some output was already accepted by the underlying stream, that written prefix remains written; `writeFmt` does not buffer the entire result merely to provide rollback.
  7. After a `writeFmt` failure, the stream remains usable unless that stream type's own contract says otherwise.
  8. `writeFmt` does not change D66's byte-oriented I/O model; it is a formatting layer above `Writable`, not a second ambient text-stream system.
  9. `format` is the allocating path and `writeFmt` is the non-allocating path. They share one placeholder language and one `Displayable` rendering model.
  **Why this fits Kyokai**: CLI programs, logging, diagnostics, and text protocols get an honest zero-allocation formatting path, while allocation failure and I/O failure remain distinct and explicit rather than being collapsed into one hidden mechanism.
  **[STAGE: DECIDED_CORE_SEMANTICS | D102 → built-in `writeFmt` over `Writable`; shared placeholder language with D40a; explicit `IoError`; non-transactional prefix-preserving failure semantics]**
- **Error context is a concrete standard-library wrapper, not a language feature or ambient error stack** — Kyokai allows ergonomic explanatory wrapping at layer boundaries, but it keeps the mechanism explicit, concrete, and type-directed.
**API shape**:
  ```kyokai
  record ContextError[E: Type] is
      message: String;
      inner: E;
  build;

  function context[T, E](result: Result[T, E], message: String): Result[T, ContextError[E]];

  let cfg := openFile(path).context("failed to open config") or return;
  ```
  **Rules**:
  1. `ContextError[E]` is a standard-library type, not a language-level error feature.
  2. `.context(message)` is ordinary UFCS over a library function from `Result[T, E]` to `Result[T, ContextError[E]]`. Kyokai adds no special syntax beyond UFCS.
  3. The message is an explicit value supplied by the caller. The helper consumes that value and, on `Err(e)`, returns `Err(ContextError { message, inner: e })`.
  4. The helper performs no implicit conversion of the surrounding function's error type. If the caller wants to propagate the result directly, the surrounding return type must explicitly be `Result[..., ContextError[E]]` or the caller must apply an explicit D119 mapping.
  5. There is no trait-object erasure, ambient source-chain registry, implicit backtrace attachment, or hidden error-conversion machinery.
  6. Nested context remains concrete and explicit: repeated wrapping yields types such as `ContextError[ContextError[E]]`.
  7. `ContextError[E]` implements `Displayable` when `E` implements `Displayable`, rendering the outer message and then the wrapped inner error.
  8. `ContextError` is for layer-boundary explanation, not Kyokai's universal error architecture. D119-style explicit mapping remains the primary mechanism for domain error conversion.
  **Why this fits Kyokai**: the common "add human context and propagate" case becomes ergonomic without introducing dynamic-error folklore, hidden conversions, or a second error model separate from `Result`.
  **[STAGE: DECIDED_CORE_SEMANTICS | D103 → concrete `ContextError[E]` + `.context(message)` UFCS helper; no implicit conversions or dynamic error machinery]**
- **Errors have an explicit standard-library classification typeclass, but Kyokai does not adopt a dynamic error-object system** — generic APIs can talk about "error types" directly, while rendering, wrapping, and transport remain separate explicit mechanisms.
**Rules**:
  1. `Error` is a standard-library typeclass used to classify types intended to represent ordinary recoverable error domains.
  2. `Error` is a marker-style typeclass. It does not introduce hidden allocation, hidden backtraces, hidden source chains, implicit conversion, or dynamic error erasure machinery.
  3. Human-readable rendering remains the job of `Displayable`, not `Error`. A generic API that needs both "this is an error type" and "this can be rendered" must require both constraints explicitly.
  4. `ContextError[E]` from D103 implements `Error` whenever `E` implements `Error`.
  5. Kyokai has no `dyn Error`, trait-object error box, or existential error surface under this decision.
  6. If the standard library later provides typed source-chaining helpers, they must remain concrete and typed wrappers rather than erased runtime polymorphism.
  **Why this fits Kyokai**: generic code gains an explicit way to talk about error domains, but the language still rejects the dynamic "anything implementing Error can be boxed and passed around" model that would conflict with D82, D103, and D193.
  **[STAGE: DECIDED_CORE_SEMANTICS | D166 → standard-library marker `Error` typeclass; rendering stays with `Displayable`; no dynamic error-object system]**
- **Hashing uses a hasher-driven core protocol, with one-shot `Nat64` helpers kept explicit and algorithm-named** — the owner of the hash table or helper picks the algorithm; value types contribute structure, not an ambient default hash number.
**Core protocol**:
  ```kyokai
  typeclass Hashable(Self: Type) is
      method hash(self: &[Self], hasher: &![Hasher]): Unit;
  spec;
  ```
  **Rules**:
  1. `Hashable` is the core language-facing hashing protocol for user types and standard-library types.
  2. `Hasher` lives under `Kyokai.Hash` as the explicit state object that receives bytes and produces a final digest such as `Nat64`.
  3. Containers such as `HashMap` and `HashSet` choose their hashing algorithm through the concrete hasher they instantiate or carry; `Hashable` implementations do not hard-code one ambient `Nat64` algorithm.
  4. The standard library may provide explicit one-shot helpers tied to named algorithms, such as `SipHash24.hash64(&value)` or `WyHash.hash64(&value)`, but those are convenience APIs layered on top of the core `Hashable` protocol.
  5. There is no language-wide ambient `hash(value) -> Nat64` default that hides which algorithm was chosen.
  6. Standard `Hashable` instances exist for the built-in integer types, `Bool`, `String`, enums, and other standard-library key types.
  **Why this fits Kyokai**: algorithm choice stays visible where it matters, containers remain free to choose secure vs fast hashing explicitly, and callers still get explicit one-shot helpers when that is the actual goal.
  **[STAGE: DECIDED_CORE_SEMANTICS | D134 → hasher-based `Hashable`; explicit named one-shot hash helpers allowed, but no ambient default `hash() -> Nat64`]**
- **`Result` gets a small linearity-aware combinator surface based on one-shot callbacks** — Kyokai keeps explicit `case` and `let...else`, but it also standardizes the common single-branch transformations so error plumbing does not become needless boilerplate.
**Required surface**:
  - `map`
  - `mapErr`
  - `andThen`
  - `orElse`
  **Rules**:
  1. Each `Result` combinator consumes its input `Result` exactly once.
  2. `map` applies its callback only on the `Ok` branch and returns the `Err` branch unchanged.
  3. `mapErr` applies its callback only on the `Err` branch and returns the `Ok` branch unchanged.
  4. `andThen` applies its callback only on the `Ok` branch; that callback returns another `Result`.
  5. `orElse` applies its callback only on the `Err` branch; that callback returns another `Result`.
  6. These combinators are specified against the D21 `CallableOnce` substrate because each callback is invoked at most once.
  7. If the transformed branch payload is `Linear`, the callback consumes that payload explicitly in the ordinary way. The combinator does not duplicate it, drop it, or invent any hidden cleanup path.
  8. The untouched branch payload is preserved exactly and is not rewrapped in a second hidden envelope.
  **Why this fits Kyokai**: the library gets the ergonomics of standard `Result` transformation without giving up linear visibility or replacing `case`/`let...else` as the fully explicit escape hatch.
  **[STAGE: DECIDED_CORE_SEMANTICS | D167 → `Result` provides `map`/`mapErr`/`andThen`/`orElse`, specified in terms of one-shot callbacks and ordinary linear consumption]**
- **Generic dispatch is static and every concrete instantiation behaves as if a fully specialized body exists — the compiler may share or deduplicate identical bodies as a non-observable optimization** — this is the "as-if monomorphization" model. The language semantics are monomorphized; the implementation strategy has freedom within those semantics.
**Rules**:
  1. Every concrete use of a generic function or type behaves as if a fully specialized body was materialized with all type parameters resolved. This is the semantic contract.
  2. The compiler may share or deduplicate concrete bodies that are identical at the machine code level, provided this does not change observable behavior, `require`/`ensure` contract evaluation, debug identity (source locations, function names in stack traces), or diagnostic output.
  3. The compiler must NOT share bodies that differ in layout, alignment, `sizeOf`, `alignOf`, or any type-dependent property.
  4. There is no "shared generic body with runtime type info" mode. D82 explicitly rejected runtime dictionaries.
  5. The materialization strategy is an implementation detail of the compiler — the language contract is the "as-if" rule, not a mandate for how code is generated.
  **Why "as-if" rather than mandating full monomorphization**: mandating that every concrete use emits a fresh body would prevent legitimate size optimizations (merging `fn foo[T: Addable](x: T)` for `Int32` and `Int64` if they produce identical machine code). The "as-if" rule gives the compiler freedom while keeping the programmer's model simple: "my generic function is specialized for my types."
  **[STAGE: DECIDED_CORE_SEMANTICS | D82a → as-if monomorphization; every concrete instantiation behaves as if fully specialized; compiler may deduplicate identical bodies without changing observable behavior]**
- **Cross-package generic instantiation ownership is coordinated explicitly by the toolchain; `.koi` artifacts carry enough metadata for downstream materialization; the reference toolchain should avoid redundant materialization via workspace-level caching** — this separates the language contract (what `.koi` must carry) from the toolchain strategy (how to avoid redundant work).
**Language/artifact contract**:
  1. `.koi` artifacts (D79) carry serialized generic body metadata sufficient for a downstream package to materialize concrete bodies from upstream generics without re-parsing upstream source.
  2. The toolchain coordinates which compilation unit emits each concrete instantiation. The spec mandates that ownership is explicit and deterministic, but does not mandate caller-side or callee-side emission.
  3. Duplicate materialization of identical instantiations is legal but wasteful. The toolchain should avoid it.
  **Toolchain-level strategy** (part of toolchain spec, D86):
  1. The reference workspace build should avoid redundant materialization of identical generic instantiations when the required inputs and compatibility class match.
  2. A deterministic workspace-level instantiation cache is the preferred mechanism, keyed by `(package identity, generic identity, concrete type arguments, compiler compatibility class, target, profile)`.
  3. Reuse of cached materializations must be semantics-preserving and reproducible (D83).
  4. Cache invalidation tracks upstream generic body changes through `.koi` fingerprints.
  5. This strategy is a toolchain quality-of-implementation concern, not a frozen language invariant. A conforming compiler that re-materializes every instantiation is correct (just slow). A high-quality compiler avoids redundant work.
  **Why this matters for compile times**: Kyokai's generic surface is smaller than Rust's (no trait objects, no `dyn`, no deep adapter chains, simpler associated types). But the architecture matters more than the surface area. By naming workspace-level caching as the preferred strategy and requiring `.koi` metadata to support it, Kyokai's toolchain is designed for fast incremental builds from the start rather than backing into a model that requires linker-level deduplication of redundant work already done.
  **[DECIDED: D82b → `.koi` carries generic body metadata for downstream materialization; toolchain coordinates instantiation ownership explicitly; workspace-level cache is preferred strategy; redundant materialization is legal but discouraged; strategy is toolchain-level, not language invariant]**
- **Incremental compilation is layered: modules are the within-package reuse unit, packages are the cross-package artifact unit, and fingerprint/query machinery is the implementation technique underneath** — Kyokai does not force a false choice between Go-style package caching, OCaml-style module recompilation boundaries, and Rust-style dependency fingerprinting.
**Rules**:
  1. A logical module (`.kyo` + `.kai`) is the separate-compilation and invalidation unit within a package.
  2. A package and its `.koi` artifact are the cross-package compatibility and downstream invalidation unit.
  3. Each module produces a semantic summary digest capturing exactly the declarations and facts that sibling modules inside the package may depend on, including used `internal` declarations.
  4. If a module body changes without changing that module's semantic summary digest, unrelated sibling modules in the same package need not be recompiled.
  5. If a package rebuild leaves its serialized `.koi` artifact unchanged, downstream packages must not be recompiled.
  6. Cache and invalidation keys include at least the language edition, compiler compatibility class, target contract, selected CPU-feature baseline, active profile, and dependency interface digests.
  7. Independent modules inside one package and independent packages inside one workspace should be compiled in parallel.
  8. D82b's generic-instantiation cache is part of this model rather than a separate ad hoc cache layer.
  9. The reference compiler should realize this through dependency fingerprints or query-style invalidation, but the normative external contract is the module/package reuse boundary above, not one mandatory internal compiler architecture.
  **Why this fits Kyokai**: cross-package builds get a hard `.koi` boundary, same-package edits do not collapse back to whole-package recompilation, and the implementation still has room to use modern dependency tracking instead of pretending timestamps alone are enough.
  **[STAGE: DECIDED_CORE_SEMANTICS | D144 → hybrid incremental model: module-level within packages, package-level across packages, fingerprint/query machinery underneath]**
- **Monomorphized code-size mitigation is explicit and layered: compiler sharing is governed by D82a, and optimizing profiles request post-codegen identical-code folding where the selected toolchain can do it without violating the active debug/diagnostic contract** — Kyokai does not treat "same size/alignment" as a semantic equivalence rule, and it does not leave binary-size policy to unnamed linker folklore.
**Rules**:
  1. Compiler-level sharing of generic bodies is governed by D82a. Matching size or alignment alone is never sufficient justification for sharing.
  2. A compiler may share concrete instantiations only when it can prove that the resulting emitted body preserves D82a's requirements, including all type-dependent behavior, layout-sensitive operations, contract evaluation, and diagnostics.
  3. Toolchain-level identical-code folding is a separate post-codegen optimization. It may merge emitted machine-code sections only when doing so preserves Kyokai language semantics and the active profile's debugging/diagnostic contract.
  4. The standardized profile control for this optimization is D31's `identical_code_folding` field.
  5. The conventional `debug` profile sets `identical_code_folding = false`. The conventional `release` and `size` profiles set `identical_code_folding = true`.
  6. The exact linker flags or backend passes used to realize identical-code folding are target/toolchain configuration under D31. The language does not standardize one flag spelling such as `--icf=all`.
  7. If a profile explicitly requests identical-code folding and the selected backend/toolchain cannot provide a conforming implementation, the build fails rather than silently pretending the request was honored.
  **Why this fits Kyokai**: compiler sharing stays semantically rigorous, optimizing profiles get an explicit size-reduction lever, and toolchain behavior becomes part of the written contract rather than a hidden linker accident.
  **[STAGE: DECIDED_CORE_SEMANTICS | D200 → layered monomorphization size mitigation: D82a-proof-based compiler sharing plus explicit profile-controlled toolchain identical-code folding]**
- **Kyokai names its target audience explicitly and uses that audience as a design filter** — the language is not designed for "everyone who might ever write systems software." It is designed first for programmers coming from C who want modern safety without paying for hidden behavior or unreadable code at scale.
**Rules**:
  1. Kyokai's primary audience is C programmers who want memory safety, resource safety, capability security, and faster codebase comprehension than C gives them.
  2. Kyokai's secondary audience is broader systems programmers, but secondary audience pressure does not override the primary readability-and-explicitness target.
  3. The language is optimized for code that a competent C programmer can read, audit, and reason about quickly.
  4. Readability under real codebase scale is part of the design contract, not an aesthetic preference.
  5. When a feature increases abstraction power but makes ordinary systems code harder to scan without delivering a commensurate safety gain, Kyokai rejects it.
  **Why this fits Kyokai**: it resolves the plan's identity question directly. Kyokai is not "Austral with more stuff" and not "Rust minus a few features." It is a modern systems language built around explicit ownership, explicit authority, and code that stays legible under pressure.
  **[STAGE: DECIDED_CORE_SEMANTICS | D145 → explicit target audience: primary C programmers seeking modern safety and codebase readability; secondary broader systems programmers]**
- **Kyokai carries an explicit non-goals list, and crossing one of those boundaries requires a new full decision point** — the language does not let scope creep hide behind "maybe later" ambiguity.
**Normative non-goals**:
  1. No garbage collector.
  2. No implicit destructors, `Drop`, or compiler-inserted cleanup calls at ordinary scope exit.
  3. No exceptions or stack unwinding.
  4. No runtime reflection.
  5. No null pointers as an ordinary language value model.
  6. No safe ambient global mutable state.
  7. No inheritance or class-hierarchy object model.
  8. No macro system or syntactic metaprogramming surface.
  9. No erased trait-object or hidden runtime-dictionary polymorphism.
  10. No competing second mechanism when one explicit mechanism already covers the semantic job.
  11. No weakening of safety checks or analysis obligations merely to win compile-time benchmarks.
  12. No language-level `async`/`await`, `Future`-style colored concurrency surface, or hidden executor model.
  **Rules**:
  1. This list is normative project boundary, not aspirational marketing.
  2. Reversing any item requires a new explicit D-point that names the reversal and its consequences.
  3. New non-goals may be added only by the same explicit-decision process.
  **Why this fits Kyokai**: boundaries are part of the product. A language named "boundary" should say where its boundaries are.
  **[STAGE: DECIDED_CORE_SEMANTICS | D147 → explicit normative non-goals list; changes require a new D-point]**
- **The official language server is part of the toolchain and shares the compiler's analysis engine rather than re-implementing it** — Kyokai does not accept a split-brain tooling model where the editor and compiler disagree because they are separate semantic systems.
**Rules**:
  1. The official entrypoint is `kyokai lsp`.
  2. The language server ships as part of the same reference toolchain release as the compiler.
  3. Parsing, name resolution, type checking, linearity checking, `.koi` loading, and incremental dependency state are shared compiler-library components used by both batch commands and the LSP.
  4. `kyokai check` and `kyokai lsp` must agree on diagnostics for the same source and configuration.
  5. The implementation must support broken and partial editor buffers through parser recovery and incremental snapshots rather than by inventing a second weaker semantic model.
  6. The official feature floor includes diagnostics, hover/type information, go-to-definition, find references, semantic tokens, and explicit visibility into borrow/consumption state.
  7. The official feature target includes completion, rename, code actions, workspace symbol search, and inlay hints for type arguments, capability flow, and other semantically relevant information the shared engine can expose.
  **Why this fits Kyokai**: linearity, capabilities, and comptime eligibility are too central to leave editor support as an afterthought. Sharing the compiler engine keeps the tool honest and avoids rust-analyzer-style duplicate-logic drift.
  **[STAGE: DECIDED_CORE_SEMANTICS | D148 → official in-tree `kyokai lsp` sharing the compiler engine; compiler and LSP are developed together, not as separate semantic systems]**
- **Cross-compilation uses one manifest-centered configuration model that can import reusable target-spec files, and both backends are described explicitly under that same model** — Kyokai does not split target configuration between ad hoc CLI folklore, one manifest world for ordinary targets, and a second custom-target format for embedded work.
**Rules**:
  1. `kyokai build --target <triple>` selects a legal D80 target triple.
  2. Backend selection is explicit through `[build].backend` or CLI `--backend <c|llvm>`.
  3. `[target.<triple>]` is the primary configuration surface for cross-compilation.
  4. A target table may import a reusable target-spec TOML file with `spec = "<relative-path>"`.
  5. Imported target-spec data and manifest-local overrides participate in one merged configuration model; target specs are not a second independent configuration system.
  6. Shared target fields live at `[target.<triple>]`. Backend-specific overrides live at `[target.<triple>.backend.c]` and `[target.<triple>.backend.llvm]`.
  7. CLI overrides manifest-local overrides imported target-spec values. Environment variables may assist tool discovery only where the manifest/configuration model explicitly permits them; they are never the primary contract.
  8. The resolved target-spec inputs are part of the reproducible build identity under D83.
  9. If the selected target/backend combination lacks a conforming toolchain configuration, the build fails rather than silently changing backend or target behavior.
  **Why this fits Kyokai**: it keeps cross-compilation explicit, reviewable, and backend-aware without forcing users into two unrelated config languages or pretending the LLVM and C backends can share one unnamed folklore contract.
  **[STAGE: DECIDED_CORE_SEMANTICS | D149 → manifest-centered cross-compilation with importable target-spec TOML files and explicit backend-specific target configuration for both C and LLVM]**
- **`kyokai audit` is a first-class authority-audit tool built on top of Kyokai's capability model rather than a separate sandbox mechanism** — the language already enforces explicit authority flow; auditing makes that authority surface inspectable and CI-checkable.
**Rules**:
  1. The official entrypoint is `kyokai audit`.
  2. `kyokai audit` loads the locked dependency graph and computes, for each package, both:
     - the public capability surface exposed through public API
     - the full implementation capability ceiling used anywhere inside the package
  3. `kyokai audit` also reports unsafe-boundary facts, including `pragma Unsafe_Module`, raw `foreign` usage, `UnsafeCapability`, dynamic loading, and plugin loading when present.
  4. Package manifests may declare an explicit audit policy in `[audit]`.
  5. The standardized manifest field `capability_ceiling = [...]` is checked against the inferred full implementation capability ceiling, not merely against the public API surface.
  6. Standardized booleans such as `uses_unsafe`, `uses_dynamic_load`, and `uses_plugins` must match the inferred package behavior or the audit fails.
  7. Application-root audit output includes the transitive union across the locked dependency graph.
  8. This tool is orthogonal to CVE scanning. It is about authority and unsafe-boundary visibility, not vulnerability databases.
  **Why this fits Kyokai**: package auditing becomes the supply-chain expression of the same explicit-authority philosophy used inside ordinary source code.
  **[STAGE: DECIDED_CORE_SEMANTICS | D150 → first-class `kyokai audit`; public-surface plus implementation-ceiling reporting; manifest-declared audit policy checked against inferred capability and unsafe usage]**
- **Exploratory tooling is provided through compiler-backed `kyokai eval` and `kyokai repl`, not through a separate subset interpreter** — learning and experimentation must use the real language rules rather than a toy semantics that teaches the wrong ownership, capability, or cleanup model.
**Rules**:
  1. The official exploratory entrypoints are `kyokai eval <file.kai>` and `kyokai repl`.
  2. Both commands use the same parser, resolver, type checker, linearity checker, and runtime contracts as ordinary compilation. They are not a reduced subset language and not a separate interpreter semantics.
  3. `kyokai eval` executes a single source file as a synthetic runnable unit. The file format is: zero or more file-scope `import` declarations followed by an ordinary statement body.
  4. `kyokai eval` lowers that statement body to the synthetic entrypoint `main(root: RootCapability, args: &[Span[String]]): ExitCode`.
  5. Inside `kyokai eval`, the names `root` and `args` are the ordinary entrypoint bindings of that synthetic `main`, and reaching the end of the file returns `ExitSuccess`.
  6. `kyokai repl` is a persistent interactive session whose session-state semantics are defined by D151a.
  7. `build`, `check`, `repl`, `eval`, and `lsp` share the same core compiler-library components under D148; exploratory mode does not get a weaker semantic engine.
  **Why this fits Kyokai**: it lowers experimentation friction without teaching a fake language, and it keeps exploratory tooling aligned with the same explicit contracts users will meet in real packages.
  **[STAGE: DECIDED_CORE_SEMANTICS | D151 → official `kyokai eval` + `kyokai repl`, both using the real compiler engine and ordinary language semantics]**
- **`kyokai repl` is one persistent session scope with ordinary linear obligations, not a garbage-collected scratchpad** — interactive use does not suspend Kyokai's ownership rules or invent hidden session cleanup.
**Rules**:
  1. A REPL session maintains two persistent environments:
     - a synthetic module environment for accepted imports and declarations
     - a persistent session-execution scope for top-level executable bindings and deferred actions
  2. Accepted imports and declarations extend the synthetic module environment for later inputs.
  3. Accepted executable inputs run in the same persistent session-execution scope unless they create their own inner lexical scopes. Top-level bindings introduced in one input remain available to later inputs subject to ordinary no-shadowing and linearity rules.
  4. `Free` bindings may persist across turns normally.
  5. `Linear` bindings may also persist across turns, but they remain ordinary live linear obligations and must still be consumed exactly once.
  6. A top-level `defer` registered in the session-execution scope remains pending until that session scope exits. Inner-scope `defer` and `errdefer` still run at their ordinary lexical exits within the current input.
  7. Top-level `errdefer`, `return`, `or return`, `break`, and `continue` are illegal in REPL session scope. They are legal only inside ordinary nested Kyokai constructs introduced by the current input where such exits have a real enclosing target.
  8. Bare expression input is legal only when the resulting type is both `Free` and `Displayable`; the REPL prints that value. A bare expression whose result type is `Linear` is a compile-time error unless the value is explicitly bound, consumed, or moved in the same input.
  9. Compile-time errors and rejected inputs do not mutate session state.
  10. Runtime `panic(message)` and TPOE follow ordinary program semantics and terminate the whole REPL session. They are not catchable as recoverable REPL events.
  11. `:quit` and `:reset` are host commands, not Kyokai syntax. They attempt ordinary exit of the session-execution scope: pending ordinary `defer` actions run under D2a/D2b, and the command is rejected if live linear bindings would remain unconsumed after those deferred actions.
  12. `:reset` starts a fresh empty session only after the previous session has exited legally under rule 11.
  13. Every new REPL session begins with explicit bindings `root: RootCapability` and `args: &[Span[String]]`, mirroring D48's entrypoint contract. `args` is the argument slice supplied after `--` to `kyokai repl`, or an empty slice when none is supplied.
  **Why this fits Kyokai**: REPL state stays real program state, top-level cleanup remains visible, and quitting a session does not become the one place where the language silently drops linear values.
  **[STAGE: DECIDED_CORE_SEMANTICS | D151a → REPL session is one persistent scope; linear values may persist across turns; `:quit`/`:reset` run ordinary `defer` and reject leftover live linear obligations]**
- **Kyokai's standard library is a batteries-included systems standard library, not a placeholder waiting for a future ecosystem** — the language project commits to shipping the foundations a systems programmer reasonably expects to use without third-party package hunting.
**Rules**:
  1. The official standard library is part of Kyokai's core value proposition, not a temporary bootstrap convenience.
  2. The committed standard-library scope includes at minimum facilities for core types, collections, formatting, text, filesystem, process management, time, randomness, networking, encoding, crypto, testing, documentation/testing support, and concurrency support libraries built on the decided language primitives.
  3. These categories are in-scope commitments of the project even when their exact APIs are phased across releases or split into later detailed D-points.
  4. Standard-library APIs must still obey D85 semantic contract documentation, capability gating, D44/D201 allocator explicitness, D73's no-language-UB model, and Kyokai's no-hidden-behavior rules.
  5. "Batteries included" does not mean open-ended application-domain expansion. The boundary is systems programming: if the absence of a facility would make ordinary Kyokai systems programming feel unfinished, it belongs in stdlib scope.
  **Why this fits Kyokai**: Austral's minimal-library posture is one of the main pressures that created Kyokai in the first place. Kyokai's lane is a readable, explicit systems language that is still usable out of the box.
  **[STAGE: DECIDED_CORE_SEMANTICS | D152 → batteries-included systems stdlib is a core project commitment; listed facility families are in scope even when API sequencing is phased]**
- **The core stdlib collection surface is committed explicitly rather than left to an open-ended future roadmap** — Kyokai will ship the ordinary systems-programming collection families directly instead of pretending `Buffer` plus one map type is an adequate long-term answer.
**Rules**:
  1. The committed core owning-collection families are `Buffer[T]`, `HashMap[K, V]`, `HashSet[T]`, `BTreeMap[K, V]`, `BTreeSet[T]`, `Deque[T]`, and `PriorityQueue[T]`.
  2. These are standard-library commitments, not optional ecosystem placeholders.
  3. All owning collection types are linear.
  4. Collection construction and any operation that allocates fresh owned storage remain allocator-explicit under D44 and D201.
  5. Hash-based collections use D134's explicit hasher-based model rather than an ambient default hash algorithm.
  6. Ordered collections rely on the explicit ordering contracts of the language rather than hidden comparator folklore.
  7. This decision does not commit Kyokai to `LinkedList` as part of the core collection set.
  8. This decision also does not introduce GC-dependent persistent collections, shared-ownership collection models, or other surfaces that would contradict Kyokai's explicit ownership boundary.
  **Why this fits Kyokai**: the language keeps its batteries-included promise for ordinary systems work while still drawing a firm boundary around what belongs in the core collection story.
  **[STAGE: DECIDED_CORE_SEMANTICS | D174 → explicit committed core collection families: `Buffer`, `HashMap`, `HashSet`, `BTreeMap`, `BTreeSet`, `Deque`, and `PriorityQueue`; allocator-explicit and linear; no `LinkedList` commitment]**
- **Sorting and ordered search are explicit standard-library operations built on `TotalOrder`, with key-projection helpers as the preferred customization surface** — Kyokai provides ordinary in-place sorting and binary search without making comparator folklore the primary API.
**Rules**:
  1. `Buffer[T]` provides `sort(&!buffer): Unit` when `T: TotalOrder`.
  2. `Buffer[T]` also provides `sortByKey(&!buffer, key): Unit`, where `key` is a callable that maps an element to some `K: TotalOrder`.
  3. The standard library provides `binarySearch(buffer, needle)` for buffers sorted under the element type's `TotalOrder`.
  4. The standard library also provides `binarySearchByKey(buffer, needle, key)` for buffers sorted by the same key projection used for the search.
  5. Standard `sort` and `sortByKey` are stable.
  6. Comparator-driven forms, if provided, are secondary explicit APIs such as `sortWith` or `binarySearchWith` taking a callable that returns `Ordering`; they do not replace the primary `TotalOrder` and `...ByKey` surfaces.
  7. Ordered collections such as `BTreeMap` and `BTreeSet` rely on the same D23/D175 ordering contracts rather than storing hidden per-container comparator state.
  **Why this fits Kyokai**: the common case stays concise, key-based customization covers the usual "sort by field" need without callback boilerplate, and lower-level comparator control remains explicit instead of becoming the only story.
  **[STAGE: DECIDED_CORE_SEMANTICS | D175 → stable `sort`/`sortByKey` plus `binarySearch`/`binarySearchByKey`; comparator forms remain secondary explicit APIs]**
- **Official learning material is staged as guide-plus-reference first, full book after self-hosting** — Kyokai does not outsource onboarding to future community folklore.
**Rules**:
  1. Before self-hosting, the project provides official reference documentation plus an official guide/tutorial site in the spirit of `zig.guide`.
  2. The early guide teaches the real Kyokai model directly: ownership, borrowing, capabilities, TPOE, package/toolchain flow, and standard-library usage patterns.
  3. After Kyokai is written in Kyokai, the project produces a full official book as the deeper canonical teaching text.
  4. The guide is the primary early learning path; the later book is the long-form canonical teaching text.
  **Why this fits Kyokai**: the language has too much semantic weight to rely on scattered posts and examples, but forcing the full book to exist before self-hosting would delay useful learning material for no real gain.
  **[STAGE: DECIDED_CORE_SEMANTICS | D153 → official guide/tutorial plus reference docs before self-hosting; full official book after self-hosting]**
- **Kyokai provides an Austral migration guide and difference reference, not a required mechanical translator** — the realistic migration audience is small enough that documentation beats translator engineering.
**Rules**:
  1. The project provides an Austral-to-Kyokai migration guide.
  2. The project also provides a syntax/semantics difference reference that maps Austral constructs to their Kyokai equivalents and explicitly calls out real semantic changes.
  3. The migration material includes before/after examples for each important surface or semantic difference.
  4. No mechanical translator is required by the plan.
  **Why this fits Kyokai**: it serves the actual likely early audience without spending design and implementation effort on translator machinery for a very small ecosystem.
  **[STAGE: DECIDED_CORE_SEMANTICS | D154 → Austral migration is documentation-first: migration guide + difference reference + before/after examples; no required translator]**
- **Language evolution uses a maintainer-led public decision-point process, and spec/compiler divergence is a bug** — Kyokai does not let accepted behavior drift between discussion threads, compiler experiments, and normative documents.
**Rules**:
  1. Non-trivial language, toolchain, standard-library-surface, compatibility, or governance changes begin as a short public proposal or issue.
  2. If the change affects semantics, syntax, toolchain contract, compatibility, or project boundary in a way that needs real design discussion, it must become an explicit D-point in the public decision tracker before it is considered accepted.
  3. Discussion happens publicly on that D-point in `Kyokaishape.md`, GitHub Discussions, issues, or PRs with the D-point label.
  4. The final written shape must exist before acks close the point.
  5. A public D-point needs at least three community acks on the final shape before it is considered decided, unless the maintainer explicitly marks an emergency or bookkeeping correction.
  6. Once a point is decided, the normative Kyokai spec becomes the source of truth for the accepted behavior; supporting notes and discussion artifacts are non-normative.
  7. The reference compiler, official toolchain components, and normative spec must converge on the same accepted behavior. Spec/compiler disagreement is a bug, not an alternate interpretation.
  8. The compiler may prototype undecided ideas only behind clearly non-default experimental flags or branch-local work. Such experiments do not change the language contract until a D-point closes and the normative spec is updated.
  **Why this fits Kyokai**: it preserves decision velocity while keeping the design auditable, explicit, and publicly traceable, and it directly rejects compiler-first drift as a source of truth.
  **[STAGE: DECIDED_CORE_SEMANTICS | D155 → maintainer-led public D-point governance; final shape plus 3 acks; normative spec is source of truth; spec/compiler divergence is a bug]**
- **Release cadence and language editions are separate clocks** — shipping rhythm is a toolchain policy, while editions remain rare source-semantics boundaries under D105.
**Rules**:
  1. During early development, releases ship when the maintainer judges them ready.
  2. Once the compiler, stdlib, and toolchain are operationally stable enough to support regular consumer-facing releases, the project adopts a regular release train with a default target cadence of four weeks.
  3. The release train ships completed work only; the calendar does not force incomplete features into a release.
  4. Language editions have no fixed time cadence. A new edition is cut only when a real source-semantic break or edition-gated default shift is worth the migration cost.
  5. Edition cadence is deliberately sparse and independent of the ordinary release train.
  6. D105's exact edition semantics and `.koi` compatibility rules remain unchanged by release cadence.
  **Why this fits Kyokai**: users get predictable toolchain releases once the project is mature enough, but editions remain rare deliberate source-boundary events rather than a second calendar ritual.
  **[STAGE: DECIDED_CORE_SEMANTICS | D157 → early releases ship when ready; later default to a four-week release train; editions remain rare and demand-driven on a separate clock]**

- **CI integration is defined by one portable release-artifact and installation contract**: Kyokai does not make CI support depend on one host platform, one forge, or a second hidden installer semantics.
**Rules**:
  1. Every official toolchain release publishes versioned binaries for supported host platforms, SHA-256 checksums, and provenance or signature metadata.
  2. Releases are available at stable, version-addressable URLs.
  3. Kyokai provides an official `kyokai/setup-kyokai` GitHub Action that installs an explicitly requested toolchain version from those same official release artifacts.
  4. Kyokai also publishes official OCI images containing the toolchain for CI use.
  5. CI guidance prefers immutable version tags or digests over floating tags.
  6. The GitHub Action is convenience tooling only; it must not define a second installation semantics.
  7. Any CI system capable of downloading the official release artifacts or OCI images can run Kyokai in a fully supported way.
  8. CI use of `kyokai check`, `kyokai build`, `kyokai test`, and `kyokai fmt --check` follows the same language and toolchain semantics as local use for the same explicit inputs.
  9. Cache behavior, if provided by official tooling, is an optimization only and must not affect language or build correctness.
  **Why this fits Kyokai**: the toolchain stays explicit and reproducible while still making first-party CI use trivial on common platforms.
  **[STAGE: DECIDED_CORE_SEMANTICS | D225 -> official release artifacts, official `setup-kyokai` action, official OCI images, and one portable CI installation contract]**
- **The public browser-playground story is Compiler Explorer plus one explicit sandbox-runner contract**: Kyokai should support try-it-in-browser use without requiring a bespoke hosted playground to be the language's only public surface.
**Rules**:
  1. The project supports a public "try Kyokai" experience through Compiler Explorer integration when feasible.
  2. The toolchain also defines an official sandbox runner contract for browser-based compilation and execution.
  3. A conforming playground runner compiles each snippet from source using an explicitly selected toolchain version, backend, and target.
  4. Execution is sandboxed with no ambient filesystem persistence, no ambient network access, and explicit CPU, memory, and wall-time limits.
  5. Standard output, standard error, compile diagnostics, and formatter output are captured explicitly and reported separately.
  6. Playground execution grants no extra capabilities beyond what the sandbox runner explicitly provides.
  7. Shared links or permalinks must capture the source text and the explicit toolchain settings needed to reproduce the result.
  8. A dedicated hosted `play.kyokai.dev` service may exist as one implementation of this runner contract, but it is not the only acceptable public surface.
  9. Any official hosted playground must use the same runner semantics as the documented runner contract. There is no second hidden web-only execution model.
  **Why this fits Kyokai**: it gives the project a realistic one-maintainer adoption path while still making the execution contract explicit and portable.
  **[STAGE: DECIDED_CORE_SEMANTICS | D226 -> Compiler Explorer plus an official sandbox-runner contract; hosted `play.kyokai.dev` remains optional]**
- **Kyokai provides both property-based testing and coverage-guided fuzzing** — testing a safety-focused language requires both generator-driven specification checking and mutation-driven coverage exploration.
**Rules**:
  1. Kyokai provides both property-based testing and coverage-guided fuzzing.
  2. Property-based testing lives in an official stdlib/testing surface such as `Kyokai.Test.Property`.
  3. The property surface includes typed generators `Gen[T]`, property runners, shrinking for built-in core data types, reproducible seeding, and deterministic replay by explicit seed.
  4. `kyokai test` can run property tests as part of the ordinary test workflow.
  5. `kyokai test --fuzz` is an official toolchain mode for coverage-guided fuzzing.
  6. Fuzzing includes corpus management, crash reproducers, deterministic replay, and integration with the decided coverage infrastructure from D219.
  7. Fuzz targets are explicit test declarations or explicit test-adjacent declarations under toolchain-defined discovery rules; Kyokai does not invent hidden execution entrypoints.
  8. Fuzzing and property testing are complementary, not competing mechanisms: property testing is generator/spec-driven, fuzzing is mutation/coverage-driven.
  **Why this fits Kyokai**: a safety-focused language should make correctness verification easy. Both mechanisms are committed as part of the toolchain/stdlib plan, not phased or deferred.
  **[STAGE: DECIDED_CORE_SEMANTICS | D220 -> property-based testing and coverage-guided fuzzing as committed toolchain/stdlib facilities]**
- **Kyokai provides an official read-only package index service** — Go-style discovery infrastructure over git-hosted packages, not a centralized publish registry.
**Rules**:
  1. Kyokai provides an official read-only package index service.
  2. Packages remain git-hosted; the index is discovery infrastructure, not the canonical storage location.
  3. Index inclusion requires a reachable repository containing a valid `kyokai.toml`.
  4. The index records package metadata, repository URL, docs link, declared versions, tags when present, and dependency metadata derivable from manifests.
  5. `kyokai add <name>` may resolve through the official index, but the resulting manifest entry still records an explicit git source plus explicit revision as required by D51.
  6. The index does not introduce a `publish` command, registry-only package names, or registry-mediated trust semantics.
  7. The index stores compact docs metadata, docs-search projections, and retrieval facts. Generated docs remain under each published package root at the exact indexed Git revision. A later Kyokai-operated mirror is cache-aside derived infrastructure only and is not the source of truth.
  8. Alternative third-party indexes are allowed; the language/toolchain model does not require exactly one global index.
  **Why this fits Kyokai**: discovery is essential for ecosystem growth, but D51's git-pinned dependency model remains the source of truth. The index is a lens, not a gatekeeper.
  **[STAGE: DECIDED_CORE_SEMANTICS | D221 -> official read-only package index (Go model); discovery only, not canonical storage; D51 git+rev dependency model unchanged]**
- **Kyokai has no separate `kyokai lint` semantic tool; the compiler is the linter** — all linting logic lives in the compiler/toolchain engine used by build, test, check, and LSP.
**Rules**:
  1. All linting logic lives in the compiler/toolchain engine used by build, test, check, and LSP.
  2. Lints are categorized at minimum into: hard error, warning, and style.
  3. Correctness and soundness violations stay compile errors, not optional lints.
  4. New non-style lints default to `warn`, not `error`, unless they enforce an already-decided language rule.
  5. Per-project lint configuration and suppression live in `kyokai.toml`.
  6. There are no per-line suppression comments such as `nolint`, `allow`, or pragma-style inline escapes.
  7. LSP surfaces the same lint set as the compiler; there is no second analyzer with a divergent rulebook.
  **Why this fits Kyokai**: "one semantic engine" means the compiler, the LSP, and the linter are the same program. No second tool with different opinions.
  **[STAGE: DECIDED_CORE_SEMANTICS | D222 -> compiler-integrated lints; tiered error/warning/style; `kyokai.toml` suppression; no per-line suppression comments; no separate lint tool]**
- **Kyokai uses SemVer as the official package-versioning convention** — SemVer for human communication, git `rev` for reproducible resolution.
**Rules**:
  1. Kyokai uses SemVer as the official package-versioning convention.
  2. The `version` field in `kyokai.toml` is meaningful package metadata, but reproducible dependency resolution still uses explicit git revision pinning under D51.
  3. Tooling provides `kyokai semver-check` to compare two public API surfaces using `.kyo` interfaces and classify changes as breaking, additive, or patch-compatible.
  4. The check is advisory tooling, not language-level enforcement.
  5. The source of truth for compatibility is the declared public interface surface, not implementation details in `.kai`.
  6. A package may choose bad version numbers, but the tooling can report the mismatch clearly.
  **Why this fits Kyokai**: SemVer gives humans a shared vocabulary for what changed. `rev` gives the build system exact reproducibility. Advisory tooling bridges the gap without forcing enforcement.
  **[STAGE: DECIDED_CORE_SEMANTICS | D223 -> SemVer convention + advisory `kyokai semver-check` over `.kyo` interface surfaces; `rev` remains the reproducibility mechanism]**
- **Build-time code generation is manifest-declared, not hidden in auto-executed language files** — explicit `[generate]` steps plus narrow comptime embedding replace the `build.rs` model.
**Rules**:
  1. Build-time code generation is declared in `kyokai.toml`, not hidden in auto-executed language files.
  2. The toolchain provides an explicit `kyokai generate` command.
  3. Generation steps are listed in a manifest `[generate]` surface with declared inputs, outputs, and commands.
  4. Generated outputs are ordinary files in the source tree or declared generated directories with explicit paths; they are not hidden compiler-side ephemeral artifacts unless separately decided.
  5. Reproducibility rules from D83 apply to generation inputs and outputs.
  6. Comptime remains sandboxed and does not gain ambient filesystem or process access through this decision.
  7. Asset embedding is provided by an explicit comptime facility `@embedBytes(...)` or `@embedText(...)`, with deterministic byte-for-byte embedding semantics.
  8. FFI bindgen, protocol codegen, and asset embedding are thus handled by explicit manifest generation plus narrow explicit comptime embedding, not by a general executable build script language.
  9. No `build.kai`, no auto-running package code during dependency resolution, and no hidden pre-build execution model.
  **Why this fits Kyokai**: codegen is visible in the manifest, embedding is visible in source, and no package code runs as a side effect of dependency resolution.
  **[STAGE: DECIDED_CORE_SEMANTICS | D224/D335 -> manifest-declared `[generate]` steps + `@embedBytes`/`@embedText` comptime embedding; no `build.kai` or auto-execution]**

### 3.4 Readability Research - What Science Says

This section synthesizes findings from cognitive science, eye-tracking studies, and programming language theory research to inform Kyokai's syntax decisions. Every claim here is grounded in published research or verified observation.

#### How Programmers Actually Read Code

**Code comprehension uses the brain's executive network, NOT language processing.** fMRI studies (Siegmund et al. 2014, "Understanding, Understanding Source Code with Functional Magnetic Resonance Imaging") show that reading source code activates the **multiple demand network** (MDN) — the same network used for logic puzzles, mathematics, and spatial reasoning. Crucially, it does NOT primarily activate Broca's area or Wernicke's area, which handle natural language processing.

**What this means for syntax design**: Making code "read like English" is a misleading goal. The brain doesn't process code as language — it processes it as **structured patterns**. Syntax should optimize for:

1. **Pattern recognition** — consistent shapes that the MDN can chunk
2. **Working memory load** — fewer symbols to hold in active memory
3. **Dependency locality** — things that depend on each other should be close together

**Eye-tracking reveals fixation patterns.** Studies (Busjahn et al. 2015, "Eye Movements in Code Reading") show that experienced programmers fixate primarily on:

1. **Identifiers** (variable and function names) — ~60% of fixation time
2. **Operators** — ~20% of fixation time
3. **Keywords** — ~10% of fixation time
4. **Delimiters** (braces, semicolons) — ~10% of fixation time

**What this means**: The NAMES of things matter more than the syntax sugar around them. This validates Austral's emphasis on meaningful identifiers and explicit type annotations. But it also means that BOILERPLATE (which contains zero useful identifier information) is literally wasted fixation time — the programmer's eyes scan past `generic [R: Region]` 18 times without extracting any useful information.

#### SVO Ordering and Dependency Locality

**Subject-Verb-Object is the most common word order in natural languages** — approximately 80% of the world's languages use either SVO (English, Mandarin, Spanish) or SOV (Japanese, Hindi, Korean) ordering. Only ~10% use VSO (Arabic, Irish, Hawaiian).

**Applied to programming syntax**:

- `buffer.append(byte)` — SVO: subject=buffer, verb=append, object=byte
- `appendByte(&~out, byte)` — VSO: verb=appendByte, subject=&~out, object=byte
- `out := append(out, byte)` — SOV: subject=out, verb=append, object=byte

Austral uses **VSO (function-call) syntax** for everything — `appendByte(&~out, byte)`. This is the LEAST common ordering in natural languages. But Austral has principled reasons: it avoids method syntax (which would require a receiver concept and implicit `self` parameter, violating "no hidden anything").

**The tradeoff**: VSO syntax is more explicit (the function name comes first, you see EXACTLY what's being called) but less ergonomic (the subject is buried in the argument list). Kyokai could add **method call syntax as sugar** — `out.appendByte(byte)` desugaring to `appendByte(&~out, byte)` — but this would need to be carefully specified to avoid hidden behavior. See **D7**.

#### Naming and Cognitive Load

**Research consistently shows that naming consistency is the #1 factor in code readability** — more important than syntax choice, indentation style, or language features. Studies (Lawrie et al. 2006, 2007) demonstrate that:

- **Full words win**: `buffer_length` is read faster than `bufLen` which is faster than `bl`
- **Consistent casing matters more than which casing**: A codebase that consistently uses `camelCase` is read faster than one that mixes `camelCase` and `snake_case`, regardless of which convention is "better"
- **snake_case vs camelCase**: Binkley et al. (2009) found `camelCase` had slightly higher accuracy for individual identifier recognition, but Sharif & Maletic (2010) found `snake_case` was identified faster on first fixation and preferred by experienced programmers. The difference is small; consistency dominates.

**What Kyokai inherits from Austral**: `camelCase` for functions/variables, `PascalCase` for types and modules. This is consistent with itself. Changing it would impose a migration cost for no strong scientific reason. Kyokai keeps Austral’s convention and enforces it consistently.

#### Nesting Depth and Comprehension

**Shallow code is faster to understand.** Multiple studies correlate nesting depth with comprehension difficulty. Each additional nesting level adds to working memory load.

**Austral naturally encourages shallow code** because:

1. Linear types require balanced consumption on all branches — deep conditionals with linearity create a combinatorial explosion of consumption paths
2. No exceptions means no try/catch nesting
3. No closures/lambdas means no deeply nested callback patterns
4. Explicit resource management encourages factoring into small functions

This means Austral's `end if` / `end for` terminators have LESS value than in languages that allow deep nesting (like C/C++). See **D9** for analysis.

### 3.5 Naming Convention Principles

Drawing from the Rust API Guidelines (`api-guidelines/src/naming.md`, `api-guidelines/src/predictability.md`), adapted for Austral/Kyokai's linear type system:

#### Conversion Functions and Linearity

Rust defines a naming convention for conversion functions that encodes the **cost and ownership semantics** in the function name:


| Prefix  | Rust Meaning                                                  | Austral/Kyokai Mapping                                       |
| ------- | ------------------------------------------------------------- | ------------------------------------------------------------ |
| `as`_   | Free conversion, no allocation, borrows input, borrows output | Read-borrow in (`&[T, R]`), returns `Free` view or `&[U, R]` |
| `to`_   | Potentially expensive, allocates new value, borrows input     | Read-borrow in (`&[T, R]`), returns owned `Free` value       |
| `into`_ | Consumes input, returns owned output                          | Takes `Linear` value by move, returns new owned value        |


In Kyokai, this maps beautifully to the linearity system:

```austral
-- as_: borrow in, borrow out (or Free return). No ownership change.
generic [R: Region]
function asSpan(buf: &[ByteBuf, R]): Span[Nat8, R];

-- to_*In: borrow in, owned out, allocator explicit. Creates new allocation.
generic [R: Region, A: Allocator]
function toStringIn(buf: &[ByteBuf, R], alloc: &![A]): Result[String, AllocError];

-- into_: consume input, produce output. Ownership transfers.
function intoBuffer(s: String): ByteBuf;
```

The `into_` prefix is the most Austral-native because it maps directly to linear consumption — you give up `s`, you get back `ByteBuf`. The `as_` prefix maps to borrowing. The `to_*In` pattern maps to borrowing-plus-explicit-allocation when the operation creates a fresh owned result.

#### Constructor Naming

Following Rust (`predictability.md` lines 147–168):


| Pattern        | Meaning                        | Kyokai Example                        |
| -------------- | ------------------------------ | ------------------------------------- |
| `new` / `make` | Default constructor            | `makeByteBuf(cap: Index): ByteBuf`    |
| `with_*`       | Constructor with configuration | `withCapacity(cap: Index): ByteBuf`   |
| `from_*`       | Constructor from another type  | `fromSpan(s: Span[Nat8, R]): ByteBuf` |


Austral already uses `make` (e.g., `makeByteBuf`). Kyokai should keep this and add `from` variants.

#### Method-like vs Function Naming

If Kyokai adds method syntax (see **D7**), naming changes:

- **Without methods**: `bufferLength(buf)` — verb-object for actions, noun for queries
- **With methods**: `buf.length()` — no prefix needed, subject is implicit

The Rust guideline: getters do NOT use `get_` prefix. `buf.length()` not `buf.getLength()`. If we add methods, follow this.

---

## 4. Work Items — Prioritized by Hardness and Severity

No phases. No weeks. Items are ordered by severity (how badly Kyokai needs it) × hardness (how difficult it is to implement). Work is picked based on these scores and current project pressure.

### Severity Scale

- **S-CRITICAL**: Can't write real programs without it
- **S-HIGH**: Major pain point for any real usage
- **S-MEDIUM**: Would improve experience significantly
- **S-LOW**: Nice to have

### Hardness Scale

- **H-1 to H-3**: Straightforward implementation, well-understood algorithms
- **H-4 to H-6**: Requires careful design, moderate complexity
- **H-7 to H-10**: Requires deep compiler work, novel design decisions, or complex algorithms

---

### S-CRITICAL Items

#### [C01] Build System — H-5

**What**: A `kyokai build` command that reads a package or workspace manifest, resolves packages and modules according to D78, consumes the lockfile defined by D78/D51, and invokes the compiler.

**Why critical**: Currently you must manually pass every `.kyo` and `.kai` file in dependency order to `kyokai compile`. This is unusable for any project beyond trivial.

**Implementation reference**:

- The compiler already handles module ordering internally (`design-austral-compiler.md` — extraction pass resolves imports). A build system just needs to discover files and construct the correct ordering.
- Consider Zig's approach: a single `build.zig` file that IS the build system. For Kyokai: a `kyokai.toml` manifest.

**What it needs**:

- Nearest-manifest discovery for package roots
- `[workspace]` vs `[package]` validation (mutually exclusive per D78)
- Explicit workspace member loading from `[workspace].members`
- File discovery under the package module root declared by `[layout].module_root`
- D78 module resolution (`[layout].module_root`, `.` = directory separator, one import path = one `.kyo`/`.kai` pair)
- Duplicate logical-module detection
- Package/module dependency resolution (parse imports, topological ordering)
- Consume `kyokai.lock` from the workspace root or package root as appropriate
- Resolve the selected build profile and target triple
- Resolve `[target.<triple>]` toolchain settings and any per-profile target overrides
- Invoke compiler with correct file ordering
- Output binary / artifact according to profile

**Reference**: Zig's `std.Build` (`zig/lib/std/Build.zig`), Cargo's manifest format.

**See also**: D19 (conditional compilation / platform modules), D26 (CLI specification), D27 (debugging / `#line` directives), D31 (binary size / linking / build profiles), D51 (dependency declaration syntax), D78 (package/workspace model).

---

#### [C02] Result/Optional Types with Ergonomic Patterns — H-3

**What**: Proper `Result[T, E]` and enhanced `Optional[T]` types with `map`, `flatMap`, `unwrapOr`, and pattern matching sugar.

**Why critical**: Currently there's no standard way to handle errors-as-values. The spec rationale (`rationale/2.error-handling.md`) declares that Error Conditions should be "represented as values, and error handling done using standard control flow" (line 79-80), but provides no standard types for this.

**Implementation**:

```kyokai
// In pure Kyokai, no unsafe needed
union Result[T: Type, E: Type]: Auto is
    case Ok(value: T);
    case Err(error: E);
build;
```

Linear type interaction: `Result[File, Error]` is `Linear` because `File` is `Linear`. You MUST pattern match and handle both cases — the linear type system forces exhaustive error handling automatically.

---

#### [C03] String and Span Comparison — H-2

**What**: `spanEquals()`, `spanCompare()`, `stringEquals()`, `stringCompare()`, plus `startsWith()`, `endsWith()`, `contains()`, `find()`.

**Why critical**: Requiring each program to manually implement byte-by-byte comparison is unreasonable. This is a basic operation for text and protocol processing.

**Implementation**: Pure Kyokai. No unsafe. Just byte comparison loops over `Span[Nat8, R]`. Implement `Equality` and `TotalOrder` typeclass instances for `Span` and `String`.

---

#### [C04] POSIX I/O Layer — H-5

**What**: Safe, capability-secure file I/O and explicit buffered I/O helpers as standard-library surfaces.

**Why critical**: Without this, every program that does I/O must build its own POSIX wrapper from scratch. Kyokai standardizes the safe surface so programs do not each recreate the platform boundary.

**Implementation**: The first safe wrapper inventory covers `read`, `write`, `open`, `close`, `stat`, `uname`, `sysinfo`, `readlink`, `access`, `fork`, `waitpid`, `pipe`, `dup2`, and `execvp`. Buffered I/O uses a linear buffer with explicit construction, destruction, append operations, and `writeAll()`. Wrap these operations in capability-secure APIs following the capability rules stated in the Kyokai spec.

---

#### [C05] Concurrency Model — H-10

**What**: Safe concurrent programming primitives built from visible structured task groups, ownership-transfer channels, explicit synchronization, cooperative cancellation, and explicit readiness waiting.

**Accepted shape**: Every child task is created inside a `taskgroup` and joined before that group exits. SPSC channels transfer ownership of messages and expose explicit capacity, close, cleanup, and backpressure behavior. Shared-memory algorithms use the accepted explicit atomic, mutex, read-write-lock, and condition-variable APIs under the safe memory model. Cancellation uses explicit source/token propagation and named cancellation points. High-concurrency I/O uses explicit `Poller` readiness APIs and source-visible retry loops rather than language-level `async`/`await`. Ordinary blocking calls remain ordinary blocking calls. Kyokai does not add a hidden scheduler, unstructured task spawning, implicit cancellation, or implicit priority inheritance.

**Implementation work**: Implement and test task groups, `spawn`/`join`, channels, `select`, cancellation tokens, deadlines, `Poller`, signal integration, explicit atomics and locks, backend atomic mappings, happens-before rules, diagnostics, and conformance examples. The accepted mechanics are tracked by D3, D90-D95, D100-D101, D141, D146, D156, D164, D168, D183-D184, D212, D234-D237, D247-D248, D252, D256, D282, D317, D327, D342, D353-D354, D388, D411, D457-D457a, and D473.

---

### S-HIGH Items

#### [H01] `defer` Statement — H-6

**What**: `defer consume(x);` at variable declaration point. Compiler ensures the deferred call happens on every exit path from the current scope.

**Why high severity**: Resource-heavy functions otherwise end with long manual destroy chains. This is a major ergonomic cost of linear types.

**Why hardness 6**: Requires compiler modification:

- Parse new `defer` keyword
- In linearity checker: `defer consume(x)` marks `x` as "will be consumed" at scope exit
- Code generation: insert deferred calls before every `return` in scope

**Key constraint**: The `defer` MUST appear in source code. It IS source code. There are no hidden destructor calls. The programmer writes `defer destroyByteBuf(x);` and that's what happens. It's syntactic sugar equivalent to writing the destroy call before every return statement, nothing more.

**Reference**: Zig's `defer` and `errdefer`. Go's `defer`. Both have visible-in-source semantics.

---

#### [H02] Integer and Float Math Library — H-4

**What**: `Kyokai.Math.Int` and `Kyokai.Math.Float` — pure integer and float operations.

**Implementation**: All pure Kyokai. No unsafe. No FFI.

For integers: `abs()`, `min()`, `max()`, `clamp()`, `gcd()` (Euclidean algorithm), `lcm()`, `isPowerOfTwo()` (single AND operation), `nextPowerOfTwo()` (bit manipulation), `countLeadingZeros()`, `countTrailingZeros()`, `popcount()` (all implementable via bit twiddling), wrapping/saturating/checked arithmetic variants.

For floats: IEEE 754 bit manipulation. `isNan(x)` = `x != x`. `isInf(x)` = check exponent bits. `abs(x)` = clear sign bit. `floor()`/`ceil()`/`round()` via exponent inspection.

**Reference**: Hacker's Delight (Henry S. Warren) for bit manipulation algorithms. musl `src/math/__fpclassify.c` for float classification.

---

#### [H03] Trigonometry and Exponentials — Pure Implementation — H-6

**What**: `sin()`, `cos()`, `tan()`, `exp()`, `log()`, `sqrt()`, `pow()` — all in pure Kyokai.

**Why not wrap libm**: These are polynomial evaluations. `sin(x)` is a Chebyshev polynomial after range reduction to `[-π/4, π/4]`. `sqrt(x)` is Newton-Raphson iteration. `exp(x)` is range reduction + polynomial + ldexp. There are no syscalls, no state, no side effects. It's pure math.

**Implementation plan**:

1. Port FDLIBM's `s_sin.c`, `s_cos.c`, `s_tan.c` — each is ~100 lines of C doing argument reduction + minimax polynomial evaluation. The algorithms are public domain (Sun Microsystems, 1993).
2. Port FDLIBM's `e_sqrt.c` — bit manipulation + Newton-Raphson. ~50 lines.
3. Port FDLIBM's `e_exp.c` — range reduction + Horner polynomial. ~80 lines.
4. Verify precision against mpfr/glibc test vectors.

**Reference**: FDLIBM source at `https://www.netlib.org/fdlibm/`. Each function file includes detailed mathematical comments explaining the algorithm and error bounds.

---

#### [H04] HashMap — H-7

**What**: Linear-safe hash map. Keys and values can be `Linear` or `Free`.

**Why hard**: Hash tables require internal arrays (pointer arithmetic) and hashing. The linear type system means:

- Inserting a linear key/value transfers ownership to the map.
- Removing returns ownership back to the caller.
- The map itself is `Linear` and must be explicitly destroyed, which destroys all remaining key/value pairs.

**Implementation sketch**:

- Open addressing (Robin Hood hashing) for cache friendliness.
- Internal `Buffer` for storage (already exists and is linear-safe).
- Hash via the hasher-based `Hashable` protocol: the container selects a concrete hasher, feeds each key through `Hashable.hash(&key, &!hasher)`, and uses the hasher's explicit `finish` result.
- Must handle: insert, remove, get (returns borrow), contains, iterate, destroy.

**Reference**: Zig's `std.HashMap` implementation, Rust's `hashbrown` for Robin Hood hashing strategy.

---

#### [H05] Allocator Abstraction — H-7

**What**: A typeclass-based allocator interface so containers can use custom allocators.

Current state: Everything in the stdlib directly calls `malloc`/`free` through `Austral.Memory`. This means:

- No arena allocators
- No stack allocators
- No pool allocators
- No custom alignment

**Design**:

```kyokai
typeclass Allocator(A: Type) is
    method allocate(alloc: &![A, R], size: Index): Result[Address[Nat8], AllocError];
    method deallocate(alloc: &![A, R], ptr: Address[Nat8], size: Index): Unit;
    method reallocate(alloc: &![A, R], ptr: Address[Nat8], old_size: Index, new_size: Index): Result[Address[Nat8], AllocError];
spec;
```

Every container (`Buffer`, `HashMap`, `String`, etc.) would be parameterized by allocator.

**Reference**: Zig's `std.mem.Allocator` interface. Rust's `std::alloc::Allocator` trait.

---

#### [H06] Separate Compilation — H-8

**What**: Compile **packages** independently, reuse their interface/code artifacts downstream, and link later. Module-by-module incremental recompilation inside a package remains desirable, but it is a secondary optimization layer, not the primary artifact boundary.

**Why hard**: The current compiler is whole-program. Generic body materialization currently happens globally. After D78, D79, D82, D82a, D82b, and D83, separate compilation now has a much more explicit shape:

- Package boundary from D78
- `.koi` interface artifact contract from D79
- Static-dispatch contract from D82
- Generic materialization / instantiation ownership from D82a and D82b
- Reproducible artifact identity from D83

So H06 is no longer "some future cache." It is the package-level compilation model of the language toolchain.

**What it requires**:

- Deterministic per-package `.koi` artifacts
- Reusable compiled code artifacts for nongeneric concrete code
- Enough generic/typeclass metadata for downstream instantiation where D82a and D82b require it
- Incremental dependency/fingerprint tracking for rebuild invalidation
- Link-time or semantics-preserving post-codegen deduplication of identical instantiations where profitable

**Important clarification**:

- **Required first**: package-level separate compilation
- **Wanted later**: module-level incremental recompilation within a package

That means the first implementation target is "depend on compiled packages without recompiling their whole source tree," not "every module is its own independently shipped artifact."

**Reference**: Austral's README explicitly identifies lack of separate compilation as the bootstrapping compiler's main limitation (`README.md`, Status section). OCaml's split between compiled interface artifacts and compiled object code is useful prior art for the package-artifact model.

---

#### [H07] Package Manager — H-6

**What**: `kyokai add`, `kyokai install`, `kyokai publish`, `kyokai update`. Resolve and fetch dependencies according to D51, maintain `kyokai.lock`, and surface package-level audit information.

**Tied to**: The capability-based security model. Borretti's blog post on capabilities (`how-capabilities-work-austral.md` lines 424-445) describes an auditing system where each dependency's unsafe modules must be reviewed. The package manager should implement this.

**Must implement**:

- Workspace dependencies by package name (`core = { workspace = "core" }`)
- External Git dependencies with mandatory `rev`
- Optional `tag`, verified against `rev` at add/update time
- `kyokai add` behavior that never leaves a moving reference in the manifest: unpinned Git adds are errors; tag-based adds resolve and write both `tag` and `rev`; any future HEAD convenience flow must resolve immediately to a stored `rev`
- Rejection of `branch` in manifests
- One lockfile per workspace, otherwise one lockfile per standalone package
- Package-name uniqueness checks within a workspace
- Fetch/update/cache behavior for pinned Git revisions
- Audit surfaces for unsafe modules in dependencies

**Reference**: Borretti's "Dependency Resolution Made Simple" blog post (referenced in the capabilities article). Zig's package manager. Cargo's lockfile format.

**See also**: D17 (visibility / `internal` keyword — requires package concept), D26 (CLI specification — `kyokai add`), D51 (dependency model), D78 (package/workspace model).

---

#### [H08] Fixed-Size Array Type — H-5

**What**: `Array[T, N]` where `N` is a compile-time constant. Stack-allocated, bounds-checked.

**Why needed**: Currently only `Buffer` (heap, dynamic) and `Span` (view, no ownership) exist. Many systems programs need fixed-size stack arrays.

**Requires**: Const-generic or dependent-type mechanism for the size parameter. This is a language-level change.

**See also**: D18 (compile-time evaluation — required for const-generic `N` parameter).

---

### S-MEDIUM Items

#### [M01] `defer` Integration with Linearity Checker — H-4

Ensure the linearity checker treats `defer consume(x)` as consuming `x` at every scope exit. Must validate that deferred consumptions don't conflict.

#### [M02] ASCII/Unicode Base Library — H-3

`Kyokai.Ascii` for byte classification and case conversion. Pure Kyokai, no unsafe. Later: UTF-8 validation and iteration.

**See also**: D30 (Unicode / string encoding — `String` vs `ByteBuf` model, UTF-8 guarantee).

#### [M03] Sorting Algorithms — H-3

`sort()` for `Buffer`. Quicksort + insertion sort hybrid. Pure Kyokai, operates on `Buffer` via mutable borrow. Requires `TotalOrder` typeclass constraint.

#### [M04] Region Parameter Simplification — H-8

Explore region inference for same-scope borrows. This is a compiler change affecting the type system. Must be very careful not to introduce hidden behavior. Possible approach: when all borrows in a function call come from the same scope, allow a single Region parameter to cover all of them. The programmer must be able to opt-in or out.

#### [M05] Cross-Compilation Support — H-5

Wire the C backend to emit code for different targets. Since we generate C, this mostly means setting correct `sizeof` and `alignof` values and using the right cross-compiler.

#### [M06] Error Reporting Improvements — H-4

Better error messages with source context, color output, suggestions. JSON error output for tooling.

**See also**: D29 (compiler diagnostics — full specification with diagnostic codes, output formats, warning categories, error recovery).

#### [M07] LSP Server — H-7

Language Server Protocol implementation for editor support. Needs incremental parsing, type information caching.

#### [M08] Documentation Generator — H-4

Extract docstrings from `.kyo` interface files, generate HTML/Markdown documentation. Austral already has a docstring syntax (triple-backtick strings).

#### [M09] Process Spawning — H-6

`Kyokai.Process`: `spawn()`, `waitpid()`, `pipe()`, `dup2()`. Capability-secure: requires `ProcessCapability`.

#### [M10] Networking — H-8

`Kyokai.Net.Socket`: TCP/UDP. Capability-secure. This is one of the hardest stdlib modules because networking is inherently stateful and error-prone.

---

### S-LOW Items

#### [L01] Typeclass Default Methods — H-4

#### [L02] `while let` Pattern Matching — H-3

#### [L03] Integer Literal Inference for Unambiguous Contexts — H-5

#### [L04] Structured Binding Improvements — H-3

#### [L05] LLVM Backend — H-9

#### [L06] Formal Specification Update — H-3

#### [L07] Test Framework — H-5

**See also**: D28 (testing framework — full specification with inline test blocks, assertions API, `kyokai test` runner).

---
