# Governance

[Rikona Kurasaki / Mjoyufull]
> ProofTrace: SPEC-APPENDICES-E-GOVERNANCE
> Covers: This chapter is registered in the public ProofTrace evidence graph; registration does not claim implementation, conformance, or theorem completion.

Kyokai is a maintainer-led project with an administered-member governance model.

The project does not use a BDFL model, which would make one person the required decision point for minor choices and pull requests. It also does not use pure majority rule: Kyokai's accepted design goals, linearity bounds, and capability guarantees remain constraints on proposals until changed through the decision process.

Proposals pass through a 3-ack gate among administered members or through a public `Lead YES` from the lead maintainer. The structure is informed by the freedesktop governance model.

> Trace: Governance Model Update
> Covers: Kyokai's governance model is maintainer-led with an administered-member 3-ack gate and a Lead YES override.

[Rikona Kurasaki / Mjoyufull]
## The Proposal Flow

Language semantics, standard-library contracts, and toolchain behavior do not change silently. A proposed change begins with a public proposal.

The proposal flow is:

1. **Open a Proposal**: Open a PR or MR, or place the canonical public proposal in the temporary-holding section of `Kyokaishape.md`, using the standard proposal template in `PROJECT_STANDARDS.md`.
2. **Debate**: The shape is debated publicly.
3. **Final Wording**: The final proposed rule text is written.
4. **Gather Acks**: The proposal must gather 3 acks from administered members listed in `MEMBERS.md`, or receive a `Lead YES` from the lead maintainer.
5. **Decision**: The maintainer marks the proposal decided or sends it back for wording.
6. **Ledger Update**: A contributor or maintainer moves the decided shape into `kyokaidecided.md`. Ordinary proposals receive a D-point number at acceptance; children required by an accepted umbrella can already have explicitly `PROPOSED` reserved IDs.
7. **Extraction**: The normative text is extracted to `kyokaispec/` when the spec section exists.

A PR that changes language semantics, toolchain behavior, or stdlib APIs cannot merge without an accepted proposal. If a maintainer or co-contributor implements the change first, the PR is still subject to the discussion process and must gather acks or a Lead YES.

> Trace: Governance Model Update
> Covers: All changes require a public proposal, acks from administered members or Lead YES, and a public D-point record.

## Acks and Lead YES

Acks happen *after* final wording is proposed. Earlier agreement with the direction does not close the proposal.

The `Lead YES` path is a public decision-flow status. The lead maintainer can accept final wording directly without waiting for 3 acks. But a `Lead YES` does not remove the requirement for exact final text, accepted-shape extraction, traceability, and status updates. The rule must still be written down.

## Separation of Governance and Semantics

This governance model applies to the `kyokai-lang/kyokai` project, not to the language as a semantic requirement. Independent implementations need not use this governance model, but conforming implementations must follow the normative language and toolchain contracts.

> Trace: Governance Model Update
> Covers: Governance rules are project-specific and decoupled from language semantics, allowing independent implementations.

## Accepted Text And Review Cadence

Accepted final D-point wording controls intended design until another accepted
D-point amends or supersedes it. A specification edit has no authority to
change that design. A contradiction is a specification defect and reopens the
affected Gate-A claim; implementation does not get to invent a third rule.

Every active calendar month has a specification review record. Every language
or toolchain release candidate requires another. Monthly review checks accepted
decisions, amendments, supersessions, and calculus findings, and deeply reviews
at least one rotating chapter family. A month with no semantic change still
records what was checked.

A release review covers the accepted delta since the preceding release, all
affected cross-references, grammar and artifact schemas, examples, diagnostics,
traceability, calculus impact, implementation and conformance status, and
generated output. Records bind the decision cutoff, revisions, release or
edition, clause IDs, reviewer role, tools, findings, dispositions, exclusions,
and blockers. Unresolved contradictions, missing accepted clauses, stale
generated output, or unclassified semantic findings prevent Gate-A closure.

> Trace: D562-D562a
> Covers: Decisions outrank editable prose, and periodic review creates revision-bound evidence rather than ceremonial sign-off.

## Clause-Level Extraction Evidence

Each accepted or pending D-point is decomposed into stable clause IDs for every
applicable syntax/API, static, dynamic, ownership, borrow, capability, failure,
artifact, diagnostic, compatibility, target, example, illegal-form, and
conformance obligation. A clause records its accepted source span or digest,
normative, workflow, or service destination, extraction state, supersession
edge, reviewer, and evidence links.

Extraction states are `missing`, `partial`, `complete`,
`not-applicable-with-reason`, and `superseded`. `SPEC_EXTRACTED` requires every
live clause to be complete or validly not applicable. Traceability, maturity,
and Gate-A summaries are generated or checked views of this registry. Routing
text and a chapter's `Covers` line cannot promote maturity.

Multi-clause changes carry a generated accepted-wording checklist showing what
was added, changed, omitted, contradicted, or superseded. Exact-name and
contradiction checks cover keywords, built-ins, commands, types, manifests,
numeric values, and explicitly rejected alternatives. Automation checks record
completeness; semantic fidelity remains human review.

The checked machine registries are
`kyokaispec/extraction/d558-d625.toml` and
`kyokaispec/extraction/d627-d635.toml`. The project checker expands each listed
decision into stable `<decision>.<obligation-category>` clause IDs, verifies
the accepted-source heading and digest, destination files, trace row,
exact-name and rejected-active-form tripwires, review identity, proof impact,
and supersession edge, then checks each generated review sheet and the named
traceability, maturity, and Gate-A projections. Omitted categories become
`not-applicable-with-reason`; they are not silently dropped. These registries
establish D577 evidence only for their named ranges. Earlier accepted ranges
require their own checked entries before the global Gate-A audit can close.

The author performs extraction in the PR/MR that makes accepted text
normative, or in an explicitly linked extraction PR/MR with a named owner.
GitHub Actions runs `make check-spec-integrity` when specification,
accepted-shape, calculus, ProofTrace, clause-registry, or governing workflow
paths change. The check rejects stale registry evidence, generated reviews,
source inventories, and ProofTrace views. It does not write normative prose or
decide whether the prose faithfully implements the accepted rule; the named
reviewer remains responsible for that comparison.

> Trace: D577
> Covers: Extraction maturity is clause evidence, not confidence in a routing table.

## Public Document Identity

Every maintained public document has a stable document ID, document revision,
class, status, source revision, last substantive review date, owner, and
supersession relations. Language edition, toolchain range, KBI, manifest,
lockfile, diagnostic and documentation schema ranges, target scope, and
accepted-D-point boundary are separate optional axes.

Released normative snapshots are immutable. A living development specification
identifies its source revision and unreleased status. Generated documents name
their registries and generator versions and are not independently editable
sources. A checked registry produces the public document index, verifies
headers, links, supersession, edition claims, source hashes, and review age, and
preserves the exact governing revision at public URLs and in release/package
artifacts. An insufficiently identified document is draft and cannot support a
compatibility, conformance, proof, release, or service claim.

The assembled normative specification has a forward-only Semantic Versioning
identity. The versioned public contract includes normative language,
toolchain, standard-library, artifact, compatibility, target, and
project-governance requirements. An incompatible released change outside an
already declared edition or compatibility boundary advances the major version.
A backward-compatible normative addition or new declared boundary advances the
minor version. A correction that preserves accepted meaning advances the patch
version. Pre-1.0 specifications follow the same classification.

Every project release publishes a knowledge manifest. It binds the
specification version, language edition, toolchain and schema versions,
calculus family, model epoch and revision, proof-artifact revisions, latest
accepted D-point, active XP set, target scope, source digests, generated
outputs, review records, and supersession state. These are separate identity
axes; one number does not stand in for another. Stable-carried experiments are
listed in an experimental annex or profile and remain outside stable semantics.

> Trace: D578
> Covers: Document revision, language edition, artifact schema, target, and decision boundary remain distinct identities.

## Typed Finding Intake

Project findings use exactly one class: `DEFECT`,
`AUTHORIZED_KNOWN_ISSUE`, `DPOINT_CANDIDATE`, `XP_CANDIDATE`, `RESEARCH`,
`DIRECTION`, or `REJECTED`. Records retain origin, evidence, impact, scope,
owner, authority, next action, status, duplicate links, and transition history.

Only the lead maintainer authorizes additions to the private known-issue ledger,
accepts D-points, and grants those governance transitions. AI tools may propose
classification, evidence, options, and wording; they have no governance vote.
Changing a class is explicit and authorized. “Discussed” is not “resolved.”
Public status contains accepted or authorized work; private direction material
may retain clearly labeled candidates.

A PR-local finding does not require a duplicate issue. Before merge, its named
reviewer records the finding's class, owner, authority, next action, and
disposition. A `DPOINT_CANDIDATE` receives a public proposal or temporary
holding entry and records its allocated D-point ID. Routing is not resolution.

Every repository release has an append-only implementation review covering the
changed shipped boundaries, conformance and adversarial evidence, targets and
native providers, generated artifacts, diagnostics, security, packaging, and
evidence gaps. The main repository reviews its compiler, runtime, standard
library, toolchain, bundled first-party packages, schemas, and workloads as one
project release. A separately released repository owns its own review.

The review closes as `NO_HOTFIX_REQUIRED` or freezes a required hotfix set. A
hotfix is the smallest justified repair and receives another review. A further
hotfix requires a newly established repair. Unclassified findings, missing
owners, or evidence that differs from shipped artifacts keep the review open.

> Trace: D614
> Covers: Findings can move between evidence, work, experiment, and decision states only through an explicit human-authorized transition.

## Umbrella Decisions And Gated Children

An umbrella D-point decides only its explicit invariant, scope, exclusions,
obligation list, and closure rule. Obligations have stable identities and
dependency edges. Accepting the umbrella immediately creates every required
child with a reserved D-point ID and `PROPOSED` state. A number is not evidence
of acceptance.

Each child has one canonical editable home: its public PR, the temporary-holding
section of `Kyokaishape.md`, or the private planning ledger while still
internal. Moving a proposal to a PR leaves a public tracker row. Umbrella
closure is `OPEN_CHILDREN`, `CHILDREN_DECIDED`, `CHILDREN_RESOLVED`, or
`EXTRACTED`. A child closes only as accepted, rejected, withdrawn, superseded,
or explicitly not applicable.

An umbrella cannot claim `SPEC_EXTRACTED` until it and every accepted normative
child pass clause-level extraction checks. Generated traceability exposes the
dependency graph, canonical homes, current states, accepted cutoff, XP
relationships, and extraction and evidence gaps.

> Trace: D628-D630, D634-D635
> Covers: Versioned public knowledge, PR-local findings, release review, umbrella closure, and public temporary holding remain explicit project contracts.
