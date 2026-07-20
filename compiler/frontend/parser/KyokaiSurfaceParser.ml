(*
   Part of the Kyokai project.

   SPDX-License-Identifier: GPL-3.0-or-later
*)

(* kyokai:prooftrace id=FRONTEND-KYOKAI-SURFACE-PARSER *)

include KyokaiSurfaceAst

type parser = {
  tokens: KyokaiLexicalToken.token array;
  mutable index: int;
}

let is_comment_token (token: KyokaiLexicalToken.token): bool =
  match token.kind with
  | Comment _ -> true
  | _ -> false

let make_parser tokens =
  let significant =
    tokens
    |> List.filter (fun token -> not (is_comment_token token))
    |> Array.of_list
  in
  { tokens = significant; index = 0 }

let current parser =
  if parser.index >= Array.length parser.tokens then None
  else Some parser.tokens.(parser.index)

let advance parser =
  match current parser with
  | None -> None
  | Some token ->
     parser.index <- parser.index + 1;
     Some token

let token_text token =
  (token: KyokaiLexicalToken.token).text

let token_span token =
  (token: KyokaiLexicalToken.token).span

let error ?token kind =
  Error { parser_error_kind = kind; parser_error_span = Option.map token_span token }

let eof_error kind =
  Error { parser_error_kind = kind; parser_error_span = None }

let is_text parser text =
  match current parser with
  | Some token -> token_text token = text
  | None -> false

let is_eof_token token =
  (token: KyokaiLexicalToken.token).kind = KyokaiLexicalToken.Eof

let expect_text parser text =
  match current parser with
  | Some token when token_text token = text ->
     ignore (advance parser);
     Ok token
  | Some token -> error ~token (ExpectedToken text)
  | None -> eof_error (ExpectedToken text)

let expect_semicolon parser =
  expect_text parser ";"

let is_ascii_upper char =
  'A' <= char && char <= 'Z'

let is_module_identifier text =
  String.length text > 0 && is_ascii_upper text.[0]

let is_identifier_token token =
  match (token: KyokaiLexicalToken.token).kind with
  | Identifier -> true
  | _ -> false

let expect_identifier parser =
  match current parser with
  | Some token when is_identifier_token token ->
     ignore (advance parser);
     Ok token
  | Some token -> error ~token ExpectedIdentifier
  | None -> eof_error ExpectedIdentifier

let is_identifier_or_keyword_token token =
  match (token: KyokaiLexicalToken.token).kind with
  | Identifier | Keyword -> true
  | _ -> false

let expect_identifier_or_keyword parser =
  match current parser with
  | Some token when is_identifier_or_keyword_token token ->
     ignore (advance parser);
     Ok token
  | Some token -> error ~token ExpectedIdentifier
  | None -> eof_error ExpectedIdentifier

let expect_module_identifier parser =
  match expect_identifier parser with
  | Error error -> Error error
  | Ok token ->
     if is_module_identifier (token_text token) then Ok token
     else error ~token ExpectedModuleIdentifier

let parse_module_name parser =
  let rec loop acc =
    if is_text parser "." then begin
      ignore (advance parser);
      match expect_module_identifier parser with
      | Error error -> Error error
      | Ok token -> loop (token_text token :: acc)
    end else
      Ok (List.rev acc)
  in
  match expect_module_identifier parser with
  | Error error -> Error error
  | Ok first -> loop [token_text first]

let parse_import_item parser =
  match expect_identifier parser with
  | Error error -> Error error
  | Ok imported ->
     if is_text parser "as" then begin
       ignore (advance parser);
       match expect_identifier parser with
       | Error error -> Error error
       | Ok local -> Ok { imported_name = token_text imported; local_name = Some (token_text local) }
     end else
       Ok { imported_name = token_text imported; local_name = None }

let parse_import_items parser =
  let rec loop acc =
    if is_text parser ")" then Ok (List.rev acc)
    else
      match parse_import_item parser with
      | Error error -> Error error
      | Ok item ->
         if is_text parser "," then begin
           ignore (advance parser);
           loop (item :: acc)
         end else
           Ok (List.rev (item :: acc))
  in
  loop []

let parse_import parser =
  match expect_text parser "import" with
  | Error error -> Error error
  | Ok start ->
     begin match parse_module_name parser with
     | Error error -> Error error
     | Ok import_module ->
        let parse_kind () =
          if is_text parser "as" then begin
            ignore (advance parser);
            match expect_module_identifier parser with
            | Error error -> Error error
            | Ok alias -> Ok (ModuleAliasImport (token_text alias))
          end else if is_text parser "(" then begin
            ignore (advance parser);
            match parse_import_items parser with
            | Error error -> Error error
            | Ok items ->
               begin match expect_text parser ")" with
               | Error error -> Error error
               | Ok _ -> Ok (SelectiveImport items)
               end
          end else
            Ok QualifiedImport
        in
        begin match parse_kind () with
        | Error error -> Error error
        | Ok import_kind ->
           begin match expect_semicolon parser with
           | Error error -> Error error
           | Ok end_token ->
              Ok { import_module; import_kind; import_span = { (token_span start) with end_byte = end_token.span.end_byte; end_line = end_token.span.end_line; end_column = end_token.span.end_column } }
           end
        end
     end

let parse_pragma parser =
  match expect_text parser "pragma" with
  | Error error -> Error error
  | Ok start ->
     begin match expect_identifier_or_keyword parser with
     | Error error -> Error error
     | Ok _ ->
        begin match expect_semicolon parser with
        | Error error -> Error error
        | Ok end_token ->
           Ok { (token_span start) with end_byte = end_token.span.end_byte; end_line = end_token.span.end_line; end_column = end_token.span.end_column }
        end
     end

let nested_terminator token previous_text outer_terminator =
  match token_text token with
  | "record" | "bitrecord" | "union" -> Some "build"
  | "function" | "method" | "instance" | "generator"
       when outer_terminator = "qed" || outer_terminator = "spec" -> Some "qed"
  | "typeclass" -> Some "spec"
  | "type" when previous_text = Some "extern" -> None
  | _ -> None

let consume_optional_semicolon parser =
  if is_text parser ";" then ignore (advance parser)

let scan_to_simple_semicolon parser =
  let rec loop () =
    match current parser with
    | None -> eof_error UnexpectedEndOfFile
    | Some token when token_text token = ";" ->
       ignore (advance parser);
       Ok (token, ";")
    | Some _ ->
       ignore (advance parser);
       loop ()
  in
  loop ()

let scan_to_boundary parser terminator =
  let rec loop stack previous_text =
    match current parser with
    | None -> eof_error (UnclosedBoundary terminator)
    | Some token when token_text token = terminator && stack = [] ->
       ignore (advance parser);
       begin match expect_semicolon parser with
       | Error error -> Error error
       | Ok end_token -> Ok (end_token, terminator)
       end
    | Some token ->
       let text = token_text token in
       begin match stack with
       | nested :: rest when text = nested ->
          ignore (advance parser);
          consume_optional_semicolon parser;
          loop rest (Some text)
       | _ ->
          let next_stack =
            match nested_terminator token previous_text terminator with
            | Some nested -> nested :: stack
            | None -> stack
          in
          ignore (advance parser);
          loop next_stack (Some text)
       end
  in
  loop [] None

let declaration_kind_for_start parser start_token =
  match token_text start_token with
  | "constant" -> Ok (ConstantDeclaration, None, None)
  | "type" ->
     begin match expect_text parser "alias" with
     | Error error -> Error error
     | Ok _ -> Ok (TypeDeclaration, None, None)
     end
  | "capability" -> Ok (CapabilityDeclaration, None, None)
  | "record" -> Ok (RecordDeclaration, None, Some OrdinaryRecord)
  | "packed" ->
     begin match expect_text parser "record" with
     | Error error -> Error error
     | Ok _ -> Ok (RecordDeclaration, None, Some PackedRecord)
     end
  | "bitrecord" -> Ok (BitrecordDeclaration, Some "build", None)
  | "union" -> Ok (UnionDeclaration, Some "build", None)
  | "function" -> Ok (FunctionDeclaration, None, None)
  | "receiver" ->
     begin match expect_text parser "function" with
     | Error error -> Error error
     | Ok _ -> Ok (FunctionDeclaration, None, None)
     end
  | "typeclass" -> Ok (TypeclassDeclaration, Some "spec", None)
  | "instance" -> Ok (InstanceDeclaration, None, None)
  | "generator" -> Ok (GeneratorDeclaration, None, None)
  | "test" -> Ok (TestDeclaration, None, None)
  | "foreign" -> Ok (ForeignBlock, Some "mon", None)
  | "unsafe" ->
     begin match expect_text parser "contract" with
     | Error error -> Error error
     | Ok _ -> Ok (UnsafeContract, Some "audit", None)
     end
  | "extern" ->
     begin match current parser with
     | Some token when token_text token = "type" ->
        ignore (advance parser);
        Ok (ExternTypeDeclaration, None, None)
     | Some token when token_text token = "record" ->
        ignore (advance parser);
        Ok (RecordDeclaration, None, Some ExternRecord)
     | Some token -> error ~token UnknownTopLevelDeclaration
     | None -> eof_error UnexpectedEndOfFile
     end
  | "compile_error" -> Ok (CompileErrorDeclaration, None, None)
  | _ -> error ~token:start_token UnknownTopLevelDeclaration

let declaration_kind_has_name declaration_kind =
  match declaration_kind with
  | ConstantDeclaration
  | TypeDeclaration
  | ExternTypeDeclaration
  | RecordDeclaration
  | BitrecordDeclaration
  | UnionDeclaration
  | CapabilityDeclaration
  | FunctionDeclaration
  | TypeclassDeclaration
  | InstanceDeclaration
  | GeneratorDeclaration
  | UnsafeContract -> true
  | TestDeclaration
  | ForeignBlock
  | CompileErrorDeclaration -> false

let parse_optional_declaration_name parser declaration_kind =
  if declaration_kind_has_name declaration_kind then
    match current parser with
    | Some token when is_identifier_token token ->
       ignore (advance parser);
       Some (token_text token)
    | _ -> None
  else
    None

let parse_optional_region parser =
  if is_text parser "]" then
    Ok None
  else
    match expect_text parser "," with
    | Error error -> Error error
    | Ok _ ->
       begin match expect_identifier parser with
       | Error error -> Error error
       | Ok region -> Ok (Some (token_text region))
       end

let rec parse_type_ref parser =
  match current parser with
  | Some token when token_text token = "&" ->
     ignore (advance parser);
     begin match expect_text parser "[" with
     | Error error -> Error error
     | Ok _ ->
        begin match parse_type_ref parser with
        | Error error -> Error error
        | Ok inner ->
           begin match parse_optional_region parser with
           | Error error -> Error error
           | Ok region ->
              begin match expect_text parser "]" with
              | Error error -> Error error
              | Ok _ -> Ok (ReadBorrowType (inner, region))
              end
           end
        end
     end
  | Some token when token_text token = "&!" ->
     ignore (advance parser);
     begin match expect_text parser "[" with
     | Error error -> Error error
     | Ok _ ->
        begin match parse_type_ref parser with
        | Error error -> Error error
        | Ok inner ->
           begin match parse_optional_region parser with
           | Error error -> Error error
           | Ok region ->
              begin match expect_text parser "]" with
              | Error error -> Error error
              | Ok _ -> Ok (WriteBorrowType (inner, region))
              end
           end
        end
     end
  | Some token when token_text token = "FnPtr" ->
     ignore (advance parser);
     begin match expect_text parser "(" with
     | Error error -> Error error
     | Ok _ ->
        begin match parse_type_list parser with
        | Error error -> Error error
        | Ok parameters ->
           begin match expect_text parser ":" with
           | Error error -> Error error
           | Ok _ ->
              begin match parse_type_ref parser with
              | Error error -> Error error
              | Ok return_type -> Ok (FunctionPointerType (parameters, return_type))
              end
           end
        end
     end
  | Some token when is_identifier_token token ->
     begin match parse_module_name parser with
     | Error error -> Error error
     | Ok name ->
        if is_text parser "[" then begin
          ignore (advance parser);
          match parse_type_arguments parser with
          | Error error -> Error error
          | Ok args -> Ok (NamedType (name, args))
        end else
          Ok (NamedType (name, []))
     end
  | Some token -> error ~token ExpectedType
  | None -> eof_error ExpectedType

and parse_type_arguments parser =
  if is_text parser "]" then begin
    ignore (advance parser);
    Ok []
  end else
    let rec loop acc =
      match parse_generic_argument parser with
      | Error error -> Error error
      | Ok argument ->
         if is_text parser "," then begin
           ignore (advance parser);
           if is_text parser "]" then begin
             ignore (advance parser);
             Ok (List.rev (argument :: acc))
           end else
             loop (argument :: acc)
         end else
           begin match expect_text parser "]" with
           | Error error -> Error error
           | Ok _ -> Ok (List.rev (argument :: acc))
           end
    in
    loop []

and parse_generic_argument parser =
  match current parser with
  | Some token ->
     begin match token.kind with
     | KyokaiLexicalToken.IntegerLiteral _ ->
        begin match parse_const_generic_expression parser with
        | Error error -> Error error
        | Ok expression -> Ok (ConstArgument expression)
        end
     | _ when token_text token = "(" ->
        begin match parse_const_generic_expression parser with
        | Error error -> Error error
        | Ok expression -> Ok (ConstArgument expression)
        end
     | _ when is_identifier_token token ->
        let start_index = parser.index in
        begin match parse_type_ref parser with
        | Error error -> Error error
        | Ok (NamedType (name, [])) ->
           if is_const_binary_operator parser then begin
             parser.index <- start_index;
             begin match parse_const_generic_expression parser with
             | Error error -> Error error
             | Ok expression -> Ok (ConstArgument expression)
             end
           end else
             Ok (UnresolvedNameArgument name)
        | Ok type_ref -> Ok (TypeArgument type_ref)
        end
     | _ ->
        begin match parse_type_ref parser with
        | Error error -> Error error
        | Ok type_ref -> Ok (TypeArgument type_ref)
        end
     end
  | None -> eof_error ExpectedType

and parse_const_generic_expression parser =
  parse_const_binary_expression parser 0

and parse_const_binary_expression parser minimum_precedence =
  match parse_const_primary parser with
  | Error error -> Error error
  | Ok left -> parse_const_binary_rhs parser minimum_precedence left

and parse_const_binary_rhs parser minimum_precedence left =
  match const_binary_operator parser with
  | Some (operator, precedence) when precedence >= minimum_precedence ->
     ignore (advance parser);
     begin match parse_const_binary_expression parser (precedence + 1) with
     | Error error -> Error error
     | Ok right -> parse_const_binary_rhs parser minimum_precedence (ConstBinary (left, operator, right))
     end
  | _ -> Ok left

and parse_const_primary parser =
  match current parser with
  | Some token ->
     begin match token.kind with
     | KyokaiLexicalToken.IntegerLiteral _ ->
        ignore (advance parser);
        Ok (ConstIndexLiteral (token_text token))
     | _ when is_identifier_token token ->
        begin match parse_module_name parser with
        | Error error -> Error error
        | Ok name -> Ok (ConstName name)
        end
     | _ when token_text token = "(" ->
        ignore (advance parser);
        begin match parse_const_generic_expression parser with
        | Error error -> Error error
        | Ok expression ->
           begin match expect_text parser ")" with
           | Error error -> Error error
           | Ok _ -> Ok (ConstParenthesized expression)
           end
        end
     | _ -> error ~token (ExpectedToken "Index const-generic expression")
     end
  | None -> eof_error (ExpectedToken "Index const-generic expression")

and const_binary_operator parser =
  match current parser with
  | Some token ->
     begin match token_text token with
     | "*" | "/" | "%" as operator -> Some (operator, 20)
     | "+" | "-" as operator -> Some (operator, 10)
     | _ -> None
     end
  | None -> None

and is_const_binary_operator parser =
  const_binary_operator parser <> None

and parse_type_list parser =
  if is_text parser ")" then begin
    ignore (advance parser);
    Ok []
  end else
    let rec loop acc =
      match parse_type_ref parser with
      | Error error -> Error error
      | Ok type_ref ->
         if is_text parser "," then begin
           ignore (advance parser);
           if is_text parser ")" then begin
             ignore (advance parser);
             Ok (List.rev (type_ref :: acc))
           end else
             loop (type_ref :: acc)
         end else
           begin match expect_text parser ")" with
           | Error error -> Error error
           | Ok _ -> Ok (List.rev (type_ref :: acc))
           end
    in
    loop []

let generic_parameter_classifier token =
  match token_text token with
  | "Type" -> Some TypeClassifier
  | "Free" -> Some FreeClassifier
  | "Linear" -> Some LinearClassifier
  | "Index" -> Some IndexClassifier
  | "Region" -> Some RegionClassifier
  | _ -> None

let parse_generic_parameter parser =
  match expect_identifier parser with
  | Error error -> Error error
  | Ok name ->
     begin match expect_text parser ":" with
     | Error error -> Error error
     | Ok _ ->
        begin match current parser with
        | Some token ->
           begin match generic_parameter_classifier token with
           | None -> error ~token (ExpectedToken "Type, Free, Linear, Index, or Region")
           | Some classifier ->
              ignore (advance parser);
              Ok {
                generic_parameter_name = token_text name;
                generic_parameter_classifier = classifier;
              }
           end
        | None -> eof_error (ExpectedToken "generic parameter classifier")
        end
     end

let parse_optional_generic_parameters parser =
  if not (is_text parser "[") then
    Ok []
  else begin
    ignore (advance parser);
    let rec loop acc =
      match parse_generic_parameter parser with
      | Error error -> Error error
      | Ok parameter ->
         if is_text parser "," then begin
           ignore (advance parser);
           if is_text parser "]" then begin
             ignore (advance parser);
             Ok (List.rev (parameter :: acc))
           end else
             loop (parameter :: acc)
         end else
           begin match expect_text parser "]" with
           | Error error -> Error error
           | Ok _ -> Ok (List.rev (parameter :: acc))
           end
    in
    if is_text parser "]" then
      match current parser with
      | Some token -> error ~token ExpectedIdentifier
      | None -> eof_error ExpectedIdentifier
    else
      loop []
  end

let parse_parameter parser =
  match expect_identifier parser with
  | Error error -> Error error
  | Ok name ->
     begin match expect_text parser ":" with
     | Error error -> Error error
     | Ok _ ->
        begin match parse_type_ref parser with
        | Error error -> Error error
        | Ok parameter_type -> Ok { parameter_name = token_text name; parameter_type }
        end
     end

let parse_parameter_list parser =
  if is_text parser ")" then begin
    ignore (advance parser);
    Ok []
  end else
    let rec loop acc =
      match parse_parameter parser with
      | Error error -> Error error
      | Ok parameter ->
         if is_text parser "," then begin
           ignore (advance parser);
           if is_text parser ")" then begin
             ignore (advance parser);
             Ok (List.rev (parameter :: acc))
           end else
             loop (parameter :: acc)
         end else
           begin match expect_text parser ")" with
           | Error error -> Error error
           | Ok _ -> Ok (List.rev (parameter :: acc))
           end
    in
    loop []

let parse_where_obligation parser =
  match parse_type_ref parser with
  | Error error -> Error error
  | Ok constrained_type ->
     if is_text parser ":" then begin
       ignore (advance parser);
       match parse_module_name parser with
       | Error error -> Error error
       | Ok typeclass_name -> Ok (TypeclassBound (constrained_type, typeclass_name))
     end else if is_text parser "==" then begin
       ignore (advance parser);
       match constrained_type with
       | NamedType (_ :: _ :: _, []) ->
          begin match parse_type_ref parser with
          | Error error -> Error error
          | Ok equal_type -> Ok (AssociatedTypeEquality (constrained_type, equal_type))
          end
       | _ ->
          begin match current parser with
          | Some token -> error ~token ExpectedAssociatedTypeProjection
          | None -> eof_error ExpectedAssociatedTypeProjection
          end
     end else
       match current parser with
       | Some token -> error ~token (ExpectedToken ": or ==")
       | None -> eof_error (ExpectedToken ": or ==")

let parse_optional_where_clause parser =
  if not (is_text parser "where") then
    Ok []
  else begin
    ignore (advance parser);
    let rec loop acc =
      match parse_where_obligation parser with
      | Error error -> Error error
      | Ok obligation ->
         if is_text parser "," then begin
           ignore (advance parser);
           if is_text parser "require" || is_text parser "ensure" || is_text parser "is" then
             Ok (List.rev (obligation :: acc))
           else
             loop (obligation :: acc)
         end else
           Ok (List.rev (obligation :: acc))
    in
    loop []
  end

let expression_span
      (start_token: KyokaiLexicalToken.token)
      (end_token: KyokaiLexicalToken.token) =
  {
    (token_span start_token) with
    end_byte = end_token.KyokaiLexicalToken.span.end_byte;
    end_line = end_token.KyokaiLexicalToken.span.end_line;
    end_column = end_token.KyokaiLexicalToken.span.end_column;
  }

let span_from_spans start_span end_span =
  {
    start_span with
    end_byte = end_span.end_byte;
    end_line = end_span.end_line;
    end_column = end_span.end_column;
  }

let expression_with_span expression_kind expression_span =
  { expression_kind; expression_span }

let expect_static_string_literal parser =
  match current parser with
  | Some token ->
     begin match token.kind with
     | KyokaiLexicalToken.StaticStringLiteral _ ->
        ignore (advance parser);
        Ok token
     | _ -> error ~token (ExpectedToken "string literal")
     end
  | None -> eof_error (ExpectedToken "string literal")

let binary_operator parser =
  match current parser with
  | Some token ->
     begin match token_text token with
     | "or"
          when parser.index + 1 < Array.length parser.tokens
               && List.mem
                    (token_text parser.tokens.(parser.index + 1))
                    ["return"; "break"; "continue"] -> None
     | "or" -> Some ("or", 10, false)
     | "and" -> Some ("and", 20, false)
     | "<" | "<=" | ">" | ">=" | "==" | "!=" as operator ->
        Some (operator, 30, true)
     | "+" | "-" | "++" as operator -> Some (operator, 40, false)
     | "*" | "/" | "%" as operator -> Some (operator, 50, false)
     | "band" | "bor" | "bxor" | "shl" | "shr" | "rotl" | "rotr" as operator ->
        Some (operator, 35, false)
     | _ -> None
     end
  | None -> None

let is_comparison_expression expression =
  match expression.expression_kind with
  | BinaryExpression (_, ("<" | "<=" | ">" | ">=" | "==" | "!="), _) -> true
  | _ -> false

let bitwise_operator = function
  | "band" | "bor" | "bxor" | "shl" | "shr" | "rotl" | "rotr" -> true
  | _ -> false

let direct_binary_operator expression =
  match expression.expression_kind with
  | BinaryExpression (_, operator, _) -> Some operator
  | _ -> None

let mixes_operator_families operator expression =
  match direct_binary_operator expression with
  | None -> false
  | Some nested_operator ->
     if bitwise_operator operator then nested_operator <> operator
     else bitwise_operator nested_operator

let is_expression_name token =
  match (token: KyokaiLexicalToken.token).kind with
  | Identifier -> true
  | Keyword -> List.mem (token_text token) ["None"; "Ok"; "Err"; "Some"; "target"]
  | _ -> false

let rec parse_expression parser =
  parse_binary_expression parser 0

and parse_binary_expression parser minimum_precedence =
  match parse_prefix_expression parser with
  | Error error -> Error error
  | Ok left -> parse_binary_rhs parser minimum_precedence left

and parse_binary_rhs parser minimum_precedence left =
  match binary_operator parser with
  | Some (operator, precedence, comparison) when precedence >= minimum_precedence ->
     begin match current parser with
     | None -> eof_error (ExpectedToken "expression")
     | Some operator_token ->
        if comparison && is_comparison_expression left then
          error ~token:operator_token (ExpectedToken "parenthesized or combined comparison")
        else if mixes_operator_families operator left then
          error ~token:operator_token (ExpectedToken "parenthesized mixed operator families")
        else begin
          ignore (advance parser);
          match parse_binary_expression parser (precedence + 1) with
          | Error error -> Error error
          | Ok right ->
             if comparison && is_comparison_expression right then
               error ~token:operator_token (ExpectedToken "parenthesized or combined comparison")
             else if mixes_operator_families operator right then
               error ~token:operator_token (ExpectedToken "parenthesized mixed operator families")
             else
               let expression_span = span_from_spans left.expression_span right.expression_span in
               let combined = expression_with_span (BinaryExpression (left, operator, right)) expression_span in
               parse_binary_rhs parser minimum_precedence combined
        end
     end
  | _ -> Ok left

and parse_prefix_expression parser =
  match current parser with
  | Some token when List.mem (token_text token) ["&read"; "&write"; "&reborrow"; "~"; "-"; "not"; "bnot"] ->
     let operator = token_text token in
     ignore (advance parser);
     begin match parse_prefix_expression parser with
     | Error error -> Error error
     | Ok operand ->
        let expression_span = span_from_spans (token_span token) operand.expression_span in
        Ok (expression_with_span (UnaryExpression (operator, operand)) expression_span)
     end
  | Some token when token_text token = "comptime" ->
     ignore (advance parser);
     begin match parse_prefix_expression parser with
     | Error error -> Error error
     | Ok operand ->
        let expression_span = span_from_spans (token_span token) operand.expression_span in
        Ok (expression_with_span (ComptimeExpression operand) expression_span)
     end
  | _ ->
     begin match parse_primary_expression parser with
     | Error error -> Error error
     | Ok primary -> parse_postfix_expression parser primary
     end

and parse_primary_expression parser =
  match current parser with
  | Some token ->
     begin match token.kind with
     | KyokaiLexicalToken.IntegerLiteral _ ->
        ignore (advance parser);
        Ok (expression_with_span
              (LiteralExpression (IntegerExpressionLiteral (token_text token)))
              (token_span token))
     | KyokaiLexicalToken.FloatLiteral _ ->
        ignore (advance parser);
        Ok (expression_with_span
              (LiteralExpression (FloatExpressionLiteral (token_text token)))
              (token_span token))
     | KyokaiLexicalToken.StaticStringLiteral _ ->
        ignore (advance parser);
        Ok (expression_with_span
              (LiteralExpression (StaticStringExpressionLiteral (token_text token)))
              (token_span token))
     | KyokaiLexicalToken.CodePointLiteral ->
        ignore (advance parser);
        Ok (expression_with_span
              (LiteralExpression (CodePointExpressionLiteral (token_text token)))
              (token_span token))
     | KyokaiLexicalToken.ByteLiteral ->
        ignore (advance parser);
        Ok (expression_with_span
              (LiteralExpression (ByteExpressionLiteral (token_text token)))
              (token_span token))
     | _ when token_text token = "nil" ->
        ignore (advance parser);
        Ok (expression_with_span (LiteralExpression NilLiteral) (token_span token))
     | _ when token_text token = "true" || token_text token = "false" ->
        ignore (advance parser);
        Ok (expression_with_span
              (LiteralExpression (BoolLiteral (token_text token = "true")))
              (token_span token))
     | _ when token_text token = "static" ->
        ignore (advance parser);
        begin match expect_static_string_literal parser with
        | Error error -> Error error
        | Ok literal ->
           Ok (expression_with_span
                 (StaticStringBridgeExpression (token_text literal))
                 (expression_span token literal))
        end
     | _ when token_text token = "static_assert" -> parse_static_assert_expression parser
     | _ when token_text token = "build" -> parse_build_expression parser
     | _ when token_text token = "fn" -> parse_closure_expression parser
     | _ when token_text token = "(" -> parse_parenthesized_expression parser
     | _ when token_text token = "[" -> parse_array_expression parser
     | KyokaiLexicalToken.ComptimeBuiltin _ ->
        ignore (advance parser);
        Ok (expression_with_span (NameExpression (token_text token)) (token_span token))
     | _ when is_expression_name token -> parse_name_or_construction_expression parser
     | _ -> error ~token (ExpectedToken "expression")
     end
  | None -> eof_error (ExpectedToken "expression")

and parse_name_or_construction_expression parser =
  match current parser with
  | None -> eof_error (ExpectedToken "expression")
  | Some start_token ->
     let start_index = parser.index in
     begin match parse_type_ref parser with
     | Ok constructor_type when is_text parser "{" ->
        parse_named_field_construction parser start_token constructor_type
     | Ok _ | Error _ ->
        parser.index <- start_index;
        begin match current parser with
        | Some token when is_expression_name token ->
           ignore (advance parser);
           Ok (expression_with_span (NameExpression (token_text token)) (token_span token))
        | Some token -> error ~token (ExpectedToken "expression")
        | None -> eof_error (ExpectedToken "expression")
        end
     end

and parse_closure_expression parser =
  match expect_text parser "fn" with
  | Error error -> Error error
  | Ok start_token ->
     begin match expect_text parser "[" with
     | Error error -> Error error
     | Ok _ ->
        begin match parse_closure_captures parser with
        | Error error -> Error error
        | Ok captures ->
           begin match expect_text parser "(" with
           | Error error -> Error error
           | Ok _ ->
              begin match parse_parameter_list parser with
              | Error error -> Error error
              | Ok parameters ->
                 begin match expect_text parser ":" with
                 | Error error -> Error error
                 | Ok _ ->
                    begin match parse_type_ref parser with
                    | Error error -> Error error
                    | Ok return_type ->
                    if is_text parser "=>" then begin
                      ignore (advance parser);
                      match parse_expression parser with
                      | Error error -> Error error
                      | Ok body ->
                         Ok (expression_with_span
                               (ClosureExpression
                                  (captures, parameters, return_type,
                                   ExpressionClosureBody body))
                               (span_from_spans (token_span start_token) body.expression_span))
                    end else
                      begin match expect_text parser "is" with
                      | Error error -> Error error
                      | Ok _ ->
                         begin match parse_block_until parser ["qed"] with
                         | Error error -> Error error
                         | Ok body ->
                            begin match expect_text parser "qed" with
                            | Error error -> Error error
                            | Ok end_token ->
                               Ok (expression_with_span
                                     (ClosureExpression
                                        (captures, parameters, return_type,
                                         BlockClosureBody body))
                                     (expression_span start_token end_token))
                            end
                         end
                      end
                    end
                 end
              end
           end
        end
     end

and parse_closure_captures parser =
  if is_text parser "]" then begin
    ignore (advance parser);
    Ok []
  end else
    let rec loop acc =
      let mode =
        if is_text parser "&!" then begin
          ignore (advance parser);
          WriteBorrowCapture
        end else if is_text parser "&" then begin
          ignore (advance parser);
          ReadBorrowCapture
        end else
          ByValueCapture
      in
      match expect_identifier parser with
      | Error error -> Error error
      | Ok name_token ->
         let capture = {
           closure_capture_name = token_text name_token;
           closure_capture_mode = mode;
         } in
         if is_text parser "," then begin
           ignore (advance parser);
           if is_text parser "]" then begin
             ignore (advance parser);
             Ok (List.rev (capture :: acc))
           end else
             loop (capture :: acc)
         end else
           begin match expect_text parser "]" with
           | Error error -> Error error
           | Ok _ -> Ok (List.rev (capture :: acc))
           end
    in
    loop []

and parse_named_field_construction parser start_token constructor_type =
  match expect_text parser "{" with
  | Error error -> Error error
  | Ok _ ->
     if is_text parser "}" then
       begin match expect_text parser "}" with
       | Error error -> Error error
       | Ok end_token ->
          Ok (expression_with_span
                (NamedFieldConstructionExpression (constructor_type, [], None))
                (expression_span start_token end_token))
       end
     else
       parse_construction_fields parser start_token constructor_type []

and parse_construction_fields parser start_token constructor_type acc =
  match expect_identifier parser with
  | Error error -> Error error
  | Ok name_token ->
     let value_result =
       if is_text parser ":" then begin
         ignore (advance parser);
         match parse_expression parser with
         | Error error -> Error error
         | Ok value -> Ok (Some value)
       end else
         Ok None
     in
     begin match value_result with
     | Error error -> Error error
     | Ok construction_field_value ->
        let field = {
          construction_field_name = token_text name_token;
          construction_field_value;
        } in
        if is_text parser "," then begin
          ignore (advance parser);
          if is_text parser "with" then begin
            ignore (advance parser);
            match parse_expression parser with
            | Error error -> Error error
            | Ok update_source ->
               if is_text parser "," then ignore (advance parser);
               begin match expect_text parser "}" with
               | Error error -> Error error
               | Ok end_token ->
                  Ok (expression_with_span
                        (NamedFieldConstructionExpression
                           (constructor_type, List.rev (field :: acc), Some update_source))
                        (expression_span start_token end_token))
               end
          end else if is_text parser "}" then begin
            match expect_text parser "}" with
            | Error error -> Error error
            | Ok end_token ->
               Ok (expression_with_span
                     (NamedFieldConstructionExpression
                        (constructor_type, List.rev (field :: acc), None))
                     (expression_span start_token end_token))
          end else
            parse_construction_fields parser start_token constructor_type (field :: acc)
        end else
          begin match expect_text parser "}" with
          | Error error -> Error error
          | Ok end_token ->
             Ok (expression_with_span
                   (NamedFieldConstructionExpression
                      (constructor_type, List.rev (field :: acc), None))
                   (expression_span start_token end_token))
          end
     end

and parse_parenthesized_expression parser =
  match expect_text parser "(" with
  | Error error -> Error error
  | Ok start ->
     begin match parse_expression parser with
     | Error error -> Error error
     | Ok inner ->
        begin match expect_text parser ")" with
        | Error error -> Error error
        | Ok end_token ->
           Ok (expression_with_span
                 (ParenthesizedExpression inner)
                 (expression_span start end_token))
        end
     end

and parse_array_expression parser =
  match expect_text parser "[" with
  | Error error -> Error error
  | Ok start ->
     if is_text parser "]" then begin
       match expect_text parser "]" with
       | Error error -> Error error
       | Ok end_token ->
          Ok (expression_with_span (ArrayExpression []) (expression_span start end_token))
     end else
       let rec loop acc =
         match parse_expression parser with
         | Error error -> Error error
         | Ok item ->
            if is_text parser "," then begin
              ignore (advance parser);
              if is_text parser "]" then
                match expect_text parser "]" with
                | Error error -> Error error
                | Ok end_token ->
                   Ok (expression_with_span
                         (ArrayExpression (List.rev (item :: acc)))
                         (expression_span start end_token))
              else
                loop (item :: acc)
            end else
              match expect_text parser "]" with
              | Error error -> Error error
              | Ok end_token ->
                 Ok (expression_with_span
                       (ArrayExpression (List.rev (item :: acc)))
                       (expression_span start end_token))
       in
       loop []

and parse_static_assert_expression parser =
  match expect_text parser "static_assert" with
  | Error error -> Error error
  | Ok start ->
     begin match expect_text parser "(" with
     | Error error -> Error error
     | Ok _ ->
        begin match parse_expression parser with
        | Error error -> Error error
        | Ok condition ->
           begin match expect_text parser "," with
           | Error error -> Error error
           | Ok _ ->
              begin match expect_static_string_literal parser with
              | Error error -> Error error
              | Ok message ->
                 begin match expect_text parser ")" with
                 | Error error -> Error error
                 | Ok end_token ->
                    Ok (expression_with_span
                          (StaticAssertExpression (condition, token_text message))
                          (expression_span start end_token))
                 end
              end
           end
        end
     end

and parse_build_expression parser =
  match expect_text parser "build" with
  | Error error -> Error error
  | Ok start_token ->
     begin match parse_type_ref parser with
     | Error error -> Error error
     | Ok result_type ->
        begin match expect_text parser "do" with
        | Error error -> Error error
        | Ok _ ->
           begin match parse_block_until parser ["build"] with
           | Error error -> Error error
           | Ok body ->
              begin match expect_text parser "build" with
              | Error error -> Error error
              | Ok end_token ->
                 Ok (expression_with_span
                       (BuildExpression (result_type, body))
                       (expression_span start_token end_token))
              end
           end
        end
     end

and parse_argument_list parser =
  if is_text parser ")" then begin
    match expect_text parser ")" with
    | Error error -> Error error
    | Ok end_token -> Ok ([], end_token)
  end else
    let rec loop acc =
      match parse_expression parser with
      | Error error -> Error error
      | Ok argument ->
         if is_text parser "," then begin
           ignore (advance parser);
           if is_text parser ")" then begin
             match expect_text parser ")" with
             | Error error -> Error error
             | Ok end_token -> Ok (List.rev (argument :: acc), end_token)
           end else
             loop (argument :: acc)
         end else
           match expect_text parser ")" with
           | Error error -> Error error
           | Ok end_token -> Ok (List.rev (argument :: acc), end_token)
    in
    loop []

and parse_postfix_expression parser base =
  if is_text parser "(" then begin
    ignore (advance parser);
    match parse_argument_list parser with
    | Error error -> Error error
    | Ok (arguments, end_token) ->
       let call = expression_with_span
           (CallExpression (base, arguments))
           (span_from_spans base.expression_span (token_span end_token))
       in
       parse_postfix_expression parser call
  end else if is_text parser "." then begin
    ignore (advance parser);
    match expect_identifier_or_keyword parser with
    | Error error -> Error error
    | Ok field ->
       let access = expression_with_span
           (FieldAccessExpression (base, token_text field))
           (span_from_spans base.expression_span (token_span field))
       in
       parse_postfix_expression parser access
  end else if is_text parser "[" then begin
    ignore (advance parser);
    if is_text parser ".." then begin
      ignore (advance parser);
      parse_slice_tail parser base None
    end else
      match parse_expression parser with
      | Error error -> Error error
      | Ok lower ->
         if is_text parser ".." then begin
           ignore (advance parser);
           parse_slice_tail parser base (Some lower)
         end else
           begin match expect_text parser "]" with
           | Error error -> Error error
           | Ok end_token ->
              let indexed = expression_with_span
                  (IndexExpression (base, lower))
                  (span_from_spans base.expression_span (token_span end_token))
              in
              parse_postfix_expression parser indexed
           end
  end else
    Ok base

and parse_slice_tail parser base lower =
  let upper_result =
    if is_text parser "]" then Ok None
    else
      match parse_expression parser with
      | Error error -> Error error
      | Ok upper -> Ok (Some upper)
  in
  match upper_result with
  | Error error -> Error error
  | Ok upper ->
     begin match expect_text parser "]" with
     | Error error -> Error error
     | Ok end_token ->
        let slice = expression_with_span
            (SliceExpression (base, lower, upper))
            (span_from_spans base.expression_span (token_span end_token))
        in
        parse_postfix_expression parser slice
     end

and statement_with_span statement_kind statement_span =
  { statement_kind; statement_span }

and pattern_with_span pattern_kind pattern_span =
  { pattern_kind; pattern_span }

and is_pattern_name token =
  match (token: KyokaiLexicalToken.token).kind with
  | Identifier -> true
  | Keyword -> List.mem (token_text token) ["None"; "Ok"; "Err"; "Some"]
  | _ -> false

and parse_pattern parser =
  match current parser with
  | None -> eof_error (ExpectedToken "pattern")
  | Some token when token_text token = "ignore" ->
     ignore (advance parser);
     Ok (pattern_with_span IgnorePattern (token_span token))
  | Some token when token_text token = "{" -> parse_record_pattern parser
  | Some token when is_pattern_name token -> parse_named_pattern parser
  | Some token -> error ~token (ExpectedToken "pattern")

and parse_named_pattern parser =
  match current parser with
  | None -> eof_error ExpectedIdentifier
  | Some start_token ->
     let rec parse_path acc =
       match current parser with
       | Some component when is_pattern_name component ->
          ignore (advance parser);
          let path = token_text component :: acc in
          if is_text parser "." then begin
            ignore (advance parser);
            parse_path path
          end else
            Ok (List.rev path, component)
       | Some component -> error ~token:component ExpectedIdentifier
       | None -> eof_error ExpectedIdentifier
     in
     begin match parse_path [] with
     | Error error -> Error error
     | Ok (name, last_token) ->
        if is_text parser "(" then begin
          ignore (advance parser);
          match parse_pattern parser with
          | Error error -> Error error
          | Ok payload ->
             begin match expect_text parser ")" with
             | Error error -> Error error
             | Ok end_token ->
                Ok (pattern_with_span
                      (ConstructorPattern (name, UnnamedPatternPayload payload))
                      (expression_span start_token end_token))
             end
        end else if is_text parser "{" then
          begin match parse_named_pattern_fields parser with
          | Error error -> Error error
          | Ok (fields, end_token) ->
             Ok (pattern_with_span
                   (ConstructorPattern (name, NamedPatternPayload fields))
                   (expression_span start_token end_token))
          end
        else
          let pattern_kind =
            if name = ["None"] then ConstructorPattern (name, NoPatternPayload)
            else NamePattern name
          in
          Ok (pattern_with_span pattern_kind (expression_span start_token last_token))
     end

and parse_record_pattern parser =
  match current parser with
  | None -> eof_error (ExpectedToken "{")
  | Some start_token ->
     begin match parse_named_pattern_fields parser with
     | Error error -> Error error
     | Ok (fields, end_token) ->
        Ok (pattern_with_span (RecordPattern fields) (expression_span start_token end_token))
     end

and parse_named_pattern_fields parser =
  match expect_text parser "{" with
  | Error error -> Error error
  | Ok _ ->
     if is_text parser "}" then
       match expect_text parser "}" with
       | Error error -> Error error
       | Ok end_token -> Ok ([], end_token)
     else
       let rec loop acc =
         match expect_identifier parser with
         | Error error -> Error error
         | Ok name_token ->
            let nested_result =
              if is_text parser ":" then begin
                ignore (advance parser);
                match parse_pattern parser with
                | Error error -> Error error
                | Ok nested -> Ok (Some nested)
              end else
                Ok None
            in
            begin match nested_result with
            | Error error -> Error error
            | Ok pattern_field_pattern ->
               let field = {
                 pattern_field_name = token_text name_token;
                 pattern_field_pattern;
               } in
               if is_text parser "," then begin
                 ignore (advance parser);
                 if is_text parser "}" then
                   match expect_text parser "}" with
                   | Error error -> Error error
                   | Ok end_token -> Ok (List.rev (field :: acc), end_token)
                 else
                   loop (field :: acc)
               end else
                 match expect_text parser "}" with
                 | Error error -> Error error
                 | Ok end_token -> Ok (List.rev (field :: acc), end_token)
            end
       in
       loop []

and parse_block_until parser stop_tokens =
  let rec loop acc =
    match current parser with
    | None -> eof_error (ExpectedToken (String.concat " or " stop_tokens))
    | Some token when List.mem (token_text token) stop_tokens -> Ok (List.rev acc)
    | Some _ ->
       begin match parse_statement parser with
       | Error error -> Error error
       | Ok statement -> loop (statement :: acc)
       end
  in
  loop []

and parse_statement parser =
  match current parser with
  | None -> eof_error (ExpectedToken "statement")
  | Some token ->
     begin match token_text token with
     | "let" -> parse_let_statement parser
     | "var" -> parse_var_statement parser
     | "return" -> parse_optional_expression_statement parser "return" (fun value -> ReturnStatement value)
     | "break" -> parse_loop_exit_statement parser "break" (fun label -> BreakStatement label)
     | "continue" -> parse_loop_exit_statement parser "continue" (fun label -> ContinueStatement label)
     | "panic" -> parse_required_expression_statement parser "panic" (fun value -> PanicStatement value)
     | "debug" -> parse_required_expression_statement parser "debug" (fun value -> DebugStatement value)
     | "yield" -> parse_required_expression_statement parser "yield" (fun value -> YieldStatement value)
     | "produce" -> parse_required_expression_statement parser "produce" (fun value -> ProduceStatement value)
     | "todo" -> parse_todo_statement parser
     | "unreachable" -> parse_marker_statement parser "unreachable" UnreachableStatement
     | "defer" -> parse_deferred_statement parser "defer" (fun statement -> DeferStatement statement)
     | "errdefer" -> parse_deferred_statement parser "errdefer" (fun statement -> ErrdeferStatement statement)
     | "if" -> parse_if_statement parser
     | "case" -> parse_case_statement parser
     | "while" -> parse_while_statement parser
     | "for" -> parse_for_statement parser
     | "borrow" -> parse_borrow_statement parser
     | "taskgroup" -> parse_taskgroup_statement parser
     | "spawn" -> parse_spawn_statement parser
     | "select" -> parse_select_statement parser
     | "wait" -> parse_wait_statement parser
     | _ -> parse_expression_statement parser
     end

and parse_let_statement parser =
  match expect_text parser "let" with
  | Error error -> Error error
  | Ok start_token ->
     begin match parse_pattern parser with
     | Error error -> Error error
     | Ok binding_pattern ->
        let type_result =
          if is_text parser ":" then begin
            ignore (advance parser);
            match parse_type_ref parser with
            | Error error -> Error error
            | Ok type_ref -> Ok (Some type_ref)
          end else
            Ok None
        in
        begin match type_result with
        | Error error -> Error error
        | Ok annotated_type ->
           begin match expect_text parser ":=" with
           | Error error -> Error error
           | Ok _ ->
              begin match parse_expression parser with
              | Error error -> Error error
              | Ok initial_value ->
                 if is_text parser "else" then begin
                   ignore (advance parser);
                   match parse_pattern parser with
                   | Error error -> Error error
                   | Ok fallback_pattern ->
                      begin match expect_text parser "do" with
                      | Error error -> Error error
                      | Ok _ ->
                         begin match parse_block_until parser ["fi"] with
                         | Error error -> Error error
                         | Ok fallback_body ->
                            begin match expect_text parser "fi" with
                            | Error error -> Error error
                            | Ok _ ->
                               begin match expect_semicolon parser with
                               | Error error -> Error error
                               | Ok end_token ->
                                  Ok (statement_with_span
                                        (LetElseStatement
                                           (binding_pattern, annotated_type, initial_value,
                                            fallback_pattern, fallback_body))
                                        (expression_span start_token end_token))
                               end
                            end
                         end
                      end
                 end else
                   begin match parse_optional_or_clause parser with
                   | Error error -> Error error
                   | Ok or_clause ->
                      begin match expect_semicolon parser with
                      | Error error -> Error error
                      | Ok end_token ->
                         Ok (statement_with_span
                               (LetStatement
                                  (binding_pattern, annotated_type, initial_value, or_clause))
                               (expression_span start_token end_token))
                      end
                   end
              end
           end
        end
     end

and parse_optional_or_clause parser =
  if not (is_text parser "or") then
    Ok None
  else begin
    ignore (advance parser);
    if is_text parser "return" then begin
      ignore (advance parser);
      if is_text parser ";" then
        Ok (Some (OrReturn None))
      else
        match expect_identifier parser with
        | Error error -> Error error
        | Ok name ->
           begin match expect_text parser "=>" with
           | Error error -> Error error
           | Ok _ ->
              begin match parse_expression parser with
              | Error error -> Error error
              | Ok mapping -> Ok (Some (OrReturn (Some (token_text name, mapping))))
              end
           end
    end else if is_text parser "break" then begin
      ignore (advance parser);
      match parse_optional_loop_label parser with
      | Error error -> Error error
      | Ok label -> Ok (Some (OrBreak label))
    end else if is_text parser "continue" then begin
      ignore (advance parser);
      match parse_optional_loop_label parser with
      | Error error -> Error error
      | Ok label -> Ok (Some (OrContinue label))
    end else
      match current parser with
      | Some token -> error ~token (ExpectedToken "return, break, or continue")
      | None -> eof_error (ExpectedToken "return, break, or continue")
  end

and parse_optional_loop_label parser =
  if is_text parser ";" then
    Ok None
  else
    match expect_identifier parser with
    | Error error -> Error error
    | Ok label -> Ok (Some (token_text label))

and parse_borrow_statement parser =
  match expect_text parser "borrow" with
  | Error error -> Error error
  | Ok start_token ->
     begin match expect_identifier parser with
     | Error error -> Error error
     | Ok name ->
        begin match expect_text parser ":=" with
        | Error error -> Error error
        | Ok _ ->
           begin match parse_expression parser with
           | Error error -> Error error
           | Ok borrowed_place ->
              begin match expect_text parser "do" with
              | Error error -> Error error
              | Ok _ ->
                 begin match parse_block_until parser ["drop"] with
                 | Error error -> Error error
                 | Ok body ->
                    begin match expect_text parser "drop" with
                    | Error error -> Error error
                    | Ok _ ->
                       begin match expect_semicolon parser with
                       | Error error -> Error error
                       | Ok end_token ->
                          Ok (statement_with_span
                                (BorrowStatement (token_text name, borrowed_place, body))
                                (expression_span start_token end_token))
                       end
                    end
                 end
              end
           end
        end
     end

and parse_taskgroup_statement parser =
  match expect_text parser "taskgroup" with
  | Error error -> Error error
  | Ok start_token ->
     begin match expect_text parser "do" with
     | Error error -> Error error
     | Ok _ ->
        begin match parse_block_until parser ["join"] with
        | Error error -> Error error
        | Ok body ->
           begin match expect_text parser "join" with
           | Error error -> Error error
           | Ok _ ->
              begin match expect_semicolon parser with
              | Error error -> Error error
              | Ok end_token ->
                 Ok (statement_with_span
                       (TaskgroupStatement body)
                       (expression_span start_token end_token))
              end
           end
        end
     end

and parse_spawn_statement parser =
  match expect_text parser "spawn" with
  | Error error -> Error error
  | Ok start_token ->
     begin match expect_text parser "[" with
     | Error error -> Error error
     | Ok _ ->
        begin match parse_closure_captures parser with
        | Error error -> Error error
        | Ok captures ->
           begin match expect_text parser "do" with
           | Error error -> Error error
           | Ok _ ->
              begin match parse_block_until parser ["od"] with
              | Error error -> Error error
              | Ok body ->
                 begin match expect_text parser "od" with
                 | Error error -> Error error
                 | Ok _ ->
                    if is_text parser "else" then begin
                      ignore (advance parser);
                      match expect_identifier parser with
                      | Error error -> Error error
                      | Ok failure_name ->
                         begin match expect_text parser "do" with
                         | Error error -> Error error
                         | Ok _ ->
                            begin match parse_block_until parser ["fi"] with
                            | Error error -> Error error
                            | Ok failure_body ->
                               begin match expect_text parser "fi" with
                               | Error error -> Error error
                               | Ok _ ->
                                  begin match expect_semicolon parser with
                                  | Error error -> Error error
                                  | Ok end_token ->
                                     Ok (statement_with_span
                                           (SpawnStatement
                                              (captures, body,
                                               Some (token_text failure_name, failure_body)))
                                           (expression_span start_token end_token))
                                  end
                               end
                            end
                         end
                    end else
                      begin match expect_semicolon parser with
                      | Error error -> Error error
                      | Ok end_token ->
                         Ok (statement_with_span
                               (SpawnStatement (captures, body, None))
                               (expression_span start_token end_token))
                      end
                 end
              end
           end
        end
     end

and parse_select_statement parser =
  match expect_text parser "select" with
  | Error error -> Error error
  | Ok start_token ->
     let rec parse_arms arms timeout =
       if is_text parser "when" then begin
         ignore (advance parser);
         match parse_expression parser with
         | Error error -> Error error
         | Ok operation ->
            begin match expect_text parser "do" with
            | Error error -> Error error
            | Ok _ ->
               begin match parse_block_until parser ["when"; "timeout"; "pick"] with
               | Error error -> Error error
               | Ok body -> parse_arms ((operation, body) :: arms) timeout
               end
            end
       end else if is_text parser "timeout" then begin
         ignore (advance parser);
         match expect_text parser "(" with
         | Error error -> Error error
         | Ok _ ->
            begin match parse_expression parser with
            | Error error -> Error error
            | Ok deadline ->
               begin match expect_text parser ")" with
               | Error error -> Error error
               | Ok _ ->
                  begin match expect_text parser "do" with
                  | Error error -> Error error
                  | Ok _ ->
                     begin match parse_block_until parser ["pick"] with
                     | Error error -> Error error
                     | Ok body -> parse_arms arms (Some (deadline, body))
                     end
                  end
               end
            end
       end else
         begin match expect_text parser "pick" with
         | Error error -> Error error
         | Ok _ ->
            begin match expect_semicolon parser with
            | Error error -> Error error
            | Ok end_token ->
               Ok (statement_with_span
                     (SelectStatement (List.rev arms, timeout))
                     (expression_span start_token end_token))
            end
         end
     in
     parse_arms [] None

and parse_wait_statement parser =
  match expect_text parser "wait" with
  | Error error -> Error error
  | Ok start_token ->
     let rec parse_arms arms default_body =
       if is_text parser "when" then begin
         ignore (advance parser);
         match parse_expression parser with
         | Error error -> Error error
         | Ok token ->
            begin match expect_text parser "do" with
            | Error error -> Error error
            | Ok _ ->
               begin match parse_block_until parser ["when"; "default"; "wake"] with
               | Error error -> Error error
               | Ok body -> parse_arms ((token, body) :: arms) default_body
               end
            end
       end else if is_text parser "default" then begin
         ignore (advance parser);
         match expect_text parser "do" with
         | Error error -> Error error
         | Ok _ ->
            begin match parse_block_until parser ["wake"] with
            | Error error -> Error error
            | Ok body -> parse_arms arms (Some body)
            end
       end else
         begin match expect_text parser "wake" with
         | Error error -> Error error
         | Ok _ ->
            begin match expect_semicolon parser with
            | Error error -> Error error
            | Ok end_token ->
               Ok (statement_with_span
                     (WaitStatement (List.rev arms, default_body))
                     (expression_span start_token end_token))
            end
         end
     in
     parse_arms [] None

and parse_var_statement parser =
  match expect_text parser "var" with
  | Error error -> Error error
  | Ok start_token ->
     begin match expect_identifier parser with
     | Error error -> Error error
     | Ok name_token ->
        begin match expect_text parser ":" with
        | Error error -> Error error
        | Ok _ ->
           begin match parse_type_ref parser with
           | Error error -> Error error
           | Ok variable_type ->
              let initial_value_result =
                if is_text parser ":=" then begin
                  ignore (advance parser);
                  match parse_expression parser with
                  | Error error -> Error error
                  | Ok initial_value -> Ok (Some initial_value)
                end else
                  Ok None
              in
              begin match initial_value_result with
              | Error error -> Error error
              | Ok initial_value ->
                 begin match expect_semicolon parser with
                 | Error error -> Error error
                 | Ok end_token ->
                    Ok (statement_with_span
                          (VarStatement (token_text name_token, variable_type, initial_value))
                          (expression_span start_token end_token))
                 end
              end
           end
        end
     end

and parse_optional_expression_statement parser keyword make_kind =
  match expect_text parser keyword with
  | Error error -> Error error
  | Ok start_token ->
     if is_text parser ";" then begin
       match expect_semicolon parser with
       | Error error -> Error error
       | Ok end_token ->
          Ok (statement_with_span (make_kind None) (expression_span start_token end_token))
     end else
       begin match parse_expression parser with
       | Error error -> Error error
       | Ok value ->
          begin match expect_semicolon parser with
          | Error error -> Error error
          | Ok end_token ->
             Ok (statement_with_span
                   (make_kind (Some value))
                   (expression_span start_token end_token))
          end
       end

and parse_loop_exit_statement parser keyword make_kind =
  match expect_text parser keyword with
  | Error error -> Error error
  | Ok start_token ->
     let label_result =
       if is_text parser ";" then Ok None
       else
         match expect_identifier parser with
         | Error error -> Error error
         | Ok label -> Ok (Some (token_text label))
     in
     begin match label_result with
     | Error error -> Error error
     | Ok label ->
        begin match expect_semicolon parser with
        | Error error -> Error error
        | Ok end_token ->
           Ok (statement_with_span (make_kind label) (expression_span start_token end_token))
        end
     end

and parse_required_expression_statement parser keyword make_kind =
  match expect_text parser keyword with
  | Error error -> Error error
  | Ok start_token ->
     begin match parse_expression parser with
     | Error error -> Error error
     | Ok value ->
        begin match expect_semicolon parser with
        | Error error -> Error error
        | Ok end_token ->
           Ok (statement_with_span (make_kind value) (expression_span start_token end_token))
        end
     end

and parse_todo_statement parser =
  match expect_text parser "todo" with
  | Error error -> Error error
  | Ok start_token ->
     let message_result =
       if is_text parser ";" then Ok None
       else
         match expect_static_string_literal parser with
         | Error error -> Error error
         | Ok message -> Ok (Some (token_text message))
     in
     begin match message_result with
     | Error error -> Error error
     | Ok message ->
        begin match expect_semicolon parser with
        | Error error -> Error error
        | Ok end_token ->
           Ok (statement_with_span (TodoStatement message) (expression_span start_token end_token))
        end
     end

and parse_marker_statement parser keyword statement_kind =
  match expect_text parser keyword with
  | Error error -> Error error
  | Ok start_token ->
     begin match expect_semicolon parser with
     | Error error -> Error error
     | Ok end_token ->
        Ok (statement_with_span statement_kind (expression_span start_token end_token))
     end

and parse_deferred_statement parser keyword make_kind =
  match expect_text parser keyword with
  | Error error -> Error error
  | Ok start_token ->
     begin match parse_statement parser with
     | Error error -> Error error
     | Ok deferred ->
        Ok (statement_with_span
              (make_kind deferred)
              (span_from_spans (token_span start_token) deferred.statement_span))
     end

and parse_if_statement parser =
  match expect_text parser "if" with
  | Error error -> Error error
  | Ok start_token ->
     let rec parse_branch acc =
       match parse_expression parser with
       | Error error -> Error error
       | Ok condition ->
          begin match expect_text parser "then" with
          | Error error -> Error error
          | Ok _ ->
             begin match parse_block_until parser ["else"; "fi"] with
             | Error error -> Error error
             | Ok body ->
                let branches = (condition, body) :: acc in
                if is_text parser "else" then begin
                  ignore (advance parser);
                  if is_text parser "if" then begin
                    ignore (advance parser);
                    parse_branch branches
                  end else
                    begin match parse_block_until parser ["fi"] with
                    | Error error -> Error error
                    | Ok else_body -> finish_if branches (Some else_body)
                    end
                end else
                  finish_if branches None
             end
          end
     and finish_if reversed_branches else_body =
       match expect_text parser "fi" with
       | Error error -> Error error
       | Ok _ ->
          begin match expect_semicolon parser with
          | Error error -> Error error
          | Ok end_token ->
             Ok (statement_with_span
                   (IfStatement (List.rev reversed_branches, else_body))
                   (expression_span start_token end_token))
          end
     in
     parse_branch []

and parse_while_statement parser =
  match expect_text parser "while" with
  | Error error -> Error error
  | Ok start_token ->
     if is_text parser "let" then begin
       ignore (advance parser);
       match parse_pattern parser with
       | Error error -> Error error
       | Ok binding_pattern ->
          begin match expect_text parser ":=" with
          | Error error -> Error error
          | Ok _ ->
             begin match parse_expression parser with
             | Error error -> Error error
             | Ok value ->
                begin match expect_text parser "do" with
                | Error error -> Error error
                | Ok _ ->
                   begin match parse_block_until parser ["od"] with
                   | Error error -> Error error
                   | Ok body ->
                      begin match expect_text parser "od" with
                      | Error error -> Error error
                      | Ok _ ->
                         begin match expect_semicolon parser with
                         | Error error -> Error error
                         | Ok end_token ->
                            Ok (statement_with_span
                                  (WhileLetStatement (binding_pattern, value, body))
                                  (expression_span start_token end_token))
                         end
                      end
                   end
                end
             end
          end
     end else
       begin match parse_expression parser with
       | Error error -> Error error
       | Ok condition ->
          begin match expect_text parser "do" with
          | Error error -> Error error
          | Ok _ ->
             begin match parse_block_until parser ["od"] with
             | Error error -> Error error
             | Ok body ->
                begin match expect_text parser "od" with
                | Error error -> Error error
                | Ok _ ->
                   begin match expect_semicolon parser with
                   | Error error -> Error error
                   | Ok end_token ->
                      Ok (statement_with_span
                            (WhileStatement (condition, body))
                            (expression_span start_token end_token))
                   end
                end
             end
          end
       end

and parse_case_statement parser =
  match expect_text parser "case" with
  | Error error -> Error error
  | Ok start_token ->
     begin match parse_expression parser with
     | Error error -> Error error
     | Ok scrutinee ->
        begin match expect_text parser "of" with
        | Error error -> Error error
        | Ok _ ->
           let rec parse_arms acc =
             if is_text parser "esac" then begin
               ignore (advance parser);
               match expect_semicolon parser with
               | Error error -> Error error
               | Ok end_token ->
                  Ok (statement_with_span
                        (CaseStatement (scrutinee, List.rev acc))
                        (expression_span start_token end_token))
             end else
               begin match expect_text parser "when" with
               | Error error -> Error error
               | Ok _ ->
                  begin match parse_pattern parser with
                  | Error error -> Error error
                  | Ok arm_pattern ->
                     begin match expect_text parser "do" with
                     | Error error -> Error error
                     | Ok _ ->
                        begin match parse_block_until parser ["when"; "esac"] with
                        | Error error -> Error error
                        | Ok body -> parse_arms ((arm_pattern, body) :: acc)
                        end
                     end
                  end
               end
           in
           parse_arms []
        end
     end

and parse_for_statement parser =
  match expect_text parser "for" with
  | Error error -> Error error
  | Ok start_token ->
     let start_index = parser.index in
     begin match current parser with
     | Some token when is_identifier_token token ->
        ignore (advance parser);
        if is_text parser "from" then begin
          let loop_name = token_text token in
          ignore (advance parser);
          match parse_expression parser with
          | Error error -> Error error
          | Ok range_start ->
             let inclusive_result =
               if is_text parser "to" then begin ignore (advance parser); Ok true end
               else if is_text parser "below" then begin ignore (advance parser); Ok false end
               else
                 match current parser with
                 | Some current_token -> error ~token:current_token (ExpectedToken "to or below")
                 | None -> eof_error (ExpectedToken "to or below")
             in
             begin match inclusive_result with
             | Error error -> Error error
             | Ok inclusive ->
                begin match parse_expression parser with
                | Error error -> Error error
                | Ok range_end ->
                   begin match expect_text parser "do" with
                   | Error error -> Error error
                   | Ok _ ->
                      begin match parse_block_until parser ["od"] with
                      | Error error -> Error error
                      | Ok body ->
                         begin match expect_text parser "od" with
                         | Error error -> Error error
                         | Ok _ ->
                            begin match expect_semicolon parser with
                            | Error error -> Error error
                            | Ok end_token ->
                               Ok (statement_with_span
                                     (ForRangeStatement
                                        (loop_name, range_start, inclusive, range_end, body))
                                     (expression_span start_token end_token))
                            end
                         end
                      end
                   end
                end
             end
        end else begin
          parser.index <- start_index;
          parse_for_in_statement parser start_token
        end
     | Some _ -> parse_for_in_statement parser start_token
     | None -> eof_error (ExpectedToken "for binding")
     end

and parse_for_in_statement parser start_token =
  match parse_pattern parser with
  | Error error -> Error error
  | Ok binding_pattern ->
     begin match expect_text parser "in" with
     | Error error -> Error error
     | Ok _ ->
        begin match parse_expression parser with
        | Error error -> Error error
        | Ok iterable ->
           begin match expect_text parser "do" with
           | Error error -> Error error
           | Ok _ ->
              begin match parse_block_until parser ["od"] with
              | Error error -> Error error
              | Ok body ->
                 begin match expect_text parser "od" with
                 | Error error -> Error error
                 | Ok _ ->
                    begin match expect_semicolon parser with
                    | Error error -> Error error
                    | Ok end_token ->
                       Ok (statement_with_span
                             (ForInStatement (binding_pattern, iterable, body))
                             (expression_span start_token end_token))
                    end
                 end
              end
           end
        end
     end

and parse_expression_statement parser =
  match parse_expression parser with
  | Error error -> Error error
  | Ok expression ->
     if is_text parser ":=" then begin
       ignore (advance parser);
       match parse_expression parser with
       | Error error -> Error error
       | Ok value ->
          begin match expect_semicolon parser with
          | Error error -> Error error
          | Ok end_token ->
             Ok (statement_with_span
                   (AssignmentStatement (expression, value))
                   (span_from_spans expression.expression_span (token_span end_token)))
          end
     end else
       begin match expect_semicolon parser with
       | Error error -> Error error
       | Ok end_token ->
          Ok (statement_with_span
                (ExpressionStatement expression)
                (span_from_spans expression.expression_span (token_span end_token)))
       end

let parse_optional_declaration_guard parser stop_text =
  if not (is_text parser "when") then
    Ok None
  else begin
    ignore (advance parser);
    if is_text parser stop_text then
      match current parser with
      | Some token -> error ~token (ExpectedToken "declaration guard expression")
      | None -> eof_error (ExpectedToken "declaration guard expression")
    else
      match parse_expression parser with
      | Error error -> Error error
      | Ok expression ->
         if is_text parser stop_text then Ok (Some expression)
         else
           match current parser with
           | Some token -> error ~token (ExpectedToken stop_text)
           | None -> eof_error (ExpectedToken stop_text)
  end

let parse_contract_clause parser =
  match current parser with
  | Some token when token_text token = "require" || token_text token = "ensure" ->
     let is_require = token_text token = "require" in
     ignore (advance parser);
     begin match parse_expression parser with
     | Error error -> Error error
     | Ok expression ->
        begin match expect_semicolon parser with
        | Error error -> Error error
        | Ok _ -> Ok (if is_require then RequireContract expression else EnsureContract expression)
        end
     end
  | Some token -> error ~token (ExpectedToken "require or ensure")
  | None -> eof_error (ExpectedToken "require or ensure")

let parse_contract_clauses parser =
  let rec loop acc =
    if is_text parser "require" || is_text parser "ensure" then
      match parse_contract_clause parser with
      | Error error -> Error error
      | Ok clause -> loop (clause :: acc)
    else
      Ok (List.rev acc)
  in
  loop []

let parse_function_signature parser =
  match parse_optional_generic_parameters parser with
  | Error error -> Error error
  | Ok function_generic_parameters ->
     begin match expect_text parser "(" with
     | Error error -> Error error
     | Ok _ ->
        begin match parse_parameter_list parser with
        | Error error -> Error error
        | Ok function_parameters ->
           begin match expect_text parser ":" with
           | Error error -> Error error
           | Ok _ ->
              begin match parse_type_ref parser with
              | Error error -> Error error
              | Ok function_return_type ->
                 begin match parse_optional_where_clause parser with
                 | Error error -> Error error
                 | Ok function_where_obligations ->
                    begin match parse_contract_clauses parser with
                    | Error error -> Error error
                    | Ok function_contracts ->
                       Ok {
                         function_generic_parameters;
                         function_parameters;
                         function_return_type;
                         function_where_obligations;
                         function_contracts;
                       }
                    end
                 end
              end
           end
        end
     end

let parse_constant_summary parser =
  match expect_text parser ":" with
  | Error error -> Error error
  | Ok _ ->
     begin match parse_type_ref parser with
     | Error error -> Error error
     | Ok constant_type ->
        begin match expect_text parser ":=" with
        | Error error -> Error error
        | Ok _ ->
           begin match parse_expression parser with
           | Error error -> Error error
           | Ok constant_initializer -> Ok { constant_type; constant_initializer }
           end
        end
     end

let parse_type_alias_summary parser =
  match parse_optional_generic_parameters parser with
  | Error error -> Error error
  | Ok type_alias_generic_parameters ->
     begin match expect_text parser ":=" with
     | Error error -> Error error
     | Ok _ ->
        begin match parse_type_ref parser with
        | Error error -> Error error
        | Ok type_alias_target -> Ok { type_alias_generic_parameters; type_alias_target }
        end
     end

let parse_optional_universe parser =
  if not (is_text parser ":") then
    Ok None
  else begin
    ignore (advance parser);
    match expect_identifier parser with
    | Error error -> Error error
    | Ok token -> Ok (Some (token_text token))
  end

let parse_record_field parser =
  match expect_identifier parser with
  | Error error -> Error error
  | Ok name ->
     begin match expect_text parser ":" with
     | Error error -> Error error
     | Ok _ ->
        begin match parse_type_ref parser with
        | Error error -> Error error
        | Ok record_field_type ->
           begin match expect_semicolon parser with
           | Error error -> Error error
           | Ok _ -> Ok { record_field_name = token_text name; record_field_type }
           end
        end
     end

let parse_record_block_fields parser =
  let rec loop acc =
    match current parser with
    | None -> eof_error (UnclosedBoundary "build")
    | Some token when token_text token = "build" ->
       ignore (advance parser);
       begin match expect_semicolon parser with
       | Error error -> Error error
       | Ok end_token -> Ok (List.rev acc, end_token)
       end
    | Some _ ->
       begin match parse_record_field parser with
       | Error error -> Error error
       | Ok field -> loop (field :: acc)
       end
  in
  loop []

let parse_one_line_record parser layout record_generic_parameters =
  if layout <> OrdinaryRecord then
    match current parser with
    | Some token -> error ~token (ExpectedToken "is")
    | None -> eof_error (ExpectedToken "is")
  else
    match parse_parameter parser with
    | Error error -> Error error
    | Ok parameter ->
       begin match expect_text parser ")" with
       | Error error -> Error error
       | Ok _ ->
          begin match expect_text parser ":" with
          | Error error -> Error error
          | Ok _ ->
             begin match expect_identifier parser with
             | Error error -> Error error
             | Ok universe ->
                begin match expect_semicolon parser with
                | Error error -> Error error
                | Ok end_token ->
                   Ok (
                     {
                       record_layout = layout;
                       record_generic_parameters;
                       record_universe = Some (token_text universe);
                       record_fields = [{ record_field_name = parameter.parameter_name; record_field_type = parameter.parameter_type }];
                       record_one_line = true;
                     },
                     end_token,
                     ";")
                end
             end
          end
       end

let parse_record_summary parser layout =
  match parse_optional_generic_parameters parser with
  | Error error -> Error error
  | Ok record_generic_parameters ->
     if is_text parser "(" then begin
       ignore (advance parser);
       parse_one_line_record parser layout record_generic_parameters
     end else
       begin match parse_optional_universe parser with
       | Error error -> Error error
       | Ok record_universe ->
          begin match expect_text parser "is" with
          | Error error -> Error error
          | Ok _ ->
             begin match parse_record_block_fields parser with
             | Error error -> Error error
             | Ok (record_fields, end_token) ->
                Ok (
                  {
                    record_layout = layout;
                    record_generic_parameters;
                    record_universe;
                    record_fields;
                    record_one_line = false;
                  },
                  end_token,
                  "build")
             end
          end
       end

let expect_integer_literal parser =
  match current parser with
  | Some token ->
     begin match token.kind with
     | KyokaiLexicalToken.IntegerLiteral _ ->
        ignore (advance parser);
        Ok token
     | _ -> error ~token (ExpectedToken "integer literal")
     end
  | None -> eof_error (ExpectedToken "integer literal")

let parse_bit_range parser =
  match expect_integer_literal parser with
  | Error error -> Error error
  | Ok high ->
     begin match expect_text parser ".." with
     | Error error -> Error error
     | Ok _ ->
        begin match expect_integer_literal parser with
        | Error error -> Error error
        | Ok low -> Ok (token_text high, token_text low)
        end
     end

let parse_bitrecord_item parser =
  if is_text parser "field" then begin
    ignore (advance parser);
    match expect_identifier parser with
    | Error error -> Error error
    | Ok name ->
       begin match expect_text parser ":" with
       | Error error -> Error error
       | Ok _ ->
          if is_text parser "bit" then begin
            ignore (advance parser);
            match expect_integer_literal parser with
            | Error error -> Error error
            | Ok bit ->
               begin match expect_semicolon parser with
               | Error error -> Error error
               | Ok _ -> Ok (BitField (token_text name, token_text bit))
               end
          end else if is_text parser "bits" then begin
            ignore (advance parser);
            match parse_bit_range parser with
            | Error error -> Error error
            | Ok (high, low) ->
               begin match expect_semicolon parser with
               | Error error -> Error error
               | Ok _ -> Ok (BitRangeField (token_text name, high, low))
               end
          end else
            match current parser with
            | Some token -> error ~token (ExpectedToken "bit or bits")
            | None -> eof_error (ExpectedToken "bit or bits")
       end
  end else if is_text parser "reserved" then begin
    ignore (advance parser);
    match expect_text parser "bits" with
    | Error error -> Error error
    | Ok _ ->
       begin match parse_bit_range parser with
       | Error error -> Error error
       | Ok (high, low) ->
          begin match expect_semicolon parser with
          | Error error -> Error error
          | Ok _ -> Ok (ReservedBitRange (high, low))
          end
       end
  end else
    match current parser with
    | Some token -> error ~token (ExpectedToken "field or reserved")
    | None -> eof_error (ExpectedToken "field or reserved")

let parse_bitrecord_summary parser =
  match expect_text parser ":" with
  | Error error -> Error error
  | Ok _ ->
     begin match expect_module_identifier parser with
     | Error error -> Error error
     | Ok backing ->
        let bitrecord_backing_type = token_text backing in
        if not (List.mem bitrecord_backing_type ["Nat8"; "Nat16"; "Nat32"; "Nat64"]) then
          error ~token:backing (ExpectedToken "Nat8, Nat16, Nat32, or Nat64")
        else
          begin match expect_text parser "is" with
          | Error error -> Error error
          | Ok _ ->
             let rec loop acc =
               if is_text parser "build" then begin
                 ignore (advance parser);
                 match expect_semicolon parser with
                 | Error error -> Error error
                 | Ok end_token ->
                    Ok ({ bitrecord_backing_type; bitrecord_items = List.rev acc }, end_token)
               end else
                 match parse_bitrecord_item parser with
                 | Error error -> Error error
                 | Ok item -> loop (item :: acc)
             in
             loop []
          end
     end

let parse_union_named_variant_fields parser =
  let rec loop acc =
    match current parser with
    | None -> eof_error (UnclosedBoundary "build")
    | Some token when token_text token = "case" || token_text token = "build" -> Ok (List.rev acc)
    | Some _ ->
       begin match parse_record_field parser with
       | Error error -> Error error
       | Ok field -> loop (field :: acc)
       end
  in
  loop []

let parse_union_variant parser =
  match expect_text parser "case" with
  | Error error -> Error error
  | Ok _ ->
     begin match expect_identifier_or_keyword parser with
     | Error error -> Error error
     | Ok name ->
        if is_text parser ";" then begin
          ignore (advance parser);
          Ok { union_variant_name = token_text name; union_variant_payload = NoVariantPayload }
        end else if is_text parser "(" then begin
          ignore (advance parser);
          match parse_type_ref parser with
          | Error error -> Error error
          | Ok payload ->
             begin match expect_text parser ")" with
             | Error error -> Error error
             | Ok _ ->
                begin match expect_semicolon parser with
                | Error error -> Error error
                | Ok _ -> Ok { union_variant_name = token_text name; union_variant_payload = UnnamedVariantPayload payload }
                end
             end
        end else if is_text parser "is" then begin
          ignore (advance parser);
          match parse_union_named_variant_fields parser with
          | Error error -> Error error
          | Ok fields -> Ok { union_variant_name = token_text name; union_variant_payload = NamedVariantPayload fields }
        end else
          begin match current parser with
          | Some token -> error ~token (ExpectedToken ";")
          | None -> eof_error (ExpectedToken ";")
          end
     end

let parse_union_variants parser =
  let rec loop acc =
    match current parser with
    | None -> eof_error (UnclosedBoundary "build")
    | Some token when token_text token = "build" ->
       ignore (advance parser);
       begin match expect_semicolon parser with
       | Error error -> Error error
       | Ok end_token -> Ok (List.rev acc, end_token)
       end
    | Some token when token_text token = "case" ->
       begin match parse_union_variant parser with
       | Error error -> Error error
       | Ok variant -> loop (variant :: acc)
       end
    | Some token -> error ~token (ExpectedToken "case")
  in
  loop []

let parse_union_summary parser =
  match parse_optional_generic_parameters parser with
  | Error error -> Error error
  | Ok union_generic_parameters ->
     begin match parse_optional_universe parser with
     | Error error -> Error error
     | Ok union_universe ->
        begin match expect_text parser "is" with
        | Error error -> Error error
        | Ok _ ->
           begin match parse_union_variants parser with
           | Error error -> Error error
           | Ok (union_variants, end_token) ->
              Ok ({ union_generic_parameters; union_universe; union_variants }, end_token, "build")
           end
        end
     end

let parse_typeclass_item parser =
  if is_text parser "type" then begin
    ignore (advance parser);
    match expect_module_identifier parser with
    | Error error -> Error error
    | Ok name ->
       begin match expect_semicolon parser with
       | Error error -> Error error
       | Ok _ -> Ok (AssociatedTypeDeclaration (token_text name))
       end
  end else if is_text parser "method" then begin
    ignore (advance parser);
    match expect_identifier parser with
    | Error error -> Error error
    | Ok name ->
       begin match parse_function_signature parser with
       | Error error -> Error error
       | Ok signature ->
          if is_text parser ";" then begin
            ignore (advance parser);
            Ok (TypeclassMethod (token_text name, signature, None))
          end else
            begin match expect_text parser "is" with
            | Error error -> Error error
            | Ok _ ->
               begin match parse_block_until parser ["qed"] with
               | Error error -> Error error
               | Ok body ->
                  begin match expect_text parser "qed" with
                  | Error error -> Error error
                  | Ok _ ->
                     begin match expect_semicolon parser with
                     | Error error -> Error error
                     | Ok _ -> Ok (TypeclassMethod (token_text name, signature, Some body))
                     end
                  end
               end
            end
       end
  end else
    match current parser with
    | Some token -> error ~token (ExpectedToken "type, method, or spec")
    | None -> eof_error (UnclosedBoundary "spec")

let parse_typeclass_summary parser =
  match parse_optional_generic_parameters parser with
  | Error error -> Error error
  | Ok typeclass_generic_parameters ->
     begin match expect_text parser "is" with
     | Error error -> Error error
     | Ok _ ->
        let rec loop acc =
          if is_text parser "spec" then begin
            ignore (advance parser);
            match expect_semicolon parser with
            | Error error -> Error error
            | Ok end_token ->
               Ok ({ typeclass_generic_parameters; typeclass_items = List.rev acc }, end_token)
          end else
            match parse_typeclass_item parser with
            | Error error -> Error error
            | Ok item -> loop (item :: acc)
        in
        loop []
     end

let parse_instance_item parser =
  if is_text parser "type" then begin
    ignore (advance parser);
    match expect_module_identifier parser with
    | Error error -> Error error
    | Ok name ->
       begin match expect_text parser ":=" with
       | Error error -> Error error
       | Ok _ ->
          begin match parse_type_ref parser with
          | Error error -> Error error
          | Ok target_type ->
             begin match expect_semicolon parser with
             | Error error -> Error error
             | Ok _ -> Ok (AssociatedTypeDefinition (token_text name, target_type))
             end
          end
       end
  end else if is_text parser "method" then begin
    ignore (advance parser);
    match expect_identifier parser with
    | Error error -> Error error
    | Ok name ->
       begin match parse_function_signature parser with
       | Error error -> Error error
       | Ok signature ->
          begin match expect_text parser "is" with
          | Error error -> Error error
          | Ok _ ->
             begin match parse_block_until parser ["qed"] with
             | Error error -> Error error
             | Ok body ->
                begin match expect_text parser "qed" with
                | Error error -> Error error
                | Ok _ ->
                   begin match expect_semicolon parser with
                   | Error error -> Error error
                   | Ok _ -> Ok (InstanceMethod (token_text name, signature, body))
                   end
                end
             end
          end
       end
  end else
    match current parser with
    | Some token -> error ~token (ExpectedToken "type, method, or qed")
    | None -> eof_error (UnclosedBoundary "qed")

let parse_instance_summary parser =
  match parse_optional_generic_parameters parser with
  | Error error -> Error error
  | Ok instance_generic_parameters ->
     begin match expect_text parser "for" with
     | Error error -> Error error
     | Ok _ ->
        begin match parse_type_ref parser with
        | Error error -> Error error
        | Ok instance_target_type ->
           begin match parse_optional_where_clause parser with
           | Error error -> Error error
           | Ok instance_where_obligations ->
              begin match parse_optional_declaration_guard parser "is" with
              | Error error -> Error error
              | Ok declaration_guard ->
                 begin match expect_text parser "is" with
                 | Error error -> Error error
                 | Ok _ ->
                    let rec loop acc =
                      if is_text parser "qed" then begin
                        ignore (advance parser);
                        match expect_semicolon parser with
                        | Error error -> Error error
                        | Ok end_token ->
                           Ok (
                             {
                               instance_generic_parameters;
                               instance_target_type;
                               instance_where_obligations;
                               instance_items = List.rev acc;
                             },
                             declaration_guard,
                             end_token)
                      end else
                        match parse_instance_item parser with
                        | Error error -> Error error
                        | Ok item -> loop (item :: acc)
                    in
                    loop []
                 end
              end
           end
        end
     end

let parse_generator_summary parser =
  match parse_optional_generic_parameters parser with
  | Error error -> Error error
  | Ok generator_generic_parameters ->
     begin match expect_text parser "(" with
     | Error error -> Error error
     | Ok _ ->
        begin match parse_parameter_list parser with
        | Error error -> Error error
        | Ok generator_parameters ->
           begin match expect_text parser ":" with
           | Error error -> Error error
           | Ok _ ->
              begin match parse_type_ref parser with
              | Error error -> Error error
              | Ok generator_yield_type ->
                 begin match parse_optional_where_clause parser with
                 | Error error -> Error error
                 | Ok generator_where_obligations ->
                    begin match parse_optional_declaration_guard parser "is" with
                    | Error error -> Error error
                    | Ok declaration_guard ->
                       begin match expect_text parser "is" with
                       | Error error -> Error error
                       | Ok _ ->
                          begin match parse_block_until parser ["qed"] with
                          | Error error -> Error error
                          | Ok body ->
                             begin match expect_text parser "qed" with
                             | Error error -> Error error
                             | Ok _ ->
                                begin match expect_semicolon parser with
                                | Error error -> Error error
                                | Ok end_token ->
                                   Ok (
                                     {
                                       generator_generic_parameters;
                                       generator_parameters;
                                       generator_yield_type;
                                       generator_where_obligations;
                                     },
                                     declaration_guard,
                                     body,
                                     end_token)
                                end
                             end
                          end
                       end
                    end
                 end
              end
           end
        end
     end

let parse_foreign_declaration parser =
  if is_text parser "function" then begin
    ignore (advance parser);
    match expect_identifier parser with
    | Error error -> Error error
    | Ok name ->
       begin match expect_text parser "(" with
       | Error error -> Error error
       | Ok _ ->
          begin match parse_parameter_list parser with
          | Error error -> Error error
          | Ok parameters ->
             begin match expect_text parser ":" with
             | Error error -> Error error
             | Ok _ ->
                begin match parse_type_ref parser with
                | Error error -> Error error
                | Ok return_type ->
                   begin match expect_semicolon parser with
                   | Error error -> Error error
                   | Ok _ -> Ok (ForeignFunction (token_text name, parameters, return_type))
                   end
                end
             end
          end
       end
  end else if is_text parser "constant" then begin
    ignore (advance parser);
    match expect_identifier parser with
    | Error error -> Error error
    | Ok name ->
       begin match expect_text parser ":" with
       | Error error -> Error error
       | Ok _ ->
          begin match parse_type_ref parser with
          | Error error -> Error error
          | Ok constant_type ->
             begin match expect_semicolon parser with
             | Error error -> Error error
             | Ok _ -> Ok (ForeignConstant (token_text name, constant_type))
             end
          end
       end
  end else
    match current parser with
    | Some token -> error ~token (ExpectedToken "function, constant, or mon")
    | None -> eof_error (UnclosedBoundary "mon")

let parse_foreign_block_summary parser =
  match expect_static_string_literal parser with
  | Error error -> Error error
  | Ok abi ->
     begin match expect_text parser "is" with
     | Error error -> Error error
     | Ok _ ->
        let rec loop declarations =
          if is_text parser "mon" then begin
            ignore (advance parser);
            match expect_semicolon parser with
            | Error error -> Error error
            | Ok end_token ->
               Ok (
                 {
                   foreign_abi = token_text abi;
                   foreign_declarations = List.rev declarations;
                 },
                 end_token)
          end else
            match parse_foreign_declaration parser with
            | Error error -> Error error
            | Ok declaration -> loop (declaration :: declarations)
        in
        loop []
     end

let unsafe_contract_field_kind token =
  match token_text token with
  | "assumes" -> Some AssumesField
  | "requires" -> Some RequiresField
  | "preserves" -> Some PreservesField
  | "forbids" -> Some ForbidsField
  | "maps_failure" -> Some MapsFailureField
  | "owns" -> Some OwnsField
  | "borrows" -> Some BorrowsField
  | "transfers" -> Some TransfersField
  | "target" -> Some TargetField
  | "threading" -> Some ThreadingField
  | "lifetime" -> Some LifetimeField
  | "layout" -> Some LayoutField
  | "reentrancy" -> Some ReentrancyField
  | "cleanup" -> Some CleanupField
  | "exports" -> Some ExportsField
  | "evidence" -> Some EvidenceField
  | _ -> None

let parse_unsafe_operation_key parser =
  let rec loop acc =
    match expect_identifier_or_keyword parser with
    | Error error -> Error error
    | Ok segment ->
       let acc = token_text segment :: acc in
       if is_text parser ":" then begin
         ignore (advance parser);
         loop acc
       end else
         Ok (List.rev acc)
  in
  loop []

let parse_unsafe_contract_fields parser =
  let rec loop acc =
    match current parser with
    | Some token ->
       begin match unsafe_contract_field_kind token with
       | None -> Ok (List.rev acc)
       | Some unsafe_field_kind ->
          ignore (advance parser);
          begin match expect_static_string_literal parser with
          | Error error -> Error error
          | Ok value ->
             loop ({ unsafe_field_kind; unsafe_field_value = token_text value } :: acc)
          end
       end
    | None -> eof_error (UnclosedBoundary "audit")
  in
  loop []

let parse_unsafe_contract_item parser =
  if is_text parser "covers" then begin
    ignore (advance parser);
    match parse_unsafe_operation_key parser with
    | Error error -> Error error
    | Ok operation_key ->
       begin match parse_unsafe_contract_fields parser with
       | Error error -> Error error
       | Ok fields ->
          begin match expect_semicolon parser with
          | Error error -> Error error
          | Ok _ -> Ok (CoversOperation (operation_key, fields))
          end
       end
  end else if is_text parser "module_invariant" then begin
    ignore (advance parser);
    match expect_static_string_literal parser with
    | Error error -> Error error
    | Ok invariant ->
       begin match parse_unsafe_contract_fields parser with
       | Error error -> Error error
       | Ok fields ->
          begin match expect_semicolon parser with
          | Error error -> Error error
          | Ok _ -> Ok (ModuleInvariant (token_text invariant, fields))
          end
       end
  end else if is_text parser "additional_invariant" then begin
    ignore (advance parser);
    match parse_unsafe_operation_key parser with
    | Error error -> Error error
    | Ok operation_key ->
       begin match parse_unsafe_contract_fields parser with
       | Error error -> Error error
       | Ok fields ->
          begin match expect_semicolon parser with
          | Error error -> Error error
          | Ok _ -> Ok (AdditionalInvariant (operation_key, fields))
          end
       end
  end else
    match current parser with
    | Some token -> error ~token (ExpectedToken "covers, module_invariant, additional_invariant, or audit")
    | None -> eof_error (UnclosedBoundary "audit")

let parse_unsafe_contract_summary parser =
  match expect_text parser "is" with
  | Error error -> Error error
  | Ok _ ->
     let rec loop items =
       if is_text parser "audit" then begin
         ignore (advance parser);
         match expect_semicolon parser with
         | Error error -> Error error
         | Ok end_token ->
            Ok ({ unsafe_contract_items = List.rev items }, end_token)
       end else
         match parse_unsafe_contract_item parser with
         | Error error -> Error error
         | Ok item -> loop (item :: items)
     in
     loop []

let semicolon_continues_function parser =
  is_text parser "require" || is_text parser "ensure" || is_text parser "when" || is_text parser "is"

let find_definition_body parser simple_terminator =
  let rec loop () =
    match current parser with
    | None -> eof_error UnexpectedEndOfFile
    | Some token when token_text token = "is" ->
       ignore (advance parser);
       scan_to_boundary parser simple_terminator
    | Some token when token_text token = ";" ->
       ignore (advance parser);
       if semicolon_continues_function parser then loop ()
       else error ~token (ExpectedToken "is")
    | Some _ ->
       ignore (advance parser);
       loop ()
  in
  loop ()

let find_boundary_or_semicolon parser terminator =
  let rec loop () =
    match current parser with
    | None -> eof_error UnexpectedEndOfFile
    | Some token when token_text token = "is" ->
       ignore (advance parser);
       scan_to_boundary parser terminator
    | Some token when token_text token = ";" ->
       ignore (advance parser);
       Ok (token, ";")
    | Some _ ->
       ignore (advance parser);
       loop ()
  in
  loop ()

let parse_declaration_prefix parser =
  match current parser with
  | Some token when token_text token = "private" -> error ~token ExplicitPrivateMarker
  | None -> eof_error UnexpectedEndOfFile
  | Some first_token ->
     let visibility =
       if is_text parser "public" then begin
         ignore (advance parser);
         Public
       end else if is_text parser "internal" then begin
         ignore (advance parser);
         Internal
       end else
         Private
     in
     let opaque = is_text parser "opaque" in
     if opaque then ignore (advance parser);
     Ok (visibility, opaque, first_token)

let opaque_is_legal declaration_kind record_layout =
  match declaration_kind, record_layout with
  | RecordDeclaration, Some OrdinaryRecord
  | UnionDeclaration, _ -> true
  | _ -> false

let parse_test_summary parser =
  match current parser with
  | Some description ->
     begin match description.kind with
     | KyokaiLexicalToken.StaticStringLiteral _ ->
        ignore (advance parser);
        let capability_parameters_result =
          if is_text parser "with" then begin
            ignore (advance parser);
            match expect_text parser "(" with
            | Error error -> Error error
            | Ok _ -> parse_parameter_list parser
          end else
            Ok []
        in
        begin match capability_parameters_result with
        | Error error -> Error error
        | Ok test_capability_parameters ->
           begin match expect_text parser "is" with
           | Error error -> Error error
           | Ok _ ->
              begin match parse_block_until parser ["qed"] with
              | Error error -> Error error
              | Ok body ->
                 begin match expect_text parser "qed" with
                 | Error error -> Error error
                 | Ok _ ->
                    begin match expect_semicolon parser with
                    | Error error -> Error error
                    | Ok end_token ->
                       Ok ({
                         test_description = token_text description;
                         test_capability_parameters;
                       }, body, end_token)
                    end
                 end
              end
           end
        end
     | _ -> error ~token:description (ExpectedToken "test description string")
     end
  | None -> eof_error (ExpectedToken "test description string")

let parse_declaration parser =
  match parse_declaration_prefix parser with
  | Error error -> Error error
  | Ok (declaration_visibility, declaration_opaque, declaration_start) ->
     begin match current parser with
     | None -> eof_error UnexpectedEndOfFile
     | Some token ->
        ignore (advance parser);
        begin match declaration_kind_for_start parser token with
        | Error error -> Error error
        | Ok (declaration_kind, fixed_terminator, record_layout) ->
           if declaration_opaque && not (opaque_is_legal declaration_kind record_layout) then
             error ~token InvalidOpaqueModifier
           else if equal_declaration_kind declaration_kind TestDeclaration
                   && (declaration_opaque
                       || not (equal_visibility declaration_visibility Private)) then
             error ~token InvalidTestModifier
           else
           let declaration_name = parse_optional_declaration_name parser declaration_kind in
           let signature_result =
             match declaration_kind with
             | FunctionDeclaration ->
                begin match parse_function_signature parser with
                | Error error -> Error error
                | Ok signature -> Ok (Some signature)
                end
             | _ -> Ok None
           in
           begin match signature_result with
           | Error error -> Error error
           | Ok declaration_signature ->
              let constant_result =
                match declaration_kind with
                | ConstantDeclaration ->
                   begin match parse_constant_summary parser with
                   | Error error -> Error error
                   | Ok summary -> Ok (Some summary)
                   end
                | _ -> Ok None
              in
              begin match constant_result with
              | Error error -> Error error
              | Ok declaration_constant ->
              let type_alias_result =
                match declaration_kind with
                | TypeDeclaration ->
                   begin match parse_type_alias_summary parser with
                   | Error error -> Error error
                   | Ok summary -> Ok (Some summary)
                   end
                | _ -> Ok None
              in
              begin match type_alias_result with
              | Error error -> Error error
              | Ok declaration_type_alias ->
              let record_result =
                match declaration_kind, record_layout with
                | RecordDeclaration, Some layout ->
                   begin match parse_record_summary parser layout with
                   | Error error -> Error error
                   | Ok (summary, end_token, terminator) -> Ok (Some summary, Some (end_token, terminator))
                   end
                | _ -> Ok (None, None)
              in
              begin match record_result with
              | Error error -> Error error
              | Ok (declaration_record, parsed_boundary) ->
              let bitrecord_result =
                match declaration_kind with
                | BitrecordDeclaration ->
                   begin match parse_bitrecord_summary parser with
                   | Error error -> Error error
                   | Ok (summary, end_token) -> Ok (Some summary, Some (end_token, "build"))
                   end
                | _ -> Ok (None, None)
              in
              begin match bitrecord_result with
              | Error error -> Error error
              | Ok (declaration_bitrecord, bitrecord_boundary) ->
              let union_result =
                match declaration_kind with
                | UnionDeclaration ->
                   begin match parse_union_summary parser with
                   | Error error -> Error error
                   | Ok (summary, end_token, terminator) -> Ok (Some summary, Some (end_token, terminator))
                   end
                | _ -> Ok (None, None)
              in
              begin match union_result with
              | Error error -> Error error
              | Ok (declaration_union, union_boundary) ->
              let typeclass_result =
                match declaration_kind with
                | TypeclassDeclaration ->
                   begin match parse_typeclass_summary parser with
                   | Error error -> Error error
                   | Ok (summary, end_token) -> Ok (Some summary, Some (end_token, "spec"))
                   end
                | _ -> Ok (None, None)
              in
              begin match typeclass_result with
              | Error error -> Error error
              | Ok (declaration_typeclass, typeclass_boundary) ->
              let instance_result =
                match declaration_kind with
                | InstanceDeclaration ->
                   begin match parse_instance_summary parser with
                   | Error error -> Error error
                   | Ok (summary, guard, end_token) ->
                      Ok (Some summary, guard, Some (end_token, "qed"))
                   end
                | _ -> Ok (None, None, None)
              in
              begin match instance_result with
              | Error error -> Error error
              | Ok (declaration_instance, instance_guard, instance_boundary) ->
              let generator_result =
                match declaration_kind with
                | GeneratorDeclaration ->
                   begin match parse_generator_summary parser with
                   | Error error -> Error error
                   | Ok (summary, guard, body, end_token) ->
                      Ok (Some summary, guard, Some body, Some (end_token, "qed"))
                   end
                | _ -> Ok (None, None, None, None)
              in
              begin match generator_result with
              | Error error -> Error error
              | Ok (declaration_generator, generator_guard, generator_body, generator_boundary) ->
              let test_result =
                match declaration_kind with
                | TestDeclaration ->
                   begin match parse_test_summary parser with
                   | Error error -> Error error
                   | Ok (summary, body, end_token) ->
                      Ok (Some summary, Some body, Some (end_token, "qed"))
                   end
                | _ -> Ok (None, None, None)
              in
              begin match test_result with
              | Error error -> Error error
              | Ok (declaration_test, test_body, test_boundary) ->
              let foreign_block_result =
                match declaration_kind with
                | ForeignBlock ->
                   begin match parse_foreign_block_summary parser with
                   | Error error -> Error error
                   | Ok (summary, end_token) -> Ok (Some summary, Some (end_token, "mon"))
                   end
                | _ -> Ok (None, None)
              in
              begin match foreign_block_result with
              | Error error -> Error error
              | Ok (declaration_foreign_block, foreign_block_boundary) ->
              let unsafe_contract_result =
                match declaration_kind with
                | UnsafeContract ->
                   begin match parse_unsafe_contract_summary parser with
                   | Error error -> Error error
                   | Ok (summary, end_token) -> Ok (Some summary, Some (end_token, "audit"))
                   end
                | _ -> Ok (None, None)
              in
              begin match unsafe_contract_result with
              | Error error -> Error error
              | Ok (declaration_unsafe_contract, unsafe_contract_boundary) ->
              let guard_result =
                match declaration_kind with
                | FunctionDeclaration -> parse_optional_declaration_guard parser "is"
                | ConstantDeclaration | TypeDeclaration | ExternTypeDeclaration | CapabilityDeclaration ->
                   parse_optional_declaration_guard parser ";"
                | InstanceDeclaration -> Ok instance_guard
                | GeneratorDeclaration -> Ok generator_guard
                | _ -> Ok None
              in
              begin match guard_result with
              | Error error -> Error error
              | Ok declaration_guard ->
              let function_body_result =
                match declaration_kind with
                | FunctionDeclaration ->
                   begin match expect_text parser "is" with
                   | Error error -> Error error
                   | Ok _ ->
                      begin match parse_block_until parser ["qed"] with
                      | Error error -> Error error
                      | Ok body ->
                         begin match expect_text parser "qed" with
                         | Error error -> Error error
                         | Ok _ ->
                            begin match expect_semicolon parser with
                            | Error error -> Error error
                            | Ok end_token -> Ok (Some body, Some (end_token, "qed"))
                            end
                         end
                      end
                   end
                | _ -> Ok (None, None)
              in
              begin match function_body_result with
              | Error error -> Error error
              | Ok (function_body, function_boundary) ->
              let declaration_body =
                match function_body with
                | Some _ -> function_body
                | None ->
                   begin match generator_body with
                   | Some _ -> generator_body
                   | None -> test_body
                   end
              in
              let boundary_result =
                match function_boundary with
                | Some boundary -> Ok boundary
                | None ->
                match unsafe_contract_boundary with
                | Some boundary -> Ok boundary
                | None ->
                match test_boundary with
                | Some boundary -> Ok boundary
                | None ->
                match foreign_block_boundary with
                | Some boundary -> Ok boundary
                | None ->
                match generator_boundary with
                | Some boundary -> Ok boundary
                | None ->
                match instance_boundary with
                | Some boundary -> Ok boundary
                | None ->
                match typeclass_boundary with
                | Some boundary -> Ok boundary
                | None ->
                match union_boundary with
                | Some boundary -> Ok boundary
                | None ->
                match bitrecord_boundary with
                | Some boundary -> Ok boundary
                | None ->
                match parsed_boundary with
                | Some boundary -> Ok boundary
                | None ->
                   begin match fixed_terminator with
                   | Some terminator -> scan_to_boundary parser terminator
                   | None ->
                      begin match declaration_kind with
                      | FunctionDeclaration | InstanceDeclaration | GeneratorDeclaration ->
                         find_definition_body parser "qed"
                      | RecordDeclaration -> find_boundary_or_semicolon parser "build"
                      | ConstantDeclaration | TypeDeclaration | ExternTypeDeclaration
                      | CapabilityDeclaration ->
                         begin match expect_semicolon parser with
                         | Error error -> Error error
                         | Ok end_token -> Ok (end_token, ";")
                         end
                      | _ -> scan_to_simple_semicolon parser
                      end
                   end
              in
              begin match boundary_result with
              | Error error -> Error error
              | Ok (end_token, terminator) ->
                 Ok {
                   declaration_kind;
                   declaration_name;
                   declaration_constant;
                   declaration_signature;
                   declaration_type_alias;
                   declaration_record;
                   declaration_bitrecord;
                   declaration_union;
                  declaration_typeclass;
                   declaration_instance;
                   declaration_generator;
                   declaration_test;
                   declaration_foreign_block;
                  declaration_unsafe_contract;
                  declaration_guard;
                   declaration_body;
                   declaration_visibility;
                   declaration_opaque;
                   declaration_span = { (token_span declaration_start) with end_byte = end_token.span.end_byte; end_line = end_token.span.end_line; end_column = end_token.span.end_column };
                   declaration_terminator = terminator;
                 }
              end
              end
              end
              end
              end
              end
              end
              end
              end
              end
              end
              end
              end
              end
           end
        end
     end

let parse_prelude parser =
  let rec loop pragmas imports =
    match current parser with
    | Some _ when is_text parser "pragma" ->
       begin match parse_pragma parser with
       | Error error -> Error error
       | Ok pragma -> loop (pragma :: pragmas) imports
       end
    | Some token when token_text token = "import" ->
       begin match parse_import parser with
       | Error error -> Error error
       | Ok item -> loop pragmas (item :: imports)
       end
    | _ -> Ok (List.rev pragmas, List.rev imports)
  in
  loop [] []

let parse_module_header parser =
  match expect_text parser "module" with
  | Error error -> Error error
  | Ok start ->
     if is_text parser "body" then
       begin match current parser with
       | Some token -> error ~token RetiredModuleBody
       | None -> eof_error RetiredModuleBody
       end
     else
       begin match parse_module_name parser with
       | Error error -> Error error
       | Ok module_name ->
          begin match expect_text parser "is" with
          | Error error -> Error error
          | Ok _ -> Ok (start, module_name)
          end
       end

let parse_module_body parser =
  let rec loop declarations =
    match current parser with
    | None -> eof_error (UnclosedBoundary "seal")
    | Some token when is_eof_token token -> eof_error (UnclosedBoundary "seal")
    | Some token when token_text token = "seal" ->
       ignore (advance parser);
       begin match expect_semicolon parser with
       | Error error -> Error error
       | Ok end_token -> Ok (List.rev declarations, end_token)
       end
    | Some _ ->
       begin match parse_declaration parser with
       | Error error -> Error error
       | Ok declaration -> loop (declaration :: declarations)
       end
  in
  loop []

let expect_eof parser =
  match current parser with
  | Some token when token.kind = KyokaiLexicalToken.Eof -> Ok ()
  | Some token -> error ~token UnexpectedToken
  | None -> Ok ()

let parse_tokens tokens =
  let parser = make_parser tokens in
  match parse_prelude parser with
  | Error error -> Error error
  | Ok (pragmas, imports) ->
     begin match parse_module_header parser with
     | Error error -> Error error
     | Ok (module_start, module_name) ->
        begin match parse_module_body parser with
        | Error error -> Error error
        | Ok (declarations, module_end) ->
           begin match expect_eof parser with
           | Error error -> Error error
           | Ok () ->
              Ok {
                module_name;
                imports;
                pragmas;
                declarations;
                module_span = { (token_span module_start) with end_byte = module_end.span.end_byte; end_line = module_end.span.end_line; end_column = module_end.span.end_column };
              }
           end
        end
     end

let parse_source ~executable_entry path source =
  match KyokaiSourceFile.classify_source_path path with
  | Error source_error -> error (SourceRoleError source_error)
  | Ok source_path ->
     begin match KyokaiSourceFile.prepare_source_text ~executable_entry source_path source with
     | Error source_text_error -> error (SourceTextError source_text_error)
     | Ok prepared ->
        begin match KyokaiLexicalToken.scan_prepared prepared with
        | Error lexical_error ->
           Error { parser_error_kind = LexicalError lexical_error; parser_error_span = Some lexical_error.span }
        | Ok tokens -> parse_tokens tokens
        end
     end

let rec render_const_generic_expression expression =
  match expression with
  | ConstIndexLiteral literal -> literal
  | ConstName name -> String.concat "." name
  | ConstBinary (left, operator, right) ->
     Printf.sprintf "%s %s %s"
       (render_const_generic_expression left)
       operator
       (render_const_generic_expression right)
  | ConstParenthesized inner ->
     Printf.sprintf "(%s)" (render_const_generic_expression inner)

and render_generic_argument argument =
  match argument with
  | TypeArgument type_ref -> render_type_ref type_ref
  | ConstArgument expression -> render_const_generic_expression expression
  | UnresolvedNameArgument name -> String.concat "." name

and render_type_ref type_ref =
  match type_ref with
  | NamedType (name, []) -> String.concat "." name
  | NamedType (name, args) ->
     Printf.sprintf "%s[%s]"
       (String.concat "." name)
       (String.concat ", " (List.map render_generic_argument args))
  | ReadBorrowType (inner, None) -> Printf.sprintf "&[%s]" (render_type_ref inner)
  | ReadBorrowType (inner, Some region) -> Printf.sprintf "&[%s, %s]" (render_type_ref inner) region
  | WriteBorrowType (inner, None) -> Printf.sprintf "&![%s]" (render_type_ref inner)
  | WriteBorrowType (inner, Some region) -> Printf.sprintf "&![%s, %s]" (render_type_ref inner) region
  | FunctionPointerType (parameters, return_type) ->
     Printf.sprintf "FnPtr(%s): %s"
       (String.concat ", " (List.map render_type_ref parameters))
       (render_type_ref return_type)

let render_where_obligation obligation =
  match obligation with
  | TypeclassBound (constrained_type, typeclass_name) ->
     Printf.sprintf "%s: %s"
       (render_type_ref constrained_type)
       (String.concat "." typeclass_name)
  | AssociatedTypeEquality (projection, equal_type) ->
     Printf.sprintf "%s == %s"
       (render_type_ref projection)
       (render_type_ref equal_type)

let rec render_expression expression =
  match expression.expression_kind with
  | LiteralExpression literal -> render_expression_literal literal
  | NameExpression name -> name
  | CallExpression (callee, arguments) ->
     Printf.sprintf "%s(%s)"
       (render_expression callee)
       (String.concat ", " (List.map render_expression arguments))
  | FieldAccessExpression (base, field) ->
     Printf.sprintf "%s.%s" (render_expression base) field
  | IndexExpression (base, index) ->
     Printf.sprintf "%s[%s]" (render_expression base) (render_expression index)
  | SliceExpression (base, lower, upper) ->
     Printf.sprintf "%s[%s..%s]"
       (render_expression base)
       (Option.fold ~none:"" ~some:render_expression lower)
       (Option.fold ~none:"" ~some:render_expression upper)
  | ArrayExpression items ->
     Printf.sprintf "[%s]" (String.concat ", " (List.map render_expression items))
  | NamedFieldConstructionExpression (constructor_type, fields, update_source) ->
     let rendered_fields = List.map render_construction_field fields in
     let items =
       match update_source with
       | None -> rendered_fields
       | Some source -> rendered_fields @ ["with " ^ render_expression source]
     in
     Printf.sprintf "%s { %s }" (render_type_ref constructor_type) (String.concat ", " items)
  | ClosureExpression (captures, parameters, return_type, closure_body) ->
     let prefix =
       Printf.sprintf "fn [%s] (%s): %s"
         (String.concat ", " (List.map render_closure_capture captures))
         (String.concat ", " (List.map render_value_parameter parameters))
         (render_type_ref return_type)
     in
     begin match closure_body with
     | ExpressionClosureBody body -> prefix ^ " => " ^ render_expression body
     | BlockClosureBody body -> prefix ^ " is " ^ render_statement_block body ^ " qed"
     end
  | UnaryExpression (operator, operand) ->
     if List.mem operator ["&read"; "&write"; "&reborrow"; "not"; "bnot"] then
       Printf.sprintf "%s %s" operator (render_expression operand)
     else
       Printf.sprintf "%s%s" operator (render_expression operand)
  | BinaryExpression (left, operator, right) ->
     Printf.sprintf "%s %s %s"
       (render_expression left)
       operator
       (render_expression right)
  | ParenthesizedExpression inner ->
     Printf.sprintf "(%s)" (render_expression inner)
  | ComptimeExpression inner ->
     Printf.sprintf "comptime %s" (render_expression inner)
  | StaticStringBridgeExpression text ->
     Printf.sprintf "static %s" text
  | StaticAssertExpression (condition, message) ->
     Printf.sprintf "static_assert(%s, %s)" (render_expression condition) message
  | BuildExpression (result_type, body) ->
     Printf.sprintf "build %s do %s build"
       (render_type_ref result_type)
       (render_statement_block body)

and render_expression_literal literal =
  match literal with
  | NilLiteral -> "nil"
  | BoolLiteral true -> "true"
  | BoolLiteral false -> "false"
  | IntegerExpressionLiteral text
  | FloatExpressionLiteral text
  | StaticStringExpressionLiteral text
  | CodePointExpressionLiteral text
  | ByteExpressionLiteral text -> text

and render_construction_field field =
  match field.construction_field_value with
  | None -> field.construction_field_name
  | Some value ->
     Printf.sprintf "%s: %s" field.construction_field_name (render_expression value)

and render_closure_capture capture =
  let prefix =
    match capture.closure_capture_mode with
    | ByValueCapture -> ""
    | ReadBorrowCapture -> "&"
    | WriteBorrowCapture -> "&!"
  in
  prefix ^ capture.closure_capture_name

and render_value_parameter parameter =
  Printf.sprintf "%s: %s" parameter.parameter_name (render_type_ref parameter.parameter_type)

and render_statement statement =
  match statement.statement_kind with
  | ExpressionStatement expression -> render_expression expression ^ ";"
  | LetStatement (binding_pattern, annotated_type, initial_value, or_clause) ->
     let annotation =
       match annotated_type with
       | None -> ""
       | Some type_ref -> ": " ^ render_type_ref type_ref
     in
     Printf.sprintf "let %s%s := %s%s;"
       (render_pattern binding_pattern)
       annotation
       (render_expression initial_value)
       (Option.fold ~none:"" ~some:render_or_clause or_clause)
  | LetElseStatement
      (binding_pattern, annotated_type, initial_value, fallback_pattern, fallback_body) ->
     let annotation =
       match annotated_type with
       | None -> ""
       | Some type_ref -> ": " ^ render_type_ref type_ref
     in
     Printf.sprintf "let %s%s := %s else %s do %s fi;"
       (render_pattern binding_pattern)
       annotation
       (render_expression initial_value)
       (render_pattern fallback_pattern)
       (render_statement_block fallback_body)
  | VarStatement (name, variable_type, initial_value) ->
     let rendered_initializer =
       match initial_value with
       | None -> ""
       | Some value -> " := " ^ render_expression value
     in
     Printf.sprintf "var %s: %s%s;" name (render_type_ref variable_type) rendered_initializer
  | AssignmentStatement (place, value) ->
     Printf.sprintf "%s := %s;" (render_expression place) (render_expression value)
  | ReturnStatement None -> "return;"
  | ReturnStatement (Some expression) -> "return " ^ render_expression expression ^ ";"
  | BreakStatement None -> "break;"
  | BreakStatement (Some label) -> "break " ^ label ^ ";"
  | ContinueStatement None -> "continue;"
  | ContinueStatement (Some label) -> "continue " ^ label ^ ";"
  | PanicStatement expression -> "panic " ^ render_expression expression ^ ";"
  | TodoStatement None -> "todo;"
  | TodoStatement (Some message) -> "todo " ^ message ^ ";"
  | UnreachableStatement -> "unreachable;"
  | DebugStatement expression -> "debug " ^ render_expression expression ^ ";"
  | YieldStatement expression -> "yield " ^ render_expression expression ^ ";"
  | ProduceStatement expression -> "produce " ^ render_expression expression ^ ";"
  | DeferStatement deferred -> "defer " ^ render_statement deferred
  | ErrdeferStatement deferred -> "errdefer " ^ render_statement deferred
  | IfStatement (branches, else_body) ->
     let render_branch index (condition, body) =
       let keyword = if index = 0 then "if" else "else if" in
       Printf.sprintf "%s %s then %s"
         keyword
         (render_expression condition)
         (render_statement_block body)
     in
     let rendered_branches =
       branches
       |> List.mapi render_branch
       |> String.concat " "
     in
     let rendered_else =
       match else_body with
       | None -> ""
       | Some body -> " else " ^ render_statement_block body
     in
     rendered_branches ^ rendered_else ^ " fi;"
  | CaseStatement (scrutinee, arms) ->
     let rendered_arms =
       arms
       |> List.map (fun (arm_pattern, body) ->
            Printf.sprintf "when %s do %s"
              (render_pattern arm_pattern)
              (render_statement_block body))
       |> String.concat " "
     in
     Printf.sprintf "case %s of %s esac;" (render_expression scrutinee) rendered_arms
  | WhileStatement (condition, body) ->
     Printf.sprintf "while %s do %s od;"
       (render_expression condition)
       (render_statement_block body)
  | WhileLetStatement (binding_pattern, value, body) ->
     Printf.sprintf "while let %s := %s do %s od;"
       (render_pattern binding_pattern)
       (render_expression value)
       (render_statement_block body)
  | ForRangeStatement (name, range_start, inclusive, range_end, body) ->
     Printf.sprintf "for %s from %s %s %s do %s od;"
       name
       (render_expression range_start)
       (if inclusive then "to" else "below")
       (render_expression range_end)
       (render_statement_block body)
  | ForInStatement (binding_pattern, iterable, body) ->
     Printf.sprintf "for %s in %s do %s od;"
       (render_pattern binding_pattern)
       (render_expression iterable)
       (render_statement_block body)
  | BorrowStatement (name, borrowed_place, body) ->
     Printf.sprintf "borrow %s := %s do %s drop;"
       name
       (render_expression borrowed_place)
       (render_statement_block body)
  | TaskgroupStatement body ->
     Printf.sprintf "taskgroup do %s join;" (render_statement_block body)
  | SpawnStatement (captures, body, failure) ->
     let rendered_failure =
       match failure with
       | None -> ""
       | Some (name, failure_body) ->
          Printf.sprintf " else %s do %s fi"
            name
            (render_statement_block failure_body)
     in
     Printf.sprintf "spawn [%s] do %s od%s;"
       (String.concat ", " (List.map render_closure_capture captures))
       (render_statement_block body)
       rendered_failure
  | SelectStatement (arms, timeout) ->
     let rendered_arms = String.concat " " (List.map render_select_arm arms) in
     let rendered_timeout =
       match timeout with
       | None -> ""
       | Some (deadline, body) ->
          Printf.sprintf " timeout(%s) do %s"
            (render_expression deadline)
            (render_statement_block body)
     in
     Printf.sprintf "select %s%s pick;" rendered_arms rendered_timeout
  | WaitStatement (arms, default_body) ->
     let rendered_arms = String.concat " " (List.map render_select_arm arms) in
     let rendered_default =
       match default_body with
       | None -> ""
       | Some body -> " default do " ^ render_statement_block body
     in
     Printf.sprintf "wait %s%s wake;" rendered_arms rendered_default

and render_statement_block statements =
  String.concat " " (List.map render_statement statements)

and render_or_clause clause =
  match clause with
  | OrReturn None -> " or return"
  | OrReturn (Some (name, mapping)) ->
     Printf.sprintf " or return %s => %s" name (render_expression mapping)
  | OrBreak None -> " or break"
  | OrBreak (Some label) -> " or break " ^ label
  | OrContinue None -> " or continue"
  | OrContinue (Some label) -> " or continue " ^ label

and render_select_arm (operation, body) =
  Printf.sprintf "when %s do %s"
    (render_expression operation)
    (render_statement_block body)

and render_pattern pattern =
  match pattern.pattern_kind with
  | NamePattern name -> String.concat "." name
  | IgnorePattern -> "ignore"
  | ConstructorPattern (name, NoPatternPayload) -> String.concat "." name
  | ConstructorPattern (name, UnnamedPatternPayload payload) ->
     Printf.sprintf "%s(%s)" (String.concat "." name) (render_pattern payload)
  | ConstructorPattern (name, NamedPatternPayload fields) ->
     Printf.sprintf "%s { %s }"
       (String.concat "." name)
       (String.concat ", " (List.map render_pattern_field fields))
  | RecordPattern fields ->
     Printf.sprintf "{ %s }" (String.concat ", " (List.map render_pattern_field fields))

and render_pattern_field field =
  match field.pattern_field_pattern with
  | None -> field.pattern_field_name
  | Some nested -> Printf.sprintf "%s: %s" field.pattern_field_name (render_pattern nested)

let render_error error =
  let detail =
    match error.parser_error_kind with
    | ExpectedToken text -> Printf.sprintf "Expected token %S." text
    | ExpectedIdentifier -> "Expected an identifier."
    | ExpectedModuleIdentifier -> "Expected a PascalCase module identifier."
    | UnexpectedToken -> "Unexpected token after the module boundary."
    | UnexpectedEndOfFile -> "Unexpected end of file."
    | RetiredModuleBody -> "The retired 'module body' header is not legal; each module is one .kyo source headed by 'module Name is'."
    | ExpectedType -> "Expected a type expression."
    | ExpectedAssociatedTypeProjection -> "Expected an associated-type projection before '=='."
    | ExplicitPrivateMarker -> "Private is the default visibility; omit the explicit 'private' marker."
    | InvalidOpaqueModifier -> "The 'opaque' modifier is legal only on ordinary record and union definitions."
    | InvalidTestModifier -> "Inline test declarations cannot be public, internal, or opaque."
    | UnknownTopLevelDeclaration -> "Unknown top-level declaration form."
    | UnclosedBoundary terminator -> Printf.sprintf "Unclosed boundary; expected %s;." terminator
    | SourceRoleError source_error -> KyokaiSourceFile.render_error source_error
    | SourceTextError source_text_error -> KyokaiSourceText.render_error source_text_error
    | LexicalError lexical_error -> KyokaiLexicalToken.render_error lexical_error
  in
  match error.parser_error_span with
  | None -> detail
  | Some span ->
     Printf.sprintf "%s At byte %d, line %d, column %d."
       detail span.start_byte span.start_line span.start_column
