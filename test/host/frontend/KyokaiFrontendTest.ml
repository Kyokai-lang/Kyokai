(*
   Part of the Kyokai project.

   SPDX-License-Identifier: GPL-3.0-or-later
*)

open OUnit2
open Kyokai_frontend

let check_ok source =
  match KyokaiFrontend.check_source ~executable_entry:false "src/Demo.kyo" source with
  | Ok checked -> checked
  | Error error -> assert_failure (KyokaiFrontend.render_error error)

let test_composes_phase3_frontend _ =
  let checked = check_ok (String.concat "\n" [
      "module Demo is";
      "public function run(value: Int32): Int32 is";
      "    return value;";
      "qed;";
      "function helper(): Unit is";
      "qed;";
      "seal;";
    ])
  in
  assert_equal ["Demo"] checked.source_unit.module_name;
  assert_equal 1 (List.length checked.derived_interface_declarations)

let test_reports_control_flow_stage _ =
  let source = "module Demo is\nfunction bad(): Unit is\nbreak;\nqed;\nseal;" in
  match KyokaiFrontend.check_source ~executable_entry:false "src/Demo.kyo" source with
  | Error (KyokaiFrontend.ControlFlowErrors [_]) -> ()
  | Error error -> assert_failure (KyokaiFrontend.render_error error)
  | Ok _ -> assert_failure "expected control-flow rejection"

let test_reports_interface_stage _ =
  let source = String.concat "\n" [
      "module Demo is";
      "record Secret(value: Int32): Free;";
      "public function reveal(): Secret is";
      "    todo;";
      "qed;";
      "seal;";
    ]
  in
  match KyokaiFrontend.check_source ~executable_entry:false "src/Demo.kyo" source with
  | Error (KyokaiFrontend.InterfaceErrors [_]) -> ()
  | Error error -> assert_failure (KyokaiFrontend.render_error error)
  | Ok _ -> assert_failure "expected interface rejection"

let suite =
  "KyokaiFrontend" >::: [
      "compose phase3 frontend" >:: test_composes_phase3_frontend;
      "report control flow stage" >:: test_reports_control_flow_stage;
      "report interface stage" >:: test_reports_interface_stage;
    ]

let _ = run_test_tt_main suite
