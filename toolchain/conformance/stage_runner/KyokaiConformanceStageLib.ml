(*
   Part of the Kyokai project.

   SPDX-License-Identifier: GPL-3.0-or-later
*)

(* kyokai:prooftrace id=TOOL-CONFORMANCE-FIXTURE-RUNNER *)

open Kyokai_frontend

exception Probe_failure of string

let fail message = raise (Probe_failure message)

let generic_parameter_names parameters =
  List.map
    (fun parameter -> parameter.KyokaiSurfaceParser.generic_parameter_name)
    parameters

type fixture_status =
  | Active
  | ImplementationGated
  | SpecGated
  | Historical

type fixture_result = {
  outcome: string;
  stage: string;
  code: string;
  facts: string list;
}

type fixture_metadata = {
  fixture_id: string;
  fixture_status: fixture_status;
  expected_result: fixture_result;
}

let path fixture_root relative = Filename.concat fixture_root relative

let read_file source_path =
  let channel = open_in_bin source_path in
  Fun.protect
    ~finally:(fun () -> close_in_noerr channel)
    (fun () -> really_input_string channel (in_channel_length channel))

let split_assignment line =
  try
    let index = String.index line '=' in
    let key = String.trim (String.sub line 0 index) in
    let value_start = index + 1 in
    let value_length = String.length line - value_start in
    let value = String.trim (String.sub line value_start value_length) in
    Some (key, value)
  with Not_found -> None

let strip_quotes value =
  let length = String.length value in
  if length >= 2 && value.[0] = '"' && value.[length - 1] = '"' then
    String.sub value 1 (length - 2)
  else
    value

let parse_string_array value =
  let value = String.trim value in
  let length = String.length value in
  if length < 2 || value.[0] <> '[' || value.[length - 1] <> ']' then
    fail (Printf.sprintf "expected TOML string array, got %S" value)
  else
    let body = String.trim (String.sub value 1 (length - 2)) in
    if body = "" then
      []
    else
      let rec loop index in_string escaped current acc =
        if index >= String.length body then
          let item = String.trim (Buffer.contents current) in
          if item = "" then List.rev acc
          else List.rev (strip_quotes item :: acc)
        else
          let char = body.[index] in
          if escaped then begin
            Buffer.add_char current char;
            loop (index + 1) in_string false current acc
          end else if char = '\\' && in_string then begin
            Buffer.add_char current char;
            loop (index + 1) in_string true current acc
          end else if char = '"' then begin
            Buffer.add_char current char;
            loop (index + 1) (not in_string) false current acc
          end else if char = ',' && not in_string then begin
            let item = String.trim (Buffer.contents current) in
            Buffer.clear current;
            if item = "" then
              loop (index + 1) in_string false current acc
            else
              loop (index + 1) in_string false current (strip_quotes item :: acc)
          end else begin
            Buffer.add_char current char;
            loop (index + 1) in_string false current acc
          end
      in
      loop 0 false false (Buffer.create (String.length body)) []

let fixture_status_of_string value =
  match value with
  | "active" -> Active
  | "implementation-gated" -> ImplementationGated
  | "spec-gated" -> SpecGated
  | "historical" -> Historical
  | _ -> fail (Printf.sprintf "unknown fixture status %S" value)

let fixture_status_to_string status =
  match status with
  | Active -> "active"
  | ImplementationGated -> "implementation-gated"
  | SpecGated -> "spec-gated"
  | Historical -> "historical"

let load_fixture_metadata fixture_path =
  let lines = String.split_on_char '\n' (read_file fixture_path) in
  let id = ref None in
  let status = ref None in
  let expected_outcome = ref None in
  let expected_stage = ref None in
  let expected_code = ref None in
  let expected_facts = ref [] in
  let set_field key value =
    match key with
    | "id" -> id := Some (strip_quotes value)
    | "status" -> status := Some (fixture_status_of_string (strip_quotes value))
    | "expected_outcome" -> expected_outcome := Some (strip_quotes value)
    | "expected_stage" -> expected_stage := Some (strip_quotes value)
    | "expected_code" -> expected_code := Some (strip_quotes value)
    | "expected_facts" -> expected_facts := parse_string_array value
    | _ -> ()
  in
  List.iter
    (fun raw_line ->
      let line = String.trim raw_line in
      if line <> "" && line.[0] <> '#' then
        match split_assignment line with
        | Some (key, value) -> set_field key value
        | None -> ())
    lines;
  match (!id, !status, !expected_outcome, !expected_stage, !expected_code) with
  | (Some fixture_id, Some fixture_status, Some outcome, Some stage, Some code) ->
     {
       fixture_id;
       fixture_status;
       expected_result = { outcome; stage; code; facts = List.sort String.compare !expected_facts };
     }
  | (None, _, _, _, _) -> fail (Printf.sprintf "%s is missing fixture id" fixture_path)
  | (_, None, _, _, _) -> fail (Printf.sprintf "%s is missing fixture status" fixture_path)
  | _ -> fail (Printf.sprintf "%s is missing machine-readable expected result" fixture_path)

let sorted_facts facts = List.sort String.compare facts

let fixture_result ~outcome ~stage ~code ~facts =
  { outcome; stage; code; facts = sorted_facts facts }

let render_result result =
  Printf.sprintf
    "outcome=%s stage=%s code=%s facts=[%s]"
    result.outcome
    result.stage
    result.code
    (String.concat "," result.facts)

let compare_result expected actual =
  if expected <> actual then
    fail
      (Printf.sprintf
         "fixture result mismatch: expected %s, got %s"
         (render_result expected)
         (render_result actual))

let is_directory candidate =
  try (Unix.stat candidate).Unix.st_kind = Unix.S_DIR
  with Unix.Unix_error _ -> false

let collect_fixture_files root =
  let rec collect directory acc =
    Array.fold_left
      (fun current name ->
        let candidate = Filename.concat directory name in
        if is_directory candidate then
          collect candidate current
        else if name = "fixture.toml" then
          candidate :: current
        else
          current)
      acc
      (Sys.readdir directory)
  in
  List.sort String.compare (collect root [])

let parse_source_ok fixture_root relative_path =
  let source_path = path fixture_root relative_path in
  let source = read_file source_path in
  match KyokaiSurfaceParser.parse_source ~executable_entry:false source_path source with
  | Ok _ -> ()
  | Error error ->
     fail (Printf.sprintf "%s unexpectedly failed to parse: %s"
             relative_path (KyokaiSurfaceParser.render_error error))

let accepted_source_skeleton fixture_root =
  let source_path = path fixture_root "src/Main.kyo" in
  let source = read_file source_path in
  match KyokaiSurfaceParser.parse_source ~executable_entry:false source_path source with
  | Error error -> fail (KyokaiSurfaceParser.render_error error)
  | Ok unit ->
     begin match unit.KyokaiSurfaceParser.declarations with
     | handle :: run :: main :: [] ->
        if not handle.KyokaiSurfaceParser.declaration_opaque then
          fail "Handle did not preserve the opaque representation marker";
        if not (KyokaiSurfaceParser.equal_visibility
                  handle.KyokaiSurfaceParser.declaration_visibility
                  KyokaiSurfaceParser.Public) then
          fail "Handle did not preserve public visibility";
        if not (KyokaiSurfaceParser.equal_visibility
                  run.KyokaiSurfaceParser.declaration_visibility
                  KyokaiSurfaceParser.Public) then
          fail "run did not preserve public visibility";
        if not (KyokaiSurfaceParser.equal_visibility
                  main.KyokaiSurfaceParser.declaration_visibility
                  KyokaiSurfaceParser.Private) then
          fail "main did not preserve private-by-default visibility"
     | _ -> fail "accepted source skeleton produced the wrong declaration set"
     end

let parse_source_rejects_inherited_comment fixture_root relative_path =
  let source_path = path fixture_root relative_path in
  let source = read_file source_path in
  match KyokaiSurfaceParser.parse_source ~executable_entry:false source_path source with
  | Ok _ -> fail (Printf.sprintf "%s unexpectedly parsed" relative_path)
  | Error { KyokaiSurfaceParser.parser_error_kind = LexicalError lexical_error; _ } ->
     begin match lexical_error.KyokaiLexicalToken.kind with
     | UnsupportedInheritedForm "--" -> ()
     | _ -> fail (Printf.sprintf "%s rejected for the wrong lexical reason: %s"
                    relative_path (KyokaiLexicalToken.render_error lexical_error))
     end
  | Error error ->
     fail (Printf.sprintf "%s rejected outside the lexical boundary: %s"
             relative_path (KyokaiSurfaceParser.render_error error))

let assert_line label expected actual =
  if expected <> actual then
    fail (Printf.sprintf "%s expected line %d, got line %d" label expected actual)

let source_span_skeleton fixture_root =
  let source_path = path fixture_root "src/Demo/Spans.kyo" in
  let source = read_file source_path in
  let source_unit =
    match KyokaiSurfaceParser.parse_source ~executable_entry:false source_path source with
    | Ok parsed -> parsed
    | Error error -> fail (KyokaiSurfaceParser.render_error error)
  in
  assert_line "module start" 4 source_unit.module_span.start_line;
  assert_line "module end" 10 source_unit.module_span.end_line;
  begin match source_unit.imports with
  | [import_item] -> assert_line "import start" 3 import_item.import_span.start_line
  | _ -> fail "source fixture expected exactly one import"
  end;
  begin match source_unit.pragmas with
  | [pragma_span] -> assert_line "pragma start" 2 pragma_span.start_line
  | _ -> fail "source fixture expected exactly one pragma"
  end;
  begin match source_unit.declarations with
  | [item; main] ->
     assert_line "record declaration start" 5 item.declaration_span.start_line;
     assert_line "record declaration end" 5 item.declaration_span.end_line;
     assert_line "function start" 6 main.declaration_span.start_line;
     assert_line "function end" 9 main.declaration_span.end_line;
     if main.declaration_name <> Some "main" then
       fail "function did not preserve declaration name";
     if main.declaration_terminator <> "qed" then
       fail "function did not preserve qed terminator"
  | _ -> fail "source fixture expected exactly two declarations"
  end

let expect_lexical_rejection fixture_root relative_path expected_kind =
  let source_path = path fixture_root relative_path in
  let source = read_file source_path in
  match KyokaiSurfaceParser.parse_source ~executable_entry:false source_path source with
  | Ok _ -> fail (Printf.sprintf "%s unexpectedly parsed" relative_path)
  | Error { KyokaiSurfaceParser.parser_error_kind = LexicalError lexical_error; _ }
    when KyokaiLexicalToken.equal_error_kind lexical_error.KyokaiLexicalToken.kind expected_kind -> ()
  | Error error ->
     fail (Printf.sprintf "%s rejected for the wrong reason: %s"
             relative_path (KyokaiSurfaceParser.render_error error))

let expect_parser_rejection fixture_root relative_path expected_kind =
  let source_path = path fixture_root relative_path in
  let source = read_file source_path in
  match KyokaiSurfaceParser.parse_source ~executable_entry:false source_path source with
  | Ok _ -> fail (Printf.sprintf "%s unexpectedly parsed" relative_path)
  | Error error when KyokaiSurfaceParser.equal_error_kind
                       error.KyokaiSurfaceParser.parser_error_kind expected_kind -> ()
  | Error error ->
     fail (Printf.sprintf "%s rejected for the wrong reason: %s"
             relative_path (KyokaiSurfaceParser.render_error error))

let expect_parser_rejection_any fixture_root relative_path =
  let source_path = path fixture_root relative_path in
  let source = read_file source_path in
  match KyokaiSurfaceParser.parse_source ~executable_entry:false source_path source with
  | Ok _ -> fail (Printf.sprintf "%s unexpectedly parsed" relative_path)
  | Error _ -> ()

let rejected_inherited_form_matrix fixture_root =
  expect_lexical_rejection fixture_root "src/austral-not-equal.kyo"
    (KyokaiLexicalToken.UnsupportedInheritedForm "/=");
  expect_lexical_rejection fixture_root "src/austral-base-prefix.kyo"
    (KyokaiLexicalToken.UnsupportedInheritedForm "#x");
  expect_lexical_rejection fixture_root "src/austral-binary-prefix.kyo"
    (KyokaiLexicalToken.UnsupportedInheritedForm "#b");
  expect_lexical_rejection fixture_root "src/austral-octal-prefix.kyo"
    (KyokaiLexicalToken.UnsupportedInheritedForm "#o");
  expect_lexical_rejection fixture_root "src/block-comment.kyo"
    (KyokaiLexicalToken.UnsupportedInheritedForm "/*");
  expect_lexical_rejection fixture_root "src/pipeline.kyo"
    (KyokaiLexicalToken.UnsupportedInheritedForm "|>");
  expect_lexical_rejection fixture_root "src/apostrophe-separator.kyo"
    (KyokaiLexicalToken.UnsupportedInheritedForm "apostrophe numeric separator");
  expect_lexical_rejection fixture_root "src/compound-suffix.kyo"
    KyokaiLexicalToken.InvalidNumericLiteral;
  expect_lexical_rejection fixture_root "src/platform-char-literal.kyo"
    (KyokaiLexicalToken.UnsupportedInheritedForm "L'");
  expect_lexical_rejection fixture_root "src/wildcard-pattern.kyo"
    KyokaiLexicalToken.InvalidCharacter;
  expect_parser_rejection fixture_root "src/module-body.kyo"
    KyokaiSurfaceParser.RetiredModuleBody;
  expect_parser_rejection fixture_root "src/explicit-private.kyo"
    KyokaiSurfaceParser.ExplicitPrivateMarker;
  expect_parser_rejection fixture_root "src/wildcard-import.kyo"
    KyokaiSurfaceParser.ExpectedIdentifier;
  expect_parser_rejection fixture_root "src/docstring-syntax.kyo"
    (KyokaiSurfaceParser.ExpectedToken "module");
  expect_parser_rejection fixture_root "src/arrow-field-access.kyo"
    (KyokaiSurfaceParser.ExpectedToken ";");
  expect_parser_rejection_any fixture_root "src/retired-read-borrow.kyo";
  expect_parser_rejection_any fixture_root "src/retired-write-borrow.kyo";
  expect_lexical_rejection fixture_root "src/retired-reborrow.kyo"
    (KyokaiLexicalToken.UnsupportedInheritedForm "&~")

let rejected_extra_syntax_matrix fixture_root =
  List.iter (expect_parser_rejection_any fixture_root)
    [ "src/tuple-expression.kyo";
      "src/class-declaration.kyo";
      "src/inheritance-declaration.kyo";
      "src/exception-declaration.kyo";
      "src/try-catch.kyo";
      "src/macro-definition.kyo";
      "src/block-local-import.kyo";
      "src/body-target-when.kyo";
      "src/pattern-guard.kyo";
      "src/drop-declaration.kyo";
      "src/module-var.kyo";
      "src/async-await.kyo" ]

let function_signature_summary fixture_root =
  let source_path = path fixture_root "src/Demo/Signatures.kyo" in
  let source = read_file source_path in
  let unit =
    match KyokaiSurfaceParser.parse_source ~executable_entry:false source_path source with
    | Ok parsed -> parsed
    | Error error -> fail (KyokaiSurfaceParser.render_error error)
  in
  match unit.KyokaiSurfaceParser.declarations with
  | [declaration] ->
     begin match declaration.KyokaiSurfaceParser.declaration_signature with
     | None -> fail "function signature fixture did not produce a signature summary"
     | Some signature ->
        begin match signature.KyokaiSurfaceParser.function_parameters with
        | [text; output] ->
           if declaration.KyokaiSurfaceParser.declaration_name <> Some "copyText" then
             fail "function signature fixture did not preserve function name";
           if generic_parameter_names signature.KyokaiSurfaceParser.function_generic_parameters <> ["T"] then
             fail "function signature fixture did not preserve generic parameter names";
           if text.KyokaiSurfaceParser.parameter_name <> "text" then
             fail "function signature fixture did not preserve first parameter name";
           if KyokaiSurfaceParser.render_type_ref text.KyokaiSurfaceParser.parameter_type <> "&[StaticString]" then
             fail "function signature fixture did not preserve first parameter type";
           if output.KyokaiSurfaceParser.parameter_name <> "output" then
             fail "function signature fixture did not preserve second parameter name";
           if KyokaiSurfaceParser.render_type_ref output.KyokaiSurfaceParser.parameter_type <> "&![Buffer[T]]" then
             fail "function signature fixture did not preserve second parameter type";
           if KyokaiSurfaceParser.render_type_ref signature.KyokaiSurfaceParser.function_return_type <> "Result[Unit, IoError]" then
             fail "function signature fixture did not preserve return type"
        | _ -> fail "function signature fixture produced the wrong parameter count"
        end
     end
  | _ -> fail "function signature fixture expected one declaration"

let structured_reference_and_fnptr fixture_root =
  let source_path = path fixture_root "src/Demo/Types.kyo" in
  let source = read_file source_path in
  let source_unit =
    match KyokaiSurfaceParser.parse_source ~executable_entry:false source_path source with
    | Ok source_unit -> source_unit
    | Error error -> fail (KyokaiSurfaceParser.render_error error)
  in
  match source_unit.KyokaiSurfaceParser.declarations with
  | [declaration] ->
     begin match declaration.KyokaiSurfaceParser.declaration_signature with
     | None -> fail "structured type fixture did not preserve function signature"
     | Some signature ->
        begin match signature.KyokaiSurfaceParser.function_generic_parameters with
        | [type_parameter; const_parameter; region_parameter]
          when KyokaiSurfaceParser.equal_generic_parameter_classifier
                 type_parameter.KyokaiSurfaceParser.generic_parameter_classifier
                 KyokaiSurfaceParser.TypeClassifier
               && KyokaiSurfaceParser.equal_generic_parameter_classifier
                    const_parameter.KyokaiSurfaceParser.generic_parameter_classifier
                    KyokaiSurfaceParser.IndexClassifier
               && KyokaiSurfaceParser.equal_generic_parameter_classifier
                    region_parameter.KyokaiSurfaceParser.generic_parameter_classifier
                    KyokaiSurfaceParser.RegionClassifier -> ()
        | _ -> fail "structured type fixture did not preserve generic parameter classifiers"
        end;
        begin match signature.KyokaiSurfaceParser.function_parameters with
        | [input; callback] ->
           if KyokaiSurfaceParser.render_type_ref input.KyokaiSurfaceParser.parameter_type
              <> "&[Buffer[T], R]" then
             fail "structured type fixture did not preserve named-region borrow";
           if KyokaiSurfaceParser.render_type_ref callback.KyokaiSurfaceParser.parameter_type
              <> "FnPtr(&[T], &![Buffer[T]]): Result[Unit, IoError]" then
             fail "structured type fixture did not preserve function-pointer parameter"
        | _ -> fail "structured type fixture produced the wrong parameter count"
        end;
        if KyokaiSurfaceParser.render_type_ref signature.KyokaiSurfaceParser.function_return_type
           <> "FnPtr(): Unit" then
          fail "structured type fixture did not preserve zero-parameter function-pointer return"
     end
  | _ -> fail "structured type fixture expected one declaration"

let where_clause_summary fixture_root =
  let source_path = path fixture_root "src/Demo/Constraints.kyo" in
  let source = read_file source_path in
  let source_unit =
    match KyokaiSurfaceParser.parse_source ~executable_entry:false source_path source with
    | Ok source_unit -> source_unit
    | Error error -> fail (KyokaiSurfaceParser.render_error error)
  in
  match source_unit.KyokaiSurfaceParser.declarations with
  | [declaration] ->
     begin match declaration.KyokaiSurfaceParser.declaration_signature with
     | None -> fail "where-clause fixture did not preserve function signature"
     | Some signature ->
        let obligations =
          List.map
            KyokaiSurfaceParser.render_where_obligation
            signature.KyokaiSurfaceParser.function_where_obligations
        in
        if obligations <> ["C: Iterable"; "C.Item: Displayable"; "C.Error == E"] then
          fail "where-clause fixture did not preserve structured obligations"
     end
  | _ -> fail "where-clause fixture expected one declaration"

let const_generic_arguments fixture_root =
  let source_path = path fixture_root "src/Demo/Shapes.kyo" in
  let source = read_file source_path in
  let source_unit =
    match KyokaiSurfaceParser.parse_source ~executable_entry:false source_path source with
    | Ok source_unit -> source_unit
    | Error error -> fail (KyokaiSurfaceParser.render_error error)
  in
  match source_unit.KyokaiSurfaceParser.declarations with
  | [declaration] ->
     begin match declaration.KyokaiSurfaceParser.declaration_record with
     | None -> fail "const-generic fixture did not preserve record summary"
     | Some summary ->
        let fields =
          List.map
            (fun field ->
              field.KyokaiSurfaceParser.record_field_name
              ^ ":"
              ^ KyokaiSurfaceParser.render_type_ref field.KyokaiSurfaceParser.record_field_type)
            summary.KyokaiSurfaceParser.record_fields
        in
        if fields <> [
             "data:Array[T, Rows * Cols]";
             "header:Array[Nat8, 32]";
             "grouped:Array[Nat8, (Rows + Cols) * 2]";
           ] then
          fail "const-generic fixture did not preserve generic arguments"
     end
  | _ -> fail "const-generic fixture expected one declaration"

let type_alias_summary fixture_root =
  let source_path = path fixture_root "src/Demo/Aliases.kyo" in
  let source = read_file source_path in
  let source_unit =
    match KyokaiSurfaceParser.parse_source ~executable_entry:false source_path source with
    | Ok source_unit -> source_unit
    | Error error -> fail (KyokaiSurfaceParser.render_error error)
  in
  match source_unit.KyokaiSurfaceParser.declarations with
  | [declaration] ->
     begin match declaration.KyokaiSurfaceParser.declaration_type_alias with
     | None -> fail "type-alias fixture did not preserve alias summary"
     | Some summary ->
        if declaration.KyokaiSurfaceParser.declaration_name <> Some "IoResult" then
          fail "type-alias fixture did not preserve alias name";
        if generic_parameter_names summary.KyokaiSurfaceParser.type_alias_generic_parameters <> ["T"] then
          fail "type-alias fixture did not preserve generic parameters";
        if KyokaiSurfaceParser.render_type_ref summary.KyokaiSurfaceParser.type_alias_target
           <> "Result[T, IoError]" then
          fail "type-alias fixture did not preserve target type"
     end
  | _ -> fail "type-alias fixture expected one declaration"

let constant_summary fixture_root =
  let source_path = path fixture_root "src/Demo/Constants.kyo" in
  let source = read_file source_path in
  let source_unit =
    match KyokaiSurfaceParser.parse_source ~executable_entry:false source_path source with
    | Ok source_unit -> source_unit
    | Error error -> fail (KyokaiSurfaceParser.render_error error)
  in
  match source_unit.KyokaiSurfaceParser.declarations with
  | [declaration] ->
     begin match declaration.KyokaiSurfaceParser.declaration_constant with
     | None -> fail "constant fixture did not preserve constant summary"
     | Some summary ->
        if declaration.KyokaiSurfaceParser.declaration_name <> Some "maxPathBytes" then
          fail "constant fixture did not preserve constant name";
        if KyokaiSurfaceParser.render_type_ref summary.KyokaiSurfaceParser.constant_type <> "Index" then
          fail "constant fixture did not preserve declared type";
        if KyokaiSurfaceParser.render_expression
             summary.KyokaiSurfaceParser.constant_initializer <> "4096" then
          fail "constant fixture did not preserve initializer expression"
     end
  | _ -> fail "constant fixture expected one declaration"

let expression_summary fixture_root =
  let source_path = path fixture_root "src/Demo/Expressions.kyo" in
  let source = read_file source_path in
  let source_unit =
    match KyokaiSurfaceParser.parse_source ~executable_entry:false source_path source with
    | Ok source_unit -> source_unit
    | Error error -> fail (KyokaiSurfaceParser.render_error error)
  in
  let rendered =
    List.map
      (fun declaration ->
        match declaration.KyokaiSurfaceParser.declaration_constant with
        | Some summary ->
           KyokaiSurfaceParser.render_expression
             summary.KyokaiSurfaceParser.constant_initializer
        | None -> fail "expression fixture declaration was not a constant")
      source_unit.KyokaiSurfaceParser.declarations
  in
  if rendered <>
       ["makeBuffer()";
        "values[start + 1..limit]";
        "Point { x: 2, with point }";
        "fn [limit, &cfg] (value: Int32): Bool => value < limit and cfg.ready";
        "fn [limit] (value: Int32): Int32 is return value + limit; qed";
        "build Pair do let left := 1; produce Pair { left, right: 2 }; build"] then
    fail "expression fixture did not preserve the shared expression structure"

let bitrecord_summary fixture_root =
  let source_path = path fixture_root "src/Demo/Bits.kyo" in
  let source = read_file source_path in
  let source_unit =
    match KyokaiSurfaceParser.parse_source ~executable_entry:false source_path source with
    | Ok source_unit -> source_unit
    | Error error -> fail (KyokaiSurfaceParser.render_error error)
  in
  match source_unit.KyokaiSurfaceParser.declarations with
  | [declaration] ->
     begin match declaration.KyokaiSurfaceParser.declaration_bitrecord with
     | None -> fail "bitrecord fixture did not preserve bitrecord summary"
     | Some summary ->
        if declaration.KyokaiSurfaceParser.declaration_name <> Some "TcpFlags" then
          fail "bitrecord fixture did not preserve declaration name";
        if summary.KyokaiSurfaceParser.bitrecord_backing_type <> "Nat16" then
          fail "bitrecord fixture did not preserve backing type";
        begin match summary.KyokaiSurfaceParser.bitrecord_items with
        | [KyokaiSurfaceParser.BitField ("fin", "0");
           KyokaiSurfaceParser.BitRangeField ("window", "7", "4");
           KyokaiSurfaceParser.ReservedBitRange ("15", "8")] -> ()
        | _ -> fail "bitrecord fixture did not preserve item structure"
        end
     end
  | _ -> fail "bitrecord fixture expected one declaration"

let function_contract_summary fixture_root =
  let source_path = path fixture_root "src/Demo/Contracts.kyo" in
  let source = read_file source_path in
  let source_unit =
    match KyokaiSurfaceParser.parse_source ~executable_entry:false source_path source with
    | Ok source_unit -> source_unit
    | Error error -> fail (KyokaiSurfaceParser.render_error error)
  in
  match source_unit.KyokaiSurfaceParser.declarations with
  | [declaration] ->
     begin match declaration.KyokaiSurfaceParser.declaration_signature with
     | None -> fail "contract fixture did not preserve function signature"
     | Some signature ->
        begin match signature.KyokaiSurfaceParser.function_contracts with
        | [KyokaiSurfaceParser.RequireContract require_expression;
           KyokaiSurfaceParser.EnsureContract ensure_expression]
             when require_expression.KyokaiSurfaceParser.expression_span.start_line = 3
                  && ensure_expression.KyokaiSurfaceParser.expression_span.start_line = 4
                  && KyokaiSurfaceParser.render_expression require_expression = "value >= 0"
                  && KyokaiSurfaceParser.render_expression ensure_expression = "result >= 0" -> ()
        | _ -> fail "contract fixture did not preserve ordered contract expressions"
        end
     end
  | _ -> fail "contract fixture expected one declaration"

let function_body_summary fixture_root =
  let source_path = path fixture_root "src/Demo/Bodies.kyo" in
  let source = read_file source_path in
  let source_unit =
    match KyokaiSurfaceParser.parse_source ~executable_entry:false source_path source with
    | Ok source_unit -> source_unit
    | Error error -> fail (KyokaiSurfaceParser.render_error error)
  in
  match source_unit.KyokaiSurfaceParser.declarations with
  | [declaration] ->
     begin match declaration.KyokaiSurfaceParser.declaration_name,
                 declaration.KyokaiSurfaceParser.declaration_body with
     | Some "classify", Some [pattern_statement; let_else_statement; or_return_statement;
                              mapped_return_statement; or_break_statement; or_continue_statement;
                              borrow_statement; taskgroup_statement; select_statement; wait_statement;
                              debug_statement; defer_statement; while_let_statement; if_statement] ->
        if KyokaiSurfaceParser.render_statement pattern_statement
           <> "let { x, y: ignore } := point;" then
          fail "function-body fixture did not preserve record pattern binding";
        if KyokaiSurfaceParser.render_statement let_else_statement
           <> "let Ok(result): Int32 := operation else Err(error) do return fallback; fi;" then
          fail "function-body fixture did not preserve let-else binding";
        if KyokaiSurfaceParser.render_statement or_return_statement
           <> "let Ok(saved) := save() or return;" then
          fail "function-body fixture did not preserve plain or-return";
        if KyokaiSurfaceParser.render_statement mapped_return_statement
           <> "let Ok(mapped) := load() or return error => wrap(error);" then
          fail "function-body fixture did not preserve mapped or-return";
        if KyokaiSurfaceParser.render_statement or_break_statement
           <> "let Ok(item) := next() or break retry;" then
          fail "function-body fixture did not preserve labeled or-break";
        if KyokaiSurfaceParser.render_statement or_continue_statement
           <> "let Ok(more) := advance() or continue retry;" then
          fail "function-body fixture did not preserve labeled or-continue";
        if KyokaiSurfaceParser.render_statement borrow_statement
           <> "borrow view := &read value do debug view; drop;" then
          fail "function-body fixture did not preserve borrow scope";
        if KyokaiSurfaceParser.render_statement taskgroup_statement
           <> "taskgroup do spawn [value, &counter] do debug value; od else spawn_error do debug spawn_error; fi; join;" then
          fail "function-body fixture did not preserve taskgroup and spawn";
        if KyokaiSurfaceParser.render_statement select_statement
           <> "select when receive(rx) do debug value; timeout(deadline) do debug deadline; pick;" then
          fail "function-body fixture did not preserve select arms";
        if KyokaiSurfaceParser.render_statement wait_statement
           <> "wait when ready(token) do debug token; default do debug idle; wake;" then
          fail "function-body fixture did not preserve wait arms";
        if KyokaiSurfaceParser.render_statement debug_statement <> "debug value;" then
          fail "function-body fixture did not preserve debug statement";
        if KyokaiSurfaceParser.render_statement defer_statement <> "defer closeLog();" then
          fail "function-body fixture did not preserve deferred call";
        if KyokaiSurfaceParser.render_statement while_let_statement
           <> "while let Some(next) := queue.next() do debug next; od;" then
          fail "function-body fixture did not preserve while-let pattern";
        begin match if_statement.KyokaiSurfaceParser.statement_kind with
        | KyokaiSurfaceParser.IfStatement (branches, Some [_]) when List.length branches = 2 -> ()
        | _ -> fail "function-body fixture did not preserve conditional branches"
        end
     | _ -> fail "function-body fixture did not preserve function body"
     end
  | _ -> fail "function-body fixture expected one declaration"

let declaration_guard_summary fixture_root =
  let source_path = path fixture_root "src/Demo/Guards.kyo" in
  let source = read_file source_path in
  let source_unit =
    match KyokaiSurfaceParser.parse_source ~executable_entry:false source_path source with
    | Ok source_unit -> source_unit
    | Error error -> fail (KyokaiSurfaceParser.render_error error)
  in
  match source_unit.KyokaiSurfaceParser.declarations with
  | [type_alias; extern_type; capability; function_declaration] ->
     begin match type_alias.KyokaiSurfaceParser.declaration_guard,
                 extern_type.KyokaiSurfaceParser.declaration_guard,
                 capability.KyokaiSurfaceParser.declaration_guard,
                 function_declaration.KyokaiSurfaceParser.declaration_guard with
     | Some alias_guard, Some extern_guard, Some capability_guard, Some function_guard
          when alias_guard.KyokaiSurfaceParser.expression_span.start_line = 2
               && extern_guard.KyokaiSurfaceParser.expression_span.start_line = 3
               && capability_guard.KyokaiSurfaceParser.expression_span.start_line = 4
               && function_guard.KyokaiSurfaceParser.expression_span.start_line = 6
               && KyokaiSurfaceParser.render_expression function_guard
                  = "target.os == Os.Linux and target.abi == Abi.Musl" -> ()
     | _ -> fail "declaration-guard fixture did not preserve guard expressions"
     end
  | _ -> fail "declaration-guard fixture expected four declarations"

let typeclass_summary fixture_root =
  let source_path = path fixture_root "src/Demo/Iteration.kyo" in
  let source = read_file source_path in
  let source_unit =
    match KyokaiSurfaceParser.parse_source ~executable_entry:false source_path source with
    | Ok source_unit -> source_unit
    | Error error -> fail (KyokaiSurfaceParser.render_error error)
  in
  match source_unit.KyokaiSurfaceParser.declarations with
  | [declaration] ->
     begin match declaration.KyokaiSurfaceParser.declaration_typeclass with
     | None -> fail "typeclass fixture did not preserve typeclass summary"
     | Some summary ->
        if generic_parameter_names summary.KyokaiSurfaceParser.typeclass_generic_parameters <> ["Self"] then
          fail "typeclass fixture did not preserve generic parameter";
        begin match summary.KyokaiSurfaceParser.typeclass_items with
        | [KyokaiSurfaceParser.AssociatedTypeDeclaration "Item";
           KyokaiSurfaceParser.TypeclassMethod ("next", next_signature, None);
           KyokaiSurfaceParser.TypeclassMethod ("isEmpty", _, Some [default_statement])] ->
           if KyokaiSurfaceParser.render_type_ref next_signature.KyokaiSurfaceParser.function_return_type
              <> "Optional[Self.Item]" then
             fail "typeclass fixture did not preserve method return type";
           if KyokaiSurfaceParser.render_statement default_statement <> "return false;" then
             fail "typeclass fixture did not preserve default method body"
        | _ -> fail "typeclass fixture did not preserve item structure"
        end
     end
  | _ -> fail "typeclass fixture expected one declaration"

let instance_summary fixture_root =
  let source_path = path fixture_root "src/Demo/Iteration.kyo" in
  let source = read_file source_path in
  let source_unit =
    match KyokaiSurfaceParser.parse_source ~executable_entry:false source_path source with
    | Ok source_unit -> source_unit
    | Error error -> fail (KyokaiSurfaceParser.render_error error)
  in
  match source_unit.KyokaiSurfaceParser.declarations with
  | [declaration] ->
     begin match declaration.KyokaiSurfaceParser.declaration_instance,
                 declaration.KyokaiSurfaceParser.declaration_guard with
     | Some summary, Some guard ->
        if generic_parameter_names summary.KyokaiSurfaceParser.instance_generic_parameters <> ["T"] then
          fail "instance fixture did not preserve generic parameter";
        if KyokaiSurfaceParser.render_type_ref summary.KyokaiSurfaceParser.instance_target_type
           <> "Buffer[T]" then
          fail "instance fixture did not preserve target type";
        if guard.KyokaiSurfaceParser.expression_span.start_line <> 4 then
          fail "instance fixture did not preserve declaration guard";
        begin match summary.KyokaiSurfaceParser.instance_items with
        | [KyokaiSurfaceParser.AssociatedTypeDefinition ("Item", item_type);
           KyokaiSurfaceParser.InstanceMethod ("next", signature, [method_statement])] ->
           if KyokaiSurfaceParser.render_type_ref item_type <> "T" then
             fail "instance fixture did not preserve associated type";
           if KyokaiSurfaceParser.render_type_ref signature.KyokaiSurfaceParser.function_return_type
              <> "Optional[T]" then
             fail "instance fixture did not preserve method return type";
           if KyokaiSurfaceParser.render_statement method_statement <> "return None;" then
             fail "instance fixture did not preserve method body"
        | _ -> fail "instance fixture did not preserve item structure"
        end
     | _ -> fail "instance fixture did not preserve summary and guard"
     end
  | _ -> fail "instance fixture expected one declaration"

let generator_summary fixture_root =
  let source_path = path fixture_root "src/Demo/Generation.kyo" in
  let source = read_file source_path in
  let source_unit =
    match KyokaiSurfaceParser.parse_source ~executable_entry:false source_path source with
    | Ok source_unit -> source_unit
    | Error error -> fail (KyokaiSurfaceParser.render_error error)
  in
  match source_unit.KyokaiSurfaceParser.declarations with
  | [declaration] ->
     begin match declaration.KyokaiSurfaceParser.declaration_generator,
                 declaration.KyokaiSurfaceParser.declaration_guard with
     | Some summary, Some guard ->
        if generic_parameter_names summary.KyokaiSurfaceParser.generator_generic_parameters
           <> ["T"; "R"] then
          fail "generator fixture did not preserve generic parameters";
        begin match summary.KyokaiSurfaceParser.generator_parameters with
        | [source_parameter; width_parameter] ->
           if KyokaiSurfaceParser.render_type_ref source_parameter.KyokaiSurfaceParser.parameter_type
              <> "&[Buffer[T], R]" then
             fail "generator fixture did not preserve source parameter type";
           if KyokaiSurfaceParser.render_type_ref width_parameter.KyokaiSurfaceParser.parameter_type
              <> "Index" then
             fail "generator fixture did not preserve width parameter type"
        | _ -> fail "generator fixture did not preserve parameters"
        end;
        if KyokaiSurfaceParser.render_type_ref summary.KyokaiSurfaceParser.generator_yield_type
           <> "Span[T]" then
          fail "generator fixture did not preserve yield type";
        if List.map KyokaiSurfaceParser.render_where_obligation
             summary.KyokaiSurfaceParser.generator_where_obligations
           <> ["T: Displayable"] then
          fail "generator fixture did not preserve where obligation";
        if guard.KyokaiSurfaceParser.expression_span.start_line <> 4 then
          fail "generator fixture did not preserve declaration guard";
        begin match declaration.KyokaiSurfaceParser.declaration_body with
        | Some [statement]
             when KyokaiSurfaceParser.render_statement statement
                  = "yield source[0..width];" -> ()
        | _ -> fail "generator fixture did not preserve structured yield body"
        end
     | _ -> fail "generator fixture did not preserve summary and guard"
     end
  | _ -> fail "generator fixture expected one declaration"

let inline_test_summary fixture_root =
  let source_path = path fixture_root "src/Demo/Tests.kyo" in
  let source = read_file source_path in
  let source_unit =
    match KyokaiSurfaceParser.parse_source ~executable_entry:false source_path source with
    | Ok unit -> unit
    | Error error -> fail (KyokaiSurfaceParser.render_error error)
  in
  match source_unit.KyokaiSurfaceParser.declarations with
  | [pure; effectful] ->
     begin match pure.KyokaiSurfaceParser.declaration_test,
                 pure.KyokaiSurfaceParser.declaration_body with
     | Some summary, Some body
       when summary.KyokaiSurfaceParser.test_description = "\"pure arithmetic\""
            && summary.KyokaiSurfaceParser.test_capability_parameters = []
            && List.length body = 1 -> ()
     | _ -> fail "pure inline test did not preserve its summary and body"
     end;
     begin match effectful.KyokaiSurfaceParser.declaration_test,
                 effectful.KyokaiSurfaceParser.declaration_body with
     | Some summary, Some body ->
        if summary.KyokaiSurfaceParser.test_description <> "\"reads env\"" then
          fail "effectful inline test did not preserve its description";
        begin match summary.KyokaiSurfaceParser.test_capability_parameters with
        | [parameter]
          when parameter.KyokaiSurfaceParser.parameter_name = "root"
               && KyokaiSurfaceParser.render_type_ref
                    parameter.KyokaiSurfaceParser.parameter_type = "RootCapability" -> ()
        | _ -> fail "effectful inline test did not preserve its capability parameter"
        end;
        if List.length body <> 2 then
          fail "effectful inline test did not preserve its body"
     | _ -> fail "effectful inline test did not preserve its summary and body"
     end
  | _ -> fail "inline test fixture expected two test declarations"

let foreign_block_summary fixture_root =
  let source_path = path fixture_root "src/Demo/Foreign.kyo" in
  let source = read_file source_path in
  let source_unit =
    match KyokaiSurfaceParser.parse_source ~executable_entry:false source_path source with
    | Ok source_unit -> source_unit
    | Error error -> fail (KyokaiSurfaceParser.render_error error)
  in
  match source_unit.KyokaiSurfaceParser.declarations with
  | [declaration] ->
     begin match declaration.KyokaiSurfaceParser.declaration_foreign_block with
     | Some summary ->
        if summary.KyokaiSurfaceParser.foreign_abi <> "\"C\"" then
          fail "foreign fixture did not preserve ABI spelling";
        begin match summary.KyokaiSurfaceParser.foreign_declarations with
        | [KyokaiSurfaceParser.ForeignFunction ("c_open", parameters, return_type);
           KyokaiSurfaceParser.ForeignConstant ("EINVAL", constant_type)] ->
           if List.map
                (fun parameter ->
                  KyokaiSurfaceParser.render_type_ref parameter.KyokaiSurfaceParser.parameter_type)
                parameters
              <> ["Address[Nat8]"; "Int32"] then
             fail "foreign fixture did not preserve function parameters";
           if KyokaiSurfaceParser.render_type_ref return_type <> "Int32"
              || KyokaiSurfaceParser.render_type_ref constant_type <> "Int32" then
             fail "foreign fixture did not preserve result and constant types"
        | _ -> fail "foreign fixture did not preserve declarations"
        end
     | None -> fail "foreign fixture did not preserve block summary"
     end
  | _ -> fail "foreign fixture expected one declaration"

let unsafe_contract_summary fixture_root =
  let source_path = path fixture_root "src/Demo/Foreign.kyo" in
  let source = read_file source_path in
  let source_unit =
    match KyokaiSurfaceParser.parse_source ~executable_entry:false source_path source with
    | Ok source_unit -> source_unit
    | Error error -> fail (KyokaiSurfaceParser.render_error error)
  in
  match source_unit.KyokaiSurfaceParser.declarations with
  | [declaration] ->
     begin match declaration.KyokaiSurfaceParser.declaration_unsafe_contract with
     | Some summary ->
        begin match summary.KyokaiSurfaceParser.unsafe_contract_items with
        | [KyokaiSurfaceParser.ModuleInvariant (_, [_]);
           KyokaiSurfaceParser.CoversOperation (["foreign"; "c_open"], [_; _; _]);
           KyokaiSurfaceParser.AdditionalInvariant (["foreign"; "c_close"], [_])] -> ()
        | _ -> fail "unsafe fixture did not preserve item and field structure"
        end
     | None -> fail "unsafe fixture did not preserve contract summary"
     end
  | _ -> fail "unsafe fixture expected one declaration"

let layout_fact layout =
  match layout with
  | KyokaiSurfaceParser.OrdinaryRecord -> "ordinary"
  | KyokaiSurfaceParser.ExternRecord -> "extern"
  | KyokaiSurfaceParser.PackedRecord -> "packed"

let record_summary fixture_root =
  let source_path = path fixture_root "src/Demo/Records.kyo" in
  let source = read_file source_path in
  let unit =
    match KyokaiSurfaceParser.parse_source ~executable_entry:false source_path source with
    | Ok parsed -> parsed
    | Error error -> fail (KyokaiSurfaceParser.render_error error)
  in
  match unit.KyokaiSurfaceParser.declarations with
  | [point; header] ->
     begin match point.KyokaiSurfaceParser.declaration_record with
     | None -> fail "record fixture did not preserve Point summary"
     | Some summary ->
        if point.KyokaiSurfaceParser.declaration_name <> Some "Point" then
          fail "record fixture did not preserve Point name";
        if layout_fact summary.KyokaiSurfaceParser.record_layout <> "ordinary" then
          fail "record fixture did not preserve Point layout";
        if generic_parameter_names summary.KyokaiSurfaceParser.record_generic_parameters <> ["T"] then
          fail "record fixture did not preserve Point generic parameter";
        if summary.KyokaiSurfaceParser.record_universe <> Some "Free" then
          fail "record fixture did not preserve Point universe";
        begin match summary.KyokaiSurfaceParser.record_fields with
        | [x; y] ->
           if x.KyokaiSurfaceParser.record_field_name <> "x" then
             fail "record fixture did not preserve first Point field name";
           if KyokaiSurfaceParser.render_type_ref x.KyokaiSurfaceParser.record_field_type <> "T" then
             fail "record fixture did not preserve first Point field type";
           if y.KyokaiSurfaceParser.record_field_name <> "y" then
             fail "record fixture did not preserve second Point field name";
           if KyokaiSurfaceParser.render_type_ref y.KyokaiSurfaceParser.record_field_type <> "Int32" then
             fail "record fixture did not preserve second Point field type"
        | _ -> fail "record fixture produced wrong Point field count"
        end
     end;
     begin match header.KyokaiSurfaceParser.declaration_record with
     | None -> fail "record fixture did not preserve Header summary"
     | Some summary ->
        if header.KyokaiSurfaceParser.declaration_name <> Some "Header" then
          fail "record fixture did not preserve Header name";
        if layout_fact summary.KyokaiSurfaceParser.record_layout <> "packed" then
          fail "record fixture did not preserve Header layout";
        begin match summary.KyokaiSurfaceParser.record_fields with
        | [tag; length] ->
           if KyokaiSurfaceParser.render_type_ref tag.KyokaiSurfaceParser.record_field_type <> "Nat8" then
             fail "record fixture did not preserve Header tag type";
           if KyokaiSurfaceParser.render_type_ref length.KyokaiSurfaceParser.record_field_type <> "Nat16" then
             fail "record fixture did not preserve Header length type"
        | _ -> fail "record fixture produced wrong Header field count"
        end
     end
  | _ -> fail "record fixture expected two declarations"

let union_summary fixture_root =
  let source_path = path fixture_root "src/Demo/Unions.kyo" in
  let source = read_file source_path in
  let unit =
    match KyokaiSurfaceParser.parse_source ~executable_entry:false source_path source with
    | Ok parsed -> parsed
    | Error error -> fail (KyokaiSurfaceParser.render_error error)
  in
  match unit.KyokaiSurfaceParser.declarations with
  | [optional; color] ->
     begin match optional.KyokaiSurfaceParser.declaration_union with
     | None -> fail "union fixture did not preserve Optional summary"
     | Some summary ->
        if optional.KyokaiSurfaceParser.declaration_name <> Some "Optional" then
          fail "union fixture did not preserve Optional name";
        if generic_parameter_names summary.KyokaiSurfaceParser.union_generic_parameters <> ["T"] then
          fail "union fixture did not preserve Optional generic parameter";
        if summary.KyokaiSurfaceParser.union_universe <> Some "Auto" then
          fail "union fixture did not preserve Optional universe";
        begin match summary.KyokaiSurfaceParser.union_variants with
        | [none; some] ->
           if none.KyokaiSurfaceParser.union_variant_name <> "None" then
             fail "union fixture did not preserve None variant";
           begin match none.KyokaiSurfaceParser.union_variant_payload with
           | KyokaiSurfaceParser.NoVariantPayload -> ()
           | _ -> fail "union fixture did not preserve None as zero-payload"
           end;
           begin match some.KyokaiSurfaceParser.union_variant_payload with
           | KyokaiSurfaceParser.UnnamedVariantPayload payload ->
              if KyokaiSurfaceParser.render_type_ref payload <> "T" then
                fail "union fixture did not preserve Some payload type"
           | _ -> fail "union fixture did not preserve Some as unnamed-payload"
           end
        | _ -> fail "union fixture produced wrong Optional variant count"
        end
     end;
     begin match color.KyokaiSurfaceParser.declaration_union with
     | None -> fail "union fixture did not preserve Color summary"
     | Some summary ->
        if color.KyokaiSurfaceParser.declaration_name <> Some "Color" then
          fail "union fixture did not preserve Color name";
        if summary.KyokaiSurfaceParser.union_universe <> Some "Free" then
          fail "union fixture did not preserve Color universe";
        begin match summary.KyokaiSurfaceParser.union_variants with
        | [rgb; greyscale] ->
           begin match rgb.KyokaiSurfaceParser.union_variant_payload with
           | KyokaiSurfaceParser.NamedVariantPayload fields ->
              let names = List.map (fun field -> field.KyokaiSurfaceParser.record_field_name) fields in
              if names <> ["red"; "green"; "blue"] then
                fail "union fixture did not preserve RGB named fields"
           | _ -> fail "union fixture did not preserve RGB as named-field payload"
           end;
           begin match greyscale.KyokaiSurfaceParser.union_variant_payload with
           | KyokaiSurfaceParser.UnnamedVariantPayload payload ->
              if KyokaiSurfaceParser.render_type_ref payload <> "Nat8" then
                fail "union fixture did not preserve Greyscale payload type"
           | _ -> fail "union fixture did not preserve Greyscale as unnamed-payload"
           end
        | _ -> fail "union fixture produced wrong Color variant count"
        end
     end
  | _ -> fail "union fixture expected two declarations"

let assert_module_loaded loaded module_name =
  let module_sources =
    List.find_opt
      (fun item -> item.KyokaiPackageSource.parsed_module_name = module_name)
      loaded.KyokaiPackageSource.loaded_modules
  in
  match module_sources with
  | None -> fail (Printf.sprintf "module %s was not loaded"
                   (KyokaiPackageSource.module_name_to_string module_name))
  | Some _ -> ()

let package_source_discovery fixture_root =
  match KyokaiPackageSource.load_package_sources fixture_root with
  | Error error -> fail (KyokaiPackageSource.render_load_error error)
  | Ok loaded ->
     assert_module_loaded loaded ["App"; "Main"];
     let main =
       List.find
         (fun item -> item.KyokaiPackageSource.parsed_module_name = ["App"; "Main"])
         loaded.KyokaiPackageSource.loaded_modules
     in
     begin match main.KyokaiPackageSource.derived_interface_declarations with
     | [declaration]
       when declaration.KyokaiSurfaceParser.declaration_name = Some "api"
            && KyokaiSurfaceParser.equal_visibility
                 declaration.KyokaiSurfaceParser.declaration_visibility
                 KyokaiSurfaceParser.Public -> ()
     | _ -> fail "App.Main did not derive exactly the public api declaration"
     end

let rejected_generated_koi fixture_root =
  match KyokaiPackageSource.load_package_sources fixture_root with
  | Ok _ -> fail "generated .koi fixture unexpectedly loaded as source"
  | Error (LoadDiscoveryErrors errors) ->
     if not (List.exists
               (function KyokaiPackageSource.GeneratedArtifactDiscovered _ -> true | _ -> false)
               errors) then
       fail "generated .koi fixture did not report GeneratedArtifactDiscovered"
  | Error error -> fail (KyokaiPackageSource.render_load_error error)

let rejected_retired_kai fixture_root =
  match KyokaiPackageSource.load_package_sources fixture_root with
  | Ok _ -> fail "retired .kai fixture unexpectedly loaded as source"
  | Error (LoadDiscoveryErrors errors) ->
     if not (List.exists
               (function KyokaiPackageSource.RetiredSourceExtensionDiscovered _ -> true | _ -> false)
               errors) then
       fail "retired .kai fixture did not report RetiredSourceExtensionDiscovered"
  | Error error -> fail (KyokaiPackageSource.render_load_error error)

let rejected_module_name_mismatch fixture_root =
  match KyokaiPackageSource.load_package_sources fixture_root with
  | Ok _ -> fail "module-name mismatch fixture unexpectedly loaded"
  | Error (LoadSourceError (_, ParsedModuleNameMismatch (["App"; "Main"], ["App"; "Other"], _))) -> ()
  | Error error -> fail (KyokaiPackageSource.render_load_error error)

let rejected_executable_entry_missing fixture_root =
  match KyokaiPackageSource.load_executable_package_sources fixture_root with
  | Ok _ -> fail "missing executable entry fixture unexpectedly loaded"
  | Error (LoadTargetSelectionError (ExecutableTargetEntryMissing ("app", ["App"; "Main"], "main"))) -> ()
  | Error error -> fail (KyokaiPackageSource.render_load_error error)

let rejected_private_type_leak fixture_root =
  match KyokaiPackageSource.load_package_sources fixture_root with
  | Ok _ -> fail "private type leak fixture unexpectedly loaded"
  | Error (LoadSourceError (_, InterfaceValidationErrors (_, [error]))) ->
     if not (KyokaiInterfaceValidation.equal_error_kind
               error.KyokaiInterfaceValidation.interface_error_kind
               KyokaiInterfaceValidation.PrivateTypeLeak) then
       fail "private type leak fixture reported the wrong interface error";
     if error.KyokaiInterfaceValidation.exposing_declaration <> "expose"
        || error.KyokaiInterfaceValidation.hidden_declaration <> Some "Hidden" then
       fail "private type leak fixture reported the wrong declarations"
  | Error error -> fail (KyokaiPackageSource.render_load_error error)

let package_workspace_lockfile_graph fixture_root =
  let loaded_workspace =
    match KyokaiPackageSource.load_workspace_sources fixture_root with
    | Ok loaded -> loaded
    | Error error -> fail (KyokaiPackageSource.render_workspace_load_error error)
  in
  let manifests =
    List.map
      (fun loaded -> loaded.KyokaiPackageSource.loaded_manifest)
      loaded_workspace.KyokaiPackageSource.loaded_workspace_packages
  in
  let graph =
    match KyokaiPackageResolution.resolve_workspace_manifests manifests with
    | Ok graph -> graph
    | Error error -> fail (KyokaiPackageResolution.render_resolution_error error)
  in
  begin match graph.KyokaiPackageResolution.graph_edges with
  | [edge]
       when edge.KyokaiPackageResolution.dependency_name = "core"
            && edge.KyokaiPackageResolution.to_instance = "workspace:core@0.1.0#2026" -> ()
  | _ -> fail "workspace lockfile fixture did not produce the expected package edge"
  end;
  let lockfile = KyokaiPackageLockfile.of_workspace_resolution ~owner_path:fixture_root graph in
  let rendered = KyokaiPackageLockfile.render lockfile in
  let repaired =
    match KyokaiPackageLockfile.repair rendered with
    | Ok text -> text
    | Error error -> fail (KyokaiPackageLockfile.render_lockfile_error error)
  in
  if rendered <> repaired then
    fail "workspace lockfile repair changed graph meaning or deterministic rendering"

let run_fixture fixture_id fixture_root =
  match fixture_id with
  | "parser.accepted-source-skeleton" ->
     accepted_source_skeleton fixture_root;
     fixture_result
       ~outcome:"accept"
       ~stage:"parser"
       ~code:"source-skeleton"
       ~facts:["src/Main.kyo:source"; "visibility=public+private"; "opaque=record"]
  | "parser.bitrecord-summary" ->
     bitrecord_summary fixture_root;
     fixture_result
       ~outcome:"accept"
       ~stage:"parser"
       ~code:"bitrecord-summary"
       ~facts:["bitrecord=TcpFlags"; "backing=Nat16"; "field=fin:bit:0"; "field=window:bits:7..4"; "reserved=15..8"]
  | "parser.const-generic-arguments" ->
     const_generic_arguments fixture_root;
     fixture_result
       ~outcome:"accept"
       ~stage:"parser"
       ~code:"const-generic-arguments"
       ~facts:["field=data:Array[T, Rows * Cols]"; "field=header:Array[Nat8, 32]"; "field=grouped:Array[Nat8, (Rows + Cols) * 2]"]
  | "parser.declaration-guard-summary" ->
     declaration_guard_summary fixture_root;
     fixture_result
       ~outcome:"accept"
       ~stage:"parser"
       ~code:"declaration-guard-summary"
       ~facts:["alias-guard-line=2"; "extern-guard-line=3"; "capability-guard-line=4"; "function-guard-line=6"; "function-guard=target.os == Os.Linux and target.abi == Abi.Musl"]
  | "parser.expression-summary" ->
     expression_summary fixture_root;
     fixture_result
       ~outcome:"accept"
       ~stage:"parser"
       ~code:"expression-summary"
       ~facts:["call=makeBuffer()"; "slice=values[start + 1..limit]";
               "construction=Point { x: 2, with point }";
               "closure=fn [limit, &cfg] (value: Int32): Bool => value < limit and cfg.ready";
               "block-closure=fn [limit] (value: Int32): Int32 is return value + limit; qed";
               "build=Pair/produce"]
  | "parser.constant-summary" ->
     constant_summary fixture_root;
     fixture_result
       ~outcome:"accept"
       ~stage:"parser"
       ~code:"constant-summary"
       ~facts:["constant=maxPathBytes"; "type=Index"; "initializer=4096"]
  | "parser.source-span-skeleton" ->
     source_span_skeleton fixture_root;
     fixture_result
       ~outcome:"accept"
       ~stage:"parser"
       ~code:"source-spans"
       ~facts:["module-lines"; "import-lines"; "declaration-lines"; "qed-terminator"]
  | "parser.rejected-inherited-comment" ->
     parse_source_rejects_inherited_comment fixture_root "src/Main.kyo";
     fixture_result
       ~outcome:"reject"
       ~stage:"lexer"
       ~code:"unsupported-inherited-form"
       ~facts:["form=--"; "src/Main.kyo"]
  | "parser.rejected-inherited-form-matrix" ->
     rejected_inherited_form_matrix fixture_root;
     fixture_result
       ~outcome:"reject"
       ~stage:"parser"
       ~code:"rejected-inherited-form-matrix"
       ~facts:["form=/="; "form=#x"; "form=#b"; "form=#o";
               "form=block-comment"; "form=pipeline";
               "form=apostrophe-separator"; "form=compound-suffix";
               "form=platform-char-literal";
               "form=wildcard-pattern"; "form=module-body";
               "form=explicit-private"; "form=wildcard-import";
               "form=docstring-syntax"; "form=arrow-field-access";
               "form=retired-read-borrow"; "form=retired-write-borrow";
               "form=retired-reborrow"]
  | "parser.rejected-extra-syntax-matrix" ->
     rejected_extra_syntax_matrix fixture_root;
     fixture_result
       ~outcome:"reject"
       ~stage:"parser"
       ~code:"rejected-extra-syntax-matrix"
       ~facts:["form=tuple-expression"; "form=class-declaration";
               "form=inheritance-declaration"; "form=exception-declaration";
               "form=try-catch"; "form=macro-definition";
               "form=block-local-import"; "form=body-target-when";
               "form=pattern-guard"; "form=drop-declaration";
               "form=module-var"; "form=async-await"]
  | "parser.function-signature-summary" ->
     function_signature_summary fixture_root;
     fixture_result
       ~outcome:"accept"
       ~stage:"parser"
       ~code:"function-signature-summary"
       ~facts:["function=copyText"; "generic=T"; "param=text:&[StaticString]"; "param=output:&![Buffer[T]]"; "return=Result[Unit, IoError]"]
  | "parser.foreign-block-summary" ->
     foreign_block_summary fixture_root;
     fixture_result
       ~outcome:"accept"
       ~stage:"parser"
       ~code:"foreign-block-summary"
       ~facts:["abi=C"; "function=c_open"; "params=Address[Nat8],Int32"; "return=Int32"; "constant=EINVAL:Int32"]
  | "parser.generator-summary" ->
     generator_summary fixture_root;
     fixture_result
       ~outcome:"accept"
       ~stage:"parser"
       ~code:"generator-summary"
       ~facts:["generator=Windows"; "generics=T,R"; "param=source:&[Buffer[T], R]"; "param=width:Index"; "yield=Span[T]"; "where=T: Displayable"; "guard-line=4"]
  | "parser.instance-summary" ->
     instance_summary fixture_root;
     fixture_result
       ~outcome:"accept"
       ~stage:"parser"
       ~code:"instance-summary"
       ~facts:["instance=Iterable"; "generic=T"; "target=Buffer[T]"; "where=T: Displayable"; "guard-line=4"; "associated=Item:T"; "method=next"; "return=Optional[T]"; "method-body=return None;"]
  | "parser.inline-test-summary" ->
     inline_test_summary fixture_root;
     fixture_result
       ~outcome:"accept"
       ~stage:"parser"
       ~code:"inline-test-summary"
       ~facts:["test=pure arithmetic"; "capabilities=none"; "body-count=1";
               "test=reads env"; "capability=root:RootCapability";
               "effectful-body-count=2"]
  | "parser.function-contract-summary" ->
     function_contract_summary fixture_root;
     fixture_result
       ~outcome:"accept"
       ~stage:"parser"
       ~code:"function-contract-summary"
       ~facts:["function=clamp"; "contracts=require,ensure"; "require-line=3"; "ensure-line=4"; "require=value >= 0"; "ensure=result >= 0"]
  | "parser.function-body-summary" ->
     function_body_summary fixture_root;
     fixture_result
       ~outcome:"accept"
       ~stage:"parser"
       ~code:"function-body-summary"
       ~facts:["function=classify"; "body-count=14"; "pattern={ x, y: ignore }";
               "let-else=Ok(result)/Err(error)"; "or-return=plain,mapped";
               "or-loop=break retry,continue retry"; "borrow=view:&read value";
               "taskgroup=spawn:value,&counter"; "select=receive,timeout";
               "wait=ready,default"; "debug=debug value;";
               "defer=defer closeLog();"; "while-let=Some(next)";
               "if-branches=2"; "else=panic"]
  | "parser.structured-reference-and-fnptr" ->
     structured_reference_and_fnptr fixture_root;
     fixture_result
       ~outcome:"accept"
       ~stage:"parser"
       ~code:"structured-reference-and-fnptr"
       ~facts:["generics=T:Type,N:Index,R:Region"; "input=&[Buffer[T], R]"; "callback=FnPtr(&[T], &![Buffer[T]]): Result[Unit, IoError]"; "return=FnPtr(): Unit"]
  | "parser.type-alias-summary" ->
     type_alias_summary fixture_root;
     fixture_result
       ~outcome:"accept"
       ~stage:"parser"
       ~code:"type-alias-summary"
       ~facts:["alias=IoResult"; "generic=T"; "target=Result[T, IoError]"]
  | "parser.typeclass-summary" ->
     typeclass_summary fixture_root;
     fixture_result
       ~outcome:"accept"
       ~stage:"parser"
       ~code:"typeclass-summary"
       ~facts:["typeclass=Iterable"; "generic=Self"; "associated=Item"; "method=next:required"; "return=Optional[Self.Item]"; "method=isEmpty:default"; "default-body=return false;"]
  | "parser.unsafe-contract-summary" ->
     unsafe_contract_summary fixture_root;
     fixture_result
       ~outcome:"accept"
       ~stage:"parser"
       ~code:"unsafe-contract-summary"
       ~facts:["contract=RawIo"; "module-invariant"; "covers=foreign:c_open"; "fields=assumes,maps_failure,owns"; "additional=foreign:c_close"; "field=cleanup"]
  | "parser.where-clause-summary" ->
     where_clause_summary fixture_root;
     fixture_result
       ~outcome:"accept"
       ~stage:"parser"
       ~code:"where-clause-summary"
       ~facts:["bound=C: Iterable"; "bound=C.Item: Displayable"; "equality=C.Error == E"]
  | "parser.record-summary" ->
     record_summary fixture_root;
     fixture_result
       ~outcome:"accept"
       ~stage:"parser"
       ~code:"record-summary"
       ~facts:["record=Point"; "layout=ordinary"; "generic=T"; "universe=Free"; "field=x:T"; "field=y:Int32"; "record=Header"; "layout=packed"; "field=tag:Nat8"; "field=length:Nat16"]
  | "parser.union-summary" ->
     union_summary fixture_root;
     fixture_result
       ~outcome:"accept"
       ~stage:"parser"
       ~code:"union-summary"
       ~facts:["union=Optional"; "generic=T"; "universe=Auto"; "variant=None:none"; "variant=Some:T"; "union=Color"; "universe=Free"; "variant=RGB:named"; "field=red:Nat8"; "field=green:Nat8"; "field=blue:Nat8"; "variant=Greyscale:Nat8"]
  | "modules.package-source-discovery" ->
     package_source_discovery fixture_root;
     fixture_result
       ~outcome:"accept"
       ~stage:"package-source"
       ~code:"loaded-module-set"
       ~facts:["App.Main:source"; "derived-interface=public"]
  | "modules.rejected-private-type-leak" ->
     rejected_private_type_leak fixture_root;
     fixture_result
       ~outcome:"reject"
       ~stage:"interface-validation"
       ~code:"private-type-leak"
       ~facts:["module=App.Main"; "declaration=expose"; "hidden=Hidden"]
  | "modules.rejected-generated-koi" ->
     rejected_generated_koi fixture_root;
     fixture_result
       ~outcome:"reject"
       ~stage:"package-source"
       ~code:"generated-artifact-discovered"
       ~facts:["src/App/Main.koi"]
  | "modules.rejected-retired-kai" ->
     rejected_retired_kai fixture_root;
     fixture_result
       ~outcome:"reject"
       ~stage:"package-source"
       ~code:"retired-source-extension"
       ~facts:["src/App/Main.kai"; "replacement=.kyo"]
  | "modules.rejected-module-name-mismatch" ->
     rejected_module_name_mismatch fixture_root;
     fixture_result
       ~outcome:"reject"
       ~stage:"package-source"
       ~code:"parsed-module-name-mismatch"
       ~facts:["expected=App.Main"; "actual=App.Other"]
  | "modules.rejected-executable-entry-missing" ->
     rejected_executable_entry_missing fixture_root;
     fixture_result
       ~outcome:"reject"
       ~stage:"package-target"
       ~code:"executable-target-entry-missing"
       ~facts:["target=app"; "module=App.Main"; "entry=main"]
  | "packages.workspace-lockfile-graph" ->
     package_workspace_lockfile_graph fixture_root;
     fixture_result
       ~outcome:"accept"
       ~stage:"package-lockfile"
       ~code:"workspace-graph-lockfile-repair"
       ~facts:["root=app"; "package=core"; "edge=app->core"]
  | _ -> fail (Printf.sprintf "fixture %S has no host probe implementation" fixture_id)

let supported_fixture fixture_id =
  match fixture_id with
  | "parser.accepted-source-skeleton"
  | "parser.bitrecord-summary"
  | "parser.const-generic-arguments"
  | "parser.declaration-guard-summary"
  | "parser.expression-summary"
  | "parser.constant-summary"
  | "parser.source-span-skeleton"
  | "parser.rejected-inherited-comment"
  | "parser.rejected-inherited-form-matrix"
  | "parser.rejected-extra-syntax-matrix"
  | "parser.function-signature-summary"
  | "parser.foreign-block-summary"
  | "parser.generator-summary"
  | "parser.instance-summary"
  | "parser.inline-test-summary"
  | "parser.function-contract-summary"
  | "parser.function-body-summary"
  | "parser.structured-reference-and-fnptr"
  | "parser.type-alias-summary"
  | "parser.typeclass-summary"
  | "parser.unsafe-contract-summary"
  | "parser.where-clause-summary"
  | "parser.record-summary"
  | "parser.union-summary"
  | "modules.package-source-discovery"
  | "modules.rejected-private-type-leak"
  | "modules.rejected-generated-koi"
  | "modules.rejected-retired-kai"
  | "modules.rejected-module-name-mismatch"
  | "modules.rejected-executable-entry-missing"
  | "packages.workspace-lockfile-graph" -> true
  | _ -> false

let run_single fixture_id fixture_root =
  try
    let actual_result = run_fixture fixture_id fixture_root in
    let fixture_path = Filename.concat fixture_root "fixture.toml" in
    if Sys.file_exists fixture_path then
      let metadata = load_fixture_metadata fixture_path in
      compare_result metadata.expected_result actual_result
  with
  | Probe_failure message ->
     prerr_endline ("kyokai-conformance-probe: " ^ message);
     exit 1
  | Sys_error message ->
     prerr_endline ("kyokai-conformance-probe: " ^ message);
     exit 1

let fixture_evidence_label status =
  match status with
  | Active -> "active"
  | ImplementationGated -> "implementation-gated"
  | SpecGated | Historical -> fixture_status_to_string status

let run_all fixture_root =
  let fixture_files = collect_fixture_files fixture_root in
  if fixture_files = [] then begin
    prerr_endline "conformance-runner: error: no fixture metadata files found";
    exit 1
  end;
  let executed = ref 0 in
  let skipped = ref 0 in
  let failures = ref [] in
  List.iter
    (fun fixture_path ->
      let metadata = load_fixture_metadata fixture_path in
      let fixture_id = metadata.fixture_id in
      let fixture_status = metadata.fixture_status in
      let fixture_directory = Filename.dirname fixture_path in
      if not (supported_fixture fixture_id) then begin
        incr skipped;
        Printf.printf "conformance-runner: skip %s: no host probe\n" fixture_id
      end else
        match fixture_status with
        | Active | ImplementationGated ->
           incr executed;
           begin
             try
               let actual_result = run_fixture fixture_id fixture_directory in
               compare_result metadata.expected_result actual_result;
               Printf.printf
                 "conformance-runner: %s pass %s (%s/%s)\n"
                 (fixture_evidence_label fixture_status)
                 fixture_id
                 actual_result.stage
                 actual_result.code
             with
             | Probe_failure message ->
                prerr_endline ("kyokai-conformance-probe: " ^ message);
                failures := fixture_id :: !failures;
                prerr_endline ("conformance-runner: fail " ^ fixture_id)
             | Sys_error message ->
                prerr_endline ("kyokai-conformance-probe: " ^ message);
                failures := fixture_id :: !failures;
                prerr_endline ("conformance-runner: fail " ^ fixture_id)
           end
        | SpecGated | Historical ->
           incr skipped;
           Printf.printf
             "conformance-runner: skip %s: status %s\n"
             fixture_id
             (fixture_status_to_string fixture_status))
    fixture_files;
  if !failures <> [] then begin
    prerr_endline
      ("conformance-runner: failed fixtures: " ^ String.concat ", " (List.rev !failures));
    exit 1
  end;
  Printf.printf
    "conformance-runner: executed %d fixtures; skipped %d; implementation-gated passes are supporting evidence only\n"
    !executed
    !skipped

let usage () =
  prerr_endline "usage: KyokaiConformanceStage --check [fixture-root]";
  prerr_endline "   or: KyokaiConformanceStage <fixture-id> <fixture-root>";
  exit 2

let main argv =
  match argv with
  | [_; "--check"] -> run_all "test/conformance"
  | [_; "--check"; fixture_root] -> run_all fixture_root
  | [_; fixture_id; fixture_root] -> run_single fixture_id fixture_root
  | _ -> usage ()
