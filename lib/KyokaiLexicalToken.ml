(* kyokai:prooftrace id=FRONTEND-KYOKAI-LEXICAL-TOKENS *)
(*
   Part of the Kyokai project.

   SPDX-License-Identifier: GPL-3.0-or-later
*)

type span = {
  start_byte: int;
  end_byte: int;
  start_line: int;
  start_column: int;
  end_line: int;
  end_column: int;
} [@@deriving eq]

type integer_base = Decimal | Hexadecimal | Binary | Octal [@@deriving eq]

type comment_kind = LineComment | DeclarationDocComment | ModuleDocComment
[@@deriving eq]

type static_string_kind = EscapedString | RawMultilineString [@@deriving eq]

type token_kind =
  | Identifier
  | Keyword
  | Comment of comment_kind
  | StaticStringLiteral of static_string_kind
  | CodePointLiteral
  | ByteLiteral
  | ComptimeBuiltin of string
  | IntegerLiteral of integer_base * string option
  | FloatLiteral of string option
  | Symbol
  | Eof
[@@deriving eq]

type token = { kind: token_kind; text: string; span: span } [@@deriving eq]

type error_kind =
  | UnsupportedInheritedForm of string
  | NonAsciiIdentifier
  | InvalidNumericLiteral
  | InvalidUtf8
  | Utf8Bom
  | DisallowedShebang
  | UnknownComptimeBuiltin
  | UnterminatedLiteral
  | InvalidLiteralEscape
  | InvalidLiteralContents
  | BareCarriageReturn
  | InvalidCharacter
[@@deriving eq]

type error = { kind: error_kind; text: string; span: span } [@@deriving eq]

type position = { offset: int; line: int; column: int }

type scanner = {
  source: string;
  length: int;
  mutable offset: int;
  mutable line: int;
  mutable column: int;
}

let keywords = [
  "additional_invariant"; "alias"; "and"; "as"; "assumes"; "audit"; "band"; "below"; "bit";
  "bitrecord"; "bits"; "bnot"; "body"; "bor"; "borrow"; "borrows"; "break"; "build"; "bxor";
  "capability"; "case"; "cleanup"; "compile_error"; "comptime"; "constant"; "continue";
  "contract"; "covers"; "debug"; "default"; "defer"; "do"; "drop"; "else"; "ensure"; "Err";
  "errdefer"; "esac"; "evidence"; "exports"; "extern"; "false"; "fi"; "field"; "fn"; "for";
  "forbids"; "foreign"; "from"; "function"; "generator"; "if"; "import"; "in"; "instance";
  "internal"; "is"; "join"; "layout"; "let"; "lifetime"; "maps_failure"; "method"; "module";
  "module_invariant"; "mon"; "nil"; "None"; "not"; "od"; "of"; "Ok"; "or"; "owns"; "packed";
  "panic"; "pick"; "pragma"; "preserves"; "produce"; "qed"; "receiver"; "record"; "reentrancy";
  "require"; "requires"; "reserved"; "return"; "rotl"; "rotr"; "seal"; "select"; "shl"; "shr";
  "Some"; "spawn"; "spec"; "static"; "static_assert"; "target"; "taskgroup"; "then";
  "threading"; "timeout"; "to"; "todo"; "transfers"; "true"; "type"; "typeclass"; "union";
  "unreachable"; "unsafe"; "var"; "wait"; "wake"; "when"; "where"; "while"; "with"; "yield";
]

let symbols = [
  ":="; "!="; "<="; ">="; "->"; "=>"; "++"; "&!"; "&~"; "..";
  "("; ")"; "["; "]"; "{"; "}"; ","; "."; ":"; ";"; "="; "<";
  ">"; "+"; "-"; "*"; "/"; "%"; "&"; "~"
]

let inherited_forms = ["/="; "--"; "#x"; "#b"; "#o"; "/*"; "|>"]
let comptime_builtins = ["@embedBytes"; "@embedText"]
let integer_suffixes = ["i8"; "i16"; "i32"; "i64"; "n8"; "n16"; "n32"; "n64"; "index"]
let float_suffixes = ["f32"; "f64"]

let current (scanner: scanner): position =
  { offset = scanner.offset; line = scanner.line; column = scanner.column }

let span (scanner: scanner) (start: position): span = {
  start_byte = start.offset;
  end_byte = scanner.offset;
  start_line = start.line;
  start_column = start.column;
  end_line = scanner.line;
  end_column = scanner.column;
}

let substring (scanner: scanner) (start: position): string =
  String.sub scanner.source start.offset (scanner.offset - start.offset)

let starts_with scanner text =
  let text_length = String.length text in
  scanner.offset + text_length <= scanner.length
  && String.sub scanner.source scanner.offset text_length = text

let advance_ascii scanner =
  scanner.offset <- scanner.offset + 1;
  scanner.column <- scanner.column + 1

let advance_count scanner count =
  for _ = 1 to count do
    advance_ascii scanner
  done

let advance_utf8_scalar scanner =
  let width =
    match Char.code scanner.source.[scanner.offset] with
    | value when value <= 0x7f -> 1
    | value when value <= 0xdf -> 2
    | value when value <= 0xef -> 3
    | _ -> 4
  in
  scanner.offset <- scanner.offset + width;
  scanner.column <- scanner.column + 1

let consume_newline scanner =
  if starts_with scanner "\r\n" then scanner.offset <- scanner.offset + 2
  else scanner.offset <- scanner.offset + 1;
  scanner.line <- scanner.line + 1;
  scanner.column <- 1

let is_ascii_alpha char =
  ('a' <= char && char <= 'z') || ('A' <= char && char <= 'Z')

let is_ascii_digit char =
  '0' <= char && char <= '9'

let is_ascii_alphanumeric char =
  is_ascii_alpha char || is_ascii_digit char

let is_identifier_continue char =
  is_ascii_alphanumeric char || char = '_'

let is_hex_digit char =
  is_ascii_digit char || ('a' <= char && char <= 'f') || ('A' <= char && char <= 'F')

let is_binary_digit char =
  char = '0' || char = '1'

let is_octal_digit char =
  '0' <= char && char <= '7'

let at_end scanner =
  scanner.offset >= scanner.length

let peek scanner =
  if at_end scanner then None else Some scanner.source.[scanner.offset]

let consume_while scanner predicate =
  while not (at_end scanner) && predicate scanner.source.[scanner.offset] do
    advance_ascii scanner
  done

let make_token (scanner: scanner) (start: position) (kind: token_kind): token =
  { kind; text = substring scanner start; span = span scanner start }

let make_error (scanner: scanner) (start: position) (kind: error_kind): ('a, error) result =
  Error { kind; text = substring scanner start; span = span scanner start }

let validate_digit_run digit run =
  let length = String.length run in
  let valid_at index =
    index >= 0 && index < length && digit run.[index]
  in
  length > 0
  && let rec loop index =
       if index >= length then true
       else
         let char = run.[index] in
         if digit char then loop (index + 1)
         else if char = '_' && valid_at (index - 1) && valid_at (index + 1) then
           loop (index + 1)
         else
           false
     in
     loop 0

let consume_digits scanner =
  let start = scanner.offset in
  consume_while scanner (fun char -> is_ascii_digit char || char = '_');
  String.sub scanner.source start (scanner.offset - start)

let consume_suffix scanner =
  let start = scanner.offset in
  consume_while scanner is_identifier_continue;
  if scanner.offset = start then None
  else Some (String.sub scanner.source start (scanner.offset - start))

let valid_suffix allowed = function
  | None -> true
  | Some suffix -> List.mem suffix allowed

let scan_based_integer scanner start base prefix_length digit =
  advance_count scanner prefix_length;
  let digit_start = scanner.offset in
  consume_while scanner (fun char -> digit char || char = '_');
  let digits = String.sub scanner.source digit_start (scanner.offset - digit_start) in
  begin
    match peek scanner with
    | Some '\'' ->
       advance_ascii scanner;
       make_error scanner start (UnsupportedInheritedForm "apostrophe numeric separator")
    | _ ->
       let suffix = consume_suffix scanner in
       if validate_digit_run digit digits && valid_suffix integer_suffixes suffix then
         Ok (make_token scanner start (IntegerLiteral (base, suffix)))
       else
         make_error scanner start InvalidNumericLiteral
  end

let scan_decimal_or_float scanner start =
  let whole = consume_digits scanner in
  let fraction = ref None in
  let exponent = ref None in
  if starts_with scanner "." && not (starts_with scanner "..") then begin
    advance_ascii scanner;
    fraction := Some (consume_digits scanner)
  end;
  begin
    match peek scanner with
    | Some ('e' | 'E') ->
       advance_ascii scanner;
       begin match peek scanner with
       | Some ('+' | '-') -> advance_ascii scanner
       | _ -> ()
       end;
       exponent := Some (consume_digits scanner)
    | _ -> ()
  end;
  match peek scanner with
  | Some '\'' ->
     advance_ascii scanner;
     make_error scanner start (UnsupportedInheritedForm "apostrophe numeric separator")
  | _ ->
     let suffix = consume_suffix scanner in
     let is_float = !fraction <> None || !exponent <> None in
     let valid_fraction =
       match !fraction with None -> true | Some "" -> true | Some run -> validate_digit_run is_ascii_digit run
     in
     let valid_exponent =
       match !exponent with None -> true | Some run -> validate_digit_run is_ascii_digit run
     in
     if validate_digit_run is_ascii_digit whole && valid_fraction && valid_exponent then
       if is_float && valid_suffix float_suffixes suffix then
         Ok (make_token scanner start (FloatLiteral suffix))
       else if not is_float && valid_suffix integer_suffixes suffix then
         Ok (make_token scanner start (IntegerLiteral (Decimal, suffix)))
       else
         make_error scanner start InvalidNumericLiteral
     else
       make_error scanner start InvalidNumericLiteral

let scan_number scanner start =
  if starts_with scanner "0x" then scan_based_integer scanner start Hexadecimal 2 is_hex_digit
  else if starts_with scanner "0b" then scan_based_integer scanner start Binary 2 is_binary_digit
  else if starts_with scanner "0o" then scan_based_integer scanner start Octal 2 is_octal_digit
  else scan_decimal_or_float scanner start

let scan_identifier scanner start =
  consume_while scanner is_identifier_continue;
  let text = substring scanner start in
  let kind = if List.mem text keywords then Keyword else Identifier in
  Ok (make_token scanner start kind)

let scan_comment scanner start =
  let kind =
    if starts_with scanner "///" then DeclarationDocComment
    else if starts_with scanner "//!" then ModuleDocComment
    else LineComment
  in
  consume_while scanner (fun char -> char <> '\n' && char <> '\r');
  Ok (make_token scanner start (Comment kind))

let consume_escape scanner start =
  advance_ascii scanner;
  match peek scanner with
  | None -> make_error scanner start UnterminatedLiteral
  | Some ('\\' | '"' | '\'' as escaped) ->
     advance_ascii scanner;
     Ok (Char.code escaped)
  | Some 'n' -> advance_ascii scanner; Ok 0x0a
  | Some 'r' -> advance_ascii scanner; Ok 0x0d
  | Some 't' -> advance_ascii scanner; Ok 0x09
  | Some '0' -> advance_ascii scanner; Ok 0x00
  | Some 'x' ->
     advance_ascii scanner;
     let digits_start = scanner.offset in
     if scanner.offset + 2 <= scanner.length
        && is_hex_digit scanner.source.[scanner.offset]
        && is_hex_digit scanner.source.[scanner.offset + 1] then begin
       advance_count scanner 2;
       let digits = String.sub scanner.source digits_start 2 in
       Ok (int_of_string ("0x" ^ digits))
     end else
       make_error scanner start InvalidLiteralEscape
  | Some 'u' ->
     advance_ascii scanner;
     if peek scanner <> Some '{' then make_error scanner start InvalidLiteralEscape
     else begin
       advance_ascii scanner;
       let digits_start = scanner.offset in
       consume_while scanner is_hex_digit;
       let digits_length = scanner.offset - digits_start in
       if digits_length = 0 || digits_length > 6 || peek scanner <> Some '}' then
         make_error scanner start InvalidLiteralEscape
       else begin
         let digits = String.sub scanner.source digits_start digits_length in
         advance_ascii scanner;
         match int_of_string_opt ("0x" ^ digits) with
         | Some scalar when scalar <= 0x10ffff && not (0xd800 <= scalar && scalar <= 0xdfff) ->
            Ok scalar
         | _ -> make_error scanner start InvalidLiteralEscape
       end
     end
  | Some _ -> advance_ascii scanner; make_error scanner start InvalidLiteralEscape

let rec scan_escaped_string scanner start =
  if at_end scanner then make_error scanner start UnterminatedLiteral
  else
    match peek scanner with
    | Some '"' -> advance_ascii scanner; Ok (make_token scanner start (StaticStringLiteral EscapedString))
    | Some '\\' ->
       begin match consume_escape scanner start with
       | Ok _ -> scan_escaped_string scanner start
       | Error error -> Error error
       end
    | Some ('\n' | '\r') -> make_error scanner start UnterminatedLiteral
    | Some char when Char.code char >= 0x80 -> advance_utf8_scalar scanner; scan_escaped_string scanner start
    | Some _ -> advance_ascii scanner; scan_escaped_string scanner start
    | None -> assert false

let rec scan_raw_multiline_string scanner start =
  if at_end scanner then make_error scanner start UnterminatedLiteral
  else if starts_with scanner "\"\"\"" then begin
    advance_count scanner 3;
    Ok (make_token scanner start (StaticStringLiteral RawMultilineString))
  end else
    match peek scanner with
    | Some '\n' -> consume_newline scanner; scan_raw_multiline_string scanner start
    | Some '\r' when starts_with scanner "\r\n" -> consume_newline scanner; scan_raw_multiline_string scanner start
    | Some '\r' -> advance_ascii scanner; make_error scanner start BareCarriageReturn
    | Some char when Char.code char >= 0x80 -> advance_utf8_scalar scanner; scan_raw_multiline_string scanner start
    | Some _ -> advance_ascii scanner; scan_raw_multiline_string scanner start
    | None -> assert false

let scan_scalar_literal scanner start kind byte_only =
  let scalar =
    match peek scanner with
    | None -> make_error scanner start UnterminatedLiteral
    | Some '\\' -> consume_escape scanner start
    | Some ('\n' | '\r' | '\'') -> make_error scanner start InvalidLiteralContents
    | Some char when Char.code char >= 0x80 ->
       if byte_only then begin
         advance_utf8_scalar scanner;
         make_error scanner start InvalidLiteralContents
       end else begin
         advance_utf8_scalar scanner;
         Ok 0x100
       end
    | Some char -> advance_ascii scanner; Ok (Char.code char)
  in
  match scalar with
  | Error error -> Error error
  | Ok scalar when byte_only && scalar > 0xff -> make_error scanner start InvalidLiteralContents
  | Ok _ ->
     begin match peek scanner with
     | Some '\'' -> advance_ascii scanner; Ok (make_token scanner start kind)
     | _ -> make_error scanner start InvalidLiteralContents
     end

let scan_string_literal scanner start =
  if starts_with scanner "\"\"\"" then begin
    advance_count scanner 3;
    scan_raw_multiline_string scanner start
  end else begin
    advance_ascii scanner;
    scan_escaped_string scanner start
  end

let scan_code_point_literal scanner start =
  advance_ascii scanner;
  scan_scalar_literal scanner start CodePointLiteral false

let scan_byte_literal scanner start =
  advance_count scanner 2;
  scan_scalar_literal scanner start ByteLiteral true

let first_prefix scanner candidates =
  List.find_opt (starts_with scanner) candidates

let accepted_comptime_builtin scanner =
  let exact_builtin builtin =
    if not (starts_with scanner builtin) then false
    else
      let next = scanner.offset + String.length builtin in
      next >= scanner.length || not (is_identifier_continue scanner.source.[next])
  in
  List.find_opt exact_builtin comptime_builtins

let scan_comptime_builtin scanner start =
  match accepted_comptime_builtin scanner with
  | Some builtin ->
     advance_count scanner (String.length builtin);
     Ok (make_token scanner start (ComptimeBuiltin builtin))
  | None ->
     advance_ascii scanner;
     consume_while scanner is_identifier_continue;
     make_error scanner start UnknownComptimeBuiltin

let scan_symbol scanner start symbol =
  advance_count scanner (String.length symbol);
  Ok (make_token scanner start Symbol)

let rec scan_all scanner tokens =
  if at_end scanner then
    let start = current scanner in
    Ok (List.rev (make_token scanner start Eof :: tokens))
  else
    let start = current scanner in
    match peek scanner with
    | Some (' ' | '\t') -> consume_while scanner (fun char -> char = ' ' || char = '\t'); scan_all scanner tokens
    | Some '\n' -> consume_newline scanner; scan_all scanner tokens
    | Some '\r' when starts_with scanner "\r\n" -> consume_newline scanner; scan_all scanner tokens
    | Some '\r' -> advance_ascii scanner; make_error scanner start BareCarriageReturn
    | Some '/' when starts_with scanner "//" ->
       begin match scan_comment scanner start with
       | Ok token -> scan_all scanner (token :: tokens)
       | Error error -> Error error
       end
    | Some '@' ->
       begin match scan_comptime_builtin scanner start with
       | Ok token -> scan_all scanner (token :: tokens)
       | Error error -> Error error
       end
    | Some 'b' when starts_with scanner "b'" ->
       begin match scan_byte_literal scanner start with
       | Ok token -> scan_all scanner (token :: tokens)
       | Error error -> Error error
       end
    | Some '"' ->
       begin match scan_string_literal scanner start with
       | Ok token -> scan_all scanner (token :: tokens)
       | Error error -> Error error
       end
    | Some '\'' ->
       begin match scan_code_point_literal scanner start with
       | Ok token -> scan_all scanner (token :: tokens)
       | Error error -> Error error
       end
    | Some char when Char.code char >= 0x80 -> advance_ascii scanner; make_error scanner start NonAsciiIdentifier
    | Some char when is_ascii_alpha char ->
       begin match scan_identifier scanner start with
       | Ok token -> scan_all scanner (token :: tokens)
       | Error error -> Error error
       end
    | Some char when is_ascii_digit char ->
       begin match scan_number scanner start with
       | Ok token -> scan_all scanner (token :: tokens)
       | Error error -> Error error
       end
    | Some _ ->
       begin match first_prefix scanner inherited_forms with
       | Some inherited ->
          advance_count scanner (String.length inherited);
          make_error scanner start (UnsupportedInheritedForm inherited)
       | None ->
          begin match first_prefix scanner symbols with
          | Some symbol ->
             begin match scan_symbol scanner start symbol with
             | Ok token -> scan_all scanner (token :: tokens)
             | Error error -> Error error
             end
          | None -> advance_ascii scanner; make_error scanner start InvalidCharacter
          end
       end
    | None -> assert false

let scan_from source offset line =
  scan_all { source; length = String.length source; offset; line; column = 1 } []

let scan_prepared prepared =
  scan_from (KyokaiSourceText.source prepared)
    (KyokaiSourceText.token_start_byte prepared)
    (KyokaiSourceText.token_start_line prepared)

let lexical_error_of_source_text source (error: KyokaiSourceText.error) =
  let kind =
    match error.kind with
    | KyokaiSourceText.InvalidUtf8 -> InvalidUtf8
    | KyokaiSourceText.Utf8Bom -> Utf8Bom
    | KyokaiSourceText.BareCarriageReturn -> BareCarriageReturn
    | KyokaiSourceText.DisallowedShebang -> DisallowedShebang
  in
  let start_byte = error.span.start_byte in
  let end_byte = error.span.end_byte in
  let width = end_byte - start_byte in
  Error {
    kind;
    text = String.sub source start_byte width;
    span = {
      start_byte;
      end_byte;
      start_line = error.span.line;
      start_column = error.span.column;
      end_line = error.span.line;
      end_column = error.span.column + (if kind = Utf8Bom then 1 else width);
    };
  }

let scan source =
  match KyokaiSourceText.prepare KyokaiSourceText.RejectShebang source with
  | Ok prepared -> scan_prepared prepared
  | Error error -> lexical_error_of_source_text source error

let render_span span =
  Printf.sprintf "bytes %d..%d, line %d, columns %d..%d"
    span.start_byte span.end_byte span.start_line span.start_column span.end_column

let render_error error =
  let description =
    match error.kind with
    | UnsupportedInheritedForm inherited ->
       Printf.sprintf "Unsupported inherited lexical form %S." inherited
    | NonAsciiIdentifier -> "Kyokai identifiers are ASCII-only."
    | InvalidNumericLiteral -> "Invalid Kyokai numeric literal."
    | InvalidUtf8 -> "Kyokai source must be valid UTF-8."
    | Utf8Bom -> "Kyokai source must not contain a UTF-8 byte-order mark."
    | DisallowedShebang -> "A shebang is legal only for an executable-entry .kai source."
    | UnknownComptimeBuiltin -> "Unknown Kyokai comptime builtin."
    | UnterminatedLiteral -> "Unterminated Kyokai literal."
    | InvalidLiteralEscape -> "Invalid Kyokai literal escape."
    | InvalidLiteralContents -> "Invalid Kyokai literal contents."
    | BareCarriageReturn -> "Bare carriage return is not a Kyokai line ending."
    | InvalidCharacter -> "Character is not admitted by the Kyokai lexical scaffold."
  in
  Printf.sprintf "%s At %s Near %S" description (render_span error.span) error.text
