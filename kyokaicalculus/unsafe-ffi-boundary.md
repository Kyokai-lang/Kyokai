# Unsafe And FFI Boundary

**Status:** `intended-by-spec` contract boundary
**Layer:** `lambda_K-unsafe`

Unsafe and FFI behavior is excluded from `lambda_K-seq`. Safe code relies on
unsafe code only through wrappers with visible contracts and audit records.

| Obligation | Required boundary rule |
| --- | --- |
| Unsafe coverage | Every unsafe operation is covered by a source-visible `unsafe contract ... audit;` obligation. |
| Linear values | Raw FFI does not take or return Kyokai linear values by value. Wrappers model transfer explicitly. |
| Sum values | Raw FFI does not pretend to understand Kyokai sum representation. Wrappers translate explicit ABI records and tags. |
| Capabilities | Raw bits never become safe capability authority. Authority comes from admitted constructors and attenuation APIs. |
| Failure | Foreign status values, sentinels, thread-local errors, and callbacks are translated into named Kyokai failure categories. |
| Unwinding | Kyokai fatal paths do not unwind through foreign frames. Foreign unwinding does not cross into safe Kyokai. |
| Volatile and assembly | MMIO and inline assembly remain target-specific operation-level unsafe surfaces, not ordinary synchronization. |
| Dynamic loading | Raw loading is unsafe. Verified Kyokai plugins use explicit identity, metadata, and authority checks. |

Module-specific wrappers need audits, tests, and admission evidence before
safe code treats them as trusted boundaries.
