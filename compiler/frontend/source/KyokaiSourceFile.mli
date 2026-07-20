(*
   Part of the Kyokai project.

   SPDX-License-Identifier: GPL-3.0-or-later
*)

(** Kyokai source files at the frontend boundary. *)

type source_path = SourcePath of string [@@deriving eq]

type error =
  | EmptyPath
  | UnknownSourceExtension of string
  | RetiredSourceExtension of string
  | InheritedSourceExtension of string
  | GeneratedArtifactIsNotSource of string
[@@deriving eq]

(** Classify one Kyokai source path. Only [*.kyo] is handwritten source.
    This function intentionally does not define a command-line encoding for
    source sets. *)
val classify_source_path : string -> (source_path, error) result

(** Render one source-file error for CLI diagnostics. *)
val render_error : error -> string

(** Validate source bytes under the executable-entry shebang contract. *)
val prepare_source_text :
  executable_entry:bool -> source_path -> string ->
  (KyokaiSourceText.prepared, KyokaiSourceText.error) result
