(*
   Part of the Kyokai project.

   SPDX-License-Identifier: GPL-3.0-or-later
*)

(* kyokai:prooftrace id=FRONTEND-KYOKAI-INTERFACE-VALIDATION *)

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

let declaration_name declaration =
  match declaration.KyokaiSurfaceParser.declaration_name with
  | Some name -> name
  | None -> "<anonymous declaration>"

let declaration_generic_parameters declaration =
  (match declaration.KyokaiSurfaceParser.declaration_signature,
         declaration.KyokaiSurfaceParser.declaration_type_alias,
         declaration.KyokaiSurfaceParser.declaration_record,
         declaration.KyokaiSurfaceParser.declaration_union,
         declaration.KyokaiSurfaceParser.declaration_typeclass,
         declaration.KyokaiSurfaceParser.declaration_instance,
         declaration.KyokaiSurfaceParser.declaration_generator with
   | Some signature, _, _, _, _, _, _ -> signature.KyokaiSurfaceParser.function_generic_parameters
   | _, Some type_alias, _, _, _, _, _ -> type_alias.KyokaiSurfaceParser.type_alias_generic_parameters
   | _, _, Some record, _, _, _, _ -> record.KyokaiSurfaceParser.record_generic_parameters
   | _, _, _, Some union, _, _, _ -> union.KyokaiSurfaceParser.union_generic_parameters
   | _, _, _, _, Some typeclass, _, _ -> typeclass.KyokaiSurfaceParser.typeclass_generic_parameters
   | _, _, _, _, _, Some instance, _ -> instance.KyokaiSurfaceParser.instance_generic_parameters
   | _, _, _, _, _, _, Some generator -> generator.KyokaiSurfaceParser.generator_generic_parameters
   | None, None, None, None, None, None, None -> [])
  |> List.map (fun parameter -> parameter.KyokaiSurfaceParser.generic_parameter_name)

let rec type_references type_ref =
  match type_ref with
  | KyokaiSurfaceParser.NamedType (path, arguments) ->
     path :: List.concat_map generic_argument_type_references arguments
  | KyokaiSurfaceParser.ReadBorrowType (inner, _)
  | KyokaiSurfaceParser.WriteBorrowType (inner, _) -> type_references inner
  | KyokaiSurfaceParser.FunctionPointerType (parameters, return_type) ->
     List.concat_map type_references parameters @ type_references return_type

and generic_argument_type_references argument =
  match argument with
  | KyokaiSurfaceParser.TypeArgument type_ref -> type_references type_ref
  | KyokaiSurfaceParser.UnresolvedNameArgument path -> [path]
  | KyokaiSurfaceParser.ConstArgument _ -> []

let field_references field =
  type_references field.KyokaiSurfaceParser.record_field_type

let variant_references variant =
  match variant.KyokaiSurfaceParser.union_variant_payload with
  | KyokaiSurfaceParser.NoVariantPayload -> []
  | KyokaiSurfaceParser.UnnamedVariantPayload payload -> type_references payload
  | KyokaiSurfaceParser.NamedVariantPayload fields ->
     List.concat_map field_references fields

let declaration_references declaration =
  let constant_references =
    match declaration.KyokaiSurfaceParser.declaration_constant with
    | None -> []
    | Some summary -> type_references summary.KyokaiSurfaceParser.constant_type
  in
  let signature_references =
    match declaration.KyokaiSurfaceParser.declaration_signature with
    | None -> []
    | Some signature ->
       let parameters =
         signature.KyokaiSurfaceParser.function_parameters
         |> List.concat_map (fun parameter ->
              type_references parameter.KyokaiSurfaceParser.parameter_type)
       in
       parameters @ type_references signature.KyokaiSurfaceParser.function_return_type
  in
  let alias_references =
    match declaration.KyokaiSurfaceParser.declaration_type_alias with
    | None -> []
    | Some summary -> type_references summary.KyokaiSurfaceParser.type_alias_target
  in
  let typeclass_references =
    match declaration.KyokaiSurfaceParser.declaration_typeclass with
    | None -> []
    | Some summary ->
       summary.KyokaiSurfaceParser.typeclass_items
       |> List.concat_map (function
            | KyokaiSurfaceParser.AssociatedTypeDeclaration _ -> []
            | KyokaiSurfaceParser.TypeclassMethod (_, signature, _) ->
               let parameters =
                 signature.KyokaiSurfaceParser.function_parameters
                 |> List.concat_map (fun parameter ->
                      type_references parameter.KyokaiSurfaceParser.parameter_type)
               in
               parameters @ type_references signature.KyokaiSurfaceParser.function_return_type)
  in
  let instance_references =
    match declaration.KyokaiSurfaceParser.declaration_instance with
    | None -> []
    | Some summary ->
       let obligation_references =
         summary.KyokaiSurfaceParser.instance_where_obligations
         |> List.concat_map (function
              | KyokaiSurfaceParser.TypeclassBound (type_ref, _) -> type_references type_ref
              | KyokaiSurfaceParser.AssociatedTypeEquality (left, right) ->
                 type_references left @ type_references right)
       in
       let item_references =
         summary.KyokaiSurfaceParser.instance_items
         |> List.concat_map (function
              | KyokaiSurfaceParser.AssociatedTypeDefinition (_, type_ref) -> type_references type_ref
              | KyokaiSurfaceParser.InstanceMethod (_, signature, _) ->
                 let parameters =
                   signature.KyokaiSurfaceParser.function_parameters
                   |> List.concat_map (fun parameter ->
                        type_references parameter.KyokaiSurfaceParser.parameter_type)
                 in
                 parameters @ type_references signature.KyokaiSurfaceParser.function_return_type)
       in
       type_references summary.KyokaiSurfaceParser.instance_target_type
       @ obligation_references
       @ item_references
  in
  let generator_references =
    match declaration.KyokaiSurfaceParser.declaration_generator with
    | None -> []
    | Some summary ->
       let parameters =
         summary.KyokaiSurfaceParser.generator_parameters
         |> List.concat_map (fun parameter ->
              type_references parameter.KyokaiSurfaceParser.parameter_type)
       in
       let obligations =
         summary.KyokaiSurfaceParser.generator_where_obligations
         |> List.concat_map (function
              | KyokaiSurfaceParser.TypeclassBound (type_ref, _) -> type_references type_ref
              | KyokaiSurfaceParser.AssociatedTypeEquality (left, right) ->
                 type_references left @ type_references right)
       in
       parameters
       @ type_references summary.KyokaiSurfaceParser.generator_yield_type
       @ obligations
  in
  let foreign_references =
    match declaration.KyokaiSurfaceParser.declaration_foreign_block with
    | None -> []
    | Some summary ->
       summary.KyokaiSurfaceParser.foreign_declarations
       |> List.concat_map (function
            | KyokaiSurfaceParser.ForeignFunction (_, parameters, return_type) ->
               let parameter_references =
                 parameters
                 |> List.concat_map (fun parameter ->
                      type_references parameter.KyokaiSurfaceParser.parameter_type)
               in
               parameter_references @ type_references return_type
            | KyokaiSurfaceParser.ForeignConstant (_, constant_type) ->
               type_references constant_type)
  in
  let representation_references =
    if declaration.KyokaiSurfaceParser.declaration_opaque then
      []
    else
      match declaration.KyokaiSurfaceParser.declaration_record,
            declaration.KyokaiSurfaceParser.declaration_union with
      | Some record, _ -> List.concat_map field_references record.KyokaiSurfaceParser.record_fields
      | _, Some union -> List.concat_map variant_references union.KyokaiSurfaceParser.union_variants
      | None, None -> []
  in
  constant_references
  @ signature_references
  @ alias_references
  @ typeclass_references
  @ instance_references
  @ generator_references
  @ foreign_references
  @ representation_references

let local_reference_name module_name generic_parameters path =
  match path with
  | [name] when not (List.mem name generic_parameters) -> Some name
  | _ ->
     let module_length = List.length module_name in
     if List.length path = module_length + 1
        && List.for_all2 String.equal module_name (List.rev (List.tl (List.rev path))) then
       Some (List.hd (List.rev path))
     else
       None

let visibility_allows exposing hidden =
  match exposing, hidden with
  | KyokaiSurfaceParser.Public, KyokaiSurfaceParser.Public -> true
  | KyokaiSurfaceParser.Internal, KyokaiSurfaceParser.Public
  | KyokaiSurfaceParser.Internal, KyokaiSurfaceParser.Internal -> true
  | KyokaiSurfaceParser.Private, _ -> true
  | _ -> false

let leak_kind hidden =
  match hidden with
  | KyokaiSurfaceParser.Private -> PrivateTypeLeak
  | KyokaiSurfaceParser.Internal -> InternalTypeLeak
  | KyokaiSurfaceParser.Public -> invalid_arg "public declarations do not leak visibility"

let validate_declaration source_unit declarations declaration =
  let exposing_visibility = declaration.KyokaiSurfaceParser.declaration_visibility in
  let exposing_declaration = declaration_name declaration in
  let generic_parameters = declaration_generic_parameters declaration in
  let private_opaque_error =
    if declaration.KyokaiSurfaceParser.declaration_opaque
       && KyokaiSurfaceParser.equal_visibility exposing_visibility KyokaiSurfaceParser.Private then
      [{
        interface_error_kind = PrivateOpaqueDeclaration;
        exposing_declaration;
        exposing_visibility;
        hidden_declaration = None;
        hidden_visibility = None;
        referenced_type = None;
        exposing_span = declaration.KyokaiSurfaceParser.declaration_span;
        hidden_span = None;
      }]
    else
      []
  in
  let leak_errors =
    declaration_references declaration
    |> List.filter_map (fun path ->
         match local_reference_name source_unit.KyokaiSurfaceParser.module_name generic_parameters path with
         | None -> None
         | Some name ->
            begin match List.find_opt
              (fun candidate -> candidate.KyokaiSurfaceParser.declaration_name = Some name)
              declarations with
            | None -> None
            | Some hidden ->
               let hidden_visibility = hidden.KyokaiSurfaceParser.declaration_visibility in
               if visibility_allows exposing_visibility hidden_visibility then
                 None
               else
                 Some {
                   interface_error_kind = leak_kind hidden_visibility;
                   exposing_declaration;
                   exposing_visibility;
                   hidden_declaration = Some name;
                   hidden_visibility = Some hidden_visibility;
                   referenced_type = Some (String.concat "." path);
                   exposing_span = declaration.KyokaiSurfaceParser.declaration_span;
                   hidden_span = Some hidden.KyokaiSurfaceParser.declaration_span;
                 }
            end)
  in
  private_opaque_error @ leak_errors

let validate_source_unit source_unit =
  let declarations = source_unit.KyokaiSurfaceParser.declarations in
  let errors =
    declarations
    |> List.concat_map (validate_declaration source_unit declarations)
  in
  if errors = [] then Ok () else Error errors

let render_visibility visibility =
  match visibility with
  | KyokaiSurfaceParser.Public -> "public"
  | KyokaiSurfaceParser.Internal -> "internal"
  | KyokaiSurfaceParser.Private -> "private"

let render_error error =
  match error.interface_error_kind with
  | PrivateOpaqueDeclaration ->
     Printf.sprintf
       "Declaration %S is private, so 'opaque' cannot define an external representation boundary; mark the type public or internal, or remove 'opaque'."
       error.exposing_declaration
  | PrivateTypeLeak | InternalTypeLeak ->
     let hidden_declaration = Option.value ~default:"<unknown>" error.hidden_declaration in
     let hidden_visibility =
       error.hidden_visibility
       |> Option.map render_visibility
       |> Option.value ~default:"hidden"
     in
     let referenced_type = Option.value ~default:hidden_declaration error.referenced_type in
     Printf.sprintf
       "%s declaration %S exposes %s type %S through reference %S."
       (String.capitalize_ascii (render_visibility error.exposing_visibility))
       error.exposing_declaration
       hidden_visibility
       hidden_declaration
       referenced_type
