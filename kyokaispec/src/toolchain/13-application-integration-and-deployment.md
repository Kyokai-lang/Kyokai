# Application Integration, Migration, Packaging, And Deployment

[Rikona Kurasaki / Mjoyufull]
> ProofTrace: SPEC-TOOLCHAIN-13-APPLICATION-INTEGRATION-AND-DEPLOYMENT
> Covers: This chapter specifies generated-API projection, edition migration, authority explanations, foreign adapters, packaging, browser tooling, mobile tooling, runtime data updates, and deployment plans. It does not claim implementation or provider admission.

Compilation is not the last door an application walks through. Generated APIs arrive before checking. Foreign build systems sit beside the linker. Signing services and stores wait after it. Browsers, phones, firmware, containers, and cloud control planes each carry their own machinery. Kyokai lets that machinery exist, but it makes the plan inspectable and keeps authority attached to the operation that uses it.

> Trace: D541, D544-D550, D554, D557
> Covers: Toolchain integration uses versioned plans, explicit authority, provenance, atomic local updates, and separately admitted adapters rather than hidden scripts or language semantics.

## Generated-API Projection Protocol

The `[generate.<name>]` manifest table remains the execution and authority contract for every generator. A generator uses the generated-API projection protocol only when it claims compiler, Analysis Server, documentation, audit, or generated-API integration.

### Request

The toolchain creates a fresh output root and writes one canonical versioned request file. The request contains:

- protocol version;
- generator executable identity, version, and content digest;
- package instance, edition, target, profile, and toolchain identity;
- declared input paths with normalized content digests;
- admitted environment keys and non-secret values;
- filesystem, process, network, clock, entropy, and other authority grants;
- requested output classes;
- previous projection identity when incremental projection is selected;
- canonicalization and path-remapping rules.

Request maps use lexicographically sorted UTF-8 keys, reject duplicate keys, reject non-finite numbers, and use the protocol's canonical integer/string encoding. Paths are package- or output-root-relative canonical paths. Absolute paths, `..`, symlink escapes, and undeclared roots are invalid.

Secrets are passed through explicit capability-bearing providers. Secret bytes, secret paths, access tokens, and private keys are absent from request files, result files, public provenance, diagnostics, and shared cache keys. A non-secret provider identity digest can participate in private local cache identity when the provider contract permits it.

### Result

The generator writes only under the fresh output root and returns one result manifest containing:

- protocol and request identity;
- complete output path, class, size, and digest records;
- structured diagnostics and related source locations;
- source and projection map references;
- stable generated-symbol identities and originating schema identities;
- generated declaration, visibility, ownership, allocator, capability, unsafe, and dependency facts;
- raw foreign versus admitted-safe-facade classification;
- generator logs and exit identity;
- drift digest over the complete result.

Large source maps, API indexes, and declaration tables are separate digest-addressed artifacts referenced by the result. A stable symbol identity can survive regeneration only when it refers to the same schema element under the generator's versioned identity rule. Reusing an identity for a different declaration is invalid output.

The toolchain validates the entire result before replacing the existing generated tree. Replacement is an atomic local filesystem transaction. Generator failure, malformed output, undeclared files, missing outputs, stale request identity, source-map disagreement, or digest mismatch leaves the prior generated tree unchanged. An interrupted commit leaves a recoverable transaction journal.

Generator-owned checked-in outputs are diagnosed when hand-edited. `kyokai generate --check` compares the validated projected result without replacing files. Generated Kyokai source uses `.kyo`; `.kai`, inherited source extensions, and `.koi` as source are rejected. Generated raw FFI declarations remain unsafe until a safe wrapper admission exists.

> Trace: D224, D351, D406, D430, D465, D499, D541
> Covers: Integrated generators share deterministic projection and editor provenance without becoming in-process compiler plugins or macros.

## Edition Migration Plans

The command surface is:

```text
kyokai migrate edition --to <edition> [--package <name> | --workspace]
kyokai migrate edition --apply <plan-path>
kyokai migrate edition --recover <journal-path>
```

The first command writes a versioned plan and changes no source. The plan records:

- source, manifest, lockfile, and generated-input preimage digests;
- package and dependency order;
- source edition and destination edition;
- selected targets, profiles, features, and policy configurations;
- classified source and manifest edits;
- generated inputs that require regeneration;
- expected `.koi` public-interface changes;
- lockfile graph consequences;
- unresolved choices and untested configurations;
- toolchain and migration-rule identity.

Each edit is one of `safe-mechanical`, `review-required`, `public-api-changing`, `target-conditional`, or `unresolved`. Only `safe-mechanical` edits can be selected for unattended application. Ownership, capability, failure, ABI, visibility, public API, dependency, and cross-package changes require explicit confirmation.

Generated outputs are regenerated from migrated inputs and generator declarations. They are not edited as handwritten files. Applying a plan verifies every preimage and rejects stale source before writing. Source, manifest, lockfile, and generated-input changes are staged and committed as one recoverable local transaction. External generator, signing, network, registry, device, and service side effects are not represented as rolled back.

The package edition field changes only after selected source and manifest edits apply successfully. The tool checks every configuration named by the plan and reports every configuration not checked. Partial workspace migration remains explicit and must satisfy mixed-edition package and `.koi` compatibility rules.

Human and JSON results contain plan identity, applied edits, confirmations, skipped edits, unresolved items, validation commands, generated results, `.koi` differences, and recovery-journal state.

> Trace: D105, D223, D488, D504, D544
> Covers: Edition changes are previewed, classified, replay-checked, workspace-aware, and honest about external side effects.

## Least-Authority Explanation And Repair

The command surface is:

```text
kyokai explain authority [<capability>] [--target <name>] [--json]
```

The report identifies the first authority-introducing API and the complete requirement graph from source declaration or package metadata through generated code, dependency edges, targets, command lanes, and effective deny-policy sources. Nodes distinguish toolchain defaults, user/global configuration, workspace and package ceilings, target contracts, generators, tests, documentation, audit, publish, and runtime startup grants.

When compiler and admission metadata prove a narrower legal path, the report lists the admitted handle and attenuation operation. A machine-applicable repair is limited to:

- threading an already-available narrow capability;
- adding an explicit parameter whose authority source already exists in the selected program;
- replacing a broad handle with a proven attenuation call;
- selecting an already-declared target or package path that has the narrower requirement.

The tool does not create authority, add a capability provider, widen global or manifest policy, add secrets, suppress unsafe requirements, mark a wrapper safe, or replace a dependency automatically. Policy widening and dependency alternatives are preview-only. An alternative records exact package identity, source/provenance, compatibility effect, admission/trust facts, and the authority difference.

Redaction removes secret values and sensitive paths while preserving requirement-node identity and causality. CLI, CI, Analysis Server, audit, and JSON lanes use the same graph and policy-precedence model.

> Trace: D310, D381, D492, D527, D545
> Covers: Capability denial produces a narrow repair path without an allow-everything action.

## Foreign Adapter Envelope

Kyokai defines three adapter classes:

| Class | Purpose | Permitted result |
| --- | --- | --- |
| Metadata query | Inspect an installed package, SDK, or toolchain without building it. | Canonical compile/link/runtime metadata and provenance. |
| Foreign build | Configure and execute a declared foreign build graph. | Declared artifacts, logs, dependency metadata, and plan digest. |
| Platform package | Consume checked Kyokai artifacts under a packaging plan. | Verified package/archive/image/store-ready outputs. |

Every adapter request records adapter identity/version, package or SDK identity, target, profile, selected C-toolchain contract, working roots, sysroot, configuration, filesystem/process/environment/network grants, declared inputs, and declared outputs. An adapter receives no source-language capability and cannot grant one.

Metadata and build results use canonical records for include paths, definitions, compile flags, link items and order, artifacts, runtime files, licenses, provenance, unsupported surfaces, raw logs, and a reproducible plan digest. Static/shared, multi-configuration, debug/release, cross-file, SDK, sysroot, generated-header, and vendored-subproject choices are explicit facts.

Configure probes and external execution require declared authority and outputs. Unknown adapter classes, protocol versions, or unadmitted adapter versions fail before execution. Adapter output cannot alter parsing, typing, ownership, capability, failure, or lowering semantics. Generated headers and sources remain under the generator protocol. Vendored foreign subprojects remain under package vendoring provenance.

`pkg-config`, CMake, Meson, Apple SDK/Xcode, Android NDK/Gradle, CUDA, browser asset systems, and other systems are adapter candidates. Each becomes official only after a separate admission record defines version range, supported surface, target matrix, authority, determinism, failure, logs, and conformance evidence.

> Trace: D83, D149-D150, D224, D351, D406, D465, D547
> Covers: Foreign ecosystem integration has one inspectable envelope and distinct operation classes instead of arbitrary manifest shell commands.

## Packaging Plans

A packaging plan is a versioned declarative artifact. It contains:

- checked input artifact paths and digests;
- target, profile, package, version, and compatibility identity;
- resources, generated assets, native dependencies, and runtime files;
- output format, architecture, component, and split relationships;
- metadata, entitlements, permissions, update channel, rollback, and secure-boot facts;
- symbols, source maps, SBOM, provenance, and advisory state;
- signing, notarization, timestamp, upload, and verification steps;
- selected adapter identity and supported format version.

Unsigned payload construction is deterministic when the platform format permits deterministic bytes. A platform limitation that prevents deterministic bytes is named in the adapter admission record and provenance output.

Signing, notarization, timestamping, upload, registry publication, and secret-provider access are separate plan steps with separate authority. A package adapter cannot rewrite checked source semantics or hide native dependencies. Success requires verification of the produced output. Multi-architecture, split, delta, rollback, and secure-boot outputs record every component digest and compatibility rule.

Each official format/platform adapter has a separate admission record containing tool identity, version range, target matrix, authority, secret handling, determinism limits, verification commands, failure classes, logs, and conformance fixtures. No package, installer, application store, firmware format, or registry is official merely because this plan schema can describe it.

> Trace: D225, D263, D503, D548
> Covers: Packaging is a first-party inspectable workflow while signing services and platform formats remain separately admitted boundaries.

## Runtime Dataset Update Operations

Toolchain-shipped and application-bundled datasets record version, digest, source, license, signature/provenance, provider class, and compatibility effect. Target-observed providers record the observed target identity. Network-updated providers additionally record endpoint policy, signature verification, freshness, expiry, cache, offline behavior, and required network capability.

Dataset update commands are explicit network- or filesystem-capable actions. They do not run during import, parsing, ordinary checking, or an unrelated build. A failed update leaves the previous verified dataset active and reports whether temporary files or a recovery journal remain.

Audit and reproducibility output state the effective dataset identity for Unicode, tzdb, trust roots, revocation, public suffix, MIME, locale, and every admitted behavioral dataset used by the selected target or application.

> Trace: D404, D421, D549
> Covers: Dataset freshness is visible and authority-bearing rather than a background side effect.

## Browser Build And Development Lane

Browser targets consume generated Web-IDL bindings and admitted wrappers. The build graph records browser target identity, Web API dataset identity, JavaScript/WebAssembly glue generator identity, assets, CSS modules, source maps, CSP requirements, worker/service-worker outputs, and browser-test matrix.

The Kyokai package and lockfile graph remains authoritative. A browser tool can invoke an admitted external asset adapter, but it cannot introduce a hidden npm graph or silently install packages. Every external asset graph appears as adapter input, lock/provenance metadata, and build-plan identity.

Development-server network listeners, browser launching, file watching, HMR channels, and remote debugging require explicit command authority. SSR, hydration, islands, reactive projection, and HMR are framework/generator protocols. Hydration output includes structural identity and source projection. HMR output names preserved state boundaries and compatibility. Arbitrary state preservation is invalid.

Browser test lanes distinguish simulated DOM tests, headless real-browser tests, browser/OS matrix tests, accessibility-tree tests, and deployment/CSP tests. A simulated lane does not establish real-browser conformance.

> Trace: D83, D406, D541, D546, D550
> Covers: Browser DX is integrated without replacing Kyokai packages, authority, or source semantics with a JavaScript toolchain model.

## Mobile Build And Distribution Lane

An Android support record names NDK, JNI/Kotlin generator, Gradle adapter, SDK/NDK versions, architectures, API levels, emulator/device classes, native library packaging, symbols, signing, and store-validation behavior. An Apple support record names SDK, deployment targets, architectures, C/Objective-C/Swift generator, Xcode adapter, simulator/device classes, dSYM/source maps, archive, notarization, signing, and store-validation behavior.

Generated managed-language shims use the generator protocol and retain source/projection maps. Build products use the foreign-adapter and packaging-plan contracts. Credentials, certificates, provisioning data, store metadata, and upload tokens are explicit secret-bearing packaging inputs.

Simulator and device execution are separate test classes. Crash and symbol reports retain Kyokai source-map identity. An unsupported OS, SDK, architecture, permission model, or adapter version fails with a target/toolchain diagnostic before packaging.

> Trace: D541, D547-D548, D554
> Covers: Mobile support includes the SDK, shim, test, symbol, signing, and store boundary instead of stopping at C interoperability.

## Cloud And Deployment Plans

Kyokai deployment plans can describe:

- OCI image construction;
- system-service units;
- Kubernetes resources and custom-resource inputs;
- serverless packaging and entrypoint metadata;
- Nix derivation or flake projections;
- provider-specific deployment adapters.

A plan records schema identity, source package and revision, toolchain, target/profile, checked artifact digests, native/runtime dependencies, generated files, capability requirements, secret-provider identities, service identities, health and readiness checks, resource policy, scaling and cold-start facts, telemetry export, rollback, drift policy, SBOM, provenance, signatures, and verification.

`plan` is read-only apart from declared local output artifacts. `apply` is a separate authority-bearing operation. Remote builds, caches, registries, deployment APIs, control planes, and telemetry endpoints require explicit network and secret providers. Apply results record changed resources, remote identities, observed revisions, verification, rollback availability, and partial failure.

Cloud SDKs are generated through the projection protocol or admitted through Bridge. Nix projection consumes the Kyokai reproducible build plan and exact artifact identities. Nix evaluation does not define Kyokai semantics, resolve hidden Kyokai dependencies, or change lockfile meaning.

Local emulators and test adapters identify the modeled provider surface. Their results do not establish production equivalence. Provider behavior remains in separately admitted adapters and cannot become core language semantics through deployment configuration.

> Trace: D83, D225, D526, D541, D546-D548, D557
> Covers: Deployment is inspectable, provenance-bearing, and authority-separated without embedding cloud or Nix semantics into the language.

## Diagnostics And Machine Output

Generator, migration, adapter, packaging, browser, mobile, and deployment diagnostics use stable codes and the common CLI JSON envelope. A diagnostic identifies the owning operation class, source or manifest span when available, tool/adapter/provider identity, target/profile, authority source, raw external log artifact, and recovery state.

An external-tool rejection is remapped to Kyokai source only when a validated source/projection map proves the relationship. Raw logs remain available. Failures are classified as source/configuration, generator, migration conflict, adapter unsupportedness, native dependency, packaging, signing, verification, remote service, authority denial, or external-tool failure. They are not fabricated as type errors.

> Trace: D29, D503, D535, D541, D544-D548, D550, D554, D557
> Covers: Integration failures remain script-safe, source-mapped only when proven, and honest about the failing boundary.

## Conformance

Conformance fixtures for this chapter cover:

- canonical generator requests and results;
- atomic projection replacement and drift detection;
- migration edit classification, stale-plan rejection, transaction recovery, and mixed editions;
- authority requirement graphs and forbidden automatic widening;
- adapter request/result canonicalization, unsupported versions, and authority denial;
- deterministic packaging where promised, signing separation, and mandatory output verification;
- dataset identity, update failure, expiry, and offline behavior;
- browser asset/glue provenance, hydration mismatch, HMR state boundaries, and real-browser lane labels;
- mobile shim/source maps, SDK matrices, simulator/device separation, and package verification;
- deployment plan/apply separation, provenance, drift, partial failure, and emulator labeling.

A fixture or plan-schema test is supporting evidence until a real public command or accepted compiler/toolchain-stage runner executes the specified behavior and checks the expected result.

> Trace: D155, D220, D367, D526, D540-D557
> Covers: Integration conformance requires executable result checking and does not promote metadata validation into implementation evidence.

## Why This Shape

[Rikona Kurasaki / Mjoyufull]
The dangerous part of a toolchain is rarely the command printed in the tutorial. It is the second process, the generated directory, the credential store, the target SDK, the upload step, and the recovery path after half of it changed. Kyokai writes those pieces into the plan. The work can still be large. It cannot be invisible.
