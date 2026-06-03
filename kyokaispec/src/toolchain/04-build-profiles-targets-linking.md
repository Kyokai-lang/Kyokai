# Build Profiles, Targets, And Linking

[Rikona Kurasaki / Mjoyufull]
> ProofTrace: SPEC-TOOLCHAIN-04-BUILD-PROFILES-TARGETS-LINKING
> Covers: This chapter is registered in the public ProofTrace evidence graph; registration does not claim implementation, conformance, or theorem completion.

A build profile is not a mood. A target is not a wish. A backend is not a secret second language. Kyokai writes these choices down because optimization, debug info, link mode, target ABI, and backend tool contracts can change what a programmer receives from the toolchain.

> Trace: D27, D31, D80, D83, D139, D149, D200
> Covers: Build profiles, targets, backends, and linking are explicit toolchain contracts.

## Profiles

Profiles are named manifest tables under `[profile.<name>]`. The standardized profile names are `debug`, `test`, `release`, and `bench`. Custom profiles are allowed when their fields are explicit or inherited from another named profile.

> Trace: D26, D31
> Covers: Build profiles are named manifest configuration, with conventional standard names and explicit custom inheritance.

A profile may contain these fields:

| Field | Type | Required Meaning | Trace |
| --- | --- | --- | --- |
| `inherits` | string | Copy fields not written in the current profile from another profile. Cycles are illegal. | D31 |
| `optimization` | integer `0`, `1`, `2`, or `3` | Backend optimization level. It must not disable safety checks. | D31, D73 |
| `debug_info` | boolean | Emit source/debug metadata for supported targets. | D27 |
| `strip` | boolean | Remove symbols/debug sections only after required diagnostics/provenance artifacts are produced. | D27, D225 |
| `lto` | boolean | Enable link-time optimization when supported by the selected backend/target. | D31 |
| `identical_code_folding` | boolean | Permit profile-controlled folding of proven identical generated code. | D200 |
| `panic_backtrace` | string: `off`, `short`, or `full` | Select fatal backtrace detail after CLI precedence and before admitted environment override. | D84, D343 |
| `environment_backtrace_override` | boolean | Permit hosted `KYOKAI_BACKTRACE` override. Reproducible profiles default to `false`. | D343 |
| `main_stack_size` | byte size | Override the selected target default main stack size within its declared range. | D262, D308, D343 |
| `task_stack_size` | byte size | Override configurable task stack default within the target range. | D308, D343 |
| `guard_size` | byte size | Select guard size where the target stack contract permits override. | D262, D308, D343 |
| `frame_pointer` | string policy | Select the recorded frame-pointer policy used by code generation and debug identity. | D27, D308 |
| `sanitizers` | array of strings | Select sanitizer instrumentation admitted by the target/backend contract. | D225, D308 |
| `path_remap` | array of strings | Map absolute source prefixes for deterministic debug info. | D27, D83 |

> Trace: D27, D31, D73, D83, D84, D200, D225
> Covers: Profile fields are typed, bounded, and visible.

`optimization` must never remove runtime checks required by the language spec. Bounds checks, integer traps where checked arithmetic applies, contract checks, borrow/linearity consequences already enforced at compile time, panic paths, TPOE paths, stack probes required by the target contract, and safe concurrency checks remain semantically present in all profiles. Stable Kyokai has no unsafe-only profile or flag that disables these semantics; admitting one requires a separate accepted D-point and source-visible contract.

> Trace: D53, D73, D75-D76, D84, D139, D262
> Covers: Release optimization cannot erase Kyokai safety semantics.

The default profile for `check`, `build`, `run`, and `doc` is `debug`. The default profile for `test` is `test` if present, otherwise `debug`. The default profile for `bench` is `bench` if present, otherwise `release`. `--release` is exactly `--profile release`.

> Trace: D26, D31
> Covers: Profile defaults are fixed and command-visible.

## Target Triples And Support Tiers

A target triple is spelled `arch-os-abi`. A target triple is legal only if it appears in Kyokai's target matrix or an imported target-spec file explicitly admitted by the toolchain version. The existence of `target.arch`, `target.os`, or `target.abi` enum values does not create a legal target triple by cartesian product.

> Trace: D19, D80, D149
> Covers: Target triples are closed, explicit support promises, not inferred enum combinations.

A target support entry records the triple, tier, supported backends, runner availability, C compiler contract when using the C backend, LLVM version/feature contract when using the LLVM backend, atomic support, stack-overflow detection strategy, object format, dynamic-link support, and known unsupported standard-library families.

> Trace: D31, D80, D139, D141, D149, D262
> Covers: Target support declares exactly what the toolchain promises for each target.

| Tier | Promise | Required Behavior | Trace |
| --- | --- | --- | --- |
| Tier 1 | Release-blocking supported target. | CI builds compiler, stdlib, conformance tests, package tools, and release artifacts for the target. | D80, D225 |
| Tier 2 | Supported but not fully release-blocking. | Compiler and stdlib build regularly; gaps are documented by target support entry. | D80 |
| Experimental | Admitted for development. | Explicitly labeled incomplete surfaces report unsupported features and never silently lower safe Kyokai through UB. | D73, D80, D139 |

> Trace: D73, D80, D139, D225
> Covers: Target tiers are user-visible promises with defined missing-feature behavior.

An unsupported target triple is a front-end configuration error. A supported triple with an unsupported selected backend is a target/backend configuration error. The tool must not silently select the host target, another ABI, another backend, or another linker.

> Trace: D26, D80, D149
> Covers: Target/backend mismatch fails early rather than falling back silently.

## Target Configuration

Target configuration lives in `[target.<triple>]` and backend-specific subtables. The key `spec = "path/to/target.toml"` imports a reusable target-spec TOML file. The importing table may override fields only where the target-spec schema admits override.

> Trace: D31, D80, D149
> Covers: Cross-compilation uses manifest-centered target tables and importable target-spec files.

A target-spec file is part of build identity. Its bytes, normalized path identity, declared schema version, and resolved imported files must be included in reproducibility fingerprints. A missing or unreadable target-spec file is a build configuration error.

> Trace: D83, D149
> Covers: Target-spec files are deterministic build inputs.

Backend-specific configuration uses standardized backend names: `c` and `llvm`. A conforming toolchain may omit a backend for a target, but if the backend is present its configuration must state the external tools and version floors needed to preserve Kyokai semantics.

> Trace: D31, D80, D139, D149
> Covers: Backend availability is explicit per target.

## Backend Contracts

The C backend emits C only inside Kyokai's supported C dialect and compiler contract. Generated C must preserve Kyokai evaluation order, checked failures, layout, atomics, volatile operations, stack checks, and source mapping without relying on C undefined behavior for safe Kyokai operations.

> Trace: D27, D73, D94, D139, D141, D228, D257
> Covers: The C backend is constrained by Kyokai semantics and cannot outsource safety to C UB.

The LLVM backend, when present, lowers directly to LLVM IR or an equivalent LLVM pipeline. It must preserve the same semantic rules as the C backend and must not introduce LLVM poison, undef, invalid aliasing metadata, misdeclared alignment, or invalid lifetime markers for safe Kyokai operations.

> Trace: D73, D139, D228
> Covers: LLVM lowering is bound by the same no-backend-UB rule.

If a backend cannot represent a Kyokai operation on a selected target, the build fails with a target/backend diagnostic. The toolchain must not silently use a weaker operation, scalarize a vector intrinsic that is specified as target-specific, ignore volatile semantics, replace atomics with non-atomic accesses, or erase stack-overflow detection.

> Trace: D73, D80, D94, D104, D141, D257, D262
> Covers: Backend limitations are diagnostics, not semantic substitutions.

## Package Output Types

Package output settings live in `[build]` in the package manifest. `output_type` is one of `executable`, `static-lib`, or `dynamic-lib`. `backend` names the default backend. `link` is `target-default`, `static`, or `dynamic`.

> Trace: D26, D31, D80
> Covers: Package output kind and default backend are manifest-declared.

A package can declare multiple runnable executable targets. Each target is a named build-graph node with root module, entry declaration, output name, profile restrictions, target filters, generated-input dependencies, and startup capability bundle. `kyokai build --bin <name>` builds one named executable and `kyokai run --bin <name>` runs one named executable. `kyokai run` without `--bin` is legal only when exactly one runnable target exists or exactly one executable is marked as the default run target.

> Trace: D26, D48, D80, D437
> Covers: Executable packages have unambiguous entrypoint behavior.

If `output_type = "static-lib"` or `dynamic-lib`, exported symbols must come only from declarations explicitly admitted for export by the language/FFI spec. Ordinary Kyokai public declarations are source-interface public; they are not automatically C or platform ABI exports.

> Trace: D17, D20, D31, D139
> Covers: Source visibility and binary export visibility are separate.

## Build Output Tree

User-visible build artifacts are written under `<out-root>/<target-triple>/<profile>/<backend>/<package-name>/`. The backend component is required for backend-produced artifacts. A backend-independent command may omit the backend component only when backend selection cannot affect the artifact identity.

> Trace: D26, D31, D78, D80, D83, D149, D264
> Covers: Build outputs are partitioned by target, profile, backend, and package so cross-build artifacts cannot collide.

The standard output subdirectories are `bin/` for executables, `lib/` for static and dynamic libraries, `koi/` for checked package interface artifacts, `gen/` for declared generated source/backend files meant for inspection, `c_output/` for explicitly requested generated C, `doc/` for generated HTML and documentation JSON, `reports/` for coverage/bench/audit/SemVer/timing/provenance reports, and `obj/` only for object files that the selected profile or flag marks as user-inspectable artifacts.

> Trace: D27, D31, D79, D83, D218, D223, D225, D264, D509
> Covers: User-visible output subdirectories have fixed meanings, including `.koi`, requested generated C, generated files, docs, reports, and inspectable object output.

Private object files, backend scratch, temporary IR, dependency build scratch, fingerprints, and incremental query state belong in the cache root, not in the output tree, unless a profile or command explicitly asks to expose them as inspectable products.

> Trace: D83, D144, D264
> Covers: Disposable compiler machinery is separated from artifacts users may keep, inspect, or package.

## Linking

Linking uses the selected target's linker configuration, package output type, dependency graph, backend artifacts, native libraries declared by unsafe/FFI contracts, and target profile overrides. Link order must be deterministic.

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

## Why This Shape

[Rikona Kurasaki / Mjoyufull]
C taught systems programmers to ask what the target really is because the machine always answers eventually. Kyokai asks earlier. The profile says what it optimizes. The target says what it supports. The backend says what tools carry it. When the answer is no, the compiler says no before the linker leaves you staring at smoke.

> Trace: D31, D80, D83, D139, D149
> Covers: Explicit target and build policy keeps systems programming practical without returning to backend folklore.

## Target Record

A target record states OS, architecture, ABI, endian, pointer width, integer widths, alignment rules, calling conventions, hosted or freestanding class, runtime shim class, available capabilities, atomics, volatile/MMIO domain, strict-float support, CPU-feature model, sanitizer support, debug-info support, object format, loader policy, and generated-C schema compatibility.

> Trace: D80, D149, D321, D393, D400, D418, D451, D464, D483
> Covers: Every target-dependent semantic fact lives in a structured target record or produces an unsupported-target diagnostic.

## Native Toolchain Discovery

Native compiler, linker, archiver, sysroot, SDK, include roots, library roots, and discovery providers are explicit target-toolchain configuration. A fallback chain is legal only when configuration lists candidates in order. Each candidate records executable identity, required version range, flags, target triple, sysroot, admitted environment keys, probe command, and rejection diagnostic.

`pkg-config` is a discovery provider only when configuration declares it. Its package names, version constraints, environment variables, sysroot behavior, queried fields, and captured output become build-metadata inputs. Reproducible profiles reject host headers and libraries outside declared roots. The toolchain never silently substitutes host `cc`, linker, shell lookup result, sysroot, SDK, or `pkg-config` response outside the configured chain.

> Trace: D405
> Covers: Native-tool discovery, fallback order, pkg-config use, sysroots, and host-leak rejection are explicit build identity.

## Strict Float And CPU Dispatch

Safe `Float32` and `Float64` operations use strict IEEE-754 semantics by default. A build profile cannot select reassociation, hidden FMA contraction, flush-to-zero, hidden denormal behavior, signaling-NaN traps, or ambient rounding dependence for ordinary safe operations. Explicit optimized math APIs can name a relaxed policy. Their names and contracts expose the policy instead of inheriting it from release mode.

The target record reports denormal behavior, FMA availability, rounding-mode support, exception-flag exposure, libm or native-oracle tier, and lowering evidence. CPU-feature dispatch is explicit profile or API policy keyed by target record; generated variants and dispatch mechanism are recorded in provenance.

> Trace: D400, D418
> Covers: Ordinary safe floats remain strict across profiles; relaxed math and CPU dispatch are explicit recorded surfaces.

## Generated C Output

Requested generated C is written to `kyokai-out/<target-triple>/<profile>/<backend>/<package-name>/c_output/` unless `--out-dir` selects another output root. Internal generated C used only to compile can remain in `.kyokai-cache/` as disposable backend state.

`--emit-c=single` writes one deterministic translation unit per declared backend artifact boundary. The backend contract states whether that boundary is package or final link unit. `--emit-c=split` writes deterministic split files plus source-map and provenance records. Generated C records source package, source revision or workspace identity, selected toolchain, target, profile, backend, `.koi`/KBI version, source-map path, generated-file schema, and whether the file is inspection-only or participates in target compilation.

> Trace: D264, D509
> Covers: Requested generated C is an inspectable output lane with deterministic schema, maps, provenance, and explicit compile participation.

## Dynamic Loading And Development Services

Dynamic-link configuration records rpath or runtime-search-path policy, soname, install name, import-library behavior, loader assumptions, and target unsupportedness. A package cannot depend on ambient loader folklore.

Hot reload is an explicit development service. It records loader mechanism, symbol/version contract, state-transfer boundary, supported target classes, sandbox grants, and restart behavior. It cannot change release-profile semantics or make a program legal under rules that ordinary builds reject.

> Trace: D445, D475
> Covers: Loader behavior and hot reload are explicit target/toolchain services, not hidden source semantics.
