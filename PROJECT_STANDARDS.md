# Kyokai Project Standards

**Document Version:** 0.3.3
**Last Updated:** 2026-05-30
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

## 2. Primary Documents

| Path | Role |
| --- | --- |
| `kyokaispec/` | Normative Kyokai spec as it is written. |
| `kyokaidecided.md` | Public accepted-shape extraction while the spec is being written. |
| `Kyokaishape.md` | Historical/index tracker for public D-points that do not live directly in a PR/MR. |
| `phase.md` | Implementation/proof roadmap and ordering gates. |
| `CODE_STANDARDS.md` | Mandatory code standards for compiler, runtime, stdlib, and future Kyokai code. |
| `PROJECT_STANDARDS.md` | This workflow document. |
| `CONTRIBUTING.md` | External contributor guide. |
| `docs/contributing/spec-writing.md` | Public guide for writing D-points, accepted shape, and spec prose. |
| `docs/infrastructure/services.md` | Public service/infrastructure ownership board. |

### 2.1 Source-Of-Truth Order

When files disagree, use this order:

1. `kyokaispec/` once a rule is written there.
2. `kyokaidecided.md` for accepted public shape not yet fully spec-extracted.
3. Public PRs/MRs that carry live D-point proposals and final wording.
4. `Kyokaishape.md` for historical/index tracking when a D-point does not live directly in a PR/MR.
5. Issues and discussions as motivation or pre-proposal material, not accepted shape.
6. `phase.md` for implementation order only.

`phase.md` is not a language spec. It can say when work should happen, what blocks what, and what counts as done, but it should not invent semantics.

### 2.2 Public Documentation Voice

Rules:

- Public docs should read like project-maintained material with stable, provenance-free wording.
- Do not write chat-style provenance, transcript-style phrasing, or scratch-note wording.
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

### 3.2 Public Shape And D-Point Work

This includes language proposals, syntax/semantics changes, stdlib-surface decisions, toolchain contracts, governance rules, and compatibility rules.

Rules:

- New public D-points normally live in PRs/MRs once they become concrete change proposals.
- `PROJECT_STANDARDS.md` owns the public D-point template. `Kyokaishape.md` can index, archive, or temporarily host proposals that do not yet have a PR/MR.
- A proposal must state the question, use case, current state, prior art, exact proposed shape, rationale, consequences, rejected alternatives when they matter for traceability, and spec target.
- A D-point needs final written shape before acks count.
- A decided D-point needs at least 3 community acks on the final shape plus maintainer acceptance, or an explicit `Lead YES`.
- After acceptance, update the PR/MR, `kyokaidecided.md`, `kyokaispec/` when the relevant spec section exists, traceability, and status docs before merge.

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


### 3.5 Website, Docs Site, And Infrastructure Work

Website, package-docs, package-index, playground, release, community, showcase, and advisory work is public infrastructure work. It does not decide language semantics by itself.

Rules:

- Keep service roles separated even when one deployment serves multiple roles.
- Record service ownership in `docs/infrastructure/services.md` once the service exists or is actively built.
- Website copy that describes behavior links to `kyokaispec/` or `kyokaidecided.md`.
- Borrowed OSS website, docs, playground, or CI code requires license compatibility, attribution, provenance notes, and removal of foreign branding/semantics.
- Package docs and showcase surfaces do not imply package trust, official support, vulnerability clearance, or source authority.
- Custom auth, databases, or hosted execution need explicit service records and accepted authority boundaries before becoming official.

## 4. Branching Strategy

### 4.1 Primary Branches

| Branch | Purpose | Push Policy |
| --- | --- | --- |
| `main` | Releases and living public docs. | Code reaches `main` through release or hotfix branches. Docs may target `main` directly by PR. |
| `dev` | Integration branch for implementation work. | Feature/fix/refactor/code PRs target `dev`. |

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
| Docs | `docs/name` | `main` unless tied to code |
| Release | `release/version` | from `dev`, merge to `main`, then back to `dev` |
| Hotfix | `hotfix/version-or-topic` | from `main`, merge to `main`, then back to `dev` |

### 4.3 Main And Dev

- Code work enters through `dev`.
- Release branches carry code from `dev` to `main`.
- Docs-only work may target `main`.
- After docs land on `main`, merge `main` into `dev` so development has current docs.
- After a hotfix lands on `main`, merge `main` back into `dev` so the fix is not lost.

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

### 5.3 Shape / D-Point PR Checklist

- [ ] Uses the D-point template from this file.
- [ ] States the question and use case.
- [ ] Compares prior art.
- [ ] Includes one explicit proposed shape and its rationale.
- [ ] Marks whether the proposed wording is final and ready for acks.
- [ ] Tracks ack state when final wording exists.
- [ ] Does not claim implementation/spec status before it exists.
- [ ] Names the ProofTrace impact: new record, updated record, or no registered-boundary change.

### 5.4 Spec PR Checklist

- [ ] Links the D-point or accepted-shape source.
- [ ] Names the affected `kyokaispec/` path.
- [ ] States compiler/test impact.
- [ ] Updates `kyokaidecided.md` or `Kyokaishape.md` if public shape status changed.
- [ ] Adds conformance tests if the implementation already exists.
- [ ] Avoids vague implementation-defined behavior.
- [ ] Registers or updates the chapter-level ProofTrace record and runs `make check-prooftrace`.

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


### 5.7 Infrastructure / Website PR Checklist

- [ ] Names the service role or website/doc family affected.
- [ ] States whether the surface is normative, derived, editorial, interactive, or operational.
- [ ] Updates `docs/infrastructure/services.md` when service ownership or deployment changes.
- [ ] Links accepted D-points/spec sections for behavior claims.
- [ ] Records OSS provenance, license compatibility, and local modifications when reusing infrastructure.
- [ ] Avoids custom auth, persistent data, hosted execution, or secrets without an accepted service record.

## 6. Public D-Point Process

Public language evolution uses D-points. The point of the process is not ceremony. The point is that accepted behavior has a public trail and ends up in the accepted-shape ledger, the spec, conformance tests, and implementation status.

### 6.1 When A D-Point Is Required

Use a D-point for changes affecting:

- syntax
- type system behavior
- linearity/borrowing
- runtime termination behavior
- FFI/unsafe/backend contract
- stdlib public API policy
- package/toolchain behavior
- compatibility, editions, releases, or governance
- anything where a reasonable implementation could make different choices

Small typo fixes, non-semantic docs cleanup, test-only coverage, and clear bookkeeping fixes do not need D-points.

Implementation tasks do not become D-points merely because they are large. Use issues, PRs, phase rows, and tests for ordinary implementation tracking. Open a D-point when the task changes or reveals language/toolchain/stdlib semantics.

### 6.2 Where A D-Point Lives

A D-point can be motivated in a discussion, issue, chat log, review comment, or maintainer note, but the concrete public D-point normally lives in a PR/MR marked with `dpoint-needed` or `dpoint`. The PR/MR is the reviewable artifact because it can carry the proposed wording, accepted-shape extraction, spec changes, traceability changes, and tests in one diff.

`Kyokaishape.md` is not the required home for new D-point bodies. It can be used as an index, archive, migration ledger, or temporary holding area when a proposal is not yet ready for a PR/MR. Issues and discussions can collect critique and motivation, but they do not become accepted shape by themselves.

### 6.3 Proposal Requirements

Every public D-point includes:

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

1. Proposal opens.
2. Shape is debated publicly.
3. The proposed final wording is written down.
4. The final wording gets community acks, or the lead maintainer uses `Lead YES`.
5. The maintainer marks it decided or asks for another wording pass.
6. The decided shape is copied into `kyokaidecided.md` and queued or patched into `kyokaispec/`.
7. The PR/MR also updates traceability, phase/status boards, conformance plans, and implementation issue links when they are affected before merge.

Acks before final wording do not close the D-point. They are useful signal, not the decision.

### 6.5 Maintainer Role

Kyokai is maintainer-led. Community acks are normal public signal, but the maintainer owns final wording quality, consistency with Kyokai's philosophy, and whether the spec text is precise enough to ship.

The lead maintainer may close a D-point with an explicit `Lead YES` without waiting for the community ack count. `Lead YES` is not a shortcut around rigor: final wording, accepted-shape extraction, traceability, and affected status docs are still required. Solo-maintainer work uses the same artifacts with fewer people involved.

### 6.6 Status Words

Use these status words for public shape tracking:

- `PROPOSED`: opened but not shaped enough to decide.
- `SHAPE_DEBATING`: the proposed shape is being debated.
- `FINAL_TEXT_PROPOSED`: final wording exists and can be acked.
- `ACKED`: final wording reached 3 acks.
- `LEAD_YES`: lead maintainer accepted final wording directly.
- `DECIDED`: maintainer accepted the final shape.
- `SPEC_EXTRACTED`: normative text exists in `kyokaispec/`.
- `CONFORMANCE_BACKED`: executable conformance tests exist.
- `IMPLEMENTED`: compiler/toolchain/stdlib implementation exists.

A point can be `DECIDED` before it is `SPEC_EXTRACTED`, `CONFORMANCE_BACKED`, or `IMPLEMENTED`. Those statuses track maturity, not whether the design question is closed.

Decision state, spec state, implementation state, conformance state, and proof state are separate axes. Do not collapse them in PR text, docs, status boards, or release notes. A D-point marked `DECIDED` means the shape is accepted. It does not mean the parser accepts it, the checker enforces it, the runtime implements it, the stdlib admits it, conformance tests cover it, or a proof includes it. Claims of implementation, testing, proof, conformance, or release readiness must name the concrete path or artifact that proves that claim.

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

Recommended header shape:

```markdown
### D41: Bitwise Operators **[DECIDED | SPEC_EXTRACTED | NAV: kyokaispec/src/7.expressions.md]**
```

If the spec section is not written yet:

```markdown
### D300: Example Feature **[DECIDED | NAV: pending kyokaispec section]**
```

Use `NAV:` to point at the real public home. Do not write historical movement notes in public headers.

### 6.8 D-Point Template

````markdown
### D300: Short Name **[PROPOSED | NAV: pending kyokaispec section]**

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
- Acks: 0/3 or Lead YES
- Decided: no
````

After it is decided and moved into the spec:

````markdown
### D300: Short Name **[DECIDED | SPEC_EXTRACTED | NAV: kyokaispec/src/path.md]**

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

After a public D-point closes:

1. Re-read the final public thread/PR and current files.
2. Update the D-point PR/MR status and ack state; update `Kyokaishape.md` only when it is acting as the index/archive for that point.
3. Add or update the public extraction in `kyokaidecided.md`.
4. Add or update normative spec text in `kyokaispec/` when that spec area exists.
5. Update `phase.md` if the decision changes implementation order, gates, or done-when checks.
6. Update tests/examples when implementation exists or when conformance examples are part of the decision.
7. Update the decision traceability appendix when the spec destination or maturity state changes.
8. Grep for stale contradictory wording.

Do not patch unrelated decisions just because they are nearby.

### 6.11 Public Spec And Accepted-Shape Authoring

Contributor-facing spec prose is written from public sources: accepted D-points, `kyokaidecided.md`, `kyokaispec/`, public PR/MR discussion, and public issues/discussions. Public files link only repository paths and external sources that readers can open.

`docs/contributing/spec-writing.md` is the public spec-writing guide. It explains:

- D-point anatomy and final-shape wording
- modal-word classification and rewrite rules for normative prose from D479-D487
- required language, toolchain, and standard-library contract tables from D502
- spec homes and traceability updates
- diagnostics, examples, target gates, and `.koi` facts
- standard-library contract, edge-case, test, oracle, and compatibility admission records from D501
- workflow-only versus normative-spec destinations

A D-point PR/MR that asks for spec prose links `docs/contributing/spec-writing.md` and identifies the relevant table family or spec-home template.



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

## 8. Early Development Release Policy

Kyokai is not on a normal consumer release cadence yet.

During early development:

- releases happen when the maintainer judges the toolchain coherent enough
- public docs may describe accepted shape before implementation if status is clear
- spec sections may be incomplete, but incomplete sections must not pretend to be exhaustive
- implementation experiments may exist, but they do not define the language contract

When releases become consumer-facing, use SemVer for toolchain releases and document compatibility clearly. Release branches should contain version bumps, release notes, final verification, and release-doc updates only.

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

Hotfixes are rare emergency changes from `main`.

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
- Do not accept a D-point before final wording exists.
- Do not count general agreement as final acks.
- Do not let compiler implementation define language semantics by accident.
- Do not leave inherited Austral docs claiming Kyokai is still Austral.
- Do not write public docs with transcript-style or scratch-note wording.
- Do not release without tests and release notes.
- Do not hide unsafe, FFI, backend, allocation, blocking, or authority consequences.

## 14. Useful Commands

Current inherited compiler checks are still evolving. Prefer project-local scripts where available.

```bash
./run-tests.sh
./run-examples.sh
dune build
dune runtest
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
