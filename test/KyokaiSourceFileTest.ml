(*
   Part of the Kyokai project.

   SPDX-License-Identifier: GPL-3.0-or-later
*)
open OUnit2
open Austral_core.KyokaiSourceFile

let classify_ok path expected =
  match classify_source_path path with
  | Ok actual -> assert_bool "classified source path" (equal_source_path actual expected)
  | Error error -> assert_failure (render_error error)

let classify_error path expected =
  match classify_source_path path with
  | Ok _ -> assert_failure "expected source-path rejection"
  | Error actual -> assert_bool "source-path error" (equal_error actual expected)

let test_body_path _ =
  classify_ok "src/Main.kai" (BodyPath "src/Main.kai")

let test_interface_path _ =
  classify_ok "src/Math.kyo" (InterfacePath "src/Math.kyo")

let test_reject_generated_artifact _ =
  classify_error "build/Math.koi" (GeneratedArtifactIsNotSource "build/Math.koi")

let test_reject_inherited_austral_path _ =
  classify_error "src/Main.aum" (UnknownSourceExtension "src/Main.aum")

let test_reject_empty_path _ =
  classify_error "" EmptyPath

let prepare_source_ok ~executable_entry source_path source =
  match prepare_source_text ~executable_entry source_path source with
  | Ok prepared -> prepared
  | Error error -> assert_failure (Austral_core.KyokaiSourceText.render_error error)

let prepare_source_error ~executable_entry source_path source expected =
  match prepare_source_text ~executable_entry source_path source with
  | Ok _ -> assert_failure "expected source-text rejection"
  | Error error ->
     assert_bool (Austral_core.KyokaiSourceText.render_error error)
       (Austral_core.KyokaiSourceText.equal_error_kind error.kind expected)

let test_entry_body_accepts_shebang _ =
  let source = "#!/usr/bin/env kyokai\nmodule body Main is\nseal;" in
  let prepared = prepare_source_ok ~executable_entry:true (BodyPath "src/Main.kai") source in
  assert_equal 2 (Austral_core.KyokaiSourceText.token_start_line prepared)

let test_nonentry_body_rejects_shebang _ =
  prepare_source_error ~executable_entry:false (BodyPath "src/Util.kai") "#!wrong\n"
    Austral_core.KyokaiSourceText.DisallowedShebang

let test_interface_rejects_shebang _ =
  prepare_source_error ~executable_entry:true (InterfacePath "src/Main.kyo") "#!wrong\n"
    Austral_core.KyokaiSourceText.DisallowedShebang

let suite =
  "KyokaiSourceFile" >::: [
      "body .kai" >:: test_body_path;
      "interface .kyo" >:: test_interface_path;
      "reject .koi source" >:: test_reject_generated_artifact;
      "reject inherited Austral extension" >:: test_reject_inherited_austral_path;
      "reject empty path" >:: test_reject_empty_path;
      "entry body accepts shebang" >:: test_entry_body_accepts_shebang;
      "non-entry body rejects shebang" >:: test_nonentry_body_rejects_shebang;
      "interface rejects shebang" >:: test_interface_rejects_shebang;
    ]

let _ = run_test_tt_main suite
