# Kyokai Project Standards

**Document Version:** 0.5.2
**Last Updated:** 2026-07-20
**Scope:** Kyokai repository workflow, public design process, spec work, implementation work, documentation, reviews, releases, and project maintenance

This file defines how Kyokai work moves through the repo. It covers code, public language shape, spec text, docs, reviews, releases, and maintenance expectations.

Kyokai is early, but it is moving into public development. The workflow needs to allow fast iteration without letting accepted behavior drift between discussions, docs, specs, tests, and compiler code.

## 1. Core Principles

1. **The spec is the destination.** Public design shape becomes real only when it can be written precisely enough for `kyokaispec/`.
2. **No compiler-first language drift.** Implementation experiments do not define Kyokai semantics until the public design/spec path accepts them.
3. **Public semantic decisions need a trail.** Non-trivial language, toolchain, stdlib, runtime, compatibility, package-index, release-shape, or governance changes go through D-points.
4. **Final wording before acks.** Acks count only after the proposed final shape is written down.
5. **Code changes go through PRs.** Even solo work should be reviewable after the fact.
6. **Docs and tests are part of the change.** Behavior changes need matching docs/spec/tests or an explicit reason they cannot land yet.
7. **Explicitness beats cleverness.** The workflow should reinforce Kyokai's language values: no hidden semantics, no UB, no authority by accident.
8. **Public docs stand on their own.** Public files should read like maintained project material with stable, provenance-free wording.
9. **Authority stays human.** AI systems may research, critique, draft, test, and perform explicitly authorized edits; they do not count as administered members, acknowledgers, reviewers required by a claim tier, or decision authorities.

## 2. Primary Documents

| Path | Role |
| --- | --- |
| `kyokaispec/` | Normative Kyokai spec as it is written. |
| `kyokaidecided.md` | Public accepted-shape extraction while the spec is being written. |
| `Kyokaishape.md` | Public temporary holding area, active-proposal tracker, decision index, migration ledger, and historical archive. |
| `phase.md` | Implementation/proof roadmap and ordering gates. |
| `notinnormativespec.md` | Generated public view of typed implementation findings; never semantic authority. |
| `CODE_STANDARDS.md` | Mandatory code standards for compiler, runtime, stdlib, and future Kyokai code. |
| `PROJECT_STANDARDS.md` | This workflow document. |
| `CONTRIBUTING.md` | External contributor guide. |
| `docs/contributing/spec-writing.md` | Public guide for writing D-points, accepted shape, and spec prose. |
| `docs/infrastructure/services.md` | Public service/infrastructure ownership board. |

### 2.1 Source-Of-Truth Order

When files disagree, use this order:

1. Accepted final D-point wording in `kyokaidecided.md` or its canonical public PR/MR controls intended design until a later accepted D-point amends or supersedes it.
2. `kyokaispec/` is the normative conformance contract after extraction. It must agree with accepted wording; a disagreement is a specification defect and reopens the affected Gate-A boundary rather than silently changing the decision.
3. `Kyokaishape.md` carries public proposals in temporary holding, tracker/index material, and history when a PR/MR does not own the complete proposal.
4. Issues and discussions provide motivation or pre-proposal material, not accepted shape.
5. `phase.md` controls implementation order only.

`phase.md` is not a language spec. It can say when work should happen, what blocks what, and what counts as done, but it should not invent semantics.

### 2.2 Public Documentation Voice

Rules:

- Public docs should read like project-maintained material with stable, provenance-free wording.
- Do not write chat-style provenance, transcript-style phrasing, or scratch-note wording.
- Public docs describe accepted behavior, current status, or named planned target shape as project facts. They do not give contributors future instructions in prose such as "before release, do X" when the rule can be written as a release criterion, status row, checklist item, or service obligation.
- Normative specifications, accepted-shape ledgers, rationale, and reference documents speak to the general public by stating rules, facts, examples, and rationale. They do not address the lead maintainer, contributors, or an implied reader with conversational instructions. Contributor guides, workflow documents, command documentation, checklists, and status documents can use instructional language only for the action that document exists to direct.
- Accepted-shape history is preserved. When a later D-point changes an earlier decision, the earlier entry is marked `SUPERSEDED` or `AMENDED`, names the replacing D-point, and briefly states the replacement. The old rule remains readable as history instead of being silently rewritten.
- `.public.txt` records public-document roots and standalone public planning files. Files under those roots do not reference internal-only documents, absolute local paths, private notes, or unpublished local provenance.
- Keep docs direct and human.
- If docs describe behavior, point to accepted shape or spec where practical.
- Inherited Austral docs must be updated before they are treated as Kyokai docs.

## 3. Work Streams

Kyokai has four normal work streams.

### 3.1 Compiler, Runtime, And Standard Library Work

This includes OCaml compiler changes, runtime support, generated C behavior, stdlib modules, tests, and build tooling.

Rules:

- Follow `CODE_STANDARDS.md`.
- Link the relevant accepted shape or spec section in the PR.
- If behavior is not decided, open a D-point before treating the implementation as the language contract.
- Runtime/FFI/backend work must state UB, ownership, ABI, and failure-mode consequences.
- Tests are expected for parser, type checker, linearity, diagnostics, backend behavior, and stdlib contracts as applicable.
- Changes to ownership, cleanup, failure, concurrency, layout, FFI, hot reload, or native-provider behavior review the applicable `examples/adversarial/` families. The PR changes a case or states why no case changes.
- Source files start with the license header required by `CODE_STANDARDS.md`. New Kyokai-owned files use the Kyokai SPDX identifier for their path class; inherited files preserve inherited notices unless the file is replaced or relicensed.
- Every touched inherited compiler/runtime/stdlib module has a `RETAIN`, `ADAPT`, `REPLACE`, or `DELETE` disposition in the compiler inventory or PR/MR. Rewriting is the implementation of `REPLACE`, not an untracked status.
- Scaffolds live only in draft/non-default experimental work, use distinct artifact identity, and cannot write reduced incompatible versions of stable public formats.

### 3.2 Public Shape And D-Point Work

This includes language proposals, syntax/semantics changes, stdlib-surface decisions, toolchain contracts, governance rules, and compatibility rules.

Rules:

- New proposals normally live in PRs/MRs. `Kyokaishape.md` is the public temporary home when a PR does not yet own the complete proposal; an issue can carry motivation or continuing discussion.
- `PROJECT_STANDARDS.md` owns the public proposal template.
- A proposal must state the question, use case, current state, prior art, exact proposed shape, rationale, consequences, rejected alternatives when they matter for traceability, and spec target.
- A proposal needs final written shape before acks count.
- A decided proposal needs at least 3 acks from administered members listed in `MEMBERS.md`, or an explicit `Lead YES`.
- After acceptance, the accepted shape is written into `kyokaidecided.md` and assigned a D-point number.
- Update the PR/MR, `kyokaispec/` when the relevant spec section exists, traceability, and status docs before merge.

### 3.3 Spec Work

This includes writing and maintaining `kyokaispec/`.

Rules:

- Spec text should be normative, not conversational.
- Every accepted behavior needs explicit syntax, static semantics, runtime behavior, errors, and interactions where relevant.
- Toolchain behavior belongs in the spec when users rely on it.
- Do not write "implementation-defined" unless the bounds of implementation choice are themselves specified.
- Apply D479-D487 during accepted-shape and spec work: modal words such as `may`, `should`, `optional`, `if provided`, `if admitted`, `future`, `unspecified`, and `implementation-defined` must be classified as source permission, non-observable optimization, full-conformance/target-gated rule, policy choice, target-contract variation, specified nondeterminism, tooling-only assistance, experimental/absent boundary, tracked D-point dependency, rationale-only prose, or a new pending D-point.
- Spec chapters that define user-visible behavior include the applicable D502 contract matrix: language rules record syntax, static semantics, ownership, borrows, capabilities, lowering, runtime behavior, failures, diagnostics, `.koi` facts, examples, illegal forms, and related decisions; toolchain rules record command/API surface, inputs, outputs, policy keys, target/profile/backend effects, cache/artifact effects, network authority, diagnostics, human and machine output, reproducibility, prompts, exits, and examples; stdlib rules record API, ownership, allocation, capabilities, blocking, cancellation, failure, invalidation, complexity, determinism, target gates, unsafe/FFI status, tests/oracles, examples, and admission status.
- Spec/compiler disagreement is a bug.

Readable specification prose follows the contract, not a house mannerism. Put
the condition before the consequence. Name the actor that checks or performs
an operation. Reuse the exact technical term instead of rotating synonyms.
Split a sentence when one clause states legality and another states runtime
behavior or failure. A paragraph has one job; delete a closing sentence that
only repeats it. Tables are for repeated fields or real comparisons, not for
making two facts look formal. Normative clauses do not use metaphor,
salesmanship, fake quotations, vague authority, decorative conclusions, or
invented specificity. Rationale can carry voice and prior art, but it cannot
define the rule by implication.

### 3.4 Public Documentation Work

This includes README, contributing docs, roadmap docs, decided-shape docs, examples, tutorials, and generated documentation.

Rules:

- Public files reference only public repository paths and public external sources.
- D-point IDs are traceability tags, not substitutes for an explanation. A public D-point citation states the operational rule in the same paragraph, table row, or immediately adjacent text.
- Status and extraction tables can group D-point ranges only when the row states the mechanics covered by the range.

- Keep docs direct and human.
- Use maintained project prose rather than conversation fragments or report voice.
- If docs describe behavior, they should point to accepted shape or spec where practical.
- Inherited Austral docs must be updated before they are treated as Kyokai docs.
- Public examples must state whether they are accepted, experimental, or aspirational.
- Maintained public documents carry a stable document ID, document revision, class, status, source revision, last substantive review date, owner, and supersession links. Applicable language edition, toolchain/schema ranges, target scope, and accepted-D-point cutoff are separate fields rather than one overloaded version.
- Released normative snapshots are immutable. Living and generated documents identify their source revision/registries and generator version. A draft or unversioned document cannot establish compatibility, conformance, proof, release, or service status.


### 3.5 Website, Docs Site, And Infrastructure Work

Website, package-docs, package-index, playground, release, community, showcase, and advisory work is public infrastructure work. It does not decide language semantics by itself.

Rules:

- Keep service roles separated even when one deployment serves multiple roles.
- Record service ownership in `docs/infrastructure/services.md` once the service exists or is actively built.
- Website copy that describes behavior links to `kyokaispec/` or `kyokaidecided.md`.
- Borrowed OSS website, docs, playground, or CI code requires license compatibility, attribution, provenance notes, and removal of foreign branding/semantics.
- Package docs and showcase surfaces do not imply package trust, official support, vulnerability clearance, or source authority.
- Custom auth, databases, or hosted execution need explicit service records and accepted authority boundaries before becoming official.
- Bootstrap vulnerability intake uses `SECURITY.md` plus repository private vulnerability reporting and security advisories. The service remains `LIMITED_SINGLE_OWNER` until a real backup/recovery owner exists; project text does not promise 24/7 response, a paid SLA, or redundant infrastructure that is not operated.
- Private case data remains separate from public advisory projections. Provider failure, embargo, revocation, incident, retention, redaction, and recovery procedures are service-board facts, not implications of publishing a policy file.

## 4. Branching Strategy

### 4.1 Primary Branches

| Branch | Purpose | Push Policy |
| --- | --- | --- |
| `main` | Releases and living public docs. | Code reaches `main` through release or hotfix branches. Docs may target `main` directly by PR. |
| `dev` | Integration branch for implementation work. | Feature/fix/refactor/code PRs target `dev`. |
| `experimental` | Integration branch for accepted XP investigations only. | XP draft PRs target `experimental`; the branch is never wholesale merged into `dev`. |

### 4.2 Branch Naming

| Type | Naming | Target |
| --- | --- | --- |
| Feature | `feat/name` | `dev` |
| Fix | `fix/name` | `dev` |
| Refactor | `refactor/name` | `dev` |
| Compiler pass | `compiler/pass-name` | `dev` |
| Stdlib | `stdlib/module-name` | `dev` |
| Runtime/backend | `runtime/name`, `backend/name` | `dev` |
| Spec | `spec/section-name` | usually `main`, or `dev` if tied to code |
| Public shape | `shape/dNNN-short-name` | usually `main`, or PR thread with label |
| Experiment Point | `xp/NNN-short-name` | `experimental` through a draft PR |
| Docs | `docs/name` | `main` unless tied to code |
| Release | `release/version` | from `dev`, merge to `main`, then back to `dev` |
| Hotfix | `hotfix/version-or-topic` | from `main`, merge to `main`, then back to `dev` |

### 4.3 Main And Dev

- Code work enters through `dev`.
- Release branches carry code from `dev` to `main`.
- Docs-only work may target `main`.
- After docs land on `main`, merge `main` into `dev` so development has current docs.
- After a hotfix lands on `main`, merge `main` back into `dev` so the fix is not lost.
- Merge current `dev` into `experimental` regularly so experiments test the active compiler. Never merge the whole `experimental` branch into `dev`; a successful XP graduates through a focused reviewed PR.

### 4.4 Active Bootstrap Maintainer Mode

Before Kyokai's public collaboration and hosted-service workflow is operational, the lead maintainer may work offline on a dirty local `main` worktree and may batch private research, planning, proof, spec, and implementation changes. A dirty bootstrap worktree is not by itself a workflow violation.

This mode does not weaken artifact truth:

- no status or review claim may imply that uncommitted work was merged, released, independently reviewed, or available to another contributor;
- reports bind observations to a commit plus explicit dirty-worktree state;
- unrelated work is preserved and is not normalized or discarded by tools/AI;
- before public merge, release, outside review, or collaboration handoff, the relevant changes are split into reviewable commits/PRs by evidence boundary and follow the normal target-branch rules;
- generated outputs, public/private boundaries, license/provenance, tests, and ProofTrace remain required even during bootstrap.

The lead maintainer explicitly ends bootstrap maintainer mode when the public branch/PR workflow becomes the normal development path. No contributor or AI can infer that transition from repository visibility alone.

### 4.5 Experiment Points And Xperimental Releases

An Experiment Point (`XP-NNN`) is a time-bounded evidence investigation, not an accepted feature. Its record contains a question, competing hypotheses, corpus, metrics, rejection criteria, owner, dates, security and compatibility boundary, artifact/cache isolation, and final disposition.

Rules:

- An XP normally branches from current `dev` as `xp/NNN-short-name` and opens a draft PR to lowercase `experimental`. Branch, PR, diagnostics, reports, versions, and artifacts carry the XP ID.
- Before integration, the XP runs its declared host, conformance, regression, security, artifact-isolation, and workload tests. Passing does not establish stable conformance or accepted semantics.
- Experimental source, `.koi`, manifests, lockfiles, caches, generated C, binaries, diagnostics, and reports use XP-qualified identities and separate install/cache/output roots. A consumer accepts them only when it explicitly enables and understands the same XP.
- The Xperimental channel publishes at most one scheduled release per week and only when included code or evidence changed. Its manifest binds base `dev`, included XP revisions, known failures, security scope, expiry, schemas, and feedback route.
- An XP closes as rejected, inconclusive, an ordinary implementation task, or a pending D-point. Semantic graduation requires accepted shape, complete spec/diagnostic/migration/conformance work, and a focused reviewed PR to `dev`.
- Expired, rejected, and inconclusive experiments leave current Xperimental builds. Historical artifacts remain unsupported.

D625 permits a distinct stable-carriage outcome after Rikona accepts a normal
D-point for it. Stable carriage means a released distribution contains the XP
implementation disabled by default; it does not mean the experiment is stable
semantics or stable conformance.

- Stable carriage enters `dev` through a focused reviewed PR. The
  `experimental` branch is never merged wholesale.
- A project enables stable-carried XPs only through root
  `[experimental].enable = ["XP-NNN"]`. There is no global "enable all" switch.
- Every affected artifact, cache key, report, diagnostic, and reproduction
  record carries the XP identity. Non-enabling consumers reject it.
- A published package or knot using the XP is marked experimental in its index
  metadata, docs, dependency constraints, admission status, and support policy.
- A stable-carried XP first appears in a minor or major release. Patch releases
  can contain compatible fixes for an already-carried XP but cannot add one.
- Graduation, incompatible revision, or removal requires another accepted
  D-point and the same specification, migration, conformance, and review duties
  as any other public behavior change.

## 5. Pull Request Rules

### 5.1 All PRs

Every PR should include:

- summary of what changed
- why it changed
- testing performed or why tests were not run
- docs/spec impact
- ProofTrace impact: new record, updated record, or no registered-boundary change
- linked issue, D-point, or rationale when relevant

Use squash merge by default unless the commit series is intentionally meaningful.

### 5.2 Code PR Checklist

- [ ] Targets `dev`.
- [ ] Follows `CODE_STANDARDS.md`.
- [ ] Links accepted shape/spec section or opens a D-point for new behavior.
- [ ] Adds or updates tests.
- [ ] Updates diagnostics/goldens if user-facing errors changed.
- [ ] Updates docs/spec if user-visible behavior changed.
- [ ] States runtime/FFI/backend safety impact when applicable.
- [ ] Updates `kyokaiproofstatus.toml` and required `kyokai:prooftrace` boundary comments when the change affects a registered or newly spec-relevant boundary.

### 5.3 Shape Proposal PR Checklist

- [ ] Uses the proposal template from this file.
- [ ] States the question and use case.
- [ ] Compares prior art.
- [ ] Includes one explicit proposed shape and its rationale.
- [ ] Marks whether the proposed wording is final and ready for acks.
- [ ] Tracks ack state from administered members when final wording exists.
- [ ] Does not claim implementation/spec/D-point status before it is accepted.
- [ ] Names the ProofTrace impact: new record, updated record, or no registered-boundary change.

### 5.4 Spec PR Checklist

- [ ] Links the D-point or accepted-shape source.
- [ ] Names the affected `kyokaispec/` path.
- [ ] States compiler/test impact.
- [ ] Updates `kyokaidecided.md` or `Kyokaishape.md` if public shape status changed.
- [ ] Adds conformance tests if the implementation already exists.
- [ ] Avoids vague implementation-defined behavior.
- [ ] Registers or updates the chapter-level ProofTrace record and runs `make check-prooftrace`.
- [ ] Includes a clause inventory for every touched D-point: syntax/API, static semantics, runtime/tool behavior, ownership/borrows, capabilities, failure, diagnostics, artifacts/`.koi`, target behavior, examples, illegal forms, compatibility, and tests, marking each `complete`, `not applicable` with reason, or still open.
- [ ] Compares every clause against the accepted source rather than relying on a D-point route or `Covers` sentence.
- [ ] Searches exact accepted spellings, numeric values, built-ins, commands, manifest forms, and explicitly rejected alternatives for omissions or contradictions.
- [ ] Does not mark `SPEC_EXTRACTED` while any live clause is missing, partial, contradictory, or routed only by number.
- [ ] Updates the applicable machine clause registry and runs `make check-clause-extraction` when the touched range is registered under D577.

Extraction is part of the Git change that makes accepted behavior normative.
The author writes the clause, updates its registry and generated review,
repairs contradictory public text, and updates maturity/status projections in
the same PR/MR unless the accepted proposal explicitly records a separately
owned extraction PR. GitHub Actions runs `make check-spec-integrity` for every
change to the specification, accepted-shape ledgers, calculus, ProofTrace,
clause registries, or governing workflow. That check verifies recorded
extraction and generated-view freshness. It cannot write missing clauses,
judge semantic fidelity, accept a D-point, or grant `SPEC_EXTRACTED`; those
remain author and reviewer responsibilities.

### 5.5 Docs PR Checklist

- [ ] Targets `main` if docs-only.
- [ ] Targets `dev` if coupled to implementation work.
- [ ] Removes inherited Austral wording when it no longer applies.
- [ ] Uses project-maintainer voice.
- [ ] Keeps examples aligned with accepted syntax/status.

### 5.6 Stdlib PR Checklist

Stdlib PRs must include the admission evidence required by D85, D229-D232, and D501 when the PR admits or changes a public standard-library API: contract fields, edge cases, tests or oracles, unsafe/FFI policy, compatibility boundary, tier, and release status.

- [ ] Names the stdlib tier and module family.
- [ ] Provides the API contract fields: ownership, allocation, capabilities, blocking, cancellation, failure, invalidation, complexity, determinism, target gates, unsafe/FFI status, and examples.
- [ ] Adds conformance, edge-case, and failure tests appropriate to the API.
- [ ] Adds property/fuzz tests when the API is parser, codec, collection, numeric, allocator, or protocol heavy.
- [ ] States whether implementation is native Kyokai, unsafe-internal, or transitional FFI.
- [ ] Updates `stdlib/11-transitional-ffi-tracking.md` or the equivalent tracking home for transitional wrappers.
- [ ] Updates generated docs or docs source.
- [ ] Links accepted D-points and spec homes.

Bridge collection PRs follow the same admission discipline plus the D529 bridge record. `Kyokai.Bridge.*` is official shipped integration code, not ordinary `kyokai vendor` output and not package-index dependency cache.

- [ ] Names the Bridge entry, admission state, owner, public modules, and whether the entry is binding, wrapper, generated binding set, port, adapter, or copied support code.
- [ ] Records upstream URL, exact revision or release, license/SPDX facts, copied-file inventory, local modifications, and generator command or `N/A`.
- [ ] States target/platform gates, native library/header/link requirements, unsafe contracts, capability requirements, and capability-deny behavior.
- [ ] Adds build/link smoke tests, unsafe/FFI wrapper tests, capability-deny tests, docs/audit extraction tests, and provenance drift checks appropriate to the entry.
- [ ] Confirms the entry does not silently fetch source, binaries, headers, package-index metadata, or docs during import or checking.
- [ ] Confirms ordinary dependency vendoring remains under `kyokai vendor` and does not copy or redefine installed Bridge modules.


### 5.7 Infrastructure / Website PR Checklist

- [ ] Names the service role or website/doc family affected.
- [ ] States whether the surface is normative, derived, editorial, interactive, or operational.
- [ ] Updates `docs/infrastructure/services.md` when service ownership or deployment changes.
- [ ] Links accepted D-points/spec sections for behavior claims.
- [ ] Records OSS provenance, license compatibility, and local modifications when reusing infrastructure.
- [ ] Avoids custom auth, persistent data, hosted execution, or secrets without an accepted service record.

### 5.8 C Toolchain Admission PR Checklist

D530 makes generated C the one maintained backend. A compiler-family or target admission changes the supported toolchain matrix and therefore needs reviewable evidence, not only a successful smoke build.

- [ ] Names compiler family/version range, target triple, C11/C17 mode, SDK/sysroot, linker, archiver, object format, and debug format.
- [ ] Records required flags and every admitted builtin, attribute, pragma, intrinsic, and inline-assembly family.
- [ ] Adds dialect, ABI/layout/calling, atomics, TLS, strict-float, volatile, stack, FFI, and runtime conformance tests.
- [ ] Adds `#line`, sidecar-map, debugger breakpoint/backtrace, symbol/local, sanitizer, coverage, and profiler mapping tests for the claimed support tier.
- [ ] Adds deterministic-output, path-remap, archive/link, raw-diagnostic capture, and external-tool build-plan tests.
- [ ] Records clean, incremental, and no-op compile-time measurements on named hardware without weakening checks or using stale artifacts.
- [ ] Lists unsupported surfaces and target-gated exclusions explicitly.
- [ ] Updates the target matrix, `phase.md`, ProofTrace, CI ownership, and public support claims in the same PR.
- [ ] Does not add a second Kyokai backend, backend selector, or backend-named output path.

## 6. Public Proposal and D-Point Process

Public language evolution happens through proposals that, once accepted, become D-points. The point of the process is not ceremony. The point is that accepted behavior has a public trail and ends up in the accepted-shape ledger, the spec, conformance tests, and implementation status.

### 6.1 When A Proposal Is Required

Use the proposal process for changes affecting:

- syntax
- type system behavior
- linearity/borrowing
- runtime termination behavior
- FFI/unsafe/backend contract
- stdlib public API policy
- package/toolchain behavior
- compatibility, editions, releases, or governance
- anything where a reasonable implementation could make different choices

Small typo fixes, non-semantic docs cleanup, test-only coverage, and clear bookkeeping fixes do not need proposals.

Implementation tasks do not become proposals merely because they are large. Use issues, PRs, phase rows, and tests for ordinary implementation tracking. Open a proposal when the task changes or reveals language/toolchain/stdlib semantics.

### 6.2 Where A Proposal Lives

A change can be motivated in a discussion, issue, chat log, review comment, or maintainer note. The complete public proposal normally lives in a PR/MR because the diff can carry wording, spec changes, and tests together. When no PR owns it yet, its canonical public body can live in the temporary-holding section of `Kyokaishape.md`.

`Kyokaishape.md` also tracks every active public proposal. Moving a proposal to a PR replaces its editable body with a tracker row pointing to that PR; it does not erase the proposal from navigation.

A standalone proposal normally receives its D-point number when accepted. A child required by an accepted umbrella receives a reserved D-point number immediately and is explicitly marked `PROPOSED`. A number is therefore never evidence of acceptance without its state.

### 6.3 Proposal Requirements

Every public proposal includes:

- **The question**: the exact design question.
- **Use case**: why this matters in real Kyokai code or tooling.
- **Current state**: what the language/toolchain currently says or does.
- **Prior art**: usually Austral first, then Rust/Zig/C, then domain-specific references if needed.
- **Proposed shape**: the exact normative rule, or text close enough to become normative spec prose, that the PR/MR asks Kyokai to accept.
- **Rationale**: why the proposed rule fits Kyokai.
- **Rejected alternatives**: competing shapes only when recording their rejection matters for traceability.
- **Consequences**: what gets harder, what gets simpler, and what other rules it touches.
- **Spec target**: where it should land in `kyokaispec/` once decided.

### 6.4 Debate Then Acks

The order matters:

1. Proposal opens (using the template below).
2. Shape is debated publicly.
3. The proposed final wording is written down.
4. The final wording receives 3 acks from administered members listed in `MEMBERS.md`, or the lead maintainer gives a `Lead YES`.
5. The lead maintainer marks it decided or asks for another wording pass.
6. A contributor or maintainer writes the decided shape into `kyokaidecided.md`. Ordinary proposals receive the next available D-point number; an umbrella-required child retains its reserved numbered identity and changes state from `PROPOSED`.
7. The normative text is extracted to `kyokaispec/`.
8. Implementation follows the accepted shape.

Acks before final wording do not close the proposal. They are useful signal, not the decision.

### 6.5 Roles

**Lead Maintainer:** Kyokai is maintainer-led. The lead maintainer owns final wording quality, consistency with Kyokai's philosophy, and whether the spec text is precise enough to ship. The lead maintainer may close a proposal with an explicit `Lead YES` without waiting for the ack count, or may reject a proposal that has acks.

**Administered Members:** Members listed in `MEMBERS.md` have the authority to ack final wordings, write decided shape into `kyokaidecided.md`, write spec prose, and perform PR reviews.

**Current operating mode:** When `MEMBERS.md` lists fewer than three independent administered members, the three-ack route is unavailable rather than symbolically satisfied. Decisions close only through an explicit lead-maintainer acceptance. Reviews by contributors or AI systems are advisory unless a separate public evidence rule grants that human reviewer a named review role; AI output never supplies an administered-member ack or an independent-human review claim.

### 6.5a Implementation-First Path

Maintainers and co-contributors may open PRs with implementation before a formal proposal is decided. However:
- They are still subject to the public discussion process.
- They must propose the semantic shape using the standard proposal format.
- They are required to make changes when requested after discussion.
- The implementation does not become the language contract until the shape goes through discussion and is accepted into `kyokaidecided.md` as a numbered D-point.

### 6.6 Status Words

Use these status words for public shape tracking during the proposal phase:

- `PROPOSED`: opened but not shaped enough to decide.
- `SHAPE_DEBATING`: the proposed shape is being debated.
- `FINAL_TEXT_PROPOSED`: final wording exists and can be acked by members.
- `ACKED`: final wording reached the administered-member threshold.
- `LEAD_YES`: the lead maintainer accepted the written final text directly.

Once accepted into `kyokaidecided.md`, the numbered D-point takes on maturity statuses:

- `DECIDED`: accepted into `kyokaidecided.md`.
- `SPEC_EXTRACTED`: every live accepted clause has checked normative destinations and is `complete` or `not-applicable-with-reason`; a chapter path or trace row alone is insufficient.
- `CONFORMANCE_BACKED`: executable conformance tests exist.
- `IMPLEMENTED`: compiler/toolchain/stdlib implementation exists.

Decision state, spec state, implementation state, conformance state, and proof state are separate axes. Do not collapse them in PR text, docs, status boards, or release notes. A D-point marked `DECIDED` means the shape is accepted. It does not mean the parser accepts it, the checker enforces it, the runtime implements it, the stdlib admits it, conformance tests cover it, or a proof includes it.

### 6.6b Umbrella And Gated D-Points

An umbrella decides only its written invariant, scope, exclusions, obligation list, and closure rule. Each obligation has a stable ID and dependency edges. Acceptance immediately creates every required child with a reserved D-point ID, `PROPOSED` status, and one canonical home.

Public children live in their PR or `Kyokaishape.md`; private drafting can live in the internal plan. Umbrella closure is recorded as `OPEN_CHILDREN`, `CHILDREN_DECIDED`, `CHILDREN_RESOLVED`, or `EXTRACTED`. A child closes only as accepted, rejected, withdrawn, superseded, or explicitly not applicable. The umbrella cannot claim `SPEC_EXTRACTED` while an accepted normative child lacks checked clause extraction.

### 6.6a ProofTrace Evidence Records

D526 requires a public ProofTrace evidence graph for spec-relevant semantic, toolchain, stdlib, backend, unsafe, conformance, and proof boundaries. `kyokaiproofstatus.toml` is the checked source registry. `kyokaiproofstatus.md` is generated public output and must not be edited manually.

Rules:

- Keep `spec_status`, `implementation_status`, `conformance_status`, and `proof_status` separate.
- Add or update a stable ProofTrace record when a change creates or changes a spec-relevant boundary.
- Add a language-appropriate `kyokai:prooftrace id=<record-id>` comment at each maintained code, harness, conformance, or proof boundary registered as comment-required.
- Do not mark every helper. A boundary marker covers subordinate implementation details until a narrower boundary becomes independently maintained.
- Use `proof_required = false` only with one closed reason category defined by the registry. This exemption does not waive testing, conformance, security, or review requirements.
- Treat ProofTrace metadata as tooling evidence only. It cannot affect language semantics, source acceptance, runtime behavior, or theorem truth.
- Run `make proofstatus` after registry edits and `make check-prooftrace` before merge.

Before committing a change that creates, removes, or changes a spec-relevant code, harness, conformance, or proof boundary:

1. Determine whether an existing ProofTrace record owns the boundary. Create a stable record ID only when the boundary is new or independently maintained.
2. Update `kyokaiproofstatus.toml` and place or update the required `kyokai:prooftrace id=<record-id>` comment at the owning boundary. Do not scatter markers across subordinate helpers.
3. Regenerate the public status board. Do not edit `kyokaiproofstatus.md` manually.
4. Run the checked validation lane from the repository root:

```bash
make proofstatus
make check-prooftrace
```

PR descriptions must state the ProofTrace impact even when the correct statement is `no registered-boundary change`.

### 6.7 Header Conventions

Use public navigation fields instead of historical section-movement notes.

Recommended header shape for proposals:

```markdown
### Proposal: Bitwise Operators **[FINAL_TEXT_PROPOSED]**
```

If the spec section is not written yet, you can indicate the target:

```markdown
### Proposal: Example Feature **[PROPOSED | TARGET: kyokaispec section]**
```

### 6.8 Proposal Template

````markdown
### Proposal: Short Name **[PROPOSED | TARGET: kyokaispec section]**

**The question**: What exactly are we deciding?

**Use case**: What real Kyokai code, tooling, stdlib work, or spec guarantee needs this?

**Current state**: What is currently decided, implemented, inherited from Austral, or missing?

**Prior art**:

| System | Shape | Notes |
| --- | --- | --- |
| Austral | ... | ... |
| Rust | ... | ... |
| Zig | ... | ... |
| C | ... | ... |

**Proposed shape**:

```text
Write the actual rule here. It should be close enough to become spec text.
```

**Consequences**:

- What this makes simpler.
- What this makes harder.
- Which existing decisions/spec sections it touches.

**Rationale**: Why does this exact rule fit Kyokai?

**Rejected alternatives**: Record only alternatives whose rejection matters for future readers. Omit this field when no rejected alternative needs a public record.

**Ack state**:

- Final wording posted: no
- Acks: 0/3 (Administered Members only) or Lead YES
- Decided: no
````

After it is accepted, it is written into `kyokaidecided.md` and receives its D-point number:

````markdown
### D300: Short Name **[DECIDED]**

**Spec home**: `kyokaispec/src/path.md`.

**The question**: ...

**Use case**: ...

**Justification**: Why this is the Kyokai shape.
````

### 6.9 Proposed-Shape Rationale Standard

A public proposed-shape rationale includes:

- what the D-point actually means
- what behavior the language/toolchain/stdlib must guarantee
- why the answer fits Kyokai specifically
- prior-art comparison
- hidden consequences and tradeoffs
- whether follow-up D-points are needed
- the explicit proposed rule text

Avoid aesthetic arguments dressed as technical reasoning. Kyokai can have taste, but accepted behavior needs operational reasons.

### 6.10 After Decision

After a public proposal is accepted:

1. Re-read the final public thread/PR and current files.
2. Update the PR/MR status.
3. Write the accepted shape into `kyokaidecided.md`, preserving its reserved D-point number or assigning the next unreserved number.
4. Add or update normative spec text in `kyokaispec/` when that spec area exists.
5. Update `phase.md` if the decision changes implementation order, gates, or done-when checks.
6. Update tests/examples when implementation exists or when conformance examples are part of the decision.
7. Update the decision traceability appendix when the spec destination or maturity state changes.
8. Grep for stale contradictory wording.

Do not patch unrelated decisions just because they are nearby.

### 6.11 Public Spec And Accepted-Shape Authoring

Contributor-facing spec prose is written from public sources: accepted D-points, `kyokaidecided.md`, `kyokaispec/`, public PR/MR discussion, and public issues/discussions. Public files link only repository paths and external sources that readers can open.

`docs/contributing/spec-writing.md` is the public spec-writing guide. It explains:

- Proposal anatomy and final-shape wording
- modal-word classification and rewrite rules for normative prose from D479-D487
- required language, toolchain, and standard-library contract tables from D502
- spec homes and traceability updates
- diagnostics, examples, target gates, and `.koi` facts
- standard-library contract, edge-case, test, oracle, and compatibility admission records from D501
- workflow-only versus normative-spec destinations

A proposal PR/MR that asks for spec prose links `docs/contributing/spec-writing.md` and identifies the relevant table family or spec-home template.



## 7. Reviews

Reviews exist to improve correctness, clarity, and shared understanding.

Review criteria:

| Area | What To Check |
| --- | --- |
| Correctness | Does the change do what it claims? |
| Spec alignment | Does behavior match accepted shape/spec? |
| Explicitness | Are semantics, allocation, blocking, authority, and failure visible? |
| Safety | Any UB, FFI, unsafe, or capability boundary concerns? |
| Tests | Are success and failure cases covered? |
| Docs | Did user-facing behavior get documented? |
| Maintainability | Is the change split well enough to review? |

Feedback should explain why. Nitpicks are non-blocking unless they affect standards or consistency.

### 7.1 Recurring Specification Review

D562a requires one append-only specification review record for every active calendar month and every language/toolchain release candidate. Monthly review covers the accepted-decision and calculus-finding delta plus a rotating deep chapter-family review. Release review covers the complete accepted delta since the previous release, every changed clause and affected cross-reference, schemas, examples, diagnostics, traceability, calculus impact, implementation/conformance status, and generated outputs.

Each record binds its accepted-D-point cutoff, source/spec revisions, release or edition, reviewed clauses, reviewer role, commands/tools, findings, dispositions, exclusions, and blockers. Findings use the D562a closed classes. A contradiction follows accepted final D-point text; a new semantic question opens a D-point. Review itself cannot decide semantics.

Gate A and a release review remain open while any accepted clause is missing, any accepted/spec contradiction is unresolved, generated output is stale, or a semantic finding is unclassified. Later repairs link to the original record; they do not rewrite it.

### 7.2 Calculus Impact And Proof Review

Every semantic spec change receives a D580 impact classification: `NO_SEMANTIC_IMPACT`, `MAPPING_ONLY`, `MODEL_AFFECTING`, `PROOF_AFFECTING`, or `CLAIM_INVALIDATING`. The record binds the affected clauses, calculus/model/proof material, compiler-IR schema, claim tier, source revisions, assumptions, exclusions, reviewer, and disposition. Proof or model work that discovers a source-semantic question routes it through `kyokaicalculus/findings-divergence.md` and a public D-point when accepted text does not already answer it.

A `paper-proven` claim requires the D581 immutable review packet described by `docs/contributing/spec-writing.md`. The packet identifies the reviewer rather than recording only a role label, distinguishes author/lead, AI-assisted, community, and independent qualified human review, and binds the exact reviewed revisions and commands. A material change invalidates or narrows prior review according to the impact record; missing current review evidence downgrades the claim instead of being hidden behind a stale label.

### 7.3 Implementation Findings And Post-Release Review

Implementation findings use the D614/D634 typed registry. A PR-local finding does not require a duplicate issue. Before merge, the named reviewer records its class, owner, authority, next action, and disposition. A semantic candidate receives a D-point proposal in the PR or `Kyokaishape.md`; recording or routing a finding does not decide it.

Every repository release receives an append-only implementation review of the changed shipped boundaries, conformance and adversarial evidence, targets and native providers, generated artifacts, diagnostics, security, packaging, and open gaps. The main repository review covers its compiler, runtime, standard library, toolchain, bundled first-party packages, schemas, and workloads together. Separately released repositories own separate reviews.

The review closes as `NO_HOTFIX_REQUIRED` or freezes a required hotfix set. A hotfix is the smallest repair justified by that set and receives its own review. Further hotfixes require newly established repairs; cadence never creates an empty hotfix.

## 8. Early Development Release Policy

Kyokai is not on a normal consumer release cadence yet.

During early development:

- releases happen when the maintainer judges the toolchain coherent enough
- public docs may describe accepted shape before implementation if status is clear
- spec sections may be incomplete, but incomplete sections must not pretend to be exhaustive
- implementation experiments may exist, but they do not define the language contract
- scaffolds and experiments remain non-default, use visibly experimental artifact identities, and cannot publish or overwrite stable-format artifacts
- the lead maintainer may use bootstrap maintainer mode from section 4.4; a clean worktree or public PR is required at public handoff/release boundaries, not as a precondition for private offline progress

When releases become consumer-facing, use SemVer for toolchain releases and document compatibility clearly. Release branches should contain version bumps, release notes, final verification, and release-doc updates only.

The assembled normative specification has its own forward-only SemVer version. Major changes are incompatible released normative changes outside a declared edition or compatibility boundary; minor changes add backward-compatible normative surface or declared boundaries; patch changes repair text without changing accepted meaning. Released snapshots are immutable. The release knowledge manifest separately binds spec version, edition, toolchain and schema versions, calculus epoch/revision, proof revisions, accepted D-point cutoff, XP set, source digests, generated outputs, and review records.

## 9. Release Branches

Release branches are created from `dev`.

Allowed on release branches:

- version bumps
- release notes
- final docs/version references
- final verification fixes to release metadata

Not allowed on release branches:

- new features
- refactors
- surprise language/spec changes
- unreviewed code changes

If a bug is found during release prep, fix it in `dev`, then merge the fix into the release branch or ship without it.

## 10. Hotfixes

Hotfixes are rare emergency changes from `main`, normally justified by the post-release review or a newly established urgent defect.

Hotfix flow:

1. Branch from `main`.
2. Apply the minimal fix.
3. Open PR to `main`.
4. Maintainer handles version bump and release.
5. Merge `main` back into `dev`.

Do not use hotfixes to bypass normal feature review.

## 11. Labels

Recommended labels:

- `d-point`
- `language-shape`
- `required`
- `target-gated`
- `compatibility-only`
- `experimental-only`
- `tooling-only`
- `absent`
- `rejected`
- `blocked-on-dpoint`
- `final-text-proposed`
- `needs-acks`
- `decided`
- `spec`
- `compiler`
- `stdlib`
- `runtime`
- `backend`
- `toolchain`
- `docs`
- `conformance`
- `unsafe-boundary`
- `needs-tests`
- `blocked`

## 12. Maintenance Rules

Maintenance changes are allowed, but they must be reviewable.

Rules:

- Read `PROJECT_STANDARDS.md` and `CODE_STANDARDS.md` before edits.
- Verify paths before patching.
- Keep patches scoped.
- Do not invent accepted semantics.
- Keep public docs in maintainer voice.
- State tests run or why none were run.
- Do not leave long-running commands active.

## 13. What Not To Do

- Do not push code directly to `main` or `dev`.
- Do not merge code without review.
- Do not accept a proposal before final wording exists.
- Do not count general agreement as final acks. Acks come from administered members.
- Do not let compiler implementation define language semantics by accident.
- Do not leave inherited Austral docs claiming Kyokai is still Austral.
- Do not write public docs with transcript-style or scratch-note wording.
- Do not release without tests and release notes.
- Do not hide unsafe, FFI, backend, allocation, blocking, or authority consequences.

## 14. Useful Commands

Current inherited compiler checks are still evolving. Prefer project-local scripts where available.

```bash
./run-tests.sh
dune build
dune runtest
make check-phase3-identity
make run-conformance-fixtures
make check-spec-integrity
```

Use targeted commands when a change only touches a narrow area, but state what was run in the PR.

## 15. Summary

The repo workflow is simple:

- public shape goes through D-points
- accepted behavior moves toward `kyokaispec/`
- implementation follows accepted shape
- tests and diagnostics prove behavior
- releases carry coherent toolchain states
- public docs stay clean, direct, and human
