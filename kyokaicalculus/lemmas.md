# `lambda_K-seq` Lemmas And Paper-Proof Obligations

**Status:** `paper-proven` lemma inventory and proof index  
**Gate:** K-C closed by maintained derivation packages and Theorem P/Q assembly  
**Depends on:** `syntax-and-statics.md`, `dynamics.md`

## 1. Purpose

This file names the obligations for the environment-and-continuation proof.
This file indexes the lemmas discharged by the maintained derivation packages. The earlier
substitution-machine inventory is retired: substituting a runtime linear value
into both source branches duplicates owner syntax even when only one branch
executes. The corrected proof keeps owners in runtime slots and proves that
machine carriers preserve unique ownership.

## 2. Definitions

```text
WT(C)                    intrinsic ordinary-machine typing from dynamics.md
WT_TPOE(C)               intrinsic typed terminal TPOE classification
ST(Sigma)                store_types(Sigma)
XT(Xi)                   slot_types(Xi)
WF(B,Xi)                 runtime lease graph is well formed over live slots
owners(w)                owner_ids(w)
owners_machine(C)        multiset of owners in live slots, ret(w), and frame values
abandoned_owners(control,K) multiset of control/frame owners captured before TPOE erases K
terminal_owners(Xi,A)      multiset of live-slot owners plus abandoned terminal snapshot A
ordinary_final(C)        C = <Sigma,B,I,Xi,ret(w),halt>
binder_alpha(e,e')       capture-avoiding source-binder alpha-equivalence
fresh_step_equiv(C,C')   consistent renaming of identities minted by one step
```

Static proof atoms have two sorts: regions `rho` and leases `b`. Runtime
identities have four sorts: regions `r`, leases `beta`, slots `ell`, and
resources `a`. `I` is a stack of scope-owned witness layers mapping static atoms to runtime
identities. Renaming preserves sorts. `binder_alpha` renames source binders.
`fresh_step_equiv` renames freshly minted runtime identities. General
equivariance maps an entire relation through a finite sort-preserving renaming.
These are separate statements. Runtime images are injective unless one local
layer records an explicit checked equality authorization to an outer layer.
Popping a local layer removes static mappings by layer ownership, never by
runtime image. Runtime minting remains fresh in `B`.

## 3. Static Structural Lemmas

### L1. Unrestricted Weakening And Contraction

Adding an unused `Free` binding or merging two names for one `Free` value
preserves a source derivation. Copying a borrow token copies one lease identity
and does not mint a lease.

### L2. Linear Exactness

Every ordinarily completing path introduced under `x:T` with `T:Linear`
removes `x` from its output `Gamma_l`. No structural rule weakens or contracts
`Gamma_l`.

### L3. Static State Threading

If the post-state of one source derivation equals the pre-state of the next,
the derivations compose. This applies to sequencing, source-ordered argument
typing, and continuation-frame typing. Sequencing advances only after its
first expression returns `Unit`.

### L4. Static Branch Compatibility

Every ordinarily completing `if` or exhaustive `case` arm has the same
`Rho_j;Gamma_lj`. No arm silently drops, duplicates, or invents a source
linear owner. Dynamic TPOE has no ordinary post-state.

## 4. Runtime Value And Slot Lemmas

### L5. Runtime Value Canonical Forms

A runtime value has exactly the shape admitted by its type:

| Type | Runtime value shape |
| --- | --- |
| `Unit` | `nil` |
| `Bool` | `true` or `false` |
| `IntK` | an abstract checked integer |
| `Resource[k]`, `Capability[k]` | `own[a]` with matching live resource type |
| `SumRT[tag_i:tau_i]` | `inject tag_j w` with `w:tau_j` |
| `BorrowRT[r,beta,tau]` | `read_ref[r,beta,ell]` with `XT(Xi)(ell)=tau` and `usable_read` |
| `MutBorrowRT[r,beta,tau]` | `write_ref[r,beta,ell]` with `XT(Xi)(ell)=tau`; access requires `usable_write` |

The literal source rules step directly to the corresponding `Unit`, `Bool`,
or `IntK` canonical runtime value.

### L6. Arbitrary Linear Slot Admission

If `w:runtime_type(I,T)`, `T:Linear`, and `ell` is fresh, extending `Xi`
with `ell |-> live(runtime_type(I,T),w)` preserves slot typing. `Xi` stores
runtime types uniformly. This includes linear sums.

### L7. Slot Movement

If `Xi(ell)=live(tau,w)` and `unborrowed(B,ell)`, `E-Move` changes exactly that
slot to `moved(tau)` and returns the same arbitrary linear value `w`. It neither
duplicates nor discards any identity in `owners(w)`.

### L8. Explicit Named Consumption

If `Xi(ell)=live(runtime_type(I,T),w)`, `unborrowed(B,ell)`,
`Delta |- op admitted-consuming T -> Unit`, and
`consume_op(Delta,Sigma,op,w)=Sigma'`, `E-Consume` changes exactly that slot to
`moved(runtime_type(I,T))`, changes every store entry in `owner_ids(w)` from live to
matching consumed state, changes no store entry outside `owner_ids(w)`, creates
no owner identity, and returns `nil`. The relation has no structural fallback.
In particular, a linear sum is destructured and its selected payload is
explicitly discharged unless `Delta` independently admits a named consuming
operation for the sum.

### L9. Linear Scope Exit

`F-End-Linear-Pending` types body evaluation while `local_obligation(Xi,ell,tau)`
holds: the fresh local slot may still be live or may already be a tombstone. The
separate `Ready-End-Linear` rule admits the `E-End-Linear` pop only after
`Xi(ell)=moved(tau)`. L2 ensures a well-typed execution cannot reach ordinary
scope exit with a live local slot.

### L10. Carrier Partition

`owners_machine(C)` counts resource identities in live slot values, the
current `ret(w)`, and evaluated argument fields held by continuation frames.
It does not count source expressions, discarded branch syntax, environments,
slot references, borrow tokens, or moved-slot tombstones.

### L11. Live-Owner Carrier Bijection

For every `WT(C)`, each live resource in `Sigma` occurs exactly once in
`owners_machine(C)`, and every identity in `owners_machine(C)` names one live
resource. Each ordinary transition preserves this bijection except that
`E-Consume` removes resources consumed by its declared named operation and
`E-Attenuate` replaces one strong capability identity with one fresh weaker
identity. A TPOE transition snapshots `abandoned_owners(control,K)` into `A`
before erasing continuation frames, so `terminal_owners(Xi,A)` preserves the
corresponding terminal bijection.

### L12. Branch Selection Preserves Slot Ownership

`E-If-True`, `E-If-False`, and `E-Case-Select` discard only source syntax and
frames. They do not copy or discard runtime slot values. A source variable can
occur in multiple arms while its runtime owner remains in one slot.

## 5. Lease Graph Lemmas

### L13. Retained-Writer Meaning

`no_writer(B,ell)` is equivalent to `all_writes(B,ell)=empty`. It remains false
while a mutable parent lease is suspended behind a read-reborrow child.
Direct shared borrowing through the owner slot is rejected in that state.

### L14. Direct Immutable Borrow Compatibility

Adding one fresh read lease under `no_writer(B,ell)` preserves `WF(B,Xi)`.
Existing retained readers can coexist.

### L15. Direct Mutable Borrow Exclusivity

Adding one fresh write lease under `unborrowed(B,ell)` preserves `WF(B,Xi)`
and establishes one frontier writer.

### L16. Borrowed Slot Immobility

If `all_reads(B,ell)` or `all_writes(B,ell)` is non-empty, movement, named
consumption, and capability attenuation of slot `ell` have no transition.
Observation requires `usable_read` or `usable_write`; mutation requires
`usable_write`. Borrow access never bypasses the retained-lease graph.

### L17. Mutable Reborrow Suspension

`reborrow_write(B,beta,beta',r,ell)` is defined only for one usable parent
writer, fresh child identity, and nested child region. It atomically adds the
child writer and records `Suspended(beta)=beta'`. The parent leaves the
frontier and `WF` is preserved.

### L18. Read Reborrow Suspension

`reborrow_read(B,beta,beta',r,ell)` has the same premises as L17 but adds one
child reader. The suspended parent writer remains retained in `all_writes`,
leaves the frontier, and prevents direct owner borrowing. `WF` is preserved.

### L19. Copied Suspended Mutable Token

A copied `write_ref[s,beta,ell]` remains runtime-typed while `beta` is
suspended, but it fails `usable_write(B,beta,ell)`. It cannot satisfy `write_access`, `read_access`, reborrow, or mutable call
compatibility until the direct child closes. An immutable token satisfies
`read_access` only while `usable_read` holds.

### L20. Close Is Defined And Local

If `closable(B,r)`, let `D=leases_at(B,r)`. `close(B,r)` removes exactly `D`,
removes exactly suspension edges whose child lies in `D`, resumes those direct
parents, removes no unrelated edge, and pops only top region `r`. The
writer-chain clause of `WF(B,Xi)` excludes an unrelated frontier reader or
writer beside a resumed parent. The full close derivation is recorded in
`close-and-witness-proof.md`.

### L21. Suspension Graph Acyclicity

Every suspension edge descends strictly through lexical region nesting.
Therefore `Suspended` is acyclic. Partial injectivity gives each child at most
one direct parent; function shape gives each parent at most one direct child.

### L22. Borrow Non-Escape

Static region typing excludes ended static atom `rho` from the ordinary result
type and output contexts. Runtime region exit additionally requires the mapped
identity `r notin regions(w)`. It therefore cannot return a token whose lease was
removed by `close(B,r)`.

### L23. Borrow-State Preservation

Every region, direct-borrow, reborrow, and close transition preserves
`WF(B,Xi)` by L13-L22. Witness extension and restoration preserve
`WF_I(Rho,B,I,eta)`: static atoms map to their corresponding active runtime
identities, caller-framed runtime leases need not be in the witness domain,
and `close_witness(I,rho)=I_entry` pops exactly the scope-owned `region(rho)`
layer. Explicitly authorized caller/callee aliases can share runtime images,
but local close never removes an outer-layer mapping. The close cases and
their finite-renaming argument are expanded in `close-and-witness-proof.md`.

## 6. Environment, Frame, And Call Lemmas

### L24. Environment Agreement

If runtime environment `eta` agrees with static contexts
`Gamma_f;Gamma_l`, it extends the interpretation required by those contexts:
required unrestricted names map to matching `free(w)` values and required
linear names map to distinct matching live slots. Additional captured
mappings are inert because the typed expression cannot name them; they can
refer to moved tombstones after an earlier source-ordered effect. Slot
references themselves carry no owner identity. Every required static lease in
`Rho` resolves through `eta` to its matching runtime slot lease in `B` under
`lease_bridge(Rho,B,I,eta)`. Additional runtime leases are caller-framed facts:
they remain visible to conflict checks but are not reachable unless an actual
argument token exposes them.

### L25. Payload Binding

`bind_payload` preserves environment agreement. A free payload extends `eta`
directly. A linear payload moves into one fresh slot and pushes one
`end_linear` frame.

### L26. Frame Typing

The closed frame-typing judgment in `dynamics.md` assigns each continuation
constructor one input result type and one output result type. `F-Let-Free` and
`F-Let-Linear` distinguish unrestricted and linear body environments.
`F-End-Linear-Pending` and `F-Call-Return-Pending` retain live obligations while
the body executes. The separate `ready(w,K)` judgment requires tombstones at the
exact pop transition. The remaining closed table defines `inject_value`,
`region_end`, `call_args`, `checked_args`, and `check_result`. Structural
`frame_values` extraction includes evaluated `done` arguments in L10 carrier
accounting. If current control returns the frame input type, readiness selects
one transition producing a typed ordinary state or intrinsic typed TPOE. The
frame-local derivation is expanded in `frame-typing-proof.md`.

### L27. Static Call Compatibility

`static_call_compatible` maps formal region, lease, path, and source-argument
relationships to actual source facts. `materialize_call_paths(phi,eta)=pi`
resolves caller whole-referent paths before argument evaluation begins, requires every mutable actual token unsuspended, requires
every read token usable, enforces declared equality or distinctness
relationships, and frames unrelated caller leases unchanged.
The complete call-start and call-entry derivation is expanded in
`call-entry-proof.md`.

### L28. Runtime Call Instantiation

If
`instantiate_call(Delta,Sigma_t,f,phi,pi,B,I,Xi,args)=<Xi',I_f,I_formal,eta_f,e_f',param_slots,psi,phi(U)>`,
then:

1. `phi` is the explicit checker-recorded call-instantiation witness retained
   by the elaborated call syntax;
2. `alpha_freshen` renames callee-local static region atoms, static lease atoms,
   and ordinary binders capture-avoidantly for this invocation;
3. `alpha_freshen` derives invocation-local callee view `psi` from recorded
   caller-visible witness `phi`;
4. `realize_call` deterministically maps formal external atoms to the runtime
   identities already carried by checked token arguments; it does not solve or
   choose an instantiation;
5. every actual runtime value has exactly its `runtime_type(I_f,psi(T_i))`;
6. mutable token arguments satisfy `usable_write` and read tokens satisfy
   `usable_read`;
7. `bind_call_args` moves every owned argument into one fresh parameter slot,
   binds every free argument directly, and records exactly the fresh owned-
   parameter slots in `param_slots`;
8. `pi` stores each checked caller whole-referent path as one caller slot before
   argument evaluation, and token-carried referent slots agree with that evidence;
   no implicit field-path semantics are used;
9. the invocation witness is one scope-owned call layer; repeated runtime images
   require explicit checked alias authorizations, and popping that layer never
   removes caller mappings;
10. unrelated leases remain unchanged in `B`, remain visible to conflict
    predicates, and remain unreachable through the callee environment;
11. runtime owner slots are allocated freshly rather than alpha-renamed;
12. recursive invocation cannot collide with active caller static atoms or
    runtime region identities.

`call-entry-proof.md` expands the ordered instantiation and carrier-transfer
proof.

### L29. Call Return Discharges Parameters

`F-Call-Return-Pending` types callee execution while each owned parameter slot
satisfies `parameter_obligations`: it may still be live or may already be a
tombstone. `Ready-Call-Return` admits ordinary pop only when every owned
parameter slot is `moved(tau)` and the borrow graph equals `B_entry`. Local linear lets are independently protected by
their `end_linear` frames. Local leases must close before return.
`return_witness(I,I_entry,I_formal)` proves that only invocation-formal mappings
remain above the caller witness. `result_bridge` then types the same returned
runtime value under invocation-local `psi(U)` and caller-visible `phi(U)` before
`I_entry` is restored exactly. The returned value is already a separate carrier
and can hold moved owned payloads or an admitted caller-tied borrow. The complete
return-restoration argument is expanded in `call-entry-proof.md`.

### L30. Suspended Mutable Argument Rejection

If `write_ref[s,beta,ell]` names a suspended parent lease,
`instantiate_call` is undefined for any formal mutable-borrow argument using
that token. A callee cannot unfold under an unavailable mutable access.

## 7. Failure, Capability, And Renaming Lemmas

### L31. TPOE Is Separate Defined Termination

A failed check transitions to `tpoe<contract_false,Sigma,B,I,Xi,A>`. A failed
checked primitive transitions to
`tpoe<checked_failure(op,args),Sigma,B,I,Xi,A>`. Each failure rule computes
`A=abandoned_owners(control,K)` before erasing `K`. `WT_TPOE` is an intrinsic
terminal-state judgment: it independently checks the store, slot, lease-graph,
witness, and `terminal_carrier_bijection(Sigma,Xi,A)` invariants rather than
being defined by predecessor reachability. `A` is proof-facing accounting, not
cleanup work and not resumable control. `frame-typing-proof.md` expands the
terminal carrier case.

### L32. Possible TPOE Does Not Imply `Never`

A checked source term retains its declared successful ordinary result type.
Dynamic TPOE does not change that type to `Never`. First-core checked
primitives have only `Free` inputs and outputs, so primitive success and TPOE
cannot silently discard a linear carrier.

### L33. Capability Origin Preservation And Primitive Admission

A primitive enters `Delta` only after the applicable declaration-admission
judgment proves its semantic relation total on admitted typed inputs and proves
its invariant footprint. Therefore admitted consuming operations, checked
primitives, read/write borrow access primitives, and attenuation cannot create
a typed stuck state merely because an operational relation is undefined.

Attenuation consumes one unborrowed strong capability slot, consumes its live
resource identity, creates one fresh weaker resource identity, and records one
accepted origin edge. Every reachable live capability origin chain ends at
initial authority. `primitive-admission-proof.md` expands the consuming,
checked, borrow-access, and attenuation derivations.

### L34. Capability Non-Forgery

No first-core source term creates capability authority from bytes, integers,
ordinary resources, borrow tokens, or sum constructors.

### L35. Binder Alpha-Equivalence

Capture-avoiding alpha-renaming of source lexical-region binders, static lease
atoms, and function-local binders preserves source typing and invocation behavior. Every
elaborated core binder is alpha-fresh within its lexical scope; surface
shadowing elaborates to fresh core names before the source rules apply.

### L36. Fresh-Step Equivalence

Two executions of one selected transition that differ only in fresh runtime
region, runtime lease, slot, or attenuated-resource identities yield `fresh_step_equiv`
targets.

### L37. Equivariance

Source typing, runtime value typing, machine typing, stepping, `nested`,
`closable`, `close`, witness extension, `close_witness`, `return_witness`, `result_bridge`,
`bind_payload`, `bind_call_args`, and `instantiate_call` are preserved by
finite sort-preserving runtime renaming.

## 8. Machine Progress And Preservation Lemmas

### L38. Unique Machine Decomposition

Every nonterminal intrinsically typed ordinary configuration is either ordinary
final or matches exactly one control/frame transition family, modulo
fresh-step equivalence. The proof proceeds by the explicit `WT-Eval`, `WT-Ret`,
and closed frame-typing rules, using declaration admission for every primitive
relation.

### L39. Ordinary-Step Preservation

If `WT(C)` and `C --> C'` with ordinary `C'`, then `WT(C')`. The proof is by
cases over machine transitions using L5-L30 and L33-L37.

### L40. Defined-Failure Preservation

If `WT(C)` and `C --> tpoe<q,Sigma,B,I,Xi,A>`, then
`WT_TPOE(tpoe<q,Sigma,B,I,Xi,A>)` by the matching intrinsic terminal rule,
`A=abandoned_owners(control,K)`, and L31-L33. This is an invariant-preservation proof, not a reachability tautology.

## 9. Main Theorems

### Theorem P. Preservation-Or-Defined-Failure

If `WT(C)` and `C --> C'`, exactly one applies:

1. `C'` is ordinary and `WT(C')`;
2. `C' = tpoe<q,Sigma,B,I,Xi,A>` and `WT_TPOE(C')`.

### Theorem Q. Ordinary Progress

If `WT(C)`, exactly one applies modulo `fresh_step_equiv`:

1. `ordinary_final(C)`;
2. there exists one ordinary `C'` with `C --> C'`;
3. there exists one terminal `C_tpoe` with `C --> C_tpoe` and
   `WT_TPOE(C_tpoe)`.

TPOE is not included in the premise. It is classified by `WT_TPOE` after a
failure transition.

## 10. Corollary Targets

Theorems P and Q discharge these narrow corollary targets for the first-core theorem:

```text
NoDuplicateLinearOwnership
NoSilentLinearDropOnOrdinaryCompletion
NoUseAfterMoveOrNamedConsume
MutableBorrowExclusivity
BorrowNonEscape
CapabilityNonForgery
CheckedFailureIsDefined
```

Each corollary applies only to `lambda_K-seq`. Cleanup, records, partial
moves, mutable `Free` places, allocation, concurrency, unsafe, FFI, backend
preservation, stdlib correctness, and toolchain conformance remain explicit
later obligations.
