# Concurrency Model Boundary

**Status:** `intended-by-spec` later-model contract  
**Layer:** `lambda_K-conc`

Concurrency is excluded from `lambda_K-seq`. The later model owns structured
1:1 OS-thread tasks, explicit spawn captures, task groups, joins, cooperative
cancellation, deadlines, pollers, SPSC channels, `select`, mutexes, fair
reader/writer locks, atomics, fences, signals, brokers, and the closed
happens-before inventory.

| Obligation | Required later treatment |
| --- | --- |
| Task transfer | Every moved capture is explicit. Shared capture requires an admitted synchronized `SpawnShareable` type. |
| Channels | Endpoints are linear. Capacity, backpressure, close, drain, and linear-message cleanup are explicit. |
| `select` | Ready-arm choice is specified nondeterminism with no hidden source-order priority. Replay tooling records the relevant boundary. |
| Cancellation | Blocking wrappers use readiness-backed composition. No hidden thread interruption or stack unwinding exists. |
| Atomics | Atomic domain, memory orders, fences, compare-exchange outcomes, and backend mapping are explicit. |
| Happens-before | The model uses the closed edge inventory from the language spec. No backend folklore adds edges. |
| Signals | Signal watchers are explicit. Synchronous host faults remain runtime-fatal. |

This document is an ownership checklist, not a concurrency proof.

