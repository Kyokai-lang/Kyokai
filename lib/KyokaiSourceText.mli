(** Source-byte contract scaffold for Kyokai files. *)

type shebang_mode = RejectShebang | ExecutableEntryBody [@@deriving eq]

type span = {
  start_byte: int;
  end_byte: int;
  line: int;
  column: int;
} [@@deriving eq]

type error_kind = InvalidUtf8 | Utf8Bom | BareCarriageReturn | DisallowedShebang
[@@deriving eq]

type error = { kind: error_kind; span: span } [@@deriving eq]

type prepared

(** Validate the source-byte contract before lexical scanning. An accepted
    executable-entry shebang remains in [source] for hashing and span offsets,
    while [token_start_byte] identifies the first byte presented to tokenization. *)
val prepare : shebang_mode -> string -> (prepared, error) result

val source : prepared -> string
val token_start_byte : prepared -> int
val token_start_line : prepared -> int

val render_error : error -> string
