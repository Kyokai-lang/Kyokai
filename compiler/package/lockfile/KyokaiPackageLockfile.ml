(*
   Part of the Kyokai project.

   SPDX-License-Identifier: GPL-3.0-or-later
*)

(* kyokai:prooftrace id=PACKAGE-LOCKFILE-SCAFFOLD *)

type lock_header = {
  schema: int;
  resolver: string;
  feature_resolver: string;
  owner_kind: string;
  owner_path: string;
  lock_mode: string;
} [@@deriving eq]

type lock_root = {
  root_name: string;
  root_instance: string;
} [@@deriving eq]

type lock_package = {
  package_instance: string;
  package_name: string;
  package_version: string;
  package_edition: string;
  source_kind: string;
  source_path: string;
  selected_features: string list;
  target_contract: string;
  semantic_profile: string;
  koi_digest: string option;
  docs_digest: string option;
  source_provenance: string option;
} [@@deriving eq]

type lock_edge = {
  edge_from: string;
  edge_dependency: string;
  edge_to: string;
  dependency_class: string;
  requested_features: string list;
  target_condition: string;
  capability_summary: string;
  introduced_by: string;
} [@@deriving eq]

type lockfile = {
  lock: lock_header;
  roots: lock_root list;
  packages: lock_package list;
  edges: lock_edge list;
} [@@deriving eq]

type lockfile_error =
  | MissingLockHeader
  | MissingLockField of string
  | InvalidLockInteger of string * string
  | InvalidLockString of string * string
  | InvalidLockArray of string * string
  | InvalidLockTable of string
  | DuplicateLockedPackage of string
  | UnknownRootPackage of string
  | UnknownEdgePackage of string * string
[@@deriving eq]

type table = LockTable | RootTable | PackageTable | EdgeTable

type value = StringValue of string | IntValue of int | StringListValue of string list

let trim text =
  let length = String.length text in
  let is_space = function ' ' | '\t' | '\r' | '\n' -> true | _ -> false in
  let rec first index = if index >= length then length else if is_space text.[index] then first (index + 1) else index in
  let rec last index = if index < 0 then -1 else if is_space text.[index] then last (index - 1) else index in
  let start = first 0 in
  let finish = last (length - 1) in
  if finish < start then "" else String.sub text start (finish - start + 1)

let split_once text needle =
  match String.index_opt text needle with
  | None -> None
  | Some index -> Some (String.sub text 0 index, String.sub text (index + 1) (String.length text - index - 1))

let strip_comment line =
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

let parse_string key raw =
  let raw = trim raw in
  let length = String.length raw in
  if length < 2 || raw.[0] <> '"' || raw.[length - 1] <> '"' then Error (InvalidLockString (key, raw))
  else Ok (String.sub raw 1 (length - 2))

let parse_array key raw =
  let raw = trim raw in
  let length = String.length raw in
  if length < 2 || raw.[0] <> '[' || raw.[length - 1] <> ']' then Error (InvalidLockArray (key, raw))
  else
    let inner = trim (String.sub raw 1 (length - 2)) in
    if inner = "" then Ok []
    else
      inner
      |> String.split_on_char ','
      |> List.map trim
      |> List.fold_left
           (fun acc item ->
             match acc with
             | Error _ -> acc
             | Ok items ->
                begin match parse_string key item with
                | Ok value -> Ok (value :: items)
                | Error error -> Error error
                end)
           (Ok [])
      |> Result.map List.rev

let parse_value key raw =
  let raw = trim raw in
  if raw = "" then Error (InvalidLockString (key, raw))
  else if raw.[0] = '"' then Result.map (fun value -> StringValue value) (parse_string key raw)
  else if raw.[0] = '[' then Result.map (fun value -> StringListValue value) (parse_array key raw)
  else
    match int_of_string_opt raw with
    | Some value -> Ok (IntValue value)
    | None -> Error (InvalidLockInteger (key, raw))

let parse_table_header line =
  match trim line with
  | "[lock]" -> Ok LockTable
  | "[[root]]" -> Ok RootTable
  | "[[package]]" -> Ok PackageTable
  | "[[edge]]" -> Ok EdgeTable
  | other -> Error (InvalidLockTable other)

let parse_records source =
  let finish current records =
    match current with
    | None -> records
    | Some (table, fields) -> (table, List.rev fields) :: records
  in
  let rec loop current records lines =
    match lines with
    | [] -> Ok (List.rev (finish current records))
    | line :: rest ->
       let line = trim (strip_comment line) in
       if line = "" then loop current records rest
       else if line.[0] = '[' then
         begin match parse_table_header line with
         | Error error -> Error error
         | Ok table -> loop (Some (table, [])) (finish current records) rest
         end
       else
         begin match current, split_once line '=' with
         | None, _ -> Error MissingLockHeader
         | _, None -> Error (InvalidLockString ("line", line))
         | Some (table, fields), Some (raw_key, raw_value) ->
            let key = trim raw_key in
            begin match parse_value key raw_value with
            | Error error -> Error error
            | Ok value -> loop (Some (table, (key, value) :: fields)) records rest
            end
         end
  in
  loop None [] (String.split_on_char '\n' source)

let field fields key = List.assoc_opt key fields

let require_string fields key =
  match field fields key with
  | Some (StringValue value) -> Ok value
  | Some _ -> Error (InvalidLockString (key, ""))
  | None -> Error (MissingLockField key)

let require_int fields key =
  match field fields key with
  | Some (IntValue value) -> Ok value
  | Some _ -> Error (InvalidLockInteger (key, ""))
  | None -> Error (MissingLockField key)

let require_array fields key =
  match field fields key with
  | Some (StringListValue value) -> Ok value
  | Some _ -> Error (InvalidLockArray (key, ""))
  | None -> Error (MissingLockField key)

let optional_string fields key =
  match field fields key with
  | Some (StringValue "") | None -> Ok None
  | Some (StringValue value) -> Ok (Some value)
  | Some _ -> Error (InvalidLockString (key, ""))

let parse_header records =
  match List.find_opt (fun (table, _) -> table = LockTable) records with
  | None -> Error MissingLockHeader
  | Some (_, fields) ->
     Result.bind (require_int fields "schema") (fun schema ->
     Result.bind (require_string fields "resolver") (fun resolver ->
     Result.bind (require_string fields "feature_resolver") (fun feature_resolver ->
     Result.bind (require_string fields "owner_kind") (fun owner_kind ->
     Result.bind (require_string fields "owner_path") (fun owner_path ->
     Result.map (fun lock_mode -> { schema; resolver; feature_resolver; owner_kind; owner_path; lock_mode })
       (require_string fields "lock_mode"))))))

let parse_root fields =
  Result.bind (require_string fields "name") (fun root_name ->
  Result.map (fun root_instance -> { root_name; root_instance })
    (require_string fields "instance"))

let parse_package fields =
  Result.bind (require_string fields "instance") (fun package_instance ->
  Result.bind (require_string fields "name") (fun package_name ->
  Result.bind (require_string fields "version") (fun package_version ->
  Result.bind (require_string fields "edition") (fun package_edition ->
  Result.bind (require_string fields "source_kind") (fun source_kind ->
  Result.bind (require_string fields "source_path") (fun source_path ->
  Result.bind (require_array fields "selected_features") (fun selected_features ->
  Result.bind (require_string fields "target_contract") (fun target_contract ->
  Result.bind (require_string fields "semantic_profile") (fun semantic_profile ->
  Result.bind (optional_string fields "koi_digest") (fun koi_digest ->
  Result.bind (optional_string fields "docs_digest") (fun docs_digest ->
  Result.map (fun source_provenance ->
    { package_instance; package_name; package_version; package_edition; source_kind; source_path; selected_features; target_contract; semantic_profile; koi_digest; docs_digest; source_provenance })
    (optional_string fields "source_provenance"))))))))))))

let parse_edge fields =
  Result.bind (require_string fields "from") (fun edge_from ->
  Result.bind (require_string fields "dependency") (fun edge_dependency ->
  Result.bind (require_string fields "to") (fun edge_to ->
  Result.bind (require_string fields "dependency_class") (fun dependency_class ->
  Result.bind (require_array fields "requested_features") (fun requested_features ->
  Result.bind (require_string fields "target_condition") (fun target_condition ->
  Result.bind (require_string fields "capability_summary") (fun capability_summary ->
  Result.map (fun introduced_by ->
    { edge_from; edge_dependency; edge_to; dependency_class; requested_features; target_condition; capability_summary; introduced_by })
    (require_string fields "introduced_by"))))))))

let collect table parser records =
  records
  |> List.filter (fun (record_table, _) -> record_table = table)
  |> List.fold_left
       (fun acc (_, fields) ->
         match acc with
         | Error _ -> acc
         | Ok values -> Result.map (fun value -> value :: values) (parser fields))
       (Ok [])
  |> Result.map List.rev

let compare_root left right = String.compare left.root_instance right.root_instance

let compare_package left right = String.compare left.package_instance right.package_instance

let compare_edge left right =
  match String.compare left.edge_from right.edge_from with
  | 0 -> String.compare left.edge_dependency right.edge_dependency
  | order -> order

let validate lockfile =
  let packages = List.sort compare_package lockfile.packages in
  let rec check_duplicates previous remaining =
    match previous, remaining with
    | _, [] -> Ok ()
    | None, package :: rest -> check_duplicates (Some package.package_instance) rest
    | Some previous, package :: _ when previous = package.package_instance -> Error (DuplicateLockedPackage previous)
    | Some _, package :: rest -> check_duplicates (Some package.package_instance) rest
  in
  let package_exists instance = List.exists (fun package -> package.package_instance = instance) packages in
  Result.bind (check_duplicates None packages) (fun () ->
  Result.bind
    (lockfile.roots
     |> List.find_opt (fun root -> not (package_exists root.root_instance))
     |> function None -> Ok () | Some root -> Error (UnknownRootPackage root.root_instance))
    (fun () ->
      lockfile.edges
      |> List.find_opt (fun edge -> not (package_exists edge.edge_from) || not (package_exists edge.edge_to))
      |> function
      | None -> Ok ()
      | Some edge -> Error (UnknownEdgePackage (edge.edge_from, edge.edge_to))))

let parse source =
  Result.bind (parse_records source) (fun records ->
  Result.bind (parse_header records) (fun lock ->
  Result.bind (collect RootTable parse_root records) (fun roots ->
  Result.bind (collect PackageTable parse_package records) (fun packages ->
  Result.bind (collect EdgeTable parse_edge records) (fun edges ->
    let lockfile = { lock; roots = List.sort compare_root roots; packages = List.sort compare_package packages; edges = List.sort compare_edge edges } in
    Result.map (fun () -> lockfile) (validate lockfile))))))

let quote text = "\"" ^ String.escaped text ^ "\""

let render_array values =
  "[" ^ (values |> List.map quote |> String.concat ", ") ^ "]"

let render_optional = function None -> "" | Some value -> value

let render_header header =
  Printf.sprintf "[lock]\nschema = %d\nresolver = %s\nfeature_resolver = %s\nowner_kind = %s\nowner_path = %s\nlock_mode = %s\n"
    header.schema (quote header.resolver) (quote header.feature_resolver) (quote header.owner_kind) (quote header.owner_path) (quote header.lock_mode)

let render_root root =
  Printf.sprintf "[[root]]\nname = %s\ninstance = %s\n" (quote root.root_name) (quote root.root_instance)

let render_package package =
  Printf.sprintf "[[package]]\ninstance = %s\nname = %s\nversion = %s\nedition = %s\nsource_kind = %s\nsource_path = %s\nselected_features = %s\ntarget_contract = %s\nsemantic_profile = %s\nkoi_digest = %s\ndocs_digest = %s\nsource_provenance = %s\n"
    (quote package.package_instance) (quote package.package_name) (quote package.package_version) (quote package.package_edition)
    (quote package.source_kind) (quote package.source_path) (render_array package.selected_features)
    (quote package.target_contract) (quote package.semantic_profile)
    (quote (render_optional package.koi_digest)) (quote (render_optional package.docs_digest)) (quote (render_optional package.source_provenance))

let render_edge edge =
  Printf.sprintf "[[edge]]\nfrom = %s\ndependency = %s\nto = %s\ndependency_class = %s\nrequested_features = %s\ntarget_condition = %s\ncapability_summary = %s\nintroduced_by = %s\n"
    (quote edge.edge_from) (quote edge.edge_dependency) (quote edge.edge_to) (quote edge.dependency_class)
    (render_array edge.requested_features) (quote edge.target_condition) (quote edge.capability_summary) (quote edge.introduced_by)

let render lockfile =
  let lockfile = { lockfile with roots = List.sort compare_root lockfile.roots; packages = List.sort compare_package lockfile.packages; edges = List.sort compare_edge lockfile.edges } in
  String.concat "\n"
    ([render_header lockfile.lock]
     @ List.map render_root lockfile.roots
     @ List.map render_package lockfile.packages
     @ List.map render_edge lockfile.edges)

let repair source = Result.map render (parse source)

let requirement_to_string requirement =
  match requirement with
  | KyokaiPackageResolution.WorkspaceRequirement package_name -> "workspace:" ^ package_name
  | KyokaiPackageResolution.GitRequirement { git; rev; tag = None } -> Printf.sprintf "git:%s@%s" git rev
  | KyokaiPackageResolution.GitRequirement { git; rev; tag = Some tag } -> Printf.sprintf "git:%s@%s#%s" git rev tag
  | KyokaiPackageResolution.IndexRequirement { index; version } -> Printf.sprintf "index:%s %s" index version

let of_workspace_resolution ~owner_path graph =
  let lock = {
    schema = 1;
    resolver = "kyokai-resolver-1";
    feature_resolver = "kyokai-feature-resolver-1";
    owner_kind = "workspace";
    owner_path;
    lock_mode = "locked";
  } in
  let roots =
    graph.KyokaiPackageResolution.graph_packages
    |> List.map (fun (package: KyokaiPackageResolution.package_instance) ->
      { root_name = package.package_name; root_instance = package.instance_id })
  in
  let packages =
    graph.KyokaiPackageResolution.graph_packages
    |> List.map (fun (package: KyokaiPackageResolution.package_instance) ->
      {
        package_instance = package.instance_id;
        package_name = package.package_name;
        package_version = package.package_version;
        package_edition = package.package_edition;
        source_kind = "workspace";
        source_path = package.package_root;
        selected_features = [];
        target_contract = "host-independent";
        semantic_profile = "default";
        koi_digest = None;
        docs_digest = None;
        source_provenance = Some "workspace-manifest";
      })
  in
  let edges =
    graph.KyokaiPackageResolution.graph_edges
    |> List.map (fun (edge: KyokaiPackageResolution.dependency_edge) ->
      {
        edge_from = edge.from_instance;
        edge_dependency = edge.dependency_name;
        edge_to = edge.to_instance;
        dependency_class = "normal";
        requested_features = [];
        target_condition = "all";
        capability_summary = "none";
        introduced_by = requirement_to_string edge.requirement;
      })
  in
  { lock; roots; packages; edges }

let render_lockfile_error error =
  match error with
  | MissingLockHeader -> "Missing [lock] header."
  | MissingLockField field -> Printf.sprintf "Missing lockfile field %S." field
  | InvalidLockInteger (field, value) -> Printf.sprintf "Invalid integer lockfile field %S = %S." field value
  | InvalidLockString (field, value) -> Printf.sprintf "Invalid string lockfile field %S = %S." field value
  | InvalidLockArray (field, value) -> Printf.sprintf "Invalid array lockfile field %S = %S." field value
  | InvalidLockTable table -> Printf.sprintf "Invalid lockfile table %S." table
  | DuplicateLockedPackage instance -> Printf.sprintf "Duplicate lockfile package instance %S." instance
  | UnknownRootPackage instance -> Printf.sprintf "Lockfile root references unknown package instance %S." instance
  | UnknownEdgePackage (from_instance, to_instance) ->
     Printf.sprintf "Lockfile edge references unknown package instance %S -> %S." from_instance to_instance
