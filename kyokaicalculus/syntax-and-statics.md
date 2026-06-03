# `lambda_K-seq` Syntax And Statics

**Status:** `paper-proven` formal-core statics  
**Gate:** K-B static half closed by Gate-B paper proof  
**Depends on:** `scope.md`

## 1. Purpose And Proof Style

`lambda_K-seq` uses an effect-style source judgment and a separate runtime-value
judgment. The source judgment exposes incoming and outgoing exact-use owner
contexts and incoming and outgoing borrow state:

```text
Delta; Rho; Gamma_f; Gamma_l |- e : T => Rho'; Gamma_l'
```

Read the judgment as follows: under declarations `Delta`, active static borrow
state `Rho`, unrestricted bindings `Gamma_f`, and live linear bindings
`Gamma_l`, expression `e` produces a value of type `T` on ordinary completion
and leaves borrow state `Rho'` and linear context `Gamma_l'`. Evaluation can
instead reach terminal TPOE. Terminal TPOE has no ordinary continuation state.

The runtime semantics does not substitute linear values into source syntax.
It uses environments, linear owner slots, and continuation frames. This
choice is proof-relevant: a source linear variable can appear in both arms of
an `if` because only one arm executes, while its runtime value remains stored
in exactly one owner slot. The machine follows the environment-machine line
from CEK/CESK presentations while retaining Kyokai-specific exact-use owners,
lexical lease state, and defined TPOE.

## 2. Metavariables

| Name | Meaning |
| --- | --- |
| `x`, `y` | Source term variables. |
| `f` | First-order function identity. |
| `rho`, `sigma` | Source lexical-region binders. |
| `b`, `c` | Static borrow-lease atoms introduced by elaboration. |
| `r`, `s` | Fresh runtime lexical-region identities. |
| `p`, `q` | Static whole-referent paths. The first core uses `owner(x)` and `referent(x)` only. |
| `ell`, `ell'` | Runtime linear owner-slot identities. |
| `a`, `a'` | Runtime resource identities held inside linear values. |
| `beta`, `beta'` | Fresh runtime borrow-lease identities. |
| `k`, `k'` | Capability authority classes. |
| `tag` | Closed-sum constructor identity. |
| `op` | Checked or named consuming primitive identity. |
| `phi` | Explicit static call-instantiation witness recorded by elaboration. |
| `pi` | Runtime path certificate materialized from `phi` and the caller environment before argument evaluation begins. |
| `psi` | Invocation-local callee view derived from `phi` by capture-avoiding freshening. |

Static paths and runtime slots are deliberately different. A checker lease
protects a source path such as `owner(x)` or the whole referent exposed by a
token path `referent(b)`. The source rules below abbreviate `owner(x)` as `x`
where the operand is syntactically an owned linear variable. A runtime lease
protects the unique slot that currently holds the corresponding linear value.
`dynamics.md` defines `resolve_slot` and `lease_bridge(Rho,B,I,eta)`: each
required static path lease resolves through the active runtime environment to
a matching slot lease, while unrelated caller leases remain explicitly
framed and runtime-visible.

Static atoms and runtime identities are deliberately different. `Rho` uses
`rho` and `b`; runtime state uses `r` and `beta`. `dynamics.md` defines the
explicit scoped witness stack `I`. Each lexical-region or invocation layer
owns the static atoms introduced in that scope. A layer can alias one
outer-layer runtime image only through an explicit equality authorization
recorded by checked elaboration. Closing a scope removes that scope's layer by
static ownership; it never deletes witness entries merely because another
entry has the same runtime image. Fresh runtime identity minting remains a
separate checked operation in `dynamics.md`.

## 3. Types, Runtime Values, And Source Terms

```text
U ::= Free | Linear

T ::= Unit | Bool | IntK
    | Resource[k]
    | Capability[k]
    | Borrow[rho, b, T]
    | MutBorrow[rho, b, T]
    | Sum[tag_i : T_i]
    | Optional[T]
    | Result[T, E]

w ::= nil | true | false | n
    | own[a]
    | read_ref[r, beta, ell]
    | write_ref[r, beta, ell]
    | inject tag w

e ::= x
    | nil | true | false | n
    | let x : T = e in e
    | seq e e
    | call f[phi](e_1, ..., e_n)
    | move x
    | consume[op] x
    | region rho in e
    | borrow[rho,b] x
    | mut_borrow[rho,b] x
    | reborrow[rho,b] x
    | read_reborrow[rho,b] x
    | read_access[op] x
    | write_access[op] x
    | check e else tpoe
    | checked[op](e_1, ..., e_n)
    | if e then e else e
    | inject tag e
    | case e of tag_i(x_i) => e_i
    | attenuate x as k
```

`w` is runtime syntax. Source programs do not write `own[a]`, owner-slot
identities, or runtime borrow tokens. Runtime values are closed under sum
injection, so movement can operate on arbitrary linear sums without inventing
a resource-only special case. The core has no universal structural-destruction
operation. `consume[op]` is a proof-facing elaboration of one statically
resolved named consuming operation.

`Optional[T]` is `Sum[None : Unit, Some : T]`. `Result[T,E]` is
`Sum[Ok : T, Err : E]`. These aliases add no extra reduction rules.

`panic`, cleanup registration, loops, records, field paths, heap allocation,
closures, concurrency, and unsafe operations remain outside `lambda_K-seq`.

Core source binders are capture-avoiding and alpha-fresh within their lexical
scope. Surface shadowing, if admitted by the surface grammar, elaborates to
fresh core names before these rules apply. Function parameters, `let`
binders, case payload binders, and lexical-region binders follow that rule.

## 4. Static Contexts And Borrow State

| Context | Contents |
| --- | --- |
| `Delta` | Type declarations, checked first-order functions, admitted checked primitives, admitted named consuming primitives, sealed capabilities, admitted borrow-access primitives, and admitted attenuation declarations. |
| `Gamma_f` | Unrestricted source bindings. Weakening and contraction are legal. |
| `Gamma_l` | Live linear source-owner bindings. Weakening and contraction are illegal. |
| `Rho` | Active static lexical regions, path leases, and parent-suspension facts. |

```text
Rho ::= <StaticRegions, StaticLeases, StaticSuspended>

StaticRegions   ::= finite stack of active static region atoms rho
StaticLeases    ::= b |-> <rho, read,  p>
                  | b |-> <rho, write, p>
StaticSuspended ::= b_parent |-> b_child
```

The following definitions are exact. `no_writer` examines every retained
writer, not merely the usable frontier. Therefore direct immutable borrowing
through an owner path remains rejected while a read reborrow has suspended a
mutable parent.

```text
active(Rho, rho)           rho occurs in StaticRegions
fresh_region(Rho, rho)     rho does not occur in StaticRegions
fresh_lease(Rho, b)        b does not occur in dom(StaticLeases)
all_reads(Rho, p)          { b | StaticLeases(b) = <rho, read, p> }
all_writes(Rho, p)         { b | StaticLeases(b) = <rho, write, p> }
unsuspended(Rho, b)        b notin dom(StaticSuspended)
frontier_reads(Rho, p)     { b | b in all_reads(Rho,p) and unsuspended(Rho,b) }
frontier_writes(Rho, p)    { b | b in all_writes(Rho,p) and unsuspended(Rho,b) }
unborrowed(Rho, p)         all_reads(Rho,p) = empty and all_writes(Rho,p) = empty
no_writer(Rho, p)          all_writes(Rho,p) = empty
nested(StaticRegions,sigma,rho) sigma occurs strictly below rho in StaticRegions
leases_at(Rho,rho)         { b | StaticLeases(b) = <rho,mode,p> }
closable(Rho,rho)          top(StaticRegions)=rho and leases_at(Rho,rho) intersect dom(StaticSuspended)=empty
descends(StaticSuspended,b,b')
                            b'=b or b' is reachable from b by one or more StaticSuspended edges
same_chain(StaticSuspended,b,b')
                            descends(StaticSuspended,b,b') or descends(StaticSuspended,b',b)
regions(T)                 static region atoms occurring in T
regions(Gamma)             union of regions(T) for bindings in Gamma
```

`StaticSuspended` is a finite partial injective function. For every
`StaticSuspended(b_parent) = b_child`:

1. both identities occur in `StaticLeases`;
2. the parent lease mode is `write`;
3. both leases protect the same path;
4. the child static region is strictly nested inside the parent static region;
5. the parent has exactly one immediate child and the child has exactly one
   immediate parent;
6. for every retained mutable lease `b` over path `p`, every other retained
   lease `b'` over `p` satisfies `same_chain(StaticSuspended,b,b')`.

Lexical nesting makes suspension cycles impossible. Closing top static region
`rho` removes exactly `leases_at(Rho,rho)`, removes edges whose child was
removed, resumes those direct parents, and pops `rho`. `closable` rejects a
close while a lease created in `rho` still owns a nested child.

## 5. Universe Rules

```text
Unit : Free             Bool : Free              IntK : Free
Resource[k] : Linear    Capability[k] : Linear

T_i : U_i
------------------------------------------------ U-Sum
Sum[tag_i : T_i] : Linear    if any U_i = Linear
Sum[tag_i : T_i] : Free      otherwise

Borrow[rho, b, T] : Free
MutBorrow[rho, b, T] : Free
```

Borrow-reference values are `Free` access tokens. Copying a token copies the
same lease identity. It does not create a lease, widen a region, copy a
referent, or create ownership. A copied mutable token can remain typed while
its parent lease is suspended, but it is unusable until the nested child
region closes.

## 6. Source Well-Formedness

`wf(Delta; Rho; Gamma_f; Gamma_l)` requires:

1. context types are well formed under `Delta`;
2. `dom(Gamma_f)` and `dom(Gamma_l)` are disjoint;
3. every `Gamma_l` binding has a `Linear` type;
4. every lease refers to an active region and a live source path;
5. `frontier_reads(Rho,p)` and `frontier_writes(Rho,p)` are never both
   non-empty;
6. `frontier_writes(Rho,p)` contains at most one identity;
7. every suspension edge satisfies the graph invariants in section 4;
8. for every retained mutable lease `b` over path `p`, every other retained lease
   over `p` lies on the same suspension chain as `b`; an unsuspended retained
   mutable lease therefore has no competing lease over its path;
9. a mutable token satisfies an access, reborrow, or call-compatibility premise
   only while its lease is unsuspended.

The first theorem borrows whole linear-owner paths only. Mutable borrowing of
a `Free` place belongs to a later place-state extension because that extension
must model mutation, reinitialization, and invalidation without pretending an
unrestricted value is a linear owner.

## 7. Basic Source Typing Rules

```text
T-Unit
----------------------------------------------------------------
Delta; Rho; Gamma_f; Gamma_l |- nil : Unit => Rho; Gamma_l

T-Bool
v_bool in {true,false}
----------------------------------------------------------------
Delta; Rho; Gamma_f; Gamma_l |- v_bool : Bool => Rho; Gamma_l

T-IntK
n in IntK
----------------------------------------------------------------
Delta; Rho; Gamma_f; Gamma_l |- n : IntK => Rho; Gamma_l

T-Var-Free
x : T in Gamma_f
----------------------------------------------------------------
Delta; Rho; Gamma_f; Gamma_l |- x : T => Rho; Gamma_l

T-Move
x : T in Gamma_l    unborrowed(Rho, x)
----------------------------------------------------------------
Delta; Rho; Gamma_f; Gamma_l |- move x : T => Rho; Gamma_l - x

T-Consume
x : T in Gamma_l    unborrowed(Rho, x)    Delta |- op admitted-consuming T -> Unit
----------------------------------------------------------------
Delta; Rho; Gamma_f; Gamma_l |- consume[op] x : Unit => Rho; Gamma_l - x

T-Seq
Delta; Rho;  Gamma_f; Gamma_l  |- e1 : Unit => Rho1; Gamma_l1
Delta; Rho1; Gamma_f; Gamma_l1 |- e2 : T2 => Rho2; Gamma_l2
----------------------------------------------------------------
Delta; Rho; Gamma_f; Gamma_l |- seq e1 e2 : T2 => Rho2; Gamma_l2
```

`move x` transfers the arbitrary linear runtime value stored in `x`'s owner
slot. `consume[op] x` represents one already resolved named consuming
operation whose declaration explicitly accepts `T` and returns `Unit`. The
calculus never invents an operation from `T`'s structure. In particular, a
linear sum must be destructured and its selected payload discharged unless a
named consuming operation for that sum is explicitly present in `Delta`.
Neither rule substitutes a runtime value into source syntax.

```text
T-Let-Free
Delta; Rho;  Gamma_f;     Gamma_l  |- e1 : T => Rho1; Gamma_l1
T : Free
Delta; Rho1; Gamma_f,x:T; Gamma_l1 |- e2 : U => Rho2; Gamma_l2
----------------------------------------------------------------
Delta; Rho; Gamma_f; Gamma_l |- let x:T = e1 in e2 : U => Rho2; Gamma_l2

T-Let-Linear
Delta; Rho;  Gamma_f; Gamma_l      |- e1 : T => Rho1; Gamma_l1
T : Linear
Delta; Rho1; Gamma_f; Gamma_l1,x:T |- e2 : U => Rho2; Gamma_l2
x notin dom(Gamma_l2)
----------------------------------------------------------------
Delta; Rho; Gamma_f; Gamma_l |- let x:T = e1 in e2 : U => Rho2; Gamma_l2
```

`T-Let-Linear` checks exact use on ordinary completion. TPOE has no ordinary
post-state and does not fabricate discharged owners.

## 8. Regions, Borrowing, And Reborrowing

```text
T-Region
fresh_region(Rho, rho)
Delta; Rho + region(rho); Gamma_f; Gamma_l |- e : T => Rho_body; Gamma_l'
closable(Rho_body, rho)
rho notin regions(T) union regions(Gamma_f) union regions(Gamma_l')
----------------------------------------------------------------
Delta; Rho; Gamma_f; Gamma_l |- region rho in e : T
  => close(Rho_body, rho); Gamma_l'

T-Borrow
x : T in Gamma_l    active(Rho,rho)    no_writer(Rho,x)    fresh_lease(Rho,b)
----------------------------------------------------------------
Delta; Rho; Gamma_f; Gamma_l |- borrow[rho,b] x : Borrow[rho,b,T]
  => Rho + read(b,rho,x); Gamma_l

T-MutBorrow
x : T in Gamma_l    active(Rho,rho)    unborrowed(Rho,x)    fresh_lease(Rho,b)
----------------------------------------------------------------
Delta; Rho; Gamma_f; Gamma_l |- mut_borrow[rho,b] x : MutBorrow[rho,b,T]
  => Rho + write(b,rho,x); Gamma_l

T-Reborrow
x : MutBorrow[sigma,b,T] in Gamma_f    active(Rho,rho)
unsuspended(Rho,b)                     fresh_lease(Rho,c)
parent_path(Rho,b) = p                 nested(StaticRegions,sigma,rho)
----------------------------------------------------------------
Delta; Rho; Gamma_f; Gamma_l |- reborrow[rho,c] x : MutBorrow[rho,c,T]
  => suspend(Rho + write(c,rho,p), b, c); Gamma_l

T-Read-Reborrow
x : MutBorrow[sigma,b,T] in Gamma_f    active(Rho,rho)
unsuspended(Rho,b)                     fresh_lease(Rho,c)
parent_path(Rho,b) = p                 nested(StaticRegions,sigma,rho)
----------------------------------------------------------------
Delta; Rho; Gamma_f; Gamma_l |- read_reborrow[rho,c] x : Borrow[rho,c,T]
  => suspend(Rho + read(c,rho,p), b, c); Gamma_l
```

Each reborrow transition atomically adds the child lease and suspends its
parent. It does not route through direct-borrow preconditions.

The core contains explicit borrow-use operations. A token-lifecycle proof is
not enough to claim borrow access safety.

```text
T-Read-Access-Read
x : Borrow[sigma,b,T] in Gamma_f    unsuspended(Rho,b)
Delta |- op admitted-read-access T -> U    U : Free
----------------------------------------------------------------
Delta; Rho; Gamma_f; Gamma_l |- read_access[op] x : U => Rho; Gamma_l

T-Read-Access-Write
x : MutBorrow[sigma,b,T] in Gamma_f    unsuspended(Rho,b)
Delta |- op admitted-read-access T -> U    U : Free
----------------------------------------------------------------
Delta; Rho; Gamma_f; Gamma_l |- read_access[op] x : U => Rho; Gamma_l

T-Write-Access
x : MutBorrow[sigma,b,T] in Gamma_f    unsuspended(Rho,b)
Delta |- op admitted-write-access T -> Unit
----------------------------------------------------------------
Delta; Rho; Gamma_f; Gamma_l |- write_access[op] x : Unit => Rho; Gamma_l
```

`read_access[op]` abstracts one admitted observation through a usable token.
`write_access[op]` abstracts one admitted mutation through a usable mutable
token. Both operations are named proof-facing nodes. Neither operation grants
authority, widens a region, changes a lease, or permits access through a
suspended parent token. `dynamics.md` gives their total admitted runtime
relations and preservation obligations.

## 9. Branches And Closed Sums

Payload binding is universe-sensitive:

```text
bind_context(Gamma_f,Gamma_l,x:T) = <Gamma_f,x:T; Gamma_l>   if T : Free
bind_context(Gamma_f,Gamma_l,x:T) = <Gamma_f; Gamma_l,x:T>   if T : Linear
```

```text
T-If
Delta; Rho;  Gamma_f; Gamma_l  |- c  : Bool => Rho_c; Gamma_lc
Delta; Rho_c; Gamma_f; Gamma_lc |- e1 : T => Rho_j; Gamma_lj
Delta; Rho_c; Gamma_f; Gamma_lc |- e2 : T => Rho_j; Gamma_lj
----------------------------------------------------------------
Delta; Rho; Gamma_f; Gamma_l |- if c then e1 else e2 : T
  => Rho_j; Gamma_lj

T-Inject
Delta; Rho; Gamma_f; Gamma_l |- e : T_i => Rho'; Gamma_l'
tag_i : T_i in Sum[tag_j:T_j]
----------------------------------------------------------------
Delta; Rho; Gamma_f; Gamma_l |- inject tag_i e : Sum[tag_j:T_j]
  => Rho'; Gamma_l'

T-Case
Delta; Rho; Gamma_f; Gamma_l |- e : Sum[tag_i:T_i] => Rho_s; Gamma_ls
for every i:
  bind_context(Gamma_f,Gamma_ls,x_i:T_i) = <Gamma_fi;Gamma_li>
  Delta; Rho_s; Gamma_fi; Gamma_li |- e_i : U => Rho_j; Gamma_lj
  x_i notin dom(Gamma_lj) when T_i : Linear
----------------------------------------------------------------
Delta; Rho; Gamma_f; Gamma_l |- case e of tag_i(x_i) => e_i : U
  => Rho_j; Gamma_lj
```

Every ordinarily completing arm has exactly the same post-state. The runtime
machine stores the unselected arms as source syntax in a continuation frame.
Those arms do not carry runtime owner values and cannot duplicate ownership.
A selected arm can still reach terminal TPOE dynamically; TPOE has no fake
join state.

## 10. Calls And Checked Primitives

```text
Delta(f) = forall Phi. fn (x_1:T_1, ..., x_n:T_n) -> U { e_f }
```

`phi` is a checker-recorded call certificate:

```text
phi ::= <TypeInst, ActualPosition, PathMap, ModeMap, Equalities, Distinctness>
```

`TypeInst` instantiates the declaration parameters. `ActualPosition` maps each
formal argument relationship to one source argument position. `PathMap` maps each
formal whole-owner or whole-referent path to one caller source path. `ModeMap`
records immutable or mutable borrow mode. `Equalities` records formal atoms that
must denote one relationship. `Distinctness` records formal atoms or paths that
must denote distinct relationships. The certificate contains no inferred runtime
identity.

For the first-core whole-referent path language, runtime resolution is exactly the
`owner(x)` and `referent(x)` relation defined in `dynamics.md`. Before argument
evaluation begins, runtime materializes `pi` from `phi` and the caller environment.
This preserves the checked source path evidence even when evaluation moves an
actual owner out of its caller slot before callee entry. Later field-path extensions
must define their own place-resolution relation.

A declaration enters `Delta` only after its body checks schematically
for every well-formed instantiation. The body starts with exactly the formal
external lease assumptions, ends with the same assumptions, consumes every
owned parameter on ordinary completion, and leaks no locally created region
or lease.

Argument typing is source ordered:

```text
T-Args-Empty
----------------------------------------------------------------
Delta; Rho; Gamma_f; Gamma_l |- [] : [] => Rho; Gamma_l

T-Args-Cons
Delta; Rho;  Gamma_f; Gamma_l  |- e  : T  => Rho1; Gamma_l1
Delta; Rho1; Gamma_f; Gamma_l1 |- es : Ts => Rho2; Gamma_l2
----------------------------------------------------------------
Delta; Rho; Gamma_f; Gamma_l |- e::es : T::Ts => Rho2; Gamma_l2
```

```text
T-Call
Delta(f) = forall Phi. fn (x_1:T_1, ..., x_n:T_n) -> U { e_f }
phi instantiates Phi
Delta; Rho; Gamma_f; Gamma_l |- args : phi(T_1..T_n) => Rho_a; Gamma_la
static_call_compatible(Rho_a, phi, f, args)
----------------------------------------------------------------
Delta; Rho; Gamma_f; Gamma_l |- call f[phi](args) : phi(U) => Rho_a; Gamma_la
```

`static_call_compatible(Rho_a,phi,f,args)` holds exactly when:

1. `phi.TypeInst` instantiates every declaration parameter of `f` exactly once;
2. `phi.ActualPosition` covers every formal relationship used by the declaration
   and names one in-range source argument position;
3. `phi.PathMap` covers every required first-core whole-owner or whole-referent
   path exactly once;
4. `phi.ModeMap` matches each actual borrow token type to the corresponding formal
   immutable or mutable mode;
5. every actual mutable-borrow token is unsuspended in `Rho_a`, and every actual
   immutable-borrow token is active and usable in `Rho_a`;
6. each equality in `phi.Equalities` is derivable from the actual static lease and
   path relationships, and each relationship declared distinct by the callee
   appears in `phi.Distinctness` and is statically distinct;
7. leases unrelated to formal arguments remain framed through unchanged; and
8. `phi(U)` contains only admitted external region and lease relationships.

The relation checks the explicit certificate. It does not search for one. Runtime
rechecks the corresponding identity facts after source-ordered argument evaluation.

The runtime call-instantiation relation additionally alpha-freshens every
callee-local lexical-region binder on every invocation, including recursive
invocations. Runtime owner slots are not source binders: call entry and local
linear binding allocate them freshly.

`phi` is elaborated call syntax, not a runtime search result. The checker
records the unique locally solved instantiation at the call site. Runtime
execution uses that recorded witness. A future erasure optimization must prove
that removing the witness preserves behavior; execution never reconstructs it
from runtime values.

```text
T-Check
Delta; Rho; Gamma_f; Gamma_l |- e : Bool => Rho'; Gamma_l'
----------------------------------------------------------------
Delta; Rho; Gamma_f; Gamma_l |- check e else tpoe : Unit => Rho'; Gamma_l'

T-Checked-Primitive
Delta |- op admitted-checked (T_1, ..., T_n) -> U
for every i: T_i : Free    U : Free
Delta; Rho; Gamma_f; Gamma_l |- args : T_1..T_n => Rho'; Gamma_l'
----------------------------------------------------------------
Delta; Rho; Gamma_f; Gamma_l |- checked[op](args) : U => Rho'; Gamma_l'
```

Possible checked failure remains dynamic TPOE. It does not change the
successful static type to `Never`. The first-core checked-primitive family is
restricted to `Free` inputs and outputs, including checked integer,
representability, divisor, shift, narrowing, and bounds predicates. A later
primitive that transfers or consumes a linear carrier needs an explicit
extension rule and a carrier-preservation proof; it cannot enter `Delta(op)`
through this first-core rule.

## 11. Sealed Capabilities

```text
T-Attenuate
x : Capability[k_strong] in Gamma_l    unborrowed(Rho,x)
Delta |- admitted-attenuation k_strong -> k_weak    k_weak <= k_strong
----------------------------------------------------------------
Delta; Rho; Gamma_f; Gamma_l |- attenuate x as k_weak : Capability[k_weak]
  => Rho; Gamma_l - x
```

Initial configurations and declared consuming attenuation are the only
capability origins. No literal, constructor, cast, decoder, integer
conversion, generic default, or unsafe first-core term produces a capability.

## 12. Runtime Value Typing Bridge

Static types use static region and lease atoms. Runtime values use runtime
identities. The explicit witness `I` instantiates one static type into one
runtime type:

```text
tau ::= Unit | Bool | IntK
      | Resource[k]
      | Capability[k]
      | BorrowRT[r,beta,tau]
      | MutBorrowRT[r,beta,tau]
      | SumRT[tag_i : tau_i]

runtime_type(I,Unit|Bool|IntK|Resource[k]|Capability[k]) = same type
runtime_type(I,Borrow[rho,b,T])    = BorrowRT[region_image(I,rho),lease_image(I,b),runtime_type(I,T)]
runtime_type(I,MutBorrow[rho,b,T]) = MutBorrowRT[region_image(I,rho),lease_image(I,b),runtime_type(I,T)]
runtime_type(I,Sum[tag_i:T_i])     = SumRT[tag_i:runtime_type(I,T_i)]
```

The machine types runtime values separately from source terms:

```text
Sigma_t; Xi_t; B |- w : tau
```

`Sigma_t` projects resource types from the runtime resource store. `Xi_t`
projects instantiated runtime payload types from the runtime owner-slot store.
Every live or moved `Xi` entry stores a runtime type `tau`; source types never
appear in `Xi`. Binding a source `T` computes `runtime_type(I,T)` before
allocating a slot.

```text
V-Owner
Sigma_t(a) = T    T in { Resource[k], Capability[k] }
----------------------------------------------------------------
Sigma_t; Xi_t; B |- own[a] : T

V-Inject
Sigma_t; Xi_t; B |- w : tau_i    tag_i:tau_i in SumRT[tag_j:tau_j]
----------------------------------------------------------------
Sigma_t; Xi_t; B |- inject tag_i w : SumRT[tag_j:tau_j]

V-Read-Token
Xi_t(ell) = tau    lease(B,beta) = <r,read,ell>
active(B,r)        unsuspended(B,beta)
----------------------------------------------------------------
Sigma_t; Xi_t; B |- read_ref[r,beta,ell] : BorrowRT[r,beta,tau]

V-Write-Token
Xi_t(ell) = tau    lease(B,beta) = <r,write,ell>    active(B,r)
----------------------------------------------------------------
Sigma_t; Xi_t; B |- write_ref[r,beta,ell] : MutBorrowRT[r,beta,tau]
```

`V-Write-Token` keeps a copied suspended parent token typed. The separate
predicate `usable_write(B,beta)` requires an active unsuspended write lease.
Reborrow, mutable access, and call compatibility require `usable_write`.
`V-Read-Token` requires usability because immutable leases are never parents
of reborrow suspension in the first core.

## 13. Declaration Admission

Primitive declaration lookup is not enough for progress. A primitive enters `Delta`
only after an admission judgment proves that its runtime relation is total on every
well-typed input admitted by its source signature and preserves the named invariants.

```text
A-Function
+ for every well-formed checked instantiation phi of Phi and every matching
  external borrow-state assumption Rho_ext:
    Delta; Rho_ext; Gamma_f(formals); Gamma_l(formals) |- e_f : U
      => Rho_ext; empty
+ the body introduces no escaping local region or lease atom
+ result types mention only admitted caller-visible relationships from phi
----------------------------------------------------------------
Delta |- forall Phi. fn (x_1:T_1,...,x_n:T_n) -> U { e_f } admitted

A-Consuming
+ for every I, Sigma, Xi, B, and w with
    Delta |- Sigma ok
    Delta; store_types(Sigma); B |- Xi ok
    store_types(Sigma); slot_types(Xi); B |- w : runtime_type(I,T)
    every owner in owner_ids(w) is live in Sigma
  there exists exactly one Sigma' with consume_op(Delta,Sigma,op,w)=Sigma'
+ Sigma' consumes exactly owner_ids(w), preserves every unrelated store entry,
  creates no owner, and returns Unit
----------------------------------------------------------------
Delta |- op admitted-consuming T -> Unit

A-Checked
+ for every well-typed Free argument vector args : runtime_type(I,Ts),
  ok(op,args) is total
+ whenever ok(op,args), result(op,args) is total and has runtime_type(I,U)
+ neither branch changes Sigma, Xi, B, I, owner carriers, or capability origins
----------------------------------------------------------------
Delta |- op admitted-checked Ts -> U

A-Read-Access
+ for every usable token to ell containing tau, read_access_op is total
+ result has declared Free type U and the relation preserves Sigma, Xi, B, I,
  owner carriers, and capability origins
----------------------------------------------------------------
Delta |- op admitted-read-access T -> U

A-Write-Access
+ for every usable mutable token to ell containing tau, write_access_op is total
+ relation preserves ell's runtime type, Sigma/Xi owner-carrier bijection, B, I,
  and capability origins; it performs no named consumption or authority creation
----------------------------------------------------------------
Delta |- op admitted-write-access T -> Unit

A-Attenuation
+ k_weak <= k_strong
+ for every admitted strong payload, attenuate_payload is total and returns one
  payload valid for Capability[k_weak]
+ transition consumes exactly one strong capability owner, creates exactly one
  fresh weaker capability owner, and records its accepted attenuation origin
----------------------------------------------------------------
Delta |- admitted-attenuation k_strong -> k_weak
```

The admission proofs are declaration obligations. An implementation cannot add a
primitive name to `Delta` while leaving its successful runtime relation, checked
predicate, result function, or attenuation payload rule partial. Backend lowering and
stdlib wrappers remain later obligations; this rule closes the first-core progress
assumption only.

## 14. Static Rejections

The first core rejects:

- use after move or named consuming operation;
- duplicate linear use or ordinary completion with a live local obligation;
- movement, named consumption, or attenuation while a protected owner slot is
  borrowed;
- direct immutable owner borrowing while any retained writer exists;
- mutable borrowing while any retained read or write lease exists;
- mutable access, reborrow, or callee transfer through a suspended mutable
  token;
- borrow escape across lexical region end;
- branch joins with different owner or lease states;
- non-exhaustive sum matching;
- capability construction outside initial configuration and attenuation;
- implicit allocation, blocking, authority acquisition, cleanup, I/O,
  spawning, dynamic loading, or unlisted control flow.

## 15. Explicit Exclusions

This first-core proof does not formalize field projection, partial moves, mutable `Free`
places, loops, `defer`, `errdefer`, `panic`, records, `build`, closures,
generators, allocation, concurrency, unsafe, FFI, backend lowering, stdlib
APIs, or toolchain artifacts. Their contracts belong to later layers named by
`scope.md` and `extension-roadmap.md`.
