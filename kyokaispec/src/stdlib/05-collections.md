# Collections

[Rikona Kurasaki / Mjoyufull]
A collection is not just a clever box. It owns values, borrows values, moves values, can allocate, can reorder, can invalidate, and can make performance promises people build whole systems on. Kyokai writes those promises down.

> Trace: D44, D77, D85, D176-D177, D201, D229
> Covers: Public collection APIs require explicit ownership, allocator, invalidation, equality/hash/order, and testing contracts.

## Collection Admission

Stable `Kyokai.Collections` modules include only collections with written semantic contracts, allocator behavior, invalidation behavior, complexity bounds, and property tests. Compatibility collections are permitted for migration or legacy data structures and live in named compatibility modules. Every stable collection admission record states why the collection belongs in the batteries-included surface; compatibility collections are never presented as the default.

> Trace: D85, D152, D220, D229, D243
> Covers: Collections enter the stdlib through the same admission process as other API families.

Kyokai has no general `Cloneable` or `Default` requirement. Collection APIs cannot fabricate elements, duplicate arbitrary elements, or discard linear elements through a generic bound that does not actually exist. Duplication and default construction stay type-specific and explicit.

> Trace: D176-D177
> Covers: Generic collection design does not smuggle in universal clone/default semantics.

## Core Collection Families

The admitted baseline families are sequence buffers, maps, sets, queues/deques, priority queues, and sorting/search helpers. More specialized structures require their own admission records.

> Trace: D152, D229
> Covers: Collection families are broad enough for systems programming but not open-ended folklore.

| API Family | Ownership | Allocation | Failure | Linearity | Invalidation | Determinism | Tests | Trace |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Sequence buffers | Own elements in indexed order. | Construction/growth uses explicit or stored allocator. | `AllocError`; checked index violations are TPOE. | Linear if element storage is linear. | Growth/reorder invalidates views by contract. | Preserves insertion order unless named operation reorders. | boundary, allocation failure, invalidation, linear cleanup. | D44, D74, D77, D201 |
| Maps | Own key/value pairs. | Construction takes allocator; mutation uses stored allocator. | `AllocError`; lookup absence returns `Optional`. | Linear when key or value is linear. | Rehash/removal invalidates stated cursors/views. | Iteration order is stable, insertion-ordered, sorted, or specified-nondeterministic per run by contract. | property tests against reference model, hash collision tests. | D77, D83, D176-D177, D229 |
| Sets | Own values as keys. | Same as maps. | `AllocError`; membership absence is data. | Linear when elements are linear. | Same as map family. | Same order rule as backing set contract. | algebraic set properties, collision tests. | D77, D83, D229 |
| Queues/deques | Own elements in removal order. | Construction/growth uses allocator contract. | `AllocError`; pop empty returns `Optional`. | Linear if elements are linear; `clear` must consume or return all elements. | Growth invalidates views; cursors documented. | FIFO/deque order is deterministic. | sequence-model properties, wraparound, allocation failure. | D77, D146, D201 |
| Priority queues | Own elements ordered by comparator. | Construction/growth uses allocator contract. | `AllocError`; pop empty returns `Optional`. | Linear if elements are linear. | Mutation invalidates heap views. | Equal-priority order is fixed or specified-nondeterministic. | heap invariant, comparator edge cases. | D77, D85, D229 |
| Sorting/search helpers | Borrow or mutably borrow ranges; consuming variants named. | In-place variants state scratch allocation; fresh results take allocator. | `AllocError` for allocating algorithms; comparator failure only if signature exposes it. | Must not duplicate or drop linear elements. | Mutable range borrow excludes live element borrows. | Stability and ordering semantics stated per function. | permutation, ordering, stability, adversarial comparator tests. | D77, D85, D201 |

> Trace: D44, D74, D77, D83, D85, D146, D176-D177, D201, D220, D229
> Covers: Collection API families publish ownership, allocation, failure, linearity, invalidation, determinism, and test contracts.

## Equality, Hashing, And Ordering

Collections that compare, hash, or order elements must name the required protocol. Equality and ordering callbacks are pure unless their type explicitly accepts capabilities. Hashing must state seed behavior and reproducibility behavior. A deterministic build or test mode requires explicit seed injection when the collection contract selects that lane rather than ambient process randomness.

> Trace: D83, D85, D229
> Covers: Collection determinism and hash seeding are part of the public contract.

Hash maps and hash sets must define behavior under collisions. Collision handling cannot introduce memory unsafety, cannot drop linear values, and cannot turn lookup absence into fatal behavior. Denial-of-service resistance, reproducible iteration, and deterministic tests are separate contract fields, not guesses.

> Trace: D73, D77, D83, D85
> Covers: Hash collection collision behavior is specified and tested.

A collection that stores `TextView[R]` keys is region-bound by the borrowed key storage. Its admission record states the owning source region, equality algorithm, hash algorithm, normalization policy, invalidation conditions, and the rule that the collection cannot outlive `R`. A collection that needs independent key lifetime stores owning `String` keys or copies text into allocator-backed storage explicitly.

> Trace: D77, D372, D401
> Covers: Borrowed text keys never become hidden owning strings or outlive their source storage.

## Linear Elements

When a collection owns linear elements, all removal, replacement, drain, retain, clear, destroy, and error paths must consume, return, or keep each element exactly once. An API that discards buffered linear elements is rejected unless it is restricted to `Free` elements or exposes an explicit drain/destruction contract.

> Trace: D77, D146, D205-D206
> Covers: Collections preserve exactly-once linear ownership obligations.

Bulk operations over linear elements use callbacks or receiver functions that state what happens if the callback fails, panics, or terminates early. The remaining collection state after early exit is part of the contract.

> Trace: D77, D84, D85
> Covers: Collection callback APIs state cleanup and remaining-state behavior.

## Examples And Tests

Each stable collection module includes examples for construction, lookup, iteration, mutation during borrowed views, removal, drain, allocation failure, and linear payload handling. A collection that does not expose insertion, removal, drain, allocation, or linear payload storage writes `N/A` for that row in its admission record. Property tests compare against a simple reference model for every data structure with algebraic behavior.

> Trace: D220, D229
> Covers: Collection examples and property tests are required admission evidence.

## Hash Collection Seed Lanes

Every hash-map and hash-set constructor selects exactly one seed lane. A public API name, constructor parameter, or concrete collection type makes that lane visible.

| Seed lane | Construction rule | Stable visible order | Admitted use |
| --- | --- | --- | --- |
| Randomized | Constructor receives an admitted random source or seed derived through explicit entropy authority. | No. Iteration order is specified nondeterminism within the collection contract. | Adversarial-input services and ordinary in-memory use that wants collision resistance. |
| Deterministic explicit seed | Constructor receives a caller-selected seed value. | Only when the collection contract explicitly promises it. | Reproducible tests, controlled tools, and replay. |
| Deterministic fixed policy | Concrete type or constructor fixes a documented seed and hash policy. | Only when the collection contract explicitly promises it. | Lockfiles, `.koi`, package metadata, docs JSON, generated artifacts, and deterministic tools. |
| User-supplied hasher | Constructor receives an admitted hasher policy value. | Defined by the concrete collection contract. | Specialized domains with a reviewed hashing policy. |

A hash collection never reads entropy, wall time, monotonic time, PID, thread identity, address bits, environment state, or host process state implicitly. A default constructor either names a deterministic policy or requires the explicit randomized source lane. Build artifacts, docs JSON, `.koi`, lockfiles, package metadata, audit reports, and spec examples cannot depend on randomized hash iteration.

> Trace: D401, D421, D484
> Covers: Hash seeding, entropy use, deterministic artifacts, and iteration-order nondeterminism are separate explicit contract fields.

## Universe-Specific Collection Operations

Generic collection operations are admitted by element universe. Borrowing lookup works for every admitted element type. Copying lookup exists only when the element is `Free`. Moving extraction exists only through an invariant-preserving named API. Clearing without returning values exists only for `Free` elements or through a consuming destroy operation that accounts for every element.

| Operation family | `Free` elements | `Linear` elements | Order and failure contract |
| --- | --- | --- | --- |
| Indexed or keyed lookup | Borrow; copy only when the named API promises copying. | Borrow only. | Bounds failure or absence uses the collection's written contract. |
| `replaceAt` or keyed replacement | Return the old value after installing the replacement. | Return the old value after installing the replacement. | Storage remains initialized throughout the operation. |
| `removeAt` | Return removed value. | Return removed value. | Preserves order and documents shifting complexity. |
| `swapRemoveAt` | Return removed value. | Return removed value. | Permits reordering and documents that fact. |
| `clear` | Discard is legal when the API says so. | Rejected. | Linear payload cleanup uses a consuming destroy or drain API. |
| `drain` and `intoIter` | Consume owner or produce a drain token. | Produce a linear drain token or owning iterator. | The caller exhausts or explicitly finalizes retained state. |

Unsafe storage internals can track uninitialized slots only behind audited initialized-length and capacity invariants. Safe APIs never expose a hole, a moved-out indexed slot, or an iterator state that silently abandons linear elements.

> Trace: D496-D497
> Covers: Collection APIs distinguish borrowing, copying, movement, destruction, draining, and internal hole tracking by explicit universe rules.

## Drain And Early-Exit Contracts

A drain token or owning iterator is linear whenever it can retain linear elements. Natural exhaustion consumes that state. Early exit calls the token's explicit finalizer or returns the token to a caller that continues to own it. A callback-driven bulk operation states whether callback failure leaves the owner unchanged, returns partial progress, returns a named recovery payload, or consumes the collection through an explicit destroy path.

The Analysis Server and generated docs render operation tables separately for `Free`, `Linear`, pinned, target-gated, and capability-gated cases. An operation is not hidden merely because it exists only for one universe.

> Trace: D491, D496-D497
> Covers: Linear bulk operations expose retained state and early-exit ownership instead of relying on hidden destruction.

## Why This Shape

[Rikona Kurasaki / Mjoyufull]
Collections are where a language often starts whispering. Kyokai does not whisper. If a map can rehash, the invalidation is written. If a queue can hold a linear handle, the drain story is written. If a hash seed changes iteration, the determinism story is written.

> Trace: D77, D83, D85, D229, D401, D496-D497
> Covers: Collection behavior remains explicit instead of living as accidental implementation custom.
