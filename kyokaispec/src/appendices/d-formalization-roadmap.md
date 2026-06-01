# Formalization Roadmap

[Rikona Kurasaki / Mjoyufull]
This appendix records the proof road. It does not pretend the proof is already done. Kyokai's prose can state the language contract, but the sequential ownership core still needs the paper theorem before `v1.0` and later mechanization after self-hosting.

> Trace: D143/D241, D394, D477
> Covers: Kyokai requires a paper proof for the sequential core before `v1.0`, keeps zero-UB claims scoped to named evidence tiers, and schedules later mechanized proof work after self-hosting.

## Proof Scope

The first calculus is `lambda_K-seq`: a small sequential core for ownership, borrowing, moves, regions, linear consumption, pattern binding, control-flow joins, checked failure, and TPOE. It deliberately excludes concurrency, FFI, backend lowering, package resolution, the full stdlib, and toolchain behavior.

> Trace: D143/D241, D90, D245
> Covers: The first formalization is sequential and excludes concurrency, FFI, backend, and stdlib/toolchain layers.

## Required Paper Artifact

The paper proof must define abstract syntax, typing judgments, store/ownership state, borrow-region state, small-step operational semantics, checked failure/TPOE outcomes, progress, preservation, and the exact theorem statement for the safe sequential core. Any gap must be named as an assumption or excluded feature.

> Trace: D73, D143/D241
> Covers: The paper proof must specify syntax, typing, semantics, failure outcomes, and soundness theorem scope.

## Milestones

| Milestone | Output | Status Meaning |
| --- | --- | --- |
| Scope freeze | Feature list for `lambda_K-seq` with exclusions. | The calculus knows what it is proving. |
| Core syntax | Abstract syntax for expressions, statements, owners, borrows, regions, and failure forms. | Surface syntax is not required; elaborated core is enough. |
| Static judgments | Typing, ownership, borrowing, movement, region, and control-flow join judgments. | The checker rules have a proof-facing shape. |
| Dynamic semantics | Small-step semantics with store, ownership state, and named failure outcomes. | Evaluation behavior is explicit. |
| Soundness theorem | Progress/preservation adapted to linear ownership and TPOE. | The theorem says what cannot go wrong and what may terminate. |
| Paper proof | Human-checkable proof document. | Required before `v1.0`. |
| Mechanized plan | Proof assistant selection and encoding strategy. | Planned after self-hosting; Coq is the current likely first target. |

> Trace: D143/D241
> Covers: Formalization work proceeds through explicit artifacts instead of vague proof intent.

## Relation To Existing Notes

`kyokaicalculus/lambda_k_research.md` is the research note. `kyokaicalculus/kyokaicalculusdirection.md` is the file-by-file execution plan. `kyokaicalculus/scope.md` freezes the first theorem boundary, and `kyokaicalculus/claim-tiers.md` defines the evidence vocabulary. Draft statics, dynamics, lemma, elaboration, extension, and later-boundary files assign the remaining work. `kyokaicalculus/paper-proof.md` now carries the initial preservation-or-defined-failure and progress-or-defined-failure derivation draft, states its assumptions, and lists its excluded features. That artifact remains `intended-by-spec`; review and derivation closure are still required before Kyokai claims `paper-proven` evidence.

> Trace: D143/D241
> Covers: The research note and direction file inform proof work but do not replace the required proof artifact.

## Current Calculus Artifacts

| Artifact | Current status | What it establishes |
| --- | --- | --- |
| `kyokaicalculus/scope.md` | `intended-by-spec` scope freeze | `lambda_K-seq` includes sequential ownership, lexical borrow regions, explicit reborrow, minimal sums/results, checked TPOE, and sealed capabilities; cleanup, panic, concurrency, unsafe, backend, stdlib, and toolchain layers are excluded and routed. |
| `kyokaicalculus/claim-tiers.md` | Public claim contract | Safety and proof claims use the closed evidence tiers and name scope, artifacts, assumptions, exclusions, and owner. |
| `kyokaicalculus/syntax-and-statics.md` | `intended-by-spec` formal-core draft | The proof-facing judgment now threads store typing, lexical borrow leases, usable reborrow-frontier state, exact-use linear contexts, branch joins, checked failure, and consuming capability attenuation explicitly. |
| `kyokaicalculus/dynamics.md` | `intended-by-spec` formal-core draft | Runtime store state is separate from borrow-lease state. Evaluation contexts and reduction rules cover movement, visible destruction, lexical regions, direct borrows, mutable and read reborrows, exhaustive case, checked primitives, contextual TPOE, and consuming attenuation. |
| `kyokaicalculus/lemmas.md` | `intended-by-spec` lemma skeleton | Thirty-two named lemmas and two main theorem skeletons define the remaining proof work. The separate initial `paper-proof.md` draft does not yet establish `paper-proven` or `mechanically-proven` evidence. |
| `kyokaicalculus/paper-proof.md` | `intended-by-spec` proof draft | The initial preservation-or-defined-failure and progress-or-defined-failure derivations, worked owner/borrow/TPOE/capability examples, and explicit review gaps exist. This is not yet `paper-proven`. |
| `kyokaicalculus/model_tests.py` | Executable spot checks | Twenty-two store, owner-bijection, owner-transfer, checked-function, linear-call, lease-frontier, reborrow, region-close, branch-join, contextual-TPOE, checked-integer, and attenuation checks exercise high-risk draft rules. They support review and do not replace a proof. |
| `kyokaicalculus/surface-elaboration.md` and `extension-roadmap.md` | Contract maps | Surface lowering and later `lambda_K-*` ownership boundaries are explicit. |
| Later boundary plans | Initial plans | Concurrency, unsafe/FFI, backend, stdlib, toolchain, references, and mechanization have named public homes. |

> Trace: D143/D241, D312, D394, D477
> Covers: Gate K-A and K-H are closed by public artifacts while Gate B remains open until the paper theorem exists.

## Accepted D488-D525 Routing

The strict-linearity usability and public-infrastructure closure does not enlarge `lambda_K-seq` indiscriminately. Every accepted point is assigned to one treatment class before proof work begins.

| Accepted decisions | Formalization treatment | Required owner |
| --- | --- | --- |
| D495 branch joins | Surface/core obligation. The first proof includes enough branch structure to establish compatible linear join state or terminal exit for every branch. | `syntax-and-statics.md`, `dynamics.md`, `surface-elaboration.md` |
| D500 `build` expressions | Surface elaboration and initialization-state obligation. A lowered construction initializes each field exactly once and exposes no usable partially initialized value. | `surface-elaboration.md`, later record treatment in `extension-roadmap.md` |
| D491-D493 and D496-D498 | Later language and stdlib contract obligations. | `extension-roadmap.md`, `stdlib-contract-model.md` |
| D488-D489, D494, D499, and D501 | Toolchain, fixture, FFI-admission, and stdlib-evidence obligations. | `toolchain-and-artifact-contracts.md`, `unsafe-ffi-boundary.md`, `stdlib-contract-model.md` |
| D502 and D508 | Spec-writing, claim-table, traceability, and modal-audit obligations that apply to calculus documents too. | `claim-tiers.md`, workflow docs, every touched normative chapter |
| D503-D505, D509, D515-D518, and D525 | Toolchain conformance obligations. | `toolchain-and-artifact-contracts.md` |
| D506-D507, D510-D514, and D519-D524 | Workflow or infrastructure obligations, not type-soundness claims. | public workflow docs, service board, website source, tracked operations work |

> Trace: D488-D525
> Covers: The accepted strict-linearity DX, toolchain, docs, website, and infrastructure closure has explicit formalization routing without overstating the first theorem.

## Later Extensions

After the sequential proof, later formalization work can add concurrency happens-before reasoning, task transfer, channels, cancellation, unsafe/FFI contracts, backend lowering preservation, stdlib contract models, and mechanized proof. These layers must not blur the first theorem. They extend the proof boundary only after the sequential core is stable.

> Trace: D90-D101, D143/D241, D228, D245
> Covers: Concurrency, unsafe/FFI, backend, and stdlib proof work are later extensions.

## Proof Honesty Rule

Until a theorem is actually discharged, spec text may say language contract, design goal, or intended invariant. It must not claim a mechanized or paper proof exists. Public claims record two separate axes. The D477 semantic-scope axis is `SafeCore`, `SafeConcurrent`, `SafeFFIWrapped`, `UnsafeModule`, or `BackendConforming`, paired with maturity state `designed`, `specified`, `mechanized`, `tested`, or `conformance_checked`. The D312 proof-evidence axis is `intended-by-spec`, `implemented-and-tested`, `conformance-backed`, `paper-proven`, or `mechanically-proven`. A claim names its semantic scope, maturity state, proof-evidence tier, artifact path, assumptions, exclusions, and owner. A D477 maturity label never implies a D312 paper or mechanized proof label. D479-D487, D502, and D508 also apply: modal words cannot hide implementation freedom, and proof-relevant prose must use explicit contract tables or open a new D-point when accepted shape is incomplete. When the proof changes a rule, the normative chapter and traceability appendix must be updated in the same pass.

> Trace: D143/D241, D155, D312, D477, D479-D487, D502, D508
> Covers: The spec must not overclaim proof status, must classify proof evidence precisely, and must keep proof-driven rule changes traceable.
