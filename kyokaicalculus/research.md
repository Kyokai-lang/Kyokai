# `lambda_K-seq` Research Synthesis

**Status:** maintained public research map  
**Claim tier:** research synthesis for the `paper-proven` `lambda_K-seq` theorem; cited prior art supports proof architecture but does not itself prove Kyokai theorems

## Purpose

This file records why the sequential proof uses its current structure. It is a
research map, not a proof artifact; the proof artifact is `theorem-assembly.md` plus
the derivation packages it cites.

## Environment Machine And Owner Slots

Van Horn and Might derive store-allocated abstract machines from CEK/CESK structure.
The relevant lesson for Kyokai is representational: environments, stores, and
continuations keep runtime state out of duplicated source syntax. Kyokai applies that
lesson to linear owners. A branch frame stores source arms and environment references;
one live owner remains in one `Xi` slot. This avoids the invalid branch-substitution
bijection that duplicated an owner into mutually exclusive syntax.

Source: Van Horn and Might, *Abstracting Abstract Machines*.
https://arxiv.org/abs/1007.4446

## Linear Ownership And Borrowing

Wadler supplies the linear-resource pressure: unrestricted weakening and contraction
cannot apply to exact-use owners. Oxide and Affe show why a systems-language core must
state borrow availability and exclusivity rather than only ownership transfer. Kyokai
does not import Rust lifetimes, Affe inference, or affine discard. The first core keeps
`Gamma_l` exact-use, retains all lease identities in `B`, separates retained leases
from the usable frontier, and now includes explicit admitted `read_access[op]` and
`write_access[op]` nodes. This lets the theorem target borrow-use exclusivity rather
than only token lifecycle.

Sources:

- Wadler, *Linear Types Can Change the World*.
  https://homepages.inf.ed.ac.uk/wadler/papers/linear/linear.pdf
- Weiss et al., *Oxide: The Essence of Rust*.
  https://arxiv.org/abs/1903.00982
- Radanne, Saffrich, and Thiemann, *Kindly Bent to Free Us*.
  https://arxiv.org/abs/1908.09681

## Regions, Freshness, And Equivariance

Cyclone prior art separates ergonomic source programs from an explicit region model
and proves region safety with static and dynamic structure. Kyokai similarly gives
proof-facing names to anonymous surface borrow scopes. Runtime identity is separate:
static `rho` and `b` map through layered witness `I` to runtime `r` and `beta`.

The layered witness repair is required because call-formal static atoms can
intentionally view a caller runtime lease. An unscoped map plus close-by-runtime-image
can erase caller evidence. Each lexical region and call invocation now owns one
witness layer; aliases require checked authorization; close pops one owned layer.

Urban, Pitts, and Gabbay and Pitts provide nominal prior art for keeping source-binder
alpha-equivalence, freshness, finite permutations, and equivariance distinct. Kyokai
uses the separation explicitly: `binder_alpha` handles source binders;
`fresh_step_equiv` relates one-step fresh runtime choices; general equivariance applies
a finite sort-preserving runtime renaming.

Sources:

- Grossman et al., *Region-Based Memory Management in Cyclone*.
  https://www.cs.umd.edu/projects/cyclone/papers/cyclone-regions.pdf
- Grossman et al., *Formal Type Soundness for Cyclone's Region System*.
  https://www.cs.cornell.edu/projects/cyclone/papers/cyclone-regions-tr.pdf
- Urban, Pitts, and Gabbay, *Nominal Unification*.
  https://doi.org/10.1016/j.tcs.2004.06.016
- Pitts, *Nominal Sets: Names and Symmetry in Computer Science*.
  https://www.cambridge.org/core/books/nominal-sets/6B0B7E5A0A5B8AB054CD91FE4B2C3ED1

## Progress, Primitive Admission, And TPOE

Wright and Felleisen supply the preservation/progress discipline. A typed syntax rule
cannot point at a partial runtime relation and still support progress. Kyokai therefore
admits a consuming, checked, borrow-access, or attenuation primitive into `Delta` only
after a declaration-admission judgment proves its runtime relation total on admitted
typed inputs and states its invariant footprint.

TPOE is intrinsic terminal state, not a predecessor-shaped shortcut. Before a
failure transition erases continuation frames, it snapshots every owner carried only
by the current control value or evaluated frame fields into proof-facing multiset `A`.
The terminal judgment rechecks store, slot, lease-graph, witness, and terminal
owner-carrier invariants while allowing live owners to remain abandoned because no
ordinary continuation observes them. `A` is accounting evidence, not cleanup work or
resumable control.

Source: Wright and Felleisen, *A Syntactic Approach to Type Soundness*.
https://doi.org/10.1006/inco.1994.1093

## Boundary

Prior art supports proof architecture, not Kyokai-specific correctness. The closed
Gate-B paper proof is the maintained derivation over Kyokai rules in
`theorem-assembly.md` and the cited packages. Broader Lean encoding remains future
mechanization work, and the theorem still excludes concurrency, unsafe/FFI, backend
lowering, stdlib admission, and toolchain behavior.
