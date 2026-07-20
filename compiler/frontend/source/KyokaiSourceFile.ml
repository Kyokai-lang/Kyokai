(*
   Part of the Kyokai project.

   SPDX-License-Identifier: GPL-3.0-or-later
*)

(* kyokai:prooftrace id=FRONTEND-KYOKAI-SOURCE-ROLES *)

type source_path = SourcePath of string [@@deriving eq]

type error =
  | EmptyPath
  | UnknownSourceExtension of string
  | RetiredSourceExtension of string
  | InheritedSourceExtension of string
  | GeneratedArtifactIsNotSource of string
[@@deriving eq]

let extension (path: string): string =
  Filename.extension path

let require_nonempty_path (path: string): (unit, error) result =
  if String.length path = 0 then Error EmptyPath else Ok ()

let classify_source_path (path: string): (source_path, error) result =
  match require_nonempty_path path with
  | Error error -> Error error
  | Ok () ->
     begin
       match extension path with
       | ".kyo" -> Ok (SourcePath path)
       | ".kai" -> Error (RetiredSourceExtension path)
       | ".aui" | ".aum" -> Error (InheritedSourceExtension path)
       | ".koi" -> Error (GeneratedArtifactIsNotSource path)
       | _ -> Error (UnknownSourceExtension path)
     end

let render_error (error: error): string =
  match error with
  | EmptyPath ->
     "A Kyokai source path must not be empty."
  | UnknownSourceExtension path ->
     Printf.sprintf "Expected a .kyo Kyokai source path, but received %S." path
  | RetiredSourceExtension path ->
     Printf.sprintf ".kai is a retired source extension; each Kyokai module is one .kyo file: %S." path
  | InheritedSourceExtension path ->
     Printf.sprintf "Inherited Austral .aui/.aum files are not Kyokai source; use one .kyo file per module: %S." path
  | GeneratedArtifactIsNotSource path ->
     Printf.sprintf ".koi is a generated interface artifact, not handwritten source: %S." path

let prepare_source_text ~executable_entry source_path source =
  let shebang_mode =
    match source_path, executable_entry with
    | SourcePath _, true -> KyokaiSourceText.ExecutableEntrySource
    | SourcePath _, false -> KyokaiSourceText.RejectShebang
  in
  KyokaiSourceText.prepare shebang_mode source
