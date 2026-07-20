# Concurrency Primitives

[Rikona Kurasaki / Mjoyufull]
> ProofTrace: SPEC-STDLIB-09-CONCURRENCY-PRIMITIVES
> Covers: This chapter is registered in the public ProofTrace evidence graph; registration does not claim implementation, conformance, or theorem completion.

Concurrency primitives state sharing, close behavior, blocking, ownership transfer, authority transfer, synchronization, and cleanup explicitly.

> Trace: D3-D3b, D90-D101, D146, D164, D183-D184, D212
> Covers: Stdlib concurrency primitives follow structured tasks, explicit transfer, SPSC channels, locks, atomics, pollers, and capability-sharing rules.

## Primitive Set

The stable primitive set includes structured task support from the language, SPSC channels, rendezvous and bounded channels, `Mutex[T]`, `RwLock[T]`, `Atomic[T]`, fences, `Poller`, `SignalWatcher`, and explicit broker/synchronized-wrapper patterns. Kyokai does not provide `Rc[T]` or `Arc[T]` shared ownership primitives.

> Trace: D3-D3b, D93, D95, D100-D101, D146, D183-D184
> Covers: The concurrency surface is explicit and rejects hidden reference-counted sharing.

MPSC and MPMC queues are not the primitive channel model. An admitted MPSC or MPMC queue is built as library structures with their own contracts or brokers over simpler primitives. They must state ownership, fairness, memory ordering, wakeup, close, and drain behavior.

> Trace: D3-D3b, D90, D146, D183
> Covers: Multi-producer/multi-consumer behavior is not silently inherited from the primitive channel contract.

## Channels

SPSC channels transfer ownership between tasks. Rendezvous channels perform synchronous handoff. Bounded channels require capacity at least one. Channel close and receiver drain behavior must preserve linear payloads.

> Trace: D3-D3b, D146, D183
> Covers: Channel capacity, transfer, close, and drain rules are explicit.

| API Family | Ownership | Allocation | Failure | Linearity | Concurrency | Tests | Trace |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Channel construction | Returns unique sender/receiver linear endpoints. | Rendezvous channels allocate no payload buffer. Bounded and growable channels take an explicit allocator at construction. | Allocator-backed construction returns `AllocError`; invalid capacity is TPOE. | Endpoints are linear; payload transfer consumes the sender-side value. | Tier-1 endpoints are SPSC only. MPSC, MPMC, and broadcast use separately admitted broker or library structures with explicit topology contracts. | capacity, close, transfer, allocation failure. | D74, D146, D183 |
| Send/receive | Mutably borrows or consumes endpoint as named. | Rendezvous and bounded-channel send/receive allocate nothing after construction. Growable-channel send can allocate through the allocator stored at construction and returns allocation failure with ownership recovery according to its API contract. | Closed/cancelled/deadline cases are data. | Linear payload moved exactly once. | Establishes channel happens-before edge. | ordering, close, blocking, cancellation, growable allocation failure. | D74, D90-D91, D146 |
| Receiver drain | Consumes or mutably borrows receiver by contract. | A callback-based drain allocates nothing. A collector drain takes an explicit destination allocator and reports `AllocError`. | Source error and collector allocation error are explicit. | Required for `Receiver[T: Linear]` completion. | Same as receiver. | buffered linear drain, early exit cleanup, collector allocation failure. | D146, D249 |

> Trace: D74, D90-D91, D146, D183, D249
> Covers: Channel APIs publish ownership, allocation, failure, linearity, concurrency, and tests.

## Locks

`Mutex[T]` and `RwLock[T]` are linear synchronization primitives. Lock guards are linear borrowed-access values. Unlock occurs by consuming the guard through the ordinary linear cleanup path; APIs must state whether lock acquisition blocks, can return cancellation/deadline results, or can fail due to poisoning-like state. Kyokai does not inherit poisoning semantics by default.

> Trace: D77, D91, D100, D184
> Covers: Lock and guard behavior is linear and blocking-explicit.

Sharing capability-bearing handles through locks is allowed only when the wrapper contract states the authority-sharing policy. Raw capability-bearing I/O remains exclusive by handle unless a broker or synchronized wrapper makes sharing visible.

> Trace: D100, D212, D236
> Covers: Locks do not hide authority sharing.

| Lock Family | Ownership | Allocation | Failure | Linearity | Concurrency | Tests | Trace |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `Mutex[T]` | Owns `T`; guard borrows protected value. | Construction allocates only when its contract states the allocation and its allocator is explicit. | Lock interruption/deadline explicit; ordinary unlock no failure. | Guard linear; protected linear values cannot be duplicated. | Mutual exclusion and happens-before on unlock/lock. | contention, cancellation, guard cleanup. | D90-D91, D100 |
| `RwLock[T]` | Owns `T`; read/write guards borrow. | Same as mutex. | Same as mutex. | Write guard exclusive; read guards obey `T` sharing rules. | Reader/writer fairness policy documented. | readers, writer exclusion, starvation policy. | D90-D91, D100, D184 |

> Trace: D90-D91, D100, D184, D212
> Covers: Lock APIs publish ownership, allocation, failure, linearity, concurrency, and tests.

## Atomics And Memory Ordering

`Atomic[T]` is admitted only for types with a supported atomic representation. Memory order is an explicit argument or fixed by the API name. Relaxed operations do not synchronize by themselves. Fences and compare/exchange operations state exact ordering requirements and failure ordering rules.

> Trace: D90-D90a, D141, D247
> Covers: Atomics use a closed memory-order model and supported lowering contract.

Atomic APIs do not grant ownership sharing. They operate on admitted scalar/atomic representations; shared access to larger resources still uses channels, locks, brokers, or explicit unsafe contracts.

> Trace: D90, D100-D101, D141
> Covers: Atomics are synchronization tools, not hidden shared ownership.

## Pollers, Signals, And Blocking

`Poller` is explicit linear readiness state. Event loops are ordinary Kyokai code over pollers. Plain blocking operations can wait indefinitely; deadline and cancellation-aware variants are separate named APIs returning explicit cases.

`select ... pick;` and `wait ... wake;` are separate surfaces. `select` chooses among channel send, channel receive, channel close observation, deadline, cancellation, and default arms. `wait` chooses among Poller readiness, timer/deadline, cancellation, target-admitted signal readiness, target-admitted process readiness, and default arms. A `wait` arm does not transfer a channel message. A `select` arm does not wait directly on a raw file descriptor, socket, OS handle, or Poller backend handle. A channel readiness adapter is legal only through a named standard contract that states ownership and close behavior; readiness observation alone does not transfer payload ownership.

| Construct | Selected arm class | Ownership commit | Required contract facts |
| --- | --- | --- | --- |
| `select` | channel send | The selected send commits the message transfer. Every unselected send retains its message. | capacity, close, cancellation, deadline, wakeup, ordering. |
| `select` | channel receive | The selected receive commits one message or the declared exhaustion result. | close, drain, buffered linear payload behavior. |
| `select` | deadline, cancellation, default | No channel transfer. | selected typed result and eligibility rule. |
| `wait` | Poller, timer, signal, process readiness | No resource transfer unless the selected token API explicitly returns an owned event record. | token lifetime, deregistration, stale-event, edge/level mode, spurious-wake policy, target gate. |
| `wait` | cancellation, default | No external-resource transfer. | selected typed result and eligibility rule. |

If several arms are ready, the selected arm is any ready arm under specified nondeterminism. Default `select` and `wait` promise neither source-order priority nor starvation freedom. A named biased or fair mode is legal only when its contract states eligibility, ordering, fairness, and replay facts. Tooling reports obvious starvation risks without changing legality.

Every blocking or cancellable primitive records one cancellation class.

| Cancellation class | Required post-cancellation contract |
| --- | --- |
| `NoEffectOnCancel` | Cancellation returns without changing user-visible resource state. |
| `PartialProgress` | The API lists every offset, buffer, handle, message, or resource field that can advance before cancellation wins. |
| `ConsumesOnCancel` | The API lists every consumed linear value and the owned recovery payload returned to the caller; an absent recovery payload is written explicitly. |
| `UncancellableBlocking` | The API does not observe cancellation until normal return or a target-recorded interruption event. |

If cancellation races with successful completion, the primitive contract states which result wins and where ownership transfer commits. Target Poller records state backend class, edge-triggered or level-triggered readiness, descriptor classes, signal/process support, and spurious-wake policy.

> Trace: D91, D93-D94, D237, D283-D284, D342
> Covers: Readiness, channel choice, cancellation classes, target Poller behavior, and indefinite blocking are visible API contracts.

`SignalWatcher` is capability-gated and notification-based. Synchronous fault signals are runtime-fatal and are not delivered as ordinary safe events.

> Trace: D95-D96, D256
> Covers: Safe signal handling is narrow and explicit.

## Bounded Resource Primitives

Semaphores, permits, bounded task slots, bounded connection slots, and rate-limit tokens are ordinary linear standard-library capability or synchronization values. Their API records acquisition, release, try-acquire, deadline, cancellation class, fairness, failure behavior, and task-transfer status. A limit value is passed explicitly, never acquired through ambient runtime policy, and never widens its own ceiling.

> Trace: D310
> Covers: Resource ceilings are explicit linear values with visible acquisition, release, cancellation, and fairness behavior.

## Tier-1 Channel Boundary

The Tier-1 channel set contains unique linear SPSC endpoints only. MPSC, MPMC, and broadcast endpoints are not core language primitives and are not Tier-1 stdlib channel endpoints. Fan-in, fan-out, work distribution, and publish/subscribe are expressed through explicit broker tasks connected by SPSC channels, poller registration, and named queue policies.

A broker contract states capacity, producer and consumer topology, queue policy, ordering, fairness or non-fairness, wakeup, backpressure, cancellation, deadlines, close behavior, linear-message drainage, and partial-progress behavior. A broker does not hand user code a hidden cloneable endpoint.

> Trace: D411, D436, D471, D473
> Covers: Complex channel topology remains visible broker structure over the SPSC core rather than hidden shared endpoints.

## Tier-1 RwLock Fairness

Tier-1 `RwLock[T]` uses `FairQueue` semantics. Requests enter a FIFO fairness queue. Readers acquire together only when no earlier writer is queued. Once a writer is queued, later readers do not bypass it. A target whose OS primitive cannot preserve this rule supplies the fairness layer in the runtime or rejects Tier-1 `RwLock` admission for that target.

`ReaderPreferring` and target-defined priority are not the standard `RwLock` contract. A separately named synchronization primitive requires its own admission record, queueing rules, starvation policy, target support, and conformance tests.

> Trace: D447
> Covers: Writer-starvation behavior is fixed for the standard rwlock instead of inherited from the host primitive.

## Spawn-Shareable Registry

Immutable spawn capture by shared reference is legal only for the closed `SpawnShareable` registry: immutable `Free` values, admitted `Atomic[T]`, admitted `Mutex[T]`, Tier-1 fair `RwLock[T]`, and explicitly admitted SPSC endpoint forms whose transfer class permits shared observation. User code cannot add registry entries.

Adding a spawn-shareable primitive requires an accepted rule, stdlib admission record, `.koi` transfer fact, and conformance tests. The registry does not create a general `Sync` typeclass and does not turn arbitrary immutable borrows into cross-task sharing.

> Trace: D448
> Covers: Shared task capture is a closed audited exception list rather than an extensible marker mechanism.

## Stateful Callbacks And Poller Adapters

Repeated callbacks with linear state use explicit state-machine values. Each invocation consumes the previous state and returns the next state or a named terminal result. A callback that consumes its captures is one-shot. A callback that mutates retained captures replaces every consumed linear field before returning.

A poller adapter for a foreign event source states readiness source, wake mechanism, registered-handle ownership, cancellation, deadline handling, close behavior, stale-event handling, thread affinity, callback reentrancy, userdata layout, cleanup, and foreign thread-local error snapshots. Partial I/O reports the bytes or messages already transferred before failure.

> Trace: D411, D456-D457a, D473, D493
> Covers: Event-loop integration and repeated callbacks preserve protocol state and partial progress explicitly.

## Lock Lifetime Diagnostics

Compiler-integrated diagnostics report a lock guard that crosses a blocking call, `spawn`, `join`, `select`, or `wait`; a nested acquisition without explicit order metadata; and a long-lived protected resource retained across unrelated blocking work. These diagnostics describe visible lifetime risk. They do not claim a proof of deadlock freedom.

> Trace: D498
> Covers: Tooling exposes risky lock lifetimes without changing legality or pretending to solve general deadlock detection.

## Synchronization Is A Contract

[Rikona Kurasaki / Mjoyufull]
Kyokai requires concurrency that can be audited from the signature and the cleanup path. The task transfer is named. The channel drain is named. The lock guard is linear. The atomic order is written where the operation happens.

> Trace: D90-D101, D146, D183-D184, D212, D436, D447-D448, D493, D498
> Covers: Concurrency primitives expose transfer, cleanup, blocking, ordering, fairness, and authority-sharing behavior.

## Topology Evidence For SPSC And Native Tasks

Kyokai keeps Linear SPSC endpoints, explicit brokers, one-to-one native tasks,
and explicit `Poller`. The standard concurrency surface does not add
async/await, a hidden executor, general MPMC endpoints, or an M:N scheduler.

Canonical material covers fan-in, fan-out, reply endpoints, sharded brokers,
work distribution, broadcast-by-copy, supervision, bounded backpressure, load
shedding, cancellation, and graceful shutdown. Workload records measure thread
count, memory, tail latency, broker contention, starvation, cancellation
latency, and topology code size, with appropriate direct-channel and lock-based
comparisons. Diagnostics may report provable bottlenecks or task/channel cycles;
only repeated measured problems justify reopening ergonomics.

> Trace: D600
> Covers: The CSP, broker, reactor, and linear-endpoint design is supported by concrete examples and measurements rather than treated as novel folklore.
