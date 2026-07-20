(*
   Part of the Kyokai project.

   SPDX-License-Identifier: GPL-3.0-or-later
*)

(** Semantic validation for the compiler-derived module interface. *)

type error_kind =
  | PrivateTypeLeak
  | InternalTypeLeak
  | PrivateOpaqueDeclaration
[@@deriving eq]

type error = {
  interface_error_kind: error_kind;
  exposing_declaration: string;
  exposing_visibility: KyokaiSurfaceParser.visibility;
  hidden_declaration: string option;
  hidden_visibility: KyokaiSurfaceParser.visibility option;
  referenced_type: string option;
  exposing_span: KyokaiSurfaceParser.span;
  hidden_span: KyokaiSurfaceParser.span option;
} [@@deriving eq]

(** Validate the visibility and opacity facts that can be decided from one
    parsed module. Imported and built-in names remain resolver work. *)
val validate_source_unit :
  KyokaiSurfaceParser.source_unit -> (unit, error list) result

val render_error : error -> string
