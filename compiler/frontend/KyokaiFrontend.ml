(*
   Part of the Kyokai project.

   SPDX-License-Identifier: GPL-3.0-or-later
*)

(* kyokai:prooftrace id=FRONTEND-KYOKAI-PHASE3-PIPELINE *)

type checked_source = {
  source_unit: KyokaiSurfaceParser.source_unit;
  derived_interface_declarations: KyokaiSurfaceParser.declaration list;
} [@@deriving eq]

type error =
  | ParseError of KyokaiSurfaceParser.error
  | ControlFlowErrors of KyokaiControlFlowValidation.error list
  | InterfaceErrors of KyokaiInterfaceValidation.error list
[@@deriving eq]

let derived_interface_declarations source_unit =
  List.filter
    (fun declaration ->
      not (KyokaiSurfaceParser.equal_visibility
             declaration.KyokaiSurfaceParser.declaration_visibility
             KyokaiSurfaceParser.Private))
    source_unit.KyokaiSurfaceParser.declarations

let check_source ~executable_entry path source =
  match KyokaiSurfaceParser.parse_source ~executable_entry path source with
  | Error error -> Error (ParseError error)
  | Ok source_unit ->
     begin match KyokaiControlFlowValidation.validate_source_unit source_unit with
     | Error errors -> Error (ControlFlowErrors errors)
     | Ok () ->
        begin match KyokaiInterfaceValidation.validate_source_unit source_unit with
        | Error errors -> Error (InterfaceErrors errors)
        | Ok () ->
           Ok {
             source_unit;
             derived_interface_declarations = derived_interface_declarations source_unit;
           }
        end
     end

let render_error = function
  | ParseError error -> KyokaiSurfaceParser.render_error error
  | ControlFlowErrors errors ->
     String.concat "\n" (List.map KyokaiControlFlowValidation.render_error errors)
  | InterfaceErrors errors ->
     String.concat "\n" (List.map KyokaiInterfaceValidation.render_error errors)
