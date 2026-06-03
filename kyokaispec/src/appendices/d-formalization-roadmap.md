# Formalization Roadmap

[Rikona Kurasaki / Mjoyufull]
> ProofTrace: SPEC-APPENDICES-D-FORMALIZATION-ROADMAP
> Covers: This chapter is registered in the public ProofTrace evidence graph; registration does not claim implementation, conformance, or theorem completion.

This appendix records the proof road and the current public evidence state. Kyokai's sequential ownership core now has the Gate-B `paper-proven` theorem for the narrow `lambda_K-seq` boundary, while later mechanization remains after self-hosting.

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
| Mechanized plan | Lean 4 selection, pinned Elan toolchain, Lake build, and encoding strategy. | Lean 4 is selected. Whole-core mechanization remains after self-hosting. |
| Early checked artifact | Narrow Lean spot lemmas for the owner-slot runtime repair. | Selected carrier, branch-frame, region-exit, retained-writer, and suspended-call-boundary facts are mechanically checked without claiming whole-core soundness. |

> Trace: D143/D241
> Covers: Formalization work proceeds through explicit artifacts instead of vague proof intent.

## Relation To Maintained Artifacts

`kyokaicalculus/scope.md` freezes the first theorem boundary, and
`kyokaicalculus/claim-tiers.md` defines the evidence vocabulary. The statics,
dynamics, lemma inventory, derivation packages, theorem assembly, elaboration map,
extension map, and later-boundary files assign each rule to its proof or non-proof
treatment. `kyokaicalculus/paper-proof.md` carries the preservation-or-defined-failure
and progress-or-defined-failure overview after the earlier substitution runtime was
retired for branch-sensitive owner duplication. The revised machine keeps linear
values in owner slots, selects one evaluation path through continuation frames,
separates static region and lease atoms from runtime identities through explicit
witness `I`, retains elaborated call witness `phi`, and limits cleanup to named
consuming operations. `kyokaicalculus/theorem-assembly.md` composes L1-L40, L38,
L39, L40, Theorem P, and Theorem Q into the Gate-B paper proof. The narrow Lean
artifact checks selected repair facts mechanically without claiming whole-core Lean
mechanization.

> Trace: D143/D241
> Covers: Maintained public calculus artifacts expose the theorem boundary and review state; none replaces the required reviewed proof artifact.

## Current Calculus Artifacts

| Artifact | Current status | What it establishes |
| --- | --- | --- |
| `kyokaicalculus/scope.md` | `paper-proven` scope freeze | `lambda_K-seq` includes sequential ownership, lexical borrow regions, explicit reborrow, minimal sums/results, checked TPOE, and sealed capabilities; cleanup, panic, concurrency, unsafe, backend, stdlib, and toolchain layers are excluded and routed. |
| `kyokaicalculus/claim-tiers.md` | Public claim contract | Safety and proof claims use the closed evidence tiers and name scope, artifacts, assumptions, exclusions, and owner. |
| `kyokaicalculus/syntax-and-statics.md` | `paper-proven` formal-core statics | The proof-facing judgment now threads store typing, lexical borrow leases, usable reborrow-frontier state, exact-use linear contexts, branch joins, checked failure, and consuming capability attenuation explicitly. |
| `kyokaicalculus/dynamics.md` | `paper-proven` formal-core dynamics | The runtime is an environment-and-continuation machine with resource store `Sigma`, borrow graph `B`, explicit static-to-runtime witness `I`, owner-slot store `Xi`, environments `eta`, and continuation frames `K`. Machine transitions cover arbitrary linear movement, resolved named consumption without structural fallback, lexical regions, direct borrows, mutable and read reborrows, exhaustive case, checked primitives, TPOE with explicit abandoned-carrier snapshot `A`, explicit `call f[phi](args)` instantiation with formal `bind_call_args`, pending local and parameter obligations during body execution, pop-time return readiness, and consuming attenuation. |
| `kyokaicalculus/lemmas.md` | `paper-proven` lemma inventory | Forty named lemmas and two main theorem statements are indexed and routed to the maintained derivation packages and `theorem-assembly.md`. |
| `kyokaicalculus/paper-proof.md` | `paper-proven` proof overview | The owner-slot machine repair, preservation-or-defined-failure and ordinary-progress cases, worked owner/borrow/TPOE/capability examples, and closure record point to the maintained theorem assembly. |
| `kyokaicalculus/close-and-witness-proof.md` | `paper-proven` derivation package | The L20, L21, L23, and close-specific L37 cases state exact lease removal, direct-parent resumption, writer-chain isolation, scope-owned witness restoration, and finite-renaming arguments used by the theorem assembly. |
| `kyokaicalculus/call-entry-proof.md` | `paper-proven` derivation package | The L27-L30 and call-specific carrier, frame, renaming, and preservation cases state pre-argument `pi` materialization, deterministic `phi` realization, owned-argument transfer, exact parameter discharge, and caller-witness restoration used by the theorem assembly. |
| `kyokaicalculus/primitive-admission-proof.md` | `paper-proven` derivation package | The primitive branches of L8, L16, L31-L34, and L38-L40 state declaration-time totality and invariant-footprint obligations for named consumption, checked primitives, borrow access, and attenuation used by the theorem assembly. |
| `kyokaicalculus/frame-typing-proof.md` | `paper-proven` derivation package | The frame-local branches of L9-L11, L26, L31, and L38-L40 distinguish pending local and owned-parameter obligations from pop-time readiness, define structural carrier extraction, and preserve erased frame carriers in TPOE snapshot `A`. |
| `kyokaicalculus/source-expression-proof.md` | `paper-proven` derivation package | The source-control branches of L1-L8, L12-L19, L24-L25, and L32-L36 expose structural context arguments, runtime-value and slot cases, branch and payload transfer, borrow lifecycle and access, environment agreement, capability origin, freshness, and source-control decomposition. |
| `kyokaicalculus/equivariance-proof.md` | `paper-proven` derivation package | L36-L37 runtime-renaming obligations define sort-preserving finite renaming, separate it from source binder alpha-equivalence and one-step fresh-choice equivalence, and enumerate structural, borrow-graph, witness, path, binding, call, primitive, and TPOE commuting cases. |
| `kyokaicalculus/theorem-assembly.md` | `paper-proven` theorem assembly | The L1-L40 route matrix connects the maintained packages to L38 unique decomposition, L39 ordinary preservation, L40 intrinsic defined-failure preservation, and Theorem P/Q proof closure. |
| `kyokaicalculus/model_tests.py` | Executable spot checks | Forty-nine owner-slot, arbitrary-linear-sum movement, named-consumption rejection and unrelated-store preservation, machine-carrier, static/runtime witness aliasing, exact lease-close locality, malformed writer-chain rejection, explicit-call-witness, caller/callee returned-borrow bridging, pre-argument path retention and referent mismatch rejection, owned-call-argument transfer and discharge, referent-typing, lease-frontier, suspended-call-rejection, call-return-restoration, region-escape, recursive-freshening, argument-frame, checked-integer, and attenuation checks exercise high-risk proof rules. They support the proof as executable evidence and do not replace the paper derivation. |
| `kyokaicalculus/machine_runner.py` | Executable whole-machine regression slice | Twenty-five complete traces construct machine configurations and execute continuation transitions through free and linear binding, both branch selections, sequencing, arbitrary linear-sum movement, payload binding, direct and nested borrow access, lexical close, owned-call entry and return, source-ordered multi-argument calls, checked operations, attenuation, intrinsic TPOE carrier accounting, and returned-local-borrow rejection. This is supporting executable evidence, not a proof or a complete interpreter. |
| `kyokaicalculus/lean/KyokaiCalculusSpot.lean` | Narrow `mechanically-proven` spot artifact | `cd kyokaicalculus/lean && lake build` checks twenty-five exact theorem identifiers recorded in `kyokaicalculus/claim-tiers.md` and `kyokaicalculus/lean/README.md` under the pinned Lean toolchain. Its trusted base, assumptions, and exclusions are recorded there. It does not mechanically establish L1-L40, Theorem P, or Theorem Q; the paper proof is maintained in `theorem-assembly.md`. |
| `kyokaicalculus/deviation.md` | Maintained proof-abstraction record | Valid proof-only abstractions are listed explicitly. Invalid spec conflicts are repaired rather than preserved as deviations. |
| `kyokaicalculus/surface-elaboration.md` and `extension-roadmap.md` | Contract maps | Surface lowering and later `lambda_K-*` ownership boundaries are explicit. |
| Later boundary plans | Initial plans | Concurrency, unsafe/FFI, backend, stdlib, toolchain, references, and mechanization have named public homes. |

> Trace: D143/D241, D312, D394, D477
> Covers: Gate K-A, Gate K-H, and Gate B are closed by public artifacts for their named scopes; later mechanization and broader language layers remain separate gates.

## Accepted D488-D526 Routing

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
| D526 | Evidence-graph and CI-metadata obligation. ProofTrace records expose state honestly but do not enlarge the first theorem. | `kyokaiproofstatus.toml`, `kyokaiproofstatus.md`, `tools/check_prooftrace.py` |

> Trace: D488-D526
> Covers: The accepted strict-linearity DX, toolchain, docs, website, infrastructure, and ProofTrace evidence closure has explicit formalization routing without overstating the first theorem.

## Later Extensions

After the sequential proof, later formalization work can add concurrency happens-before reasoning, task transfer, channels, cancellation, unsafe/FFI contracts, backend lowering preservation, stdlib contract models, and mechanized proof. These layers must not blur the first theorem. They extend the proof boundary only after the sequential core is stable.

> Trace: D90-D101, D143/D241, D228, D245
> Covers: Concurrency, unsafe/FFI, backend, and stdlib proof work are later extensions.

## Proof Honesty Rule

Until a theorem is actually discharged, spec text may say language contract, design goal, or intended invariant. It must not claim a mechanized or paper proof exists. Public claims record two separate axes. The D477 semantic-scope axis is `SafeCore`, `SafeConcurrent`, `SafeFFIWrapped`, `UnsafeModule`, or `BackendConforming`, paired with maturity state `designed`, `specified`, `mechanized`, `tested`, or `conformance_checked`. The D312 proof-evidence axis is `intended-by-spec`, `implemented-and-tested`, `conformance-backed`, `paper-proven`, or `mechanically-proven`. A claim names its semantic scope, maturity state, proof-evidence tier, artifact path, assumptions, exclusions, and owner. A D477 maturity label never implies a D312 paper or mechanized proof label. D479-D487, D502, and D508 also apply: modal words cannot hide implementation freedom, and proof-relevant prose must use explicit contract tables or open a new D-point when accepted shape is incomplete. When the proof changes a rule, the normative chapter and traceability appendix must be updated in the same pass.

> Trace: D143/D241, D155, D312, D477, D479-D487, D502, D508
> Covers: The spec must not overclaim proof status, must classify proof evidence precisely, and must keep proof-driven rule changes traceable.

## ProofTrace Evidence Graph

> Trace: D526
> Covers: Public evidence metadata connects normative chapters, maintained code boundaries, tests, conformance work, and proof artifacts without collapsing specification, implementation, conformance, or proof state.

Kyokai maintains `kyokaiproofstatus.toml` as the public source registry for the ProofTrace evidence graph. `kyokaiproofstatus.md` is generated from that registry. It is a public status board, not a normative language chapter and not a file edited by hand.

A ProofTrace record has one stable ID and records scope, owner, specification artifacts, implementation artifacts, test artifacts, proof artifacts, exclusions, and four separate state axes:

| Axis | Meaning |
| --- | --- |
| `spec_status` | Whether the registered scope has normative text or remains planned. |
| `implementation_status` | Whether implementation is absent, planned, inherited bootstrap code, a prototype, or implemented Kyokai behavior. |
| `conformance_status` | Whether public executable conformance evidence is absent, planned, or present. |
| `proof_status` | One evidence tier from `kyokaicalculus/claim-tiers.md`. |

Every record also states `proof_required = true` or `proof_required = false`. A false value requires one closed reason category: `tooling-service-behavior`, `workflow-only`, `documentation-only`, `infrastructure-only`, `bootstrap-harness`, or `generated-artifact-plumbing`. A no-proof reason does not waive ordinary correctness, test, conformance, security, or review obligations. It states only that a theorem is not the acceptance criterion for that boundary.

Every maintained normative chapter with decision traces has one chapter-level marker:

```text
> ProofTrace: SPEC-LANGUAGE-11-LINEARITY-BORROWING-AND-REGIONS
> Covers: This chapter is registered in the public ProofTrace evidence graph; registration does not claim implementation, conformance, or theorem completion.
```

Every maintained spec-relevant implementation, harness, conformance, and proof boundary has a language-appropriate source comment:

```text
(* kyokai:prooftrace id=BOOTSTRAP-LINEARITY-CHECK *)
```

The marker belongs at the boundary responsible for the registered contract. It is not required on every helper beneath that boundary. When a helper becomes an independently maintained semantic, toolchain, stdlib, unsafe, backend, conformance, or proof boundary, it receives its own record and marker.

ProofTrace metadata is tooling evidence only. It cannot change parsing, type checking, ownership, borrowing, capability checks, lowering, generated code, runtime behavior, package resolution, or theorem truth. An inherited compiler pass is marked `inherited-bootstrap`; it is not described as Kyokai implementation evidence merely because the file exists.

`tools/check_prooftrace.py` validates the registry schema, status vocabulary, chapter registrations, required code-boundary comments, closed no-proof reasons, artifact paths, and generated status board. `make proofstatus` regenerates `kyokaiproofstatus.md`. `make check-prooftrace` and CI reject stale or malformed evidence metadata.
