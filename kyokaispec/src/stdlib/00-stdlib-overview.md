# Standard Library Overview

[Rikona Kurasaki / Mjoyufull]
> ProofTrace: SPEC-STDLIB-00-STDLIB-OVERVIEW
> Covers: This chapter is registered in the public ProofTrace evidence graph; registration does not claim implementation, conformance, or theorem completion.

Kyokai's standard library is not a decorative appendix to the language. It is the place where ownership, allocation, authority, failure, platform behavior, and ordinary systems work meet. A language can be strict in the compiler and still become vague in the library; Kyokai does not get to do that.

> Trace: D85, D152, D229, D243
> Covers: The Kyokai standard library is a committed systems-library surface with explicit contracts and compatibility policy.

The public namespace for the standard library is `Kyokai.*`. Public Kyokai APIs must not expose inherited `Standard.*` or `Austral.*` names as their canonical surface. Compatibility shims, migration guides, and historical examples are permitted to mention inherited names, but stable Kyokai programs import `Kyokai.*` modules.

> Trace: D1, D5, D152
> Covers: The stdlib namespace follows Kyokai project identity and retires inherited public naming.

The official Bridge collection uses the reserved namespace `Kyokai.Bridge.*` and the repository/toolchain-owned collection root `bridge/`. Bridge modules are shipped first-party integration code for selected third-party libraries, native APIs, generated bindings, small ports, and target adapters. They are not ordinary package-index dependencies, not a package cache, and not the output of `kyokai vendor`.

> Trace: D529
> Covers: The Bridge collection is an official shipped integration collection with a reserved namespace and path, separate from ordinary dependency vendoring.

The standard library is batteries-included for systems programming. The admitted surface includes core result/optional/error/display protocols, allocators, memory containers, byte/text/path types, collections, iterators, numerics, I/O, filesystems, environment access, process control, time, random, concurrency primitives, testing helpers, crypto policy, tracked transitional FFI, and the official Bridge collection for shipped third-party integrations.

> Trace: D152, D229-D232, D529
> Covers: Kyokai commits to broad systems-library families and an official bridge collection while still requiring admission criteria per API.

## Authority And Import Model

The standard library does not receive ambient authority. File, environment, process, terminal, network, time, random, signal, and OS-specific operations require explicit capabilities. Pure modules are importable without authority, but importing a module never grants runtime permission to use authority-bearing operations.

> Trace: D67, D85, D211
> Covers: Stdlib authority follows capability flow, not imports or module names.

Every stdlib API must state whether it is pure, capability-requiring, unsafe-internal, FFI-backed, platform-specific, blocking, allocation-using, or fatal-capable. These fields are part of the public contract and are extracted by documentation and audit tooling.

> Trace: D85, D150, D218, D229
> Covers: Documentation and audit can surface stdlib semantic fields consistently.

A Bridge module is imported explicitly like any other module. Importing it grants no filesystem, network, process, dynamic-loader, unsafe, or target authority. Any required capability appears in the module contract, `.koi`, docs, audit output, and capability-deny diagnostics. Any raw foreign operation remains behind the unsafe chapter's contract and wrapper rules.

> Trace: D20, D85, D211, D245, D527, D529
> Covers: Bridge imports do not grant authority, and bridge entries keep unsafe, capability, docs, audit, and deny-policy facts visible.

## Contract Fields

Every public stdlib type, function, typeclass, method, and instance documents the following fields. A field that does not apply is written as `N/A`; it is not omitted.

| Field | Required Meaning | Trace |
| --- | --- | --- |
| Ownership | Whether each argument is consumed, borrowed immutably, borrowed mutably, stored, returned, or invalidated. | D11b, D77, D85 |
| Allocation | Whether the API allocates, which allocator it uses, whether allocation can fail, and whether the result stores allocator identity. | D44, D74, D201 |
| Failure | All `Result`, `Optional`, TPOE, `panic`, runtime-fatal, and impossible-failure cases. | D53, D74, D84, D85 |
| Capabilities | Required capability values, derivation source, and whether authority is borrowed, consumed, or split. | D67, D85, D211 |
| Linearity | Whether returned or stored values are `Linear`, how they are destroyed, and what happens on early exit. | D2, D77, D85 |
| Concurrency | Task-transfer status, synchronization behavior, blocking behavior, memory-order needs, and thread-affinity. | D3, D90-D95, D100-D101, D212 |
| Platform | Target support, OS-specific behavior, path/encoding caveats, and unsupported-target failures. | D80, D85, D149 |
| Determinism | Iteration order, randomization, hash seeding, clock dependence, locale dependence, and reproducibility effect. | D83, D85 |
| Invalidation | Which operations invalidate borrows, iterators, views, raw addresses, registrations, or cached observations. | D77, D85, D357 |
| Complexity | Time and space complexity, amortized behavior, and worst-case notes when the behavior applies. | D85, D229 |
| Edge Cases | Empty input, zero length, invalid encodings, invalid paths, closed handles, allocation edge cases, and boundary values. | D74, D85, D229-D232 |
| Tests | Required unit tests, property tests, fuzz tests, oracle/reference vectors, or cross-platform tests. | D220, D229-D232 |
| Implementation | Safe native Kyokai, unsafe internal, permanent FFI boundary, transitional FFI, or externally reviewed implementation. | D229-D231 |
| Compatibility | SemVer and edition impact, deprecation path, and whether the API is stable, experimental, or compatibility-only. | D157, D223, D243 |

> Trace: D11b, D44, D53, D67, D74, D77, D80, D83-D85, D90-D95, D100-D101, D150, D157, D201, D211-D212, D220, D223, D229-D232, D243
> Covers: The common stdlib contract table is mandatory and covers ownership, allocation, failure, authority, linearity, concurrency, platform, determinism, complexity, edge cases, tests, implementation, and compatibility.

## Module Status

Each stdlib module has a release status: `stable`, `experimental`, `compatibility`, `transitional`, or `internal`. Stable modules must satisfy the admission criteria. Experimental modules are public previews; their documented SemVer/edition policy permits breaking changes. Compatibility modules exist for legacy algorithms or migration and must not be presented as preferred defaults. Transitional modules expose temporary bootstrap or FFI-backed behavior with replacement criteria. Internal modules are not public API.

> Trace: D152, D157, D223, D229-D230, D243
> Covers: Stdlib module status controls admission, compatibility, and deprecation promises.

A stable module cannot depend on an internal module's undocumented behavior. If a stable module uses unsafe or FFI internally, its public contract still carries the complete safe behavior and the audit surface identifies the trust boundary.

> Trace: D20, D85, D150, D229-D230, D245
> Covers: Stable safe APIs use unsafe internals only through documented safe contracts and audit metadata.

## Implementation Policy

Pure computation is written in safe native Kyokai unless a stdlib admission record gives a stronger reason. Sorting, hashing, text parsing, formatting, integer helpers, containers, encoders, decoders, and ordinary math algorithms are not wrapped through C merely because C code exists.

> Trace: D229-D230
> Covers: Rewrite-It-In-Kyokai is the default for pure computation.

FFI is legitimate for OS/hardware boundaries, transitional bootstrap bridges, externally reviewed libraries, and domains where Kyokai requires more evidence than a fresh native rewrite can currently provide. Every FFI-backed public API requires an unsafe contract and a safe wrapper unless the API itself is explicitly unsafe.

> Trace: D20, D230-D231, D245
> Covers: FFI is allowed only at explicit trust boundaries with contracts and wrappers.

The Bridge collection does not weaken RIIK. Pure algorithms remain safe native Kyokai by default. A Bridge entry exists when the useful boundary is integration itself: a foreign ABI, platform SDK, native library, externally maintained protocol implementation, generated binding set, or reviewed upstream port. A Bridge entry cannot become a dumping ground for code that should be a normal package or native stdlib module.

> Trace: D64, D229-D230, D529
> Covers: Bridge entries are admitted integration boundaries and do not replace native Kyokai implementations for pure stdlib work.

## Why This Shape

[Rikona Kurasaki / Mjoyufull]
A standard library can become a second language hiding under function names. Kyokai refuses that. The function name states the ownership story. The signature shows the allocator and capability story. The contract states how it fails. The docs state what changes across platforms. No one has to read a source file in the rain to discover whether `push` can allocate, whether an iterator dies after mutation, or whether a file call secretly uses the current directory.

> Trace: D85, D152, D229
> Covers: Kyokai's stdlib contract exists so library behavior stays as explicit as language behavior.

## Admission Ladder And Full-Conformance Surface

The standard library uses five stability and release-obligation tiers: `Core`, `Systems`, `Extended`, `Experimental`, and `Internal`. `Core` contains language-adjacent essentials. `Systems` contains stable files, paths, environment, process, time, entropy, networking, concurrency, atomics, platform contracts, and FFI-wrapper surfaces. `Extended` contains stable batteries that are not required by every minimal toolchain profile. `Experimental` contains explicitly unstable incubating APIs. `Internal` contains compiler, runtime, package-manager, generated-helper, test, and stdlib implementation support with no public compatibility promise. Promotion from `Experimental` to a stable tier requires an admission record and compatibility review; age and popularity never promote an API silently.

The usability ladder below orders stable implementation work inside those tiers. It does not replace the five public stability categories.

> Trace: D305, D501
> Covers: Stdlib stability categories and implementation-order ladders are separate explicit taxonomies.

The standard-library admission ladder is ordered: `Core Pure`, `Core Containers`, `Core Text/Bytes/Paths`, `Core IO/OS`, `Core Testing/Diagnostics`, `Core Networking`, `Core Codecs`, `Core Crypto Policy`, and `Extended Protocols`. An implementation claiming a tier implements every stable module in that tier and every earlier tier. A partial, bootstrap-only, or experimental implementation labels itself accordingly and does not claim the missing stable tiers.

Tier-1 usability includes buffers, strings and text views, paths, files, arguments and environment, formatting, tests, JSON/CBOR foundations, socket and DNS foundations, time, random, process, and common collections. Stable admission requires the chapter-local contract table, target gates, conformance evidence plan, documentation examples, unsafe-audit status, and transitional-FFI record when a foreign bridge exists.

| Ladder Tier | Stable Surface | Additional Admission Burden |
| --- | --- | --- |
| `Core Pure` | result, optional, rendering, parsing, numeric helpers | Boundary tests and property tests for parsers. |
| `Core Containers` | allocators, buffers, arrays, spans, maps, sets, slot maps | Allocation-failure, invalidation, drain, and linear-payload tests. |
| `Core Text/Bytes/Paths` | UTF-8 text, bytes, OS strings, paths, codecs foundation | Encoding, target-path, and round-trip tests. |
| `Core IO/OS` | files, directories, streams, args/env, process, clocks, entropy | Capability, partial-progress, cancellation, and target tests. |
| `Core Testing/Diagnostics` | fixtures, replay records, assertions, diagnostic helpers | Fixture-cleanup and replay tests. |
| `Core Networking` | sockets, DNS, poller integration, broker examples | Timeout, cancellation, readiness, and backpressure tests. |
| `Core Codecs` | JSON/CBOR foundation and admitted codecs | Parser, fuzz, corpus, and resource-limit tests. |
| `Core Crypto Policy` | admitted secure-random and crypto wrapper policy | External vectors, advisory policy, and review evidence. |
| `Extended Protocols` | separately admitted higher-level systems modules | Protocol-specific evidence and target support. |

> Trace: D305, D392, D481, D501
> Covers: Full implementations claim explicit stdlib tiers, and the batteries-included cold-start ladder has stable admission evidence for each tier.
