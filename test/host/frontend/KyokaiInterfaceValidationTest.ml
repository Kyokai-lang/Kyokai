(*
   Part of the Kyokai project.

   SPDX-License-Identifier: GPL-3.0-or-later
*)

open OUnit2
open Kyokai_frontend

let parse source =
  match KyokaiSurfaceParser.parse_source ~executable_entry:false "src/Demo/Api.kyo" source with
  | Ok source_unit -> source_unit
  | Error error -> assert_failure (KyokaiSurfaceParser.render_error error)

let validate_ok source =
  match KyokaiInterfaceValidation.validate_source_unit (parse source) with
  | Ok () -> ()
  | Error errors ->
     assert_failure
       (String.concat " " (List.map KyokaiInterfaceValidation.render_error errors))

let validate_error source expected_kind =
  match KyokaiInterfaceValidation.validate_source_unit (parse source) with
  | Ok () -> assert_failure "expected interface validation rejection"
  | Error [error] ->
     assert_bool
       (KyokaiInterfaceValidation.render_error error)
       (KyokaiInterfaceValidation.equal_error_kind
          error.KyokaiInterfaceValidation.interface_error_kind
          expected_kind);
     error
  | Error errors ->
     assert_failure
       (Printf.sprintf "expected one interface error, got %d" (List.length errors))

let test_public_function_rejects_private_type _ =
  let error = validate_error (String.concat "\n" [
      "module Demo.Api is";
      "record Hidden: Free is";
      "build;";
      "public function expose(value: Hidden): Unit is";
      "qed;";
      "seal;";
    ]) KyokaiInterfaceValidation.PrivateTypeLeak
  in
  assert_equal "expose" error.exposing_declaration;
  assert_equal (Some "Hidden") error.hidden_declaration;
  assert_equal (Some "Hidden") error.referenced_type

let test_public_record_rejects_internal_type _ =
  let error = validate_error (String.concat "\n" [
      "module Demo.Api is";
      "internal record PackageOnly: Free is";
      "build;";
      "public record Exported: Free is";
      "    value: PackageOnly;";
      "build;";
      "seal;";
    ]) KyokaiInterfaceValidation.InternalTypeLeak
  in
  assert_equal "Exported" error.exposing_declaration;
  assert_equal (Some "PackageOnly") error.hidden_declaration

let test_public_alias_rejects_private_type _ =
  let error = validate_error (String.concat "\n" [
      "module Demo.Api is";
      "record Hidden: Free is";
      "build;";
      "public type alias Exposed := Hidden;";
      "seal;";
    ]) KyokaiInterfaceValidation.PrivateTypeLeak
  in
  assert_equal "Exposed" error.exposing_declaration;
  assert_equal (Some "Hidden") error.hidden_declaration

let test_public_constant_rejects_private_type _ =
  let error = validate_error (String.concat "\n" [
      "module Demo.Api is";
      "record Hidden: Free is";
      "build;";
      "public constant exposed: Hidden := makeHidden();";
      "seal;";
    ]) KyokaiInterfaceValidation.PrivateTypeLeak
  in
  assert_equal "exposed" error.exposing_declaration;
  assert_equal (Some "Hidden") error.hidden_declaration

let test_public_typeclass_rejects_private_method_type _ =
  let error = validate_error (String.concat "\n" [
      "module Demo.Api is";
      "record Hidden: Free is";
      "build;";
      "public typeclass ExposesHidden[Self: Type] is";
      "    method expose(value: &[Self]): Hidden;";
      "spec;";
      "seal;";
    ]) KyokaiInterfaceValidation.PrivateTypeLeak
  in
  assert_equal "ExposesHidden" error.exposing_declaration;
  assert_equal (Some "Hidden") error.hidden_declaration

let test_public_generator_rejects_private_yield_type _ =
  let error = validate_error (String.concat "\n" [
      "module Demo.Api is";
      "record Hidden: Free is";
      "build;";
      "public generator expose(): Hidden is";
      "qed;";
      "seal;";
    ]) KyokaiInterfaceValidation.PrivateTypeLeak
  in
  assert_equal "expose" error.exposing_declaration;
  assert_equal (Some "Hidden") error.hidden_declaration

let test_opaque_record_hides_private_representation _ =
  validate_ok (String.concat "\n" [
      "module Demo.Api is";
      "record Hidden: Free is";
      "build;";
      "public opaque record Exported: Free is";
      "    value: Hidden;";
      "build;";
      "public function use(value: &[Exported]): Unit is";
      "qed;";
      "seal;";
    ])

let test_internal_function_rejects_private_type _ =
  ignore (validate_error (String.concat "\n" [
      "module Demo.Api is";
      "record Hidden: Free is";
      "build;";
      "internal function expose(value: Hidden): Unit is";
      "qed;";
      "seal;";
    ]) KyokaiInterfaceValidation.PrivateTypeLeak)

let test_private_surface_can_use_private_type _ =
  validate_ok (String.concat "\n" [
      "module Demo.Api is";
      "record Hidden: Free is";
      "build;";
      "function use(value: Demo.Api.Hidden): Unit is";
      "qed;";
      "seal;";
    ])

let test_private_opaque_is_rejected _ =
  let error = validate_error (String.concat "\n" [
      "module Demo.Api is";
      "opaque record Hidden: Free is";
      "build;";
      "seal;";
    ]) KyokaiInterfaceValidation.PrivateOpaqueDeclaration
  in
  assert_equal "Hidden" error.exposing_declaration

let suite =
  "KyokaiInterfaceValidation" >::: [
      "public function rejects private type" >:: test_public_function_rejects_private_type;
      "public record rejects internal type" >:: test_public_record_rejects_internal_type;
      "public alias rejects private type" >:: test_public_alias_rejects_private_type;
      "public constant rejects private type" >:: test_public_constant_rejects_private_type;
      "public typeclass rejects private method type" >:: test_public_typeclass_rejects_private_method_type;
      "public generator rejects private yield type" >:: test_public_generator_rejects_private_yield_type;
      "opaque record hides private representation" >:: test_opaque_record_hides_private_representation;
      "internal function rejects private type" >:: test_internal_function_rejects_private_type;
      "private surface can use private type" >:: test_private_surface_can_use_private_type;
      "private opaque is rejected" >:: test_private_opaque_is_rejected;
    ]

let _ = run_test_tt_main suite
