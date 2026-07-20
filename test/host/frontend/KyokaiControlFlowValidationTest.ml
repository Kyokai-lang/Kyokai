(*
   Part of the Kyokai project.

   SPDX-License-Identifier: GPL-3.0-or-later
*)

open OUnit2
open Kyokai_frontend
open KyokaiControlFlowValidation

let parse source =
  match KyokaiSurfaceParser.parse_source
          ~executable_entry:false
          "src/Demo/Control.kyo"
          source with
  | Ok source_unit -> source_unit
  | Error error -> assert_failure (KyokaiSurfaceParser.render_error error)

let validate_ok source =
  match validate_source_unit (parse source) with
  | Ok () -> ()
  | Error errors ->
     assert_failure (String.concat "\n" (List.map render_error errors))

let test_accept_nested_contexts _ =
  validate_ok (String.concat "\n" [
      "module Demo.Control is";
      "generator values(): Int32 is";
      "    yield 1;";
      "    while true do";
      "        let Ok(value) := next() or break;";
      "        continue;";
      "    od;";
      "    taskgroup do";
      "        spawn [] do";
      "            debug value;";
      "        od else error do";
      "            debug error;";
      "        fi;";
      "    join;";
      "    let pair := build Pair do";
      "        produce Pair { left: 1, right: 2 };";
      "    build;";
      "qed;";
      "seal;";
    ])

let test_reject_invalid_contexts _ =
  let source_unit = parse (String.concat "\n" [
      "module Demo.Control is";
      "function invalid(): Unit is";
      "    break;";
      "    continue;";
      "    yield 1;";
      "    produce 1;";
      "    spawn [] do";
      "    od;";
      "qed;";
      "seal;";
    ])
  in
  match validate_source_unit source_unit with
  | Ok () -> assert_failure "expected control-flow context errors"
  | Error errors ->
     assert_equal
       [BreakOutsideLoop; ContinueOutsideLoop; YieldOutsideGenerator;
        ProduceOutsideBuild; SpawnOutsideTaskgroup]
       (List.map (fun error -> error.control_flow_error_kind) errors)

let test_reject_generator_control_in_test _ =
  let source_unit = parse (String.concat "\n" [
      "module Demo.Control is";
      "test \"not a generator\" is";
      "    yield 1;";
      "qed;";
      "seal;";
    ])
  in
  match validate_source_unit source_unit with
  | Ok () -> assert_failure "expected test-body control-flow rejection"
  | Error [error] ->
     assert_bool "yield outside generator"
       (equal_error_kind error.control_flow_error_kind YieldOutsideGenerator)
  | Error _ -> assert_failure "unexpected test-body control-flow errors"

let suite =
  "KyokaiControlFlowValidation" >::: [
      "accept nested contexts" >:: test_accept_nested_contexts;
      "reject invalid contexts" >:: test_reject_invalid_contexts;
      "reject generator control in test" >:: test_reject_generator_control_in_test;
    ]

let () = run_test_tt_main suite
