# Manifest, Packages, And Workspaces

[Rikona Kurasaki / Mjoyufull]
> ProofTrace: SPEC-TOOLCHAIN-01-MANIFEST-PACKAGE-WORKSPACE
> Covers: This chapter is registered in the public ProofTrace evidence graph; registration does not claim implementation, conformance, or theorem completion.

A Kyokai manifest declares the package or workspace boundary and the module root. The toolchain does not infer those boundaries from an undocumented directory convention.

> Trace: D78, D83, D155
> Covers: Kyokai packages and workspaces are manifest-declared boundaries, not inferred directory folklore, and tool behavior must be specified rather than discovered by accident.

The normative manifest file is `kyokai.toml`. A manifest can contain `[package]`, `[workspace]`, or both. When both are present, the directory is the workspace root and a package root; that root package joins the workspace only when canonical member `"."` appears in `[workspace].members`.

> Trace: D78, D332, D562
> Covers: `kyokai.toml` can declare a package, a workspace, or an explicitly enrolled root package and workspace in one file.

A package is the unit of dependency, visibility, build artifacts, edition selection, and `.koi` interface production. A workspace is an explicit collection of packages built together under one lockfile. A module is the source-level thing imported by Kyokai code. Kyokai deliberately collapses Rust's crate/package split into one package concept so there is one unit for dependency identity and artifact identity.

> Trace: D78, D79, D105
> Covers: Kyokai distinguishes modules, packages, and workspaces, and package identity controls dependencies, visibility, edition selection, and interface artifacts.

## Package Manifests

A package manifest contains a `[package]` table, exactly one package name, exactly one version string, exactly one edition string, and a `[layout]` table with exactly one `module_root` field.

```toml
[package]
name = "net"
version = "0.1.0"
edition = "2026"

[layout]
module_root = "src"
```

> Trace: D78, D105, D243
> Covers: Package manifests declare package identity, version, language edition, and explicit module root.

A package name must match `^[a-z][a-z0-9-]{0,63}$`. It uses only lowercase ASCII letters, ASCII digits, and `-`; it cannot end in `-`; it cannot contain `--`; it cannot contain `_`, `.`, whitespace, uppercase letters, or Unicode code points; and it is compared byte-for-byte without case folding, Unicode normalization, punctuation normalization, or locale rules. Names that collide with Windows reserved device names such as `con`, `prn`, `aux`, `nul`, `com1` through `com9`, and `lpt1` through `lpt9` are illegal.

The public package index also rejects names reserved for the standard library, official tools, examples, security advisories, project infrastructure, and official namespaces. A name confusingly close to an official or reserved name is rejected. Similarity to an ordinary third-party package is advisory metadata for index and audit tools; it does not change package identity and does not prove malicious intent. A non-index Git dependency records its exact repository URL, revision, and manifest package name even when that name would fail public-index policy.

> Trace: D78, D419
> Covers: Kyokai package names have one canonical ASCII grammar, reserved official names are protected, and ordinary third-party similarity remains advisory metadata rather than source semantics.

Package names and module names reserved for `Kyokai.Bridge.*`, the collection root `bridge/`, official bridge metadata, and bridge admission records cannot be claimed by ordinary packages. A package may wrap or depend on the same upstream project as a Bridge entry, but it cannot present itself as official Bridge surface or rely on Bridge admission status unless it is part of the shipped collection.

> Trace: D419, D529
> Covers: Official bridge names are reserved, and ordinary packages do not inherit bridge trust or support status.

The `edition` field selects the source-semantics mode for every `.kyo` source file in the package. For the first edition, the value is `"2026"`. A workspace can contain packages with different declared editions, but `.koi` compatibility is exact by edition. Cross-edition use requires a separate migration witness that records every semantic mapping; the witness is an audit artifact, not a normal `.koi` replacement, and cannot silently change ownership, capabilities, unsafe contracts, layout, failure behavior, or ABI.

> Trace: D79, D105, D243
> Covers: Language editions are manifest-selected source-semantics modes, mixed-edition workspaces are structurally legal, and `.koi` consumption requires exact edition compatibility under the current design.

The `[layout].module_root` value is a non-empty relative path interpreted from the package root. It must not be absolute. It must not escape the package root through `..` or symlink-equivalent resolution. There is no implicit default module root.

> Trace: D78
> Covers: Every package declares a module root explicitly, and the root must remain inside the package.

A package published to the official package index contains a tracked `kdocs/` directory directly under its package root in the exact indexed Git revision. `kdocs/` is generated documentation, not module source. It is not discovered under `[layout].module_root`, does not create modules, and does not affect source name resolution. A standalone package therefore uses `project-root/kdocs/`. A workspace repository containing several published packages uses one `kdocs/` directory under each published member package root.

> Trace: D515-D516, D525
> Covers: Published documentation has one fixed package-root location without changing module discovery or confusing repository roots with package roots.

The official Bridge collection is not declared in `[dependencies]`. It is installed first-party toolchain/library surface under `Kyokai.Bridge.*` and the collection root `bridge/`. A package that imports a Bridge module records that imported interface through the ordinary module graph and `.koi` compatibility records, but the package resolver does not select, fetch, update, vendor, or lock Bridge modules as package dependencies.

> Trace: D51, D78-D79, D529
> Covers: Bridge modules are installed first-party modules, not package dependencies or resolver-selected graph nodes.

## Documentation Storage Selection

The workspace-root manifest may select the inherited documentation storage
mode:

```toml
[documentation]
mode = "structured" # "rendered" or "source-only"
```

`structured` is the default when the table is absent. An explicitly selected
package may override the workspace value under the ordinary manifest
inheritance rules. Any other value is a manifest error. The recorded
command-line override has higher precedence for that invocation, but does not
rewrite the manifest. Storage, transition, sanitization, and service behavior
for the three modes are defined by the documentation chapter.

> Trace: D602
> Covers: Documentation mode is selectable in the root manifest, inherited by member packages, and overrideable only through the ordinary recorded precedence rules.

## Workspace Manifests

A workspace manifest contains a `[workspace]` table and an explicit `members` array. It may also contain the root package's `[package]`, `[layout]`, dependencies, targets, and package-owned tables. Those package tables describe the root package only; the workspace table does not acquire package identity.

```toml
[workspace]
members = [
    ".",
    "packages/core",
    "packages/net",
    "packages/cli",
]
```

> Trace: D78, D332, D562
> Covers: Workspaces exist only by explicit manifest declaration, list member packages directly, and enroll a root package only through explicit member `"."`.

Each workspace member is either canonical `"."` or a non-empty relative path from the workspace root to a package root containing its own `kyokai.toml`. Other members must not be absolute, must not escape the workspace root through `..` or symlink-equivalent resolution, and must not canonicalize to the root. Canonical member identities are unique; duplicate spellings or paths resolving to the same member are errors.

> Trace: D78, D332, D562
> Covers: Workspace members are unique canonical package roots contained by the workspace, including the explicitly written root member `"."`.

Package names must be unique within a workspace. If two workspace members declare the same `[package].name`, the workspace is ill-formed. A dependency written with `{ workspace = "name" }` resolves by package name, not by filesystem path.

> Trace: D51, D78
> Covers: Workspace package identity is name-based, package names are unique in a workspace, and workspace dependencies refer to package identity rather than paths.

A directory tree containing several packages is not a workspace unless a `kyokai.toml` explicitly declares `[workspace]`. Tools must not infer a workspace from folder layout, nested manifests, a repository root, or a shared parent directory.

> Trace: D78
> Covers: Kyokai rejects inferred workspaces; workspace structure is a written contract.

## Manifest Discovery

When a tool command runs from a directory and no manifest path is passed explicitly, the tool searches that directory and its ancestors for the nearest `kyokai.toml`. If the nearest manifest is a package manifest, the command runs in standalone-package scope. If the nearest manifest is a workspace manifest, the command runs in workspace scope.

> Trace: D78, D26
> Covers: Tool commands use nearest-manifest discovery and distinguish package scope from workspace scope by manifest contents.

If a package is a member of a workspace, commands run from inside that package may still need workspace context for dependency resolution and lockfile ownership. The tool must identify the enclosing workspace by the explicit workspace membership relation, not by guessing that any ancestor with a manifest owns the package.

> Trace: D78
> Covers: Workspace context comes from explicit membership, not accidental ancestor layout.

A package manifest nested under another package's module root is illegal unless it is also an explicitly listed workspace member and the outer package's module discovery excludes that directory. A package cannot silently contain another package's source as ordinary modules.

> Trace: D78, D155
> Covers: Nested package boundaries must be explicit and cannot be swallowed by module discovery.

## Dependencies

A package's `[dependencies]` table admits exactly three dependency source kinds: a package in the same workspace, an external Git repository pinned by commit, or an indexed package requirement resolved through configured package-index metadata.

```toml
[dependencies]
core = { workspace = "core" }
pcre = { git = "https://github.com/kyokai/pcre", rev = "a1b2c3d4..." }
pcre-release = { git = "https://github.com/kyokai/pcre", tag = "v1.2.3", rev = "a1b2c3d4..." }
json = { index = "@kyokai/json", version = "^1.4" }
```

> Trace: D51, D78, D528
> Covers: Dependencies are workspace package references, pinned Git dependencies, or indexed package version requirements.

A dependency entry must contain exactly one of `workspace`, `git`, or `index`. If `git` appears, `rev` is mandatory. `tag` is permitted metadata, and if present the package manager must verify that the tag resolves to the declared `rev` when adding or updating the dependency. `branch` is illegal in `kyokai.toml`. If `index` appears, `version` is mandatory and names a version requirement, not an exact source revision.

> Trace: D51, D528
> Covers: Git dependencies are pinned by commit, tags are checked labels, moving branch references are rejected, and indexed dependencies separate version intent from locked source identity.

The dependency key is the local package dependency name used by the manifest and lockfile. For workspace dependencies, the `workspace` value names the package identity declared by the target package. For Git dependencies, the fetched package's manifest still defines the package identity used in artifacts and diagnostics. For indexed dependencies, the `index` value names the package-index identity, and the resolved source revision's manifest must declare the package identity recorded by that index record.

> Trace: D51, D78, D79, D528
> Covers: Dependency manifests separate local dependency entries, package-index identity, package manifest identity, and artifact identity.

Version requirements for indexed dependencies use the closed first-edition requirement grammar below. Whitespace around operators is ignored. Build metadata in a version is ignored for ordering and requirement matching. A prerelease version is matched only when the requirement explicitly contains a prerelease for the same release line or the selected package-index policy names a prerelease lane.

| Form | Meaning |
| --- | --- |
| `1.2`, `1.2.3`, `^1.2`, or `^1.2.3` | At least the named release line, with omitted patch interpreted as `.0`, and below the next SemVer-incompatible release. |
| `~1.2.3` | At least `1.2.3` and below `1.3.0`. |
| `=1.2.3` | Exactly `1.2.3`. |
| `>=1.2.0`, `>1.2.0`, `<=2.0.0`, `<2.0.0` | One comparison bound. |
| `>=1.2.0, <2.0.0` | Conjunction of comma-separated comparison bounds. |

Bare wildcard requirements such as `*`, moving branch requirements, tag-only requirements, and requirements whose upper or lower bound cannot be represented by the closed grammar are illegal in stable `kyokai.toml`. A package-index policy may reject broad requirements for publication quality, but that policy is package-index admission, not source parsing.

> Trace: D223, D528
> Covers: Indexed package requirements have a closed version-requirement grammar and reject moving or unbounded dependency intent.

Package dependency graphs are acyclic at package identity level. A package cannot depend on itself directly or indirectly through normal dependencies, dev dependencies, generated packages, tool packages, target-specific dependencies, or re-exported package surfaces. The resolver rejects a cycle before build planning and prints the complete package cycle path. Cycle-breaking artifacts are not admitted.

> Trace: D78, D79, D155, D528
> Covers: Package dependency graphs must be acyclic under the current separate-compilation model and cycles remain resolver diagnostics.

## Resolver Model

The Kyokai resolver is a deterministic incompatibility-learning package solver in the PubGrub family, or a SAT-equivalent implementation that preserves the same public solution and conflict-explanation contract. The internal solver library is not normative. The normative contract is the accepted input set, resolved graph, lockfile schema, and diagnostics.

Resolver input includes package and workspace manifests, selected roots, selected target, selected profile, selected feature roots, index snapshot identities, existing lockfile when one is present, lockfile mode, offline/network policy, yanks, advisories, security holds when policy selects them, manifest authority ceilings, effective capability deny policy, package-index policy, and explicit command flags that affect acceptance or graph identity.

Resolver output is exactly one of these results:

- a resolved graph;
- an unsupported-input diagnostic for a source kind, policy, target, feature lane, or index lane not implemented by the current toolchain slice;
- a conflict diagnostic containing the smallest incompatibility chain the solver can justify from the selected inputs.

An implementation slice may initially support only workspace packages or pinned Git packages. Such a slice is valid only when it uses the final resolver data model, final lockfile schema, final mode semantics, and final diagnostic classes. It must reject unsupported indexed/version cases explicitly. It must not write a smaller incompatible lockfile, reinterpret indexed requirements as Git pins, ignore selected policy inputs, or treat current implementation limits as future semantic freedom.

The resolved graph uses package instances, not only package names. A package instance is identified by package identity, package version, edition, source kind, exact source revision or workspace path, canonical source hash when external, selected feature set, target contract, semantic profile inputs, and relevant policy identities. Two instances of the same package revision with different feature sets, target contracts, or semantic profile inputs are distinct graph nodes and produce distinct `.koi` identities.

Each dependency edge records the depender instance, local dependency name, resolved dependee instance, dependency class, requested features, target condition, capability requirement summary, and the manifest requirement or exact pin that introduced the edge. `kyokai tree`, `kyokai why`, `kyokai outdated`, `kyokai audit`, docs pulls, `.koi` compatibility checks, package graph reports, and conformance fixtures all consume this same resolved graph model.

Conflict diagnostics name the participating package identities, version requirements, exact revision pins, feature constraints, target constraints, yanks, advisories, capability-deny policies, and dependency paths. A diagnostic may summarize the chain for human output, but machine output retains stable package instance IDs and edge IDs.

> Trace: D51, D78-D79, D83, D223-D224, D244, D397, D424, D527-D528
> Covers: Dependency resolution has one final PubGrub/SAT-shaped graph model, deterministic inputs, explicit partial-implementation diagnostics, package-instance identity, and conflict explanations.

## Lockfiles

A standalone package owns `package-root/kyokai.lock`. A workspace owns exactly one `workspace-root/kyokai.lock` covering all member packages. Member packages inside a workspace do not own separate lockfiles for that workspace build.

> Trace: D51, D78, D83
> Covers: Lockfile ownership follows package or workspace scope, with one lockfile for a workspace and one for a standalone package.

The lockfile records the fully resolved dependency graph, including exact Git revisions, checked tag metadata where present, indexed package version requirements that selected each indexed source, canonical package-source hashes, package identities, versions, editions, selected feature sets, target-contract inputs, semantic profile inputs, `.koi` identities, resolver and feature-resolution versions, package artifact hashes, source provenance, and index metadata version. A manifest never relies on a moving external reference after resolution.

> Trace: D51, D79, D83, D397, D423-D424, D528
> Covers: Lockfiles make dependency resolution reproducible and record exact source, package-instance, target, resolver, version-requirement, and provenance inputs.

`kyokai.lock` is a deterministic TOML artifact with these top-level record families:

```toml
[lock]
version = 1
resolver = "kyokai-resolver-1"
feature_resolver = "kyokai-feature-resolver-1"
owner = { kind = "workspace", path = "." }
index_snapshots = ["official:2026-06-04:sha256:..."]
policy_identity = "sha256:..."

[[root]]
package = "app"
instance = "workspace:app@0.1.0#2026"

[[package]]
instance = "workspace:app@0.1.0#2026"
name = "app"
version = "0.1.0"
edition = "2026"
source = { kind = "workspace", path = "packages/app" }
features = []
target_contract = "host-default"
semantic_profile = "dev"

[[package]]
instance = "index:@kyokai/json@1.4.3#2026:9e4..."
name = "json"
version = "1.4.3"
edition = "2026"
source = { kind = "index-git", index = "official", package = "@kyokai/json", rev = "9e4...", canonical_hash = "kyokai-sha256:..." }
features = []
target_contract = "host-default"
semantic_profile = "dev"
requirement = "^1.4"

[[edge]]
from = "workspace:app@0.1.0#2026"
name = "json"
to = "index:@kyokai/json@1.4.3#2026:9e4..."
class = "normal"
features = []
target = "all"
requirement = "^1.4"
capabilities = []
```

The `[lock]` table records schema version, resolver version, feature-resolution version, owner kind, owner path, index snapshot identities, selected policy identities, and the lockfile mode that produced the graph when that mode writes a graph.

Each `[[root]]` record names a selected root package and resolved package instance. Each `[[package]]` record names one package instance with package name, version, edition, source kind, workspace path or exact external source revision, canonical source hash when external, selected features, target contract, semantic profile, `.koi` digest where produced, docs metadata digest where relevant, yanked/advisory observation where policy records it, and source provenance. Each `[[edge]]` record names one dependency edge with depender instance, local dependency name, resolved dependee instance, dependency class, requested features, target condition, capability requirement summary, and the requirement or exact pin that introduced the edge.

`instance` strings are stable lockfile-local identifiers. They are not source syntax and are not parsed by Kyokai programs. Tools may expose them in machine output and may present friendlier human names.

> Trace: D51, D79, D83, D223-D224, D397, D423-D424, D528
> Covers: Lockfiles have explicit deterministic record families for roots, package instances, and dependency edges instead of opaque dependency strings.

Existing lockfiles continue to resolve yanked package revisions unless a separate security policy explicitly blocks the build. Yanking affects new dependency resolution, not the meaning of an existing lockfile.

> Trace: D244
> Covers: Package yanks are append-only metadata that prevent new selection without breaking existing lockfile reproducibility.

## Tool Obligations

A conforming tool must validate the manifest shape before discovering modules. If the manifest is invalid, the tool reports manifest diagnostics and does not partially interpret source files under a guessed project shape.

> Trace: D26, D78, D155
> Covers: Manifest validation precedes module discovery, and invalid manifests do not fall back to guessed layout.

The formatter, documentation generator, LSP, test runner, package manager, audit tooling, and build command all consume the same manifest/package/workspace model. They may expose different commands, but they must not invent alternate package roots, alternate module roots, alternate dependency resolution, or alternate visibility boundaries.

> Trace: D25, D26, D28, D29, D78, D83, D155
> Covers: All Kyokai tools share the same package/workspace/module-root contract.

## One Declared Resolution Model

[Rikona Kurasaki / Mjoyufull]
C include paths permit ambient search order; Python relies heavily on filesystem and naming conventions; Rust distinguishes package and crate identities. Kyokai instead uses one package identity, one declared module root, one workspace membership list, one lockfile owner, and one mapping from `Foo.Bar` to a source path. The smaller identity model removes search-order and package/crate ambiguity from module resolution.

> Trace: D78
> Covers: Kyokai chooses explicit package/workspace/module-root declarations to avoid ambient include paths, naming conventions, inferred workspaces, and extra package/crate identity layers.

## Features And Package Instances

A dependency package instance is identified by package identity, exact source revision or canonical content hash, edition, target contract, semantic profile inputs, and exact feature set. Feature selection is not globally unified across the graph. Two dependents can instantiate the same package revision with different feature sets, and those instances produce distinct `.koi` identities and distinct graph entries.

Features are manifest-declared additive selections. A feature cannot silently remove an API, weaken a contract, bypass a capability requirement, alter ownership, or change failure categories under the same package version. A feature that enables public APIs, capability-requiring APIs, generated code, unsafe contracts, or target-specific behavior appears in `.koi`, lockfile metadata, graph inspection, SemVer reports, docs, and audit output. Mutually exclusive combinations are rejected with a conflict diagnostic naming the enabling dependency paths.

Cache reuse between feature instances is an optimization only. It exists after the tool proves identical public `.koi`, identical backend-independent semantic facts, and compatible generated-code inputs. Reuse cannot change diagnostics, audit output, build identity, or dependency graph reporting.

> Trace: D397, D480
> Covers: Package-instance identity includes exact features and target semantics; cache deduplication cannot erase visible package distinctions.

## Lockfile Modes And Offline Resolution

Resolver output is deterministic over manifests, selected target, selected feature roots, index snapshot identity, lockfile mode, and policy values. `kyokai build`, `check`, `test`, `doc`, and `run` do not mutate `kyokai.lock` unless the command explicitly selects an update mode.

| Mode | Contract |
| --- | --- |
| `frozen` | Reject a missing, stale, conflicted, format-drifted, or write-requiring lockfile. CI uses this mode by default when a lockfile exists. |
| `locked` | Consume the existing graph and reject dependency resolution that requires graph changes. |
| `update-selected` | Update named packages and the minimal required transitive set. |
| `update-all` | Resolve the whole graph under current manifests and selected policies. |
| `offline` | Perform no network access and use only workspace packages, vendored sources, verified local caches, and already-present index metadata. |
| `repair` | Rewrite validated ordering or format without changing graph meaning. |
| `explain-conflict` | Report solver conflicts without writing a graph. |

Lockfile formatting is deterministic and ordered by canonical package identity plus dependency edges. A merge conflict is not authoritative input. Repair or regeneration validates graph identity, source hashes, resolver version, feature-resolution version, package artifact hashes, source provenance, and index metadata version. Resolver diagnostics print package constraints, revision constraints, feature constraints, target constraints, yanks, advisories, and a minimal conflicting chain.

> Trace: D396, D424
> Covers: Compiling never rewrites lockfiles by accident; lockfile mutation, offline behavior, repair, and conflict explanation are named modes.

## Runnable Targets And Authority Ceilings

A package declares build, test, scratch, playground, and linked-runtime authority ceilings. Resolution and link planning reject a graph whose declared requirements exceed the selected ceiling. A ceiling restricts packages, targets, generated source, tests, docs examples, and generators; it does not mint runtime capabilities.

The capability deny policy from the toolchain chapter composes with manifest ceilings. A manifest `capability_ceiling` states the authority that a package, target, or audit surface is allowed to require. A user/global config or command-line `--deny-capability <name>` can make the effective policy stricter for one machine or one invocation. No manifest field can remove denial inherited from toolchain defaults, user/global config, or command-line flags.

Packages declare runnable targets explicitly. Each executable target names package entry module, entry declaration, required target class, profile restrictions, capability/startup shape, and produced artifact name. A package with several runnable targets requires `kyokai run --bin <name>` unless exactly one runnable target exists.

Runnable targets live in named `[targets.<name>]` tables. The table name is the target selector used by `--bin <name>`. The first standardized target kind is `"executable"`.

```toml
[targets.app]
kind = "executable"
module = "App.Main"
entry = "main"
output = "app"
default = true
capability_ceiling = ["Filesystem.Read"]
```

For an executable target, `module` is the dotted Kyokai module path containing the entry declaration, `entry` is the function or admitted entry declaration name inside that module, `output` is the produced executable artifact stem, and `default = true` marks the package's default run target. A package has at most one default executable target. If `output` is omitted, the target name is the output stem. A target table with `kind = "executable"` must not rely on `output_type = "executable"` alone; the target table is the source of executable entrypoint identity.

> Trace: D437, D462, D527
> Covers: Packages expose explicit runnable targets and authority ceilings without granting runtime authority through manifests, and the effective capability deny policy can only make those ceilings stricter.

## Knot Publication Declaration

A workspace can declare at most one knot:

```toml
[knot]
name = "kyokai-tools"
version = "0.4.0"
exclude_packages = ["internal-fixtures"]
```

The knot name and version are publication identity. They do not replace member
package names or versions. The default knot selection is every workspace member
whose package manifest permits publication. A package can prohibit publication
with `publish = false` in `[package]`. `exclude_packages` is a list of workspace
package names removed from this knot selection. The list is canonicalized,
duplicate-free, and records only packages that are workspace members.

Exclusion is subtractive. It cannot add a private package, change a version,
rewrite a dependency, or substitute an indexed package for a workspace edge.
If an included package has a workspace dependency on an excluded package, knot
publication fails and reports the complete dependency path. The manifest must
include the dependency, exclude every dependent package, or explicitly change
the dependent manifest to use an indexed package release.

A package remains an independent dependency, visibility, SemVer, `.koi`, docs,
advisory, yank, and publication unit. `internal` visibility remains
package-scoped across both workspace and knot membership.

Lockfiles can record knot selections and package instances. A knot dependency
records the exact knot version and selected package releases. A direct package
dependency records its package release and, when applicable, the supplying knot
as provenance. One immutable package release has one semantic package identity
even when dependency paths arrive both directly and through a knot.

> Trace: D624a
> Covers: A knot is one manifest-declared aggregate publication over a dependency-closed selected package graph; member package identity remains intact.

## Stable-Carried Experiment Selection

The root workspace manifest is the only publishable/release-capable authority
for selecting a stable-carried experiment:

```toml
[experimental]
enable = ["XP-NNN"]
```

The array contains unique accepted XP IDs. User-global configuration and
dependencies cannot enable an XP for a workspace. A command-line-only opt-in is
legal only for scratch or evaluation commands, is recorded in their output,
and cannot produce a publishable package, knot, or release artifact.

An XP used by a public interface propagates its exact XP and distribution
requirement through `.koi`. A downstream root workspace must enable that exact
XP. A package or knot using an XP carries an experimental publication marker
and cannot satisfy a stable dependency requirement without the consuming root's
matching opt-in.

> Trace: D582, D625
> Covers: Stable distributions can carry accepted experiments disabled by default, with exact root-manifest opt-in and transitive artifact identity.
