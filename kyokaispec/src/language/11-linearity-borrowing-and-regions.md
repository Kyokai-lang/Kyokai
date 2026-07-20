# Linearity, Borrowing, And Regions

[Rikona Kurasaki / Mjoyufull]
> ProofTrace: SPEC-LANGUAGE-11-LINEARITY-BORROWING-AND-REGIONS
> Covers: This chapter is registered in the public ProofTrace evidence graph; registration does not claim implementation, conformance, or theorem completion.

A linear value has one live ownership obligation. Moving it makes the source place unavailable. Borrowing it restricts the owner for the borrow's lifetime. Registering cleanup changes the checker state for every applicable exit path. The compiler tracks these transitions explicitly.

> Trace: D2, D6, D7b, D14, D72, D87, D187, D238-D240, D246
> Covers: Linearity and borrowing are checked after typed elaboration, including explicit nodes for admitted implicit borrow and reborrow completions.

This chapter defines the ownership state machine for local bindings, parameters, pattern bindings, temporaries, places, borrows, deferred cleanup, and movement. It is the checker contract. A compiler may use a different internal representation, but accepted programs and rejected programs must match this chapter.

> Trace: D73, D89, D143/D241, D228, D238
> Covers: The safe language has specified ownership behavior, no language-level undefined behavior, and a formal-core obligation around the sequential ownership model.

## Linearity Domain

A value is linear when its static type is in the `Linear` universe, when its static type contains a type parameter that may instantiate to `Linear`, or when a type constructor's universe rule classifies that instantiation as `Linear`. Linear checking applies before the compiler knows a generic value is safely `Free`; generic code must be written for the strongest admitted universe of the parameter.

> Trace: D24, D190/D192/D193/D195
> Covers: Linear checking follows universe classification and generic universe constraints instead of relying on concrete monomorphic luck.

A linear value must be consumed exactly once on every completing path that owns it. Consumption means moving the value into another owner, passing it to a consuming parameter, returning it by value, storing it into a place that takes ownership, sending it across an admitted ownership-transfer boundary, registering it in a consuming cleanup action, or calling an explicit consuming cleanup operation.

> Trace: D2, D89, D195, D246
> Covers: Linear ownership is exact-use ownership; cleanup is explicit source behavior, not hidden destruction.

A `Free` value may be copied, ignored, overwritten where mutation is legal, and allowed to leave scope without a consuming operation. The borrow checker may still restrict a `Free` place while it is borrowed, but `Free` values do not create exactly-once consumption obligations.

> Trace: D24, D194, D195
> Covers: `Free` classification removes linear consumption obligations while leaving ordinary borrow and mutability rules intact.

Borrow reference values of type `&[T]`, `&![T]`, `&[T, R]`, or `&![T, R]` are `Free` values. Copying a borrow reference value does not copy the referent, does not extend the region, and does not create ownership. The access represented by the borrow remains governed by its live region and aliasing state.

> Trace: D6, D14, D187
> Covers: Borrow references are non-owning access values with checker-managed aliasing and lifetime behavior.

## Checker States

For every local linear binding, field path, pattern-bound payload, and temporary owner that can own a linear value, the checker tracks one ownership state. The minimum observable ownership-state set is `Live`, `SharedBorrowed(n)`, `MutBorrowed`, `PartiallyMoved(field-set)`, `Moved`, `Consumed`, and `PendingLoopConsumption`. Deferred cleanup registration is a separate control-flow reservation fact layered over that ownership state.

> Trace: D2, D7b, D14, D187, D246, D348
> Covers: The checker uses the D348 ownership-state vocabulary and records deferred cleanup separately so cleanup registration cannot disguise ownership state.

| State | Meaning | Legal next motions | Rejected motions | Trace |
| --- | --- | --- | --- | --- |
| `Live` | The current scope owns the whole value and no conflicting borrow is active. | Move, consume, return, send, store, project a field, immutable-borrow, mutable-borrow, register `defer`, register `errdefer`. | Duplicate ownership; ordinary scope exit without discharge. | D89/D195/D348 |
| `SharedBorrowed(n)` | One or more immutable borrows are live. | Create another immutable borrow; read through admitted access; end a borrow region. | Move, consume, mutable-borrow, mutate through the owner. | D14/D187/D348 |
| `MutBorrowed` | Exactly one exclusive mutable borrow is live. | Read or write through that borrow; create an admitted nested reborrow; end the borrow region. | Move or consume the owner, create a conflicting borrow, mutate outside the borrow. | D14/D187/D348 |
| `PartiallyMoved(field-set)` | The listed fields have moved out of a composite owner. Remaining fields retain their own states. | Use remaining fields; reinitialize moved fields where the declaration and assignment rules permit reinitialization. | Use the parent as a whole before legal reinitialization; hide an unaccounted linear field. | D98/D195/D348 |
| `Moved` | Ownership transferred out of this place. | Reinitialize only where a legal assignment rule permits it. | Read, borrow, move again, consume again, register cleanup. | D89/D348 |
| `Consumed` | A consuming operation, return, surrender, or destruction operation discharged the value. | No later value use. | Any later use or second discharge. | D2/D195/D348 |
| `PendingLoopConsumption` | A loop body attempted to consume an owner created outside the loop. | Prove exactly-once consumption across every iteration and exit path. | Accept the loop when zero, one, and repeated iteration paths do not establish one discharge. | D32/D249/D348 |

Borrow creation records source binding, borrow mode, region, source span, and parent projection path. Borrow end restores the preceding `Live` or `PartiallyMoved(field-set)` state only after every derived reborrow ends. A mutable borrow temporarily suspended by a nested reborrow remains represented by the active reborrow chain; it is not a separate ownership state.

A `defer` registration reserves its captured owner for ordinary cleanup. An `errdefer` registration records an error-exit cleanup edge while leaving the success path responsible for discharge. A control-flow path ending in `return`, `break`, `continue`, `panic`, `todo`, TPOE, or `unreachable` is checked at that exit and contributes no fake normal-join state.

A compiler can split these states into finer internal states. It must not collapse them in a way that admits duplicate consumption, hidden drop, escaped borrow, conflicting alias, lost partial-move accounting, or a path-dependent cleanup hole.

> Trace: D73, D195, D238-D240, D246, D348
> Covers: Internal implementation freedom cannot weaken the observable D348 ownership state machine, borrow-chain accounting, or deferred-cleanup reservations.

## Movement

Moving a linear value transfers ownership and leaves the source in `Moved`. The source name or place remains syntactically present for diagnostics, but it no longer denotes a usable value.

> Trace: D89
> Covers: A moved-from linear place cannot be used again.

Kyokai's move model is as-if bytewise relocation. The language does not promise that the backend literally emits a byte copy, and it does not promise stable addresses for ordinary movable values. Optimizations may remove or fuse moves only when all observable ownership, borrow, layout, and backend-safety rules remain the same.

> Trace: D73, D89, D199, D228
> Covers: Move semantics are relocation semantics, not stable-address semantics, and backend lowering must preserve them without backend undefined behavior.

Moving a record, union, array, buffer, iterator, closure, task capture, capability, or owning handle follows the same rule: ownership transfers exactly once. A whole-composite move leaves the source `Moved`. An admitted field extraction, destructuring step, or record-update step can instead leave the source `PartiallyMoved(field-set)`. Each remaining field keeps its own state, and the parent cannot be used as a whole until the moved fields are legally reinitialized or the remaining fields are discharged.

> Trace: D89, D98, D195, D205-D206, D348
> Covers: Composite movement distinguishes whole-value `Moved` state from explicit field-by-field `PartiallyMoved(field-set)` accounting.

A `Free` value may be copied where the type admits copying. A `Linear` value is never copied by ordinary assignment, argument passing, return, generic dispatch, closure capture, task capture, formatting, debugging, or backend lowering. Any operation that truly duplicates a resource must be a named API with its own contract.

> Trace: D11b, D176, D228, D233
> Covers: Linear duplication is not hidden behind common expression forms or debug/profile behavior.

## Destruction And `drop;`

Kyokai has no hidden destructors. Leaving a scope does not call a type-specific cleanup operation merely because a linear value is live. If a linear value reaches ordinary scope exit still `Live` without an ordinary-cleanup reservation, or still success-live under an error-exit cleanup reservation, the program is rejected.

> Trace: D2, D195, D246, D348
> Covers: Scope exit is not implicit destruction; every linear owner must be visibly discharged.

A consuming cleanup operation is an ordinary function, method, or typeclass operation whose signature consumes the owner. `Destroyable[T]` is a manual domain cleanup contract. `Cleanable[T]` is the explicit generic container and drain cleanup contract: `Free` values satisfy it trivially without runtime action, while `Linear` values require a named consuming implementation. Neither contract runs automatically at scope exit, and the language does not synthesize structural destruction for user records or unions.

> Trace: D2, D82/D82a/D82b, D195, D246, D289-D290
> Covers: Generic cleanup is explicit static dispatch through manual contracts, never compiler-invented scope-exit destruction.

The `drop;` terminator closes a borrow scope. It does not destroy the borrowed referent and does not discharge an owning linear value. When `drop;` is reached, all borrow references whose region is that borrow scope become unusable, and the owner state resumes according to the borrow kind that ended.

> Trace: D9, D14, D111/D127, D187
> Covers: `drop;` ends borrow access only; it is not resource destruction.

`ignore` and omitted pattern subparts may discard only `Free` data. A pattern that would hide a linear payload behind `ignore`, an omitted field, or a catch-all is illegal. The program must bind that payload and visibly consume, move, return, defer, or otherwise discharge it.

> Trace: D38/D205/D206
> Covers: Pattern convenience cannot silently drop linear data.

## Regions

`&[T]` and `&![T]` are complete borrow types with anonymous scope-bounded regions. The programmer is not omitting a region argument; the anonymous region is what the common borrow type means. The compiler assigns internal region identities so it can reject escape and aliasing violations.

> Trace: D6
> Covers: Anonymous-by-default regions are source-level complete types, not hidden elision slots.

Named regions use `&[T, R]` or `&![T, R]` with an explicit `generic [R: Region]` parameter. A named region is required only when a signature must express a relationship that survives across an API boundary, such as returning a borrow tied to an input borrow.

> Trace: D6, D159/D188
> Covers: Named regions are explicit API relationships for rare escaping-borrow signatures.

A region cannot outlive the owner, temporary, or borrow scope that created it. A borrow value whose type contains an anonymous region must not be stored in a longer-lived place, returned from the function, captured by a closure or task beyond the region, placed into a global, or hidden in a container whose lifetime is not bounded by that region.

> Trace: D6, D72, D118/D197, D164/D248
> Covers: Anonymous-region borrow values are non-escaping and cannot be smuggled through storage or capture.

Named regions do not create ownership and do not permit arbitrary lifetime extension. They only name a relationship the checker can prove. If the owner or borrow source ends, moves, is destroyed, or enters a conflicting borrow state, every region derived from it ends or becomes unavailable according to the same rule.

> Trace: D6, D14, D187
> Covers: Region names express proven relationships; they do not override ownership state.

## Borrow Creation

`&read place` creates an immutable borrow when `place` is addressable and no live mutable borrow conflicts with it. Multiple immutable borrows of the same referent may coexist while the referent is not mutably borrowed and is not moved or consumed.

> Trace: D14, D72
> Covers: Immutable borrow creation requires an addressable place and rejects conflicts with mutable access or movement.

`&write place` creates a mutable borrow when `place` is mutable, addressable, uniquely available, and not live under any immutable or mutable borrow. Exactly one mutable lease lineage of a referent may be live at a time.

> Trace: D14, D72, D187
> Covers: Mutable borrowing requires unique mutable access and excludes all other live access to the same referent.

A borrow of a field, index projection, or slice projection borrows the selected place and every owner path needed to keep that projection valid. The checker must prevent mutation, movement, destruction, or container reallocation that would invalidate the borrowed projection before the region ends.

> Trace: D34, D36/D106/D132, D77, D187
> Covers: Projection borrows carry enough owner-state restriction to prevent invalid field, element, slice, and iterator access.

A static literal may be borrowed because its storage duration is part of the literal contract. An ordinary rvalue temporary may be immutably borrowed only for an immediate non-escaping use in the same statement. An ordinary rvalue temporary must not be mutably borrowed.

> Trace: D72/D213
> Covers: Temporary borrowing is statement-scoped, non-escaping, and immutable-only for rvalues.

## Reborrowing

`&reborrow borrow` creates an explicit reborrow from an existing mutable borrow. While the nested reborrow chain is live, the source mutable borrow is unavailable. The checker represents that restriction through the active reborrow chain and restores source availability only after every derived reborrow ends; it does not introduce a separate ownership state.

> Trace: D7b, D14, D187
> Covers: Reborrow creates nested temporary access and suspends the source mutable borrow.

When a call expects `&![T]` and the argument expression is already `&![T]`, the compiler may insert that same mutable reborrow automatically only through the elaboration pipeline. This is legal because the expected type leaves exactly one valid operation and the inserted node is checked like explicit `&reborrow`.

> Trace: D7b, D87, D238-D240
> Covers: Auto-reborrow is a tautological typed completion of explicit `&reborrow`, not a backend trick or unchecked aliasing exception.

When a call expects `&[T]` and the argument expression is `&![T]`, the compiler may insert a temporary immutable read reborrow of the referent. This is not subtyping, variance, or permanent weakening of the original mutable borrow. The mutable borrow is suspended while the read reborrow is live.

> Trace: D187, D238-D240
> Covers: Mutable-to-immutable use is a read reborrow with ordinary region and suspension behavior.

No implicit rule converts `&[T]` to `&![T]`, creates a borrow from a non-addressable value except the admitted immutable rvalue case, extends a temporary beyond its statement, or invents a named region relationship.

> Trace: D6, D72, D87, D187
> Covers: Borrow completion is a closed table and rejects widening, escaping, or guessed lifetime relationships.

## Control-Flow Joins

At every normal join point after `if`, `case`, `let...else`, loop bodies, and lowered sugar, the checker reconciles ownership states across all paths that can complete normally. A live linear value must have the same usable owner on every normally completing path, or the program is rejected.

> Trace: D15a, D38/D205/D206, D58/D191, D195, D238
> Covers: Branch joins merge only compatible continuing ownership states.

A path that exits through `return`, `break`, `continue`, `panic`, `todo`, or `unreachable` is checked at the exit. It does not have to provide a state for the later normal join because control does not reach that join.

> Trace: D43, D58/D191, D84, D121-D122
> Covers: Diverging and exiting paths are ownership-checked locally and do not fake normal continuation.

Inside loops, a linear value owned before the loop must not be consumed by the loop body unless the loop form's desugaring proves exactly one consumption across every possible zero-iteration, one-iteration, many-iteration, `break`, `continue`, and `return` path. Ordinary loops do not provide that proof for outside owners.

> Trace: D32/D249, D43, D195
> Covers: Repeated control flow cannot consume an outside linear owner an unknown number of times.

A linear value may be created inside a loop body. It must be discharged before each iteration path leaves the body through fallthrough, `continue`, `break`, `return`, `panic`, or lowered sugar. No iteration may depend on a previous iteration's hidden cleanup.

> Trace: D2, D32/D249, D43, D195, D246
> Covers: Loop-local linear obligations are per-iteration obligations with explicit cleanup or movement.

## `defer` And `errdefer` Reservations

A `defer` that consumes a linear value records an ordinary-cleanup reservation at the registration point. The reservation is layered over the value's D348 ownership state. The value is not consumed by ordinary execution at that moment, but it is reserved for the registered cleanup action. The checker treats duplicate consumption before scope exit as an error.

> Trace: D2, D2a, D246, D348
> Covers: Ordinary deferred cleanup reserves ownership immediately and runs later in visible LIFO order.

A value with an ordinary-cleanup reservation may be immutably borrowed, and may be mutably borrowed only if the borrow ends before the deferred action can run and the deferred action still receives the value in a valid state. A deferred value must not be moved, returned, sent, reassigned, destroyed by another action, or registered again for consuming cleanup.

> Trace: D14, D187, D246
> Covers: Reserved deferred ownership is still borrow-checkable, but cannot be stolen from the registered cleanup path.

An `errdefer` that consumes a linear value records an error-exit cleanup reservation layered over the value's D348 ownership state. On success paths, the value remains an obligation: it must be moved, returned, destroyed, deferred, or otherwise discharged before the scope completes normally.

> Trace: D2b, D227, D246, D348
> Covers: Error-only cleanup does not silently clean success paths.

If a scope exits through `or return` or `return Err(value)`, eligible `errdefer` and ordinary `defer` actions run in reverse registration order for that scope. If a scope exits through `break`, `continue`, `or break`, `or continue`, or `panic`, only ordinary `defer` actions run. If execution reaches TPOE, no user `defer` or `errdefer` action runs.

> Trace: D2a, D2b, D15a, D84, D208, D227
> Covers: Cleanup is selected by explicit exit category, with TPOE as immediate hard termination.

## Patterns And Destructuring

Pattern matching over a linear scrutinee consumes that scrutinee exactly once and transfers ownership of bound linear payloads into the selected arm. Every selected-arm path must discharge those bound payloads.

> Trace: D38/D205/D206, D98, D195
> Covers: Linear pattern matching moves ownership into explicit bindings instead of duplicating or discarding payloads.

Record destructuring must be total for the record form being destructured. If the record contains linear fields, each linear field must be bound and discharged. Partial record moves and hidden field drops are not part of Kyokai's pattern semantics.

> Trace: D35, D98, D206
> Covers: Record destructuring cannot leave linear fields behind in an unclassified state.

A `case` over a union must be exhaustive. Exhaustiveness is checked structurally, including nested patterns. A catch-all shape cannot hide possible linear payloads; linear alternatives must expose the payload names needed for ownership checking.

> Trace: D38/D205/D206
> Covers: Exhaustive matching remains ownership-visible for nested union payloads.

## Closures, Generators, And Tasks

A closure literal captures only what its explicit capture list names. Capturing a linear value by value moves it into the closure environment and normally makes the closure `CallableOnce`. Capturing a mutable borrow, or mutably using a by-value capture, selects `CallableMut`. Remaining captures select `CallableRead`.

> Trace: D118/D126/D197
> Covers: Closure environment ownership is explicit and determines the callable family statically.

A closure must not capture an anonymous-region borrow if the closure can outlive that region. A closure that stores, returns, or transfers a borrow must use a named region relationship admitted by the signature and still obey the owner-state rules.

> Trace: D6, D72, D118/D197
> Covers: Closure capture cannot extend borrow lifetimes by hiding them in an environment.

A generator is a named linear iterator type. Its suspended state owns whatever linear values remain live across `yield`, and its destroy operation must consume that suspended state exactly once. A generator must not suspend with live borrows that outlive their region.

> Trace: D198, D249
> Covers: Generator suspension is linear state, not a hidden coroutine runtime with erased ownership.

A `spawn` capture list moves owned captures by value or takes admitted shared captures by immutable borrow. Mutable-borrow capture is illegal. A borrowed task capture remains live until the child completes at the enclosing `join;`, and the parent cannot use the borrowed owner in a conflicting way during that interval.

> Trace: D88/D235/D252, D164/D248
> Covers: Task capture is explicit, structured, and checked through the parent-child lifetime ending at `join;`.

## Iterators And Containers

`for Pattern in expr do ... od;` owns or borrows the iterator state defined by the iterator protocol. If the iterator state is linear, the desugaring must consume that state exactly once on every loop exit path, including natural exhaustion, `break`, `continue`, `return`, `or return`, `or break`, `or continue`, and `panic` where ordinary cleanup runs.

> Trace: D32/D249, D2b, D246
> Covers: Linear iterators remain legal because loop lowering owns cleanup on every admitted exit path.

Each yielded item follows ordinary pattern and linearity rules. A yielded linear item must be bound and consumed on that iteration path. A yielded borrowed item cannot escape the region tied to the iterator or container borrow.

> Trace: D38/D205/D206, D195, D249
> Covers: Iteration does not relax item ownership or borrow escape rules.

Safe collection APIs return element borrows or iterator values whose regions are tied to the container borrow. While such a borrow or iterator is live, mutating operations that could reallocate, remove, reorder, or otherwise invalidate the selected storage are rejected unless the container API specifies a stronger stable-address contract.

> Trace: D77, D85, D187
> Covers: Container invalidation is mostly statically prevented and otherwise must be specified per container contract.

Raw addresses, pointer-like values, and unsafe container internals do not weaken safe borrow rules. If an unsafe implementation exposes safe APIs, the safe API contract must preserve the same no-dangling, no-conflicting-access, and no-hidden-drop guarantees.

> Trace: D20/D20a/D20b, D73, D77, D245
> Covers: Unsafe internals may implement containers, but safe surfaces must keep Kyokai ownership guarantees.

## Pinning And Self-Reference

Ordinary safe Kyokai values are movable unless their type declares otherwise. Because ordinary moves are relocation, safe code must not construct self-referential values that depend on an internal address staying stable after movement.

> Trace: D89, D89a
> Covers: Safe self-reference is rejected under ordinary movable value semantics.

`Box[T]` provides ordinary heap indirection but does not by itself make `T` non-movable. Moving a `Box[T]` moves the owning handle; the allocation may remain at a stable address, but generic code cannot assume pinned semantics unless the API and type contract say so.

> Trace: D89a/D89b
> Covers: Heap indirection and first-class pinning are separate contracts.

A `pinned` type declaration and `PinBox[T]` provide the admitted stable-address boundary. Once initialized behind the pinning owner, a pinned value must not be moved by safe code. Generic containers, algorithms, and returns that relocate elements must require a `Movable` capability, bound, or contract and must reject pinned values unless they provide a pin-preserving representation.

> Trace: D89b, D82/D82a/D82b
> Covers: Non-movability is declaration-site visible and generic relocation must be explicit.

Pinning does not disable borrowing, destruction, capability rules, or unsafe-contract obligations. It only forbids relocation through safe movement. A pinned value still must be destroyed exactly once through an explicit path admitted by its API.

> Trace: D2, D89b, D195, D245
> Covers: Stable address is not a license to hide cleanup or bypass ownership checking.

## Diagnostics And Conformance

A linearity error must report the owner, the state it is in, the operation that caused that state, and the later operation or scope exit that made the program invalid. For branch and loop errors, diagnostics must identify the divergent ownership states across paths.

> Trace: D29, D216, D240
> Covers: Ownership diagnostics must explain the state transition and path conflict, not only say that linearity failed.

The conformance suite must include positive and negative tests for move-after-move, missing consumption, duplicate destruction, branch-state mismatch, loop consumption of outside owners, `ignore` over linear payloads, anonymous borrow escape, named-region returns, mutable alias rejection, read-reborrow suspension, auto-reborrow elaboration, rvalue borrow limits, deferred duplicate consumption, errdefer success-path obligations, linear iterator early exit, closure capture movement, task borrow capture until `join;`, container invalidation, and pinned-value relocation rejection.

> Trace: D6, D7b, D14, D72, D87, D187, D197, D205-D206, D238-D240, D246, D249
> Covers: These rules require explicit conformance coverage across ownership, borrow, cleanup, and escape boundaries.

## Read-Only Access And Explicit Bundles

Observation of a linear owner uses `&[T]`; mutation uses `&![T]`. Observation returns computed results and does not consume and return the owner merely to permit reading. Allocator, logger, clock, random, filesystem, network, terminal, process, audit, and cancellation surfaces are passed as explicit values or explicit nominal bundles. A bundle is ordinary source-visible data. It creates no ambient lookup, injected parameter, hidden capability minting, or hidden allocation. Public APIs take the narrowest authority surface that satisfies the operation.

> Trace: D398, D492
> Covers: Immutable observation avoids ownership tuple-juggling, and nominal bundles improve ergonomics without hidden context passing or overbroad authority.

## Reborrow Suspension Across Joins

A mutable reborrow suspends its source mutable borrow until the reborrow ends. Across a control-flow join, the checker resumes the source only when every non-diverging arm ends the reborrow with compatible state. A rejected join reports the suspension source, each branch state, and the incompatible live path. Tooling can suggest explicit scope narrowing or pass-through records, but it cannot insert a hidden state transition.

> Trace: D459, D495
> Covers: Reborrow resumption is checker-visible at control-flow joins and diagnostics expose the exact mismatching path.

## Task Transfer Is Field-Visible Movement

Task transfer rejects isolate-style object-graph packaging. Moving a value into a task follows its declared transfer classification field by field. No deep copy, hidden serialization, hidden allocator, implicit ownership island, or alternate package artifact is created. A borrow captured by a task remains live until the structured join proves the task ended.

> Trace: D168, D248, D468
> Covers: Task movement preserves ordinary linearity and borrowing instead of creating a second isolation mechanism.

## Graph Owners And Hole-Free Collections

Safe graph structures use linear owners plus nominal handles, generation-checked keys, region-bound borrows, or audited pinned intrusive internals. A safe handle is not a raw integer. Lookup returns a declared failure for missing, stale, wrong-owner, removed, or wrong-generation handles.

Safe collection indexing never moves a linear element out by value. Named extraction operations preserve initialized storage invariants: `pop`, `removeAt`, `swapRemoveAt`, `replaceAt`, `takeOnly`, `drain`, `intoIter`, or an admitted domain-specific equivalent. A drain or consuming iterator that retains linear elements is linear and must be exhausted or finalized explicitly.

| Situation | Legal source shape | Rejected shape |
| --- | --- | --- |
| Observe linear owner | Pass `&[T]`. | Consume and return ownership solely to read. |
| Mutate owner | Pass `&![T]` under exclusive borrow scope. | Hidden shared mutation. |
| Reborrow across branch | End with compatible state in every non-diverging arm. | Resume source while a path retains reborrow. |
| Move collection element | Use invariant-preserving named extraction. | Safe indexing that leaves a hole. |
| Graph reference | Use owner-checked nominal handle or borrow. | Raw integer key presented as safe handle. |
| Task transfer | Move transfer-admitted fields explicitly. | Hidden isolation package or deep copy. |

> Trace: D374, D384, D463, D490, D496-D497
> Covers: Safe graphs, slot maps, hole-free collection extraction, drain obligations, and generic universe rules preserve exactly-once ownership.

## Early Release And Tooling

A resource type exposes a named consuming release operation or an accepted `defer` cleanup path. Code shortens resource lifetimes with lexical scopes, explicit release, ownership transfer, or `defer` inside the smallest owning scope. Compiler-integrated diagnostics report resources acquired long before cleanup registration, `defer` inside long-running loops, guards held across blocking or concurrency boundaries, nested locks without declared order, and large storage retained across unrelated blocking work. These reports do not claim deadlock freedom.

> Trace: D498
> Covers: Resource-release tooling points at visible ownership lifetimes and never changes legality or inserts hidden cleanup.

## Mutable-Borrow Lease Lineage

Copying a mutable-borrow token copies a value that refers to one
compiler-tracked lease lineage. It does not create a second lease or independent
write permission. A token can be used only while its lineage is live, its
writer is active rather than suspended, and no incompatible child reborrow is
active.

`&reborrow token` creates a child in the same lineage and suspends every parent
alias. Closing the child resumes the parent lineage once. Discarding one token
alias does not close the lease; lexical close invalidates every alias. A
suspended alias remains a value but cannot read, write, reborrow, escape, or be
used as proof of active access.

`T: Free`, copies, captures, calls, returns, storage, and `.koi` preserve the
region and lineage obligation. `Free` permits copying the token value; it does
not erase borrow state. Tokens cannot be serialized, compared for semantic
identity, stored beyond their region, transferred incompatibly, or returned
across region close. Checked IR keeps token-value identity separate from
lease-lineage identity.

> Trace: D559
> Covers: Mutable-borrow token copies share one lease, reborrows suspend the lineage, and `Free` never converts a borrow token into independent authority.

## Shared-Lifetime Pattern Family

General reference counting is absent. The admitted shared-lifetime patterns
are scoped borrows, arena-owned graphs, generational slot maps, stable handles,
owner/handle/view registries, broker-owned state, and separately admitted
synchronized structures. Each pattern specifies invalidation, stale identity,
cycle behavior, removal ownership, task transfer, failure, and shutdown. No
pattern implicitly extends a lifetime or creates general shared ownership.

The tooling chapter defines `kyokai explain ownership-pattern`. Its output is
advice over these accepted patterns; it does not run code, rewrite source,
obtain authority, or invent ownership inference.

> Trace: D599
> Covers: Shared-lifetime problems use explicit owners and handles without reopening general reference counting.
