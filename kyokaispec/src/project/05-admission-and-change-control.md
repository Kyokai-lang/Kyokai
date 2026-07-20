# Admission And Semantic Change Control

[Rikona Kurasaki / Mjoyufull]
> ProofTrace: SPEC-PROJECT-05-ADMISSION-AND-CHANGE-CONTROL
> Covers: This project chapter defines how the official Kyokai project changes closed semantic registries and admits standard-library, Bridge, provider, and compiler surfaces without turning project paperwork into language semantics.

An admission record is evidence about a named implementation or integration.
It is not a language construct and cannot make an otherwise illegal program
legal. The language, toolchain, or standard-library chapter states the rule;
the admission record identifies the implementation, supported targets,
contracts, and evidence that claim to satisfy it.

Closed semantic registries include compiler-known typeclasses, implicit
completions, synchronized-sharing types, `SpawnShareable` entries, task-transfer
classifications, unsafe primitives, built-in operators, and target/provider
families whose membership affects checking or artifacts. The official project
changes one of these registries only through accepted shape, updated normative
text, `.koi` and compatibility treatment where applicable, diagnostics,
conformance cases, and a reviewed implementation change. An admission record
cannot add a member before the normative rule does.

Every official standard-library module, Bridge, foreign wrapper, generated
binding family, compiler/toolchain tuple, platform adapter, protocol provider,
cryptographic provider, runtime dataset, and application integration has its
own admission identity. The record contains the applicable contract fields
from the owning chapters, provenance, owner, review state, supported and
unsupported targets, implementation and unsafe boundaries, test evidence,
compatibility class, update policy, and withdrawal procedure.

Unsafe-origin instances and secret-, capability-, unsafe-, or foreign-backed
protocol implementations receive explicit audit coverage. Bridge or generated
status never makes a raw ABI declaration safe. A safe-wrapper admission points
to the exact unsafe contracts and wrapper APIs that establish ownership,
aliasing, lifetime, thread, callback, allocator, error-snapshot, capability,
cleanup, target, and provenance obligations.

An independent implementation may use different review machinery. It cannot
claim conformance after adding a semantic registry member that the applicable
Kyokai specification revision does not contain. It can implement an optional
or target-gated provider only within the bounds written by the owning contract.

> Trace: D85, D229-D232, D245, D376, D448, D460, D499, D501, D529, D569a-D569c, D576, D584, D593a
> Covers: Official admission proves a named implementation claim; normative chapters alone decide language and contract membership.
