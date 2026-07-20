# Memory Layout And Backend Contract

[Rikona Kurasaki / Mjoyufull]
> ProofTrace: SPEC-LANGUAGE-17-MEMORY-LAYOUT-AND-BACKEND-CONTRACT
> Covers: This chapter is registered in the public ProofTrace evidence graph; registration does not claim implementation, conformance, or theorem completion.

Kyokai defines field layout classes, value movement, result placement, evaluation order, and checked failure before backend lowering. Generated C and the selected target toolchain must preserve those rules or reject the build.

Neither C semantics nor external-compiler behavior may redefine an accepted Kyokai program.

> Trace: D4, D42, D73, D89, D139, D199, D228, D530-D536
> Covers: Layout and lowering are language/backend contracts, not backend folklore or optimizer luck.

This chapter defines ordinary layout, extern layout, packed layout, layout introspection, move and result-placement lowering, backend-independent semantics, generated C obligations, C-toolchain admission, debug/source mapping, and target/toolchain failure behavior.

> Trace: D27, D31, D80, D83, D141, D196, D217, D247
> Covers: Backend output must preserve Kyokai values, checks, atomics, source mapping, reproducibility, and target contracts.

## Backend Independence

Kyokai language semantics are backend-independent. No language rule is defined as "whatever the C backend emits" or "whatever the target C compiler accepts or optimizes today".

> Trace: D4, D73, D228
> Covers: Backends implement Kyokai; they do not define it.

Kyokai maintains one backend: checked Kyokai IR to generated C. GCC, Clang, Apple Clang, clang-cl, assemblers, linkers, archivers, debuggers, and profilers are external target toolchains, not additional backends. Direct LLVM, Cranelift, QBE, custom-native, assembly, bytecode, and alternate code-generation backends are absent.

> Trace: D4, D139, D530
> Covers: One maintained lowering path keeps semantics and evidence concentrated without making C the language definition.

Generated C is not a stable hand-maintained interchange language. It can use named target/compiler extensions, helper code, and intrinsic families when the admitted toolchain contract records them and the lowering remains defined for every valid Kyokai program.

> Trace: D4, D104, D228, D530-D532
> Covers: Kyokai features are judged by the language contract; the C toolchain contract must then implement them exactly or reject the target.

If the generated-C path and selected target/toolchain contract cannot implement a source construct with the required Kyokai semantics, the build fails. The compiler must not silently weaken checks, change layout, change memory ordering, drop debug/source obligations, or reinterpret failure behavior to make the external toolchain accept the program.

> Trace: D4, D31, D80, D139, D228
> Covers: Backend limits are explicit build failures, not semantic drift.

## Layout Classes

Every record is exactly one of three layout classes: ordinary `record`, `extern record`, or `packed record`.

> Trace: D42
> Covers: Record layout is a closed type-level choice.

Kyokai has no open-ended `repr(...)` attribute system, no backend-chosen ordinary layout, no hidden field reordering, no automatic C-layout inference, and no hidden niche/layout optimization in ordinary language layout.

> Trace: D42, D73
> Covers: Layout does not depend on backend guessing.

## Ordinary Record Layout

An ordinary `record` uses Kyokai layout. Field order is the source order written by the programmer. The compiler never reorders ordinary record fields.

> Trace: D35, D42
> Covers: Source field order is semantic for ordinary records.

Each field starts at the smallest offset greater than or equal to the end of the previous field that satisfies that field type's alignment. The record alignment is the maximum alignment of its fields. The record size is rounded up to a multiple of that record alignment.

> Trace: D42
> Covers: Ordinary record offsets, alignment, and size are defined by the language.

User-specified over-alignment, under-alignment, C bitfields, backend-defined bitfields, and hidden niche optimizations are not part of ordinary record layout.

> Trace: D42, D116
> Covers: Ordinary records do not import C layout folklore.

An ordinary single-field record is representation-transparent inside Kyokai's own layout and calling model: its size, alignment, and sole field offset match the field type, and passing, returning, storing, and loading behave as though the wrapper had the same representation as its field.

> Trace: D109/D196
> Covers: Nominal wrappers are zero-cost inside Kyokai layout.

Representation transparency does not create type equality, implicit conversion, alias identity, shared typeclass instances, or FFI eligibility. The wrapper remains a distinct nominal type.

> Trace: D190, D196
> Covers: ABI equality is not type identity.

## Extern Record Layout

An `extern record` uses the selected target's C ABI layout rules for its exact field list and field order. Field order remains source order; Kyokai does not reorder extern fields.

> Trace: D20a, D42, D80
> Covers: Extern records are explicit target-C-ABI aggregates.

A record may cross raw `foreign "C"` by value only if it is an `extern record` and every field is FFI-admitted under the unsafe/FFI chapter. Ordinary records and packed records do not cross raw C by value merely because their current representation looks compatible.

> Trace: D20a, D42, D242a
> Covers: By-value aggregate FFI requires explicit extern layout.

If a target C ABI cannot define the extern record's field layout, alignment, passing convention, or return convention under the selected C-toolchain contract, the declaration is illegal for that target/toolchain path.

> Trace: D20a, D31, D80
> Covers: Extern record support is target-contract checked.

`extern record` does not permit fields of `extern type` by value, Kyokai sum types by value, ordinary borrows, capabilities, or raw types outside the admitted FFI surface.

> Trace: D20a, D42, D242a, D255
> Covers: Extern layout does not open the whole Kyokai type system to C.

## Packed Record Layout

A `packed record` is byte-tight. Fields remain in source order with no implicit padding between fields. The record alignment is 1. The record size is the sum of its field sizes.

> Trace: D42
> Covers: Packed records have exact byte-tight Kyokai layout.

Reading or writing a packed field uses copy semantics, not reference semantics. The implementation must behave as though it copies bytes into or out of a properly aligned temporary of the field type when alignment requires that.

> Trace: D42, D73
> Covers: Packed access cannot create misaligned safe references.

Taking `&read value.field` or `&write value.field` is illegal for a packed field. Packed fields cannot produce ordinary Kyokai borrows because that could create potentially misaligned references.

> Trace: D14, D42, D73
> Covers: Packed layout preserves borrow/reference alignment guarantees.

`packed` does not imply C ABI compatibility, bitfields, byte swapping, network byte order, device register semantics, or endianness conversion. Any byte-order conversion at FFI, file, network, packed-layout, or container boundaries must be written explicitly.

> Trace: D42, D117/D260
> Covers: Packed layout and endianness are separate contracts.

`extern packed record` and equivalent combined layout classes are illegal. If a foreign API requires a packed C struct, the boundary must use explicit unsafe marshaling or raw byte storage under an unsafe contract.

> Trace: D20a, D42, D245
> Covers: Packed C ABI edge cases go through unsafe wrappers.

## Bitrecords And Non-Byte Layout

Non-byte-aligned field descriptions use `bitrecord`, not C-style bitfields. A `bitrecord` is a value over a fixed-width unsigned backing integer with explicit bit positions.

> Trace: D116
> Covers: Register and protocol fields are defined by masks and shifts, not C bitfields.

When stored in memory, a `bitrecord` has exactly the storage of its backing integer type. The generated-C emitter lowers bitrecord access with masks, shifts, and equivalent helper code. It never emits C bitfields as the semantic implementation strategy.

> Trace: D116, D139
> Covers: Bitrecord lowering avoids backend-defined bitfield layout.

## Layout Introspection

`sizeOf(T)`, `alignOf(T)`, and `offsetOf(T, field)` are compile-time-only built-ins. They are evaluated through `comptime` and use the declared layout class of `T`.

```kyokai
constant HeaderSize: Index := comptime sizeOf(Header);
constant HeaderAlign: Index := comptime alignOf(Header);
constant LengthOffset: Index := comptime offsetOf(Header, length);
```

> Trace: D18/D18a, D42
> Covers: Layout introspection is deterministic compile-time evaluation.

For ordinary records, these built-ins use Kyokai layout. For `extern record`, they use the selected target C ABI layout. For `packed record`, they use byte-tight packed layout. They never use backend guesses.

> Trace: D42, D80
> Covers: Layout introspection follows the type's declared layout class.

`sizeOf`, `alignOf`, and `offsetOf` are illegal for `extern type` by value because the type has unknown size and layout. They are legal for pointer/address forms that mention an `extern type`, because the pointer/address representation is known by the target ABI.

> Trace: D20a, D42
> Covers: Opaque foreign types remain opaque to layout introspection.

## Recursive Layout

Recursive and mutually recursive nominal types are legal only when the fully expanded representation has finite size. Every cycle in the layout-dependency graph must pass through an indirection-bearing field.

> Trace: D160/D217
> Covers: Recursive layout legality is representation-based, not name-based folklore.

Inline constructors, inline record fields, and inline union payloads do not break a layout cycle. `Box[T]`, raw pointer/address forms, and other specified indirection-bearing forms may break cycles according to their type contracts.

> Trace: D160/D217
> Covers: Infinite-size representations are rejected at declaration checking.

A compiler may compute recursive layout legality with any internal graph algorithm. The observable result must match the finite-layout rule and produce diagnostics that identify the cycle and the missing indirection boundary.

> Trace: D29, D160/D217
> Covers: Recursive layout diagnostics expose the actual representation cycle.

## Move Representation

Moving a value has as-if bytewise relocation semantics. The destination receives the exact representation bytes of the source value, and the source location becomes logically dead immediately after the move.

> Trace: D89
> Covers: Move semantics are physical enough to reason about and backend-independent.

The language contract is the as-if rule, not a requirement that the backend emit `memcpy` at every move site. A backend may optimize moves away, fuse them, lower them through registers, use hidden output storage, or otherwise avoid physical copying when observable behavior matches the as-if relocation model.

> Trace: D89, D228
> Covers: Optimizing moves is legal only under the Kyokai move contract.

Safe movable values must not depend on their own storage address. Self-referential ordinary movable values are banned in safe code. Unsafe code that constructs address-sensitive values must expose them through stable-address indirection or pinned-type rules before safe code can observe them.

> Trace: D89, D89a/D89b
> Covers: Address-sensitive values cannot cross into safe code as ordinary movable values.

A moved-from place is dead. Later reads, borrows, moves, destruction, deferred cleanup registration, or assignment uses that would observe the old value are compile errors unless the assignment rule explicitly reinitializes a mutable place before observation.

> Trace: D89, D195
> Covers: Backend move optimization cannot weaken moved-state checking.

## Pinned And Stable-Address Values

A `pinned record` or `pinned union` does not participate in ordinary move semantics. Safe operations that relocate it are compile errors: by-value passing, by-value return, assignment after initialization, swapping, destructuring, field extraction by value, and storage in containers whose safe operations may relocate elements.

> Trace: D89b
> Covers: Pinned types are declaration-site non-movable values.

A type containing a pinned field inline must itself be declared pinned. Generic code may relocate a type parameter only when its constraints include `T: Movable` or an equivalent intrinsic movable condition.

> Trace: D89b
> Covers: Non-movability propagates through inline representation.

`PinBox[T]` owns stable-address storage for pinned values. Moving the `PinBox[T]` value never relocates the pointee. The API must not expose a safe operation that extracts the pinned pointee by value.

> Trace: D89b
> Covers: Stable pointee storage is explicit and API-enforced.

Ordinary `Box[T]` is still ordinary indirection. It gives separate pointee storage, but it does not make `T` pinned. Any operation that moves the pointee out of a box is legal only when `T: Movable`.

> Trace: D89a/D89b
> Covers: Plain boxes are not hidden pin wrappers.

## Direct Result Placement

If a function's return type has size greater than two machine words on the selected target, the implementation must use direct result placement semantics.

> Trace: D199
> Covers: Large return values have a guaranteed lowering shape.

Under direct result placement, the callee initializes storage already designated as the caller's final result object. The implementation must not require an additional full-width relocation of that completed result merely to hand it back to the caller.

> Trace: D89, D199
> Covers: Large returns are not dependent on optimizer folklore.

The guarantee is independent of debug/release profile, optimization level, and admitted C compiler choice. For return types of size two machine words or smaller, the implementation may use registers, direct result placement, or another equivalent lowering, provided Kyokai's as-if move semantics are preserved.

> Trace: D31, D89, D199
> Covers: Return placement semantics do not change by profile.

Direct result placement does not create a safe-language stable-address guarantee, does not permit self-referential movable values, and does not weaken pinned-type rules. It is a calling/result-lowering rule, not a pinning rule.

> Trace: D89, D89b, D199
> Covers: Result placement and stable-address typing stay separate.

## Defined Lowering Contract

Lowering from elaborated Kyokai into generated C must preserve the source program's specified Kyokai outcomes.

> Trace: D228
> Covers: Backend lowering is preservation of Kyokai semantics.

C undefined behavior, signed overflow, invalid aliasing assumptions, unchecked trap-producing operations, target-specific unreachable assumptions, or speculative removal of checked failure paths must not be used as the mechanism for implementing safe Kyokai semantics.

> Trace: D73, D139, D228
> Covers: Safe Kyokai semantics cannot be implemented by backend UB.

TPOE and runtime-fatal paths lower to explicit no-return termination operations or checked branches whose existence cannot be optimized away by assuming the failed condition is impossible.

> Trace: D84, D139, D228
> Covers: Fatal checks remain real backend control flow until proven unreachable by Kyokai semantics.

Safe `unreachable;` lowers to `emit_tpoe_unreachable(span/payload); noreturn`. Generated C can contain a compiler-specific unreachable marker only after that non-returning operation as a dead-code marker admitted by the target/compiler contract. It must not lower safe `unreachable;` directly to C undefined behavior, a bare `__builtin_unreachable`, or an optimizer assumption. Coverage and diagnostics distinguish a source `unreachable;` TPOE site from statically unreachable code and generated-only dead-code markers. Conformance inspects generated C for this rule.

> Trace: D121, D228, D355
> Covers: Safe source `unreachable;` has one explicit TPOE lowering contract before any backend dead-code marker.

The compiler may attach aliasing, lifetime, `noalias`, alignment, initialization, non-null, range, or dereferenceability metadata only when justified by the elaborated borrow, linearity, type, and contract model.

> Trace: D14, D73, D89, D195, D228
> Covers: Backend metadata must be earned by checked Kyokai facts.

If the compiler cannot justify stronger backend metadata for a construct, it must omit that metadata or fail the build. It must not emit unjustified metadata to recover performance.

> Trace: D228
> Covers: Optimizer hints cannot become lies.

Surface constructs with specified desugarings lower through the elaboration pipeline before linearity, borrow, capability, contract, unsafe, and backend checks rely on them.

> Trace: D238-D240, D228
> Covers: Backends see checked elaborated core, not raw sugar.

Backend optimizations may remove redundant checks only after proving the removed failure path is unreachable under Kyokai semantics. They must not remove checks merely because the backend would treat the failing case as undefined.

> Trace: D73, D84, D228
> Covers: Check removal is proof-driven, not UB-driven.

## C Backend Contract

Generated C for valid Kyokai programs stays inside Kyokai's documented C11 subset unless the selected target toolchain contract explicitly admits a named extension or intrinsic family. C17 modes can compile this same subset. C23 is not the generated-source baseline.

> Trace: D31, D80, D139, D531
> Covers: Generated C is constrained by a written supported-toolchain contract.

C11 is the baseline because it provides the oldest broadly available standard facilities Kyokai needs directly: static assertions, alignment, no-return declarations, thread-local syntax, and atomics. C17 adds defect corrections but no required Kyokai lowering facility. C23 support is not yet uniform enough across the major hosted, SDK, embedded, bootstrap, and freestanding toolchains to replace the baseline. A later specification revision can change the dialect contract only with matching compiler and platform conformance obligations.

> Trace: D531
> Covers: The C dialect floor is an evidence-backed portability contract, not an arbitrary version preference.

The selected C compiler family, version floor, required flags, sysroot, target triple, and admitted extension families are part of the toolchain and target contract. Unknown or unsupported combinations fail the build.

> Trace: D31, D80, D139
> Covers: C backend behavior is not host-compiler guessing.

The generated-C emitter must preserve Kyokai's left-to-right evaluation order. It must not rely on C's unconstrained expression evaluation order. When needed, it introduces temporaries and statement sequencing in generated C.

> Trace: D71, D139
> Covers: C expression-order holes cannot change Kyokai evaluation.

Kyokai integer semantics are not C integer semantics. Checked arithmetic lowers to explicit checks or checked intrinsics. TPOE behavior comes from those checks, not from C overflow, not from `-fwrapv`, and not from backend traps.

> Trace: D75, D84, D139
> Covers: Integer checks survive the C backend.

The generated-C emitter must not emit strict-aliasing violations. Representation reinterpretation, byte copying, and type punning use `memcpy`-style or equally defined C patterns only.

> Trace: D73, D139
> Covers: C aliasing rules are respected explicitly.

The generated-C emitter must not emit UB-producing shifts, division/modulo by zero, uninitialized reads, null dereference, misaligned typed accesses, invalid lifetime use, or invalid object access for valid Kyokai programs. If a Kyokai operation violates its own contract, generated code must produce the Kyokai-specified failure behavior.

> Trace: D73, D75, D84, D139
> Covers: Backend traps are not substituted for Kyokai checks.

For GCC-family and Clang-family contracts, required defensive flags include the admitted C11-or-C17 dialect mode and the family-specific equivalents of `-fwrapv`, `-fno-strict-aliasing`, and `-fno-delete-null-pointer-checks` where those flags exist. These flags are defensive support, not the source of Kyokai semantics. A compiler family without equivalent switches requires generated-code evidence proving that the emitted subset does not depend on the missing behavior.

> Trace: D31, D139
> Covers: Toolchain flags reinforce but do not define language behavior.

The generated-C emitter may use standard intrinsics, target-contract-listed compiler extensions, generated helper functions, C11 atomics, compiler builtins, or inline assembly facilities only when the selected target/toolchain contract admits them by name.

> Trace: D4, D22, D31, D80, D139, D141
> Covers: C extensions are explicit backend contracts.

CompCert can be used as an independent restricted-C evidence lane where target support and emitted-C subset compatibility exist. It is not a backend, profile, or alternate definition of Kyokai semantics.

> Trace: D139, D532, D536
> Covers: Independent compiler evidence strengthens the C lane without multiplying Kyokai backends or profiles.

## Atomics And Memory Model Lowering

Safe atomic operations lower through the memory model defined in the concurrency chapter. C compiler or target choice does not change `MemoryOrder`, happens-before, compare-exchange result, or fence semantics.

> Trace: D90/D90a, D141, D247
> Covers: Shared-memory behavior is language-level, not backend accident.

`Atomic[T]` lowers through C11 `<stdatomic.h>` when the admitted compiler/target contract implements the required atomic domain. A target-specific builtin adapter is legal only when the target record names it and conformance proves the same semantics. Safe atomics never lower to plain reads/writes or `volatile` accesses.

> Trace: D141
> Covers: C volatile is not atomics.

The compiler must ensure generated atomic storage satisfies the selected target/toolchain's C atomic alignment requirements. If a source-level combination cannot satisfy that contract, compilation fails for that target/toolchain path.

> Trace: D141, D228
> Covers: Atomic alignment failures are build errors, not weakened memory behavior.

## Volatile Lowering

Volatile operations lower according to the unsafe chapter. Generated C uses `volatile` loads/stores for the admitted volatile type domain and the selected compiler contract proves that this lowering preserves the required access.

> Trace: D94/D257, D139, D228
> Covers: Volatile access has target/compiler-specific implementations with one language contract.

Volatile lowering preserves the externally observable volatile access ordering required by the unsafe chapter. It does not create synchronization, atomicity, or happens-before edges.

> Trace: D90/D90a, D94/D257, D247
> Covers: Volatile backend code does not grow hidden concurrency semantics.

## Debug Information And Source Mapping

The generated-C emitter writes `#line N "path/to/File.kyo"` directives and an authoritative sidecar source map. The map records Kyokai byte and line/column spans, declaration and expression identities, generated-helper classes, symbol and local mappings, generic materialization provenance, contract/TPOE site identities, and path-remap facts. Debug profiles compile generated C with the admitted target contract's debug-symbol settings.

> Trace: D27, D31, D533
> Covers: Source-level debugging uses C line mapping plus a Kyokai-owned exact mapping record.

`kyokai debug` configures source directories or substitute paths so breakpoints, stack traces, source listing, and single-stepping resolve Kyokai paths. Complex lowered expressions can map to multiple generated locations, but the mapping must not point to unrelated user source.

> Trace: D27, D29
> Covers: Debug mapping is useful and honest rather than decorative.

The admitted C toolchain emits DWARF, CodeView/PDB, dSYM, or the selected target's equivalent object-level debug information. Kyokai's mapping service joins that output to the sidecar map for debugger adapters, fatal symbolization, sanitizer normalization, coverage, profiler reports, Analysis Server views, and diagnostic rendering.

> Trace: D27, D31, D86, D533
> Covers: External debug formats remain source-oriented through one Kyokai mapping service.

Variable names in debug output preserve Kyokai names when lowering retains a representable source binding. Generated temporaries and helper variables are distinguishable from source variables. Optimized-away or non-representable values are reported as unavailable; the debugger adapter must not invent a value.

> Trace: D27, D29
> Covers: Debugger-visible state does not confuse generated scaffolding with user bindings.

## Coverage And Generated Helpers

Coverage is reported in Kyokai source terms, not generated C or helper-code terms. Coverage points and stable IDs originate in checked Kyokai IR. Generated scaffolding for overflow checks, contract checks, wrappers, helper-state cleanup, or fatal-path plumbing does not count as user-visible coverage.

> Trace: D86, D228
> Covers: Coverage observes the source language, not backend artifacts.

If a target/C-toolchain combination cannot provide conforming Kyokai-source coverage for the requested profile, the toolchain fails explicitly rather than emitting misleading coverage.

> Trace: D31, D80, D86
> Covers: Source coverage does not silently degrade.

## Reproducible Backend Artifacts

Generated C, object files, `.koi` artifacts, final binaries, libraries, source maps, and external-tool build plans inherit Kyokai's reproducible build contract where they are normative build products for a selected mode.

> Trace: D83
> Covers: Backend output is part of the explicit build identity.

Backend output must not vary because of timestamps, filesystem traversal order, host locale, host timezone, random seeds, unstable hash iteration order, or unrelated environment state unless the selected output mode explicitly admits that input.

> Trace: D83
> Covers: Hidden host state cannot perturb reproducible artifacts.

Source paths in debug information are controlled by the selected build profile and target/toolchain contract. If a profile does not allow absolute paths, the toolchain must normalize or remap them so build location does not perturb artifacts.

> Trace: D27, D83
> Covers: Debug path behavior is part of reproducibility.

## Backend Failure Rules

If generated-C lowering or the selected C toolchain cannot preserve Kyokai semantics, compilation fails. The diagnostic names the construct, target, compiler contract, and missing support rule when that information is available.

> Trace: D29, D31, D80, D228
> Covers: Backend rejection is explicit and diagnosable.

The toolchain can reject a program because the target lacks conforming atomics, an extern record has no ABI-supported passing convention, an inline assembly block cannot be lowered, a SIMD intrinsic is unavailable, debug/coverage mode cannot be honored, or the selected C compiler contract cannot support required defined behavior.

> Trace: D22, D31, D80, D104, D139, D141, D228
> Covers: Unsupported backend features are build errors with named reasons.

The compiler and external toolchain contract must not accept the program and then silently change Kyokai semantics, drop checked failure paths, lower atomics as volatile, treat raw pointers as safe references, discard required cleanup, discard required source mapping, or depend on UB-sensitive host behavior.

> Trace: D73, D84, D139, D141, D228
> Covers: Backend acceptance commits to the language contract.

## Backend Conformance Obligations

A conforming backend test suite must include generated-code or runtime tests for:

| Area | Required evidence |
| --- | --- |
| Evaluation order | Side-effecting operands execute left-to-right. |
| Checked arithmetic | Overflow, invalid shifts, division by zero, and bounds checks produce TPOE. |
| Alias and movement | Moves, borrows, packed fields, and raw-address wrappers do not generate invalid aliasing behavior. |
| Layout | `record`, `extern record`, `packed record`, single-field wrappers, and layout introspection match target contracts. |
| FFI | Raw C imports/exports obey admitted type tables and reject linear/sum values by value. |
| Atomics | C11 or explicitly admitted C-toolchain atomic lowering preserves memory orders and rejects unsupported targets. |
| Volatile | Volatile operations are preserved and do not become synchronization. |
| Fatal paths | `panic`, TPOE, runtime-fatal, and stack overflow terminate through specified paths. |
| Debug/source maps | Debug and coverage outputs map to Kyokai source where profile requires it. |
| Reproducibility | Same declared inputs produce bit-identical normative artifacts. |

> Trace: D27, D31, D42, D73, D75, D83, D139, D141, D228
> Covers: Backend conformance tests target the places where backend folklore commonly leaks in.

## Floating-Point Backend Policy

Safe floating operations follow the selected profile's declared float policy. Strict mode records rounding behavior, NaN handling, signed-zero behavior, FMA contraction policy, denormal policy, exception-flag policy, and target caveats. The generated-C/C-toolchain path cannot silently use a faster float interpretation under an existing profile.

> Trace: D298-D300, D400
> Covers: Floating-point lowering is profile-declared and cannot drift through external compiler flags.

## CPU Feature Dispatch

CPU feature dispatch is explicit target, profile, and toolchain policy. Portable SIMD preserves its declared semantics. Target multiversioning records selected feature sets, generated variants, dispatch mechanism, reproducibility inputs, and unsupported-target behavior. Runtime dispatch never changes safe source meaning.

> Trace: D393, D418, D483
> Covers: CPU dispatch is reproducible target policy, not ambient host probing or silent scalarization.

## Semantics-Preserving Code Sharing

Backend optimization, cache sharing, monomorphization deduplication, identical-code folding, and code-size controls are legal only when observable semantics remain identical: values, failure category, side effects, authority, allocation, blocking, volatile behavior, atomic behavior, layout promises, debug and source-map policy, and provenance classification.

> Trace: D200, D480, D497
> Covers: Size and cache optimizations cannot silently merge observably different Kyokai programs.

## Requested Generated C

Requested generated C is a documented artifact lane. It carries generated-file schema, source-map link, package or workspace identity, Kyokai toolchain identity, target, profile, admitted C-toolchain contract, KBI version, provenance, and whether the file participates in target compilation or is inspection-only. The toolchain writes requested C under the documented `c_output/` lane; disposable internal C remains cache state.

> Trace: D264, D509
> Covers: User-requested generated C is a stable provenance-bearing artifact distinct from disposable backend scratch.

## Freestanding Backend Record

A freestanding target record states fatal action, stack policy, allocator availability, runtime shim requirements, interrupt boundary, volatile and MMIO domain, and absent hosted capabilities. The record is part of target admission. The backend does not infer these facts from a C compiler default.

> Trace: D451, D464
> Covers: Freestanding lowering has an explicit target record for the runtime facts hosted systems otherwise supply.

## Translation Validation And Lowering Evidence

The checked frontend lowers into an explicitly sequenced backend IR before C
emission. That IR fixes evaluation order, temporaries, checked arithmetic and
bounds, borrow and lifetime-sensitive accesses, cleanup edges, failure exits,
atomics, volatile operations, calls, layout operations, and source locations.
The emitter does not rediscover these facts from a surface AST.

Each lowering rule and generated helper has a stable evidence ID. Generated C
passes structural validation for the admitted C11 subset before external
compilation. Differential lanes compare normalized observable behavior across
the checked-core interpreter or executable model, backend IR, generated C, and
admitted compiler/target/profile tuples. A disagreement is a compiler defect or
unresolved semantic case; compiler majority cannot select the answer.

Preservation evidence is sliced by operation family and includes success,
defined failure, evaluation order, lifetime, aliasing, layout, atomics, volatile
access, source mapping, and termination. Translation validation is supporting
evidence, not a substitute for the language proof or conformance corpus.

> Trace: D572
> Covers: Generated C is emitted from sequenced checked IR, structurally validated, and compared against spec-owned semantic observations.
