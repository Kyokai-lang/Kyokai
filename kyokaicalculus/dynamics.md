# `lambda_K-seq` Environment-And-Continuation Dynamics

**Status:** `paper-proven` formal-core dynamics  
**Gate:** K-B dynamic half closed by Gate-B paper proof  
**Depends on:** `scope.md`, `syntax-and-statics.md`

## 1. Machine Configurations

`lambda_K-seq` evaluates with an environment-and-continuation machine:

```text
C ::= <Sigma, B, I, Xi, eval(e, eta), K>
    | <Sigma, B, I, Xi, ret(w), K>
    | tpoe<q, Sigma, B, I, Xi, A>

q ::= contract_false | checked_failure(op,args)
A ::= finite multiset of abandoned runtime resource identities
```

| Component | Meaning |
| --- | --- |
| `Sigma` | Runtime resource store. It records resource liveness, payloads, capability kinds, and capability-origin facts. |
| `B` | Runtime lexical-region and borrow-lease state. Leases protect linear owner slots. |
| `I` | Runtime instantiation witness mapping active static region and lease atoms to runtime identities. |
| `Xi` | Runtime linear owner-slot store. A live slot holds exactly one arbitrary linear runtime value. |
| `eta` | Runtime environment. Unrestricted names map to `free(w)`; linear names map to `slot(ell)`. |
| `eval(e,eta)` | Evaluate source term `e` under environment `eta`. |
| `ret(w)` | Return closed runtime value `w` to the top continuation frame. |
| `K` | Continuation stack selecting one source-ordered evaluation path. |

The machine never substitutes a runtime linear value into source syntax.
Unselected branch bodies remain source expressions captured in continuation
frames. A runtime owner appears in one carrier only: one live slot, the
current returned value, or one evaluated-value field of a continuation frame.

Ordinary completion and defined contract failure are distinct:

```text
<Sigma, B, I, Xi, ret(w), halt>       ordinary value completion
tpoe<q, Sigma, B, I, Xi, A>           defined TPOE termination
```

TPOE has no outgoing transition. It is not a typed expression and it is not a
stuck ordinary configuration. The terminal state can retain live slots and
leases because no ordinary continuation observes them. `A` is a proof-facing
snapshot of owner identities that were carried only by the erased control value
or continuation frames at the failure boundary. It is not an observable source
value, not a cleanup list, and not a resumable continuation. The snapshot makes
the accepted TPOE rule explicit: linear resources can be abandoned only because
the terminating execution context has no remaining observer.

## 2. Resource Store And Linear Owner Slots

```text
Sigma ::= a |-> live(T, payload, origin)
        | a |-> consumed(T, origin)

origin ::= ordinary
         | initial
         | attenuated(parent_a, k_strong, k_weak)

Xi ::= ell |-> live(tau, w)
     | ell |-> moved(tau)
```

`Sigma` tracks concrete abstract `Resource[k]` and `Capability[k]` entries.
`Xi` tracks program-level linear values, including sums that contain those
owners. A slot tombstone remains after movement or named consumption so use after
move has no transition.

```text
store_types(Sigma)(a)       = T
slot_types(Xi)(ell)          = tau
fresh_resource(Sigma,a')     a' notin dom(Sigma)
fresh_slot(Xi,ell')          ell' notin dom(Xi)
owner_ids(nil)               = empty
owner_ids(true|false|n)      = empty
owner_ids(own[a])            = {a}
owner_ids(read_ref[...])     = empty
owner_ids(write_ref[...])    = empty
owner_ids(inject tag w)      = owner_ids(w)
regions(nil|true|false|n)    = empty
regions(own[a])              = empty
regions(read_ref[r,...])     = {r}
regions(write_ref[r,...])    = {r}
regions(inject tag w)        = regions(w)
```

`consume_op(Delta,Sigma,op,w) = Sigma'` is the total admitted runtime
relation of one named consuming primitive. `Delta |- op admitted-consuming T -> Unit`
holds only when the declaration-admission judgment has proved that the relation is
defined for every admitted well-typed `w : runtime_type(I,T)` and every matching
well-formed store. Let `A = owner_ids(w)`. It is defined only when
the admitted source signature is `T -> Unit`, `w` has runtime type
`runtime_type(I,T)`, every identity in `A` names a live store entry before the transition, every identity in `A` names a
matching consumed entry afterward, `dom(Sigma') = dom(Sigma)`, and every store
entry outside `A` is unchanged. Because this first-core primitive returns
`Unit`, it creates no new owner identity and leaves no owner identity carried
by `w` live after the slot becomes a tombstone. The relation is not derived
from the structure of `T`. There is no universal recursive destructor. A
linear sum is moved into `case` and its selected payload is explicitly handled
unless `Delta` contains an independently admitted named consuming operation
for that sum.

For the first-core whole-referent path language, path resolution is exact:

```text
resolve_slot(eta,owner(x))    = ell
  iff eta(x) = slot(ell)

resolve_slot(eta,referent(x)) = ell
  iff eta(x) = free(read_ref[r,beta,ell])
   or eta(x) = free(write_ref[r,beta,ell])
```

Later field-path extensions must replace this definition with an explicit
place-resolution relation. They cannot silently reuse whole-owner movement
for partial paths.

The pre-argument call certificate is exact:

```text
pi ::= formal_path |-> ell

materialize_call_paths(phi,eta)=pi
  iff dom(pi)=required_paths(phi)
  and for every formal_path |-> actual_path in phi:
        resolve_slot(eta,actual_path)=ell
        pi(formal_path)=ell
```

The relation runs once at call start, before any argument expression is evaluated.
It is deterministic because `phi` is checker-recorded and `resolve_slot` is a
partial function on the first-core whole-referent path language.

## 3. Environments And Continuation Frames

```text
eta ::= x |-> free(w)
      | x |-> slot(ell)

K ::= halt
    | let_bind(x,T,e,eta) :: K
    | end_linear(ell) :: K
    | seq_next(e,eta) :: K
    | if_select(e_then,e_else,eta) :: K
    | inject_value(tag) :: K
    | case_select(arms,eta) :: K
    | region_end(rho,r,I_entry) :: K
    | call_args(f,phi,pi,done,pending,eta) :: K
    | call_return(param_slots,B_entry,I_entry,I_formal,psi,phi,pi,U) :: K
    | checked_args(op,done,pending,eta) :: K
    | check_result :: K
```

`done` contains already evaluated argument values in source order. Values
inside `done` are machine carriers and count toward runtime ownership.
`end_linear(ell)` enforces that a linear local or case payload slot was moved
or consumed before ordinary scope exit.
`call_return(param_slots,B_entry,I_entry,I_formal,psi,phi,pi,U)` enforces the same
rule for owned parameters, requires the callee to restore the entry lease graph
before ordinary return, and checks that the returned runtime value has both the
invocation-local callee result type `psi(U)` and the caller-visible result type
`phi(U)`. It restores the caller's static-to-runtime witness after callee-local
and formal atoms leave scope.

Continuation frames can carry pending ordinary-exit obligations while a body is
executing. A separate return-readiness judgment checks those obligations exactly
when `ret(w)` reaches the top frame. In particular, a live `end_linear` local or
owned call parameter is valid during body evaluation and must be moved before its
ordinary return frame can step.

## 4. Runtime Borrow State

```text
B ::= <Regions, Leases, Suspended>

Regions   ::= finite stack of distinct runtime region identities
Leases    ::= beta |-> <r, read,  ell>
           | beta |-> <r, write, ell>
Suspended ::= beta_parent |-> beta_child
```

The exact helper definitions are:

```text
active(B,r)                 r occurs in Regions
fresh_region(B,r)           r notin Regions
fresh_lease(B,beta)         beta notin dom(Leases)
all_reads(B,ell)            { beta | Leases(beta) = <r,read,ell> }
all_writes(B,ell)           { beta | Leases(beta) = <r,write,ell> }
unsuspended(B,beta)         beta notin dom(Suspended)
frontier_reads(B,ell)       { beta | beta in all_reads(B,ell) and unsuspended(B,beta) }
frontier_writes(B,ell)      { beta | beta in all_writes(B,ell) and unsuspended(B,beta) }
unborrowed(B,ell)           all_reads(B,ell) = empty and all_writes(B,ell) = empty
no_writer(B,ell)            all_writes(B,ell) = empty
usable_read(B,beta,ell)     Leases(beta)=<r,read,ell> and active(B,r) and unsuspended(B,beta)
usable_write(B,beta,ell)    Leases(beta)=<r,write,ell> and active(B,r) and unsuspended(B,beta)
nested(Regions,s,r)         s occurs strictly below r in Regions
leases_at(B,r)              { beta | Leases(beta)=<r,mode,ell> }
closable(B,r)               top(Regions)=r and leases_at(B,r) intersect dom(Suspended)=empty
descends(Suspended,beta,beta')
                             beta'=beta or beta' is reachable from beta by one or more Suspended edges
same_chain(Suspended,beta,beta')
                             descends(Suspended,beta,beta') or descends(Suspended,beta',beta)
```

`no_writer` examines retained writers. It does not examine only frontier
writers. Direct shared borrowing through an owner slot is therefore rejected
while a read reborrow has suspended a mutable parent.

`WF(B,Xi)` holds exactly when:

1. every lease names an active region and a live slot;
2. each slot has zero or more frontier readers or one frontier writer, never
   both;
3. `Suspended` is a finite partial injective function;
4. every suspension edge names existing leases over the same slot;
5. every suspended parent has mode `write`;
6. every child region is strictly nested inside its parent region;
7. lexical nesting makes the suspension graph acyclic;
8. for every retained writer `beta` over slot `ell`, every other retained lease
   `beta'` over `ell` satisfies `same_chain(Suspended,beta,beta')`. An unsuspended retained
   writer therefore has no competing lease over its slot. A suspended writer can
   coexist only with the direct or transitive child chain that temporarily replaced
   its usable access.

The static-path/runtime-slot bridge is explicit:

```text
lease_bridge(Rho,B,I,eta)
```

holds exactly when `WF_I(Rho,B,I,eta)` holds: every static region atom `rho`
required by `Rho` has `region_image(I,rho)=r` active in `B`, every static lease
`b |-> <rho,mode,p>` required by `Rho` has `lease_image(I,b)=beta`,
`resolve_slot(eta,p)=ell`, and matching runtime lease
`beta |-> <r,mode,ell>` in `B`, and every static suspension edge maps through
`I` to the same runtime edge in `B`. Runtime `B` can contain additional
leases framed around the active expression by a caller. Those framed leases
remain visible to runtime conflict predicates, are not reachable through a
callee environment unless an actual token exposes them, and remain unchanged
by call instantiation and return.

`close(B,r)` is defined only when `closable(B,r)`. Let
`D = leases_at(B,r)`. Closing performs these exact changes:

1. remove every lease in `D`;
2. remove every suspension edge `beta_parent |-> beta_child` whose child is
   in `D`, thereby resuming the direct parent;
3. remove no other edge;
4. pop `r` from `Regions`.

`closable` guarantees no identity in `D` remains a parent of a live nested
child. Invariant 8 guarantees that removing a local child and resuming its direct
parent cannot reveal an unrelated competing reader or writer. Leases from other
regions remain unchanged.


## 5. Static-To-Runtime Instantiation Witness

Static region atoms and static lease atoms never double as runtime identities. The
witness is a stack of ownership layers rather than one unscoped map:

```text
I ::= W_0 :: ... :: W_n
W ::= <owner, RegionMap, LeaseMap, AliasAuth>
owner ::= root | region(rho) | call(f,invocation)
AliasAuth ::= finite set of alias_region(rho_outer,rho_local)
            | finite set of alias_lease(b_outer,b_local)

region_image(I,rho)       = unique mapped r found by static-atom lookup
lease_image(I,b)          = unique mapped beta found by static-atom lookup
push_region_layer(I,rho,r)= I :: <region(rho), {rho |-> r}, {}, {}>
push_call_layer(I,W_f)    = I :: W_f
extend_lease_top(I,b,beta)= extend top layer with fresh static atom b |-> beta
pop_region_layer(I,rho)   = remove exactly top layer owned by region(rho)
pop_call_layer(I,f,inv)   = remove exactly top layer owned by call(f,inv)
```

Every static atom occurs in exactly one layer. A layer map is functional on static
atoms. Runtime images are injective unless `AliasAuth` contains the explicit checked
equality authorization that relates one local atom to one outer atom. Alias
authorization is directional and scope-owned: a local formal view can name an outer
runtime identity, but popping the local layer never removes the outer mapping.

`WF_I(Rho,B,I,eta)` holds exactly when:

1. every active static region and lease atom required by `Rho` occurs in one layer;
2. its image names the matching active runtime region or lease in `B`;
3. each static suspension edge maps to the corresponding runtime suspension edge;
4. every repeated runtime image is justified by one `AliasAuth` relationship;
5. every alias authorization connects matching modes, referent slots, and checked
   equality relationships;
6. no local layer claims ownership of an outer static atom;
7. caller-framed runtime leases absent from `I` remain runtime-visible to conflict
   predicates and unchanged by local close.

`WF_I_terminal(B,I)` holds when every mapped runtime region remains active, every
mapped runtime lease remains present with its matching mode and slot, every repeated
runtime image has one valid checked `AliasAuth`, and each layer owns disjoint static
atoms. It does not require a current source environment.

`close_witness(I,rho)` is defined only when the top witness layer is owned by
`region(rho)`. It pops exactly that layer. It does not search by runtime image.
`return_witness(I,I_entry,I_formal)` is defined only when `I` equals `I_entry`
followed by exactly the invocation-formal call layer `I_formal`; every callee-local
region layer has already closed. It pops exactly the invocation-formal layer.

```text
result_bridge(Sigma_t,Xi_t,B,I,I_entry,psi,phi,U,w)
  iff Sigma_t; Xi_t; B |- w : runtime_type(I,psi(U))
  and Sigma_t; Xi_t; B |- w : runtime_type(I_entry,phi(U))
```

An admitted returned borrow can therefore use distinct callee-formal and
caller-visible static atoms that intentionally denote one runtime lease without
allowing local close to erase caller witness state.

## 6. Binding, Scope Exit, And Sequencing

```text
E-Literal
v in {nil,true,false} or v in IntK
----------------------------------------------------------------
<Sigma,B,I,Xi,eval(v,eta),K> --> <Sigma,B,I,Xi,ret(v),K>

E-Var-Free
eta(x) = free(w)
----------------------------------------------------------------
<Sigma,B,I,Xi,eval(x,eta),K> --> <Sigma,B,I,Xi,ret(w),K>

E-Let-Eval
----------------------------------------------------------------
<Sigma,B,I,Xi,eval(let x:T = e1 in e2,eta),K>
  --> <Sigma,B,I,Xi,eval(e1,eta),let_bind(x,T,e2,eta)::K>

E-Let-Free
T : Free
----------------------------------------------------------------
<Sigma,B,I,Xi,ret(w),let_bind(x,T,e,eta)::K>
  --> <Sigma,B,I,Xi,eval(e,eta[x |-> free(w)]),K>

E-Let-Linear
T : Linear    fresh_slot(Xi,ell)
----------------------------------------------------------------
<Sigma,B,I,Xi,ret(w),let_bind(x,T,e,eta)::K>
  --> <Sigma,B,I,Xi[ell |-> live(runtime_type(I,T),w)],eval(e,eta[x |-> slot(ell)]),
       end_linear(ell)::K>

E-End-Linear
Xi(ell) = moved(tau)
----------------------------------------------------------------
<Sigma,B,I,Xi,ret(w),end_linear(ell)::K> --> <Sigma,B,I,Xi,ret(w),K>

E-Seq-Eval
----------------------------------------------------------------
<Sigma,B,I,Xi,eval(seq e1 e2,eta),K>
  --> <Sigma,B,I,Xi,eval(e1,eta),seq_next(e2,eta)::K>

E-Seq-Next
----------------------------------------------------------------
<Sigma,B,I,Xi,ret(nil),seq_next(e,eta)::K> --> <Sigma,B,I,Xi,eval(e,eta),K>
```

There is no ordinary exit transition for `end_linear(ell)` while the slot is
live. Static exact-use typing proves that a well-typed machine never gets
stuck there.

## 7. Arbitrary Linear Movement And Named Consumption

```text
E-Move
eta(x) = slot(ell)    Xi(ell) = live(tau,w)    unborrowed(B,ell)
----------------------------------------------------------------
<Sigma,B,I,Xi,eval(move x,eta),K>
  --> <Sigma,B,I,Xi[ell |-> moved(tau)],ret(w),K>

E-Consume
eta(x) = slot(ell)    Xi(ell) = live(tau,w)    unborrowed(B,ell)
Delta |- op admitted-consuming T -> Unit
runtime_type(I,T)=tau    consume_op(Delta,Sigma,op,w) = Sigma'
----------------------------------------------------------------
<Sigma,B,I,Xi,eval(consume[op] x,eta),K>
  --> <Sigma',B,I,Xi[ell |-> moved(tau)],ret(nil),K>
```

`E-Move` applies to every linear `T`, including
`Sum[Some:Resource[file],None:Unit]`. `E-Consume` applies only to the exact
named operation recorded in `Delta`. It never supplies a recursive fallback
for sums, records, or any other composite.

## 8. Lexical Regions And Borrowing

`E-Region-Enter` chooses a fresh runtime region identity and records the
static-to-runtime relationship explicitly. Borrow-producing forms contain one
static region atom and one static lease atom introduced by elaboration. The
runtime mints the corresponding lease identity and extends `I`; it never
rewrites static atoms into runtime syntax.

```text
E-Region-Enter
fresh_region(B,r)    rho notin dom_static_regions(I)
----------------------------------------------------------------
<Sigma,B,I,Xi,eval(region rho in e,eta),K>
  --> <Sigma,push(B,r),push_region_layer(I,rho,r),Xi,eval(e,eta),
       region_end(rho,r,I)::K>

E-Region-Exit
closable(B,r)    r notin regions(w)    close_witness(I,rho)=I_entry
----------------------------------------------------------------
<Sigma,B,I,Xi,ret(w),region_end(rho,r,I_entry)::K>
  --> <Sigma,close(B,r),I_entry,Xi,ret(w),K>

E-Borrow
eta(x)=slot(ell)    Xi(ell)=live(tau,w)    region_image(I,rho)=r
no_writer(B,ell)    b notin dom_static_leases(I)    fresh_lease(B,beta)
----------------------------------------------------------------
<Sigma,B,I,Xi,eval(borrow[rho,b] x,eta),K>
  --> <Sigma,add_read(B,beta,r,ell),extend_lease_top(I,b,beta),Xi,
       ret(read_ref[r,beta,ell]),K>

E-MutBorrow
eta(x)=slot(ell)    Xi(ell)=live(tau,w)    region_image(I,rho)=r
unborrowed(B,ell)   b notin dom_static_leases(I)    fresh_lease(B,beta)
----------------------------------------------------------------
<Sigma,B,I,Xi,eval(mut_borrow[rho,b] x,eta),K>
  --> <Sigma,add_write(B,beta,r,ell),extend_lease_top(I,b,beta),Xi,
       ret(write_ref[r,beta,ell]),K>

E-Reborrow
eta(x)=free(write_ref[s,beta,ell])    region_image(I,rho)=r
usable_write(B,beta,ell)              c notin dom_static_leases(I)
fresh_lease(B,beta')                  nested(Regions,s,r)
----------------------------------------------------------------
<Sigma,B,I,Xi,eval(reborrow[rho,c] x,eta),K>
  --> <Sigma,reborrow_write(B,beta,beta',r,ell),extend_lease_top(I,c,beta'),Xi,
       ret(write_ref[r,beta',ell]),K>

E-Read-Reborrow
eta(x)=free(write_ref[s,beta,ell])    region_image(I,rho)=r
usable_write(B,beta,ell)              c notin dom_static_leases(I)
fresh_lease(B,beta')                  nested(Regions,s,r)
----------------------------------------------------------------
<Sigma,B,I,Xi,eval(read_reborrow[rho,c] x,eta),K>
  --> <Sigma,reborrow_read(B,beta,beta',r,ell),extend_lease_top(I,c,beta'),Xi,
       ret(read_ref[r,beta',ell]),K>
```

`add_read` and `add_write` enforce the direct-borrow predicates above.
`reborrow_write` and `reborrow_read` atomically suspend the parent and add the
fresh nested child. A copied parent mutable token stays typed but cannot
satisfy `usable_write` while suspended.

## 9. Borrow Access Through Usable Tokens

Lifecycle rules alone do not establish access safety. The first core therefore models
named read and write access through borrow tokens. Declaration admission proves each
runtime relation total on admitted typed inputs and proves that it preserves `Sigma`,
`Xi`, `B`, and `I` except for the declared payload observation or payload mutation.
Neither relation changes owner carriers, lease topology, or capability authority.

```text
E-Read-Access-Read
eta(x)=free(read_ref[r,beta,ell])    usable_read(B,beta,ell)
read_access_op(Delta,Sigma,Xi,op,ell)=w
----------------------------------------------------------------
<Sigma,B,I,Xi,eval(read_access[op] x,eta),K>
  --> <Sigma,B,I,Xi,ret(w),K>

E-Read-Access-Write
eta(x)=free(write_ref[r,beta,ell])    usable_write(B,beta,ell)
read_access_op(Delta,Sigma,Xi,op,ell)=w
----------------------------------------------------------------
<Sigma,B,I,Xi,eval(read_access[op] x,eta),K>
  --> <Sigma,B,I,Xi,ret(w),K>

E-Write-Access
eta(x)=free(write_ref[r,beta,ell])    usable_write(B,beta,ell)
write_access_op(Delta,Sigma,Xi,op,ell)=<Sigma',Xi'>
----------------------------------------------------------------
<Sigma,B,I,Xi,eval(write_access[op] x,eta),K>
  --> <Sigma',B,I,Xi',ret(nil),K>
```

`write_access_op` can update the represented payload of the protected referent only
under its admitted contract. It preserves the runtime type of `ell`, resource-owner
carrier bijection, resource liveness unless the admitted access contract explicitly
routes a different operation through a later extension, and every lease fact. Named
consumption remains a separate owner-consuming node.

## 10. Conditions, Sums, And Case Selection

```text
E-If-Eval
----------------------------------------------------------------
<Sigma,B,I,Xi,eval(if c then e1 else e2,eta),K>
  --> <Sigma,B,I,Xi,eval(c,eta),if_select(e1,e2,eta)::K>

E-If-True
----------------------------------------------------------------
<Sigma,B,I,Xi,ret(true),if_select(e1,e2,eta)::K>
  --> <Sigma,B,I,Xi,eval(e1,eta),K>

E-If-False
----------------------------------------------------------------
<Sigma,B,I,Xi,ret(false),if_select(e1,e2,eta)::K>
  --> <Sigma,B,I,Xi,eval(e2,eta),K>

E-Inject-Eval
----------------------------------------------------------------
<Sigma,B,I,Xi,eval(inject tag e,eta),K>
  --> <Sigma,B,I,Xi,eval(e,eta),inject_value(tag)::K>

E-Inject-Return
----------------------------------------------------------------
<Sigma,B,I,Xi,ret(w),inject_value(tag)::K>
  --> <Sigma,B,I,Xi,ret(inject tag w),K>

E-Case-Eval
----------------------------------------------------------------
<Sigma,B,I,Xi,eval(case e of arms,eta),K>
  --> <Sigma,B,I,Xi,eval(e,eta),case_select(arms,eta)::K>
```

Selected case payload binding uses the same universe-sensitive operation as
`let`:

```text
T : Free
----------------------------------------------------------------
bind_payload(I,Xi,eta,x,T,w,K)=<Xi,eta[x |-> free(w)],K>

T : Linear    fresh_slot(Xi,ell)
----------------------------------------------------------------
bind_payload(I,Xi,eta,x,T,w,K)=
  <Xi[ell |-> live(runtime_type(I,T),w)],eta[x |-> slot(ell)],end_linear(ell)::K>
```

A free payload extends `eta` directly. A linear payload allocates one fresh runtime-
typed slot and pushes `end_linear(ell)` before the surrounding continuation.

```text
E-Case-Select
arms(tag) = x:T => e    bind_payload(I,Xi,eta,x,T,w,K) = <Xi',eta',K'>
----------------------------------------------------------------
<Sigma,B,I,Xi,ret(inject tag w),case_select(arms,eta)::K>
  --> <Sigma,B,I,Xi',eval(e,eta'),K'>
```

Unselected arms remain syntax inside the discarded frame. They never contain
runtime owners.

## 11. Calls And Explicit Invocation Instantiation

Argument-evaluation frames preserve source order and retain the elaborated
instantiation witness `phi`:

```text
E-Call-Zero
materialize_call_paths(phi,eta)=pi
instantiate_call(Delta,store_types(Sigma),f,phi,pi,B,I,Xi,[]) =
  <Xi',I_f,I_formal,eta_f,e_f',param_slots,psi,phi(U)>
----------------------------------------------------------------
<Sigma,B,I,Xi,eval(call f[phi](),eta),K>
  --> <Sigma,B,I_f,Xi',eval(e_f',eta_f),
       call_return(param_slots,B,I,I_formal,psi,phi,pi,U)::K>

E-Call-Start
n >= 1    materialize_call_paths(phi,eta)=pi
----------------------------------------------------------------
<Sigma,B,I,Xi,eval(call f[phi](e1,...,en),eta),K>
  --> <Sigma,B,I,Xi,eval(e1,eta),call_args(f,phi,pi,[],[e2,...,en],eta)::K>

E-Call-Next
----------------------------------------------------------------
<Sigma,B,I,Xi,ret(w),call_args(f,phi,pi,done,e::pending,eta)::K>
  --> <Sigma,B,I,Xi,eval(e,eta),call_args(f,phi,pi,done ++ [w],pending,eta)::K>

E-Call-Enter
instantiate_call(Delta,store_types(Sigma),f,phi,pi,B,I,Xi,done ++ [w]) =
  <Xi',I_f,I_formal,eta_f,e_f',param_slots,psi,phi(U)>
----------------------------------------------------------------
<Sigma,B,I,Xi,ret(w),call_args(f,phi,pi,done,[],eta)::K>
  --> <Sigma,B,I_f,Xi',eval(e_f',eta_f),
       call_return(param_slots,B,I,I_formal,psi,phi,pi,U)::K>

E-Call-Return
for every ell in param_slots: Xi(ell) = moved(tau_ell)    B = B_entry
return_witness(I,I_entry,I_formal)
result_bridge(store_types(Sigma),slot_types(Xi),B,I,I_entry,psi,phi,U,w)
----------------------------------------------------------------
<Sigma,B,I,Xi,ret(w),call_return(param_slots,B_entry,I_entry,I_formal,psi,phi,pi,U)::K>
  --> <Sigma,B,I_entry,Xi,ret(w),K>
```

Runtime does not solve or choose `phi`. Typed elaboration records `phi` in the
core call. Invocation verifies and realizes that witness through the following
deterministic relations.

```text
bind_call_args(Sigma_t,B,I_f,psi,Xi,[],[],eta_empty,[]) =
  <Xi,eta_empty,[]>

Sigma_t; slot_types(Xi); B |- w : runtime_type(I_f,psi(T))
T : Free
bind_call_args(Sigma_t,B,I_f,psi,Xi,ws,formals,eta[x |-> free(w)],slots) =
  <Xi',eta',slots'>
----------------------------------------------------------------
bind_call_args(Sigma_t,B,I_f,psi,Xi,w::ws,(x:T)::formals,eta,slots) =
  <Xi',eta',slots'>

Sigma_t; slot_types(Xi); B |- w : runtime_type(I_f,psi(T))
T : Linear    fresh_slot(Xi,ell)
bind_call_args(Sigma_t,B,I_f,psi,Xi[ell |-> live(runtime_type(I_f,psi(T)),w)],ws,
               formals,eta[x |-> slot(ell)],slots ++ [ell]) = <Xi',eta',slots'>
----------------------------------------------------------------
bind_call_args(Sigma_t,B,I_f,psi,Xi,w::ws,(x:T)::formals,eta,slots) =
  <Xi',eta',slots'>
```

The relation is source ordered and exact. For a `Free` formal it leaves `Xi`
unchanged and adds one `free(w)` environment binding. For a `Linear` formal it
adds one fresh slot containing the same runtime carrier `w`, adds one
`slot(ell)` environment binding, and appends exactly `ell` to `param_slots`.
The `E-Call-Enter` transition discards the completed argument frame in the same
step that those fresh parameter slots acquire the linear argument carriers.
Therefore no linear carrier exists both in the discarded frame and in a
parameter slot after call entry. Existing slots in `Xi` remain unchanged.

`phi` records the selected declaration instantiation, caller-visible atom
relationships, source argument positions, and whole-referent source paths.
`materialize_call_paths(phi,eta)=pi` runs before any argument expression is
evaluated. It resolves every referenced caller path through the caller environment and
records the resulting slot identity in `pi`. This is checked evidence, not a second
inference pass. Argument movement can tombstone the caller slot afterward without
losing the path-to-slot fact required at callee entry.

`alpha_freshen(e_f,phi,I)=<e_f',psi>` holds exactly when one injective,
sort-preserving renaming `nu` maps every declaration-local region atom, lease atom,
and ordinary binder to an atom fresh for the active witness domains and function
body; `nu` fixes caller-external atoms; `e_f'=nu(e_f)`; and `psi=nu(phi)` for the
invocation-local view. Freshening is capture avoiding and deterministic modulo
binder alpha-equivalence.

`realize_call(psi,args,B)=I_formal` is the least finite scope-owned call layer
satisfying these exact clauses:

```text
args_i = read_ref[r,beta,ell]
formal_i = Borrow[rho,b,T]
usable_read(B,beta,ell)
----------------------------------------------------------------
RegionMap(rho)=r    LeaseMap(b)=beta

args_i = write_ref[r,beta,ell]
formal_i = MutBorrow[rho,b,T]
usable_write(B,beta,ell)
----------------------------------------------------------------
RegionMap(rho)=r    LeaseMap(b)=beta
```

Its domain equals the external region and lease atoms required by `psi`; it has no
extra mapping. Repeated occurrences of one static atom must yield one runtime image.
Distinct static atoms can yield one repeated runtime image only when `psi.Equalities`
authorizes that relationship; the call layer records the corresponding directional
`AliasAuth`. Every relationship in `psi.Distinctness` must yield distinct runtime
images and distinct certified slots.

Whole-referent path checking is a separate total predicate on the completed argument
vector:

```text
verify_call_paths(phi,pi,args)
  iff dom(pi)=required_paths(phi)
  and for every formal referent path associated with argument position i:
        args_i = read_ref[r,beta,ell] or write_ref[r,beta,ell]
        pi(formal_path)=ell
  and for every declared path equality or distinctness relationship:
        the corresponding pi images satisfy that relationship
```

A mode mismatch, missing atom, inconsistent repeated mapping, unauthorized repeated
runtime image, unavailable lease, missing path certificate, token/certificate slot
mismatch, or failed distinctness requirement leaves realization undefined.

`instantiate_call(Delta,Sigma_t,f,phi,pi,B,I,Xi,args)` is defined exactly when:

1. `Delta(f) = forall Phi. fn (x_1:T_1,...,x_n:T_n) -> U { e_f }` and the
   explicit `phi` is one checked instantiation of `Phi`;
2. `alpha_freshen(e_f,phi,I) = <e_f',psi>` capture-avoiding freshens every
   callee-local static region atom, static lease atom, and ordinary local
   binder for this invocation;
3. `realize_call(psi,args,B) = I_formal` deterministically maps the formal
   external static region and lease atoms named by `psi` to runtime identities
   already carried by the checked borrow-token arguments;
4. `I_f = push_call_layer(I,I_formal)`, where `I_formal` is one scope-owned call layer, static domains are disjoint after freshening, and repeated runtime images have explicit checked alias authorization;
5. every argument value has exactly `runtime_type(I_f,psi(T_i))`;
6. each immutable token argument satisfies `usable_read`, and each mutable
   token argument satisfies `usable_write`;
7. token aliasing satisfies the declaration's explicit equality or
   distinctness relationships; absent declared distinctness, copied tokens
   naming one lease remain one accepted access;
8. `verify_call_paths(phi,pi,args)` holds: every formal source path is present in
   `pi`, `pi` records the exact caller slot materialized before argument evaluation,
   token-carried referent slots agree with that certificate, and equality or
   distinctness relationships hold with no implicit field-path rule;
9. `bind_call_args(Sigma_t,B,I_f,psi,Xi,args,formals,eta_empty,[])`
   transfers every linear argument carrier into exactly one fresh parameter
   slot, binds every `Free` argument directly, and returns `param_slots` as
   exactly those fresh linear-parameter slots;
10. unrelated caller leases remain in `B` unchanged and runtime-visible;
11. the callee body has invocation-local result type `psi(U)`, the caller sees
    exactly `phi(U)`, and `result_bridge` checks both views against the same
    returned runtime value before `I_entry` is restored; callee-local atoms do
    not escape.

`realize_call` verifies a checker-recorded witness. It does not search for an
instantiation, infer one from returned values, or choose between alternatives.
Recursive calls receive fresh callee-local static atoms, and later region entry
mints fresh runtime identities for those atoms. `call_return` requires exact
restoration of `B_entry`, discharges every owned parameter slot, and restores
`I_entry`.

## 12. Checks And Checked Primitives

```text
E-Check-Eval
----------------------------------------------------------------
<Sigma,B,I,Xi,eval(check e else tpoe,eta),K>
  --> <Sigma,B,I,Xi,eval(e,eta),check_result::K>

E-Check-True
----------------------------------------------------------------
<Sigma,B,I,Xi,ret(true),check_result::K> --> <Sigma,B,I,Xi,ret(nil),K>

E-Check-False
abandoned_owners(ret(false),check_result::K)=A
----------------------------------------------------------------
<Sigma,B,I,Xi,ret(false),check_result::K> --> tpoe<contract_false,Sigma,B,I,Xi,A>
```

Checked primitive arguments use `checked_args` frames with the same
left-to-right shape as calls. The zero-argument case is explicit. A declaration enters `Delta` only under
`Delta |- op admitted-checked (T_1,...,T_n) -> U`, which proves that `ok(op,args)`
is total on admitted well-typed arguments and that `result(op,args)` is total whenever
`ok(op,args)` holds. When all arguments are values, that admitted semantic function
selects exactly one transition. First-core checked primitives accept and return only `Free`
values, so `result(op,args)` cannot duplicate, discard, or forge a linear
carrier:

```text
E-Checked-Zero-Ok
ok(op,[])
----------------------------------------------------------------
<Sigma,B,I,Xi,eval(checked[op](),eta),K>
  --> <Sigma,B,I,Xi,ret(result(op,[])),K>

E-Checked-Zero-Fail
not ok(op,[])    abandoned_owners(eval(checked[op](),eta),K)=A
----------------------------------------------------------------
<Sigma,B,I,Xi,eval(checked[op](),eta),K>
  --> tpoe<checked_failure(op,[]),Sigma,B,I,Xi,A>

E-Checked-Start
n >= 1
----------------------------------------------------------------
<Sigma,B,I,Xi,eval(checked[op](e1,...,en),eta),K>
  --> <Sigma,B,I,Xi,eval(e1,eta),checked_args(op,[],[e2,...,en],eta)::K>

E-Checked-Next
----------------------------------------------------------------
<Sigma,B,I,Xi,ret(w),checked_args(op,done,e::pending,eta)::K>
  --> <Sigma,B,I,Xi,eval(e,eta),checked_args(op,done ++ [w],pending,eta)::K>

E-Checked-Ok
args = done ++ [last]    ok(op,args)
----------------------------------------------------------------
<Sigma,B,I,Xi,ret(last),checked_args(op,done,[],eta)::K>
  --> <Sigma,B,I,Xi,ret(result(op,args)),K>

E-Checked-Fail
args = done ++ [last]    not ok(op,args)
abandoned_owners(ret(last),checked_args(op,done,[],eta)::K)=A
----------------------------------------------------------------
<Sigma,B,I,Xi,ret(last),checked_args(op,done,[],eta)::K>
  --> tpoe<checked_failure(op,args),Sigma,B,I,Xi,A>
```

The accepted primitive contract defines representability, divisor, shift,
narrowing, and bounds predicates. Backend lowering cannot inherit host-C
undefined behavior.

## 13. Capability Attenuation

```text
E-Attenuate
eta(x)=slot(ell)    Xi(ell)=live(Capability[k_strong],own[a])
unborrowed(B,ell)   Sigma(a)=live(Capability[k_strong],payload,origin)
Delta |- admitted-attenuation k_strong -> k_weak    k_weak <= k_strong
fresh_resource(Sigma,a')
attenuate_payload(Delta,payload,k_weak)=payload'
----------------------------------------------------------------
<Sigma,B,I,Xi,eval(attenuate x as k_weak,eta),K>
  --> <Sigma[a |-> consumed(Capability[k_strong],origin),
                a' |-> live(Capability[k_weak],
                            payload',
                            attenuated(a,k_strong,k_weak))],
       B,
       I,
       Xi[ell |-> moved(Capability[k_strong])],
       ret(own[a']),
       K>
```

Attenuation consumes the strong owner slot and creates one fresh weaker
resource owner. No other transition creates capability authority.

## 14. Intrinsic Configuration And Frame Typing

Machine typing is an inference system, not a shape checklist. It uses these judgments:

```text
Delta |- Sigma ok
Delta; Sigma_t; B |- Xi ok
Delta; Sigma_t; Xi_t; B; I |- eta agrees Gamma_f; Gamma_l
Delta; Sigma_t; Xi_t; B; I |- K : tau_in => tau_out
Delta; Sigma_t; Xi_t; B; I |- ready(w,K)
Delta |- <Sigma,B,I,Xi,control,K> : tau_out
Delta |- tpoe<q,Sigma,B,I,Xi,A> ok
```

`Delta |- Sigma ok` requires matching store types and admitted capability origins.
`Delta; Sigma_t; B |- Xi ok` requires every live `ell |-> live(tau,w)` to satisfy
`Sigma_t; slot_types(Xi); B |- w : tau`; moved tombstones retain their runtime type.
Every slot type is a runtime `tau`. Source `T` is converted only through
`runtime_type(I,T)` at binding boundaries.

Environment agreement is intrinsic:

```text
A-Free
eta(x)=free(w)    Sigma_t; Xi_t; B |- w : runtime_type(I,T)
----------------------------------------------------------------
Delta; Sigma_t; Xi_t; B; I |- eta agrees x:T in Gamma_f

A-Linear
eta(x)=slot(ell)    Xi(ell)=live(runtime_type(I,T),w)
----------------------------------------------------------------
Delta; Sigma_t; Xi_t; B; I |- eta agrees x:T in Gamma_l
```

Required linear source names map to distinct slots. Additional captured mappings are
allowed only as inert environment extensions: an additional linear mapping can name a
moved tombstone after an earlier source-ordered effect, but the typed current
expression cannot name it. `lease_bridge(Rho,B,I,eta)` is required for the current
source certificate.

Each continuation constructor has an explicit frame rule. `K : tau_in => tau_out`
means that if current control returns `tau_in`, then the stack ultimately returns
`tau_out` or reaches intrinsic TPOE.

```text
F-Halt
----------------------------------------
Delta; Sigma_t; Xi_t; B; I |- halt : tau => tau

F-Let-Free
T : Free
Delta; Rho; Gamma_f,x:T; Gamma_l |- e : U => Rho'; Gamma_l'
Delta; Sigma_t; Xi_t; B; I |- eta agrees Gamma_f; Gamma_l
Delta; Sigma_t; Xi_t; B; I |- K : runtime_type(I,U) => tau_out
----------------------------------------------------------------
Delta; Sigma_t; Xi_t; B; I |- let_bind(x,T,e,eta)::K
  : runtime_type(I,T) => tau_out

F-Let-Linear
T : Linear
Delta; Rho; Gamma_f; Gamma_l,x:T |- e : U => Rho'; Gamma_l'
Delta; Sigma_t; Xi_t; B; I |- eta agrees Gamma_f; Gamma_l
Delta; Sigma_t; Xi_t; B; I |- K : runtime_type(I,U) => tau_out
----------------------------------------------------------------
Delta; Sigma_t; Xi_t; B; I |- let_bind(x,T,e,eta)::K
  : runtime_type(I,T) => tau_out

F-End-Linear-Pending
local_obligation(Xi,ell,tau_local)
Delta; Sigma_t; Xi_t; B; I |- K : tau => tau_out
----------------------------------------------------------------
Delta; Sigma_t; Xi_t; B; I |- end_linear(ell)::K : tau => tau_out

F-Seq
Delta; Rho; Gamma_f; Gamma_l |- e : T => Rho'; Gamma_l'
Delta; Sigma_t; Xi_t; B; I |- eta agrees Gamma_f; Gamma_l
Delta; Sigma_t; Xi_t; B; I |- K : runtime_type(I,T) => tau_out
----------------------------------------------------------------
Delta; Sigma_t; Xi_t; B; I |- seq_next(e,eta)::K : Unit => tau_out

F-If
both captured branches type from the same post-condition state to T
Delta; Sigma_t; Xi_t; B; I |- eta agrees Gamma_f; Gamma_l
Delta; Sigma_t; Xi_t; B; I |- K : runtime_type(I,T) => tau_out
----------------------------------------------------------------
Delta; Sigma_t; Xi_t; B; I |- if_select(e1,e2,eta)::K : Bool => tau_out

F-Case
all captured arms type from the selected-scrutinee post-state to U
Delta; Sigma_t; Xi_t; B; I |- eta agrees Gamma_f; Gamma_l
Delta; Sigma_t; Xi_t; B; I |- K : runtime_type(I,U) => tau_out
----------------------------------------------------------------
Delta; Sigma_t; Xi_t; B; I |- case_select(arms,eta)::K
  : SumRT[tag_i:tau_i] => tau_out
```

The remaining constructors are clauses of the same inductive judgment, not prose
side conditions:

```text
F-Inject
Delta; Sigma_t; Xi_t; B; I |- K : SumRT[tag_j:tau_j] => tau_out
----------------------------------------------------------------
Delta; Sigma_t; Xi_t; B; I |- inject_value(tag_i)::K : tau_i => tau_out

F-Region-End
closable(B,r)    r notin regions(tau)    close_witness(I,rho)=I_entry
Delta; Sigma_t; Xi_t; close(B,r); I_entry |- K : tau => tau_out
----------------------------------------------------------------
Delta; Sigma_t; Xi_t; B; I |- region_end(rho,r,I_entry)::K : tau => tau_out

F-Call-Args
materialize_call_paths(phi,eta)=pi
typed_done(Sigma_t,Xi_t,B,I,done,Ts_done)
typed_pending(Delta,Sigma_t,Xi_t,B,I,Rho,Gamma_f,Gamma_l,eta,pending,Ts_pending,Rho_out,Gamma_l_out)
carriers_once(done)
call_args_residual(Delta,f,phi,pi,Ts_done,T_current,Ts_pending,U)
Delta; Sigma_t; Xi_t; B; I |- K : runtime_type(I,phi(U)) => tau_out
----------------------------------------------------------------
Delta; Sigma_t; Xi_t; B; I |- call_args(f,phi,pi,done,pending,eta)::K
  : runtime_type(I,T_current) => tau_out

F-Call-Return-Pending
parameter_obligations(Xi,param_slots)    B=B_entry
return_witness(I,I_entry,I_formal)
for every w with Sigma_t; Xi_t; B |- w : runtime_type(I,psi(U)):
  result_bridge(Sigma_t,Xi_t,B,I,I_entry,psi,phi,U,w)
Delta; Sigma_t; Xi_t; B; I_entry |- K : runtime_type(I_entry,phi(U)) => tau_out
----------------------------------------------------------------
Delta; Sigma_t; Xi_t; B; I |- call_return(param_slots,B_entry,I_entry,I_formal,psi,phi,pi,U)::K
  : runtime_type(I,psi(U)) => tau_out

F-Checked-Args
typed_done(Sigma_t,Xi_t,B,I,done,Ts_done)
typed_pending(Delta,Sigma_t,Xi_t,B,I,Rho,Gamma_f,Gamma_l,eta,pending,Ts_pending,Rho_out,Gamma_l_out)
checked_args_residual(Delta,op,Ts_done,T_current,Ts_pending,U)
Delta; Sigma_t; Xi_t; B; I |- K : runtime_type(I,U) => tau_out
----------------------------------------------------------------
Delta; Sigma_t; Xi_t; B; I |- checked_args(op,done,pending,eta)::K
  : runtime_type(I,T_current) => tau_out

F-Check
Delta; Sigma_t; Xi_t; B; I |- K : Unit => tau_out
----------------------------------------------------------------
Delta; Sigma_t; Xi_t; B; I |- check_result::K : Bool => tau_out
```

The helpers above are inductive relations with these exact clauses:

```text
local_obligation(Xi,ell,tau)
  iff Xi(ell)=live(tau,w) for one w or Xi(ell)=moved(tau)

parameter_obligations(Xi,[])
parameter_obligations(Xi,ell::ells)
  iff local_obligation(Xi,ell,tau) and parameter_obligations(Xi,ells)
      and ell notin ells

all_moved(Xi,[])
all_moved(Xi,ell::ells)
  iff Xi(ell)=moved(tau) and all_moved(Xi,ells) and ell notin ells

typed_done(Sigma_t,Xi_t,B,I,[],[])
typed_done(Sigma_t,Xi_t,B,I,w::ws,T::Ts)
  iff Sigma_t;Xi_t;B |- w : runtime_type(I,T)
      and typed_done(Sigma_t,Xi_t,B,I,ws,Ts)

typed_pending(Delta,Sigma_t,Xi_t,B,I,Rho,Gamma_f,Gamma_l,eta,[],[],Rho,Gamma_l)
typed_pending(Delta,Sigma_t,Xi_t,B,I,Rho,Gamma_f,Gamma_l,eta,e::es,T::Ts,Rho_out,Gamma_l_out)
  iff Delta;Rho;Gamma_f;Gamma_l |- e : T => Rho_1;Gamma_l1
      and Delta;Sigma_t;Xi_t;B;I |- eta agrees Gamma_f;Gamma_l
      and lease_bridge(Rho,B,I,eta)
      and typed_pending(Delta,Sigma_t,Xi_t,B,I,Rho_1,Gamma_f,Gamma_l1,eta,es,Ts,Rho_out,Gamma_l_out)

call_args_residual(Delta,f,phi,pi,Ts_done,T_current,Ts_pending,U)
  iff Delta(f)=forall Phi. fn (x_1:T_1,...,x_n:T_n)->U {e_f}
      and phi instantiates Phi
      and phi([T_1,...,T_n])=Ts_done ++ [T_current] ++ Ts_pending
      and dom(pi)=required_paths(phi)

checked_args_residual(Delta,op,Ts_done,T_current,Ts_pending,U)
  iff Delta |- op admitted-checked (Ts_done ++ [T_current] ++ Ts_pending) -> U

carriers_once(done)
  iff the owner identities in done are pairwise disjoint
```

`F-Call-Args` uses one `T_current` selected by `call_args_residual` and
`F-Checked-Args` uses one `T_current` selected by `checked_args_residual`. The
rules apply when `pending` is empty as well as when more source expressions
remain: the current `ret(w)` supplies the final value before `E-Call-Enter`,
`E-Checked-Ok`, or `E-Checked-Fail`. Zero-argument calls and checked primitives
use their explicit zero-argument entry rules and never create an argument frame.

`local_obligation` and `parameter_obligations` deliberately permit live slots while
a body executes. They do not permit ordinary scope exit. Return readiness below
requires the corresponding tombstones exactly when the return reaches the frame.

Return readiness is another inductive judgment over the current top frame:

```text
Ready-Halt
----------------------------------------
Delta; Sigma_t; Xi_t; B; I |- ready(w,halt)

Ready-Let-Free
T : Free
----------------------------------------
Delta; Sigma_t; Xi_t; B; I |- ready(w,let_bind(x,T,e,eta)::K)

Ready-Let-Linear
T : Linear    fresh_slot(Xi,ell)
----------------------------------------
Delta; Sigma_t; Xi_t; B; I |- ready(w,let_bind(x,T,e,eta)::K)

Ready-End-Linear
Xi(ell)=moved(tau_local)
----------------------------------------
Delta; Sigma_t; Xi_t; B; I |- ready(w,end_linear(ell)::K)

Ready-Seq
w=nil
----------------------------------------
Delta; Sigma_t; Xi_t; B; I |- ready(w,seq_next(e,eta)::K)

Ready-If
w=true or w=false
----------------------------------------
Delta; Sigma_t; Xi_t; B; I |- ready(w,if_select(e1,e2,eta)::K)

Ready-Inject
----------------------------------------
Delta; Sigma_t; Xi_t; B; I |- ready(w,inject_value(tag)::K)

Ready-Case
w=inject tag payload and arms(tag) exists
----------------------------------------
Delta; Sigma_t; Xi_t; B; I |- ready(w,case_select(arms,eta)::K)

Ready-Region-End
closable(B,r)    r notin regions(w)    close_witness(I,rho)=I_entry
----------------------------------------
Delta; Sigma_t; Xi_t; B; I |- ready(w,region_end(rho,r,I_entry)::K)

Ready-Call-Args-Next
pending=e::pending_tail
----------------------------------------
Delta; Sigma_t; Xi_t; B; I |- ready(w,call_args(f,phi,pi,done,pending,eta)::K)

Ready-Call-Args-Enter
pending=[]
instantiate_call(Delta,Sigma_t,f,phi,pi,B,I,Xi,done++[w]) is defined
----------------------------------------
Delta; Sigma_t; Xi_t; B; I |- ready(w,call_args(f,phi,pi,done,[],eta)::K)

Ready-Call-Return
all_moved(Xi,param_slots)    B=B_entry
return_witness(I,I_entry,I_formal)
result_bridge(Sigma_t,Xi_t,B,I,I_entry,psi,phi,U,w)
----------------------------------------
Delta; Sigma_t; Xi_t; B; I |- ready(w,call_return(param_slots,B_entry,I_entry,I_formal,psi,phi,pi,U)::K)

Ready-Checked-Args-Next
pending=e::pending_tail
----------------------------------------
Delta; Sigma_t; Xi_t; B; I |- ready(w,checked_args(op,done,pending,eta)::K)

Ready-Checked-Args-Done
pending=[]    args=done++[w]    ok(op,args) or not ok(op,args)
----------------------------------------
Delta; Sigma_t; Xi_t; B; I |- ready(w,checked_args(op,done,[],eta)::K)

Ready-Check
w=true or w=false
----------------------------------------
Delta; Sigma_t; Xi_t; B; I |- ready(w,check_result::K)
```

Frame typing says a stack can eventually consume a value of the input type.
Readiness says this particular returned runtime value and current machine state
satisfy the top frame's immediate transition premises.

`bind_payload`, `bind_call_args`, and frame transitions preserve these judgments. Their
proof obligations are explicit parts of L25-L29 and L38-L40.

An ordinary configuration is well typed only by one of these rules:

```text
WT-Eval
Delta; Rho; Gamma_f; Gamma_l |- e : T => Rho'; Gamma_l'
Delta; Sigma_t; Xi_t; B; I |- eta agrees Gamma_f; Gamma_l
lease_bridge(Rho,B,I,eta)    Delta; Sigma_t; Xi_t; B; I |- K : runtime_type(I,T) => tau_out
machine_invariants(Sigma,B,I,Xi,eval(e,eta),K)
----------------------------------------------------------------
Delta |- <Sigma,B,I,Xi,eval(e,eta),K> : tau_out

WT-Ret
Sigma_t; Xi_t; B |- w : tau
Delta; Sigma_t; Xi_t; B; I |- K : tau => tau_out
Delta; Sigma_t; Xi_t; B; I |- ready(w,K)
machine_invariants(Sigma,B,I,Xi,ret(w),K)
----------------------------------------------------------------
Delta |- <Sigma,B,I,Xi,ret(w),K> : tau_out
```

Carrier extraction is structural and total on machine syntax:

```text
frame_values(halt)                                      = []
frame_values(let_bind(...)::K)                          = frame_values(K)
frame_values(end_linear(...)::K)                        = frame_values(K)
frame_values(seq_next(...)::K)                          = frame_values(K)
frame_values(if_select(...)::K)                         = frame_values(K)
frame_values(inject_value(...)::K)                      = frame_values(K)
frame_values(case_select(...)::K)                       = frame_values(K)
frame_values(region_end(...)::K)                        = frame_values(K)
frame_values(call_args(...,done,... )::K)               = done ++ frame_values(K)
frame_values(call_return(...)::K)                       = frame_values(K)
frame_values(checked_args(...,done,... )::K)            = done ++ frame_values(K)
frame_values(check_result::K)                           = frame_values(K)

control_values(eval(e,eta)) = []
control_values(ret(w))      = [w]

slot_values(Xi) = [ w | ell |-> live(tau,w) in Xi ]

owners_values(ws) = multiset union of owner_ids(w) for every w in ws

owners_machine(Xi,control,K)
  = owners_values(slot_values(Xi) ++ control_values(control) ++ frame_values(K))

abandoned_owners(control,K)
  = owners_values(control_values(control) ++ frame_values(K))

terminal_owners(Xi,A)
  = owners_values(slot_values(Xi)) multiset-union A
```

`carrier_bijection(Sigma,Xi,control,K)` holds exactly when every live resource
identity in `Sigma` occurs exactly once in `owners_machine(Xi,control,K)` and every
identity in that multiset names one live store entry. Source syntax, environment
slot references, and tombstones contribute no carriers.

`terminal_carrier_bijection(Sigma,Xi,A)` holds exactly when every live resource
identity in `Sigma` occurs exactly once in `terminal_owners(Xi,A)` and every identity
in that multiset names one live store entry. The terminal snapshot `A` preserves
proof accounting for control or frame carriers erased by immediate TPOE. It does not
authorize observation, cleanup, or resumption.

`machine_invariants(Sigma,B,I,Xi,control,K)` holds exactly when:

1. `Delta |- Sigma ok`;
2. `Delta; store_types(Sigma); B |- Xi ok`;
3. `WF(B,Xi)`;
4. active witness layers satisfy `WF_I` for the current control and frame stack;
5. capability origins are initial or accepted attenuation edges; and
6. `carrier_bijection(Sigma,Xi,control,K)`.

Defined failure typing is intrinsic rather than reachability-defined:

```text
WT-TPOE-Contract
Delta |- Sigma ok    Delta; Sigma_t; B |- Xi ok    WF(B,Xi)    WF_I_terminal(B,I)
terminal_carrier_bijection(Sigma,Xi,A)
----------------------------------------------------------------
Delta |- tpoe<contract_false,Sigma,B,I,Xi,A> ok

WT-TPOE-Checked
Delta |- op admitted-checked Ts -> U
Sigma_t; Xi_t; B |- args : runtime_type(I,Ts)    not ok(op,args)
Delta |- Sigma ok    Delta; Sigma_t; B |- Xi ok    WF(B,Xi)    WF_I_terminal(B,I)
terminal_carrier_bijection(Sigma,Xi,A)
----------------------------------------------------------------
Delta |- tpoe<checked_failure(op,args),Sigma,B,I,Xi,A> ok
```

A terminal state may retain live owners and leases because no ordinary continuation
observes them. Failure transitions store `abandoned_owners(control,K)` in `A` before
erasing `K`. A checked condition or `Free` primitive argument does not itself add a
linear carrier, but an outer source-ordered frame can already hold one. The terminal
state therefore preserves store, lease-graph, witness, and complete carrier-accounting
invariants independently of its predecessor.

## 15. Binder Alpha-Equivalence, Fresh-Step Equivalence, And Equivariance

The calculus separates three relations:

1. `binder_alpha(e,e')` capture-avoiding renames source lexical-region binders
   and declaration-local binders while preserving binding structure;
2. `fresh_step_equiv(C,C')` consistently renames only runtime identities
   freshly minted by one selected transition: region identities from
   `E-Region-Enter`, lease identities from borrow/reborrow, owner slots from
   linear binding or invocation, and resource identities from attenuation;
3. `equivariant(R)` means relation `R` is preserved by sort-preserving finite
   renaming of runtime identities throughout `Sigma`, `B`, `I`, `Xi`,
   environments, returned values, and continuation frames.

Typing, stepping, `nested`, `closable`, `close`, witness extension and
restoration, `close_witness`, `return_witness`, `bind_payload`,
`bind_call_args`, and `instantiate_call` must each satisfy an equivariance
lemma. Binder alpha-
equivalence and fresh-step equivalence are not interchangeable.

## 16. Determinism Target

For every nonterminal `WT` ordinary configuration, exactly one applies:

1. the configuration is `<Sigma,B,I,Xi,ret(w),halt>`;
2. one transition family determines the next configuration;
3. one checked operation determines terminal TPOE and its exact abandoned-owner
   snapshot `A=abandoned_owners(control,K)`.

Fresh choices are unique modulo `fresh_step_equiv`. TPOE is classified by the
separate `WT_TPOE` predicate and is not included in the premise of ordinary
progress.
