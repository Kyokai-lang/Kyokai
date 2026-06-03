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

       <out-root>/<target-triple>/<profile>/<backend>/<package-name>/

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

       <cache-root>/<toolchain-compat>/<target-triple>/<profile>/<backend>/<package-name>/

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
   to whether they are user-visible declared outputs. A generated `.kyo` or `.kai` file
   used as source must have source-origin metadata tying it to the generator declaration.
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
       4  sources         module set, source-origin records, interface/body hashes
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
   except through doc metadata. It does not preserve private body declarations.
   It does not preserve statement bodies except where generic materialization
   metadata is explicitly required by the generics contract.

5. Visibility boundary

   Public declarations are visible to downstream packages.
   Internal declarations may be present for same-package tooling and incremental
   checking but must be ignored by downstream packages outside the producing
   package. Private `.kai` body declarations never appear in `.koi` unless they
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
       backend/generic materialization compatibility class
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
- Keeps private `.kai` body declarations out of downstream package interfaces.
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
