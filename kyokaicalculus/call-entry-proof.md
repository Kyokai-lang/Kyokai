# Call Entry And Return Derivation Package

**Status:** `paper-proven` Gate-B call-entry derivation package  
**Discharges in the maintained proof:** call cases of L10, L11, L24, L26-L30, and L37-L39  
**Depends on:** `syntax-and-statics.md`, `dynamics.md`, `lemmas.md`

## 1. Claim Boundary

This package expands and discharges the first-core call derivation. It does not claim that
surface callable lookup, higher-order calls, closures, records, field paths, or FFI are proved. Surface callable resolution and
callee-expression evaluation remain a recorded proof abstraction in
`deviation.md`.

The first core uses elaborated call syntax:

```text
call f[phi](e_1,...,e_n)
```

`phi` is checker-recorded evidence. Runtime verifies and realizes that evidence;
it never searches for an instantiation or selects one after arguments have moved.

## 2. Pre-Argument Path Certificate

The first-core path language is intentionally small:

```text
resolve_slot(eta,owner(x))    = ell  iff eta(x)=slot(ell)
resolve_slot(eta,referent(x)) = ell  iff eta(x)=free(read_ref[r,beta,ell])
                                  or eta(x)=free(write_ref[r,beta,ell])
```

For every whole-referent relationship required by `phi`, call start computes:

```text
materialize_call_paths(phi,eta)=pi
```

where `pi(formal_path)=ell` exactly when the recorded caller path resolves to
`ell`. `E-Call-Start` computes `pi` before evaluating `e_1`. `E-Call-Zero`
computes the same certificate before direct zero-argument entry. Argument
evaluation can tombstone a caller slot after this point, but it cannot erase or
change the slot identity already stored in `pi`.

This ordering closes the path-evidence hole: invocation does not need to recover a
source owner path from a closed moved value after argument evaluation.

## 3. L27: Static Call Compatibility

`static_call_compatible` checks one explicit `phi` before runtime entry. It
records:

1. the selected first-order declaration and source argument positions;
2. formal external region and lease atoms;
3. equality and distinctness relationships between formal atoms;
4. whole-owner or whole-referent paths required by the declaration;
5. the caller-visible result type `phi(U)`.

`materialize_call_paths` then resolves every required actual path exactly once.
It is a partial function because `phi` and `resolve_slot` are functions. A missing
path, stale source binding, or mismatched path leaves call start undefined and is
excluded by static call compatibility plus environment agreement.

Mutable actual tokens must satisfy `usable_write`; immutable actual tokens must
satisfy `usable_read`. Retained caller leases unrelated to the argument vector stay
in `B`. They remain visible to conflict checks but are unreachable through the
callee environment.

## 4. L28: Deterministic Runtime Instantiation

Assume:

```text
instantiate_call(Delta,Sigma_t,f,phi,pi,B,I,Xi,args)
  = <Xi',I_f,I_formal,eta_f,e_f',param_slots,psi,phi(U)>
```

The relation is derived in this fixed order:

1. Look up the one declaration selected by `f` and verify the retained `phi`.
2. Apply `alpha_freshen` to declaration-local static region atoms, lease atoms,
   and ordinary binders, producing invocation-local `psi` and body `e_f'`.
3. Apply `realize_call(psi,args,B)`. Token arguments determine the runtime images
   of formal external atoms. Its domain equals exactly the external atoms required
   by `psi`. Repeated formal atoms must realize to one runtime identity. Repeated
   runtime images require one checked alias authorization recorded in the call layer.
4. Check `verify_call_paths(phi,pi,args)`. Every token-carried referent slot must
   equal the exact slot recorded in `pi`; declared path equality and distinctness
   relationships must also hold. No field-path inference or post-move reconstruction
   occurs.
5. Push one call-owned witness layer `I_formal`, yielding `I_f`. Outer layers are
   retained unchanged.
6. Check each argument value against `runtime_type(I_f,psi(T_i))` and each borrow
   token against its usable-access premise.
7. Apply `bind_call_args` in source order.

No step above chooses between alternative runtime instantiations. `alpha_freshen`
is capture avoiding, fixes caller-external atoms, and renames local atoms and binders
injectively to names fresh for the active witness domains. All nondeterminism is
limited to those fresh invocation-local atom names and fresh owned-parameter slots,
which are identified modulo the explicit alpha and fresh-step relations.

## 5. Owned-Argument Carrier Transfer

`bind_call_args` is a list induction over paired runtime argument values and formal
parameters.

Base case:

```text
bind_call_args(Sigma_t,B,I_f,psi,Xi,[],[],eta_empty,[])
  = <Xi,eta_empty,[]>
```

Free step:

```text
w : runtime_type(I_f,psi(T))    T : Free
------------------------------------------------------------
bind one x:T as eta[x |-> free(w)] and recurse
```

Linear step:

```text
w : runtime_type(I_f,psi(T))    T : Linear    fresh_slot(Xi,ell)
------------------------------------------------------------
bind one x:T as eta[x |-> slot(ell)]
store Xi(ell)=live(runtime_type(I_f,psi(T)),w)
append ell to param_slots and recurse
```

For a `Free` step, no owner carrier is introduced because first-core `Free` values
carry no resource owner. For a `Linear` step, the same closed runtime value `w`
moves from the completed `call_args.done` field into one fresh slot. `E-Call-Enter`
discards the completed argument frame in the same transition that installs the
fresh parameter slots. Therefore `owners_machine` loses one frame carrier and gains
one slot carrier with the same `owner_ids(w)`. It never counts both after entry.

Induction over the argument vector proves:

1. each owned argument receives exactly one fresh parameter slot;
2. each free argument receives exactly one direct environment binding;
3. `param_slots` contains exactly the fresh owned-parameter slots in source order;
4. pre-existing `Xi` entries are unchanged;
5. the live-owner carrier bijection is preserved.

## 6. L29: Return Restoration

The pushed frame is:

```text
call_return(param_slots,B_entry,I_entry,I_formal,psi,phi,pi,U)
```

During callee execution, `F-Call-Return-Pending` requires:

```text
parameter_obligations(Xi,param_slots)
```

Each owned parameter slot may still be live or may already be a tombstone. This
keeps the entered callee intrinsically typable while its body performs the
visible moves or named consuming operations required by linear exactness.

Ordinary return is admitted only by `Ready-Call-Return` and `E-Call-Return`,
which require:

```text
for every ell in param_slots: Xi(ell)=moved(tau_ell)
B=B_entry
return_witness(I,I_entry,I_formal)
result_bridge(Sigma_t,slot_types(Xi),B,I,I_entry,psi,phi,U,w)
```

The moved-slot premises prove exact owned-parameter discharge at the pop, not
prematurely at call entry. `B=B_entry` proves
that every callee-local borrow scope closed and every framed caller lease was
restored exactly. `return_witness` pops one call-owned formal layer after all
callee-local region layers have closed. `result_bridge` checks the same returned
runtime value under invocation-local result type `psi(U)` and caller-visible result
type `phi(U)` before restoring `I_entry`.

A returned caller-tied borrow can therefore survive through an explicitly checked
alias relationship. A callee-local borrow cannot escape because it has no valid
caller-visible bridge and its region layer must close before return.

## 7. L30: Suspended Mutable Argument Rejection

Suppose a copied token carries:

```text
write_ref[s,beta_parent,ell]
Suspended(beta_parent)=beta_child
```

The token remains runtime-typed so ordinary copying of a `Free` token does not
invent a use-after-move rule. It fails `usable_write(B,beta_parent,ell)` because
the parent is suspended. `realize_call` and `instantiate_call` require mutable
actual tokens to satisfy `usable_write`, so call entry is undefined. The child
scope must close and resume the direct parent before the copied parent token can
cross a mutable-borrow call boundary.

## 8. L37-L39 Call Cases

Finite sort-preserving runtime renaming commutes with `resolve_slot`,
`materialize_call_paths`, `realize_call`, witness-layer push, `bind_call_args`,
`return_witness`, and `result_bridge`. Each relation compares identities only for
equality, preserves sort, or allocates a fresh identity. Applying one consistent
renaming to inputs and outputs preserves each premise.

The `E-Call-Zero`, `E-Call-Start`, `E-Call-Next`, `E-Call-Enter`, and
`E-Call-Return` cases are deterministic modulo fresh-step equivalence and
preserve intrinsic machine typing. `theorem-assembly.md` composes these call
derivations with frame typing and L38-L40.

## 9. Executable And Checked Evidence

`model_tests.py` exercises pre-argument path materialization, path-certificate
retention after caller-slot movement, mismatched referent rejection, source-ordered
argument frames, zero-argument entry, owned-argument transfer into one fresh
parameter slot, suspended mutable-token call rejection, exact borrow-graph return
restoration, and required owned-parameter discharge. `machine_runner.py` executes a
complete owned-call trace in which one moved caller carrier enters a fresh owned
parameter slot, remains a live pending obligation during callee execution, is consumed
visibly, and permits `E-Call-Return` only after the slot becomes a tombstone.

`lean/KyokaiCalculusSpot.lean` checks narrow simplified facts named:

```text
KyokaiCalculusSpot.materializedPathCertificateSurvivesCallerSlotMove
KyokaiCalculusSpot.ownedCallEntryTransfersArgumentCarrier
KyokaiCalculusSpot.materializedPathCertificateChecksTokenReferent
KyokaiCalculusSpot.suspendedMutableTokenCannotSatisfyCallBoundary
KyokaiCalculusSpot.returnedBorrowCanBridgeCalleeAndCallerAtoms
```

Those checked facts support this package. The complete call derivation is the prose proof above plus its composition in `theorem-assembly.md`; the Lean facts remain narrow representation checks.
