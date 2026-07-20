(*
   Part of the Kyokai project.

   SPDX-License-Identifier: GPL-3.0-or-later
*)
open OUnit2
open Kyokai_frontend.KyokaiLexicalToken

let scan_ok source =
  match scan source with
  | Ok tokens -> tokens
  | Error error -> assert_failure (render_error error)

let scan_error source expected =
  match scan source with
  | Ok _ -> assert_failure "expected lexical rejection"
  | Error error -> assert_bool (render_error error) (equal_error_kind error.kind expected)

let kinds source =
  List.map (fun (token: token) -> token.kind) (scan_ok source)

let test_comments _ =
  assert_equal
    [Comment LineComment; Comment DeclarationDocComment; Comment ModuleDocComment; Eof]
    (kinds "// ordinary\n/// decl\n//! module")

let test_keyword_identifier_and_not_equal _ =
  assert_equal [Keyword; Identifier; Symbol; Identifier; Eof]
    (kinds "module value != other")

let test_grammar_reserved_words _ =
  let source =
    "additional_invariant below bit bitrecord bits compile_error contract covers default " ^
    "drop field fn from method module_invariant produce qed reserved target timeout to wait wake"
  in
  let actual = kinds source in
  let expected = List.init (List.length actual - 1) (fun _ -> Keyword) @ [Eof] in
  assert_equal expected actual

let test_contextual_words_remain_identifiers _ =
  let source =
    "result old ignore assumes requires preserves forbids maps_failure owns borrows " ^
    "transfers threading lifetime layout reentrancy cleanup exports evidence"
  in
  let actual = kinds source in
  let expected = List.init (List.length actual - 1) (fun _ -> Identifier) @ [Eof] in
  assert_equal expected actual

let test_borrow_creation_operators _ =
  assert_equal [Symbol; Identifier; Symbol; Identifier; Symbol; Identifier; Eof]
    (kinds "&read value &write slot &reborrow loan")

let test_reject_retired_reborrow_operator _ =
  scan_error "&~loan" (UnsupportedInheritedForm "&~")

let test_numeric_forms_and_suffixes _ =
  assert_equal
    [ IntegerLiteral (Decimal, None);
      IntegerLiteral (Hexadecimal, Some "n64");
      IntegerLiteral (Binary, None);
      IntegerLiteral (Octal, None);
      FloatLiteral (Some "f32");
      Eof ]
    (kinds "1_000 0xDEAD_BEEFn64 0b1010_0101 0o755 3.141_592f32")

let test_minus_is_separate _ =
  assert_equal [Symbol; IntegerLiteral (Decimal, None); Eof] (kinds "-42")

let test_symbol_family _ =
  let actual = kinds ":= != <= >= -> => ++ &! .. ( ) [ ] { } , . : ; = < > + - * / % & ~" in
  let expected = List.init (List.length actual - 1) (fun _ -> Symbol) @ [Eof] in
  assert_equal expected actual

let test_numeric_edge_acceptance _ =
  assert_equal
    [ FloatLiteral None; FloatLiteral (Some "f64"); IntegerLiteral (Hexadecimal, None);
      IntegerLiteral (Binary, None); IntegerLiteral (Octal, None); Eof ]
    (kinds "1e10 1.f64 0xA_B 0b1_0 0o7_5")

let test_numeric_edge_rejection _ =
  List.iter (fun source -> scan_error source InvalidNumericLiteral)
    ["0x"; "0b102"; "0o8"; "1_"; "1e"; "1._0"; "1e_2"; "1f32"]

let test_reject_inherited_forms _ =
  List.iter (fun source -> scan_error source (UnsupportedInheritedForm source))
    ["--"; "/="; "#x"; "#b"; "#o"; "/*"; "|>"]

let test_comptime_builtins _ =
  assert_equal
    [ ComptimeBuiltin "@embedBytes"; Symbol; StaticStringLiteral EscapedString; Symbol;
      ComptimeBuiltin "@embedText"; Symbol; StaticStringLiteral EscapedString; Symbol; Eof ]
    (kinds "@embedBytes(\"asset.bin\") @embedText(\"asset.txt\")")

let test_reject_unknown_comptime_builtin _ =
  scan_error "@embedFile(\"asset.bin\")" UnknownComptimeBuiltin

let test_reject_extended_comptime_builtin _ =
  scan_error "@embedBytesExtra(\"asset.bin\")" UnknownComptimeBuiltin

let test_literal_families _ =
  assert_equal
    [ StaticStringLiteral EscapedString;
      StaticStringLiteral RawMultilineString;
      CodePointLiteral;
      CodePointLiteral;
      ByteLiteral;
      ByteLiteral;
      Eof ]
    (kinds "\"hello\\n\" \"\"\"raw\ntext\"\"\" 'A' '\\u{1F600}' b'A' b'\\xFF'")

let test_reject_unterminated_literal _ =
  scan_error "\"unterminated" UnterminatedLiteral

let test_reject_invalid_literal_escape _ =
  scan_error "\"\\q\"" InvalidLiteralEscape

let test_reject_multi_scalar_code_point _ =
  scan_error "'ab'" InvalidLiteralContents

let test_reject_raw_non_ascii_byte _ =
  scan_error "b'\195\169'" InvalidLiteralContents

let test_reject_wide_escaped_byte _ =
  scan_error "b'\\u{100}'" InvalidLiteralContents

let test_accept_escape_family _ =
  assert_equal
    [StaticStringLiteral EscapedString; ByteLiteral; Eof]
    (kinds "\"\\\\\\\"\\'\\n\\r\\t\\0\\x41\\u{1F600}\" b'\\u{FF}'")

let test_accept_unicode_string _ =
  assert_equal [StaticStringLiteral EscapedString; Eof] (kinds "\"caf\195\169\"")

let test_reject_string_newline _ =
  scan_error "\"line\nnext\"" UnterminatedLiteral

let test_reject_short_hex_escape _ =
  scan_error "\"\\xF\"" InvalidLiteralEscape

let test_reject_invalid_unicode_escape _ =
  scan_error "\"\\u{D800}\"" InvalidLiteralEscape

let test_reject_high_unicode_escape _ =
  scan_error "\"\\u{110000}\"" InvalidLiteralEscape

let test_reject_empty_code_point _ =
  scan_error "''" InvalidLiteralContents

let test_span_after_crlf _ =
  match scan_ok "// hi\r\nmodule" with
  | _comment :: keyword :: _ ->
     assert_equal 2 keyword.span.start_line;
     assert_equal 1 keyword.span.start_column;
     assert_equal 7 keyword.span.start_byte
  | _ -> assert_failure "expected comment and keyword"

let test_reject_austral_comment _ =
  scan_error "-- inherited" (UnsupportedInheritedForm "--")

let test_reject_austral_not_equal _ =
  scan_error "left /= right" (UnsupportedInheritedForm "/=")

let test_reject_austral_base_prefix _ =
  scan_error "#xFF" (UnsupportedInheritedForm "#x")

let test_reject_austral_binary_and_octal_prefixes _ =
  scan_error "#b1010" (UnsupportedInheritedForm "#b");
  scan_error "#o755" (UnsupportedInheritedForm "#o")

let test_reject_apostrophe_separator _ =
  scan_error "1'000" (UnsupportedInheritedForm "apostrophe numeric separator")

let test_reject_bad_separator _ =
  scan_error "1__000" InvalidNumericLiteral

let test_reject_compound_numeric_suffix _ =
  scan_error "1UL" InvalidNumericLiteral

let test_reject_platform_char_literals _ =
  scan_error "L'A'" (UnsupportedInheritedForm "L'");
  scan_error "u'A'" (UnsupportedInheritedForm "u'");
  scan_error "U'A'" (UnsupportedInheritedForm "U'");
  scan_error "u8'A'" (UnsupportedInheritedForm "u8'")

let test_reject_wildcard_token _ =
  scan_error "_" InvalidCharacter

let test_reject_non_ascii_identifier _ =
  scan_error "caf\195\169" NonAsciiIdentifier

let test_reject_bare_carriage_return _ =
  scan_error "module\rbody" BareCarriageReturn

let test_reject_invalid_utf8 _ =
  scan_error "module\192\175" InvalidUtf8

let test_reject_bom _ =
  scan_error "\239\187\191module" Utf8Bom

let test_reject_unprepared_shebang _ =
  scan_error "#!/usr/bin/env kyokai\nmodule body Main is\nseal;" DisallowedShebang

let test_scan_prepared_entry_shebang _ =
  let source = "#!/usr/bin/env kyokai\nmodule body Main is\nseal;" in
  match Kyokai_frontend.KyokaiSourceText.prepare Kyokai_frontend.KyokaiSourceText.ExecutableEntrySource source with
  | Error error -> assert_failure (Kyokai_frontend.KyokaiSourceText.render_error error)
  | Ok prepared ->
     begin match scan_prepared prepared with
     | Error error -> assert_failure (render_error error)
     | Ok (keyword :: _) ->
        assert_bool "module keyword" (equal_token_kind keyword.kind Keyword);
        assert_equal 2 keyword.span.start_line;
        assert_equal (Kyokai_frontend.KyokaiSourceText.token_start_byte prepared) keyword.span.start_byte
     | Ok [] -> assert_failure "expected tokens"
     end

let suite =
  "KyokaiLexicalToken" >::: [
      "comments" >:: test_comments;
      "keyword identifier and !=" >:: test_keyword_identifier_and_not_equal;
      "grammar reserved words" >:: test_grammar_reserved_words;
      "contextual words remain identifiers" >:: test_contextual_words_remain_identifiers;
      "borrow creation operators" >:: test_borrow_creation_operators;
      "reject retired reborrow operator" >:: test_reject_retired_reborrow_operator;
      "numeric forms and suffixes" >:: test_numeric_forms_and_suffixes;
      "minus separate from literal" >:: test_minus_is_separate;
      "symbol family" >:: test_symbol_family;
      "numeric edge acceptance" >:: test_numeric_edge_acceptance;
      "numeric edge rejection" >:: test_numeric_edge_rejection;
      "reject inherited forms" >:: test_reject_inherited_forms;
      "comptime builtins" >:: test_comptime_builtins;
      "reject unknown comptime builtin" >:: test_reject_unknown_comptime_builtin;
      "reject extended comptime builtin" >:: test_reject_extended_comptime_builtin;
      "literal families" >:: test_literal_families;
      "reject unterminated literal" >:: test_reject_unterminated_literal;
      "reject invalid literal escape" >:: test_reject_invalid_literal_escape;
      "reject multi-scalar code point" >:: test_reject_multi_scalar_code_point;
      "reject raw non-ASCII byte" >:: test_reject_raw_non_ascii_byte;
      "reject wide escaped byte" >:: test_reject_wide_escaped_byte;
      "accept escape family" >:: test_accept_escape_family;
      "accept unicode string" >:: test_accept_unicode_string;
      "reject string newline" >:: test_reject_string_newline;
      "reject short hex escape" >:: test_reject_short_hex_escape;
      "reject invalid unicode escape" >:: test_reject_invalid_unicode_escape;
      "reject high unicode escape" >:: test_reject_high_unicode_escape;
      "reject empty code point" >:: test_reject_empty_code_point;
      "span after crlf" >:: test_span_after_crlf;
      "reject Austral comment" >:: test_reject_austral_comment;
      "reject Austral not-equal" >:: test_reject_austral_not_equal;
      "reject Austral base prefix" >:: test_reject_austral_base_prefix;
      "reject Austral binary and octal prefixes" >:: test_reject_austral_binary_and_octal_prefixes;
      "reject apostrophe separator" >:: test_reject_apostrophe_separator;
      "reject bad separator" >:: test_reject_bad_separator;
      "reject compound numeric suffix" >:: test_reject_compound_numeric_suffix;
      "reject platform char literals" >:: test_reject_platform_char_literals;
      "reject wildcard token" >:: test_reject_wildcard_token;
      "reject non-ASCII identifier" >:: test_reject_non_ascii_identifier;
      "reject bare carriage return" >:: test_reject_bare_carriage_return;
      "reject invalid utf8" >:: test_reject_invalid_utf8;
      "reject bom" >:: test_reject_bom;
      "reject unprepared shebang" >:: test_reject_unprepared_shebang;
      "scan prepared entry shebang" >:: test_scan_prepared_entry_shebang;
    ]

let _ = run_test_tt_main suite
