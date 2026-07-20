(*
   Part of the Kyokai project.

   SPDX-License-Identifier: GPL-3.0-or-later
*)

(** Phase 3 Kyokai frontend pipeline.

    This is the sole implementation entry from accepted source bytes through
    parsing and the phase-local structural checks. Resolution, typing,
    ownership, [.koi] production, and lowering belong to later phases. *)

type checked_source = {
  source_unit: KyokaiSurfaceParser.source_unit;
  derived_interface_declarations: KyokaiSurfaceParser.declaration list;
} [@@deriving eq]

type error =
  | ParseError of KyokaiSurfaceParser.error
  | ControlFlowErrors of KyokaiControlFlowValidation.error list
  | InterfaceErrors of KyokaiInterfaceValidation.error list
[@@deriving eq]

val check_source :
  executable_entry:bool -> string -> string -> (checked_source, error) result

val render_error : error -> string
