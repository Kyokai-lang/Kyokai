# Calculus Findings And Divergence Ledger

**Status:** public semantic-audit ledger
**Authority:** records findings and routing only; it does not decide language behavior
**Owner:** Kyokai calculus track
**Updated:** 2026-07-14

## 1. Purpose

This ledger records places where proof, executable-model, or mechanization work
finds that the normative specification is ambiguous, incomplete, contradictory,
or materially different from the maintained calculus. It also records the
opposite direction: a normative change whose impact on the calculus has not yet
been discharged.

This file is distinct from `deviation.md`:

- `deviation.md` records intentional, reviewed proof abstractions that remain
  valid for a named theorem scope.
- this file records discovered mismatches or unresolved correspondence work.
- a mismatch is never made valid merely by writing it into either ledger.

## 2. Finding Classes

| Class | Meaning | Required route |
| --- | --- | --- |
| `SPEC_AMBIGUOUS` | The normative text permits more than one semantic reading. | Public semantic proposal or accepted-text clarification. |
| `SPEC_INCOMPLETE` | The calculus needs a source rule or obligation the spec does not state. | Public semantic proposal unless existing accepted wording already fixes the answer. |
| `SPEC_CONTRADICTION` | Normative clauses or accepted public rules conflict. | Stop affected implementation/proof claims; resolve through the public decision authority. |
| `CALCULUS_MISMATCH` | The calculus models behavior different from the normative rule without an accepted abstraction. | Repair the calculus or publicly accept and record a deliberate abstraction. |
| `CALCULUS_IMPACT_OPEN` | A normative change has not been propagated through the model/proof surface. | Impact analysis, repair, rerun, and claim review. |
| `CORRESPONDENCE_UNPROVEN` | Two artifacts are intended to agree but the mapping/evidence does not establish it. | Add the mapping, tests, or proof and keep claims narrow meanwhile. |

## 3. Required Finding Record

Every public finding contains:

- stable finding ID and discovery date;
- discovering artifact and reviewer/tool role;
- exact normative clauses and exact calculus/model/proof artifacts;
- smallest witness program, judgment, trace, or counterexample available;
- finding class and affected public claims;
- reason the difference matters;
- required disposition and public proposal/issue when semantics are open;
- resolution revision, reviewer, tests/proofs rerun, and claim impact when closed.

Every record also receives one D580 impact class:

| Impact | Minimum disposition |
| --- | --- |
| `NO_SEMANTIC_IMPACT` | Record why no mapping, model, proof, IR, conformance, or claim changes. |
| `MAPPING_ONLY` | Repair forward and reverse links and review the changed mapping. |
| `MODEL_AFFECTING` | Update definitions and executable traces, rerun affected model evidence, and review proof/claim consequences. |
| `PROOF_AFFECTING` | Update the affected lemmas/theorems and obtain the applicable revision-bound proof review. |
| `CLAIM_INVALIDATING` | Downgrade or withdraw the affected public claim until repaired evidence and review are admitted. |

Correspondence and resolution records bind the source revision, clause IDs,
calculus revision, compiler-IR schema where applicable, trusted assumptions,
exclusions, identified reviewer, exact review class, and disposition. A generic
role label is not an identified reviewer.

A finding moves through:

```text
OPEN
  -> ROUTED_TO_SPEC_CORRECTION
  -> ROUTED_TO_CALCULUS_REPAIR
  -> ROUTED_TO_PUBLIC_DECISION
  -> ROUTED_TO_DELIBERATE_ABSTRACTION_REVIEW
  -> RESOLVED | REJECTED_AS_FALSE_POSITIVE
```

`ROUTED` is not `RESOLVED`. A finding remains open until the affected public
artifacts and evidence have changed and the resolution record identifies them.

## 4. Public And Pre-Public Findings

A finding enters this public ledger when its evidence and affected public
artifacts can be disclosed. A semantic difference with no already-accepted
answer requires a public proposal; the ledger cannot select an option.

Work discovered before disclosure remains outside this public file. When it is
made public, its public record uses the actual disclosure date and evidence and
does not pretend an earlier public review occurred.

AI systems may discover, reproduce, and draft findings. They are not decision
authorities or proof reviewers merely by generating a record.

## 5. Active Findings

### CFD-001 — Copied Mutable-Borrow Tokens Lack A Complete Surface Rule

| Field | Record |
| --- | --- |
| Status | `ROUTED_TO_SPEC_CORRECTION` |
| Discovered | 2026-07-12 during the calculus/spec audit; ledgered 2026-07-13 |
| Class | `SPEC_INCOMPLETE` and `CORRESPONDENCE_UNPROVEN` |
| Normative surface | `kyokaispec/src/language/06-type-system.md`, `kyokaispec/src/language/11-linearity-borrowing-and-regions.md` |
| Calculus surface | `syntax-and-statics.md`, `dynamics.md`, `close-and-witness-proof.md`, `theorem-assembly.md` |
| Finding | The maintained calculus permits copied mutable-borrow token values as aliases of one lease lineage and suspends every parent alias together during reborrow. The normative surface does not state lineage identity, copied-alias suspension, generic/closure/return behavior, or the distinction between token value identity and lease identity with equivalent precision. |
| Why it matters | A checker or `.koi` consumer could otherwise treat `Free` copying as independent write authority, reject sound copied aliases, or disagree about escape and suspension. |
| Required route | D559 was accepted on 2026-07-13. Extract its normative clauses, surface/core mapping, `.koi` facts, checker tests, diagnostics, and correspondence review before marking this finding resolved. |
| Claim impact | The existing paper theorem remains scoped to its maintained calculus. It does not establish that the current normative surface or compiler implements the same copied-token rule. |

## 6. Resolution Rule

Closing a finding requires all affected artifacts named by the finding. A spec
edit alone does not close an executable-model or proof impact; a proof edit
alone does not change source semantics. ProofTrace records are updated only to
the evidence actually established after the repair.
