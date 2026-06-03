# Writing Kyokai Spec And Accepted Shape

This guide is the public contributor-facing rule for writing Kyokai D-points, accepted-shape text, and spec prose.

`PROJECT_STANDARDS.md` defines the repository workflow, PR/MR process, D-point acceptance process, and source-of-truth order. This guide defines the contributor-facing writing contract.

> Trace: D507-D508, D523
> Covers: Public D-points live in reviewable PRs/MRs, accepted behavior receives a public destination without vague modal wording, and contributors use this self-contained writing guide.

## Authority Order

1. `kyokaispec/` is normative once a rule is written there.
2. `kyokaidecided.md` is accepted shape waiting for spec extraction.
3. Public PRs/MRs carry live D-point proposals and final wording.
4. `Kyokaishape.md` is an index, archive, migration ledger, or temporary holding area.
5. Issues and discussions are motivation and pre-proposal material.
6. `phase.md` orders implementation and proof work only.

Spec prose must not invent behavior. If the behavior is missing, open or update a D-point.

## D-Point Anatomy

A D-point PR/MR includes:

- question
- use case
- current state
- prior art
- explicit proposed shape
- rationale
- rejected alternatives only when their rejection matters for traceability
- consequences
- spec target or workflow-only target
- traceability/status updates

Public D-points do not carry internal A/B/C option menus. They propose one explicit rule. Public review can revise that rule, and the D-point records rejected alternatives only when the rejection matters for future traceability.

Final wording comes before acks. A general agreement with an idea is not an accepted D-point until the final rule text exists and is accepted.

## D-Point Citation Rule

A D-point identifier is a traceability tag, not an explanation. When public prose cites a D-point, the same paragraph, table row, or immediately adjacent text states the operational rule that matters at that location. A reader must not need to open another file merely to discover what the citation requires.

Status boards and extraction queues can group D-point ranges when the row names the mechanics covered by that range. Normative chapters, guides, and examples state the mechanic directly and use the D-point ID as supporting traceability.

## Accepted-Shape Wording

Accepted-shape text states the rule directly. It includes the surfaces needed by a spec writer:

- syntax, command, API, document, service, or workflow surface
- static semantics when source code is affected
- ownership, borrowing, linearity, capability, visibility, and `.koi` effects when relevant
- runtime or tool behavior
- target/profile/backend behavior
- diagnostics and illegal forms
- generated artifacts, cache effects, provenance, and reproducibility effects
- interactions with existing accepted decisions
- rejected alternatives

Do not write accepted-shape prose as a summary of the discussion. Write it as pre-spec semantics.

## Modal Words

Public accepted shape and spec text do not use vague modal wording. Before merge, classify every `may`, `should`, `optional`, `if provided`, `if admitted`, `future`, `later`, `where relevant`, `unspecified`, and `implementation-defined` occurrence as one of these exact categories:

- source permission
- non-observable optimization
- full-conformance or target-gated rule
- policy choice
- target-contract variation
- specified nondeterminism
- tooling-only assistance
- experimental or absent boundary
- tracked D-point dependency
- rationale-only prose
- new pending D-point

If the category is not one of those, rewrite the sentence.

## Contract Tables

A spec chapter that defines user-visible behavior includes the applicable table.

Language behavior tables list syntax, static semantics, ownership/linearity impact, borrow impact, capability impact, lowering, runtime behavior, failure category, diagnostics, `.koi` facts, examples, illegal forms, and related D-points.

Toolchain behavior tables list command/API surface, inputs, outputs, policy keys, target/profile/backend effects, cache/artifact effects, network authority, diagnostics, human output lanes, JSON schema version, reproducibility facts, prompts/interactivity, exit classifications, examples, and related D-points.

Standard-library behavior tables list module/API, ownership, allocation, capabilities, blocking, cancellation, failure, invalidation, complexity, determinism, target gates, unsafe/FFI status, tests/oracles, examples, and admission status.

Workflow or infrastructure documents list role, authority boundary, source of truth, owner, inputs, outputs, status, and traceability.

## Examples And Diagnostics

Behavioral spec sections include examples unless the behavior is impossible to demonstrate in source or CLI form. Examples are illustrative unless the section says they are conformance tests.

Diagnostics include stable code, severity, source span or artifact path, human message, machine category, and fix ID when a machine-applicable fix exists.

## PR/MR Checklist

Before a D-point or spec PR/MR merges:

- accepted behavior is written directly
- rejected alternatives are named when they matter
- required contract table exists
- `kyokaidecided.md` is updated for accepted shape
- `kyokaispec/` is updated when the spec home exists
- traceability and phase/status rows are updated
- tests or conformance plans are named
- public docs use provenance-free project voice
- every cited repository path and external source is public and reader-accessible

## ProofTrace Blocks

D526 requires each normative chapter with decision traces to register one public ProofTrace ID. Add the chapter marker near the opening trace material:

```text
> ProofTrace: SPEC-LANGUAGE-11-LINEARITY-BORROWING-AND-REGIONS
> Covers: This chapter is registered in the public ProofTrace evidence graph; registration does not claim implementation, conformance, or theorem completion.
```

The corresponding registry record lives in `kyokaiproofstatus.toml`. `kyokaiproofstatus.md` is generated output; do not edit it manually.

ProofTrace keeps specification, implementation, conformance, and proof state separate. A chapter registration states where a contract lives. It does not claim the compiler implements the chapter, tests cover it, or a theorem proves it. Tooling-only and workflow-only records can state `proof_required = false`, but they use one closed reason category and remain subject to correctness, test, conformance, security, and review requirements.

Before merge, run:

```bash
make proofstatus
make check-prooftrace
```
