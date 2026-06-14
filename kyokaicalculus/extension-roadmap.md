# `lambda_K-*` Extension Roadmap

**Status:** `intended-by-spec` ownership map  
**Gate:** K-F open

| Layer | Owns | Evidence required before coverage is claimed |
| --- | --- | --- |
| `lambda_K-seq` | Sequential ownership, borrow exclusivity, lexical region end, checked TPOE, minimal branch joins, and sealed capabilities. | Syntax, dynamics, lemmas, paper proof, and reviewed surface map. |
| `lambda_K-elab` | Closed implicit-completion registry and source-to-core elaboration. | Elaboration rules and conformance matrix. |
| `lambda_K-cleanup` | `defer`, `errdefer`, `panic`, structured error exits, break/continue exits, cleanup selection, and LIFO execution. | Static cleanup states, dynamics, and no-drop extension theorem. |
| `lambda_K-gen` | Generics, universes, typeclasses, coherence, instances, materialization, and code-sharing boundaries. | Static extension rules and artifact model. |
| `lambda_K-layout` | Records, unions, arrays, construction state, pinning, ABI layout classes, and direct result placement. | Layout model and backend preservation links. |
| `lambda_K-conc` | Structured tasks, spawn transfer, channels, atomics, locks, pollers, signals, cancellation, and happens-before. | `concurrency-model.md` and later proof artifacts. |
| `lambda_K-unsafe` | Unsafe contracts, wrappers, FFI, ABI, volatile, inline assembly, plugins, and capability boundary. | `unsafe-ffi-boundary.md`, audits, and module-specific evidence. |
| `lambda_K-backend` | Generated-C lowering, admitted C-toolchain contracts, UB closure, evaluation-order preservation, and debug/source mapping. | `backend-preservation.md` and conformance evidence. |
| `lambda_K-stdlib` | Admission contracts, allocators, containers, text, I/O, numerics, crypto, and transitional FFI records. | `stdlib-contract-model.md` and API-specific evidence. |
| `lambda_K-toolchain` | `.koi`, builds, cache, packages, diagnostics, formatter, docs, Analysis Server, audit, and replay. | `toolchain-and-artifact-contracts.md` and fixtures. |
| `lambda_K-services` | Website, repository-owned package-doc retrieval, optional cache-only mirrors, playground deployment, auth/data boundaries, service ownership, and repository topology. | Public service records. This is operational conformance documentation, not metatheory. |
| `lambda_K-mech` | Proof-assistant artifacts. | `mechanization-plan.md`, checked files, and CI command. |

No layer inherits proof status from a neighboring layer. Each claim names its
own artifact and tier from `claim-tiers.md`.
