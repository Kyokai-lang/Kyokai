# Calculus Claim Tiers

**Status:** public claim contract  
**Gate:** K-H closed by this document  
**Owner:** Kyokai calculus track

## 1. Rule

Every public Kyokai safety, implementation, conformance, or proof claim names
its evidence tier. A narrower artifact never silently upgrades a broader
claim. A paper proof for `lambda_K-seq` does not prove concurrency, unsafe
wrappers, generated C, the standard library, the package manager, or hosted
services.

## 2. Evidence Tiers

| Tier | Meaning | Required evidence |
| --- | --- | --- |
| `intended-by-spec` | Normative prose or an accepted calculus contract states the rule. | Public spec or calculus path and exact scope. |
| `implemented-and-tested` | An implementation exists and focused tests exercise it. | Implementation path, test path, target/profile facts, and known exclusions. |
| `conformance-backed` | A public conformance family tests the observable contract across its admitted boundary. | Conformance suite path, runner command, support tier, and exclusions. |
| `paper-proven` | A reviewed human-checkable proof discharges a named theorem for a named formal model. | Theorem path, assumptions, trusted base, review record, and exclusions. |
| `mechanically-proven` | A proof assistant checks a named theorem artifact. | Proof assistant, artifact path, build command, trusted base, assumptions, and exclusions. |

The tiers are evidence classes, not a universal ladder. A toolchain command can
be `conformance-backed` without being a theorem. A calculus theorem can be
`paper-proven` while the compiler remains unimplemented. A narrow mechanized
lemma does not upgrade the whole language.

## 3. Required Claim Record

Every claim record contains:

| Field | Meaning |
| --- | --- |
| Scope | Exact feature family, theorem, command, target contract, stdlib API, or service role. |
| Tier | One evidence tier from the closed table above. |
| Artifact | Public path or external stable reference that carries the evidence. |
| Assumptions | Trusted premises required by the artifact. |
| Exclusions | Nearby behavior that the artifact does not cover. |
| Owner | Document, implementation component, conformance family, or service record responsible for updates. |

## 3.1 ProofTrace Projection

D526 projects public evidence records into `kyokaiproofstatus.toml` and the generated `kyokaiproofstatus.md` board. A ProofTrace record keeps specification, implementation, conformance, and proof state separate. It names scope, owner, artifacts, exclusions, and whether proof is required. A `proof_required = false` record means that a theorem is not the acceptance criterion for that boundary; it does not waive ordinary correctness, testing, conformance, security, or review requirements.

ProofTrace metadata does not create a new evidence tier. It records the applicable tier from this file and links it to maintained artifacts. Registry validation proves metadata consistency only. It cannot upgrade an `intended-by-spec` claim to `paper-proven` or `mechanically-proven`.

## 4. Current Calculus Claim Table

| Scope | Current tier | Artifact | Exclusions | Owner |
| --- | --- | --- | --- | --- |
| `lambda_K-seq` theorem statement, L1-L40, Theorem P, and Theorem Q | `paper-proven` | `scope.md`, `paper-proof.md`, `close-and-witness-proof.md`, `call-entry-proof.md`, `primitive-admission-proof.md`, `frame-typing-proof.md`, `source-expression-proof.md`, `equivariance-proof.md`, `theorem-assembly.md`, `machine_runner.py` | The owner-slot environment machine is the maintained model. Named consumption, admitted-total primitives, explicit borrow access, layered static/runtime witnesses, explicit call witnesses, pre-argument path certificates, formal frame typing, intrinsic TPOE, and formal call-argument binding are stated and composed. `theorem-assembly.md` closes L1-L40, L38 unique decomposition, L39 ordinary preservation, L40 intrinsic TPOE preservation, Theorem P, and Theorem Q for the narrow `lambda_K-seq` boundary. `machine_runner.py` executes twenty-five high-risk whole-machine traces as supporting evidence. The narrow Lean artifact below is mechanically proven only for its named representation facts; it is not the proof of Theorem P or Theorem Q. | `syntax-and-statics.md`, `dynamics.md`, `lemmas.md`, `paper-proof.md`, `close-and-witness-proof.md`, `call-entry-proof.md`, `primitive-admission-proof.md`, `frame-typing-proof.md`, `source-expression-proof.md`, `equivariance-proof.md`, `theorem-assembly.md`, `machine_runner.py` |
| Owner-slot repair spot lemmas | `mechanically-proven` | `lean/KyokaiCalculusSpot.lean`, `lean/lean-toolchain`, `lean/lakefile.toml` | The exact theorem list, trusted base, assumptions, command, and exclusions are recorded below. This narrow artifact does not mechanically establish L1-L40, Theorem P, Theorem Q, or whole-core soundness. | `lambda_K-mech` |
| Surface elaboration discipline | `intended-by-spec` | `surface-elaboration.md` | Compiler implementation and conformance fixtures do not exist yet. | `surface-elaboration.md` |
| Cleanup semantics proof | `intended-by-spec` | `extension-roadmap.md` | Excluded from `lambda_K-seq`. | `lambda_K-cleanup` |
| Concurrency and memory model | `intended-by-spec` | `concurrency-model.md` | Excluded from `lambda_K-seq`; no concurrency proof exists. | `lambda_K-conc` |
| Unsafe and FFI wrapper boundary | `intended-by-spec` | `unsafe-ffi-boundary.md` | Safe-wrapper audits and implementation evidence remain module-specific. | `lambda_K-unsafe` |
| Backend preservation and UB closure | `intended-by-spec` | `backend-preservation.md` | No backend-preservation proof or UB conformance suite exists yet. | `lambda_K-backend` |
| Standard-library admission evidence | `intended-by-spec` | `stdlib-contract-model.md` | No API becomes admitted from this template alone. | `lambda_K-stdlib` |
| Toolchain and artifact conformance | `intended-by-spec` | `toolchain-and-artifact-contracts.md` | Tool implementation and fixtures do not exist yet. | `lambda_K-toolchain` |
| Whole-core mechanization | `intended-by-spec` | `mechanization-plan.md` | Planned after paper-core stabilization. | `lambda_K-mech` |


## 5. Lean Spot Artifact Claim Record

| Field | Record |
| --- | --- |
| Scope | The twenty-five named `KyokaiCalculusSpot` representation theorems listed below. |
| Tier | Narrow `mechanically-proven`. |
| Artifact | `lean/KyokaiCalculusSpot.lean`, pinned by `lean/lean-toolchain` and built by `lean/lakefile.toml`. |
| Build command | Run `cd kyokaicalculus/lean && lake build`. |
| Trusted base | Lean 4 kernel from pinned `leanprover/lean4:v4.30.0`; Lake build orchestration; no external Lean packages. |
| Assumptions | The artifact checks its local simplified datatypes and definitions. It assumes, but does not prove, correspondence between those simplified definitions and the prose calculus. |
| Exclusions | No full machine step relation, no L1-L40 derivations, no Theorem P, no Theorem Q, no compiler, no backend, and no whole-language theorem. |
| Owner | `lambda_K-mech`. |

The exact checked theorem identifiers are:

```text
KyokaiCalculusSpot.injectedLinearSumCarriesSelectedPayloadOwner
KyokaiCalculusSpot.movingSlotTransfersArbitraryLinearValueCarrier
KyokaiCalculusSpot.returnedReadTokenCannotCrossClosingRegion
KyokaiCalculusSpot.returnedWriteTokenCannotCrossClosingRegion
KyokaiCalculusSpot.branchFrameStoresSyntaxWithoutOwnerCarriers
KyokaiCalculusSpot.readReborrowRetainsParentWriter
KyokaiCalculusSpot.suspendedParentLeavesWritableFrontier
KyokaiCalculusSpot.retainedParentStillBlocksDirectSharedBorrow
KyokaiCalculusSpot.suspendedMutableTokenCannotSatisfyCallBoundary
KyokaiCalculusSpot.directMutableTokenIsUsableBeforeSuspension
KyokaiCalculusSpot.namedConsumptionPreservesUnrelatedStoreEntry
KyokaiCalculusSpot.returnedBorrowCanBridgeCalleeAndCallerAtoms
KyokaiCalculusSpot.closingLocalWitnessLayerKeepsCallerLayer
KyokaiCalculusSpot.materializedPathCertificateSurvivesCallerSlotMove
KyokaiCalculusSpot.intrinsicTpoeRetainsAbandonedOwnerAccounting
KyokaiCalculusSpot.zeroArgumentTpoeHasNoAbandonedOwnerCarrier
KyokaiCalculusSpot.closingChildRegionRemovesExactlyItsLeases
KyokaiCalculusSpot.closingChildRegionResumesDirectParent
KyokaiCalculusSpot.closingUnrelatedRegionPreservesSuspensionEdge
KyokaiCalculusSpot.closingLocalWitnessLayerDoesNotSearchByRuntimeImage
KyokaiCalculusSpot.ownedCallEntryTransfersArgumentCarrier
KyokaiCalculusSpot.materializedPathCertificateChecksTokenReferent
KyokaiCalculusSpot.linearLocalBindingTransfersReturnedCarrier
KyokaiCalculusSpot.selectedCasePayloadBindingTransfersCarrier
KyokaiCalculusSpot.capabilityAttenuationRecordsOneWayOrigin
```

## 6. Proof-Tooling Boundary

Solver output, generated obligations, bounds reports, proof hints, LSP facts,
and optimization reports are tooling facts. They do not make rejected source
valid, do not weaken a static rule, and do not become hidden prerequisites for
ordinary type checking. If a proof result is ever required for source
acceptance, that change requires a separate accepted language decision and
normative spec update.

## 7. Selective Early Mechanization

A narrow early mechanized artifact is allowed when it isolates a high-risk
rule and records the required claim fields. Examples include context-splitting
lemmas, borrow-exclusivity lemmas, a checked-arithmetic lowering lemma, or an
artifact-graph verifier. The artifact claims only its named theorem. It does
not imply `lambda_K-seq`, the compiler, or Kyokai as a whole is mechanically
proven.

## 8. Public Wording

Public docs and release notes do not say only `proven safe`, `verified`, or
`sound`. They name the tier and scope, for example:

```text
paper-proven: lambda_K-seq progress-or-defined-failure under the assumptions
listed in kyokaicalculus/paper-proof.md.
```

The current first-core wording is:

```text
paper-proven: lambda_K-seq progress-or-defined-failure under the assumptions
listed in kyokaicalculus/theorem-assembly.md.
```
