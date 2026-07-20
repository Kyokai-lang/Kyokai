(*
   Part of the Kyokai project.

   SPDX-License-Identifier: GPL-3.0-or-later
*)

(** Kyokai surface parser.

    This parser consumes [KyokaiLexicalToken] output and produces the shared
    span-carrying surface AST used by the package source loader. *)

include module type of KyokaiSurfaceAst

(** Parse already-scanned tokens under Kyokai's single source-file start
    symbol. Comments are ignored for grammar recognition but retain their token
    spans for later documentation attachment work. *)
val parse_tokens : KyokaiLexicalToken.token list -> (source_unit, error) result

(** Classify, source-validate, scan, and parse one source file. Package and
    workspace source-set selection remains owned by [KyokaiPackageSource]. *)
val parse_source :
  executable_entry:bool -> string -> string -> (source_unit, error) result

val render_type_ref : type_ref -> string

val render_generic_argument : generic_argument -> string

val render_where_obligation : where_obligation -> string

val render_expression : expression -> string

val render_statement : statement -> string

val render_pattern : pattern -> string

val render_error : error -> string
