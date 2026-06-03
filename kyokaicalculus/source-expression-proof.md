# Source Expression Derivation Package

**Status:** `paper-proven` Gate-B source-control derivation package  
**Discharges:** source-control cases of L1-L8, L12-L19, L24-L25, and L32-L36  
**Depends on:** `syntax-and-statics.md`, `dynamics.md`, `lemmas.md`

## 1. Claim Boundary

This package discharges the source-expression half of the sequential first-core
proof. It makes the control-side induction explicit so `theorem-assembly.md` can
compose it with the closed frame judgment in `frame-typing-proof.md`.

The induction ranges only over terms included in `scope.md`. Cleanup, panic, mutable
`Free` places, records, partial moves, allocation, concurrency, unsafe, FFI, backend
lowering, and standard-library implementation remain excluded.

## 2. Structural Source Lemmas

### L1: Unrestricted Weakening And Contraction

The proof is induction over source typing. Every rule threads `Gamma_f` without
consuming it. Adding an unused `x:T` with `T:Free` preserves each premise. Merging two
names that map to one `Free` value preserves each premise after capture-avoiding
renaming. Borrow tokens remain `Free` access tokens: contraction copies one token
value carrying one lease identity; it does not mint a lease or duplicate the
referent.

### L2: Linear Exactness

The proof is induction over source typing. There is no weakening or contraction rule
for `Gamma_l`. `move x`, `consume[op] x`, and `attenuate x as k` remove `x`. Borrow
creation leaves the owner in `Gamma_l` while extending `Rho`. `T-Let-Linear` and the
linear payload branch of `T-Case` require the introduced name absent from the
ordinary output context. Every ordinarily completing branch of `T-If` and `T-Case`
returns one identical linear post-state. Dynamic TPOE has no ordinary post-state.

### L3: Static State Threading

The proof is direct from the premises of `T-Seq`, `T-Args-Cons`, `T-Let`, and branch
rules. The output `Rho;Gamma_l` of one source-ordered premise is exactly the input of
the next. No rule skips an intermediate state.

### L4: Static Branch Compatibility

`T-If` checks both arms under the condition post-state and requires one shared output
`Rho_j;Gamma_lj`. `T-Case` does the same for every exhaustive arm after
universe-sensitive payload binding. Therefore an ordinary join cannot hide a move,
drop, lease creation, or lease close performed by only one branch.

## 3. Runtime Values, Slots, And Named Consumption

### L5: Canonical Values

The proof is inversion over runtime value typing. `Unit`, `Bool`, and `IntK` have
their literal shapes. `Resource[k]` and `Capability[k]` have `own[a]` with matching
live store type. A sum has `inject tag_i w` for one declared payload type. Borrow
tokens carry one active runtime region, lease, and referent slot; mutable token value
typing permits suspension, while access rules separately require usability.

### L6-L7: Linear Slot Admission And Movement

`E-Let-Linear`, linear `bind_payload`, and linear `bind_call_args` allocate one fresh
slot with runtime type `runtime_type(I,T)`. Freshness preserves existing entries.
`E-Move` changes one live slot to a tombstone and returns the same arbitrary runtime
value. Because `owner_ids` recurses through sums, moving `inject tag own[a]` transfers
one carrier without requiring a resource-only redex.

### L8: Named Consumption

`T-Consume` cites one admitted named operation. `E-Consume` applies only to one live,
unborrowed slot. Declaration admission supplies one total `consume_op` result that
marks exactly `owner_ids(w)` consumed, leaves unrelated store entries unchanged,
creates no owner identity, tombstones the slot, and returns `nil`. There is no
structural destructor fallback.

## 4. Branch And Payload Cases

### L12: Branch Selection

`E-If-True`, `E-If-False`, and `E-Case-Select` discard only source syntax held by one
frame. Source branch syntax and environment slot references contribute no runtime
owner carrier. `bind_payload` handles the selected case payload exactly once:

| Payload universe | Dynamic binding | Carrier effect |
| --- | --- | --- |
| `Free` | bind `x |-> free(w)` | no resource carrier added |
| `Linear` | allocate fresh `ell`, store `live(runtime_type(I,T),w)`, bind `x |-> slot(ell)`, push `end_linear(ell)` | returned carrier moves into one slot |

Unselected arms do not execute and never receive runtime owner values.

## 5. Borrow Lifecycle And Access Cases

### L13-L16: Direct Borrow And Use

| Term | Required runtime premise | State change | Preservation fact |
| --- | --- | --- | --- |
| `borrow[rho,b] x` | `no_writer(B,ell)` | add one fresh read lease | retained writers remain absent |
| `mut_borrow[rho,b] x` | `unborrowed(B,ell)` | add one fresh write lease | no read or write competitor exists |
| `read_access[op] x` through immutable token | `usable_read(B,beta,ell)` | admitted observation only | topology, witnesses, owners, and origins remain unchanged |
| `read_access[op] x` through mutable token | `usable_write(B,beta,ell)` | admitted observation only | same invariant footprint |
| `write_access[op] x` | `usable_write(B,beta,ell)` | admitted protected payload mutation | slot runtime type and owner carrier remain unchanged |

`no_writer` examines all retained writers, including suspended parents. Therefore a
read reborrow cannot make a direct shared borrow through the owner legal while the
parent mutable lease remains retained.

### L17-L19: Reborrow And Suspension

`E-Reborrow` and `E-Read-Reborrow` require one usable parent mutable lease, one nested
active child region, and one fresh child lease identity. Each transition atomically
adds the child and suspends the parent. The parent token remains typable as a copied
`Free` value but fails `usable_write` until close removes the child edge. Access,
reborrow, and mutable call entry all reject that suspended token.

## 6. Environment Agreement And Payload Binding

### L24: Environment Agreement

`eta agrees Gamma_f;Gamma_l` is preserved by each binding step:

1. a free binding adds `x |-> free(w)` with matching runtime type;
2. a linear binding adds fresh `x |-> slot(ell)` with one matching live runtime slot;
3. movement tombstones the slot and removes the corresponding required source name
   before later source-ordered evaluation;
4. captured environments can retain inert mappings to tombstones, but a typed current
   expression cannot name a removed linear binding;
5. `lease_bridge(Rho,B,I,eta)` keeps each required static path connected to one
   matching runtime slot lease while unrelated caller leases remain framed.

### L25: Selected Payload Binding

The two `bind_payload` clauses are total after canonical-sum inversion. The `Free`
clause extends only `Gamma_f` interpretation. The `Linear` clause uses L6, transfers
the returned carrier into one fresh slot, and pushes `end_linear` so ordinary arm exit
requires visible discharge.

## 7. Failure, Capability, And Freshness Cases

### L32: Possible TPOE Does Not Imply `Never`

`T-Check` has successful result `Unit`. `T-Checked-Primitive` has the admitted
successful `Free` result type `U`. Their dynamic failure transitions enter intrinsic
`tpoe<q,Sigma,B,I,Xi,A>` and do not manufacture an ordinary `Never` value.

### L33-L34: Capability Origin And Non-Forgery

Initial configuration and admitted attenuation are the only first-core capability
origins. `E-Attenuate` consumes one unborrowed strong slot and store identity, creates
one fresh weaker identity with explicit origin edge, tombstones the source slot, and
returns the fresh weaker owner. Literals, sums, moves, borrows, access nodes, and
checked primitives do not create capability authority.

### L35-L36: Binder Alpha And Fresh-Step Equivalence

Capture-avoiding source-binder renaming preserves each source derivation by ordinary
induction. Runtime fresh choices appear only in region entry, lease creation,
reborrow, fresh slot allocation, and attenuation. Two targets that differ only in one
consistent sort-preserving renaming of freshly minted identities satisfy
`fresh_step_equiv`.

## 8. Closed Case Derivations

This section expands the compressed induction obligations. Each row cites the
actual static premise and the runtime family that preserves it.

### 8.1 L1: Unrestricted Weakening And Contraction

Induct on the final source typing rule.

| Final rule | Weakening case | Contraction case |
| --- | --- | --- |
| Literals | Premises do not mention `Gamma_f`; the same rule applies. | Same derivation; no name is read. |
| `T-Var-Free` | If the variable is the old one, lookup is unchanged. If it is the new unused name, the original expression cannot name it, so the old lookup remains selected. | If either contracted name is selected, replace it by the representative name and use the shared `Free` value typing. |
| `T-Let-Free` | Apply induction to the initializer under the old context, then to the body under the context extended with the bound `Free` name. Alpha-rename the bound name away from the weakened name first. | Apply induction to initializer and body after alpha-renaming the binder away from both contracted names. |
| `T-Let-Linear`, `T-Case` linear arm, and owned call formals | The added `Free` name is threaded through `Gamma_f`; exact-use `Gamma_l` premises are unchanged. | Contract only `Gamma_f`; linear binders and owned formals remain distinct. |
| `T-Seq`, argument lists, `T-If`, `T-Case` | Apply induction to every premise in source order. The post-state equality required by the rule is unchanged because `Gamma_f` is not consumed. | Contract in each premise; branch post-state equality is preserved because all branches receive the same contracted `Gamma_f`. |
| Borrow-token access and calls | A copied borrow token carries the same `read_ref` or `write_ref` runtime value. No rule mints a new static lease, runtime lease, or owner. | The contracted token aliases one lease identity; usable-access premises still inspect `Rho`/`B`, not multiplicity of `Gamma_f` names. |

Therefore adding or contracting unrestricted names cannot change linear ownership,
lease creation, lease suspension, or source post-state.

### 8.2 L2: Linear Exactness

Induct on the final source typing rule and track `Gamma_l` input/output.

| Final rule | Exact-use obligation |
| --- | --- |
| Literals and `T-Var-Free` | Output `Gamma_l` equals input `Gamma_l`; no linear binding is introduced or removed. |
| `T-Move` | Requires `x:T` in `Gamma_l` and `unborrowed(Rho,x)`; output removes exactly `x`. |
| `T-Consume` | Same source removal as `T-Move`; dynamic consumption additionally tombstones the resolved slot. |
| `T-Attenuate` | Removes the strong capability variable; the returned weaker capability is a produced value, not an implicit source binding. A caller must bind it explicitly with `let`. |
| `T-Borrow` and `T-MutBorrow` | Leave the owner in `Gamma_l` and extend `Rho`; later movement/consumption is blocked by retained leases until close. |
| `T-Reborrow` and `T-Read-Reborrow` | Operate on `Free` tokens and update `Rho`; they do not add or remove a linear owner binding. |
| `T-Let-Linear` | The initializer produces a linear value. The body is checked with `x:T` added, and the rule requires the ordinary body output to omit `x`. |
| Linear `T-Case` arm | The selected payload binding is checked as a linear owner and must be absent from that arm's ordinary output. All ordinary arms still share one post-state. |
| `T-Seq` and argument lists | The next premise receives exactly the previous premise's output; no premise can skip a live linear name. |
| `T-If` and `T-Case` | Every ordinarily completing arm must return the same output `Gamma_l`; an arm that moves an owner not moved by the others fails the join. |
| Dynamic TPOE forms | They have no ordinary output state, so they cannot witness a successful path with an unconsumed linear binding. |

No source rule weakens, contracts, silently drops, or silently fabricates a member
of `Gamma_l`.

### 8.3 L3: Static State Threading

The proof is structural because every multi-premise source rule names the exact
post-state consumed by the next premise.

| Rule family | Threading equation |
| --- | --- |
| `T-Seq` | `e1` checks from `Rho0;Gamma_l0` to `Rho1;Gamma_l1`; `e2` checks from exactly `Rho1;Gamma_l1`. |
| Source-ordered call args | Argument `i+1` checks from the output of argument `i`; `phi` is checked against the final vector, not a reordered vector. |
| Source-ordered checked args | Same list induction as calls; checked primitives accept only the completed source-order vector. |
| `T-Let-Free` and `T-Let-Linear` | The body input is the initializer output plus the one new binding. |
| `T-If` | The condition output is the input to both arms; both arms return one common post-state. |
| `T-Case` | The scrutinee output is the input to every selected-arm derivation after the universe-sensitive payload binding. |

Thus no dynamic family can be selected from a stale pre-state when the static
derivation is inverted.

### 8.4 L4: Static Branch Compatibility

For `if`, invert `T-If`. The condition has type `Bool`. The true and false arm
derivations both start from the condition post-state and both end in exactly
`Rho_j;Gamma_lj`. If one arm consumes, moves, borrows, reborrows, closes, or
attenuates a linear owner differently from the other, its output state differs and
the rule is inapplicable.

For `case`, invert `T-Case`. Exhaustiveness gives one arm per tag. Each arm is
checked from the scrutinee post-state plus exactly one payload binding. A `Free`
payload extends `Gamma_f`; a `Linear` payload extends `Gamma_l` and must be
discharged before the arm's ordinary output. All arms share one post-state. Dynamic
TPOE in an arm has no ordinary join state and therefore cannot mask a linear-state
mismatch.

### 8.5 L5: Runtime Canonical Forms

Induct on runtime value typing.

| Runtime type | Last value rule | Canonical result |
| --- | --- | --- |
| `Unit` | `V-Unit` | value is `nil` |
| `Bool` | `V-Bool` | value is `true` or `false`; no other rule concludes `Bool` |
| `IntK` | `V-IntK` | value is one abstract checked integer literal |
| `Resource[k]` / `Capability[k]` | `V-Owner` | value is `own[a]` and `Sigma_t(a)` has the matching resource/capability type |
| `SumRT[tag_i:tau_i]` | `V-Inject` | value is `inject tag_j w` for one declared tag and `w:tau_j` |
| immutable borrow | `V-Read-Token` | value is `read_ref[r,beta,ell]`, `B(beta)=<r,read,ell>`, `active(B,r)`, and `slot_types(Xi)(ell)=tau` |
| mutable borrow | `V-Write-Token` | value is `write_ref[r,beta,ell]`, `B(beta)=<r,write,ell>`, `active(B,r)`, and `slot_types(Xi)(ell)=tau`; usability is a separate premise |

The mutable-token case deliberately separates value typing from `usable_write` so a
copied suspended parent token can remain a value without granting access.

### 8.6 L6-L8: Slots, Movement, And Named Consumption

For L6, `E-Let-Linear`, linear `bind_payload`, and linear `bind_call_args` all
choose `fresh_slot(Xi,ell)`. Extending `Xi` with
`ell |-> live(runtime_type(I,T),w)` leaves every old lookup unchanged and gives the
new slot exactly the type supplied by the source premise. Since `runtime_type` is
applied at the boundary, the store never mixes source and runtime type atoms.

For L7, invert `E-Move`: `eta(x)=slot(ell)`, `Xi(ell)=live(tau,w)`, and
`unborrowed(B,ell)`. The target changes only `Xi(ell)` to `moved(tau)` and returns
the same `w`. Owner accounting removes `owner_ids(w)` from the slot component and
adds the identical multiset to the returned-control component.

For L8, invert `T-Consume` and primitive admission. Admission proves totality and
the exact footprint of `consume_op`. `E-Consume` is defined only for a live,
unborrowed slot. It tombstones exactly that slot, consumes exactly
`owner_ids(w)`, preserves unrelated `Sigma` entries, creates no owner identity, and
returns `nil`. A missing `consume_op` is an admission failure, not a progress case.

### 8.7 L14-L18: Borrow Creation And Suspension

| Lemma | Transition | Preservation argument |
| --- | --- | --- |
| L14 | `E-Borrow` | `no_writer(B,ell)` means `all_writes(B,ell)=empty`; adding a fresh read lease cannot create a writer conflict, and every existing retained read is same-mode. |
| L15 | `E-MutBorrow` | `unborrowed(B,ell)` means no retained read or write exists; adding one fresh write lease creates exactly one frontier writer. |
| L16 | move/consume/attenuate/access | If any retained lease protects `ell`, `unborrowed(B,ell)` fails, so owner movement, named consumption, and attenuation cannot step. Read access requires `usable_read` or `usable_write`; write access requires `usable_write`. |
| L17 | `E-Reborrow` | The parent must be an unsuspended usable writer in an outer region. The child identity is fresh, the child region is nested, the child protects the same slot, and `Suspended(parent)=child` removes the parent from the frontier. |
| L18 | `E-Read-Reborrow` | Same as L17 except the child mode is read. The retained parent remains in `all_writes`, so direct owner read still fails `no_writer`. |

Each case preserves active-region membership, same-slot edge consistency,
partial-injective suspension shape, acyclicity by strict nesting, and writer-chain
isolation because the only new lease is on the parent's chain.

### 8.8 L24-L25: Environment Agreement And Payload Binding

For L24, induct on the environment-agreement derivation.

| Runtime event | Agreement preservation |
| --- | --- |
| Free binding | Extend `eta` with `x |-> free(w)` and use runtime value typing for `w`. No slot or owner carrier is added. |
| Linear binding | Extend `eta` with `x |-> slot(ell)` where L6 created one fresh matching live slot. Distinctness follows from `fresh_slot`. |
| Movement or consumption | The current expression's source typing removes `x` from `Gamma_l`; any captured mapping to `ell` is inert because later typed source cannot name removed `x`. |
| Borrow and reborrow | `lease_bridge` extends with the static/runtime lease pair created by the transition; unrelated framed leases remain visible to conflicts but unreachable by names. |
| Call entry and return | `call-entry-proof.md` proves that `phi`, `pi`, `psi`, `I_formal`, and `result_bridge` preserve agreement across the invocation layer. |

For L25, invert canonical sum typing. The selected payload is the only payload value
available to `bind_payload`. In the `Free` case the environment receives
`free(w)` and carrier accounting is unchanged. In the `Linear` case L6 creates one
fresh slot, the environment receives `slot(ell)`, and `end_linear(ell)` makes ordinary
arm exit require tombstoning. Unselected arms receive no runtime payload.

### 8.9 L33-L37: Failure, Capability, Alpha, Freshness, And Renaming

L33 follows by inverting capability-origin facts. Initial configuration and
`E-Attenuate` are the only origin rules. `E-Attenuate` consumes one strong owner,
creates one fresh weaker owner, and records `attenuated(parent,k_strong,k_weak)`;
all other source-control transitions either move existing owners, create borrow
tokens, or produce `Free` values.

L34 is induction over transitions. Literals, variables, sequencing, branches,
injections, cases, borrows, reborrows, access, calls, and checked primitives create
no capability owner. Named consumption only consumes. Attenuation creates one owner
only under an admitted weakening edge and with an explicit origin. TPOE snapshots
owners but creates no owner or authority.

L35 is capture-avoiding source-binder alpha induction. The affected binders are
`let` names, case payload names, function-local names, and source region atoms.
Before each binder case, choose a name fresh for free names in the surrounding source
and active witness domains. Static lookup, `regions(T)`, and path references are
renamed consistently, so typing and invocation behavior are preserved.

L36 is by cases on the fresh-minting transitions: region entry mints one runtime
region, borrow creation and reborrow mint one lease, linear binding and payload/call
binding mint one slot, and attenuation mints one resource. In each case the selected
transition is deterministic after the fresh identity is chosen; two choices differ
only by a sort-preserving bijection on the new identity and therefore satisfy
`fresh_step_equiv`.

L37 is the relation-local equivariance theorem from `equivariance-proof.md`. Every
source-control case either fixes runtime identities, applies a helper already shown
to commute with finite sort-preserving renaming, or allocates a fresh identity and is
compared modulo L36.

## 9. Source-Control Decomposition Table

| Evaluated source form | Static evidence | Selected runtime family |
| --- | --- | --- |
| literal | literal typing | `E-Literal` |
| unrestricted variable | `x:T in Gamma_f` | `E-Var-Free` |
| `let x:T=e1 in e2` | `T-Let-Free` or `T-Let-Linear` | `E-Let-Eval`, then one ready `E-Let-*` rule |
| `move x` | live unborrowed linear owner | `E-Move` |
| `consume[op] x` | admitted named consuming operation | `E-Consume` |
| `e1; e2` | first result `Unit` | `E-Seq-Eval`, then `E-Seq-Next` |
| `region rho in e` | fresh region atom | `E-Region-Enter`, then ready `E-Region-Exit` |
| direct borrow | retained-writer or unborrowed premise | `E-Borrow` or `E-MutBorrow` |
| reborrow | usable parent mutable lease | `E-Reborrow` or `E-Read-Reborrow` |
| borrow-token access | admitted operation and usable token | `E-Read-Access-*` or `E-Write-Access` |
| `if` | condition `Bool`; compatible arms | `E-If-Eval`, then one selected arm |
| injection | declared payload type | `E-Inject-Eval`, then `E-Inject-Return` |
| exhaustive `case` | declared sum and compatible arms | `E-Case-Eval`, then `E-Case-Select` |
| `call f[phi](args)` | explicit checked certificate and source-ordered arguments | `E-Call-Zero` or `E-Call-Start`; frame package handles continuation |
| `check e else tpoe` | condition `Bool` | `E-Check-Eval`; frame package selects success or intrinsic TPOE |
| `checked[op](args)` | admitted total checked primitive | zero-argument or source-ordered checked family |
| `attenuate x as k` | admitted weaker authority edge | `E-Attenuate` |

For each row, source typing and canonical forms select one transition family.
`frame-typing-proof.md` supplies the returned-control half after a frame is pushed.
Primitive totality is supplied by `primitive-admission-proof.md`. Call entry is
supplied by `call-entry-proof.md`. Region close is supplied by
`close-and-witness-proof.md`.

## 10. Executable Evidence

`model_tests.py` exercises the high-risk representation predicates and primitive
footprints. `machine_runner.py` executes twenty-five selected traces for free and
linear binding, both branch selections, sequencing, arbitrary linear-sum movement,
payload binding, direct and nested borrow access, lexical close, owned-call entry and
return, source-ordered multi-argument calls, checked operations, attenuation,
intrinsic TPOE carrier accounting, and returned-local-borrow rejection. These
artifacts support the paper proof. They are executable evidence, not substitutes for
the human-checkable derivation above and its composition in `theorem-assembly.md`.

## 11. Composition Hooks

This package supplies the source-control cases consumed by `theorem-assembly.md`.
Frame-local return cases come from `frame-typing-proof.md`; close and witness
restoration come from `close-and-witness-proof.md`; invocation cases come from
`call-entry-proof.md`; primitive totality comes from `primitive-admission-proof.md`;
and runtime finite-renaming comes from `equivariance-proof.md`.
