(*
   Part of the Kyokai project.

   SPDX-License-Identifier: GPL-3.0-or-later
*)

(* kyokai:prooftrace id=FRONTEND-KYOKAI-CONTROL-FLOW-VALIDATION *)

type error_kind =
  | BreakOutsideLoop
  | ContinueOutsideLoop
  | OrBreakOutsideLoop
  | OrContinueOutsideLoop
  | YieldOutsideGenerator
  | ProduceOutsideBuild
  | SpawnOutsideTaskgroup
[@@deriving eq]

type error = {
  control_flow_error_kind: error_kind;
  control_flow_error_span: KyokaiSurfaceParser.span;
} [@@deriving eq]

type context = {
  loop_depth: int;
  build_depth: int;
  taskgroup_depth: int;
  generator_body: bool;
}

let root_context ~generator_body = {
  loop_depth = 0;
  build_depth = 0;
  taskgroup_depth = 0;
  generator_body;
}

let error statement kind = {
  control_flow_error_kind = kind;
  control_flow_error_span = statement.KyokaiSurfaceParser.statement_span;
}

let rec validate_expression context expression =
  match expression.KyokaiSurfaceParser.expression_kind with
  | KyokaiSurfaceParser.LiteralExpression _
  | KyokaiSurfaceParser.NameExpression _
  | KyokaiSurfaceParser.StaticStringBridgeExpression _ -> []
  | KyokaiSurfaceParser.CallExpression (callee, arguments) ->
     validate_expression context callee
     @ List.concat_map (validate_expression context) arguments
  | KyokaiSurfaceParser.FieldAccessExpression (base, _) ->
     validate_expression context base
  | KyokaiSurfaceParser.IndexExpression (base, index) ->
     validate_expression context base @ validate_expression context index
  | KyokaiSurfaceParser.SliceExpression (base, lower, upper) ->
     validate_expression context base
     @ Option.fold ~none:[] ~some:(validate_expression context) lower
     @ Option.fold ~none:[] ~some:(validate_expression context) upper
  | KyokaiSurfaceParser.ArrayExpression items ->
     List.concat_map (validate_expression context) items
  | KyokaiSurfaceParser.NamedFieldConstructionExpression (_, fields, update_source) ->
     let field_errors =
       fields
       |> List.concat_map (fun field ->
            Option.fold
              ~none:[]
              ~some:(validate_expression context)
              field.KyokaiSurfaceParser.construction_field_value)
     in
     field_errors
     @ Option.fold ~none:[] ~some:(validate_expression context) update_source
  | KyokaiSurfaceParser.ClosureExpression (_, _, _, closure_body) ->
     begin match closure_body with
     | KyokaiSurfaceParser.ExpressionClosureBody body ->
        validate_expression context body
     | KyokaiSurfaceParser.BlockClosureBody body ->
        validate_statements (root_context ~generator_body:false) body
     end
  | KyokaiSurfaceParser.UnaryExpression (_, operand)
  | KyokaiSurfaceParser.ParenthesizedExpression operand
  | KyokaiSurfaceParser.ComptimeExpression operand ->
     validate_expression context operand
  | KyokaiSurfaceParser.BinaryExpression (left, _, right) ->
     validate_expression context left @ validate_expression context right
  | KyokaiSurfaceParser.StaticAssertExpression (condition, _) ->
     validate_expression context condition
  | KyokaiSurfaceParser.BuildExpression (_, body) ->
     validate_statements { context with build_depth = context.build_depth + 1 } body

and validate_statement context statement =
  let expression_errors expression = validate_expression context expression in
  match statement.KyokaiSurfaceParser.statement_kind with
  | KyokaiSurfaceParser.ExpressionStatement expression
  | KyokaiSurfaceParser.PanicStatement expression
  | KyokaiSurfaceParser.DebugStatement expression -> expression_errors expression
  | KyokaiSurfaceParser.LetStatement (_, _, expression, or_clause) ->
     expression_errors expression @ validate_or_clause context statement or_clause
  | KyokaiSurfaceParser.LetElseStatement (_, _, expression, _, body) ->
     expression_errors expression @ validate_statements context body
  | KyokaiSurfaceParser.VarStatement (_, _, initial_value) ->
     Option.fold ~none:[] ~some:expression_errors initial_value
  | KyokaiSurfaceParser.AssignmentStatement (place, value) ->
     expression_errors place @ expression_errors value
  | KyokaiSurfaceParser.ReturnStatement value ->
     Option.fold ~none:[] ~some:expression_errors value
  | KyokaiSurfaceParser.BreakStatement _ ->
     if context.loop_depth = 0 then [error statement BreakOutsideLoop] else []
  | KyokaiSurfaceParser.ContinueStatement _ ->
     if context.loop_depth = 0 then [error statement ContinueOutsideLoop] else []
  | KyokaiSurfaceParser.TodoStatement _
  | KyokaiSurfaceParser.UnreachableStatement -> []
  | KyokaiSurfaceParser.YieldStatement expression ->
     let errors = expression_errors expression in
     if context.generator_body then errors
     else error statement YieldOutsideGenerator :: errors
  | KyokaiSurfaceParser.ProduceStatement expression ->
     let errors = expression_errors expression in
     if context.build_depth > 0 then errors
     else error statement ProduceOutsideBuild :: errors
  | KyokaiSurfaceParser.DeferStatement deferred
  | KyokaiSurfaceParser.ErrdeferStatement deferred ->
     validate_statement context deferred
  | KyokaiSurfaceParser.IfStatement (branches, else_body) ->
     let branch_errors =
       branches
       |> List.concat_map (fun (condition, body) ->
            expression_errors condition @ validate_statements context body)
     in
     branch_errors
     @ Option.fold ~none:[] ~some:(validate_statements context) else_body
  | KyokaiSurfaceParser.CaseStatement (scrutinee, arms) ->
     expression_errors scrutinee
     @ List.concat_map (fun (_, body) -> validate_statements context body) arms
  | KyokaiSurfaceParser.WhileStatement (condition, body) ->
     expression_errors condition
     @ validate_statements { context with loop_depth = context.loop_depth + 1 } body
  | KyokaiSurfaceParser.WhileLetStatement (_, expression, body) ->
     expression_errors expression
     @ validate_statements { context with loop_depth = context.loop_depth + 1 } body
  | KyokaiSurfaceParser.ForRangeStatement (_, first, _, last, body) ->
     expression_errors first
     @ expression_errors last
     @ validate_statements { context with loop_depth = context.loop_depth + 1 } body
  | KyokaiSurfaceParser.ForInStatement (_, iterable, body) ->
     expression_errors iterable
     @ validate_statements { context with loop_depth = context.loop_depth + 1 } body
  | KyokaiSurfaceParser.BorrowStatement (_, borrowed_place, body) ->
     expression_errors borrowed_place @ validate_statements context body
  | KyokaiSurfaceParser.TaskgroupStatement body ->
     validate_statements { context with taskgroup_depth = context.taskgroup_depth + 1 } body
  | KyokaiSurfaceParser.SpawnStatement (_, body, failure) ->
     let context_errors =
       if context.taskgroup_depth = 0 then [error statement SpawnOutsideTaskgroup] else []
     in
     context_errors
     @ validate_statements (root_context ~generator_body:false) body
     @ Option.fold
         ~none:[]
         ~some:(fun (_, failure_body) -> validate_statements context failure_body)
         failure
  | KyokaiSurfaceParser.SelectStatement (arms, timeout) ->
     validate_arms context arms
     @ Option.fold
         ~none:[]
         ~some:(fun (deadline, body) ->
           expression_errors deadline @ validate_statements context body)
         timeout
  | KyokaiSurfaceParser.WaitStatement (arms, default_body) ->
     validate_arms context arms
     @ Option.fold ~none:[] ~some:(validate_statements context) default_body

and validate_or_clause context statement clause =
  match clause with
  | None
  | Some (KyokaiSurfaceParser.OrReturn None) -> []
  | Some (KyokaiSurfaceParser.OrReturn (Some (_, mapping))) ->
     validate_expression context mapping
  | Some (KyokaiSurfaceParser.OrBreak _) ->
     if context.loop_depth = 0 then [error statement OrBreakOutsideLoop] else []
  | Some (KyokaiSurfaceParser.OrContinue _) ->
     if context.loop_depth = 0 then [error statement OrContinueOutsideLoop] else []

and validate_arms context arms =
  arms
  |> List.concat_map (fun (operation, body) ->
       validate_expression context operation @ validate_statements context body)

and validate_statements context statements =
  List.concat_map (validate_statement context) statements

let validate_declaration declaration =
  let direct_body_errors =
    match declaration.KyokaiSurfaceParser.declaration_body with
    | None -> []
    | Some body ->
       let generator_body =
         Option.is_some declaration.KyokaiSurfaceParser.declaration_generator
       in
       validate_statements (root_context ~generator_body) body
  in
  let typeclass_errors =
    match declaration.KyokaiSurfaceParser.declaration_typeclass with
    | None -> []
    | Some summary ->
       summary.KyokaiSurfaceParser.typeclass_items
       |> List.concat_map (function
            | KyokaiSurfaceParser.AssociatedTypeDeclaration _
            | KyokaiSurfaceParser.TypeclassMethod (_, _, None) -> []
            | KyokaiSurfaceParser.TypeclassMethod (_, _, Some body) ->
               validate_statements (root_context ~generator_body:false) body)
  in
  let instance_errors =
    match declaration.KyokaiSurfaceParser.declaration_instance with
    | None -> []
    | Some summary ->
       summary.KyokaiSurfaceParser.instance_items
       |> List.concat_map (function
            | KyokaiSurfaceParser.AssociatedTypeDefinition _ -> []
            | KyokaiSurfaceParser.InstanceMethod (_, _, body) ->
               validate_statements (root_context ~generator_body:false) body)
  in
  direct_body_errors @ typeclass_errors @ instance_errors

let validate_source_unit source_unit =
  let errors =
    List.concat_map validate_declaration source_unit.KyokaiSurfaceParser.declarations
  in
  match errors with
  | [] -> Ok ()
  | _ -> Error errors

let render_error error =
  let message =
    match error.control_flow_error_kind with
    | BreakOutsideLoop -> "break is only legal inside a loop"
    | ContinueOutsideLoop -> "continue is only legal inside a loop"
    | OrBreakOutsideLoop -> "or break is only legal inside a loop"
    | OrContinueOutsideLoop -> "or continue is only legal inside a loop"
    | YieldOutsideGenerator -> "yield is only legal inside a generator body"
    | ProduceOutsideBuild -> "produce is only legal inside a build expression"
    | SpawnOutsideTaskgroup -> "spawn is only legal inside a taskgroup"
  in
  Printf.sprintf "%s at line %d, column %d."
    message
    error.control_flow_error_span.start_line
    error.control_flow_error_span.start_column
