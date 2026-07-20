(*
   Part of the Kyokai project.

   SPDX-License-Identifier: GPL-3.0-or-later
*)

(* kyokai:prooftrace id=TOOL-KYOKAI-CLI-SCAFFOLD *)

let default_fixture_root = "test/conformance"

let print_usage () =
  prerr_endline "usage: kyokai --version";
  prerr_endline "   or: kyokai internal frontend-check [package-or-workspace-root]";
  prerr_endline "   or: kyokai internal conformance-fixture <id> [--fixture-root <path>]";
  exit 2

let print_version () =
  print_endline ("kyokai " ^ Kyokai_cli_support.KyokaiVersion.version_string ^ " bootstrap")

let rec parse_check_args fixture_id fixture_root source_root args =
  match args with
  | [] -> (fixture_id, fixture_root, source_root)
  | "--conformance-fixture" :: id :: rest ->
     parse_check_args (Some id) fixture_root source_root rest
  | "--fixture-root" :: root :: rest ->
     parse_check_args fixture_id root source_root rest
  | root :: rest when String.length root > 0 && root.[0] <> '-' && source_root = None ->
     parse_check_args fixture_id fixture_root (Some root) rest
  | _ -> print_usage ()

let find_fixture_dir fixture_root fixture_id =
  let rec find paths =
    match paths with
    | [] -> None
    | fixture_path :: rest ->
       let metadata = KyokaiConformanceStageLib.load_fixture_metadata fixture_path in
       if metadata.fixture_id = fixture_id then
         Some (Filename.dirname fixture_path)
       else
         find rest
  in
  find (KyokaiConformanceStageLib.collect_fixture_files fixture_root)

let run_conformance_fixture fixture_root fixture_id =
  match find_fixture_dir fixture_root fixture_id with
  | None ->
     prerr_endline ("kyokai internal conformance-fixture: unknown fixture " ^ fixture_id);
     exit 1
  | Some fixture_dir ->
     KyokaiConformanceStageLib.run_single fixture_id fixture_dir;
     Printf.printf "kyokai internal conformance-fixture: %s accepted\n" fixture_id

let checked_module_count loaded =
  List.length loaded.Kyokai_frontend.KyokaiPackageSource.loaded_modules

let run_package_check root =
  match Kyokai_frontend.KyokaiPackageSource.load_package_sources root with
  | Ok loaded ->
     Printf.printf
       "kyokai internal frontend-check: package %s accepted (%d modules)\n"
       loaded.Kyokai_frontend.KyokaiPackageSource.loaded_manifest.package_name
       (checked_module_count loaded)
  | Error error ->
     prerr_endline (Kyokai_frontend.KyokaiPackageSource.render_load_error error);
     exit 1

let run_workspace_check root =
  match Kyokai_frontend.KyokaiPackageSource.load_workspace_sources root with
  | Ok loaded ->
     let package_count = List.length loaded.Kyokai_frontend.KyokaiPackageSource.loaded_workspace_packages in
     let module_count =
       List.fold_left
         (fun count package -> count + checked_module_count package)
         0
         loaded.Kyokai_frontend.KyokaiPackageSource.loaded_workspace_packages
     in
     Printf.printf
       "kyokai internal frontend-check: workspace accepted (%d packages, %d modules)\n"
       package_count
       module_count
  | Error error ->
     prerr_endline (Kyokai_frontend.KyokaiPackageSource.render_workspace_load_error error);
     exit 1

let run_source_check root =
  match Kyokai_frontend.KyokaiPackageSource.load_project_manifest root with
  | Ok (Kyokai_frontend.KyokaiPackageSource.PackageProject _) -> run_package_check root
  | Ok (Kyokai_frontend.KyokaiPackageSource.WorkspaceProject _) -> run_workspace_check root
  | Error error ->
     prerr_endline (Kyokai_frontend.KyokaiPackageSource.render_manifest_error error);
     exit 1

let run_check args =
  match parse_check_args None default_fixture_root None args with
  | (Some fixture_id, fixture_root, None) -> run_conformance_fixture fixture_root fixture_id
  | (Some _, _, Some _) -> print_usage ()
  | (None, _, Some source_root) -> run_source_check source_root
  | (None, _, None) -> run_source_check "."

let () =
  match Array.to_list Sys.argv with
  | [_; "--version"] | [_; "version"] -> print_version ()
  | _ :: "internal" :: "frontend-check" :: rest -> run_check rest
  | _ :: "internal" :: "conformance-fixture" :: fixture_id :: rest ->
     run_check ("--conformance-fixture" :: fixture_id :: rest)
  | _ -> print_usage ()
