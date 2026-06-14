# Command Line Interface

[Rikona Kurasaki / Mjoyufull]
> ProofTrace: SPEC-TOOLCHAIN-03-CLI
> Covers: This chapter is registered in the public ProofTrace evidence graph; registration does not claim implementation, conformance, or theorem completion.

The `kyokai` command is direct, but direct does not mean loose. Every command enters through the same manifest door, resolves the same project graph, and either reports exactly what it did or fails before it invents a shape for the project.

> Trace: D26, D78, D83
> Covers: The CLI is manifest-driven, deterministic, and shared by all project-facing commands.

## Command Discovery And Scope

Unless a command explicitly accepts no project, `kyokai` discovers the nearest `kyokai.toml` from the current directory upward. A package manifest gives standalone-package scope. A workspace manifest gives workspace scope. If a member package is selected from within a workspace, dependency and lockfile behavior still belongs to the workspace that explicitly lists that member.

> Trace: D26, D78
> Covers: CLI project scope follows nearest manifest discovery and explicit workspace membership.

The global flag `--manifest-path <path>` selects a manifest directly. The path must name a `kyokai.toml` file, not just a directory. The tool must reject a path that does not parse as a valid package or workspace manifest before it reads source files.

> Trace: D26, D78, D29
> Covers: Explicit manifest selection is allowed, and invalid manifests fail before source interpretation.

The flags `--workspace` and `--package <name>` select scope inside a workspace. `--workspace` selects all members. `--package <name>` selects exactly one workspace member by package name. Using both flags in one command is an error unless that command explicitly defines a combined meaning; no Phase 12 command does.

> Trace: D26, D78
> Covers: Workspace and package selection is explicit and non-overlapping.

## Common Flags

| Flag | Meaning | Applies To | Trace |
| --- | --- | --- | --- |
| `--manifest-path <file>` | Use the named manifest instead of nearest-manifest discovery. | Project commands | D26, D78 |
| `--workspace` | Select all members of an enclosing workspace. | Project commands | D26, D78 |
| `-p`, `--package <name>` | Select one workspace member by package name. | Project commands | D26, D78 |
| `--profile <name>` | Select a build profile. | check, build, run, test, doc, bench | D26, D31 |
| `--release` | Exact alias for `--profile release`. | check, build, run, test, doc, bench | D26, D31 |
| `--target <triple>` | Select a legal target triple. | check, build, run, test, doc, bench | D19, D80, D149 |
| `--message-format=human|json|json-lines` | Select the human lane, one versioned JSON document, or a stream of versioned JSON records. Scripts consume `json` or `json-lines`; `human` is presentation output. | Reporting commands whose matrix admits output selection | D29, D503 |
| `--color auto|always|never|machine` | Select terminal presentation policy. `machine` forbids ANSI styling, cursor motion, progress animation, pager behavior, and prompts. | All reporting commands | D29, D422, D503 |
| `--verbose` | Print resolved plan facts before execution. | Project commands | D26, D83 |
| `--quiet` | Suppress non-error presentation output. | Project commands | D29 |
| `--offline` | Forbid every network action. A command fails if its required inputs are not already available from workspace packages, vendored sources, or verified local caches. | Commands whose matrix admits local or remote inputs | D396, D424 |
| `--deny-capability <name>` | Add an exact capability or capability-family denial to the effective capability deny policy for this invocation. Repeating the flag adds more denied names. | check, build, run, test, bench, doc, audit, publish, semver-check, generate, eval, repl, scratch/playground lanes, and other project commands that inspect, build, generate, publish, or execute code | D527 |
| `--out-dir <path>` | Select the user-visible output root for this command. | build, run, test, bench, doc, audit, semver-check | D26, D83, D264 |
| `--cache-dir <path>` | Select the disposable toolchain cache root for this command. | Project commands | D83, D144, D264 |

> Trace: D26, D29, D31, D78, D80, D83, D149, D264, D396, D422, D424, D503, D527
> Covers: Common CLI flags have fixed meanings, machine output is versioned, machine color policy is noninteractive, offline mode forbids network contact, and capability denial is an explicit per-invocation authority ceiling.

`--verbose` must print the selected manifest, command scope, selected packages, selected Kyokai toolchain, selected target, selected profile, admitted C-toolchain contract, output root, project cache root, package-source cache root, docs cache root, global cache root when it is relevant to the command, lockfile path, lockfile mode, target-spec files, resolved C compiler/linker/archive tools, admitted discovery providers, explicit extra flags, effective capability deny policy, each deny-policy source that contributed to it, and every declared network action. It must not print secrets from the environment. Presentation output can redact user-home prefixes only when the redaction marker remains visible. Deterministic artifact identity stores the unredacted normalized identity required by the reproducibility chapter.

> Trace: D26, D29, D83, D149, D396, D404-D405, D422, D424-D425, D503, D527
> Covers: Verbose output exposes toolchain, cache, resolver, native-tool, deny-policy, and network facts without leaking secrets.

## Exit Status

| Status | Machine classification | Meaning | Trace |
| ---: | --- | --- | --- |
| `0` | `success` | The command completed successfully. | D26, D503 |
| `1` | `diagnostics-failed` | Checked user input, tests, audit policy, SemVer policy, or another command-owned validation rule failed. | D26, D29, D503 |
| `2` | `tool-usage-error` | The CLI invocation is malformed: unknown flag, missing flag value, incompatible flags, unknown subcommand, or a required explicit scope was omitted. | D26, D503 |
| `3` | `internal-compiler-error` | The compiler, toolchain, or tool-owned artifact violated an internal invariant and the command could not recover by rebuilding validated state. | D26, D84, D429, D503 |
| `4` | `target-or-toolchain-unavailable` | Required target support, selected component, admitted C tool, runner, or target contract is unavailable. | D31, D80, D149, D503, D532 |
| `5` | `dependency-or-index-failure` | Dependency resolution, index access, advisory refresh, source retrieval, provenance verification, or an offline-required local artifact failed. | D51, D396, D424, D503 |
| `6` | `sandbox-failure` | A declared generator, scratch, eval, playground, or hosted-development sandbox could not enforce or satisfy its contract. | D226, D465, D475, D503 |
| `130` | `interrupted` | External interruption stopped the command before normal completion. | D503 |

> Trace: D26, D29, D31, D51, D80, D84, D149, D226, D396, D424, D429, D465, D475, D503
> Covers: CLI exit behavior has stable numeric statuses and machine classifications for scripts and CI.

A command that exits nonzero must emit at least one diagnostic or structured error record explaining the reason, unless the process is killed externally before it can report. Human output is localized only through explicit locale selection. Diagnostic codes, JSON keys, machine fix keys, category names, and conformance goldens use canonical English identifiers. Missing translations fall back to English.

> Trace: D29, D225
> Covers: Failed commands explain themselves and keep machine-readable diagnostics stable.

## Core Commands

| Command | Required Behavior | Trace |
| --- | --- | --- |
| `kyokai --version` | Print the selected toolchain summary without requiring a project. `kyokai version --verbose` prints the full component, source, cache-root, native-tool, and version-ABI record. | D26, D225, D268, D425 |
| `kyokai doctor` | Inspect the host toolchain, supported targets, admitted C compiler/linker contracts, cache/output roots, release provenance, and common setup problems without reading source as language input. | D31, D80, D149, D225, D268, D532, D535 |
| `kyokai init` | Create a package manifest in the current directory, write explicit layout information, and refuse to overwrite an existing package/workspace unless an explicit force flag is passed. | D26, D78, D266 |
| `kyokai new` | Create a new package or workspace directory from an official template, including `kyokai.toml`, module roots, an initial `.kyo` module source file, and template-selected test/doc skeletons. | D26, D78, D266, D537 |
| `kyokai check` | Parse, resolve modules/imports, validate `.koi`, typecheck, check contracts syntactically/semantically, resolve instances, check linearity, borrow rules, capabilities, unsafe contracts, target guards, and the effective capability deny policy. It may skip final code generation and linking. | D26, D29, D79, D527 |
| `kyokai build` | Perform `check`, emit generated C and source maps, invoke the admitted C compile/link plan required by the package output type, reject denied build/generator/runtime-startup authority, and emit requested build products. | D26, D31, D80, D139, D527, D530-D535 |
| `kyokai run` | Build one executable package target, reject denied target or runner authority, and execute it through the selected runner; `--` separates program arguments. | D26, D80, D527 |
| `kyokai test` | Build and run inline tests. It also runs documentation tests when the selected package or command enables the documented `doc-tests` lane. Both lanes use ordinary semantics, explicit capability grants, isolated authority bundles, and the effective capability deny policy. | D28, D137, D218, D527 |
| `kyokai bench` | Build and run benchmark declarations or bench-marked tests under the selected profile and target runner. | D28, D137 |
| `kyokai fmt` | Format source deterministically and idempotently without configuration knobs. | D25 |
| `kyokai doc` | Generate public-interface documentation and JSON from checked interfaces and contracts, including installed first-party Bridge modules when those modules are selected by an explicit docs lane or imported by the checked graph. | D17, D218, D529 |
| `kyokai lsp` | Run the official language server using the same compiler engine. | D148 |
| `kyokai audit` | Report dependency, unsafe, FFI, capability, generation, denied-authority edges, Bridge admission/provenance facts, and public-surface risk facts. | D150, D527, D529 |
| `kyokai explain` | Print detailed documentation for a diagnostic code, warning category, lint category, audit category, or command exit status. | D29, D267 |
| `kyokai fix` | Apply selected `machine-applicable-safe` suggestions by default; apply `machine-applicable` edits only with explicit opt-in after checking that every edit still parses, formats, and preserves the diagnostic's stated repair semantics. | D25, D29, D267, D488 |
| `kyokai repl` | Start a persistent interactive session using ordinary compiler semantics. | D151-D151a |
| `kyokai eval` | Compile and run a one-shot expression, statement block, or file fragment using ordinary compiler semantics. | D151 |
| `kyokai add` | Add a workspace or pinned Git dependency and update the lockfile. | D51 |
| `kyokai remove` | Remove a dependency entry, update the lockfile, and report any packages that still require the removed dependency. | D51, D83, D269 |
| `kyokai update` | Re-resolve selected dependencies within explicit pins/policies and update the lockfile. | D51, D83, D244 |
| `kyokai search` | Query the configured discovery index and print package metadata without changing manifests, lockfiles, or caches except for ordinary index cache state. | D221, D269 |
| `kyokai info` | Print package, version, source revision, license, docs, yanked/advisory, public interface, and audit metadata for a dependency or index result. | D51, D150, D221, D269 |
| `kyokai tree` | Print the resolved dependency graph from the lockfile or selected manifest resolution in deterministic order. | D51, D83, D269 |
| `kyokai why` | Explain why a package appears in the dependency graph by printing one or more dependency paths from selected roots to that package. | D51, D269 |
| `kyokai outdated` | Compare pinned dependencies against explicit update policy and index metadata, reporting available newer revisions, yanks, and advisories without editing files. | D51, D221, D244, D269 |
| `kyokai vendor` | Materialize pinned dependency sources into an explicit vendor directory and rewrite or record resolution metadata so offline builds use the same revisions. It does not copy or rewrite installed `Kyokai.Bridge.*` modules. | D51, D83, D269, D529 |
| `kyokai lock repair` | Validate and deterministically rewrite lockfile formatting without changing graph meaning. | D424, D528 |
| `kyokai lock explain-conflict` | Run the resolver in conflict-explanation mode and print the incompatibility chain without writing a graph. | D424, D528 |
| `kyokai publish` | Validate package metadata and release policy, then prepare or submit package discovery metadata. | D221, D223, D244 |
| `kyokai semver-check` | Compare public interface surfaces and report source/API compatibility changes. | D223 |
| `kyokai clean` | Remove selected project cache state by default. `--outputs` removes selected project outputs. `--all` removes selected project cache and output state. `--global` is a separate global-cache scope. `kyokai clean docs` removes generated local docs and docs-cache entries. | D83, D144, D264, D397, D425, D429, D516 |
| `kyokai koi verify` | Validate `.koi` container structure, sections, hashes, compatibility fields, and canonical ordering. | D79, D265 |
| `kyokai koi print` | Print a derived JSON or text view of a `.koi` artifact without making the derived view authoritative. | D79, D265 |
| `kyokai koi diff` | Compare two `.koi` artifacts and classify public API, internal API, contract, generic metadata, target, and hash changes. | D79, D223, D265 |

> Trace: D25-D29, D51, D79, D83, D137, D144, D148-D151a, D218, D221, D223-D225, D244, D264-D270, D397, D425, D429, D516, D527
> Covers: Required CLI commands and their top-level obligations are specified, including project creation, diagnostics explanation, safe fixes, toolchain health, scoped cleanup, offline docs cleanup, package inspection commands, and capability deny-policy enforcement.

## Project Creation Commands

`kyokai init` operates on the current directory. It writes `kyokai.toml`, creates the selected module root, and creates an initial `.kyo` module source file only when that path does not already exist. The default package template writes `[package]`, `version`, `edition`, and `[layout].module_root = "src"`. The default workspace template writes `[workspace].members = []` and does not invent packages unless the user asks for a package member template.

> Trace: D26, D78, D266
> Covers: Project initialization is explicit, non-destructive by default, and writes the required manifest layout instead of relying on inferred source roots.

`kyokai new <path>` creates a new directory and then follows the same manifest and template rules as `init`. Official templates are `package`, `workspace`, `library`, `executable`, and `empty`. A template may add tests, documentation examples, or CI files only when the command line says so or the selected template's documented contract says so. Template expansion must be deterministic for the same toolchain version and flags.

> Trace: D26, D78, D83, D266
> Covers: New-project scaffolding is deterministic, template-driven, and does not hide generated project shape.

## Check Is A Real Compiler Pass

`kyokai check` is not allowed to be a parser-only command. It must run the same resolver, type checker, contract checker, linearity checker, capability checker, target guard evaluator, instance resolver, and `.koi` compatibility checker that `build` uses. It can skip generated-C lowering, external C compilation, assembly, archiving, linking, and final executable runner checks.

> Trace: D26, D29, D79, D86
> Covers: Fast checking is semantically honest but may omit generated-C emission, external compilation, and link phases.

If `check` succeeds and `build` later fails, the failure must belong to a phase `check` is allowed to skip, such as generated-C lowering defect, admitted C-toolchain unavailability or rejection, link failure, missing native library, runner failure, or code-size/linker limit. If a later build finds a source semantic error that `check` is required to find, the toolchain is non-conforming.

> Trace: D26, D31, D80, D139, D149
> Covers: `check` success narrows later failure causes to generated-code, external-toolchain, link, target, and runner phases.

## Package Commands

`kyokai add --workspace <name>` writes a workspace dependency entry. `kyokai add --git <url> --rev <rev>` writes a pinned Git dependency. `kyokai add --git <url> --tag <tag>` resolves the tag to a commit and writes both `tag` and `rev`. `kyokai add --index <package> --version <requirement>` writes an indexed package requirement and then resolves the graph through the final resolver model. A command that cannot determine an immutable revision for a Git dependency, cannot validate an indexed package requirement against the selected index policy, or cannot produce a valid lockfile update must fail without editing the manifest.

> Trace: D51, D83, D528
> Covers: Adding dependencies records workspace identity, pinned Git identity, or indexed version intent while lockfile updates carry immutable resolution information.

`kyokai update` updates only the selected package requirements and the minimal required transitive set in `update-selected` mode, or the whole graph in `update-all` mode. It may update Git revisions only when the selected dependency source and policy allow it. It may select a new indexed package version only when every applicable version requirement, feature constraint, target constraint, yank policy, advisory policy, and capability-deny policy is satisfied. It must rewrite the lockfile deterministically and report old and new package instances, old and new revisions, package identity, package version, selected features, selected target/profile facts, and whether the new revision is yanked, superseded, advisory-affected, or policy-blocked when such metadata is available.

> Trace: D51, D83, D221, D244, D528
> Covers: Dependency updates are explicit resolver operations with visible package-instance and revision movement.

`kyokai lock repair` reads an existing lockfile, validates graph identity against the selected manifests, source hashes, resolver version, feature-resolution version, package artifact hashes, source provenance, and index metadata version, and rewrites only deterministic formatting or ordering. It must not change selected package instances, revisions, features, target facts, `.koi` identities, advisories, yanks, policy identities, or dependency edges.

`kyokai lock explain-conflict` runs the resolver in explanation mode. It reports package constraints, version requirements, exact revision pins, feature constraints, target constraints, yanks, advisories, capability-deny policy, and the minimal incompatibility chain the solver can justify. It must not write `kyokai.lock`.

> Trace: D424, D528
> Covers: Lockfile repair is non-semantic, while conflict explanation is an explicit read-only solver lane.

`kyokai publish` does not make the package index the source of code or documentation truth. Publishing records discovery metadata, release metadata, and the compact documentation-index projection. The immutable source and committed `<package-root>/kdocs/` tree remain at the declared repository and exact revision. A publish command must reject package metadata whose manifest identity, source revision, version, `.koi` interface summary, package-root path, committed `kdocs/manifest.toml`, generated-file digest tree, or documentation-search projection do not agree.

`kyokai publish --dry-run` performs local release and staged-publication-`kdocs/` validation without creating index metadata. `kyokai publish` requires the published source tree, including `kdocs/`, to be committed and reachable at one exact Git revision before it generates a ready-to-submit package-index PR/MR payload. The payload contains package identity, version, repository URL, exact revision, package-root path, source digest, `kdocs/manifest.toml` digest, docs-schema version, docs status, raw-file adapter class, and deterministic compact search projection. It does not upload source or copy the full `kdocs/` tree into Kyokai infrastructure.

> Trace: D51, D221, D223, D244, D515-D516, D525
> Covers: Publishing supports source and docs discovery through one reviewed metadata patch without replacing pinned repository identity or centrally storing package docs.

`kyokai remove <name>` edits the manifest only when the named dependency is directly declared in the selected package. It must update the lockfile or report why the dependency remains reachable through another package. The command must not delete source code or vendor directories unless a separate explicit flag names that cleanup.

> Trace: D51, D83, D269
> Covers: Dependency removal is manifest-scoped and does not pretend transitive dependency cleanup is source cleanup.

`kyokai search`, `kyokai info`, `kyokai tree`, `kyokai why`, and `kyokai outdated` are read-only inspection commands. They may refresh package-index metadata in the tool cache, but they must not edit `kyokai.toml`, `kyokai.lock`, source files, or output artifacts. A mutating variant is absent from stable Kyokai until a separate accepted D-point defines its command, prompts, network behavior, filesystem effects, and machine output.

> Trace: D51, D83, D221, D244, D269
> Covers: Package discovery and graph inspection are safe daily commands with clear filesystem effects.

`kyokai vendor` writes only into the selected vendor directory and records enough metadata to prove that vendored sources correspond to the same immutable revisions in the lockfile. Offline builds may use vendored sources only when the manifest, lockfile, and vendor metadata agree. A vendored source tree is not a registry and does not change package identity.

> Trace: D51, D83, D269
> Covers: Offline and vendored workflows preserve the same pinned dependency identity as online resolution.

`kyokai vendor` does not materialize the official Bridge collection. Bridge modules live under the installed toolchain's first-party `Kyokai.Bridge.*` interface root and repository/toolchain-owned `bridge/` collection root. A project that imports a Bridge module can audit and document that module's admission, license, provenance, capability, unsafe, and native-link facts, but it cannot turn Bridge code into an ordinary dependency directory through vendoring. If a project needs an independently pinned third-party source tree, it uses a package dependency and lockfile entry.

> Trace: D51, D83, D269, D529
> Covers: Ordinary vendoring and official bridge modules are separate workflows with different identity and provenance rules.

## Explanation And Fix Commands

`kyokai explain <code-or-category>` reads the versioned diagnostic explanation catalog shipped with the toolchain. The output must include the diagnostic code or category, severity, short meaning, longer explanation, common causes, at least one repair pattern when a repair is known, and links or local anchors to the relevant spec chapter when available. Compiler-backed modes are `--linearity <span-or-symbol>`, `--borrows <span-or-symbol>`, `--defer <function-or-span>`, `--lowering <span-or-symbol>`, `--koi <symbol>`, and `--diagnostic <code>`. They read the same compiler facts as `check`, `build`, the Analysis Server, and the `.koi` reader. They cannot change program validity, suppress diagnostics, or redefine lowering.

> Trace: D29, D267, D474
> Covers: Diagnostics, ownership, borrows, deferred cleanup, lowering, and `.koi` facts have a first-party explanation path over ordinary compiler facts.

`kyokai fix` is separate from `kyokai fmt`. Formatting changes layout only; fixing applies compiler-suggested semantic edits. Every suggestion has one closed safety class: `note-only`, `manual`, `maybe-applicable`, `machine-applicable`, or `machine-applicable-safe`. By default `fix` applies only selected `machine-applicable-safe` suggestions for diagnostics already emitted by `check`. A `machine-applicable` edit set requires explicit opt-in. `maybe-applicable`, `manual`, and `note-only` suggestions are never applied silently. Before committing file changes, `fix` rejects stale spans, rejects unmerged overlapping edits, writes a deterministic summary, and reruns parsing plus formatting validation.

> Trace: D25, D29, D267, D488
> Covers: Automatic fixes use the closed five-class safety model, default only to validated safe edits, and remain compiler-checked instead of becoming hidden formatter behavior.

## Toolchain Health Commands

`kyokai --version` and `kyokai doctor` do not require a project. `--version` prints the public identity of the installed toolchain. `doctor` checks host support, admitted C compiler/linker discovery, default target-toolchain selection, supported target triples, release provenance, cache writability, configured index access, and common environment problems. It reports findings as ordinary diagnostics and must not modify project files.

> Trace: D31, D80, D149, D225, D268
> Covers: Toolchain identity and host setup problems are inspectable without making a dummy project or reading source files.

## Output And Cache Roots

A standalone package owns its default output and cache roots at the package root. A workspace owns its default output and cache roots at the workspace root. Member packages in a workspace do not create independent default output/cache roots for workspace builds.

> Trace: D78, D83, D264
> Covers: Output/cache ownership follows the same package/workspace owner as lockfiles and build scope.

The default user-visible output root is `<owner-root>/kyokai-out/`. The default disposable toolchain cache root is `<owner-root>/.kyokai-cache/`. `--out-dir <path>` and `--cache-dir <path>` override those roots for the current command. Relative override paths are interpreted from the current working directory.

> Trace: D26, D83, D144, D264
> Covers: Kyokai has explicit default and override roots for build products and tool-owned cache state.

`kyokai clean` removes the selected owner root's project build cache. `kyokai clean --outputs` removes the selected owner root's output tree. `kyokai clean --all` removes both of those project-owned roots. `kyokai clean docs` removes project-local generated `kdocs/` output and docs-cache entries for the selected owner root. `kyokai clean --global` is a separate operation for global caches; before removal it prints every global root it will touch. `--dry-run` performs the same scope resolution and prints the removal plan without deleting anything.

No clean form removes source files, `kyokai.toml`, `kyokai.lock`, vendor source trees, package-index metadata outside the explicitly selected cache scope, installed toolchains, package-source caches, or user-selected paths outside the owner root unless that root was explicitly selected by the command's clean scope. `--all` means all project-owned cache and output state. It does not mean all Kyokai state on the machine.

> Trace: D26, D83, D144, D264, D397, D425, D429, D516
> Covers: Clean behavior distinguishes project cache, project output, generated docs, docs cache, and global cache scopes and cannot turn `--all` into machine-wide deletion.

`kyokai run` executes the selected executable from the output tree unless a target runner requires staging. `kyokai test` and `kyokai bench` can place harness executables and private runner state in the cache tree, but user-requested reports go under the output tree's `reports/` directory or to stdout when requested.

> Trace: D26, D28, D83, D137, D264, D479-D480
> Covers: Run, test, and bench distinguish user-visible reports from private harness/cache state.

## Standard Streams

Human diagnostics and progress output go to stderr. Command results intended for another program, such as JSON reports or `kyokai eval` values requested in machine mode, go to stdout. `kyokai run` reserves stdout and stderr after launch for the child program, except for runner setup failures reported before execution.

> Trace: D26, D29, D225
> Covers: CLI output streams are stable for scripts and CI.

## Why This Shape

[Rikona Kurasaki / Mjoyufull]
The command line is a pact. If `kyokai check` says yes, it means a real yes for the parts it claims to check. If `kyokai add` writes a dependency, it cannot smuggle a moving branch into tomorrow's build. This is the difference between a tool that prevents damage and one that merely reports it afterward.

> Trace: D26, D51, D83
> Covers: Kyokai CLI commands are explicit enough to make automation and trust possible.

## Human And Machine Output

Human output uses fixed lanes and omits lanes with no records: command header, selected Kyokai toolchain, workspace/package, target/profile/C-toolchain, dependency resolution, authority/network action, progress, diagnostics, artifacts, cache/provenance, suggestions, and next actions. Human presentation is recognizable but is not a parser contract.

Machine output uses `json` or `json-lines` and records schema version, command, Kyokai toolchain identity, project identity, target, profile, admitted C-toolchain contract identity, policy values, diagnostics, artifact paths, cache facts, authority/network actions, fix IDs, and exit classification. A code action uses the same fix ID in diagnostics, `kyokai fix`, Analysis Server responses, and machine reports.

`--color=auto` observes declared terminal facts and accepted display-only no-color policy. `--color=always` styles human streams. `--color=never` emits plain human text. `--color=machine` emits stable machine output and disables styling, animation, cursor movement, pagers, and prompts. Color never carries the only copy of information.

Kyokai's canonical semantic palette uses Capability Cyan (`#4FD1C5`) only for success and accepted-state markers, Visceral Red (`#C60D2D`) only for errors, fatal termination, and rejected-state markers, Authority Gold (`#DAC564`) for warnings and authority or policy attention, and lavender (`#B8AAFF`, `#CAC0FF`, `#7A5AF5`, or `#9B7FFF`) for informational structure, notes, source emphasis, and navigation. Warm Ivory (`#EDE6D4`) and Deep Violet-Black (`#1A0F2E`) are the preferred foreground/background pair only when the client controls both surfaces. A client maps semantic roles to true-color, 256-color, 16-color, monochrome, or an explicit user theme. Labels, symbols, diagnostic codes, spans, and ordering carry the complete meaning without color.

> Trace: D29, D422, D444, D474, D503
> Covers: Output lanes, JSON schemas, fix IDs, localization boundaries, and color policy are explicit and script-safe.

## Network And Prompt Contract

Every command is classified as `network-forbidden`, `network-capable`, or `network-required`. Local `check`, `build`, `run`, `test`, `fmt`, `doc`, `lsp`, `fix`, `explain`, `--version`, and local `doctor` are `network-forbidden`. Package discovery, `search`, `info`, `add`, `update`, `publish`, explicit docs pulls, advisory-feed refresh, package-index synchronization, and `bleedring` index/update operations are `network-capable` or `network-required` only where their command matrix names the remote action. No command performs telemetry, crash upload, source upload, package-graph upload, timing upload, host-fingerprint upload, or background network contact.

Prompts exist only where a command matrix declares interactivity. `build`, `check`, `test`, `fmt --check`, `doc --check`, `fix --check`, `explain`, `audit`, and every machine-output invocation are noninteractive. A permitted prompt prints its reason, default action, authority or network consequence, and equivalent noninteractive flag.

| Command family | Network class | Prompt rule | Primary artifacts |
| --- | --- | --- | --- |
| `check`, `build`, `run`, `test`, `bench`, `fmt`, local `doc`, `lsp`, `explain`, `fix`, `audit` | `network-forbidden` | Noninteractive in stable build, check, test, and machine lanes. | Reports, diagnostics, binaries, libraries, generated C, maps, and audit output. |
| `add`, `remove`, `update`, `search`, `info`, `outdated`, `vendor`, `publish` | Command-specific package lane; `--offline` forbids contact. | Declared by each mutating command. | Manifest edits, lockfile edits, vendor tree, and package reports. |
| `docs --pull`, advisory refresh, `bleedring` install/update-index | Explicit remote lane; `--offline` forbids contact. | Declared by each mutating command. | Docs cache, advisory cache, and installed toolchain state. |
| `repl`, `eval`, scratch, playground | No ambient network or authority. | Interactive only for declared frontend commands. | Sandboxed reports and requested generated output. |

> Trace: D396, D424-D426, D503, D516
> Covers: Commands name network contact, offline behavior, prompt legality, and the artifacts affected by remote actions.

## Toolchain Management

`kyokai bleedring` manages installed Kyokai toolchains. The bootstrap installer/proxy `kyokaibleed` delegates to that command after installation. `bleedring` installs exact versions, selects explicit directory/workspace/user pins in the precedence order defined by the toolchain-management contract, verifies checksums and provenance, separates install roots from project outputs and package caches, and never rewrites project lockfiles as a side effect of toolchain selection.

`kyokai version --verbose` and `kyokai doctor` print selected toolchain component versions, source commit and clean/dirty state, build date, tag and channel, host and target triples, `.koi`/KBI version, target metadata version, enabled compile-time flags, installed components, relevant external tool paths and versions, install root, global cache root, project cache root, and version ABI string.

> Trace: D425
> Covers: First-party toolchain management, pin precedence, root separation, and full version reporting are visible CLI behavior.

## CLI Contract Matrix

| Surface | Inputs | Outputs | Cache/artifact effect | Network authority | Prompt rule | Exit classifications | Trace |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Project compile lane | Manifest scope, lockfile mode, target, profile, admitted C-toolchain contract, policy flags. | Human lanes or versioned machine records. | Reads project cache; `build` writes requested artifacts. | Forbidden. | Noninteractive. | `success`, `diagnostics-failed`, `target-or-toolchain-unavailable`, `internal-compiler-error`, `interrupted`. | D26, D396, D424, D503, D530-D535 |
| Package mutation lane | Manifest scope, selected dependency action, lockfile mode, index/source policy. | Graph changes, lockfile changes, package reports. | Writes only declared manifest, lockfile, vendor, index-cache, or source-cache roots. | Explicit remote lane; `--offline` forbids contact. | Declared per mutating command. | Compile-lane classes plus `dependency-or-index-failure`. | D51, D396, D424, D503 |
| Cleanup lane | Owner root, explicit clean scope, `--dry-run`. | Reported removal plan and machine records. | Removes only selected project, docs, or global cache/output roots. | Forbidden. | Noninteractive. | `success`, `tool-usage-error`, `diagnostics-failed`, `interrupted`. | D397, D425, D429, D516 |
| Explain lane | Diagnostic code, symbol, or source span. | Human explanation or versioned machine facts. | Read-only. | Forbidden. | Noninteractive. | `success`, `diagnostics-failed`, `tool-usage-error`, `internal-compiler-error`. | D267, D474, D503 |

## Integration Plans And Authority Explanation

The application-integration command family uses versioned plans and the common human/JSON output envelope:

```text
kyokai migrate edition --to <edition> [--package <name> | --workspace]
kyokai migrate edition --apply <plan-path>
kyokai migrate edition --recover <journal-path>
kyokai explain authority [<capability>] [--target <name>] [--json]
```

Packaging and deployment operations use the plan/apply separation defined by the application-integration chapter. The admission record that exposes an operation records its exact subcommand spelling and machine-output schema. Plan-producing operations are read-only apart from their declared local plan artifacts. Apply operations verify plan schema, toolchain identity, target/profile identity, input digests, adapter admission, authority grants, and secret-provider identities before performing local or remote effects. A stale or incompatible plan fails without silent regeneration.

`kyokai explain authority` reports the complete requirement graph and the effective deny-policy sources. It emits only the narrow machine-applicable repairs admitted by the capability-deny chapter. It never widens policy, creates authority, adds a provider, suppresses an unsafe requirement, or replaces a dependency automatically.

> Trace: D503, D527, D544-D545, D548, D557
> Covers: Migration, packaging, deployment, and authority explanation share versioned plans, explicit apply boundaries, stable machine output, and deny-only repair behavior.
