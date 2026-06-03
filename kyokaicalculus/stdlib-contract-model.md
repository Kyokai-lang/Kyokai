# Standard-Library Contract Model

**Status:** `intended-by-spec` admission model  
**Layer:** `lambda_K-stdlib`

The sequential core can justify ownership facts for safe stdlib code. It does
not prove algorithm correctness, numerical accuracy, crypto security, OS
behavior, or wrapper soundness.

Every stable stdlib API record states:

| Field | Required content |
| --- | --- |
| Surface | Module, type, function, and tier. |
| Ownership | Consumed, returned, retained, drained, and destroyed values. |
| Allocation | Allocator source, allocation sites, failure category, and invalidation. |
| Authority | Required capability and attenuation behavior. |
| Blocking | Blocking, readiness, cancellation, deadline, and partial-progress behavior. |
| Failure | Domain `Result`, `Optional`, TPOE, panic, runtime-fatal, or target rejection. |
| Determinism | Complexity, iteration order, randomness lane, and replay facts. |
| Boundary | Native-safe, unsafe-internal, transitional FFI, or external-review requirement. |
| Evidence | Unit, edge, allocator-failure, property, fuzz, oracle, vector, and target tests. |

Pure computation is admitted as native safe Kyokai where practical.
Transitional FFI remains tracked as debt with a replacement record. Numerics
need accuracy tiers and reference oracles. Crypto needs external specs, test
vectors, side-channel contracts, and review.

