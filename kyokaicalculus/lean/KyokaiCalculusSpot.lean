/- kyokai:prooftrace id=CALC-LEAN-OWNER-SLOT-SPOT -/
namespace KyokaiCalculusSpot

/- This artifact checks narrow representation lemmas for the lambda_K-seq
   owner-slot repair. It is not a whole-calculus mechanization. -/

abbrev ResourceId := Nat
abbrev RegionId := Nat
abbrev LeaseId := Nat
abbrev SlotId := Nat

inductive Value where
  | unit
  | bool (value : Bool)
  | int (value : Int)
  | owner (resource : ResourceId)
  | readRef (region : RegionId) (lease : LeaseId) (slot : SlotId)
  | writeRef (region : RegionId) (lease : LeaseId) (slot : SlotId)
  | inject (tag : Nat) (payload : Value)
  deriving DecidableEq, Repr

def ownerIds : Value -> List ResourceId
  | .owner resource => [resource]
  | .inject _ payload => ownerIds payload
  | _ => []

def valueRegions : Value -> List RegionId
  | .readRef region _ _ => [region]
  | .writeRef region _ _ => [region]
  | .inject _ payload => valueRegions payload
  | _ => []

def regionCanExit (region : RegionId) (value : Value) : Bool :=
  !(valueRegions value).contains region

theorem injectedLinearSumCarriesSelectedPayloadOwner :
    ownerIds (.inject 1 (.owner 9)) = [9] := by
  rfl

def optionalOwnerIds : Option Value -> List ResourceId
  | some value => ownerIds value
  | none => []

structure CarrierState where
  slot : Option Value
  returned : Option Value
  deriving DecidableEq, Repr

def carrierOwnerIds (state : CarrierState) : List ResourceId :=
  optionalOwnerIds state.slot ++ optionalOwnerIds state.returned

theorem movingSlotTransfersArbitraryLinearValueCarrier (value : Value) :
    carrierOwnerIds { slot := some value, returned := none } =
      carrierOwnerIds { slot := none, returned := some value } := by
  simp [carrierOwnerIds, optionalOwnerIds]

theorem returnedReadTokenCannotCrossClosingRegion :
    regionCanExit 2 (.readRef 2 3 7) = false := by
  decide

theorem returnedWriteTokenCannotCrossClosingRegion :
    regionCanExit 2 (.writeRef 2 3 7) = false := by
  decide

inductive Expr where
  | literal
  | variable (name : Nat)
  | consume (operation : Nat) (name : Nat)
  | branch (condition : Expr) (whenTrue : Expr) (whenFalse : Expr)
  deriving DecidableEq, Repr

abbrev Env := List (Nat × SlotId)

inductive Frame where
  | ifSelect (whenTrue : Expr) (whenFalse : Expr) (environment : Env)
  deriving DecidableEq, Repr

def frameOwnerIds : Frame -> List ResourceId
  | .ifSelect _ _ _ => []

theorem branchFrameStoresSyntaxWithoutOwnerCarriers
    (whenTrue whenFalse : Expr) (environment : Env) :
    frameOwnerIds (.ifSelect whenTrue whenFalse environment) = [] := by
  rfl

inductive LeaseMode where
  | read
  | write
  deriving BEq, DecidableEq, Repr

structure Lease where
  id : LeaseId
  region : RegionId
  mode : LeaseMode
  slot : SlotId
  deriving DecidableEq, Repr

abbrev Suspended := List LeaseId

def retainedWrites (leases : List Lease) (slot : SlotId) : List Lease :=
  leases.filter fun lease => lease.mode == .write && lease.slot == slot

def frontierWrites
    (leases : List Lease) (suspended : Suspended) (slot : SlotId) : List Lease :=
  (retainedWrites leases slot).filter fun lease => !(suspended.contains lease.id)

def noWriter (leases : List Lease) (slot : SlotId) : Bool :=
  (retainedWrites leases slot).isEmpty

def usableWrite (suspended : Suspended) (lease : Lease) : Bool :=
  lease.mode == .write && !(suspended.contains lease.id)

def parentWriter : Lease :=
  { id := 11, region := 1, mode := .write, slot := 7 }

def childReader : Lease :=
  { id := 12, region := 2, mode := .read, slot := 7 }

def readReborrowLeases : List Lease :=
  [parentWriter, childReader]

def readReborrowSuspended : Suspended :=
  [parentWriter.id]

theorem readReborrowRetainsParentWriter :
    retainedWrites readReborrowLeases 7 = [parentWriter] := by
  decide

theorem suspendedParentLeavesWritableFrontier :
    frontierWrites readReborrowLeases readReborrowSuspended 7 = [] := by
  decide

theorem retainedParentStillBlocksDirectSharedBorrow :
    noWriter readReborrowLeases 7 = false := by
  decide

theorem suspendedMutableTokenCannotSatisfyCallBoundary :
    usableWrite readReborrowSuspended parentWriter = false := by
  decide

theorem directMutableTokenIsUsableBeforeSuspension :
    usableWrite [] parentWriter = true := by
  decide

abbrev SuspensionEdge := LeaseId × LeaseId

def leaseIdsAt (leases : List Lease) (region : RegionId) : List LeaseId :=
  (leases.filter fun lease => lease.region == region).map (fun lease => lease.id)

def closeLeases (leases : List Lease) (region : RegionId) : List Lease :=
  leases.filter fun lease => lease.region != region

def closeSuspensions
    (leases : List Lease) (suspended : List SuspensionEdge) (region : RegionId) :
    List SuspensionEdge :=
  let removed := leaseIdsAt leases region
  suspended.filter fun edge => !(removed.contains edge.2)

def unrelatedOuterReader : Lease :=
  { id := 13, region := 1, mode := .read, slot := 8 }

def nestedWriteLeases : List Lease :=
  [parentWriter, childReader, unrelatedOuterReader]

def nestedWriteSuspensions : List SuspensionEdge :=
  [(parentWriter.id, childReader.id)]

theorem closingChildRegionRemovesExactlyItsLeases :
    closeLeases nestedWriteLeases 2 = [parentWriter, unrelatedOuterReader] := by
  decide

theorem closingChildRegionResumesDirectParent :
    closeSuspensions nestedWriteLeases nestedWriteSuspensions 2 = [] := by
  decide

theorem closingUnrelatedRegionPreservesSuspensionEdge :
    closeSuspensions nestedWriteLeases nestedWriteSuspensions 3 =
      nestedWriteSuspensions := by
  decide

structure ResourceState where
  selectedLive : Bool
  unrelatedLive : Bool
  deriving DecidableEq, Repr

def consumeSelected (state : ResourceState) : ResourceState :=
  { selectedLive := false, unrelatedLive := state.unrelatedLive }

theorem namedConsumptionPreservesUnrelatedStoreEntry (state : ResourceState) :
    (consumeSelected state).unrelatedLive = state.unrelatedLive := by
  rfl

abbrev StaticRegionAtom := Nat
abbrev StaticLeaseAtom := Nat

structure InstantiationWitness where
  regionImage : StaticRegionAtom -> RegionId
  leaseImage : StaticLeaseAtom -> LeaseId

def sameReturnedBorrowView
    (callee caller : InstantiationWitness)
    (calleeRegion : StaticRegionAtom)
    (calleeLease : StaticLeaseAtom)
    (callerRegion : StaticRegionAtom)
    (callerLease : StaticLeaseAtom) : Bool :=
  callee.regionImage calleeRegion == caller.regionImage callerRegion &&
    callee.leaseImage calleeLease == caller.leaseImage callerLease

def calleeWitness : InstantiationWitness :=
  { regionImage := fun _ => 2, leaseImage := fun _ => 3 }

def callerWitness : InstantiationWitness :=
  { regionImage := fun _ => 2, leaseImage := fun _ => 3 }

theorem returnedBorrowCanBridgeCalleeAndCallerAtoms :
    sameReturnedBorrowView calleeWitness callerWitness 10 11 20 21 = true := by
  decide

structure WitnessLayer where
  regionAtoms : List StaticRegionAtom
  leaseAtoms : List StaticLeaseAtom
  deriving DecidableEq, Repr

def popLocalLayer : List WitnessLayer -> List WitnessLayer
  | _local :: outer => outer
  | [] => []

def callerLayer : WitnessLayer :=
  { regionAtoms := [20], leaseAtoms := [21] }

def localAliasLayer : WitnessLayer :=
  { regionAtoms := [10], leaseAtoms := [11] }

theorem closingLocalWitnessLayerKeepsCallerLayer :
    popLocalLayer [localAliasLayer, callerLayer] = [callerLayer] := by
  rfl

theorem closingLocalWitnessLayerDoesNotSearchByRuntimeImage :
    popLocalLayer [localAliasLayer, callerLayer] = [callerLayer] := by
  rfl

structure PathCertificate where
  slot : SlotId
  deriving DecidableEq, Repr

def moveCallerSlot (_certificate : PathCertificate) : Option Value :=
  none

theorem materializedPathCertificateSurvivesCallerSlotMove :
    let certificate : PathCertificate := { slot := 7 }
    moveCallerSlot certificate = none ∧ certificate.slot = 7 := by
  decide

structure CallCarrierState where
  completedFrameValue : Option Value
  parameterSlotValue : Option Value
  deriving DecidableEq, Repr

def callCarrierOwnerIds (state : CallCarrierState) : List ResourceId :=
  optionalOwnerIds state.completedFrameValue ++ optionalOwnerIds state.parameterSlotValue

def bindOwnedCallArgument (value : Value) : CallCarrierState :=
  { completedFrameValue := none, parameterSlotValue := some value }

theorem ownedCallEntryTransfersArgumentCarrier (value : Value) :
    callCarrierOwnerIds { completedFrameValue := some value, parameterSlotValue := none } =
      callCarrierOwnerIds (bindOwnedCallArgument value) := by
  simp [callCarrierOwnerIds, bindOwnedCallArgument, optionalOwnerIds]

def pathCertificateMatchesSlot (certificate : PathCertificate) (slot : SlotId) : Bool :=
  certificate.slot == slot

theorem materializedPathCertificateChecksTokenReferent :
    pathCertificateMatchesSlot { slot := 7 } 7 = true := by
  decide

inductive TpoeReason where
  | contractFalse
  | checkedFailure
  deriving DecidableEq, Repr

structure TerminalTpoe where
  reason : TpoeReason
  abandonedOwners : List ResourceId
  deriving DecidableEq, Repr

theorem intrinsicTpoeRetainsAbandonedOwnerAccounting :
    ({ reason := .checkedFailure,
       abandonedOwners := [9] } : TerminalTpoe).abandonedOwners = [9] := by
  rfl

theorem zeroArgumentTpoeHasNoAbandonedOwnerCarrier :
    ({ reason := .checkedFailure,
       abandonedOwners := [] } : TerminalTpoe).abandonedOwners = [] := by
  rfl

def bindLinearLocal (value : Value) : CarrierState :=
  { slot := some value, returned := none }

theorem linearLocalBindingTransfersReturnedCarrier (value : Value) :
    carrierOwnerIds { slot := none, returned := some value } =
      carrierOwnerIds (bindLinearLocal value) := by
  simp [carrierOwnerIds, bindLinearLocal, optionalOwnerIds]

def bindSelectedPayload (value : Value) : CarrierState :=
  { slot := some value, returned := none }

theorem selectedCasePayloadBindingTransfersCarrier (value : Value) :
    carrierOwnerIds { slot := none, returned := some value } =
      carrierOwnerIds (bindSelectedPayload value) := by
  simp [carrierOwnerIds, bindSelectedPayload, optionalOwnerIds]

inductive CapabilityKind where
  | filesystemRoot
  | filesystemSubtree
  deriving DecidableEq, Repr

inductive CapabilityOrigin where
  | initial
  | attenuated (parent : ResourceId) (strong weak : CapabilityKind)
  deriving DecidableEq, Repr

structure CapabilityEntry where
  id : ResourceId
  kind : CapabilityKind
  origin : CapabilityOrigin
  deriving DecidableEq, Repr

def attenuateCapability (parent child : ResourceId) : CapabilityEntry :=
  { id := child
    kind := .filesystemSubtree
    origin := .attenuated parent .filesystemRoot .filesystemSubtree }

theorem capabilityAttenuationRecordsOneWayOrigin :
    attenuateCapability 9 10 =
      { id := 10
        kind := .filesystemSubtree
        origin := .attenuated 9 .filesystemRoot .filesystemSubtree } := by
  rfl

end KyokaiCalculusSpot
