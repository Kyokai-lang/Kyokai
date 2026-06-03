# Contracts And Runtime Failure

[Rikona Kurasaki / Mjoyufull]
> ProofTrace: SPEC-LANGUAGE-13-CONTRACTS-AND-RUNTIME-FAILURE
> Covers: This chapter is registered in the public ProofTrace evidence graph; registration does not claim implementation, conformance, or theorem completion.

Some failures are doors. A missing file, a closed channel, a refused connection, a timeout at the edge of a machine that never promised to answer. Kyokai makes those ordinary values because the program can still choose its next step.

A contract violation is different. That is not a locked door. That is the floor giving way under the room. Once the program proves that its own stated rule is false, Kyokai does not ask the same broken state to negotiate recovery. It stops the process, or it follows an explicitly named fatal path. No pretending. No hidden unwind. No second story where the bug was actually a branch.

> Trace: D24, D53, D84, D140, D142, D211, D253
> Covers: Recoverable failures are values; contracts, runtime checks, panic, and runtime-fatal conditions are distinct termination categories.

This chapter defines function contracts, contract expression semantics, `panic`, TPOE, runtime-fatal termination, ordinary exit, and the exact failure category for common checked operations. It is normative for safe Kyokai programs and for backend/runtime support code that reports failures.

> Trace: D73, D84, D139, D228
> Covers: Runtime failure behavior is specified Kyokai behavior, not backend undefined behavior or host-language folklore.

## Failure Categories

Every observable failure in Kyokai belongs to exactly one of these categories. A standard-library API refines ordinary recoverable or absence data through a named domain `Result` or `Optional` contract; it does not add an unclassified failure category.

> Trace: D84, D211, D253
> Covers: Failure taxonomy is closed enough that each surface can state its result category directly.

| Category | Meaning | User observation | Runs `defer` | Runs `errdefer` | Catchable in-process | Trace |
| --- | --- | --- | --- | --- | --- | --- |
| Compile error | Source violates a static rule. | Build fails with diagnostics. | Not applicable. | Not applicable. | Not applicable. | D29/D73 |
| Ordinary value | Operation returns a normal value. | Caller receives the declared value. | Only if surrounding control flow exits a scope. | Only on structured error exits. | Not an error. | D24 |
| `Optional` | Absence is expected. | Caller must inspect `Some` or `None`. | No special cleanup. | No special cleanup. | Yes, as ordinary data. | D24 |
| `Result` | Recoverable failure is expected. | Caller must inspect `Ok` or `Err`. | No special cleanup unless control exits. | `or return` triggers `errdefer`. | Yes, as ordinary data. | D15/D15a/D24 |
| TPOE | A contract or checked runtime rule was violated. | Process terminates through the TPOE runtime path. | No. | No. | No. | D53/D75/D84 |
| `panic` | Source explicitly requests abnormal termination. | Process terminates through the panic runtime path. | Yes, ordinary `defer` only. | No, unless already on a structured error exit. | No. | D84/D208 |
| Runtime-fatal | Runtime or host condition invalidates safe continuation. | Process terminates through the runtime-fatal path. | No. | No. | No. | D84/D95/D262/D285 |
| Ordinary process exit | Entrypoint returns an exit code or the host entry path completes normally. | Process exits with that code/status. | Ordinary structured scope exits run. | Only on structured error exits before final return. | Not an error. | D84 |

A standard-library API must name its failure mode as `Optional`, `Result`, TPOE, `panic`, runtime-fatal, or ordinary value. It must not say only "fails" or "throws".

> Trace: D85, D211, D229
> Covers: Public API contracts name failure modes instead of relying on vague prose.

## Function Contracts

A `require` clause is a precondition on a function. It appears after the function signature and before `is`. Each `require` expression must have type `Bool` and is evaluated at function entry after argument binding and after `old` snapshots for that function have been captured.

> Trace: D53, D129, D140
> Covers: Preconditions are function-entry Boolean checks with fixed ordering relative to `old`.

If a `require` expression evaluates to `false`, the program terminates by TPOE. A failed precondition is not returned as `Result`, not translated to `Optional`, not caught by the caller, and not a profile-stripped assertion.

> Trace: D53, D84
> Covers: Failed preconditions are runtime contract violations and always terminate through TPOE.

An `ensure` clause is a postcondition on a function. It appears in the same contract region as `require`. Each `ensure` expression must have type `Bool` and is evaluated after the function body has produced its return value but before that value is delivered to the caller.

> Trace: D53, D142
> Covers: Postconditions observe the produced return value before caller delivery.

If an `ensure` expression evaluates to `false`, the program terminates by TPOE. The return value is not delivered to the caller. The failure is a bug in the callee contract or implementation, not recoverable data.

> Trace: D53, D84, D142
> Covers: Failed postconditions are TPOE and cannot be observed as ordinary return.

Contracts are always checked. No build profile, optimization level, target mode, debug setting, or compiler flag may strip or weaken `require` or `ensure` clauses.

> Trace: D53
> Covers: Contracts are language semantics, not debug-only checks.

Multiple `require` clauses evaluate in source order. Multiple `ensure` clauses evaluate in source order. The first contract subexpression that triggers TPOE or evaluates to `false` determines the failure path; later clauses are not evaluated.

> Trace: D53, D71, D140
> Covers: Contract evaluation order is source-ordered and short-circuits only by termination.

Contract clauses are part of the public interface when they appear in `.kyo` interface files. Tools, documentation, and diagnostics must preserve them as caller-visible obligations.

> Trace: D29, D53, D85, D218
> Covers: Contracts are interface-visible API facts.

## Contract Expression Purity

A `require` or `ensure` expression must be observation-only. It may read immutable data, call admitted pure observation functions, compare values, perform ordinary arithmetic, and inspect `Free` data or immutable borrows. It must not mutate, allocate, block, consume linear values, acquire capabilities, perform I/O, spawn tasks, register cleanup, or call functions whose contract admits any of those effects.

> Trace: D53, D124-D125, D129, D211
> Covers: Contract expressions observe program state without changing ownership, authority, allocation, blocking, or control flow.

A contract expression uses ordinary Kyokai value semantics. Integer overflow, division by zero, invalid shift counts, failed bounds checks, and other checked runtime traps inside the contract expression are TPOE. They are not reinterpreted as the contract evaluating to `false`.

> Trace: D75, D84, D140
> Covers: Contract arithmetic has the same runtime rules as ordinary code; overflowing contracts are bugs.

Contract authors must write overflow-safe conditions explicitly, by decomposing inequalities, widening through explicit conversions where admitted, or using checked helper APIs that return ordinary values. The compiler does not switch contracts into mathematical integers or wrapping arithmetic.

> Trace: D37, D75, D140
> Covers: Contract expressions do not use a separate proof-language arithmetic tier.

## `result`

Inside an `ensure` clause, `result` is a contextual name for a read-only view of the return slot. It is not a keyword elsewhere and does not bind in `require` clauses or function bodies.

> Trace: D53, D125, D142
> Covers: `result` is contextual to postconditions only.

When the return type is `Free`, `result` may be observed as a `Free` value according to the ordinary read rules. When the return type is `Linear`, `result` is an immutable borrow of the produced return value. The postcondition may observe it but must not move it, consume it, mutably borrow it, store the borrow beyond the postcondition, or return another borrow tied to it.

> Trace: D14, D53, D142
> Covers: Linear `result` is a read-only postcondition borrow, not a duplicate owner.

For a function returning `Unit`, `ensure` is legal, but `result` is not available because the single `Unit` value carries no useful postcondition binding.

> Trace: D8, D53, D142
> Covers: Unit postconditions cannot refer to `result`.

## `old`

Inside an `ensure` clause, `old expr` denotes the value of a pure entry-state expression. Each distinct `old expr` is evaluated exactly once at function entry before any `require` clause is checked, saved by value, and then made available to postconditions.

> Trace: D53, D129
> Covers: `old` snapshots happen at entry and are later observed in `ensure`.

The expression inside `old` must be pure, must depend only on values available at function entry, and must observe only `Free` data. Directly or indirectly observing a `Linear` value through `old` is a compile error.

> Trace: D129, D195
> Covers: `old` cannot copy linear state or smuggle ownership into postconditions.

`old` may apply to a qualified pure expression, not only to a bare parameter name. It must not allocate, call authority-bearing APIs, block, mutate, consume, or observe values that are introduced after function entry.

> Trace: D53, D129, D211
> Covers: Entry snapshots are pure and entry-bounded.

## TPOE

TPOE means Terminate Program On Error. It is the required outcome for runtime contract violations and checked runtime conditions that the language classifies as programmer bugs.

> Trace: D53, D73, D75, D84
> Covers: TPOE is the language outcome for checked bug conditions.

The following failures are TPOE: failed `require`, failed `ensure`, overflow or invalid arithmetic in a checked integer operation, integer division or remainder by zero, invalid shift or rotate count, bounds failure in checked indexing or slicing, `unreachable` reached at runtime, failed runtime assertion where the assertion API is specified as contract-checking, and any other operation whose spec says failure is TPOE.

> Trace: D36/D106/D132, D53, D75, D84, D121
> Covers: Common checked bug conditions terminate by TPOE.

TPOE runs no user `defer` or `errdefer` actions. The process is already outside the contract the program claimed. Runtime support may emit diagnostics, flush host-owned diagnostic streams where safe, or record crash metadata, but it must not run arbitrary user cleanup.

> Trace: D2b, D84, D208
> Covers: TPOE is immediate hard termination without user cleanup.

TPOE is not `Never` before it happens. An expression that may overflow, fail a bounds check, or violate a contract keeps its ordinary static type until a checked failure actually occurs. Only statically diverging forms have type `Never`.

> Trace: D58/D191, D84
> Covers: Possible runtime failure does not make an expression statically diverging.

## `panic`, `todo`, And `unreachable`

`panic(message);` is explicit programmer-requested abnormal termination. It has type `Never` at the statement/expression site where the grammar admits it, runs ordinary `defer` actions for exited scopes in LIFO order, does not run `errdefer`, and then terminates the process through the panic path.

> Trace: D2a, D2b, D84, D208
> Covers: Panic is explicit, statically diverging, cleanup-running process termination.

Kyokai has no in-process `catch panic`, panic recovery block, task-level panic result, or join-time panic observation. Fault isolation uses supervised OS worker processes and explicit IPC/status observation.

> Trace: D84, D168, D253
> Covers: Panic is not recoverable inside the same Kyokai process.

`todo(message);` marks intentionally unfinished code. Reaching it at runtime terminates through the panic path, because the programmer explicitly chose a placeholder. Tools may warn or fail builds that contain `todo` according to project policy, but runtime meaning remains panic.

> Trace: D121, D84
> Covers: Runtime `todo` is explicit panic-class termination.

`unreachable;` states that control cannot reach that point. It has type `Never`. Reaching it at runtime triggers TPOE with diagnostic kind `UnreachableReached` and the source span. Safe `unreachable;` is not `panic`, backend undefined behavior, LLVM poison, a bare `__builtin_unreachable`, or an optimizer assumption. The compiler can remove its branch only after accepted static analysis proves that the branch cannot execute under Kyokai semantics.

> Trace: D73, D84, D121, D228, D355
> Covers: Reached safe `unreachable;` is a source-located TPOE path and never lowers directly to backend undefined behavior.

## Runtime-Fatal Termination

Runtime-fatal termination is used when the runtime or host environment can no longer preserve safe Kyokai execution and the condition is not an ordinary contract check in user code.

> Trace: D84, D95, D262
> Covers: Runtime-fatal is distinct from programmer `panic` and contract TPOE.

Stack overflow is runtime-fatal. The runtime must either detect it before memory corruption or use a target contract whose guard-page or equivalent mechanism makes the failure fatal before safe Kyokai invariants can be violated. Stack overflow is not recoverable, not `Result`, and not TPOE.

> Trace: D84, D262
> Covers: Stack overflow terminates fatally before corruption becomes language behavior.

Synchronous host fault signals such as invalid instruction, segmentation fault, bus error, arithmetic fault signal, or abort signal are runtime-fatal when they reach Kyokai safe execution. Safe Kyokai does not translate them into ordinary values, `panic`, TPOE, or cancellation.

> Trace: D95, D256
> Covers: Synchronous host faults are fatal process conditions.

An implementation bug in the compiler, runtime, backend helper, or standard library support code that violates an internal invariant is runtime-fatal or compile-fatal depending on when it is detected. It must not be reported as a user `Result` or ordinary program branch.

> Trace: D29, D73, D84, D228
> Covers: Implementation failures are not user-level recoverable errors.

## Allocation Failure

Allocation failure in ordinary standard-library APIs is recoverable data unless an API is explicitly named and documented as fatal-on-OOM. The ordinary shape is `Result[..., AllocError]` or another declared `Result` carrying allocation failure.

> Trace: D74, D85, D229
> Covers: Ordinary allocation failure is explicit value-level failure.

A named fatal-on-OOM helper may terminate through runtime-fatal or a specified fatal path only when its name and contract make that stronger behavior clear. Hidden allocation failure termination in ordinary APIs is rejected.

> Trace: D74, D211, D229
> Covers: Fatal allocation helpers must be named and contract-visible.

If allocation failure occurs inside a construct whose contract does not admit allocation, that is a bug in the implementation or API contract and must be diagnosed or treated as runtime-fatal according to where it is detected.

> Trace: D211, D229
> Covers: Allocation behavior is part of the API contract and cannot appear invisibly.

## Hosted And Freestanding Diagnostics

On hosted targets, panic, TPOE, and runtime-fatal support emits a structured fatal payload. The payload records terminal category, diagnostic code, message, source span when available, failed contract or check when available, `Optional[Backtrace]`, target triple, selected profile, backend, runtime phase, and hosted exit mapping. `ExitCode` return remains ordinary process exit and does not enter this payload path.

Backtrace policy resolves in this order: explicit CLI `--backtrace=<off|short|full>`, profile key `panic_backtrace = "off"|"short"|"full"`, hosted `KYOKAI_BACKTRACE=0|1|short|full` only when the selected profile permits environment override, then target default. A reproducible profile disables environment override by default. Backtrace capture failure omits the trace and does not change the terminal category.

On freestanding targets, every fatal route uses the selected target contract's non-returning action: trap, halt, reset, non-returning hook, or another named target-specific action. A freestanding hook receives terminal category, diagnostic code, static message or bounded payload pointer and length, `Optional[Backtrace]` when supported, and target/runtime context admitted by the target contract. It cannot allocate or perform capability-requiring I/O unless those capabilities are passed explicitly or the target contract declares a fixed runtime sink. Returning from the hook escalates to the target's trap, halt, or reset action.

| Fatal surface fact | Required target/profile record |
| --- | --- |
| Stack overflow detection | Guard page, stack probe, explicit bound check, OS signal/trap mediation, or unavailable diagnostic limitation. |
| Stack sizing | Main stack default, task stack default, minimum stack, maximum configured stack, guard size, overflow action. |
| Spawn stack request | Availability flag and typed spawn/config error for an unsupported or invalid request; no silent rounding. |
| Fatal hook ABI | Parameter layout, non-returning rule, allowed fixed sinks, allocation rule, and return-escalation action. |
| Inspection | `kyokai doctor --target` and profile inspection print every configured fatal, backtrace, and stack field. |

Backtraces are diagnostic output, not language control flow. Absence of a backtrace does not change the failure category. Presence of a backtrace does not permit recovery.

> Trace: D27, D29, D80, D84, D86, D253, D343
> Covers: Hosted and freestanding fatal paths publish payload, backtrace precedence, stack policy, fatal-hook ABI, and inspection rules without changing termination semantics.

## FFI Boundaries

A Kyokai `panic`, TPOE, or runtime-fatal condition must not unwind through foreign frames. If it occurs while foreign code is on the stack, Kyokai terminates the process through the relevant fatal path rather than crossing the FFI boundary with stack unwinding.

> Trace: D20b, D84, D253
> Covers: Fatal Kyokai paths do not unwind across FFI.

Foreign error conventions such as `errno`, null pointers, sentinel values, status integers, callbacks, and host exceptions must be translated by unsafe wrappers into explicit Kyokai values, TPOE, panic, or runtime-fatal behavior according to the wrapper contract. Raw foreign failure conventions are not safe Kyokai semantics.

> Trace: D20/D20a/D20b, D73, D242
> Covers: FFI wrappers own the translation from host failure to Kyokai categories.

## Failure Category Table

| Situation | Category | Result visible to user code | Cleanup behavior | Trace |
| --- | --- | --- | --- | --- |
| Parse/type/linearity/capability violation | Compile error | Build fails. | None. | D29/D73 |
| `static_assert(false)` at compile time | Compile error | Build fails with assertion diagnostic. | None. | D18/D18a |
| Missing file, timeout, disconnected channel, spawn resource refusal | `Result` or `Optional` as specified by API | Caller handles ordinary data. | Ordinary structured cleanup only. | D3a/D24/D74/D235 |
| Failed `require` or `ensure` | TPOE | No caller value. | No user cleanup. | D53/D84 |
| Contract subexpression overflow | TPOE | No caller value. | No user cleanup. | D75/D140 |
| Integer overflow, division by zero, invalid shift | TPOE | No expression value. | No user cleanup. | D75/D84 |
| Index or slice bounds failure | TPOE | No expression value. | No user cleanup. | D36/D132/D84 |
| Runtime `unreachable` reached | TPOE | No expression value. | No user cleanup. | D121/D84 |
| Explicit `panic(message)` | `panic` | No caller value. | Ordinary `defer` runs; `errdefer` does not. | D84/D208 |
| Runtime `todo(message)` reached | `panic` | No caller value. | Ordinary `defer` runs; `errdefer` does not. | D121/D84 |
| Stack overflow | Runtime-fatal | No caller value. | No user cleanup unless target hook says only host-owned action. | D84/D262 |
| Synchronous host fault signal | Runtime-fatal | No caller value. | No user cleanup. | D95/D256 |
| Compiler/runtime internal invariant failure | Compile-fatal or runtime-fatal | No ordinary user branch. | Not user cleanup. | D29/D84 |
| Entrypoint returns `ExitCode` | Ordinary process exit | Host observes exit status. | Structured scope cleanup already ran. | D84 |

## Recoverable Mutation Classes

A fallible mutating API declares exactly one error-state class.

| Class | Required contract after `Err` |
| --- | --- |
| `NoMutationOnErr` | Observable state is unchanged. |
| `PartialProgressOnErr` | The contract lists every cursor, offset, buffer, handle, protocol state, or resource field that can advance. |
| `ConsumesOnErr` | The contract lists consumed linear resources and returns every remaining owned recovery value. |
| `PoisonedOnErr` | The value remains owned, but only named inspect, repair, and destroy operations remain legal. |

A caller cannot infer rollback from `Err`. Public `.kyo` docs and `.koi` metadata record the class. Non-transactional I/O and protocol APIs also state success, error, timeout, cancellation, EOF, close, and protocol-rejection state transitions.

> Trace: D454, D473
> Covers: Recoverable mutation exposes exact post-error state instead of treating every `Err` as rollback.

## Named Recovery Payloads And Transactional Builders

When failure leaves owned linear values alive across an API boundary, the error variant carries a named `must_use` recovery payload record. Every field remains a live ownership obligation. Anonymous tuple recovery is illegal.

Transactional builders expose `begin`, step operations, `commit`, and `abort`. `commit` consumes the builder and returns the completed value or a named recovery payload. `abort` consumes the builder and performs the documented recovery behavior. `errdefer` remains the local cleanup tool; a recovery payload is the cross-function ownership handoff.

`kyokai explain failure-flow` renders the owned-resource state before the failing operation, the recovery payload shape, and the caller obligations.

> Trace: D491
> Covers: Partial linear failure remains usable because ownership crosses the error boundary through nominal visible payloads.

## Panic During Cleanup

During panic cleanup, a `defer` action that completes normally allows cleanup to continue. A `defer` action that invokes `panic`, reaches TPOE, triggers runtime-fatal termination, violates an unsafe contract, or hits a cleanup failure classified as nonrecoverable escalates immediately to runtime-fatal. No further user `defer` actions run after escalation.

Compiler-integrated diagnostic `defer_may_fail` reports a `defer` action that calls an API whose contract admits recoverable failure or panic/TPOE without an explicit cleanup-failure policy. Project policy can raise this advisory severity. It does not change runtime semantics.

> Trace: D472
> Covers: Nested abnormal cleanup has one escalation path and cannot recursively pretend cleanup succeeded.

## Fatal Diagnostics And Redaction

Hosted fatal diagnostics are local by default. Accepted Kyokai defines no crash-upload service. A program or tool selects `none`, local-file reporting, or a custom-handler policy only through an API that admits that policy.

Redaction happens before a custom failure hook receives its payload. Fatal reports do not print `Secret[T]` values, redacted environment values, arguments marked secret, raw tokens, arbitrary memory, capability internals, or private source excerpts beyond the configured limit. A failure hook receives read-only structured failure data, source location, bounded diagnostic payload, and a policy-bounded backtrace. It cannot resume, mark handled, run skipped cleanup, acquire authority, or allocate unless allocator authority is passed explicitly.

> Trace: D404
> Covers: Fatal reporting is local, bounded, authority-limited, and redacted before extension hooks run.

## Freestanding Fatal Consequences

Freestanding and embedded targets use the existing terminal categories: normal exit, explicit `panic`, TPOE, and runtime-fatal. A target record selects trap, halt, reset, existing fatal hook, or another named target-specific fatal handler. TPOE remains non-catchable, does not unwind, does not resume, and does not run user cleanup.

Driver and MMIO/DMA API records state which external hardware resources can remain active or externally observable after TPOE or runtime-fatal termination. This is hardware-consequence documentation, not a new cleanup mechanism. Recoverable conditions such as timeout, busy peripheral, missing clock, denied register access, allocation failure, and unsupported target feature use `Result` or `Optional` where their API contracts admit recovery.

> Trace: D358, D464
> Covers: Embedded targets state fatal hardware consequences without turning TPOE into an exaggerated replacement for recoverable device errors.
