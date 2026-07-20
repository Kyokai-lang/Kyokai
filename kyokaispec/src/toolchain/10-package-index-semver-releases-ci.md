# Package Index, SemVer, Releases, And CI

[Rikona Kurasaki / Mjoyufull]
> ProofTrace: SPEC-TOOLCHAIN-10-PACKAGE-INDEX-SEMVER-RELEASES-CI
> Covers: This chapter is registered in the public ProofTrace evidence graph; registration does not claim implementation, conformance, or theorem completion.

The package index provides discovery and resolution metadata; it is not the source of package contents. Resolution selects immutable source identity, interface checking validates the selected package, and release artifacts carry inspectable provenance.

> Trace: D51, D221, D223-D225, D244
> Covers: Package discovery, versioning, yanks, release artifacts, and CI are explicit ecosystem contracts.

## Package Discovery Index

The official package index is a read-only discovery and resolution metadata index. It records package names, versions, source repository URLs, immutable source revisions, canonical source hashes, yanked status, advisory metadata, documentation metadata, license metadata, feature metadata, dependency requirements, and `.koi` interface summaries where produced. Documentation metadata includes the package-root path, `kdocs/manifest.toml` digest, docs-schema version, raw-file adapter class, docs status, and compact deterministic search projection. The index is not the canonical source or documentation store and does not replace exact Git `rev` identity in the lockfile.

> Trace: D51, D221, D223, D244, D525, D528
> Covers: The package index helps users find packages, solve indexed version requirements, and locate repository-owned documentation without becoming the source or documentation storage authority.

The official Bridge collection is outside the package index. Bridge entries are shipped first-party toolchain/library modules under `Kyokai.Bridge.*`; their metadata records upstream provenance, license facts, admission status, target gates, native-link requirements, unsafe contracts, and capability requirements. Package-index search may display cross-links between ordinary packages and related Bridge entries, but those links do not make an ordinary package official Bridge surface and do not make a Bridge entry an indexed package dependency.

> Trace: D221, D419, D522, D529
> Covers: Package-index discovery and Bridge collection governance remain separate, while search can expose related facts without combining trust.

A dependency resolved through the index starts from a manifest version requirement and index metadata. The resolver selects a package version and immutable source revision, then writes the selected package instance into the lockfile with exact revision, canonical source hash, selected features, target/profile inputs, policy identities, observed yank/advisory state, and source provenance. A manifest records version intent; the lockfile records exact source identity used for the build.

> Trace: D51, D83, D221, D223, D528
> Covers: Index discovery and version intent do not weaken lockfile reproducibility.

Index metadata is append-only for released versions except for yanks, advisories, documentation links, and explicitly versioned metadata corrections. A metadata correction must not change the source revision or package identity of an existing version.

> Trace: D221, D244
> Covers: Published version identity is stable while safety metadata can grow.

Index records used by the resolver include the dependency requirements declared by each indexed package version. Those requirements use the same closed dependency source kinds and version-requirement grammar as package manifests. A package-index correction that changes dependency requirements for an existing released version is a new metadata revision and appears in index snapshot identity; it must not silently change an existing lockfile's graph meaning.

> Trace: D223, D424, D528
> Covers: Package-index dependency metadata is resolver input, versioned by index snapshot identity, and cannot silently rewrite existing locked graphs.

## Yanks

A yank marks a package version or source revision as unavailable for new resolution. Existing lockfiles that already name the yanked revision continue to build unless audit policy, advisory policy, or an explicit security block rejects them.

> Trace: D83, D244
> Covers: Yanks affect new selection without breaking existing lockfile meaning.

A yank record includes package name, version, source revision, reason category, timestamp authority of the index, and either an advisory link or an explicit no-advisory-link marker. The reason category is one of `security`, `soundness`, `licensing`, `accidental-publish`, `replaced`, or `other`.

> Trace: D221, D244
> Covers: Yank metadata is inspectable and categorized.

## Package Inspection And Offline Workflows

`kyokai search` queries configured package discovery indexes and prints package metadata. `kyokai info` prints one package or dependency's identity, source revision, version, license, docs link, yanked/advisory state, public interface summary, and audit summary when those facts are known. Both commands are read-only with respect to manifests and lockfiles.

> Trace: D51, D150, D221, D269
> Covers: Package discovery and package fact lookup are daily read-only operations.

`kyokai tree` prints the selected dependency graph in deterministic order. `kyokai why <package>` prints dependency paths explaining why a package is present. `kyokai outdated` compares lockfile package instances to configured update policy and index metadata, reporting newer versions, newer revisions, yanks, advisories, and policy-blocked candidates without editing files.

> Trace: D51, D83, D221, D244, D269, D528
> Covers: Dependency graph explanation and update visibility are available without changing the build.

`kyokai vendor` materializes exact locked dependency sources into an explicit vendor directory. Vendor metadata records package identity, source URL, revision, checksums where available, and lockfile identity. Offline builds may use vendored sources only when that metadata agrees with the lockfile; a vendor directory is never a hidden package registry.

> Trace: D51, D83, D269
> Covers: Offline use keeps pinned dependency identity and does not create a second dependency authority.

Vendoring does not copy the installed Bridge collection. A project using `Kyokai.Bridge.*` relies on the installed toolchain's bridge interface and admission records. The release artifact for the toolchain carries bridge source, copied-file inventory, license records, provenance, and checksums as first-party distribution evidence. A project that needs to pin or audit an independent upstream source tree uses ordinary dependencies and `kyokai.lock`, not Bridge vendoring.

> Trace: D51, D83, D225, D263, D269, D529
> Covers: Bridge code ships with the toolchain and ordinary vendoring remains only for locked package dependencies.

## SemVer Convention

The `version` field follows SemVer as an ecosystem convention for package API intent. It does not replace immutable revision pins and it does not define language editions. The source revision and lockfile remain the reproducibility mechanism.

> Trace: D105, D223, D243
> Covers: SemVer guides package evolution without becoming edition or resolution identity.

`kyokai semver-check` compares public `.kyo` interfaces, `.koi` API metadata, docs JSON, and declared tool-schema surfaces. Public compatibility includes signatures, visibility, typeclass instances, associated types, capability requirements, allocation behavior, blocking behavior, error/result variants, panic/TPOE/runtime-fatal cases, iteration and ordering guarantees, target availability, exported ABI surfaces, docs JSON, diagnostic JSON, and declared security or performance contracts when those facts are part of the public contract.

The report classifies each difference as `source-breaking`, `abi-breaking`, `behavior-contract-breaking`, `diagnostic-or-tool-output-breaking`, `additive-compatible`, or `documentation-only`. Publishing rejects a version that understates the reported difference unless an explicit maintainer override records the reason. A bug or security repair is non-breaking only when the previous behavior was outside the stated contract or the release record identifies the correction policy.

> Trace: D17, D20, D53, D79, D218, D223, D416
> Covers: SemVer checking covers public source, ABI, behavior, failure, capability, documentation, and machine-schema contracts and emits explicit diff classes.

The checker is advisory by default. CI or manifest policy may promote SemVer findings to errors. A SemVer pass does not prove behavioral compatibility beyond the surfaces the checker actually compares, and the report must say which comparison domains were included.

> Trace: D29, D223, D225
> Covers: SemVer checks are useful but honest about their proof boundary.

## Release Cadence

Early Kyokai releases ship when the project has something coherent to release. Once the toolchain reaches steady public use, ordinary toolchain releases default to a four-week train. Language editions remain rare, demand-driven, and separate from the ordinary release train.

> Trace: D105, D157, D243
> Covers: Toolchain release cadence and language editions are separate clocks.

A release note must classify changes as bug fix, toolchain behavior change, diagnostic change, package ecosystem change, stdlib API change, generated-C/C-toolchain/target support change, SemVer-relevant API change, or edition/source-semantics change.

> Trace: D105, D157, D223, D243
> Covers: Releases explain compatibility impact explicitly.

## Official Artifacts

Official releases provide source archives, compiler/toolchain binaries for supported hosts, checksums, provenance records, signatures when signing infrastructure exists, setup action metadata, OCI images, and target support notes. Runtime, stdlib, startup, compiler support, and target helper license boundaries follow the project licensing decision; spec documentation keeps its existing documentation license.

> Trace: D225, D263
> Covers: Release artifacts and licensing boundaries are visible.

Checksums cover every distributed archive and binary. Provenance records name source revision, Kyokai toolchain version, build identity, target, profile, admitted C-toolchain contract and executable identities, lockfile hash, artifact hash, and builder identity class. If a release artifact is rebuilt, the new artifact must either match or carry a new provenance record explaining the changed identity.

> Trace: D83, D225
> Covers: Release artifacts are verifiable and provenance-backed.

## CI Installation Contract

The official CI contract provides one portable installation path for supported CI systems. `setup-kyokai` or the equivalent official action installs a requested toolchain version, verifies checksums, exposes `kyokai` on `PATH`, and reports the installed version. Cache priming runs only when the action input `prime-cache = true` is selected, and it must not change project lockfiles.

> Trace: D225
> Covers: CI installs are standard, verified, and lockfile-preserving.

Official OCI images include the toolchain, target support declared by the image tag, checksums/provenance labels, and documented default user/environment behavior. Image tags that move, such as `latest`, are convenience labels and must not be used as reproducible release identity.

> Trace: D83, D225
> Covers: OCI images support CI while preserving immutable release identity.

## Local Toolchain Health

The installed toolchain reports its identity through `kyokai --version`: toolchain version, source revision or release id, supported language editions, diagnostic schema version, host triple, default target-toolchain contract, generated-C schema version, and KBI compatibility range. This command does not need a project and must not read source files.

> Trace: D105, D225, D265, D268
> Covers: Users and CI can inspect the installed compiler identity without constructing a project.

`kyokai doctor` checks local setup: release provenance, checksum/signature status where available, host support, configured target tools, admitted C compiler/linker discovery, cache and output writability, package index access, environment variables admitted by the toolchain spec, and common path or permission mistakes. It reports diagnostics and suggested repairs but does not modify project files.

> Trace: D31, D80, D149, D225, D268
> Covers: Host setup failures are diagnosable through a first-party command instead of surfacing as late build folklore.

## Discovery Is Not Trust

[Rikona Kurasaki / Mjoyufull]
The package index supports discovery but does not establish source or build identity. The lockfile records the resolved source, `.koi` records the checked interface, and release provenance records which source and target produced an artifact. Search rank, ownership, support, advisories, and provenance remain separate facts rather than collapsing into one trust score.

> Trace: D51, D83, D221, D223-D225, D244
> Covers: Kyokai's ecosystem model combines discoverability with pinned, auditable, reproducible source identity.

## Index Record Separation

Index records separate package identity, immutable source revision, canonical source-artifact digest, package owner metadata, repository-owned docs state, docs-manifest digest, raw-file adapter class, compact docs-search projection, yank state, advisory records, security holds, takedowns, name disputes, maintainer transfers, provenance records, support tier, badges, search facts, and editorial showcase links. Each record type has its own schema. No record silently changes source identity.

Public index names use the canonical lowercase ASCII grammar in the manifest chapter. Reserved standard-library, official-tool, example, advisory, infrastructure, and official-namespace names cannot be claimed by ordinary packages. A name confusingly close to an official or reserved name is rejected. Similarity to an ordinary third-party name is advisory metadata only; it is not package-identity normalization and does not prove malice.

> Trace: D419, D423, D506, D522
> Covers: Package identity, canonical content, reserved names, search, showcase, badges, and trust metadata remain separate records.

## Advisories And Minimum-Safe Versions

Advisories record identifier, affected package identities and revisions or version ranges, severity vocabulary, summary, patched revisions, yanks, minimum safe version when one exists, publication timestamp authority, and source links. `kyokai audit` reports advisory state without rewriting lockfiles. A security policy blocks an affected lockfile only when the selected policy declares that behavior.

> Trace: D428, D431
> Covers: Advisory reporting and policy-controlled blocking do not mutate package identity or lockfile meaning silently.

## Repository-Owned Package Documentation

Every package published to the official index contains generated `kdocs/` directly under that package's root in the exact indexed Git revision. A standalone package therefore uses `project-root/kdocs/`; a workspace repository stores one `kdocs/` directory under each published member package root. `kdocs/` is a tracked publication artifact. The official infrastructure does not require a second upload of the full documentation tree.

The package-index docs record stores package identity, package version, repository URL, exact source revision, package-root path, source digest, `kdocs/manifest.toml` digest, docs-schema version, raw-file adapter class, docs status, and deterministic compact search projection. Early publication uses the same reviewed PR/MR metadata or signed automation path as package release metadata. It does not require a custom login service. A replacement ownership flow requires an accepted public rule before deployment.

The official website retrieves structured documentation files from the exact indexed Git revision through a reviewed forge raw-file adapter, verifies recorded digests, and renders the structured schema through the official renderer. Publisher-controlled HTML, scripts, stylesheets, executable content, and active embeds are not injected into the official Kyokai origin. A Git host with no reviewed browser raw-file adapter reports `browser-render-unavailable`; this does not invalidate toolchain retrieval through the pinned Git revision.

An official docs page reports `verified`, `missing`, `stale`, `malformed`, `schema-incompatible`, `digest-mismatch`, `target-context-mismatch`, `untrusted-revision`, or `browser-render-unavailable`. Documentation indexing and rendering never grant package trust, ownership, support, vulnerability clearance, or source authority.

`kyokai-package-docs` is not a required bootstrap repository. A later docs mirror is cache-aside infrastructure only. It requires a separate service decision defining storage budgets, retention, regeneration, active-content policy, failure states, and deployment ownership. It never becomes canonical documentation storage or a package-publication requirement.

> Trace: D515-D516, D520, D525
> Covers: Published documentation is committed beside exact Git-hosted package source, centrally indexed as compact reviewed metadata, retrieved through verified raw-file adapters or pinned Git fetches, and rendered without turning Kyokai into a package-doc storage service or granting trust implicitly.

## Release Verification

Official releases publish source archive, toolchain binaries, checksums, provenance, setup metadata, target notes, SBOM status, and attestation status. Release verification checks checksum and provenance independently of caches. CI installation verifies exact requested toolchain identity before exposing `kyokai` on `PATH`.

> Trace: D225, D461
> Covers: Release artifacts and CI setup verify exact identity independently of cache state.

## ProofTrace CI Contract

> Trace: D526
> Covers: CI checks the public evidence graph and generated status board while preserving the difference between metadata validation, executable tests, conformance evidence, and proofs.

CI runs `make check-prooftrace`. The check validates `kyokaiproofstatus.toml`, chapter-level ProofTrace registrations, mandatory code-boundary `kyokai:prooftrace id=...` comments, closed status and no-proof vocabularies, referenced artifact paths, and generated `kyokaiproofstatus.md` freshness. A stale board is an error; `make proofstatus` is the regeneration command.

Passing this lane proves only that public evidence metadata is internally consistent. It does not prove that a registered implementation is correct, turn inherited bootstrap code into Kyokai conformance evidence, or upgrade an `intended-by-spec` theorem target to `paper-proven` or `mechanically-proven`.

## Packaging And Deployment Evidence

Release records reference the exact packaging-plan schema and digest, admitted adapter identity, checked input artifacts, produced component digests, native/runtime dependencies, symbols/source maps, SBOM and provenance state, signing/notarization/timestamp identities, verification results, and rollback facts. Registry upload or application-store acceptance is an operational result, not proof of compiler or package conformance.

Deployment records reference the exact deployment-plan digest, checked artifact identities, target/profile/toolchain identity, provider adapter, capability requirements, secret-provider identities, remote resource identities, observed revision, drift result, verification result, rollback availability, and partial-failure state. A Nix derivation or flake is a projection of that explicit build/deployment record; Nix evaluation does not define Kyokai dependency or language semantics.

Official package formats, stores, deployment providers, and Nix projections require separate adapter admission and CI fixtures. A generic plan schema does not make a platform supported.

> Trace: D225, D263, D503, D548, D554, D557
> Covers: Release and deployment metadata preserve exact plan, adapter, artifact, authority, provenance, verification, and rollback identity without turning an external platform into semantic authority.

## Knot And Package Publication

Every package keeps its own public name, version, edition/compatibility facts,
owners, features, dependencies, KST/source identity, license/provenance, docs,
SemVer surface, advisories, yanks, and index page. A consumer can depend on a
package without selecting its knot.

A knot is an immutable indexed publication set for one exact selected package
graph from one workspace source revision. It has a distinct name, version,
owners, repository/revision, KST and manifest digest, license/provenance
summary, docs overview, support matrix, and release status. A knot version
records every included package name/version, content and interface digest,
source path, dependency edge, selected feature, target support, exclusion, and
publication result. Knot and package versions are independent.

Knot publication is one atomic index transaction containing the selected
package releases and knot record. An existing package version is reusable only
when its complete immutable identity and content match. A same-name/version
mismatch fails. Any selected package failure in build/check/tests, docs,
target/admission, SemVer, license/provenance, advisory policy, or publication
aborts the transaction and exposes no newly published record.

The main discovery surface is knot-first. A separate complete packages section
remains available. A knot page shows exact packages and dependency tree; a
package page shows versions, dependencies, docs, advisories, yanks, provenance,
and containing-knot facts. Knot priority is presentation, not trust. Each
package keeps package-root `kdocs/`; the knot overview links those docs and
projects package versions, dependency tree, targets, compatibility, exclusions,
and provenance.

Package advisories and yanks apply wherever a package release appears. Knot
advisories and yanks describe set-level faults and never suppress package
records. A package can appear in knot releases, be published independently, or
belong to no knot.

> Trace: D624a
> Covers: Knots are atomic aggregate releases over separately addressable package releases, with knot-first discovery and complete package-level records.

## Vulnerability Intake And Incident Records

The repository publishes `SECURITY.md` with supported artifact/version classes,
in-scope surfaces, private reporting channels, maintained encryption options,
best-effort acknowledgement/update targets, safe-harbor intent, and a ban on
public issues for undisclosed vulnerabilities. Private cases use the states
`received`, `acknowledged`, `triaged`, `reproduced`, `impact-assessed`,
`remediation-active`, `coordinated-release`, `disclosed`,
`rejected-with-reason`, `duplicate`, and `closed`.

Private records separate reporter/exploit data from public advisories and state
access, retention, backup, redaction, and conflict policy. Severity records
reachability, authority, affected artifacts/targets, exploit evidence, and
mitigation independently of any CVSS score. Disclosure records coordinator,
affected parties, cadence, credit preference, deadline/escalation, downstream
notification, and early-disclosure conditions.

Playbooks cover compromised signing/provenance keys, malicious packages or
index metadata, poisoned caches/mirrors, vulnerable compiler/runtime/stdlib or
Bridge releases, sandbox escape, secret leakage, and service compromise.
Revocation binds exact artifacts and versions, reason, mitigation/replacement,
index/yank/advisory action, cache invalidation, signature/checksum state, and
verification commands.

Bootstrap intake uses GitHub private vulnerability reporting and repository
security advisories. No custom database, public web form, paid SLA, or always-on
service is implied. During single-maintainer bootstrap the status is
`LIMITED_SINGLE_OWNER` with the actual owner and survivability limits named.
Provider failure or compromise is recorded as an intake failure with an
explicit recovery/export procedure.

> Trace: D274, D431, D583
> Covers: Vulnerability handling has a private case state machine, public advisory boundary, revocation evidence, and honest single-owner service status.

## Experimental Release And Artifact Identity

An XP can enter a stable distribution only after a specification revision
defines the boundary and the official project accepts the corresponding release
change. The implementation must be production-quality, isolated, tested, and
disabled by default. Source, `.koi`, generated C, caches, binaries,
diagnostics, lockfiles, package/knot records, and provenance carry every enabled
XP ID. Stable and experimental identities never collide.

Packages and knots using an XP publish only with an explicit experimental marker
and exact XP/distribution requirements. Adding a stable-carried XP requires a
minor or major distribution release. A patch can repair security or correctness
without changing intended experimental semantics. XP behavior is outside
ordinary stable SemVer, but support range, migration, expiry, security support,
renewal, and removal remain explicit. Graduation removes XP identities only
after stable semantic acceptance, normative extraction, migration,
diagnostics, and conformance.

> Trace: D582, D625
> Covers: Stable-carried experiments remain opt-in, identity-separated, release-bounded, and unable to masquerade as stable dependencies or conformance.

## Bundled Distribution Release Records

Each official release record identifies the complete bundled Kyokai
distribution and every compatibility-critical component inside it. The record
includes the Bleedring installation identity and exact CI invocation. A release
cannot advertise a supported distribution assembled from components belonging
to different release identities.

> Trace: D615
> Covers: Release and CI metadata identify the same atomic distribution installed by Bleedring.
