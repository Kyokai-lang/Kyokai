# Mechanization Plan

**Status:** `intended-by-spec` plan  
**Layer:** `lambda_K-mech`

Lean 4 is the selected proof assistant. Elan manages the pinned toolchain and
Lake builds checked artifacts. Whole-core mechanization still begins only
after the paper core stabilizes; selecting Lean does not pretend that the
whole soundness theorem has already been encoded.

The encoding plan must decide binder representation, finite maps for contexts,
slots, and borrow state, store typing, environment and continuation encoding,
binder-alpha automation, finite-renaming automation, CI build command, trusted
base, assumptions, and artifact metadata. Every checked theorem uses the
`mechanically-proven` record fields from `claim-tiers.md`.

Narrow early mechanization is permitted for isolated high-risk lemmas when it
does not freeze an unstable core. A narrow checked lemma claims only its own
scope.

## Checked Early Artifact

The first narrow artifact lives in `lean/KyokaiCalculusSpot.lean`. Run it with:

```text
cd kyokaicalculus/lean
lake build
```

`lean/lean-toolchain` pins `leanprover/lean4:v4.30.0`. The checked theorems
cover only these repair facts:

1. a selected linear-sum payload carries its owner identity;
2. moving an arbitrary represented linear value transfers its owner carriers
   from a slot to the returned value without changing their owner list;
3. an `if_select` frame stores branch syntax without runtime owner carriers;
4. a returned borrow token cannot cross the close of its own region;
5. read reborrow retains the suspended parent writer;
6. a suspended parent leaves the writable frontier;
7. that retained parent still blocks direct shared owner borrowing;
8. a suspended mutable token cannot satisfy mutable call-boundary usability;
9. named consumption leaves unrelated store state unchanged;
10. returned borrows can bridge distinct callee-formal and caller-visible static
    atoms that denote the same runtime identities;
11. popping one local witness layer keeps the outer caller layer;
12. a materialized path certificate survives the caller-slot move event;
13. intrinsic TPOE retains abandoned-owner accounting;
14. child-region close removes exactly its local leases;
15. child-region close resumes its direct suspended parent;
16. unrelated-region close preserves an unrelated suspension edge;
17. witness close selects a local layer rather than searching by shared runtime image;
18. owned call entry transfers one arbitrary linear carrier from a completed
    argument frame into one parameter slot;
19. a materialized path certificate checks one token referent slot;
20. linear-local binding transfers one returned carrier into one owner slot;
21. selected-case payload binding transfers one returned carrier into one owner slot;
22. capability attenuation records one explicit one-way origin edge;
23. a returned mutable-borrow token cannot cross the close of its own region;
24. a direct mutable token is usable before suspension; and
25. zero-argument TPOE carries no abandoned owner carrier.

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

The trusted base is the Lean 4 kernel from pinned
`leanprover/lean4:v4.30.0`, Lake build orchestration, and no external Lean
packages. The artifact assumes correspondence between its simplified local
datatypes and the prose calculus; it does not mechanize or prove that
correspondence.
