(** Isolated Kyokai lexical-token scaffold.

    This module is deliberately separate from the inherited Austral lexer. It
    recognizes an initial Kyokai token boundary without claiming parser or full
    lexical conformance. *)

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

(** Validate and scan one non-shebang source string into Kyokai tokens.
    Whitespace is discarded, while comments remain tokens for later documentation
    attachment. *)
val scan : string -> (token list, error) result

(** Scan source accepted by the source-byte contract. An admitted shebang is
    skipped while original byte offsets and logical line numbers are preserved. *)
val scan_prepared : KyokaiSourceText.prepared -> (token list, error) result

(** Render a stable host-side explanation for scaffold tests and future
    diagnostic integration. *)
val render_error : error -> string
