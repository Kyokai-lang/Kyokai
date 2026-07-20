(*
   Part of the Kyokai project.

   SPDX-License-Identifier: GPL-3.0-or-later
*)
open OUnit2
open Kyokai_frontend.KyokaiPackageSource
open Kyokai_frontend.KyokaiPackageResolution

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

let resolve_ok manifests =
  match resolve_workspace_manifests manifests with
  | Ok graph -> graph
  | Error error -> assert_failure (render_resolution_error error)

let resolve_error manifests expected =
  match resolve_workspace_manifests manifests with
  | Ok _ -> assert_failure "expected package resolver rejection"
  | Error actual ->
     assert_bool (render_resolution_error actual)
       (equal_resolution_error actual expected)

let test_resolves_workspace_dependency_edges _ =
  let core = parse_manifest "core" (manifest_text "core") in
  let app = parse_manifest "app" (manifest_text "app" ~dependencies:{|

[dependencies]
core = { workspace = "core" }
|}) in
  let graph = resolve_ok [app; core] in
  assert_equal ["workspace:app@0.1.0#2026"; "workspace:core@0.1.0#2026"] graph.graph_roots;
  assert_equal 2 (List.length graph.graph_packages);
  match graph.graph_edges with
  | [edge] ->
     assert_equal "workspace:app@0.1.0#2026" edge.from_instance;
     assert_equal "core" edge.dependency_name;
     assert_equal "workspace:core@0.1.0#2026" edge.to_instance;
     assert_bool "workspace requirement recorded"
       (equal_dependency_requirement edge.requirement (WorkspaceRequirement "core"))
  | _ -> assert_failure "expected one workspace edge"

let test_rejects_unknown_workspace_dependency _ =
  let app = parse_manifest "app" (manifest_text "app" ~dependencies:{|

[dependencies]
core = { workspace = "core" }
|}) in
  resolve_error [app] (UnknownWorkspaceDependency ("app", "core", "core"))

let test_rejects_external_git_dependency_lane _ =
  let app = parse_manifest "app" (manifest_text "app" ~dependencies:{|

[dependencies]
pcre = { git = "https://example.invalid/pcre", rev = "a1b2" }
|}) in
  resolve_error [app]
    (UnsupportedExternalDependency
       ("app", "pcre", GitRequirement { git = "https://example.invalid/pcre"; rev = "a1b2"; tag = None }))

let test_rejects_external_index_dependency_lane _ =
  let app = parse_manifest "app" (manifest_text "app" ~dependencies:{|

[dependencies]
json = { index = "@kyokai/json", version = "^1.4" }
|}) in
  resolve_error [app]
    (UnsupportedExternalDependency
       ("app", "json", IndexRequirement { index = "@kyokai/json"; version = "^1.4" }))

let test_rejects_workspace_cycle _ =
  let app = parse_manifest "app" (manifest_text "app" ~dependencies:{|

[dependencies]
core = { workspace = "core" }
|}) in
  let core = parse_manifest "core" (manifest_text "core" ~dependencies:{|

[dependencies]
app = { workspace = "app" }
|}) in
  match resolve_workspace_manifests [app; core] with
  | Ok _ -> assert_failure "expected package cycle rejection"
  | Error (PackageDependencyCycle cycle) ->
     assert_bool "cycle names app" (List.mem "app" cycle);
     assert_bool "cycle names core" (List.mem "core" cycle)
  | Error error -> assert_failure (render_resolution_error error)

let suite =
  "KyokaiPackageResolution" >::: [
      "resolves workspace dependency edges" >:: test_resolves_workspace_dependency_edges;
      "rejects unknown workspace dependency" >:: test_rejects_unknown_workspace_dependency;
      "rejects external git dependency lane" >:: test_rejects_external_git_dependency_lane;
      "rejects external index dependency lane" >:: test_rejects_external_index_dependency_lane;
      "rejects workspace cycle" >:: test_rejects_workspace_cycle;
    ]

let _ = run_test_tt_main suite
