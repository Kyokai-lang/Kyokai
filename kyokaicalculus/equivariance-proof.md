# Runtime Equivariance Derivation Package

**Status:** `paper-proven` Gate-B runtime-equivariance derivation package  
**Discharges in the maintained proof:** relation-local cases of L36-L37  
**Depends on:** `syntax-and-statics.md`, `dynamics.md`, `lemmas.md`

## 1. Claim Boundary

This package discharges runtime finite-renaming obligations for the sequential first
core.
Source-binder alpha-equivalence remains a separate L35 induction. This file concerns
runtime identities only.

## 2. Sort-Preserving Finite Renaming

A runtime renaming `zeta` is a finite bijection that preserves identity sorts:

```text
zeta_r    : runtime regions   <-> runtime regions
zeta_beta : runtime leases    <-> runtime leases
zeta_ell  : runtime slots     <-> runtime slots
zeta_a    : runtime resources <-> runtime resources
```

`zeta` acts homomorphically on runtime values, `Sigma`, `B`, witness runtime images,
`Xi`, environments, returned control, continuation frame value fields, path
certificates `pi`, and complete machine configurations. It fixes source syntax,
static atoms, declaration names, kinds, source types, and primitive names.

For example:

```text
zeta(own[a])                    = own[zeta_a(a)]
zeta(read_ref[r,beta,ell])      = read_ref[zeta_r(r),zeta_beta(beta),zeta_ell(ell)]
zeta(write_ref[r,beta,ell])     = write_ref[zeta_r(r),zeta_beta(beta),zeta_ell(ell)]
zeta(inject tag w)              = inject tag zeta(w)
zeta(pi(formal_path)=ell)       = zeta(pi)(formal_path)=zeta_ell(ell)
```

Static witness atoms are not renamed by `zeta`; their runtime images are.

## 3. Separate Name Relations

The proof uses three distinct relations:

| Relation | Renames | Fixes | Purpose |
| --- | --- | --- | --- |
| `binder_alpha(e,e')` | source lexical binders, declaration-local static atoms, and ordinary binders | runtime machine state | capture-avoiding source equivalence |
| `fresh_step_equiv(C,C')` | only identities freshly minted by one selected transition | all predecessor identities | deterministic execution modulo fresh choice |
| runtime equivariance under `zeta` | any finite sort-preserving runtime identity set consistently | source syntax and static atoms | relation invariance under runtime renaming |

No proof step uses one relation as a substitute for another.

## 4. Structural Commutation Facts

Each structural helper commutes with `zeta` by definition:

```text
owner_ids(zeta(w))              = zeta_a(owner_ids(w))
regions(zeta(w))                = zeta_r(regions(w))
slot_values(zeta(Xi))           = zeta(slot_values(Xi))
frame_values(zeta(K))           = zeta(frame_values(K))
control_values(zeta(control))   = zeta(control_values(control))
owners_machine(zeta(Xi),zeta(control),zeta(K))
                                = zeta_a(owners_machine(Xi,control,K))
abandoned_owners(zeta(control),zeta(K))
                                = zeta_a(abandoned_owners(control,K))
terminal_owners(zeta(Xi),zeta_a(A))
                                = zeta_a(terminal_owners(Xi,A))
```

Therefore ordinary and terminal carrier bijections are invariant under `zeta`.

## 5. Borrow Graph Relations

The following predicates are equivariant because they compare runtime identities for
equality, membership, stack order, or reachability only:

```text
active, fresh_region, fresh_lease, all_reads, all_writes,
frontier_reads, frontier_writes, unborrowed, no_writer,
usable_read, usable_write, nested, leases_at, closable,
descends, same_chain, WF
```

For every defined update:

```text
zeta(add_read(B,beta,r,ell))
  = add_read(zeta(B),zeta_beta(beta),zeta_r(r),zeta_ell(ell))

zeta(add_write(B,beta,r,ell))
  = add_write(zeta(B),zeta_beta(beta),zeta_r(r),zeta_ell(ell))

zeta(reborrow_write(B,parent,child,r,ell))
  = reborrow_write(zeta(B),zeta_beta(parent),zeta_beta(child),zeta_r(r),zeta_ell(ell))
```

The analogous equation holds for read reborrow. The close case is expanded in
`close-and-witness-proof.md`: renaming maps `leases_at(B,r)` exactly to
`leases_at(zeta(B),zeta_r(r))`, so exact child removal and direct-parent resumption
commute with `zeta`.

## 6. Witness And Path Relations

Witness lookup and scope ownership preserve static domains while renaming runtime
images:

```text
region_image(zeta(I),rho)       = zeta_r(region_image(I,rho))
lease_image(zeta(I),b)          = zeta_beta(lease_image(I,b))
zeta(push_region_layer(I,rho,r))
                                = push_region_layer(zeta(I),rho,zeta_r(r))
zeta(extend_lease_top(I,b,beta))
                                = extend_lease_top(zeta(I),b,zeta_beta(beta))
zeta(close_witness(I,rho))      = close_witness(zeta(I),rho)
```

Alias authorization remains valid because `zeta` preserves equality of runtime
images and fixes the static atoms named by the authorization. `return_witness`
commutes because it checks the exact layer suffix, not a runtime-image search.

Path resolution and certification commute:

```text
resolve_slot(zeta(eta),owner(x))    = zeta_ell(resolve_slot(eta,owner(x)))
resolve_slot(zeta(eta),referent(x)) = zeta_ell(resolve_slot(eta,referent(x)))
zeta(materialize_call_paths(phi,eta))
                                    = materialize_call_paths(phi,zeta(eta))
verify_call_paths(phi,pi,args)
                                    iff verify_call_paths(phi,zeta(pi),zeta(args))
```

## 7. Binding And Call Relations

`bind_payload` commutes by cases on payload universe. The `Free` case renames the
bound runtime value. The `Linear` case also renames the fresh slot consistently.

`bind_call_args` commutes by list induction. The `Free` case extends the environment
with `free(zeta(w))`. The `Linear` case allocates consistently renamed fresh slot
`zeta_ell(ell)`, stores `zeta(w)`, and appends that slot to the renamed parameter
list.

`realize_call` commutes because it reads token region, lease, and slot identities,
checks equality, distinctness, and usability, and records runtime images in one
scope-owned layer. `zeta` preserves all of those premises. `alpha_freshen` acts on
source binders and static atoms, so it commutes independently with runtime `zeta`.
`push_call_layer`, `return_witness`, and `result_bridge` then commute by their exact
layer and runtime-value typing definitions.

Therefore:

```text
instantiate_call(Delta,Sigma_t,f,phi,pi,B,I,Xi,args)=result
----------------------------------------------------------------
instantiate_call(Delta,zeta(Sigma_t),f,phi,zeta(pi),zeta(B),zeta(I),zeta(Xi),zeta(args))
  = zeta(result)
```

modulo fresh-step equivalence for newly allocated parameter slots.

## 8. Primitive Relations

Each admitted primitive declaration carries an equivariance obligation as part of its
runtime footprint:

| Primitive family | Required commuting fact |
| --- | --- |
| named consumption | `consume_op` commutes with resource renaming and changes exactly renamed `owner_ids(w)` |
| checked primitive | `ok` is identity-insensitive for its admitted `Free` arguments; `result` commutes with runtime-value renaming |
| borrow read/write access | operation commutes with referent-slot and resource renaming while preserving the admitted footprint |
| attenuation | payload attenuation commutes with resource renaming; the fresh weaker identity is compared modulo `fresh_step_equiv` |

A concrete primitive cannot enter `Delta` if its admitted semantics violate the
applicable commuting fact.

## 9. Step Relation

L37 is by cases over the selected step rule. Structural rules follow by homomorphic
renaming. Borrow rules use Section 5. Region entry, borrow creation, reborrow, slot
allocation, and attenuation select consistently renamed fresh identities and are
compared modulo `fresh_step_equiv`. Call rules use Sections 6-7. Primitive rules use
Section 8. TPOE rules use Section 4:

```text
A = abandoned_owners(control,K)
----------------------------------------------------------------
zeta_a(A) = abandoned_owners(zeta(control),zeta(K))
```

so intrinsic terminal carrier accounting is preserved.

## 10. Composition Result

This package supplies L36-L37 runtime-renaming cases to `theorem-assembly.md`.
Close-specific equations are discharged in `close-and-witness-proof.md`; admitted
primitive equivariance obligations are discharged in `primitive-admission-proof.md`.
