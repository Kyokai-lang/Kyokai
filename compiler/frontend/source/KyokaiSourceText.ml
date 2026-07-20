(*
   Part of the Kyokai project.

   SPDX-License-Identifier: GPL-3.0-or-later
*)

(* kyokai:prooftrace id=FRONTEND-KYOKAI-SOURCE-TEXT *)

type shebang_mode = RejectShebang | ExecutableEntrySource [@@deriving eq]

type span = {
  start_byte: int;
  end_byte: int;
  line: int;
  column: int;
} [@@deriving eq]

type error_kind = InvalidUtf8 | Utf8Bom | BareCarriageReturn | DisallowedShebang
[@@deriving eq]

type error = { kind: error_kind; span: span } [@@deriving eq]

type prepared = {
  source: string;
  token_start_byte: int;
  token_start_line: int;
}

let byte source offset =
  Char.code source.[offset]

let has_bytes source offset expected =
  let length = String.length source in
  List.mapi (fun index item -> offset + index < length && byte source (offset + index) = item) expected
  |> List.for_all Fun.id

let utf8_width source offset =
  match byte source offset with
  | value when value <= 0x7f -> 1
  | value when value <= 0xdf -> 2
  | value when value <= 0xef -> 3
  | _ -> 4

let position_at source target =
  let rec loop offset line column =
    if offset >= target then (line, column)
    else if has_bytes source offset [0x0d; 0x0a] then loop (offset + 2) (line + 1) 1
    else if byte source offset = 0x0a then loop (offset + 1) (line + 1) 1
    else loop (offset + utf8_width source offset) line (column + 1)
  in
  loop 0 1 1

let make_error source start_byte width kind =
  let line, column = position_at source start_byte in
  Error { kind; span = { start_byte; end_byte = start_byte + width; line; column } }

let is_continuation value =
  0x80 <= value && value <= 0xbf

let validate_utf8 source =
  let length = String.length source in
  let valid_continuation offset =
    offset < length && is_continuation (byte source offset)
  in
  let in_range offset lower upper =
    offset < length && lower <= byte source offset && byte source offset <= upper
  in
  let rec loop offset =
    if offset >= length then Ok ()
    else if has_bytes source offset [0xef; 0xbb; 0xbf] then make_error source offset 3 Utf8Bom
    else
      match byte source offset with
      | value when value <= 0x7f -> loop (offset + 1)
      | value when 0xc2 <= value && value <= 0xdf && valid_continuation (offset + 1) ->
         loop (offset + 2)
      | 0xe0 when in_range (offset + 1) 0xa0 0xbf && valid_continuation (offset + 2) ->
         loop (offset + 3)
      | value when 0xe1 <= value && value <= 0xec
                && valid_continuation (offset + 1) && valid_continuation (offset + 2) ->
         loop (offset + 3)
      | 0xed when in_range (offset + 1) 0x80 0x9f && valid_continuation (offset + 2) ->
         loop (offset + 3)
      | value when 0xee <= value && value <= 0xef
                && valid_continuation (offset + 1) && valid_continuation (offset + 2) ->
         loop (offset + 3)
      | 0xf0 when in_range (offset + 1) 0x90 0xbf
                && valid_continuation (offset + 2) && valid_continuation (offset + 3) ->
         loop (offset + 4)
      | value when 0xf1 <= value && value <= 0xf3
                && valid_continuation (offset + 1) && valid_continuation (offset + 2)
                && valid_continuation (offset + 3) ->
         loop (offset + 4)
      | 0xf4 when in_range (offset + 1) 0x80 0x8f
                && valid_continuation (offset + 2) && valid_continuation (offset + 3) ->
         loop (offset + 4)
      | _ -> make_error source offset 1 InvalidUtf8
  in
  loop 0

let validate_newlines source =
  let length = String.length source in
  let rec loop offset =
    if offset >= length then Ok ()
    else if byte source offset = 0x0d then
      if offset + 1 < length && byte source (offset + 1) = 0x0a then loop (offset + 2)
      else make_error source offset 1 BareCarriageReturn
    else loop (offset + 1)
  in
  loop 0

let starts_shebang source offset =
  has_bytes source offset [0x23; 0x21]

let validate_shebangs mode source =
  let length = String.length source in
  let rec loop offset line_start =
    if offset >= length then Ok ()
    else if line_start && starts_shebang source offset then
      if offset = 0 && mode = ExecutableEntrySource then skip_first_line offset
      else make_error source offset 2 DisallowedShebang
    else if byte source offset = 0x0a then loop (offset + 1) true
    else loop (offset + 1) false
  and skip_first_line offset =
    if offset >= length then Ok ()
    else if byte source offset = 0x0a then loop (offset + 1) true
    else skip_first_line (offset + 1)
  in
  loop 0 true

let token_start source =
  if starts_shebang source 0 then
    match String.index_opt source '\n' with
    | Some newline -> (newline + 1, 2)
    | None -> (String.length source, 1)
  else
    (0, 1)

let prepare mode source =
  match validate_utf8 source with
  | Error error -> Error error
  | Ok () ->
     begin match validate_newlines source with
     | Error error -> Error error
     | Ok () ->
        begin match validate_shebangs mode source with
        | Error error -> Error error
        | Ok () ->
           let token_start_byte, token_start_line = token_start source in
           Ok { source; token_start_byte; token_start_line }
        end
     end

let source prepared =
  prepared.source

let token_start_byte prepared =
  prepared.token_start_byte

let token_start_line prepared =
  prepared.token_start_line

let render_error error =
  let description =
    match error.kind with
    | InvalidUtf8 -> "Kyokai source must be valid UTF-8."
    | Utf8Bom -> "Kyokai source must not contain a UTF-8 byte-order mark."
    | BareCarriageReturn -> "Bare carriage return is not a Kyokai line ending."
    | DisallowedShebang -> "A shebang is legal only at byte zero of the manifest-selected executable-entry .kyo source."
  in
  Printf.sprintf "%s At byte %d, line %d, column %d."
    description error.span.start_byte error.span.line error.span.column
