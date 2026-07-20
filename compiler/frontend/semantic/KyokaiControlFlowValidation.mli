(*
   Part of the Kyokai project.

   SPDX-License-Identifier: GPL-3.0-or-later
*)

(** Context validation for structured statements and expression-owned blocks. *)

type error_kind =
  | BreakOutsideLoop
  | ContinueOutsideLoop
  | OrBreakOutsideLoop
  | OrContinueOutsideLoop
  | YieldOutsideGenerator
  | ProduceOutsideBuild
  | SpawnOutsideTaskgroup
[@@deriving eq]

type error = {
  control_flow_error_kind: error_kind;
  control_flow_error_span: KyokaiSurfaceParser.span;
} [@@deriving eq]

val validate_source_unit :
  KyokaiSurfaceParser.source_unit -> (unit, error list) result

val render_error : error -> string
