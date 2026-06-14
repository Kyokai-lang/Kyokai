# Build Generation, Evaluation, Repl, And Playground

[Rikona Kurasaki / Mjoyufull]
> ProofTrace: SPEC-TOOLCHAIN-11-BUILD-GENERATION-AND-PLAYGROUND
> Covers: This chapter is registered in the public ProofTrace evidence graph; registration does not claim implementation, conformance, or theorem completion.

Generated code and playgrounds are where hidden power likes to dress up as convenience. Kyokai allows convenience, but it makes the wire visible: what runs, what it reads, what it writes, what authority it holds, and whether the result is ordinary Kyokai.

> Trace: D83, D150, D151-D151a, D226
> Covers: Build generation, exploration, and playground execution are explicit and authority-bounded.

## Build-Time Generation

Build-time generation is manifest-declared. A package may declare generators that produce `.kyo` source files, documentation assets, embedded data outputs, or declared native/generated-C inputs only through a `[generate.<name>]` table admitted by this chapter. A source file is not a build script merely because it exists in the repository.

> Trace: D78, D83, D150
> Covers: Generation is explicit manifest configuration, not hidden source execution.

A generator declaration records command identity, arguments, working directory, input files, output files, environment variables admitted by name, target/profile/edition inputs if used, required capabilities, and whether outputs are checked into source or build-directory only.

> Trace: D83, D137, D150
> Covers: Generator inputs, outputs, environment, and authority are declared.

Generated source under a package module root must have source origin metadata tying it to a generator declaration. Undeclared generated files that look like ordinary package source are rejected when the tool can distinguish them by source origin policy. A checked-in generated file without generation metadata is treated as ordinary source and must not be overwritten by a generator unless the manifest declares it as an output. Build-directory-only generated files go under the output tree `gen/` directory when they are user-visible declared outputs, and under the cache root when they are private generator scratch.

> Trace: D52, D78, D83, D150, D264
> Covers: Generated source is not silently mixed with handwritten source, and generated build-directory outputs are separated into visible `gen/` artifacts or private cache scratch.

Generators run before module discovery only for their declared outputs. A generator failure is a build failure. A generator must not modify files outside its declared outputs. The selected host sandbox enforces declared read, write, network, process-spawn, environment, and working-root grants when the host can enforce them. On a weaker host, audit marks the build as weaker and CI policy can reject it. Undeclared generator authority is a build error, not a warning.

> Trace: D78, D83, D150
> Covers: Generation has explicit output boundaries and audit-visible sandbox status.

## Embed File

`@embedFile` or the admitted embedding form reads a file as a compile-time input only when the source names it explicitly and the path is inside an admitted package asset root or declared generator output. The embedded bytes become part of build identity.

> Trace: D18, D83, D150
> Covers: Embedded files are explicit compile-time inputs.

Embedding a file grants no runtime filesystem authority. It copies bytes into an artifact according to the embedding rule; it does not let the program read arbitrary files at runtime and does not mint a filesystem capability.

> Trace: D67, D83, D211
> Covers: Compile-time embedding and runtime authority are separate.

## Evaluation

`kyokai eval` compiles and runs a one-shot expression, statement block, or file fragment through the real parser, resolver, type checker, borrow checker, capability checker, generated-C path, admitted external toolchain, and runtime path. It is not a separate scripting language.

> Trace: D151
> Covers: Evaluation mode uses ordinary Kyokai semantics.

`eval` receives no ambient capabilities by default. Capability-using evaluation requires explicit flags or declarations that say which capabilities are provided. If the target runner cannot safely provide the requested authority, evaluation fails.

> Trace: D67, D137, D151, D211
> Covers: Evaluation mode does not bypass capability rules.

## Repl

`kyokai repl` creates one persistent interactive session scope. Declarations and values may persist across turns according to ordinary ownership rules. Linear values may persist across turns only when they remain live in the session environment and are neither duplicated nor silently dropped.

> Trace: D151-D151a
> Covers: REPL scope is persistent and respects linear ownership.

`:reset` and `:quit` run ordinary eligible `defer` cleanup for the session scope and reject or report leftover live linear obligations according to the same rules as ordinary scope exit. The REPL must not silently leak or drop linear values to make interaction feel easier.

> Trace: D2, D151a
> Covers: REPL reset and quit obey cleanup and linearity rules.

REPL commands beginning with `:` are tool commands, not Kyokai source. Required commands are `:quit`, `:reset`, `:type <expr>`, `:browse <module>`, `:load <file>`, and `:help`. Tool commands must not be accepted inside ordinary `.kyo` source files.

> Trace: D151-D151a
> Covers: REPL commands are separate from source syntax.

## Compiler Explorer

Kyokai supports Compiler Explorer style operation by exposing a mode that compiles a single package or source snippet and returns generated C, external-tool assembly where requested and admitted, diagnostics, selected target/profile/C-toolchain facts, and source maps. This mode uses the same compiler engine, C emitter, and toolchain contracts as ordinary builds.

> Trace: D27, D31, D80, D139, D149, D226
> Covers: Compiler Explorer output is an official view of the real generated-C and admitted external-toolchain behavior.

Compiler Explorer mode must not run arbitrary compiled programs unless paired with the sandbox runner contract. It may compile and show artifacts without granting runtime authority.

> Trace: D67, D150, D226
> Covers: Compile-only exploration and program execution are separate authority modes.

## Sandbox Runner And Playground

The official sandbox runner contract defines how untrusted Kyokai programs are built and run for playground-like services. It must bound CPU time, wall time, memory, output bytes, process count, filesystem access, network access, environment variables, and available capabilities. Defaults deny filesystem, network, environment, process-spawn, and clock/random authority unless the sandbox profile explicitly grants them.

> Trace: D67, D137, D211, D226
> Covers: Playground execution is capability-denied by default and resource-bounded.

The normative toolchain surface is the sandbox-runner contract and a conforming runner implementation path. A hosted playground deployment, hostname, and frontend are infrastructure choices outside stable language semantics. Every official hosted playground uses the same runner contract; no web-only execution model exists.

> Trace: D226
> Covers: The normative requirement is the runner contract, not one permanent website.

Sandbox results must distinguish compile error, test failure, runtime normal exit, `panic`, TPOE, runtime-fatal termination, timeout, memory limit, output limit, sandbox policy violation, and internal runner error. These categories must not be collapsed into one generic failure.

> Trace: D29, D84, D226
> Covers: Playground failures preserve Kyokai failure categories and runner policy categories.

## Generation Sandbox Record

Each `[generate.<name>]` declaration records command identity, arguments, working root, input roots, output roots, admitted environment keys, filesystem grants, network grants, process-spawn grants, target, profile, edition and toolchain inputs, required capabilities, sandbox profile, checked-in or build-only classification, and provenance destination. A generator receives no `RootCapability`, no application capabilities, and no ambient secrets.

The build rejects undeclared reads and writes when the host sandbox can enforce them. On a weaker host, the audit record names the missing enforcement and CI policy can reject the build. Generated provenance records generator configuration hash, tool hash, input hashes, output hashes, and granted authority.

> Trace: D150, D465
> Covers: Build generation runs under a default-deny authority record with auditable weaker-host handling.

## Generation Drift Check

`kyokai generate --check` regenerates under the declared sandbox and fails when checked output differs. It prints changed outputs, generator identity, source digests, output digests, sandbox-profile identity, and provenance path. It does not rewrite files.

> Trace: D406, D465
> Covers: CI can detect stale checked-in generation without mutating the workspace.

## Generated-API Projection

A generator that claims compiler, Analysis Server, documentation, audit, or generated-API integration implements the versioned projection protocol in the application-integration toolchain chapter. Its ordinary `[generate.<name>]` declaration remains the execution, input, output, sandbox, and authority contract.

Projection runs use a fresh output root and canonical request/result manifests. The toolchain validates the complete output tree, stable generated-symbol identities, source/projection maps, API facts, and digests before atomically replacing the previous tree. Failure or malformed output leaves the previous tree active. `kyokai generate --check` compares the validated projection without replacing it.

Generators without integrated projection remain legal ordinary generators and emit no compiler/editor API projection. The protocol is not an in-process compiler plugin, macro system, parsing hook, or permission to execute outside the declared generation lane.

> Trace: D224, D351, D406, D465, D541
> Covers: Integrated generated APIs add validated metadata and atomic projection while preserving the existing explicit generator authority boundary.

## Bindgen Wrapper Kit

`kyokai bindgen` is a generation frontend for foreign interfaces. It records preprocessor identity, headers, include paths, macro-modeling policy, target headers, sysroot, defines, probes, generated raw declarations, generated wrapper skeletons, provenance digest, and audit destination. Generated declarations remain unsafe-only until wrapper admission establishes a safe API and records foreign error translation, callback rules, TLS error snapshots, target ABI facts, and replacement or permanent-boundary status.

> Trace: D405-D406, D430, D499
> Covers: Bindgen accelerates wrapper authoring without treating generated foreign declarations as safe Kyokai.

## Standalone Compiler Mode

Direct compiler mode accepts explicit source roots, dependency KBI artifacts, target record, profile, admitted C-toolchain contract, output root, and entrypoint or library artifact class. It uses the same parser, resolver, checker, lowering, generated-C emitter, external-tool invocation, diagnostics, artifact layout, source-map, and provenance rules as package builds. Bypassing manifest discovery does not define alternate language semantics.

> Trace: D426, D509
> Covers: Standalone compilation is an explicit-input lane through the ordinary compiler engine.

## Development Service Boundary

Scratch, eval, REPL, playground, and hosted development services use explicit sandbox profiles and non-release markers. Hot reload, debugger setup, and editor setup are toolchain development services. Hot reload requires a development profile, target support, `HotReloadCapability`, stable KBI identity, stable ABI fingerprint, stable layout dependencies, stable authority requirements, and no active linear-state migration. A reload that violates those requirements fails with a structured tool error.

> Trace: D475, D489, D505
> Covers: Development services improve iteration without changing stable language semantics or smuggling state migration into reload.

## Why This Shape

[Rikona Kurasaki / Mjoyufull]
There is nothing wrong with a generator, a REPL, or a playground. The danger is pretending they are small because they are convenient. A build generator can rewrite the room before the compiler walks in. A REPL can hide a dropped linear value behind a prompt. A playground can become a tiny unguarded server. Kyokai lets these tools exist with the lights on.

> Trace: D83, D150, D151-D151a, D226, D465, D475, D505, D509
> Covers: Convenience tools remain explicit about source generation, ownership, authority, sandbox boundaries, and artifact identity.
