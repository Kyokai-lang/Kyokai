# Toolchain And Artifact Contract Model

**Status:** `intended-by-spec` conformance model  
**Layer:** `lambda_K-toolchain`

Toolchain behavior is outside type soundness but inside Kyokai conformance.

| Family | Required conformance record |
| --- | --- |
| CLI | Human output, JSON lane, color, prompts, quiet mode, exits, offline mode, and stable diagnostic categories. |
| Build artifacts | `kyokai-out/`, `.kyokai-cache/`, target/profile/backend/package partition, generated-C output, and cleaning behavior. |
| `.koi` | Canonical KBI identity, transport compression verification, required sections, compatibility gates, and verify/print/diff commands. |
| Packages | Manifests, workspaces, exact feature-set instances, lockfiles, vendoring, source identity, provenance, and network authority. |
| Diagnostics | Explanation IDs, checked fixes, resource-flow assists, branch-join reports, and file-role diagnostics. |
| Formatter | Idempotence, parse preservation, import-sort policy, and explicit partial-recovery write opt-in. |
| Analysis Server | Diagnostics, navigation, semantic facts, edits, package/build/docs facts, audit facts, controlled execution, and debugger lanes. |
| Tests | Sandboxes, fixtures, allocator failures, property/fuzz seeds, shrinking, replay, benchmark records, and coverage artifacts. |
| Docs | Generated public docs, package-root committed `kdocs/`, compact index projections, exact-revision retrieval, local cache, local rendering, and package-doc provenance. |
| Services | Playground, explorer, hot reload, optional package-doc cache mirrors, and advisory surfaces retain separate authority and deployment records. |

Every conformance rule uses an explicit contract matrix and modal audit. Tool
assistance produces visible source edits or reports; it does not change
language semantics.
