(*
   Part of the Kyokai project.

   SPDX-License-Identifier: GPL-3.0-or-later
*)
open OUnit2
open Kyokai_frontend.KyokaiPackageSource

let manifest_text = {|
[package]
name = "demo"
version = "0.1.0"
edition = "2026"

[layout]
module_root = "src"
|}

let executable_manifest_text = {|
[package]
name = "demo"
version = "0.1.0"
edition = "2026"

[layout]
module_root = "src"

[targets.app]
kind = "executable"
module = "App.Main"
entry = "main"
default = true

[targets.tool]
kind = "executable"
module = "App.Tool"
entry = "main"
|}

let parse_manifest_ok ~package_root source =
  match parse_package_manifest ~package_root source with
  | Ok manifest -> manifest
  | Error error -> assert_failure (render_manifest_error error)

let parse_manifest_error ~package_root source expected =
  match parse_package_manifest ~package_root source with
  | Ok _ -> assert_failure "expected manifest rejection"
  | Error actual -> assert_bool (render_manifest_error actual) (equal_manifest_error actual expected)

let parse_workspace_ok ~workspace_root source =
  match parse_workspace_manifest ~workspace_root source with
  | Ok manifest -> manifest
  | Error error -> assert_failure (render_manifest_error error)

let parse_workspace_error ~workspace_root source expected =
  match parse_workspace_manifest ~workspace_root source with
  | Ok _ -> assert_failure "expected workspace manifest rejection"
  | Error actual -> assert_bool (render_manifest_error actual) (equal_manifest_error actual expected)

let test_parse_package_manifest _ =
  let manifest = parse_manifest_ok ~package_root:"/pkg" manifest_text in
  assert_equal "demo" manifest.package_name;
  assert_equal "0.1.0" manifest.package_version;
  assert_equal "2026" manifest.package_edition;
  assert_equal "src" manifest.module_root;
  assert_equal "/pkg/src" manifest.module_root_path;
  assert_equal [] manifest.package_dependencies;
  assert_equal [] manifest.executable_targets

let test_parse_package_dependencies _ =
  let manifest = parse_manifest_ok ~package_root:"/pkg" {|
[package]
name = "demo"
version = "0.1.0"
edition = "2026"

[layout]
module_root = "src"

[dependencies]
core = { workspace = "core" }
json = { index = "@kyokai/json", version = "^1.4" }
pcre = { git = "https://example.invalid/pcre", tag = "v1.2.3", rev = "a1b2c3" }
|} in
  match manifest.package_dependencies with
  | [core; json; pcre] ->
     assert_equal "core" core.dependency_name;
     assert_bool "workspace dependency parsed" (equal_dependency_source core.dependency_source (WorkspaceDependency "core"));
     assert_equal "json" json.dependency_name;
     assert_bool "indexed dependency parsed"
       (equal_dependency_source json.dependency_source
          (IndexDependency { index = "@kyokai/json"; version = "^1.4" }));
     assert_equal "pcre" pcre.dependency_name;
     assert_bool "git dependency parsed"
       (equal_dependency_source pcre.dependency_source
          (GitDependency { git = "https://example.invalid/pcre"; tag = Some "v1.2.3"; rev = "a1b2c3" }))
  | _ -> assert_failure "expected three dependencies"

let test_parse_executable_target_manifest _ =
  let manifest = parse_manifest_ok ~package_root:"/pkg" {|
[package]
name = "demo"
version = "0.1.0"
edition = "2026"

[layout]
module_root = "src"

[targets.app]
kind = "executable"
module = "App.Main"
entry = "main"
output = "app"
default = true
|} in
  match manifest.executable_targets with
  | [target] ->
     assert_equal "app" target.target_name;
     assert_equal ["App"; "Main"] target.target_module;
     assert_equal "main" target.target_entry;
     assert_equal "app" target.target_output;
     assert_equal true target.target_default
  | _ -> assert_failure "expected one executable target"

let test_executable_target_output_defaults_to_name _ =
  let manifest = parse_manifest_ok ~package_root:"/pkg" {|
[package]
name = "demo"
version = "0.1.0"
edition = "2026"

[layout]
module_root = "src"

[targets.tool]
kind = "executable"
module = "App.Tool"
entry = "main"
|} in
  match manifest.executable_targets with
  | [target] -> assert_equal "tool" target.target_output
  | _ -> assert_failure "expected one executable target"

let select_target_ok ?target_name manifest =
  match select_executable_target ?target_name manifest with
  | Ok target -> target
  | Error error -> assert_failure (render_target_selection_error error)

let select_target_error ?target_name manifest expected =
  match select_executable_target ?target_name manifest with
  | Ok _ -> assert_failure "expected executable target selection rejection"
  | Error actual -> assert_bool (render_target_selection_error actual) (equal_target_selection_error actual expected)

let test_select_only_executable_target_by_default _ =
  let manifest = parse_manifest_ok ~package_root:"/pkg" {|
[package]
name = "demo"
version = "0.1.0"
edition = "2026"

[layout]
module_root = "src"

[targets.app]
kind = "executable"
module = "App.Main"
entry = "main"
|} in
  let target = select_target_ok manifest in
  assert_equal "app" target.target_name

let test_select_default_executable_target _ =
  let manifest = parse_manifest_ok ~package_root:"/pkg" executable_manifest_text in
  let target = select_target_ok manifest in
  assert_equal "app" target.target_name

let test_select_explicit_executable_target _ =
  let manifest = parse_manifest_ok ~package_root:"/pkg" executable_manifest_text in
  let target = select_target_ok ~target_name:"tool" manifest in
  assert_equal "tool" target.target_name;
  assert_equal ["App"; "Tool"] target.target_module

let test_reject_unknown_executable_target_selection _ =
  let manifest = parse_manifest_ok ~package_root:"/pkg" executable_manifest_text in
  select_target_error ~target_name:"server" manifest (UnknownExecutableTarget "server")

let test_reject_ambiguous_executable_target_selection _ =
  let manifest = parse_manifest_ok ~package_root:"/pkg" {|
[package]
name = "demo"
version = "0.1.0"
edition = "2026"

[layout]
module_root = "src"

[targets.app]
kind = "executable"
module = "App.Main"
entry = "main"

[targets.tool]
kind = "executable"
module = "App.Tool"
entry = "main"
|} in
  select_target_error manifest (AmbiguousExecutableTarget ["app"; "tool"])

let test_reject_workspace_manifest _ =
  parse_manifest_error ~package_root:"/pkg" {|
[workspace]
members = ["packages/core"]
|} WorkspaceManifestUnsupported

let test_reject_mixed_manifest _ =
  parse_manifest_error ~package_root:"/pkg" {|
[package]
name = "demo"
version = "0.1.0"
edition = "2026"

[workspace]
members = ["packages/core"]
|} MixedPackageAndWorkspace

let test_parse_workspace_manifest _ =
  let manifest = parse_workspace_ok ~workspace_root:"/repo" {|
[workspace]
members = [
  "packages/core",
  "packages/app",
]
|} in
  assert_equal "/repo" manifest.workspace_root;
  assert_equal ["packages/core"; "packages/app"] manifest.workspace_member_paths;
  assert_equal ["/repo/packages/core"; "/repo/packages/app"] manifest.workspace_member_roots

let test_reject_workspace_member_escape _ =
  parse_workspace_error ~workspace_root:"/repo" {|
[workspace]
members = ["../core"]
|} (InvalidWorkspaceMemberPath "../core")

let test_reject_duplicate_workspace_member_path _ =
  parse_workspace_error ~workspace_root:"/repo" {|
[workspace]
members = ["packages/core", "packages/core"]
|} (DuplicateWorkspaceMemberPath "packages/core")

let test_reject_bad_package_name _ =
  parse_manifest_error ~package_root:"/pkg" {|
[package]
name = "Demo"
version = "0.1.0"
edition = "2026"

[layout]
module_root = "src"
|} (InvalidPackageName "Demo")

let test_reject_dependency_branch _ =
  parse_manifest_error ~package_root:"/pkg" {|
[package]
name = "demo"
version = "0.1.0"
edition = "2026"

[layout]
module_root = "src"

[dependencies]
pcre = { git = "https://example.invalid/pcre", branch = "main" }
|} (BranchDependencyUnsupported "pcre")

let test_reject_git_dependency_without_rev _ =
  parse_manifest_error ~package_root:"/pkg" {|
[package]
name = "demo"
version = "0.1.0"
edition = "2026"

[layout]
module_root = "src"

[dependencies]
pcre = { git = "https://example.invalid/pcre" }
|} (MissingDependencyRevision "pcre")

let test_reject_index_dependency_without_version _ =
  parse_manifest_error ~package_root:"/pkg" {|
[package]
name = "demo"
version = "0.1.0"
edition = "2026"

[layout]
module_root = "src"

[dependencies]
json = { index = "@kyokai/json" }
|} (MissingDependencyVersionRequirement "json")

let test_reject_index_dependency_with_invalid_version _ =
  parse_manifest_error ~package_root:"/pkg" {|
[package]
name = "demo"
version = "0.1.0"
edition = "2026"

[layout]
module_root = "src"

[dependencies]
json = { index = "@kyokai/json", version = "*" }
|} (InvalidDependencyVersionRequirement ("json", "*"))

let test_reject_index_dependency_with_invalid_identity _ =
  parse_manifest_error ~package_root:"/pkg" {|
[package]
name = "demo"
version = "0.1.0"
edition = "2026"

[layout]
module_root = "src"

[dependencies]
json = { index = "kyokai/json", version = "^1.4" }
|} (InvalidDependencyIndexSource ("json", "kyokai/json"))

let test_reject_dependency_with_both_sources _ =
  parse_manifest_error ~package_root:"/pkg" {|
[package]
name = "demo"
version = "0.1.0"
edition = "2026"

[layout]
module_root = "src"

[dependencies]
bad = { workspace = "core", index = "@kyokai/core", version = "^1.0" }
|} (InvalidDependencyEntry "bad")

let test_reject_escaping_module_root _ =
  parse_manifest_error ~package_root:"/pkg" {|
[package]
name = "demo"
version = "0.1.0"
edition = "2026"

[layout]
module_root = "../src"
|} (InvalidModuleRoot "../src")

let test_reject_duplicate_default_executable_targets _ =
  parse_manifest_error ~package_root:"/pkg" {|
[package]
name = "demo"
version = "0.1.0"
edition = "2026"

[layout]
module_root = "src"

[targets.app]
kind = "executable"
module = "App.Main"
entry = "main"
default = true

[targets.tool]
kind = "executable"
module = "App.Tool"
entry = "main"
default = true
|} (DuplicateDefaultExecutableTarget ("app", "tool"))

let test_reject_bad_executable_target_module _ =
  parse_manifest_error ~package_root:"/pkg" {|
[package]
name = "demo"
version = "0.1.0"
edition = "2026"

[layout]
module_root = "src"

[targets.app]
kind = "executable"
module = "app.Main"
entry = "main"
|} (InvalidExecutableTargetModule ("app", "app.Main"))

let test_expected_source_path _ =
  let manifest = parse_manifest_ok ~package_root:"/pkg" manifest_text in
  assert_equal "/pkg/src/Foo/Bar.kyo" (expected_source_path manifest ["Foo"; "Bar"])

let make_temp_dir () =
  let path = Filename.temp_file "kyokai-package-source-" "" in
  Sys.remove path;
  Unix.mkdir path 0o700;
  path

let rec remove_tree path =
  if Sys.file_exists path then begin
    if (Unix.lstat path).Unix.st_kind = Unix.S_DIR then begin
      Sys.readdir path
      |> Array.iter (fun entry -> remove_tree (Filename.concat path entry));
      Unix.rmdir path
    end else
      Sys.remove path
  end

let ensure_dir path =
  if not (Sys.file_exists path) then Unix.mkdir path 0o700

let write_file path contents =
  let channel = open_out_bin path in
  Fun.protect
    ~finally:(fun () -> close_out_noerr channel)
    (fun () -> output_string channel contents)

let write_tree_file root relative_path contents =
  let path = Filename.concat root relative_path in
  let rec make_parents dir =
    if dir <> root && not (Sys.file_exists dir) then begin
      make_parents (Filename.dirname dir);
      Unix.mkdir dir 0o700
    end
  in
  make_parents (Filename.dirname path);
  write_file path contents

let with_package_manifest manifest_source files test =
  let root = make_temp_dir () in
  Fun.protect
    ~finally:(fun () -> remove_tree root)
    (fun () ->
      let src = Filename.concat root "src" in
      let kdocs = Filename.concat root "kdocs" in
      ensure_dir src;
      ensure_dir kdocs;
      write_file (Filename.concat root "kyokai.toml") manifest_source;
      List.iter
        (fun (relative_path, contents) -> write_tree_file root relative_path contents)
        files;
      let manifest =
        match load_package_manifest root with
        | Ok manifest -> manifest
        | Error error -> assert_failure (render_manifest_error error)
      in
      test manifest)

let with_package files test =
  with_package_manifest manifest_text files test

let discover_ok manifest =
  match discover_sources manifest with
  | Ok sources -> sources
  | Error errors ->
     let message = errors |> List.map render_discovery_error |> String.concat "\n" in
     assert_failure message

let discover_error manifest expected =
  match discover_sources manifest with
  | Ok _ -> assert_failure "expected source discovery rejection"
  | Error errors ->
     assert_bool "expected discovery error"
       (List.exists (fun actual -> equal_discovery_error actual expected) errors)

let test_discover_single_source _ =
  with_package [
      "src/App/Main.kyo", "module App.Main is\nfunction main(): Unit is\nqed;\nseal;";
      "kdocs/index.json", "{}";
    ]
    (fun manifest ->
      let sources = discover_ok manifest in
      assert_equal 1 (List.length sources);
      match sources with
      | [source] ->
         assert_equal ["App"; "Main"] source.module_name;
         assert_equal (Filename.concat manifest.module_root_path "App/Main.kyo") source.module_source_path
      | _ -> assert_failure "unexpected source count")

let test_reject_retired_kai_source _ =
  with_package [
      "src/App/Main.kai", "module body App.Main is\nseal;";
    ]
    (fun manifest ->
      let path = Filename.concat manifest.module_root_path "App/Main.kai" in
      discover_error manifest (RetiredSourceExtensionDiscovered path))

let test_reject_generated_artifact_under_module_root _ =
  with_package ["src/App/Main.koi", "generated"]
    (fun manifest ->
      let path = Filename.concat manifest.module_root_path "App/Main.koi" in
      discover_error manifest (GeneratedArtifactDiscovered path))

let test_reject_inherited_extension_under_module_root _ =
  with_package ["src/App/Main.aum", "module body Main is\nend module body."]
    (fun manifest ->
      let path = Filename.concat manifest.module_root_path "App/Main.aum" in
      discover_error manifest (InheritedSourceExtensionDiscovered path))

let test_reject_dotted_filename_module _ =
  with_package ["src/App.Main.kyo", "module App.Main is\nseal;"]
    (fun manifest ->
      let path = Filename.concat manifest.module_root_path "App.Main.kyo" in
      discover_error manifest (InvalidModulePath path))

let test_reject_module_root_symlink_escape _ =
  let root = make_temp_dir () in
  let outside = make_temp_dir () in
  Fun.protect
    ~finally:(fun () -> remove_tree root; remove_tree outside)
    (fun () ->
      write_file (Filename.concat root "kyokai.toml") {|
[package]
name = "demo"
version = "0.1.0"
edition = "2026"

[layout]
module_root = "src-link"
|};
      Unix.symlink outside (Filename.concat root "src-link");
      match load_package_manifest root with
      | Error error -> assert_failure (render_manifest_error error)
      | Ok manifest ->
         discover_error manifest (ModuleRootEscapesPackageRoot (Filename.concat root "src-link")))

let parse_one_discovered manifest relative_path logical_module =
  let source = {
    logical_module;
    source_path = Filename.concat manifest.package_root relative_path;
  } in
  parse_discovered_source ~executable_entry:false source

let test_parse_discovered_source_matches_module _ =
  with_package ["src/App/Main.kyo", "module App.Main is\nseal;"]
    (fun manifest ->
      match parse_one_discovered manifest "src/App/Main.kyo" ["App"; "Main"] with
      | Ok parsed -> assert_equal ["App"; "Main"] parsed.module_name
      | Error error -> assert_failure (render_discovery_error error))

let test_parse_discovered_source_rejects_mismatch _ =
  with_package ["src/App/Main.kyo", "module App.Other is\nseal;"]
    (fun manifest ->
      match parse_one_discovered manifest "src/App/Main.kyo" ["App"; "Main"] with
      | Ok _ -> assert_failure "expected module-name mismatch"
      | Error error ->
         assert_bool (render_discovery_error error)
           (equal_discovery_error error
              (ParsedModuleNameMismatch (["App"; "Main"], ["App"; "Other"], Filename.concat manifest.package_root "src/App/Main.kyo"))))

let load_ok root =
  match load_package_sources root with
  | Ok loaded -> loaded
  | Error error -> assert_failure (render_load_error error)

let load_executable_ok ?target_name root =
  match load_executable_package_sources ?target_name root with
  | Ok loaded -> loaded
  | Error error -> assert_failure (render_load_error error)

let load_workspace_ok root =
  match load_workspace_sources root with
  | Ok loaded -> loaded
  | Error error -> assert_failure (render_workspace_load_error error)

let package_manifest_source package_name = Printf.sprintf {|
[package]
name = "%s"
version = "0.1.0"
edition = "2026"

[layout]
module_root = "src"
|} package_name

let write_minimal_package root relative_root package_name module_name =
  let package_root = Filename.concat root relative_root in
  let source_path =
    module_name
    |> String.split_on_char '.'
    |> String.concat Filename.dir_sep
    |> fun path -> Filename.concat "src" (path ^ ".kyo")
  in
  write_tree_file root (Filename.concat relative_root "kyokai.toml") (package_manifest_source package_name);
  write_tree_file root (Filename.concat relative_root source_path) (Printf.sprintf "module %s is\nseal;" module_name);
  package_root

let with_workspace manifest_source files test =
  let root = make_temp_dir () in
  Fun.protect
    ~finally:(fun () -> remove_tree root)
    (fun () ->
      write_file (Filename.concat root "kyokai.toml") manifest_source;
      List.iter (fun (relative_path, contents) -> write_tree_file root relative_path contents) files;
      test root)

let test_load_package_sources _ =
  with_package [
      "src/App/Main.kyo", "import Kyokai.Core;\nmodule App.Main is\npublic function api(): Unit is\nqed;\ninternal function packageHelper(): Unit is\nqed;\nfunction main(): Unit is\nqed;\ntest \"private helper\" is\n    packageHelper();\nqed;\nseal;";
      "src/App/Internal.kyo", "module App.Internal is\nfunction helper(): Unit is\nqed;\nseal;";
    ]
    (fun manifest ->
      let loaded = load_ok manifest.package_root in
      assert_equal "demo" loaded.loaded_manifest.package_name;
      assert_equal 2 (List.length loaded.loaded_modules);
      match loaded.loaded_modules with
      | internal_module :: main_module :: [] ->
         assert_equal ["App"; "Internal"] internal_module.parsed_module_name;
         assert_equal ["App"; "Main"] main_module.parsed_module_name;
         assert_equal 4 (List.length main_module.parsed_source.source_unit.declarations);
         assert_equal 2 (List.length main_module.derived_interface_declarations);
         begin match main_module.derived_interface_declarations with
         | public_decl :: internal_decl :: [] ->
            assert_bool "derived public declaration"
              (Kyokai_frontend.KyokaiSurfaceParser.equal_visibility
                 public_decl.Kyokai_frontend.KyokaiSurfaceParser.declaration_visibility
                 Kyokai_frontend.KyokaiSurfaceParser.Public);
            assert_bool "derived internal declaration"
              (Kyokai_frontend.KyokaiSurfaceParser.equal_visibility
                 internal_decl.Kyokai_frontend.KyokaiSurfaceParser.declaration_visibility
                 Kyokai_frontend.KyokaiSurfaceParser.Internal)
         | _ -> assert_failure "unexpected derived interface declaration set"
         end;
         assert_equal 1 (List.length internal_module.parsed_source.source_unit.declarations);
         assert_equal 0 (List.length internal_module.derived_interface_declarations)
      | _ -> assert_failure "unexpected loaded module set")

let test_load_package_sources_reports_parse_error _ =
  with_package ["src/App/Main.kyo", "module App.Other is\nseal;"]
    (fun manifest ->
      match load_package_sources manifest.package_root with
      | Ok _ -> assert_failure "expected package-source load rejection"
      | Error (LoadSourceError (source_file, ParsedModuleNameMismatch (expected, actual, path))) ->
         assert_equal ["App"; "Main"] source_file.logical_module;
         assert_equal ["App"; "Main"] expected;
         assert_equal ["App"; "Other"] actual;
         assert_equal (Filename.concat manifest.package_root "src/App/Main.kyo") path
      | Error error -> assert_failure (render_load_error error))

let test_load_package_sources_rejects_private_type_leak _ =
  with_package [
      "src/App/Main.kyo", String.concat "\n" [
        "module App.Main is";
        "record Hidden: Free is";
        "build;";
        "public function expose(value: Hidden): Unit is";
        "qed;";
        "seal;";
      ];
    ]
    (fun manifest ->
      match load_package_sources manifest.package_root with
      | Ok _ -> assert_failure "expected interface visibility rejection"
      | Error (LoadSourceError (_, InterfaceValidationErrors (_, [error]))) ->
         assert_bool "private type leak"
           (Kyokai_frontend.KyokaiInterfaceValidation.equal_error_kind
              error.Kyokai_frontend.KyokaiInterfaceValidation.interface_error_kind
              Kyokai_frontend.KyokaiInterfaceValidation.PrivateTypeLeak)
      | Error error -> assert_failure (render_load_error error))

let test_load_executable_package_sources_selects_target_and_shebang_policy _ =
  with_package_manifest executable_manifest_text [
      "src/App/Main.kyo", "#!/usr/bin/env kyokai\nmodule App.Main is\nfunction main(): Unit is\nqed;\nseal;";
      "src/App/Tool.kyo", "module App.Tool is\nfunction main(): Unit is\nqed;\nseal;";
    ]
    (fun manifest ->
      let loaded = load_executable_ok manifest.package_root in
      assert_equal "app" loaded.selected_executable_target.target_name;
      assert_equal 2 (List.length loaded.executable_loaded_package.loaded_modules);
      let main_module =
        List.find
          (fun parsed -> parsed.parsed_module_name = ["App"; "Main"])
          loaded.executable_loaded_package.loaded_modules
      in
      assert_equal 2 main_module.parsed_source.source_unit.module_span.start_line)

let test_load_executable_package_sources_selects_explicit_target _ =
  with_package_manifest executable_manifest_text [
      "src/App/Main.kyo", "module App.Main is\nfunction main(): Unit is\nqed;\nseal;";
      "src/App/Tool.kyo", "#!/usr/bin/env kyokai\nmodule App.Tool is\nfunction main(): Unit is\nqed;\nseal;";
    ]
    (fun manifest ->
      let loaded = load_executable_ok ~target_name:"tool" manifest.package_root in
      assert_equal "tool" loaded.selected_executable_target.target_name;
      let tool_module =
        List.find
          (fun parsed -> parsed.parsed_module_name = ["App"; "Tool"])
          loaded.executable_loaded_package.loaded_modules
      in
      assert_equal 2 tool_module.parsed_source.source_unit.module_span.start_line)

let test_load_executable_package_sources_rejects_missing_target_module _ =
  with_package_manifest executable_manifest_text [
      "src/App/Tool.kyo", "module App.Tool is\nfunction main(): Unit is\nqed;\nseal;";
    ]
    (fun manifest ->
      match load_executable_package_sources manifest.package_root with
      | Ok _ -> assert_failure "expected missing executable target module rejection"
      | Error (LoadTargetSelectionError error) ->
         assert_bool (render_target_selection_error error)
           (equal_target_selection_error error (ExecutableTargetModuleMissing ("app", ["App"; "Main"])))
      | Error error -> assert_failure (render_load_error error))

let test_load_executable_package_sources_rejects_missing_entry _ =
  with_package_manifest executable_manifest_text [
      "src/App/Main.kyo", "module App.Main is\nfunction not_main(): Unit is\nqed;\nseal;";
      "src/App/Tool.kyo", "module App.Tool is\nfunction main(): Unit is\nqed;\nseal;";
    ]
    (fun manifest ->
      match load_executable_package_sources manifest.package_root with
      | Ok _ -> assert_failure "expected missing executable entry rejection"
      | Error (LoadTargetSelectionError error) ->
         assert_bool (render_target_selection_error error)
           (equal_target_selection_error error (ExecutableTargetEntryMissing ("app", ["App"; "Main"], "main")))
      | Error error -> assert_failure (render_load_error error))

let test_load_workspace_sources_loads_explicit_members _ =
  with_workspace {|
[workspace]
members = ["packages/core", "packages/app"]
|} []
    (fun root ->
      ignore (write_minimal_package root "packages/core" "core" "Core");
      ignore (write_minimal_package root "packages/app" "app" "App.Main");
      let loaded = load_workspace_ok root in
      assert_equal ["packages/core"; "packages/app"] loaded.loaded_workspace_manifest.workspace_member_paths;
      assert_equal ["core"; "app"]
        (List.map (fun package -> package.loaded_manifest.package_name) loaded.loaded_workspace_packages))

let test_load_workspace_sources_does_not_infer_unlisted_packages _ =
  with_workspace {|
[workspace]
members = ["packages/core"]
|} []
    (fun root ->
      ignore (write_minimal_package root "packages/core" "core" "Core");
      ignore (write_minimal_package root "packages/extra" "extra" "Extra");
      let loaded = load_workspace_ok root in
      assert_equal ["core"]
        (List.map (fun package -> package.loaded_manifest.package_name) loaded.loaded_workspace_packages))

let test_load_workspace_sources_rejects_duplicate_package_names _ =
  with_workspace {|
[workspace]
members = ["packages/one", "packages/two"]
|} []
    (fun root ->
      let first_root = write_minimal_package root "packages/one" "core" "One" in
      let second_root = write_minimal_package root "packages/two" "core" "Two" in
      match load_workspace_sources root with
      | Ok _ -> assert_failure "expected duplicate workspace package-name rejection"
      | Error error ->
         assert_bool (render_workspace_load_error error)
           (equal_workspace_load_error error (DuplicateWorkspacePackageName ("core", first_root, second_root))))

let test_load_workspace_sources_rejects_missing_member_manifest _ =
  with_workspace {|
[workspace]
members = ["packages/missing"]
|} []
    (fun root ->
      match load_workspace_sources root with
      | Ok _ -> assert_failure "expected missing workspace member manifest rejection"
      | Error (WorkspaceMemberLoadError (member_root, LoadManifestError (ManifestReadError _))) ->
         assert_equal (Filename.concat root "packages/missing") member_root
      | Error error -> assert_failure (render_workspace_load_error error))

let test_load_workspace_sources_rejects_member_symlink_escape _ =
  let outside = make_temp_dir () in
  Fun.protect
    ~finally:(fun () -> remove_tree outside)
    (fun () ->
      write_tree_file outside "src/Escape.kyo" "module Escape is\nseal;";
      write_file (Filename.concat outside "kyokai.toml") (package_manifest_source "escape");
      with_workspace {|
[workspace]
members = ["packages/escape"]
|} []
        (fun root ->
          write_tree_file root "packages/.keep" "";
          Unix.symlink outside (Filename.concat root "packages/escape");
          match load_workspace_sources root with
          | Ok _ -> assert_failure "expected escaping workspace member rejection"
          | Error error ->
             let expected = WorkspaceMemberEscapesWorkspaceRoot (Filename.concat root "packages/escape") in
             assert_bool (render_workspace_load_error error)
               (equal_workspace_load_error error expected)))

let test_load_project_manifest_classifies_package_from_tables _ =
  with_package_manifest manifest_text []
    (fun manifest ->
      match load_project_manifest manifest.package_root with
      | Ok (PackageProject loaded) -> assert_equal "demo" loaded.package_name
      | Ok (WorkspaceProject _) -> assert_failure "package classified as workspace"
      | Error error -> assert_failure (render_manifest_error error))

let test_load_project_manifest_classifies_workspace_from_tables _ =
  with_workspace {|
[workspace]
members = []
|} []
    (fun root ->
      match load_project_manifest root with
      | Ok (WorkspaceProject loaded) -> assert_equal [] loaded.workspace_member_paths
      | Ok (PackageProject _) -> assert_failure "workspace classified as package"
      | Error error -> assert_failure (render_manifest_error error))

let suite =
  "KyokaiPackageSource" >::: [
      "parse package manifest" >:: test_parse_package_manifest;
      "parse package dependencies" >:: test_parse_package_dependencies;
      "parse executable target manifest" >:: test_parse_executable_target_manifest;
      "executable target output defaults to name" >:: test_executable_target_output_defaults_to_name;
      "select only executable target by default" >:: test_select_only_executable_target_by_default;
      "select default executable target" >:: test_select_default_executable_target;
      "select explicit executable target" >:: test_select_explicit_executable_target;
      "reject unknown executable target selection" >:: test_reject_unknown_executable_target_selection;
      "reject ambiguous executable target selection" >:: test_reject_ambiguous_executable_target_selection;
      "reject workspace manifest" >:: test_reject_workspace_manifest;
      "reject mixed package workspace manifest" >:: test_reject_mixed_manifest;
      "parse workspace manifest" >:: test_parse_workspace_manifest;
      "reject workspace member escape" >:: test_reject_workspace_member_escape;
      "reject duplicate workspace member path" >:: test_reject_duplicate_workspace_member_path;
      "reject bad package name" >:: test_reject_bad_package_name;
      "reject dependency branch" >:: test_reject_dependency_branch;
      "reject git dependency without rev" >:: test_reject_git_dependency_without_rev;
      "reject index dependency without version" >:: test_reject_index_dependency_without_version;
      "reject index dependency with invalid version" >:: test_reject_index_dependency_with_invalid_version;
      "reject index dependency with invalid identity" >:: test_reject_index_dependency_with_invalid_identity;
      "reject dependency with both sources" >:: test_reject_dependency_with_both_sources;
      "reject escaping module root" >:: test_reject_escaping_module_root;
      "reject duplicate default executable targets" >:: test_reject_duplicate_default_executable_targets;
      "reject bad executable target module" >:: test_reject_bad_executable_target_module;
      "expected source path" >:: test_expected_source_path;
      "discover single source" >:: test_discover_single_source;
      "reject retired .kai source" >:: test_reject_retired_kai_source;
      "reject generated artifact under module root" >:: test_reject_generated_artifact_under_module_root;
      "reject inherited extension under module root" >:: test_reject_inherited_extension_under_module_root;
      "reject dotted filename module" >:: test_reject_dotted_filename_module;
      "reject module root symlink escape" >:: test_reject_module_root_symlink_escape;
      "parse discovered source matches module" >:: test_parse_discovered_source_matches_module;
      "parse discovered source rejects mismatch" >:: test_parse_discovered_source_rejects_mismatch;
      "load package sources" >:: test_load_package_sources;
      "load package sources reports parse error" >:: test_load_package_sources_reports_parse_error;
      "load package sources rejects private type leak" >:: test_load_package_sources_rejects_private_type_leak;
      "load executable package sources selects target and shebang policy" >:: test_load_executable_package_sources_selects_target_and_shebang_policy;
      "load executable package sources selects explicit target" >:: test_load_executable_package_sources_selects_explicit_target;
      "load executable package sources rejects missing target module" >:: test_load_executable_package_sources_rejects_missing_target_module;
      "load executable package sources rejects missing entry" >:: test_load_executable_package_sources_rejects_missing_entry;
      "load workspace sources loads explicit members" >:: test_load_workspace_sources_loads_explicit_members;
      "load workspace sources does not infer unlisted packages" >:: test_load_workspace_sources_does_not_infer_unlisted_packages;
      "load workspace sources rejects duplicate package names" >:: test_load_workspace_sources_rejects_duplicate_package_names;
      "load workspace sources rejects missing member manifest" >:: test_load_workspace_sources_rejects_missing_member_manifest;
      "load workspace sources rejects member symlink escape" >:: test_load_workspace_sources_rejects_member_symlink_escape;
      "load project manifest classifies package from tables" >:: test_load_project_manifest_classifies_package_from_tables;
      "load project manifest classifies workspace from tables" >:: test_load_project_manifest_classifies_workspace_from_tables;
    ]

let _ = run_test_tt_main suite
