(* kyokai:prooftrace id=FRONTEND-KYOKAI-SOURCE-ROLES *)
(*
   Part of the Kyokai project.

   SPDX-License-Identifier: GPL-3.0-or-later
*)

type source_path =
  | InterfacePath of string
  | BodyPath of string
[@@deriving eq]

type error =
  | EmptyPath
  | UnknownSourceExtension of string
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
       | ".kyo" -> Ok (InterfacePath path)
       | ".kai" -> Ok (BodyPath path)
       | ".koi" -> Error (GeneratedArtifactIsNotSource path)
       | _ -> Error (UnknownSourceExtension path)
     end

let render_error (error: error): string =
  match error with
  | EmptyPath ->
     "A Kyokai source path must not be empty."
  | UnknownSourceExtension path ->
     Printf.sprintf "Expected a .kyo interface or .kai body source path, but received %S." path
  | GeneratedArtifactIsNotSource path ->
     Printf.sprintf ".koi is a generated interface artifact, not handwritten source: %S." path

let prepare_source_text ~executable_entry source_path source =
  let shebang_mode =
    match source_path with
    | BodyPath _ when executable_entry -> KyokaiSourceText.ExecutableEntryBody
    | InterfacePath _
    | BodyPath _ -> KyokaiSourceText.RejectShebang
  in
  KyokaiSourceText.prepare shebang_mode source
