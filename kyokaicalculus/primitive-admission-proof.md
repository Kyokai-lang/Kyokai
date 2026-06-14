# Primitive Admission Derivation Package

**Status:** `paper-proven` Gate-B primitive-admission derivation package  
**Discharges in the maintained proof:** primitive-totality cases of L8, L16, L31-L34, and L38-L40  
**Depends on:** `syntax-and-statics.md`, `dynamics.md`, `lemmas.md`

## 1. Claim Boundary

This package discharges the paper obligation created by first-core primitive nodes.
It does not prove concrete standard-library implementations, backend lowering,
FFI wrappers, OS behavior, allocator behavior, or generated-C/C-toolchain UB closure. Those remain
later layers. It proves the narrower statement needed for first-core progress:
a primitive name cannot enter `Delta` unless its abstract semantic relation is
total on every admitted typed input and its invariant footprint is explicit.

## 2. Admission Is A Declaration Premise

Primitive lookup and primitive admission are different judgments. Lookup alone is
insufficient because a typed term could otherwise name an operation whose runtime
relation is undefined. `Delta` contains only admitted declarations.

For every primitive family below, the admission derivation is checked once when
the declaration enters `Delta`. A use-site typing rule then cites the admitted
declaration. A runtime transition cites the same relation. Progress uses admission
totality; preservation uses the admitted footprint.

## 3. Named Consuming Operations

Admission rule:

```text
for every well-formed I,Sigma,Xi,B,w with
  w : runtime_type(I,T)
  every a in owner_ids(w) live in Sigma
there exists exactly one Sigma' with consume_op(Delta,Sigma,op,w)=Sigma'
Sigma' consumes exactly owner_ids(w)
Sigma' preserves every unrelated store entry
Sigma' creates no owner identity
------------------------------------------------------------
Delta |- op admitted-consuming T -> Unit
```

At `E-Consume`, the slot is live and unborrowed. Totality gives one `Sigma'`, so
the transition exists. The footprint changes the slot to a tombstone, marks exactly
the carried owners consumed, preserves unrelated entries, creates no carrier, and
returns `nil`. Therefore owner accounting and slot typing are preserved after the
declared discharge.

There is no universal recursive destructor. A sum is destructured and its selected
payload explicitly discharged unless a separately admitted operation names the sum
type itself.

## 4. Checked Primitives

Admission rule:

```text
Ts and U are Free
for every typed args : runtime_type(I,Ts), ok(op,args) is total
when ok(op,args), result(op,args) is total and result(op,args) : runtime_type(I,U)
neither branch changes Sigma,Xi,B,I,owner carriers,or capability origins
------------------------------------------------------------
Delta |- op admitted-checked Ts -> U
```

When all source-ordered arguments are evaluated, total `ok` selects exactly one
transition. If it is true, total `result` supplies one ordinary `Free` result. If it
is false, the machine enters intrinsic terminal
`tpoe<checked_failure(op,args),Sigma,B,I,Xi,A>`, where
`A=abandoned_owners(control,K)` is computed before the continuation is erased.
First-core checked arguments and results are `Free`, so the checked-argument frame
does not itself add a linear carrier. An outer source-ordered frame can already
hold a carrier, and `A` preserves that terminal accounting without authorizing
cleanup or resumption.

## 5. Borrow Access Primitives

Read admission rule:

```text
for every usable token to ell containing tau, read_access_op is total
result has declared Free type U
Sigma,Xi,B,I,owner carriers,and capability origins are preserved
------------------------------------------------------------
Delta |- op admitted-read-access T -> U
```

Write admission rule:

```text
for every usable mutable token to ell containing tau, write_access_op is total
ell retains tau
Sigma/Xi owner-carrier bijection,B,I,and capability origins are preserved
the relation performs no named consumption or authority creation
------------------------------------------------------------
Delta |- op admitted-write-access T -> Unit
```

The runtime use site separately requires `usable_read` or `usable_write`. Admission
does not weaken lease availability. It states only that once the usable-token
premise is met, the named abstract observation or mutation has one defined result
and preserves its declared invariant footprint.

## 6. Capability Attenuation

Admission rule:

```text
k_weak <= k_strong
for every admitted strong payload, attenuate_payload is total
the transition consumes exactly one strong capability owner
the transition creates exactly one fresh weaker capability owner
the fresh owner records accepted attenuation origin
------------------------------------------------------------
Delta |- admitted-attenuation k_strong -> k_weak
```

At `E-Attenuate`, one unborrowed slot contains `own[a]` for the strong capability.
Freshness chooses `a'` outside `dom(Sigma)`. The transition tombstones the strong
slot, marks `a` consumed, inserts `a'` with the weaker kind and explicit origin edge,
and returns `own[a']`. The owner carrier changes from exactly one strong identity to
exactly one weaker identity. No operation in the first core creates capability
authority except initial configuration and admitted attenuation.

## 7. Progress And Preservation Cases

Admission discharges the primitive branches of the machine proof:

| Transition family | Progress fact | Preservation fact |
| --- | --- | --- |
| `E-Consume` | Total `consume_op` yields one `Sigma'`. | Exact discharge footprint preserves unrelated store entries and removes only declared carriers. |
| `E-Checked-*-Ok` / `Fail` | Total `ok` selects success or intrinsic TPOE; true implies total `result`. | Success preserves all machine state; failure satisfies intrinsic `WT_TPOE`. |
| `E-Read-Access-*` | Total `read_access_op` yields one `Free` result after usability holds. | No owner, lease, witness, or capability-origin fact changes. |
| `E-Write-Access` | Total `write_access_op` yields one state update after usability holds. | The admitted footprint preserves slot type, carrier bijection, lease state, witness state, and origins. |
| `E-Attenuate` | Total `attenuate_payload` and fresh-resource choice yield one target modulo `fresh_step_equiv`. | Exactly one strong authority carrier becomes one weaker carrier with an accepted origin edge. |

A missing semantic relation is therefore a declaration-admission rejection, not a
typed stuck machine state.

## 8. Executable Evidence

`model_tests.py` exercises named consumption, unrelated-store preservation,
borrowed-slot rejection before store mutation, absent-consuming rejection,
checked-integer success and TPOE, absent-checked rejection, capability attenuation,
fresh weakened-resource enforcement, absent-attenuation rejection, usable borrow
observation, and suspended mutable-token mutation rejection.

These are executable checks supporting the proof. They do not prove totality for every future
concrete primitive implementation. Each admitted concrete primitive still needs its
own implementation, tests, conformance evidence, and later backend or stdlib record.
