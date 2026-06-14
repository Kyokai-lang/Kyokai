# Why Kyokai Uses One Generated-C Backend

[Rikona Kurasaki / Mjoyufull]
> ProofTrace: SPEC-RATIONALE-09-BACKEND-CHOICE
> Covers: This chapter is registered in the public ProofTrace evidence graph; registration does not claim implementation, conformance, performance-budget completion, or theorem completion.

A compiler backend looks small from the source side. One arrow leaves checked IR, and a binary appears at the other end. Under that arrow sit calling conventions, register allocation, object formats, unwind tables, debug records, target intrinsics, linkers, sanitizers, profilers, platform SDKs, and every optimizer decision that can expose a bad assumption. Maintaining another arrow means maintaining another copy of that pressure.

Kyokai therefore maintains one code-generation path: checked Kyokai IR to a defined generated-C subset, then through an admitted external C toolchain. The decision is not that LLVM, Cranelift, QBE, or native code generation are poor systems. Each solves a real problem. The decision is that Kyokai's priorities are served better by concentrating semantic preservation, conformance, debugging, platform admission, and compile-time work on one path.

> Trace: D4, D139, D228, D530-D536
> Covers: Kyokai has one generated-C backend, no backend selector, and no direct LLVM, Cranelift, QBE, custom-native, assembly, bytecode, or tiered alternate backend.

## The Decision Boundary

The generated-C backend is not permission to emit arbitrary C and trust whichever `cc` happens to be installed. Kyokai emits a documented C11 subset, admits compiler-family and target combinations through testable contracts, records every external-tool invocation, and rejects a build when the selected path cannot preserve Kyokai semantics.

GCC, Clang, Apple Clang, clang-cl, assemblers, linkers, archivers, debuggers, coverage tools, and profilers are external target tools. They are not separately selectable Kyokai backends. Clang can use LLVM internally without turning Kyokai into a direct LLVM client. GCC can use its own optimizer without creating a second Kyokai semantic lowering. The maintained Kyokai boundary remains generated C plus the admitted toolchain contract.

This distinction matters. Kyokai owns one representation mapping, one checked-failure lowering, one layout mapping, one source-map schema, one generated-code conformance suite, and one place where C undefined behavior must be excluded. Compiler-family adapters still exist, but they adapt flags, extensions, diagnostics, object/debug formats, and target facilities around the same generated program model.

> Trace: D31, D80, D139, D228, D530-D535
> Covers: External compiler variation is admitted toolchain variation around one semantic emission path, not multiple language implementations.

## Why Generated C

C is useful here because operating systems, SDKs, cross toolchains, linkers, debuggers, profilers, and foreign libraries already meet at its ABI and object-toolchain boundary. Emitting C lets Kyokai reuse that installed platform knowledge instead of reproducing it separately for every object format and calling convention.

That reuse is not free. The external compiler must parse and lower generated source. Some Kyokai ownership facts are difficult to preserve as optimization facts in C. Exact source-level variable locations can be lost. Compiler extensions differ. Cross-package optimization can be obscured by generated-unit boundaries. These are accepted costs, not facts the spec hides.

Kyokai addresses those costs directly:

- deterministic package, module, and materialization C units limit recompilation;
- `.koi` reuse, object caching, prebuilt standard-library and Bridge objects, parallel compilation, and incremental linking protect the daily loop;
- a strict generated subset avoids C undefined behavior and unsequenced evaluation;
- compiler admission tests ABI, atomics, TLS, floating point, diagnostics, debug data, deterministic output, and runtime behavior;
- `#line` records and authoritative Kyokai sidecar maps keep diagnostics, fatal reports, debugging, coverage, and profiling source-oriented;
- target/compiler extensions are named contract entries rather than accidental ambient features;
- release builds can use admitted C-toolchain LTO, PGO, vectorization, and CPU dispatch without adding another Kyokai lowering path.

The result is one backend with several admitted external toolchains, not one language semantics per C compiler.

> Trace: D79, D83, D139, D149, D228, D531-D535
> Covers: Generated C buys platform reuse only under defined emission, admission, source mapping, reproducibility, and incremental-build contracts.

## Why Not Direct LLVM

LLVM is the strongest rejected alternative. It provides a mature target-independent code generator, extensive target machinery, optimization infrastructure, debug metadata, sanitizers, and scalable LTO facilities. Those are substantial benefits. Kyokai does not reject their quality.

A direct LLVM backend would still make Kyokai responsible for a second maintained semantic translation: checked Kyokai IR to LLVM IR. That path would need its own layout and ABI lowering, poison and undefined-value discipline, checked-failure preservation, atomics mapping, intrinsics, debug metadata construction, target feature policy, optimizer-version compatibility, diagnostics, conformance tests, and release support matrix. Keeping generated C as a portability path beside it would duplicate the highest-risk backend obligations instead of removing them.

LLVM also does not satisfy Kyokai's compile-time goal merely by being mature. Deep optimization, whole-program analysis, and link-time optimization trade time for output quality. LLVM's own documentation describes a large target-independent code-generation pipeline, and Clang's ThinLTO documentation describes scalable and incremental LTO rather than cost-free optimization. Kyokai uses those capabilities indirectly when an admitted Clang toolchain is appropriate, but it does not force every Kyokai implementation and contributor through a direct LLVM integration.

The cost of this decision is less direct access to LLVM IR metadata, target intrinsics, and pass control. Kyokai accepts that cost because direct LLVM control is less important than one auditable lowering, broad C-toolchain reach, and predictable ownership of the compile-time budget.

> Trace: D4, D228, D530, D534
> Covers: Direct LLVM is rejected as a maintained Kyokai backend because its benefits do not justify a second semantic, ABI, debug, conformance, and optimization-integration path.

## Why Not Cranelift

Cranelift is designed as a retargetable code generator and is production-used through Wasmtime. Its project documents fast compilation, production use, fuzzing, ongoing formal-verification work, and backends for x86-64, AArch64, s390x, and RISC-V 64. Those properties align with Kyokai's concern for compile speed and correctness.

They do not close Kyokai's full backend problem. Cranelift's documented target set is narrower than the C-toolchain reach Kyokai wants for hosted, cross, embedded, kernel, and freestanding work. Its official integration surface is a collection of Rust crates whose APIs are not declared stable. Kyokai's current compiler is OCaml and its destination is self-hosted Kyokai, so direct use introduces a maintained language/FFI integration boundary or a Rust-owned compiler component.

Cranelift would also require Kyokai-owned ABI lowering, object emission, debug/source integration, unwind behavior, target intrinsics, sanitizer strategy, and conformance for every admitted platform. Keeping generated C for the targets and tools Cranelift does not cover would create the multi-backend matrix D530 rejects.

Cranelift is therefore good prior art for fast code generation, verification, fuzzing, and avoiding unnecessary optimizer work. It is not Kyokai's maintained backend.

> Trace: D530, D532, D534
> Covers: Cranelift is rejected because its integration and target/tooling surface would add another maintained path without replacing Kyokai's portability path.

## Why Not QBE

QBE makes an unusually clear trade: its project aims for a compact backend with a useful fraction of industrial optimizer performance, a simple SSA IL, full C ABI support on its supported targets, and a small codebase. That is valuable prior art for keeping a compiler understandable.

The same deliberate scope is the reason Kyokai does not select QBE as its sole backend. QBE's official target list is AMD64, ARM64, and RISC-V 64. Kyokai's target contract includes a broader hosted and systems-toolchain direction, and its required debugging, sanitizer, coverage, profiling, inline-assembly, strict-float, and target-intrinsic surfaces exceed the contract QBE claims to provide as a small backend.

Using QBE for fast builds while retaining generated C for broader targets and optimizing releases would again create two semantic lowering paths, two debug stories, and a cross-backend conformance obligation. The small implementation would not make that duplicated Kyokai work small.

> Trace: D530-D534
> Covers: QBE is respected as compact backend prior art but rejected as Kyokai's sole or fast-tier backend because its declared scope does not replace the required target and tooling contract.

## Why Not A Custom Native Or Assembly Backend

A custom native backend offers maximum control. Kyokai could tune instruction selection, register allocation, object emission, and debug behavior around its exact IR. A narrow native backend can also compile quickly.

The price is ownership of the entire machine boundary: calling conventions, register classes, instruction encodings, relocation models, object formats, linkers, unwind tables, stack maps, TLS, atomics, vector instructions, debug information, platform security features, exception boundaries, CPU dispatch, and every target-specific defect. Supporting one architecture well is a major subsystem. Supporting Kyokai's platform direction multiplies it.

That work would compete directly with the frontend, proof, standard library, package system, diagnostics, Analysis Server, and source-level debugging work that distinguishes Kyokai. It would also create the easiest place for a low-level miscompile to escape the language's no-undefined-behavior promise. Kyokai does not accept that maintenance and assurance burden merely to avoid invoking a C compiler.

> Trace: D73, D139, D228, D530
> Covers: A custom native backend is rejected because target breadth and assurance would require Kyokai to own the complete machine-code, ABI, object, unwind, and debug stack.

## Why Not Multiple Or Tiered Backends

The familiar proposal is one fast backend for daily builds and one optimizing backend for releases. It can work for projects with the staff and testing budget to maintain both. It is not free speed.

Every backend must preserve evaluation order, ownership, moves, layout, checked arithmetic, contracts, TPOE, panic, atomics, volatile operations, FFI, inline assembly, source mapping, debugging, coverage, profiling, and target behavior. Every backend also expands cache identity, CI, release qualification, bug reproduction, platform admission, and user support. A mismatch can make a program pass tests in the daily lane and fail only in the shipping lane, which is the worst point to discover semantic drift.

Kyokai instead makes the one generated-C path serve both purposes. `debug` minimizes external optimization and maximizes incremental reuse. `release` enables the admitted optimizer, LTO, PGO, and CPU settings selected by the project. The profile changes optimization and observability, not the semantic emitter or language implementation.

> Trace: D31, D83, D228, D530, D534, D536
> Covers: Kyokai rejects fast/release backend splitting because each backend duplicates preservation, tooling, cache, CI, target, and release obligations.

## Why Not Trust Arbitrary C Compilers

Choosing generated C does not mean the host compiler becomes unreviewed authority. Different C compilers and versions disagree about extensions, diagnostics, debug formats, atomics, TLS, floating-point controls, linkers, and reproducibility. A compiler can accept C11 syntax and still fail Kyokai's semantic or tooling contract.

Kyokai therefore admits exact compiler-family, version, target, SDK/sysroot, linker, archive, debug-format, and extension combinations. Unknown or mismatched combinations fail before compilation. Ambient `cc` discovery is evidence gathering, not automatic trust. TCC is not admitted merely because it is fast. CompCert is an independent evidence lane where its subset and targets fit, not a second backend or a stronger language profile.

This is the line between a generated-C architecture and outsourcing correctness.

> Trace: D80, D139, D149, D532, D535
> Covers: C-toolchain admission prevents arbitrary external compilers from silently defining Kyokai behavior.

## What Could Reopen The Decision

D530 is the accepted architecture. Replacing it requires a new D-point, not an implementation experiment that quietly becomes permanent. A replacement case must show, with public evidence, that it removes rather than duplicates the generated-C path, preserves or improves target reach, meets the same ABI/debug/sanitizer/profiling obligations, satisfies Kyokai's compile-time gates on named workloads, and carries a sustainable conformance and maintenance plan.

A backend's popularity, benchmark headline, implementation language, or promise of faster code generation is not enough. The relevant unit is the whole Kyokai contract: semantics, compile time, runtime quality, platforms, diagnostics, debugging, observability, reproducibility, and maintenance together.

> Trace: D155, D530-D536
> Covers: Reconsidering the architecture requires a new accepted decision backed by whole-contract evidence rather than an untracked alternate implementation.

## Primary References

- ISO C11 committee draft N1570: <https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1570.pdf>
- LLVM target-independent code generator: <https://llvm.org/docs/CodeGenerator.html>
- LLVM source-level debugging: <https://llvm.org/docs/SourceLevelDebugging.html>
- Clang ThinLTO: <https://clang.llvm.org/docs/ThinLTO.html>
- Clang sanitizers: <https://clang.llvm.org/docs/UsersManual.html#controlling-code-generation>
- Cranelift project documentation and status: <https://github.com/bytecodealliance/wasmtime/tree/main/cranelift>
- QBE project and scope: <https://c9x.me/compile/>
- GCC C dialect controls: <https://gcc.gnu.org/onlinedocs/gcc/C-Dialect-Options.html>
- GCC line-control behavior: <https://gcc.gnu.org/onlinedocs/cpp/Line-Control.html>
- Clang source-based coverage: <https://clang.llvm.org/docs/SourceBasedCodeCoverage.html>
- CompCert verified compiler: <https://compcert.org/>

These references establish the claimed scope and capabilities of the alternatives and external C-toolchain facilities. They do not prove Kyokai's generated-C implementation correct or fast; D532-D535 require Kyokai-specific admission, conformance, source-mapping, and benchmark evidence.
