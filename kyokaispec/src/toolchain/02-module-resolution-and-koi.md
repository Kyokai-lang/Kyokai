# Module Resolution And Koi Artifacts

[Rikona Kurasaki / Mjoyufull]
> ProofTrace: SPEC-TOOLCHAIN-02-MODULE-RESOLUTION-AND-KOI
> Covers: This chapter is registered in the public ProofTrace evidence graph; registration does not claim implementation, conformance, or theorem completion.

Module resolution is where the written package shape becomes a language graph. By the time the type checker sees imports, the toolchain must have already answered the practical questions: which package is this, which module root is in force, which source files belong to the package, which target-specific declarations exist, and which dependency interfaces are trusted inputs.

> Trace: D19a, D52, D78, D79, D105
> Covers: The toolchain resolves package scope, module roots, source files, target selection, editions, and dependency artifacts before language checking consumes a single module graph.

This chapter specifies the toolchain side of the module boundary. The language chapter specifies what modules, imports, visibility, and name lookup mean once the graph exists. The two chapters meet at the resolved module graph and the checked interface artifact.

> Trace: D78, D79, D86, D155
> Covers: Toolchain module discovery and language name resolution are separate normative surfaces joined by explicit artifacts and graph construction.

## Logical Module Mapping

Within a package, a logical module name maps to one fixed candidate path under `[layout].module_root`. A dot in a module name is always a directory separator. If `module_root = "src"`, then `Foo` maps to `src/Foo.kyo` and `Foo.Bar` maps to `src/Foo/Bar.kyo`. Each logical module is one source file; whole-file target variants of a logical module are selected before module-graph construction as described under target selection.

> Trace: D52, D78, D537
> Covers: Kyokai maps each dotted module name to one `.kyo` source file under the explicit package module root.

There is no alternate dotted filename form such as `src/Foo.Bar.kyo`. There is no `mod.kyo` convention. There is no include path search. There is no fallback from one package's module root into another directory. One logical module path has one source spelling inside its package.

> Trace: D52, D78
> Covers: Kyokai rejects alternate module-file spellings, include-path search, and implicit fallback roots.

Prefix modules may coexist. `Foo` and `Foo.Bar` are distinct logical modules because directory segments are path segments, not implicit nested module declarations. Their coexistence is legal when each present source file declares its resolved logical module name and every importable module has its required interface.

> Trace: D78
> Covers: Prefix module names may coexist without creating nested visibility or resolution ambiguity.

A package must not contain two filesystem paths that resolve to the same logical module after canonical path normalization for the host and target rules. Case-insensitive filesystem collisions, symlink-equivalent duplicates, alternate separators, and generated-source overlays must be rejected or normalized before they can create two sources for one module.

> Trace: D78, D83, D155
> Covers: Duplicate logical modules are errors, and filesystem normalization cannot create ambiguous module identity.

## Source Discovery

For each package, the toolchain discovers source modules only under the declared module root after manifest validation. It must ignore files outside the module root unless another explicit toolchain rule names them as generated inputs, build scripts, tests, or non-source assets.

> Trace: D78, D83
> Covers: Source module discovery is confined to the package's explicit module root.

A discovered `.kyo` file is a module source file. A source file whose module declaration does not match the required module identity for its resolved logical path is rejected. A file with the retired `.kai` extension, or an old Austral extension such as `.aui` or `.aum`, is not a Kyokai source file and is rejected with a diagnostic that names the single-file model.

> Trace: D52, D78, D537
> Covers: `.kyo` is the only Kyokai source extension, the `.kai`/`.aui`/`.aum` extensions are retired, and source declarations must match resolved module identity.

A logical module has one selected `.kyo` source file. The compiler derives its importable interface: declarations marked `public` are published, while a module containing only private or `internal` declarations is non-importable and replaces the old body-only module. The toolchain rejects attempts to import a non-importable module or publish its private declarations in an external `.koi` API surface.

Downstream packages consume a dependency module through that package's `.koi` interface artifact rather than reading private source. Within the same package, full module source remains available for implementation checking, but only the derived public and `internal` surface is importable.

> Trace: D17, D52, D78, D79, D313, D537
> Covers: Each logical module is one source file whose interface is derived by the compiler, non-importable private-only modules replace body-only modules, dependency checking consumes `.koi` interfaces, and same-package source stays an implementation input outside its derived surface.

## Target And Edition Selection

The package edition is read from `[package].edition` before parsing source files. The parser, resolver, formatter, diagnostics, and documentation generator must interpret each source file according to the package's declared edition.

> Trace: D105, D243
> Covers: Source parsing and source-facing tools are edition-aware and use the package manifest edition.

Whole-file target selection happens before module-graph construction. If a package supplies platform-specific variants of a module's source file, the build target selects exactly one `.kyo` variant for the logical module before imports are resolved. The selected variant must declare the resolved module name, and every variant must expose a compatible derived interface.

> Trace: D19, D19a, D78, D390, D537
> Covers: Target-specific whole-file variant selection happens before module graph construction, preserves module identity, and requires a compatible derived interface across variants.

Declaration-level `when` guards are evaluated during source checking for the selected target. A false guard makes the declaration semantically absent from the current build. In a shared selected module, overlapping active definitions for the same declaration and zero active definitions where one is required are compile-time errors.

> Trace: D19, D19a, D123
> Covers: Declaration-level target guards remove inactive declarations and reject overlapping or missing active definitions for the selected build target.

The language does not have body-level target branching. A target-specific implementation difference must be expressed through whole-file selection, declaration-level `when` guards, or typeclass abstraction.

> Trace: D19, D123
> Covers: Kyokai rejects body-level inline target branching and keeps platform variation at module, declaration, or abstraction boundaries.

## Import Graph Construction

The toolchain parses interface imports to construct the package module graph. Imports are file-scope only and may target modules in the same package or modules exported by dependency packages. A module import that cannot be resolved to exactly one visible interface is a compile-time error.

> Trace: D78, D79, D179, D214
> Covers: Import graph construction uses file-scope imports and requires each imported module to resolve to one visible interface.

Imports may also target installed first-party standard-library modules and installed first-party Bridge modules. Standard-library modules live under `Kyokai.*`; official Bridge entries live under `Kyokai.Bridge.*`. The installed toolchain supplies their checked interface artifacts and admission metadata. They do not come from the current package's module root, from `[dependencies]`, from the package resolver, or from a vendored dependency directory.

> Trace: D1, D78-D79, D152, D529
> Covers: Standard-library and Bridge imports resolve through installed first-party interface roots rather than package-source discovery or dependency vendoring.

Same-package imports may see public and internal declarations from the imported module's interface. Cross-package imports may see only public declarations recorded in the dependency interface artifact. Private (unmarked) declarations are never candidates for import graph construction.

> Trace: D17, D78, D79
> Covers: Import graph visibility follows package boundaries, and private declarations never enter the import graph.

Bridge entry admission status is part of the imported artifact facts. Experimental, compatibility, transitional, and internal Bridge entries cannot masquerade as stable public modules. If a selected toolchain lacks a requested Bridge entry, target contract, native library, or compatibility class, module resolution or build planning reports that missing bridge fact directly instead of falling back to a package of the same name.

> Trace: D80, D149, D157, D229, D529
> Covers: Bridge imports preserve admission status and fail explicitly when installed support or target/native prerequisites are absent.

The import graph must be deterministic. The same manifest, lockfile, target, edition, source content, generated-source inputs, and compiler compatibility class must produce the same resolved module graph or the same diagnostics. Host directory iteration order, filesystem case behavior, and import declaration order must not change the selected graph.

> Trace: D78, D83, D214
> Covers: Module graph construction is deterministic and reproducible, independent of host iteration order and import order.

Module import graphs are acyclic. A module cannot import itself directly or indirectly through `.kyo` source, generated `.koi` interface artifacts, or re-export chains. The compiler rejects a cycle before type checking and prints the complete cycle path. A module calls another module only through its derived interface; a module's private declarations are never an import target from another module.

> Trace: D78, D79, D155
> Covers: Import cycles are rejected under the single-file module model, and another module's private declarations are not an import mechanism.

## Koi Artifact Role

A `.koi` artifact is the checked interface product of a package. It is not an incremental cache blob and not an implementation detail. Downstream checking, documentation, auditing, separate compilation, and reproducible builds may depend on its specified contents and compatibility fields.

> Trace: D79, D83, D86
> Covers: `.koi` is a versioned package interface contract artifact, not an opaque cache.

A `.koi` artifact records at least the producing compiler version, language edition, `.koi` format version, target contract, package identity, package version, package module set, hashes or fingerprints of interface inputs, visibility-marked declarations, type definitions at their visible opacity level, typeclass definitions, legal instances, generic metadata needed for downstream checking and materialization, and any compatibility fields required by generated-code materialization and the generics chapter.

> Trace: D79, D82a, D82b, D83, D105
> Covers: `.koi` artifacts record identity, compatibility, interface declarations, visible type/typeclass/instance data, hashes, and generic metadata needed by downstream compilation.

A `.koi` artifact may record internal declarations and internal instances because same-package incremental checking and documentation may need them. A downstream package outside the producing package must treat internal entries as nonexistent. Private unmarked declarations that are not part of the package interface never appear in `.koi`.

> Trace: D17, D79
> Covers: `.koi` preserves internal metadata for same-package use while excluding private declarations and hiding internals from external consumers.

A `.koi` artifact records enough information for dependency consumers to typecheck against public declarations without reading dependency source bodies. It does not grant access to private implementation, unsafe internals, or hidden source files.

> Trace: D17, D79, D245
> Covers: Dependency consumers typecheck against interface artifacts, not private source or unsafe implementation details.

## Koi Binary Interface

A `.koi` file uses the canonical Koi Binary Interface container, version `KBI-1`. The binary file is the artifact authority. Human-readable JSON or text produced from it is a derived view and must not be treated as a second artifact format.

> Trace: D79, D83, D265
> Covers: `.koi` has one canonical binary artifact format and derived inspection views are not separate authorities.

The first bytes of a `KBI-1` file are the magic bytes `0x4B 0x4F 0x49 0x0A`, spelling `KOI\n`, followed by `container_major: u16`, `container_minor: u16`, `section_count: u32`, and `section_table_offset: u64`. Fixed-width integers in the container are little-endian unsigned integers. Strings are UTF-8 byte strings with unsigned length prefixes and no reader-side normalization.

> Trace: D79, D83, D265
> Covers: The `.koi` container header, integer encoding, and string encoding are fixed.

The section table is sorted by numeric section id. Duplicate section ids are illegal. Unknown required sections make the artifact unsupported. Unknown extension sections are skipped only when the KBI compatibility table admits that section version. Every skipped extension section remains covered by artifact hashes.

> Trace: D79, D83, D265
> Covers: Section ordering, duplicate handling, and unknown-section handling are deterministic and versioned.

`KBI-1` requires these sections:

| Id | Section | Required Contents | Trace |
| ---: | --- | --- | --- |
| 1 | `manifest` | Package identity, package version, edition, module root, workspace/package owner facts. | D78, D105, D265 |
| 2 | `producer` | Compiler version, compiler compatibility classes, KBI version, diagnostic schema version when the artifact records diagnostic metadata. | D79, D265 |
| 3 | `target` | Target triple, target contract hash, C-toolchain compatibility class when it affects materialization, and CPU-feature baseline if it affects interface shape. | D80, D149, D265, D530-D532 |
| 4 | `sources` | Module set, source-origin records, source-file hashes, selected whole-file variant hashes where interface-affecting. | D52, D78, D83, D265 |
| 5 | `imports` | Dependency package identities, dependency `.koi` hashes, lockfile dependency ids. | D51, D79, D83, D265 |
| 6 | `declarations` | Visibility-marked public/internal declaration graph. | D17, D79, D265 |
| 7 | `types` | Nominal type ids, universes, visible opacity, visible layout facts. | D42, D79, D265 |
| 8 | `typeclasses` | Typeclass definitions, associated types, method surfaces, default-method availability. | D82, D182, D265 |
| 9 | `instances` | Legal exported/internal instances and coherence keys. | D79, D82, D265 |
| 10 | `generics` | Generic signatures and materialization metadata required for downstream checking/code materialization. | D82a, D82b, D265 |
| 11 | `contracts` | `require`/`ensure` surfaces, failure summaries, capability requirements. | D53, D85, D265 |
| 12 | `unsafe_audit` | Unsafe modules, unsafe contracts, FFI surfaces, capability audit surface. | D20, D150, D245, D265 |
| 13 | `docs` | Documentation comment hashes and doc extraction metadata. | D218, D265 |
| 14 | `hashes` | Canonical section hashes and whole-artifact hash. | D83, D265 |

> Trace: D17, D20, D42, D51-D53, D78-D80, D82-D82b, D83, D85, D105, D149-D150, D182, D218, D245, D265
> Covers: `KBI-1` required sections cover identity, provenance, target, sources, imports, declarations, types, typeclasses, instances, generics, contracts, unsafe audit, docs, and hashes.

## Koi Semantic Contents

A `.koi` artifact represents the checked interface graph after parsing, name resolution, target selection, declaration-guard evaluation, type checking, typeclass checking, contract checking, capability checking, and unsafe-audit coverage checking for the selected target/profile inputs that affect interface shape.

> Trace: D19, D29, D53, D79, D105, D150, D245, D265
> Covers: `.koi` stores checked interface semantics, not unchecked source text.

A `.koi` artifact does not preserve unchecked source syntax, comments except through documentation metadata, private declarations, private statement bodies, or compiler memory layouts. It stores generic body materialization metadata only where the generics contract requires downstream packages to materialize checked generic code without reading upstream source.

> Trace: D17, D79, D82b, D218, D265
> Covers: `.koi` excludes private source and unchecked syntax while allowing explicitly versioned generic materialization metadata.

Every declaration record stores declaration kind, module path, visibility, source span fingerprint when available, canonical name, type and universe information, generic parameters, `where` obligations, contract summary, capability requirements, unsafe marker when present, deprecation or compatibility metadata, and links to referenced type/typeclass/instance ids.

> Trace: D17, D29, D53, D79, D85, D158, D189, D265
> Covers: Declaration metadata is explicit enough for downstream checking, documentation, diagnostics, and SemVer/audit tools.

Every declaration id is derived from package id, logical module path, declaration kind, canonical source name, generic parameter shape, and a disambiguating ordinal where Kyokai admits same-name overload families. Declaration ids must not include filesystem traversal order, host paths, memory addresses, or unstable hash iteration order.

> Trace: D78, D83, D214, D265
> Covers: Declaration identity is deterministic and independent of host iteration or memory layout.

Types are encoded as canonical typed graph nodes, not as pretty-printed source strings. Nominal identities, universe classification, type parameters, const parameters, associated-type projections, borrow/reference types, arrays, built-ins, records, unions, extern records, packed records, and opaque types each have explicit tags. Visible layout information is recorded only at the opacity level promised by the source interface and ABI/layout rules.

> Trace: D6, D24, D33, D42, D55, D79, D159, D188, D265
> Covers: Type metadata is structured, canonical, and visibility/opacity aware.

Each type record stores one task-boundary classification: `task_local` or `task_transfer`. A generic user type is `task_local` unless its declaration records `task_transfer structural`. For structural opt-in, `.koi` records the opt-in and the stored-field obligations needed to classify each concrete substitution. For an opaque, unsafe-backed, target-backed, or foreign-backed type, `.koi` records the explicit unsafe transfer contract identity instead of guessing from hidden representation. Public records and internal records needed for same-package checking carry these facts; downstream consumers treat package-internal facts as invisible outside the package.

> Trace: D248, D280, D265
> Covers: `.koi` records task-local defaults, structural-transfer opt-in, post-substitution obligations, and explicit unsafe transfer-contract provenance.

Typeclass records store method signatures, associated types, default method availability, and coherence identity. Instance records store dispatch type, implementing package/module, satisfied obligations, associated type bindings, exported/internal visibility, and overlap/coherence key. Instance bodies are not exposed except through generic materialization metadata explicitly admitted by the generics contract.

> Trace: D79, D82, D82b, D182, D216, D265
> Covers: Typeclass and instance metadata supports static dispatch and coherence without exposing hidden runtime dictionaries.

The generics section records enough checked metadata for downstream packages to typecheck and materialize required generic bodies without re-parsing upstream source. This metadata is not a runtime dictionary and must not encode hidden dynamic dispatch. It records checked generic body IR or another versioned materialization description, compatibility class, referenced declarations, captured constants/comptime values, and invalidation fingerprints.

> Trace: D18, D82, D82a, D82b, D83, D144, D265
> Covers: Generic materialization data is explicit, versioned, cache-invalidatable, and still static-dispatch only.

## Koi Canonicalization And Inspection

All maps inside `.koi` are serialized in bytewise sorted key order. Lists whose source order is semantically meaningful preserve source order. Lists whose order is not semantically meaningful use canonical sorted order. Hashes are computed over normalized section bytes after path remapping and before transport compression.

> Trace: D83, D265
> Covers: `.koi` serialization and hashing are deterministic.

Compression is not part of canonical `KBI-1` bytes. A compressed `.koi` transport wrapper records wrapper version, compression algorithm ID, uncompressed length, compressed length, canonical uncompressed hash, wrapper checksum, and decompression resource limits. Tools decompress, verify the canonical hash, and then operate on canonical KBI bytes. Unknown algorithms, resource-limit violations, malformed streams, and hash mismatches are hard errors. Compression never changes `.koi` identity or compatibility meaning.

> Trace: D79, D83, D265
> Covers: Compression is a verified transport wrapper and cannot change artifact identity or compatibility meaning.

The toolchain provides `kyokai koi verify <file>`, `kyokai koi print <file> --format json`, `kyokai koi print <file> --format text`, and `kyokai koi diff <old> <new>`. `verify` checks container structure, required sections, section hashes, compatibility fields, and deterministic ordering. `print` emits a derived view. `diff` classifies public API, internal API, contract, generic metadata, target, and hash changes.

> Trace: D29, D79, D83, D223, D265
> Covers: `.koi` artifacts are inspectable, verifiable, and diffable without making derived text authoritative.

A compiler must reject a `.koi` with malformed container structure, unsupported required section, duplicate section id, invalid UTF-8 string, noncanonical ordering, hash mismatch, unsupported KBI major version, edition mismatch, target contract mismatch, dependency hash mismatch, missing required declaration/type reference, or visibility violation.

> Trace: D29, D79, D83, D105, D265
> Covers: Malformed or incompatible `.koi` artifacts fail with explicit diagnostics.

A `.koi` artifact is not a stable ABI promise by itself, not an archive of object code, not a source distribution format, and not a documentation format. It must not expose private implementation merely because exposing it would make an early compiler easier to write.

> Trace: D17, D79, D139, D218, D265
> Covers: `.koi` non-goals preserve the boundary between interface metadata, binary ABI, source distribution, docs, and private implementation.

## Koi Compatibility

A compiler may consume a `.koi` artifact only when the language edition, KBI major version, target contract, built-in/stdlib interface identity required by the package, dependency artifact hashes, and explicitly versioned generic/codegen compatibility fields match exactly. The producing compiler version is recorded for provenance and diagnostics, but a compiler-version mismatch alone is not automatically incompatible if the compatibility-class fields match.

> Trace: D79, D83, D105, D265
> Covers: `.koi` compatibility is exact over edition, KBI major version, target contract, dependency artifact hashes, required built-in/stdlib identity, and versioned generic/codegen contracts, with compiler version recorded separately for provenance.

A compiler may reject a `.koi` format version it does not implement. It must not reinterpret an unsupported artifact as though it were a best-effort cache. Rejection must produce a diagnostic that names the unsupported field or format version when known.

> Trace: D79, D29
> Covers: Unsupported `.koi` versions are explicit diagnostics, not silent best-effort reinterpretations.

Mixed-edition workspaces are legal as repository structure, but cross-edition `.koi` consumption is not implied. Under the current design, a package must not consume a `.koi` artifact produced for a different language edition.

> Trace: D79, D105, D243
> Covers: Mixed-edition workspaces are structurally legal, but `.koi` dependencies require exact language-edition match.

## Separate Compilation Boundary

Package-level separate compilation is the required artifact boundary. A dependency package can be checked and compiled to reusable artifacts, and downstream packages can consume its `.koi` without rechecking the dependency's private source bodies. Module-level incremental recompilation inside a package is permitted as an optimization, but it is not the public dependency boundary.

> Trace: D78, D79, D83
> Covers: Separate compilation is package-level first, with module-level incremental behavior treated as an internal optimization.

Compiled code artifacts for a package are separate from `.koi` interface artifacts, but their identities must be tied to the same package, edition, target, source, dependency, and compatibility inputs used for reproducible builds. A downstream package must not link code whose interface artifact is incompatible with the checked dependency interface it used.

> Trace: D79, D83, D139
> Covers: Code artifacts and interface artifacts share reproducible identity inputs, and linking must not pair incompatible code with a different checked interface.

Generic and typeclass materialization metadata stored in `.koi` is governed by the generics and generated-C lowering chapters. The artifact must not hide runtime dictionaries or erased trait-object machinery that the language rejects. If downstream compilation needs generic bodies or materialization descriptions, the `.koi` compatibility contract must state exactly what is available.

> Trace: D79, D82, D82a, D82b, D193
> Covers: `.koi` generic metadata must respect Kyokai's static-dispatch and no-hidden-runtime-dictionary model.

## Diagnostics And Auditing

Module-resolution diagnostics must name the package, logical module name, source path or artifact, import declaration, and visibility rule involved when that information is available. A diagnostic must not report only a filesystem failure when the real error is module identity, package visibility, edition mismatch, duplicate logical modules, or incompatible artifact format.

> Trace: D29, D78, D79, D214
> Covers: Module-resolution diagnostics identify the relevant package, module, import, visibility, and artifact rule.

Audit tooling must be able to list, per package, modules marked `Unsafe_Module`, unsafe contracts, foreign blocks, public declarations exposed by unsafe modules, dependencies with unsafe surfaces, and `.koi` artifact provenance. This audit report reads module/package metadata; it does not change language visibility or grant authority.

> Trace: D20, D79, D245, D255
> Covers: Audit tooling exposes unsafe module and artifact provenance while preserving ordinary visibility and capability rules.

Documentation generation must follow visibility. Public docs for external consumers show public declarations. Same-package/internal docs may include internal declarations when explicitly requested. Private (unmarked) declarations are excluded from public docs by default.

> Trace: D17, D29, D79
> Covers: Documentation output respects public/internal/private visibility and uses `.koi` metadata where appropriate.

## Interface Artifacts, Not Compiler Memory

[Rikona Kurasaki / Mjoyufull]
A `.koi` file is a checked package-interface artifact, not an opaque incremental cache. It records names, visibility, types, instances, edition, target identity, contracts, and the generic metadata required for downstream checking without exposing private implementation state.

> Trace: D79, D83
> Covers: `.koi` makes package interfaces inspectable, reproducible, and consumable without exposing private implementation.

## KBI-1 Semantic Payload Registry

The `KBI-1` header and required top-level section IDs are defined once in **Koi Binary Interface** above. This subsection does not define a second header or a second container schema. It fixes the structured payload records carried inside those required sections and the extension-section registry used by compatible readers.

The required sections carry string-table entries, symbols, exports, type declarations, value declarations, generics, constraints, typeclasses, instances, imports, visibility, contracts, capability requirements, implicit-completion records, stable ABI records, unsafe and audit summaries, const-generic values, receiver-callable metadata, diagnostic metadata, and provenance. A payload kind lives in the top-level section whose table row above names its semantic family. Extension sections state ID, schema version, flags, byte length, canonical hash, required or extension bit, and compatibility policy.

Unknown required sections cause consumer rejection. Unknown extension sections are skipped only when the KBI compatibility table admits that section version. `.koi diff` classifies changes as `compatible`, `additive`, `breaking`, `target-restricted`, `feature-restricted`, `provenance-only`, `docs-only`, or `unknown-incompatible`.

> Trace: D311, D364, D397, D461, D497
> Covers: `KBI-1` has one container header and one top-level section table; the payload registry enriches those sections without creating a competing schema.

## Edition Boundary

Cross-edition `.koi` consumption is rejected unless a KBI normalization table explicitly admits the producing edition, consuming edition, normalized sections, erased differences, preserved differences, and compatibility result. No cross-edition normalization table is admitted for the initial edition. A mixed-edition workspace can exist as repository structure without implying cross-edition dependency compatibility.

> Trace: D438, D537
> Covers: `.koi` remains edition-specific until a reviewed normalization table defines an exact cross-edition mapping.

## Compressed KBI Transport

A compressed `.koi` wrapper is transport only. The wrapper records algorithm, version, uncompressed length, compressed length, canonical uncompressed hash, wrapper checksum, and decompression resource limits. Canonical KBI identity is the uncompressed bytes.

> Trace: D423, D446, D480
> Covers: Compression changes transport representation without changing canonical interface identity.

## Shared KBI Reader And File Roles

The compiler, package manager, docs generator, audit tool, Analysis Server, SemVer checker, and cache use the same `.koi` parser. `.kyo` and `.koi` role diagnostics reject handwritten `.koi`, the retired `.kai` extension, attempts to compile `.koi` as source, and stale generated artifacts. A `.kyo` file is the handwritten module source; a `.koi` file is generated checked interface data, not a source file.

> Trace: D79, D265, D518, D537
> Covers: Every tool consumes one `.koi` parser and reports file-role mistakes, including the retired `.kai` extension, without pretending generated artifacts are editable source.

## KBI-1 Container Framing

KBI-1 begins with a fixed header that identifies the magic, container major and
minor, byte order, header size, directory offset, section count, directory-entry
size, required/optional framing flags, total file length, and whole-artifact
digest algorithm and bytes. All integers have one fixed byte order. Readers
perform checked arithmetic before slicing, allocating, or converting to host
integer widths.

Each fixed-size directory entry records numeric section ID, section-schema
major and minor, flags, alignment, offset, stored length, logical length,
payload digest algorithm and bytes, and reserved-zero fields. Sections must be
inside the file, non-overlapping, correctly aligned, and ordered by numeric
section ID. Duplicate IDs, reserved flag bits, invalid alignment, unsupported
required schemas, and digest mismatch are malformed. Unknown framing flags
fail closed. Digest coverage states which self-referential digest bytes are
zeroed or excluded.

`entry_size` equals the published base size. A later container minor can
increase it only through a canonical, hash-covered extension tail whose old
reader behavior is specified. Optional future information uses registered
extension sections after base framing succeeds. Unknown optional sections can
be skipped; unknown required sections, required flags, entry tails, or framing
semantics fail closed. No extension redefines base offsets, lengths, alignment,
digests, section identity, overlap checks, or validation order. Such a change
requires a new container major.

> Trace: D573
> Covers: A reader can bounds-check and authenticate every KBI-1 section from fixed framing before interpreting semantic payloads.

## KBI-1 Semantic Byte Grammar

One machine-readable schema assigns stable numeric tags to every KBI value
kind, type node, declaration kind, visibility, universe, constraint,
contract/effect fact, audit fact, and reference. It fixes the encodings of
signed and unsigned integers, lengths, booleans, byte strings, UTF-8 strings,
optionals, tagged unions, records, lists, maps, and field order. Encoders use
the shortest admitted integer and length form; readers reject non-minimal forms.

Strings contain valid UTF-8 and receive no reader normalization. The schema
distinguishes identifiers normalized before serialization from exact source
bytes. Each reference names its target table/domain and width. Forward
references, cycles, and recursion are legal only for enumerated graph kinds;
dangling, cross-domain, duplicate, and forbidden cyclic references are
malformed. Semantically unordered collections use one canonical byte order and
reject duplicates. Source-ordered collections preserve source order.

An unknown value tag in a required section is incompatible. Extension payloads
belong in registered extension sections. Generated encoders/decoders are
checked against the schema and an independently written decoder. Text and JSON
views are derived and non-authoritative.

> Trace: D574
> Covers: KBI-1 has one canonical tagged payload grammar with closed reference domains and minimal encodings.

## Hostile-Input Budgets

KBI decoding is streaming. It checks framing, arithmetic, digests, and policy
budgets before allocating payload-sized structures. The decoder names ceilings
for file and section bytes, section count, strings, records, graph nodes and
edges, nesting, references, generic bodies, spans, diagnostic metadata,
cumulative allocation, and validation work.

Universal representation ceilings prevent integer and offset overflow. Lower
practical budgets come from versioned target/toolchain policy and enter build
and cache identity when they change acceptance. Exhaustion produces
`artifact-too-complex`, distinct from malformed bytes, unsupported schema,
compatibility failure, and digest failure.

Readers do not recurse over attacker-controlled depth on the host stack, use
unchecked count multiplication, perform quadratic duplicate search, or render
unbounded diagnostics. Compiler and Analysis Server use the same verification
library and budgets unless a named read-only inspection profile is stricter.

> Trace: D575
> Covers: KBI parsing is streaming, allocation-bounded, work-bounded, and explicit about malformed, incompatible, and over-budget artifacts.

## Stability, Inspection, And Decoder Admission

KBI-1 is stable only when its published container and payload schemas leave no
unspecified bytes, tags, fields, reference domains, digest coverage, or resource
classes. A compatibility table classifies each container-minor and section
schema change as additive, skippable, required, incompatible, or
normalization-only. Required semantic changes increment the applicable major.

Skipped extension sections remain hash-covered. Only a lossless rewriting tool
that promises preservation retains unknown sections byte-for-byte. The
conformance corpus contains canonical bytes and semantic views, deterministic
re-encoding, each malformed/budget class, old/new reader-writer matrices, and
cross-edition rejection. At least one decoder independent of the production
schema-generated parser must agree before stability is claimed.

Clean builds on supported hosts and admitted toolchains produce byte-identical
KBI-1 for identical normalized inputs. `koi verify`, `koi print`, and `koi
diff` distinguish container, schema, compatibility, canonicality, hash,
resource, and semantic failures in stable machine output. Migration never
overwrites the only artifact and records source/target schemas, tool identity,
lossy fields, compatibility result, and output digest.

> Trace: D576
> Covers: KBI stability requires closed schemas, independent decoding, hostile corpora, deterministic bytes, explicit compatibility, and non-destructive migration.
