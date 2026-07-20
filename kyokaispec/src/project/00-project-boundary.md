# Kyokai Project Contract And Evidence

[Rikona Kurasaki / Mjoyufull]
> ProofTrace: SPEC-PROJECT-00-BOUNDARY
> Covers: This chapter separates language and toolchain conformance from the governance, extraction, review, proof, licensing, and evidence rules of the official Kyokai project.

This part of the specification governs the official Kyokai project. It does not
add syntax, change program meaning, or impose the project's decision process on
an independent implementation.

The document uses five kinds of material:

| Part | Authority |
| --- | --- |
| Language | Defines accepted source programs and their static and dynamic meaning. |
| Toolchain | Defines observable behavior required of conforming Kyokai tools and artifacts. |
| Standard library | Defines the contracts of shipped Kyokai APIs and admitted providers. |
| Rationale | Explains pressure, prior art, and rejected designs without creating rules. |
| Project | Governs the official project's decisions, extraction evidence, proof claims, releases, and licensing. |

An independent implementation claiming language conformance follows the
language rules. It follows a toolchain or standard-library rule only when it
claims conformance for that surface. It need not use Kyokai's membership,
D-point, branch, review, or release procedure, and it cannot acquire official
project status merely by copying those procedures.

Implementation status is evidence, not semantics. Compiler source, tests,
admission records, review packets, and ProofTrace records can establish that a
named revision satisfies a rule. They cannot replace the rule or make a
different behavior conforming. Conversely, a complete rule does not claim that
the current compiler implements it.

The following project chapters contain governance, decision traceability,
formalization and review obligations, and the project's licensing boundary.
Keeping them inside this specification makes their relationship to accepted
semantics visible without presenting project administration as part of the
programming language.

> Trace: D86, D155, D307, D477, D502, D562-D562a, D577-D581
> Covers: Normative language, observable toolchain and library contracts, explanatory rationale, and official-project evidence have distinct authority even when published in one assembled specification.
