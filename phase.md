# Kyokai Execution Phases

**Version:** 0.2.38
**Date:** 2026-06-14
**Status:** Active roadmap
**Public decided shape:** `kyokaidecided.md`
**Public D-point index/archive:** `Kyokaishape.md`
**Normative spec:** `kyokaispec/`

## 1. Purpose

This file defines the execution order for turning Kyokai from the decided language plan into a specified, tested, implemented, and eventually proven systems language.

This file is not a second language spec. It is not a reduced scope document. It is not an MVP list. `kyokaidecided.md` is the public extraction of accepted shape, PRs/MRs are the normal home for live public D-points, `Kyokaishape.md` is the public D-point index/archive, and `kyokaispec/` is the normative spec for rules already written there. `phase.md` exists to answer these practical questions:

- what must be written before compiler work can safely move fast
- what parts of the Austral compiler/spec are forked, retired, or rewritten first
- when the Kyokai calculus must be written
- when the generated-C backend, admitted C toolchains, stdlib, package manager, and tooling become valid targets
- what tests and proof artifacts close each phase
- which work is allowed to proceed in parallel and which work is gated by earlier semantics

The guiding rule is simple: implementation order must not create hidden semantics. If a feature cannot be implemented without guessing, the phase is blocked until the relevant rule is written in `kyokaispec/` or opened as a real public D-point PR/MR, with `Kyokaishape.md` used only for index/archive tracking when needed.

## 2. Source-Of-Truth Order

Kyokai has several documents and code trees. They do not have equal authority.

1. `kyokaispec/` is the normative reference once a rule is written there.
2. `kyokaidecided.md` is the public accepted-shape extraction for rules not yet fully spec-extracted.
3. Public PRs/MRs carry live D-point proposals and final wording.
4. `Kyokaishape.md` is the public index/archive for D-points that do not live directly in PRs/MRs.
5. `phase.md` is an implementation and proof-order roadmap only.
6. `lib/`, `standard/`, `test/`, and `test-programs/` are the active compiler, stdlib, and test trees in this repo.
7. Upstream Austral source/tests remain evidence for inherited behavior, not public Kyokai authority.

When a conflict appears, fix the lower-authority artifact. Do not silently reinterpret public Kyokai docs through stale inherited prose.

## 3. Current State

The initial language-design pass is closed enough to seed public development, and the first full Kyokai specification extraction now exists under `kyokaispec/`. That does not mean Kyokai is implemented or proven. It means the active roadmap can stop treating the spec as an empty target and can start treating it as the public contract that compiler work must chase.

Current assets:

- `kyokaispec/` contains the extracted language, toolchain, standard-library, rationale, and appendix chapter family. It is the normative home for written Kyokai rules.
- `kyokaidecided.md` contains the public accepted-shape extraction through D557.
- `Kyokaishape.md` is the public index/archive for D-points that do not live directly in PRs/MRs; live D-points normally live in PR/MR threads.
- `kyokaispec/src/appendices/b-decision-traceability.md` maps accepted decisions into spec sections.
- `kyokaispec/spec.md`, `kyokaispec/spec.html`, `kyokaispec/README.md`, `kyokaispec/Makefile`, and `kyokaispec/SPEC_COMPILER_TRACE.md` describe and build the extracted spec family.
- `lib/` is the forked Austral compiler codebase.
- `standard/` is the current inherited standard-library tree.
- `test/` and `test-programs/` are current public compiler and end-to-end test assets.
- `kyokaicalculus/lean/` pins Lean 4 through Elan and builds the first narrow
  owner-slot repair spot artifact with Lake.

Current liabilities:

- The current compiler and standard library are still largely Austral-shaped.
- The extracted spec needs implementation pressure, review, and conformance tests before it can be treated as proven by tooling.
- D266-D557 have spec destinations or workflow homes. Their compiler commands, tool contracts, standard-library admissions, application-integration contracts, target records, concurrency rules, generated-C/toolchain safety rules, `.koi`/KBI implementation, resolver and lockfile implementation, conformance tests, capability deny-policy implementation, official Bridge collection implementation, and deployed service work still need implementation evidence where their gates require it. The active Phase 3 scaffold implements the D537-D539 source boundary: one `.kyo` file per module, retired `.kai` rejection, per-declaration visibility and `opaque` parsing, derived public/`internal` interface facts, and local visibility/opacity validation for currently represented declaration type surfaces. Final AST construction, complete cross-module semantic export/opacity checking, `.koi` serialization, and inherited-loader replacement remain open.
- The extraction backlog through D557 is closed. Future accepted D-points reopen Gate A until the affected chapter-family work package, trace row, modal audit, and status update land together.
- The D143/D241 sequential `lambda_K-seq` paper proof is closed at the
  `paper-proven` tier for Gate B. A narrow Lean spot artifact checks selected
  owner-slot repair facts mechanically, but it does not mechanically prove
  the main theorem.
- The future mechanized proof is intentionally after self-hosting, not an early bootstrap blocker.

## 4. Non-Negotiable Execution Rules

These rules apply to every phase.

1. No accepted safe Kyokai program may rely on language-level undefined behavior.
2. Generated-C lowering and every admitted C toolchain must preserve Kyokai semantics and must not encode safe operations through C undefined behavior or unsupported compiler assumptions.
3. Every user-visible semantic rule must live in a normative document, not only in compiler code.
4. A test can expose missing behavior, but a test cannot be the only specification of that behavior.
5. All sugar must lower through the D238 pipeline before later checks rely on it.
6. Implicit compiler completions must be recorded in the D239 registry and checked by the tautology pass.
7. Auto-reborrow and read-reborrow behavior must be backed by the D240 conformance matrix.
8. Unsafe operations require source-visible `unsafe contract ... audit;` coverage under D245.
9. Raw FFI cannot pretend to understand Kyokai linear ownership, sum-type layout, capabilities, or cleanup semantics.
10. Pure computation should be written safely in native Kyokai unless D229/D230/D231 explicitly justify a transitional or externally reviewed implementation.
11. The standard library must publish edge-case contracts before a module is admitted as stable.
12. Compiler behavior that is fuzzy enough to argue about is not ready to implement as hidden policy.
13. Daily-use tooling is part of the language contract: project creation, version reporting, health checks, diagnostic explanations, checked fixes, package inspection, vendoring, and test replay must expose exact behavior instead of hiding source, build, or dependency semantics.

## 5. Maturity States

These states track implementation maturity. They are not language editions.

Completion markers in this roadmap use Markdown task boxes:

- [x] done for the named scope
- [ ] not done yet or only partially done; the row text states what remains

| State | Meaning | Exit Requirement |
| --- | --- | --- |
| `SHAPE_DECIDED` | The design point is decided in public accepted-shape docs. | `kyokaidecided.md`, the owning public PR/MR when one exists, and any `Kyokaishape.md` index/archive row agree. |
| `SPEC_EXTRACTED` | The rule has a normative home in `kyokaispec/`. | Exact behavior, errors, examples, and cross-references are written. |
| `CALCULUS_DRAFTED` | The behavior is represented in `lambda_K` scope or explicitly excluded from it. | Syntax, static semantics, and dynamic semantics draft exist. |
| `CALCULUS_PROVEN_PAPER` | The sequential core proof obligation is discharged at paper level. | Preservation/progress-or-defined-failure proof is written and reviewed. |
| `PARSER_ACCEPTED` | Surface syntax is parsed into AST nodes with source spans. | Positive and negative parser tests pass. |
| `ELABORATED_CORE` | Surface constructs lower through the D238 ordered pipeline. | Elaborated output exposes all implicit completions and sugar nodes. |
| `CHECKED` | Name, type, borrow, linearity, capability, contract, and unsafe checks enforce the spec. | Negative conformance tests fail with stable diagnostics. |
| `LOWERED_SAFE` | Backend output implements the checked semantics without backend UB. | C backend and runtime tests cover UB-prone operations. |
| `CONFORMANCE_BACKED` | Behavior has executable tests and diagnostic goldens. | Positive, negative, and edge-case tests run in CI. |
| `STDLIB_ADMITTED` | A stdlib API has its contract, edge cases, tests, and implementation policy. | D229 admission checklist is satisfied. |
| `BOOTSTRAP_RELEASED` | The OCaml/Austral-derived compiler can compile practical Kyokai programs. | Real workloads build without local runtime shims for pure computation. |
| `SELF_HOSTING` | Important compiler components are written in Kyokai and built by Kyokai. | The Kyokai toolchain can build the self-hosting slice from source. |
| `MECHANIZED_PROVEN` | The relevant core theorem is machine-checked. | Proof assistant artifacts build in CI. |

## 6. Global Gates

These gates are stronger than ordinary phase completion. Public claims should not move past a gate until the gate is closed.

### Gate A: Plan-To-Spec Closure

Every decided D-point has one of these destinations:

- a normative language-spec section
- a normative toolchain-spec section
- a normative standard-library contract section
- an explicit implementation-only note with no semantic authority
- a historical-only note retained outside public spec flow

Done when there is no live behavior whose only source is an old recommendation block or informal note. The accepted decisions through D557 now have normative spec destinations or explicit workflow/service homes. Gate A is closed for the accepted design set through D557. New accepted D-points reopen Gate A until they receive the same extraction or routing treatment.

### Gate B: Sequential Core Soundness

D143/D241 require a paper-level proof for the sequential ownership-and-borrowing core before `v1.0`.

Done when `lambda_K` has:

- abstract syntax
- type and kind/universe rules
- linear and unrestricted contexts
- borrow and region rules
- operational semantics
- explicit TPOE / defined terminal failure states
- preservation theorem
- progress-or-defined-failure theorem
- a surface-to-core mapping for the features included in the first proof scope

### Gate C: Compiler Semantic Pipeline

The compiler must implement the D238/D239/D240 pipeline before ergonomic surface features are considered trustworthy.

Done when parser, typed elaboration, implicit-completion registry, tautology checking, sugar lowering, and linearity/borrow/capability checks are observable in tests and diagnostics.

### Gate D: Generated-C And C-Toolchain Closure

The generated-C backend and every admitted C compiler/target contract must preserve safe Kyokai semantics without C undefined behavior, unsupported compiler assumptions, or silent target fallback.

Done when lowering rules exist for arithmetic, shifts, floats, enum/union tags, records, packed records, pointers, stack checks, volatile, atomics, panic/TPOE, and FFI calls; major-platform compiler admission records pass; source-map/debug/sanitizer evidence exists; and compilation-time gates are measured on named reference systems.

### Gate E: Practical Bootstrap Usability

Kyokai must compile real systems code, not only toy examples.

Done when a representative small POSIX CLI workload can be written in Kyokai with native stdlib support for buffers, strings, POSIX I/O, process information, formatting, error handling, and cleanup.

### Gate F: Public Conformance Release

This gate is the earliest point where the project can claim the language surface is externally testable.

Done when the extracted spec, `lambda_K` paper proof, compiler conformance suite, stdlib admission records, package/workspace behavior, project scaffolding, package graph and vendoring commands, diagnostic explain/fix behavior, version and doctor output, property/fuzz replay controls, formatter, and generated docs agree.

### Gate G: Self-Hosting And Mechanization

Mechanized proof is after self-hosting by design.

Done when Kyokai compiler components are written in Kyokai, the bootstrap path is documented, and the proof assistant artifacts build against the chosen formalization.

### Gate Closure Status

| Gate | Current State | Closed Evidence | Still Open |
| --- | --- | --- | --- |
| Gate A: Plan-To-Spec Closure | Closed through D557 | `kyokaispec/` carries the normative language/toolchain/stdlib extraction including the D537-D539 single-file module model and D540-D557 application-integration contracts, `src/appendices/b-decision-traceability.md` maps accepted decisions through D557, and workflow/service-only decisions route to public standards and service records | New accepted D-points reopen Gate A until they receive normative extraction or an explicit workflow/service/historical home |
| Gate B: Sequential Core Soundness | Closed for `lambda_K-seq` paper proof | `kyokaicalculus/scope.md` freezes the first theorem boundary; claim tiers, explicit static inference rules, an environment-and-continuation machine with resource store `Sigma`, lease graph `B`, static-to-runtime witness `I`, owner slots `Xi`, environments `eta`, and continuations `K`, a 40-lemma proof index, revised preservation/progress proof overview, expanded close-and-witness, call-entry, primitive-admission, frame-typing, source-expression, and equivariance derivation packages, the closed `theorem-assembly.md` L1-L40/Theorem P/Q paper proof, forty-nine executable model spot checks, a twenty-five-trace executable whole-machine regression slice, a narrow checked Lean owner-slot artifact with twenty-five named theorems, a surface map, and later-layer plans exist | Whole-core Lean mechanization, compiler conformance, concurrency, unsafe/FFI, backend lowering, stdlib admission, toolchain behavior, package management, and hosted services remain outside Gate B and are tracked by later gates |
| Gate C: Compiler Semantic Pipeline | Open | Spec text describes the required D238/D239/D240 shape | Parser, typed elaboration, implicit-completion registry, tautology checking, and safety checks are not implemented as a tested pipeline |
| Gate D: Generated-C And C-Toolchain Closure | Open | D530-D536 specify one generated-C backend, C11 subset, compiler admission, source-oriented DX, performance gates, external-tool evidence, and standard profiles | C emitter UB closure, major-platform compiler admissions, source-map/debug/coverage/profiler implementation, sanitizer/conformance evidence, and measured build-time gates are not done |
| Gate E: Practical Bootstrap Usability | Open | Required workload shape and stdlib domains are identified | Native stdlib modules and representative small POSIX CLI workload support are not implemented |
| Gate F: Public Conformance Release | Open | Spec extraction, the Gate-B paper proof, and daily-usability command contracts exist | Compiler conformance suite, package behavior, formatter, diagnostics, docs, and stdlib admission records do not yet agree in implementation |
| Gate G: Self-Hosting And Mechanization | Open | Lean 4 is selected; Elan and Lake build the narrow owner-slot repair artifact; self-hosting and whole-core mechanization order are specified | Self-hosting compiler slices, whole-core Lean encoding, mechanized soundness, and proof CI have not begun |

Closed gates right now: Gate A is closed for accepted decisions through D557, and Gate B is closed for the narrow `lambda_K-seq` paper proof. No compiler, generated-C/toolchain, stdlib implementation, package implementation, application-integration implementation, Bridge collection implementation, release, self-hosting, or whole-core mechanized proof gate is closed yet.

Gate checklist:

- [x] Gate A: Plan-To-Spec Closure through D557.
- [x] Gate B: Sequential Core Soundness for the narrow `lambda_K-seq` paper proof.
- [ ] Gate C: Compiler Semantic Pipeline.
- [ ] Gate D: Generated-C And C-Toolchain Closure.
- [ ] Gate E: Practical Bootstrap Usability.
- [ ] Gate F: Public Conformance Release.
- [ ] Gate G: Self-Hosting And Mechanization.

## 7. Build Order

The phases below are ordered by dependency, not by excitement. Some implementation work can run in parallel after its input contracts exist, but no phase may bypass its gates by treating unspecified behavior as compiler policy.

### Phase 0: Repository Baseline And Decision Audit

**Purpose:** Establish the workspace facts and remove stale planning assumptions before implementation churn begins.

**Dependencies:** None.

**Status:** Complete enough for the implementation-roadmap baseline. No global gate is closed by Phase 0 alone; it prepares Gate A by making the source tree and document authority visible.

**Subparts:**

0.1. Verify the initial decision batch has been extracted into public accepted shape or explicitly left as historical-only context. **Status: complete.** `kyokaidecided.md` now holds the accepted-shape extraction used for spec writing.

0.2. Record the source-of-truth order in this file and in public workflow docs. **Status: complete.** Current order is `kyokaispec/` once written, then `kyokaidecided.md`, then public D-point PRs/MRs, then `Kyokaishape.md` as index/archive when needed, then `phase.md` for implementation order only.

0.3. Inventory the active public source, specification, standard-library, test, and upstream-reference trees and assign each one a purpose. This means documenting what `lib/`, `standard/`, `kyokaispec/`, `test/`, `test-programs/`, and upstream `austral/` references are used for. It does not require moving them. **Status: complete enough for Phase 0.** Deeper compiler-pass inventory belongs to later implementation phases.

0.4. Identify stale references in public docs, especially inherited Austral text and old path names. **Status: complete enough for Phase 0.** The root README, `kyokaispec/README.md`, `kyokaispec/SPEC_COMPILER_TRACE.md`, and active spec root describe Kyokai as a full forked language spec that carries forward applicable Austral behavior while defining Kyokai's differences directly. Remaining stale inherited docs can be cleaned as they are touched.

0.5. Create or update a D-point-to-work-area map covering parser, resolver, type checker, linearity checker, code generation, runtime, stdlib, package manager, and tooling. This is not only `Kyokaishape.md`: live/new public D-points normally live in PRs/MRs, `Kyokaishape.md` indexes or archives points that do not live there, and `kyokaidecided.md` plus `kyokaispec/` trace accepted decisions to implementation areas. **Status: complete enough for Phase 0.** `kyokaispec/src/appendices/b-decision-traceability.md` is the spec-facing traceability index, and future decisions must update it when they become accepted.

0.6. Keep the extracted Kyokai spec under `kyokaispec/`. Inherited Austral spec material may be used as a seed, but Kyokai spec text must be reviewed and rewritten before it becomes normative. **Status: complete enough for Phase 0.** The active build uses the Kyokai chapter family under `kyokaispec/src/`; old inherited Austral chapters are no longer the active spec source.

**Done when:**

- `phase.md` no longer contains stale D-point meanings.
- Every major public source and reference tree has an assigned purpose.
- The spec extraction target path is chosen.
- Stale path references are either fixed or tracked.
- Implementation work has a visible dependency map back to public shape/spec sections.

**May run in parallel with:** Early compiler inventory and test-harness inventory.

**Must not do:** Rewrite language behavior while calling it cleanup.

### Phase 1: Normative Kyokai Specification Extraction

**Purpose:** Convert the public accepted shape into maintainable normative specs under `kyokaispec/`.

**Dependencies:** Phase 0.

**Status:** `SPEC_EXTRACTED` through D557 for normative language, toolchain, stdlib, rationale, and appendix rules. Workflow/service-only decisions through D557 are routed to public standards and the service board. This closes Gate A through D557 without claiming compiler implementation, conformance tests, resolver implementation, application-integration implementation, capability deny-policy implementation, Bridge collection implementation, generated-C/toolchain implementation, or deployed services. Gate B is separately closed for the narrow `lambda_K-seq` paper proof; Gates C-G remain open.

**Subparts:**

1.1. Create the Kyokai language spec structure under `kyokaispec/`. Use inherited Austral spec material as formatting and organization prior art only after checking it against actual Austral compiler behavior.

1.2. Extract lexical syntax, comments, docstrings, literals, numeric suffixes, keywords, operators, terminators, and source-file structure.

1.3. Extract declarations: modules, interfaces/bodies, records, unions, extern/packed records, type aliases, newtypes, typeclasses, associated types, capability declarations, constants, functions, tests, and visibility.

1.4. Extract expression and statement semantics: evaluation order, `let`, assignment, `case`, `if`, loops, `while let`, `for-in`, `let...else`, `or return`, `defer`, `errdefer`, `debug`, `panic`, `require`, `ensure`, and `old`.

1.5. Extract the type system: `Free`, `Linear`, `Auto`, region behavior, borrow types, reference syntax, field auto-deref, auto-reborrow, linear destructuring, `Never`, optional/result shapes, generics, const generics, and monomorphization.

1.6. Extract capability and authority rules: `RootCapability`, ordinary capabilities, task-transfer classifications, unsafe capability access, sealed capabilities, and authority flow across FFI and tasks.

1.7. Extract FFI and unsafe rules: `foreign`, `pragma Unsafe_Module`, `UnsafeCapability`, `unsafe contract ... audit;`, raw pointer/address rules, volatile, inline assembly, ABI records, sum-type boundary wrappers, ownership transfer wrappers, and failure contracts.

1.8. Extract concurrency rules: 1:1 OS-thread tasks, task groups, spawn capture lists, join, cancellation, SPSC channels, select, atomics, memory orders, happens-before edges, mutexes, `RwLock`, `Poller`, `SignalWatcher`, broker patterns, and process supervision.

1.9. Extract runtime-failure semantics: TPOE, `panic`, runtime-fatal/internal failures, stack overflow detection, OOM, failed assertions/contracts, arithmetic errors, and the rule that TPOE/panic are not catchable in process.

1.10. Extract backend and layout rules: one generated-C backend, C11 subset, compiler admission, record layout, packed layout, extern layout, endian transforms, C UB avoidance, source maps, linking, binary outputs, target profiles, and compilation-time gates.

1.11. Extract the toolchain spec: `kyokai --version`, `doctor`, `init`, `new`, `check`, `build`, `run`, `test`, `fmt`, `doc`, `lsp`, `audit`, `bench`, `repl`, `explain`, `fix`, package/workspace manifests, lockfiles, `.koi` artifacts, target triples, profiles, generated artifacts, diagnostics, JSON output, warning suppression, lints, semver checking, and package commands including `add`, `remove`, `update`, `search`, `info`, `tree`, `why`, `outdated`, `vendor`, and `publish`.

1.12. Extract the stdlib admission and contract spec: D229 admission criteria, D231 crypto policy, D232 numerical accuracy contracts, allocator policy, formatting, `StandardError`, collections, OS APIs, capabilities, and transitional FFI tracking.

1.13. Add a traceability index from each public D-point or accepted-shape entry to the normative spec section that owns it.

1.14. Keep historical research notes out of the final spec unless they are needed for rationale.

1.15. Apply the D502 contract-matrix discipline while extracting every user-visible rule. Language, toolchain, and stdlib chapters use their own required matrix fields. Workflow-only and service-only documents name their role explicitly instead of masquerading as language semantics.

1.16. Run the D479-D487 and D508 modal-word audit over each touched normative chapter. Every `may`, `should`, `optional`, `if provided`, `if admitted`, `future`, `later`, `where relevant`, `unspecified`, `implementation-defined`, or equivalent hit is rewritten or classified in the review record. A hit that would change accepted behavior becomes a new D-point instead of an editorial guess.

1.17. Extract the strict-linearity usability closure from D488-D501. This includes resource-flow refactors, sound scratch workflows, graph/slot-map guidance, recovery payloads, explicit context bundles, callback invocation classes, linear fixtures, join diagnostics, hole-free collections, universe-aware containers, early-release warnings, FFI wrapper kits, the `build` expression, and the stdlib admission ladder.

1.18. Extract the D502-D529 toolchain, public-infrastructure, ProofTrace evidence, capability deny-policy, final resolver/lockfile closure, and official Bridge collection closure. Normative toolchain behavior lands in `kyokaispec/src/toolchain/`; numeric and Bridge admission evidence lands in `kyokaispec/src/stdlib/`; workflow rules land in `PROJECT_STANDARDS.md` and `docs/contributing/spec-writing.md`; service ownership lands in `docs/infrastructure/services.md`; website, examples, organization migration, repository-owned package docs, optional package-doc mirrors, and `kyokai-showcase` receive tracked implementation issues or PRs without being presented as implemented.

1.19. Keep `kyokaispec/src/appendices/b-decision-traceability.md` synchronized as each work package lands. A work package is not complete when prose exists only in `kyokaidecided.md`; its trace row must point at the normative chapter, workflow home, service record, or historical-only note that owns it.

#### Phase 1 Extraction Board

This board is the executable spec-writing queue. It groups accepted decisions by the document family that must absorb them. Each row is complete only when the destination text, D502 matrix, modal audit, traceability update, and review note exist.

| Work package | Accepted pressure | Required destination | Completion evidence |
| --- | --- | --- | --- |
| S1: Lexical, grammar, declarations, and control flow | D313, D322-D323, D335, D340-D341, D368-D370, D390, D420, D467, D469, D500, D537-D539 | `language/02-lexical-syntax.md`, `language/03-grammar.md`, `language/04-modules-and-visibility.md`, `language/05-declarations.md`, `language/08-patterns.md`, `language/10-statements-and-control-flow.md` | Grammar tables, single-file module model, per-declaration visibility, opaque representation, illegal-form diagnostics, lowering notes, examples, and matrix rows. |
| S2: Types, universes, generics, borrowing, and elaboration | D318-D319, D337-D339, D348-D349, D356, D360-D361, D373-D377, D386-D387, D466, D470, D492-D493, D495, D497 | `language/06-type-system.md`, `language/07-generics-and-typeclasses.md`, `language/09-expressions-and-evaluation.md`, `language/11-linearity-borrowing-and-regions.md`, `language/12-implicit-completions-and-elaboration.md` | State tables, completion registry rows, `.koi` facts, rejection cases, and elaboration order. |
| S3: Failure, capabilities, concurrency, unsafe, ABI, layout, and backend | D310, D321-D322, D327-D329, D342-D355, D358, D378-D381, D388-D389, D432-D465, D471-D473, D477, D491, D493-D499 | `language/13-contracts-and-runtime-failure.md` through `language/17-memory-layout-and-backend-contract.md` | Failure taxonomy, authority tables, target gates, unsafe contracts, memory-model tables, lowering obligations, and diagnostic rows. |
| S4: Built-ins and source examples | D316, D323, D330-D331, D335-D336, D341, D355, D359, D362, D365, D370-D372, D385 | `language/18-built-ins.md`, `language/19-examples.md`, `examples/` | Built-in contracts, accepted examples, target/capability metadata, and CI classification. |
| S5: Toolchain CLI, diagnostics, formatter, tests, Analysis Server, artifacts, and package behavior | D302-D304, D307-D308, D311, D315, D320-D321, D328, D332-D333, D351-D352, D364, D383, D391, D396-D431, D474-D475, D479-D489, D495, D497-D499, D503-D505, D509, D516, D518 | `toolchain/00-toolchain-overview.md` through `toolchain/11-build-generation-and-playground.md` | Command matrices, machine-output schemas, diagnostic/fix IDs, artifact layouts, protocol lanes, network policy, cache identity, and replay contracts. |
| S6: Stdlib admission, containers, text, OS, concurrency, numerics, crypto, and transitional FFI | D305, D309, D324-D327, D344, D347, D357, D362-D363, D370-D372, D374, D376, D384-D385, D392, D401, D408-D413, D417, D490-D501, D517 | `stdlib/00-stdlib-overview.md` through `stdlib/11-transitional-ffi-tracking.md` | Admission records, tier checklist, allocation/failure/capability fields, target tables, oracle/test-vector rows, and transitional FFI records. |
| S7: Workflow, service board, website, examples, organization migration, package docs, showcase, and ProofTrace evidence graph | D306-D307, D315, D367, D383, D407, D478, D502, D506-D508, D510-D516, D519-D526 | `PROJECT_STANDARDS.md`, `docs/contributing/spec-writing.md`, `docs/infrastructure/services.md`, `README.md`, `website/`, `examples/`, and tracked PRs/issues | Public process text, service records, repo split records, website source plan, examples taxonomy, and non-semantic implementation tracking. |
| S8: Formalization roadmap and claim boundaries | D143/D241, D312, D319, D367, D394, D477, D479-D529 | `appendices/d-formalization-roadmap.md`, `kyokaicalculus/scope.md`, `kyokaicalculus/claim-tiers.md`, `kyokaicalculus/syntax-and-statics.md`, `kyokaicalculus/dynamics.md`, `kyokaicalculus/lemmas.md`, `kyokaicalculus/paper-proof.md`, `kyokaicalculus/deviation.md` | Claim tiers, proof exclusions, environment-machine semantics, later-layer owner map, surface/core obligations, authority-policy proof exclusions, resolver proof exclusions, Bridge proof exclusions, and Gate B input list. |

**Extraction board status:** S1-S6 and S8 are `SPEC_EXTRACTED` for accepted decisions through D557. S7 is `WORKFLOW_ROUTED`: public standards and the service board exist, while website, repository split, showcase, and hosted-service implementation stay as later tracked infrastructure work.

Extraction board checklist:

- [x] S1: Lexical, grammar, declarations, and control flow.
- [x] S2: Types, universes, generics, borrowing, and elaboration.
- [x] S3: Failure, capabilities, concurrency, unsafe, ABI, layout, and backend.
- [x] S4: Built-ins and source examples.
- [x] S5: Toolchain CLI, diagnostics, formatter, tests, Analysis Server, artifacts, and package behavior.
- [x] S6: Stdlib admission, containers, text, OS, concurrency, numerics, crypto, and transitional FFI.
- [ ] S7: Workflow, service board, website, examples, organization migration, package docs, showcase, and ProofTrace evidence graph is publicly routed; service implementation remains later infrastructure work.
- [x] S8: Formalization roadmap and claim boundaries.

**Done when:**

- Gate A is closed for accepted decisions through D557 because every accepted point has a normative spec destination or an explicit workflow/service destination before implementation depends on it.
- The extracted Kyokai spec can be read without needing informal planning context for normative behavior.
- Every D-point has a traceability destination.
- The spec has no phrases like "implementation-defined" unless the implementation choice is itself explicitly bounded and observable.
- The Austral spec material has either been forked into Kyokai wording or marked as inherited reference only.

**May run in parallel with:** Phase 2 research writing and compiler pass inventory.

**Must not do:** Treat inherited Austral spec text as authoritative when compiler source/tests disagree.

### Phase 2: Sequential `lambda_K` Core Calculus And Paper Proof

**Purpose:** Discharge the D143/D241 proof obligation for Kyokai's sequential safety core before `v1.0`.

**Dependencies:** Phase 1 core-language extraction should be far enough along to avoid proving the wrong language. Full toolchain spec extraction is not a blocker.

**Status:** Gate B is closed for the narrow sequential `lambda_K-seq` paper theorem. Scope freeze, claim tiers, explicit static inference rules, an environment-and-continuation machine, a 40-lemma proof index, revised preservation/progress proof overview, expanded close-and-witness, call-entry, primitive-admission, frame-typing, source-expression, and equivariance derivation packages, and the closed `theorem-assembly.md` L1-L40/Theorem P/Q proof exist under `kyokaicalculus/`. Supporting evidence includes forty-nine executable model spot checks, a twenty-five-trace executable whole-machine regression slice, and a narrow checked Lean owner-slot artifact with twenty-five named theorems. The earlier substitution runtime was retired because it duplicated owner syntax across mutually exclusive branches, was not closed over arbitrary linear sums, and left calls and lease availability under-specified. The repaired model keeps runtime owners in unique slots, distinguishes static store typing from runtime resource state, retains all leases separately from the usable lease frontier, checks suspended mutable tokens at call boundaries, connects runtime token types to referent slots, separates static region and lease atoms from runtime identities through explicit witness `I`, permits explicit caller/callee witness aliasing without conflating it with fresh identity minting, retains elaborated `call f[phi](args)` witnesses, derives invocation-local `psi`, defines formal `bind_call_args` and `result_bridge`, restricts cleanup to resolved named consuming operations without structural fallback, admits primitive relations only after totality obligations, models named borrow-token read/write access, stores witness aliases in scope-owned layers, materializes pre-argument whole-referent certificate `pi`, gives continuation frames intrinsic input/output typing, freshens callee-local atoms per invocation, separates ordinary progress from intrinsic terminal TPOE classification, and requires every retained writer's same-slot leases to remain on one suspension chain so local close cannot resume a writer beside an unrelated reader. Whole-core Lean mechanization and compiler conformance remain later gates; the checked Lean spot artifact does not mechanically establish the main theorem.

**Subparts:**

2.1. Freeze the first calculus scope in `kyokaicalculus/scope.md` and keep the theorem exclusions explicit.

2.2. Define the core syntax for variables, values, first-order functions, `let`, explicit consumption, borrow creation, borrow end, checked primitive operations, explicit TPOE, and minimal closed-sum/exhaustive-case support.

2.3. Define core types and universes: unrestricted/free values, linear resources, immutable borrows, mutable borrows, base integers/bools/unit, and any minimal optional/result form included in the core.

2.4. Define typing contexts explicitly: declaration context, unrestricted context, linear context, region/borrow context, and any dynamic-store typing needed by the semantics.

2.5. Define static rules for linear use, no drop, no duplicate, borrow exclusivity, borrow lifetime, capability-as-linear-value behavior, function calls, and checked operations.

2.6. Define dynamic semantics with deterministic evaluation order and terminal configurations for values, normal steps, and TPOE. Route runtime-fatal states to the later runtime/backend layer.

2.7. Prove preservation for all included reduction rules.

2.8. Prove progress-or-defined-failure: a well-typed configuration is a value, can step, or is in a defined terminal failure state such as TPOE.

2.9. Write the surface-to-core mapping for included features, especially `require`, `ensure`, `old`, UFCS-as-call, checked arithmetic, explicit cleanup states, and simple pattern control flow.

2.10. List exclusions explicitly: modules, packages, typeclasses, generics, FFI, allocators, formatting, OS, concurrency, atomics, channels, backend lowering, and unsafe reasoning.

2.11. Update the maintained public calculus artifacts and the formalization appendix whenever accepted shape adds a proof-relevant rule or a non-proof conformance obligation. The calculus docs must classify each rule as first-core theorem, surface elaboration, later extension calculus, separate concurrency model, unsafe/FFI boundary, backend-preservation obligation, stdlib evidence model, toolchain conformance model, workflow-only rule, or infrastructure-only rule.

2.12. Record the D488-D501 strict-linearity closure in the formalization map. D495 branch joins and D500 `build` lowering are surface/core obligations; D491 recovery payloads, D492 explicit bundles, D493 invocation classes, D496 hole-free collection APIs, D497 container universes, and D498 early release are later language/stdlib contract obligations; D488, D489, D494, D499, and D501 are tooling, test-harness, FFI-admission, or stdlib-evidence obligations rather than new `lambda_K-seq` theorem claims.

2.13. Record the D502-D529 closure in the formalization map as toolchain conformance, docs-process, authority-policy, resolver, official Bridge collection, or infrastructure obligations. These decisions do not enlarge the first sequential theorem. D502 and D508 constrain proof/spec writing discipline; D503-D505, D509, D515-D518, D525, D527, D528, and D529 constrain toolchain, stdlib, unsafe, and package conformance; D506-D507, D510-D514, and D519-D524 remain workflow or infrastructure boundaries. D526 adds evidence-graph validation and does not enlarge the theorem.

2.14. Maintain the expanded Gate-B derivation packages: `kyokaicalculus/close-and-witness-proof.md`, `kyokaicalculus/call-entry-proof.md`, `kyokaicalculus/primitive-admission-proof.md`, `kyokaicalculus/frame-typing-proof.md`, `kyokaicalculus/source-expression-proof.md`, and `kyokaicalculus/equivariance-proof.md`. Their L1-L40 and transition-family arguments are composed by `kyokaicalculus/theorem-assembly.md`, which is the paper-proof artifact that closes Gate B for `lambda_K-seq`.

2.15. Expand executable evidence from local spot checks into a whole-machine runner that exercises typed configuration construction, continuation-frame transitions, ordinary completion, and intrinsic TPOE. The first twenty-five traces now cover linear-let discharge, both branch selections, arbitrary linear-sum movement, owned-call parameter discharge and returned-owner transfer, nested contract TPOE abandoned-carrier accounting, mutable-reborrow close and resumed access, read-reborrow close, direct immutable and mutable-borrow access, checked-primitive success and TPOE, capability attenuation, selected linear-sum payload consumption, successful contract checking, zero-argument call entry, source-ordered multi-argument call entry, zero-argument checked-primitive success and TPOE, explicit injection followed by linear-payload case discharge, free-payload case binding, unrestricted variable lookup, and returned-local-borrow rejection at region close. Broaden the runner alongside the paper derivations. Keep it labeled as executable evidence; it does not replace the paper proof.

**Done when:**

- Gate B is closed.
- The proof document is reviewable without relying on informal plan prose.
- Excluded features are named as future proof extensions, not hidden assumptions.
- The compiler's core IR/elaboration plan can point at the calculus for the sequential ownership core.

**May run in parallel with:** Parser/frontend bring-up after enough surface syntax is extracted.

**Must not do:** Try to prove the whole language in the first paper proof.

### Phase 3: Compiler Fork Identity And Frontend Surface Bring-Up

**Purpose:** Turn the Austral-shaped compiler into a Kyokai compiler at the source-language boundary.

**Dependencies:** Phase 1 lexical/syntax extraction. Phase 2 may be in progress.

**Status:** Active scaffold. `docs/compiler-pipeline-inventory.md` maps the inherited entry and pass boundaries. The isolated frontend now accepts one `.kyo` source role, rejects retired `.kai`, inherited `.aui`/`.aum`, and handwritten `.koi`, validates source bytes, tokenizes the Kyokai lexical scaffold, and parses one module start symbol with imports, pragmas, definitions, `public`/`internal`/private-by-default visibility, `opaque` record/union modifiers, structured constant/type-alias/function/record/bitrecord/union/typeclass/instance/generator summaries, generic parameter classifiers, named/applied types, unresolved bare generic arguments, unambiguous `Index` literal/arithmetic generic arguments, anonymous and named-region borrows, bare function-pointer types, structured `where` obligations, ordered `require`/`ensure` expression spans, declaration-guard spans, associated-type declarations/definitions, required/default/instance method signatures, semantic terminators, and stable spans. Top-level bodyless generators are rejected under the one-file definition rule. `KyokaiInterfaceValidation` rejects local private/internal type leaks from represented public/internal constant, alias, function, record, union, typeclass-method, instance, and generator surfaces, preserves opaque representation hiding, and rejects private `opaque` declarations. `KyokaiPackageSource` runs that validation while discovering one `.kyo` file per logical module, applying executable-entry shebang policy, verifying path/module identity and entry definitions, and deriving the public/`internal` declaration surface that later `.koi` production consumes. Manifest, workspace, workspace-only resolver graph, and deterministic workspace lockfile scaffolds remain in place. The Dune-built stage runner exercises the updated single-file parser/module/interface/package fixtures as supporting evidence only. Git/index solving, graph-changing lockfile modes, package-index solving, workspace profile inheritance, inherited-loader replacement, semantic `kyokai check`, cross-module and remaining declaration export/opacity checks, `.koi` serialization, final AST construction, guard/contract/body expression AST and semantics, generator body/yield AST and suspension semantics, foreign/unsafe declaration structure, full const-generic expression/comptime calls and argument-kind resolution, full associated-type resolution and coherence, bitrecord range semantics, source-span conformance, and the phase-local parser/source gate remain open.

**Subparts:**

3.1. Rename command, diagnostics, namespace defaults, standard-library roots, editor metadata, examples, and test names from Austral to Kyokai where they are no longer reference-only.

3.2. Establish the single-file module rule (D537): one `.kyo` source file per module, the compiler-derived `.koi` interface artifact, and rejection of the retired `.kai` extension and any inherited two-file mode.

3.3. Implement lexer changes for Kyokai keywords, comments, docstrings, numeric literal separators, numeric literal suffixes, string/raw/code-point/byte literals, and rejected inherited tokens.

3.4. Implement parser support for Kyokai declaration terminators and semantic block terminators: `qed`, `build`, `seal`, `spec`, `od`, `fi`, `esac`, `join`, `pick`, `audit`, and other decided closures.

3.5. Implement parser support for major surface constructs: UFCS dot calls, record/union construction, pattern matching, `let...else`, `or return`, `while let`, `for-in`, `defer`, `errdefer`, `taskgroup`, `spawn`, `select`, `debug`, contracts, unsafe contract blocks, and inline tests.

3.6. Preserve source spans and enough AST metadata for D239 implicit-completion auditing and diagnostics.

3.7. Add parser negative tests for old Austral forms that Kyokai deliberately rejects unless a migration mode is explicitly selected.

3.8. Keep public compiler and package fixtures synchronized with decided syntax; historical comparison material remains outside the public conformance surface.

**Done when:**

- Basic Kyokai source files parse with stable source spans.
- Old Austral syntax is not accidentally accepted as Kyokai syntax.
- Parser tests cover accepted and rejected forms.
- CLI identity and module roots no longer present as accidental Austral branding in user-facing paths.

**May run in parallel with:** Toolchain skeleton work that only depends on parser invocation.

**Must not do:** Keep inherited syntax because it is easier unless the plan says Kyokai kept it.

### Phase 4: Name Resolution, Imports, Packages, And Interface Artifacts

**Purpose:** Implement Kyokai's compilation unit, package, visibility, and lookup rules before deep typing makes them harder to change.

**Dependencies:** Phase 1 declaration/toolchain extraction and Phase 3 parser support.

**Status:** Not started. The package/spec gate is open.

**Subparts:**

4.1. Implement module identity, package identity, module root layout, and import path resolution.

4.2. Implement the single-file module rule (D537): one `.kyo` source file per module and the compiler-derived `.koi` interface, replacing interface-body pairing.

4.3. Implement per-declaration visibility (D538): `public`, `internal`, private-by-default, rejection of an explicit `private` marker, package boundary checks, the `opaque` representation modifier (D539), import collision errors, and explicit `as` renaming.

4.4. Implement ordinary name lookup exactly as specified before UFCS fallback is added.

4.5. Implement D254 receiver-module UFCS fallback only after ordinary lookup finds no candidate.

4.6. Implement the remaining package/workspace manifest surface, expand final resolver graph construction beyond workspace-only graphs, complete deterministic lockfile reading/writing/repair for every D528 source kind and mode, workspace member discovery, target/profile selection, and source file discovery.

4.7. Implement `.koi` interface artifact generation and consumption for package-level separate compilation.

4.8. Implement package-level generic/typeclass metadata requirements for downstream instantiation under the D82/D82a/D82b family.

4.9. Add cycle detection, duplicate logical-module detection, and reproducible artifact identity checks.

**Done when:**

- `kyokai check` can load a package/workspace and resolve modules without manual file ordering.
- Import ambiguity is an error at the import site.
- UFCS does not create global ADL or dependency-wide method search.
- `.koi` artifacts are deterministic enough to use in tests.

**May run in parallel with:** Early toolchain CLI plumbing and formatter work.

**Must not do:** Let import order or dependency order silently choose winners.

### Phase 5: Type System, Elaboration Pipeline, And Core IR

**Purpose:** Build the semantic frontend around the exact D238 lowering order.

**Dependencies:** Phases 1, 3, and 4. Phase 2 should be far enough to guide the core IR shape for the sequential subset.

**Status:** Not started. Gate C is open.

**Subparts:**

5.1. Define the compiler's typed core IR and explicitly document which surface constructs elaborate into it.

5.2. Implement D238 pass order:

1. Parse source into surface AST.
2. Perform syntax-only lowering that does not need type facts.
3. Resolve names and call shapes.
4. Type-check and elaborate expressions.
5. Insert D87 implicit completions as explicit elaboration nodes.
6. Record every implicit completion in the compiler-maintained registry.
7. Run the D239 tautology-check pass over those elaboration nodes.
8. Lower typed sugar.
9. Run linearity, borrow, capability, contract, unsafe, and backend-readiness checks.

5.3. Implement universes and kind rules for `Free`, `Linear`, and `Auto`.

5.4. Implement records, unions, aliases, newtypes, fixed arrays, optional/result shapes, `Never`, and built-in types.

5.5. Implement generics, const generics, monomorphization ownership, static dispatch, typeclasses, associated types, default methods where specified, coherence, and orphan rules.

5.6. Implement literal typing, D12 bidirectional literal inference, D261 suffix typing, and all numeric representability checks.

5.7. Implement expression typing for calls, UFCS, indexing, bitwise keyword operators, arithmetic variants, comparisons, boolean operations, ranges, casts/conversions, and format DSL checks.

5.8. Implement pattern typing for `case`, `let...else`, `while let`, destructuring, exhaustive matches, and no-shadowing.

5.9. Implement contract typing for `require`, `ensure`, `old`, and TPOE-producing checks.

5.10. Implement typed sugar lowering for `or return`, `or break`, `or continue`, `for-in`, `while let`, UFCS, field auto-deref, and auto-reborrow.

5.11. Build a conformance view that can show the elaborated core for tests and debugging.

**Done when:**

- Gate C's frontend half is complete.
- Type errors and ambiguity errors are deterministic and diagnostic-coded.
- Elaboration output exposes implicit completions instead of hiding them.
- The sequential subset matches the `lambda_K` surface-to-core plan where applicable.

**May run in parallel with:** Initial stdlib interface drafting, but not with final stdlib admission.

**Must not do:** Run linearity on unelaborated sugar or let implicit completions bypass D239.

### Phase 6: Linearity, Borrows, Capabilities, Contracts, And Unsafe Checks

**Purpose:** Enforce the safety properties that make Kyokai distinct.

**Dependencies:** Phase 5 typed elaboration.

**Status:** Not started. The safety-checker part of Gate C is open.

**Subparts:**

6.1. Port and adapt Austral's linearity checker only after reading its actual source and tests.

6.2. Implement linear states for available, moved/consumed, borrowed, deferred, and errdeferred values.

6.3. Implement explicit consumption rules, no implicit drop, no duplicate use, linear field movement, linear destructuring, and all exit-path consumption checks.

6.4. Implement immutable and mutable borrow creation, anonymous-by-default regions, explicit region syntax where needed, borrow end, and conflict checking.

6.5. Implement auto-reborrow and field auto-deref only as elaborated nodes that the checker can see.

6.6. Implement D240 conformance tests for auto-reborrow/read-reborrow success, failure, nested calls, field paths, temporary lifetimes, and linear payloads.

6.7. Implement `defer` and `errdefer` ordering, checker states, cleanup insertion, and interaction with `or return` / structured error exits.

6.8. Implement capability declarations as sealed authority values that unsafe code cannot forge.

6.9. Implement task-transfer and task-local classifications for types, capabilities, and runtime handles.

6.10. Implement unsafe-module checking: `pragma Unsafe_Module`, `UnsafeCapability`, raw operations, volatile, asm, FFI, and required `unsafe contract ... audit;` coverage.

6.11. Implement contract checks for `require`, `ensure`, asserts, bounds checks, overflow checks, and TPOE categories.

**Done when:**

- Safe code cannot leak, duplicate, forge, or use-after-consume linear resources.
- Borrow conflicts are caught before code generation.
- Deferred cleanup has exact ownership states and order.
- Unsafe operations without audit coverage fail compilation.
- Capability authority cannot be constructed from raw bits by safe or unsafe user code.

**May run in parallel with:** Backend design for already-checked operations.

**Must not do:** Treat unsafe as a blanket escape hatch from capability, ownership, or audit rules.

### Phase 7: Runtime Semantics And Generated-C Safety

**Purpose:** Make generated code preserve Kyokai semantics without relying on C undefined behavior.

**Dependencies:** Phase 5 for typed IR and Phase 6 for checked ownership/capability state.

**Status:** Not started. Gate D is open.

**Subparts:**

7.1. Define generated-C lowering contracts for every core operation in the extracted spec.

7.2. Implement D84 termination categories: normal return, recoverable `Result` values, TPOE, `panic`, runtime-fatal/internal failure, and OS process exit.

7.3. Implement TPOE and panic paths as hard process termination, not recoverable exceptions.

7.4. Implement stack overflow detection for hosted and freestanding targets using guard pages, probes, bounds checks, or an equivalent documented mechanism before corruption.

7.5. Implement integer operations with defined overflow, checked, wrapping, saturating, modular, shift, rotate, divide-by-zero, and representability behavior.

7.6. Implement floating semantics, NaN handling, classification, conversion, and math edge cases according to admitted contracts.

7.7. Implement record, union, enum/tag, packed-record, extern-record, and address lowering without layout folklore.

7.8. Implement memory operations, allocator calls, pointer/address operations, volatile operations, atomics, fences, and barriers with target contracts.

7.9. Implement C backend emission patterns that avoid signed overflow UB, invalid shift UB, invalid aliasing assumptions, invalid enum values, uninitialized reads, invalid pointer provenance assumptions, and fallthrough into unreachable states.

7.10. Add conformance tests that inspect generated C for known-dangerous patterns and execute edge cases under sanitizers across admitted compiler families.

7.11. Implement D531's C11 subset checker and generated-source schema.

7.12. Implement D532 compiler admission records and probes for GCC/Clang Linux, Apple Clang macOS, clang-cl Windows, and Clang FreeBSD before those lanes claim support.

7.13. Implement D533 source maps, debugger path substitution, symbolization, sanitizer mapping, Kyokai-level coverage IDs, and profiler mapping.

7.14. Implement D534 deterministic split C units, object caching, prebuilt stdlib/Bridge objects, parallel compilation, incremental linking, and benchmark reporting.

7.15. Implement D535 reproducible external-tool build plans, raw-log retention, and family-specific diagnostic normalization.

**Done when:**

- Gate D is closed for the generated-C backend and every Tier 1 C-toolchain lane.
- Generated C is boring, explicit, and auditable.
- Safe Kyokai operations never depend on C UB for optimization or convenience.
- Runtime-fatal and TPOE paths are visible in generated code and tests.

**May run in parallel with:** Tooling and stdlib work that only depends on stable ABI/runtime hooks.

**Must not do:** Use `__builtin_unreachable`, signed-overflow assumptions, unchecked C shifts, or layout punning as semantic shortcuts for safe Kyokai.

### Phase 8: Toolchain Skeleton, Diagnostics, Formatter, And Test Harness

**Purpose:** Build the operator and contributor tools needed to keep implementation honest.

**Dependencies:** Phases 3 and 4 for package loading; Phase 5 for typed checks; parts can begin earlier as CLI shells.

**Status:** Not started. The conformance-infrastructure gate and Gate F remain open.

**Subparts:**

8.1. Implement `kyokai check` as the first reliable command.

8.2. Implement `kyokai --version` and `kyokai doctor` so users can report the exact toolchain identity, host facts, configured paths, target compiler availability, cache paths, package index state, and actionable environment failures without guessing.

8.3. Implement `kyokai init` and `kyokai new` with deterministic templates, explicit package layout, selected profile/edition/target defaults, and no hidden network access.

8.4. Implement `kyokai build`, `run`, and profile/target selection after package loading and backend invocation are stable.

8.5. Implement `kyokai test` with inline test blocks, production-build exclusion, test filtering, failure reporting, deterministic listing, failed-test rerun, property/fuzz seed selection, replay tokens, corpus directories, and minimization controls. Test-only behavior must never become hidden language behavior.

8.6. Implement `kyokai fmt` as deterministic, idempotent, and zero-configuration.

8.7. Implement diagnostics with stable diagnostic codes, source spans, notes, suggestions, warning categories, per-project suppression, JSON output, a local `kyokai explain` catalog, and `kyokai fix` only for suggestions that the compiler can prove are machine-applicable. Human rendering uses the D503 semantic Kyokai palette with explicit true-color, limited-color, monochrome, `NO_COLOR`, and machine-output tests; color never replaces severity words, codes, symbols, or spans.

8.8. Implement `kyokai doc` from docstrings and interfaces, including generated stdlib documentation. Local docs generation writes package-root `kdocs/` by default, emits versioned docs JSON and HTML, validates the closed docs tag set, runs doc-test classification only for execution-admitted examples, and supports `kyokai doc --check`, `kyokai doc --open`, and `kyokai clean docs` without hidden network access.

8.9. Implement `kyokai audit` for unsafe modules, package unsafe surfaces, capability requirements, and dependency review.

8.10. Implement lints inside the compiler, including ownership-signaling naming warnings.

8.11. Implement conformance-test runner layout: parser tests, type tests, negative tests, backend execution tests, diagnostic goldens, property/fuzz replay tests, and stdlib contract tests.

8.12. Sync public examples and compiler fixtures against the decided spec and exclude obsolete comparison material from conformance claims.

8.13. Implement the Analysis Server as a shared compiler-engine service, with `kyokai lsp` as the protocol frontend rather than a second analyzer. The server must share parser, resolver, type checker, borrow checker, capability checker, target-guard evaluator, `.koi` reader, formatter, diagnostic catalog, and fix metadata with `kyokai check`.

8.14. Add Analysis Server protocol and DX tests for source snapshots, cancellation, edit ordering, manifest/workspace discovery, CLI-compatible diagnostics, semantic tokens, completion, hover, rename safety, code actions, formatter integration, generated-source boundaries, package graph facts, docs facts, `.koi`/KBI facts, and lowering/debug views. The fixture matrix includes single-file `.kyo` module editing with derived-interface navigation, public-signature preview against the derived `.koi`, stale-`.koi` diagnostics, terminator-preserving folding/selection/matching/repair, accepted import-form insertion, callback capture/class hover, capture-primary diagnostics, and blocking/try/deadline/poller completion grouping.

8.15. Implement `kyokai explain` and `kyokai fix` as compiler-fact tools, not prose wrappers. `explain` reads the shipped diagnostic catalog and compiler facts. `fix` applies only checked safety classes, rejects stale or overlapping edits, reruns parsing/formatting validation, and shares fix IDs with diagnostics, JSON output, and the Analysis Server.

8.16. Implement `kyokai audit` over package, source, dependency, unsafe, FFI, capability, generation, reproducibility, documentation, and public-API facts. Audit policy can promote named categories to errors, but audit never grants authority or changes language legality.

8.17. Implement `kyokai bleedring` and the `kyokaibleed` bootstrap handoff as first-party toolchain-management surfaces. This includes exact-version installs, directory/workspace/user pin precedence, checksum and provenance verification, install-root separation from package caches and project outputs, offline behavior, version ABI reporting, and `doctor` integration.

8.18. Implement local REPL, eval, scratch, and development-service command boundaries only through ordinary compiler semantics and explicit sandbox/profile records. These tools start with no ambient capabilities and do not create a second scripting language.

8.19. Implement ProofTrace tooling integration for spec chapters, maintained code-boundary markers, conformance records, generated public status, Analysis Server navigation, docs presentation, and audit reporting. Passing ProofTrace metadata checks remains evidence about registry consistency only.

8.20. Add command-matrix tests for network policy, prompt legality, stream routing, exit classifications, human-output lanes, JSON/JSON-lines schemas, cache/output roots, `KYOKAI_CACHE=off`, `--offline`, and `--color=machine`.

8.21. Implement capability deny-policy loading, normalization, diagnostics, and command enforcement for the first CLI lanes. This includes toolchain defaults, `$XDG_CONFIG_HOME/kyokai/config.toml` or `~/.config/kyokai/config.toml`, manifest ceilings, repeated `--deny-capability <name>` flags, strictest-policy composition, unknown-name rejection, verbose/machine-output reporting, and diagnostics that name the denied capability, policy source, requiring surface, and dependency or generation path.

8.22. Implement the D541 generated-API projection request/result protocol, atomic generated-tree replacement, stable generated-symbol identities, source/projection maps, drift checking, and Analysis Server/docs/audit consumption without creating compiler plugins or macros.

8.23. Implement D544 edition migration plan, apply, and recovery commands with edit safety classes, preimage verification, `.koi`/lockfile/configuration reporting, generated-input regeneration, transaction journals, and mixed-edition validation.

8.24. Implement D545 authority requirement graphs and narrow repair actions across CLI, diagnostics, Analysis Server, CI, and audit. Machine-applicable repairs preserve the effective deny ceiling and never create authority or widen policy.

8.25. Add D546 deterministic service-simulation lanes and evidence labels that distinguish simulated, headless real-system, target-matrix, device, and production-equivalence claims.

**Done when:**

- Contributors can run one command to check language conformance tests.
- Diagnostics are stable enough for golden tests, local explanation lookup, and checked machine fixes.
- Formatter output is canonical.
- `kyokai --version`, `doctor`, `init`, `new`, and test replay controls expose deterministic state instead of relying on tribal knowledge.
- Docs, LSP, audit, explain, fix, and ProofTrace output are generated from compiler-understood facts, not hand-maintained guesses.
- Capability deny policy is enforced by command tests rather than documented only as a planned policy.
- `bleedring` can report and manage installed toolchains without modifying project lockfiles or package caches as a side effect.
- Analysis Server behavior is test-backed against the same semantic engine as the CLI.
- Official editor tooling preserves written terminators and passes module/derived-interface, import, callback-capture, and operation-family DX fixtures without defining alternate syntax.
- Human CLI and diagnostic rendering passes semantic-palette, limited-color, monochrome, `NO_COLOR`, and machine-output fixtures.

**May run in parallel with:** Standard library implementation once core compiler checks are usable.

**Must not do:** Let tooling hide compiler errors or provide behavior the compiler cannot enforce.

### Phase 9: Core Standard Library Foundation

**Purpose:** Admit the safe pure and low-level foundation modules required by real programs.

**Dependencies:** Phase 5 for typing, Phase 6 for linearity, Phase 7 for runtime/backends, Phase 8 for tests.

**Status:** Not started. D229 stdlib admission is open.

**Subparts:**

9.1. Establish the stdlib module layout under `Kyokai.*` and retire inherited `Standard.*` naming from public Kyokai APIs.

9.2. Implement `Unit`, `Bool`, fixed integers, floats, `Index`, `Optional`, `Result`, `Never`, `Pair`, `Triple`, and domain-named result types where needed.

9.3. Implement `Span`, `Array`, `Buffer`, `String`, `StaticString`, byte strings, UTF-8 validation, ASCII helpers, Unicode base helpers, and string/span comparison.

9.4. Implement `Equality`, `Order`, `Hashable`, `Displayable`, `FormatSink`, `StandardError`, `Parsable`, and related typeclass instances.

9.5. Implement allocator interfaces and core allocators with explicit value-level allocator choice and no hidden default allocator.

9.6. Implement formatting: allocating `format`, sink-based `writeFmt`, interpolation rules, checked formatter DSL, and exact allocation/failure behavior.

9.7. Implement integer math, bitwise helpers, endian transforms, byte encode/decode, sorting, hashing, and pure algorithms without FFI unless admission policy says otherwise.

9.8. Implement floating math under D232 accuracy contracts, with test vectors and explicit edge-case behavior.

9.9. Implement collections: linear-safe `HashMap`, sets, queues/deques where admitted, iterator support, and explicit destroy/drain behavior for linear payloads.

9.10. Implement eager iterator helpers, fused iteration contracts, and linear iterator finalization under D249.

9.11. Apply D229 admission records to every module: contract, edge cases, oracle/test source, unsafe/FFI policy, compatibility boundary, and release status.

9.12. Implement the D540 owner/handle/view foundation for admitted slot maps and framework graphs: nominal owners and handles, generation exhaustion, slot retirement, mutation epochs, invalidation failures, linear payload removal, task-transfer rules, persistent-identity separation, property tests, docs, and debugger facts.

9.13. Implement D549 dataset-provider foundations for Unicode and other pure behavioral tables with version, digest, provenance, compatibility, cache, offline, and explicit update identities.

9.14. Admit the pure foundations required by D551-D553 application domains: streaming codecs, URI/header/protocol value types, command schemas, terminal layout/text-width primitives, retained-state contracts, geometry/color/image foundations, and deterministic simulation/snapshot hooks. Frameworks remain separately admitted packages or Bridge entries.

**Done when:**

- Real text, buffer, collection, error, formatting, and math code can be written without local shims.
- Pure computation modules are safe native Kyokai unless explicitly admitted otherwise.
- Every admitted API has tests for edge cases and linear cleanup behavior.
- Small POSIX CLI buffer and string logic no longer needs custom runtime modules for pure operations.

**May run in parallel with:** OS stdlib wrappers after allocator/buffer/string contracts stabilize.

**Must not do:** Wrap libc/libm by default for pure computation just because it is faster to bootstrap.

### Phase 10: OS, FFI Boundary, Capabilities, And Runtime Standard Library

**Purpose:** Provide safe systems APIs at the OS/hardware boundary without smuggling authority or ownership through FFI.

**Dependencies:** Phases 6, 7, 8, and core Phase 9 allocator/string/buffer types.

**Status:** Not started. Gate E is open.

**Subparts:**

10.1. Implement `RootCapability`, terminal, filesystem, process, environment, clock, random, network, signal, and platform capabilities.

10.2. Implement paths, OS strings, C strings, byte spans, file descriptors/handles, sockets, process IDs, exit statuses, and platform error types.

10.3. Implement safe file I/O: open/read/write/close/stat/readlink/access/directory operations with linear handles and explicit partial-read/write behavior.

10.4. Implement process spawning, pipes, dup/redirect operations, wait/status observation, supervised worker process patterns, and no in-process panic/TPOE catching.

10.5. Implement networking: TCP/UDP sockets, address parsing, DNS policy if admitted, listener/connection lifecycle, and explicit blocking/non-blocking operations.

10.6. Implement `Poller` and readiness-backed APIs. Blocking cancellation is cooperative only through Poller-backed or explicitly readiness-backed operations.

10.7. Implement `SignalWatcher` as the safe signal surface. Raw handler registration remains unsafe-only. Synchronous fault signals are runtime-fatal.

10.8. Implement volatile/MMIO APIs for the closed legal type domain under unsafe operation-level contracts.

10.9. Implement FFI wrappers for OS boundaries with explicit ABI records, ownership-transfer wrappers, sum-type translations, and unsafe audit contracts.

10.10. Track transitional FFI wrappers under D230 with replacement criteria and do not let them become unreviewed permanent stdlib internals.

10.11. Implement D549 target-observed and network-updated provider adapters for tzdb, locale, trust roots, revocation, public suffix, MIME, and related behavioral datasets with explicit capabilities, signature/provenance verification, freshness, expiry, offline behavior, and fail-closed activation.

10.12. Implement D551 server foundations: HTTP/TLS/protocol contracts, streaming and backpressure, cancellation, structured shutdown, database pool and migration primitives, observability context propagation, and deterministic service fixtures without hidden ambient runtime authority.

10.13. Implement D552 CLI/TUI foundations: command-schema projection, help/completion/man-page output, terminal capability detection, raw-mode restoration, signal-safe teardown boundaries, event decoding, grapheme/display-width behavior, accessibility metadata where representable, and deterministic frame/event replay.

**Done when:**

- Gate E can be closed for file/process/terminal/buffer workloads.
- OS authority is visible through capabilities.
- FFI ownership and ABI boundaries are wrapper-modeled and audited.
- Blocking behavior is visible in API names or explicit operation contracts.

**May run in parallel with:** Concurrency primitives after `Poller`, atomics, and capability transfer rules are implemented.

**Must not do:** Add ambient globals for OS authority, hidden runtime reactors, or raw FFI shortcuts in safe APIs.

### Phase 11: Concurrency, Atomics, Channels, And Synchronization

**Purpose:** Implement Kyokai's explicit structured concurrency model.

**Dependencies:** Phase 6 task-transfer/capability checks, Phase 7 memory/runtime semantics, Phase 10 `Poller` and OS threading hooks where needed.

**Status:** Not started. The memory-model/runtime gate is open.

**Subparts:**

11.1. Implement 1:1 OS-thread task creation with explicit spawn failure handling or pre-reserved task capacity.

11.2. Implement `taskgroup do ... join;` as the only safe structured spawn boundary.

11.3. Implement spawn capture lists: by-value copy for `Free`, by-value transfer for eligible `Linear`, immutable borrow for allowed shared forms, and no `&!` capture.

11.4. Implement task-boundary classifications: `task_transfer`, `task_local`, and standard-library handle/capability contracts.

11.5. Implement memory orders, atomics, fences, and the closed happens-before inventory from D247.

11.6. Implement `Mutex[T]`, `RwLock[T]`, poisoning policy if any, lock lifecycle, lock guards, and linear payload interaction.

11.7. Implement SPSC channels with explicit capacity constructors, close/drain behavior, blocking and non-blocking operation names, and failure types that return linear values on failed send.

11.8. Implement `select ... when ... do ... pick;` for multi-channel waiting with explicit non-priority selection semantics.

11.9. Implement broker-pattern library helpers over SPSC channels without adding MPSC/MPMC/broadcast endpoint primitives.

11.10. Implement cancellation tokens and cooperative cancellation for Poller-backed operations.

11.11. Add stress tests for ownership transfer, task-local rejection, channel closure/drain, select fairness/non-priority semantics, atomics, locks, and process-fatal panic/TPOE behavior.

11.12. Implement D540/D546 shared-owner service and simulation patterns over structured concurrency without cloneable framework owners, hidden callback runtimes, or weakened cancellation/join obligations.

11.13. Implement D551-D553 background-work and UI/message boundaries with explicit owner transfer, main-thread or executor affinity, backpressure, cancellation, reentrancy, and teardown contracts.

**Done when:**

- Safe Kyokai supports structured parallel programs without shared mutable data races.
- Every task lifetime and blocking join point is visible in source.
- Channels remain SPSC primitives; fan-in/fan-out are explicit broker tasks.
- Memory-order behavior is backend-independent and tested.

**May run in parallel with:** Networking/event-loop examples after `Poller` is stable.

**Must not do:** Add hidden green threads, cloneable channel endpoints, implicit join on `od`, or Rust-style `Send`/`Sync` auto traits.

### Phase 12: Package Manager, Index, Build Artifacts, And Ecosystem Tooling

**Purpose:** Make Kyokai packages reproducible, auditable, and usable outside the repository.

**Dependencies:** Phase 4 package/workspace basics, Phase 8 tooling, Phase 9 stdlib basics.

**Status:** Not started. The ecosystem gate and Gate F remain open.

**Subparts:**

12.1. Implement `kyokai add`, `remove`, `update`, `search`, `info`, `tree`, `why`, `outdated`, `vendor`, and `publish`, plus package cache behavior, D528 lockfile modes, workspace dependency references, pinned Git revisions, indexed package version requirements, and offline metadata reporting.

12.2. Implement official read-only package index support, package discovery, metadata fetching, package detail display, index snapshot identity, dependency metadata for indexed package versions, and append-only yanks that affect new resolution but preserve existing lockfiles.

12.3. Implement the final package resolver as a PubGrub-family incompatibility-learning solver or SAT-equivalent engine that preserves Kyokai's public solution and conflict-explanation contract. Resolver inputs include manifests, selected roots, lockfile mode, target/profile, selected feature roots, index snapshots, offline/network policy, yanks, advisories, authority ceilings, effective capability deny policy, and explicit graph-affecting command flags.

12.4. Implement deterministic `kyokai.lock` read/write over `[lock]`, `[[root]]`, `[[package]]`, and `[[edge]]` record families. Lock repair validates and normalizes formatting without changing graph meaning; graph-changing commands regenerate the graph through the resolver.

12.5. Implement package graph inspection so users can see why a dependency is present, which version or exact revision selected, which feature, target/profile, yank, advisory, or capability-deny inputs affected it, and whether the answer came from the lockfile, local cache, vendor directory, or remote index.

12.6. Implement package audit surfaces for unsafe modules, capabilities, FFI, build-time code generation, dependency authority, vendored source, and package-index provenance.

12.6a. Implement Bridge collection metadata consumption without adding Bridge code yet: package search cross-links, docs/audit display, admission-record schema checks, license/provenance inventory validation, capability-deny reporting, and module-resolution diagnostics for installed `Kyokai.Bridge.*` entries. Actual Bridge entry source, copied support code, and ports remain blocked behind self-hosting work by D529 scheduling.

12.7. Implement SemVer checking for public API changes and stdlib compatibility policy under language editions.

12.8. Implement manifest-declared build-time code generation and `@embedFile` without hidden execution authority.

12.9. Implement release artifact generation, checksums, provenance, official CI setup action, OCI images, and portable installation contract.

12.10. Implement package docs publishing, search indexing, and generated API reference integration.

12.11. Implement Compiler Explorer integration and sandbox-runner contract. Hosted playground remains optional until the sandbox contract is real.

12.12. Implement repository-owned package documentation publication. Published packages commit `kdocs/` under each package root at the exact indexed Git revision; `kyokai publish --dry-run` validates the staged release record and `kdocs/`; `kyokai publish` generates a ready-to-submit package-index PR/MR payload instead of uploading docs into Kyokai storage.

12.13. Implement package-graph capability deny checks for dependency resolution, package-index metadata, docs-index metadata, generated packages, publish validation, and audit reports. Denied authority requirements must report the exact graph path or artifact source and must not be downgraded to warnings in CI policy lanes that select fatal denial.

12.14. Implement package-index documentation metadata as compact discovery records. The index stores package identity, version, repository URL, exact revision, package-root path, source digest, `kdocs/manifest.toml` digest, docs-schema version, raw-file adapter class, docs status, and deterministic search projection. It does not store full documentation trees.

12.15. Implement official package-doc rendering over verified structured data. The website or package-doc route retrieves files from the exact indexed revision through reviewed forge raw-file adapters or pinned Git fetches, verifies digests and schema compatibility, renders through the official renderer, and never injects publisher-controlled HTML, scripts, stylesheets, or active embeds into the Kyokai origin.

12.16. Implement docs status reporting and local docs cache behavior. Docs pages and tools report `verified`, `missing`, `stale`, `malformed`, `schema-incompatible`, `digest-mismatch`, `target-context-mismatch`, `untrusted-revision`, or `browser-render-unavailable`; `kyokai docs --pull <pkg>` and `kyokai docs --pull all` populate the local cache by explicit network-capable action only.

12.17. Implement the official website source and static deployment lane. The bootstrap site lives in the main monorepo under `website/`, builds deterministically, renders or links spec/decided/guide/toolchain/stdlib/example/package/security/roadmap surfaces by authority class, and records OSS reuse provenance, license obligations, copied-file inventory, and removal of foreign semantics.

12.18. Implement the public service board records as infrastructure work moves from `PLANNED` to `SCAFFOLDED`. Main website, normative docs, package index/search, generated package docs, playground/sandbox, advisories/security, releases/downloads, community surfaces, and showcase each name source input, deployment target, authority class, auth model, data retention, privacy/logging, cache policy, verification workflow, and operational blockers.

12.19. Implement `kyokai-showcase` as editorial discovery separate from package search, security/advisory state, provenance badges, docs-quality badges, official/community labels, and package trust. Showcase placement never changes `kyokai add`, `kyokai audit`, package-index resolution, or package docs warnings.

12.20. Implement community and support surfaces with explicit authority boundaries. GitHub Discussions is the bootstrap pre-proposal/support venue; no forum subdomain or custom forum is official until a recorded service exists. Community pages state purpose, moderation status, expected response scope, archival/searchability status, and non-normative authority.

12.21. Implement release and installation infrastructure, including setup action metadata, OCI images, checksums, provenance, attestation/SBOM status when available, release-note compatibility classes, CI install smoke tests, and `bleedring` distribution metadata. Release artifacts are operational distribution evidence, not compiler conformance by themselves.

12.22. Implement the D547 foreign-adapter envelope and admit individual metadata-query, foreign-build, and platform-package adapters only after version, authority, determinism, target, failure, raw-log, provenance, and conformance records exist.

12.23. Implement D548 packaging plans and plan/apply commands for deterministic unsigned payload construction, separately authorized signing/notarization/upload, output verification, multi-architecture/split/delta/rollback facts, symbols, source maps, SBOM, and provenance.

12.24. Implement D550 browser build/development integration: generated Web-IDL wrappers, asset/CSS/source-map provenance, explicit external asset graphs, CSP, workers/service workers, SSR/hydration/islands/HMR projection contracts, and simulated versus real-browser test lanes.

12.25. Implement D554 mobile SDK/shim/build/package/test records and D557 deployment plan/apply records, including narrow Nix projection from exact Kyokai build identities. Platform stores, cloud providers, and Nix remain admitted adapters rather than language semantics.

**Done when:**

- External packages can be pinned, fetched, inspected, vendored, audited, built, tested, documented, and reproduced.
- Package graph commands explain selected dependencies without requiring manual lockfile reading.
- Yanks, lockfiles, vendored source, offline mode, and SemVer checks obey the spec.
- Package-root `kdocs/`, package-index docs metadata, raw-file retrieval, official rendering, and local docs cache behavior obey the repository-owned docs model.
- Website, showcase, package docs, community, release, and service-board work has explicit authority status and deployment records before it is called official.
- Build-time code generation has explicit authority and dependency tracking.
- Bridge collection metadata, if displayed by package/docs/audit tooling, remains separated from package-index trust, ordinary vendoring, and resolver-selected dependencies.

**May run in parallel with:** C-toolchain admission, source-map tooling, and self-hosting preparation after core package artifacts are stable.

**Must not do:** Allow moving branches, unaudited build scripts, or package resolution that changes existing lockfiles behind the user's back.

### Phase 13: C Toolchain Matrix, Cross Compilation, Optimization, And Debuggability

**Purpose:** Mature the one generated-C backend across major targets, optimizing C toolchains, cross compilation, source-level debugging, profiling, and build-time budgets.

**Dependencies:** Phase 7 C backend safety, Phase 8 conformance harness, Phase 4 target/profile model.

**Status:** Not started. D530-D536 define the generated-C target shape; D554-D556 add mobile, embedded, GPU/ML/data target and provider pressure. Implementation depends on Phase 7 generated-C safety and Phase 8 conformance infrastructure.

**Subparts:**

13.1. Admit GCC and Clang on Linux, Apple Clang on macOS, clang-cl on Windows, and Clang on FreeBSD through complete D532 records.

13.2. Implement target triples, SDK/sysroot discovery, C ABI/layout probes, calling conventions, symbol visibility, object formats, linking modes, and profile integration.

13.3. Validate integer, float, pointer/address, record, union, packed, volatile, atomic, panic/TPOE, stack-check, and FFI lowering across every admitted compiler lane without C UB or unsupported assumptions.

13.4. Run the same semantic conformance IDs across all admitted C compiler/target combinations and preserve raw external-tool evidence.

13.5. Add cross-compilation support for tiered targets only after target contracts define sizes, alignment, atomics, stack behavior, libc/OS boundary expectations, and linker behavior.

13.6. Add C-emitter and external-tool optimization controls only when they preserve elaborated linear/capability semantics and do not erase required checks.

13.7. Add debugger-quality sidecar maps and DWARF, CodeView/PDB, and dSYM behavior matching D27/D533.

13.8. Add sanitizer normalization, Kyokai-source coverage, profiler symbolization, pretty-printer/NatVis support, and honest optimized-value handling.

13.9. Meet D534 no-op, incremental, fsel-class, Zig/Hyprland-class, and very-large build gates on published reference hardware.

13.10. Evaluate additional compiler/target lanes, including MinGW, MSVC `cl`, cross GCC/Clang, WASI, embedded, freestanding, CompCert evidence, and TCC, only through the ordinary admission process.

13.11. Add D554 Android and Apple mobile target lanes only after SDK/NDK/Xcode/Gradle adapters, generated managed-language shims, simulator/device matrices, symbols/source maps, signing, packaging, permission/lifecycle, and store-verification contracts pass admission.

13.12. Add D555 embedded board-support lanes only after board, linker-script, startup, interrupt, MMIO, allocator, executor, flashing, probing, emulator, hardware-in-loop, secure-boot, OTA, rollback, and fatal-hook records pass target admission.

13.13. Add D556 GPU/ML/data providers as separately admitted runtime/FFI/toolchain integrations with explicit device/context/queue/buffer ownership, synchronization, memory domains, kernels/shaders, tensor metadata, allocator, cancellation, error, target, and conformance contracts. This work does not add a GPU language, implicit dispatch, built-in autodiff, universal tensor type, or second backend.

**Done when:**

- Every admitted Tier 1 C toolchain agrees on source-language conformance outcomes.
- Generated C and compiler flags avoid UB and unsupported assumptions forbidden by Kyokai semantics.
- Cross-compilation failures are explicit target unsupportedness, not silent miscompilation.
- Source debugging, fatal symbolization, sanitizers, coverage, and profiling report Kyokai locations with raw evidence retained.
- Published build-time gates pass on the named reference systems.

**May run in parallel with:** Self-hosting compiler-component work once frontend artifacts are stable.

**Must not do:** Treat a C compiler as a semantic oracle, admit ambient `cc` by accident, or trade safety/source accuracy for benchmark numbers.

### Phase 14: Self-Hosting Transition

**Purpose:** Move compiler components into Kyokai once the language and stdlib are strong enough to support compiler implementation.

**Dependencies:** Gate F, package artifacts, core stdlib, parser/typechecker maturity, and stable bootstrap compiler.

**Status:** Not started. Gate F is open, so self-hosting is not unblocked.

**Subparts:**

14.1. Choose self-hosting slices with low semantic risk first: lexer, parser helpers, diagnostic rendering, source maps, formatter, manifest parsing, or test harness support.

14.2. Keep the OCaml/Austral-derived compiler as a reference bootstrap while Kyokai components grow.

14.3. Track transitional FFI or OCaml bridge code under D230 replacement policy.

14.4. Port pure computation compiler utilities to safe Kyokai before OS/backend boundary code.

14.5. Add cross-check tests where OCaml and Kyokai implementations process the same input and produce the same typed/elaborated result.

14.6. Move larger frontend passes only after the Kyokai implementation can express the required invariants cleanly.

14.7. Document the bootstrap chain: what compiler builds what source, which artifacts are trusted, and how reproducibility is checked.

14.8. Start official Bridge collection implementation only after self-hosting work is active enough to own the integration code deliberately. The first Bridge entries require D529 admission records, copied-file inventories, license/provenance records, unsafe contracts, capability facts, target gates, build/link smoke tests, docs/audit extraction, and update owners before the collection is treated as shipped surface.

14.9. Admit concrete framework and provider bridges for D550-D557 only after the shared D540-D549 contracts, target/toolchain lanes, and D529 Bridge admission evidence exist. The language and stdlib contracts remain framework-neutral; no framework becomes mandatory through Bridge admission.

**Done when:**

- A meaningful compiler slice is written in Kyokai and built by the Kyokai toolchain.
- The bootstrap path is reproducible and documented.
- Transitional bridges have owners and removal criteria.
- Official Bridge entries that exist have D529 admission records and are not ordinary vendored dependencies.

**May run in parallel with:** Mechanized proof preparation after the core calculus is stable.

**Must not do:** Rewrite difficult compiler passes in Kyokai before the language can express their invariants and tests.

### Phase 15: Mechanized Proof And Long-Term Governance

**Purpose:** Move from paper proof to machine-checked proof and keep the spec/compiler relationship healthy.

**Dependencies:** Phase 2 paper proof and Phase 14 self-hosting progress. The proof assistant choice should be made when the project is ready to sustain the proof.

**Status:** Lean 4 selected and narrow spot artifact building locally. Whole-core mechanization has not started. Gate G is open.

**Subparts:**

15.1. Use Lean 4 as the proof assistant. Pin the release through Elan and build artifacts with Lake. **Status: selected.**

15.2. Mechanize the sequential `lambda_K` syntax, static semantics, dynamic semantics, and soundness theorem.

15.3. Add proof builds to CI.

15.4. Extend the formal model in separate layers only after the core mechanization is stable: generics, modules, typeclasses, contracts, unsafe/FFI boundary models, concurrency, memory model, and backend simulation.

15.5. Establish spec-change governance: any semantic change updates the spec, conformance tests, implementation, and proof impact notes in the same tracked change.

15.6. Establish edition governance under the already-decided edition/release policy rather than inventing a second compatibility system.

15.7. Keep planning/rationale material separate once the specs own normative behavior.

**Done when:**

- Gate G is closed for the sequential core.
- Proof artifacts build in CI.
- New semantic changes have an explicit proof-impact and conformance-impact path.

**May run in parallel with:** Later backend and stdlib growth after the core proof is stable.

**Must not do:** Let the mechanized proof become stale ceremonial evidence disconnected from the compiler and spec.

## 8. Cross-Phase Ordering Rules

These rules are the short version of the dependency graph.

| Work | Must Happen Before | Reason |
| --- | --- | --- |
| D-point traceability | spec extraction closure | No behavior should vanish during extraction. |
| Language spec extraction | broad compiler rewrites | The compiler should not encode guessed semantics. |
| `lambda_K` paper proof | public conformance release | D143/D241 require it before `v1.0`. |
| Parser/source spans | diagnostics, formatter, tooling | Tooling needs stable syntax trees. |
| Name/package resolution | typeclass and UFCS behavior | Lookup rules control ambiguity and fallback. |
| D238 pipeline | linearity/borrow/capability checking | Checks must run on elaborated semantics. |
| D239 registry | accepted implicit completions | Implicit completions must be auditable. |
| D240 matrix | auto-reborrow confidence | Ergonomics cannot weaken borrow soundness. |
| Linearity and borrow checks | backend codegen | Codegen must not receive illegal programs. |
| Generated-C/toolchain contract | external optimization and target admission | Optimization cannot define semantics. |
| Allocator model | containers and strings | Storage ownership must be explicit first. |
| Buffer/string/span | POSIX/network/std formatting | OS APIs and formatting need byte/text foundations. |
| Capabilities | OS stdlib | Authority cannot be retrofitted safely. |
| Atomics/memory model | channels/locks/tasks | Concurrency primitives need HB and ordering rules. |
| `Poller` | cancellation and event loops | Cancellation is readiness-backed, not magic. |
| Package artifacts | package manager and self-hosting | Reuse and reproducibility require stable artifacts. |
| Generated-C conformance | C compiler and target admission | Every admitted external toolchain must match already-defined semantics. |
| Self-hosting | mechanized proof priority shift | D143 places mechanization after self-hosting. |
| Diagnostic catalog and fix-safety classes | `kyokai fix`, Analysis Server code actions, and migration assists | Automated edits need stable IDs, spans, post-application validation, and safety classes before they can modify user source. |
| Analysis Server shared engine | public LSP/editor bundles and DX conformance | Editor tools must reuse compiler facts instead of creating a second parser, checker, package loader, or formatter. |
| `kdocs/` schema and package-index docs metadata | official package-doc website rendering and docs search | The website can render package docs only after package-root docs, digests, raw-file adapter class, and docs status are explicit. |
| Sandbox-runner contract | Compiler Explorer execution, playground, eval services, and build generation execution | Hosted or local execution of untrusted code needs resource, authority, failure-category, and artifact rules before service rollout. |
| `bleedring` install/provenance contract | public setup action, release installs, and user-facing toolchain switching | Installed toolchains need exact-version identity, pin precedence, checksum/provenance validation, and root separation before release claims. |
| Service board record | official public service deployment | A website, package-doc route, package index, showcase, playground, forum, advisory feed, or release channel needs a role, authority class, owner, deployment target, privacy/logging, and verification record before official links claim it. |

## 9. Parallel Work Lanes

Some work can proceed concurrently if dependencies are respected.

### Lane A: Specification And Proof

- Extract normative spec sections.
- Write D-point traceability index.
- Expand `lambda_K` research into the paper proof.
- Keep calculus exclusions explicit.
- Maintain the Phase 1 extraction board, D502 matrices, D479-D487 modal audits, and calculus ownership classification as accepted shape lands.

This lane blocks public conformance claims.

### Lane B: Compiler Frontend

- Parser and lexer changes.
- Module/package resolution.
- Typed elaboration and core IR.
- Linearity/borrow/capability checks.

This lane blocks safe execution.

### Lane C: Backend And Runtime

- Runtime failure paths.
- C backend UB avoidance.
- Stack checks.
- Target contracts.
- C11 subset enforcement, compiler admission, source maps, external-tool diagnostics, and build-time gates.

This lane blocks executable trust.

### Lane D: Standard Library

- Core types and containers.
- Allocators.
- Formatting and diagnostics.
- Math/numerics.
- OS capabilities and safe wrappers.
- Concurrency primitives.

This lane blocks real programs.

### Lane E: Tooling And Ecosystem

- `--version/doctor/init/new/check/build/test/fmt/doc/audit/lsp/explain/fix`.
- Package manager and index.
- CI setup.
- Playground/compiler explorer.
- Documentation publishing.

This lane splits into three implementation boards once work begins:

- daily local DX: CLI, diagnostics, formatter, docs, audit, explain, fix, LSP, Analysis Server, ProofTrace views, replay, and `bleedring` local toolchain management;
- package ecosystem: package index, yanks, advisories, SemVer, vendoring, lockfiles, release metadata, setup actions, OCI images, and docs-search projections;
- public infrastructure: website, package-doc renderer, package-index static site, showcase, community surfaces, service board, sandbox/playground deployment, release/download pages, and security/advisory pages.

The public infrastructure board blocks external adoption. It does not block parser/type-checker implementation unless an implementation tries to claim deployed service, package, release, or conformance status.

This lane blocks external adoption.

## 10. Feature Admission Checklists

### 10.1 Language Feature Checklist

A language feature is not complete until:

- normative text exists
- syntax and grammar are written
- type rules are written
- runtime behavior is written
- error behavior is written
- interaction with linearity, borrows, capabilities, contracts, unsafe, and backend lowering is either defined or explicitly irrelevant
- parser tests exist
- type/checker tests exist
- negative tests exist
- diagnostic codes exist for common failure modes
- conformance examples exist

### 10.2 Standard Library API Checklist

A stdlib API is not admitted until:

- its authority/capability requirements are stated
- ownership transfer and cleanup are stated
- allocator behavior is stated
- blocking behavior is visible in the name or contract
- error type and failure behavior are stated
- TPOE/runtime-fatal cases are stated
- edge cases are listed
- implementation policy is stated: safe native Kyokai, unsafe internal, FFI wrapper, or transitional FFI
- oracle/test-vector source is listed where applicable
- compatibility boundary is stated

### 10.3 Backend Lowering Checklist

A backend lowering is not complete until:

- source Kyokai operation is named
- target representation is documented
- generated-C and external C-toolchain UB hazards are listed
- mitigation strategy is implemented
- debug/source-span behavior is defined
- sanitizer or edge-case tests exist where practical
- behavior agrees with the interpreter/core semantics if such a runner exists

### 10.4 Unsafe/FFI Checklist

An unsafe or FFI surface is not complete until:

- it is inside an unsafe module when required
- it has `UnsafeCapability` access when required
- every unsafe operation is covered by an `unsafe contract ... audit;` block
- ownership transfer is wrapper-modeled
- raw FFI does not take or return Kyokai `Linear` values by value
- sum types are translated through explicit ABI records/tags
- failure modes are represented as values or documented fatal behavior
- safe wrapper tests cover success, failure, cleanup, and invalid input rejection

## 11. Status Tracker

Current status is planning/spec extraction. No implementation phase is complete just because the plan decisions are closed.

Phase checklist:

- [x] Phase 0: Repository Baseline And Decision Audit is complete enough for the roadmap baseline.
- [x] Phase 1: Normative Kyokai Specification Extraction is complete through D557.
- [x] Phase 2: Sequential `lambda_K` Core Calculus And Paper Proof is complete for the narrow `lambda_K-seq` paper theorem.
- [ ] Phase 3: Compiler Fork Identity And Frontend Surface Bring-Up is partially done; frontend scaffolds now cover source roles, source bytes, lexical tokens, source-file skeleton parsing with declaration names, structured constant/type-alias/function/record/bitrecord/union/typeclass/instance/generator summaries, generic parameters and `where` obligations, ordered contract and declaration-guard spans, associated-type and method surfaces, unresolved generic names, unambiguous const-generic literals/arithmetic, local derived-interface visibility checks over represented declaration types, and stable spans, plus manifest-rooted package discovery, workspace-only graph construction, deterministic workspace lockfile parse/render/repair, and a supporting implementation-gated fixture runner. D528 specifies the full resolver and lockfile model, but inherited-loader integration, Git/index solving, graph-changing lockfile modes, full final AST construction, guard/contract/initializer/body expression parsing, generator body/yield and suspension semantics, foreign/unsafe declaration structure, complete const-generic/comptime expressions and argument-kind resolution, full type resolution/coherence, and conformance-backed status remain open.
- [ ] Phase 4: Name Resolution, Imports, Packages, And Interface Artifacts.
- [ ] Phase 5: Type System, Elaboration Pipeline, And Core IR.
- [ ] Phase 6: Linearity, Borrows, Capabilities, Contracts, And Unsafe Checks.
- [ ] Phase 7: Runtime Semantics And Generated-C Safety.
- [ ] Phase 8: Toolchain Skeleton, Diagnostics, Formatter, And Test Harness.
- [ ] Phase 9: Core Standard Library Foundation.
- [ ] Phase 10: OS, FFI Boundary, Capabilities, And Runtime Standard Library.
- [ ] Phase 11: Concurrency, Atomics, Channels, And Synchronization.
- [ ] Phase 12: Package Manager, Index, Build Artifacts, And Ecosystem Tooling.
- [ ] Phase 13: C Toolchain Matrix, Cross Compilation, Optimization, And Debuggability.
- [ ] Phase 14: Self-Hosting Transition.
- [ ] Phase 15: Mechanized Proof And Long-Term Governance is partially done; Lean 4 is selected and the narrow spot artifact builds, but whole-core mechanization has not started.

| Phase | Status | Gate State |
| --- | --- | --- |
| Phase 0: Repository Baseline And Decision Audit | Complete enough for implementation-roadmap baseline; future stale references are cleanup work, not a Phase 0 blocker | Prepares Gate A; closes no global gate by itself |
| Phase 1: Normative Kyokai Specification Extraction | `SPEC_EXTRACTED` through D557; workflow/service-only decisions are publicly routed; implementation, deployed services, application-integration implementation, capability deny-policy implementation, resolver implementation, lockfile implementation, Bridge implementation, generated-C/toolchain admission, and conformance are not claimed | Gate A closed through D557; Gate B is separately closed for `lambda_K-seq`; Gates C-G remain open |
| Phase 2: Sequential `lambda_K` Core Calculus And Paper Proof | Owner-slot environment-machine statics and dynamics, 40-lemma proof index, closed derivation packages, Theorem P/Q assembly, executable model spot checks, whole-machine traces, and narrow Lean spot artifact exist | Gate B closed for `lambda_K-seq` paper proof |
| Phase 3: Compiler Fork Identity And Frontend Surface Bring-Up | Active scaffold: one `.kyo` source role, retired `.kai` rejection, one parser start symbol, per-declaration visibility, `opaque` parsing, local function/record/union interface validation, single-source package discovery, derived interface facts, executable target/entry selection, manifest/dependency/workspace loading, workspace-only resolver graph construction, deterministic workspace lockfile parse/render/repair, host tests, and compiler-stage fixtures exist; Git/index solving, graph-changing lockfile modes, inherited-loader replacement, cross-module/full-declaration semantic export checking, `.koi` serialization, final AST construction, expression-body parsing, full type parsing and conformance remain open | Parser/source gate open |
| Phase 4: Name Resolution, Imports, Packages, And Interface Artifacts | Not started | Package/spec gate open |
| Phase 5: Type System, Elaboration Pipeline, And Core IR | Not started | Gate C open |
| Phase 6: Linearity, Borrows, Capabilities, Contracts, And Unsafe Checks | Not started | Gate C safety-checker work open |
| Phase 7: Runtime Semantics And Generated-C Safety | Not started | Gate D open |
| Phase 8: Toolchain Skeleton, Diagnostics, Formatter, And Test Harness | Not started | Conformance infrastructure and Gate F open |
| Phase 9: Core Standard Library Foundation | Not started | D229 admission open |
| Phase 10: OS, FFI Boundary, Capabilities, And Runtime Standard Library | Not started | Gate E open |
| Phase 11: Concurrency, Atomics, Channels, And Synchronization | Not started | Memory-model/runtime gate open |
| Phase 12: Package Manager, Index, Build Artifacts, And Ecosystem Tooling | Not started | Ecosystem gate and Gate F open |
| Phase 13: C Toolchain Matrix, Cross Compilation, Optimization, And Debuggability | Not started | D530-D536 extracted; blocked on generated-C implementation, conformance harness, platform admission, source-map tooling, and benchmark infrastructure |
| Phase 14: Self-Hosting Transition | Not started | Gate F open |
| Phase 15: Mechanized Proof And Long-Term Governance | Lean 4 selected; pinned Elan/Lake owner-slot spot artifact builds; whole-core mechanization has not started | Gate G open |

## 12. Near-Term Work Queue

The next concrete work should happen in this order.

- [x] Review `kyokaidecided.md` as an accepted-shape ledger through D557: exact accepted decisions and supersession history are preserved, conversational/public-address prose is removed, and detailed normative contracts live in their specification chapters.
- [x] Use the Gate-B paper proof as the compiler-facing sequential-core reference while keeping whole-core Lean mechanization, compiler conformance, and later feature proofs on their separate gates.
- [x] Inventory the compiler passes in `lib/` against the D238 pipeline in `docs/compiler-pipeline-inventory.md`; keep it updated as frontend handoff boundaries move.
- [x] Create the first conformance directory shape for lexer, parser, modules, type, linearity, backend, diagnostics, package behavior, and related lanes. The Dune-built compiler-stage runner executes current implementation-gated parser, module, and package scaffolds and compares machine-readable expected-result fields as supporting evidence only; stdlib-specific fixtures, property/fuzz replay, public command execution, full diagnostic-code matching, and conformance-backed reporting remain later work.
- [x] Start compiler frontend changes against the extracted S1-S4 sections with isolated source-role, source-byte, lexical-token, source-file parser, package-source loading, and host-test scaffolds.
- [x] Migrate the active Phase 3 frontend scaffold to D537-D539: remove the `.kai` source role and parser start symbol, discover one `.kyo` file per logical module, derive interface facts for `.koi`, parse `public`/`internal`/private-by-default and `opaque`, reject retired `.kai` source, and rewrite the affected host tests, conformance fixtures, stage-runner facts, package-source target selection, and ProofTrace scope together.
- [ ] Prioritize `kyokai check`, `--version`, `doctor`, `init`, `new`, local `kyokai explain`, checked `kyokai fix`, and deterministic replay before broad package publishing.
- [ ] Prioritize allocator, buffer, string/span, result/optional, formatting, final resolver data structures, deterministic lockfile read/write, package graph inspection, vendoring, and lockfile reproducibility before large OS, concurrency, remote publishing workflows, or official Bridge collection code.
- [ ] Implement the one generated-C backend and D531-D536 compiler admission, source-map/DX, external-tool evidence, incremental units, and performance gates; do not create a second backend path.
- [ ] Build the Analysis Server shared-engine plan before shipping `kyokai lsp`, editor bundles, resource-flow refactors, or public-signature migrations.
- [ ] Implement the diagnostic catalog, fix-safety classes, and JSON/code-action identity before enabling `kyokai fix` or LSP source edits beyond preview.
- [ ] Implement `bleedring` toolchain-management contracts before public setup/install/release guidance depends on automatic toolchain switching.
- [ ] Create tracked infrastructure work for website source, organization migration, repository-owned package-doc indexing and rendering, optional package-doc mirrors, showcase, community surfaces, sandbox/playground, release/download pages, and hosted services without presenting planned deployments as shipped.
- [ ] Implement `kdocs/manifest.toml`, `kyokai doc --check`, `kyokai docs --pull`, package-index docs metadata, and raw-file adapter verification before package docs appear on official website routes.
- [ ] Keep package index, package docs, showcase, forum/community, playground, releases, and security/advisory surfaces separated by service-board authority class.
- [ ] Implement D540-D549 shared application-integration foundations before domain-specific frameworks: owner/handle/view state, generated-API projection, explicit heterogeneous boundaries, callback contract tooling, migration plans, authority explanation, deterministic simulation, foreign adapters, packaging plans, and behavioral dataset providers.
- [ ] Implement D550-D557 browser, server, CLI/TUI, GUI/media, mobile, embedded, GPU/ML/data, and deployment/Nix support only through the shared contracts and separate target/provider/framework admission records; do not add hidden runtime semantics or a second backend.
- [ ] Update `kyokaispec/src/appendices/b-decision-traceability.md` after every new accepted D-point or extraction PR/MR.

## 13. Changelog

### 0.2.38 - 2026-06-14

- Added structured generator-definition summaries for generic parameters, value parameters, yielded type, `where` obligations, and declaration guards.
- Enforced the D537 one-file rule by rejecting bodyless top-level generator declarations and expanded local interface validation over generator parameter and yielded types.
- Added focused parser/interface host tests and `parser.generator-summary`, bringing the implementation-gated supporting fixture count to twenty-four. Gate C remains open.

### 0.2.37 - 2026-06-14

- Added declaration-level `when` guard provenance for functions, type aliases, extern types, capabilities, and instances, including empty-guard rejection and stable spans.
- Added structured typeclass summaries for generic parameters, associated types, required methods, and default method bodies.
- Added structured instance summaries for heads, constraints, guards, associated-type definitions, and method definitions; expanded local interface validation over represented typeclass and instance surfaces.
- Added three compiler-stage fixtures, bringing the implementation-gated supporting fixture count to twenty-three. Gate C remains open.

### 0.2.36 - 2026-06-14

- Added structured function `where` obligations for typeclass bounds, associated-type bounds, and associated-type equality under the accepted D189 grammar.
- Added lexical `==`, projection-shaped equality validation, focused positive/negative host tests, and the implementation-gated `parser.where-clause-summary` compiler-stage fixture.
- Added an honest generic-argument split: nested types remain structured, bare names stay unresolved until declaration metadata is available, and unambiguous `Index` literals and parenthesized arithmetic have a dedicated const-expression AST. The `parser.const-generic-arguments` fixture covers the accepted subset.
- Added structured constant declared-type, transparent type-alias, and closed bitrecord summaries. Local interface validation now checks public/internal constant and alias type references, and parser fixtures cover all three declaration forms.
- Added ordered `require`/`ensure` contract summaries with stable expression spans and balanced delimiter checking. Contract expression typing and purity remain later semantic work.
- Kept Gate C open: semantic constraint resolution, duplicate/contradiction checks, projection normalization, final AST integration, and public conformance evidence remain unfinished.

### 0.2.35 - 2026-06-13

- Added the first semantic interface-validation pass over parsed module summaries. Public declarations reject local private and `internal` type leaks; `internal` declarations reject local private type leaks; opaque record/union representations remain sealed; private `opaque` declarations are rejected because they create no external representation boundary.
- Wired interface validation into package-source loading, added focused host tests, and added an implementation-gated compiler-stage fixture for a rejected private type leak.
- Registered the new frontend semantic boundary in ProofTrace. Complete cross-module resolution, type aliases, contracts, typeclasses, instances, final AST checking, `.koi` serialization, and conformance-backed status remain open.
- Expanded structured generic parameters across `Type`, `Free`, `Linear`, `Index`, and `Region`, plus structured type references with named-region borrow syntax and `FnPtr(...) : Ret`, including nested borrow and applied parameter/return types. Const-generic arguments, associated-type projections, and complete `where` constraints remain open.

### 0.2.34 - 2026-06-13

- Accepted and spec-extracted D540-D557 across the new application-integration stdlib and toolchain chapters, owning language/stdlib/toolchain cross-references, ProofTrace registration, and decision traceability.
- Routed shared owner/handle/view, generated projection, composition, callback, migration, authority, simulation, adapter, packaging, and dataset foundations into Phases 8-12 before browser, server, CLI/TUI, GUI/media, mobile, embedded, GPU/ML/data, deployment, Nix, and framework/provider admission work in Phases 12-14.
- Closed Gate A through D557 without claiming compiler, stdlib, command, adapter, target, provider, framework, deployment, or conformance implementation.
- Removed internal comparison-test material from the public roadmap surface and recorded the public-document voice and accepted-history preservation rules in project standards.
- Completed the accepted-ledger and public-boundary audit through D557, including explicit supersession preservation and removal of remaining maintainer-addressed normative prose.

### 0.2.33 - 2026-06-11

- Migrated the active Phase 3 source, parser, package-loader, target-selection, host-test, fixture-runner, and ProofTrace scaffolds to D537-D539.
- The scaffold now has one `.kyo` source role and one parser start symbol, rejects `.kai` as retired input, records `public`/`internal`/private-by-default visibility and `opaque`, derives the importable declaration surface for later `.koi` production, and checks executable entries in the selected source.
- Completed the migration audit across accepted shape, spec traceability, implementation inventory, direction/status prose, internal D-point numbering, historical supersession labels, and public-document boundaries. The complete Dune build and tests pass; all twelve implementation-gated compiler-stage fixtures pass; ProofTrace validates seventy-eight records.
- Kept semantic export/opacity validation, final AST construction, `.koi` serialization, inherited-loader replacement, and conformance-backed status open rather than overstating the scaffold.

### 0.2.32 - 2026-06-07

- Accepted and extracted D537-D539: one handwritten `.kyo` source file now owns each module, the compiler derives the checked `.koi` interface, visibility is per declaration with a private default, and `opaque` replaces representation hiding by interface/body file location.
- Marked the existing `.kai` classifier, parser start symbol, source pairing, executable-target body lookup, host tests, and implementation-gated fixtures as migration material rather than behavior to preserve.
- Added the concrete Phase 3 migration slice to the near-term queue so source discovery, parsing, target selection, derived-interface facts, diagnostics, tests, runner output, and ProofTrace move together.

### 0.2.31 - 2026-06-06

- Accepted and extracted D530-D536: Kyokai now maintains one generated-C backend and treats GCC, Clang, Apple Clang, clang-cl, and later admitted compiler families as external target toolchains rather than alternate backends. The planned direct LLVM backend is removed.
- Fixed the generated-source baseline at a defined C11 subset, with C17 compiler modes accepted for the same subset and C23 requiring a later evidence-backed D-point before it can replace the baseline.
- Added major-platform compiler admission, source-map/debug/symbolization/coverage/profiling, external-tool evidence, deterministic split-C/incremental compilation, measured build-time gates, and standard-profile closure to Gate D and Phase 13.
- Re-audited normative build identity, CLI, `.koi`, provenance, examples, FFI, and standalone-compiler text so external compiler choice is consistently an admitted C-toolchain contract rather than a selectable backend. Added `rationale/09-backend-choice.md` with the public tradeoff case against direct LLVM, Cranelift, QBE, custom-native, arbitrary ambient C, and tiered backend paths.
- Closed Gate A through D536 without claiming generated-C implementation, platform admission, debugger integration, conformance, or performance-budget completion.

### 0.2.30 - 2026-06-05

- Accepted and extracted D529: Kyokai now specifies the official Bridge collection under `Kyokai.Bridge.*` and `bridge/` for curated shipped third-party integrations. Bridge entries are first-party shipped integration surface, not ordinary `kyokai vendor` output, not package-index dependencies, and not a package cache.
- Added D529 spec coverage across stdlib overview/admission, manifest/package rules, module resolution, CLI vendoring separation, package-index separation, unsafe/FFI obligations, and decision traceability. Bridge entries require provenance, license, copied-file inventory, local-modification records, generator records, unsafe contracts, capability facts, target/native-link gates, tests, docs, owner, update policy, and audit status.
- Updated the roadmap to close Gate A through D529 without claiming Bridge implementation. Actual Bridge source/ports/copied support code are scheduled behind self-hosting; earlier package/docs/audit work may validate and display Bridge metadata only.

### 0.2.29 - 2026-06-05

- Extended the isolated surface parser with a structured function signature summary for top-level functions: generic parameter names, value parameters, borrow-type wrappers, named generic type applications, and return type facts are now preserved in the parser scaffold.
- Extended the isolated surface parser with a structured record summary for ordinary, extern, and packed record layout markers, generic parameter names, universe markers, one-line record sugar, and block field lists.
- Extended the isolated surface parser with a structured union summary for generic parameter names, universe markers, zero-payload variants, unnamed-payload variants, and named-field variants.
- Added `test/conformance/parser/function-signature-summary/fixture.toml`, `test/conformance/parser/record-summary/fixture.toml`, and `test/conformance/parser/union-summary/fixture.toml`, then wired them into the Dune-built compiler-stage conformance runner. The runner now executes eleven implementation-gated fixtures and compares stable expected facts, including function signature, record, and union facts, as supporting evidence only.
- Updated ProofTrace scope for `FRONTEND-KYOKAI-SURFACE-PARSER` and `TOOL-CONFORMANCE-FIXTURE-RUNNER` so the public evidence registry reflects the parser signature, record, and union slices while still excluding full AST construction, expression-body parsing, full type parsing and validation, semantic checking, and conformance-backed status.

### 0.2.28 - 2026-06-04

- Accepted and extracted D528: Kyokai now specifies the final resolver and lockfile contract instead of a temporary bootstrap dependency language. Dependencies are workspace references, pinned Git references, or indexed package version requirements; the resolver is PubGrub-family incompatibility learning or SAT-equivalent with the same public solution and conflict-explanation contract; `kyokai.lock` uses deterministic `[lock]`, `[[root]]`, `[[package]]`, and `[[edge]]` record families; implementation slices must use this final model and report unsupported lanes explicitly.
- Added `KyokaiPackageResolution` as the first D528 final-model resolver graph scaffold. It resolves explicitly loaded workspace package manifests into deterministic package instances and workspace dependency edges, rejects duplicate workspace package identities, rejects unknown workspace dependencies, rejects package cycles, and reports Git/index dependencies as unsupported resolver lanes instead of inventing temporary semantics.
- Added `KyokaiPackageLockfile` as the first D528 lockfile scaffold. It renders, parses, validates, and repairs deterministic workspace lockfile records using `[lock]`, `[[root]]`, `[[package]]`, and `[[edge]]`; repair normalizes order and formatting without changing graph meaning.
- Added an implementation-gated package fixture for workspace graph plus lockfile rendering/repair through `toolchain/conformance/stage_runner/KyokaiConformanceStage.ml`. The same Dune-built compiler-stage runner now executes all supported implementation-gated parser, module, and package fixtures directly from `make run-conformance-fixtures`. This remains supporting evidence only; it does not make package behavior conformance-backed or public-command-backed.
- Added machine-readable expected-result fields to supported implementation-gated conformance fixtures. The compiler-stage runner now compares expected outcome, stage, result code, and stable facts instead of treating fixture execution as a bare success/failure probe.
- Added `bin/kyokai.ml` as the first narrow Kyokai public-command scaffold. It supports `kyokai --version`, `kyokai check --conformance-fixture <id>`, and `kyokai check <package-or-workspace-root>` over the current source/package scaffold; semantic checking, full diagnostic-code matching, and active conformance status remain open.
- Accepted and extracted D527: Kyokai now has a deny-only capability deny policy. Toolchain defaults, user/global config, manifest ceilings, and `--deny-capability <name>` compose by strictest policy; denied package, target, generator, test, docs, audit, publish, or execution requirements fail with diagnostics without changing source-level capability semantics.
- Extended `lib/compiler/package/manifest/KyokaiPackageSource.ml` with the first workspace-manifest member expansion scaffold. It parses `[workspace].members` as an explicit TOML string-array subset, rejects mixed package/workspace manifests, rejects package manifests at the workspace-loader boundary, rejects escaping or duplicate workspace member paths, loads only listed package roots, and rejects duplicate package names across loaded members.
- Added host frontend tests for workspace manifest parsing, invalid member paths, duplicate member paths, explicit member loading, non-inference of unlisted packages, duplicate workspace package names, and missing member manifests. This is compiler-stage supporting evidence only; it does not claim package dependency resolution, lockfile ownership, public build/check command conformance, or workspace profile inheritance.
- Phase 3 package-source status now treats basic workspace member expansion as scaffolded. The loader also rejects module-root and workspace-member symlink escapes by canonical path containment. D528 makes the final resolver and lockfile schema specified, while inherited-loader wiring, dependency graph resolution, lockfile read/write, workspace profile inheritance, final AST construction, expression/type parsing, public command execution, and conformance-backed reporting remain open.
- Added the first `[dependencies]` manifest parser subset for D51/D528: workspace dependencies parse as `{ workspace = "name" }`; Git dependencies parse as `{ git = "url", rev = "commit" }` with optional `tag`; indexed dependencies parse as `{ index = "@scope/name", version = "^1.4" }`; `branch` is rejected because moving references are not stored in Kyokai manifests. This remains parsing/admission evidence only, not package graph resolution or lockfile evidence.

### 0.2.26 - 2026-06-03

- Re-audited `phase.md` against `kyokaidecided.md`, `kyokaispec/src/toolchain/03-cli.md`, `08-docs-lsp-audit.md`, `10-package-index-semver-releases-ci.md`, `11-build-generation-and-playground.md`, `kyokaiinfrastructuredirection.md`, and `kyokaiciandtestsuitedirection.md` for accepted/spec-extracted work that was present but too compressed in the roadmap.
- Expanded Phase 8 with explicit homes for package-root local docs generation, Analysis Server/LSP shared-engine work, protocol/DX fixtures, `explain`, checked `fix`, audit, `bleedring`/`kyokaibleed`, REPL/eval/scratch service boundaries, ProofTrace tool integration, and command-matrix tests.
- Expanded Phase 12 with explicit homes for repository-owned `kdocs/`, package-index docs metadata, verified official package-doc rendering, docs-status states, local docs cache pulls, website source/deployment, service-board records, `kyokai-showcase`, community/forum boundaries, releases/downloads, setup action, OCI images, and `bleedring` distribution metadata.
- Added cross-phase ordering rows for diagnostic/fix safety, Analysis Server shared engine, `kdocs` metadata, sandbox runner, `bleedring`, and service-board records so these surfaces do not disappear behind broad tooling or ecosystem wording.
- Split Lane E into local DX, package ecosystem, and public infrastructure boards while preserving the rule that infrastructure status never becomes language semantics or compiler conformance.

### 0.2.25 - 2026-06-03

- Continued Phase 3 after Gate B closure by adding `lib/compiler/package/manifest/KyokaiPackageSource.ml` as the package-manifest/source discovery and isolated source-set loading scaffold. It parses the required package manifest subset, rejects workspace manifests at this isolated boundary, validates package names, explicit module roots, and `[targets.<name>]` executable target tables, maps logical module names to `.kyo` / `.kai` source paths, discovers sources deterministically under `[layout].module_root`, rejects generated `.koi` and inherited `.aui` / `.aum` files under the module root, verifies parsed module declarations against manifest-rooted paths, and loads the parsed source skeleton set for one package.
- Started the physical language-tree migration for the Phase 3 Kyokai scaffolds and support tools: source roles and source text live under `lib/compiler/frontend/source/`, lexical tokens under `lib/compiler/frontend/lexer/`, surface parsing under `lib/compiler/frontend/parser/`, package-manifest/source discovery under `lib/compiler/package/manifest/`, host frontend tests under `test/host/frontend/`, conformance fixture tooling under `toolchain/conformance/`, and ProofTrace validation under `toolchain/prooftrace/`. Public path references, ProofTrace artifacts, and Dune include-subdir settings were updated with the move.
- Materialized the first public conformance lane directory shape under `test/conformance/`, added the fixture metadata schema, added initial implementation-gated parser/modules fixture packs including parser span preservation and executable-entry rejection, added `toolchain/conformance/check_fixtures.py` plus `make check-conformance-fixtures` for metadata validation, and added `make run-conformance-fixtures` for executing the current parser/module scaffolds through the Dune-built compiler-stage runner. The runner now checks machine-readable expected-result fields for supported implementation-gated fixtures. Implementation-gated runner passes are supporting evidence only until the public command or accepted compiler stage owns the same result contract and ProofTrace records become conformance-backed.
- Added host tests covering package manifest parsing, invalid package names, escaping module roots, expected source-path mapping, paired and body-only module discovery, generated/inherited source rejection, dotted filename rejection, and parsed module-name mismatch diagnostics.
- Added command-level executable-target selection over parsed `[targets.<name>]` manifest records. The loader now selects an explicit target, the only runnable target, or the single `default = true` target; rejects unknown, missing, interface-only, or ambiguous executable targets; and parses the selected target body with executable-entry shebang policy. Workspace expansion, inherited-loader wiring, final AST construction, expression/type parsing, public conformance fixtures, and CLI identity remain open Phase 3 work.
- Registered the package-source scaffold in ProofTrace as a prototype with the target-selection and executable-entry policy scope included.

### 0.2.24 - 2026-06-02

- Closed Gate B for the narrow `lambda_K-seq` paper proof: `theorem-assembly.md` now composes L1-L40, L38 unique decomposition, L39 ordinary preservation, L40 intrinsic defined-failure preservation, Theorem P, and Theorem Q from the maintained derivation packages. ProofTrace records the theorem as `paper-proven` while keeping the Lean artifact narrow and mechanically proven only for its twenty-five named spot theorems.
- Expanded the Gate-B close audit into `kyokaicalculus/close-and-witness-proof.md`, covering the L20, L21, L23, and close-specific L37 derivations without upgrading the theorem claim.
- Tightened static and runtime borrow-state well-formedness with writer-chain isolation: a retained mutable lease can coexist only with leases on its own suspension chain, so closing a local child cannot resume the parent beside an unrelated frontier reader or writer.
- Expanded executable model spot checks from forty-one to forty-five and the narrow Lean artifact from thirteen to seventeen named local theorems. That revision still required review, remaining L1-L40 cases, call-entry proof, admission derivations, whole-machine coverage, and broader Lean encoding.
- Expanded the call-entry derivation in `kyokaicalculus/call-entry-proof.md`: `pi` is materialized before argument effects, token referents must match the certificate, `phi` realization is deterministic, owned argument carriers transfer into exactly one fresh parameter slot, and ordinary return requires exact parameter discharge and caller-state restoration.
- Expanded executable model spot checks from forty-five to forty-nine and the narrow Lean artifact from seventeen to nineteen named local theorems. That revision still required package review, remaining L1-L40 cases, admission derivations, whole-machine coverage, and broader Lean encoding.
- Expanded the declaration-admission derivation in `kyokaicalculus/primitive-admission-proof.md`: named consumption, checked primitives, borrow access, and attenuation now have explicit declaration-time totality premises, invariant footprints, and progress/preservation case tables. That revision still required review and composition into the complete L1-L40 proof.
- Repaired the next Gate-B review blockers without upgrading the theorem claim: linear locals and owned call parameters now keep live pending obligations during body execution, ordinary pop readiness requires tombstones, and terminal TPOE snapshots control/frame carriers before erasing continuations.
- Added `kyokaicalculus/frame-typing-proof.md` and `kyokaicalculus/machine_runner.py`. The derivation package expands frame-local L9-L11/L26/L31/L38-L40 cases; the runner executes five complete regression traces for linear-let discharge, branch-slot preservation, arbitrary linear-sum movement, owned-call discharge, and nested TPOE carrier accounting. CI runs the spot model and executable machine slice through `make gate-b-model`.
- Tightened checked call evidence: `phi` has explicit certificate fields, `static_call_compatible` checks them, `alpha_freshen` has a capture-avoiding fresh-renaming contract, `realize_call` has exact-domain and alias rules, and `verify_call_paths` checks token referents against pre-argument `pi` certificates.
- Added `kyokaicalculus/source-expression-proof.md` so the source-control half of L1-L8/L12-L19/L24-L25/L32-L36 is explicit before final L38-L40 composition and renewed review.
- Added `kyokaicalculus/equivariance-proof.md` with sort-preserving runtime renaming and relation-local commuting cases for L36-L37, kept separate from source binder alpha-equivalence and one-step fresh-choice equivalence.
- Added `kyokaicalculus/theorem-assembly.md` with the L1-L40 route matrix, L38 non-overlap checks, L39 ordinary-preservation routing, L40 intrinsic-TPOE partition argument, and explicit Theorem P/Q review checklist. At that revision, the tier still remained `intended-by-spec` until renewed independent review accepted the assembly.
- Expanded `kyokaicalculus/machine_runner.py` from five to ten whole-machine regression traces. The new traces cover mutable-reborrow close and resumed parent access, read-reborrow close, checked-primitive success, checked TPOE beneath an outer owned-argument frame, and one-way capability attenuation followed by visible consumption. At that revision, Gate B still remained `intended-by-spec`; the executable slice supported review and did not replace the paper theorem.
- Expanded `kyokaicalculus/machine_runner.py` from ten to fifteen whole-machine regression traces. The new traces cover direct immutable-borrow access and close, selected linear-sum payload consumption, successful contract checking, zero-argument call entry, and zero-argument checked-primitive success. At that revision, the theorem tier remained unchanged.
- Expanded the narrow Lean owner-slot artifact from nineteen to twenty-two named spot theorems. The new identifiers check linear-local carrier transfer, selected-case payload carrier transfer, and explicit one-way capability-attenuation origin recording. This remains narrow `mechanically-proven` evidence only.
- Expanded `kyokaicalculus/machine_runner.py` from fifteen to nineteen whole-machine regression traces. The new traces cover explicit injection and linear-payload case discharge, free-payload case binding, unrestricted variable lookup, and zero-argument checked-primitive TPOE. The runner now exercises the remaining first-core structural frame families selected for this review pass.
- Expanded `kyokaicalculus/machine_runner.py` from nineteen to twenty-five whole-machine regression traces. The new traces cover false-arm selection, direct mutable-borrow read and write access, source-ordered successful multi-argument call entry, returned owned-call carriers, and returned-local-borrow rejection at region close.
- Expanded the narrow Lean owner-slot artifact from twenty-two to twenty-five named spot theorems. The new identifiers check returned mutable-borrow region-exit rejection, direct mutable-token usability before suspension, and zero-argument TPOE with no abandoned carrier.

### 0.2.23 - 2026-06-02

- Added the isolated `lib/compiler/frontend/lexer/KyokaiLexicalToken.ml` frontend scaffold without wiring it into inherited parsing or ownership-sensitive lowering. The scanner covers initial Kyokai comment, ASCII-identifier, keyword, punctuation, numeric-boundary, CRLF-span, and selected inherited-form rejection cases.
- Added focused host tests and registered the lexical-token boundary in ProofTrace as proof-relevant frontend semantics. The isolated scanner now tokenizes static-string, raw-string, code-point, and byte literal families with the closed escape grammar plus the accepted `@embedBytes` / `@embedText` comptime-builtin family. Parser integration, stable diagnostic codes, formatter integration, and exhaustive conformance fixtures remain open.
- Added the isolated `lib/compiler/frontend/source/KyokaiSourceText.ml` source-byte contract scaffold for strict UTF-8 validation, BOM rejection, LF/CRLF and bare-CR handling, Unicode-scalar diagnostic columns, and executable-entry shebang gating. The validated representation now feeds the isolated scanner, and the source-role scaffold selects shebang policy from `.kyo` / `.kai` role plus a caller-provided executable-entry fact. Executable-target discovery and loader wiring remain open.
- Synchronized the normative reserved-word table with accepted grammar-only words such as `bitrecord`, `drop`, `qed`, `wait`, `wake`, unsafe-contract fields, and range-loop words. Contextual `result`, `old`, and `ignore` remain identifiers outside their specified parser contexts.

### 0.2.22 - 2026-06-02

- Repaired the renewed Gate B review findings without upgrading the theorem claim: `lambda_K-seq` now has admitted-total consuming, checked, borrow-access, and attenuation primitives; explicit `read_access[op]` / `write_access[op]`; uniform runtime slot types; intrinsic configuration/frame typing; and intrinsic TPOE terminal-state rules.
- Replaced unscoped witness aliasing with scope-owned witness layers and explicit checked alias authorization, then added pre-argument call-path certificate `pi` so callee entry does not lose caller path evidence after argument moves.
- Added `kyokaicalculus/research.md`, recorded valid first-core deviations, corrected the accepted Lean 4 wording, expanded executable model spot checks from thirty-three to forty-one, and expanded the narrow Lean artifact from ten to thirteen named local theorems.
- Recorded the then-open proof obligations: renewed L1-L40 assembly review, layered-witness close/equivariance review, call-entry review over `pi`, admission review, whole-machine executable coverage, and broader Lean encoding.

### 0.2.21 - 2026-06-02

- Started the Gate-B-independent Phase 3 frontend lane with `docs/compiler-pipeline-inventory.md`, an isolated `.kyo` / `.kai` source-role classifier, and host tests for accepted interface/body paths plus inherited-extension, empty-path, and handwritten-`.koi` rejection. The scaffold deliberately does not define a public CLI encoding for source sets.
- Added `test/conformance/README.md` as the explicit future Kyokai conformance-lane scaffold without claiming that inherited Austral fixtures are Kyokai conformance evidence.
- Registered the new frontend source-role boundary in ProofTrace as a prototype and kept manifest discovery, loader wiring, parser support, CLI identity migration, and ownership-sensitive lowering explicitly open.

### 0.2.20 - 2026-06-01

- Accepted and extracted D526: Kyokai now maintains a public ProofTrace evidence graph with separate specification, implementation, conformance, and proof axes.
- Added chapter-level spec registrations, required code-boundary `kyokai:prooftrace` comments, closed no-proof reason categories, and honest inherited-bootstrap markers.
- Added `kyokaiproofstatus.toml`, generated `kyokaiproofstatus.md`, `toolchain/prooftrace/check_prooftrace.py`, `make proofstatus`, `make check-prooftrace`, and the CI validation lane.

### 0.2.19 - 2026-06-01

- Repaired the renewed-review spec conflict by replacing universal recursive destruction with `consume[op]`, a proof-facing abstraction of one resolved named consuming operation. Linear sums now require explicit destructuring unless an independently admitted named operation exists.
- Separated static region and lease atoms from runtime identities through explicit witness `I`, retained elaborated `call f[phi](args)` witnesses, and defined deterministic `bind_call_args` and call-witness realization obligations.
- Added `kyokaicalculus/deviation.md`, narrowed and fully recorded the Lean spot-artifact claim, removed stale TPOE child-propagation wording, and expanded executable spot checks from twenty-seven to thirty-three.
- Tightened call return with invocation-local `psi`, caller-visible `phi(U)`, and explicit `result_bridge`; allowed intentional static-witness aliasing without weakening fresh runtime minting; and expanded the narrow Lean artifact from eight to ten named spot theorems.

### 0.2.18 - 2026-06-01

- Selected Lean 4 as the Kyokai proof assistant, pinned `leanprover/lean4:v4.30.0` through Elan, and recorded Lake as the checked-artifact build command.
- Added the first narrow `mechanically-proven` Lean artifact for selected owner-slot repair facts: linear-sum owner carriage, branch frames without owner carriers, returned-token region-exit rejection, retained-writer behavior after read reborrow, and suspended mutable call-boundary rejection.
- Recorded that the first narrow Lean spot artifact did not discharge L1-L40, Theorem P, or Theorem Q; later entries record the paper-proof closure.

### 0.2.17 - 2026-06-01

- Retired the substitution runtime after its closure audit found: branch substitution duplicated owner syntax, arbitrary linear sums were not closed under movement, runtime borrow-token typing was disconnected from referent types, suspended mutable tokens could cross call boundaries, and ordinary progress conflated TPOE with ordinary machine typing.
- Replaced that runtime description with an environment-and-continuation machine using resource store `Sigma`, lease graph `B`, owner-slot store `Xi`, environments `eta`, and continuation stack `K`; expanded the proof inventory from L1-L32 to L1-L40.
- Added explicit source-literal rules, arbitrary-linear slot movement and named consumption, retained-writer close invariants, returned-token region-exit rejection, referent-derived token typing, exact call-return borrow-graph restoration, recursive region-binder freshening, zero-argument call entry, complete checked-primitive frame entry/advance rules, `Unit`-only sequencing, inert captured-environment mappings after source-ordered effects, separate `WT_TPOE` classification, and twenty-seven executable spot checks.

### 0.2.16 - 2026-06-01

- Added the initial `lambda_K-seq` paper-proof derivation draft, explicit statics and separated-store dynamics, a 32-lemma inventory, surface mapping, claim tiers, research references, and later-layer contract plans.
- Corrected the first-core reborrow transition to create child leases atomically while suspending the parent, made contextual TPOE propagation non-competing, kept suspended copied mutable tokens typed but unusable, and restricted first-core direct borrowing to linear-owner places.
- Strengthened well-typed closed configurations to require a live-owner bijection, required unborrowed capability attenuation with fresh weaker-resource identities, recorded a finite sort-preserving alpha-equivalence convention, and expanded the executable model to twenty-two spot checks.

### 0.2.15 - 2026-06-01

- Accepted and extracted D525: every published package commits generated `kdocs/` under its package root at the exact indexed Git revision.
- Replaced the required `kyokai-package-docs` repository with compact reviewed docs metadata and search projections inside `kyokai-package-index`.
- Added exact-revision retrieval, reviewed forge raw-file adapters, official structured rendering, active-content rejection, explicit docs-status states, and a cache-aside-only future mirror boundary.

### 0.2.14 - 2026-05-31

- Double-checked D396-D524 traceability and confirmed that every accepted heading has a public spec, workflow, service, or trace destination.
- Corrected the D410 appendix route so atomic file updates, temp resources, replacement, sync policy, no-follow behavior, TOCTOU exposure, advisory locks, and linear lock-guard lifetime no longer appear under an unrelated terminal-services summary.
- Expanded extracted normative text for D409 argument/environment nominal values and redaction, D411 socket naming, D427 docs metadata, D435 fixture ownership classes, D450 rename safety classes, and D458 independent field projection under active borrows.
- Added local trace mechanics for compiler architecture ownership, public spec writing, and service-board routing without claiming implementation or deployment.

### 0.2.13 - 2026-05-31

- Extracted the accepted D272-D524 language, toolchain, stdlib, rationale, appendix, workflow, and service-routing closure into public destinations.
- Closed Gate A through D524 without claiming compiler implementation, conformance, deployed services, or proof completion.
- Added exact traceability coverage for every accepted D-point heading in D272-D524 plus the embedded D272-D279 clarifications.
- Repaired stale contradictory prose around static strings, BOM handling, import/package cycles, formatter recovery and sorting, multi-binary packages, compressed `.koi` transport, fixture ownership, generated-code sandboxes, hosted-playground boundaries, unsafe ABI growth, volatile domains, `SpawnShareable`, and no-maybe wording.


### 0.2.12 - 2026-05-30

- Converted the D272-D524 Gate A backlog into explicit Phase 1 spec-writing work packages S1-S8.
- Added mandatory D502 contract matrices, D479-D487/D508 modal audits, traceability updates, and workflow/service-home assignments to Phase 1 completion.
- Added Phase 2 calculus synchronization rules for the D488-D501 strict-linearity closure and D502-D524 toolchain/infrastructure closure.
- Reordered near-term work so spec, workflow, service-board, calculus, and repository bootstrap work can proceed without treating accepted shape as implementation.


### 0.2.11 - 2026-05-30

- Accepted D502-D524 and updated the status board for accepted shape through D524.
- Added the infrastructure/public-docs/tooling cluster to roadmap assumptions, including spec contract matrices, CLI output contracts, Analysis Server feature lanes, editor/debug bundles, `kyokai-showcase`, PR/MR D-point workflow, no-maybe public docs, generated C artifact output, docs/website layout, examples/demo/all, compiler architecture boundaries, OSS infrastructure reuse, GitHub organization and repo split policy, package docs and `kdocs/`, local docs cache, numeric admission records, file-role diagnostics, community surfaces, web service topology, website taxonomy, package badge/trust separation, public spec-writing guide, and service ownership board.

### 0.2.10 - 2026-05-30

- Filled the accepted-shape gap for D466-D478 inside the already-open Gate A extraction range.
- Updated the status board for accepted shape D272-D524.
- Added the D466-D478 integrated language/toolchain contracts to roadmap assumptions, including validated wrappers, `compile_error`, task-transfer packaging rejection, parameter access syntax reaffirmation, conditional typeclass instances, explicit channel backpressure, nested defer failure, protocol state contracts, compiler explain modes, hot reload as a toolchain development service, string literal allocation identity, claim tiers, and public-doc slogan cleanup.

### 0.2.9 - 2026-05-28

- Filled the accepted-shape gap for D432-D465 inside the already-open Gate A extraction range.
- Updated the status board for accepted shape D272-D465 and D479-D487.
- Added the D432-D465 integrated FFI/toolchain/concurrency/safety contracts to roadmap assumptions, including non-C ABI tables, import/package cycle bans, linear-aware fixtures, SPSC broker discipline, multi-binary targets, edition-specific `.koi`, refutable `for-in` rejection, C export wrappers, raw signal handler contracts, formatter sort/recovery policy, diagnostic localization, dynamic loader policy, compressed `.koi` transport, fair `RwLock`, `SpawnShareable`, benchmark/property reports, LSP refactor safety, volatile/MMIO domain, failure taxonomy, inline asm, partial-error state, callback/TLS FFI, field projection/reborrow tables, unsafe instance audit, package provenance, authority ceilings, generational handles, embedded fatal hardware contracts, and generator sandboxing.

### 0.2.8 - 2026-05-27

- Filled the accepted-shape gap for D420-D431 inside the already-open D272-D431 and D479-D487 Gate A extraction range.
- Added the D420-D431 toolchain/stdlib/security closure to roadmap assumptions, including source-byte identity, explicit randomness lanes, terminal services, canonical package source artifacts, lockfile modes, `bleedring` toolchain management, scratch execution, docs metadata, deprecation policy, cache trust, bindgen provenance, and KYSA security advisories.

### 0.2.7 - 2026-05-26

- Updated the status board for accepted shape through D431 and D479-D487.
- Reopened Gate A for D272-D431 and D479-D487 until those accepted rules are extracted into spec/workflow homes.
- Added the D479-D487 modal-wording clarification pass to roadmap assumptions, covering legal meanings of `may`, banned `should` in normative text, non-observable optimizations, full implementation conformance, target-gated surfaces, proposal/search labels, policy-selected behavior, target-contract variation, specified nondeterminism, tooling-only assistance, tracked D-point dependencies, experimental absence, and required modal audits during spec extraction.

### 0.2.6 - 2026-05-26

- Updated the status board for accepted shape through D419.
- Reopened Gate A for D272-D419 until those accepted rules are extracted into spec/workflow homes.
- Added the D396-D419 daily systems/toolchain critique closure to roadmap assumptions, including no telemetry/background network, exact feature-set package instances, visible startup authority bundles, target-native paths, strict float semantics, split hash determinism, OS error versioning, clock authority splits, fatal redaction, explicit native toolchain discovery, generated-source provenance, executable examples, PR/MR-based D-point workflow, Unicode algorithm versioning, native args/env, atomic file update contracts, capability-gated networking, test sandboxing, strict codecs, diagnostic stability, allocation-failure testing, behavior SemVer, process status values, CPU feature dispatch, and package-name policy.

### 0.2.5 - 2026-05-24

- Updated the status board for accepted shape through D395.
- Reopened Gate A for D272-D395 until those accepted rules are extracted into spec/workflow homes.
- Added the D366-D395 External systems-language critique closure to roadmap assumptions, including maturity honesty, doc-comment strictness, terminator reaffirmation, named modulo APIs, literal ambiguity rejection, static text and text views, nominal return values, generational handles, universe reaffirmation, typeclass admission, defer/error propagation diagnostics, failure hooks, capability bundles, module split reaffirmation, package/vendoring behavior, allocator-context rejection, collection syntax reaffirmation, UFCS reaffirmation, iterator-first generators, structured taskgroups, unsafe audit reaffirmation, file build constraints, essential CLI behavior, first stdlib slice, layout facts, proof-scope reaffirmation, and license-boundary reaffirmation.

### 0.2.4 - 2026-05-24

- Updated the status board for accepted shape through D365.
- Reopened Gate A for D272-D365 until those accepted rules are extracted into spec/workflow homes.
- Added the D322-D365 granular critique closure to roadmap assumptions, including unsafe grammar, ABI, diagnostics, concurrency, memory model, `.koi`/KBI, comptime, typeclass coherence, generators, allocation failure, and arithmetic contracts.

### 0.2.3 - 2026-05-21

- Updated the status board for accepted shape through D311.
- Reopened Gate A for D272-D311 until those accepted rules are extracted into spec/workflow homes.
- Added the D307 public decision workflow shape to the roadmap assumptions.

### 0.2.2 - 2026-05-16

- Added explicit status lines to every phase.
- Added a gate closure ledger showing Gate A closed for accepted decisions through D270 and Gates B-G still open at that time.
- Updated the status tracker so each phase names its current gate state.

### 0.2.1 - 2026-05-16

- Updated the roadmap for the current spec extraction state: `kyokaispec/` now has the active Kyokai chapter family and traceability appendix.
- Added D266-D270 daily-usability work to Phase 1, Phase 8, Phase 12, Gate F, the tooling lane, and the near-term queue.
- Corrected Phase 0 and Phase 1 statuses so they no longer claim the spec has not started.

### 0.2.0 - 2026-05-02

- Replaced the stale phase list with a full roadmap based on the decided Kyokai shape.
- Added source-of-truth order, maturity states, global gates, detailed phase breakdowns, cross-phase dependencies, feature admission checklists, and a near-term queue.
- Corrected stale D-point mappings by grounding recent work in D143/D241, D238/D239/D240, D228, D229-D232, D242-D262, and the current work-item section.
- Made spec extraction, Austral-spec-to-Kyokai-spec work, and the sequential `lambda_K` paper proof explicit early phases.

### 0.1.0 - historical

- Initial short execution-phase sketch. Superseded because it used stale D-point meanings after later decision closures.
