# Lean 4 Owner-Slot Spot Artifact

**Evidence tier:** narrow `mechanically-proven` artifact  
**Whole-core theorem status:** not mechanically proven by this artifact

This Lake package checks selected representation facts for the
`lambda_K-seq` owner-slot runtime repair. It is intentionally smaller than the
L1-L40 paper-proof inventory.

## Build

Elan resolves the pinned Lean toolchain from `lean-toolchain`. Lake checks the
artifact:

```text
lake build
```

Run the command from this directory.

## Checked Scope

`KyokaiCalculusSpot.lean` checks:

1. selected linear-sum payload owner carriage;
2. arbitrary represented linear-value carrier transfer from a slot to a returned value;
3. branch frames that store source syntax without runtime owner carriers;
4. rejection of a returned borrow token when its region closes;
5. retained-writer behavior after read reborrow;
6. removal of a suspended parent from the writable frontier;
7. direct shared-owner borrow rejection while the retained writer exists;
8. mutable call-boundary rejection for a suspended parent token;
9. named consumption preserving an unrelated store entry;
10. returned-borrow views through distinct callee-formal and caller-visible static atoms
    that denote the same runtime identities;
11. local witness-layer close preserving the outer caller layer;
12. materialized path-certificate retention across the caller-slot move event;
13. intrinsic TPOE abandoned-owner accounting;
14. child-region close removing exactly its local leases;
15. child-region close resuming its direct suspended parent;
16. unrelated-region close preserving an unrelated suspension edge;
17. witness close selecting a local layer rather than searching by shared runtime image;
18. owned call entry transferring one arbitrary linear carrier from a completed
    argument frame into one parameter slot;
19. materialized path-certificate checking against one token referent slot;
20. linear-local binding transferring one returned carrier into one owner slot;
21. selected-case payload binding transferring one returned carrier into one owner slot;
22. capability attenuation recording one explicit one-way origin edge;
23. returned mutable-borrow token rejection when its region closes;
24. direct mutable-token usability before suspension; and
25. zero-argument TPOE with no abandoned owner carrier.

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

## Trusted Base And Assumptions

The trusted base is the Lean 4 kernel from pinned
`leanprover/lean4:v4.30.0`, Lake build orchestration, and no external Lean
packages. This artifact checks its local simplified datatypes and definitions.
It assumes, but does not prove, correspondence between those simplified
definitions and the prose calculus.

This artifact does not mechanically establish a full machine step relation, L1-L40,
Theorem P, Theorem Q, compiler correctness, backend preservation, or whole-
language soundness. The paper proof for L1-L40, Theorem P, and Theorem Q lives
in `../theorem-assembly.md` and the derivation packages it cites.
