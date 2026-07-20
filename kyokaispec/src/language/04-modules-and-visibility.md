# Modules And Visibility

[Rikona Kurasaki / Mjoyufull]
> ProofTrace: SPEC-LANGUAGE-04-MODULES-AND-VISIBILITY
> Covers: This chapter is registered in the public ProofTrace evidence graph; registration does not claim implementation, conformance, or theorem completion.

Kyokai retains Austral's interface-first module contract and removes the handwritten interface/body pair. A module has one handwritten `.kyo` source file. The compiler derives its importable interface from checked declarations in that file. Package boundaries are explicit, every declaration carries its visibility, `internal` has package-defined reach, and imports follow one mechanical lookup rule.

> Trace: D5, D17, D52, D78, D86, D537, D538
> Covers: Kyokai keeps interface-first modularity but replaces the handwritten interface/body pair with one `.kyo` source file, per-declaration visibility, package-visible `internal`, and deterministic package-rooted module resolution specified in the Kyokai spec itself.

A Kyokai module is the language-level unit named by a dotted module path such as `Kyokai.Core.Result` or `App.Main`. A module is written in exactly one handwritten source file with the `.kyo` extension: `Name.kyo` holds the whole module, its public surface and its private implementation in one place. The compiler derives the importable interface from that file. A module whose declarations are all private or `internal` publishes no public interface and cannot be imported from another package; it is still one `.kyo` file. A dependency may also provide a checked `.koi` interface artifact instead of source text, as specified by the toolchain chapter.

> Trace: D52, D78, D79, D313, D537
> Covers: Modules are named language units, each is one `.kyo` source file, the compiler derives the importable interface, a module with no public declarations is non-importable, and `.koi` artifacts provide checked package interface contracts for downstream compilation.

The module declaration inside the source file must match the logical module path assigned by package module resolution. If `Foo.Bar` maps to `src/Foo/Bar.kyo`, that file must declare `module Foo.Bar is ... seal;`. There is no separate `module body` header. A mismatch is a compile-time error before name resolution inside the module proceeds.

> Trace: D52, D78, D537
> Covers: The declared module name must match the manifest-rooted single-file mapping, and the retired `module body` header is not part of accepted Kyokai.

## The Module Source File

One `.kyo` file holds the entire module: constants, types, records, unions, capabilities, functions, typeclasses, instances, generators, and the other declarations the declaration chapter admits. Each declaration carries its own visibility marker and, where it has one, its own body. There is no second file and no handwritten interface to keep in sync.

> Trace: D17, D52, D78, D537
> Covers: A module's declarations and their implementations live in one source file; the two-file interface/body split is retired.

The compiler extracts the importable interface surface from that file: the `public` and `internal` declarations under D538, recorded at the representation level each declaration promises under D539. It records that surface as the `.koi` artifact. `.koi` is the checked, separately compiled package interface; it is generated from the single source file, never handwritten, and is never higher authority than the source. A declaration with no visibility marker is module-private and never enters the derived interface.

> Trace: D17, D79, D537, D538, D539
> Covers: The importable interface and the `.koi` artifact are derived by the compiler from the one source file, scoped by per-declaration visibility and opacity, and private declarations are excluded.

A module's interface can be checked, recorded, and consumed before its private implementation is checked. A module that imports another module typechecks against the imported module's derived interface surface, not against its private declarations. This is the old Austral modularity rule carried forward: clients depend on contracts, not implementation rooms they cannot enter. The contract now lives in one file the compiler defends, instead of a second file an author maintained by hand.

> Trace: D5, D78, D79, D537
> Covers: Kyokai preserves interface-first checking; clients typecheck against the derived interface or `.koi`, not against private source, and the derived interface is the single source of the contract.

Because there is no separate interface to satisfy, the old interface/body divergence errors are gone: one source file cannot disagree with itself about a signature. What remains is the export-consistency rule. A `public` or `internal` declaration must not expose a name the consumer cannot see, and an `opaque` type must not leak its representation. Each whole-file target variant of a logical module (D390) must expose a compatible derived interface; a target-dependent public surface is recorded in `.koi` through the target-keyed compatibility fields. The precise per-declaration checks live in the later declaration, type, contract, and unsafe chapters.

> Trace: D17, D53, D78, D79, D155, D390, D537, D539
> Covers: Single-file modules remove interface/body divergence; export-consistency, opacity leak, and target-variant interface compatibility are the remaining cross-boundary checks, resolved by the relevant normative chapters.

## Visibility Levels

Kyokai has exactly three source visibility levels, each written as a leading marker on the declaration.

| Visibility | How It Is Written | Who May Name It |
| --- | --- | --- |
| Public | declaration prefixed `public` | Any package that imports the module and has dependency access to the package. |
| Internal | declaration prefixed `internal` | Only modules in the same package. |
| Private | declaration with no visibility marker | Only the declaring module. |

> Trace: D17, D78, D538
> Covers: Kyokai visibility is public, package-internal, or module-private, written per declaration; there is no workspace visibility and no path-relative visibility lattice.

A declaration with no visibility marker is module-private. Private is the default on purpose: in one file, a default-public rule would export private machinery the instant it is written next to public declarations, which is the invisible-export trap Kyokai rejects. Export is therefore always an explicit, source-visible act. `public` and `private` are reserved keywords and `internal` remains reserved. Writing `private` explicitly is a compile-time error that names the omit-the-marker rule; a later D-point may admit `private` as a synonym, but it is not admitted now.

> Trace: D17, D78, D538
> Covers: The unmarked default is module-private; `public`/`private`/`internal` are reserved; explicit `private` is rejected with a guiding diagnostic.

`internal` restricts a declaration to modules in the same package. It changes who may name a declaration; it does not change whether a type's representation is opaque or transparent (that is the `opaque` modifier, D539), does not change layout, does not change typeclass coherence, and does not grant unsafe authority.

> Trace: D17, D20, D245, D539
> Covers: `internal` is a package-visibility marker and does not alter opacity, layout, coherence, or unsafe authority.

Workspace membership does not widen visibility. Two packages in the same workspace are still separate packages for `internal`. A package must not import another package's internal declaration merely because both packages are listed in the same `[workspace].members` array.

> Trace: D17, D78
> Covers: `internal` is package-visible, never workspace-visible.

An internal or private declaration cannot be surfaced across a package boundary by import tricks, aliasing, documentation generation, `.koi` consumption, or a later public declaration that simply exposes the same name. Public APIs may mention only declarations that are public to the consuming package. If a public declaration's signature would mention an internal or private type from the same package, that public declaration is not importable outside the package unless the type is exported through the `opaque` representation-hiding form defined in the declaration and type chapters.

> Trace: D17, D79, D229, D539
> Covers: Internal and private declarations cannot leak through imports, artifacts, docs, or public signatures as accidental external API, except through an admitted `opaque` exposure.

A program entry function is selected by the manifest target and the runtime startup contract, not by import. It does not require `public`; an unmarked entry function is legal because nothing imports it.

> Trace: D78, D538
> Covers: The program entry function is chosen by manifest/runtime contract rather than export, so it needs no visibility marker.

## Representation Visibility

Visibility controls who may name a declaration; it does not by itself control whether a type's representation is visible. A `public record` or `public union` exports its fields or variants as public API, so changing that representation is a public API change.

A type marked `opaque`, for example `public opaque record`, exports only its nominal identity and universe classification. Outside the defining module, its representation is sealed against construction, destructuring, pattern matching, and inspection. Inside the defining module, the representation is fully visible. The declarations and type-system chapters specify the `opaque` modifier, its universe interaction, and its `.koi` recording; this chapter establishes that representation visibility is orthogonal to name visibility.

> Trace: D17, D466, D539
> Covers: Name visibility and representation visibility are orthogonal; `opaque` is the representation-hiding mechanism and full rules live in the declarations and type-system chapters.

## Imports

Imports are file-scope declarations and appear once per source file, before the module's declarations. There are no function-local imports, block-local imports, expression-local imports, wildcard imports, `open`, `using namespace`, or import-order priority rules.

> Trace: D78, D179, D214
> Covers: Imports are file-scope only and Kyokai rejects wildcard/open imports and import-order-dependent meaning.

Kyokai has exactly three import forms:

```kyokai
import Foo.Bar;
import Foo.Bar as Bar;
import Foo.Bar (baz, qux as localQux);
```

The first form introduces the module path for qualified access. The second introduces the same module for qualified access through the alias. The third introduces only the listed direct exports as unqualified names, applying each `as` rename before collision checking.

> Trace: D179, D214
> Covers: Kyokai imports support qualified module access, module aliases, and selective unqualified imports with per-name renaming.

The compiler records the imports that feed the public or `internal` interface in the `.koi` imports section; imports used only by private declarations stay private and do not appear in the derived interface.

> Trace: D79, D537
> Covers: The derived interface records only the imports its public/`internal` surface depends on; private-only imports are not exported.

The official Bridge collection uses ordinary imports under the reserved `Kyokai.Bridge.*` namespace. Bridge modules have no special import syntax, no wildcard privilege, and no ambient authority. When installed, the toolchain supplies them as first-party checked interface roots rather than package dependencies; their project admission evidence does not alter import semantics.

> Trace: D1, D17, D78-D79, D211, D529
> Covers: Bridge modules use ordinary import and visibility rules while resolving from installed first-party bridge interfaces instead of package dependencies.

Selective imports name direct exports of the imported module only. They do not recursively import exports from modules that the imported module imports, and they do not create transitive namespace injection. If code wants both qualified module access and unqualified selected names, it writes both imports explicitly.

> Trace: D179, D214
> Covers: Selective imports are direct and non-transitive, and qualified access is separate from unqualified member import.

A qualified module import does not introduce each exported declaration as an unqualified name. A selective import does introduce unqualified names. If two imports would introduce the same unqualified name after renaming, the source file is ill-formed at the import site. Import order never chooses the winner.

> Trace: D179, D214
> Covers: Qualified imports avoid unqualified collisions, selective import collisions are compile-time errors, and import order has no semantic effect.

Built-in language names cannot be introduced or shadowed by imports. This includes `Ok`, `Err`, `Some`, `None`, `true`, `false`, `target`, and the built-in type and target descriptor names specified in the built-ins chapter. A selective import or alias that would collide with a protected built-in name is a compile-time error.

> Trace: D24, D214
> Covers: Built-in language names are protected from import shadowing.

## Name Lookup

Name lookup starts from lexical scope, then file-scope imports, then qualified module paths where the program writes a qualified name. A name that is not in scope is a compile-time error. A name that resolves to more than one candidate is a compile-time error unless the source disambiguates with a qualified path or explicit import rename.

> Trace: D60, D179, D214, D254
> Covers: Kyokai name lookup is lexical and import-explicit; missing names and ambiguous names are compile-time errors.

No still-live binding may be shadowed by another binding, pattern binding, parameter, declaration, or import-introduced unqualified name in the same lookup reach. This rule is especially important for linear values: a language that lets one name hide another can make ownership obligations disappear from the reader's eyes.

> Trace: D60
> Covers: Kyokai rejects shadowing of still-live bindings, including shadowing introduced by patterns or imports.

Qualified access through `Foo.Bar.name` may name only declarations visible to the current package. From a different package, only public declarations are visible. From the same package, public and internal declarations are visible. Private unmarked declarations are not visible through qualified access from any other module.

> Trace: D17, D179, D214
> Covers: Qualified access respects package visibility and never exposes private module-local declarations.

UFCS receiver-module lookup is not a fourth import form. It is a narrow fallback used only after ordinary imported-name lookup fails, and it searches only the receiver type's defining module or the explicit owner of a compiler-known receiver surface. It does not search the dependency graph, repair import collisions, or act like C++ argument-dependent lookup.

Only an exported `receiver function` declaration participates in that fallback. Its first parameter must be an owned value, immutable borrow, or exclusive mutable borrow of the defining module's nominal receiver type, unless the compiler-known built-in receiver family names a different explicit owner module. The marker changes dot-call eligibility only. It does not change calling convention, visibility, ownership, capability requirements, typeclass selection, or ordinary call syntax. Receiver-callable identity, receiver type, first-parameter access mode, visibility, generic constraints, and owner module are recorded in `.koi`.

> Trace: D110, D179, D214, D254, D337, D386
> Covers: UFCS receiver-module lookup is a constrained fallback over explicit `receiver function` exports, not global method search or collision repair.

## Instances And Coherence Across Modules

Typeclass instances follow ordinary visibility and import rules, but coherence is global over the resolved program. For any fully resolved typeclass application visible at a call site, there must be exactly one applicable legal instance. If two legal visible instances could apply, the program is rejected.

> Trace: D17, D214
> Covers: Instance visibility follows module/package visibility, and typeclass calls require one deterministic applicable instance.

An instance may be declared only where the package owns the typeclass or owns at least one concrete head type named by the instance. Internal or private visibility does not relax this orphan rule. A package cannot create a private foreign-typeclass-for-foreign-type instance and rely on scope to hide the coherence problem.

> Trace: D17, D214
> Covers: Kyokai uses an orphan/coherence rule for typeclass instances, and internal/private visibility does not create orphan exceptions.

Internal instances are visible only inside the package. `.koi` artifacts may record internal instances so same-package compilation can use them, but downstream packages must treat those internal entries as nonexistent. Public documentation generated for external consumers must exclude internal instances by default.

> Trace: D17, D79
> Covers: Internal instances may be present in artifacts for same-package checking but are invisible to external package consumers and public docs by default.

## Unsafe Modules And Importability

`pragma Unsafe_Module;` is a module marker for modules that contain raw unsafe operations, raw foreign declarations, or other unsafe facilities admitted by the unsafe chapter. The pragma does not make a declaration public, does not widen `internal`, and does not let callers forge capabilities or bypass ordinary visibility.

> Trace: D20, D245, D255
> Covers: `pragma Unsafe_Module;` marks a raw unsafe implementation boundary but does not alter visibility or grant authority by itself.

A safe module may import safe wrapper declarations from an unsafe module when those declarations are public or same-package internal according to the normal visibility rules. A safe module must not call raw foreign declarations or unsafe primitives merely because it can import the module name. Raw unsafe access requires the unsafe chapter's explicit contracts and capabilities.

> Trace: D20, D245, D255
> Covers: Safe code may import safe wrappers exposed by unsafe modules, but raw unsafe operations remain gated by unsafe contracts and explicit capabilities.

Unsafe contracts are source-level declarations that document and bind the unsafe obligations of a module. They are part of the audit surface, and toolchain audit output must be able to locate them through module/package metadata. They are not imports, not capabilities, and not a substitute for visibility rules.

> Trace: D20, D79, D245
> Covers: Unsafe contracts are audit metadata and source obligations for unsafe modules, not a visibility escape hatch.

## Module Resolution Boundary

The language chapter defines what a module, import, visible declaration, and name lookup mean. The toolchain chapter defines how a package manifest chooses roots, how source files are discovered, how `.koi` artifacts are produced and consumed, and how target selection chooses one source file among whole-file variants for a logical module. These rules meet at one hard boundary: by the time the language checker resolves imports, the toolchain must provide one selected module graph with one interface surface for every imported module.

> Trace: D19a, D52, D78, D79, D105, D537
> Covers: The toolchain selects package roots, the single source file per module, target-specific whole-file variants, editions, and artifacts before language name resolution consumes a single resolved module graph.

## File Roles And Acyclic Graphs

`.kyo` files are handwritten module source. `.koi` files are generated KBI artifacts and are never parsed as handwritten source. `.kai` is a retired source extension under D537: encountering it, or the inherited `.aui`/`.aum` extensions, as handwritten source is a diagnostic that names the single-file model and the `.kyo` extension. A module that publishes no public interface is a `.kyo` file whose declarations are all private or `internal`, restricted to package-private executable internals, tests, and generated implementation internals admitted by the manifest.

The module import graph is acyclic. A module cannot import itself directly or transitively. Interface-only edges do not exempt a cycle. A cycle diagnostic prints one complete cycle path, identifies each import span on that path, and states that Kyokai has no recursive-module cycle protocol. The compiler does not promise that the printed cycle is the shortest possible cycle.

The workspace package dependency graph is also acyclic. Package interfaces, `.koi` artifacts, and edition boundaries do not create a package-cycle escape hatch.

Whole-file build constraints remove excluded files before declarations, `.koi` facts, generated code, or semantic diagnostics contribute to compilation. Declaration-level `when` guards remain the only source-level platform guard inside an included file. Body-level target branching is illegal.

> Trace: D390, D433-D434, D518, D537
> Covers: The `.kyo` source role, the generated `.koi` role, the retired `.kai` extension, non-importable private-only modules, module-cycle rejection, package-cycle rejection, whole-file exclusion, and declaration-only platform guards are explicit.
