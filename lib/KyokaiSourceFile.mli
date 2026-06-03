(** Kyokai source-file roles at the frontend boundary. *)

type source_path =
  | InterfacePath of string
  | BodyPath of string
[@@deriving eq]

type error =
  | EmptyPath
  | UnknownSourceExtension of string
  | GeneratedArtifactIsNotSource of string
[@@deriving eq]

(** Classify one Kyokai source path. Only [*.kyo] interfaces and [*.kai]
    bodies are handwritten source. This function intentionally does not define
    a command-line encoding for source sets. *)
val classify_source_path : string -> (source_path, error) result

(** Render one source-role error for CLI diagnostics. *)
val render_error : error -> string

(** Validate source bytes under the role-specific shebang contract. Only an
    executable-entry body source can admit a shebang. *)
val prepare_source_text :
  executable_entry:bool -> source_path -> string ->
  (KyokaiSourceText.prepared, KyokaiSourceText.error) result
