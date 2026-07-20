# Build Profiles, Targets, And Linking

[Rikona Kurasaki / Mjoyufull]
> ProofTrace: SPEC-TOOLCHAIN-04-BUILD-PROFILES-TARGETS-LINKING
> Covers: This chapter is registered in the public ProofTrace evidence graph; registration does not claim implementation, conformance, or theorem completion.

Build profiles, targets, and admitted C toolchains are explicit configuration. They determine optimization, debug information, link mode, target ABI, external tools, and produced artifacts without changing Kyokai language semantics.

> Trace: D27, D31, D80, D83, D139, D149, D200, D530-D536
> Covers: Build profiles, targets, admitted C toolchains, and linking are explicit contracts.

## Profiles

Profiles are named manifest tables under `[profile.<name>]`. The standardized profile names are `debug`, `test`, `release`, and `bench`. Custom profiles are allowed when their fields are explicit or inherited from another named profile.

> Trace: D26, D31
> Covers: Build profiles are named manifest configuration, with conventional standard names and explicit custom inheritance.

A profile may contain these fields:

| Field | Type | Required Meaning | Trace |
| --- | --- | --- | --- |
| `inherits` | string | Copy fields not written in the current profile from another profile. Cycles are illegal. | D31 |
| `optimization` | integer `0`, `1`, `2`, or `3` | Requested optimization class mapped through the admitted C compiler contract. It must not disable safety checks. | D31, D73, D536 |
| `debug_info` | boolean | Emit source/debug metadata for supported targets. | D27 |
| `strip` | boolean | Remove symbols/debug sections only after required diagnostics/provenance artifacts are produced. | D27, D225 |
| `lto` | boolean | Enable link-time optimization when supported by the selected C compiler/linker contract. | D31, D536 |
| `identical_code_folding` | boolean | Permit profile-controlled folding of proven identical generated code. | D200 |
| `panic_backtrace` | string: `off`, `short`, or `full` | Select fatal backtrace detail after CLI precedence and before admitted environment override. | D84, D343 |
| `environment_backtrace_override` | boolean | Permit hosted `KYOKAI_BACKTRACE` override. Reproducible profiles default to `false`. | D343 |
| `main_stack_size` | byte size | Override the selected target default main stack size within its declared range. | D262, D308, D343 |
| `task_stack_size` | byte size | Override configurable task stack default within the target range. | D308, D343 |
| `guard_size` | byte size | Select guard size where the target stack contract permits override. | D262, D308, D343 |
| `frame_pointer` | string policy | Select the recorded frame-pointer policy used by code generation and debug identity. | D27, D308 |
| `sanitizers` | array of strings | Select sanitizer instrumentation admitted by the target/C-toolchain contract. | D225, D308, D532 |
| `path_remap` | array of strings | Map absolute source prefixes for deterministic debug info. | D27, D83 |

> Trace: D27, D31, D73, D83, D84, D200, D225
> Covers: Profile fields are typed, bounded, and visible.

`optimization` must never remove runtime checks required by the language spec. Bounds checks, integer traps where checked arithmetic applies, contract checks, borrow/linearity consequences already enforced at compile time, panic paths, TPOE paths, stack probes required by the target contract, and safe concurrency checks remain semantically present in all profiles. Stable Kyokai has no unsafe-only profile or flag that disables these semantics. A later specification revision could add only a source-visible contract; project approval alone could not weaken the conformance rule.

> Trace: D53, D73, D75-D76, D84, D139, D262
> Covers: Release optimization cannot erase Kyokai safety semantics.

The default profile for `check`, `build`, `run`, and `doc` is `debug`. The default profile for `test` is `test` if present, otherwise `debug`. The default profile for `bench` is `bench` if present, otherwise `release`. `--release` is exactly `--profile release`.

> Trace: D26, D31
> Covers: Profile defaults are fixed and command-visible.

`debug` is the fast daily compilation lane with source maps and symbols, frame pointers where admitted, no stripping, and no LTO. `release` is the one ordinary shipping and maximum-performance lane; LTO, PGO, and CPU-dispatch choices remain explicit recorded settings. `test` and `bench` add their named instrumentation and observability rules. Kyokai has no `dev-fast`, `maximum`, `assurance`, LLVM-release, or backend-selection profile.

> Trace: D536
> Covers: Profiles select build behavior over one C pipeline instead of multiplying backend modes.

## Target Triples And Support Tiers

A target triple is spelled `arch-os-abi`. A target triple is legal only if it appears in Kyokai's target matrix or an imported target-spec file explicitly admitted by the toolchain version. The existence of `target.arch`, `target.os`, or `target.abi` enum values does not create a legal target triple by cartesian product.

> Trace: D19, D80, D149
> Covers: Target triples are closed, explicit support promises, not inferred enum combinations.

A target support entry records the triple, tier, runner availability, admitted C compiler family and version range, C dialect mode, SDK/sysroot, linker and archiver, object/debug format, atomic and TLS support, stack-overflow detection strategy, dynamic-link support, admitted extensions/intrinsics, and known unsupported standard-library families.

> Trace: D31, D80, D139, D141, D149, D262, D531-D532
> Covers: Target support declares exactly what the toolchain promises for each target.

| Tier | Promise | Required Behavior | Trace |
| --- | --- | --- | --- |
| Tier 1 | Release-blocking supported target. | CI builds compiler, stdlib, conformance tests, package tools, and release artifacts for the target. | D80, D225 |
| Tier 2 | Supported but not fully release-blocking. | Compiler and stdlib build regularly; gaps are documented by target support entry. | D80 |
| Experimental | Admitted for development. | Explicitly labeled incomplete surfaces report unsupported features and never silently lower safe Kyokai through UB. | D73, D80, D139 |

> Trace: D73, D80, D139, D225
> Covers: Target tiers are user-visible promises with defined missing-feature behavior.

An unsupported target triple is a front-end configuration error. A supported triple with an unsupported selected compiler contract is a target/toolchain configuration error. The tool must not silently select the host target, another ABI, another compiler family, or another linker.

> Trace: D26, D80, D149
> Covers: Target/C-toolchain mismatch fails early rather than falling back silently.

## Target Configuration

Target configuration lives in `[target.<triple>]` and C-toolchain subtables. The key `spec = "path/to/target.toml"` imports a reusable target-spec TOML file. The importing table can override fields only where the target-spec schema admits override.

> Trace: D31, D80, D149
> Covers: Cross-compilation uses manifest-centered target tables and importable target-spec files.

A target-spec file is part of build identity. Its bytes, normalized path identity, declared schema version, and resolved imported files must be included in reproducibility fingerprints. A missing or unreadable target-spec file is a build configuration error.

> Trace: D83, D149
> Covers: Target-spec files are deterministic build inputs.

The target record names one or more admitted C toolchain contracts through an
ordered `c_toolchain_contracts = ["<contract-id>", ...]` list. A contract records
compiler family, its set of individually admitted builds, dialect mode,
required flags, SDK/sysroot constraints, linker, archiver, object/debug format,
admitted environment keys, extension families, probe commands, and rejection
diagnostics. A displayed version range is only a summary over exact admitted
records. `[build].backend`, `[backend.c]`, `[backend.llvm]`, and `--backend` are
not valid Kyokai configuration.

> Trace: D31, D80, D139, D149, D530-D532
> Covers: Target-toolchain availability is explicit without exposing multiple Kyokai backends.

Release and reproducible profiles resolve exactly one contract and one native
provider into the lockfile and build plan. Development configuration can list
alternatives, but the selected provider remains part of build identity. A
dependency cannot select the workspace provider.

## Generated-C And C-Toolchain Contract

The generated-C emitter writes C only inside Kyokai's supported C dialect and compiler contract. Generated C must preserve Kyokai evaluation order, checked failures, layout, atomics, volatile operations, stack checks, and source mapping without relying on C undefined behavior for safe Kyokai operations.

> Trace: D27, D73, D94, D139, D141, D228, D257
> Covers: The generated-C path is constrained by Kyokai semantics and cannot outsource safety to C UB.

If generated C or an admitted compiler contract cannot represent a Kyokai operation on the selected target, the build fails with a target/toolchain diagnostic. The toolchain must not silently use a weaker operation, scalarize a vector intrinsic that is specified as target-specific, ignore volatile semantics, replace atomics with non-atomic accesses, or erase stack-overflow detection.

> Trace: D73, D80, D94, D104, D141, D257, D262
> Covers: Backend limitations are diagnostics, not semantic substitutions.

## Package Output Types

Package output settings live in `[build]` in the package manifest. `output_type` is one of `executable`, `static-lib`, or `dynamic-lib`. `link` is `target-default`, `static`, or `dynamic`. The target/toolchain configuration selects the admitted C compiler contract.

> Trace: D26, D31, D80, D530
> Covers: Package output kind and link policy are manifest-declared without a backend selector.

A package can declare multiple runnable executable targets. Each target is a named build-graph node with root module, entry declaration, output name, profile restrictions, target filters, generated-input dependencies, and startup capability bundle. `kyokai build --bin <name>` builds one named executable and `kyokai run --bin <name>` runs one named executable. `kyokai run` without `--bin` is legal only when exactly one runnable target exists or exactly one executable is marked as the default run target.

Executable targets are declared by `[targets.<name>]` tables in the package manifest:

```toml
[targets.app]
kind = "executable"
module = "App.Main"
entry = "main"
output = "app"
default = true
```

The `<name>` segment is the stable target selector. The `module` value is resolved through the package's `[layout].module_root`; it does not name a file directly. The `entry` value names the declaration inside that module. The optional `output` value selects the executable artifact stem and defaults to `<name>`. The optional `default` value defaults to `false`; at most one executable target in a package may set it to `true`. Unknown target kinds are rejected unless a later spec section admits them.

> Trace: D26, D48, D80, D437
> Covers: Executable packages have unambiguous entrypoint behavior.

If `output_type = "static-lib"` or `dynamic-lib`, exported symbols must come only from declarations explicitly admitted for export by the language/FFI spec. Ordinary Kyokai public declarations are source-interface public; they are not automatically C or platform ABI exports.

> Trace: D17, D20, D31, D139
> Covers: Source visibility and binary export visibility are separate.

## Build Output Tree

User-visible build artifacts are written under `<out-root>/<target-triple>/<profile>/<package-name>/`. C compiler identity remains in provenance and cache keys rather than creating a public backend directory.

> Trace: D26, D31, D78, D80, D83, D149, D264, D530
> Covers: Build outputs are partitioned by target, profile, and package; toolchain identity protects cache and provenance correctness.

The standard output subdirectories are `bin/` for executables, `lib/` for static and dynamic libraries, `koi/` for checked package interface artifacts, `gen/` for declared generated source or native-input files meant for inspection, `c_output/` for explicitly requested generated C, `doc/` for generated HTML and documentation JSON, `reports/` for coverage/bench/audit/SemVer/timing/provenance reports, and `obj/` only for object files that the selected profile or flag marks as user-inspectable artifacts.

> Trace: D27, D31, D79, D83, D218, D223, D225, D264, D509
> Covers: User-visible output subdirectories have fixed meanings, including `.koi`, requested generated C, generated files, docs, reports, and inspectable object output.

Private object files, generated-C scratch, temporary IR, dependency build scratch, fingerprints, and incremental query state belong in the cache root, not in the output tree, unless a profile or command explicitly asks to expose them as inspectable products.

> Trace: D83, D144, D264
> Covers: Disposable compiler machinery is separated from artifacts users may keep, inspect, or package.

## Linking

Linking uses the selected target's linker configuration, package output type, dependency graph, compiled C objects, native libraries declared by unsafe/FFI contracts, and target profile overrides. Link order must be deterministic.

> Trace: D20, D31, D80, D83, D149
> Covers: Linking has deterministic inputs and explicit native dependency sources.

A safe Kyokai package cannot gain native link dependencies by ambient discovery. Native libraries required by foreign blocks, runtime support, target helpers, or unsafe wrappers must be declared in the package manifest, target-spec file, or toolchain target contract.

> Trace: D20, D83, D150, D230
> Covers: Native dependencies are explicit and auditable.

Dynamic linking is allowed only when the selected target and package configuration admit it. If dynamic linking is selected, the runtime search path policy, install names, sonames, import libraries, and platform loader assumptions must be explicit target-toolchain fields or rejected.

> Trace: D31, D80, D83, D149
> Covers: Dynamic linking behavior is written configuration.

## Identical Code Folding

`identical_code_folding = true` permits the toolchain to merge generated code only when the compiler proves the folded bodies are semantically identical for all observable Kyokai behavior and the selected profile allows the optimization. Folding must not merge functions when doing so would change stack traces, exported symbol identity, address-sensitive unsafe contracts, debug requirements for the selected profile, or provenance obligations.

> Trace: D27, D83, D200
> Covers: Code-size optimization is explicit and constrained by observable semantics.

## Reject Unsupported Targets Early

[Rikona Kurasaki / Mjoyufull]
The build profile selects optimization and artifact policy. The target contract selects platform behavior and available facilities. The admitted C-toolchain record identifies the external tools that implement that combination. An unsupported combination is rejected before code generation rather than failing later as an unexplained linker or runtime defect.

> Trace: D31, D80, D83, D139, D149
> Covers: Explicit target and build policy keeps systems programming practical without returning to external-toolchain folklore.

## Target Record

A target record states OS, architecture, ABI, endian, pointer width, integer widths, alignment rules, calling conventions, hosted or freestanding class, runtime shim class, available capabilities, atomics, volatile/MMIO domain, strict-float support, CPU-feature model, sanitizer support, debug-info support, object format, loader policy, and generated-C schema compatibility.

> Trace: D80, D149, D321, D393, D400, D418, D451, D464, D483
> Covers: Every target-dependent semantic fact lives in a structured target record or produces an unsupported-target diagnostic.

## Native Toolchain Discovery

Native compiler, linker, archiver, sysroot, SDK, include roots, library roots, and discovery providers are explicit target-toolchain configuration. A fallback chain is legal only when configuration lists candidates in order. Each candidate records executable identity, required version range, flags, target triple, sysroot, admitted environment keys, probe command, and rejection diagnostic.

`pkg-config` is a discovery provider only when configuration declares it. Its package names, version constraints, environment variables, sysroot behavior, queried fields, and captured output become build-metadata inputs. Reproducible profiles reject host headers and libraries outside declared roots. The toolchain never silently substitutes host `cc`, linker, shell lookup result, sysroot, SDK, or `pkg-config` response outside the configured chain.

> Trace: D405
> Covers: Native-tool discovery, fallback order, pkg-config use, sysroots, and host-leak rejection are explicit build identity.

## Native Compiler Providers

A native compiler provider is the host-local realization of an admitted target
contract. Provider classes are `bleedring_managed`, `system`, `explicit_path`,
`container`, and `self_verified`. Host-local configuration maps
`[c_toolchain_provider.<name>]` to a contract, class, installation or content
identity, compiler, linker, archiver, runtime, sysroot or SDK, admitted
environment, and verification state. A published package or workspace manifest
must not contain developer-local provider paths.

`--c-toolchain-provider <name>` selects one compatible declared provider for
one invocation. Resolution order is the command selection, the
manifest/profile contract requirement, the user provider mapping, then the
distribution's target default. Each candidate must satisfy the requested
contract. Kyokai never adds an unrecorded fallback by searching `cc`, `gcc`,
`clang`, a linker, an SDK, or PATH.

A failed resolution lists the requested contracts, every rejected provider and
reason, and an exact Bleedring install command when a verified provider bundle
is available. `doctor`, verbose and machine build reports, cache keys, generated
artifacts, provenance, crash records, and admission records expose the selected
contract and provider identity.

Bleedring is the separately released, officially supported bootstrap installer.
It is implemented in Kyokai and distributed as standalone binaries. It can
install complete Kyokai distributions and exact native-compiler provider
bundles. Distribution and compiler-provider roots, manifests, caches, locks,
provenance, updates, verification, and removal state remain separate.

A managed provider manifest binds the exact compiler, linker, archiver,
runtime, sysroot or SDK, targets, admission record, upstream provenance,
licenses, signatures and checksums, archive and unpacked manifests, host
requirements, and security state. Installation uses bounded safe extraction
and atomic publication under explicit roots. It neither invokes an external OS
package manager nor silently elevates privilege. When redistribution is not
available, Bleedring supplies exact probes and guidance for a declared system
or path provider rather than claiming to manage it.

Bleedring lists, installs, verifies, updates, and removes providers without
silently editing project selection. `kyokai install` remains a package and
dependency command; it does not install compilers, SDKs, or arbitrary system
software.

> Trace: D405, D569, D615, D631-D632
> Covers: Native compiler acquisition and selection are reproducible without ambient `cc`, hidden PATH precedence, or system-package-manager behavior in `kyokai install`.

## C Compiler Admission

Kyokai admits C toolchains by exact compiler build and version, provider
identity, target triple, dialect mode, SDK/sysroot, linker/archive family,
object/debug format, and tested feature contract. A range displayed to users is
derived from individually admitted records; it does not admit untested members.
An arbitrary ambient `cc` is not conforming merely because it accepts one
generated file.

The initial major hosted lanes are:

| Platform family | Admitted compiler lane | Required debug/object lane |
| --- | --- | --- |
| Linux | GCC and Clang | ELF with DWARF; admitted GNU, LLD, or mold-style linker contract |
| macOS | Apple Clang | Mach-O with dSYM/DWARF and Apple SDK identity |
| Windows | clang-cl | COFF with CodeView/PDB and explicit Windows SDK/toolset identity |
| FreeBSD | Clang | ELF with DWARF and the selected FreeBSD sysroot/base-tool contract |

Cross GCC/Clang, MinGW, MSVC `cl`, other BSDs, WASI, embedded, kernel, and freestanding lanes require separate target records. clang-cl is the initial Windows lane because the C11 generated subset, atomics, alignment, TLS, and debug contract must be implemented together. MSVC `cl` requires named adapters and complete evidence for every missing or divergent standard facility before admission.

Every admission record includes:

1. C11/C17 dialect and preprocessor probes;
2. integer, float, pointer, record, union, alignment, argument, return, varargs, callback, and ABI tests;
3. atomics, fences, lock-free claims, TLS, volatile, and strict-float tests;
4. intrinsic, attribute, pragma, and inline-assembly inventory;
5. `#line`, source-map, debugger breakpoint/backtrace, symbol/local, coverage, profiler, and sanitizer tests;
6. compiler, assembler, linker, archive, dynamic-link, sysroot, and SDK probes;
7. deterministic-output and path-remap tests;
8. human and machine diagnostic capture;
9. generated-C compile-time benchmarks and runtime conformance;
10. explicit unsupported surfaces and support-tier ownership.

CompCert is an independent restricted-C evidence lane on admitted targets. TCC and every other compiler family enter only through this same admission process; compile speed alone does not establish atomics, TLS, ABI, debug, diagnostic, or semantic conformance.

> Trace: D532, D535
> Covers: Major-platform support is a tested compiler contract, not a shell-path guess.

## Strict Float And CPU Dispatch

Safe `Float32` and `Float64` operations use strict IEEE-754 semantics by default. A build profile cannot select reassociation, hidden FMA contraction, flush-to-zero, hidden denormal behavior, signaling-NaN traps, or ambient rounding dependence for ordinary safe operations. Explicit optimized math APIs can name a relaxed policy. Their names and contracts expose the policy instead of inheriting it from release mode.

The target record reports denormal behavior, FMA availability, rounding-mode support, exception-flag exposure, libm or native-oracle tier, and lowering evidence. CPU-feature dispatch is explicit profile or API policy keyed by target record; generated variants and dispatch mechanism are recorded in provenance.

> Trace: D400, D418
> Covers: Ordinary safe floats remain strict across profiles; relaxed math and CPU dispatch are explicit recorded surfaces.

## Generated C Output

Requested generated C is written to `kyokai-out/<target-triple>/<profile>/<package-name>/c_output/` unless `--out-dir` selects another output root. Internal generated C used only to compile can remain in `.kyokai-cache/` as disposable code-generation state.

`--emit-c=single` writes one deterministic translation unit per declared code-generation artifact boundary. `--emit-c=split` writes deterministic package, module, and materialization units plus source-map and provenance records. Generated C records source package, source revision or workspace identity, selected toolchain, target, profile, `.koi`/KBI version, source-map path, generated-file schema, and whether the file is inspection-only or participates in target compilation.

> Trace: D264, D509
> Covers: Requested generated C is an inspectable output lane with deterministic schema, maps, provenance, and explicit compile participation.

## Compilation-Time Gates

Generated C is partitioned so a local edit invalidates only affected package, module, materialization, object, link, and report nodes. `.koi` reuse, prebuilt standard-library and Bridge objects, parallel external compilation, object caching, and incremental linking are part of the ordinary build design.

Published performance reports identify exact workload revisions, reference hardware, OS, compiler/tool versions, cache state, target, profile, and median/p95 timing. They distinguish no-op, one-file incremental, dependency-cached clean, full clean debug, and release builds. The initial gates are:

| Work class | Gate |
| --- | --- |
| no-op build | under 1 second |
| ordinary analysis after edit | under 1 second |
| typical incremental executable rebuild | under 5 seconds |
| clean fsel-class debug build | under 15 seconds |
| clean Zig/Hyprland-class debug build | under 60 seconds |
| very-large clean debug build | under 5 minutes |

A missed gate is reported as a measured toolchain defect or release blocker against the named benchmark contract. It does not permit hidden caching inputs, stale objects, skipped checks, or changed language semantics.

> Trace: D534
> Covers: Fast compilation is an auditable product contract over deterministic incremental C units.

## Dynamic Loading And Development Services

Dynamic-link configuration records rpath or runtime-search-path policy, soname, install name, import-library behavior, loader assumptions, and target unsupportedness. A package cannot depend on ambient loader folklore.

Hot reload is an explicit development service. It records loader mechanism, symbol/version contract, state-transfer boundary, supported target classes, sandbox grants, and restart behavior. It cannot change release-profile semantics or make a program legal under rules that ordinary builds reject.

> Trace: D445, D475
> Covers: Loader behavior and hot reload are explicit target/toolchain services, not hidden source semantics.

## C-Toolchain Semantic Corpus And Admission Lifecycle

Every admission case has a stable Kyokai semantic/conformance ID and expected
outcome. Frozen evidence binds compiler, IR schemas, generated-C bundle,
runtime/prelude, target contract, and manifest. Except for declared
target/profile transforms, the same generated C bytes run across candidate
compiler lanes. The oracle is the specification, attached expected result, and
an executable model where available. Candidate agreement cannot legalize a
different result.

Cases cover execution, defined failure, invalid-subset rejection, structural C,
sanitizers, source maps/debuggers, atomics/litmus, optimization/LTO, linking,
and target runtime. Randomized cases retain seeds and are minimized on
disagreement. `PASS`, `FAIL`, `TIMEOUT`, `UNSUPPORTED`, `UNRESOLVED`, and
`FLAKY` are distinct. Upstream compiler suites are supporting health evidence,
not copied Kyokai semantic cases.

An admission tuple binds compiler executable and provenance, justified version
interval, host, target, sysroot/runtime, linker, archiver, profile,
optimization, LTO, debug mode, and required flags. Family names are headings,
not facts. Correctness covers debug, release, size, unoptimized, optimized, and
each claimed LTO/ICF mode. Cross-target evidence distinguishes compile-only,
emulated/simulated, and physical execution. Compile-only evidence cannot claim
runtime conformance. Performance status is separate from correctness, and a
partial pass narrows the admitted tuple.

Revalidation is triggered by a relevant backend, runtime/prelude, C subset,
compiler/linker/sysroot, target SDK, profile/flag, corpus, miscompilation,
security advisory, or review-interval change. A correctness or security defect
suspends the affected tuple without deleting history. Readmission creates a
linked record. `doctor`, build JSON, release provenance, and crash reports name
the admission used; offline reuse requires exact identity.

A developer can run the complete harness for an unlisted tuple and produce
`SELF_VERIFIED` evidence. It is unofficial and user-owned, creates no support
claim, and cannot update official admission until project-controlled
infrastructure reproduces the relevant run. Every major release reruns the full
official matrix. Patches inherit admission and cannot silently change
admission-relevant semantics, generated C, runtime ABI, target contract, or
flags. A minor reruns affected tuples when those facts change. Active defects
can suspend at any release level.

> Trace: D569a-D569c
> Covers: C compiler support is tuple-specific, oracle-owned, evidence-retaining, suspendable, and distinct from unofficial self-verification.

## Apple Admission Matrix

`aarch64-macos-none` is the first Tier-One Apple host and target identity.
Apple/Clang triples and deployment targets are recorded external facts. Intel
macOS is a separate tuple. iOS, iPadOS, tvOS, watchOS, visionOS, Mac Catalyst,
and each simulator/device/architecture combination require separate admission.

Each tuple records Xcode and SDK identities and paths, deployment target,
Clang, linker, archiver, frameworks, external triple, destination, signing
class, entitlements, and runtime evidence. Generated C, module maps, headers,
static/dynamic libraries, bundles, symbols, and XCFramework slices are explicit
outputs. Objective-C and Swift adapters state ARC retention, callback ownership,
exception boundaries, affinity, and teardown.

Planning, build, test, and packaging are toolchain/adapter operations. Simulator
execution establishes no physical-device performance or behavior. Tier-One
status requires hosted CI, simulator lanes, named physical-device lanes,
debugging, packaging, release provenance, and maintained admission ownership.
Signing, notarization, deployment, and store submission are separate
authority-bearing steps.

> Trace: D548, D554, D619
> Covers: Apple support is claimed per exact target, SDK, toolchain, simulator/device, adapter, packaging, and physical-execution evidence tuple.
