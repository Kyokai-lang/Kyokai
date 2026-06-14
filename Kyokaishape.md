# Kyokai Shape And Public D-Points

This file indexes public Kyokai design shape while the full spec is being written in `kyokaispec/`. Live D-point bodies normally live in PRs/MRs; this file is the archive/index path when a point does not live directly in a PR/MR.

Use this file for:

- index rows for public D-point PRs/MRs
- temporary proposals that do not yet have a PR/MR
- historical D-point material kept for traceability
- accepted shape that has not yet been moved into `kyokaispec/` when no better public artifact owns it
- short notes about public design direction that are too live for `kyokaidecided.md`

Keep this file public, concise, and traceable.

## Source-Of-Truth Order

1. `kyokaispec/` once a rule is written there.
2. `kyokaidecided.md` for public accepted shape not yet fully spec-extracted.
3. Public PRs/MRs that carry live D-point proposals and final wording.
4. `Kyokaishape.md` for index/archive tracking when a D-point does not live directly in a PR/MR.
5. Issues and discussions as motivation or pre-proposal material.
6. `phase.md` for implementation order only.

## Public D-Point Flow

1. Open a proposal PR/MR labeled `dpoint-needed` or `dpoint`; use `Kyokaishape.md` only as temporary/index storage when no PR/MR exists yet.
2. Debate the shape publicly.
3. Write the final proposed rule text.
4. Gather community acks on the final shape, or record `Lead YES` from the lead maintainer.
5. Maintainer marks the point decided or sends it back for wording.
6. Move the decided shape into `kyokaidecided.md` and then `kyokaispec/` when the spec section exists.
7. Update traceability, phase/status rows, conformance plans, and implementation links when affected.

The acks happen after final wording, not before. Early approval of the general direction is useful, but it does not close the point.

`Lead YES` can close final wording without the normal ack count, but it does not remove the requirement for exact final text, accepted-shape extraction, traceability, and status updates.

## External D-Point Tracker Row

Use this compact row when a D-point lives in a PR/MR or external public thread instead of being fully written in this file.

| D-point | Source | State | Owner | Final wording | Spec target | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| DNNN | link | `PROPOSED` | name | no | path or pending | one-line scope |

## Maturity State Tracker

This tracker records how far accepted Kyokai shape has moved toward normative spec text, conformance tests, and implementation. It is not a roadmap and it does not reopen decided semantics. `phase.md` remains the implementation/proof ordering document.

Use the highest honest state that is currently true:

The maturity axes are separate. `SHAPE_DECIDED` does not imply spec extraction, parser support, checker support, runtime support, stdlib admission, conformance coverage, release readiness, or proof. Any row that claims one of those stronger states must name the concrete evidence path for that exact axis.

| State | Meaning | Evidence To Record Here |
| --- | --- | --- |
| `SHAPE_DECIDED` | The design point is decided in public accepted-shape docs. | D-point IDs, accepted-shape section, and any public thread/PR link if applicable. |
| `SPEC_EXTRACTED` | The rule has a normative home in the specification. | `kyokaispec/` path and short note on the covered rule scope. |
| `CALCULUS_DRAFTED` | The behavior is represented in `lambda_K` scope or explicitly excluded from it. | Calculus document path and whether the feature is included or explicitly out of scope. |
| `CALCULUS_PROVEN_PAPER` | The sequential core proof obligation is discharged at paper level. | Proof document path and theorem/scope name. |
| `PARSER_ACCEPTED` | Surface syntax is parsed into AST nodes with source spans. | Parser implementation path and positive/negative parser test path. |
| `ELABORATED_CORE` | Surface constructs lower through the D238 ordered pipeline: name resolution, type-directed completion insertion, explicit elaboration nodes, tautology checking, and later semantic checks run in the specified order. | Elaboration/lowering pass path and tests showing implicit completions/sugar exposure. |
| `CHECKED` | Name, type, borrow, linearity, capability, contract, and unsafe checks enforce the spec. | Checker implementation path and negative diagnostic/conformance test path. |
| `LOWERED_SAFE` | Backend output implements the checked semantics without backend UB. | Backend/runtime path plus UB-sensitive generated-code/runtime tests. |
| `CONFORMANCE_BACKED` | Behavior has executable tests and diagnostic goldens. | Conformance test path and diagnostic golden path if relevant. |
| `STDLIB_ADMITTED` | A stdlib API has its contract, edge cases, tests, and implementation policy. | Stdlib module path, admission/contract note, and edge-case test path. |
| `BOOTSTRAP_RELEASED` | The OCaml/Austral-derived compiler can compile practical Kyokai programs. | Release/build artifact path and workload/test path. |
| `SELF_HOSTING` | Important compiler components are written in Kyokai and built by Kyokai. | Self-hosting component path and bootstrap build instructions/test path. |
| `MECHANIZED_PROVEN` | The relevant core theorem is machine-checked. | Proof assistant artifact path and CI/build command. |

## Public Status Words

Use these status words for live D-point flow:

- `PROPOSED`: opened but not shaped enough to decide.
- `SHAPE_DEBATING`: the proposed shape is being debated.
- `FINAL_TEXT_PROPOSED`: final wording exists and can be acked.
- `ACKED`: final wording reached the public ack threshold.
- `LEAD_YES`: lead maintainer accepted final wording directly.
- `DECIDED`: maintainer accepted the final shape.
- `SPEC_EXTRACTED`: normative text exists in `kyokaispec/`.
- `CONFORMANCE_BACKED`: executable conformance tests exist.
- `IMPLEMENTED`: compiler/toolchain/stdlib implementation exists.

`LEAD_YES` is a public decision-flow status, not an implementation maturity state.

## D-Point Template

````markdown
### D300: Short Name **[PROPOSED | NAV: pending kyokaispec section]**

**The question**: What exactly are we deciding?

**Use case**: What real Kyokai code, tooling, stdlib work, or spec guarantee needs this?

**Current state**: What is currently decided, implemented, inherited from Austral, or missing?

**Prior art**:

| System | Shape | Notes |
| --- | --- | --- |
| Austral | ... | ... |
| Rust | ... | ... |
| Zig | ... | ... |
| C | ... | ... |

**Rationale**: Why does this exact rule fit Kyokai?

**Proposed shape**:

```text
Write the actual rule here. It should be close enough to become spec text.
```

**Consequences**:

- What this makes simpler.
- What this makes harder.
- Which existing decisions/spec sections it touches.

**Rejected alternatives**: Record only alternatives whose rejection matters for future readers. Omit this field when no rejected alternative needs a public record.

**Ack state**:

- Final wording posted: no
- Acks: 0/3 or Lead YES
- Decided: no
````

## Decided Entry Template

````markdown
### D300: Short Name **[DECIDED | SPEC_EXTRACTED | NAV: kyokaispec/src/path.md]**

**Naved to spec**: `kyokaispec/src/path.md`.

**The question**: What was decided?

**Use case**: Why does real Kyokai need this?

**Justification**: Why this is the Kyokai shape.
````

## Decided And Spec-Extracted

### D540-D557: Application Integration And Takeover Ergonomics **[DECIDED | SPEC_EXTRACTED | NAV: kyokaispec/src/stdlib/12-application-integration-contracts.md, kyokaispec/src/toolchain/13-application-integration-and-deployment.md]**

**Naved to spec**: `kyokaispec/src/stdlib/12-application-integration-contracts.md` and `kyokaispec/src/toolchain/13-application-integration-and-deployment.md`, with supporting integration in the existing language, toolchain, and stdlib chapters named by `kyokaispec/src/appendices/b-decision-traceability.md`.

**The question**: Which shared contracts make Kyokai practical for frameworks, generated APIs, edition migration, testing, foreign builds, packaging, runtime datasets, browsers, servers, CLI/TUI, native GUI/media, mobile, embedded, GPU/ML/data, and cloud deployment without adding hidden ownership, dynamic dispatch, ambient authority, another backend, or domain-specific core syntax?

**Justification**: D540-D557 accept common owner/handle/view semantics, generated-API projection, explicit heterogeneous boundaries, the existing callback-class model, migration plans, least-authority explanation, deterministic simulations, typed foreign adapters, packaging plans, dataset providers, and first-party application-domain contracts. Frameworks and providers remain separately admitted. D543 explicitly adds no framework callback-role type system. D556 explicitly adds no GPU language, implicit device dispatch, built-in autodiff, universal tensor type, or second backend. D557 keeps cloud and Nix behavior in inspectable external plans rather than language semantics.

**Decision state**: Lead YES on 2026-06-13. Accepted shape is in `kyokaidecided.md`; normative mechanics and conformance boundaries are in the spec chapters above.

### D264: Build Output And Cache Directory Layout **[DECIDED | SPEC_EXTRACTED | NAV: kyokaispec/src/toolchain/03-cli.md, kyokaispec/src/toolchain/04-build-profiles-targets-linking.md, kyokaispec/src/toolchain/09-reproducibility-incremental-builds.md]**

**The question**: Where does `kyokai build` write user-visible build products, where does the toolchain keep disposable cache/internal state, how are target/profile/backend/package facts reflected in paths, and which knobs may override those locations?

**Use case**: Real Kyokai projects need a stable answer for local builds, CI artifacts, `kyokai run`, `kyokai test`, `kyokai clean`, generated source, `.koi` artifacts, reproducible build identity, package/workspace builds, cross-compilation, editor tooling, and release packaging. Without this rule, two conforming toolchains could put binaries, `.koi`, generated C, object files, and caches in incompatible places while both claiming to implement `kyokai build`.

**Current state**: The toolchain spec says `kyokai build` emits requested build products, `kyokai clean` removes toolchain-generated build outputs and caches, `--verbose` prints lockfile/cache/build-plan facts, generated files may be build-directory-only, and reproducibility includes artifact identity. It does not yet choose a default output directory, cache directory, artifact layout, override flags, workspace-vs-package ownership rule, final-artifact install/prefix rule, or exact `clean` boundary.

**Prior art**:

| System | Shape | Notes |
| --- | --- | --- |
| Austral | No mature package/build-output convention. | The inherited compiler is not a package/workspace toolchain and does not answer Kyokai's artifact-layout question. |
| Rust/Cargo | Workspace-root `target` by default; target triples and profiles appear in the output path; `--target-dir`, config, and env can override. Cargo docs also distinguish final build artifacts from intermediate artifacts in newer build-cache docs. | Good evidence for target/profile path partitioning and workspace-root ownership. Less ideal for Kyokai naming because `target` is already a semantic word for target triples. Source: <https://doc.rust-lang.org/cargo/reference/build-cache.html> and <https://doc.rust-lang.org/cargo/reference/config.html#buildtarget-dir>. |
| Zig | Project-local `.zig-cache` for cache and `zig-out` as an installation prefix containing `bin`/`lib`; user can choose prefix with `--prefix`/`-p`. Zig explicitly says `.zig-cache` can be deleted and `zig-out` is the install prefix. | Strong prior art for separating disposable cache from user-facing install/output. Source: <https://ziglang.org/learn/build-system/>. |
| Go | `go build -o` can choose the final executable path; build cache lives under `GOCACHE` and is not normally a project output tree. | Good prior art for separate global/cache-like compiler state and explicit final output override, but too little package-artifact structure for Kyokai's `.koi`, generated C, and multi-target workspace needs. Source: <https://pkg.go.dev/cmd/go>. |
| CMake | Builds are normally configured around a separate build tree (`cmake -S <src> -B <build>`), with generated files kept out of the source tree; official docs recommend a separate build tree for a pristine source tree. | Good prior art for keeping generated/build files out of source, but CMake leaves too much directory shape to project convention for Kyokai's standard toolchain. Source: <https://cmake.org/cmake/help/latest/manual/cmake.1.html>. |
| Bazel-like systems | Tool-owned output trees and caches are deliberately separated from source and often symlinked or opaque. | Good evidence for hermeticity and cache control, but too opaque for Kyokai's goal that users can find final artifacts without learning a separate build-system filesystem. |

**Rationale**: Kyokai uses a project-local `kyokai-out/` for user-visible artifacts and `.kyokai-cache/` for disposable toolchain state. Within `kyokai-out/`, partition first by target triple, then profile, then backend when backend affects artifact kind or identity, then package name for workspace builds. Keep final products in predictable `bin/`, `lib/`, `koi/`, `doc/`, `reports/`, and `gen/` directories. Keep internal compiler state, incremental query caches, downloaded build scratch, temporary object directories, and tool-private fingerprints in `.kyokai-cache/`.

This keeps the parts a user may inspect separate from the parts the tool owns. It also prevents `target` from meaning both "the build output directory" and "the selected target triple." The shape follows Cargo's target/profile partitioning, Zig's cache/output split, and CMake's source-tree cleanliness, while rejecting Go's too-flat output model for Kyokai's larger artifact surface.

**Proposed shape**:

```text
1. Output root ownership

   A standalone package owns its default output and cache roots at the package root.
   A workspace owns its default output and cache roots at the workspace root.
   Member packages in a workspace do not create independent default output/cache roots
   for workspace builds.

2. Default roots

   The default user-visible output root is:

       <owner-root>/kyokai-out/

   The default disposable toolchain cache root is:

       <owner-root>/.kyokai-cache/

   <owner-root> means the workspace root for a workspace build and the package root
   for a standalone package build.

3. Override flags

   --out-dir <path> selects the user-visible output root for the command.
   --cache-dir <path> selects the disposable cache root for the command.
   Both paths are interpreted relative to the current working directory unless absolute.
   Both paths are part of build identity when they can affect artifact paths embedded in
   debug info, generated C, source maps, docs JSON, provenance, or diagnostics-as-artifacts.
   Path remapping can remove host-specific prefixes from reproducible artifacts.

4. Output layout

   User-visible build artifacts are written under:

       <out-root>/<target-triple>/<profile>/<package-name>/

   The backend component is required for backend-produced artifacts. A command may omit
   the backend component only for backend-independent reports or docs whose identity does
   not depend on backend selection.

   Standard subdirectories are:

       bin/       executables
       lib/       static and dynamic libraries
       koi/       checked package interface artifacts
       gen/       declared generated source/backend files meant for inspection
       doc/       generated documentation HTML and docs JSON
       reports/   coverage, bench, audit, SemVer, timing, and provenance reports
       obj/       object files only when the selected profile marks objects inspectable

5. Cache layout

   Tool-private incremental state is written under:

       <cache-root>/<toolchain-compat>/<target-triple>/<profile>/<c-toolchain-contract>/<package-name>/

   The cache may contain parsed trees, query caches, fingerprints, private object files,
   temporary generated backend IR, dependency build scratch, and other implementation
   acceleration state. Cache entries must be validated by the reproducible build identity
   before reuse. Deleting the cache must not change accepted programs, diagnostics meaning,
   final artifacts, or runtime behavior.

6. Clean behavior

   kyokai clean removes cache state by default and removes output artifacts when passed
   --outputs. kyokai clean --all removes both <out-root> and <cache-root> for the selected
   package/workspace scope, but must not remove source files, kyokai.toml, kyokai.lock,
   package index metadata outside the selected cache root, or user-selected paths outside
   the owner root unless those paths were explicitly passed as --out-dir or --cache-dir.

7. Run/test/bench behavior

   kyokai run executes the selected executable from the output tree unless a target runner
   requires staging. kyokai test and kyokai bench may place harness executables and private
   runner state in the cache tree, but user-requested reports go in reports/ under the
   output tree or to stdout when requested.

8. Generated files

   Declared generated files that are build-directory-only go under gen/ or cache according
   to whether they are user-visible declared outputs. A generated `.kyo` file used as
   source must have source-origin metadata tying it to the generator declaration. A
   generated `.kai` file is rejected as retired source.
   Undeclared generated source under handwritten module roots is rejected.

9. Reproducibility

   The output tree path itself is not a semantic input to source checking. It becomes a
   build identity input only where artifact contents record paths. In reproducible profiles,
   path remapping must make artifacts independent of the absolute checkout location unless
   the user explicitly opts into absolute path embedding.
```

**Consequences**:

- Makes `kyokai build`, `run`, `test`, `bench`, `doc`, `audit`, `semver-check`, `clean`, and CI artifact collection predictable.
- Keeps user-visible outputs separate from disposable compiler state.
- Gives `.koi`, generated source, docs, reports, binaries, libraries, and optional object files stable homes.
- Avoids using `target/` as the directory name, so `target` remains visually available for target triples and target contracts.
- Requires the CLI spec to add `--out-dir` and `--cache-dir` to common/project flags.
- Requires the toolchain spec to define whether `obj/` is always emitted or only profile/flag-selected; the proposed shape makes private object files cache-owned unless inspectable output is requested.
- Touches D26 CLI behavior, D31 profiles/build outputs, D78 workspace ownership, D79 `.koi`, D83 reproducibility, D144 incremental compilation, D149 cross-compilation, D218 docs, D219 coverage, D223 SemVer reports, D225 CI/release artifacts, and D224 generation.
- Does not change language semantics; it is a toolchain contract.

**Ack state**:

- Final wording posted: yes
- Acks: maintainer accepted final wording
- Decided: yes


### D265: `.koi` Artifact Concrete Format And Semantics **[DECIDED | SPEC_EXTRACTED | NAV: kyokaispec/src/toolchain/02-module-resolution-and-koi.md]**

**The question**: What is a `.koi` file concretely: is it text or binary, what grammar/container does it use, what semantic sections must it contain, how does it represent Kyokai declarations and generic bodies, what is excluded, and how do tools inspect it without treating compiler caches as public contract?

**Use case**: Kyokai already decided that `.koi` is the package interface boundary for separate compilation, downstream checking, documentation, auditing, generic materialization, and incremental invalidation. That is not enough for implementation. The compiler, package manager, docs generator, LSP, audit tooling, SemVer checker, release tooling, and future self-hosting compiler all need to know what bytes are in the artifact, what those bytes mean, how compatibility is checked, and what a human can inspect when the artifact causes a build failure.

**Current state**: D79 says `.koi` is a versioned per-package interface artifact, not a cache. It records compiler/version/provenance fields, edition, `.koi` format version, target contract, package identity, module set, interface hashes, visibility-marked declarations, type definitions at visible opacity, typeclass definitions, legal instances, and generic metadata required by D82a/D82b. D105 says `.koi` compatibility requires exact edition match. D83 says `.koi` is reproducible. D144 says unchanged `.koi` means downstream packages should not be rebuilt. What remains missing is the concrete syntax/container format, canonical ordering, human-inspection story, exact section inventory, privacy boundary, and representation of declarations/generic materialization metadata.

**Prior art**:

| System | Shape | Notes |
| --- | --- | --- |
| Austral | No stable compiled interface artifact. | Austral's lack of mature separate compilation is one reason Kyokai needs `.koi`; there is no inherited artifact format worth preserving. |
| OCaml | `.cmi` compiled interface files are produced from `.mli` or inferred signatures; dependent modules load `.cmi`; the compiler rejects corrupted or renamed/mismatched interface files. | Strong prior art for compiled interfaces as the separate-compilation boundary. Weakness for Kyokai: `.cmi` is not designed as a public, inspectable, cross-tool artifact format. Source: <https://ocaml.org/manual/comp.html> and <https://ocaml.org/docs/compiler-frontend>. |
| Rust | `rlib`, `dylib`, and `.rmeta` carry rustc-specific crate metadata so the compiler can understand external crates; `.rmeta` is a custom binary format. | Good evidence that rich metadata is needed for downstream checking and generics. Weakness for Kyokai: rustc metadata is compiler-internal and version-coupled in ways Kyokai is explicitly trying to avoid for `.koi`. Source: <https://rustc-dev-guide.rust-lang.org/backend/libs-and-metadata.html>. |
| GHC/Haskell | Object files are paired with `.hi` interface files; imports look for interface files during separate compilation. | Good prior art for explicit interface files as dependency boundaries, but the format is not Kyokai-shaped and Haskell's typeclass/module model differs heavily. Source: <https://downloads.haskell.org/ghc/latest/docs/users_guide/separate_compilation.html>. |
| Swift | `.swiftmodule` is a binary compiler module; `.swiftinterface` is a textual stable module interface used for module stability and distribution when enabled. | Useful split: fast binary representation vs stable textual inspectable interface. Kyokai can learn from this by making `.koi` a stable canonical artifact and optionally deriving human views, instead of distributing fragile compiler memory images. Source: <https://forums.swift.org/t/update-on-module-stability-and-module-interface-files/23337>. |
| C/C++ headers and modules | Textual headers expose declarations but also execute preprocessing/import behavior; binary/precompiled module formats are usually toolchain-specific. | Good warning: textual declaration surfaces are inspectable, but unrestricted preprocessing/include search creates exactly the ambient behavior Kyokai rejects. |

**Rationale**: `.koi` is a canonical structured binary container with a small fixed header, a canonical section table, deterministic section encodings, cryptographic hashes over normalized section bytes, and an official inspection/validation command. The binary file is the normative artifact. Human-readable JSON/text is derived from it and must not become a second artifact authority.

This fits Kyokai because `.koi` is too important to be an opaque cache, but also too rich to pretend it is just a pretty source file. Kyokai needs the OCaml/GHC idea of an interface file, the Rust idea that downstream compilers need rich metadata, and the Swift lesson that a stable interface surface must not be a fragile compiler memory dump. The compromise is not mushy: one canonical artifact, one exact compatibility algorithm, one official way to inspect it.

**Proposed shape**:

```text
1. Artifact kind

   A `.koi` file is the canonical checked package interface artifact.
   It is a toolchain contract artifact, not an incremental cache, object file,
   source file, archive, or generated documentation file.

2. Container

   `.koi` uses a canonical binary container named Koi Binary Interface version 1
   (`KBI-1`). The first bytes are:

       4 bytes   magic: 0x4B 0x4F 0x49 0x0A    ASCII "KOI\n"
       u16       container_major
       u16       container_minor
       u32       section_count
       u64       section_table_offset

   Integers in the container are little-endian fixed-width unsigned integers.
   Strings are UTF-8 byte strings with unsigned length prefixes and are not
   normalized by the reader. Names that Kyokai compares byte-for-byte are stored
   exactly in their canonical source spelling.

3. Section table

   The section table is sorted by numeric section id. Duplicate section ids are
   illegal. Unknown required sections make the artifact unsupported. Unknown
   optional sections are skipped but remain covered by whole-artifact hashes.

   Required sections for KBI-1 are:

       1  manifest        package identity, package version, edition, root facts
       2  producer        compiler version, compiler compatibility classes
       3  target          target triple, target contract hash, backend contract class
       4  sources         module set, source-origin records, source/derived-interface hashes
       5  imports         dependency package ids, dependency `.koi` hashes, lock ids
       6  declarations    visibility-marked public/internal declaration graph
       7  types           nominal type ids, universes, layouts visible to interface
       8  typeclasses     typeclass definitions, associated types, method surfaces
       9  instances       legal exported/internal instances and coherence keys
       10 generics        generic signatures and materialization metadata
       11 contracts       require/ensure surfaces, failure/capability summaries
       12 unsafe_audit    unsafe module/contract/FFI/capability audit surface
       13 docs            doc comment hashes and doc extraction metadata
       14 hashes          canonical section hashes and whole-artifact hash

4. Semantic model

   `.koi` represents the checked interface graph after parsing, name resolution,
   target selection, declaration-guard evaluation, type checking, typeclass
   checking, contract checking, capability checking, and unsafe-audit coverage
   checking for the selected target/profile inputs that affect interface shape.

   `.koi` does not represent unchecked source syntax. It does not preserve comments
   except through doc metadata. It does not preserve private declarations.
   It does not preserve statement bodies except where generic materialization
   metadata is explicitly required by the generics contract.

5. Visibility boundary

   Public declarations are visible to downstream packages.
   Internal declarations may be present for same-package tooling and incremental
   checking but must be ignored by downstream packages outside the producing
   package. Unmarked module-private declarations never appear in `.koi` unless they
   are part of explicit generic materialization metadata admitted by the generic
   section, and even then they are not name-resolvable declarations.

6. Declaration encoding

   Every declaration receives a stable declaration id derived from package id,
   module logical path, declaration kind, canonical source name, generic parameter
   shape, and disambiguating ordinal where the language admits same-name overload
   families. Declaration ids are deterministic and do not include filesystem
   traversal order or memory addresses.

   Declaration records store declaration kind, module path, visibility, source
   span fingerprint when available, canonical name, type/universe information,
   generic parameters, where-clause obligations, contract summary, capability
   requirements, unsafe marker if any, deprecation/compatibility metadata, and
   links to referenced type/typeclass/instance ids.

7. Type and layout encoding

   Types are encoded as canonical typed graph nodes, not as pretty-printed source
   strings. Nominal identities, universe classification, type parameters, const
   parameters, associated-type projections, borrow/reference types, arrays,
   built-ins, records, unions, extern records, packed records, and opaque types
   each have explicit tags. Visible layout information is recorded only at the
   opacity level promised by the source interface and ABI/layout rules.

8. Typeclass and instance encoding

   Typeclass definitions record method signatures, associated types, default
   method availability, and coherence identity. Instance records store the
   dispatch type, implementing package/module, satisfied obligations, associated
   type bindings, exported/internal visibility, and an overlap/coherence key.
   Instance bodies are not exposed except for generic materialization metadata
   explicitly required by D82b-like rules.

9. Generic materialization metadata

   The generics section records enough checked metadata for downstream packages
   to typecheck and materialize required generic bodies without re-parsing
   upstream source. This metadata is not a runtime dictionary and must not encode
   hidden dynamic dispatch. It records checked generic body IR or another
   versioned materialization description, its compatibility class, referenced
   declarations, captured constants/comptime values, and fingerprints needed for
   invalidation.

10. Compatibility

   A compiler may consume a `.koi` only when these fields match exactly or are
   explicitly declared compatible by the KBI-1 compatibility table:

       language edition
       KBI major version
       target contract identity
       code-generation/generic materialization compatibility class
       built-in/stdlib interface identity required by the package
       package identity of dependencies recorded in imports
       whole-artifact hash for each dependency named by the lockfile

   Producer compiler version is provenance. It is not by itself a compatibility
   key unless the compatibility fields say so.

11. Canonical ordering and hashing

   All maps are serialized in bytewise sorted key order. All lists whose source
   order is semantically meaningful preserve source order. All lists whose order
   is not semantically meaningful use canonical sorted order. Hashes are computed
   over normalized section bytes after path remapping and before compression.
   Compression is not part of KBI-1. A future compressed wrapper must hash the
   uncompressed canonical bytes.

12. Inspection commands

   The toolchain provides:

       kyokai koi verify <file>
       kyokai koi print <file> --format json
       kyokai koi print <file> --format text
       kyokai koi diff <old> <new>

   `verify` checks container structure, required sections, section hashes,
   compatibility fields, and deterministic ordering. `print` emits a derived
   view and is not itself the artifact authority. `diff` reports public API,
   internal API, contract, generic metadata, target, and hash changes by category
   so SemVer and incremental-build tooling can reuse the same classification.

13. Rejection rules

   The compiler must reject a `.koi` with malformed container structure,
   unsupported required section, duplicate section id, invalid UTF-8 string,
   noncanonical ordering, hash mismatch, unsupported KBI major version, edition
   mismatch, target contract mismatch, dependency hash mismatch, missing required
   declaration/type reference, or visibility violation.

14. Non-goals

   `.koi` is not a stable ABI promise by itself.
   `.koi` is not an archive of object code.
   `.koi` is not a source distribution format.
   `.koi` is not a documentation format.
   `.koi` is not allowed to expose private implementation merely because doing
   so would make the first compiler easier to write.
```

**Consequences**:

- Makes `.koi` implementable without leaving the artifact as an opaque cache.
- Gives docs, LSP, audit, SemVer, package index, release provenance, and incremental compilation one artifact truth to inspect.
- Requires a `kyokai koi` command family or equivalent subcommands to inspect, verify, and diff artifacts.
- Requires exact binary encoding work in the toolchain spec beyond the current high-level D79 extraction.
- Forces generic materialization metadata to be versioned and explicit instead of smuggled in as compiler memory.
- Keeps unmarked module-private declarations out of downstream package interfaces.
- Leaves room for fast loading without giving up human debuggability.
- Touches D17 visibility, D20/D245 unsafe surfaces, D29 diagnostics, D79 `.koi`, D82a/D82b generics, D83 reproducibility, D105 editions, D144 incremental builds, D148 LSP, D150 audit, D218 docs, D223 SemVer, D244 yanks/lockfile provenance, and the concrete `.koi` spec extraction.

**Ack state**:

- Final wording posted: yes
- Acks: maintainer accepted final wording
- Decided: yes

## Decided But Not Yet Spec-Extracted

The initial decided shape is being cleaned into `kyokaidecided.md` first. As the public spec gets written, decisions will move from there into `kyokaispec/` and be linked here only when useful.

### D525: Repository-Owned `kdocs/` And Central Metadata-Only Documentation Index **[DECIDED | SPEC_EXTRACTED | NAV: kyokaispec/src/toolchain/01-manifest-package-workspace.md, kyokaispec/src/toolchain/03-cli.md, kyokaispec/src/toolchain/08-docs-lsp-audit.md, kyokaispec/src/toolchain/10-package-index-semver-releases-ci.md]**

**Naved to spec**: `kyokaispec/src/toolchain/01-manifest-package-workspace.md`, `kyokaispec/src/toolchain/03-cli.md`, `kyokaispec/src/toolchain/08-docs-lsp-audit.md`, and `kyokaispec/src/toolchain/10-package-index-semver-releases-ci.md`.

**The question**: Where do published package docs live, what does the official package index store, and how do the toolchain and website retrieve docs without requiring Kyokai to operate package-doc artifact storage?

**Use case**: A package owner should publish one reviewable metadata patch while keeping generated docs beside the exact Git-hosted package source. Kyokai needs central search and retrieval without copying every package's generated HTML and structured docs into a Kyokai-owned repository.

**Justification**: Each published package commits a generated `kdocs/` directory at its package root. The official package index stores the exact Git revision, package-root path, docs manifest digest, schema, retrieval-adapter class, status, and compact search projection. The website and `kyokai docs --pull` retrieve verified files from that exact indexed revision. A workspace monorepo stores one `kdocs/` directory under each published member package root. `kyokai-package-docs` is not a required bootstrap repository; any future mirror is cache-aside infrastructure and requires a separate service decision.

### D526: ProofTrace Evidence Graph, Code Markers, And Generated Public Status **[DECIDED | SPEC_EXTRACTED | IMPLEMENTED | NAV: kyokaispec/src/appendices/d-formalization-roadmap.md, kyokaispec/src/toolchain/08-docs-lsp-audit.md, kyokaispec/src/toolchain/10-package-index-semver-releases-ci.md]**

**Naved to spec**: `kyokaispec/src/appendices/d-formalization-roadmap.md`, `kyokaispec/src/toolchain/08-docs-lsp-audit.md`, and `kyokaispec/src/toolchain/10-package-index-semver-releases-ci.md`.

**The question**: How does Kyokai keep spec text, compiler and toolchain boundaries, tests, conformance suites, and proof artifacts visibly connected without pretending that one kind of evidence proves another?

**Use case**: A maintainer changing the linearity checker, backend, stdlib, package toolchain, or calculus should be able to see the owning spec surface, current implementation state, conformance state, proof requirement, proof evidence, and known exclusions. The public project status should be generated from checked metadata instead of reconstructed manually from prose.

**Justification**: Kyokai uses one public `ProofTrace` evidence graph. Every spec-relevant semantic, toolchain, stdlib, backend, unsafe, conformance, and proof boundary has a stable record ID. Records keep specification, implementation, conformance, and proof state as separate fields. Source chapters use chapter-level `ProofTrace` registrations. Maintained implementation and proof boundaries use language-appropriate `kyokai:prooftrace id=...` comments. Tooling-only boundaries can state that proof is not required, but they must use one closed reason category. CI validates registry structure, required boundary markers, artifact paths, generated-board freshness, and chapter registration. `kyokaiproofstatus.md` is generated from `kyokaiproofstatus.toml` and is never edited manually. The metadata is tooling evidence only: it cannot affect Kyokai source legality, type checking, code generation, runtime behavior, or proof conclusions.

### D527: Capability Deny Policy **[DECIDED | SPEC_EXTRACTED | NAV: kyokaispec/src/toolchain/12-capability-deny-policy.md, kyokaispec/src/toolchain/03-cli.md, kyokaispec/src/toolchain/01-manifest-package-workspace.md, kyokaispec/src/language/14-capabilities-and-authority.md]**

**Naved to spec**: `kyokaispec/src/toolchain/12-capability-deny-policy.md`, with supporting references in `kyokaispec/src/toolchain/03-cli.md`, `kyokaispec/src/toolchain/01-manifest-package-workspace.md`, `kyokaispec/src/toolchain/08-docs-lsp-audit.md`, `kyokaispec/src/toolchain/09-reproducibility-incremental-builds.md`, and `kyokaispec/src/language/14-capabilities-and-authority.md`.

**The question**: Can a user, project, CI lane, or toolchain invocation ban selected capability families during checking, building, testing, documentation, audit, generation, package publication, and dependency use without changing Kyokai's source-level capability semantics?

**Use case**: A developer may want a project or one command invocation to fail if any selected target, dependency, generator, test, doc example, or executable path requires `Network`, `Process`, `DynamicLoader`, broad filesystem authority, or another named capability family. This is a daily DX and audit tool: it lets Kyokai's explicit authority model become a practical build-time tripwire instead of only a source-reading discipline.

**Justification**: Kyokai accepts a toolchain-level **capability deny policy**. D527 adds no new language capability semantics and grants no authority. A deny policy is a ceiling over already-declared or inferred capability requirements. If the selected policy denies a capability family or exact capability name, every relevant command rejects any package graph edge, executable target, generator, test, doc example, scratch/eval/playground execution, publish payload, or audit-checked surface whose required capability set intersects the denied set. The diagnostic names the denied capability, the policy source, the package or target that required it, and the dependency or generation path that introduced it.

The policy sources compose from broad to narrow: toolchain defaults, user/global config at `$XDG_CONFIG_HOME/kyokai/config.toml` or `~/.config/kyokai/config.toml`, package/workspace manifest ceilings in `kyokai.toml`, and command-line flags such as `--deny-capability <name>`. The strictest selected policy wins. A policy can reject more programs; it cannot make a rejected source program legal, fabricate capabilities, weaken source checks, suppress unsafe requirements, or hide authority from `.koi`, lockfiles, audit output, docs, LSP, or reproducibility records.

Prior art: Gentoo Portage USE flags (`https://devmanual.gentoo.org/general-concepts/use-flags/`) show why users like machine-checkable build policy knobs, while Kyokai deliberately does not copy feature toggles because D527 is not optional feature selection. Cargo features (`https://doc.rust-lang.org/cargo/reference/features.html`) and Cargo configuration (`https://doc.rust-lang.org/cargo/reference/config.html`) show useful separation between manifest-declared package behavior and user/tool configuration, while Kyokai keeps this lane deny-only so authority cannot be widened by configuration. The accepted shape is therefore closer to an authority firewall than to a package feature resolver.

### D528: Final Resolver Model, Version Constraints, And Lockfile Schema **[DECIDED | SPEC_EXTRACTED | NAV: kyokaispec/src/toolchain/01-manifest-package-workspace.md, kyokaispec/src/toolchain/03-cli.md, kyokaispec/src/toolchain/09-reproducibility-incremental-builds.md, kyokaispec/src/toolchain/10-package-index-semver-releases-ci.md]**

**Naved to spec**: `kyokaispec/src/toolchain/01-manifest-package-workspace.md`, with supporting references in `kyokaispec/src/toolchain/03-cli.md`, `kyokaispec/src/toolchain/09-reproducibility-incremental-builds.md`, and `kyokaispec/src/toolchain/10-package-index-semver-releases-ci.md`.

**The question**: Does Kyokai leave dependency resolution as a small pinned-Git-only bootstrap trick, or does it specify the final package resolver and lockfile model now while implementation lands in smaller slices?

**Use case**: Package authors need to write version intent for indexed packages without losing Kyokai's exact-revision reproducibility. Users need conflict diagnostics that explain the real dependency path, version requirement, feature requirement, target condition, yank/advisory policy, and capability-deny policy that made a graph impossible. Implementers need permission to land workspace-only or pinned-Git slices without inventing a second resolver contract.

**Justification**: Kyokai accepts a final PubGrub/SAT-shaped resolver model. The public dependency surface has three source kinds: workspace package references, pinned Git references, and indexed package version requirements. Workspace and pinned-Git dependencies remain exact where they are written. Indexed dependencies state version constraints and resolve through package-index metadata to exact Git revisions, canonical source hashes, package identity, selected feature set, target/profile inputs, `.koi` identity, advisory/yank state, and provenance in `kyokai.lock`.

The resolver is specified as an incompatibility-learning solver in the PubGrub family, or a SAT-equivalent implementation that preserves the same public solution and conflict-explanation contract. The implementation may land in slices, but every slice must use the final resolver data model, final lockfile tables, final diagnostics vocabulary, and final mode semantics. A partial implementation reports unsupported source kinds or policy inputs explicitly. It must not define a temporary dependency language, temporary lockfile meaning, or alternate conflict policy.

`kyokai.lock` is a deterministic TOML artifact with explicit `lock`, `root`, `package`, and `edge` records. `package` records name package identity, version, edition, source kind, exact revision or workspace path, canonical source hash when external, selected features, target contract, semantic profile, `.koi` digest where produced, and provenance. `edge` records name the depender instance, local dependency name, resolved dependee instance, dependency class, requested features, target condition, capability requirement summary, and the requirement or pin that introduced the edge. Repair validates graph identity and formatting; it never changes graph meaning. Regeneration or update is the only graph-changing operation.

Prior art: Cargo's [resolver](https://doc.rust-lang.org/cargo/reference/resolver.html) and [lockfile](https://doc.rust-lang.org/cargo/guide/cargo-toml-vs-cargo-lock.html) documentation separate manifest intent from exact `Cargo.lock` resolution and make graph inspection part of daily tooling; Kyokai uses that separation without copying Cargo's registry-source authority or accidental build-time lockfile mutation. Dart pub's [PubGrub solver documentation](https://github.com/dart-lang/pub/blob/master/doc/solver.md) gives Kyokai the right shape for useful incompatibility explanations. SAT-solver literature and Borretti's [Dependency Resolution Made Simple](https://borretti.me/article/dependency-resolution-made-simple) support the formal constraint-solving framing, but Kyokai's public contract is the user-visible incompatibility graph, deterministic lockfile, and conflict report rather than a mandate for one internal solver library.

### D529: Official Bridge Collection For Shipped Third-Party Integrations **[DECIDED | SPEC_EXTRACTED | NAV: kyokaispec/src/language/04-modules-and-visibility.md, kyokaispec/src/language/16-unsafe-ffi-and-abi.md, kyokaispec/src/stdlib/00-stdlib-overview.md, kyokaispec/src/stdlib/01-admission-contracts.md, kyokaispec/src/toolchain/01-manifest-package-workspace.md, kyokaispec/src/toolchain/02-module-resolution-and-koi.md, kyokaispec/src/toolchain/03-cli.md, kyokaispec/src/toolchain/10-package-index-semver-releases-ci.md]**

**Naved to spec**: `kyokaispec/src/language/04-modules-and-visibility.md`, `kyokaispec/src/language/16-unsafe-ffi-and-abi.md`, `kyokaispec/src/stdlib/00-stdlib-overview.md`, `kyokaispec/src/stdlib/01-admission-contracts.md`, `kyokaispec/src/toolchain/01-manifest-package-workspace.md`, `kyokaispec/src/toolchain/02-module-resolution-and-koi.md`, `kyokaispec/src/toolchain/03-cli.md`, and `kyokaispec/src/toolchain/10-package-index-semver-releases-ci.md`.

**The question**: Does Kyokai ship a curated first-party collection of third-party bindings, ports, adapters, and reviewed copied support code, and if it does, how does that avoid colliding with ordinary `kyokai vendor` dependency vendoring?

**Use case**: Systems programmers need practical entrypoints to common external libraries, native APIs, and protocol ecosystems without treating a package cache as official language support. Maintainers need a place for reviewed bindings and small ports that ship with the toolchain, carry license/provenance records, and obey Kyokai's capability and unsafe-contract model.

**Justification**: Kyokai accepts an official **Bridge collection**. The collection is first-party shipped integration code under the reserved public namespace `Kyokai.Bridge.*` and the repository/toolchain-owned collection root `bridge/`. It is not called `vendor`, is not the output of `kyokai vendor`, is not a package-index cache, and is not an ordinary dependency directory. Bridge modules are explicit imports; importing a bridge module grants no authority, hides no unsafe operation, and performs no network or native-library discovery beyond the command contracts that already allow those actions.

A Bridge entry may be a binding to an external ABI library, a safe wrapper over raw FFI, a small port of upstream source, generated binding output with generator provenance, or an adapter around a target-native facility. Every admitted entry records upstream URL, exact revision or release, license/SPDX facts, copied-file inventory, local modifications, generator command when generated, target/platform gates, native library requirements, unsafe contracts, capability requirements, tests, docs, owner, update policy, and audit status. Capability deny policy applies to bridge entries exactly as it applies to packages, targets, generators, docs, tests, audit, publish, and execution lanes.

Bridge entries are toolchain-versioned shipped code. They are resolved as installed first-party modules, not through package-index dependency resolution. They may depend on external native libraries only through declared target/link contracts and diagnostics. They must not silently fetch source, binaries, headers, or package-index entries during import or checking. Prebuilt binary payloads are admitted only with platform gates, checksum/provenance records, license records, reproducibility status, and a reason a source or system-library path is insufficient.

Prior art: Odin's `vendor:` collection is shipped with the Odin implementation (`https://github.com/odin-lang/Odin/blob/master/vendor/README.md`), Odin install docs describe `base`, `core`, and `vendor` as expected installation roots beside the compiler or under `ODIN_ROOT` (`https://odin-lang.org/docs/install/`), and Odin package-doc tooling documents installed collections (`https://github.com/odin-lang/pkg.odin-lang.org/blob/master/resources/odin-doc.json`). Kyokai keeps the useful idea of a shipped curated integration collection while changing the name and governance because Kyokai already uses `kyokai vendor` for ordinary reproducible dependency vendoring, and because Kyokai's authority model requires license, provenance, unsafe, capability, target, and audit records before code can be treated as official bridge surface.

### D530: One Maintained Generated-C Backend **[DECIDED | SPEC_EXTRACTED | OVERRIDES: D4 direct-LLVM plan | NAV: kyokaispec/src/language/17-memory-layout-and-backend-contract.md, kyokaispec/src/toolchain/04-build-profiles-targets-linking.md]**

**The question**: Does Kyokai maintain multiple code-generation backends, or one semantic lowering path whose output is compiled by admitted external C toolchains?

**Accepted shape**: Kyokai has one maintained backend: generated C. The compiler lowers checked Kyokai IR into defined generated C. GCC, Clang, Apple Clang, clang-cl, linkers, assemblers, archivers, debuggers, and profilers are external target toolchains, not Kyokai backends. Kyokai does not maintain a direct LLVM, Cranelift, QBE, custom native, assembly, or bytecode backend. This decision overrides D4's planned direct LLVM backend while preserving D4's rule that Kyokai semantics are independent of C and cannot be weakened to suit a host compiler.

Backend selection is therefore not a user dimension. `--backend`, `[build].backend`, `[backend.c]`, `[backend.llvm]`, backend-specific output directories, and cross-backend conformance claims are absent. Target and profile selection choose an admitted C compiler contract and its linker/archive/debug tool family. Requested generated C remains a first-class inspectable artifact, but generated C is not a stable source-level interchange format and is not hand-maintained application code.

### D531: C11 Generated-Source Baseline **[DECIDED | SPEC_EXTRACTED | NAV: kyokaispec/src/language/17-memory-layout-and-backend-contract.md, kyokaispec/src/toolchain/04-build-profiles-targets-linking.md]**

**Accepted shape**: Kyokai's portable generated-source baseline is a documented C11 subset. It uses C11's `_Static_assert`, alignment facilities, `_Noreturn`, thread-local syntax where the target contract admits TLS, and `<stdatomic.h>` where the admitted compiler/target combination provides the required atomic semantics. It avoids variable-length arrays, C bitfields, implementation-defined signed shifts, unsequenced side effects, type-punning alias violations, signed-overflow dependence, and every other C undefined or unspecified behavior that could alter a valid Kyokai program.

C17 compiler modes are accepted when they compile the same C11 generated subset. C17 adds defect corrections but no required Kyokai lowering facility that justifies raising the portability floor. C23 is not the baseline because support remains uneven across major platform SDKs and compiler families, and Kyokai does not need C23 features to preserve its semantics. A later change to the generated-source baseline requires a new D-point, a compiler/platform support matrix, generated-code conformance evidence, and a migration analysis for bootstrap, freestanding, and older supported targets.

Named compiler builtins, intrinsics, attributes, pragmas, and inline assembly are legal only through target/compiler contracts. An admitted extension never becomes general source-C permission and never supplies Kyokai semantics through undefined behavior.

Primary references: WG14 C11 N1570 (`https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1570.pdf`), C17 N2176 (`https://www.open-std.org/jtc1/sc22/wg14/www/docs/n2176.pdf`), C23 N3096 (`https://www.open-std.org/jtc1/sc22/wg14/www/docs/n3096.pdf`), GCC C dialect options (`https://gcc.gnu.org/onlinedocs/gcc/C-Dialect-Options.html`), Clang C status (`https://clang.llvm.org/c_status.html`), and MSVC standard-mode documentation (`https://learn.microsoft.com/en-us/cpp/build/reference/std-specify-language-standard-version`).

### D532: C Toolchain Admission And Major-Platform Matrix **[DECIDED | SPEC_EXTRACTED | NAV: kyokaispec/src/toolchain/04-build-profiles-targets-linking.md, kyokaispec/src/toolchain/03-cli.md]**

**Accepted shape**: Kyokai admits C toolchains by compiler family, version range, target triple, SDK/sysroot, linker/archive family, object/debug format, and tested feature contract. It never treats an arbitrary ambient `cc` as conforming merely because it accepts a generated file.

The major hosted platform lanes are GCC and Clang on Linux, Apple Clang on macOS, clang-cl on Windows, and Clang on FreeBSD. Additional GCC/Clang cross toolchains, MinGW, MSVC `cl`, other BSDs, WASI, embedded, kernel, and freestanding toolchains enter the supported matrix only through the same admission record. Windows support does not depend on incomplete MSVC ISO C atomics: clang-cl is the initial standards-capable Windows lane, while an MSVC-family lane requires explicit atomic/TLS/alignment adapters and full conformance evidence before admission.

Every admission record includes dialect probes, ABI/layout and calling tests, atomics and TLS, strict-float behavior, inline assembly/intrinsics, debug/source mapping, sanitizer availability, linker/archive behavior, deterministic-output controls, diagnostic capture, generated-C compile time, runtime correctness, and known unsupported surfaces. Unknown families and versions fail with a toolchain diagnostic. CompCert is an optional independent evidence lane where its C subset and target support fit; it is not a separate Kyokai backend or a weaker/stronger language profile. TCC is not admitted by speed alone and requires the same semantics, atomics, TLS, ABI, debug, diagnostic, and target evidence as every other compiler.

Primary references: CompCert (`https://compcert.org/`), TCC (`https://bellard.org/tcc/tcc-doc.html`), GCC debug options (`https://gcc.gnu.org/onlinedocs/gcc/Debugging-Options.html`), and MSVC CodeView/PDB modes (`https://learn.microsoft.com/en-us/cpp/build/reference/z7-zi-zi-debug-information-format`).

### D533: Kyokai-Native Debug, Symbolization, Coverage, And Profiling **[DECIDED | SPEC_EXTRACTED | NAV: kyokaispec/src/language/17-memory-layout-and-backend-contract.md, kyokaispec/src/toolchain/05-diagnostics.md, kyokaispec/src/toolchain/07-testing-coverage-bench.md]**

**Accepted shape**: The generated-C architecture does not make generated C the user-facing debugging model. The compiler emits `#line` directives plus an authoritative sidecar source map that records Kyokai byte and line/column spans, declaration/expression identities, generated-helper classification, symbol/local mappings, materialization provenance, contract/TPOE site identities, and path-remap facts. Object-level DWARF, CodeView/PDB, dSYM, and equivalent data are produced by the admitted C toolchain and consumed through Kyokai's source-map/symbolizer service.

`kyokai debug`, fatal reporting, sanitizer normalization, coverage, profiler reports, the Analysis Server, and diagnostic rendering share that mapping service. Debuggers receive source-directory or substitute-path configuration so breakpoints and listings resolve Kyokai files rather than generated files. Optimized-away or non-representable values are reported as unavailable; the toolchain never invents a false value. Coverage points are inserted and identified at Kyokai IR level so helper C, checks, wrappers, and runtime scaffolding do not become user coverage. Raw external-tool logs and generated-file locations remain inspectable evidence behind normalized Kyokai locations.

Primary references: GCC line control (`https://gcc.gnu.org/onlinedocs/cpp/Line-Control.html`), GDB source-path substitution (`https://sourceware.org/gdb/current/onlinedocs/gdb.html/Source-Path.html`), Clang source-based coverage (`https://clang.llvm.org/docs/SourceBasedCodeCoverage.html`), and MSVC debug-information formats (`https://learn.microsoft.com/en-us/cpp/build/reference/z7-zi-zi-debug-information-format`).

### D534: Compilation-Time Contract And Incremental C Units **[DECIDED | SPEC_EXTRACTED | NAV: kyokaispec/src/toolchain/09-reproducibility-incremental-builds.md, phase.md]**

**Accepted shape**: Fast compilation is a product contract. Generated C is split into deterministic package, module, and materialization units with stable dependencies. `.koi` reuse, object caching, prebuilt standard-library and Bridge objects, parallel external compilation, dependency-cached builds, and incremental linking prevent a local edit from recompiling the whole graph.

Kyokai publishes benchmark classes and reference machines for no-op, one-file incremental, dependency-cached clean, full clean debug, and release builds. The initial engineering gates are: no-op build under one second, ordinary analysis feedback under one second, typical incremental executable rebuild under five seconds, clean fsel-class debug build under fifteen seconds, clean Zig/Hyprland-class debug build under sixty seconds, and very-large clean debug build under five minutes on the named reference hardware. A missed budget is a measured toolchain defect or explicit release blocker, not permission to change language semantics or hide work. Exact benchmark repositories, revisions, hardware, and statistical protocol are maintained in the performance plan and CI records.

### D535: External-Tool Diagnostics And Reproducible Build Plans **[DECIDED | SPEC_EXTRACTED | NAV: kyokaispec/src/toolchain/03-cli.md, kyokaispec/src/toolchain/05-diagnostics.md]**

**Accepted shape**: Every external compiler, assembler, linker, archiver, debugger, symbolizer, coverage, and profiler invocation has a reproducible build-plan record. The record includes executable identity and version, target, sysroot/SDK, normalized arguments, admitted environment inputs, working directory, input/output digests, exit status or signal, stdout/stderr artifacts, and source-map identity. Secret and user-private values follow the existing redaction contract.

Kyokai parses diagnostics from admitted compiler families and remaps them to Kyokai source only when the source map proves the location. The human diagnostic includes the Kyokai span and stable category; machine output preserves the raw external diagnostic and generated location. A generated-C compile rejection for valid checked Kyokai is classified as a code-generation defect, unsupported toolchain contract, native dependency error, or external-tool failure rather than being misreported as a source type error. `kyokai doctor` and `--print-plan` expose toolchain selection and probes without silently repairing configuration.

### D536: Standard Profiles Over One C Pipeline **[DECIDED | SPEC_EXTRACTED | NAV: kyokaispec/src/toolchain/04-build-profiles-targets-linking.md]**

**Accepted shape**: Kyokai keeps the standard `debug`, `test`, `release`, and `bench` profiles. It does not add `dev-fast`, `maximum`, `assurance`, LLVM-release, or backend-selection profiles. `debug` is the fast daily build with source mapping, symbols, frame pointers where admitted, no stripping, and no LTO. `test` adds the selected test instrumentation and isolation contract. `release` is the shipping optimization profile and is the single ordinary maximum-performance lane; LTO/PGO and CPU dispatch remain explicit recorded release settings. `bench` is release-like with benchmark observability preserved.

Profile differences never disable Kyokai safety checks or change source semantics. GCC versus Clang versus another admitted compiler is target-toolchain selection, not a profile. CompCert and sanitizer runs are evidence/toolchain lanes, not language profiles.

### D537: Single-File Module Source Model **[DECIDED | SPEC_EXTRACTED | SUPERSEDES: D382 | AMENDS: D52, D78, D303, D313, D390, D518 | NAV: kyokaispec/src/language/03-grammar.md, kyokaispec/src/language/04-modules-and-visibility.md, kyokaispec/src/toolchain/02-module-resolution-and-koi.md]**

**The question**: Does a Kyokai module keep the inherited two-file split, where a handwritten `.kyo` interface and a handwritten `.kai` body declare the same module, or does a module live in one handwritten source file from which the compiler derives the checked interface?

**Use case**: Every public function, type, contract, doc comment, import, and target guard in the two-file model is written twice: once in the `.kyo` interface and once in the `.kai` body. The second copy carries no fact the compiler cannot derive from the first. Real Kyokai authoring, refactoring, and review pay that duplication on every edit. The `.koi` artifact already exists as the checked, inspectable, separately compiled package interface, so the handwritten interface file is a third copy of a contract the toolchain already produces.

**Current state**: D382 rejected a single-file module mode and kept handwritten `.kyo` + `.kai`. D313 reaffirmed body-only `.kai` modules. D518 named `.kyo` interface source, `.kai` body source, and `.koi` artifact roles. D52/D78 mapped one logical module to a `.kyo` interface candidate and a `.kai` body candidate. D382 was decided as a syntax-complaint deferral that routed ceremony reduction to formatter, LSP, and interface-sync tooling. It did not defend duplication on its own merits, and duplication is the exact pressure D6, D7b, D8, and D12 already remove elsewhere when the compiler can prove the omitted spelling.

**Prior art**:

| System | Shape | Notes |
| --- | --- | --- |
| Austral / OCaml / Ada | Two handwritten files: body plus a handwritten signature/interface. | The inherited model. The OCaml community's own canonical complaint is signature duplication; `ocamlc -i` exists to generate the interface, and the "intf trick" exists to factor shared definitions out of the duplicated pair. The defense of the model reduces to requiring the second file only to hide implementation, which is an argument for deriving the interface rather than handwriting it. |
| Rust | One source file. Per-item visibility (`pub`, `pub(crate)`, private default). `.rmeta` crate metadata generated by `rustc`. | Strong evidence that interface metadata and separate compilation do not require a handwritten interface file. |
| Swift | One source file. Per-declaration access control. `.swiftinterface` is a textual, ABI-stable interface emitted by the compiler under library evolution. | Direct precedent: the compiler emits a stable interface describing the public ABI from single-source input, and representation hiding (frozen vs non-frozen layout) is expressed in the source and recorded in the generated interface, not in a second handwritten file. |
| Zig | One source file. `file == module`. `pub` exposes a declaration to importers; private is the default. | Single-file `pub` visibility works in practice. Kyokai keeps the per-declaration marker but binds visibility to the module and the explicit marker rather than to the file as a compilation unit, avoiding Zig's "pub does nothing inside one file" confusion. |

**Rationale**: A Kyokai module is written in one handwritten source file. The compiler extracts the importable interface surface from that file and produces the `.koi` artifact as the checked, separately compiled package interface. Clients still typecheck against `.koi`, never against another package's private source, so interface-first checking and package-level separate compilation are preserved exactly. The boundary that mattered in the two-file model was never the second file; it was the contract, and the contract now lives in one place that the compiler defends.

This removes the largest remaining instance of writing-it-twice in Kyokai. It is the same justification stamped on D6 (anonymous regions), D7b (auto-reborrow), D8 (implicit unit return), and D12 (literal inference): when one well-formed spelling is forced by the program and the compiler can derive the rest, spelling it a second time is ceremony, not information. It also matches the convergent modern answer in Rust, Swift, Zig, and Go, while keeping Kyokai's stricter linearity, capability, and `.koi` discipline.

**Accepted shape**:

```text
1. Source file model

   A Kyokai module is written in exactly one handwritten source file with the
   `.kyo` extension. The file contains one module. The module header is
   `module Name is ... seal;`. There is no separate `module body` header and no
   handwritten interface/body pair.

2. Retired roles

   `.kai` is no longer a handwritten Kyokai source extension. The two-file
   `module ... is` interface plus `module body ... is` body form is retired.
   `module body` is not a module header in accepted Kyokai.

3. Interface derivation

   The compiler derives the importable interface surface (the public and
   `internal` declarations under D538) from the single source file. `.koi`
   remains the generated, checked, separately compiled package interface
   artifact defined by D79/D265. `.koi` is produced from the single source
   file's extracted surface rather than from a handwritten interface file.

4. Separate compilation

   A downstream package typechecks against a dependency's `.koi` interface, not
   against the dependency's source. Within a package, a module's body is
   available for implementation checking but only its derived public/`internal`
   surface is importable. Interface-first checking is preserved: a module that
   imports another module checks against the imported module's derived
   interface, not its private declarations.

5. Non-importable modules

   A module whose declarations are all private or `internal` is the replacement
   for the old body-only `.kai` module: it publishes no public interface and
   cannot be imported across packages. It is still a `.kyo` source file. There
   is no separate body-only file role.

6. Target variation

   Whole-file build constraints (D390) and declaration-level `when` guards (D19)
   remain the only platform-variance mechanisms. A target may select one of
   several whole-file `.kyo` variants for a logical module. Every selected
   variant for a logical module must expose a compatible derived public
   interface; a target-dependent public surface is recorded in `.koi` through
   the existing target-keyed compatibility fields.

7. Imports

   Import syntax is unchanged from D179/D214. Imports are file-scope
   declarations that now appear once per source file. The compiler determines
   which imports feed the derived public/`internal` interface and records those
   in the `.koi` imports section; imports used only by private declarations stay
   private.

8. File-role diagnostics

   `.kyo` is the handwritten source file. `.koi` is the generated interface
   artifact and is never source. `.kai` and the inherited `.aui`/`.aum`
   extensions are rejected as handwritten Kyokai source with a diagnostic that
   names the single-file model and the `.kyo` extension.
```

**Consequences**:

- Removes interface/body duplication of signatures, contracts, doc comments, and imports.
- `.koi` becomes the only derived interface artifact; there is no handwritten interface competing with it.
- Generic body availability is simplified: a generic's definition is always present in the one source file (D82a/D82b materialization unchanged).
- Requires the visibility surface to become explicit per declaration (D538) because the file no longer signals public vs private.
- Requires an explicit representation-hiding mechanism (D539) because opacity can no longer come from "declared in `.kyo`, defined in `.kai`."
- Rewrites D518 file-role diagnostics and amends D52/D78 module-path mapping to one `.kyo` candidate per logical module.
- Implementation impact: the active Phase 3 source-role, parser-skeleton, package-discovery, target-entry, derived-interface-fact, host-test, and implementation-gated fixture migration is complete. Semantic export/opacity checks, final AST construction, `.koi` serialization, inherited-loader replacement, and standard-library/full-corpus migration remain tracked in `phase.md`.

**Rejected alternatives**:

- Keep handwritten `.kyo` + `.kai` (status quo / D382): loses on duplication, contradicts the D6/D7b/D8/D12 ceremony-reduction record, and the original rejection was a deferral rather than a defense of the second file.
- Optional handwritten interface (OCaml `.mli` style, Swift hand-authored interface): keeps the duplicate model alive and lets the two surfaces drift; `.koi` plus `kyokai koi print` already serves inspection, so a handwritten interface is a redundant second source of truth.
- Tie visibility to the file as a compilation unit (Zig style): reintroduces the "marker does nothing inside one file" confusion and conflates physical file layout with logical visibility.

### D538: Per-Declaration Visibility With Private Default **[DECIDED | SPEC_EXTRACTED | AMENDS: D17 | NAV: kyokaispec/src/language/02-lexical-syntax.md, kyokaispec/src/language/03-grammar.md, kyokaispec/src/language/04-modules-and-visibility.md, kyokaispec/src/language/05-declarations.md]**

**The question**: With the single-file model (D537), how is a declaration's visibility spelled, and what is the default when no marker is written?

**Use case**: In the two-file model, public-versus-internal was the `internal` marker in `.kyo`, and private was expressed by location: a declaration that lived only in `.kai`. Once the file no longer carries that signal, every declaration needs an explicit, source-visible visibility, and the default must be chosen so that crossing a module or package boundary is always a deliberate act.

**Current state**: D17 defined three visibility levels: public, package-`internal`, and module-private. `internal` is already a reserved keyword and an interface-only marker. `public` and `private` are not reserved keywords. The default in a `.kyo` interface was public (no marker), and private was body-only-by-location.

**Prior art**:

| System | Shape | Notes |
| --- | --- | --- |
| Rust | Private by default; `pub` exports; `pub(crate)` is package-internal. | Effective Rust Item 22 ("minimize visibility; visibility changes are hard to undo") makes private-by-default the safe default. The consistent ecosystem regret is accidental public API, which default-private prevents. |
| Swift | Per-declaration `private`/`fileprivate`/`internal`/`package`/`public`/`open`. | Validates per-declaration markers and a package-scoped middle level matching Kyokai's `internal`. |
| Zig | Private by default; `pub` to export. | Validates default-private and a single export marker. |
| Go | Capitalization exports. | Rejected for Kyokai: implicit, invisible export boundary, which is the opposite of Kyokai's make-the-boundary-visible rule. |

**Rationale**: Kyokai uses three source visibility levels written as per-declaration markers: `public`, `internal`, and module-private. A declaration with no visibility marker is module-private. `public` exports the declaration to any package that imports the module and has dependency access. `internal` restricts the declaration to modules in the same package. This makes export a deliberate, source-visible act, which matches Kyokai's core rule that authority and reach are written where the reader can see them, and matches the no-accidental-API lesson from Rust, Swift, and Zig.

Default-private is an inversion from the two-file model, where an unmarked `.kyo` declaration was public. The inversion is accepted on purpose: in a single file, a default-public rule would silently export private machinery the moment it is written next to public declarations, which is the Go-style invisible-export trap Kyokai rejects.

**Accepted shape**:

```text
1. Visibility levels and markers

   public   declaration exported to importing packages with dependency access.
   internal declaration visible only to modules in the same package.
   (none)   declaration is module-private; only the declaring module names it.

   `public` and `internal` are written as the leading declaration modifier
   before the declaration keyword. A declaration with neither marker is private.

2. Reserved words

   `public` and `private` become reserved keywords. `internal` remains reserved.
   `private` is reserved for diagnostics and future use; module-private is
   expressed by omitting a marker, and writing `private` explicitly is a
   compile-time error that names the omit-the-marker rule. (A later D-point may
   admit `private` as an explicit synonym; it is not admitted here.)

3. Default

   The unmarked default is module-private. This inverts the two-file rule where
   an unmarked interface declaration was public.

4. Visibility and opacity are orthogonal

   A visibility marker controls who may name a declaration. It does not control
   whether a type's representation is exposed; representation hiding is the
   `opaque` modifier in D539. `internal` does not change opacity, layout,
   typeclass coherence, or unsafe authority, exactly as in D17.

5. Leak rules preserved

   A `public` signature may mention only `public` names visible to the consumer.
   A `public` declaration may not leak a private or same-package `internal` name
   to an outside package except through an admitted opaque exposure (D539). This
   is the D17/type-system leak rule restated for per-declaration visibility.

6. Entry functions

   A program entry function is selected by the manifest target and the runtime
   startup contract, not by import. It does not require `public`; an unmarked
   entry function is legal because nothing imports it.

7. Workspace boundary

   `internal` is package-visible, never workspace-visible. Two packages in one
   workspace are still separate packages for `internal`.
```

**Consequences**:

- Every cross-module name becomes an explicit `public`/`internal` decision.
- Existing examples and chapters that relied on "unmarked interface declaration = public" are rewritten to mark exports explicitly.
- Reserves `public` and `private` as keywords; confirms `internal`.
- Preserves D17's package-visibility semantics and the type-system leak rule.

**Rejected alternatives**:

- Default-public plus a `private` marker: recreates Go's invisible export and violates minimize-visibility.
- File-scoped or compilation-unit-scoped visibility (Zig): conflates physical file layout with logical reach.

### D539: Opaque Representation Modifier **[DECIDED | SPEC_EXTRACTED | AMENDS: D466 | NAV: kyokaispec/src/language/05-declarations.md, kyokaispec/src/language/06-type-system.md, kyokaispec/src/toolchain/02-module-resolution-and-koi.md]**

**The question**: With the single-file model (D537), how does a module export a type's name while hiding its representation, now that opacity can no longer come from declaring the type in `.kyo` and defining it in `.kai`?

**Use case**: In the two-file model, a module published `type FileHandle: Linear;` in the interface and defined the concrete `record FileHandle ... build;` in the body. Clients saw the nominal name and universe but not the representation. In one file the representation sits beside the public name, so the source needs an explicit way to say "export the name and universe, seal the representation."

**Current state**: The declarations chapter expressed opacity through the interface opaque-type declaration plus a separate body definition. D466 defined validated wrapper types whose representation is private to the defining module. With the file split gone, both rely on a representation-hiding mechanism that no longer exists by location.

**Prior art**:

| System | Shape | Notes |
| --- | --- | --- |
| Swift | A public type with non-public stored properties; `@frozen` versus non-frozen controls whether layout is part of the ABI; `.swiftinterface` records the chosen opacity. | Direct precedent for expressing representation hiding in the single source and recording it in the generated interface. Non-frozen = full encapsulation, frozen = exposed layout. |
| Rust | `pub struct` with private fields; the type name is public, fields are private unless marked `pub`. | Validates "public name, sealed representation" through per-member visibility. |
| OCaml / Austral | Abstract type in a handwritten signature. | The mechanism Kyokai is replacing: opacity by signature, not by source marker. |

**Rationale**: Kyokai adds an `opaque` modifier that combines with a visibility marker on a type definition. `opaque` means the nominal type name and its universe are exported, but its representation (fields, variants, layout) is sealed against construction, deconstruction, and inspection from outside the defining module. This is the single-source spelling of the promise the two-file split used to make by location, and it maps onto the existing `.koi` rule that visible layout is recorded only at the opacity level the source promises. It is the non-frozen case in Swift's frozen/non-frozen split; a plain `public record` is the frozen case where fields are public API.

**Accepted shape**:

```text
1. The opaque modifier

   `opaque` is a type-definition modifier written with a visibility marker, for
   example `public opaque record`, `public opaque union`, or
   `internal opaque record`. It applies to nominal type definitions (records,
   unions, and the nominal type forms the declarations chapter admits).

2. What opaque exports

   An `opaque` type exports its nominal identity and its universe classification
   (`Free`, `Linear`, or the admitted classifier). It does not export field
   names, field types, variant shapes, or constructible representation. Outside
   the defining module, code may name the type, hold it, move it, borrow it,
   store it where its universe allows, and call visible functions over it. Code
   outside the defining module must not construct, destructure, pattern match,
   or inspect the representation unless a separate public declaration exposes
   that operation.

3. Inside the defining module

   The defining module sees the full representation and may construct,
   destructure, and pattern match the type normally.

4. .koi recording

   `.koi` records an `opaque` type's nominal identity, universe, and only the
   layout facts the opacity level promises (for example sizing facts required by
   the target/backend contract), never the constructible field/variant surface.
   This is the existing visible-opacity rule in the module-resolution chapter,
   now keyed by the `opaque` source modifier instead of by which file held the
   definition.

5. Non-opaque public types

   A `public record` or `public union` without `opaque` exports its full
   representation as public API, including fields and variants. This is the
   frozen case: changing the representation is a public API change.

6. Relationship to validated wrappers (D466)

   D466 validated wrappers are expressed as `opaque` types whose construction is
   restricted to named constructors that return recoverable validation results.
   `opaque` is the representation-hiding mechanism; D466 adds the validation and
   accessor contract on top of it.

7. Illegal forms

   `opaque` on a transparent `type alias`, on an `extern type` (already opaque
   at the C boundary), or on a non-type declaration is a compile-time error.
```

**Consequences**:

- Replaces interface-opaque-type-plus-body-definition with one source declaration.
- Folds D466 validated wrappers onto an explicit representation-hiding primitive.
- Keeps `.koi` opacity recording unchanged in substance; only the source trigger changes.

**Rejected alternatives**:

- Per-field `public` fields only (Rust style) as the sole mechanism: workable but starts finer-grained than the 1:1 replacement for the file split; whole-type `opaque` is the direct replacement and keeps one boundary, one marker. Per-field visibility may be added later by a separate D-point.
- Inferring opacity from whether any field is private: implicit and easy to get wrong; Kyokai prefers an explicit modifier.
