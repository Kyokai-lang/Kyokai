(*
   Part of the Kyokai project.

   SPDX-License-Identifier: GPL-3.0-or-later
*)
open OUnit2
open Austral_core.KyokaiSourceText

let prepare_ok mode source =
  match prepare mode source with
  | Ok prepared -> prepared
  | Error error -> assert_failure (render_error error)

let prepare_error mode source expected =
  match prepare mode source with
  | Ok _ -> assert_failure "expected source-byte rejection"
  | Error error -> assert_bool (render_error error) (equal_error_kind error.kind expected)

let test_accept_lf_crlf_and_utf8 _ =
  let source = "// caf\195\169\r\nmodule body Main is\nseal;" in
  let prepared = prepare_ok RejectShebang source in
  assert_equal 0 (token_start_byte prepared);
  assert_equal 1 (token_start_line prepared)

let test_accept_entry_shebang _ =
  let source = "#!/usr/bin/env kyokai\nmodule body Main is\nseal;" in
  let prepared = prepare_ok ExecutableEntryBody source in
  assert_equal (String.index source '\n' + 1) (token_start_byte prepared);
  assert_equal 2 (token_start_line prepared)

let test_reject_disallowed_entry_shebang _ =
  prepare_error RejectShebang "#!/usr/bin/env kyokai\n" DisallowedShebang

let test_reject_later_shebang _ =
  prepare_error ExecutableEntryBody "// header\n#!wrong\n" DisallowedShebang

let test_reject_initial_bom _ =
  prepare_error RejectShebang "\239\187\191module" Utf8Bom

let test_reject_interior_bom _ =
  prepare_error RejectShebang "module\239\187\191body" Utf8Bom

let test_reject_invalid_utf8 _ =
  prepare_error RejectShebang "module\192\175" InvalidUtf8

let test_reject_utf8_surrogate _ =
  prepare_error RejectShebang "module\237\160\128" InvalidUtf8

let test_reject_bare_carriage_return _ =
  prepare_error RejectShebang "module\rbody" BareCarriageReturn

let test_unicode_scalar_column _ =
  match prepare RejectShebang "// caf\195\169\nmodule\rbody" with
  | Ok _ -> assert_failure "expected bare carriage-return rejection"
  | Error error ->
     assert_bool (render_error error) (equal_error_kind error.kind BareCarriageReturn);
     assert_equal 2 error.span.line;
     assert_equal 7 error.span.column

let suite =
  "KyokaiSourceText" >::: [
      "accept lf crlf and utf8" >:: test_accept_lf_crlf_and_utf8;
      "accept entry shebang" >:: test_accept_entry_shebang;
      "reject disallowed entry shebang" >:: test_reject_disallowed_entry_shebang;
      "reject later shebang" >:: test_reject_later_shebang;
      "reject initial bom" >:: test_reject_initial_bom;
      "reject interior bom" >:: test_reject_interior_bom;
      "reject invalid utf8" >:: test_reject_invalid_utf8;
      "reject utf8 surrogate" >:: test_reject_utf8_surrogate;
      "reject bare carriage return" >:: test_reject_bare_carriage_return;
      "unicode scalar column" >:: test_unicode_scalar_column;
    ]

let _ = run_test_tt_main suite
