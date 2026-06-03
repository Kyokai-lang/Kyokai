# `lambda_K-seq` Scope Freeze

**Status:** `paper-proven` scope freeze  
**Proof artifact:** `theorem-assembly.md` plus the maintained derivation packages  
**Gate:** K-A closed by this document  
**Owner:** Kyokai calculus track

## 1. The First Theorem Claim

`lambda_K-seq` is the sequential proof core for Kyokai. A well-typed closed
`lambda_K-seq` configuration either is a value, takes a semantic step, or is
in the defined terminal state `tpoe`. It does not get stuck because of
duplicate linear ownership, silent loss of a live linear owner on ordinary
completion, use after move or named consumption, conflicting usable borrow access, access through a suspended token, borrow escape,
forged capability values, or an undefined admitted primitive relation.

This theorem statement is `paper-proven` by `theorem-assembly.md` for the narrow
`lambda_K-seq` boundary. It is not `mechanically-proven`; the Lean artifact remains
a narrow set of representation theorems.

## 2. Scope Decisions

The first proof uses these exact choices. `deviation.md` records valid proof-only
abstractions that intentionally differ from the normative surface without
changing accepted language behavior.

| Question | `lambda_K-seq` choice | Reason |
| --- | --- | --- |
| Borrow regions | Core terms open and end lexical region frames explicitly. Every elaborated borrow carries a static region atom and lease atom; runtime witness `I` maps them to fresh runtime identities. | Borrow end must be a reduction rule, not prose. Surface anonymous regions elaborate to proof-facing atoms without gaining source-level region arguments. |
| Named consumption | `consume[op] x` represents one already-resolved named consuming operation. There is no universal structural destructor. | Normative Kyokai cleanup is visible and named. Linear sums require explicit destructuring unless an independently admitted named operation exists. |
| Reborrow | Explicit core `reborrow` and `read_reborrow` terms suspend the parent mutable borrow until the nested region ends. | Kyokai auto-reborrow is checked over an explicit elaborated node. |
| Deferred cleanup | `defer` and `errdefer` are excluded from `lambda_K-seq` and owned by `lambda_K-cleanup`. | Cleanup exit categories are substantial enough to prove separately. The first no-drop corollary covers ordinary core completion only. |
| Integers | One abstract checked integer domain `IntK` with explicit primitive checks. | Width-specific representation and backend lowering are later preservation obligations. |
| Sum data | Minimal sums, `Optional[T]`, and `Result[T, E]` are included. | They expose branch joins, linear payload movement, and structured error-value flow without importing the full record/union surface. |
| Patterns | Minimal constructor patterns and exhaustive `case` are included. | Linear payload transfer and branch-state compatibility need an explicit core form. |
| `panic` | Excluded from the first theorem. | `panic` has cleanup behavior in full Kyokai. `lambda_K-seq` models `tpoe`, not cleanup-running abnormal exit. |
| Capabilities | Abstract sealed linear capability values and explicit primitive attenuation are included. | The first core proves source-level non-forgery without importing OS APIs. |

## 3. Included Core

`lambda_K-seq` includes:

- `Free` and `Linear` universes;
- an unrestricted context and an exact-use linear context;
- first-order functions, local binding, sequencing, and deterministic
  left-to-right evaluation;
- linear owners supplied by the initial runtime configuration, explicit move,
  and visible named consuming operations;
- immutable borrow, mutable borrow, mutable reborrow, read reborrow, lexical
  region opening, lexical region ending, and named borrow-token read/write access;
- `Unit`, `Bool`, `IntK`, abstract linear `Resource`, and abstract sealed
  linear `Capability`;
- minimal sums, `Optional[T]`, `Result[T, E]`, constructor patterns, exhaustive
  `case`, and branch-state joins;
- checked integer primitives and explicit contract-check terms;
- `tpoe` as a defined terminal state;
- primitive capability attenuation that can derive narrower authority from an
  existing capability but cannot manufacture authority from ordinary bits.

Borrow values are non-owning access tokens. They can be copied as values only
while their region remains active. Copying a borrow token does not copy the
referent, extend the region, or create ownership.

## 4. Excluded Surface And Runtime Areas

Exclusion means the first theorem makes no claim about the excluded area. Each
area has an explicit owner.

| Excluded group | Treatment | Owner |
| --- | --- | --- |
| UFCS, auto-borrow, auto-reborrow, read reborrow insertion, implicit `Unit`, contracts, `old`, `let...else`, `or return`, checked source arithmetic, branch joins, and `build` | Elaborates into explicit core nodes or an explicit later initialization-state model. | `surface-elaboration.md` |
| `defer`, `errdefer`, `panic`, loop-exit cleanup, and cleanup ordering | Extends the core. | `extension-roadmap.md`, layer `lambda_K-cleanup` |
| Rich records, unions, arrays, const generics, closures, generators, iterators, typeclasses, instances, monomorphization, layout, pinning, and direct result placement | Extends the core. | `extension-roadmap.md` |
| Tasks, channels, atomics, locks, pollers, signals, cancellation, and happens-before | Separate formal model. | `concurrency-model.md`, layer `lambda_K-conc` |
| Unsafe contracts, raw pointers, FFI, ABI, dynamic loading, volatile/MMIO, inline assembly, and foreign callbacks | Contract boundary and later model. | `unsafe-ffi-boundary.md`, layer `lambda_K-unsafe` |
| C lowering, LLVM lowering, target objects, link steps, stack guards, and debug mapping | Preservation boundary. | `backend-preservation.md`, layer `lambda_K-backend` |
| Allocators, concrete heap storage, standard-library algorithms, formatting, text, I/O, math, crypto, and OS handles | Admission and evidence boundary. | `stdlib-contract-model.md`, layer `lambda_K-stdlib` |
| Modules, packages, imports, visibility, `.kyo`, `.kai`, `.koi`, manifests, lockfiles, build graphs, diagnostics, formatter, docs, Analysis Server, package index, and release behavior | Conformance model. | `toolchain-and-artifact-contracts.md`, layer `lambda_K-toolchain` |
| Website, service deployment, repository topology, showcase, and community surfaces | Operational records outside metatheory. | public workflow and service records |

## 5. Failure Boundary

`tpoe<q,Sigma,B,I,Xi,A>` is a defined terminal configuration. It is not stuck
execution and it does not run cleanup in `lambda_K-seq`. Proof-facing snapshot `A`
accounts for owner carriers erased with the ordinary continuation; it is not
observable state, cleanup work, or resumable control. A checked operation has its ordinary
static result type even when evaluation can reach `tpoe`. Possible runtime
TPOE is not static `Never`.

`panic` and runtime-fatal termination are excluded. Full Kyokai distinguishes
them from TPOE, and later layers must preserve those distinctions.

## 6. Cleanup Claim Boundary

The first no-drop corollary is deliberately narrow:

> A normally completing closed `lambda_K-seq` term cannot leave a live linear
> obligation undischarged.

It does not claim that `defer`, `errdefer`, `panic`, `break`, `continue`, or
structured error propagation have already been proven. `lambda_K-cleanup`
owns those paths and must prove their source-ordered cleanup selection and
LIFO execution rules before Kyokai claims proof coverage for them.

## 7. Surface/Core Rule

No Kyokai surface form becomes proof-covered merely because a similar core
term exists. `surface-elaboration.md` must name the elaboration, the inserted
node, its effect bound, and the conformance obligation. A surface feature that
needs new semantics is an extension, not elaboration.

## 8. Scope Closure Record

Gate K-A is closed. The scope decisions above remove the representation
questions that blocked syntax and statics drafting. Formal-core statics,
dynamics, a lemma inventory, derivation packages, and Theorem P/Q paper proof now
exist. The runtime model uses environments, owner slots, and continuation frames so
branch selection never duplicates runtime owners through substitution. Gate B is
closed for the `lambda_K-seq` paper theorem. Explicit call syntax retains
caller-visible `phi`, invocation freshening derives callee-local `psi`, and
`result_bridge` checks returned borrows before the caller witness is restored. The
checked Lean spot artifact covers selected repair facts only; it does not mechanically
prove the first theorem.
