# Capabilities Rationale

[Rikona Kurasaki / Mjoyufull]
> ProofTrace: SPEC-RATIONALE-05-CAPABILITIES
> Covers: This chapter is registered in the public ProofTrace evidence graph; registration does not claim implementation, conformance, or theorem completion.

Borretti's Austral image still works: from the ground the crust looks enormous; from far away it is a thin skin over a much heavier world. Application code can feel like the whole world from inside it, but it rests on libraries, transitive dependencies, tools, plugins, generated code, and foreign calls. Kyokai's capability design starts from that change in scale.

> Trace: D67, D85, D211, D255
> Covers: Capability security makes authority visible in types, signatures, and stdlib contracts.

## Permissionless Code Is The Problem

[Rikona Kurasaki / Mjoyufull]
Modern software does not fail only because one team wrote one bad function. It fails because a dependency nobody reviewed can run with the same process authority as the code people trust. If a logging helper can read the environment, open arbitrary files, start a process, or talk to the network without the signature saying so, review has already lost the first round.

> Trace: D67, D113a-D113b, D171, D211-D212
> Covers: Filesystem, environment, process, dynamic loading, and external authority require explicit capabilities or handles.

Capabilities move authority from atmosphere into values. A function that needs filesystem access receives a `FileCapability` or a narrower handle. A function that reads environment variables receives `EnvCapability`. A function that talks to raw foreign code lives behind an unsafe boundary and a safe wrapper.

> Trace: D48/D162, D67, D171, D245, D255
> Covers: Authority is obtained through root-derived or explicitly passed capability values and unsafe wrappers.

## Root Authority

[Rikona Kurasaki / Mjoyufull]
Root authority enters only at bootstrap. Safe code cannot create it later, cannot forge it from raw bits, and cannot make an import grant it. That makes `main(root: RootCapability)` an honest sentence: this entrypoint may derive authority because the runtime handed it the one value that can prove it.

> Trace: D48/D162, D255
> Covers: `RootCapability` is minted only by runtime bootstrap and safe code cannot forge authority.

Authority can narrow. A root can derive filesystem authority. Filesystem authority can open a directory handle. A directory handle can be passed to a dependency that should see only that part of the world. The narrower value is easier to audit because it cannot mean the entire machine.

> Trace: D67, D171, D211
> Covers: Capability APIs can derive narrower authority values and handles with ordinary ownership rules.

## Capabilities And Linearity

[Rikona Kurasaki / Mjoyufull]
Capabilities fit linear types because authority should not duplicate accidentally. Surrendering a capability is passing it. Destroying it is consuming it. Borrowing it allows temporary use without creating a second owner.

> Trace: D6, D77, D211, D255
> Covers: Capability values follow ordinary linear ownership and borrow behavior.

Kyokai does not put every effect in a broad effect system. The authority boundary that matters most is built into capability values. Other effects, such as allocation, blocking, determinism, and platform behavior, are surfaced through names, signatures, and stdlib contract fields.

> Trace: D85, D211, D229
> Covers: Capabilities are Kyokai's built-in authority boundary while other effects remain contract-visible.

## FFI Boundary

[Rikona Kurasaki / Mjoyufull]
Foreign code is permissionless by default. Kyokai does not pretend a C function respects a capability merely because the wrapper wishes it did. That is why raw FFI belongs in unsafe modules with source-level unsafe contracts, safe wrappers, and audit surfaces.

> Trace: D20/D20a/D20b, D242/D242a/D245
> Covers: FFI authority and safety are controlled through unsafe modules, unsafe contracts, and safe wrappers.

The capability story is still useful at the boundary because it shrinks the audit surface. Instead of auditing every dependency for arbitrary file access, `kyokai audit` can name the modules that hold authority, unsafe code, dynamic loading, native dependencies, and capability-bearing APIs.

> Trace: D150, D211, D245
> Covers: Tooling can audit capability and unsafe surfaces without changing semantics.

## Bundles, Ceilings, And Sandboxes

[Rikona Kurasaki / Mjoyufull]
Passing ten narrow capabilities one by one can become visual noise. Hiding them in a global context would solve the wrong problem. Kyokai permits nominal bundles: ordinary visible records assembled at a boundary and passed where their shape is honest. Leaf APIs still ask for the narrowest capability or handle they need.

The same rule applies outside the running program. Package manifests can declare authority ceilings for dependency graphs. Build generators run under default-deny sandboxes with declared inputs, outputs, environment keys, network access, and process authority. A bundle, ceiling, or sandbox is useful because it names authority; none of them mint authority by convenience.

> Trace: D381, D462, D465, D492
> Covers: Visible bundles, dependency authority ceilings, and generation sandboxes improve capability ergonomics without creating ambient permission.
