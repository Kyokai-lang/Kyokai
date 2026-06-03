# Text, Bytes, Paths, And Strings

[Rikona Kurasaki / Mjoyufull]
> ProofTrace: SPEC-STDLIB-04-TEXT-BYTES-PATHS-AND-STRINGS
> Covers: This chapter is registered in the public ProofTrace evidence graph; registration does not claim implementation, conformance, or theorem completion.

Text looks gentle until it crosses a boundary. Then the old lies appear: bytes pretending to be words, paths pretending to be strings, C strings hiding a zero byte like a knife under the table. Kyokai keeps those shapes separate.

> Trace: D30-D30a, D54, D68-D69, D120, D201
> Covers: Text, byte, C-string, OS-string, path, parsing, and conversion APIs use separate named contracts.

## Text Model

`String` is owned linear UTF-8 text with stored allocator identity. Moving a `String` transfers ownership of its allocation and allocator identity. Destroying a `String` releases its owned storage through the allocator stored in the value.

> Trace: D30-D30a, D44, D201
> Covers: `String` ownership, encoding, and allocation identity are explicit.

`StaticString` is immutable compile-time UTF-8 text produced by plain, raw multiline, and explicit `static "..."` literals. It is not allocator-owned, not destroyable storage, and not retargeted by contextual typing into `String`. `literal.toStringIn(allocator)` allocates an owned `String` with the explicit destination allocator and returns `Result[String, AllocError]`.

> Trace: D120, D201
> Covers: Static text and owned text are separate values with explicit allocation on conversion.

`TextView[R]` is a `Free` non-owning immutable UTF-8 view tied to region `R`. It owns no storage. A `TextView[R]` is constructed explicitly from `StaticString`, an immutable borrow of `String`, or a byte view after successful UTF-8 validation. It cannot outlive its source region and cannot expose mutable bytes. Read-only text APIs take `TextView[R]` when they do not need ownership, mutation, or allocator-backed storage.

> Trace: D30-D30a, D77, D372
> Covers: The borrowed UTF-8 view has a nominal name, an explicit source relation, no storage ownership, and no mutable-byte escape.

Text indexing is not byte indexing unless the API name says byte. Character, scalar, grapheme, and byte views are different contracts. No stdlib API silently normalizes Unicode, accepts invalid UTF-8, or reinterprets bytes as text.

> Trace: D30-D30a, D54, D85, D372
> Covers: Text view boundaries and Unicode behavior are explicit.

| API Family | Ownership | Allocation | Failure | Capabilities | Platform | Tests | Trace |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `String` construction | Consumes or borrows source according to `from*`, `to*In`, or `into*`. | Fresh owned results take explicit allocator and store it. | `AllocError`; invalid UTF-8 returns `TextError` unless compile-time literal validation rejects it. | None. | UTF-8 on all targets. | valid/invalid UTF-8, empty, embedded NUL, allocation failure. | D30-D30a, D54, D74, D201 |
| `StaticString` | Borrowed immutable static data. | None. | Literal syntax errors are compile-time diagnostics. | None. | UTF-8 on all targets. | literal escaping, zero length, non-ASCII, invalid escape rejection. | D54, D120 |
| `TextView[R]` slices/views | Borrow validated UTF-8 source; cannot outlive region `R`. | None. | Bad checked bounds are TPOE; byte validation returns `Result`. | None. | UTF-8 on all targets. | boundary indices, scalar boundaries, invalid byte offsets, source-region escape rejection. | D30-D30a, D77, D372 |
| Text formatting/parsing | Borrows or consumes by named contract. | Formatting to owned text takes allocator; sink formatting does not allocate by itself. | `ParseError`, `AllocError`, or sink error as named. | Capability only through sink value. | Locale-independent unless an API explicitly names locale data. | parse failures, round trips, sink prefix failure. | D40-D40a, D69, D102 |

> Trace: D30-D30a, D40-D40a, D54, D69, D74, D77, D102, D120, D201
> Covers: Text API families publish ownership, allocation, failure, authority, platform, and test contracts.

## Bytes

`Byte` data is not text. Byte arrays, byte spans, and byte buffers expose raw octets and do not promise UTF-8 validity. APIs that validate bytes as text have names such as `validateUtf8`, `fromUtf8In`, or another explicit text-conversion form.

> Trace: D30-D30a, D54, D201
> Covers: Bytes and text do not collapse into each other.

`ByteSpan` is a borrowed view. `ByteBuffer` is owned growable storage with stored allocator identity. Operations that append, encode, decode, compress, hash, or parse bytes must state whether they allocate, whether partial output can be written before failure, and how existing views are invalidated.

> Trace: D44, D74, D77, D85, D201
> Covers: Byte containers inherit allocator and invalidation rules from the memory-container contract.

## C Strings

`CString` is owned NUL-terminated storage suitable for C interop. `CStr` is a borrowed validated C-string view. Constructing `CString` from Kyokai text or bytes checks for interior NUL unless the function name explicitly says it accepts raw bytes and states the resulting contract.

> Trace: D20, D30-D30a, D68, D201
> Covers: C string interop uses dedicated wrappers with validation, ownership, and allocator contracts.

Borrowed `CStr` values are valid only for the lifetime of the underlying storage and must not be used after the foreign call invalidates that storage. Owned `CString` values are linear and destroy through their stored allocator.

> Trace: D68, D77, D245
> Covers: C-string lifetimes and ownership are explicit across FFI boundaries.

## OS Strings And Paths

`OsString` and `OsStr` represent platform-native argument and environment text where the host does not promise UTF-8. `PathBuf` and `Path` represent filesystem paths. A path is not a `String`; APIs that accept filesystem names take path types.

> Trace: D30-D30a, D67, D171
> Covers: Platform-native strings and filesystem paths are separate from ordinary UTF-8 text.

Pure path manipulation is capability-free only when it joins paths, normalizes lexical components, checks extension-like syntax, or views components without consulting host state. Filesystem observation or mutation requires `FileCapability` or an explicitly narrowed `Directory` handle. Environment-dependent path discovery requires `EnvCapability`. Symlink resolution, metadata reads, handle opening, and permission changes are filesystem observations or mutations and therefore use filesystem authority.

> Trace: D67, D85, D171, D211
> Covers: Path syntax work is pure; filesystem authority requires capabilities.

Safe Kyokai has no ambient current-directory semantics. Relative paths are resolved only against an explicit `Directory` handle or a named capability-gated API that returns such a handle. Top-level `FileCapability` path operations accept absolute paths only.

> Trace: D171
> Covers: Relative filesystem behavior names its base directory explicitly.

| API Family | Ownership | Allocation | Failure | Capabilities | Platform | Edge Cases | Trace |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `OsString`/`OsStr` | Owned or borrowed platform string storage. | Owned conversions take allocator. | Encoding conversion returns `TextError` when UTF-8 cannot be produced. | None for pure conversion. | Native OS encoding/representation is documented per target. | invalid native bytes, empty value, embedded NUL where OS rejects it. | D30-D30a, D67 |
| `PathBuf`/`Path` | Owned or borrowed path storage. | Owned path construction takes allocator. | Invalid path syntax returns `PathError` where target rejects it. | None for lexical operations. | Separator, root, drive, and encoding rules are target-specific but specified. | empty, root-only, relative, absolute, reserved names, invalid separators. | D171, D201 |
| Filesystem path operations | Borrows or consumes path and handle as named. | Output paths/strings take allocator. | `IoError`, `PathError`, or `AllocError`. | `FileCapability` or explicit `Directory` handle. | Target support documented per operation. | symlinks, races, missing path, permission denial, non-directory base. | D67, D171, D211 |

> Trace: D30-D30a, D67, D74, D85, D171, D201, D211
> Covers: OS-string and path families publish ownership, allocation, failure, capability, platform, and edge-case contracts.

## Parsing

`Parsable[T]` parses text into a value and returns `Result[T, ParseError]`. Numeric parsers must state accepted syntax, radix rules, signs, separators, overflow behavior, whitespace behavior, and whether the parser consumes the whole input.

> Trace: D69, D75-D76, D85
> Covers: Parsing is typed, fallible, and syntax-explicit.

Parsing bytes requires a byte parser contract. Parsing text requires valid UTF-8. A parser that accepts both must expose two named entrypoints or a parameter whose type makes the boundary visible.

> Trace: D30-D30a, D69
> Covers: Byte parsing and text parsing do not silently share one boundary.

## Structured Codec Profiles

Structured codecs use named profiles rather than one permissive parser whose behavior changes by accident. Toolchain JSON uses the strict UTF-8 `IJsonTool` profile: duplicate object keys are rejected, nesting depth and string/container sizes are budgeted, emitted canonical objects use deterministic key ordering, and numeric values follow the profile's exact integer, decimal, and floating-point rules.

User-facing codec APIs name their mode as `strict`, `permissive`, `streaming`, or `canonical`. A parser receives an explicit allocator and `CodecBudget`, or it consumes a codec value whose constructor stored both. `CodecBudget` records maximum nesting depth, input bytes, string bytes, container elements, output bytes, and work units. Exceeding a budget returns `CodecBudgetExceeded`; it does not silently truncate input, allocate beyond the budget, or become TPOE. Streaming decoders report consumed input, produced output, retained parser state, and recovery or reset requirements after error.

Duplicate-key policy is part of the selected profile and is exactly one of `reject`, `first`, `last`, or `collect`. Numeric policy is selected by API name and schema as exact integer, decimal, or floating-point interpretation. Unknown-field handling is exactly `reject`, `ignore`, or `preserve` according to the schema contract. Canonical encoding states map-key ordering, whitespace, Unicode treatment, numeric spelling, and byte-for-byte output stability.

Generated codecs record schema identity and version, generator provenance, budget defaults, unknown-field policy, duplicate-key policy, numeric policy, canonicalization policy, and compatibility behavior. Hand-written codecs implement the same public contracts. Codec generation remains a manifest-declared generation step; it does not add token macros, derive macros, or hidden source rewriting.

| Codec surface | Allocation | Failure | Determinism | Required tests |
| --- | --- | --- | --- | --- |
| Strict tool JSON | Explicit allocator and `CodecBudget`. | Syntax, UTF-8, duplicate-key, numeric, and budget errors are typed results. | Canonical emission is byte-stable. | malformed corpus, duplicate keys, limits, canonical golden files. |
| User strict/permissive decode | Explicit allocator and `CodecBudget`, directly or through stored codec state. | Selected profile returns typed syntax, schema, numeric, and budget errors. | Profile states ordering and unknown-field behavior. | fuzzing, corpus, round trips, policy matrices. |
| Streaming decode | Stored parser state with explicit allocator and budget. | Error reports consumed input, produced output, retained state, and reset/recovery rule. | Chunking must not change the decoded value for the same profile. | split-point fuzzing, partial input, reset, budget exhaustion. |
| Canonical encode | Explicit destination sink or allocator. | Sink and allocation failures remain visible. | Output is byte-for-byte stable for one schema and codec version. | canonical vectors and cross-run stability. |

> Trace: D297, D413
> Covers: Structured codecs publish exact profiles, allocator and budget flow, duplicate-key and numeric policy, streaming recovery state, schema evolution metadata, deterministic canonical encoding, and generation provenance.

## Why This Shape

[Rikona Kurasaki / Mjoyufull]
The standard library never makes the programmer guess whether a value is language text, protocol bytes, a C argument, or a path crossing into the operating system. Those are different rooms. Kyokai keeps the doors labeled.

> Trace: D30-D30a, D68-D69, D171
> Covers: Separate text, byte, C-string, OS-string, and path contracts prevent hidden boundary behavior.

## Static Text, Unicode Versions, And Target-Native Paths

A plain, raw multiline, or explicit `static "..."` source literal denotes a `StaticString`: immutable artifact-backed UTF-8 bytes plus encoding metadata. Evaluation allocates nothing, stores no allocator identity, and acquires no authority. `literal.toStringIn(allocator)` creates owning `String` storage and returns `Result[String, AllocError]`.

Unicode-sensitive APIs name their Unicode data version and algorithm: scalar validation, grapheme segmentation, case mapping, normalization, display width, and identifier-oriented rendering are separate operations. Updating Unicode tables changes the recorded data version and does not silently change package, docs, cache, or replay identity where the algorithm participates.

Path operations follow the selected target contract. `Path` and `PathBuf` preserve target-native path representation; conversion to or from UTF-8 text is explicit and fallible when the target representation is not UTF-8. A portable API never treats a path as a display string or assumes one separator, root, case, normalization, or current-directory rule across targets.

| Surface | Storage Or Representation | Allocation | Failure | Target Fact |
| --- | --- | --- | --- | --- |
| `StaticString` | Artifact-backed immutable UTF-8 view. | None. | Literal diagnostics before runtime. | UTF-8 literal contract. |
| `String` | Linear owning UTF-8 storage with allocator identity. | Explicit allocator-taking construction. | `AllocError` and validation errors as named. | Portable UTF-8 text. |
| `OsStr`/`OsString` | Target-native process/env text representation. | Owned conversion takes allocator. | Explicit conversion error. | Process/env encoding class. |
| `Path`/`PathBuf` | Target-native path representation. | Owned conversion takes allocator. | `PathError`, conversion error, or OS error. | Filesystem and path representation class. |

> Trace: D399, D408, D420, D476, D483
> Covers: Static literal storage, Unicode algorithm versions, and target-native paths are explicit and allocator-aware.
