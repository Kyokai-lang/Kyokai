(*
   Part of the Kyokai project.

   SPDX-License-Identifier: GPL-3.0-or-later
*)

(* kyokai:prooftrace id=FRONTEND-KYOKAI-PACKAGE-SOURCE-DISCOVERY *)

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

type table =
  | PackageTable
  | WorkspaceTable
  | LayoutTable
  | DependenciesTable
  | TargetTable of string
  | OtherTable of string
[@@deriving eq]

type manifest_value =
  | StringValue of string
  | BoolValue of bool
  | StringArrayValue of string list
  | InlineStringTableValue of (string * string) list

type binding = {
  binding_table: table;
  binding_key: string;
  binding_value: manifest_value;
}

let table_marker_key = ""

let manifest_filename = "kyokai.toml"

let module_name_to_string parts = String.concat "." parts

let trim (text: string): string =
  let length = String.length text in
  let is_space = function
    | ' ' | '\t' | '\r' | '\n' -> true
    | _ -> false
  in
  let rec first index =
    if index >= length then length
    else if is_space text.[index] then first (index + 1)
    else index
  in
  let rec last index =
    if index < 0 then -1
    else if is_space text.[index] then last (index - 1)
    else index
  in
  let start = first 0 in
  let finish = last (length - 1) in
  if finish < start then "" else String.sub text start (finish - start + 1)

let split_once (text: string) (needle: char): (string * string) option =
  match String.index_opt text needle with
  | None -> None
  | Some index ->
     Some (
       String.sub text 0 index,
       String.sub text (index + 1) (String.length text - index - 1))

let strip_comment (line: string): string =
  let rec loop index in_string escaped =
    if index >= String.length line then line
    else
      match line.[index], in_string, escaped with
      | _, true, true -> loop (index + 1) true false
      | '\\', true, false -> loop (index + 1) true true
      | '"', true, false -> loop (index + 1) false false
      | '"', false, false -> loop (index + 1) true false
      | '#', false, false -> String.sub line 0 index
      | _ -> loop (index + 1) in_string false
  in
  loop 0 false false

let parse_table_header (line: string): table option =
  let length = String.length line in
  if length >= 2 && line.[0] = '[' && line.[length - 1] = ']' then
    let name = trim (String.sub line 1 (length - 2)) in
    match name with
    | "package" -> Some PackageTable
    | "workspace" -> Some WorkspaceTable
    | "layout" -> Some LayoutTable
    | "dependencies" -> Some DependenciesTable
    | _ when String.length name > 8 && String.sub name 0 8 = "targets." ->
       Some (TargetTable (String.sub name 8 (String.length name - 8)))
    | _ -> Some (OtherTable name)
  else
    None

let parse_string_literal (table_name: string) (key: string) (value: string): (string, manifest_error) result =
  let value = trim value in
  let length = String.length value in
  if length < 2 || value.[0] <> '"' || value.[length - 1] <> '"' then
    Error (InvalidStringValue (table_name, key))
  else
    let buffer = Buffer.create (length - 2) in
    let rec loop index =
      if index >= length - 1 then Ok (Buffer.contents buffer)
      else
        match value.[index] with
        | '\\' when index + 1 < length - 1 ->
           begin
             match value.[index + 1] with
             | '"' -> Buffer.add_char buffer '"'; loop (index + 2)
             | '\\' -> Buffer.add_char buffer '\\'; loop (index + 2)
             | 'n' -> Buffer.add_char buffer '\n'; loop (index + 2)
             | 'r' -> Buffer.add_char buffer '\r'; loop (index + 2)
             | 't' -> Buffer.add_char buffer '\t'; loop (index + 2)
             | _ -> Error (InvalidStringValue (table_name, key))
           end
        | '\\' -> Error (InvalidStringValue (table_name, key))
        | char -> Buffer.add_char buffer char; loop (index + 1)
    in
    loop 1

let parse_string_array_literal (table_name: string) (key: string) (value: string): (string list, manifest_error) result =
  let value = trim value in
  let length = String.length value in
  if length < 2 || value.[0] <> '[' || value.[length - 1] <> ']' then
    Error (InvalidStringArrayValue (table_name, key))
  else
    let inner = String.sub value 1 (length - 2) in
    let parse_item item =
      match parse_string_literal table_name key (trim item) with
      | Ok text -> Ok text
      | Error _ -> Error (InvalidStringArrayValue (table_name, key))
    in
    let rec finish_item items buffer =
      let item = Buffer.contents buffer |> trim in
      if item = "" then Ok items
      else
        match parse_item item with
        | Ok text -> Ok (text :: items)
        | Error error -> Error error
    in
    let rec loop index in_string escaped items buffer =
      if index >= String.length inner then
        match finish_item items buffer with
        | Ok items -> Ok (List.rev items)
        | Error error -> Error error
      else
        match inner.[index], in_string, escaped with
        | char, true, true -> Buffer.add_char buffer char; loop (index + 1) true false items buffer
        | '\\', true, false -> Buffer.add_char buffer '\\'; loop (index + 1) true true items buffer
        | '"', true, false -> Buffer.add_char buffer '"'; loop (index + 1) false false items buffer
        | '"', false, false -> Buffer.add_char buffer '"'; loop (index + 1) true false items buffer
        | ',', false, false ->
           begin match finish_item items buffer with
           | Ok items -> Buffer.clear buffer; loop (index + 1) false false items buffer
           | Error error -> Error error
           end
        | char, false, false -> Buffer.add_char buffer char; loop (index + 1) false false items buffer
        | char, true, false -> Buffer.add_char buffer char; loop (index + 1) true false items buffer
        | char, false, true -> Buffer.add_char buffer char; loop (index + 1) false false items buffer
    in
    loop 0 false false [] (Buffer.create (String.length inner))

let parse_inline_string_table_literal (table_name: string) (key: string) (value: string): ((string * string) list, manifest_error) result =
  let value = trim value in
  let length = String.length value in
  if length < 2 || value.[0] <> '{' || value.[length - 1] <> '}' then
    Error (InvalidDependencyEntry key)
  else
    let inner = String.sub value 1 (length - 2) in
    let parse_field field =
      match split_once field '=' with
      | None -> Error (InvalidDependencyEntry key)
      | Some (raw_key, raw_value) ->
         let field_key = trim raw_key in
         begin match parse_string_literal table_name field_key raw_value with
         | Ok text -> Ok (field_key, text)
         | Error _ -> Error (InvalidDependencyEntry key)
         end
    in
    let rec finish_field fields buffer =
      let field = Buffer.contents buffer |> trim in
      if field = "" then Ok fields
      else
        match parse_field field with
        | Ok field -> Ok (field :: fields)
        | Error error -> Error error
    in
    let rec loop index in_string escaped fields buffer =
      if index >= String.length inner then
        match finish_field fields buffer with
        | Ok fields -> Ok (List.rev fields)
        | Error error -> Error error
      else
        match inner.[index], in_string, escaped with
        | char, true, true -> Buffer.add_char buffer char; loop (index + 1) true false fields buffer
        | '\\', true, false -> Buffer.add_char buffer '\\'; loop (index + 1) true true fields buffer
        | '"', true, false -> Buffer.add_char buffer '"'; loop (index + 1) false false fields buffer
        | '"', false, false -> Buffer.add_char buffer '"'; loop (index + 1) true false fields buffer
        | ',', false, false ->
           begin match finish_field fields buffer with
           | Ok fields -> Buffer.clear buffer; loop (index + 1) false false fields buffer
           | Error error -> Error error
           end
        | char, _, _ -> Buffer.add_char buffer char; loop (index + 1) in_string false fields buffer
    in
    loop 0 false false [] (Buffer.create (String.length inner))

let table_name table =
  match table with
  | PackageTable -> "package"
  | WorkspaceTable -> "workspace"
  | LayoutTable -> "layout"
  | DependenciesTable -> "dependencies"
  | TargetTable name -> "targets." ^ name
  | OtherTable name -> name

let parse_manifest_value (table_name: string) (key: string) (value: string): (manifest_value, manifest_error) result =
  let value = trim value in
  match value with
  | "true" -> Ok (BoolValue true)
  | "false" -> Ok (BoolValue false)
  | _ ->
     if String.length value > 0 && value.[0] = '[' then
       match parse_string_array_literal table_name key value with
       | Ok values -> Ok (StringArrayValue values)
       | Error error -> Error error
     else if String.length value > 0 && value.[0] = '{' then
       match parse_inline_string_table_literal table_name key value with
       | Ok values -> Ok (InlineStringTableValue values)
       | Error error -> Error error
     else
       match parse_string_literal table_name key value with
       | Ok text -> Ok (StringValue text)
       | Error error -> Error error

let array_value_closed (value: string): bool =
  let value = trim value in
  let rec loop index in_string escaped closed =
    if index >= String.length value then closed && not in_string
    else
      match value.[index], in_string, escaped with
      | _, true, true -> loop (index + 1) true false closed
      | '\\', true, false -> loop (index + 1) true true closed
      | '"', true, false -> loop (index + 1) false false closed
      | '"', false, false -> loop (index + 1) true false closed
      | ']', false, false -> loop (index + 1) false false true
      | char, false, false when not closed && char <> ' ' && char <> '\t' && char <> '\r' && char <> '\n' -> loop (index + 1) false false false
      | _ -> loop (index + 1) in_string false closed
  in
  loop 0 false false false

let parse_manifest_bindings (source: string): (binding list, manifest_error) result =
  let lines = String.split_on_char '\n' source in
  let rec loop current_table bindings lines =
    match lines with
    | [] -> Ok (List.rev bindings)
    | line :: rest ->
       let line = trim (strip_comment line) in
       if line = "" then
         loop current_table bindings rest
       else
         match parse_table_header line with
         | Some table ->
            loop table ({ binding_table = table; binding_key = table_marker_key; binding_value = BoolValue true } :: bindings) rest
         | None ->
            begin match split_once line '=' with
            | None -> loop current_table bindings rest
            | Some (raw_key, raw_value) ->
               let key = trim raw_key in
               let rec collect_array_value acc remaining =
                 let value = String.concat " " (List.rev acc) in
                 if array_value_closed value then (value, remaining)
                 else
                   match remaining with
                   | [] -> (value, [])
                   | next :: rest ->
                      collect_array_value (trim (strip_comment next) :: acc) rest
               in
               let raw_value, rest =
                 let first_value = trim raw_value in
                 if String.length first_value > 0 && first_value.[0] = '[' && not (array_value_closed first_value) then
                   collect_array_value [first_value] rest
                 else
                   (raw_value, rest)
               in
               begin match parse_manifest_value (table_name current_table) key raw_value with
               | Error error -> Error error
               | Ok value ->
                  loop current_table ({ binding_table = current_table; binding_key = key; binding_value = value } :: bindings) rest
               end
            end
  in
  loop (OtherTable "") [] lines

let find_binding bindings table key =
  let matches =
    List.filter
      (fun binding -> equal_table binding.binding_table table && binding.binding_key = key)
      bindings
  in
  match matches with
  | [] -> Error (MissingRequiredField (table_name table, key))
  | [binding] -> Ok binding
  | _ -> Error (DuplicateField (table_name table, key))

let find_string_field bindings table key =
  match find_binding bindings table key with
  | Error error -> Error error
  | Ok binding ->
     begin match binding.binding_value with
     | StringValue value -> Ok value
     | BoolValue _ | StringArrayValue _ | InlineStringTableValue _ -> Error (InvalidStringValue (table_name table, key))
     end

let find_optional_string_field bindings table key =
  match find_binding bindings table key with
  | Error (MissingRequiredField _) -> Ok None
  | Error error -> Error error
  | Ok binding ->
     begin match binding.binding_value with
     | StringValue value -> Ok (Some value)
     | BoolValue _ | StringArrayValue _ | InlineStringTableValue _ -> Error (InvalidStringValue (table_name table, key))
     end

let find_optional_bool_field bindings table key =
  match find_binding bindings table key with
  | Error (MissingRequiredField _) -> Ok false
  | Error error -> Error error
  | Ok binding ->
     begin match binding.binding_value with
     | BoolValue value -> Ok value
     | StringValue _ | StringArrayValue _ | InlineStringTableValue _ -> Error (InvalidBooleanValue (table_name table, key))
     end

let find_string_array_field bindings table key =
  match find_binding bindings table key with
  | Error error -> Error error
  | Ok binding ->
     begin match binding.binding_value with
     | StringArrayValue values -> Ok values
     | StringValue _ | BoolValue _ | InlineStringTableValue _ -> Error (InvalidStringArrayValue (table_name table, key))
     end

let dependency_bindings bindings =
  bindings
  |> List.filter (fun binding -> equal_table binding.binding_table DependenciesTable && binding.binding_key <> table_marker_key)
  |> List.sort (fun left right -> String.compare left.binding_key right.binding_key)

let table_present bindings table =
  List.exists (fun binding -> equal_table binding.binding_table table) bindings

let is_lower char = 'a' <= char && char <= 'z'

let is_digit char = '0' <= char && char <= '9'

let is_package_name_char char = is_lower char || is_digit char || char = '-'

let reserved_windows_names =
  [ "con"; "prn"; "aux"; "nul";
    "com1"; "com2"; "com3"; "com4"; "com5"; "com6"; "com7"; "com8"; "com9";
    "lpt1"; "lpt2"; "lpt3"; "lpt4"; "lpt5"; "lpt6"; "lpt7"; "lpt8"; "lpt9" ]

let validate_package_name name =
  let length = String.length name in
  let rec all_chars index =
    index >= length || (is_package_name_char name.[index] && all_chars (index + 1))
  in
  let rec contains_double_dash index =
    index + 1 < length
    && ((name.[index] = '-' && name.[index + 1] = '-') || contains_double_dash (index + 1))
  in
  if length = 0 || length > 64 then Error (InvalidPackageName name)
  else if not (is_lower name.[0]) then Error (InvalidPackageName name)
  else if not (all_chars 0) then Error (InvalidPackageName name)
  else if name.[length - 1] = '-' then Error (InvalidPackageName name)
  else if contains_double_dash 0 then Error (InvalidPackageName name)
  else if List.mem name reserved_windows_names then Error (InvalidPackageName name)
  else Ok ()

let validate_dependency_name name =
  match validate_package_name name with
  | Ok () -> Ok ()
  | Error _ -> Error (InvalidDependencyName name)

let assoc_field fields key = List.assoc_opt key fields

let has_ascii_whitespace text =
  let rec loop index =
    index < String.length text
    && (match text.[index] with
        | ' ' | '\t' | '\r' | '\n' -> true
        | _ -> loop (index + 1))
  in
  loop 0

let is_index_segment_char char = is_package_name_char char

let validate_index_identity text =
  let text = trim text in
  match String.split_on_char '/' text with
  | [scope; package]
       when String.length scope > 1
            && scope.[0] = '@'
            && not (has_ascii_whitespace text) ->
     let scope_name = String.sub scope 1 (String.length scope - 1) in
     let valid_segment segment =
       let length = String.length segment in
       let rec loop index =
         index >= length || (is_index_segment_char segment.[index] && loop (index + 1))
       in
       length > 0 && is_lower segment.[0] && loop 1 && segment.[length - 1] <> '-'
     in
     valid_segment scope_name && valid_segment package
  | _ -> false

let strip_prefix prefix text =
  let prefix_length = String.length prefix in
  if String.length text >= prefix_length && String.sub text 0 prefix_length = prefix then
    Some (String.sub text prefix_length (String.length text - prefix_length))
  else
    None

let valid_semver_number text =
  let length = String.length text in
  let rec loop index = index >= length || (is_digit text.[index] && loop (index + 1)) in
  length > 0 && loop 0

let is_ascii_alpha char = ('a' <= char && char <= 'z') || ('A' <= char && char <= 'Z')

let valid_semver_suffix text =
  let length = String.length text in
  let rec loop index =
    index >= length
    || (let char = text.[index] in
        ((is_ascii_alpha char || is_digit char || char = '-' || char = '.') && loop (index + 1)))
  in
  length > 0 && loop 0

let validate_version_atom text =
  let text = trim text in
  let core_with_prerelease =
    match split_once text '+' with
    | None -> text
    | Some (core, build) -> if valid_semver_suffix build then core else ""
  in
  let core =
    match split_once core_with_prerelease '-' with
    | None -> core_with_prerelease
    | Some (core, prerelease) -> if valid_semver_suffix prerelease then core else ""
  in
  match String.split_on_char '.' core with
  | [major; minor] ->
     valid_semver_number major && valid_semver_number minor
  | [major; minor; patch] ->
     valid_semver_number major && valid_semver_number minor && valid_semver_number patch
  | _ -> false

let validate_version_requirement text =
  let text = trim text in
  let validate_single requirement =
    let requirement = trim requirement in
    let prefixed prefixes =
      List.find_map (fun prefix -> strip_prefix prefix requirement |> Option.map trim) prefixes
    in
    match prefixed [">="; "<="; ">"; "<"; "^"; "~"; "="] with
    | Some version -> validate_version_atom version
    | None -> validate_version_atom requirement
  in
  if text = "" || text = "*" then false
  else
    let parts = String.split_on_char ',' text in
    match parts with
    | [] -> false
    | [single] -> validate_single single
    | bounds ->
       List.for_all
         (fun bound ->
           let bound = trim bound in
           (strip_prefix ">=" bound <> None
            || strip_prefix "<=" bound <> None
            || strip_prefix ">" bound <> None
            || strip_prefix "<" bound <> None)
           && validate_single bound)
         bounds

let parse_dependency_binding binding =
  let name = binding.binding_key in
  match validate_dependency_name name with
  | Error error -> Error error
  | Ok () ->
     begin match binding.binding_value with
     | InlineStringTableValue fields ->
        let workspace = assoc_field fields "workspace" in
        let git = assoc_field fields "git" in
        let index = assoc_field fields "index" in
        let rev = assoc_field fields "rev" in
        let tag = assoc_field fields "tag" in
        let version = assoc_field fields "version" in
        let branch = assoc_field fields "branch" in
        begin match branch with
        | Some _ -> Error (BranchDependencyUnsupported name)
        | None ->
           begin match workspace, git, index with
           | Some workspace_name, None, None ->
              begin match validate_package_name workspace_name with
              | Ok () -> Ok { dependency_name = name; dependency_source = WorkspaceDependency workspace_name }
              | Error _ -> Error (InvalidDependencyEntry name)
              end
           | None, Some git_url, None ->
              if trim git_url = "" then Error (InvalidDependencyGitSource (name, git_url))
              else
                begin match rev with
                | None -> Error (MissingDependencyRevision name)
                | Some rev when trim rev = "" -> Error (MissingDependencyRevision name)
                | Some rev -> Ok { dependency_name = name; dependency_source = GitDependency { git = git_url; rev; tag } }
                end
           | None, None, Some index_identity ->
              if not (validate_index_identity index_identity) then Error (InvalidDependencyIndexSource (name, index_identity))
              else
                begin match version with
                | None -> Error (MissingDependencyVersionRequirement name)
                | Some version when not (validate_version_requirement version) ->
                   Error (InvalidDependencyVersionRequirement (name, version))
                | Some version -> Ok { dependency_name = name; dependency_source = IndexDependency { index = index_identity; version } }
                end
           | _ -> Error (InvalidDependencyEntry name)
           end
        end
     | _ -> Error (InvalidDependencyEntry name)
     end

let parse_package_dependencies bindings =
  let rec loop parsed dependencies =
    match dependencies with
    | [] -> Ok (List.rev parsed)
    | binding :: rest ->
       begin match parse_dependency_binding binding with
       | Ok dependency -> loop (dependency :: parsed) rest
       | Error error -> Error error
       end
  in
  loop [] (dependency_bindings bindings)

let is_ascii_upper char = 'A' <= char && char <= 'Z'

let is_ascii_alpha char = ('a' <= char && char <= 'z') || ('A' <= char && char <= 'Z')

let is_identifier_continue char = is_ascii_alpha char || is_digit char


let valid_module_segment segment =
  String.length segment > 0
  && is_ascii_upper segment.[0]
  && not (String.contains segment '.')

let parse_module_path text =
  let parts = String.split_on_char '.' text in
  if parts <> [] && List.for_all valid_module_segment parts then Some parts else None

let valid_entry_name text =
  let length = String.length text in
  let rec loop index =
    index >= length || (is_identifier_continue text.[index] && loop (index + 1))
  in
  length > 0 && is_lower text.[0] && loop 1

let target_tables bindings =
  bindings
  |> List.filter_map (fun binding ->
         match binding.binding_table with
         | TargetTable name -> Some name
         | _ -> None)
  |> List.sort_uniq String.compare

let validate_target_name name =
  match validate_package_name name with
  | Ok () -> Ok ()
  | Error _ -> Error (InvalidExecutableTargetName name)

let parse_executable_target bindings name =
  let table = TargetTable name in
  match validate_target_name name with
  | Error error -> Error error
  | Ok () ->
     begin match find_string_field bindings table "kind" with
     | Error error -> Error error
     | Ok kind when kind <> "executable" -> Error (InvalidExecutableTargetKind (name, kind))
     | Ok _ ->
        begin match find_string_field bindings table "module" with
        | Error error -> Error error
        | Ok module_text ->
           begin match parse_module_path module_text with
           | None -> Error (InvalidExecutableTargetModule (name, module_text))
           | Some target_module ->
              begin match find_string_field bindings table "entry" with
              | Error error -> Error error
              | Ok target_entry when not (valid_entry_name target_entry) ->
                 Error (InvalidExecutableTargetEntry (name, target_entry))
              | Ok target_entry ->
                 begin match find_optional_string_field bindings table "output" with
                 | Error error -> Error error
                 | Ok output_option ->
                    let target_output = Option.value output_option ~default:name in
                    begin match validate_package_name target_output with
                    | Error _ -> Error (InvalidExecutableTargetOutput (name, target_output))
                    | Ok () ->
                       begin match find_optional_bool_field bindings table "default" with
                       | Error error -> Error error
                       | Ok target_default ->
                          Ok { target_name = name; target_module; target_entry; target_output; target_default }
                       end
                    end
                 end
              end
           end
        end
     end

let parse_executable_targets bindings =
  let rec loop parsed defaults names =
    match names with
    | [] -> Ok (List.rev parsed)
    | name :: rest ->
       begin match parse_executable_target bindings name with
       | Error error -> Error error
       | Ok target ->
          let defaults = if target.target_default then target.target_name :: defaults else defaults in
          begin match defaults with
          | second :: first :: _ -> Error (DuplicateDefaultExecutableTarget (first, second))
          | _ -> loop (target :: parsed) defaults rest
          end
       end
  in
  loop [] [] (target_tables bindings)

let target_names targets =
  List.map (fun target -> target.target_name) targets

let find_executable_target targets name =
  List.find_opt (fun target -> target.target_name = name) targets

let select_executable_target ?target_name manifest =
  match target_name with
  | Some name ->
     begin match find_executable_target manifest.executable_targets name with
     | Some target -> Ok target
     | None -> Error (UnknownExecutableTarget name)
     end
  | None ->
     begin match manifest.executable_targets with
     | [] -> Error NoExecutableTargets
     | [target] -> Ok target
     | targets ->
        let defaults = List.filter (fun target -> target.target_default) targets in
        begin match defaults with
        | [target] -> Ok target
        | _ -> Error (AmbiguousExecutableTarget (target_names targets))
        end
     end

let split_path path =
  path
  |> String.split_on_char '/'
  |> List.filter (fun part -> part <> "")

let path_is_absolute path =
  String.length path > 0 && path.[0] = '/'

let validate_relative_path path =
  let parts = split_path path in
  path <> "" && not (path_is_absolute path) && not (List.exists (fun part -> part = "." || part = "..") parts)

let join_path left right =
  if left = "" then right
  else if right = "" then left
  else Filename.concat left right

let validate_module_root package_root module_root =
  if validate_relative_path module_root then Ok (join_path package_root module_root)
  else Error (InvalidModuleRoot module_root)

let validate_workspace_member_path workspace_root member_path =
  if validate_relative_path member_path then Ok (join_path workspace_root member_path)
  else Error (InvalidWorkspaceMemberPath member_path)

let parse_workspace_manifest ~workspace_root source =
  match parse_manifest_bindings source with
  | Error error -> Error error
  | Ok bindings ->
     let has_package = table_present bindings PackageTable in
     let has_workspace = table_present bindings WorkspaceTable in
     let has_layout = table_present bindings LayoutTable in
     if has_package && has_workspace then Error MixedPackageAndWorkspace
     else if has_package then Error PackageManifestUnsupported
     else if not has_workspace then Error WorkspaceManifestUnsupported
     else if has_layout then Error MixedPackageAndWorkspace
     else
       match find_string_array_field bindings WorkspaceTable "members" with
       | Error error -> Error error
       | Ok member_paths ->
          let sorted_unique = List.sort_uniq String.compare member_paths in
          if List.length sorted_unique <> List.length member_paths then
            let duplicate =
              member_paths
              |> List.sort String.compare
              |> List.find (fun path -> List.length (List.filter (( = ) path) member_paths) > 1)
            in
            Error (DuplicateWorkspaceMemberPath duplicate)
          else
            let rec loop roots paths =
              match paths with
              | [] -> Ok { workspace_root; workspace_member_paths = member_paths; workspace_member_roots = List.rev roots }
              | member_path :: rest ->
                 begin match validate_workspace_member_path workspace_root member_path with
                 | Error error -> Error error
                 | Ok root -> loop (root :: roots) rest
                 end
            in
            loop [] member_paths

let parse_package_manifest ~package_root source =
  match parse_manifest_bindings source with
  | Error error -> Error error
  | Ok bindings ->
     let has_package = table_present bindings PackageTable in
     let has_workspace = table_present bindings WorkspaceTable in
     let has_layout = table_present bindings LayoutTable in
     if has_package && has_workspace then Error MixedPackageAndWorkspace
     else if has_workspace then Error WorkspaceManifestUnsupported
     else if not has_package then Error MissingPackageTable
     else if not has_layout then Error MissingLayoutTable
     else
       match find_string_field bindings PackageTable "name" with
       | Error error -> Error error
       | Ok package_name ->
          begin match validate_package_name package_name with
          | Error error -> Error error
          | Ok () ->
             begin match find_string_field bindings PackageTable "version" with
             | Error error -> Error error
             | Ok package_version ->
                begin match find_string_field bindings PackageTable "edition" with
                | Error error -> Error error
                | Ok package_edition ->
                   begin match find_string_field bindings LayoutTable "module_root" with
                   | Error error -> Error error
                   | Ok module_root ->
                      begin match validate_module_root package_root module_root with
                      | Error error -> Error error
                      | Ok module_root_path ->
                         begin match parse_package_dependencies bindings with
                         | Error error -> Error error
                         | Ok package_dependencies ->
                            begin match parse_executable_targets bindings with
                            | Error error -> Error error
                            | Ok executable_targets ->
                               Ok { package_root; package_name; package_version; package_edition; module_root; module_root_path; package_dependencies; executable_targets }
                            end
                         end
                      end
                   end
                end
             end
          end

let read_file path =
  try
    let channel = open_in_bin path in
    Ok (Fun.protect
          ~finally:(fun () -> close_in_noerr channel)
          (fun () -> really_input_string channel (in_channel_length channel)))
  with Sys_error message -> Error message

let load_package_manifest package_root =
  let path = Filename.concat package_root manifest_filename in
  match read_file path with
  | Error message -> Error (ManifestReadError message)
  | Ok source -> parse_package_manifest ~package_root source

let load_workspace_manifest workspace_root =
  let path = Filename.concat workspace_root manifest_filename in
  match read_file path with
  | Error message -> Error (ManifestReadError message)
  | Ok source -> parse_workspace_manifest ~workspace_root source

let load_project_manifest root =
  let path = Filename.concat root manifest_filename in
  match read_file path with
  | Error message -> Error (ManifestReadError message)
  | Ok source ->
     begin match parse_workspace_manifest ~workspace_root:root source with
     | Ok manifest -> Ok (WorkspaceProject manifest)
     | Error PackageManifestUnsupported ->
        begin match parse_package_manifest ~package_root:root source with
        | Ok manifest -> Ok (PackageProject manifest)
        | Error error -> Error error
        end
     | Error WorkspaceManifestUnsupported ->
        begin match parse_package_manifest ~package_root:root source with
        | Ok manifest -> Ok (PackageProject manifest)
        | Error error -> Error error
        end
     | Error error -> Error error
     end

let expected_source_path manifest logical_module =
  let relative = String.concat Filename.dir_sep logical_module ^ ".kyo" in
  join_path manifest.module_root_path relative

let is_regular_file path =
  try (Unix.stat path).Unix.st_kind = Unix.S_REG with Unix.Unix_error _ -> false

let is_directory path =
  try (Unix.stat path).Unix.st_kind = Unix.S_DIR with Unix.Unix_error _ -> false

let realpath path =
  try Ok (Unix.realpath path)
  with Unix.Unix_error (_, _, _) -> Error path

let string_starts_with ~prefix text =
  let prefix_length = String.length prefix in
  String.length text >= prefix_length && String.sub text 0 prefix_length = prefix

let canonical_path_is_within ~root path =
  match realpath root, realpath path with
  | Ok root, Ok path ->
     let prefix = if root = Filename.dir_sep then root else root ^ Filename.dir_sep in
     Ok (path = root || string_starts_with ~prefix path)
  | Error _, _ | _, Error _ -> Ok false

let sorted_readdir path =
  try
    Ok (Sys.readdir path
        |> Array.to_list
        |> List.sort String.compare)
  with Sys_error message -> Error message

let logical_module_of_relative_path relative_path =
  match Filename.extension relative_path with
  | ".kyo" ->
     let without_extension = Filename.remove_extension relative_path in
     let parts = split_path without_extension in
     if parts <> [] && List.for_all valid_module_segment parts then
       Some { logical_module = parts; source_path = relative_path }
     else
       None
  | _ -> None

let discover_source_files manifest =
  let root = manifest.module_root_path in
  let rec walk relative_dir physical_dir files errors =
    match sorted_readdir physical_dir with
    | Error message -> (files, SourceReadError message :: errors)
    | Ok entries ->
       List.fold_left
         (fun (files, errors) entry ->
           let physical_path = Filename.concat physical_dir entry in
           let relative_path = if relative_dir = "" then entry else Filename.concat relative_dir entry in
           if is_directory physical_path then
             walk relative_path physical_path files errors
           else if is_regular_file physical_path then
             match Filename.extension entry with
             | ".kyo" ->
                begin match logical_module_of_relative_path relative_path with
                | None -> (files, InvalidModulePath physical_path :: errors)
                | Some source ->
                   ({ source with source_path = physical_path } :: files, errors)
                end
             | ".kai" -> (files, RetiredSourceExtensionDiscovered physical_path :: errors)
             | ".koi" -> (files, GeneratedArtifactDiscovered physical_path :: errors)
             | ".aui" | ".aum" -> (files, InheritedSourceExtensionDiscovered physical_path :: errors)
             | _ -> (files, errors)
           else
             (files, errors))
         (files, errors)
         entries
  in
  if not (Sys.file_exists root) then Error [ModuleRootMissing root]
  else if not (is_directory root) then Error [ModuleRootIsNotDirectory root]
  else
    match canonical_path_is_within ~root:manifest.package_root root with
    | Ok false -> Error [ModuleRootEscapesPackageRoot root]
    | Error _ -> Error [ModuleRootEscapesPackageRoot root]
    | Ok true ->
       let files, errors = walk "" root [] [] in
       if errors = [] then Ok (List.rev files) else Error (List.rev errors)

let compare_module_name left right =
  String.compare (module_name_to_string left) (module_name_to_string right)

let insert_module_source sources source =
  let rec loop acc sources =
    match sources with
    | [] ->
       let item = { module_name = source.logical_module; module_source_path = source.source_path } in
       Ok (List.rev (item :: acc))
    | item :: _ when item.module_name = source.logical_module ->
       Error (DuplicateModuleSource (source.logical_module, item.module_source_path, source.source_path))
    | item :: rest -> loop (item :: acc) rest
  in
  loop [] sources

let group_sources files =
  let sorted =
    List.sort
      (fun left right ->
        String.compare
          (module_name_to_string left.logical_module)
          (module_name_to_string right.logical_module))
      files
  in
  let rec loop grouped errors sources =
    match sources with
    | [] ->
       if errors = [] then
         Ok (List.sort (fun left right -> compare_module_name left.module_name right.module_name) grouped)
       else
         Error (List.rev errors)
    | source :: rest ->
       begin match insert_module_source grouped source with
       | Ok grouped -> loop grouped errors rest
       | Error error -> loop grouped (error :: errors) rest
       end
  in
  loop [] [] sorted

let discover_sources manifest =
  match discover_source_files manifest with
  | Error errors -> Error errors
  | Ok files -> group_sources files

let check_discovered_source ~executable_entry source_file =
  match read_file source_file.source_path with
  | Error message -> Error (SourceReadError message)
  | Ok source ->
     begin match KyokaiFrontend.check_source ~executable_entry source_file.source_path source with
     | Error (KyokaiFrontend.ParseError parser_error) ->
        Error (ParserError (source_file.source_path, parser_error))
     | Error (KyokaiFrontend.ControlFlowErrors errors) ->
        Error (ControlFlowValidationErrors (source_file.source_path, errors))
     | Error (KyokaiFrontend.InterfaceErrors errors) ->
        Error (InterfaceValidationErrors (source_file.source_path, errors))
     | Ok checked ->
        if checked.source_unit.module_name <> source_file.logical_module then
          Error
            (ParsedModuleNameMismatch
               (source_file.logical_module, checked.source_unit.module_name, source_file.source_path))
        else
          Ok checked
     end

let parse_discovered_source ~executable_entry source_file =
  match check_discovered_source ~executable_entry source_file with
  | Ok checked -> Ok checked.KyokaiFrontend.source_unit
  | Error error -> Error error

let parse_module_source ?(executable_entry_module=None) module_source =
  let executable_entry =
    match executable_entry_module with
    | Some module_name -> module_name = module_source.module_name
    | None -> false
  in
  let source_file = {
    logical_module = module_source.module_name;
    source_path = module_source.module_source_path;
  } in
  match check_discovered_source ~executable_entry source_file with
  | Error error -> Error (source_file, error)
  | Ok checked ->
     Ok {
       parsed_module_name = module_source.module_name;
       parsed_source = { source_file; source_unit = checked.KyokaiFrontend.source_unit };
       derived_interface_declarations = checked.KyokaiFrontend.derived_interface_declarations;
     }

let find_module_source module_sources module_name =
  List.find_opt (fun module_source -> module_source.module_name = module_name) module_sources

let require_executable_target_module target module_sources =
  match find_module_source module_sources target.target_module with
  | None -> Error (ExecutableTargetModuleMissing (target.target_name, target.target_module))
  | Some _ -> Ok ()

let parse_module_source_sets ?executable_entry_module manifest module_source_sets =
  let rec loop parsed remaining =
    match remaining with
    | [] -> Ok { loaded_manifest = manifest; loaded_modules = List.rev parsed }
    | module_source :: rest ->
       begin match parse_module_source ?executable_entry_module module_source with
       | Error (source_file, error) -> Error (source_file, error)
       | Ok parsed_module -> loop (parsed_module :: parsed) rest
       end
  in
  loop [] module_source_sets

let parsed_module_contains_entry parsed_module entry_name =
  List.exists
    (fun declaration ->
      KyokaiSurfaceParser.equal_declaration_kind
        declaration.KyokaiSurfaceParser.declaration_kind
        KyokaiSurfaceParser.FunctionDeclaration
      && declaration.KyokaiSurfaceParser.declaration_name = Some entry_name)
    parsed_module.parsed_source.source_unit.KyokaiSurfaceParser.declarations

let require_executable_target_entry target loaded =
  match List.find_opt
          (fun parsed -> parsed.parsed_module_name = target.target_module)
          loaded.loaded_modules with
  | Some parsed_module when parsed_module_contains_entry parsed_module target.target_entry -> Ok ()
  | _ -> Error (ExecutableTargetEntryMissing (target.target_name, target.target_module, target.target_entry))

let load_package_sources package_root =
  match load_package_manifest package_root with
  | Error error -> Error (LoadManifestError error)
  | Ok manifest ->
     begin match discover_sources manifest with
     | Error errors -> Error (LoadDiscoveryErrors errors)
     | Ok module_source_sets ->
        begin match parse_module_source_sets manifest module_source_sets with
        | Ok loaded -> Ok loaded
        | Error (source_file, error) -> Error (LoadSourceError (source_file, error))
        end
     end

let load_executable_package_sources ?target_name package_root =
  match load_package_manifest package_root with
  | Error error -> Error (LoadManifestError error)
  | Ok manifest ->
     begin match select_executable_target ?target_name manifest with
     | Error error -> Error (LoadTargetSelectionError error)
     | Ok target ->
        begin match discover_sources manifest with
        | Error errors -> Error (LoadDiscoveryErrors errors)
        | Ok module_source_sets ->
           begin match require_executable_target_module target module_source_sets with
           | Error error -> Error (LoadTargetSelectionError error)
           | Ok () ->
              begin match parse_module_source_sets ~executable_entry_module:(Some target.target_module) manifest module_source_sets with
              | Error (source_file, error) -> Error (LoadSourceError (source_file, error))
              | Ok loaded ->
                 begin match require_executable_target_entry target loaded with
                 | Error error -> Error (LoadTargetSelectionError error)
                 | Ok () -> Ok { executable_loaded_package = loaded; selected_executable_target = target }
                 end
              end
           end
        end
     end

let package_root loaded = loaded.loaded_manifest.package_root

let package_name loaded = loaded.loaded_manifest.package_name

let load_workspace_sources workspace_root =
  match load_workspace_manifest workspace_root with
  | Error error -> Error (WorkspaceLoadManifestError error)
  | Ok manifest ->
     let rec load_members loaded remaining_roots =
       match remaining_roots with
       | [] -> Ok (List.rev loaded)
       | member_root :: rest ->
          begin match Sys.file_exists member_root, canonical_path_is_within ~root:workspace_root member_root with
          | true, Ok false | true, Error _ -> Error (WorkspaceMemberEscapesWorkspaceRoot member_root)
          | _ ->
             begin match load_package_sources member_root with
             | Error error -> Error (WorkspaceMemberLoadError (member_root, error))
             | Ok package -> load_members (package :: loaded) rest
             end
          end
     in
     begin match load_members [] manifest.workspace_member_roots with
     | Error error -> Error error
     | Ok packages ->
        let rec check_unique seen packages =
          match packages with
          | [] -> Ok { loaded_workspace_manifest = manifest; loaded_workspace_packages = packages }
          | package :: rest ->
             let name = package_name package in
             begin match List.assoc_opt name seen with
             | Some first_root -> Error (DuplicateWorkspacePackageName (name, first_root, package_root package))
             | None -> check_unique ((name, package_root package) :: seen) rest
             end
        in
        begin match check_unique [] packages with
        | Ok _ -> Ok { loaded_workspace_manifest = manifest; loaded_workspace_packages = packages }
        | Error error -> Error error
        end
     end

let render_manifest_error error =
  match error with
  | ManifestReadError message -> Printf.sprintf "Could not read kyokai.toml: %s" message
  | MissingPackageTable -> "kyokai.toml must contain a [package] table for package source discovery."
  | MissingLayoutTable -> "A package kyokai.toml must contain a [layout] table."
  | MixedPackageAndWorkspace -> "A kyokai.toml file must not contain both [package] and [workspace] tables."
  | PackageManifestUnsupported -> "This operation expected a workspace manifest but found a package manifest."
  | WorkspaceManifestUnsupported -> "This operation expected a package manifest but found a workspace manifest; use workspace loading at the workspace root."
  | MissingRequiredField (table, key) -> Printf.sprintf "Missing required [%s].%s field in kyokai.toml." table key
  | DuplicateField (table, key) -> Printf.sprintf "Duplicate [%s].%s field in kyokai.toml." table key
  | InvalidStringValue (table, key) -> Printf.sprintf "Expected [%s].%s to be a TOML basic string in the supported Phase 3 manifest subset." table key
  | InvalidBooleanValue (table, key) -> Printf.sprintf "Expected [%s].%s to be a TOML boolean in the supported Phase 3 manifest subset." table key
  | InvalidStringArrayValue (table, key) -> Printf.sprintf "Expected [%s].%s to be a TOML array of basic strings in the supported Phase 3 manifest subset." table key
  | InvalidPackageName name -> Printf.sprintf "Invalid Kyokai package name %S." name
  | InvalidDependencyName name -> Printf.sprintf "Invalid dependency entry name %S." name
  | InvalidDependencyEntry name -> Printf.sprintf "Invalid [dependencies].%s entry; use exactly one workspace package reference, pinned git source, or indexed package version requirement." name
  | InvalidDependencyGitSource (name, git) -> Printf.sprintf "Invalid [dependencies].%s git source %S." name git
  | InvalidDependencyIndexSource (name, index) -> Printf.sprintf "Invalid [dependencies].%s package-index identity %S." name index
  | InvalidDependencyVersionRequirement (name, version) -> Printf.sprintf "Invalid [dependencies].%s version requirement %S." name version
  | MissingDependencyRevision name -> Printf.sprintf "Git dependency [dependencies].%s must declare a non-empty rev field." name
  | MissingDependencyVersionRequirement name -> Printf.sprintf "Indexed dependency [dependencies].%s must declare a valid version requirement." name
  | BranchDependencyUnsupported name -> Printf.sprintf "Dependency [dependencies].%s uses branch, but Kyokai dependencies must not store moving branch references." name
  | InvalidModuleRoot path -> Printf.sprintf "Invalid [layout].module_root %S; it must be a non-empty relative path that does not escape the package root." path
  | InvalidWorkspaceMemberPath path -> Printf.sprintf "Invalid [workspace].members entry %S; it must be a non-empty relative package-root path that does not escape the workspace root or name the workspace root itself." path
  | DuplicateWorkspaceMemberPath path -> Printf.sprintf "Duplicate [workspace].members entry %S." path
  | InvalidExecutableTargetName name -> Printf.sprintf "Invalid executable target name %S." name
  | InvalidExecutableTargetKind (name, kind) -> Printf.sprintf "Executable target %S uses unsupported kind %S; the current standardized kind is \"executable\"." name kind
  | InvalidExecutableTargetModule (name, module_name) -> Printf.sprintf "Executable target %S has invalid module path %S." name module_name
  | InvalidExecutableTargetEntry (name, entry) -> Printf.sprintf "Executable target %S has invalid entry declaration name %S." name entry
  | InvalidExecutableTargetOutput (name, output) -> Printf.sprintf "Executable target %S has invalid output stem %S." name output
  | DuplicateDefaultExecutableTarget (first, second) -> Printf.sprintf "Executable targets %S and %S both set default = true." first second

let render_discovery_error error =
  match error with
  | ModuleRootMissing path -> Printf.sprintf "The manifest-declared module root does not exist: %S." path
  | ModuleRootIsNotDirectory path -> Printf.sprintf "The manifest-declared module root is not a directory: %S." path
  | ModuleRootEscapesPackageRoot path -> Printf.sprintf "The manifest-declared module root escapes the package root after canonical path resolution: %S." path
  | SourceOutsideModuleRoot path -> Printf.sprintf "Source path is outside the manifest-declared module root: %S." path
  | InvalidModulePath path -> Printf.sprintf "Source path does not map to a legal PascalCase dotted module name: %S." path
  | DuplicateModuleSource (module_name, first_path, second_path) ->
     Printf.sprintf "Duplicate .kyo source for module %s: %S and %S."
       (module_name_to_string module_name) first_path second_path
  | GeneratedArtifactDiscovered path -> Printf.sprintf ".koi is a generated interface artifact, not source: %S." path
  | RetiredSourceExtensionDiscovered path ->
     Printf.sprintf ".kai is a retired source extension; each Kyokai module is one .kyo file: %S." path
  | InheritedSourceExtensionDiscovered path ->
     Printf.sprintf "Inherited Austral .aui/.aum files are not Kyokai source; use one .kyo file per module: %S." path
  | SourceReadError message -> Printf.sprintf "Could not read source file: %s" message
  | ParsedModuleNameMismatch (expected, actual, path) ->
     Printf.sprintf "Module declaration mismatch in %S: expected %s, got %s."
       path (module_name_to_string expected) (module_name_to_string actual)
  | ParserError (path, parser_error) ->
     Printf.sprintf "Could not parse %S: %s" path (KyokaiSurfaceParser.render_error parser_error)
  | ControlFlowValidationErrors (path, errors) ->
     Printf.sprintf "Invalid control flow in %S: %s"
       path
       (String.concat " " (List.map KyokaiControlFlowValidation.render_error errors))
  | InterfaceValidationErrors (path, errors) ->
     Printf.sprintf "Could not derive a valid interface for %S: %s"
       path
       (String.concat " " (List.map KyokaiInterfaceValidation.render_error errors))

let render_target_selection_error error =
  match error with
  | NoExecutableTargets ->
     "This package declares no executable targets."
  | UnknownExecutableTarget name ->
     Printf.sprintf "Unknown executable target %S." name
  | AmbiguousExecutableTarget names ->
     Printf.sprintf
       "Executable target selection is ambiguous; pass an explicit target name. Available targets: %s."
       (String.concat ", " names)
  | ExecutableTargetModuleMissing (target_name, module_name) ->
     Printf.sprintf "Executable target %S names missing module %s."
       target_name (module_name_to_string module_name)
  | ExecutableTargetEntryMissing (target_name, module_name, entry_name) ->
     Printf.sprintf "Executable target %S names entry %s.%s, but that function definition was not found in the target source."
       target_name (module_name_to_string module_name) entry_name

let render_load_error error =
  match error with
  | LoadManifestError manifest_error -> render_manifest_error manifest_error
  | LoadTargetSelectionError target_selection_error ->
     render_target_selection_error target_selection_error
  | LoadDiscoveryErrors errors ->
     errors |> List.map render_discovery_error |> String.concat "\n"
  | LoadSourceError (source_file, discovery_error) ->
     Printf.sprintf "Could not load source for module %s: %s"
       (module_name_to_string source_file.logical_module)
       (render_discovery_error discovery_error)

let render_workspace_load_error error =
  match error with
  | WorkspaceLoadManifestError manifest_error -> render_manifest_error manifest_error
  | WorkspaceMemberEscapesWorkspaceRoot member_root ->
     Printf.sprintf "Workspace member escapes the workspace root after canonical path resolution: %S." member_root
  | WorkspaceMemberLoadError (member_root, load_error) ->
     Printf.sprintf "Could not load workspace member %S: %s"
       member_root (render_load_error load_error)
  | DuplicateWorkspacePackageName (package_name, first_root, second_root) ->
     Printf.sprintf "Workspace package name %S is declared by both %S and %S."
       package_name first_root second_root
