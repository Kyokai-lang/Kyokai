# Reproducibility And Incremental Builds

[Rikona Kurasaki / Mjoyufull]
> ProofTrace: SPEC-TOOLCHAIN-09-REPRODUCIBILITY-INCREMENTAL-BUILDS
> Covers: This chapter is registered in the public ProofTrace evidence graph; registration does not claim implementation, conformance, or theorem completion.

Reproducible builds fix the observable result for one declared build identity. Incremental compilation may reuse prior work only when that reuse preserves the same result. Kyokai requires both release reproducibility and bounded daily rebuild work.

> Trace: D83, D144
> Covers: Reproducible outputs and incremental compilation are both normative toolchain concerns.

## Reproducible Build Identity

Given the same build identity, a conforming toolchain must produce the same `.koi` artifacts, generated C where requested, object files when the admitted C-toolchain contract guarantees bit-identical objects, libraries, executables, documentation JSON, lockfile updates, and release provenance records. If a target external tool cannot make an output bit-identical, the target contract must state the exception and the reproducible artifact boundary that remains guaranteed.

> Trace: D27, D79, D83, D139, D149, D218, D225
> Covers: Reproducibility applies to specified artifacts, with target exceptions bounded by target contracts.

Build identity includes:

| Input | Included Facts | Trace |
| --- | --- | --- |
| Source | File bytes, logical module names, source origins, generated-source declarations, and doc-test extraction inputs. | D52, D78, D218 |
| Project | Package/workspace manifests, lockfile, package identities, versions, editions, module roots, build tables, profiles, manifest authority ceilings, resolver mode, and diagnostic policy. | D51, D78, D83, D105, D527-D528 |
| Dependencies | Workspace dependencies, pinned Git revisions, indexed version requirements, selected index snapshot identities, canonical source-artifact hashes, package-instance feature sets, dependency `.koi` identities, compatibility fields, yanked/advisory policy when fatal, capability-deny policy when graph-affecting, and package provenance. | D51, D79, D244, D397, D423-D424, D461, D528 |
| Target | Triple, support tier, target-spec bytes, admitted C-toolchain contract identity, external tool versions, sysroot, linker, admitted flags, CPU/features, stack defaults, task-stack defaults, guard policy, and overflow detection. | D31, D80, D149, D262, D308, D343, D530-D532 |
| Compiler | Kyokai toolchain identity, version ABI string, compiler version, stdlib/runtime/resolver versions, `.koi`/KBI version, language edition, generated-C schema and C-toolchain compatibility classes, cache-format version, package-index schema version, target-metadata version, and diagnostic schema version. | D79, D83, D105, D425, D429, D530-D532 |
| Command | Flags and policy values that affect accepted source, generated artifacts, diagnostics as artifacts, profile, target, admitted C-toolchain selection, output mode, output root, cache root, effective capability deny policy, debug/source-map policy, sanitizer policy, frame-pointer policy, LTO, and instrumentation. | D26, D27, D29, D31, D264, D308, D527, D530-D536 |
| Output paths | Output/cache roots only where artifact contents record paths; path remapping controls reproducible profiles. | D27, D83, D264 |

> Trace: D26, D29, D31, D51, D52, D78-D80, D83, D105, D149, D218, D244, D264, D397, D423-D425, D429, D461, D527-D528
> Covers: Build identity records package instances, indexed version requirements, canonical source content, authority-deny policy, resolver inputs, toolchain compatibility, cache schema, and provenance inputs explicitly.

Hidden host facts are excluded unless a chapter admits them. Excluded facts include current time, timezone, locale, process ID, random seed, current username, unrelated environment variables, shell aliases, host directory iteration order, and absolute build path after path-remapping policy.

> Trace: D83
> Covers: Ambient host state does not perturb reproducible builds.

## Paths And Debug Info

Source paths embedded in debug info, diagnostics-as-artifacts, docs JSON, generated C `#line` directives, source maps, and provenance records must use normalized logical paths unless the selected profile explicitly requests absolute paths. Path remapping happens before artifact hashing.

> Trace: D27, D83
> Covers: Path handling is deterministic and profile-controlled.

If absolute paths are requested, the artifact is still deterministic only for builds performed under the same remapped path identity. Release profiles use remapped paths by default.

> Trace: D27, D83, D225
> Covers: Absolute debug paths are explicit and not the release default.

## Output And Cache Path Identity

The output tree path is not a source semantic input. It becomes a build-identity input only when artifact contents record paths, such as debug information, generated C line directives, source maps, docs JSON, provenance, or diagnostics-as-artifacts. In reproducible profiles, path remapping must make artifacts independent of the absolute checkout location unless the user explicitly opts into absolute path embedding.

> Trace: D27, D83, D264
> Covers: Output/cache paths affect reproducibility only through path-recording artifacts, and reproducible profiles remap paths by default.

The default output root `kyokai-out/` holds user-visible artifacts. The default project build cache root `.kyokai-cache/` holds disposable project-owned compiler state. Package-source caches, local docs caches, installed-toolchain caches, and global caches are separate roots. A cache entry must not be the only copy of a requested build product, and an output artifact must not be required as hidden compiler state unless it is also validated by ordinary artifact identity.

> Trace: D83, D144, D264, D397, D425, D429, D516
> Covers: User-visible artifacts, project build cache, package-source cache, docs cache, installed-toolchain cache, and global cache state remain separate roots.

## Package Cache

The package-source cache stores canonical package source artifacts. For Git dependencies it records repository identity, immutable revision, canonical uncompressed source-content hash, transport provenance, artifact-format version, and hash-algorithm version. For index and mirror retrieval it records the same canonical source-content identity instead of trusting provider-specific archive bytes. A cache hit verifies canonical path ordering, file-mode policy, symlink policy, metadata stripping, manifest hash, content hash, and source provenance before use. A branch name, tag name alone, mutable checkout, provider archive checksum alone, or unverified local directory cannot satisfy a dependency.

> Trace: D51, D83, D244, D423
> Covers: Dependency cache reuse is pinned to canonical source content and verified provenance rather than transport bytes or mutable labels.

An indexed package cache hit is valid only when the selected lockfile package instance, exact source revision, canonical source hash, index snapshot identity, package version, selected feature set, target contract, semantic profile, and relevant policy identities match. A newer package-index version or metadata correction cannot replace a locked cache entry unless the command selects a graph-changing resolver mode.

> Trace: D83, D221, D244, D423-D424, D528
> Covers: Indexed package cache reuse follows the resolved lockfile package instance and cannot drift with package-index changes.

A corrupted package-source cache entry is rejected. A command with an admitted remote source action can repair it by refetching the declared immutable source and revalidating canonical identity. An offline command fails with a package-source diagnostic instead. Repairing a cache entry does not edit manifests or lockfiles unless the command explicitly selects a lockfile update mode.

> Trace: D51, D83, D396, D423-D424, D429
> Covers: Package-source repair preserves dependency meaning, obeys offline policy, and cannot mutate lockfile graphs by accident.

## Incremental Compilation

Kyokai uses a hybrid incremental model: package-level artifacts are the public dependency boundary, module-level work may be reused inside a package, and query/fingerprint invalidation may be used inside the compiler. Incremental compilation is an optimization and must not change accepted programs, rejected programs, diagnostic meaning, artifact compatibility, or runtime behavior.

> Trace: D78, D79, D83, D144
> Covers: Incremental compilation is allowed under a package/module/query model but cannot change semantics.

Incremental cache keys include every build identity input that could affect the cached result. If the compiler cannot prove a cached result is valid, it must recompute. A stale cache hit that changes a result is a toolchain bug, not an accepted nondeterminism.

> Trace: D83, D144
> Covers: Incremental cache correctness is required.

A build-result cache entry records cache-format version, toolchain identity, version ABI string, source and generated-input hashes, manifest and lockfile hashes, canonical package-source hashes, package-instance feature set, target contract, profile, selected C compiler/linker contract, code-generation schema, policy values, effective capability deny policy when it affects acceptance or artifacts, admitted environment inputs, external tool identities, `.koi`/KBI version, package-index schema version, output-integrity hash, and the compatibility class needed to validate reuse.

Cache state is partitioned under `<cache-root>/<toolchain-compat>/<target-triple>/<profile>/<c-toolchain-contract>/<package-instance>/` when those components apply. The tool may share cache state between package instances only after proving identical public `.koi`, identical semantic facts, compatible deny-policy effect, compatible generated-code inputs, and compatible C-toolchain contracts. Sharing never changes diagnostics, audit output, build identity, or package-graph reporting.

> Trace: D29, D79, D83, D144, D218, D264, D397, D425, D429, D480, D497, D527
> Covers: Build-result cache reuse is keyed by complete package-instance, policy, and toolchain facts and is a semantics-preserving optimization only.

Cache writes publish atomically after content verification. Concurrent builds use explicit cache locks or content-addressed temporary paths. Lock acquisition, stale-lock detection, unsupported locking, and timeout produce stable diagnostics. Eviction never deletes an entry held by an active build under that protocol. A partial write, unknown cache format, missing metadata record, integrity mismatch, or stale generated-source record is discarded and rebuilt from declared inputs when those inputs are available.

Remote build-result cache use is disabled by default. Enabling it requires explicit configuration for endpoint identity, trust policy, integrity verification, provenance validation, selected target/toolchain/profile compatibility, and build-metadata recording. A remote entry cannot introduce a package, source, authority, graph edge, or toolchain fact absent from the declared build. `kyokai build --no-cache` and `KYOKAI_CACHE=off` disable build-result cache reads and writes without changing requested artifacts except for timing and cache reports.

Deleting cache state does not change command results except for timing, progress output, and cache reports. `kyokai clean` removes project build cache state. `kyokai clean --outputs` removes project outputs. `kyokai clean --all` removes both project-owned roots. `kyokai clean docs` removes project-generated docs and docs-cache entries. `kyokai clean --global` selects global caches separately and prints each global root before removal.

> Trace: D83, D144, D264, D397, D425, D429, D480, D516
> Covers: Cache publication, locking, corruption handling, remote trust, cache-off operation, and scoped removal are explicit and cannot change semantics.

## Generated Sources

Generated sources participate in reproducibility through generator declaration, command identity, declared inputs, declared outputs, admitted environment-key names, sandbox grants, target/profile/edition inputs, toolchain identity, source digests, output digests, and checked-in or build-only classification. Undeclared generated files under a module root are rejected unless the generation chapter admits their source origin. `kyokai generate --check` regenerates under the declared sandbox and fails on drift without silently rewriting source.

> Trace: D78, D83, D150, D406, D465
> Covers: Generated source provenance records the generator and its bounded authority; drift checking is explicit and non-mutating.

## Release Provenance

Release provenance records include build identity, source revision, Kyokai toolchain version, target, profile, admitted C-toolchain contract and executable identities, lockfile hash, generated-source hashes, `.koi` hashes, artifact checksums, and signing/checksum metadata when produced. Provenance itself is an artifact and must be reproducible except for explicit signature bytes and timestamp authority fields named by the release chapter.

> Trace: D83, D225
> Covers: Release provenance names its deterministic and authority-backed fields.

## Reuse Cannot Change Meaning

[Rikona Kurasaki / Mjoyufull]
Wall-clock time and undeclared host state are not build inputs. Incremental reuse is permitted only when the cache key covers every input that can affect the reused result and validation confirms the artifact's identity. A cache miss may cost time; a false hit would change program meaning.

> Trace: D83, D144
> Covers: Kyokai treats reproducibility as trust and incremental compilation as a checked optimization.

## Canonical Source-Tree Identity (`KST-1`)

`KST-1` identifies a publishable package-source snapshot independently of
archive format, Git history, host paths, locale, enumeration order, uid/gid,
timestamps, extended attributes, and clock state. It is distinct from local
workspace identity, semantic compiler-input identity, and build/artifact
identity.

Selected paths contain non-empty NFC UTF-8 components, use `/` as the canonical
separator, and sort by unsigned UTF-8 bytes. Absolute, empty, dot, dot-dot, NUL,
platform-separator, normalization-duplicate, and portable case-fold-collision
paths are rejected. File contents are exact bytes. KST performs no newline,
Unicode, comment, or formatter normalization. Identity includes one normalized
executable bit; empty directories and other metadata are absent.

Published snapshots reject symlinks, hard-link identity, special files, mount
crossings, gitlinks/submodules, and alternate streams. External content is
vendored as ordinary selected files or separately identified. Selection uses a
closed toolchain exclusion set plus explicit manifest includes; VCS, editor,
archive, and ambient ignore files have no effect. Controlling manifests are
included. Checked-in generated files are ordinary bytes; build outputs remain
separate inputs and outputs.

Capture uses an immutable staging snapshot with containment-safe traversal and
fails on replacement, truncation, or metadata swap. Nodes use a canonical
length-delimited binary grammar containing node type, lengths, executable bit,
ordered child names, and child digests. The root domain includes `KST-1`, the
package namespace/identity where applicable, and algorithm ID. SHA-256 is the
initial algorithm. Algorithm agility requires a new schema/ID.

Implementations stream under path, entry, byte, depth, and work budgets.
Lockfiles, package and knot records, mirrors, caches, docs, provenance,
transparency, vendoring, signatures, and plans record schema, algorithm, root,
counts, and capture policy. KST authenticates captured structure and bytes; it
does not establish publisher identity, review, safety, licensing, absence of
malice, or reproducible outputs.

> Trace: D570
> Covers: Publishable source has one exact cross-host tree identity with hostile traversal, exact-byte, and metadata boundaries.

## Kyokai-Native Toolchain Convergence

Kyokai is the target implementation language for the compiler, package/build
system, formatter, test/fuzz/bench runners, docs, audit, Analysis Server/LSP,
migration, and ordinary toolchain components. OCaml is a pinned transitional
bootstrap and differential implementation, not semantic authority.

Every bootstrap component has both a semantic disposition (`RETAIN`, `ADAPT`,
`REPLACE`, or `DELETE`) and a language-transition disposition (`KEEP`, `WRAP`,
`REIMPLEMENT`, or `REMOVE`). Replacement seams use stable command/data
protocols, shared conformance corpora, and implementation-independent IR
contracts. Source semantics cannot depend on an OCaml convenience.

Native migration starts only after the self-host entry gate proves substantial
multi-package compilation plus stable parsing, elaboration/type checking,
linearity and borrowing, module/`.koi`, generated-C/runtime, deterministic
builds, diagnostics, package/build foundations, Tier-One stdlib, conformance,
and a documented recovery route. A toy self-compile is insufficient.

Stage 0 is the pinned OCaml bootstrap. Stage 1 builds a Kyokai-native slice with
Stage 0. Stage 2 rebuilds it with Stage 1. Stage 3 repeats and checks declared
convergence of generated C, `.koi`, diagnostics, tests, package graphs, and
final artifacts after normalization of specified nondeterminism. Each stage
records source, compiler, admitted C toolchain, target/profile, dependency,
generator, environment, and content identities. Execution success alone is not
convergence.

Cross-bootstrap uses a previous admitted Kyokai toolchain or a reviewed,
content-identified generated-C snapshot. Binary users do not require OCaml.
An OCaml component retires only after its named replacement, owner, parity and
differential suites, convergence evidence, relevant gates, and recovery role
are satisfied. Bootstrap intrinsics are explicit, audited, minimized, and
retired or standardized.

> Trace: D592a
> Covers: Self-hosting begins at an evidence gate, proceeds through reproducible stages, and retains an audited recovery path while OCaml authority is removed component by component.
