(*
   Part of the Kyokai project.

   SPDX-License-Identifier: GPL-3.0-or-later
*)

(** Phase 3 package-manifest, source-discovery, and frontend-loading boundary. *)

type executable_target = {
  target_name: string;
  target_module: string list;
  target_entry: string;
  target_output: string;
  target_default: bool;
} [@@deriving eq]

type dependency_source =
  | WorkspaceDependency of string
  | GitDependency of { git: string; rev: string; tag: string option }
  | IndexDependency of { index: string; version: string }
[@@deriving eq]

type package_dependency = {
  dependency_name: string;
  dependency_source: dependency_source;
} [@@deriving eq]

type package_manifest = {
  package_root: string;
  package_name: string;
  package_version: string;
  package_edition: string;
  module_root: string;
  module_root_path: string;
  package_dependencies: package_dependency list;
  executable_targets: executable_target list;
} [@@deriving eq]

type workspace_manifest = {
  workspace_root: string;
  workspace_member_paths: string list;
  workspace_member_roots: string list;
} [@@deriving eq]

type project_manifest =
  | PackageProject of package_manifest
  | WorkspaceProject of workspace_manifest
[@@deriving eq]

type manifest_error =
  | ManifestReadError of string
  | MissingPackageTable
  | MissingLayoutTable
  | MixedPackageAndWorkspace
  | PackageManifestUnsupported
  | WorkspaceManifestUnsupported
  | MissingRequiredField of string * string
  | DuplicateField of string * string
  | InvalidStringValue of string * string
  | InvalidBooleanValue of string * string
  | InvalidStringArrayValue of string * string
  | InvalidPackageName of string
  | InvalidDependencyName of string
  | InvalidDependencyEntry of string
  | InvalidDependencyGitSource of string * string
  | InvalidDependencyIndexSource of string * string
  | InvalidDependencyVersionRequirement of string * string
  | MissingDependencyRevision of string
  | MissingDependencyVersionRequirement of string
  | BranchDependencyUnsupported of string
  | InvalidModuleRoot of string
  | InvalidWorkspaceMemberPath of string
  | DuplicateWorkspaceMemberPath of string
  | InvalidExecutableTargetName of string
  | InvalidExecutableTargetKind of string * string
  | InvalidExecutableTargetModule of string * string
  | InvalidExecutableTargetEntry of string * string
  | InvalidExecutableTargetOutput of string * string
  | DuplicateDefaultExecutableTarget of string * string
[@@deriving eq]

type source_file = {
  logical_module: string list;
  source_path: string;
} [@@deriving eq]

type module_source = {
  module_name: string list;
  module_source_path: string;
} [@@deriving eq]

type parsed_source = {
  source_file: source_file;
  source_unit: KyokaiSurfaceParser.source_unit;
} [@@deriving eq]

type parsed_module_source = {
  parsed_module_name: string list;
  parsed_source: parsed_source;
  derived_interface_declarations: KyokaiSurfaceParser.declaration list;
} [@@deriving eq]

type loaded_package_sources = {
  loaded_manifest: package_manifest;
  loaded_modules: parsed_module_source list;
} [@@deriving eq]

type loaded_executable_package_sources = {
  executable_loaded_package: loaded_package_sources;
  selected_executable_target: executable_target;
} [@@deriving eq]

type loaded_workspace_sources = {
  loaded_workspace_manifest: workspace_manifest;
  loaded_workspace_packages: loaded_package_sources list;
} [@@deriving eq]

type discovery_error =
  | ModuleRootMissing of string
  | ModuleRootIsNotDirectory of string
  | ModuleRootEscapesPackageRoot of string
  | SourceOutsideModuleRoot of string
  | InvalidModulePath of string
  | DuplicateModuleSource of string list * string * string
  | GeneratedArtifactDiscovered of string
  | RetiredSourceExtensionDiscovered of string
  | InheritedSourceExtensionDiscovered of string
  | SourceReadError of string
  | ParsedModuleNameMismatch of string list * string list * string
  | ParserError of string * KyokaiSurfaceParser.error
  | ControlFlowValidationErrors of string * KyokaiControlFlowValidation.error list
  | InterfaceValidationErrors of string * KyokaiInterfaceValidation.error list
[@@deriving eq]

type target_selection_error =
  | NoExecutableTargets
  | UnknownExecutableTarget of string
  | AmbiguousExecutableTarget of string list
  | ExecutableTargetModuleMissing of string * string list
  | ExecutableTargetEntryMissing of string * string list * string
[@@deriving eq]

type load_error =
  | LoadManifestError of manifest_error
  | LoadTargetSelectionError of target_selection_error
  | LoadDiscoveryErrors of discovery_error list
  | LoadSourceError of source_file * discovery_error
[@@deriving eq]

type workspace_load_error =
  | WorkspaceLoadManifestError of manifest_error
  | WorkspaceMemberEscapesWorkspaceRoot of string
  | WorkspaceMemberLoadError of string * load_error
  | DuplicateWorkspacePackageName of string * string * string
[@@deriving eq]

(** Parse the package-manifest subset needed by Phase 3 source discovery. This
    function validates the required package fields and [layout.module_root], but
    it does not implement dependency or workspace resolution. *)
val parse_package_manifest :
  package_root:string -> string -> (package_manifest, manifest_error) result

(** Parse the workspace-manifest subset needed by Phase 3 source discovery. This
    function validates explicit member paths and keeps dependency, lockfile, and
    inherited workspace settings outside this Phase 3 subset. *)
val parse_workspace_manifest :
  workspace_root:string -> string -> (workspace_manifest, manifest_error) result

(** Read [package-root/kyokai.toml] and parse it as a package manifest. *)
val load_package_manifest : string -> (package_manifest, manifest_error) result

(** Read [workspace-root/kyokai.toml] and parse it as a workspace manifest. *)
val load_workspace_manifest : string -> (workspace_manifest, manifest_error) result

(** Read one root manifest and classify it from parsed TOML tables. This is the
    project-kind boundary used by bootstrap commands; callers must not infer a
    workspace from substrings or other source-text heuristics. *)
val load_project_manifest : string -> (project_manifest, manifest_error) result

(** Return the expected [.kyo] source path for a logical module under the
    manifest-declared module root. *)
val expected_source_path : package_manifest -> string list -> string

(** Select the executable target for a command. An explicit [target_name]
    selects that stable [targets.<name>] table. Without a name, selection is
    legal only when exactly one executable target exists or exactly one target
    is marked [default = true]. *)
val select_executable_target :
  ?target_name:string -> package_manifest -> (executable_target, target_selection_error) result

(** Discover handwritten [.kyo] source files under the declared module root.
    Retired [.kai], generated [.koi], and inherited Austral extensions are
    diagnostics, not source inputs. *)
val discover_sources : package_manifest -> (module_source list, discovery_error list) result

(** Parse a discovered source file and verify that its declared module name
    matches the manifest-rooted logical path. *)
val parse_discovered_source :
  executable_entry:bool -> source_file -> (KyokaiSurfaceParser.source_unit, discovery_error) result

(** Load one package's manifest, discover package sources, run every source
    through [KyokaiFrontend], and verify declarations against path-derived
    module names. *)
val load_package_sources : string -> (loaded_package_sources, load_error) result

(** Load one package for an executable command. The selected target's source is
    parsed with executable-entry shebang policy enabled; other sources keep the
    ordinary source-file policy. This is a Phase 3 loader boundary, not a full
    build/run command. *)
val load_executable_package_sources :
  ?target_name:string -> string -> (loaded_executable_package_sources, load_error) result

(** Load the explicitly listed package members of a workspace manifest. This
    does not infer unlisted packages, resolve dependencies, or claim public
    build-command conformance. *)
val load_workspace_sources : string -> (loaded_workspace_sources, workspace_load_error) result

val render_manifest_error : manifest_error -> string

val render_target_selection_error : target_selection_error -> string

val render_discovery_error : discovery_error -> string

val render_load_error : load_error -> string

val render_workspace_load_error : workspace_load_error -> string

val module_name_to_string : string list -> string
