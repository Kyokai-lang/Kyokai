# Capability Deny Policy

[Rikona Kurasaki / Mjoyufull]
> ProofTrace: SPEC-TOOLCHAIN-12-CAPABILITY-DENY-POLICY
> Covers: This chapter is registered in the public ProofTrace evidence graph; registration does not claim implementation, conformance, or theorem completion.

Kyokai makes authority visible in source. The toolchain must let a user turn that visibility into a hard build rule: if this command, project, target, dependency, generator, or test would need a banned kind of authority, the command fails before success can pretend nothing happened.

> Trace: D527
> Covers: Capability deny policy is a toolchain rejection policy over declared or inferred authority requirements; it is not a source-level grant mechanism.

## Boundary

A capability deny policy is a deny-only ceiling over capability requirements. It can reject a command, package graph, target, generator, test, documentation example, audit report, publish payload, scratch run, eval run, REPL run, playground run, or hosted-development run whose required capability set intersects the selected deny set.

The policy does not create capabilities. It does not derive narrower capabilities. It does not make a denied source program legal. It does not make unsafe code safe. It does not weaken source-level capability checking, unsafe contracts, target guards, `.koi` compatibility, lockfile identity, sandbox rules, or runtime startup rules.

> Trace: D20, D85, D211, D255, D527
> Covers: D527 adds no new language capability semantics; it only adds a toolchain-level rejection surface.

The language chapter defines what capabilities mean. This chapter defines when the official toolchain refuses to proceed because selected policy says that a capability requirement is not acceptable for the current operation.

## Capability Names And Matching

A policy item names either an exact capability or a capability family. Exact names use the canonical capability declaration name or the canonical standard-library capability name, such as `NetworkCapability`, `ProcessCapability`, or `DynamicLoaderCapability`. Family names use the stable audit names used by command output, `.koi`, docs, and audit reports, such as `Network`, `Process`, `DynamicLoader`, `Filesystem`, `Filesystem.Read`, `Filesystem.Write`, `Environment`, `Clock`, `Entropy`, `Terminal`, `Signal`, `Unsafe`, and `Device`.

A family deny matches every exact capability in that family. `Filesystem` denies both read and write filesystem authority. `Filesystem.Read` denies capabilities and handles whose contract permits filesystem reads. `Filesystem.Write` denies capabilities and handles whose contract permits filesystem writes. If one capability or handle belongs to several families, denial by any matching family is enough to reject the operation.

Unknown policy names are configuration errors. A conforming tool does not silently ignore `Netwrok`, `Proc`, or a package-local nickname. A package can expose its own capability declarations, but public policy matching uses canonical package-qualified capability names and any family mappings recorded in `.koi` or admitted standard-library metadata.

> Trace: D255, D310, D346, D462, D527
> Covers: Deny policy uses canonical capability and audit names, rejects unknown names, and matches both exact capability types and named authority families.

## Policy Inputs

The effective capability deny policy is formed from four policy sources. They compose from broad to narrow, and the strictest selected rule wins:

| Source | Scope | Contract |
| --- | --- | --- |
| Toolchain defaults | Installed toolchain and command defaults. | The toolchain may define default deny sets for commands whose contract requires default-deny behavior, such as pure tests, eval, scratch, playground, and hosted runners. |
| User/global config | User toolchain configuration. | `$XDG_CONFIG_HOME/kyokai/config.toml` is used when `XDG_CONFIG_HOME` is set. Otherwise the default user path is `~/.config/kyokai/config.toml`. |
| Project manifest | Workspace, package, audit, target, test, doc, generation, and profile policy in `kyokai.toml`. | Manifest policy can narrow authority for the project, workspace, or target. It cannot grant host authority or override a stricter user/global or command-line deny. |
| Command line | Current invocation. | `--deny-capability <name>` adds a deny item for this invocation. Repeating the flag adds more deny items. |

The effective policy is the union of all selected deny items after command-specific scoping is applied. A narrower source can add denial. It cannot remove denial inherited from a broader source.

> Trace: D26, D78, D396, D424, D527
> Covers: Capability deny policy has deterministic source precedence and cannot be relaxed by narrower configuration.

The user/global config schema is:

```toml
[authority]
deny = ["Network", "Process", "DynamicLoader"]

[authority.commands.test]
deny = ["Network"]

[authority.commands.doc]
deny = ["Process", "Network"]
```

Command-specific entries add denial only for the named command family. They do not erase the top-level `[authority].deny` set.

Manifest policy is written where the corresponding project surface is declared:

```toml
[audit]
capability_ceiling = ["Filesystem.Read", "Clock.Monotonic"]

[targets.app]
kind = "executable"
module = "App.Main"
entry = "main"
capability_ceiling = ["Filesystem.Read"]
```

The manifest field `capability_ceiling` remains a ceiling over admitted or inferred capability requirements. If a target ceiling permits `Filesystem.Read` but the user/global config denies `Filesystem`, the target is denied for that command because the stricter effective policy wins.

## CLI Surface

The common CLI flag is:

```text
--deny-capability <capability-or-family-name>
```

The flag is admitted on `check`, `build`, `run`, `test`, `bench`, `doc`, `audit`, `publish`, `semver-check`, `generate`, `eval`, `repl`, scratch/playground lanes, and other project commands that inspect, build, generate, publish, or execute code. A command that does not inspect a project or authority-bearing artifact can reject the flag as a usage error.

Examples:

```sh
kyokai check --deny-capability Network
kyokai build --deny-capability Process --deny-capability DynamicLoader
kyokai test --deny-capability Network
kyokai audit --deny-capability Unsafe
```

`--verbose` prints the effective deny policy, each policy source that contributed to it, and the command surfaces to which it applies. Machine output records the same facts under the command's policy values.

> Trace: D26, D29, D503, D527
> Covers: CLI denial is explicit, repeatable, visible in verbose output, and recorded in machine reports.

## Enforcement Points

The official toolchain applies the effective deny policy before a command reports success.

| Surface | Deny-policy obligation |
| --- | --- |
| `check` | Reject source, dependency interfaces, unsafe contracts, target guards, or generated source whose inferred or declared requirements intersect the deny set. |
| `build` and `run` | Apply `check` obligations and reject build scripts, generators, runtime startup shape, linked runtime requirements, and executable target requirements that intersect the deny set. |
| `test`, `bench`, and doc tests | Reject tests and benches whose declared grants, required capabilities, fixtures, or runner authority intersect the deny set. Pure tests remain default-no-authority. |
| `doc` and docs pull/render | Reject documentation examples and rendering lanes that require denied authority. Reading package docs from configured remote sources still obeys the command's network and offline contract. |
| `generate` and build generation | Reject a generator whose declared read, write, process, network, environment, target, or capability grants intersect the deny set. |
| `audit` | Report denied edges and fail only when the selected audit policy makes the denial fatal. A denial report does not grant authority and does not rewrite manifests. |
| `publish` | Reject a publish payload whose package metadata, `.koi`, target declarations, generated documentation metadata, or compact docs-index projection disagrees with the effective deny policy selected for publication validation. |
| `eval`, `repl`, scratch, playground, and hosted runners | Reject requested authority before execution. Sandbox refusal and deny-policy rejection remain separate error classes. |

A command may discover denial from manifest metadata, `.koi` capability facts, standard-library admission metadata, generated-source provenance, dependency graph facts, target records, docs metadata, test metadata, or source analysis. A command must not wait until runtime to discover a capability requirement that the available static or artifact metadata already exposes.

> Trace: D137, D150, D218, D465, D515-D516, D525, D527
> Covers: Deny policy applies across compile, build, test, docs, generation, audit, publish, and hosted execution surfaces.

## Dependency Graph Behavior

Dependency denial is graph-sensitive. If a dependency, transitive dependency, selected feature instance, generated package, target-specific dependency, dev dependency, doc-test dependency, or tool package requires a denied capability, the diagnostic names the dependency path that introduced the requirement.

```text
error[KY-AUTH-DENIED]: dependency requires denied capability Network
  package: http-client
  required by: app -> updater -> http-client
  source: public interface imports NetworkCapability
  policy: user config ~/.config/kyokai/config.toml denies Network
```

The policy cannot be bypassed by hiding authority in a private implementation when the command checks implementation ceilings. A public-surface audit may report a narrower public requirement, but `check`, `build`, release validation, and implementation-ceiling audit use the full selected graph and target context required by their contracts.

> Trace: D150, D397, D462, D527
> Covers: Dependency denial reports the introducing graph path and distinguishes public surface from full implementation ceiling.

## Reproducibility And Artifacts

The effective capability deny policy is a build-identity input whenever it can affect acceptance, diagnostics-as-artifacts, generated artifacts, dependency graph selection, generator execution, test/doc-test selection, audit output, publish payloads, or release provenance. Cache entries that depend on accepted-source or artifact decisions include the normalized deny-policy set and policy-source identities needed to validate reuse.

`.koi`, lockfiles, docs metadata, audit reports, SemVer reports, and package-index metadata do not treat policy as a hidden side channel. When an artifact records required capabilities, it records the facts independent of the current deny policy. When an artifact records a command result, it records the effective policy that shaped that result.

> Trace: D79, D83, D144, D218, D397, D423-D425, D527
> Covers: Deny policy participates in build identity when it affects command results, while authority facts remain artifact data independent of local policy.

## Diagnostics

A deny-policy diagnostic includes:

- the denied exact capability or family name;
- the source of the policy item: toolchain default, user/global config path, manifest path and table, or command-line flag;
- the package, target, generator, test, doc example, dependency, or artifact that required the capability;
- the dependency, generation, test, docs, publish, or target path that introduced the requirement when one exists;
- whether the requirement came from public API, implementation ceiling, unsafe contract, generated provenance, runner authority, or target/runtime startup shape;
- the command exit classification.

If a policy item is unknown, malformed, ambiguous, or unsupported by the selected toolchain version, the command fails with a tool-usage or configuration diagnostic before source checking proceeds.

> Trace: D29, D150, D503, D527
> Covers: Capability denial produces stable diagnostics instead of becoming a vague build failure.

## Narrow Repair Contract

`kyokai explain authority` and Analysis Server actions use the same effective-policy and requirement-graph calculation as enforcement. A machine-applicable repair is legal only when it:

- threads a narrower capability already available in the selected program;
- adds an explicit parameter whose existing caller-side authority source is proven;
- replaces a broad handle with an admitted attenuation operation; or
- selects an already-declared target or package path whose requirements satisfy the current ceiling.

No repair creates authority, introduces a capability provider, adds a secret, widens global or manifest policy, suppresses an unsafe contract, marks a wrapper safe, or replaces a dependency automatically. Dependency alternatives and policy changes are preview-only and include exact identity, provenance, compatibility, trust/admission, and authority differences.

> Trace: D310, D381, D492, D527, D545
> Covers: Capability-denial repair preserves the effective authority ceiling and automates only compiler-proven narrowing or threading of existing authority.

## Why This Shape

[Rikona Kurasaki / Mjoyufull]
Gentoo Portage USE flags (`https://devmanual.gentoo.org/general-concepts/use-flags/`) are useful prior art because they show that users value build policy that the tool can enforce instead of merely documenting. Kyokai does not copy USE flags: capability deny policy is not feature selection, dependency customization, or optional API shape. It is a hard ceiling over authority.

Cargo features (`https://doc.rust-lang.org/cargo/reference/features.html`) and Cargo configuration (`https://doc.rust-lang.org/cargo/reference/config.html`) provide useful prior art for separating manifest behavior, package feature selection, and user/tool configuration. Kyokai keeps D527 deny-only because authority policy must never become a way to widen what source code can do. If a project says "no network," a dependency that needs network fails loudly. That failure is the feature.

> Trace: D527
> Covers: The accepted policy shape borrows the useful idea of enforceable build policy while rejecting feature-toggle semantics for authority.
