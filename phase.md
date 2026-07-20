# Kyokai Execution Phases

**Version:** 0.2.59
**Date:** 2026-07-20
**Status:** Active roadmap
**Public decided shape:** `kyokaidecided.md`
**Public D-point holding/index/archive:** `Kyokaishape.md`
**Normative spec:** `kyokaispec/`

## 1. Purpose

This file defines the execution order for turning Kyokai from the decided language plan into a specified, tested, implemented, and eventually proven systems language.

This file is not a second language spec. It is not a reduced scope document. It is not an MVP list. `kyokaidecided.md` is the public extraction of accepted shape, PRs/MRs are the normal home for live public D-points, `Kyokaishape.md` is the public temporary holding area and decision/index/archive ledger, and `kyokaispec/` is the normative spec for rules already written there. `phase.md` exists to answer these practical questions:

- what must be written before compiler work can safely move fast
- what parts of the Austral compiler/spec are forked, retired, or rewritten first
- when the Kyokai calculus must be written
- when the generated-C backend, admitted C toolchains, stdlib, package manager, and tooling become valid targets
- what tests and proof artifacts close each phase
- which work is allowed to proceed in parallel and which work is gated by earlier semantics

The guiding rule is simple: implementation order must not create hidden semantics. If a feature cannot be implemented without guessing, the phase is blocked until the relevant rule is written in `kyokaispec/` or opened as a real public D-point in a PR/MR or the `Kyokaishape.md` temporary-holding area.

## 2. Source-Of-Truth Order

Kyokai has several documents and code trees. They do not have equal authority.

1. `kyokaispec/` is the normative reference once a rule is written there.
2. `kyokaidecided.md` is the public accepted-shape extraction for rules not yet fully spec-extracted.
3. Public PRs/MRs carry live D-point proposals and final wording.
4. `Kyokaishape.md` is the public temporary holding area and decision/index/archive ledger for D-points that do not yet have a better canonical PR/MR home.
5. `phase.md` is an implementation and proof-order roadmap only.
6. `compiler/` owns active Kyokai compiler code; `lib/` is the classified inherited bootstrap; `standard/`, `test/`, and `test-programs/` retain their stated bootstrap and evidence roles.
7. Upstream Austral source/tests remain evidence for inherited behavior, not public Kyokai authority.

When a conflict appears, fix the lower-authority artifact. Do not silently reinterpret public Kyokai docs through stale inherited prose.

## 3. Current State

The initial language-design pass is closed enough to seed public development, and the first full Kyokai specification extraction now exists under `kyokaispec/`. That does not mean Kyokai is implemented or proven. It means the active roadmap can stop treating the spec as an empty target and can start treating it as the public contract that compiler work must chase.

Current assets:

- `kyokaispec/` contains the extracted language, toolchain, standard-library, rationale, and appendix chapter family. It is the normative home for written Kyokai rules.
- `kyokaidecided.md` contains the public accepted-shape extraction through D635, including D562a, D569a-D569c, D573a, D592a, D593a, D596a, and D624a; D609, D613, D617, and D622 are duplicate withdrawals, and D626 remains withdrawn by D596a.
- `Kyokaishape.md` is the public temporary holding area and decision/index/archive ledger for D-points that do not yet have a better canonical PR/MR home; live D-points normally live in PR/MR threads.
- `kyokaispec/src/project/02-decision-traceability.md` maps accepted decisions into spec sections.
- `kyokaispec/spec.md`, `kyokaispec/spec.html`, `kyokaispec/README.md`, `kyokaispec/Makefile`, and `kyokaispec/SPEC_COMPILER_TRACE.md` describe and build the extracted spec family.
- `compiler/` contains the active Kyokai frontend and package-source implementation.
- `lib/` contains the classified inherited Austral bootstrap passes.
- `standard/` is the current inherited standard-library tree.
- `test/` and `test-programs/` are current public compiler and end-to-end test assets.
- `kyokaicalculus/lean/` pins Lean 4 through Elan and builds the first narrow
  owner-slot repair spot artifact with Lake.

Current liabilities:

- The current compiler and standard library are still largely Austral-shaped.
- The extracted spec needs implementation pressure, review, and conformance tests before it can be treated as proven by tooling.
- D266-D557 have spec destinations or workflow homes. Their compiler commands, tool contracts, standard-library admissions, application-integration contracts, target records, concurrency rules, generated-C/toolchain safety rules, `.koi`/KBI implementation, resolver and lockfile implementation, conformance tests, capability deny-policy implementation, official Bridge collection implementation, and deployed service work still need implementation evidence where their gates require it. Phase 3 closes the source-language boundary: one `.kyo` file per module, retired and inherited source-form rejection, a span-carrying surface AST, phase-local structural checks, manifest-rooted source loading, and derived public/`internal` interface facts. Cross-module resolution, `.koi` serialization and consumption, typing, elaboration, ownership, backend work, and conformance-backed status remain in their owning later phases.
- Gate A is closed through D635. The three checked D577 registries cover the 573 accepted pre-D558 decisions, D558-D625, and D627-D635; D626 remains withdrawn. They bind stable clause IDs to accepted-source digests, canonical individual or grouped trace rows, destinations, review identity, supersession, proof impact, exact vocabulary, rejected forms, and generated status projections. Implementation, conformance, API/admission packets, the semantic atlas, operational security intake, compiler/provider admissions, and platform/workload evidence remain separate work.
- D627-D635 are also `SPEC_EXTRACTED` under their checked registry. Their concrete artifacts are not thereby implemented: the adversarial corpus, public-knowledge manifest, calculus/review version records, native-provider distribution, target-contract/provider selection, diagnostic registry, typed finding/release-review machinery, and umbrella-child workflow still belong to Phases 3, 8, 13, and 15 as named below.
- The D143/D241 sequential `lambda_K-seq` paper proof is closed at the
  `paper-proven` tier for Gate B. A narrow Lean spot artifact checks selected
  owner-slot repair facts mechanically, but it does not mechanically prove
  the main theorem.
- Whole-core mechanization remains later work, but narrow vertical mechanization now starts before self-hosting where it can test the architecture: the next target connects one executable step-relation case and one typing judgment end to end. These narrow artifacts do not become general compiler blockers or broaden their proof claims.

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

Numbered roadmap items put their status immediately after the item number:

- `✅` means done for the named scope.
- `⬜` means not done or only partially done; the row text states what remains.

Unnumbered checklists still use Markdown task boxes where the list itself is an
artifact to close, such as the global gate checklist and the extraction board.

| State | Meaning | Exit Requirement |
| --- | --- | --- |
| `SHAPE_DECIDED` | The design point is decided in public accepted-shape docs. | `kyokaidecided.md`, the owning public PR/MR when one exists, and any `Kyokaishape.md` index/archive row agree. |
| `SPEC_EXTRACTED` | Every live accepted clause has checked normative destinations and complete or validly not-applicable state. | Clause registry/review evidence plus exact behavior, errors, examples, and cross-references. |
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

Done when there is no live behavior whose only source is an old recommendation block or informal note, and every accepted rule has clause-level evidence for exact behavior, errors, examples, cross-references, and contradiction resolution. A route or trace row is necessary but cannot close Gate A by itself. `pre-d558.toml`, `d558-d625.toml`, and `d627-d635.toml` now satisfy this condition through the current accepted boundary.

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

Whole-core mechanization and Gate-G closure remain coupled to sustained compiler and self-hosting work. Narrow, high-risk vertical mechanizations may and should land earlier when they test a semantic seam without claiming the whole core.

Done when Kyokai compiler components are written in Kyokai, the bootstrap path is documented, and the proof assistant artifacts build against the chosen formalization.

Gate G has an earlier D592a **self-host entry threshold** that permits Phase 14
implementation before Gate F closes. Entry requires substantial multi-package
Kyokai compilation; stable parser/elaboration/type/linearity/borrow/module/`.koi`
and generated-C/runtime foundations; deterministic builds; usable diagnostics;
working package/build fundamentals; the Tier-One stdlib subset needed by the
selected compiler slice; shared conformance and differential suites; and a
documented recovery bootstrap. A toy compiler, one successful self-build, or an
unstable toolchain does not qualify. Entry permits migration; it does not close
Gate G or retire OCaml.

### Gate Closure Status

| Gate | Current State | Closed Evidence | Still Open |
| --- | --- | --- | --- |
| Gate A: Plan-To-Spec Closure | Closed through D635 | The three D577 registries/checker and generated reviews verify the complete accepted inventory through D635, accepted-source identity, canonical trace rows, destinations, review identity, supersession, proof impact, exact-name/rejected-form checks, and stale-view detection | New accepted D-points or later contradictions reopen only their affected extraction boundary; implementation/admission/service evidence belongs to later gates |
| Gate B: Sequential Core Soundness | Closed for `lambda_K-seq` paper proof | `kyokaicalculus/scope.md` freezes the first theorem boundary; the maintained derivation packages and `theorem-assembly.md` close the named paper theorem; `kyokaicalculus/reviews/lambda-k-seq-maintainer-review-2026-07-12.md` records the reported three maintainer review passes without claiming independent review; executable traces and the narrow Lean artifact provide supporting evidence only | Independent review is still desirable but is not silently claimed; whole-core Lean mechanization, compiler correspondence, concurrency, unsafe/FFI, backend lowering, stdlib admission, toolchain behavior, package management, and hosted services remain outside Gate B |
| Gate C: Compiler Semantic Pipeline | Open | Spec text describes the required D238/D239/D240 shape | Parser, typed elaboration, implicit-completion registry, tautology checking, and safety checks are not implemented as a tested pipeline |
| Gate D: Generated-C And C-Toolchain Closure | Open | D530-D536 specify one generated-C backend and its toolchain contract; D572 adds sequenced IR, structural validation, lowering evidence IDs, differential execution, and targeted proof slices | Sequenced IR, validator, C emitter UB closure, major-platform compiler admissions, source-map/debug/coverage/profiler implementation, sanitizer/differential/conformance evidence, proof slices, and measured build-time gates are not done |
| Gate E: Practical Bootstrap Usability | Open | Required workload shape and stdlib domains are identified | Native stdlib modules and representative small POSIX CLI workload support are not implemented |
| Gate F: Public Conformance Release | Open | Spec extraction, the Gate-B paper proof, and daily-usability command contracts exist | Compiler conformance suite, package behavior, formatter, diagnostics, docs, and stdlib admission records do not yet agree in implementation |
| Gate G: Self-Hosting And Mechanization | Open; D592a entry threshold also open | Lean 4 is selected; Elan and Lake build the narrow owner-slot repair artifact; D592a defines replacement preparation, entry, convergence, retirement, and recovery stages | Current OCaml components need transition dispositions and replacement-safe seams; the entry threshold, Kyokai-native slices, Stage 2/3 convergence, recovery evidence, whole-core Lean encoding, mechanized soundness, and proof CI remain open |

Closed gates right now: Gate A is closed through D635 and Gate B is closed for the narrow `lambda_K-seq` paper proof. No compiler, generated-C/toolchain, stdlib implementation, package implementation, application-integration implementation, Bridge collection implementation, release, self-hosting, or whole-core mechanized proof gate is closed yet.

Public visibility is staged independently from stable platform claims. The service board in `docs/infrastructure/services.md` owns the public visibility labels: `PUBLIC_EXPERIMENTAL`, `PUBLIC_BOOTSTRAP`, `PUBLIC_PACKAGE_ECOSYSTEM`, `PUBLIC_CONFORMANCE_RELEASE`, and `PUBLIC_STABLE_PLATFORM`. Kyokai can become public knowledge at `PUBLIC_EXPERIMENTAL` once organization/repository ownership and website/service records are scaffolded and every page says that compiler conformance, package trust, stable install, and support are not claimed. Phase 12 owns the package index, package docs, website, community, release, and service-board work needed for bootstrap and ecosystem public stages. Phase 13.1 and later C-toolchain evidence are required for stable platform claims over named C toolchains and targets; they are not the first point where public infrastructure can exist.

Gate checklist:

- [x] Gate A: Plan-To-Spec Closure is closed through D635 by the checked pre-D558, D558-D625, and D627-D635 registries; D626 is withdrawn by D596a. API/admission packets, recurring review evidence, and public services remain on their own maturity axes rather than being smuggled into extraction status.
- [x] Gate B: Sequential Core Soundness for the narrow `lambda_K-seq` paper proof.
- [ ] Gate C: Compiler Semantic Pipeline.
- [ ] Gate D: Generated-C And C-Toolchain Closure.
- [ ] Gate E: Practical Bootstrap Usability.
- [ ] Gate F: Public Conformance Release.
- [ ] Gate G: Self-Hosting And Mechanization.
- [ ] D592a self-host entry threshold: replacement preparation begins now; source migration remains blocked until the compiler/stdlib/conformance/recovery criteria above pass.

## 7. Build Order

The phases below are ordered by dependency, not by excitement. Some implementation work can run in parallel after its input contracts exist, but no phase may bypass its gates by treating unspecified behavior as compiler policy.

Read each numbered row as `number → status → work`. A phase is complete only
when its completion verdict says `COMPLETE` and every exit condition below that
verdict is true. An `OPEN` verdict is authoritative even when many numbered rows
are already checked. A completed scoped gate may leave explicitly named follow-on
evidence work open; the verdict must say so instead of making the reader guess.

### Workstream Placement Map

This table answers where cross-cutting work actually happens. Phase numbers are
dependency labels, not a demand to finish every earlier phase before starting a
later lane whose stated entry condition has passed.

| Workstream | Starts | Becomes the real implementation | Why it is placed there |
| --- | --- | --- | --- |
| Accepted decisions, normative clauses, traceability, and contradiction repair | Phase 1; repeated with every accepted semantic change | The owning spec chapter and checked clause record in the same change | Implementation cannot choose between stale accepted text and newer normative prose. Later governance in Phase 15 keeps the loop alive. |
| Repository-root classification and cleanup | Phase 3.10 | Phase 3 exit for current root material; later additions follow the same rule | Authority and public/private roles are known after Phase 0, but paths must be cleaned before more tools hard-code the current clutter. |
| Compiler/toolchain/runtime/stdlib tree migration | Phase 3.11 | Incrementally in Phases 3-14; the active owner moves with each subsystem | A flag-day move would destroy useful history and break build/evidence paths. Leaving it as an unnumbered cleanup task lets the inherited tree become permanent. |
| OCaml bootstrap compiler | Phases 3-7 | Never the final product implementation | It exists only to reach a trustworthy Kyokai compiler and must expose replacement-safe boundaries from the start. |
| Core and systems standard library | API/admission packets can begin earlier; source begins in Phase 9 | Ordinary Kyokai source in Phases 9-11 | The compiler must first check and lower the language features used by each module. The stdlib is not implemented in OCaml. |
| CLI, formatter, docs, package/build, audit, Analysis Server, and other ordinary toolchain components | Contracts, schemas, harnesses, and the minimum bootstrap adapters begin in Phase 8 | Kyokai-native slices begin immediately after the Phase 10.14 entry review passes and continue through Phase 14 | The first native slices need diagnostics, package/build fundamentals, and tests, but implementing the whole product in OCaml would create the rewrite D592a rejects. |
| Package/index/ecosystem commands | Protocol and resolver work begins in Phases 4, 8, and 12 | Shipped local toolchain code is Kyokai-native through Phase 14; hosted services follow Phase 12 service records | Resolver semantics must exist before self-hosting, while product command implementations should not become permanent OCaml code. |
| CI, conformance, admission, and proof checks | Grow with every implementing phase; shared harness in Phase 8 | Target matrices in Phase 13 and mechanized proof lanes in Phase 15 | Evidence must land with the feature it checks instead of being postponed into one final testing phase. |
| Bleedring bootstrap installation and admitted native compiler providers | Provider protocol and bootstrap boundary in Phase 8.17; implementation in its separate repository | Standalone Kyokai-written Bleedring implementation; official provider matrices close in Phase 13 | Bleedring installs complete Kyokai distributions and exact admitted C-provider bundles. It does not split Kyokai itself into mixed components, edit project selection, or turn `kyokai install` into a system installer. |
| Adversarial ownership and wrong-semantics workloads | Public schema in Phase 3.12; cases land with their owning Phases 4-13 | Shared indexing/results in Phase 8; admission and release matrices in Phase 13 | Workloads must pressure semantics while those semantics are being implemented, not arrive after the checker and backend have hardened. |
| Diagnostic code registry | Schema and import audit in Phase 8.7 | Generated compiler/catalog/test tables before released diagnostics | Stable codes need one allocation and lifecycle owner before CLI, LSP, fixes, and external-tool normalization depend on them. |
| Release knowledge manifest and post-release implementation review | Schemas/checks in Phases 8 and 12 | Required release evidence in Phases 12-15 | Spec, calculus, implementation, providers, XPs, and review have separate versions that must be joined at release without collapsing their claims. |
| Semantic atlas | Authoring may begin alongside the Phase 1 clause audit | Drift-checked atlas tooling in Phase 8; official publication with Phase 12 docs infrastructure | The atlas explains the spec and tests reader prediction. It cannot become a second semantic authority or claim currency without clause-revision checks. |
| Xperimental and stable-carried experiments | Records and isolated branch workflow may begin once an XP is authorized | Harness and artifact isolation in Phase 8; distribution/index enforcement in Phase 12 | An experiment needs tests before experimental merge, not after feedback has already been collected from an untracked build. |
| Compiler admission | Schema work begins with the Phase 8 conformance runner; generated-C checks begin in Phase 7 | Reviewed compiler/target admissions in Phase 13 | Admission reuses stable semantic IDs. It does not reimplement language semantics or let C compiler agreement define Kyokai. |
| Public website, package/knot docs, showcase, community, security intake, releases, and playground | Records and local skeletons may begin before deployment | Phase 12 service work, each behind its own authority and security gate | Public infrastructure can develop early, but no planned service becomes official by existing in the tree. |
| Application integration, official Bridges, and reference products | Shared value/ownership/API foundations in Phases 9-12 | First Bridge/native slices and reference applications through Phases 13-14; the long-lived Poller server is first after the language toolchain | Framework and platform pressure should test ordinary Kyokai contracts, not create compiler-private escape hatches. |
| Calculus and proof | Phase 2 paper core; proof-impact tracking continues with semantic changes | Narrow mechanization may start early; sustained whole-core work is Phase 15 | Executable tests pressure semantics but do not replace the theorem, and proof artifacts do not replace compiler conformance. |
| Known defects, critique findings, and implementation divergences | Immediately in the phase that owns the affected boundary | Closed only by the owning fix, test, spec/calculus synchronization, or explicit retained-risk record | A defect is not postponed merely because its discovery came from a review document rather than planned feature work. |

### Test And Evidence Timing

Tests are written with the feature that creates the behavior. Phase 8 supplies
the shared runner, report formats, replay, and CI lanes; it is not the first time
semantic tests appear.

| Evidence family | First required | Promotion or broad matrix |
| --- | --- | --- |
| Spec source, clause registry, traceability, modal wording, and public-boundary checks | Every Phase 1 spec/extraction change | Required PR checks once their checker exists; release record includes the exact spec revision. |
| Lexer, parser, source-role, span, accepted-form, and rejected-form tests | Same Phase 3 change that adds or changes the syntax | Public parser conformance after the real compiler command and stable diagnostics exist in Phase 8. |
| Module, import, visibility, package/workspace, resolver, lockfile, and `.koi` tests | Same Phase 4 implementation slice | Hostile decoder, compatibility, reproducibility, and package-scale matrices in Phases 8 and 12. |
| Type, generic, elaboration, implicit-completion, pattern, and contract tests | Same Phase 5 implementation slice | Gate-C conformance and diagnostic goldens through the Phase 8 runner. |
| Linearity, borrow, cleanup, capability, unsafe, and task-transfer tests | Same Phase 6 implementation slice, including negative branch/exit cases | Gate-C conformance, property cases, and explanation fixtures through Phase 8. |
| Adversarial ownership/design-pressure cases | Schema in Phase 3; first applicable case with each Phase 4-7 semantic owner | Shared runner in Phase 8; stdlib/concurrency/application and target/provider matrices in Phases 9-13. |
| Runtime, TPOE, fatal arbitration, generated-C structure, arithmetic/range, ABI, and lowering tests | Same Phase 7 lowering/runtime slice | Sanitizers, differential execution, compiler admission, debugger/source-map, optimization, and target matrices in Phase 13. |
| CLI, formatter, diagnostics, Analysis Server, docs, audit, fix, replay, and machine-protocol tests | With each Phase 8 contract and implementation slice | Full Gate-F command matrix and editor/protocol parity before public conformance release. |
| Stdlib unit, edge-case, allocation-failure, oracle/vector, property, fuzz, cleanup, and compatibility tests | With each Phase 9-11 module, before that module is admitted | Cross-platform and workload suites expand in Phases 10-13; admission is per module, not deferred until the whole stdlib exists. |
| Package, knot, publish, vendor, offline, docs-rendering, generator, cache, and service tests | With each Phase 12 implementation slice | Release/security/deployment lanes only after identities, retention, authority, and rollback records exist. |
| Reference workloads and end-to-end programs | First narrow workload as soon as its dependencies compile; the long-lived Poller server begins across Phases 9-12 | Target/provider matrices in Phase 13 and release smoke in Phase 12/14. |
| Property and fuzz targets | Added with parser, decoder, allocator, collection, protocol, and unsafe surfaces when a stable oracle and replay form exist | Scheduled campaigns begin only after Phase 8 preserves artifacts and deterministic replay; a campaign never substitutes for the PR regression. |
| XP-specific conformance, security, workload, cache, and artifact-isolation tests | Before an XP branch can merge into `experimental` | Weekly Xperimental or stable-carried distribution only after its evidence packet and identity checks pass. |
| Paper and mechanized proof builds | Paper sources and executable witnesses in Phase 2; narrow Lean artifacts as they appear | Dedicated proof CI in Phase 15, with explicit theorem scope and spec correspondence. |

### Phase 0: Repository Baseline And Decision Audit

**Purpose:** Establish the workspace facts and remove stale planning assumptions before implementation churn begins.

**Dependencies:** None.

**Status:** Complete enough for the implementation-roadmap baseline. No global gate is closed by Phase 0 alone; it prepares Gate A by making the source tree and document authority visible.

**Subparts:**

- 0.1. ✅ Verify the initial decision batch has been extracted into public accepted shape or explicitly left as historical-only context. **Status: complete.** `kyokaidecided.md` now holds the accepted-shape extraction used for spec writing.

- 0.2. ✅ Record the source-of-truth order in this file and in public workflow docs. **Status: complete.** Current order is `kyokaispec/` once written, then `kyokaidecided.md`, then public D-point PRs/MRs, then `Kyokaishape.md` as temporary holding and decision/index/archive when needed, then `phase.md` for implementation order only.

- 0.3. ✅ Inventory the active public source, specification, standard-library, test, and upstream-reference trees and assign each one a purpose. Active implementation paths remain in this repository; separately obtained upstream checkouts are evidence only and are not part of the public source tree. **Status: complete enough for Phase 0.** Deeper compiler-pass inventory and the implementation-tree migration belong to later phases.

- 0.4. ✅ Identify stale references in public docs, especially inherited Austral text and old path names. **Status: complete enough for Phase 0.** The root README, `kyokaispec/README.md`, `kyokaispec/SPEC_COMPILER_TRACE.md`, and active spec root describe Kyokai as a full forked language spec that carries forward applicable Austral behavior while defining Kyokai's differences directly. Remaining stale inherited docs can be cleaned as they are touched.

- 0.5. ✅ Create or update a D-point-to-work-area map covering parser, resolver, type checker, linearity checker, code generation, runtime, stdlib, package manager, and tooling. This is not only `Kyokaishape.md`: live/new public D-points normally live in PRs/MRs, `Kyokaishape.md` temporarily holds and indexes points that do not live there, and `kyokaidecided.md` plus `kyokaispec/` trace accepted decisions to implementation areas. **Status: complete enough for Phase 0.** `kyokaispec/src/project/02-decision-traceability.md` is the spec-facing traceability index, and future decisions must update it when they become accepted.

- 0.6. ✅ Keep the extracted Kyokai spec under `kyokaispec/`. Inherited Austral spec material may be used as a seed, but Kyokai spec text must be reviewed and rewritten before it becomes normative. **Status: complete enough for Phase 0.** The active build uses the Kyokai chapter family under `kyokaispec/src/`; old inherited Austral chapters are no longer the active spec source.

**Completion verdict:** ✅ **COMPLETE.**

**Exit rule:** Phase 0 is done because every condition below is true:

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

**Status:** complete. Normative chapter text and traceability reach D635, and the pre-D558, D558-D625, and D627-D635 ranges are `SPEC_EXTRACTED` under checked D577 registries and generated reviews; D626 is withdrawn. Gate A is closed through D635. Gate B is separately closed for the narrow `lambda_K-seq` paper proof; Gates C-G remain open.

**Subparts:**

- 1.1. ✅ Create the Kyokai language spec structure under `kyokaispec/`. Use inherited Austral spec material as formatting and organization prior art only after checking it against actual Austral compiler behavior.

- 1.2. ✅ Extract lexical syntax, comments, docstrings, literals, numeric suffixes, keywords, operators, terminators, and source-file structure.

- 1.3. ✅ Extract declarations: modules, interfaces/bodies, records, unions, extern/packed records, type aliases, newtypes, typeclasses, associated types, capability declarations, constants, functions, tests, and visibility.

- 1.4. ✅ Extract expression and statement semantics: evaluation order, `let`, assignment, `case`, `if`, loops, `while let`, `for-in`, `let...else`, `or return`, `defer`, `errdefer`, `debug`, `panic`, `require`, `ensure`, and `old`.

- 1.5. ✅ Extract the type system: `Free`, `Linear`, `Auto`, region behavior, borrow types, reference syntax, field auto-deref, auto-reborrow, linear destructuring, `Never`, optional/result shapes, generics, const generics, and monomorphization.

- 1.6. ✅ Extract capability and authority rules: `RootCapability`, ordinary capabilities, task-transfer classifications, unsafe capability access, sealed capabilities, and authority flow across FFI and tasks.

- 1.7. ✅ Extract FFI and unsafe rules: `foreign`, `pragma Unsafe_Module`, `UnsafeCapability`, `unsafe contract ... audit;`, raw pointer/address rules, volatile, inline assembly, ABI records, sum-type boundary wrappers, ownership transfer wrappers, and failure contracts.

- 1.8. ✅ Extract concurrency rules: 1:1 OS-thread tasks, task groups, spawn capture lists, join, cancellation, SPSC channels, select, atomics, memory orders, happens-before edges, mutexes, `RwLock`, `Poller`, `SignalWatcher`, broker patterns, and process supervision.

- 1.9. ✅ Extract runtime-failure semantics: TPOE, `panic`, runtime-fatal/internal failures, stack overflow detection, OOM, failed assertions/contracts, arithmetic errors, and the rule that TPOE/panic are not catchable in process.

- 1.10. ✅ Extract backend and layout rules: one generated-C backend, C11 subset, compiler admission, record layout, packed layout, extern layout, endian transforms, C UB avoidance, source maps, linking, binary outputs, target profiles, and compilation-time gates.

- 1.11. ✅ Extract the toolchain spec: `kyokai --version`, `doctor`, `init`, `new`, `check`, `build`, `run`, `test`, `fmt`, `doc`, `lsp`, `audit`, `bench`, `repl`, `explain`, `fix`, package/workspace manifests, lockfiles, `.koi` artifacts, target triples, profiles, generated artifacts, diagnostics, JSON output, warning suppression, lints, semver checking, and package commands including `add`, `remove`, `update`, `search`, `info`, `tree`, `why`, `outdated`, `vendor`, and `publish`.

- 1.12. ✅ Extract the stdlib admission and contract spec: D229 admission criteria, D231 crypto policy, D232 numerical accuracy contracts, allocator policy, formatting, `StandardError`, collections, OS APIs, capabilities, and transitional FFI tracking.

- 1.13. ✅ Add a traceability index from each public D-point or accepted-shape entry to the normative spec section that owns it.

- 1.14. ✅ Keep historical research notes out of the final spec unless they are needed for rationale.

- 1.15. ✅ Apply the D502 contract-matrix discipline while extracting every user-visible rule. Language, toolchain, and stdlib chapters use their own required matrix fields. Workflow-only and service-only documents name their role explicitly instead of masquerading as language semantics.

- 1.16. ✅ Run the D479-D487 and D508 modal-word audit over each touched normative chapter. Every `may`, `should`, `optional`, `if provided`, `if admitted`, `future`, `later`, `where relevant`, `unspecified`, `implementation-defined`, or equivalent hit is rewritten or classified in the review record. A hit that would change accepted behavior becomes a new D-point instead of an editorial guess.

- 1.17. ✅ Extract the strict-linearity usability closure from D488-D501. This includes resource-flow refactors, sound scratch workflows, graph/slot-map guidance, recovery payloads, explicit context bundles, callback invocation classes, linear fixtures, join diagnostics, hole-free collections, universe-aware containers, early-release warnings, FFI wrapper kits, the `build` expression, and the stdlib admission ladder.

- 1.18. ✅ Extract the D502-D529 toolchain, public-infrastructure, ProofTrace evidence, capability deny-policy, final resolver/lockfile closure, and official Bridge collection closure. Normative toolchain behavior lands in `kyokaispec/src/toolchain/`; numeric and Bridge admission evidence lands in `kyokaispec/src/stdlib/`; workflow rules land in `PROJECT_STANDARDS.md` and `docs/contributing/spec-writing.md`; service ownership lands in `docs/infrastructure/services.md`; website, examples, organization migration, repository-owned package docs, optional package-doc mirrors, and `kyokai-showcase` receive tracked implementation issues or PRs without being presented as implemented.

- 1.19. ✅ Keep `kyokaispec/src/project/02-decision-traceability.md` synchronized as each work package lands. A work package is not complete when prose exists only in `kyokaidecided.md`; its trace row must point at the normative chapter, workflow home, service record, or historical-only note that owns it.

- 1.20. ✅ Extract D558-D570, including D562a and D569a-D569c: closed callable effects; borrow lineage; structural `Free`; concurrent fatal arbitration; workspace/spec authority repair; monthly/release review records; projection syntax; authority-versus-containment labels; defined unsafe providers; unsafe-capability topology; callable classes and `.koi`; untrusted-input validation; the Kyokai atomic model; shared compiler-admission corpus, matrix, lifecycle, and self-verification; and `KST-1` source identity.

- 1.21. ✅ Extract D571-D583, including D573a: structured child reaping; sequenced generated-C validation; KBI-1 framing, payload grammar, hostile-input budgets, compatibility and independent-decoder admission; explicit Linux `io_uring`; clause-level extraction evidence; public-document identity; the semantic atlas; bidirectional spec/calculus correspondence; identified revision-bound proof review; XP/Xperimental governance; and the vulnerability-reporting/incident-service schema.

- 1.22. ✅ Extract D584-D596a: exact Tier-One API packets; closed `TextView[R]`; storage and collection matrices; CLI and testing protocols; capability-map and authority-explanation rules; observability; codec/data placement; Kyokai-native toolchain entry, convergence, recovery, and OCaml retirement; crypto/provider and admission-record classes; maintained web/database surfaces; the initial Bridge evidence portfolio; and the explicit rejection of overarching Rust integration. Mark D609 withdrawn as a D585 duplicate.

- 1.23. ✅ Extract D597-D614: fail-closed generator admission; math ownership/oracles/replacement; shared-lifetime patterns and `kyokai explain ownership-pattern`; SPSC/native-task evidence; the long-lived Poller reference product; root `[documentation].mode` and CLI documentation modes; non-authorizing `debug`; `drop;`, terminator-layout, unsafe-label, borrow-spelling, comment, and `build;` closure; no-shadowing assistance; frontend ownership plus dual inherited-pass dispositions; and typed finding intake. Preserve D609/D613 as duplicate withdrawals rather than second normative rules.

- 1.24. ✅ Extract D615-D625: standalone Bleedring and bundled distribution identity; named deep-analysis engines; deterministic development supervision; Apple-platform evidence; game-integration workloads without an official engine; CLI/machine/LSP analysis parity; cross-phase reference workloads; foreign-build plans; atomic knot publication over a selected set of separately publishable/indexed packages, including exclusions and dependency closure; and stable-carried, root-manifest-enabled experiments. Preserve D617/D622 as duplicate withdrawals and D626 as withdrawn by D596a.

- 1.25. ✅ Extract D627-D635: adversarial ownership and wrong-semantics workloads; separate public-knowledge identity and forward-only spec SemVer; calculus/proof revision and Git review classes; Bleedring-managed exact native compiler providers; portable target-contract/provider selection without ambient `cc`; a canonical diagnostic registry; PR-local implementation finding routing plus post-release review/hotfix rules; and umbrella decisions with reserved proposed children and public temporary holding. D627-D635 passes the D577 clause-level extraction check; implementation and evidence remain open in their owning phases.

- 1.26. ✅ Enforce checked extraction in the Git workflow. The author writes the normative clauses, registry entries, generated review, traceability, and status changes in the semantic PR or in an explicitly linked extraction PR. `.github/workflows/spec-integrity.yml` runs `make check-spec-integrity` on affected PRs and `main`/`dev` pushes. The check rejects stale or incomplete recorded extraction; it cannot write clauses, accept a D-point, judge semantic fidelity, or grant `SPEC_EXTRACTED` by itself.

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
| S8: Formalization roadmap and claim boundaries | D143/D241, D312, D319, D367, D394, D477, D479-D529 | `project/03-formalization-roadmap.md`, `kyokaicalculus/scope.md`, `kyokaicalculus/claim-tiers.md`, `kyokaicalculus/syntax-and-statics.md`, `kyokaicalculus/dynamics.md`, `kyokaicalculus/lemmas.md`, `kyokaicalculus/paper-proof.md`, `kyokaicalculus/deviation.md` | Claim tiers, proof exclusions, environment-machine semantics, later-layer owner map, surface/core obligations, authority-policy proof exclusions, resolver proof exclusions, Bridge proof exclusions, and Gate B input list. |
| S9: D571-D583 cross-cutting closure | D571-D583, including D573a | owning language/toolchain/stdlib chapters; `PROJECT_STANDARDS.md`; `CODE_STANDARDS.md`; `docs/contributing/spec-writing.md`; `docs/infrastructure/services.md`; `SECURITY.md`; `docs/semantics/`; calculus review/correspondence records | Clause registry entries, KBI schemas and corpora, generated-C validation obligations, provider contracts, document registry, atlas links and prediction cases, review packets, XP artifact/branch rules, and security-service state. |
| S10: D584-D596a concrete API and native-toolchain closure | D584-D596a | owning language/toolchain/stdlib/rationale chapters and public admission/trace records | Exact declarations and matrices, checked projections, self-host entry and Stage 0-3 records, API/stdlib/package/Bridge/provider/dataset schemas, protocol/provider contracts, negative cases, portfolio evidence requirements, and the D609/D626 supersession boundary. |
| S11: D597-D614 remaining judgment and reference-evidence closure | D597-D608, D610-D612, D614; D609/D613 duplicate withdrawals | owning language/toolchain/stdlib/rationale/manifest chapters; infrastructure and compiler directions; CLI/formatter/diagnostic/migration/example records; typed intake and trace records | Exact generator-host gate, math owner/oracle records, explain schema, topology/reference-product evidence, three documentation modes and root-manifest precedence, debug event contract, grammar/migration changes, frontend ownership tables, intake transitions, negative cases, and duplicate-resolution links. |
| S12: D615-D625 distribution, analysis, development, publication, and experimental closure | D615-D616, D618-D621, D623-D625; D617/D622 duplicate withdrawals; D626 withdrawn by D596a | toolchain manifest/CLI/build/index/docs/testing chapters; project standards; installer, compiler, CI, infrastructure, and experimental directions | Bundled-distribution identity, deep-check engine schema, dev-event protocol, Apple and game workload matrices, analysis projection parity, foreign-build plan schema, individual-package and atomic-knot publication, exclusion/dependency closure, knot-first/package-complete index views, root XP opt-in and artifact identity, and duplicate/supersession links. |

**Extraction board status:** S1-S6 and S8-S12 have checked clause evidence and are `SPEC_EXTRACTED`; they do not derive completeness from trace rows alone. S7 is `WORKFLOW_ROUTED`: public standards and the service board exist, while website, repository split, showcase, and hosted-service implementation stay as later tracked infrastructure work.

Extraction board checklist:

- [x] S1: Lexical, grammar, declarations, and control flow has extracted chapters and checked clause evidence.
- [x] S2: Types, universes, generics, borrowing, and elaboration has extracted chapters and checked clause evidence.
- [x] S3: Failure, capabilities, concurrency, unsafe, ABI, layout, and backend has extracted chapters and checked clause evidence.
- [x] S4: Built-ins and source examples has extracted chapters and checked clause evidence.
- [x] S5: Toolchain CLI, diagnostics, formatter, tests, Analysis Server, artifacts, and package behavior has extracted chapters and checked clause evidence.
- [x] S6: Stdlib admission, containers, text, OS, concurrency, numerics, crypto, and transitional FFI has extracted chapters and checked clause evidence.
- [x] S7: Workflow, service board, website, examples, organization migration, package docs, showcase, and ProofTrace evidence graph has explicit nonsemantic homes; service implementation remains later infrastructure work.
- [x] S8: Formalization roadmap and claim boundaries has extracted material and checked clause evidence; recurring bidirectional calculus/spec correspondence remains later evidence work.
- [x] S9: D571-D583 normative text and D577 clause-registry entries are checked; atlas publication, recurring monthly/release review records, conformance, provider evidence, and the operational security service remain in their implementation/evidence phases.
- [x] S10: D584-D596a normative contracts and checked clause projections are present; concrete admission, self-host, provider, and Bridge evidence remains in later phases.
- [x] S11: D597-D614 normative and manifest text plus checked clause evidence are present; migration, conformance, workload measurements, and implementation evidence remain in later phases.
- [x] S12: D615-D625 normative text and checked clause evidence are present; schema migration, installer/index/platform implementation, conformance, admissions, workload evidence, and experimental-release enforcement remain in later phases.

**Completion verdict:** ✅ **COMPLETE.** Every accepted decision through D635 is covered by a checked D577 registry or explicit supersession, all generated extraction views are current, and Gate A is closed. Later implementation, conformance, admission, service, workload, and proof work does not reopen this phase unless it exposes a real specification contradiction.

**Exit rule:** Phase 1 is done only when every condition below is true:

- Gate A is closed only when every accepted point has a verified normative clause set or an explicit nonsemantic workflow/service destination; a destination alone is insufficient.
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

- 2.1. ✅ Freeze the first calculus scope in `kyokaicalculus/scope.md` and keep the theorem exclusions explicit.

- 2.2. ✅ Define the core syntax for variables, values, first-order functions, `let`, explicit consumption, borrow creation, borrow end, checked primitive operations, explicit TPOE, and minimal closed-sum/exhaustive-case support.

- 2.3. ✅ Define core types and universes: unrestricted/free values, linear resources, immutable borrows, mutable borrows, base integers/bools/unit, and any minimal optional/result form included in the core.

- 2.4. ✅ Define typing contexts explicitly: declaration context, unrestricted context, linear context, region/borrow context, and any dynamic-store typing needed by the semantics.

- 2.5. ✅ Define static rules for linear use, no drop, no duplicate, borrow exclusivity, borrow lifetime, capability-as-linear-value behavior, function calls, and checked operations.

- 2.6. ✅ Define dynamic semantics with deterministic evaluation order and terminal configurations for values, normal steps, and TPOE. Route runtime-fatal states to the later runtime/backend layer.

- 2.7. ✅ Prove preservation for all included reduction rules.

- 2.8. ✅ Prove progress-or-defined-failure: a well-typed configuration is a value, can step, or is in a defined terminal failure state such as TPOE.

- 2.9. ✅ Write the surface-to-core mapping for included features, especially `require`, `ensure`, `old`, UFCS-as-call, checked arithmetic, explicit cleanup states, and simple pattern control flow.

- 2.10. ✅ List exclusions explicitly: modules, packages, typeclasses, generics, FFI, allocators, formatting, OS, concurrency, atomics, channels, backend lowering, and unsafe reasoning.

- 2.11. ✅ Update the maintained public calculus artifacts and the formalization appendix whenever accepted shape adds a proof-relevant rule or a non-proof conformance obligation. The calculus docs must classify each rule as first-core theorem, surface elaboration, later extension calculus, separate concurrency model, unsafe/FFI boundary, backend-preservation obligation, stdlib evidence model, toolchain conformance model, workflow-only rule, or infrastructure-only rule.

- 2.12. ✅ Record the D488-D501 strict-linearity closure in the formalization map. D495 branch joins and D500 `build` lowering are surface/core obligations; D491 recovery payloads, D492 explicit bundles, D493 invocation classes, D496 hole-free collection APIs, D497 container universes, and D498 early release are later language/stdlib contract obligations; D488, D489, D494, D499, and D501 are tooling, test-harness, FFI-admission, or stdlib-evidence obligations rather than new `lambda_K-seq` theorem claims.

- 2.13. ✅ Record the D502-D529 closure in the formalization map as toolchain conformance, docs-process, authority-policy, resolver, official Bridge collection, or infrastructure obligations. These decisions do not enlarge the first sequential theorem. D502 and D508 constrain proof/spec writing discipline; D503-D505, D509, D515-D518, D525, D527, D528, and D529 constrain toolchain, stdlib, unsafe, and package conformance; D506-D507, D510-D514, and D519-D524 remain workflow or infrastructure boundaries. D526 adds evidence-graph validation and does not enlarge the theorem.

- 2.14. ✅ Maintain the expanded Gate-B derivation packages: `kyokaicalculus/close-and-witness-proof.md`, `kyokaicalculus/call-entry-proof.md`, `kyokaicalculus/primitive-admission-proof.md`, `kyokaicalculus/frame-typing-proof.md`, `kyokaicalculus/source-expression-proof.md`, and `kyokaicalculus/equivariance-proof.md`. Their L1-L40 and transition-family arguments are composed by `kyokaicalculus/theorem-assembly.md`, which is the paper-proof artifact that closes Gate B for `lambda_K-seq`.

- 2.15. ⬜ Expand executable evidence from local spot checks into a whole-machine runner that exercises typed configuration construction, continuation-frame transitions, ordinary completion, and intrinsic TPOE. The first twenty-five traces now cover linear-let discharge, both branch selections, arbitrary linear-sum movement, owned-call parameter discharge and returned-owner transfer, nested contract TPOE abandoned-carrier accounting, mutable-reborrow close and resumed access, read-reborrow close, direct immutable and mutable-borrow access, checked-primitive success and TPOE, capability attenuation, selected linear-sum payload consumption, successful contract checking, zero-argument call entry, source-ordered multi-argument call entry, zero-argument checked-primitive success and TPOE, explicit injection followed by linear-payload case discharge, free-payload case binding, unrestricted variable lookup, and returned-local-borrow rejection at region close. Broaden the runner alongside the paper derivations. Keep it labeled as executable evidence; it does not replace the paper proof.

**Completion verdict:** ✅ **COMPLETE for the narrow `lambda_K-seq` Gate-B paper-proof scope.** Item 2.15 is continuing executable evidence and does not reopen that scoped result.

**Exit rule:** This scoped phase is done because every condition below is true:

- Gate B is closed.
- The proof document is reviewable without relying on informal plan prose.
- Excluded features are named as future proof extensions, not hidden assumptions.
- The compiler's core IR/elaboration plan can point at the calculus for the sequential ownership core.

**May run in parallel with:** Parser/frontend bring-up after enough surface syntax is extracted.

**Must not do:** Try to prove the whole language in the first paper proof.

### Phase 3: Compiler Fork Identity And Frontend Surface Bring-Up

**Purpose:** Turn the Austral-shaped compiler into a Kyokai compiler at the source-language boundary.

**Dependencies:** Phase 1 lexical/syntax extraction. Phase 2 may be in progress.

**Status:** Complete for the Phase 3 source-language boundary. `compiler/frontend/KyokaiFrontend.ml` is the sole composition point from Kyokai source text through parsing, phase-local structural checks, and the derived declaration surface. `KyokaiPackageSource` invokes that frontend after manifest-rooted `.kyo` discovery and module/path validation; it does not call the inherited interface/body lexer, parser, or combining pass. The public executable, package metadata, Nix artifact, CI artifacts, and active editor boundary use Kyokai identity. The active frontend lives under `compiler/`, all inherited `lib/` modules have checked transition dispositions, and implementation-gated fixtures invoke an explicitly internal command. Resolution, complete cross-module visibility, `.koi`, typing, elaboration, ownership, backend behavior, released diagnostic codes, and public conformance remain later-phase work.

**Subparts:**

- **3.1. ✅ Kyokai identity migration.** The public executable, Dune/opam/Nix package, CI artifacts, active compiler paths, diagnostics for retired forms, and editor boundary use Kyokai identity. Accurate Austral names remain only on inherited bootstrap code, prior art, migration diagnostics, and comparison fixtures. The stale editor bundles were moved to the private prior-art corpus instead of being relabeled as Kyokai syntax.

- **3.2. ✅ Single-file modules and derived-interface handoff.** Source discovery and parsing enforce one `.kyo` file per logical module; reject `.kai`, `.aui`, `.aum`, handwritten `.koi`, and `module body`; and derive the in-memory public/internal surface consumed by Phase 4. `.koi` serialization and consumption are Phase 4 work, not a second Phase 3 parser gate.

- **3.3. ✅ Kyokai lexical surface.** The active lexer implements the grammar-reserved word set, contextual-word boundary, `//`/`///`/`//!` comments, numeric separators and closed suffixes, string/raw/code-point/byte literals, word borrow operators, punctuation, comptime embed names, source-byte validation handoff, and the named inherited-form rejection matrix. Documentation attachment belongs to the later docs/analysis boundary; token classification is complete for Phase 3.

- **3.4. ✅ Declaration and block terminators.** Parse `qed`, `build`, `seal`, `spec`, `od`, `fi`, `esac`, `join`, `pick`, `audit`, `drop`, `mon`, `wake`, and the other decided closures used by the represented surface. **Current state:** implemented in the active surface parser with nested block retention and focused host/fixture coverage.

- **3.5. ✅ Major surface constructs.** The surface AST and parser represent UFCS-shaped dot calls, record/union construction, patterns, fallible binding, loops, cleanup, borrow scopes, taskgroups, spawn, select/wait, debug, contracts, unsafe contracts, closures, build expressions, and inline tests. Inline tests retain descriptions, explicit capability parameters, bodies, spans, module-private visibility, and derived-interface exclusion. Typing, elaboration, ownership, cleanup semantics, test-runner lowering, and concurrency admission remain later checks.

- **3.6. ✅ Spans and later-completion handoff.** Source validation, tokens, imports, declarations, expressions, patterns, statements, and nested bodies retain byte and line/column origins. The surface AST keeps the source constructs that Phase 5 needs to create D239 completion records. Stable released diagnostic codes and the completion records themselves remain with Phases 5 and 8.

- **3.7. ✅ Rejected inherited syntax.** Lexer, parser, source-role, and compiler-stage negative tests cover retired source extensions, `module body`, explicit `private`, Austral comments/not-equal/base prefixes and borrow spellings, block comments, apostrophe separators, compound suffixes, platform-shaped character literals, wildcard patterns/imports, retired docstring syntax, pipeline syntax, and arrow field access. Kyokai has no default-mode Austral compatibility path.

- **3.8. ✅ Fixture synchronization and claim separation.** Keep public compiler/package fixtures synchronized with decided syntax and keep historical comparison material outside public conformance claims. **Current state:** current fixtures validate and the compiler-stage runner labels all thirty-one results as implementation-gated supporting evidence rather than conformance-backed status.

- **3.9. ✅ D592a/D612 transition preparation.** `docs/compiler-transition-inventory.toml` assigns every inherited OCaml source/interface module exactly one semantic disposition and one implementation-language disposition. `docs/compiler-pipeline-inventory.md` maps every active Phase 3 path to its target owner. The maintainer dashboard names every entry row and records the honest `NOT_READY` state before a first slice is selected; it remains private and is not a clean-checkout dependency. The public Phase 14 completion verdict carries the corresponding open state. The Phase 3 identity checker rejects missing, overlapping, or invalid public classifications without reading maintainer-local files.

- **3.10. ✅ Repository-root classification and cleanup.** Research and prior art live under the workspace `material/` taxonomy; private directions, budgets, notes, issues, and side-project records live under `project/`; active repository-root files are authority, build, license, public status, or session entry documents. Generic generated remnants and the obsolete roadmap were removed, and public-path references were updated.

- **3.11. ✅ Phase 3 implementation-tree migration.** Active Kyokai frontend and package-source code lives under `compiler/`; CLI/bootstrap adapters and evidence tools live under `toolchain/`; host and public fixture assets retain explicit test owners. The inherited flat `lib/` tree remains only as a classified bootstrap for later pass-by-pass replacement. Future phases move their active subsystems when touched and cannot use Phase 3 closure as permission for a flag-day rewrite.

- **3.12. ✅ Adversarial corpus root and schema.** Establish `examples/adversarial/` with a public case schema and evidence boundary before language implementation hardens. **Current state:** the public root, README, and schema are present. Executable case families enter only with real implementation-gated or runnable cases in their owning phases; no empty family scaffolds count as progress.

**Completion verdict:** ✅ **COMPLETE for the Phase 3 source-language, identity, and ownership boundary.**

**Exit rule:** Phase 3 is done only when every condition below is true:

- Basic Kyokai source files parse through `KyokaiFrontend` with stable source spans.
- The named old Austral source roles, tokens, borrow spellings, and grammar forms are rejected by negative tests.
- Host tests and 31 implementation-gated fixtures cover accepted and rejected forms.
- The public binary/package/CI identity and active module roots no longer present accidental Austral branding.
- Root research, prior art, private direction, budgets, and notes have explicit owners.
- Every active Phase 3 path has a declared target owner, and every inherited OCaml module has both transition dispositions.

**May run in parallel with:** Phase 4 resolution/`.koi` work and toolchain skeleton work that consumes the frontend boundary without redefining it.

**Must not do:** Keep inherited syntax because it is easier unless the plan says Kyokai kept it.

### Phase 4: Name Resolution, Imports, Packages, And Interface Artifacts

**Purpose:** Implement Kyokai's compilation unit, package, visibility, and lookup rules before deep typing makes them harder to change.

**Dependencies:** Phase 1 declaration/toolchain extraction and Phase 3 parser support.

**Status:** Not started. The package/spec gate is open.

**Subparts:**

- 4.1. ⬜ Implement module identity, package identity, module root layout, and import path resolution.

- 4.2. ⬜ Implement the single-file module rule (D537): one `.kyo` source file per module and the compiler-derived `.koi` interface, replacing interface-body pairing.

- 4.3. ⬜ Implement per-declaration visibility (D538): `public`, `internal`, private-by-default, rejection of an explicit `private` marker, package boundary checks, the `opaque` representation modifier (D539), import collision errors, and explicit `as` renaming.

- 4.4. ⬜ Implement ordinary name lookup exactly as specified before UFCS fallback is added.

- 4.5. ⬜ Implement D254 receiver-module UFCS fallback only after ordinary lookup finds no candidate.

- 4.6. ⬜ Implement the remaining package/workspace manifest surface, expand final resolver graph construction beyond workspace-only graphs, complete deterministic lockfile reading/writing/repair for every D528 source kind and mode, workspace member discovery, target/profile selection, and source file discovery.

- 4.7. ⬜ Implement `.koi` interface artifact generation and consumption for package-level separate compilation.

- 4.8. ⬜ Implement package-level generic/typeclass metadata requirements for downstream instantiation under the D82/D82a/D82b family.

- 4.9. ⬜ Add cycle detection, duplicate logical-module detection, and reproducible artifact identity checks.

**Completion verdict:** ⬜ **OPEN.**

**Exit rule:** Phase 4 is done only when every condition below is true:

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

- 5.1. ⬜ Define the compiler's typed core IR and explicitly document which surface constructs elaborate into it.

- 5.2. ⬜ Implement D238 pass order:

1. Parse source into surface AST.
2. Perform syntax-only lowering that does not need type facts.
3. Resolve names and call shapes.
4. Type-check and elaborate expressions.
5. Insert D87 implicit completions as explicit elaboration nodes.
6. Record every implicit completion in the compiler-maintained registry.
7. Run the D239 tautology-check pass over those elaboration nodes.
8. Lower typed sugar.
9. Run linearity, borrow, capability, contract, unsafe, and backend-readiness checks.

- 5.3. ⬜ Implement universes and kind rules for `Free`, `Linear`, and `Auto`.

- 5.4. ⬜ Implement records, unions, aliases, newtypes, fixed arrays, optional/result shapes, `Never`, and built-in types.

- 5.5. ⬜ Implement generics, const generics, monomorphization ownership, static dispatch, typeclasses, associated types, default methods where specified, coherence, and orphan rules.

- 5.6. ⬜ Implement literal typing, D12 bidirectional literal inference, D261 suffix typing, and all numeric representability checks.

- 5.7. ⬜ Implement expression typing for calls, UFCS, indexing, bitwise keyword operators, arithmetic variants, comparisons, boolean operations, ranges, casts/conversions, and format DSL checks.

- 5.8. ⬜ Implement pattern typing for `case`, `let...else`, `while let`, destructuring, exhaustive matches, and no-shadowing.

- 5.9. ⬜ Implement contract typing for `require`, `ensure`, `old`, and TPOE-producing checks.

- 5.10. ⬜ Implement typed sugar lowering for `or return`, `or break`, `or continue`, `for-in`, `while let`, UFCS, field auto-deref, and auto-reborrow.

- 5.11. ⬜ Build a conformance view that can show the elaborated core for tests and debugging.

**Completion verdict:** ⬜ **OPEN.**

**Exit rule:** Phase 5 is done only when every condition below is true:

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

- 6.1. ⬜ Port and adapt Austral's linearity checker only after reading its actual source and tests.

- 6.2. ⬜ Implement linear states for available, moved/consumed, borrowed, deferred, and errdeferred values.

- 6.3. ⬜ Implement explicit consumption rules, no implicit drop, no duplicate use, linear field movement, linear destructuring, and all exit-path consumption checks.

- 6.4. ⬜ Implement immutable and mutable borrow creation, anonymous-by-default regions, explicit region syntax where needed, borrow end, and conflict checking.

- 6.5. ⬜ Implement auto-reborrow and field auto-deref only as elaborated nodes that the checker can see.

- 6.6. ⬜ Implement D240 conformance tests for auto-reborrow/read-reborrow success, failure, nested calls, field paths, temporary lifetimes, and linear payloads.

- 6.7. ⬜ Implement `defer` and `errdefer` ordering, checker states, cleanup insertion, and interaction with `or return` / structured error exits.

- 6.8. ⬜ Implement capability declarations as sealed authority values that unsafe code cannot forge.

- 6.9. ⬜ Implement task-transfer and task-local classifications for types, capabilities, and runtime handles.

- 6.10. ⬜ Implement unsafe-module checking: `pragma Unsafe_Module`, `UnsafeCapability`, raw operations, volatile, asm, FFI, and required `unsafe contract ... audit;` coverage.

- 6.11. ⬜ Implement contract checks for `require`, `ensure`, asserts, bounds checks, overflow checks, and TPOE categories.

- 6.12. ⬜ Add the first ownership-pressure cases for arena escape/reset, ECS mutation during iteration, stale generational handles, scene-graph reparenting, retained callback capture, linear-container early exit/drain, transactional asset failure, and task capture/spawn failure. Each case includes a plausible wrong-checker mutation it must reject.

**Completion verdict:** ⬜ **OPEN.**

**Exit rule:** Phase 6 is done only when every condition below is true:

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

- 7.1. ⬜ Define generated-C lowering contracts for every core operation in the extracted spec.

- 7.2. ⬜ Implement D84 termination categories: normal return, recoverable `Result` values, TPOE, `panic`, runtime-fatal/internal failure, and OS process exit.

- 7.3. ⬜ Implement TPOE and panic paths as hard process termination, not recoverable exceptions.

- 7.4. ⬜ Implement stack overflow detection for hosted and freestanding targets using guard pages, probes, bounds checks, or an equivalent documented mechanism before corruption.

- 7.5. ⬜ Implement integer operations with defined overflow, checked, wrapping, saturating, modular, shift, rotate, divide-by-zero, and representability behavior.

- 7.6. ⬜ Implement floating semantics, NaN handling, classification, conversion, and math edge cases according to admitted contracts.

- 7.7. ⬜ Implement record, union, enum/tag, packed-record, extern-record, and address lowering without layout folklore.

- 7.8. ⬜ Implement memory operations, allocator calls, pointer/address operations, volatile operations, atomics, fences, and barriers with target contracts.

- 7.9. ⬜ Implement C backend emission patterns that avoid signed overflow UB, invalid shift UB, invalid aliasing assumptions, invalid enum values, uninitialized reads, invalid pointer provenance assumptions, and fallthrough into unreachable states.

- 7.10. ⬜ Add conformance tests that inspect generated C for known-dangerous patterns and execute edge cases under sanitizers across admitted compiler families.

- 7.11. ⬜ Implement D531's C11 subset checker and generated-source schema.

- 7.12. ⬜ Implement the D532 admission schema, stable-conformance-ID projection, frozen generated-C/runtime bundle, and structural/probe harness for GCC/Clang Linux, Apple Clang macOS, clang-cl Windows, and Clang FreeBSD. This phase may produce experimental records, but it does not admit a compiler before the full Phase 13 matrix executes.

- 7.13. ⬜ Implement D533 source maps, debugger path substitution, symbolization, sanitizer mapping, Kyokai-level coverage IDs, and profiler mapping.

- 7.14. ⬜ Implement D534 deterministic split C units, object caching, prebuilt stdlib/Bridge objects, parallel compilation, incremental linking, and benchmark reporting.

- 7.15. ⬜ Implement D535 reproducible external-tool build plans, raw-log retention, and family-specific diagnostic normalization.

- 7.16. ⬜ Add adversarial generated-C observations and deliberate wrong-lowering mutations for evaluation order, cleanup order, checked arithmetic/ranges, invalid storage, provider identity, and fatal paths. These tests use public compiler output and never a private semantic shortcut.

**Completion verdict:** ⬜ **OPEN.**

**Exit rule:** Phase 7 is done only when every condition below is true:

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

**Implementation-language boundary:** Phase 8 defines the final command contracts,
schemas, diagnostic identities, harnesses, and shared service boundaries. Before
the D592a entry review, OCaml may contain only thin bootstrap adapters needed to
compile, inspect, and test the first Kyokai-native slice. Formatter, docs,
package/build, audit, Analysis Server, migration, replay, and other shipped
toolchain implementations are ordinary Kyokai work begun through Phase 14 after
the entry review passes; temporary host adapters have explicit retirement rows.

**Subparts:**

- 8.1. ⬜ Implement `kyokai check` as the first reliable command.

- 8.1a. ⬜ Freeze the bootstrap-adapter boundary for `check`, compile/build invocation, diagnostics, and test execution. Record which endpoints are temporarily hosted in OCaml, which schemas are implementation-independent, and which Kyokai-native component replaces each endpoint. Do not implement a second permanent toolchain merely to reach self-hosting.

- 8.2. ⬜ Implement `kyokai --version` and `kyokai doctor` so users can report the exact toolchain identity, host facts, configured paths, target compiler availability, cache paths, package index state, and actionable environment failures without guessing.

- 8.3. ⬜ Implement `kyokai init` and `kyokai new` with deterministic templates, explicit package layout, selected profile/edition/target defaults, and no hidden network access.

- 8.4. ⬜ Implement `kyokai build`, `run`, and profile/target selection after package loading and backend invocation are stable.

- 8.5. ⬜ Implement `kyokai test` with inline test blocks, production-build exclusion, test filtering, failure reporting, deterministic listing, failed-test rerun, property/fuzz seed selection, replay tokens, corpus directories, and minimization controls. Test-only behavior must never become hidden language behavior.

- 8.6. ⬜ Implement `kyokai fmt` as deterministic, idempotent, and zero-configuration.

- 8.7. ⬜ Import every existing diagnostic into `toolchain/diagnostics/registry.toml`; implement monotonic allocation, lifecycle and compatibility checks, generated compiler/catalog/test tables, source spans, notes, suggestions, warning categories, project suppression, JSON output, local explanation, and safe fixes. A released tool cannot emit an unregistered code. Human rendering uses the D503 semantic Kyokai palette with explicit true-color, limited-color, monochrome, `NO_COLOR`, and machine-output tests; color never replaces severity words, codes, symbols, or spans.

- 8.8. ⬜ Implement `kyokai doc` from docstrings and interfaces, including generated stdlib documentation. Local docs generation writes package-root `kdocs/` by default, emits versioned docs JSON and HTML, validates the closed docs tag set, runs doc-test classification only for execution-admitted examples, and supports `kyokai doc --check`, `kyokai doc --open`, and `kyokai clean docs` without hidden network access.

- 8.9. ⬜ Implement `kyokai audit` for unsafe modules, package unsafe surfaces, capability requirements, and dependency review.

- 8.10. ⬜ Implement lints inside the compiler, including ownership-signaling naming warnings.

- 8.11. ⬜ Implement conformance-test runner layout: parser tests, type tests, negative tests, backend execution tests, diagnostic goldens, property/fuzz replay tests, and stdlib contract tests.

- 8.12. ⬜ Sync public examples and compiler fixtures against the decided spec and exclude obsolete comparison material from conformance claims.

- 8.13. ⬜ Implement the Analysis Server as a shared compiler-engine service, with `kyokai lsp` as the protocol frontend rather than a second analyzer. The server must share parser, resolver, type checker, borrow checker, capability checker, target-guard evaluator, `.koi` reader, formatter, diagnostic catalog, and fix metadata with `kyokai check`.

- 8.14. ⬜ Add Analysis Server protocol and DX tests for source snapshots, cancellation, edit ordering, manifest/workspace discovery, CLI-compatible diagnostics, semantic tokens, completion, hover, rename safety, code actions, formatter integration, generated-source boundaries, package graph facts, docs facts, `.koi`/KBI facts, and lowering/debug views. The fixture matrix includes single-file `.kyo` module editing with derived-interface navigation, public-signature preview against the derived `.koi`, stale-`.koi` diagnostics, terminator-preserving folding/selection/matching/repair, accepted import-form insertion, callback capture/class hover, capture-primary diagnostics, and blocking/try/deadline/poller completion grouping.

- 8.15. ⬜ Implement `kyokai explain` and `kyokai fix` as compiler-fact tools, not prose wrappers. `explain` reads the shipped diagnostic catalog and compiler facts. `fix` applies only checked safety classes, rejects stale or overlapping edits, reruns parsing/formatting validation, and shares fix IDs with diagnostics, JSON output, and the Analysis Server.

- 8.16. ⬜ Implement `kyokai audit` over package, source, dependency, unsafe, FFI, capability, generation, reproducibility, documentation, and public-API facts. Audit policy can promote named categories to errors, but audit never grants authority or changes language legality.

- 8.17. ⬜ Freeze the separately released Bleedring protocol and bootstrap implementation boundary. Bleedring is written in Kyokai and installs exact complete Kyokai distributions plus separately identified admitted native-compiler provider bundles. Implement checksum/provenance/license verification, safe bounded extraction, atomic install/update/removal, isolated distribution/provider roots and caches, offline artifacts, version/schema reporting, and doctor visibility. It does not mix Kyokai compiler/toolchain component versions, edit project manifests/provider choice, depend on ambient PATH, invoke an OS package manager silently, or maintain rustup-style directory/workspace override semantics.

- 8.18. ⬜ Implement local REPL, eval, scratch, and development-service command boundaries only through ordinary compiler semantics and explicit sandbox/profile records. These tools start with no ambient capabilities and do not create a second scripting language.

- 8.19. ⬜ Implement ProofTrace tooling integration for spec chapters, maintained code-boundary markers, conformance records, generated public status, Analysis Server navigation, docs presentation, and audit reporting. Passing ProofTrace metadata checks remains evidence about registry consistency only.

- 8.20. ⬜ Add command-matrix tests for network policy, prompt legality, stream routing, exit classifications, human-output lanes, JSON/JSON-lines schemas, cache/output roots, `KYOKAI_CACHE=off`, `--offline`, and `--color=machine`.

- 8.21. ⬜ Implement capability deny-policy loading, normalization, diagnostics, and command enforcement for the first CLI lanes. This includes toolchain defaults, `$XDG_CONFIG_HOME/kyokai/config.toml` or `~/.config/kyokai/config.toml`, manifest ceilings, repeated `--deny-capability <name>` flags, strictest-policy composition, unknown-name rejection, verbose/machine-output reporting, and diagnostics that name the denied capability, policy source, requiring surface, and dependency or generation path.

- 8.22. ⬜ Implement the D541 generated-API projection request/result protocol, atomic generated-tree replacement, stable generated-symbol identities, source/projection maps, drift checking, and Analysis Server/docs/audit consumption without creating compiler plugins or macros.

- 8.23. ⬜ Implement D544 edition migration plan, apply, and recovery commands with edit safety classes, preimage verification, `.koi`/lockfile/configuration reporting, generated-input regeneration, transaction journals, and mixed-edition validation.

- 8.24. ⬜ Implement D545 authority requirement graphs and narrow repair actions across CLI, diagnostics, Analysis Server, CI, and audit. Machine-applicable repairs preserve the effective deny ceiling and never create authority or widen policy.

- 8.25. ⬜ Add D546 deterministic service-simulation lanes and evidence labels that distinguish simulated, headless real-system, target-matrix, device, and production-equivalence claims.

- 8.26. ⬜ Build the semantic-atlas maintenance pipeline: authored explanations and diagrams, generated stable node/clause links, accepted-boundary and revision identity, prediction exercises, drift checks, and review status. Atlas authoring may begin earlier, but it is not called current until these checks bind it to the normative revision.

- 8.27. ⬜ Implement XP evidence plumbing for authorized experiments: XP record validation, isolated branch/channel identities, required conformance/security/workload tests before experimental merge, artifact/cache/schema separation, weekly-build manifests, expiry, result packets, and stable-carried root-manifest opt-in. The harness cannot accept semantics or graduate an XP.

- 8.28. ⬜ Implement compiler-admission schema and corpus projection beside the conformance runner. Admission bundles reference stable Kyokai semantic IDs and exact source/runtime/toolchain identities; they do not copy the frontend, duplicate expected semantics, or issue final admissions before Phase 13.

- 8.29. ⬜ Implement `kyokai deep-check` as an orchestrator for the closed named engines: `core`, `ownership`, `generated-c`, `sanitizer`, `schedule`, and `differential`. Every engine has separate prerequisites, supported operations, budgets, evidence class, replay identity, findings, skips, and false-positive policy; named profiles select explicit sets, and the command never silently runs every expensive engine or flattens their claims into one pass/fail bit.

- 8.30. ⬜ Implement `kyokai dev` as the foreground, generation-ordered development supervisor. It watches only resolved declared roots, reconciles watcher hints against containment-checked snapshots, cancels stale work, uses adapter-declared reload classes, commits migrations transactionally, owns killable process trees, records authority and configuration, and tests atomic saves, rename storms, delete/recreate, symlink attacks, concurrent changes, stale completion, adapter failure, port conflict, crash loops, and interrupted shutdown. It is not a required global daemon or hidden application runtime.

- 8.31. ⬜ Index `examples/adversarial/` through the unified result protocol, enforce budgets and explicit skips, run the fast assigned subset in PR lanes, and route mismatches into the typed finding registry. Preserve the corpus's evidence class instead of counting it as proof or whole-language conformance.

- 8.32. ⬜ Implement the D628 knowledge-manifest schema and D634 typed implementation-finding registry/generator. PR templates require finding disposition; release tooling binds spec/toolchain/schema/calculus/proof/D-point/XP/provider identities and creates the append-only post-release review record.

**Completion verdict:** ⬜ **OPEN.**

**Exit rule:** Phase 8 is done only when every condition below is true:

- Contributors can run one command to check language conformance tests.
- Diagnostics are stable enough for golden tests, local explanation lookup, and checked machine fixes.
- Formatter output is canonical.
- `kyokai --version`, `doctor`, `init`, `new`, and test replay controls expose deterministic state instead of relying on tribal knowledge.
- Docs, LSP, audit, explain, fix, and ProofTrace output are generated from compiler-understood facts, not hand-maintained guesses.
- Capability deny policy is enforced by command tests rather than documented only as a planned policy.
- `bleedring` can verify, install, replace, and diagnose exact bundled Kyokai distributions and exact admitted native compiler providers without mixing Kyokai component versions, changing project policy, using ambient PATH, or touching package caches as a side effect.
- Analysis Server behavior is test-backed against the same semantic engine as the CLI.
- Official editor tooling preserves written terminators and passes module/derived-interface, import, callback-capture, and operation-family DX fixtures without defining alternate syntax.
- Human CLI and diagnostic rendering passes semantic-palette, limited-color, monochrome, `NO_COLOR`, and machine-output fixtures.
- Every shipped toolchain component is ordinary Kyokai source or an explicitly temporary bootstrap adapter with a named replacement and retirement condition.
- Semantic-atlas, XP, and compiler-admission harness records are schema-checked and cannot silently grant semantic, release, or support authority.
- `deep-check` preserves each engine's prerequisites, scope, evidence, and replay identity; `kyokai dev` passes generation-order, containment, authority, reload, and hostile-watcher tests without becoming a daemon or runtime.

**May run in parallel with:** Standard library implementation once core compiler checks are usable.

**Must not do:** Let tooling hide compiler errors or provide behavior the compiler cannot enforce.

### Phase 9: Core Standard Library Foundation

**Purpose:** Admit the safe pure and low-level foundation modules required by real programs.

**Dependencies:** Phase 5 for typing, Phase 6 for linearity, Phase 7 for
runtime/backends, and the Phase 8 runner/report slice required by each module.
The rest of Phase 8 is not a blanket blocker for core-library work.

**Status:** Not started. D229 stdlib admission is open.

**Implementation language:** Every ordinary core-library module is written in
Kyokai and checked by the same compiler rules as user code. OCaml may host the
bootstrap compiler, but an OCaml helper is not a standard-library
implementation. Unsafe Kyokai internals, narrow runtime primitives, and
transitional FFI remain visible under their separate admission policies.

**Subparts:**

- 9.1. ⬜ Establish the stdlib module layout under `Kyokai.*` and retire inherited `Standard.*` naming from public Kyokai APIs.

- 9.1a. ⬜ Select the first bootstrap-safe Kyokai module slice and compile it through the real frontend, checker, generated-C path, and Phase 8 test runner. Move modules one admission packet at a time; do not port the inherited `standard/` tree wholesale or count an OCaml substitute as progress.

- 9.2. ⬜ Implement `Unit`, `Bool`, fixed integers, floats, `Index`, `Optional`, `Result`, `Never`, `Pair`, `Triple`, and domain-named result types where needed.

- 9.3. ⬜ Implement `Span`, `Array`, `Buffer`, `String`, `StaticString`, byte strings, UTF-8 validation, ASCII helpers, Unicode base helpers, and string/span comparison.

- 9.4. ⬜ Implement `Equality`, `Order`, `Hashable`, `Displayable`, `FormatSink`, `StandardError`, `Parsable`, and related typeclass instances.

- 9.5. ⬜ Implement allocator interfaces and core allocators with explicit value-level allocator choice and no hidden default allocator.

- 9.6. ⬜ Implement formatting: allocating `format`, sink-based `writeFmt`, interpolation rules, checked formatter DSL, and exact allocation/failure behavior.

- 9.7. ⬜ Implement integer math, bitwise helpers, endian transforms, byte encode/decode, sorting, hashing, and pure algorithms without FFI unless admission policy says otherwise.

- 9.8. ⬜ Implement floating math under D232 accuracy contracts, with test vectors and explicit edge-case behavior.

- 9.9. ⬜ Implement collections: linear-safe `HashMap`, sets, queues/deques where admitted, iterator support, and explicit destroy/drain behavior for linear payloads.

- 9.10. ⬜ Implement eager iterator helpers, fused iteration contracts, and linear iterator finalization under D249.

- 9.11. ⬜ Apply D229 admission records to every module: contract, edge cases, oracle/test source, unsafe/FFI policy, compatibility boundary, and release status.

- 9.12. ⬜ Implement the D540 owner/handle/view foundation for admitted slot maps and framework graphs: nominal owners and handles, generation exhaustion, slot retirement, mutation epochs, invalidation failures, linear payload removal, task-transfer rules, persistent-identity separation, property tests, docs, and debugger facts.

- 9.13. ⬜ Implement D549 dataset-provider foundations for Unicode and other pure behavioral tables with version, digest, provenance, compatibility, cache, offline, and explicit update identities.

- 9.14. ⬜ Admit the pure foundations required by D551-D553 application domains: streaming codecs, URI/header/protocol value types, command schemas, terminal layout/text-width primitives, retained-state contracts, geometry/color/image foundations, and deterministic simulation/snapshot hooks. Frameworks remain separately admitted packages or Bridge entries.

- 9.15. ⬜ Author and admit the D584-D592 packets needed by the first self-host slice: `Result`/`Optional`/error/display/parse, `TextView[R]`, allocator/storage, selected collections, native TOML 1.0, CLI schema, replay/property support, and explicit observability where the chosen slice uses it. Do not require unrelated APIs merely to inflate an entry percentage.

**Completion verdict:** ⬜ **OPEN.**

**Exit rule:** Phase 9 is done only when every condition below is true:

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

**Implementation language:** Safe OS and systems APIs are Kyokai modules.
Platform interaction uses audited unsafe Kyokai wrappers, explicit foreign
declarations, and the smallest necessary C/assembly/runtime shims. Host-language
helpers do not become the public systems standard library.

**Subparts:**

- 10.1. ⬜ Implement `RootCapability`, terminal, filesystem, process, environment, clock, random, network, signal, and platform capabilities.

- 10.2. ⬜ Implement paths, OS strings, C strings, byte spans, file descriptors/handles, sockets, process IDs, exit statuses, and platform error types.

- 10.3. ⬜ Implement safe file I/O: open/read/write/close/stat/readlink/access/directory operations with linear handles and explicit partial-read/write behavior.

- 10.4. ⬜ Implement process spawning, pipes, dup/redirect operations, wait/status observation, supervised worker process patterns, and no in-process panic/TPOE catching.

- 10.5. ⬜ Implement networking: TCP/UDP sockets, address parsing, DNS policy if admitted, listener/connection lifecycle, and explicit blocking/non-blocking operations.

- 10.6. ⬜ Implement `Poller` and readiness-backed APIs. Blocking cancellation is cooperative only through Poller-backed or explicitly readiness-backed operations.

- 10.7. ⬜ Implement `SignalWatcher` as the safe signal surface. Raw handler registration remains unsafe-only. Synchronous fault signals are runtime-fatal.

- 10.8. ⬜ Implement volatile/MMIO APIs for the closed legal type domain under unsafe operation-level contracts.

- 10.9. ⬜ Implement FFI wrappers for OS boundaries with explicit ABI records, ownership-transfer wrappers, sum-type translations, and unsafe audit contracts.

- 10.10. ⬜ Track transitional FFI wrappers under D230 with replacement criteria and do not let them become unreviewed permanent stdlib internals.

- 10.11. ⬜ Implement D549 target-observed and network-updated provider adapters for tzdb, locale, trust roots, revocation, public suffix, MIME, and related behavioral datasets with explicit capabilities, signature/provenance verification, freshness, expiry, offline behavior, and fail-closed activation.

- 10.12. ⬜ Implement D551 server foundations: HTTP/TLS/protocol contracts, streaming and backpressure, cancellation, structured shutdown, database pool and migration primitives, observability context propagation, and deterministic service fixtures without hidden ambient runtime authority.

- 10.13. ⬜ Implement D552 CLI/TUI foundations: command-schema projection, help/completion/man-page output, terminal capability detection, raw-mode restoration, signal-safe teardown boundaries, event decoding, grapheme/display-width behavior, accessibility metadata where representable, and deterministic frame/event replay.

- 10.14. ⬜ Run the first D592a self-host entry review as soon as the selected slice's exact Phase 4-10 dependencies pass. Record every dashboard row, admitted bootstrap C-toolchain tuple, package/build and recovery exercise, and explicit non-dependency. Passing this review unblocks Phase 14 in parallel with remaining Phase 10-13 work; failing it creates concrete repairs and does not invite a toy self-host exception.

**Completion verdict:** ⬜ **OPEN.**

**Exit rule:** Phase 10 is done only when every condition below is true:

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

**Implementation language:** Concurrency APIs and their ownership-facing logic
are Kyokai stdlib/runtime code. Only admitted OS primitives, atomics, startup,
and unavoidable low-level shims sit below that source boundary.

**Subparts:**

- 11.1. ⬜ Implement 1:1 OS-thread task creation with explicit spawn failure handling or pre-reserved task capacity.

- 11.2. ⬜ Implement `taskgroup do ... join;` as the only safe structured spawn boundary.

- 11.3. ⬜ Implement spawn capture lists: by-value copy for `Free`, by-value transfer for eligible `Linear`, immutable borrow for allowed shared forms, and no `&!` capture.

- 11.4. ⬜ Implement task-boundary classifications: `task_transfer`, `task_local`, and standard-library handle/capability contracts.

- 11.5. ⬜ Implement memory orders, atomics, fences, and the closed happens-before inventory from D247.

- 11.6. ⬜ Implement `Mutex[T]`, `RwLock[T]`, poisoning policy if any, lock lifecycle, lock guards, and linear payload interaction.

- 11.7. ⬜ Implement SPSC channels with explicit capacity constructors, close/drain behavior, blocking and non-blocking operation names, and failure types that return linear values on failed send.

- 11.8. ⬜ Implement `select ... when ... do ... pick;` for multi-channel waiting with explicit non-priority selection semantics.

- 11.9. ⬜ Implement broker-pattern library helpers over SPSC channels without adding MPSC/MPMC/broadcast endpoint primitives.

- 11.10. ⬜ Implement cancellation tokens and cooperative cancellation for Poller-backed operations.

- 11.11. ⬜ Add stress tests for ownership transfer, task-local rejection, channel closure/drain, select fairness/non-priority semantics, atomics, locks, and process-fatal panic/TPOE behavior.

- 11.12. ⬜ Implement D540/D546 shared-owner service and simulation patterns over structured concurrency without cloneable framework owners, hidden callback runtimes, or weakened cancellation/join obligations.

- 11.13. ⬜ Implement D551-D553 background-work and UI/message boundaries with explicit owner transfer, main-thread or executor affinity, backpressure, cancellation, reentrancy, and teardown contracts.

**Completion verdict:** ⬜ **OPEN.**

**Exit rule:** Phase 11 is done only when every condition below is true:

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

**Implementation-language boundary:** Resolver libraries, local package/build
commands, docs generation, audit, publishing plans, and other distributed
toolchain code are ordinary Kyokai-native components once the Phase 10.14 entry
review permits their slice. Before that point, this phase may build schemas,
fixtures, static data, service records, and minimum bootstrap adapters, but it
does not authorize a permanent OCaml package manager or product toolchain.
Hosted website/index/community services keep their own implementation and
deployment records; they do not become compiler code by association.

**Subparts:**

- 12.1. ⬜ Implement `kyokai add`, `remove`, `update`, `search`, `info`, `tree`, `why`, `outdated`, `vendor`, and `publish`, plus package cache behavior, D528 lockfile modes, workspace dependency references, pinned Git revisions, indexed package version requirements, and offline metadata reporting.

- 12.2. ⬜ Implement the official read-only ecosystem index with knot-first main discovery, a separate complete package section, knot and package detail pages, exact membership/dependency projections, index snapshot identity, direct package and knot resolution metadata, and distinct append-only package/knot yanks.

- 12.3. ⬜ Implement the final package resolver as a PubGrub-family incompatibility-learning solver or SAT-equivalent engine that preserves Kyokai's public solution and conflict-explanation contract. Resolver inputs include manifests, selected roots, lockfile mode, target/profile, selected feature roots, index snapshots, offline/network policy, yanks, advisories, authority ceilings, effective capability deny policy, and explicit graph-affecting command flags.

- 12.4. ⬜ Implement deterministic `kyokai.lock` read/write over `[lock]`, `[[root]]`, `[[package]]`, and `[[edge]]` record families. Lock repair validates and normalizes formatting without changing graph meaning; graph-changing commands regenerate the graph through the resolver.

- 12.5. ⬜ Implement package graph inspection so users can see why a dependency is present, which version or exact revision selected, which feature, target/profile, yank, advisory, or capability-deny inputs affected it, and whether the answer came from the lockfile, local cache, vendor directory, or remote index.

- 12.6. ⬜ Implement package audit surfaces for unsafe modules, capabilities, FFI, build-time code generation, dependency authority, vendored source, and package-index provenance.

- 12.6a. ⬜ Implement Bridge collection metadata consumption without adding Bridge code yet: package search cross-links, docs/audit display, admission-record schema checks, license/provenance inventory validation, capability-deny reporting, and module-resolution diagnostics for installed `Kyokai.Bridge.*` entries. Actual Bridge entry source, copied support code, and ports remain blocked behind self-hosting work by D529 scheduling.

- 12.7. ⬜ Implement SemVer checking for public API changes and stdlib compatibility policy under language editions.

- 12.8. ⬜ Implement manifest-declared build-time code generation and `@embedFile` without hidden execution authority.

- 12.9. ⬜ Implement release artifact generation, checksums, provenance, official CI setup action, OCI images, and portable installation contract.

- 12.10. ⬜ Implement package-root docs publication, knot overview/dependency projections, search indexing, and generated API-reference integration.

- 12.11. ⬜ Implement Compiler Explorer integration and sandbox-runner contract. Hosted playground remains optional until the sandbox contract is real.

- 12.12. ⬜ Implement repository-owned package documentation publication. Published packages commit `kdocs/` under each package root at the exact indexed Git revision; `kyokai publish --dry-run` validates the staged release record and `kdocs/`; `kyokai publish` generates a ready-to-submit package-index PR/MR payload instead of uploading docs into Kyokai storage.

- 12.13. ⬜ Implement package-graph capability deny checks for dependency resolution, package-index metadata, docs-index metadata, generated packages, publish validation, and audit reports. Denied authority requirements must report the exact graph path or artifact source and must not be downgraded to warnings in CI policy lanes that select fatal denial.

- 12.14. ⬜ Implement package-index documentation metadata as compact discovery records. The index stores package identity, version, repository URL, exact revision, package-root path, source digest, `kdocs/manifest.toml` digest, docs-schema version, raw-file adapter class, docs status, and deterministic search projection. It does not store full documentation trees.

- 12.15. ⬜ Implement official package-doc rendering over verified structured data. The website or package-doc route retrieves files from the exact indexed revision through reviewed forge raw-file adapters or pinned Git fetches, verifies digests and schema compatibility, renders through the official renderer, and never injects publisher-controlled HTML, scripts, stylesheets, or active embeds into the Kyokai origin.

- 12.16. ⬜ Implement docs status reporting and local docs cache behavior. Docs pages and tools report `verified`, `missing`, `stale`, `malformed`, `schema-incompatible`, `digest-mismatch`, `target-context-mismatch`, `untrusted-revision`, or `browser-render-unavailable`; `kyokai docs --pull <pkg>` and `kyokai docs --pull all` populate the local cache by explicit network-capable action only.

- 12.17. ⬜ Implement the official website source and static deployment lane. The bootstrap site lives in the main monorepo under `website/`, builds deterministically, renders or links spec/decided/guide/toolchain/stdlib/example/package/security/roadmap surfaces by authority class, records OSS reuse provenance, license obligations, copied-file inventory, and removal of foreign semantics, and labels public pages with the active public visibility stage from the service board.

- 12.18. ⬜ Implement the public service board records as infrastructure work moves from `PLANNED` to `SCAFFOLDED`. Main website, normative docs, knot-first/package-complete index/search, generated package docs and knot projections, playground/sandbox, advisories/security, releases/downloads, community surfaces, and showcase each name source input, deployment target, authority class, auth model, data retention, privacy/logging, cache policy, verification workflow, and operational blockers.

- 12.19. ⬜ Implement `kyokai-showcase` as editorial discovery separate from knot/package search, security/advisory state, provenance badges, docs-quality badges, official/community labels, and package trust. Showcase placement never changes `kyokai add`, `kyokai audit`, index resolution, or package/knot docs warnings.

- 12.20. ⬜ Implement community and support surfaces with explicit authority boundaries. GitHub Discussions is the bootstrap pre-proposal/support venue; no forum subdomain or custom forum is official until a recorded service exists. Community pages state purpose, moderation status, expected response scope, archival/searchability status, and non-normative authority.

- 12.21. ⬜ Implement release and installation infrastructure, including setup action metadata, OCI images, checksums, provenance, attestation/SBOM status when available, release-note compatibility classes, CI install smoke tests, and `bleedring` distribution metadata. Release artifacts are operational distribution evidence, not compiler conformance by themselves.

- 12.22. ⬜ Implement the D547 foreign-adapter envelope and admit individual metadata-query, foreign-build, and platform-package adapters only after version, authority, determinism, target, failure, raw-log, provenance, and conformance records exist.

- 12.22a. ⬜ Implement the D624 foreign-build plan protocol as a versioned reviewable DAG with declared tools, argv, environment, inputs, outputs, link facts, rerun predicates, plan/execute separation, quarantined partial results, raw logs, and validated replanning. An adapter cannot inject shell text, mutate compiler semantics, or turn an unknown plan class into executable policy.

- 12.23. ⬜ Implement D548 packaging plans and plan/apply commands for deterministic unsigned payload construction, separately authorized signing/notarization/upload, output verification, multi-architecture/split/delta/rollback facts, symbols, source maps, SBOM, and provenance.

- 12.24. ⬜ Implement D550 browser build/development integration: generated Web-IDL wrappers, asset/CSS/source-map provenance, explicit external asset graphs, CSP, workers/service workers, SSR/hydration/islands/HMR projection contracts, and simulated versus real-browser test lanes.

- 12.25. ⬜ Implement D554 mobile SDK/shim/build/package/test records and D557 deployment plan/apply records, including narrow Nix projection from exact Kyokai build identities. Platform stores, cloud providers, and Nix remain admitted adapters rather than language semantics.

- 12.26. ⬜ Implement the browser package-index and package-doc information architecture. Search has one large query target, stable sort controls, and separate facets for package set, license, target/platform compatibility, docs status, advisory/yank/hold state, provenance, owner, labels, Bridge relationship, and showcase inclusion. Third-party package detail pages are README/overview first, then versions, dependencies, dependents when available, security/advisory facts, docs, source, audit, and provenance. First-party stdlib and Bridge entries route to generated API-reference pages and admission/provenance records rather than pretending to be ordinary resolver dependencies.

- 12.27. ⬜ Implement Xperimental and stable-carried distribution enforcement: weekly release manifests only when included XP evidence changed, exact base and XP revisions, separate install/cache/output/artifact identities, root-manifest opt-in for stable carriage, package/knot publication labels, expiry/removal handling, and rejection of experimental evidence where stable conformance or admission is required.

- 12.28. ⬜ Make the vulnerability-reporting and incident boundary operational before security intake is advertised: one owner, confidential route, acknowledgement and triage states, severity/affected-version records, embargo and disclosure handling, advisory/yank/hold coordination, incident log boundaries, and service-board status. A planned address or document is not an operating security service.

**Completion verdict:** ⬜ **OPEN.**

**Exit rule:** Phase 12 is done only when every condition below is true:

- External packages can be pinned, fetched, inspected, vendored, audited, built, tested, documented, and reproduced.
- Package graph commands explain selected dependencies without requiring manual lockfile reading.
- Yanks, lockfiles, vendored source, offline mode, and SemVer checks obey the spec.
- Package-root `kdocs/`, package-index docs metadata, raw-file retrieval, official rendering, and local docs cache behavior obey the repository-owned docs model.
- Website, showcase, package docs, community, release, and service-board work has explicit authority status and deployment records before it is called official.
- Public pages and service records use the correct public visibility stage; Phase 12 may reach public experimental/bootstrap/ecosystem visibility, while stable platform claims remain blocked on Gate F plus Phase 13 evidence for the named targets.
- Build-time code generation has explicit authority and dependency tracking.
- Foreign build adapters produce reviewable deterministic plans with quarantined failure and retained raw evidence rather than executing ambient shell policy.
- Bridge collection metadata, if displayed by package/docs/audit tooling, remains separated from package-index trust, ordinary vendoring, and resolver-selected dependencies.
- Experimental distribution and security-intake surfaces enforce their recorded authority, identity, and lifecycle rules instead of existing only as website copy.

**May run in parallel with:** C-toolchain admission, source-map tooling, and self-hosting preparation after core package artifacts are stable.

**Must not do:** Allow moving branches, unaudited build scripts, or package resolution that changes existing lockfiles behind the user's back.

### Phase 13: C Toolchain Matrix, Cross Compilation, Optimization, And Debuggability

**Purpose:** Mature the one generated-C backend across major targets, optimizing C toolchains, cross compilation, source-level debugging, profiling, and build-time budgets.

**Dependencies:** Phase 7 C backend safety, Phase 8 conformance harness, Phase 4 target/profile model.

**Status:** Not started. D530-D536 define the generated-C target shape; D554-D556 add mobile, embedded, GPU/ML/data target and provider pressure. Implementation depends on Phase 7 generated-C safety and Phase 8 conformance infrastructure.

**Subparts:**

- 13.1. ⬜ Admit GCC and Clang on Linux, Apple Clang on macOS, clang-cl on Windows, and Clang on FreeBSD through complete D532 records bound to the exact compiler, host, target, SDK/sysroot, linker, profile/flag set, Kyokai semantic corpus, generated-C bundle, runtime/prelude, runner, and raw evidence.

- 13.2. ⬜ Implement target triples, SDK/sysroot discovery, C ABI/layout probes, calling conventions, symbol visibility, object formats, linking modes, and profile integration.

- 13.3. ⬜ Validate integer, float, pointer/address, record, union, packed, volatile, atomic, panic/TPOE, stack-check, and FFI lowering across every admitted compiler lane without C UB or unsupported assumptions.

- 13.4. ⬜ Run the same semantic conformance IDs across all admitted C compiler/target combinations and preserve raw external-tool evidence.

- 13.4a. ⬜ Treat compiler agreement, sanitizers, warnings, and upstream vendor suites as supporting evidence only. Resolve every disagreement against the owning Kyokai clause and lowering contract; never use a compiler majority as the language oracle.

- 13.5. ⬜ Add cross-compilation support for tiered targets only after target contracts define sizes, alignment, atomics, stack behavior, libc/OS boundary expectations, and linker behavior.

- 13.6. ⬜ Add C-emitter and external-tool optimization controls only when they preserve elaborated linear/capability semantics and do not erase required checks.

- 13.7. ⬜ Add debugger-quality sidecar maps and DWARF, CodeView/PDB, and dSYM behavior matching D27/D533.

- 13.8. ⬜ Add sanitizer normalization, Kyokai-source coverage, profiler symbolization, pretty-printer/NatVis support, and honest optimized-value handling.

- 13.9. ⬜ Meet D534 no-op, incremental, fsel-class, Zig/Hyprland-class, and very-large build gates on published reference hardware.

- 13.10. ⬜ Evaluate additional compiler/target lanes, including MinGW, MSVC `cl`, cross GCC/Clang, WASI, embedded, freestanding, CompCert evidence, and TCC, only through the ordinary admission process.

- 13.10a. ⬜ Implement admission revalidation, suspension, revocation, readmission, and offline evidence lookup. Every semantic, lowering, runtime ABI, target, compiler-version, flag, linker, sysroot, or SDK change that affects the tuple triggers the declared revalidation policy, and every fixed defect leaves a minimized permanent regression.

- 13.10b. ⬜ Implement D569c `SELF_VERIFIED` user records as an explicit unsupported local lane. They bind the ordinary evidence bundle but cannot change official support or the semantic corpus until project-controlled reproduction. Run the complete official matrix for major releases, only affected tuples for relevant minor releases, and no routine patch recertification; patch releases cannot silently change admission-relevant inputs.

- 13.11. ⬜ Add D554 Android and Apple mobile target lanes only after SDK/NDK/Xcode/Gradle adapters, generated managed-language shims, simulator/device matrices, symbols/source maps, signing, packaging, permission/lifecycle, and store-verification contracts pass admission.

- 13.12. ⬜ Add D555 embedded board-support lanes only after board, linker-script, startup, interrupt, MMIO, allocator, executor, flashing, probing, emulator, hardware-in-loop, secure-boot, OTA, rollback, and fatal-hook records pass target admission.

- 13.13. ⬜ Add D556 GPU/ML/data providers as separately admitted runtime/FFI/toolchain integrations with explicit device/context/queue/buffer ownership, synchronization, memory domains, kernels/shaders, tensor metadata, allocator, cancellation, error, target, and conformance contracts. This work does not add a GPU language, implicit dispatch, built-in autodiff, universal tensor type, or second backend.

- 13.14. ⬜ Earn D619 Apple support per exact evidence tuple. Start with `aarch64-macos-none`; record Apple Clang, Xcode, SDK, deployment target, architecture, linker, framework set, runtime, ARC/object/block/callback ownership, simulator or named physical device, debugger/symbols, packaging, signing/notarization authority, CI owner, and raw evidence. Intel macOS and every iOS-family device/simulator tuple remain separate admissions, and simulator success never claims physical-device behavior or performance.

- 13.15. ⬜ Publish exact Bleedring provider manifests for every redistributable admitted compiler tuple and explicit system/path acquisition records where redistribution is unavailable. Test project `c_toolchain_contracts`, local provider mapping, `--c-toolchain-provider`, failure guidance, cache identity, and absolute rejection of ambient `cc` across Linux, macOS, Windows, and FreeBSD.

**Completion verdict:** ⬜ **OPEN.**

**Exit rule:** Phase 13 is done only when every condition below is true:

- Every admitted Tier 1 C toolchain agrees on source-language conformance outcomes.
- Generated C and compiler flags avoid UB and unsupported assumptions forbidden by Kyokai semantics.
- Cross-compilation failures are explicit target unsupportedness, not silent miscompilation.
- Source debugging, fatal symbolization, sanitizers, coverage, and profiling report Kyokai locations with raw evidence retained.
- Published build-time gates pass on the named reference systems.
- Apple claims name the exact admitted host/target/SDK/tool/device tuple; simulator and compile-only evidence never stand in for physical-device execution.

**May run in parallel with:** Self-hosting compiler-component work after the selected Phase 10.14 entry record passes; unrelated target admissions remain independent.

**Must not do:** Treat a C compiler as a semantic oracle, admit ambient `cc` by accident, or trade safety/source accuracy for benchmark numbers.

### Phase 14: Self-Hosting Transition

**Purpose:** Move the compiler and ordinary toolchain into Kyokai at the first trustworthy point, without using an immature implementation as its own authority and without allowing OCaml-specific structure to harden into permanent rewrite debt.

**Dependencies:** The D592a self-host entry threshold, not full Gate F. The selected slice needs stable package artifacts, parser/elaboration/type and ownership checking, generated-C/runtime behavior, deterministic package/build fundamentals, usable diagnostics, its Tier-One stdlib dependencies, shared conformance/differential tests, and a recoverable pinned bootstrap. Unrelated package-index, hosted-service, or complete-ecosystem work cannot delay entry once those facts are real.

**Status:** Transition preparation starts immediately in the OCaml tree; Kyokai-source migration is not started because the D592a entry threshold is open. Phase 14 is an interruptible cross-phase lane, not a command to wait for Phases 11-13: once Phase 10.14 passes for a selected slice, Stage 1 begins in parallel with unrelated stdlib, ecosystem, target, and service work. Gate F is not the entry condition, and Gate G remains open until meaningful native slices, convergence, recovery, and proof work exist.

**Subparts:**

- 14.1. ⬜ Maintain a complete OCaml transition map. Every active host module is `KEEP_BOOTSTRAP`, `WRAP`, `REIMPLEMENT_IN_KYOKAI`, or `REMOVE`, with owner, semantic dependencies, replacement interface, parity suite, differential evidence, and retirement/recovery role. This work is required during current OCaml implementation, not deferred until the port.

- 14.2. ⬜ Make current host boundaries replacement-safe: typed/serialized stage inputs and outputs, stable command/data protocols, implementation-independent IR schemas, deterministic fixtures, shared conformance IDs, and no semantic rule that exists only in an OCaml type or control-flow convenience.

- 14.3. ⬜ Build and continuously report the self-host entry dashboard. It separately measures substantial multi-package compilation; parser; elaboration/type; linearity/borrow/capability; module/`.koi`; generated-C/runtime; deterministic build; diagnostics; package/build; selected Tier-One stdlib; conformance/differential coverage; and bootstrap recovery. No aggregate percentage or successful self-build can substitute for every required row.

- 14.4. ⬜ When every entry row needed by the first slice passes, choose a vertical slice with high language feedback and bounded bootstrap risk. Candidate first slices include manifest/TOML parsing, diagnostic rendering, formatter foundations, lexer/parser support, source maps, test/replay infrastructure, or pure compiler utilities; the selection record explains why its invariants and dependencies are already expressible.

- 14.4a. ⬜ Start the chosen Kyokai-native slice immediately after its Phase 10.14 entry record passes, even if unrelated Phase 10 work or Phases 11-13 remain open. Record the exact prerequisites that were required and the tempting unrelated work that was deliberately not made a blocker.

- 14.5. ⬜ Implement Stage 0 and Stage 1. Stage 0 is a pinned reproducible OCaml bootstrap with an admitted generated-C toolchain tuple. Stage 1 uses Stage 0 to build the selected Kyokai-native compiler/toolchain slice and records all source, compiler, target/profile, dependency, generator, environment-contract, and content identities.

- 14.6. ⬜ Implement Stage 2 and Stage 3 convergence. Stage 1 rebuilds the same slice, then the rebuilt toolchain repeats the build. Compare normalized generated C, `.koi`, diagnostics, package graphs, test results, and final artifacts; investigate and classify every mismatch. Merely running successfully or producing behaviorally similar output is not convergence evidence where exact identity is required.

- 14.7. ⬜ Keep the OCaml compiler as transition bootstrap and differential evidence, never as semantic authority. Accepted D-points and extracted normative clauses decide disagreements. Differential comparison includes positive, negative, diagnostic, resource-failure, and hostile-input cases rather than happy-path outputs alone.

- 14.8. ⬜ Define cross-bootstrap and disaster recovery. A new host uses a previous admitted Kyokai toolchain or reviewed content-identified generated-C snapshot; binary users do not need OCaml; source-bootstrap and recovery paths remain separately documented and tested. Preserve enough pinned OCaml/bootstrap material to recover until a later admitted recovery route replaces it.

- 14.9. ⬜ Retire each OCaml component independently only after its Kyokai replacement passes parity, differential, conformance, Stage 2/3 convergence, target, and recovery obligations. Do not perform one flag-day rewrite and do not keep two permanent semantic implementations after the transition evidence closes.

- 14.10. ⬜ Build compiler, package/build, formatter, test/fuzz/bench, docs, audit, analysis/LSP, and migration components in ordinary admitted Kyokai using the same libraries available to users. Any bootstrap intrinsic is explicit, audited, minimized, and either standardized or removed.

- 14.11. ⬜ Treat native toolchain friction as design evidence. It may produce implementation tasks, XPs, or proposed D-points, but the toolchain cannot grant itself hidden syntax, authority, allocation, effects, or compatibility exemptions.

- 14.12. ⬜ Start the D596 official Bridge evidence portfolio once native toolchain work is active enough to own its integration code deliberately and the relevant D529/D593a admission schemas exist. SQLite is first priority; each shipped entry has provenance/license, unsafe/capability/ownership/callback, target/build, reference-application, update, and vulnerability evidence.

- 14.13. ⬜ Implement the D620 game evidence sequence without adopting an official engine. Admit SDL3 first as the serious raw-systems Bridge/workload and raylib separately as the first small beginner surface; record integration class, callback thread/affinity, ownership, lifetime, reload, assets, audio, packaging, and target facts. Maintained reference games exercise 2D rendering, fixed-step simulation, frame arenas, data-oriented/ECS and slot-map pressure, input, audio, save/load, asset reload, profiling, and deterministic replay. Godot and Unity experiments remain personal/project experiments until separately admitted and do not establish official support.

**Completion verdict:** ⬜ **OPEN.** The self-host entry threshold has not been met.

**Exit rule:** Phase 14 is done only when every condition below is true:

- A meaningful compiler/toolchain slice is written in ordinary Kyokai and built through the documented Stage 0-3 chain.
- Declared convergence and recovery exercises pass on the admitted target/toolchain tuples.
- Every retained OCaml component has a live bootstrap/recovery reason and every retired one has closed replacement evidence.
- The migration began only after the explicit entry threshold and before completion of the entire toolchain/ecosystem, so neither immature self-hosting nor late ceremonial rewrite became policy.
- Official Bridge entries that exist have their class-specific D529/D593a admission records and are not ordinary vendored dependencies.
- Game Bridges and reference games, if present, follow the SDL3-then-raylib evidence order and do not imply an official engine or unadmitted Godot/Unity support.

**May run in parallel with:** Remaining Gate-F package/index/docs/service work, Phase 13 target expansion beyond the admitted bootstrap tuple, and mechanized proof preparation after the core calculus is stable.

**Must not do:** Begin from a toy or half-correct compiler, make one self-build count as trust, encode semantics in OCaml-only structure, wait until every ecosystem feature is complete, perform a flag-day rewrite, require OCaml for ordinary binary use, or retire the recovery bootstrap before convergence and recovery evidence exist.

### Phase 15: Mechanized Proof And Long-Term Governance

**Purpose:** Move from paper proof to machine-checked proof and keep the spec/compiler relationship healthy.

**Dependencies:** Phase 2 paper proof. Whole-core mechanization still depends on sustained compiler/self-hosting progress, but narrow vertical artifacts may begin earlier when they connect a frozen typing judgment to an executable step relation.

**Status:** Lean 4 selected and narrow spot artifact building locally. Whole-core mechanization has not started. Gate G is open.

**Subparts:**

- 15.1. ✅ Use Lean 4 as the proof assistant. Pin the release through Elan and build artifacts with Lake. **Status: selected.**

- 15.2. ⬜ Mechanize the sequential `lambda_K` syntax, static semantics, dynamic semantics, and soundness theorem.

- 15.2a. ⬜ Build the first vertical mechanized slice: one exact executable machine-step case, its typing judgment, preservation across that step, and a correspondence note back to the normative surface rule. Keep the theorem name and exclusions narrow.

- 15.3. ⬜ Add proof builds to CI.

- 15.4. ⬜ Extend the formal model in separate layers only after the core mechanization is stable: generics, modules, typeclasses, contracts, unsafe/FFI boundary models, concurrency, memory model, and backend simulation.

- 15.5. ⬜ Establish spec-change governance: any semantic change updates the spec, conformance tests, implementation, and proof impact notes in the same tracked change.

- 15.6. ⬜ Establish edition governance under the already-decided edition/release policy rather than inventing a second compatibility system.

- 15.7. ⬜ Keep planning/rationale material separate once the specs own normative behavior.

- 15.8. ⬜ Maintain revision-bound review records under `kyokaicalculus/reviews/`. Author/maintainer review and independent review must be labeled separately.

- 15.9. ⬜ Maintain bidirectional calculus/spec correspondence: a calculus clarification opens a spec impact row, and a normative semantic change opens a calculus impact row before either side claims synchronization.

**Completion verdict:** ⬜ **OPEN.** Gate G and whole-core mechanization remain open.

**Exit rule:** Phase 15 is done only when every condition below is true:

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
| Phase 3 root and implementation ownership cleanup | deeper compiler/toolchain path growth | New code needs a stable owner before more build scripts, tests, and evidence records encode inherited locations. |
| Feature implementation | its positive, negative, diagnostic, and replay evidence | Phase 8 provides the common harness; it does not excuse a feature from landing tests with its implementation. |
| Phase 9 first admitted Kyokai modules | Phase 10.14 self-host entry review | The first native toolchain slice needs real language libraries, not OCaml stand-ins or compiler-private helpers. |
| Phase 10.14 passing entry record | first Kyokai-native compiler/toolchain slice | Native migration begins as soon as the selected slice is trustworthy; unrelated Phase 10-13 work cannot delay it. |
| Self-hosting | mechanized proof priority shift | D143 places mechanization after self-hosting. |
| Diagnostic catalog and fix-safety classes | `kyokai fix`, Analysis Server code actions, and migration assists | Automated edits need stable IDs, spans, post-application validation, and safety classes before they can modify user source. |
| Analysis Server shared engine | public LSP/editor bundles and DX conformance | Editor tools must reuse compiler facts instead of creating a second parser, checker, package loader, or formatter. |
| `kdocs/` schema and package-index docs metadata | official package-doc website rendering and docs search | The website can render package docs only after package-root docs, digests, raw-file adapter class, and docs status are explicit. |
| Sandbox-runner contract | Compiler Explorer execution, playground, eval services, and build generation execution | Hosted or local execution of untrusted code needs resource, authority, failure-category, and artifact rules before service rollout. |
| `bleedring` install/provenance contract | public setup action and release installation | Bundled distributions need exact-version identity, checksum/provenance validation, atomic replacement, offline install, and root separation before release claims; Bleedring does not own project toolchain selection. |
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

- daily local DX: CLI, diagnostics, formatter, docs, audit, explain, fix, LSP, Analysis Server, ProofTrace views, replay, and standalone Bleedring distribution installation/diagnosis;
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

Current status is checked specification extraction through D635, the narrow Gate-B paper theorem, and a completed Phase 3 source-language/identity/ownership boundary. No later implementation phase is complete merely because its plan decisions or normative clauses are closed.

Phase checklist:

- [x] Phase 0: Repository Baseline And Decision Audit is complete enough for the roadmap baseline.
- [x] Phase 1: Normative Kyokai Specification Extraction has chapter-family text and D577 clause-level verification through D635. Recurring review packets and implementation/admission artifacts remain tracked under their own phases and maturity axes.
- [x] Phase 2: Sequential `lambda_K` Core Calculus And Paper Proof is complete for the narrow `lambda_K-seq` paper theorem.
- [x] Phase 3: Compiler Fork Identity And Frontend Surface Bring-Up is complete for its source-language, fork-identity, root-classification, and implementation-ownership exit. The active path constructs a span-carrying surface AST and phase-local checked frontend result without the inherited interface/body parser. Resolution, `.koi`, typing, safety checking, backend work, final toolchain commands, and conformance remain open in Phases 4-8.
- [ ] Phase 4: Name Resolution, Imports, Packages, And Interface Artifacts.
- [ ] Phase 5: Type System, Elaboration Pipeline, And Core IR.
- [ ] Phase 6: Linearity, Borrows, Capabilities, Contracts, And Unsafe Checks.
- [ ] Phase 7: Runtime Semantics And Generated-C Safety.
- [ ] Phase 8: Toolchain Skeleton, Diagnostics, Formatter, And Test Harness must establish the common evidence machinery and bootstrap-adapter boundary without turning OCaml scaffolding into the final toolchain.
- [ ] Phase 9: Core Standard Library Foundation begins ordinary Kyokai stdlib source and per-module admission; no OCaml implementation counts as a stdlib module.
- [ ] Phase 10: OS, FFI Boundary, Capabilities, And Runtime Standard Library.
- [ ] Phase 11: Concurrency, Atomics, Channels, And Synchronization.
- [ ] Phase 12: Package Manager, Index, Build Artifacts, And Ecosystem Tooling separates Kyokai-native local tools from separately governed hosted services and experimental/security operations.
- [ ] Phase 13: C Toolchain Matrix, Cross Compilation, Optimization, And Debuggability.
- [ ] Phase 14: Self-Hosting Transition has immediate host-architecture preparation open; Kyokai-source migration begins as soon as Phase 10.14 passes for the selected slice and does not wait for unrelated Phases 11-13 or full Gate F.
- [ ] Phase 15: Mechanized Proof And Long-Term Governance is partially done; Lean 4 is selected and the narrow spot artifact builds, but whole-core mechanization has not started.

| Phase | Status | Gate State |
| --- | --- | --- |
| Phase 0: Repository Baseline And Decision Audit | Complete enough for implementation-roadmap baseline; future stale references are cleanup work, not a Phase 0 blocker | Prepares Gate A; closes no global gate by itself |
| Phase 1: Normative Kyokai Specification Extraction | Complete through D635 under the checked pre-D558, D558-D625, and D627-D635 registries | Gate A closed through D635; Gate B separately closed for `lambda_K-seq`; Gates C-G remain open |
| Phase 2: Sequential `lambda_K` Core Calculus And Paper Proof | Owner-slot environment-machine statics and dynamics, 40-lemma proof index, closed derivation packages, Theorem P/Q assembly, executable model spot checks, whole-machine traces, and narrow Lean spot artifact exist | Gate B closed for `lambda_K-seq` paper proof |
| Phase 3: Compiler Fork Identity And Frontend Surface Bring-Up | Complete: active Kyokai source/lexer/AST/parser/frontend/package-source owners, stable spans, accepted/rejected tests, internal fixture path, root cleanup, checked inherited transition map, and D592a entry dashboard | Phase 3 parser/source/identity/ownership exit closed; Gates C-F remain open |
| Phase 4: Name Resolution, Imports, Packages, And Interface Artifacts | Not started | Package/spec gate open |
| Phase 5: Type System, Elaboration Pipeline, And Core IR | Not started | Gate C open |
| Phase 6: Linearity, Borrows, Capabilities, Contracts, And Unsafe Checks | Not started | Gate C safety-checker work open |
| Phase 7: Runtime Semantics And Generated-C Safety | Not started | Gate D open |
| Phase 8: Toolchain Skeleton, Diagnostics, Formatter, And Test Harness | Final contracts/harnesses and the bootstrap-adapter boundary are not implemented; final product components are Kyokai-native after entry | Conformance infrastructure and Gate F open |
| Phase 9: Core Standard Library Foundation | No ordinary Kyokai stdlib module has completed the real compiler/admission path | D229 admission and self-host library prerequisites open |
| Phase 10: OS, FFI Boundary, Capabilities, And Runtime Standard Library | Not started | Gate E open |
| Phase 11: Concurrency, Atomics, Channels, And Synchronization | Not started | Memory-model/runtime gate open |
| Phase 12: Package Manager, Index, Build Artifacts, And Ecosystem Tooling | Schemas and service records exist in specification/direction; Kyokai-native local tools, hosted services, XP distribution, and operational security intake are not implemented | Ecosystem gate and Gate F open |
| Phase 13: C Toolchain Matrix, Cross Compilation, Optimization, And Debuggability | Not started | D530-D536 extracted; blocked on generated-C implementation, conformance harness, platform admission, source-map tooling, and benchmark infrastructure |
| Phase 14: Self-Hosting Transition | Replacement preparation is required now; Kyokai-source migration and Stage 0-3 execution start immediately after a selected Phase 10.14 entry record passes | D592a self-host entry threshold open; Gate G open |
| Phase 15: Mechanized Proof And Long-Term Governance | Lean 4 selected; pinned Elan/Lake owner-slot spot artifact builds; whole-core mechanization has not started | Gate G open |

### Component Reality Board

This board is deliberately independent of the phase prose. A component moves only when its cited entry point and evidence move. Broad parser or frontend progress never upgrades a downstream semantic component.

| Component | Current state | Evidence/entry point | Principal open work |
| --- | --- | --- | --- |
| repository root and implementation ownership | Phase 3 boundary complete | workspace `material/`, private `project/`, `compiler/`, `toolchain/`, transition inventory, identity check | preserve ownership as later phases move their subsystems; do not recreate loose or inherited catch-all paths |
| source roles and source bytes | Phase 3 implementation + focused host tests | `compiler/frontend/source/` | released diagnostics and public-command conformance in Phase 8 |
| lexical tokens | Phase 3 implementation + accepted/rejected host and fixture tests | `compiler/frontend/lexer/` | documentation attachment, formatter integration, released diagnostics, and conformance in Phase 8 |
| surface AST and parser | Phase 3 implementation, still bootstrap/prototype maturity | `compiler/frontend/ast/`, `compiler/frontend/parser/`, `compiler/frontend/KyokaiFrontend.ml` | parser recovery/decomposition when next touched; resolution, typing, and public conformance belong to later owners |
| manifest/workspace discovery | Phase 3 package-root/member/target/source slice implemented; module-root and member symlink containment tested | `compiler/package/manifest/` | complete D332 root semantics, traversal-cycle defense, TOML 1.0 implementation, profiles/features, and remote sources in Phase 4 |
| resolver/lockfile | workspace-only scaffold | package resolver/lockfile modules | Git/index solving, graph-changing modes, final TOML schema, adversarial fixtures |
| module/name resolution and `.koi` | not implemented as accepted contract | Phase 4 | KBI framing and payload schema, visibility/coherence checks, hostile decoder |
| typed elaboration/core IR | not implemented | Phase 5 | D238 order, callable/effect evidence, tautology registry, typed IR ownership |
| linearity/borrow/capability checker | not implemented | Phase 6 | state machine, lease lineage, universe well-formedness, authority topology |
| generated-C/runtime safety | inherited evidence plus open defects | Phase 7 | replacement/repair dispositions, evaluation-order/range preservation, C admission |
| core and systems stdlib | inherited Austral tree is migration evidence; no admitted Kyokai-native module slice yet | Phase 9-11 | ordinary Kyokai implementations, concrete API contracts, admission records, oracle/capability/failure tests, inherited-tree retirement |
| ordinary product toolchain | contracts are specified; current host/compiler scaffolds are not the final toolchain | Phase 8 boundary, Phase 10.14 entry review, Phase 14 | freeze temporary adapters, choose first native slice, implement CLI/build/fmt/test/docs/audit/analysis/package components in Kyokai, converge and retire host substitutes |
| host tests | aggregate Dune alias green on the 2026-07-20 Phase 3 closeout | `test/`, `test/host/frontend/`, and Dune aliases | keep inherited tests classified and add semantic tests with each later owning feature |
| conformance runner | implementation-gated scaffold | `toolchain/conformance/` and `test/conformance/` | bounded execution, stable diagnostic identity, public command ownership, replay/artifacts |
| specification integrity | full accepted-range Git check present | `.github/workflows/spec-integrity.yml`, `make check-spec-integrity` | keep new decisions registered and reviewer fidelity judgment human; reopen affected extraction when a contradiction is found |
| adversarial workload corpus | schema and private direction exist; executable coverage is only beginning | `examples/adversarial/`, Phase 3.12, Phase 8.31 | add cases with owning semantic slices, mutation checks, budgets, target/provider identity, and public-runner integration |
| diagnostic and finding registries | contracts extracted; implementation not started | Phase 8.7 and Phase 8.32 | import current codes, generate checked tables, implement typed PR/release finding records and hotfix review closure |
| release knowledge identity | contract extracted; schema/tooling not implemented | Phase 8.32 and D628-D630 | bind spec, D-point, XP, calculus/proof, toolchain/schema, target, and provider revisions in release artifacts |
| native compiler providers | distribution and selection contracts extracted; no provider bundle admitted | Phase 8.17 and Phase 13.15 | implement Bleedring bundle verification, explicit project selection, isolated roots, exact admission identities, and no ambient `cc` |
| ProofTrace | metadata checker and generated board exist | `toolchain/prooftrace/`, `kyokaiproofstatus.toml` | clause identifiers, generated spec/compiler map, evidence-state enforcement |
| paper calculus | narrow `paper-proven` theorem | `kyokaicalculus/theorem-assembly.md` and review record | independent review if sought, spec correspondence, revision-bound reviews |
| Lean calculus | twenty-five narrow spot theorems | `kyokaicalculus/lean/` | first step-relation + typing vertical slice, then sustained whole-core work |

The 2026-07-20 Phase 3 closeout runs one green aggregate Dune alias across the inherited host groups and the active Kyokai frontend groups. The active Kyokai groups currently contain 173 assertions: 10 source-text, 7 source-role, 44 lexer, 39 parser, 3 frontend-composition, 3 control-flow, 10 interface-validation, 47 package-source, 5 resolver, and 5 lockfile assertions. The inherited groups are reported separately by Dune. This is host implementation evidence, not public language conformance.

### Next implementation line

The next compiler session starts in Phase 4. It consumes the Phase 3 frontend
boundary; it does not reopen the source grammar casually, call the inherited
two-file parser, implement the final toolchain in OCaml, or attempt self-hosting
before the D592a dashboard passes.

1. Record the aggregate host, identity, fixture, and ProofTrace baseline before changing resolution code.
2. Split `KyokaiPackageSource.ml` along the recorded exception before adding TOML 1.0, dependency solving, profile inheritance, or `.koi` work.
3. Establish one owner for module/import/package name resolution and one resolved-AST handoff.
4. Implement the first `.koi` framing and hostile-decoder slice against the accepted KBI rules, with deterministic print/verify evidence.
5. Add positive, negative, span, cycle, visibility, artifact, and hostile-input tests with each Phase 4 slice.
6. Maintain the transition inventory and D592a dashboard while host code changes; temporary adapters remain named and bounded.
7. Route implementation-discovered ambiguity through the typed finding workflow. A real accepted/spec contradiction reopens only the affected Gate-A boundary.

## 12. Near-Term Work Queue

The next concrete work should happen in this order.

- [x] Create the D592a OCaml transition map and self-host entry dashboard before adding more host-only architecture: every inherited module has both dispositions, every active Phase 3 path has a target owner, and the dashboard records `NOT_READY` until a real first slice is selected.
- [x] Execute Phase 3.10 root cleanup: research/prior art and private project records now have owned paths; generic generated remnants and the obsolete inherited roadmap are removed; references and the public-path manifest are synchronized.
- [x] Execute Phase 3.11 ownership migration for the active frontend: Kyokai compiler code lives under `compiler/`, tool adapters under `toolchain/`, and inherited `lib/` modules are classified rather than used as a new-code bucket.
- [x] Repair the duplicate-module conflict and retire the inherited parser from the active Kyokai source path. One aggregate Dune host command and the Phase 3 fixture runner are green; inherited end-to-end assets remain labeled bootstrap evidence rather than active Kyokai tests.
- [ ] Build the first vertical Lean slice connecting one executable step relation and one typing judgment, with a surface/spec correspondence note and narrow theorem claim.
- [ ] Turn accepted stdlib/API decisions into reviewed declaration packets; do not implement accepted shape as undocumented code policy or mistake a candidate packet for admission.
- [ ] Choose the first Phase 9 ordinary-Kyokai stdlib slice needed by the self-host candidate, then define its exact compiler, admission, oracle, failure, property/fuzz, and cleanup evidence before implementation.
- [ ] Freeze the Phase 8 bootstrap-adapter boundary and candidate first Kyokai-native toolchain slice so necessary host scaffolding cannot silently grow into the final formatter, docs, package/build, audit, Analysis Server, or test tool.
- [ ] Implement each new semantic test with its owning Phase 3-7 feature; use Phase 8 to unify execution, reports, replay, and CI rather than deferring semantic coverage until the harness phase.
- [ ] Add the first executable `examples/adversarial/` cases with their owning checker/backend slices, beginning with arena escape/reset, generational handles, linear-container early exit/drain, and transactional asset failure. Each case must name the wrong implementation it detects.
- [ ] Prepare the accepted D601 long-lived Poller server workload contract so stdlib/API admission can be tested against a real server rather than isolated examples; implementation waits for the required public knot/stdlib surfaces rather than using compiler-private hooks.

- [x] Review `kyokaidecided.md` as an accepted-shape ledger through D635: exact accepted decisions and duplicate history are preserved, normative destinations are recorded, and D558-D625 plus D627-D635 are promoted only after their D577 registries verify clause evidence. D626 remains withdrawn.
- [x] Use the Gate-B paper proof as the compiler-facing sequential-core reference while keeping whole-core Lean mechanization, compiler conformance, and later feature proofs on their separate gates.
- [x] Inventory the compiler passes in `lib/` against the D238 pipeline in `docs/compiler-pipeline-inventory.md`; keep it updated as frontend handoff boundaries move.
- [x] Create the first conformance directory shape for lexer, parser, modules, type, linearity, backend, diagnostics, package behavior, and related lanes. The internal compiler-stage runner executes 31 implementation-gated parser, module, and package fixtures and compares machine-readable expected-result fields as supporting evidence only; stdlib-specific fixtures, property/fuzz replay, public command execution, full diagnostic-code matching, and conformance-backed reporting remain later work.
- [x] Implement the Phase 3 source boundary against extracted S1-S4: role and byte validation, lexical tokens, the span-carrying surface AST/parser, phase-local structural/interface checks, package-source loading, and host/fixture evidence are composed by `KyokaiFrontend`.
- [x] Migrate the active Phase 3 frontend scaffold to D537-D539: remove the `.kai` source role and parser start symbol, discover one `.kyo` file per logical module, derive interface facts for `.koi`, parse `public`/`internal`/private-by-default and `opaque`, reject retired `.kai` source, and rewrite the affected host tests, conformance fixtures, stage-runner facts, package-source target selection, and ProofTrace scope together.
- [x] Standardize value equality on `==` and replace initializer, contract, and declaration-guard token scans with one span-carrying expression AST for the implemented core subset.
- [ ] Prioritize `kyokai check`, `--version`, `doctor`, `init`, `new`, local `kyokai explain`, checked `kyokai fix`, and deterministic replay before broad package or knot publishing.
- [ ] Prioritize allocator, buffer, string/span, result/optional, formatting, final resolver data structures, deterministic lockfile read/write, package/knot graph inspection, vendoring, and lockfile reproducibility before large OS, concurrency, remote publishing workflows, or official Bridge collection code.
- [ ] Implement the one generated-C backend and D531-D536 compiler admission, source-map/DX, external-tool evidence, incremental units, and performance gates; do not create a second backend path.
- [ ] Build the Analysis Server shared-engine plan before shipping `kyokai lsp`, editor bundles, resource-flow refactors, or public-signature migrations.
- [ ] Implement the diagnostic catalog, fix-safety classes, and JSON/code-action identity before enabling `kyokai fix` or LSP source edits beyond preview.
- [ ] Freeze the separately released Kyokai-written Bleedring protocol before public setup guidance depends on it: complete-distribution installation, exact admitted native-provider bundles, isolated roots, safe extraction, licenses/provenance, explicit non-redistributable provider guidance, and no project-selection or ambient-PATH behavior.
- [ ] Import existing diagnostic codes into the D633 registry and add a checker before CLI, Analysis Server, fix, or external-tool normalization emits released codes from generated tables.
- [ ] Implement the D628 knowledge-manifest and D634 finding/release-review schemas before the first release claims the new versioning or post-release-review contract.
- [ ] Create tracked infrastructure work for website source, organization migration, public visibility labels, repository-owned package docs plus knot projections, optional docs mirrors, showcase, community surfaces, sandbox/playground, release/download pages, and hosted services without presenting planned deployments as shipped.
- [ ] Implement `kdocs/manifest.toml`, `kyokai doc --check`, `kyokai docs --pull`, package and knot index metadata, and raw-file adapter verification before official package/knot docs routes appear.
- [ ] Keep package/knot index, generated docs, showcase, forum/community, playground, releases, and security/advisory surfaces separated by service-board authority class.
- [ ] Implement D540-D549 shared application-integration foundations before domain-specific frameworks: owner/handle/view state, generated-API projection, explicit heterogeneous boundaries, callback contract tooling, migration plans, authority explanation, deterministic simulation, foreign adapters, packaging plans, and behavioral dataset providers.
- [ ] Implement D550-D557 browser, server, CLI/TUI, GUI/media, mobile, embedded, GPU/ML/data, and deployment/Nix support only through the shared contracts and separate target/provider/framework admission records; do not add hidden runtime semantics or a second backend.
- [ ] Update `kyokaispec/src/project/02-decision-traceability.md` after every new accepted D-point or extraction PR/MR.

## 13. Changelog

### 0.2.59 - 2026-07-20

- Closed Phase 3 at its stated source-language, fork-identity, root-classification, and implementation-ownership boundary without claiming resolution, `.koi`, typing, ownership checking, backend work, public command conformance, or Gate C.
- Established `compiler/frontend/KyokaiFrontend.ml` as the sole active `.kyo` composition path and moved the active frontend/package code out of the inherited `lib/` tree. The inherited interface/body parser is no longer on the Kyokai source path.
- Repaired package, binary, Nix, CI artifact, fixture-command, and editor identity; classified all 135 inherited compiler source units; added the D592a self-host entry dashboard; and completed the Phase 3 root/tree ownership work.
- Made `run-tests.sh` the green aggregate Phase 3 evidence command: inherited and Kyokai host tests, 31 implementation-gated fixtures, Phase 3 identity, spec/ProofTrace integrity, and the narrow Gate-B model all run under one owned entrypoint.
- Synchronized ProofTrace, compiler inventories, direction records, conformance-lane notes, the Austral comparison, and the component board with the closed Phase 3 boundary.

### 0.2.58 - 2026-07-20

- Closed Gate A through D635 after checking a frozen inventory of 573 accepted pre-D558 decisions alongside the existing D558-D625 and D627-D635 registries.
- Added accepted-source anchors for legacy grouped decisions, canonical grouped trace-row checks, source digests, clause-category applicability, destination vocabulary tripwires, supersession edges, and generated review evidence.
- Marked Phase 1 complete while keeping implementation, conformance, admission, services, workloads, and proof on their own gates and maturity axes.

### 0.2.57 - 2026-07-20

- Added the focused Git specification-integrity lane and made the authority split explicit: authors extract, reviewers judge fidelity, and CI verifies recorded completeness without deciding semantics or granting maturity.
- Added an implementation start line that begins with the Phase 3 aggregate-host baseline, bounded root/ownership cleanup, duplicate-module repair, inherited-loader handoff, and one vertically tested frontend slice.
- Clarified when Kyokai-native toolchain and stdlib work begins: transition preparation is current, source migration waits for the D592a entry threshold, and final components are not written as permanent OCaml substitutes.
- Expanded the component board for adversarial workloads, specification integrity, diagnostic/finding registries, release knowledge identity, and exact native compiler providers.
- Restored `Kyokaishape.md`'s accepted D635 role as a public temporary holding area as well as a decision/index/archive ledger.

### 0.2.56 - 2026-07-20

- Accepted and extracted D627-D635 for adversarial workloads, public-knowledge/spec/calculus versioning, Bleedring native compiler providers, explicit contract/provider selection, diagnostic-code registry, PR-local findings and post-release review, and umbrella D-points with public temporary holding.
- Added the public `examples/adversarial/` schema, private adversarial direction, reusable multi-batch clause checker, D627-D635 registry/review, GitHub finding/proposal forms, and PR finding disposition template.
- Scheduled adversarial cases with their owning compiler phases, common runner integration in Phase 8, exact provider publication in Phase 13, diagnostic registry import, release knowledge manifests, and post-release implementation reviews.

### 0.2.55 - 2026-07-20

- Added a workstream placement map covering repository cleanup, incremental tree migration, the OCaml bootstrap boundary, Kyokai-native stdlib and toolchain timing, package/ecosystem work, CI, semantic atlas, experiments, compiler admission, infrastructure, and proof.
- Made repository-root cleanup and implementation-tree ownership numbered Phase 3.10-3.11 work with explicit Phase 3 exit conditions instead of leaving them only in the near-term queue.
- Added a phase-by-phase test and evidence schedule: tests now land with their owning language/compiler/stdlib/toolchain feature, while Phase 8 owns the common runner, reports, replay, and CI promotion.
- Clarified that Phase 9-11 stdlib code is ordinary Kyokai, Phase 8 host code is limited to named temporary bootstrap adapters, and final toolchain slices begin in Kyokai immediately after the Phase 10.14 entry review passes rather than waiting for Phases 11-13 or full Gate F.
- Placed semantic-atlas maintenance, XP evidence/distribution, compiler-admission schema work, and operational vulnerability intake into explicit Phase 8/12 subparts and status rows.
- Added explicit roadmap rows for the named `deep-check` engines, the foreground `kyokai dev` supervisor, foreign-build plan execution, exact Apple admission tuples, and the SDL3-then-raylib game-evidence sequence; synchronized the private direction ledgers to those public phase owners.

### 0.2.54 - 2026-07-16

- Moved every numbered phase-item status directly after its number: `✅` for complete and `⬜` for open or partial.
- Added an explicit completion verdict to every phase and replaced vague `Done when` headings with exit rules that say whether the phase is currently complete and what must become true before an open phase closes.
- Clarified the scoped Phase 2 result: the narrow Gate-B paper-proof phase is complete, while item 2.15 remains continuing executable-evidence work rather than a hidden reopening of the proof result.

### 0.2.53 - 2026-07-16

- Added the D577 machine-readable D558-D625 clause registry, validator, generated review sheet, Make targets, and ProofTrace boundary.
- Made the validator check traceability, maturity, and Gate-A projections and wired the clause/source checks into the bootstrap CI path, so a stale public status view fails validation.
- Promoted D558-D625 to `SPEC_EXTRACTED` after checking accepted-source digests, destinations, review identity, supersession edges, proof impact, exact-name/rejected-form tripwires, and all obligation-category states.
- Kept Gate A open for earlier accepted ranges and kept implementation, conformance, admission, services, workloads, and proof on their separate axes.
- Kept one assembled specification while moving official-project governance, traceability, proof-roadmap, licensing, admission, and workload-evidence material into the in-spec `project/` chapter family.

### 0.2.52 - 2026-07-16

- Extracted normative D558-D625 text into the owning language, toolchain, stdlib, application-integration, governance, formalization, rationale, and traceability chapters.
- Repaired live contradictions in borrow creation, callable classes, workspace-root membership, Bleedring, `debug`, crypto ownership, package/knot publication, and the Austral comparison.
- Initially kept D558-D625 at `SHAPE_DECIDED` pending D577 evidence; 0.2.53 records the later checked promotion. Recurring review packets, concrete API/admission packets, conformance, implementation, provider/platform evidence, and operational services remain open on separate axes.

### 0.2.51 - 2026-07-16

- Accepted D615-D625 and extended Gate A through D625 without claiming specification extraction, schema migration, installer/toolchain implementation, conformance, admission, or release evidence. D617 and D622 are duplicate withdrawals; D626 remains withdrawn by D596a.
- Fixed the distribution model: standalone `bleedring` bootstraps exact bundled Kyokai distributions for users and CI; it is neither a `kyokai` subcommand nor a persistent component/toolchain manager.
- Corrected D624a: workspace members remain independently publishable packages. A knot is the prioritized atomic publication of a selected package set; included packages also receive individual index records, docs, dependency identities, advisories, and yanks. Manifest/CLI exclusions are explicit and dependency-closed.
- Amended D582 with D625 stable-carried experiments: stable releases can contain accepted XPs disabled by default, selected from root `[experimental]`, while all affected artifacts and published knots remain explicitly experimental.

### 0.2.50 - 2026-07-14

- Accepted D597-D614 and extended Gate A through D614 without claiming specification extraction, conformance, admission, or implementation.
- Added fail-closed generator admission, native-math ownership, shared-lifetime explanation, measured SPSC/native-task evidence, and the long-lived Poller reference product.
- Added root `[documentation].mode` with `structured`, `rendered`, and `source-only` documentation modes plus the explicit CLI override.
- Closed non-authorizing `debug`, borrow/comment/build/terminator and unsafe-label surface rules, no-shadowing assistance, frontend ownership/dispositions, and typed finding intake.
- Preserved D609 as a D585 duplicate withdrawal and D613 as a D581 duplicate withdrawal.

### 0.2.49 - 2026-07-14

- Accepted D584-D596a and extended Gate A through D596a without claiming specification extraction, API admission, conformance, implementation, or self-hosting.
- Added exact Tier-One API packet, `TextView[R]`, memory/collection, CLI/testing, authority-explanation, observability, codec, crypto/provider, web/database, and official Bridge portfolio work.
- Made Kyokai the target implementation language for its compiler and toolchain under a staged D592a transition: replacement-safe OCaml seams begin immediately, source migration waits for a substantial self-host entry threshold, and OCaml retirement waits for Stage 2/3 convergence and recovery evidence.
- Rejected an overarching Rust frontend, ABI, Cargo importer, translator, or universal Bridge; project-specific stable-boundary Bridges and language-neutral migration assistance remain permitted.
- Withdrew D609 as a duplicate of D585's narrower nominal text-view decision.

### 0.2.48 - 2026-07-14

- Accepted D571-D583, including D573a, and extended Gate A through D583 pending normative and workflow/service extraction.
- Added structured native-task reclamation without hidden source cleanup, the sequenced generated-C validation program, and the KBI-1 framing/payload/budget/compatibility closure.
- Accepted an explicit capability-bounded Linux `io_uring` provider without making it portable I/O semantics.
- Added clause-level extraction evidence, public-document identity, the semantic atlas, bidirectional spec/calculus correspondence, identified proof-review packets, isolated XP/Xperimental releases, and the limited-single-owner vulnerability-response bootstrap.

### 0.2.47 - 2026-07-13

- Accepted D558-D570, including D562a and D569a-D569c, and reopened Gate A through D570 pending normative extraction and clause verification.
- Split compiler-admission work into an early Phase 7 schema/corpus-projection harness and the actual Phase 13 admission matrix.
- Required admission records to bind exact toolchain, target, semantic-corpus, generated-C, runtime, runner, and raw-evidence identities.
- Made compiler agreement supporting evidence rather than a language oracle and added explicit suspension, revocation, readmission, and permanent-regression work.

### 0.2.46 - 2026-07-12

- Reopened Gate A because chapter routing and trace rows were not sufficient evidence of complete normative clause extraction.
- Added a component-level reality board and recorded the red aggregate Dune result separately from the fourteen OUnit groups and 181 assertions reached successfully.
- Added incremental implementation-tree restructuring, inherited-pass dispositions, and the first early step-relation/typing Lean slice to the near-term queue.
- Added revision-bound calculus review records and labeled the current `lambda_K-seq` review as maintainer review rather than independent review.
- Made `SPEC_COMPILER_TRACE.md` subordinate to ProofTrace evidence status.

### 0.2.45 - 2026-06-20

- Clarified that public visibility is staged: public experimental and bootstrap infrastructure can appear before Phase 13, while stable platform claims require Gate F plus Phase 13 evidence for the named C toolchains and targets.
- Added package-index and package-doc UI architecture to Phase 12: README-first package detail pages, facets, status fields, first-party stdlib/Bridge routing, docs renderer separation, and no collapsed trust score.
- Updated the near-term infrastructure queue so website, package search, package docs, community, releases, and service records carry explicit public-stage labels instead of implying deployed or stable status.

### 0.2.44 - 2026-06-15

- Added structured inline-test declarations with static descriptions, explicit capability parameters, statement bodies, spans, and module-private derived-interface exclusion.
- Added host coverage for parsing, modifier rejection, test-body control-flow context, and package-interface exclusion, plus the twenty-ninth implementation-gated compiler-stage fixture.
- Added the exact inline-test grammar and test-build artifact contract to the normative specification.
- Expanded the inherited and intentionally rejected syntax matrices, including retired base prefixes, platform-shaped char-literal prefixes, and unadmitted tuple/class/inheritance/exception/macro/local-import/body-target/pattern-guard/drop/global/async surfaces; the implementation-gated supporting fixture count is now thirty-one.
- Closed a parser hole that previously swallowed trailing tokens after structured constant/type/capability declarations.

### 0.2.43 - 2026-06-15

- Added completion checkboxes to every numbered phase subpart so roadmap state is visible without reading each phase status block.
- Expanded Phase 3 subparts with explicit current-state summaries and kept partial work unchecked.

### 0.2.41 - 2026-06-14

- Replaced top-level function and generator body scans with structured statement lists.
- Added the structural pattern AST and core statement nodes for pattern bindings, mutation, assignment, expression statements, exits, debug/fatal forms, cleanup registration, conditionals, ordinary and pattern-matching while loops, and generator yield.
- Added host and compiler-stage checks for nested function control flow and structured generator bodies.

### 0.2.40 - 2026-06-14

- Standardized value equality on `==` across accepted shape and normative syntax/expression chapters.
- Added the shared structured expression AST for constant initializers, function contracts, and declaration guards, including named-field construction/update and one-expression explicit-capture closures.
- Added parser enforcement and tests for non-chaining comparisons and explicit grouping of mixed bitwise, shift, rotate, arithmetic, comparison, and Boolean operator families.
- Updated compiler-stage fixture checks to inspect initializer, contract, and guard expression facts rather than spans alone.

### 0.2.39 - 2026-06-14

- Added structured foreign blocks with ABI literal, raw function signatures, and foreign constants.
- Added structured unsafe contracts with operation keys, module/additional invariants, and the closed D322 field vocabulary.
- Added focused host tests and two compiler-stage fixtures, bringing the implementation-gated supporting fixture count to twenty-six.
- Recorded the equality-spelling conflict that blocks the shared final expression parser pending language-shape judgment. Gate C remains open.

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
- Added `bin/kyokai.ml` as an early command scaffold. At that revision it exposed parser/package probes under `kyokai check`; the Phase 3 closeout later moved both probes under `kyokai internal` because they do not satisfy the accepted public `check` contract. `kyokai --version` remains public.
- Accepted and extracted D527: Kyokai now has a deny-only capability deny policy. Toolchain defaults, user/global config, manifest ceilings, and `--deny-capability <name>` compose by strictest policy; denied package, target, generator, test, docs, audit, publish, or execution requirements fail with diagnostics without changing source-level capability semantics.
- Extended `compiler/package/manifest/KyokaiPackageSource.ml` with the first workspace-manifest member expansion scaffold. It parses `[workspace].members` as an explicit TOML string-array subset, rejects mixed package/workspace manifests, rejects package manifests at the workspace-loader boundary, rejects escaping or duplicate workspace member paths, loads only listed package roots, and rejects duplicate package names across loaded members.
- Added host frontend tests for workspace manifest parsing, invalid member paths, duplicate member paths, explicit member loading, non-inference of unlisted packages, duplicate workspace package names, and missing member manifests. This is compiler-stage supporting evidence only; it does not claim package dependency resolution, lockfile ownership, public build/check command conformance, or workspace profile inheritance.
- Phase 3 package-source status now treats basic workspace member expansion as scaffolded. The loader also rejects module-root and workspace-member symlink escapes by canonical path containment. D528 makes the final resolver and lockfile schema specified, while inherited-loader wiring, dependency graph resolution, lockfile read/write, workspace profile inheritance, final AST construction, expression/type parsing, public command execution, and conformance-backed reporting remain open.
- Added the first `[dependencies]` manifest parser subset for D51/D528: workspace dependencies parse as `{ workspace = "name" }`; Git dependencies parse as `{ git = "url", rev = "commit" }` with optional `tag`; indexed dependencies parse as `{ index = "@scope/name", version = "^1.4" }`; `branch` is rejected because moving references are not stored in Kyokai manifests. This remains parsing/admission evidence only, not package graph resolution or lockfile evidence.

### 0.2.26 - 2026-06-03

- Re-audited `phase.md` against accepted shape, public toolchain spec chapters, and public service-routing obligations for accepted/spec-extracted work that was present but too compressed in the roadmap.
- Expanded Phase 8 with explicit homes for package-root local docs generation, Analysis Server/LSP shared-engine work, protocol/DX fixtures, `explain`, checked `fix`, audit, `bleedring`/`kyokaibleed`, REPL/eval/scratch service boundaries, ProofTrace tool integration, and command-matrix tests.
- Expanded Phase 12 with explicit homes for repository-owned `kdocs/`, package-index docs metadata, verified official package-doc rendering, docs-status states, local docs cache pulls, website source/deployment, service-board records, `kyokai-showcase`, community/forum boundaries, releases/downloads, setup action, OCI images, and `bleedring` distribution metadata.
- Added cross-phase ordering rows for diagnostic/fix safety, Analysis Server shared engine, `kdocs` metadata, sandbox runner, `bleedring`, and service-board records so these surfaces do not disappear behind broad tooling or ecosystem wording.
- Split Lane E into local DX, package ecosystem, and public infrastructure boards while preserving the rule that infrastructure status never becomes language semantics or compiler conformance.

### 0.2.25 - 2026-06-03

- Continued Phase 3 after Gate B closure by adding `compiler/package/manifest/KyokaiPackageSource.ml` as the package-manifest/source discovery and isolated source-set loading scaffold. It parses the required package manifest subset, rejects workspace manifests at this isolated boundary, validates package names, explicit module roots, and `[targets.<name>]` executable target tables, maps logical module names to `.kyo` / `.kai` source paths, discovers sources deterministically under `[layout].module_root`, rejects generated `.koi` and inherited `.aui` / `.aum` files under the module root, verifies parsed module declarations against manifest-rooted paths, and loads the parsed source skeleton set for one package.
- Started the physical language-tree migration for the Phase 3 Kyokai scaffolds and support tools: source roles and source text live under `compiler/frontend/source/`, lexical tokens under `compiler/frontend/lexer/`, surface parsing under `compiler/frontend/parser/`, package-manifest/source discovery under `compiler/package/manifest/`, host frontend tests under `test/host/frontend/`, conformance fixture tooling under `toolchain/conformance/`, and ProofTrace validation under `toolchain/prooftrace/`. Public path references, ProofTrace artifacts, and Dune include-subdir settings were updated with the move.
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

- Added the isolated `compiler/frontend/lexer/KyokaiLexicalToken.ml` frontend scaffold without wiring it into inherited parsing or ownership-sensitive lowering. The scanner covers initial Kyokai comment, ASCII-identifier, keyword, punctuation, numeric-boundary, CRLF-span, and selected inherited-form rejection cases.
- Added focused host tests and registered the lexical-token boundary in ProofTrace as proof-relevant frontend semantics. The isolated scanner now tokenizes static-string, raw-string, code-point, and byte literal families with the closed escape grammar plus the accepted `@embedBytes` / `@embedText` comptime-builtin family. Parser integration, stable diagnostic codes, formatter integration, and exhaustive conformance fixtures remain open.
- Added the isolated `compiler/frontend/source/KyokaiSourceText.ml` source-byte contract scaffold for strict UTF-8 validation, BOM rejection, LF/CRLF and bare-CR handling, Unicode-scalar diagnostic columns, and executable-entry shebang gating. The validated representation now feeds the isolated scanner, and the source-role scaffold selects shebang policy from `.kyo` / `.kai` role plus a caller-provided executable-entry fact. Executable-target discovery and loader wiring remain open.
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
