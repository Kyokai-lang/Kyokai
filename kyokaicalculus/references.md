# Calculus References

**Status:** maintained reference list

| Source | Use |
| --- | --- |
| Wright and Felleisen, *A Syntactic Approach to Type Soundness* | Preservation and progress proof structure. https://doi.org/10.1006/inco.1994.1093 |
| Pierce, *Types and Programming Languages* | Syntax, statics, dynamics, substitution, and canonical forms presentation. https://mitpress.mit.edu/9780262162098/types-and-programming-languages/ |
| Van Horn and Might, *Abstracting Abstract Machines* | CESK-style environment, store, and continuation separation. Kyokai uses an environment-and-continuation machine so runtime linear owners remain in unique slots rather than being substituted into branch syntax. https://arxiv.org/abs/1007.4446 |
| Wadler, *Linear Types Can Change the World* | Linear context discipline. https://homepages.inf.ed.ac.uk/wadler/papers/linear/linear.pdf |
| *Oxide: The Essence of Rust* | Extracting a smaller ownership-and-borrow core from a larger systems language. https://arxiv.org/abs/1903.00982 |
| Radanne, Saffrich, and Thiemann, *Kindly Bent to Free Us* | Affe prior art for combining linear or affine resource use with shared and exclusive borrowing. Kyokai cites the borrow-model pressure without adopting Affe inference or affine discard. https://arxiv.org/abs/1908.09681 |
| Grossman et al., *Region-Based Memory Management in Cyclone* | Lexically scoped region names, live-region tracking, region-polymorphic API relationships, and the warning that region names in types are insufficient without control-flow state. https://www.cs.umd.edu/projects/cyclone/papers/cyclone-regions.pdf |
| Grossman et al., *Formal Type Soundness for Cyclone's Region System* | Prior art for separating an ergonomic surface from an explicit formal region language and for proving region safety with progress and preservation. https://www.cs.cornell.edu/projects/cyclone/papers/cyclone-regions-tr.pdf |
| Urban, Pitts, and Gabbay, *Nominal Unification* | Alpha-equivalence, freshness, and equivariance prior art for proof-critical binder reasoning. The Kyokai proof keeps source-binder alpha-equivalence separate from runtime finite renaming. https://doi.org/10.1016/j.tcs.2004.06.016 |
| Pitts, *Nominal Sets: Names and Symmetry in Computer Science* | Nominal-set treatment of names, finite permutations, freshness, and equivariance. https://www.cambridge.org/core/books/nominal-sets/6B0B7E5A0A5B8AB054CD91FE4B2C3ED1 |
| *RustBelt* | Later unsafe-library proof pressure. https://doi.org/10.1145/3158154 |
| *The Definition of Standard ML (Revised)* | A serious language definition organized around formal static and dynamic semantics. https://smlfamily.github.io/sml97-defn.pdf |
| WebAssembly Core Specification | Practical validation and execution organization. https://webassembly.github.io/spec/core/ |
| CompCert | Later backend-preservation discipline. https://compcert.org/ |
| CakeML | End-to-end compiler verification and bootstrap lessons. https://cakeml.org/ |
| Iris | Later concurrency and unsafe-boundary proof techniques. https://iris-project.org/ |
| Lean 4 | Selected proof assistant for `lambda_K-mech`. The checked artifact is pinned through Elan and built with Lake. https://lean-lang.org/ |
| Elan | Lean toolchain manager used to resolve the pinned Lean release. https://github.com/leanprover/elan |

## Notation

| Name | Meaning |
| --- | --- |
| `Delta` | Type declarations plus admitted first-order functions, checked primitives, named consuming primitives, borrow-access primitives, and attenuation relations. |
| `Rho` | Static active lexical-region atoms, static lease atoms, and suspended-parent facts. |
| `Gamma_f` | Unrestricted context. |
| `Gamma_l` | Exact-use linear-owner context. |
| `Sigma_t` | Store typing. |
| `Sigma` | Runtime store. |
| `B` | Runtime lexical regions, borrow leases, and suspended-parent state. |
| `I` | Stack of scope-owned witness layers mapping active static region and lease atoms to runtime identities with explicit checked alias authorization. |
| `phi` | Caller-visible call-instantiation witness recorded by typed elaboration and retained in core call syntax. |
| `psi` | Invocation-local callee view derived from `phi` after capture-avoiding freshening. |
| `pi` | Pre-argument runtime path certificate materialized from checker-recorded `phi` and the caller environment. |
| `Xi` | Runtime linear owner-slot store. A live slot contains one arbitrary linear runtime value. |
| `eta` | Runtime environment mapping unrestricted names to values and linear names to slots. |
| `K` | Continuation stack selecting one source-ordered evaluation path. |
| `b` | Static borrow-lease atom introduced by elaboration. |
| `beta` | Runtime borrow-lease identity. Copying a borrow token copies this identity; it does not mint a lease. |
| `ell` | Runtime owner-slot identity. Borrow leases protect slots, not duplicated syntax. |
| `a` | Runtime linear resource identity. Abstract moves transfer its unique machine carrier. |
| `binder_alpha` | Capture-avoiding alpha-equivalence for source lexical-region and declaration-local binders. |
| `fresh_step_equiv` | Same-step equivalence that fixes old identities and consistently renames only freshly minted runtime region, lease, slot, and resource identities. |

## Cross-File Index

| Subject | Definition home |
| --- | --- |
| First theorem boundary and exclusions | `scope.md` |
| Primary static judgment, contexts, types, helper predicates, and inference rules | `syntax-and-statics.md` |
| Runtime store, explicit witness `I`, owner slots, environments, continuation frames, borrow state, machine transitions, and configuration typing | `dynamics.md` |
| L1-L40 and the two main theorem skeletons | `lemmas.md` |
| Preservation/progress proof overview and worked examples | `paper-proof.md` |
| Close, layered-witness restoration, and close-equivariance derivation package | `close-and-witness-proof.md` |
| Call-entry, path-certificate, owned-argument transfer, and return-restoration derivation package | `call-entry-proof.md` |
| Primitive totality, footprint, progress, and preservation derivation package | `primitive-admission-proof.md` |
| Frame typing, pop readiness, and intrinsic TPOE carrier derivation package | `frame-typing-proof.md` |
| Source-expression, structural, borrow-use, payload, and freshness derivation package | `source-expression-proof.md` |
| Runtime finite-renaming and equivariance derivation package | `equivariance-proof.md` |
| L1-L40 route matrix and Theorem P/Q assembly record | `theorem-assembly.md` |
| Surface-to-core and later-extension routing | `surface-elaboration.md` |
| Intentional proof-only abstractions and excluded-layer differences | `deviation.md` |
| Evidence tiers and claim discipline | `claim-tiers.md` |
| Lean 4 selection, pinned toolchain, Lake command, and checked early scope | `mechanization-plan.md`, `lean/KyokaiCalculusSpot.lean` |
| Later calculus and conformance layers | `extension-roadmap.md` |
| Public research synthesis | `research.md` |
| Executable model spot checks | `model_tests.py` |
| Executable whole-machine regression slice | `machine_runner.py` |

## Stable Names

The calculus documents use these names consistently:

| Name | Required use |
| --- | --- |
| `lambda_K-seq` | First sequential formal core only. |
| `tpoe` | Defined terminal contract-failure configuration in the first core. |
| `Sigma_t` | Static store typing projection. |
| `Sigma` | Runtime resource store. |
| `Rho` | Static lexical-region and lease state. |
| `B` | Runtime lexical-region and lease state. |
| `I` | Static-to-runtime region and lease instantiation witness. |
| `Xi` | Runtime linear owner-slot store. |
| `eta` | Runtime environment. |
| `K` | Runtime continuation stack. |
| `all_reads`, `all_writes` | Every retained lease for one owner, including suspended parents. |
| `frontier_reads`, `frontier_writes` | Usable unsuspended lease frontier for one owner. |
| `unborrowed` | No retained read or write lease exists for the owner. |
| `no_writer` | No retained mutable lease exists for the owner. |
| `close` | Lexical region-end operation that removes child leases and resumes direct parents. |
| `consume[op]` | Proof-facing form for one resolved named consuming operation; never a synthesized structural destructor. |
| `result_bridge` | Call-return check that types one returned runtime value under invocation-local `psi(U)` and caller-visible `phi(U)` before restoring the caller witness. |

## Intentional Differences From Prior Art

| Prior-art pressure | Kyokai treatment |
| --- | --- |
| Linear logic rejects unrestricted weakening and contraction for resources. | `Gamma_l` has exact-use obligations. `Gamma_f` retains weakening and contraction. |
| Oxide uses a substructural account of ownership and borrowing for Rust-like lifetimes. | Kyokai uses an effect-style post-state judgment because visible exact consumption, lexical region close, and TPOE branch joins are central claims. |
| Cyclone tracks region names and live-region facts to prevent dangling pointers. | Kyokai keeps lexical region identities and non-escape checks, then adds borrow lease modes and reborrow suspension. |
| Affe combines resource sensitivity with exclusive and shared borrowing. | Kyokai cites the pressure but keeps its explicit surface and exact-use linear contract instead of adopting affine discard or inferred borrowing semantics. |
| Inherited Austral classifies write references as linear. | Kyokai classifies borrow-reference values as `Free` access tokens. Copying a token preserves one lease identity, while `Rho` and `B` enforce usable exclusive access. |
| RustBelt addresses unsafe-library semantic soundness. | `lambda_K-seq` does not claim unsafe or FFI soundness. Those obligations remain in `unsafe-ffi-boundary.md`. |
