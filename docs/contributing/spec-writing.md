# Writing Kyokai Spec And Accepted Shape

This guide is the public contributor-facing rule for writing Kyokai D-points, accepted-shape text, and spec prose.

`PROJECT_STANDARDS.md` defines the repository workflow, PR/MR process, D-point acceptance process, and source-of-truth order. This guide defines the contributor-facing writing contract.

> Trace: D507-D508, D523, D562a, D577-D581
> Covers: Public D-points live in reviewable PRs/MRs, accepted behavior receives a public destination without vague modal wording, and contributors use this self-contained writing guide.

## Authority Order

1. `kyokaispec/` is normative once a rule is written there.
2. `kyokaidecided.md` is accepted shape waiting for spec extraction.
3. Public PRs/MRs carry live proposals and final wording.
4. `Kyokaishape.md` is the public temporary holding area and decision/index/archive ledger when a D-point has no better canonical PR/MR home.
5. Issues and discussions are motivation and pre-proposal material.
6. `phase.md` orders implementation and proof work only.

Spec prose must not invent behavior. If the behavior is missing, open or update a D-point.

Routing a D-point number to a chapter is not extraction. A `Trace` or `Covers` block is not evidence that every accepted clause was written. Extraction is complete only when the accepted mechanics themselves are present and contradictions are removed.

## Proposal Anatomy

A proposal PR/MR includes:

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

Public proposals do not carry internal A/B/C option menus. They propose one explicit rule. Public review can revise that rule, and the proposal records rejected alternatives only when the rejection matters for future traceability.

Final wording comes before acks. A general agreement with an idea is not an accepted shape until the final rule text exists and is accepted by administered members. It receives a D-point number when it is written into `kyokaidecided.md`.

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

## Clause-Level Extraction Worksheet

Before writing prose, decompose every touched accepted D-point into distinct clauses. Use one row per live obligation, including clauses that reject a form or preserve an exact spelling/value.

| Field | Required content |
| --- | --- |
| Clause identity | Stable local identifier under the D-point or accepted source. |
| Accepted source | Exact heading plus quoted/paraphrased mechanic or source hash/span. |
| Surface | Syntax, API, command, schema, document, or service behavior. |
| Static behavior | Lookup, typing, universes, ownership, borrows, capabilities, visibility, coherence, and legality. |
| Dynamic/tool behavior | Evaluation/order, blocking, allocation, cleanup, failure, termination, outputs, mutation, and external effects. |
| Artifact behavior | `.koi`, manifest, lockfile, cache, generated files, provenance, source maps, and machine schemas. |
| Compatibility/target behavior | Edition, target, profile, toolchain, schema, SemVer, and migration effects. |
| Diagnostics/examples/tests | Stable rejection category, examples, illegal forms, and conformance plan. |
| Destination/status | Exact public home and `missing`, `partial`, `complete`, `not applicable` with reason, or `superseded`. |

A D-point is not `SPEC_EXTRACTED` while any live row is missing, partial, contradictory, or represented only by a navigation citation. When one D-point contains multiple independent mechanics, the worksheet keeps them separate even if they land in the same chapter.

The checked registries live in `kyokaispec/extraction/`: `pre-d558.toml`,
`d558-d625.toml`, and `d627-d635.toml`. Their generated review sheets are not
edited by hand. From the repository root, `make check-clause-extraction`
verifies inventory closure, accepted-source digests, canonical individual or
grouped trace rows, destinations, exact-name and rejected-active-form
tripwires, supersession edges, and generated output. A new range can reuse the
schema and checker only after its required-decision set, review identity,
clause applicability, and source boundary are explicit.

For exact accepted names and values—keywords, built-ins, types, commands, file extensions, manifest keys, schema versions, numeric widths, and rejected spellings—add search tripwires. Search is not semantic proof; it is a cheap way to catch omissions that prose review often misses.

## Large Spec Change Review

A PR/MR touching more than one chapter family or more than five D-points includes a review packet with:

1. clause worksheet before and after the change;
2. contradictions and supersession edges discovered;
3. exact-name/value tripwire results;
4. contract-table coverage;
5. modal-word audit with each hit classified;
6. examples and diagnostic changes;
7. `.koi`/artifact/schema impact;
8. calculus/proof impact;
9. conformance and implementation impact;
10. public-document version/review impact;
11. reviewer disposition for every incomplete or not-applicable row.

Large generated diffs do not replace this packet. A reviewer must be able to see which accepted clauses became normative and which remain open.

## Public Document Identity

A maintained public document declares these independent facts through its header or the checked public-document registry:

- stable document ID;
- document revision;
- document class and current status;
- source revision or source-registry digest;
- last substantive review date and owner;
- superseded-by and supersedes relations;
- applicable language edition, toolchain range, schema ranges, target scope, and accepted-D-point cutoff.

Do not compress these axes into a single version number. A language edition does not identify a document revision, a source commit does not claim a review, and an accepted-D-point cutoff does not claim implementation or conformance. Released normative snapshots are immutable. Living documents say that they are unreleased; generated documents name their source registry and generator version and remain non-editable projections.

A draft or insufficiently identified document can inform work, but it cannot support compatibility, conformance, proof, release, or operational-service claims. Public links and release artifacts retain access to the exact document revision that governed them.

## Specification And Calculus Correspondence

Every semantic spec change includes a proof-impact record. Every calculus rule, abstraction, lemma family, executable trace, and Lean theorem identifies the normative clauses and surface/core/IR facts that it represents or explicitly excludes. The record binds source revision, clause IDs, calculus revision, compiler-IR schema, trusted assumptions, exclusions, reviewer, and disposition.

Use one D580 impact class:

| Class | Minimum consequence |
| --- | --- |
| `NO_SEMANTIC_IMPACT` | Record why no mapping, model, proof, IR, conformance, or claim changes. Editorial link repair does not replay theorems. |
| `MAPPING_ONLY` | Update forward and reverse correspondence records and review the changed mapping. |
| `MODEL_AFFECTING` | Update definitions and executable traces, rerun affected model evidence, and review downstream proof/claim impact. |
| `PROOF_AFFECTING` | Update affected lemmas/theorems and verification evidence, then obtain the required revision-bound proof review. |
| `CLAIM_INVALIDATING` | Downgrade or withdraw the affected public claim until repaired evidence and review are admitted. |

A proof/model clarification closes as a normative correction, a reviewed model-only abstraction in `kyokaicalculus/deviation.md`, or a pending D-point. Source meaning cannot change only inside proof material. `kyokaicalculus/findings-divergence.md` is the public mismatch intake; a routed finding remains open until every affected spec, calculus, proof, IR, test, and claim artifact is updated and reviewed.

Machine-readable links generate forward and reverse views, but bookkeeping never establishes semantic equivalence. Unknown correspondence blocks the affected Gate-A, proof-tier, or release claim rather than unrelated implementation work.

## Revision-Bound Proof Review Packets

A `paper-proven` claim names an immutable review packet bound to a source commit or tree digest, theorem IDs, proof revision, model revision, Lean revision, and verification commands. The packet records:

- the reviewer's display name or stable public identity;
- relationship to authorship and relevant competence;
- review date, exact review class, scope, and checklist;
- findings, severities, responses, and repair revisions;
- unresolved assumptions and exclusions;
- final disposition and any carry-forward decision.

`maintainer`, `AI`, `community`, or `independent` is a class, not an identity. Author/lead review, AI-assisted review, community review, and independent qualified human review remain distinct labels. A material proof, calculus, or semantic-spec change invalidates or narrows the old packet according to its D580 impact record. Missing or stale review evidence downgrades the claim; ProofTrace can verify binding and coverage, not the mathematics.

## Monthly And Release-Bound Review Record

D562a adds a recurring review layer on top of individual PR/MR review:

- each active calendar month checks the accepted-D-point, amendment, supersession, and calculus-finding delta and deeply reviews at least one rotating chapter family;
- each language/toolchain release candidate checks the complete accepted delta since the previous release, every changed clause and affected unchanged cross-reference, grammar/API/artifact schemas, examples, diagnostics, traceability, calculus impact, implementation/conformance status, and generated output;
- a no-change month still records its cutoff and evidence;
- the record binds decision cutoff, source/spec revision, release/edition, clauses, reviewer role, tools, findings, dispositions, exclusions, and blockers;
- findings are classified as editorial defect, missing extraction, accepted/spec contradiction, stale example/diagnostic, calculus correspondence gap, implementation-status overclaim, or new semantic question;
- accepted final D-point text resolves contradictions; a new semantic question requires another D-point;
- unresolved contradictions, missing accepted clauses, stale generated output, or unclassified semantic findings block the affected Gate A/release claim;
- records are append-only and later repairs link back.

The review record proves that named material was checked at a named revision. It does not by itself prove the compiler implements the text or that a calculus theorem covers it.

## Normative And Rationale Prose Modes

Normative rules use the shortest form that remains complete: grammar, legality condition, state transition, failure, artifact fact, diagnostic, and example. Metaphor, scene-setting, atmospheric repetition, personal voice, and congratulatory conclusions do not sit between the condition and its rule.

Rationale may use Rikona's direct and physical writing voice when it clarifies pressure or consequence. It still ends in the exact rule, does not invent evidence, and does not repeat a setting or metaphor after it has done its work. A reader performing repeated lookup should reach the normative mechanism before the literary explanation.

## Write Clauses A Human Can Use

A specification is read out of order. Someone arrives with one broken program,
one compiler diagnostic, or one artifact and needs the rule without reading the
project's history. Write for that lookup.

1. Begin with the condition that selects the rule.
2. Name the compiler pass, tool, runtime actor, or program operation responsible
   for the behavior when that actor matters.
3. State what is legal. State the important illegal form beside it.
4. Separate static rejection from runtime failure. Do not make one sentence
   carry both when the boundary becomes hard to see.
5. State ordering, ownership, authority, allocation, blocking, cleanup, target,
   artifact, and compatibility facts only where they apply; do not imply them
   through adjectives such as “safe”, “robust”, or “portable”.
6. Reuse the same technical noun for the same concept. A compiler does not
   become an engine, translator, and processor for stylistic variety.
7. Give each paragraph one job. Remove a final sentence that only explains the
   paragraph again.
8. Use a table when three or more cases share fields or when readers must
   compare mappings. Two unrelated facts do not need a table.
9. Use examples to expose a boundary, failure, or interaction. Do not repeat in
   prose what the example already makes obvious.
10. Keep metaphor, scene-setting, personal voice, praise, and dramatic closure
    in rationale. End a normative section when its contract is complete.
11. A concrete name, number, quotation, citation, or platform fact must come
    from accepted text, source, tests, or a verified external reference. Style
    does not authorize invented detail.
12. Do not repair model-like prose by swapping flagged words. Repair the missing
    actor, mechanism, condition, evidence, or paragraph structure.

Passive voice, repeated normative terms, nominalizations, lists, and exact
parallel grammar are not defects by themselves. Change them only when they
hide the actor, flatten distinct rules, or make the clause harder to predict
from. The target is readable technical truth, not detector evasion.

## Examples And Diagnostics

Behavioral spec sections include examples unless the behavior is impossible to demonstrate in source or CLI form. Examples are illustrative unless the section says they are conformance tests.

Diagnostics include stable code, severity, source span or artifact path, human message, machine category, and fix ID when a machine-applicable fix exists.

## PR/MR Checklist

Before a proposal or spec PR/MR merges:

- accepted behavior is written directly
- rejected alternatives are named when they matter
- required contract table exists
- `kyokaidecided.md` is updated for accepted shape
- `kyokaispec/` is updated when the spec home exists
- traceability and phase/status rows are updated
- tests or conformance plans are named
- public docs use provenance-free project voice
- every cited repository path and external source is public and reader-accessible
- the applicable clause registry and generated review are current
- `make check-spec-integrity` passes locally and in the Git workflow

The author performs extraction. GitHub Actions verifies its recorded shape:
clause completeness metadata, accepted-source identity, destination presence,
generated review freshness, spec-source coverage, and ProofTrace consistency.
Automation cannot determine that prose faithfully expresses the accepted rule.
The named reviewer compares the clause with its accepted source and owns that
judgment.

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

## Umbrella And Child Decisions

An umbrella proposal contains only its explicit invariant, scope, exclusions,
stable obligation list, dependency edges, and closure rule. Acceptance reserves
an explicitly `PROPOSED` D-point ID for every required child. The child body has
one canonical public home in its PR or the temporary-holding section of
`Kyokaishape.md`; a tracker row replaces the body when ownership moves.

Do not infer an unanswered child mechanic from the umbrella's direction.
Record umbrella state as `OPEN_CHILDREN`, `CHILDREN_DECIDED`,
`CHILDREN_RESOLVED`, or `EXTRACTED`, and close each child explicitly. An
umbrella reaches `SPEC_EXTRACTED` only when it and every accepted normative
child pass clause-level extraction.

## Specification Versions And Release Knowledge

The assembled specification uses forward-only SemVer. Classify incompatible
released normative change as major, backward-compatible normative additions or
new declared boundaries as minor, and accepted-meaning-preserving repairs as
patch. Released snapshots are immutable. Do not use pre-1.0 status to avoid the
classification.

A release review records the specification version separately from language
edition, toolchain/schema versions, calculus epoch/revision, proof revisions,
accepted D-point cutoff, XP set, targets, source digests, generated artifacts,
and supersession. The release knowledge manifest joins these identities; it
does not replace any of them.
