(*
   Part of the Kyokai project.

   SPDX-License-Identifier: GPL-3.0-or-later
*)
open OUnit2
open Kyokai_frontend.KyokaiPackageSource
open Kyokai_frontend.KyokaiPackageResolution
open Kyokai_frontend.KyokaiPackageLockfile

let manifest_text ?(dependencies="") name =
  Printf.sprintf {|
[package]
name = "%s"
version = "0.1.0"
edition = "2026"

[layout]
module_root = "src"
%s
|} name dependencies

let parse_manifest name source =
  match parse_package_manifest ~package_root:("/repo/packages/" ^ name) source with
  | Ok manifest -> manifest
  | Error error -> assert_failure (render_manifest_error error)

let sample_graph () =
  let core = parse_manifest "core" (manifest_text "core") in
  let app = parse_manifest "app" (manifest_text "app" ~dependencies:{|

[dependencies]
core = { workspace = "core" }
|}) in
  match resolve_workspace_manifests [app; core] with
  | Ok graph -> graph
  | Error error -> assert_failure (render_resolution_error error)

let parse_lock_ok source =
  match parse source with
  | Ok lockfile -> lockfile
  | Error error -> assert_failure (render_lockfile_error error)

let test_renders_final_record_families _ =
  let lockfile = of_workspace_resolution ~owner_path:"/repo" (sample_graph ()) in
  let rendered = render lockfile in
  assert_bool "has lock table" (String.contains rendered '[');
  assert_bool "contains root records" (String.contains rendered 'r');
  assert_bool "contains workspace source" (String.contains rendered 'w');
  assert_bool "contains edge dependency" (String.contains rendered 'd');
  assert_bool "mentions package edge" (String.contains rendered '-')

let test_parse_render_round_trip _ =
  let lockfile = of_workspace_resolution ~owner_path:"/repo" (sample_graph ()) in
  let reparsed = parse_lock_ok (render lockfile) in
  assert_bool "round trip lockfile" (equal_lockfile lockfile reparsed)

let test_repair_normalizes_record_order _ =
  let lockfile = of_workspace_resolution ~owner_path:"/repo" (sample_graph ()) in
  let rendered = render lockfile in
  let repaired =
    match repair rendered with
    | Ok text -> text
    | Error error -> assert_failure (render_lockfile_error error)
  in
  assert_equal rendered repaired

let test_validate_rejects_unknown_edge_instance _ =
  let lockfile = of_workspace_resolution ~owner_path:"/repo" (sample_graph ()) in
  let bad_edges =
    match lockfile.edges with
    | edge :: rest -> { edge with edge_to = "workspace:missing@0.1.0#2026" } :: rest
    | [] -> assert_failure "expected sample edge"
  in
  match validate { lockfile with edges = bad_edges } with
  | Ok () -> assert_failure "expected bad edge rejection"
  | Error (UnknownEdgePackage (_, "workspace:missing@0.1.0#2026")) -> ()
  | Error error -> assert_failure (render_lockfile_error error)

let test_parse_rejects_missing_header _ =
  match parse "[[package]]\ninstance = \"x\"\n" with
  | Ok _ -> assert_failure "expected missing header rejection"
  | Error MissingLockHeader -> ()
  | Error error -> assert_failure (render_lockfile_error error)

let suite =
  "KyokaiPackageLockfile" >::: [
      "renders final record families" >:: test_renders_final_record_families;
      "parse render round trip" >:: test_parse_render_round_trip;
      "repair normalizes record order" >:: test_repair_normalizes_record_order;
      "validate rejects unknown edge instance" >:: test_validate_rejects_unknown_edge_instance;
      "parse rejects missing header" >:: test_parse_rejects_missing_header;
    ]

let _ = run_test_tt_main suite
