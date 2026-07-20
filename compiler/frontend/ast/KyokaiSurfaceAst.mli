(*
   Part of the Kyokai project.

   SPDX-License-Identifier: GPL-3.0-or-later
*)

(** Span-carrying Kyokai surface abstract syntax.

    These types are the stable Phase 3 boundary between source parsing and the
    later resolution, elaboration, and semantic-checking phases. *)

type span = KyokaiLexicalToken.span = {
  start_byte: int;
  end_byte: int;
  start_line: int;
  start_column: int;
  end_line: int;
  end_column: int;
} [@@deriving eq]

type import_item = {
  imported_name: string;
  local_name: string option;
} [@@deriving eq]

type import_kind =
  | QualifiedImport
  | ModuleAliasImport of string
  | SelectiveImport of import_item list
[@@deriving eq]

type import = {
  import_module: string list;
  import_kind: import_kind;
  import_span: span;
} [@@deriving eq]

type declaration_kind =
  | ConstantDeclaration
  | TypeDeclaration
  | ExternTypeDeclaration
  | RecordDeclaration
  | BitrecordDeclaration
  | UnionDeclaration
  | CapabilityDeclaration
  | FunctionDeclaration
  | TypeclassDeclaration
  | InstanceDeclaration
  | GeneratorDeclaration
  | TestDeclaration
  | ForeignBlock
  | UnsafeContract
  | CompileErrorDeclaration
[@@deriving eq]

type visibility = Public | Internal | Private [@@deriving eq]

type const_generic_expression =
  | ConstIndexLiteral of string
  | ConstName of string list
  | ConstBinary of const_generic_expression * string * const_generic_expression
  | ConstParenthesized of const_generic_expression
[@@deriving eq]

type generic_argument =
  | TypeArgument of type_ref
  | ConstArgument of const_generic_expression
  | UnresolvedNameArgument of string list
and type_ref =
  | NamedType of string list * generic_argument list
  | ReadBorrowType of type_ref * string option
  | WriteBorrowType of type_ref * string option
  | FunctionPointerType of type_ref list * type_ref
[@@deriving eq]

type value_parameter = {
  parameter_name: string;
  parameter_type: type_ref;
} [@@deriving eq]

type generic_parameter_classifier =
  | TypeClassifier
  | FreeClassifier
  | LinearClassifier
  | IndexClassifier
  | RegionClassifier
[@@deriving eq]

type generic_parameter = {
  generic_parameter_name: string;
  generic_parameter_classifier: generic_parameter_classifier;
} [@@deriving eq]

type where_obligation =
  | TypeclassBound of type_ref * string list
  | AssociatedTypeEquality of type_ref * type_ref
[@@deriving eq]

type expression_literal =
  | NilLiteral
  | BoolLiteral of bool
  | IntegerExpressionLiteral of string
  | FloatExpressionLiteral of string
  | StaticStringExpressionLiteral of string
  | CodePointExpressionLiteral of string
  | ByteExpressionLiteral of string
[@@deriving eq]

type expression = {
  expression_kind: expression_kind;
  expression_span: span;
}
and expression_kind =
  | LiteralExpression of expression_literal
  | NameExpression of string
  | CallExpression of expression * expression list
  | FieldAccessExpression of expression * string
  | IndexExpression of expression * expression
  | SliceExpression of expression * expression option * expression option
  | ArrayExpression of expression list
  | NamedFieldConstructionExpression of type_ref * construction_field list * expression option
  | ClosureExpression of closure_capture list * value_parameter list * type_ref * closure_body
  | UnaryExpression of string * expression
  | BinaryExpression of expression * string * expression
  | ParenthesizedExpression of expression
  | ComptimeExpression of expression
  | StaticStringBridgeExpression of string
  | StaticAssertExpression of expression * string
  | BuildExpression of type_ref * statement list
and construction_field = {
  construction_field_name: string;
  construction_field_value: expression option;
}
and closure_capture_mode =
  | ByValueCapture
  | ReadBorrowCapture
  | WriteBorrowCapture
and closure_capture = {
  closure_capture_name: string;
  closure_capture_mode: closure_capture_mode;
}
and closure_body =
  | ExpressionClosureBody of expression
  | BlockClosureBody of statement list
and statement = {
  statement_kind: statement_kind;
  statement_span: span;
}
and statement_kind =
  | ExpressionStatement of expression
  | LetStatement of pattern * type_ref option * expression * or_clause option
  | LetElseStatement of pattern * type_ref option * expression * pattern * statement list
  | VarStatement of string * type_ref * expression option
  | AssignmentStatement of expression * expression
  | ReturnStatement of expression option
  | BreakStatement of string option
  | ContinueStatement of string option
  | PanicStatement of expression
  | TodoStatement of string option
  | UnreachableStatement
  | DebugStatement of expression
  | YieldStatement of expression
  | ProduceStatement of expression
  | DeferStatement of statement
  | ErrdeferStatement of statement
  | IfStatement of (expression * statement list) list * statement list option
  | CaseStatement of expression * (pattern * statement list) list
  | WhileStatement of expression * statement list
  | WhileLetStatement of pattern * expression * statement list
  | ForRangeStatement of string * expression * bool * expression * statement list
  | ForInStatement of pattern * expression * statement list
  | BorrowStatement of string * expression * statement list
  | TaskgroupStatement of statement list
  | SpawnStatement of closure_capture list * statement list * (string * statement list) option
  | SelectStatement of select_arm list * (expression * statement list) option
  | WaitStatement of select_arm list * statement list option
and or_clause =
  | OrReturn of (string * expression) option
  | OrBreak of string option
  | OrContinue of string option
and select_arm = expression * statement list
and pattern = {
  pattern_kind: pattern_kind;
  pattern_span: span;
}
and pattern_kind =
  | NamePattern of string list
  | IgnorePattern
  | ConstructorPattern of string list * pattern_payload
  | RecordPattern of pattern_field list
and pattern_payload =
  | NoPatternPayload
  | UnnamedPatternPayload of pattern
  | NamedPatternPayload of pattern_field list
and pattern_field = {
  pattern_field_name: string;
  pattern_field_pattern: pattern option;
}
[@@deriving eq]

type contract_clause =
  | RequireContract of expression
  | EnsureContract of expression
[@@deriving eq]

type function_signature = {
  function_generic_parameters: generic_parameter list;
  function_parameters: value_parameter list;
  function_return_type: type_ref;
  function_where_obligations: where_obligation list;
  function_contracts: contract_clause list;
} [@@deriving eq]

type constant_summary = {
  constant_type: type_ref;
  constant_initializer: expression;
} [@@deriving eq]

type type_alias_summary = {
  type_alias_generic_parameters: generic_parameter list;
  type_alias_target: type_ref;
} [@@deriving eq]

type record_layout =
  | OrdinaryRecord
  | ExternRecord
  | PackedRecord
[@@deriving eq]

type record_field = {
  record_field_name: string;
  record_field_type: type_ref;
} [@@deriving eq]

type record_summary = {
  record_layout: record_layout;
  record_generic_parameters: generic_parameter list;
  record_universe: string option;
  record_fields: record_field list;
  record_one_line: bool;
} [@@deriving eq]

type bitrecord_item =
  | BitField of string * string
  | BitRangeField of string * string * string
  | ReservedBitRange of string * string
[@@deriving eq]

type bitrecord_summary = {
  bitrecord_backing_type: string;
  bitrecord_items: bitrecord_item list;
} [@@deriving eq]

type typeclass_item =
  | AssociatedTypeDeclaration of string
  | TypeclassMethod of string * function_signature * statement list option
[@@deriving eq]

type typeclass_summary = {
  typeclass_generic_parameters: generic_parameter list;
  typeclass_items: typeclass_item list;
} [@@deriving eq]

type instance_item =
  | AssociatedTypeDefinition of string * type_ref
  | InstanceMethod of string * function_signature * statement list
[@@deriving eq]

type instance_summary = {
  instance_generic_parameters: generic_parameter list;
  instance_target_type: type_ref;
  instance_where_obligations: where_obligation list;
  instance_items: instance_item list;
} [@@deriving eq]

type generator_summary = {
  generator_generic_parameters: generic_parameter list;
  generator_parameters: value_parameter list;
  generator_yield_type: type_ref;
  generator_where_obligations: where_obligation list;
} [@@deriving eq]

type test_summary = {
  test_description: string;
  test_capability_parameters: value_parameter list;
} [@@deriving eq]

type foreign_declaration =
  | ForeignFunction of string * value_parameter list * type_ref
  | ForeignConstant of string * type_ref
[@@deriving eq]

type foreign_block_summary = {
  foreign_abi: string;
  foreign_declarations: foreign_declaration list;
} [@@deriving eq]

type unsafe_contract_field_kind =
  | AssumesField
  | RequiresField
  | PreservesField
  | ForbidsField
  | MapsFailureField
  | OwnsField
  | BorrowsField
  | TransfersField
  | TargetField
  | ThreadingField
  | LifetimeField
  | LayoutField
  | ReentrancyField
  | CleanupField
  | ExportsField
  | EvidenceField
[@@deriving eq]

type unsafe_contract_field = {
  unsafe_field_kind: unsafe_contract_field_kind;
  unsafe_field_value: string;
} [@@deriving eq]

type unsafe_contract_item =
  | CoversOperation of string list * unsafe_contract_field list
  | ModuleInvariant of string * unsafe_contract_field list
  | AdditionalInvariant of string list * unsafe_contract_field list
[@@deriving eq]

type unsafe_contract_summary = {
  unsafe_contract_items: unsafe_contract_item list;
} [@@deriving eq]

type union_variant_payload =
  | NoVariantPayload
  | UnnamedVariantPayload of type_ref
  | NamedVariantPayload of record_field list
[@@deriving eq]

type union_variant = {
  union_variant_name: string;
  union_variant_payload: union_variant_payload;
} [@@deriving eq]

type union_summary = {
  union_generic_parameters: generic_parameter list;
  union_universe: string option;
  union_variants: union_variant list;
} [@@deriving eq]

type declaration = {
  declaration_kind: declaration_kind;
  declaration_name: string option;
  declaration_constant: constant_summary option;
  declaration_signature: function_signature option;
  declaration_type_alias: type_alias_summary option;
  declaration_record: record_summary option;
  declaration_bitrecord: bitrecord_summary option;
  declaration_union: union_summary option;
  declaration_typeclass: typeclass_summary option;
  declaration_instance: instance_summary option;
  declaration_generator: generator_summary option;
  declaration_test: test_summary option;
  declaration_foreign_block: foreign_block_summary option;
  declaration_unsafe_contract: unsafe_contract_summary option;
  declaration_guard: expression option;
  declaration_body: statement list option;
  declaration_visibility: visibility;
  declaration_opaque: bool;
  declaration_span: span;
  declaration_terminator: string;
} [@@deriving eq]

type source_unit = {
  module_name: string list;
  imports: import list;
  pragmas: span list;
  declarations: declaration list;
  module_span: span;
} [@@deriving eq]

type error_kind =
  | ExpectedToken of string
  | ExpectedIdentifier
  | ExpectedModuleIdentifier
  | UnexpectedToken
  | UnexpectedEndOfFile
  | RetiredModuleBody
  | ExpectedType
  | ExpectedAssociatedTypeProjection
  | ExplicitPrivateMarker
  | InvalidOpaqueModifier
  | InvalidTestModifier
  | UnknownTopLevelDeclaration
  | UnclosedBoundary of string
  | SourceRoleError of KyokaiSourceFile.error
  | SourceTextError of KyokaiSourceText.error
  | LexicalError of KyokaiLexicalToken.error
[@@deriving eq]

type error = { parser_error_kind: error_kind; parser_error_span: span option }
[@@deriving eq]
