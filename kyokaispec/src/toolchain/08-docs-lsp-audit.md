# Documentation, LSP, And Audit

[Rikona Kurasaki / Mjoyufull]
> ProofTrace: SPEC-TOOLCHAIN-08-DOCS-LSP-AUDIT
> Covers: This chapter is registered in the public ProofTrace evidence graph; registration does not claim implementation, conformance, or theorem completion.

Docs, editor tooling, and audit reports look like separate tools from the street. Inside Kyokai they stand on the same floor: the checked interface graph, the package boundary, visibility, contracts, capabilities, and unsafe facts the compiler already knows.

> Trace: D148, D150, D218
> Covers: Documentation, LSP, and audit tooling share the compiler engine and project graph.

## Documentation Generator

`kyokai doc` generates documentation from checked `.kyo` interfaces and the `.koi` artifacts of dependencies. Public documentation shows public declarations by default. `internal` declarations are shown only for same-package/internal documentation modes. Private (unmarked) declarations are excluded from public docs.

> Trace: D17, D79, D218
> Covers: Documentation follows visibility and interface artifacts.

Documentation output includes HTML for humans and JSON for tools. Both outputs include package identity, package version, language edition, module names, public declarations, type signatures, typeclass and instance surfaces, associated types, contracts, documented failure behavior, capability requirements, unsafe markers, deprecation markers, examples, and doc-test metadata.

> Trace: D53, D79, D105, D150, D218, D223
> Covers: Docs expose the API facts needed by users, tools, SemVer checks, and audits.

Declaration doc comments attach only to the immediately following declaration. Module and file doc comments attach only to their containing module or file surface. A doc comment cannot change type checking, visibility, ownership, borrowing, code generation, capability requirements, runtime behavior, or `.koi` semantics.

Docs metadata uses a closed machine-readable tag set for parameters, return value, errors, capabilities, allocation, blocking, cancellation, TPOE, panic/runtime-fatal behavior, safety and unsafe contracts, examples, deprecation, replacement, stability, target availability, feature requirements, security notes, and audit notes. `kyokai doc --check` rejects unknown tags. An executable example has exactly one status label: `conformance`, `illustrative`, `historical`, `aspirational`, or `negative`. Only an execution-admitted label with declared target and capability grants enters doc-test execution.

Deprecation metadata records the declaration or tool surface, since-version, reason, replacement when one exists, fix availability, fix safety class, diagnostic code, and removal class. Versioned docs JSON records declarations, visibility, signatures, typeclass facts, contracts, capability facts, allocation/failure/blocking facts, docs tags, examples, deprecations, stability tags, target guards, source spans, and links. Docs HTML, Analysis Server hover, SemVer checking, audit, and `kyokai fix` consume that shared metadata model.

> Trace: D427
> Covers: Doc attachment, tag validation, executable-example labels, deprecation metadata, and docs JSON consumers are explicit.

Documentation must render `require` and `ensure` contracts as first-class API facts. It must not bury contract clauses as unstructured comments when the compiler has checked them as contracts.

> Trace: D53, D218
> Covers: Contracts are visible documentation surface.

The documentation JSON schema must be versioned. A tool consuming docs must be able to distinguish a declaration removed from output, a declaration hidden by visibility mode, and a declaration whose source failed to check.

> Trace: D17, D29, D218
> Covers: Documentation JSON has stable schema and meaningful absence states.

`kyokai doc` writes project-local generated documentation to `<package-root>/kdocs/` by default. A standalone package therefore uses `project-root/kdocs/`; each published member of a workspace repository owns a separate `kdocs/` directory under that member package root. Build-output documentation requested through the output-root policy is written under `kyokai-out/<target-triple>/<profile>/<package-name>/doc/`. `kyokai doc --open` renders local generated docs first. It does not contact a remote host.

`kdocs/manifest.toml` records package identity, package version, repository URL, exact source revision, package-root-relative path, docs-schema version, selected toolchain identity and compatibility class, `.koi` digest, selected target/profile documentation contexts, feature-set package instance, dependency-graph identity, source-link facts, license metadata, advisory state, generation command, generated-file digest tree, deterministic documentation-search projection digest, and active-content classification. Every indexed file path is package-root-relative and canonical. Absolute paths, `..`, symlink escapes, mutable branch references, and indexed files outside `kdocs/` are illegal.

`kyokai doc --check` verifies that checked package source, `kyokai.toml`, `.koi` facts, generated files, digests, docs metadata, and exact source revision agree. It exits unsuccessfully when `kdocs/` is absent, stale, malformed, generated from another package revision, or inconsistent with the package instance.

`kyokai docs --pull <pkg>` fetches one package's documentation from the exact indexed Git revision or its verified `kdocs/` subtree. `kyokai docs --pull all` performs the same operation for the resolved dependency graph. Both commands verify recorded digests and schema compatibility before storing docs in the local cache. These are explicit network-capable actions. The offline docs cache is keyed by package identity, revision, selected toolchain, target/profile docs context, feature-set package instance, `.koi` digest, docs-schema version, and dependency-graph identity. `kyokai clean docs` removes local generated docs and docs-cache entries without removing source, manifests, or lockfiles.

> Trace: D396, D515-D516, D525
> Covers: Package-root docs generation, committed publication artifacts, verification, build-output docs, explicit docs pulls, offline cache identity, and docs cleanup are separate and inspectable.

## Analysis Server And LSP

The Analysis Server is the required first-party analysis engine. `kyokai lsp` is the official protocol frontend over that server. It is not a separate analyzer.

`kyokai lsp` is the official language server. It uses the same parser, resolver, type checker, borrow checker, capability checker, target guard evaluator, `.koi` reader, formatter, and diagnostic engine as the command-line compiler. It may cache and schedule work differently, but it must not define a second semantic model.

> Trace: D29, D79, D148
> Covers: The LSP shares compiler truth instead of becoming a parallel compiler.

The LSP must respect the same manifest discovery and workspace rules as the CLI. An editor workspace containing several manifests is not automatically a Kyokai workspace unless a `kyokai.toml` declares `[workspace]` and members.

> Trace: D78, D148
> Covers: Editor project shape follows the same manifest contract.

LSP diagnostics use the same diagnostic codes and JSON-compatible fields as CLI diagnostics. The LSP may stream partial diagnostics while the user edits, but completed diagnostics for a stable source snapshot must match `kyokai check` for the phases the LSP reports.

> Trace: D29, D148
> Covers: LSP diagnostics are compatible with CLI diagnostics.

Every Analysis Server feature observes visibility, target guards, editions, imports, typeclass resolution, generated-source boundaries, source snapshots, and the same checked semantic model as `kyokai check`. A code action that rewrites source is an ordinary workspace edit and cannot bypass formatting or compiler validation.

| Lane | Required first-party surface |
| --- | --- |
| Navigation | Completion, hover, go-to definition, go-to type, references, rename, document symbols, workspace symbols, call hierarchy, type hierarchy, implementation lookup, declaration-to-derived-interface navigation, and generated-source origin navigation. |
| Editing | Formatter integration, organize imports, manifest-aware package edits, safe workspace edits, safe fix preview, resource-flow refactors, public-signature migration, `.koi`/KBI diff migration, test skeletons, docs skeletons, and example/doc-test insertion. |
| Diagnostics | Compiler-backed diagnostics, warning categories, explanation links, fix IDs, diagnostic provenance, stale generated-source reports, stale `.koi` interface reports, target/profile guards, and CLI-compatible JSON identity. |
| Ownership and cleanup | Moved values, consumed values, live immutable borrows, live mutable borrows, reborrow chains, branch-join tables, pass-through obligations, `defer` and `errdefer` obligations, drain/finalization obligations, partial-initialization state, builder-block state, task-transfer graphs, and early-release opportunities. |
| Capability and audit | Required capabilities, capability flow, overbroad-authority warnings, unsafe-origin instances, unsafe contracts, dependency authority trees, manifest ceilings, effective capability deny policy, denied-authority diagnostics, audit records, FFI wrapper records, and generated-binding provenance. |
| Package, build, and docs | Workspace roots, package graph, lockfile state, index/vendor provenance, SemVer facts, local `kdocs/`, remote docs-cache state, examples, doc tests, target/profile/C-toolchain state, and generated artifacts. |
| Lowering and debug | Surface parse, typed elaboration, inserted completions, lowered core, generated C, source maps, layout facts, `.koi`/KBI facts, and C-toolchain/build-plan provenance. |
| Migration and CI | Constructor migration, record-field migration, capability-parameter migration, cleanup insertion, total-destructuring repair, downstream call-site repair, config-matrix checking, and CI/eval parity reports. |

Interface derivation is an ordinary checked-source workflow. The server provides navigation between a declaration and its derived `.koi` interface entry, visibility-change previews across private, `internal`, and `public`, signature and contract previews against the derived interface, rename previews that show the affected public surface, and stale-`.koi` diagnostics. These actions edit the one explicit `.kyo` source file. They do not make the generated `.koi` authoritative over the source or expose a declaration the source did not mark.

Structural editor assistance preserves Kyokai's written terminators. Official clients provide folding, structural selection, opener/terminator matching, and repair for a missing or wrong terminator. They do not replace terminators with braces, hide them, or render an official alternate block notation.

Import completion inserts only the accepted qualified, aliased, or selective import forms. Before applying an edit, the action reports the source module, introduced local spelling, collision result, and whether the form is qualified or selective. It never introduces wildcard imports, implicit imports, transitive namespace injection, or generated everything-modules.

Callback hover and diagnostics expose the selected callable invocation class, arity, environment universe, explicit captures and capture modes, borrow regions, state consumption or replacement obligation, and known thread, executor, or reentrancy requirements. A capture error points primarily at the capture expression or captured binding. Framework declarations, generated adapters, and unsafe wrapper records are related locations unless one of those contracts is itself the defect.

Completion groups accepted operation families such as blocking, try, deadline, and poller variants. Grouping is presentation only. It does not create an overloaded operation, hide blocking or cancellation, or rename the declared APIs.

Rename returns an LSP `WorkspaceEdit` plus Kyokai rename safety metadata. The closed safety classes are `LocalPrivate`, `ModulePrivate`, `PackagePrivate`, `WorkspaceInternal`, and `PublicInterfaceChanging`. A public-interface rename requires successful name resolution, a visibility check, an affected `.koi` diff, and user confirmation. During broken-parse recovery, the server offers local textual rename only for a fully resolved symbol; it rejects rename for an unresolved symbol. A cross-package rename remains preview-only until `kyokai check --affected` succeeds, unless the client requested dry-run and therefore requested no edits.

> Trace: D450
> Covers: Rename safety classes, public-interface confirmation, broken-parse limits, `.koi` diffing, and cross-package validation are explicit.

Resource-flow edits use the shared closed safety classes: `note-only`, `manual`, `maybe-applicable`, `machine-applicable`, and `machine-applicable-safe`. A `machine-applicable-safe` edit is offered only after parse, type, linearity, borrow, capability, contract, format, and selected target/config checks pass after application. A `machine-applicable` edit set requires explicit opt-in. When several explicit repairs are valid, the server returns `maybe-applicable` candidates or an ordered `manual` checklist without applying one silently.

Official Neovim, VS Code-compatible, and Zed bundles launch the same server binary and formatter command. A protocol-version mismatch fails startup with expected protocol version, actual protocol version, selected toolchain, and update command.

> Trace: D25, D78-D79, D105, D148, D303, D450, D474, D488, D504-D505
> Covers: The Analysis Server has explicit navigation, editing, diagnostic, ownership, authority, package, lowering, migration, and setup lanes over the ordinary compiler model.

## Audit

`kyokai audit` reports supply-chain, unsafe, FFI, capability, native dependency, generated-source, target, license, and public API risk facts. It does not change language semantics and does not grant authority. It reads manifests, lockfiles, source interfaces/bodies where available, `.koi` artifacts, package index metadata, target-spec files, and configured audit policy.

> Trace: D20, D51, D79, D150, D221, D244, D245
> Covers: Audit is a read-only risk report over package, source, dependency, and artifact facts.

Audit output includes at least these categories:

| Category | Required Facts | Trace |
| --- | --- | --- |
| Dependencies | Git URL, pinned revision, tag label, package identity, version, yanked status, advisories when known. | D51, D221, D244 |
| Unsafe | Unsafe modules, unsafe contracts, raw pointer use, volatile/MMIO, inline assembly, dynamic loading, and unsafe capability access. | D20, D22, D94, D150, D245, D257 |
| FFI/native | Foreign blocks, exported ABI surfaces, native libraries, link flags, ownership/failure contracts, and transitional FFI status. | D20, D31, D150, D230 |
| Capabilities | Public APIs requiring capabilities, capability derivation/splitting/surrender, task-transfer capability surfaces, root authority entrypoints, configured capability deny policy, and denied graph edges. | D48, D137, D150, D211, D255, D527 |
| Generation | Build-time generators, declared inputs/outputs, sandbox grants, generated source provenance, stale generation, hand-edited generated files, generated bindings, and wrapper admission state. | D83, D150, D406, D430, D465, D499 |
| Reproducibility | Hidden-input risks, path remapping gaps, target-spec drift, lockfile freshness, package-source identity, cache trust, remote-cache policy, and non-reproducible output modes. | D83, D423-D424, D429, D461 |
| API | Public declarations exposed by unsafe modules, SemVer-relevant interface changes, deprecated APIs, capability ceilings, and contract changes. | D17, D218, D223, D416, D462 |
| Documentation | Local docs provenance, docs-cache identity, repository-owned `kdocs/` state, indexed raw-file retrieval state, stale docs, malformed docs, schema incompatibility, digest mismatch, untrusted revision state, browser-render availability, and target-context mismatch. | D515-D516, D525 |

> Trace: D17, D20, D22, D31, D48, D51, D83, D94, D137, D150, D211, D218, D221, D223, D230, D244-D245, D255, D257, D406, D416, D423-D424, D429-D430, D461-D462, D465, D499, D515-D516, D525, D527
> Covers: Audit reports cover dependencies, unsafe code, FFI/native links, capabilities, denied-authority policy, generation, reproducibility, documentation provenance, and API risk.

An audit policy may promote categories to errors. For example, a project may reject yanked dependencies, public unsafe surfaces, undeclared native libraries, unreviewed build generators, or packages whose `.koi` provenance cannot be verified. Policy failures use audit diagnostics and exit status `1`.

> Trace: D29, D150, D244
> Covers: Audit policy is explicit and CI-enforceable.

Audit must distinguish implementation ceiling from public surface. A package may use unsafe internally without exposing unsafe authority publicly, but the audit report must show both facts so reviewers can tell the difference between contained risk and exported risk.

> Trace: D17, D150, D245
> Covers: Audit separates internal implementation risk from public API risk.

## Why This Shape

[Rikona Kurasaki / Mjoyufull]
Documentation is the face of the API. The Analysis Server keeps the compiler's facts beside the source while it is written. Audit checks the locks after sunset. They cannot be three different stories. If the compiler knows a function needs authority, or an unsafe wrapper holds the line against C, those tools show it plainly.

> Trace: D148, D150, D218
> Covers: Docs, LSP, and audit are trustworthy only when they share the compiler's semantic facts.

## ProofTrace Reports

> Trace: D526
> Covers: Tooling presents checked evidence metadata without converting reports, editor hints, or status views into language semantics or proof conclusions.

The public `kyokaiproofstatus.md` board is generated from `kyokaiproofstatus.toml`. Tooling can expose the same records through documentation pages, Analysis Server navigation, and audit reports. A displayed record includes stable ID, scope, owner, specification state, implementation state, conformance state, proof state, proof requirement, artifacts, and exclusions.

The Analysis Server can navigate from a registered spec chapter or maintained code-boundary comment to its ProofTrace record. `kyokai audit` can report stale, malformed, missing, or overclaimed metadata. These surfaces are tooling-only assistance. They do not accept rejected source, weaken a static rule, grant authority, or claim a theorem from tests alone.

## Application Integration Views

Documentation and Analysis Server views expose generated-API projection identity, schema origin, stable generated-symbol identity, generated ownership/allocation/capability/unsafe facts, and source/projection maps. Generator-owned files are visibly generated; edits route to the originating schema or generator input only when a validated projection map provides that location.

Edition migration appears first as a preview over the versioned migration plan. The view groups safe mechanical, review-required, public-API-changing, target-conditional, and unresolved edits; shows `.koi`, lockfile, generated-input, and configuration effects; and never applies an edit merely because it can render one.

Framework state views expose owner and handle types, handle owner/generation identity without revealing forgeable representation, invalidation classes, current mutation epoch, active view conflicts, and persistent-identity separation. Callback views expose the existing callable class and the API contract's retention, affinity, reentrancy, cancellation, retry, replacement, and state-consumption facts. No editor presentation creates a callback-role type system.

Authority views use the same requirement graph and policy precedence as `kyokai explain authority`, CI, and audit. A code action cannot widen the effective ceiling or create a missing authority source.

> Trace: D504, D540-D545
> Covers: Documentation and editor assistance project generated, migration, framework-state, callback, and authority facts without changing source semantics or applying authority-expanding edits.
