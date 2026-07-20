# Transitional FFI Tracking

[Rikona Kurasaki / Mjoyufull]
> ProofTrace: SPEC-STDLIB-11-TRANSITIONAL-FFI-TRACKING
> Covers: This chapter is registered in the public ProofTrace evidence graph; registration does not claim implementation, conformance, or theorem completion.

Kyokai permits transitional FFI only when the boundary is recorded, audited, tested, and assigned a retention or replacement disposition.

> Trace: D20, D64, D229-D230, D245
> Covers: Transitional FFI is allowed only with unsafe contracts, safe wrappers, and replacement tracking.

## Allowed Reasons

FFI-backed stdlib implementation is allowed for OS and hardware boundaries, mature externally reviewed libraries, bootstrap dependencies needed before Kyokai can self-host, and temporary bridges recorded in the implementation plan. Pure computation does not remain FFI-backed merely because a C implementation already exists.

> Trace: D64, D229-D230
> Covers: FFI is a boundary or bridge, not the default home of pure algorithms.

A permanent FFI boundary must say why the boundary is permanent. A transitional FFI boundary must say what native Kyokai or safer boundary will replace it, what evidence is needed for replacement, and what condition removes or downgrades the bridge.

> Trace: D229-D230, D243
> Covers: Permanent and transitional FFI have different documented obligations.

## Required Record

Each transitional FFI item has a tracking record containing module path, public safe API, unsafe module path, foreign library or ABI, reason for FFI, permanent-or-transitional status, replacement target, owner, admission status, license/provenance notes, supported targets, test/oracle source, audit status, and removal or stabilization criteria.

> Trace: D20, D85, D229-D230, D263
> Covers: FFI tracking records carry provenance, ownership, testing, and replacement information.

| Record Field | Required Meaning | Trace |
| --- | --- | --- |
| Public API | Safe Kyokai module/function/type exposed to users. | D20, D245 |
| Unsafe Boundary | `pragma Unsafe_Module`, foreign declarations, callbacks, dynamic loading, or raw pointer surface. | D20, D242-D242a, D245 |
| Reason | OS/hardware boundary, reviewed external dependency, bootstrap bridge, or separate justified exception. | D64, D230-D231 |
| Replacement Target | Native Kyokai implementation, safer wrapper, permanent external boundary, or explicit compatibility retirement. | D229-D230 |
| Contracts | Ownership, allocation, failure, callback, thread, lifetime, panic/TPOE, and capability behavior. | D20, D85, D245 |
| Tests | Conformance vectors, oracle comparison, ABI tests, and fuzz/property tests; any category outside the wrapper domain is recorded as `N/A`. | D220, D229-D232 |
| License/Provenance | Source project, license compatibility, generated/bundled status, and attribution needs. | D263 |
| Compatibility | Stable, experimental, transitional, compatibility-only, deprecation/removal rule. | D223, D243 |

> Trace: D20, D64, D85, D220, D223, D229-D232, D242-D245, D263
> Covers: Transitional FFI records are auditable across safety, tests, license, and compatibility boundaries.

## Unsafe Module And Safe Wrapper Rule

Every FFI wrapper used by safe stdlib code lives behind an unsafe module boundary. Safe code calls a safe Kyokai wrapper whose contract fully states ownership, lifetime, allocation, failure, callback, concurrency, and capability behavior. The wrapper cannot export raw foreign behavior as safe folklore.

> Trace: D20, D242-D242a, D245
> Covers: Safe stdlib APIs over FFI require documented unsafe boundaries and safe wrappers.

FFI must not pass raw by-value linear values or Kyokai sum types across the C boundary unless a specific unsafe ABI contract admits the representation and ownership transfer. Callback APIs must state whether foreign code can call back after the initiating call returns, on which task/thread, and with what authority.

> Trace: D20, D42, D77, D113a-D113b, D245
> Covers: Linear ownership, sum representation, callbacks, and authority do not cross FFI silently.

## Replacement And Admission

A transitional FFI API is public only as `experimental`, `transitional`, or through a stable safe wrapper whose internal FFI boundary is accepted as either permanent or tracked for replacement. The public contract remains stable only if replacing the implementation with native Kyokai preserves the same behavior.

> Trace: D157, D223, D229-D230, D243
> Covers: Implementation replacement cannot change public stdlib behavior without compatibility process.

When a native Kyokai replacement is proposed, it must satisfy the same admission record as any other stdlib API: semantic contract, edge cases, tests/oracles, allocation/failure behavior, portability notes, and compatibility impact. RIIK is not an exemption from evidence.

> Trace: D64, D220, D229-D232
> Covers: Native replacements are admitted by evidence, not by ideology.

## Transitional Does Not Mean Untracked

[Rikona Kurasaki / Mjoyufull]
Some foreign boundaries are permanent platform interfaces; others exist only to bootstrap missing native code. Tracking records distinguish those cases, state the wrapper contract, and assign either a retention justification or a replacement condition so transitional code does not become permanent by neglect.

> Trace: D20, D64, D229-D230, D245
> Covers: Transitional FFI stays useful, visible, and replaceable.

## Bindgen Wrapper-Kit Record

`kyokai bindgen` generates raw foreign declarations, extern records, constants, layout checks, target facts, probes, and unsafe wrapper skeletons. Generated output remains unsafe-only until a safe-wrapper admission record exists.

A safe-wrapper record names foreign library version range, headers, target triples, symbols, flags, ownership, aliasing, lifetimes, initialization, thread safety, callbacks, allocator behavior, foreign error-state translation, required Kyokai capabilities, cleanup, provenance digest, replacement owner, audit owner, target coverage, test evidence, and graduation criteria. Capability-bearing foreign operations expose explicit Kyokai capability parameters in the safe wrapper.

| Wrapper Stage | Public Status | Required Exit Condition |
| --- | --- | --- |
| Raw generated binding | Unsafe-only. | Add audited unsafe contracts and wrapper skeleton review. |
| Transitional safe wrapper | Stable only when the public safe contract is complete; internal bridge remains tracked. | Meet replacement or permanent-boundary criteria. |
| Permanent external boundary | Stable safe wrapper over a reviewed foreign dependency. | Keep target, version, advisory, audit, and provenance records current. |
| Native replacement | Safe native Kyokai implementation preserving the same public behavior. | Pass the ordinary admission record and compatibility review. |

> Trace: D430, D499, D501
> Covers: Bindgen provenance, wrapper-kit admission, owners, target coverage, evidence, and graduation criteria are explicit.

## Initial Official Bridge Portfolio

The initial evidence portfolio covers SQLite, one stable TLS provider, raylib,
one Apple-framework slice, CMake and Meson foreign-build adapters, one
GPU/compute provider, one callback-heavy library, and one system-provider
boundary. SDL follows the initial raylib work as the first serious raw game and
systems workload. `libc` and platform runtime surfaces are target contracts,
not ordinary Bridges.

Bundled, system, vendored, and dynamic provider forms have distinct records and
exact CI identities. Each Bridge ships a real reference application. An
abandoned Bridge becomes `SUSPENDED`; documentation does not continue to call
it admitted. Figma and design-tool work remains separate until it receives its
own admission.

## Rust Project Boundary

Kyokai defines no Rust frontend, compiler mode, Rust ABI or layout contract,
Cargo resolver or importer, arbitrary crate loader, universal translator,
`Kyokai.Bridge.Rust`, or Rust-special port command. Language-neutral migration
tools may inventory source, dependencies, APIs, tests, and unfinished work, but
make no equivalence or safety claim.

A required Rust project receives an individual package or Bridge decision and
crosses a stable C ABI, process, WASI, file, or wire boundary. Cargo and
`build.rs` may run only inside that project's governed foreign-build plan.
Overarching Rust integration can be reopened only by a new D-point showing that
project-specific Bridges and neutral migration help are insufficient.

> Trace: D596-D596a
> Covers: Official Bridges are concrete maintained products; Rust receives project-specific boundaries rather than a second language ecosystem inside Kyokai.
