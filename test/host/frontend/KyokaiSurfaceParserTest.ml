(*
   Part of the Kyokai project.

   SPDX-License-Identifier: GPL-3.0-or-later
*)
open OUnit2
open Kyokai_frontend.KyokaiSurfaceParser

let parse_ok ~executable_entry path source =
  match parse_source ~executable_entry path source with
  | Ok unit -> unit
  | Error error -> assert_failure (render_error error)

let parse_error ~executable_entry path source expected =
  match parse_source ~executable_entry path source with
  | Ok _ -> assert_failure "expected parser rejection"
  | Error error ->
     assert_bool (render_error error) (equal_error_kind error.parser_error_kind expected)

let generic_parameter_names parameters =
  List.map (fun parameter -> parameter.generic_parameter_name) parameters

let test_source_skeleton _ =
  let source = String.concat "\n" [
      "//! module docs";
      "pragma Unsafe_Module;";
      "import Core.Math;";
      "import Core.Text as Text;";
      "import Core.Io (openFile, closeFile as close);";
      "module Demo.Api is";
      "internal function helper(): Unit is";
      "qed;";
      "public opaque record UserId(value: Int64): Free;";
      "public union MaybeUser: Free is";
      "    case None;";
      "    case Some(UserId);";
      "build;";
      "function privateHelper(): Unit is";
      "qed;";
      "seal;";
    ]
  in
  let unit = parse_ok ~executable_entry:false "src/Demo/Api.kyo" source in
  assert_equal ["Demo"; "Api"] unit.module_name;
  assert_equal 1 (List.length unit.pragmas);
  assert_equal 3 (List.length unit.imports);
  assert_equal 4 (List.length unit.declarations);
  match unit.declarations with
  | helper :: record_decl :: union_decl :: private_helper :: [] ->
     assert_bool "internal helper" (equal_visibility helper.declaration_visibility Internal);
     assert_bool "function" (equal_declaration_kind helper.declaration_kind FunctionDeclaration);
     assert_equal (Some "helper") helper.declaration_name;
     assert_bool "record" (equal_declaration_kind record_decl.declaration_kind RecordDeclaration);
     assert_bool "public record" (equal_visibility record_decl.declaration_visibility Public);
     assert_bool "opaque record" record_decl.declaration_opaque;
     assert_equal (Some "UserId") record_decl.declaration_name;
     assert_equal ";" record_decl.declaration_terminator;
     begin match record_decl.declaration_record with
     | None -> assert_failure "missing one-line record summary"
     | Some summary ->
        assert_bool "ordinary record" (equal_record_layout summary.record_layout OrdinaryRecord);
        assert_bool "one-line record" summary.record_one_line;
        assert_equal (Some "Free") summary.record_universe;
        begin match summary.record_fields with
        | [field] ->
           assert_equal "value" field.record_field_name;
           assert_equal "Int64" (render_type_ref field.record_field_type)
        | _ -> assert_failure "unexpected one-line record fields"
        end
     end;
     assert_bool "union" (equal_declaration_kind union_decl.declaration_kind UnionDeclaration);
     assert_bool "public union" (equal_visibility union_decl.declaration_visibility Public);
     assert_bool "transparent union" (not union_decl.declaration_opaque);
     assert_equal (Some "MaybeUser") union_decl.declaration_name;
     assert_equal "build" union_decl.declaration_terminator;
     begin match union_decl.declaration_union with
     | None -> assert_failure "missing union summary"
     | Some summary ->
        assert_equal (Some "Free") summary.union_universe;
        begin match summary.union_variants with
        | [none; some] ->
           assert_equal "None" none.union_variant_name;
           assert_bool "none payload" (equal_union_variant_payload none.union_variant_payload NoVariantPayload);
           assert_equal "Some" some.union_variant_name;
           begin match some.union_variant_payload with
           | UnnamedVariantPayload payload -> assert_equal "UserId" (render_type_ref payload)
           | _ -> assert_failure "unexpected Some payload"
           end
        | _ -> assert_failure "unexpected union variants"
        end
     end;
     assert_bool "private default" (equal_visibility private_helper.declaration_visibility Private);
     assert_equal 6 unit.module_span.start_line;
     assert_equal 16 unit.module_span.end_line
  | _ -> assert_failure "unexpected declarations"

let test_definition_skeleton _ =
  let source = String.concat "\n" [
      "pragma Unsafe_Module;";
      "import Core.Io;";
      "module Demo.Main is";
      "function main(): Unit";
      "    require true;";
      "is";
      "    if true then";
      "    fi;";
      "qed;";
      "foreign \"C\" is";
      "    function puts(text: StaticString): Int32;";
      "mon;";
      "unsafe contract RawIo is";
      "    covers foreign:puts assumes \"C puts contract\";";
      "audit;";
      "seal;";
    ]
  in
  let unit = parse_ok ~executable_entry:false "src/Demo/Main.kyo" source in
  assert_equal ["Demo"; "Main"] unit.module_name;
  assert_equal 1 (List.length unit.pragmas);
  assert_equal 1 (List.length unit.imports);
  assert_equal 3 (List.length unit.declarations);
  match unit.declarations with
  | function_decl :: foreign_decl :: unsafe_decl :: [] ->
     assert_bool "function" (equal_declaration_kind function_decl.declaration_kind FunctionDeclaration);
     assert_equal (Some "main") function_decl.declaration_name;
     assert_equal "qed" function_decl.declaration_terminator;
     begin match function_decl.declaration_body with
     | Some [statement] -> assert_equal "if true then  fi;" (render_statement statement)
     | _ -> assert_failure "missing structured function body"
     end;
     assert_bool "foreign" (equal_declaration_kind foreign_decl.declaration_kind ForeignBlock);
     assert_equal None foreign_decl.declaration_name;
     assert_equal "mon" foreign_decl.declaration_terminator;
     assert_bool "unsafe" (equal_declaration_kind unsafe_decl.declaration_kind UnsafeContract);
     assert_equal (Some "RawIo") unsafe_decl.declaration_name;
     assert_equal "audit" unsafe_decl.declaration_terminator
  | _ -> assert_failure "unexpected body declarations"

let test_function_signature_summary _ =
  let source = String.concat "\n" [
      "module Demo.Signatures is";
      "function copyText[T: Type](text: &[StaticString], output: &![Buffer[T]]): Result[Unit, IoError] is";
      "qed;";
      "seal;";
    ]
  in
  let unit = parse_ok ~executable_entry:false "src/Demo/Signatures.kyo" source in
  match unit.declarations with
  | [declaration] ->
     assert_bool "function" (equal_declaration_kind declaration.declaration_kind FunctionDeclaration);
     assert_equal (Some "copyText") declaration.declaration_name;
     begin match declaration.declaration_signature with
     | None -> assert_failure "missing function signature summary"
     | Some signature ->
        assert_equal ["T"] (generic_parameter_names signature.function_generic_parameters);
        assert_bool "type classifier"
          (equal_generic_parameter_classifier
             (List.hd signature.function_generic_parameters).generic_parameter_classifier
             TypeClassifier);
        assert_equal 2 (List.length signature.function_parameters);
        begin match signature.function_parameters with
        | [text; output] ->
           assert_equal "text" text.parameter_name;
           assert_equal "&[StaticString]" (render_type_ref text.parameter_type);
           assert_equal "output" output.parameter_name;
           assert_equal "&![Buffer[T]]" (render_type_ref output.parameter_type)
        | _ -> assert_failure "unexpected function parameters"
        end;
        assert_equal "Result[Unit, IoError]" (render_type_ref signature.function_return_type);
        assert_equal [] signature.function_where_obligations;
        assert_equal [] signature.function_contracts
     end
  | _ -> assert_failure "unexpected declarations"

let test_structured_reference_and_function_pointer_types _ =
  let source = String.concat "\n" [
      "module Demo.Types is";
      "function adapt[T: Type, N: Index, R: Region](input: &[Buffer[T], R], callback: FnPtr(&[T], &![Buffer[T]]): Result[Unit, IoError]): FnPtr(): Unit is";
      "qed;";
      "seal;";
    ]
  in
  let unit = parse_ok ~executable_entry:false "src/Demo/Types.kyo" source in
  match unit.declarations with
  | [declaration] ->
     begin match declaration.declaration_signature with
     | None -> assert_failure "missing structured type signature"
     | Some signature ->
        assert_equal ["T"; "N"; "R"] (generic_parameter_names signature.function_generic_parameters);
        begin match signature.function_generic_parameters with
        | [type_parameter; const_parameter; region_parameter] ->
           assert_bool "type classifier"
             (equal_generic_parameter_classifier type_parameter.generic_parameter_classifier TypeClassifier);
           assert_bool "index classifier"
             (equal_generic_parameter_classifier const_parameter.generic_parameter_classifier IndexClassifier);
           assert_bool "region classifier"
             (equal_generic_parameter_classifier region_parameter.generic_parameter_classifier RegionClassifier)
        | _ -> assert_failure "unexpected generic parameter classifications"
        end;
        begin match signature.function_parameters with
        | [input; callback] ->
           assert_equal "&[Buffer[T], R]" (render_type_ref input.parameter_type);
           assert_equal
             "FnPtr(&[T], &![Buffer[T]]): Result[Unit, IoError]"
             (render_type_ref callback.parameter_type)
        | _ -> assert_failure "unexpected structured type parameters"
        end;
        assert_equal "FnPtr(): Unit" (render_type_ref signature.function_return_type)
     end
  | _ -> assert_failure "unexpected declarations"

let test_where_clause_summary _ =
  let source = String.concat "\n" [
      "module Demo.Constraints is";
      "function collect[C: Type, E: Type](iter: &[C]): Result[Buffer[C.Item], E]";
      "where C: Iterable, C.Item: Displayable, C.Error == E,";
      "is";
      "qed;";
      "seal;";
    ]
  in
  let unit = parse_ok ~executable_entry:false "src/Demo/Constraints.kyo" source in
  match unit.declarations with
  | [declaration] ->
     begin match declaration.declaration_signature with
     | None -> assert_failure "missing constrained function signature"
     | Some signature ->
        assert_equal 3 (List.length signature.function_where_obligations);
        assert_equal
          ["C: Iterable"; "C.Item: Displayable"; "C.Error == E"]
          (List.map render_where_obligation signature.function_where_obligations)
     end
  | _ -> assert_failure "unexpected declarations"

let test_const_generic_arguments _ =
  let source = String.concat "\n" [
      "module Demo.Shapes is";
      "record Matrix[T: Type, Rows: Index, Cols: Index]: Auto is";
      "    data: Array[T, Rows * Cols];";
      "    header: Array[Nat8, 32];";
      "    grouped: Array[Nat8, (Rows + Cols) * 2];";
      "build;";
      "seal;";
    ]
  in
  let unit = parse_ok ~executable_entry:false "src/Demo/Shapes.kyo" source in
  match unit.declarations with
  | [declaration] ->
     begin match declaration.declaration_record with
     | None -> assert_failure "missing const-generic record summary"
     | Some summary ->
        begin match summary.record_fields with
        | [data; header; grouped] ->
           assert_equal "Array[T, Rows * Cols]" (render_type_ref data.record_field_type);
           assert_equal "Array[Nat8, 32]" (render_type_ref header.record_field_type);
           assert_equal "Array[Nat8, (Rows + Cols) * 2]" (render_type_ref grouped.record_field_type)
        | _ -> assert_failure "unexpected const-generic fields"
        end
     end
  | _ -> assert_failure "unexpected declarations"

let test_function_contract_spans _ =
  let source = String.concat "\n" [
      "module Demo.Contracts is";
      "function clamp(value: Int32): Int32";
      "require value >= 0;";
      "ensure result >= 0;";
      "is";
      "qed;";
      "seal;";
    ]
  in
  let unit = parse_ok ~executable_entry:false "src/Demo/Contracts.kyo" source in
  match unit.declarations with
  | [declaration] ->
     begin match declaration.declaration_signature with
     | None -> assert_failure "missing contracted function signature"
     | Some signature ->
        begin match signature.function_contracts with
        | [RequireContract require_expression; EnsureContract ensure_expression] ->
           assert_equal 3 require_expression.expression_span.start_line;
           assert_equal 4 ensure_expression.expression_span.start_line;
           assert_equal "value >= 0" (render_expression require_expression);
           assert_equal "result >= 0" (render_expression ensure_expression)
        | _ -> assert_failure "unexpected contract clauses"
        end
     end
  | _ -> assert_failure "unexpected declarations"

let test_declaration_guard_spans _ =
  let source = String.concat "\n" [
      "module Demo.Guards is";
      "public type alias Word := Nat64 when target.arch == Arch.X86_64;";
      "extern type FILE when target.os == Os.Linux;";
      "capability DeviceCapability when target.os == Os.Linux;";
      "public function pageSize(): Index";
      "when target.os == Os.Linux and target.abi == Abi.Musl";
      "is";
      "qed;";
      "seal;";
    ]
  in
  let unit = parse_ok ~executable_entry:false "src/Demo/Guards.kyo" source in
  match unit.declarations with
  | [type_alias; extern_type; capability; function_declaration] ->
     begin match type_alias.declaration_guard, extern_type.declaration_guard,
                 capability.declaration_guard, function_declaration.declaration_guard with
     | Some alias_guard, Some extern_guard, Some capability_guard, Some function_guard ->
        assert_equal 2 alias_guard.expression_span.start_line;
        assert_equal 3 extern_guard.expression_span.start_line;
        assert_equal 4 capability_guard.expression_span.start_line;
        assert_equal 6 function_guard.expression_span.start_line;
        assert_equal "target.os == Os.Linux and target.abi == Abi.Musl"
          (render_expression function_guard)
     | _ -> assert_failure "missing declaration guard spans"
     end
  | _ -> assert_failure "unexpected guarded declarations"

let test_record_summary _ =
  let source = String.concat "\n" [
      "module Demo.Records is";
      "record Point[T: Type]: Free is";
      "    x: T;";
      "    y: Int32;";
      "build;";
      "packed record Header: Free is";
      "    tag: Nat8;";
      "    length: Nat16;";
      "build;";
      "seal;";
    ]
  in
  let unit = parse_ok ~executable_entry:false "src/Demo/Records.kyo" source in
  match unit.declarations with
  | [point; header] ->
     begin match point.declaration_record with
     | None -> assert_failure "missing point record summary"
     | Some summary ->
        assert_bool "ordinary layout" (equal_record_layout summary.record_layout OrdinaryRecord);
        assert_bool "block record" (not summary.record_one_line);
        assert_equal ["T"] (generic_parameter_names summary.record_generic_parameters);
        assert_equal (Some "Free") summary.record_universe;
        begin match summary.record_fields with
        | [x; y] ->
           assert_equal "x" x.record_field_name;
           assert_equal "T" (render_type_ref x.record_field_type);
           assert_equal "y" y.record_field_name;
           assert_equal "Int32" (render_type_ref y.record_field_type)
        | _ -> assert_failure "unexpected point fields"
        end
     end;
     begin match header.declaration_record with
     | None -> assert_failure "missing header record summary"
     | Some summary ->
        assert_bool "packed layout" (equal_record_layout summary.record_layout PackedRecord);
        assert_equal ["tag"; "length"] (List.map (fun field -> field.record_field_name) summary.record_fields)
     end
  | _ -> assert_failure "unexpected record declarations"

let test_type_alias_summary _ =
  let source = String.concat "\n" [
      "module Demo.Aliases is";
      "public type alias IoResult[T: Type] := Result[T, IoError];";
      "seal;";
    ]
  in
  let unit = parse_ok ~executable_entry:false "src/Demo/Aliases.kyo" source in
  match unit.declarations with
  | [declaration] ->
     assert_bool "type alias" (equal_declaration_kind declaration.declaration_kind TypeDeclaration);
     assert_equal (Some "IoResult") declaration.declaration_name;
     begin match declaration.declaration_type_alias with
     | None -> assert_failure "missing type alias summary"
     | Some summary ->
        assert_equal ["T"] (generic_parameter_names summary.type_alias_generic_parameters);
        assert_equal "Result[T, IoError]" (render_type_ref summary.type_alias_target)
     end
  | _ -> assert_failure "unexpected declarations"

let test_constant_summary _ =
  let source = String.concat "\n" [
      "module Demo.Constants is";
      "public constant maxPathBytes: Index := 4096;";
      "seal;";
    ]
  in
  let unit = parse_ok ~executable_entry:false "src/Demo/Constants.kyo" source in
  match unit.declarations with
  | [declaration] ->
     begin match declaration.declaration_constant with
     | None -> assert_failure "missing constant summary"
     | Some summary ->
        assert_equal "Index" (render_type_ref summary.constant_type);
        assert_equal "4096" (render_expression summary.constant_initializer)
     end
  | _ -> assert_failure "unexpected declarations"

let test_union_summary _ =
  let source = String.concat "\n" [
      "module Demo.Unions is";
      "union Optional[T: Type]: Auto is";
      "    case None;";
      "    case Some(T);";
      "build;";
      "union Color: Free is";
      "    case RGB is";
      "        red: Nat8;";
      "        green: Nat8;";
      "        blue: Nat8;";
      "    case Greyscale(Nat8);";
      "build;";
      "seal;";
    ]
  in
  let unit = parse_ok ~executable_entry:false "src/Demo/Unions.kyo" source in
  match unit.declarations with
  | [optional; color] ->
     begin match optional.declaration_union with
     | None -> assert_failure "missing Optional union summary"
     | Some summary ->
        assert_equal ["T"] (generic_parameter_names summary.union_generic_parameters);
        assert_equal (Some "Auto") summary.union_universe;
        assert_equal ["None"; "Some"] (List.map (fun variant -> variant.union_variant_name) summary.union_variants)
     end;
     begin match color.declaration_union with
     | None -> assert_failure "missing Color union summary"
     | Some summary ->
        begin match summary.union_variants with
        | [rgb; greyscale] ->
           begin match rgb.union_variant_payload with
           | NamedVariantPayload fields ->
              assert_equal ["red"; "green"; "blue"] (List.map (fun field -> field.record_field_name) fields)
           | _ -> assert_failure "unexpected RGB payload"
           end;
           begin match greyscale.union_variant_payload with
           | UnnamedVariantPayload payload -> assert_equal "Nat8" (render_type_ref payload)
           | _ -> assert_failure "unexpected Greyscale payload"
           end
        | _ -> assert_failure "unexpected Color variants"
        end
     end
  | _ -> assert_failure "unexpected union declarations"

let test_bitrecord_summary _ =
  let source = String.concat "\n" [
      "module Demo.Bits is";
      "bitrecord TcpFlags: Nat16 is";
      "    field fin: bit 0;";
      "    field window: bits 7..4;";
      "    reserved bits 15..8;";
      "build;";
      "seal;";
    ]
  in
  let unit = parse_ok ~executable_entry:false "src/Demo/Bits.kyo" source in
  match unit.declarations with
  | [declaration] ->
     begin match declaration.declaration_bitrecord with
     | None -> assert_failure "missing bitrecord summary"
     | Some summary ->
        assert_equal "Nat16" summary.bitrecord_backing_type;
        assert_equal 3 (List.length summary.bitrecord_items)
     end
  | _ -> assert_failure "unexpected declarations"

let test_typeclass_summary _ =
  let source = String.concat "\n" [
      "module Demo.Iteration is";
      "public typeclass Iterable[Self: Type] is";
      "    type Item;";
      "    method next(iter: &![Self]): Optional[Self.Item];";
      "    method isEmpty(iter: &[Self]): Bool is";
      "        return false;";
      "    qed;";
      "spec;";
      "seal;";
    ]
  in
  let unit = parse_ok ~executable_entry:false "src/Demo/Iteration.kyo" source in
  match unit.declarations with
  | [declaration] ->
     begin match declaration.declaration_typeclass with
     | None -> assert_failure "missing typeclass summary"
     | Some summary ->
        assert_equal ["Self"] (generic_parameter_names summary.typeclass_generic_parameters);
        begin match summary.typeclass_items with
        | [AssociatedTypeDeclaration "Item";
           TypeclassMethod ("next", next_signature, None);
           TypeclassMethod ("isEmpty", _, Some [default_statement])] ->
           assert_equal "Optional[Self.Item]" (render_type_ref next_signature.function_return_type);
           assert_equal "return false;" (render_statement default_statement)
        | _ -> assert_failure "unexpected typeclass items"
        end
     end
  | _ -> assert_failure "unexpected declarations"

let test_instance_summary _ =
  let source = String.concat "\n" [
      "module Demo.Iteration is";
      "public instance Iterable[T: Type] for Buffer[T]";
      "where T: Displayable";
      "when target.os == Os.Linux";
      "is";
      "    type Item := T;";
      "    method next(iter: &![Buffer[T]]): Optional[T] is";
      "        return None;";
      "    qed;";
      "qed;";
      "seal;";
    ]
  in
  let unit = parse_ok ~executable_entry:false "src/Demo/Iteration.kyo" source in
  match unit.declarations with
  | [declaration] ->
     begin match declaration.declaration_instance, declaration.declaration_guard with
     | Some summary, Some guard ->
        assert_equal ["T"] (generic_parameter_names summary.instance_generic_parameters);
        assert_equal "Buffer[T]" (render_type_ref summary.instance_target_type);
        assert_equal 1 (List.length summary.instance_where_obligations);
        assert_equal 4 guard.expression_span.start_line;
        begin match summary.instance_items with
        | [AssociatedTypeDefinition ("Item", item_type);
           InstanceMethod ("next", signature, [method_statement])] ->
           assert_equal "T" (render_type_ref item_type);
           assert_equal "Optional[T]" (render_type_ref signature.function_return_type);
           assert_equal "return None;" (render_statement method_statement)
        | _ -> assert_failure "unexpected instance items"
        end
     | _ -> assert_failure "missing instance summary or guard"
     end
  | _ -> assert_failure "unexpected declarations"

let test_generator_summary _ =
  let source = String.concat "\n" [
      "module Demo.Generation is";
      "public generator Windows[T: Type, R: Region](source: &[Buffer[T], R], width: Index): Span[T]";
      "where T: Displayable";
      "when target.os == Os.Linux";
      "is";
      "    yield source[0..width];";
      "qed;";
      "seal;";
    ]
  in
  let unit = parse_ok ~executable_entry:false "src/Demo/Generation.kyo" source in
  match unit.declarations with
  | [declaration] ->
     begin match declaration.declaration_generator, declaration.declaration_guard with
     | Some summary, Some guard ->
        assert_equal ["T"; "R"] (generic_parameter_names summary.generator_generic_parameters);
        begin match summary.generator_parameters with
        | [source_parameter; width_parameter] ->
           assert_equal "source" source_parameter.parameter_name;
           assert_equal "&[Buffer[T], R]" (render_type_ref source_parameter.parameter_type);
           assert_equal "width" width_parameter.parameter_name;
           assert_equal "Index" (render_type_ref width_parameter.parameter_type)
        | _ -> assert_failure "unexpected generator parameters"
        end;
        assert_equal "Span[T]" (render_type_ref summary.generator_yield_type);
        assert_equal ["T: Displayable"]
          (List.map render_where_obligation summary.generator_where_obligations);
        assert_equal 4 guard.expression_span.start_line;
        assert_equal "qed" declaration.declaration_terminator;
        begin match declaration.declaration_body with
        | Some [statement] ->
           assert_equal "yield source[0..width];" (render_statement statement)
        | _ -> assert_failure "missing structured generator body"
        end
     | _ -> assert_failure "missing generator summary or guard"
     end
  | _ -> assert_failure "unexpected declarations"

let test_function_body_statements _ =
  let source = String.concat "\n" [
      "module Demo.Bodies is";
      "function classify(value: Int32): Int32 is";
      "    let limit: Int32 := 10;";
      "    let { x, y: ignore } := point;";
      "    let Ok(result): Int32 := operation else Err(error) do";
      "        return fallback;";
      "    fi;";
      "    let Ok(saved) := save() or return;";
      "    let Ok(mapped) := load() or return error => wrap(error);";
      "    let Ok(item) := next() or break retry;";
      "    let Ok(more) := advance() or continue retry;";
      "    borrow view := &read value do";
      "        debug view;";
      "    drop;";
      "    taskgroup do";
      "        spawn [value, &counter] do";
      "            debug value;";
      "        od else spawn_error do";
      "            debug spawn_error;";
      "        fi;";
      "    join;";
      "    select";
      "        when receive(rx) do";
      "            debug value;";
      "        timeout(deadline) do";
      "            debug deadline;";
      "    pick;";
      "    wait";
      "        when ready(token) do";
      "            debug token;";
      "        default do";
      "            debug idle;";
      "    wake;";
      "    var current: Int32 := value;";
      "    current := current + 1;";
      "    debug value;";
      "    defer closeLog();";
      "    while current < limit do";
      "        current := current + 1;";
      "    od;";
      "    while let Some(next) := queue.next() do";
      "        debug next;";
      "    od;";
      "    for i from 0 below limit do";
      "        debug i;";
      "    od;";
      "    for Some(item) in items do";
      "        debug item;";
      "    od;";
      "    case state of";
      "        when None do";
      "            debug state;";
      "        when Some(item) do";
      "            debug item;";
      "    esac;";
      "    if value > 0 then";
      "        return value;";
      "    else if value == 0 then";
      "        todo \"zero\";";
      "    else";
      "        panic(\"negative\");";
      "    fi;";
      "qed;";
      "seal;";
    ]
  in
  let unit = parse_ok ~executable_entry:false "src/Demo/Bodies.kyo" source in
  match unit.declarations with
  | [declaration] ->
     begin match declaration.declaration_body with
     | Some [let_statement; destructure_statement; let_else_statement; or_return_statement;
             mapped_return_statement; or_break_statement; or_continue_statement;
             borrow_statement; taskgroup_statement; select_statement; wait_statement;
             var_statement; assignment_statement; debug_statement;
             defer_statement; while_statement; while_let_statement; range_statement;
             for_in_statement; case_statement; if_statement] ->
        assert_equal "let limit: Int32 := 10;" (render_statement let_statement);
        assert_equal "let { x, y: ignore } := point;" (render_statement destructure_statement);
        assert_equal
          "let Ok(result): Int32 := operation else Err(error) do return fallback; fi;"
          (render_statement let_else_statement);
        assert_equal "let Ok(saved) := save() or return;" (render_statement or_return_statement);
        assert_equal
          "let Ok(mapped) := load() or return error => wrap(error);"
          (render_statement mapped_return_statement);
        assert_equal
          "let Ok(item) := next() or break retry;"
          (render_statement or_break_statement);
        assert_equal
          "let Ok(more) := advance() or continue retry;"
          (render_statement or_continue_statement);
        assert_equal
          "borrow view := &read value do debug view; drop;"
          (render_statement borrow_statement);
        assert_equal
          "taskgroup do spawn [value, &counter] do debug value; od else spawn_error do debug spawn_error; fi; join;"
          (render_statement taskgroup_statement);
        assert_equal
          "select when receive(rx) do debug value; timeout(deadline) do debug deadline; pick;"
          (render_statement select_statement);
        assert_equal
          "wait when ready(token) do debug token; default do debug idle; wake;"
          (render_statement wait_statement);
        assert_equal "var current: Int32 := value;" (render_statement var_statement);
        assert_equal "current := current + 1;" (render_statement assignment_statement);
        assert_equal "debug value;" (render_statement debug_statement);
        assert_equal "defer closeLog();" (render_statement defer_statement);
        assert_equal
          "while current < limit do current := current + 1; od;"
          (render_statement while_statement);
        assert_equal
          "while let Some(next) := queue.next() do debug next; od;"
          (render_statement while_let_statement);
        assert_equal
          "for i from 0 below limit do debug i; od;"
          (render_statement range_statement);
        assert_equal
          "for Some(item) in items do debug item; od;"
          (render_statement for_in_statement);
        assert_equal
          "case state of when None do debug state; when Some(item) do debug item; esac;"
          (render_statement case_statement);
        assert_equal
          "if value > 0 then return value; else if value == 0 then todo \"zero\"; else panic (\"negative\"); fi;"
          (render_statement if_statement)
     | _ -> assert_failure "unexpected function body structure"
     end
  | _ -> assert_failure "unexpected declarations"

let test_foreign_block_summary _ =
  let source = String.concat "\n" [
      "pragma Unsafe_Module;";
      "module Demo.Foreign is";
      "foreign \"C\" is";
      "    function c_open(path: Address[Nat8], flags: Int32): Int32;";
      "    constant EINVAL: Int32;";
      "mon;";
      "seal;";
    ]
  in
  let unit = parse_ok ~executable_entry:false "src/Demo/Foreign.kyo" source in
  match unit.declarations with
  | [declaration] ->
     begin match declaration.declaration_foreign_block with
     | None -> assert_failure "missing foreign block summary"
     | Some summary ->
        assert_equal "\"C\"" summary.foreign_abi;
        begin match summary.foreign_declarations with
        | [ForeignFunction ("c_open", parameters, return_type);
           ForeignConstant ("EINVAL", constant_type)] ->
           assert_equal ["Address[Nat8]"; "Int32"]
             (List.map (fun parameter -> render_type_ref parameter.parameter_type) parameters);
           assert_equal "Int32" (render_type_ref return_type);
           assert_equal "Int32" (render_type_ref constant_type)
        | _ -> assert_failure "unexpected foreign declarations"
        end
     end
  | _ -> assert_failure "unexpected declarations"

let test_unsafe_contract_summary _ =
  let source = String.concat "\n" [
      "pragma Unsafe_Module;";
      "module Demo.Foreign is";
      "unsafe contract RawIo is";
      "    module_invariant \"descriptors remain owned\" evidence \"fd tests\";";
      "    covers foreign:c_open assumes \"C ABI\" maps_failure \"negative errno\" owns \"returned descriptor\";";
      "    additional_invariant foreign:c_close cleanup \"close exactly once\";";
      "audit;";
      "seal;";
    ]
  in
  let unit = parse_ok ~executable_entry:false "src/Demo/Foreign.kyo" source in
  match unit.declarations with
  | [declaration] ->
     begin match declaration.declaration_unsafe_contract with
     | None -> assert_failure "missing unsafe contract summary"
     | Some summary ->
        begin match summary.unsafe_contract_items with
        | [ModuleInvariant ("\"descriptors remain owned\"", [evidence]);
           CoversOperation (["foreign"; "c_open"], [assumes; maps_failure; owns]);
           AdditionalInvariant (["foreign"; "c_close"], [cleanup])] ->
           assert_bool "evidence" (equal_unsafe_contract_field_kind evidence.unsafe_field_kind EvidenceField);
           assert_bool "assumes" (equal_unsafe_contract_field_kind assumes.unsafe_field_kind AssumesField);
           assert_bool "maps failure" (equal_unsafe_contract_field_kind maps_failure.unsafe_field_kind MapsFailureField);
           assert_bool "owns" (equal_unsafe_contract_field_kind owns.unsafe_field_kind OwnsField);
           assert_bool "cleanup" (equal_unsafe_contract_field_kind cleanup.unsafe_field_kind CleanupField)
        | _ -> assert_failure "unexpected unsafe contract items"
        end
     end
  | _ -> assert_failure "unexpected declarations"

let test_reject_retired_module_body _ =
  parse_error ~executable_entry:false "src/Main.kyo" "module body Main is\nseal;"
    RetiredModuleBody

let test_reject_retired_source_extension _ =
  parse_error ~executable_entry:false "src/Main.kai" "module Main is\nseal;"
    (SourceRoleError (Kyokai_frontend.KyokaiSourceFile.RetiredSourceExtension "src/Main.kai"))

let test_reject_explicit_private _ =
  parse_error ~executable_entry:false "src/Main.kyo" "module Main is\nprivate function helper(): Unit is\nqed;\nseal;"
    ExplicitPrivateMarker

let test_reject_opaque_function _ =
  parse_error ~executable_entry:false "src/Main.kyo" "module Main is\npublic opaque function helper(): Unit is\nqed;\nseal;"
    InvalidOpaqueModifier

let test_reject_invalid_generic_classifier _ =
  parse_error ~executable_entry:false "src/Main.kyo"
    "module Main is\nfunction helper[T: Auto](value: T): Unit is\nqed;\nseal;"
    (ExpectedToken "Type, Free, Linear, Index, or Region")

let test_reject_invalid_where_obligation _ =
  parse_error ~executable_entry:false "src/Main.kyo"
    "module Main is\nfunction helper[T: Type](value: T): Unit where T is\nqed;\nseal;"
    (ExpectedToken ": or ==")

let test_reject_non_projection_where_equality _ =
  parse_error ~executable_entry:false "src/Main.kyo"
    "module Main is\nfunction helper[T: Type](value: T): Unit where T == Unit is\nqed;\nseal;"
    ExpectedAssociatedTypeProjection

let test_reject_empty_declaration_guard _ =
  parse_error ~executable_entry:false "src/Main.kyo"
    "module Main is\nfunction helper(): Unit when is\nqed;\nseal;"
    (ExpectedToken "declaration guard expression")

let test_reject_chained_comparison _ =
  parse_error ~executable_entry:false "src/Main.kyo"
    "module Main is\nconstant ordered: Bool := a < b < c;\nseal;"
    (ExpectedToken "parenthesized or combined comparison")

let test_reject_mixed_bitwise_operators _ =
  parse_error ~executable_entry:false "src/Main.kyo"
    "module Main is\nconstant flags: Nat32 := a band b bor c;\nseal;"
    (ExpectedToken "parenthesized mixed operator families")

let test_accept_parenthesized_operator_families _ =
  let source = String.concat "\n" [
      "module Demo.Expressions is";
      "constant ordered: Bool := (a < b) and (b < c);";
      "constant flags: Nat32 := (a band b) bor c;";
      "seal;";
    ]
  in
  let unit = parse_ok ~executable_entry:false "src/Demo/Expressions.kyo" source in
  match unit.declarations with
  | [ordered; flags] ->
     begin match ordered.declaration_constant, flags.declaration_constant with
     | Some ordered_summary, Some flags_summary ->
        assert_equal "(a < b) and (b < c)"
          (render_expression ordered_summary.constant_initializer);
        assert_equal "(a band b) bor c"
          (render_expression flags_summary.constant_initializer)
     | _ -> assert_failure "missing expression summaries"
     end
  | _ -> assert_failure "unexpected expression declarations"

let test_expression_forms _ =
  let source = String.concat "\n" [
      "module Demo.ExpressionForms is";
      "constant empty: Buffer := makeBuffer();";
      "constant slice: Span := values[start + 1..limit];";
      "constant embedded: StaticString := static \"asset.txt\";";
      "constant generated: Buffer := comptime @embedBytes(\"asset.bin\");";
      "constant checked: Unit := static_assert(limit >= 1, \"limit required\");";
      "constant point: Point := Point { x: 1, y };";
      "constant moved: Point := Point { x: 2, with point };";
      "constant color: Color := Color.RGB { red: 255, green: 0, blue: 0 };";
      "constant predicate: Predicate := fn [limit, &cfg, &!state] (value: Int32): Bool => value < limit and cfg.ready;";
      "constant mapper: Mapper := fn [limit] (value: Int32): Int32 is";
      "    return value + limit;";
      "qed;";
      "constant pair: Pair := build Pair do";
      "    let left := 1;";
      "    produce Pair { left, right: 2 };";
      "build;";
      "seal;";
    ]
  in
  let unit = parse_ok ~executable_entry:false "src/Demo/ExpressionForms.kyo" source in
  let rendered =
    List.map
      (fun declaration ->
        match declaration.declaration_constant with
        | Some summary -> render_expression summary.constant_initializer
        | None -> assert_failure "missing expression summary")
      unit.declarations
  in
  assert_equal
    ["makeBuffer()";
     "values[start + 1..limit]";
     "static \"asset.txt\"";
     "comptime @embedBytes(\"asset.bin\")";
     "static_assert(limit >= 1, \"limit required\")";
     "Point { x: 1, y }";
     "Point { x: 2, with point }";
     "Color.RGB { red: 255, green: 0, blue: 0 }";
     "fn [limit, &cfg, &!state] (value: Int32): Bool => value < limit and cfg.ready";
     "fn [limit] (value: Int32): Int32 is return value + limit; qed";
     "build Pair do let left := 1; produce Pair { left, right: 2 }; build"]
    rendered

let test_inline_test_declarations _ =
  let source = String.concat "\n" [
      "module Demo.Tests is";
      "test \"pure arithmetic\" is";
      "    assert(add(2, 2) == 4);";
      "qed;";
      "test \"reads env\" with (root: RootCapability) is";
      "    let env := root.env();";
      "    assert(env.isReady());";
      "qed;";
      "seal;";
    ]
  in
  let unit = parse_ok ~executable_entry:false "src/Demo/Tests.kyo" source in
  match unit.declarations with
  | [pure; effectful] ->
     assert_bool "pure test kind"
       (equal_declaration_kind pure.declaration_kind TestDeclaration);
     assert_equal None pure.declaration_name;
     assert_equal "qed" pure.declaration_terminator;
     begin match pure.declaration_test, pure.declaration_body with
     | Some summary, Some [body] ->
        assert_equal "\"pure arithmetic\"" summary.test_description;
        assert_equal [] summary.test_capability_parameters;
        assert_equal "assert(add(2, 2) == 4);" (render_statement body)
     | _ -> assert_failure "missing pure test summary or body"
     end;
     begin match effectful.declaration_test, effectful.declaration_body with
     | Some summary, Some body ->
        assert_equal "\"reads env\"" summary.test_description;
        begin match summary.test_capability_parameters with
        | [parameter] ->
           assert_equal "root" parameter.parameter_name;
           assert_equal "RootCapability" (render_type_ref parameter.parameter_type)
        | _ -> assert_failure "unexpected test capability parameters"
        end;
        assert_equal 2 (List.length body)
     | _ -> assert_failure "missing capability test summary or body"
     end
  | _ -> assert_failure "unexpected inline test declarations"

let test_reject_test_modifiers _ =
  parse_error ~executable_entry:false "src/Main.kyo"
    "module Main is\npublic test \"visible\" is\nqed;\nseal;"
    InvalidTestModifier

let test_borrow_creation_spellings _ =
  let source = String.concat "\n" [
      "module Demo.Borrows is";
      "function inspect(value: Int32, slot: Int32, loan: &[Int32]): Unit is";
      "    borrow first := &read value do";
      "        debug first;";
      "    drop;";
      "    borrow second := &write slot do";
      "        debug second;";
      "    drop;";
      "    borrow third := &reborrow loan do";
      "        debug third;";
      "    drop;";
      "qed;";
      "seal;";
    ]
  in
  let unit = parse_ok ~executable_entry:false "src/Demo/Borrows.kyo" source in
  match unit.declarations with
  | [{ declaration_body = Some [first; second; third]; _ }] ->
     assert_equal "borrow first := &read value do debug first; drop;" (render_statement first);
     assert_equal "borrow second := &write slot do debug second; drop;" (render_statement second);
     assert_equal "borrow third := &reborrow loan do debug third; drop;" (render_statement third)
  | _ -> assert_failure "expected three structured borrow scopes"

let test_reject_bodyless_generator _ =
  parse_error ~executable_entry:false "src/Main.kyo"
    "module Main is\ngenerator Values(): Int32;\nseal;"
    (ExpectedToken "is")

let test_reject_unclosed_module _ =
  parse_error ~executable_entry:false "src/Main.kyo" "module Main is\nfunction main(): Unit;"
    (ExpectedToken "is")

let test_reject_unknown_top_level_form _ =
  parse_error ~executable_entry:false "src/Main.kyo" "module Main is\nvar global: Int32;\nseal;"
    UnknownTopLevelDeclaration

let test_reject_trailing_tokens_after_structured_declaration _ =
  parse_error ~executable_entry:false "src/Main.kyo"
    "module Main is\nconstant selected: Int32 := value->field;\nseal;"
    (ExpectedToken ";")

let test_parse_entry_shebang _ =
  let source = "#!/usr/bin/env kyokai\nmodule Main is\nfunction main(): Unit is\nqed;\nseal;" in
  let unit = parse_ok ~executable_entry:true "src/Main.kyo" source in
  assert_equal 2 unit.module_span.start_line;
  assert_equal ["Main"] unit.module_name

let suite =
  "KyokaiSurfaceParser" >::: [
      "single source skeleton" >:: test_source_skeleton;
      "definition skeleton" >:: test_definition_skeleton;
      "function signature summary" >:: test_function_signature_summary;
      "structured reference and function pointer types" >:: test_structured_reference_and_function_pointer_types;
      "where clause summary" >:: test_where_clause_summary;
      "const generic arguments" >:: test_const_generic_arguments;
      "function contract spans" >:: test_function_contract_spans;
      "declaration guard spans" >:: test_declaration_guard_spans;
      "record summary" >:: test_record_summary;
      "type alias summary" >:: test_type_alias_summary;
      "constant summary" >:: test_constant_summary;
      "union summary" >:: test_union_summary;
      "bitrecord summary" >:: test_bitrecord_summary;
      "typeclass summary" >:: test_typeclass_summary;
      "instance summary" >:: test_instance_summary;
      "generator summary" >:: test_generator_summary;
      "function body statements" >:: test_function_body_statements;
      "foreign block summary" >:: test_foreign_block_summary;
      "unsafe contract summary" >:: test_unsafe_contract_summary;
      "reject retired module body" >:: test_reject_retired_module_body;
      "reject retired source extension" >:: test_reject_retired_source_extension;
      "reject explicit private" >:: test_reject_explicit_private;
      "reject opaque function" >:: test_reject_opaque_function;
      "reject invalid generic classifier" >:: test_reject_invalid_generic_classifier;
      "reject invalid where obligation" >:: test_reject_invalid_where_obligation;
      "reject non-projection where equality" >:: test_reject_non_projection_where_equality;
      "reject empty declaration guard" >:: test_reject_empty_declaration_guard;
      "reject chained comparison" >:: test_reject_chained_comparison;
      "reject mixed bitwise operators" >:: test_reject_mixed_bitwise_operators;
      "accept parenthesized operator families" >:: test_accept_parenthesized_operator_families;
      "expression forms" >:: test_expression_forms;
      "inline test declarations" >:: test_inline_test_declarations;
      "borrow creation spellings" >:: test_borrow_creation_spellings;
      "reject test modifiers" >:: test_reject_test_modifiers;
      "reject bodyless generator" >:: test_reject_bodyless_generator;
      "reject unclosed module" >:: test_reject_unclosed_module;
      "reject unknown top level form" >:: test_reject_unknown_top_level_form;
      "reject trailing declaration tokens" >:: test_reject_trailing_tokens_after_structured_declaration;
      "parse entry shebang" >:: test_parse_entry_shebang;
    ]

let _ = run_test_tt_main suite
