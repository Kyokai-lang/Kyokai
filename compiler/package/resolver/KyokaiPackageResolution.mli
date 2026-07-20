(*
   Part of the Kyokai project.

   SPDX-License-Identifier: GPL-3.0-or-later
*)

(** Final-model package graph scaffold for Kyokai package resolution. *)

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

val package_instance_id : KyokaiPackageSource.package_manifest -> string

val resolve_workspace_manifests :
  KyokaiPackageSource.package_manifest list -> (resolved_graph, resolution_error) result

val render_resolution_error : resolution_error -> string
