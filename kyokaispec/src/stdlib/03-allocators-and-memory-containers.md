# Allocators, Memory, And Containers

[Rikona Kurasaki / Mjoyufull]
Memory APIs are where a systems standard library either earns trust or starts lying. Kyokai makes the allocator visible, the failure visible, and the lifetime of stored values visible.

> Trace: D44, D74, D77, D201, D250-D251
> Covers: Allocation and container APIs use explicit allocator identity, explicit failure, and explicit invalidation contracts.

## Allocator Model

`Allocator` is an ordinary runtime value chosen explicitly by source code. There is no hidden default allocator, ambient thread-local allocator, lexical allocator context, or allocator type parameter machinery. APIs that allocate fresh owned storage take an allocator or use allocator identity already stored by the container.

> Trace: D44, D130, D201, D250-D251
> Covers: Allocator choice is explicit runtime state and not a hidden generic dictionary or ambient default.

Low-level allocator operations return `Result[..., AllocError]` for valid allocation requests that cannot be satisfied. Invalid size, alignment, layout, or allocator state is a contract violation unless the specific low-level API says it reports that case as data.

> Trace: D53, D74
> Covers: Allocation failure and invalid allocation requests are distinct failure categories.

Zero-sized allocation requests are legal. They return a stable non-null token suitable for later deallocation with the same allocator/layout contract, but not for ordinary dereference. Reallocation failure leaves the original allocation valid, owned by the caller, and unchanged.

> Trace: D74
> Covers: Zero-sized allocation and reallocation failure semantics are explicit.

| API Family | Ownership | Allocation | Failure | Capabilities | Tests | Trace |
| --- | --- | --- | --- | --- | --- | --- |
| `allocate`/`deallocate` | Allocator mutably borrowed; returned block is linear owned storage. | Direct allocator operation. | `AllocError`; invalid layout is TPOE. | None for ordinary heap; OS-backed allocators state authority separately. | zero-size, alignment, OOM, double-free compile/runtime boundary. | D44, D74 |
| `reallocate` | Old allocation remains owned until success transfers ownership to new block. | Direct allocator operation. | `AllocError` leaves old block valid. | Same as allocator. | growth, shrink, fail-preserves-old. | D74 |
| `must*` allocation helpers | Same as underlying operation. | Same as underlying operation. | OOM is named runtime-fatal behavior. | Same as underlying operation. | fatal path and naming diagnostics. | D74, D84 |

> Trace: D44, D74, D84, D85
> Covers: Allocator APIs state ownership, allocation, failure, authority, and tests.

## Core Containers

`Array[T, N]` is fixed-size inline storage with `N: Index`. `Span[T]` and byte/text views are non-owning borrowed views. `Buffer[T]` is growable owned storage that stores allocator identity because its admitted operations reallocate or destroy allocated storage.

> Trace: D55, D77, D201
> Covers: Fixed arrays, spans, and buffers have distinct ownership and allocation contracts.

A container that stores linear elements is itself linear unless a closed built-in rule says otherwise. Destroying or clearing a container with linear elements must consume or return every element according to the API contract. No container silently drops linear payloads.

> Trace: D77, D146, D205-D206
> Covers: Containers preserve linear element obligations.

Mutation whose contract permits reallocation or reordering requires a mutable borrow of the container. Live element borrows, iterators, cursors, spans, or raw unsafe addresses are invalidated according to the container contract. Safe APIs must let the borrow checker reject common invalidation; remaining unsafe raw-address cases are documented per container.

> Trace: D77, D85
> Covers: Container invalidation is part of the public API contract.

| Container | Ownership | Allocation | Failure | Invalidation | Concurrency | Trace |
| --- | --- | --- | --- | --- | --- | --- |
| `Array[T, N]` | Owns `N` inline elements. | None after construction. | Construction failure only from element construction. | Inline borrows follow ordinary borrow rules. | Transfer follows element/task rules. | D55, D77 |
| `Span[T]` | Non-owning borrow view. | None. | Bounds TPOE for checked indexing. | Ends with borrow region; cannot outlive owner. | Not shareable beyond borrow rules. | D6, D77 |
| `Buffer[T]` | Owns elements and stored allocator identity. | Grows with stored allocator. | `AllocError` on growth; fatal variants named. | Reallocation invalidates views/raw addresses; mutable borrow excludes live views. | Linear unless synchronized wrapper says otherwise. | D44, D74, D77, D201 |
| `Box[T]` | Owns separately allocated `T`. | Allocates on construction, deallocates on destroy. | `AllocError`; moving box does not move pointee storage. | Borrowed pointee follows ordinary borrow rules. | Transfer follows `T` rules. | D44, D74, D89a-D89b |
| `PinBox[T]` | Owns stable-address pinned `T`. | Allocates in final pointee storage. | `AllocError`; no safe by-value extraction. | Pointee never relocates through safe API. | Transfer follows pinned/task rules. | D89b |

> Trace: D6, D44, D55, D74, D77, D89a-D89b, D201
> Covers: Core containers state ownership, allocation, failure, invalidation, concurrency, and pinned behavior.

## Naming And Allocation Effects

In-place mutation uses stored allocator identity. View operations allocate nothing and use `as*` names. Fresh owned results require an explicit destination allocator and use `to*In`, `cloneIn`, `collectIn`, or another `...In` name. Consuming conversions that reuse storage use `into*`; consuming conversions that allocate fresh destination storage use `into*In`.

> Trace: D11b, D201
> Covers: Container API names expose allocation and ownership effects.

## Why This Shape

[Rikona Kurasaki / Mjoyufull]
A hidden allocator is a hidden policy decision. A silent reallocation is a hidden invalidation. A dropped linear element is a broken promise. Kyokai containers make those promises public, because memory is not background scenery in systems code.

> Trace: D44, D74, D77, D201
> Covers: Kyokai memory containers expose allocator, ownership, and invalidation behavior directly.

## Ownership-Indexed Graphs, Builders, And Hole-Free Storage

Safe graph-like structures use a linear owner. Arena-owned graphs, generational slot maps, pinned intrusive collections, owner-record state machines, and domain registries expose `Free` nominal handles or region-bound borrows rather than ambient shared ownership. A safe handle is not a raw integer. Checked lookup returns a declared error for missing, stale, wrong-owner, removed, or wrong-generation handles.

Slot reuse increments generation identity under the container's documented width and wrap policy. Removing a node with linear payload returns the payload and incident linear resources, consumes them through a named teardown operation, or rejects the removal until dependencies are resolved. Pinned intrusive structures keep their pointer invariants inside audited unsafe internals.

Safe indexing never moves a linear element out of an initialized slot. Movement uses invariant-preserving names such as `pop`, `removeAt`, `swapRemoveAt`, `replaceAt`, `takeOnly`, `drain`, and `intoIter`. `replaceAt` returns the old value after installing the new value. `removeAt` preserves order and reports shifting complexity. `swapRemoveAt` permits reordering and states that effect. Unsafe storage internals track holes only behind initialized-length and capacity invariants.

Transactional construction uses `begin`, step operations, `commit`, and `abort`. A failed `commit` returns a nominal recovery payload when ownership leaves the builder. `abort` consumes the builder and performs the documented recovery path. Generic `Auto` containers are `Free` exactly when every stored field and element is `Free`; otherwise they are `Linear`.

| Family | Owner | External Reference | Removal Rule | Required Failure Surface |
| --- | --- | --- | --- | --- |
| Generational slot map | Linear slot-map owner. | Free nominal `(slot, generation)` handle. | Invalidate old generation and return or consume payload. | Stale, missing, wrong-owner, removed, wrong-generation. |
| Arena graph | Linear arena owner. | Free nominal handle or region borrow. | Resolve incident owned resources explicitly. | Missing, stale, dependency-live. |
| Pinned intrusive collection | Linear pinned owner. | Region borrow or admitted handle. | Preserve pinning; audited unsafe internals only. | Contract violation or declared lookup error, never backend UB. |
| Transactional builder | Linear builder state. | No externally usable partial value. | `commit` or consuming `abort`. | Named recovery payload. |

> Trace: D374, D463, D490-D491, D496-D497
> Covers: Graphs, slot maps, transactional builders, hole-free extraction, pinning, and universe-aware containers preserve linear ownership without ambient sharing.
