# Close And Layered-Witness Derivation Package

**Status:** `paper-proven` Gate-B close-and-witness derivation package  
**Discharges in the maintained proof:** close cases of L20, L21, L23, and L37  
**Depends on:** `syntax-and-statics.md`, `dynamics.md`, `lemmas.md`

## 1. Claim Boundary

This package gives the human-checkable derivation for lexical region close and
scope-owned witness restoration. `theorem-assembly.md` composes these cases into the
closed `lambda_K-seq` paper proof.

The close proof uses the exact accepted first-core boundary: anonymous surface
borrow scopes elaborate to proof-facing lexical regions, `drop;` ends borrow
access rather than destroying the referent, and a nested reborrow suspends its
mutable parent until the child scope closes. The surface contract is specified in
`kyokaispec/src/language/11-linearity-borrowing-and-regions.md`.

## 2. Definitions Used By The Derivation

Let runtime borrow state be:

```text
B = <Regions,Leases,Suspended>
D = leases_at(B,r)
```

For the selected top region `r`, `closable(B,r)` means:

```text
top(Regions)=r
D intersect dom(Suspended)=empty
```

The second premise means that no lease created in `r` remains the parent of a
live nested child. `close(B,r)` then performs exactly:

```text
Regions'   = pop(Regions)
Leases'    = Leases restricted to dom(Leases) - D
Suspended' = { parent |-> child in Suspended | child notin D }
B'         = <Regions',Leases',Suspended'>
```

`descends(Suspended,beta,beta')` is the reflexive-transitive child relation.
`same_chain(Suspended,beta,beta')` holds when either identity descends from the
other. `WF(B,Xi)` requires that every retained writer and every other retained
lease over the same slot lie on one suspension chain. This clause is necessary:
without it, a malformed state could contain a suspended writer, its read child,
and an unrelated frontier reader over the same slot. Closing the child region
would resume the parent beside the unrelated reader and violate exclusivity.

Witness state is a stack:

```text
I = W_0 :: ... :: W_n
W_n.owner = region(rho)
close_witness(I,rho) = W_0 :: ... :: W_(n-1)
```

The operation removes the top layer by scope ownership. It never searches
`RegionMap` or `LeaseMap` for a runtime image. A checked call-formal alias in a
local layer can therefore denote an outer runtime identity without making local
close erase the outer mapping.

## 3. L20: Close Is Defined And Local

Assume `WF(B,Xi)` and `closable(B,r)`. Let `B'=close(B,r)`.

1. By definition of `Leases'`, a lease remains exactly when its identity is not
   in `D`. Therefore close removes exactly the leases created in `r`.
2. By definition of `Suspended'`, an edge remains exactly when its child is not
   in `D`. Therefore close removes exactly the edges whose child lease closed.
3. A removed edge `parent |-> child` resumes that direct parent: `parent`
   remains in `Leases'` because suspension edges descend through strict lexical
   nesting, while `child` lies in top region `r`.
4. `closable(B,r)` states `D intersect dom(Suspended)=empty`. Therefore no
   removed lease remains a parent of a live nested child.
5. By definition of `Regions'`, close pops exactly top region `r`.

No unrelated lease, suspension edge, region, slot, resource, or owner carrier is
changed.

## 4. L21: Suspension Acyclicity

Every edge `beta_parent |-> beta_child` satisfies:

```text
Leases(beta_parent)=<s,write,ell>
Leases(beta_child) =<r,mode,ell>
nested(Regions,s,r)
```

`nested` is strict stack order. Along every suspension edge, the region position
strictly increases. A finite strict increase cannot return to its starting
position, so `Suspended` is acyclic. Because `Suspended` is a partial injective
function, each parent has at most one direct child and each child has at most one
direct parent. Every connected suspension component is therefore a finite chain.

## 5. L23: Close Preserves Borrow-State Well-Formedness

Assume `WF(B,Xi)`, `closable(B,r)`, and `B'=close(B,r)`.

| `WF` clause | Preservation argument |
| --- | --- |
| Active region and live slot for every lease | Remaining leases were not created in popped top region `r`; their regions remain active. Close does not change `Xi`. |
| Frontier readers or one frontier writer, never both | Removing leases cannot introduce a conflict. Resuming a direct parent cannot introduce a conflict because every lease over that writer's slot lies on the same suspension chain. The removed child was the unique next link; no unrelated frontier lease can remain beside the resumed parent. |
| `Suspended` is a finite partial injective function | Restricting a finite partial injective function by removing edges preserves both properties. |
| Every edge names existing same-slot leases | Every retained edge has a retained child by construction. Its parent cannot lie in `D`: `closable` excludes a removed parent with a live child. Slot identities are unchanged. |
| Every suspended parent has mode `write` | Close does not change lease modes. |
| Child regions are strictly nested | Retained edges mention retained regions and preserve the same strict stack order after top-region removal. |
| Suspension graph is acyclic | Removing edges from an acyclic graph cannot create a cycle. |
| Writer-chain isolation | Restricting one chain and resuming its direct parent preserves chain comparability. No unrelated lease is inserted. |

Therefore `WF(B',Xi)`.

For witness state, assume `WF_I(Rho,B,I,eta)` and
`close_witness(I,rho)=I_entry`. The top layer is owned by `region(rho)`.
Popping it removes exactly the static atoms introduced by that lexical scope.
Every outer layer remains byte-for-byte unchanged, including outer mappings whose
runtime images were intentionally shared with a removed local alias. Because
`close(B,r)` removes only runtime leases created in `r`, every retained outer
mapping still names its matching active runtime fact. Therefore witness
restoration preserves the outer `WF_I` obligation.

## 6. L37: Close Equivariance

Let `zeta` be a finite sort-preserving renaming of runtime region, lease, slot,
and resource identities. Static atoms and witness-layer ownership labels are not
runtime identities and are fixed by `zeta`.

Renaming commutes with each close helper:

```text
zeta(leases_at(B,r))          = leases_at(zeta(B),zeta(r))
closable(B,r)                 iff closable(zeta(B),zeta(r))
zeta(close(B,r))              = close(zeta(B),zeta(r))
zeta(close_witness(I,rho))    = close_witness(zeta(I),rho)
```

The first equality follows because renaming preserves lease membership and
region equality. The second follows from the first plus preservation of top-stack
position and set intersection. The third follows component-wise from restriction,
edge filtering by renamed child membership, and top-stack pop. The fourth follows
because witness close selects the top layer by fixed static owner `region(rho)`,
not by a runtime image.

## 7. Executable And Checked Evidence

`model_tests.py` exercises exact local lease removal, direct-parent resumption,
unrelated-edge preservation, malformed writer-chain rejection, top-layer witness
close, outer alias preservation, and non-top witness-close rejection.

`lean/KyokaiCalculusSpot.lean` checks narrow simplified facts named:

```text
KyokaiCalculusSpot.closingChildRegionRemovesExactlyItsLeases
KyokaiCalculusSpot.closingChildRegionResumesDirectParent
KyokaiCalculusSpot.closingUnrelatedRegionPreservesSuspensionEdge
KyokaiCalculusSpot.closingLocalWitnessLayerKeepsCallerLayer
KyokaiCalculusSpot.closingLocalWitnessLayerDoesNotSearchByRuntimeImage
```

Those checked facts support this package. The paper proof itself is the prose derivation above plus its composition in `theorem-assembly.md`; the Lean facts remain narrow representation checks.
