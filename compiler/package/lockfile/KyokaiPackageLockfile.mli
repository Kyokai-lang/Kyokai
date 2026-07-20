(*
   Part of the Kyokai project.

   SPDX-License-Identifier: GPL-3.0-or-later
*)

(** Deterministic Kyokai lockfile scaffold using the final D528 record families. *)

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

val of_workspace_resolution :
  owner_path:string -> KyokaiPackageResolution.resolved_graph -> lockfile

val validate : lockfile -> (unit, lockfile_error) result

val render : lockfile -> string

val parse : string -> (lockfile, lockfile_error) result

val repair : string -> (string, lockfile_error) result

val render_lockfile_error : lockfile_error -> string
