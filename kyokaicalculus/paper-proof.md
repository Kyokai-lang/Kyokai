# `lambda_K-seq` Paper-Proof Overview

**Status:** `paper-proven` proof overview  
**Gate:** K-D closed by `theorem-assembly.md` and derivation packages  
**Depends on:** `scope.md`, `syntax-and-statics.md`, `dynamics.md`, `lemmas.md`

## 1. Claim Boundary

This artifact records the corrected proof shape for the sequential core. The closed
L1-L40, Theorem P, and Theorem Q assembly is maintained in `theorem-assembly.md`. The
previous substitution semantics is retired because it duplicated runtime
owner syntax across mutually exclusive branch bodies and did not remain
closed over arbitrary linear sums.

The revised claim is narrow: an ordinarily well-typed closed
`lambda_K-seq` machine configuration is final, takes one ordinary machine
step, or takes one step to defined terminal TPOE. Ordinary execution does not
get stuck from duplicate linear ownership, silent ordinary-path owner loss,
use after move or named consuming operation, conflicting usable borrow access, access through a suspended token, borrow escape,
capability forgery, or an undefined included primitive relation.

Cleanup, `panic`, mutable `Free` places, records, partial moves, `build`,
allocation, concurrency, unsafe, FFI, backend lowering, stdlib correctness,
and toolchain conformance remain excluded.

## 2. Why The Runtime Representation Changed

A substitution semantics is wrong for this proof target. Consider source term:

```text
let x : Resource[file] = open_file in
  if true then consume[release_resource] x else consume[release_resource] x
```

A substitution step would place one runtime owner value into both branch
bodies even though only one branch executes. Counting syntax would then report
two owners. The corrected machine binds `x` to one linear slot:

```text
Xi(ell_x) = live(Resource[file], own[a])
eta(x)    = slot(ell_x)
```

`if_select` stores the two source branch expressions. Selecting one branch
discards the other source expression without copying or consuming the slot.
Only the selected `consume[release_resource] x` transition consumes `ell_x`.

The same representation handles arbitrary linear sums. For:

```text
let x : Optional[Resource[file]] = inject Some (move file) in move x
```

`x`'s slot holds `inject Some own[a]`. `E-Move` transfers that entire runtime
value. It does not require a resource-only `move own[a]` redex.

## 3. Preservation-Or-Defined-Failure

**Theorem P.** If `WT(C)` and `C --> C'`, exactly one applies:

1. `C'` is ordinary and `WT(C')`;
2. `C'` is terminal TPOE and `WT_TPOE(C')`.

The proof is by cases over machine transitions. The following cases carry the
highest risk and are written for review.

### 3.1 Linear Let And Scope Exit

`E-Let-Linear` receives returned runtime value `w:runtime_type(I,T)`, allocates
fresh slot `ell`, stores `live(runtime_type(I,T),w)`, extends the environment with `x |-> slot(ell)`, and
pushes `end_linear(ell)`. L6 preserves slot typing and L11 transfers owner
carrier responsibility from `ret(w)` into the live slot exactly once.
`F-End-Linear-Pending` permits that slot to remain live while the body executes.

When the body ordinarily returns, `Ready-End-Linear` and `E-End-Linear` apply
only after the slot is `moved(runtime_type(I,T))`. L9 connects this runtime
condition to static exact-use L2. TPOE discards ordinary continuation frames
and does not pretend the slot discharged.

### 3.2 Arbitrary Linear Move

`E-Move` operates on `eta(x)=slot(ell)` and `Xi(ell)=live(tau,w)` for every
linear runtime `tau`. It changes the slot tombstone to `moved(tau)` and transfers the same
closed runtime value into `ret(w)`. L7 preserves arbitrary sums and L11
preserves the owner-carrier bijection.

### 3.3 Explicit Named Consumption

`E-Consume` requires one live unborrowed slot and one explicit declaration
`Delta |- op admitted-consuming T -> Unit`. Declaration admission proves
`consume_op` total over admitted well-typed stores and values. The relation performs only the named
operation's declared store transition: every owner identity carried by `w`
becomes consumed, every unrelated store entry remains unchanged, and this
first-core `Unit`-returning primitive creates no new owner identity. It does not
recurse from the structure of `T`. A linear sum is destructured and its
selected payload explicitly discharged unless `Delta` independently admits a
named consuming operation for that sum. L8 and L16 preserve the slot and
resource invariants.

### 3.4 Branch Selection

`E-If-True`, `E-If-False`, and `E-Case-Select` discard source syntax stored in
one continuation frame. Source expressions contain no runtime owners. The
selected branch uses the same environment and the same owner slots. L12
therefore preserves ownership without a syntactic duplication argument.
If evaluating a condition moved an owner, the captured environment can retain
an inert mapping to that moved tombstone. The selected branch is typed under
the condition's output context and cannot name the removed linear binding.
Case payload binding is universe-sensitive: a `Free` payload extends the
unrestricted environment directly, while a `Linear` payload transfers into
one fresh owner slot guarded by `end_linear`.

### 3.5 Direct Borrow And Retained Writers

`E-Borrow` adds a read lease only under `no_writer(B,ell)`. L13 makes explicit
that this predicate examines retained writers, including suspended parents.
A read-reborrow child does not permit a new direct read through the owner slot.
`E-MutBorrow` requires the stronger `unborrowed(B,ell)` predicate. L14-L16
preserve `WF`.

### 3.6 Reborrow, Copied Tokens, And Close

`E-Reborrow` and `E-Read-Reborrow` require one usable unsuspended parent write
lease. The transition atomically creates one nested child lease and suspends
the parent. The retained lease map still contains the parent, but the frontier
contains only the child. Copied parent tokens remain typed and fail
`usable_write` until close.

For top region `r`, `close(B,r)` removes exactly `leases_at(B,r)`, removes
exactly suspension edges whose child was removed, resumes only their direct
parents, and pops only `r`. Region exit also requires `r notin regions(w)` and
`close_witness(I,rho)=I_entry`, so the returned value cannot retain a token
whose lease was removed. The witness is a stack of scope-owned layers: close pops
exactly `region(rho)`, never every mapping that happens to share one runtime image.
Explicitly authorized caller/callee aliases therefore cannot be erased by local close.
The writer-chain clause of `WF(B,Xi)` also excludes an unrelated frontier lease
beside a resumed writer. `close-and-witness-proof.md` expands the L20, L21, L23,
and close-specific L37 derivations. L17-L23 discharge the graph-preservation case.

### 3.7 Runtime Borrow-Token Type Connection

`V-Read-Token` and `V-Write-Token` require `slot_types(Xi)(ell)=tau`. A lease
cannot type as a borrow of an arbitrary payload. Mutable-token typing permits
a suspended copied parent token to remain a value; access, reborrow, and
mutable call compatibility separately require `usable_write`.

### 3.8 Access Through Borrow Tokens

The core includes `read_access[op]` and `write_access[op]`. Observation through an
immutable token requires `usable_read`. Observation or mutation through a mutable
token requires `usable_write`. Their admitted operational relations preserve owner
carriers, lease topology, witness layers, and capability origins. A suspended parent
mutable token remains typable as a copied value but has no access transition. L16 and
L19 therefore establish a narrow usable-access exclusivity claim rather than only a
token-lifecycle claim.

### 3.9 Invocation And Recursive Binder Freshening

`E-Call-Start` first computes `materialize_call_paths(phi,eta)=pi`, preserving
every checked whole-referent caller path as an exact slot identity before argument
evaluation can move a carrier. `E-Call-Enter` then uses
`instantiate_call(Delta,Sigma_t,f,phi,pi,B,I,Xi,args)`, not syntactic simultaneous
substitution. Elaborated syntax retains `call f[phi](args)`, so runtime never
chooses an instantiation. The relation checks the recorded `phi`, realizes its
formal external atoms against token arguments, rejects a suspended mutable
actual token, maps formal whole-referent paths to actual referent slots,
checks `pi` against token-carried referents, preserves unrelated caller leases as
framed state, pushes one scope-owned invocation witness layer with explicit alias
authorizations, and uses `bind_call_args`
to move each owned argument into one fresh parameter slot while binding each
free argument directly. It capture-avoiding freshens every callee-local static
region atom, static lease atom, and ordinary binder. Zero-argument invocation
uses the same relation directly, without entering an argument frame.

Recursive invocation therefore cannot reopen an already active region
identity merely because the declaration text reuses one binder spelling.
`F-Call-Return-Pending` permits owned parameter slots to remain live while the
callee executes. At the pop boundary, `Ready-Call-Return` and
`E-Call-Return` require every owned parameter slot moved, exact restoration of
the entry borrow graph,
`return_witness(I,I_entry,I_formal)`, and `result_bridge`. The result bridge
types the same returned runtime value under invocation-local callee result
`psi(U)` and caller-visible result `phi(U)` before restoring the caller
static-to-runtime witness on ordinary return. This is what permits an admitted
caller-tied returned borrow without permitting callee-local atoms to escape.
L27-L30 discharge the invocation case.

`call-entry-proof.md` expands the pre-argument certificate, deterministic
instantiation, owned-argument carrier-transfer induction, return-restoration,
and call-specific renaming cases for review.

`lease_bridge(Rho,B,I,eta)` makes the source/runtime relationship explicit. A
formal `owner(x)` path resolves through a linear environment binding; a
formal `referent(x)` path resolves through an actual borrow token. Static atoms
`rho` and `b` map through `I` to runtime identities `r` and `beta`. Unrelated
caller leases remain in `B`, remain visible to conflict checks, and remain
unreachable unless an actual argument token exposes them.

### 3.10 Capability Attenuation

`E-Attenuate` requires one admitted total attenuation relation and one live
unborrowed slot containing exactly one strong
capability owner. It consumes that slot, consumes the strong resource, creates
one fresh weaker resource, records one accepted origin edge, and returns the
fresh weaker owner. L33-L34 preserve origin-chain and non-forgery claims.

### 3.11 Intrinsic Defined TPOE

Failed contract and checked-primitive transitions compute
`A=abandoned_owners(control,K)` before erasing the continuation and produce
`tpoe<contract_false,Sigma,B,I,Xi,A>` or
`tpoe<checked_failure(op,args),Sigma,B,I,Xi,A>`. L31 classifies each terminal
with an intrinsic rule that rechecks store, slot, lease-graph, witness, and
`terminal_carrier_bijection(Sigma,Xi,A)` invariants. `A` records owners held by
the erased control value or frame values. It is not cleanup work, observable
state, or resumable control. The terminal has no outgoing transition and no
ordinary continuation requirement. Its typing is not defined by predecessor
reachability. TPOE is not an expression value and is not an input to ordinary
progress.

## 4. Ordinary Progress

**Theorem Q.** If `WT(C)`, exactly one applies modulo
`fresh_step_equiv`:

1. `C` is ordinary final;
2. `C` takes one ordinary step;
3. `C` takes one step to `WT_TPOE`.

This premise intentionally excludes TPOE. Defined TPOE is a separate terminal
classification.

Progress is by cases over control and the top continuation frame. The closed
derivation checks these non-routine facts:

1. a linear variable is evaluated only through `move`, named consumption, borrow, or
   attenuation forms that read its live slot;
2. an `end_linear` or `call_return` frame cannot observe a live obligation on
   an ordinarily typed path;
3. `if_select` receives canonical `Bool` values;
4. `case_select` receives one declared runtime injection;
5. declaration admission makes every consuming, checked, borrow-access, and
   attenuation relation total on admitted typed inputs;
6. `region_end` receives a closable top lexical region on ordinary return;
7. direct borrow and reborrow premises follow from source typing and machine
   agreement;
8. invocation compatibility rejects unavailable mutable arguments before
   callee entry;
9. explicit frame typing excludes stale captured witnesses, inconsistent argument
   carriers, and wrong frame input/output types;
10. total primitive `ok` selects success or terminal TPOE;
11. fresh choices differ only by `fresh_step_equiv`.

Sequencing is not an untyped discard form: `T-Seq` requires its first
expression to produce `Unit`, matching the `E-Seq-Next` `ret(nil)` transition.
Likewise, first-core checked primitives accept and return only `Free` values;
adding a linear primitive requires a later carrier-preservation rule.

## 5. Worked Machine Traces

### 5.1 Visible Named Consumption Without Runtime Substitution

Starting from:

```text
Sigma(a)   = live(Resource[file], payload, ordinary)
Xi(ell_x)  = live(Resource[file], own[a])
eta(x)     = slot(ell_x)
```

then:

```text
<Sigma,B,I,Xi,eval(consume[release_resource] x,eta),K>
--> <Sigma[a |-> consumed(Resource[file],ordinary)],
     B,
     I,
     Xi[ell_x |-> moved(Resource[file])],
     ret(nil),
     K>
```

No intermediate universal-destructor term exists. The selected named
operation is visible in core syntax.

### 5.2 Linear Sum Movement

Starting with:

```text
Xi(ell_x) = live(Optional[Resource[file]], inject Some own[a])
eta(x)    = slot(ell_x)
```

then:

```text
<Sigma,B,I,Xi,eval(move x,eta),K>
--> <Sigma,B,I,Xi[ell_x |-> moved(Optional[Resource[file]])],
     ret(inject Some own[a]),K>
```

The machine remains closed over linear sums.

### 5.3 Branch Syntax Does Not Duplicate Owners

Starting with one slot `ell_x`, evaluation of:

```text
if true then consume[release_resource] x else consume[release_resource] x
```

pushes
`if_select(consume[release_resource] x,consume[release_resource] x,eta)`.
The frame contains source syntax and one environment reference to `ell_x`; it
does not contain two `own[a]` values. Selecting the true branch evaluates
`consume[release_resource] x` under the same environment and consumes one
slot.

### 5.4 Suspended Mutable Token Cannot Enter A Callee

If:

```text
Leases(beta_parent)       = <s,write,ell_x>
Suspended(beta_parent)    = beta_child
```

then copied `write_ref[s,beta_parent,ell_x]` remains runtime-typed but fails
`usable_write`. `instantiate_call` rejects it as a mutable actual argument.

### 5.5 Recursive Region Binder Freshening

Each `instantiate_call` alpha-freshens declaration-local binders. A recursive
function whose text contains `region rho in e` receives fresh binder atom
`rho_1` on one invocation and `rho_2` on its recursive invocation. Each
`E-Region-Enter` then chooses a fresh runtime identity and extends `I`. The
recursive call cannot collide with the caller's active region.

### 5.6 Nested TPOE Preserves Erased Frame Carriers

Suppose a source-ordered call has already evaluated one owned argument. Its
`call_args.done` field carries `own[a]` after the caller slot has moved. If a
later argument executes `check false else tpoe`, the failing transition computes:

```text
A = abandoned_owners(ret(false),check_result::call_args(...,[own[a]],...)::K)
  = {a}
```

The terminal state is `tpoe<contract_false,Sigma,B,I,Xi,{a}>`. The continuation
is erased immediately, as required by TPOE, while
`terminal_carrier_bijection(Sigma,Xi,{a})` still accounts for the live store
entry. No cleanup or continuation resumption occurs. `frame-typing-proof.md`
expands this frame-local derivation together with the linear-let and owned-call
pending-obligation cases.

## 6. Renaming Discipline

The proof keeps three distinct facts separate:

1. `binder_alpha` preserves source typing and invocation behavior;
2. `fresh_step_equiv` identifies targets differing only in fresh region,
   lease, slot, or attenuated-resource choices from one selected transition;
3. machine relations are equivariant under finite sort-preserving runtime
   renaming.

Conflating binder alpha-conversion with runtime fresh-name choice would leave
recursive invocation under-specified.

## 7. Closure Record

`theorem-assembly.md` closes the L1-L40 route matrix, L38 unique decomposition,
L39 ordinary preservation, L40 intrinsic defined-failure preservation, Theorem P,
and Theorem Q. The package split is now:

1. `source-expression-proof.md` discharges L1-L8, L12-L19, L24-L25, and L32-L36
   source-control cases;
2. `frame-typing-proof.md` discharges L9-L11, L26, L31, and returned-control
   decomposition/readiness cases;
3. `close-and-witness-proof.md` discharges L20-L23 and close-specific L37;
4. `call-entry-proof.md` discharges L27-L30 and call-specific carrier,
   witness, and preservation cases;
5. `primitive-admission-proof.md` discharges primitive totality and footprint cases
   for L8, L16, L31-L34, and L38-L40;
6. `equivariance-proof.md` discharges runtime finite-renaming cases for L36-L37;
7. `theorem-assembly.md` composes those packages into Theorem P and Theorem Q.

The current evidence tier for the narrow `lambda_K-seq` theorem is `paper-proven`.
The theorem remains intentionally narrow: concurrency, unsafe/FFI, backend lowering,
stdlib admission, compiler conformance, toolchain behavior, and whole-core Lean
mechanization are outside this proof.
