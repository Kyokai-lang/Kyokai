# Core Result, Optional, Display, And Error Protocols

[Rikona Kurasaki / Mjoyufull]
The core library shapes are the language's daily grammar for absence, failure, rendering, and diagnostic identity. They have to be small enough to remember and explicit enough that they do not grow into hidden control flow.

> Trace: D24, D40, D40a, D102, D259
> Covers: Core `Optional`, `Result`, formatting, and standard error protocols are stdlib contract surfaces tied to language built-ins.

## Optional And Result

`Optional[T]` represents absence and presence. `Result[T, E]` represents success or recoverable failure. Both are language-known built-in type families with stdlib protocol support. Their pattern behavior is specified by the language chapters; this chapter specifies stdlib helper contracts.

> Trace: D24, D65, D205-D206
> Covers: `Optional` and `Result` are language-known shapes with stdlib helper APIs.

Helpers over `Optional[T]` and `Result[T, E]` must preserve linearity. A helper that receives or returns a `Linear` payload must consume, return, or bind that payload exactly as its contract states. No helper may silently discard a linear payload on an ignored branch.

> Trace: D24, D77, D205-D206
> Covers: Core combinators respect linear payload obligations.

`Result` transformation helpers must not perform implicit error conversion. Error mapping is explicit through named functions or callbacks, matching `or return err => expr` behavior in the language.

> Trace: D119, D259
> Covers: Error conversion remains explicit in both syntax and stdlib helpers.

| API Family | Ownership | Allocation | Failure | Capabilities | Tests | Trace |
| --- | --- | --- | --- | --- | --- | --- |
| `Optional` predicates | Borrow input; do not consume payload unless named `into*`. | None. | Cannot fail. | None. | Some/None and linear payload compile-fail cases. | D24, D205-D206 |
| `Result` predicates | Borrow input; do not consume payload unless named `into*`. | None. | Cannot fail. | None. | Ok/Err and linear payload compile-fail cases. | D24, D119 |
| `map`/`mapErr` helpers | Consume the selected payload and callback result exactly once. | Only if callback allocates; helper itself none. | Callback failure shape is explicit in signature. | Callback capability needs are ordinary parameters. | Branch, cleanup, linearity, callback failure. | D119, D205-D206 |
| `unwrap`-style fatal helpers | Consume container and return payload or terminate by named fatal contract. | None. | Failure branch is named fatal helper behavior. | None. | Success, fatal path, linear cleanup. | D74, D84 |

> Trace: D24, D74, D84, D119, D205-D206, D259
> Covers: Optional/Result helper families state ownership, allocation, failure, authority, and tests.

## Displayable And FormatSink

`Displayable[T]` is the standard protocol for rendering a value as human-readable text. Rendering is not raw stream transport. Displayability carries no terminal, file, socket, or allocation authority.

> Trace: D40, D102
> Covers: Display rendering is separated from I/O transport.

`FormatSink` is the sink protocol used by non-allocating formatting. A sink receives bytes or text chunks according to its contract and reports sink-specific failure. `writeFmt` writes through a `FormatSink`/`Writable` path and returns ordinary stream failure rather than allocating a `String`.

> Trace: D40, D102
> Covers: Non-allocating formatted output uses an explicit sink and typed stream failure.

`format(alloc, template, args...)` allocates a `String` using the explicit destination allocator and returns `Result[String, AllocError]`. The template language is comptime-checked and limited to `{}` placeholders. Width, radix, alignment, and localization mini-language extensions are absent. Ordinary named formatting functions express those operations.

> Trace: D40, D40a, D74
> Covers: Allocating formatting is allocator-explicit, fallible, and uses a narrow checked placeholder language.

| API Family | Ownership | Allocation | Failure | Capabilities | Determinism | Trace |
| --- | --- | --- | --- | --- | --- | --- |
| `display(value, sink)` | Borrows value; mutably borrows sink. | None unless sink allocates by its own contract. | Sink error only. | The sink carries any capability requirement through its own construction contract, not by `Displayable`. | Deterministic over value and sink. | D40, D102 |
| `format(alloc, template, args...)` | Borrows or consumes args according to display instance; allocator mutably borrowed. | Allocates destination `String`. | `AllocError`; template errors are compile-time diagnostics. | None. | Deterministic over args and template. | D40a, D74 |
| `writeFmt(sink, template, args...)` | Mutably borrows sink; observes args. | None by formatting layer. | Stream/sink error; prefix writes can occur before failure. | Capability only through sink value. | Prefix-preserving failure. | D102 |

> Trace: D40-D40a, D74, D85, D102
> Covers: Formatting APIs state ownership, allocation, failure, capability, and determinism.

Stable `debug expr;` resolves ordinary `Displayable` and observes the value through immutable borrowing. Stable Kyokai does not define a second `DebugRenderable` protocol for the debug statement. Raw pointers, addresses, dynamic symbols, unsafe views, capability internals, and secret-bearing values are not `Displayable` by default. Separately named audit and fatal-report APIs render those values through bounded, redacting policies that label rawness and truncation. No display, audit, or fatal renderer consumes a linear value unless its name and signature explicitly take ownership.

> Trace: D316, D362
> Covers: User display, stable debug observation, and bounded redacting audit/fatal rendering are separate explicit surfaces without a second hidden debug-statement protocol.

## StandardError

Implementing `StandardError[E]` is not required for error types. It is a diagnostic protocol for error types. It is separate from `Displayable`; an error can be displayable without implementing structured diagnostics, and an API can return an error type without forcing a dynamic error-object system.

> Trace: D259
> Covers: `StandardError` is standalone and does not inherit from `Displayable`.

`StandardError` does not provide a mandatory `source()` chain. Error context is expressed by concrete wrapper types such as `ContextError[E]`, not by ambient dynamic stacks or hidden exception chains.

> Trace: D119, D259
> Covers: Error context remains concrete and explicit.

`StandardError` instances expose a documented subset of category, stable code, message rendering through a sink, and structured fields. They must state allocation behavior and must not allocate unless the method name/signature exposes an allocator.

> Trace: D40, D85, D259
> Covers: Structured error diagnostics remain allocator-explicit and sink-oriented.

## Naming Contracts

Core helpers follow ownership-signaling names. `as*` borrows and returns a view, `to*In` borrows plus allocates into an explicit allocator, `into*` consumes without a fresh destination allocator, and `into*In` consumes while allocating into an explicit allocator.

> Trace: D11b, D201
> Covers: Core helper names signal ownership and allocation boundaries.

## Why This Shape

[Rikona Kurasaki / Mjoyufull]
`Result` does not become exceptions wearing a different coat. `Displayable` does not become I/O authority. `StandardError` does not become a dynamic object system. These shapes stay small because Kyokai wants the branch, the allocator, the sink, and the error mapping to be visible at the call site.

> Trace: D24, D40, D102, D119, D259
> Covers: Core stdlib protocols keep absence, failure, rendering, and diagnostics explicit.

## Domain Errors And Validated Wrappers

Every stdlib failure has one global category: `RecoverableResult`, `OptionalAbsence`, `ContractViolationTPOE`, `ProgrammerBugTPOE`, or `RuntimeFatal`. `IoError`, `PathError`, `ParseError`, `NetError`, `ProcessError`, `AllocError`, and equivalent domain values inhabit `RecoverableResult` unless the API contract states a violated precondition. Programmer bugs and invariant corruption are not encoded as ordinary `Result` values.

A validated wrapper is a nominal type with a private representation and public checked constructors. Construction returns the wrapper or a domain error. Code outside the defining module cannot bypass validation by constructing the raw field. A wrapper exposes raw data only through explicitly named borrow, conversion, or unsafe operations.

Every OS-backed error preserves operation, portable category, raw target code, target family, mapping-table version, and available context such as path, process, socket, source span, or tool phase. Display text is derived presentation data; matching logic uses stable categories and raw-code accessors rather than localized prose. Pattern matches acknowledge unknown and target-specific categories unless the selected target contract proves those cases absent. Adding a portable category is compatible only when older consumers preserve raw code and map the new category to a declared unknown or other-known case. Removing a category or changing its meaning is compatibility-breaking.

| Surface | Construction And Ownership | Failure | Tooling Contract |
| --- | --- | --- | --- |
| Domain `Result` | Return owned success and owned error values explicitly. | One declared global category and domain type. | Docs, `.koi`, audit, and diagnostics report the category. |
| Validated wrapper | Checked constructor returns a nominal value; raw representation stays private. | Domain validation error. | Hover and docs link constructor and invariant. |
| OS-backed error | Preserve operation, portable category, target family, mapping version, raw code, and available context. | Recoverable environmental result unless the caller violated a contract. | Diagnostics render portable category first and raw target detail second; JSON carries stable keys and schema version. |

> Trace: D402, D452, D455, D466
> Covers: Domain failures, validated wrappers, bug classification, and versioned OS-backed errors preserve portable category, raw target detail, context, and compatibility behavior explicitly.
