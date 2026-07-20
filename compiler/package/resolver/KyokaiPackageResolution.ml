(*
   Part of the Kyokai project.

   SPDX-License-Identifier: GPL-3.0-or-later
*)

(* kyokai:prooftrace id=PACKAGE-RESOLVER-GRAPH-SCAFFOLD *)

type package_instance = {
  instance_id: string;
  package_name: string;
  package_version: string;
  package_edition: string;
  package_root: string;
} [@@deriving eq]

type dependency_requirement =
  | WorkspaceRequirement of string
  | GitRequirement of { git: string; rev: string; tag: string option }
  | IndexRequirement of { index: string; version: string }
[@@deriving eq]

type dependency_edge = {
  edge_id: string;
  from_instance: string;
  dependency_name: string;
  to_instance: string;
  requirement: dependency_requirement;
} [@@deriving eq]

type resolved_graph = {
  graph_roots: string list;
  graph_packages: package_instance list;
  graph_edges: dependency_edge list;
} [@@deriving eq]

type resolution_error =
  | DuplicatePackageIdentity of string * string * string
  | UnknownWorkspaceDependency of string * string * string
  | UnsupportedExternalDependency of string * string * dependency_requirement
  | PackageDependencyCycle of string list
[@@deriving eq]

let package_instance_id manifest =
  Printf.sprintf "workspace:%s@%s#%s"
    manifest.KyokaiPackageSource.package_name
    manifest.KyokaiPackageSource.package_version
    manifest.KyokaiPackageSource.package_edition

let package_instance_of_manifest manifest =
  {
    instance_id = package_instance_id manifest;
    package_name = manifest.KyokaiPackageSource.package_name;
    package_version = manifest.KyokaiPackageSource.package_version;
    package_edition = manifest.KyokaiPackageSource.package_edition;
    package_root = manifest.KyokaiPackageSource.package_root;
  }

let dependency_requirement_of_source source =
  match source with
  | KyokaiPackageSource.WorkspaceDependency package_name -> WorkspaceRequirement package_name
  | KyokaiPackageSource.GitDependency { git; rev; tag } -> GitRequirement { git; rev; tag }
  | KyokaiPackageSource.IndexDependency { index; version } -> IndexRequirement { index; version }

let edge_id ~from_instance ~dependency_name ~to_instance =
  from_instance ^ "::" ^ dependency_name ^ "->" ^ to_instance

let compare_instance left right = String.compare left.instance_id right.instance_id

let compare_edge left right = String.compare left.edge_id right.edge_id

let sorted_manifests manifests =
  List.sort
    (fun left right ->
      String.compare
        left.KyokaiPackageSource.package_name
        right.KyokaiPackageSource.package_name)
    manifests

let find_manifest_by_name manifests package_name =
  List.find_opt
    (fun manifest -> manifest.KyokaiPackageSource.package_name = package_name)
    manifests

let check_duplicate_package_names manifests =
  let sorted = sorted_manifests manifests in
  let rec loop previous remaining =
    match previous, remaining with
    | _, [] -> Ok ()
    | None, manifest :: rest -> loop (Some manifest) rest
    | Some previous, manifest :: _
         when previous.KyokaiPackageSource.package_name = manifest.KyokaiPackageSource.package_name ->
       Error (DuplicatePackageIdentity
                (manifest.KyokaiPackageSource.package_name,
                 previous.KyokaiPackageSource.package_root,
                 manifest.KyokaiPackageSource.package_root))
    | Some _, manifest :: rest -> loop (Some manifest) rest
  in
  loop None sorted

let edges_for_manifest manifests manifest =
  let from_instance = package_instance_id manifest in
  let rec loop edges dependencies =
    match dependencies with
    | [] -> Ok (List.rev edges)
    | dependency :: rest ->
       let dependency_name = dependency.KyokaiPackageSource.dependency_name in
       let requirement = dependency_requirement_of_source dependency.KyokaiPackageSource.dependency_source in
       begin match requirement with
       | WorkspaceRequirement target_name ->
          begin match find_manifest_by_name manifests target_name with
          | None -> Error (UnknownWorkspaceDependency (manifest.KyokaiPackageSource.package_name, dependency_name, target_name))
          | Some target ->
             let to_instance = package_instance_id target in
             let edge = { edge_id = edge_id ~from_instance ~dependency_name ~to_instance; from_instance; dependency_name; to_instance; requirement } in
             loop (edge :: edges) rest
          end
       | GitRequirement _ | IndexRequirement _ ->
          Error (UnsupportedExternalDependency (manifest.KyokaiPackageSource.package_name, dependency_name, requirement))
       end
  in
  loop [] manifest.KyokaiPackageSource.package_dependencies

let package_name_for_instance packages instance_id =
  match List.find_opt (fun package -> package.instance_id = instance_id) packages with
  | None -> instance_id
  | Some package -> package.package_name

let detect_cycle packages edges =
  let outgoing instance_id =
    edges
    |> List.filter (fun edge -> edge.from_instance = instance_id)
    |> List.map (fun edge -> edge.to_instance)
  in
  let rec visit stack visiting visited instance_id =
    if List.mem instance_id visiting then
      let cycle =
        instance_id :: stack
        |> List.rev
        |> List.map (package_name_for_instance packages)
      in
      Error (PackageDependencyCycle cycle)
    else if List.mem instance_id visited then Ok visited
    else
      let visiting = instance_id :: visiting in
      let stack = instance_id :: stack in
      let rec visit_children visited children =
        match children with
        | [] -> Ok (instance_id :: visited)
        | child :: rest ->
           begin match visit stack visiting visited child with
           | Error error -> Error error
           | Ok visited -> visit_children visited rest
           end
      in
      visit_children visited (outgoing instance_id)
  in
  let rec loop visited instances =
    match instances with
    | [] -> Ok ()
    | instance :: rest ->
       begin match visit [] [] visited instance.instance_id with
       | Error error -> Error error
       | Ok visited -> loop visited rest
       end
  in
  loop [] packages

let resolve_workspace_manifests manifests =
  match check_duplicate_package_names manifests with
  | Error error -> Error error
  | Ok () ->
     let packages = manifests |> List.map package_instance_of_manifest |> List.sort compare_instance in
     let rec collect_edges edges remaining =
       match remaining with
       | [] -> Ok (List.sort compare_edge edges)
       | manifest :: rest ->
          begin match edges_for_manifest manifests manifest with
          | Error error -> Error error
          | Ok manifest_edges -> collect_edges (List.rev_append manifest_edges edges) rest
          end
     in
     begin match collect_edges [] (sorted_manifests manifests) with
     | Error error -> Error error
     | Ok graph_edges ->
        begin match detect_cycle packages graph_edges with
        | Error error -> Error error
        | Ok () ->
           Ok {
             graph_roots = packages |> List.map (fun package -> package.instance_id);
             graph_packages = packages;
             graph_edges;
           }
        end
     end

let render_requirement requirement =
  match requirement with
  | WorkspaceRequirement package_name -> "workspace:" ^ package_name
  | GitRequirement { git; rev; tag = None } -> Printf.sprintf "git:%s@%s" git rev
  | GitRequirement { git; rev; tag = Some tag } -> Printf.sprintf "git:%s@%s tag %s" git rev tag
  | IndexRequirement { index; version } -> Printf.sprintf "index:%s %s" index version

let render_resolution_error error =
  match error with
  | DuplicatePackageIdentity (package_name, first_root, second_root) ->
     Printf.sprintf "Duplicate workspace package %S at %S and %S." package_name first_root second_root
  | UnknownWorkspaceDependency (package_name, dependency_name, target_name) ->
     Printf.sprintf "Package %S dependency %S names unknown workspace package %S."
       package_name dependency_name target_name
  | UnsupportedExternalDependency (package_name, dependency_name, requirement) ->
     Printf.sprintf "Package %S dependency %S requires unsupported resolver lane %S."
       package_name dependency_name (render_requirement requirement)
  | PackageDependencyCycle cycle ->
     Printf.sprintf "Package dependency cycle: %s." (String.concat " -> " cycle)
