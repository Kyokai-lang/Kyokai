# Grammar

[Rikona Kurasaki / Mjoyufull]
> ProofTrace: SPEC-LANGUAGE-03-GRAMMAR
> Covers: This chapter is registered in the public ProofTrace evidence graph; registration does not claim implementation, conformance, or theorem completion.

Kyokai keeps Austral's interface-first module model without retaining its handwritten interface/body file pair. One `.kyo` file contains the module's public declarations, private helpers, and selected platform-specific bodies. Each declaration carries its own visibility marker, and the compiler derives the importable interface from the checked file.

> Trace: D5, D17, D52, D78, D86, D537, D538
> Covers: Kyokai is a fork that keeps Austral's interface-first modularity while replacing the handwritten interface/body pair with one `.kyo` source file, per-declaration visibility, package-visible `internal`, and deterministic module resolution.

This chapter defines source grammar. Later chapters define name resolution, typing, ownership, borrowing, evaluation, layout, contracts, FFI, unsafe obligations, concurrency, and runtime failure. A form admitted here is syntactically recognizable; it is not necessarily semantically legal.

> Trace: D86, D87, D155
> Covers: Syntax admission is separate from semantic acceptance, and accepted Kyokai behavior is defined by the normative spec rather than by inherited implementation accidents.

## Start Symbol

[Rikona Kurasaki / Mjoyufull]
Kyokai has one source-file start symbol.

```ebnf
source file = file docs, {pragma declaration}, {import declaration}, module;
```

A `.kyo` file must match `source file`. Imports are file-scope declarations and appear once per file. A source file must not contain more than one module declaration. `.kai` is not a handwritten source extension; a file presented with that extension, or with the inherited `.aui`/`.aum` extensions, is rejected with a diagnostic that names the single-file model.

> Trace: D52, D78, D179, D537
> Covers: There is one `.kyo` start symbol, imports are file-scope only, Kyokai keeps one module per source file, and the `.kai` interface/body extensions are retired.

`file docs` is zero or more `//!` documentation comments. Declaration documentation uses `///` immediately before the declaration it documents. Documentation comments do not change the grammar category of the item they document.

> Trace: D63
> Covers: Kyokai documentation comments use `//!` and `///` line forms rather than Austral triple-quote docstrings.

## Modules And Imports

[Rikona Kurasaki / Mjoyufull]
A module boundary is sealed. The reader can walk into a file, see its imports at the front, see the module name, and know exactly when the symbol table closes.

```ebnf
module = "module", module name, "is", {declaration}, "seal", ";";
```

> Trace: D9, D52, D78, D537
> Covers: A Kyokai module is `module Name is ... seal;` with `seal;` as the module-boundary terminator; the `module body Name is` header is retired.

Kyokai import syntax has exactly three forms.

```ebnf
import declaration = qualified import | module alias import | selective import;
qualified import = "import", module name, ";";
module alias import = "import", module name, "as", module identifier, ";";
selective import = "import", module name, "(", [import item list], ")", ";";
import item list = import item, {",", import item}, [","];
import item = identifier, ["as", identifier];
```

`import Foo.Bar;` introduces the module for qualified access. `import Foo.Bar as Bar;` introduces the module under the alias `Bar`. `import Foo.Bar (baz, qux as localQux);` introduces only the listed exported names unqualified after applying explicit renames. Wildcard imports, `open`, function-local imports, block-local imports, and expression-local imports do not exist.

> Trace: D78, D179, D214
> Covers: Kyokai imports are file-scope only, have exactly qualified/module-alias/selective forms, reject wildcard or open imports, and report import collisions at the import site.

## Declarations

[Rikona Kurasaki / Mjoyufull]
A module's declarations all live in one file, each with its visibility written on the front. The grammar puts the marker where the reader sees it, so the surface another module can rely on is never a rumor carried by convention. The compiler reads the markers and derives the importable interface; the author writes the contract once.

```ebnf
declaration = declaration docs, [visibility], declaration item;
visibility = "public" | "internal";
declaration item = constant definition
                 | type alias declaration
                 | record declaration
                 | bitrecord declaration
                 | union declaration
                 | extern type declaration
                 | capability declaration
                 | configuration rejection declaration
                 | function definition
                 | typeclass declaration
                 | instance definition
                 | generator definition
                 | test declaration
                 | foreign block
                 | unsafe contract;
```

A declaration prefixed `public` is exported to importing packages. A declaration prefixed `internal` is visible only within the same package. A declaration with no visibility marker is module-private. `public` and `private` are reserved keywords; `internal` remains reserved. Writing `private` explicitly is a compile-time error that names the omit-the-marker rule. Because there is no second body file, top-level functions, constants, instances, and generators are always written as definitions; the bodyless `function declaration` shape survives only inside typeclass `method declaration` signatures and `foreign declaration` entries. Module-level `var` is illegal.

> Trace: D17, D62, D78, D538
> Covers: Kyokai writes visibility per declaration with a private default, reserves `public`/`private`/`internal`, requires top-level definitions to carry their bodies, and forbids module-level mutable variables.

A declaration may carry a declaration-level `when` guard. A false guard makes the declaration semantically absent for the selected target. `when` guards are not statements and are not allowed inside function bodies.

```ebnf
guarded declaration suffix = ["when", expression];
```

> Trace: D19, D19a, D123
> Covers: Kyokai conditional compilation uses whole-file selection, declaration-level `when` guards, and typeclass abstraction, with no body-level target branching.

## Constants, Types, Records, Unions, And Capabilities

[Rikona Kurasaki / Mjoyufull]
Top-level constants are immutable and defined where they are declared, since there is no separate body file to define them in later.

```ebnf
constant definition = "constant", identifier, ":", type, ":=", expression, guarded declaration suffix, ";";
type alias declaration = "type", "alias", type name, [generic parameters], ":=", type, guarded declaration suffix, ";";
extern type declaration = "extern", "type", type name, guarded declaration suffix, ";";
capability declaration = "capability", type name, guarded declaration suffix, ";";
```

A type's representation is hidden with the `opaque` modifier on a `record` or `union` definition (see the record and union grammar below). `opaque` exports the type's nominal identity and universe while sealing its fields or variants outside the defining module. The standalone abstract `type Name : Universe;` interface form is retired: an exported type with a hidden representation is now written `public opaque record` or `public opaque union` in the one source file. `opaque` on a `type alias`, an `extern type`, a `bitrecord`, or a non-type declaration is a compile-time error.

> Trace: D17, D24, D50, D61, D78, D255, D539
> Covers: Kyokai admits constants defined in place, aliases, extern types, and sealed capability declarations, expresses representation hiding through the `opaque` record/union modifier, and keeps capability constructors unforgeable.

Records have three layout classes: ordinary Kyokai records, C-ABI extern records, and byte-tight packed records. These are grammar choices, not backend hints.

```ebnf
record declaration = record header, record body;
record header = [representation modifier], "record", type name, [generic parameters], [":", universe];
representation modifier = "opaque" | "extern" | "packed";
record body = "is", {field declaration}, {projection independence clause}, "build", ";"
            | "(", single field, ")", ":", universe, ";";
field declaration = declaration docs, identifier, ":", type, ";";
single field = identifier, ":", type;
projection independence clause = "projection", "independent", "(", identifier, {",", identifier}, [","], ")", ";";
```

The one-line record form is legal only for a single-field ordinary record. `extern record` and `packed record` use the block form so their layout boundary stays visible. The representation modifiers are mutually exclusive: `opaque` seals the representation outside the defining module, while `extern` and `packed` are ABI/layout modes whose representation is the contract, so `opaque extern record` and `opaque packed record` are rejected.

`projection independent (fieldA, fieldB);` is legal only in the block form of
an ordinary record. The type-system chapter defines the field restrictions and
the pairwise meaning of the relation.

> Trace: D35, D42, D109, D116, D196, D539, D563
> Covers: Kyokai has `record`, `opaque record`, `extern record`, and `packed record`; the representation modifiers are mutually exclusive; single-field records are the nominal wrapper mechanism; ordinary records can declare independently projectable fields; and record declarations close with `build;`.

`bitrecord` declares nominal fixed-width bit-position views over unsigned integer storage.

```ebnf
bitrecord declaration = "bitrecord", type name, ":", bitrecord backing type, "is", {bitrecord item}, "build", ";";
bitrecord backing type = "Nat8" | "Nat16" | "Nat32" | "Nat64";
bitrecord item = "field", identifier, ":", "bit", integer literal, ";"
               | "field", identifier, ":", "bits", integer literal, "..", integer literal, ";"
               | "reserved", "bits", integer literal, "..", integer literal, ";";
```

Bit numbers start at zero at the least-significant bit. Ranges are inclusive. Field and reserved ranges cannot overlap. The declarations chapter defines view types, uncovered-bit policy, raw conversion, borrowing rejection, and lowering.

> Trace: D116, D323
> Covers: `bitrecord Name: NatN is ... build;` is a declaration form with closed item grammar and least-significant-bit numbering.

Unions declare named variants. A variant may carry no payload, one unnamed payload type, or named fields.

```ebnf
union declaration = ["opaque"], "union", type name, [generic parameters], [":", universe], "is", {union variant}, "build", ";";
union variant = "case", constructor name, ";"
              | "case", constructor name, "(", type, ")", ";"
              | "case", constructor name, "is", {field declaration};
```

An `opaque union` exports its nominal identity and universe while sealing its variants and payloads outside the defining module, so external code cannot construct or pattern match it without an exported operation.

> Trace: D47, D54, D65, D131, D539
> Covers: Kyokai sum types are named unions, may be `opaque` to seal their variants, have explicit variant payload forms, close with `build;`, and do not create tuple syntax.

## Functions, Contracts, Typeclasses, And Instances

[Rikona Kurasaki / Mjoyufull]
A function signature is a small contract room: name, parameters, return type, generic obligations, value obligations, then the body, which a top-level function always carries in its one source file.

```ebnf
function declaration = ["receiver"], "function", identifier, [generic parameters], "(", [parameter list], ")", ":", type,
                       [where clause], {contract clause}, guarded declaration suffix, ";";
function definition = ["receiver"], "function", identifier, [generic parameters], "(", [parameter list], ")", ":", type,
                      [where clause], {contract clause}, guarded declaration suffix,
                      "is", block, "qed", ";";
parameter list = parameter, {",", parameter}, [","];
parameter = identifier, ":", type;
contract clause = require clause | ensure clause;
require clause = "require", expression, ";";
ensure clause = "ensure", expression, ";";
```

`receiver function` is the exact receiver-callable export marker. It does not create a method body form, implicit receiver, different calling convention, or hidden lookup lane. The declarations chapter and module chapter restrict where it is legal.

> Trace: D254, D337, D386
> Covers: Receiver-callable UFCS exports use one visible declaration marker without adding receiver declaration sugar.

`require` and `ensure` clauses sit between the signature and the body or terminating semicolon. `result` is available only inside `ensure` clauses for non-`Unit` functions as a read-only view of the produced return value. `old expr` is available only inside `ensure` and only for pure entry-state expressions over `Free` data.

> Trace: D53, D125, D129, D140, D142
> Covers: Kyokai function contracts use `require` and `ensure`, `result` is contextual inside postconditions, `old` snapshots pure entry-state `Free` expressions, and contract failures are TPOE.

Generic parameters use brackets after the declared name. `Type`, `Free`, and `Linear` are parameter constraints. `Auto` is a declaration-site classifier, not a generic bound users can pass around as a loose promise.

```ebnf
generic parameters = "[", generic parameter, {",", generic parameter}, [","], "]";
generic parameter = type parameter | const generic parameter | region parameter;
type parameter = type name, ":", generic classifier;
generic classifier = "Type" | "Free" | "Linear";
const generic parameter = identifier, ":", "Index";
region parameter = identifier, ":", "Region";
where clause = "where", where obligation, {",", where obligation}, [","];
where obligation = type, ":", type name
                 | associated type projection, ":", type name
                 | associated type projection, "==", type;
```

> Trace: D158, D159, D188, D189, D190, D192, D193, D195
> Covers: Kyokai uses rank-1 generic parameter lists, admits explicit `Index` const generic parameters, uses a closed `where` grammar for constraints and associated-type equality, and rejects higher-rank, existential, and opaque return type surfaces.

Typeclasses define contracts. Instances provide witnesses. Both proof bodies close with the same `qed;` boundary as functions when they contain implementation.

```ebnf
typeclass declaration = "typeclass", type name, [generic parameters], "is", {method declaration}, "spec", ";";
method declaration = "method", identifier, [generic parameters], "(", [parameter list], ")", ":", type,
                     [where clause], {contract clause}, ";"
                   | "method", identifier, [generic parameters], "(", [parameter list], ")", ":", type,
                     [where clause], {contract clause}, "is", block, "qed", ";";
instance declaration = "instance", type name, [generic parameters], "for", type, [where clause], guarded declaration suffix, ";";
instance definition = "instance", type name, [generic parameters], "for", type, [where clause], guarded declaration suffix,
                      "is", {method definition}, "qed", ";";
method definition = "method", identifier, [generic parameters], "(", [parameter list], ")", ":", type,
                    [where clause], {contract clause}, "is", block, "qed", ";";
```

> Trace: D182, D195, D214
> Covers: Kyokai typeclasses close with `spec;`, may contain default method bodies, and instances close with `qed;` while remaining subject to ordinary name and visibility rules.

## Foreign Blocks And Unsafe Contracts

[Rikona Kurasaki / Mjoyufull]
Foreign code is a gate, not a hallway. The grammar makes the gate visible, then the unsafe chapter defines what must be audited before anyone is allowed to walk through it.

```ebnf
pragma declaration = "pragma", pragma name, ";";
foreign block = "foreign", string literal, "is", {foreign declaration}, "mon", ";";
foreign declaration = "function", identifier, "(", [parameter list], ")", ":", type, ";"
                    | "constant", identifier, ":", type, ";";
unsafe contract = "unsafe", "contract", type name, "is", {unsafe contract item}, "audit", ";";
unsafe contract item = "covers", unsafe operation key, {unsafe contract field}, ";"
                     | "module_invariant", string literal, {unsafe contract field}, ";"
                     | "additional_invariant", unsafe operation key, {unsafe contract field}, ";";
unsafe contract field = ("assumes" | "requires" | "preserves" | "forbids" | "maps_failure"
                       | "owns" | "borrows" | "transfers" | "target" | "threading" | "lifetime"
                       | "layout" | "reentrancy" | "cleanup" | "exports" | "evidence"), string literal;
unsafe operation key = identifier, {":", identifier};
```

The labels after `covers` and `module_invariant` are position-bound grammar
labels. Outside an already recognized `unsafe contract` item, the same
spellings are ordinary identifiers unless another production reserves them.
Parser recovery must choose one interpretation without name lookup or type
information. A spelling that cannot meet that recovery rule remains globally
reserved.

`foreign "C" is ... mon;` is the portable baseline form. A non-`"C"` ABI string is type-checked against the selected target contract and is rejected unless that contract admits the exact spelling and lowering contract. Raw foreign declarations are legal only in a module marked with `pragma Unsafe_Module;`, and that module must contain source-level unsafe contracts covering the unsafe operations it uses. Unsafe operation keys use compiler-produced colon-separated identifiers such as `foreign:c_open`; source contracts cannot invent a key that matches no operation.

> Trace: D20, D20a, D20b, D127, D242, D242a, D245, D606
> Covers: Kyokai raw FFI uses `foreign "C" is ... mon;`, requires `pragma Unsafe_Module;`, forbids implicit linear ownership transfer and implicit sum-type ABI across raw C, requires audited unsafe contracts, and limits contextual audit labels to one unambiguous grammar position.

## Types

[Rikona Kurasaki / Mjoyufull]
Type syntax names ownership and authority boundaries directly. References are not comments in the margin; they are part of the type.

```ebnf
type = type atom
     | module path
     | type application
     | immutable reference type
     | mutable reference type
     | function pointer type;
type application = type atom, "[", type argument, {",", type argument}, [","], "]";
immutable reference type = "&", "[", type, [",", region], "]";
mutable reference type = "&!", "[", type, [",", region], "]";
function pointer type = "FnPtr", "(", [type list], ")", ":", type;
universe = "Type" | "Free" | "Linear" | "Auto";
```

`&[T]` is an immutable borrow type. `&![T]` is a mutable borrow type. Region arguments may be written when the region chapter admits them; the common spelling omits them. `FnPtr(...) : Ret` is the bare function-pointer surface for C interop and dispatch tables. Tuples do not exist.

> Trace: D14, D21, D47, D126, D131, D187, D195
> Covers: Kyokai type syntax includes explicit immutable and mutable references, a bare `FnPtr` callback form, universe constraints, and no tuple type syntax.

## Statements And Blocks

[Rikona Kurasaki / Mjoyufull]
A block is a sequence of statements. Empty blocks are allowed. Statements end in semicolons unless their closing keyword already includes the semicolon.

```ebnf
block = {statement};
statement = let statement
          | let else statement
          | var statement
          | assignment statement
          | expression statement
          | return statement
          | break statement
          | continue statement
          | defer statement
          | errdefer statement
          | panic statement
          | todo statement
          | unreachable statement
          | debug statement
          | if statement
          | case statement
          | while statement
          | while let statement
          | for range statement
          | for in statement
          | borrow statement
          | taskgroup statement
          | spawn statement
          | select statement
          | wait statement
          | yield statement;
```

> Trace: D9, D16, D180
> Covers: Kyokai has statement-oriented syntax with semicolons, explicit block terminators, empty no-op blocks, and insignificant newlines.

Local immutable binding uses `let`; local mutable binding uses `var`. Assignment is a statement and never an expression.

```ebnf
let statement = "let", pattern, [":", type], ":=", expression, [or clause], ";";
let else statement = "let", pattern, [":", type], ":=", expression, "else", pattern, "do", block, "fi", ";";
var statement = "var", identifier, ":", type, [":=", expression], ";";
assignment statement = place, ":=", expression, ";";
or clause = "or", "return", [identifier, "=>", expression]
          | "or", "break", [loop label]
          | "or", "continue", [loop label];
```

`or return`, `or break`, and `or continue` are statement suffixes for fallible binding forms. They are not general expression operators. Assignment produces no value and cannot be chained.

> Trace: D15, D15a, D58, D59, D60
> Covers: Kyokai has `let...else` and `or ...` fallible binding sugar, statement-only assignment, no binding shadowing, and expression-site `Never` coercion for diverging exits.

Control-flow statements use explicit open and close words.

```ebnf
if statement = "if", expression, "then", block, {"else", "if", expression, "then", block}, ["else", block], "fi", ";";
case statement = "case", expression, "of", {case arm}, "esac", ";";
case arm = "when", pattern, "do", block;
while statement = "while", expression, "do", block, "od", ";";
while let statement = "while", "let", pattern, ":=", expression, "do", block, "od", ";";
for range statement = "for", identifier, "from", expression, ("to" | "below"), expression, "do", block, "od", ";";
for in statement = "for", pattern, "in", expression, "do", block, "od", ";";
```

`case` arms do not have guard clauses. Boolean filtering belongs inside the arm body with `if`. `for ... from ... to ...` is inclusive. `for ... from ... below ...` is exclusive. `for ... in ...` uses the language-defined iterator protocol.

> Trace: D13, D32, D38, D39, D56, D180, D205, D206, D249
> Covers: Kyokai uses `if/fi`, `case/esac`, `while/od`, range loops, `for-in`, exhaustive structural pattern matching, `while let`, and no pattern guards.

Borrow scopes make reference lifetime visible in source.

```ebnf
borrow statement = "borrow", identifier, ":=", borrow expression, "do", block, "drop", ";";
borrow expression = "&read", place | "&write", place | "&reborrow", place;
```

`&read` creates an immutable borrow, `&write` creates a mutable borrow, and
`&reborrow` creates the explicit mutable reborrow admitted by the borrow
chapter. `drop;` ends the lexical borrow scope; it does not destroy a value.
The retired `&place`, `&!place`, and `&~place` creation forms are edition
migration inputs, not alternate current syntax.

> Trace: D7b, D14, D34, D87, D111, D187, D238-D240, D604, D607
> Covers: Kyokai gives immutable borrow, mutable borrow, and reborrow distinct source words; borrow scopes close with the non-destructive `drop;`; and accepted implicit reborrow completions are checked through the elaboration pipeline rather than guessed by syntax.

`defer` and `errdefer` register visible cleanup work. `debug` observes existing values only. `todo`, `panic`, and `unreachable` are explicit fatal or divergent statement forms, not optimizer folklore.

```ebnf
defer statement = "defer", statement;
errdefer statement = "errdefer", statement;
return statement = "return", [expression], ";";
break statement = "break", [loop label], ";";
continue statement = "continue", [loop label], ";";
panic statement = "panic", expression, ";";
todo statement = "todo", [string literal], ";";
unreachable statement = "unreachable", ";";
debug statement = "debug", expression, ";";
```

> Trace: D2, D8, D84, D89, D121, D122, D191, D233, D246
> Covers: Kyokai has visible cleanup statements, explicit divergence and fatal paths, named break/continue labels, debug-observation purity, and implicit `Unit` completion only at the end of `Unit` functions.

## Concurrency Statements

[Rikona Kurasaki / Mjoyufull]
Task syntax is built like a lit room at night: the source shows where children start, what they carry, where the parent waits, and where thread creation can fail.

```ebnf
taskgroup statement = "taskgroup", "do", block, "join", ";";
spawn statement = "spawn", capture list, "do", block, "od", [spawn failure arm], ";";
spawn failure arm = "else", identifier, "do", block, "fi";
capture list = "[", [capture item list], "]";
capture item list = capture item, {",", capture item}, [","];
capture item = identifier | "&", identifier | "&!", identifier;
```

A `spawn` statement is legal only inside a `taskgroup`. Spawn capture lists are mandatory. For spawned tasks, by-value capture and immutable-borrow capture are admitted by the concurrency chapter; mutable `&!` capture is rejected for `spawn` even though closure literals use the same visual capture list family.

> Trace: D3, D88, D164, D235, D248, D252
> Covers: Kyokai uses structured `taskgroup do ... join;`, explicit `spawn [captures] do ... od`, fallible spawn failure arms, 1:1 OS tasks, and no implicit child-task capture.

`select` is the structured channel-wait form. Its exact channel-arm expressions and readiness semantics are defined by the concurrency chapter; this grammar fixes the boundary and arm shape.

```ebnf
select statement = "select", {select arm}, [select timeout arm], "pick", ";";
select arm = "when", expression, "do", block;
select timeout arm = "timeout", "(", expression, ")", "do", block;
wait statement = "wait", {wait arm}, [wait default arm], "wake", ";";
wait arm = "when", expression, "do", block;
wait default arm = "default", "do", block;
```

`select ... pick;` waits on channel operations. `wait ... wake;` waits on Poller readiness tokens, deadline tokens, cancellation-token observation, and target-admitted signal or process readiness tokens. The concurrency chapter defines the closed arm tables and ownership transfer points.

> Trace: D3a, D3b, D90-D93, D283, D342
> Covers: Channel selection and external readiness waiting use separate visible grammar forms with separate semantic arm registries.

## Expressions

[Rikona Kurasaki / Mjoyufull]
Expressions are where Kyokai stays plain on purpose. Calls look like calls. Construction looks like construction. Field access is not secretly pointer syntax. The reader does not need a folklore ladder from C taped to the wall.

```ebnf
expression = literal
           | identifier
           | module path
           | "nil"
           | "true" | "false"
           | "Ok", "(", expression, ")"
           | "Err", "(", expression, ")"
           | "Some", "(", expression, ")"
           | "None"
           | call expression
           | ufcs expression
           | field access expression
           | index expression
           | slice expression
           | record construction
           | union construction
           | array literal
           | closure literal
           | comptime expression
           | static string expression
           | static assert expression
           | build expression
           | unary expression
           | binary expression
           | parenthesized expression;
```

> Trace: D24, D35, D36, D47, D54, D65, D106, D118, D120, D131
> Covers: Kyokai expression grammar includes built-in result/optional constructors, calls, UFCS, field access, indexing, slicing, construction, arrays, closures, compile-time forms, and no tuple expression syntax.

Calls use parentheses. UFCS `receiver.name(args)` is sugar for first-argument function call according to the name-resolution chapter, with the narrow receiver-module fallback only when ordinary imported lookup finds no candidate. Field access uses `.`, including one level of auto-deref through `&[Record]` or `&![Record]`. `->` is not a field-access operator.

```ebnf
call expression = expression, "(", [argument list], ")";
ufcs expression = expression, ".", identifier, "(", [argument list], ")";
field access expression = expression, ".", identifier;
argument list = expression, {",", expression}, [","];
```

> Trace: D7a, D34, D110, D254
> Covers: Kyokai uses call syntax, UFCS as first-argument call sugar with narrow receiver-module fallback, one-level field auto-deref, and no `->` operator.

Record construction uses braces and field names. Record update names the source explicitly with `with source`. Union construction uses braces for multi-field variants, parentheses for one-field variants, and a bare constructor for zero-field variants.

```ebnf
record construction = type, "{", record field init list, [",", "with", expression], [","], "}";
record field init list = [record field init, {",", record field init}];
record field init = identifier, ":", expression | identifier;
union construction = constructor name, "{", record field init list, [","], "}"
                   | constructor name, "(", expression, ")"
                   | constructor name;
array literal = "[", [expression, {",", expression}, [","]], "]";
```

> Trace: D35, D55, D65, D98, D109, D138
> Covers: Kyokai construction uses visible record and union forms, explicit `with source` record update, array literals with length inference only, and no hidden defaults or positional record construction.

Indexing and slicing use brackets. Indexing is the total-or-TPOE surface over the language-defined indexing protocol. Slicing is half-open and checked.

```ebnf
index expression = expression, "[", expression, "]";
slice expression = expression, "[", [expression], "..", [expression], "]";
```

> Trace: D36, D106
> Covers: Kyokai uses `a[i]` indexing and `a[i..j]` half-open slicing through closed checked container protocols.

Closure literals have explicit capture lists. A zero-capture closure writes `[]`.

```ebnf
closure literal = "fn", capture list, "(", [parameter list], ")", ":", type, "is", block, "qed", ";"
                | "fn", capture list, "(", [parameter list], ")", ":", type, "=>", expression;
```

> Trace: D21, D118, D126, D197
> Covers: Kyokai closure literals have mandatory explicit capture lists, block and one-expression forms, and lower to the fixed callable-family substrate.

Compile-time evaluation is visible at the call site. `static_assert` is a compile-time assertion form. `static "..."` is an explicit spelling for the same `StaticString` type produced by plain escaped and raw multiline literals.

```ebnf
comptime expression = "comptime", expression;
static string expression = "static", string literal;
static assert expression = "static_assert", "(", expression, ",", string literal, ")";
```

> Trace: D18, D18a, D120
> Covers: Kyokai uses call-site `comptime`, compile-time static assertions, and explicit `static "..."` text bridging.

Operator precedence is deliberately small.

| Level | Operators |
| --- | --- |
| 1 | postfix `.`, call `(...)`, indexing/slicing `[...]` |
| 2 | prefix `&read`, `&write`, `&reborrow`, `~`, unary `-`, `not`, `bnot` |
| 3 | `*`, `/`, `%` |
| 4 | `+`, binary `-`, `++` |
| 5 | `<`, `<=`, `>`, `>=`, `==`, `!=` |
| 6 | `and` |
| 7 | `or` |

Operators at the same level associate left-to-right unless another rule says otherwise. Comparisons and equality do not chain. Value equality is written `==`; `=` remains specification notation in EBNF and is not a Kyokai source operator. Bitwise, shift, and rotate operators do not mix implicitly with arithmetic, comparison, boolean operators, or each other except for same-operator chaining; parentheses are required.

> Trace: D10, D41, D56, D57
> Covers: Kyokai uses `!=`, short-circuiting boolean operators, keyword bitwise operators, and a limited precedence table with explicit grouping for risky mixes.

## Patterns

[Rikona Kurasaki / Mjoyufull]
Patterns are structural, but they do not become a trapdoor for throwing resources away.

```ebnf
pattern = identifier
        | "ignore"
        | constructor name
        | constructor name, "(", pattern, ")"
        | constructor name, "{", [record pattern fields], [","], "}"
        | "{", [record pattern fields], [","], "}";
record pattern fields = record pattern field, {",", record pattern field};
record pattern field = identifier
                     | identifier, ":", pattern;
```

`ignore` is the discard pattern. `_` is not a pattern token. Nested patterns are allowed. Pattern guards do not exist. Omitting a record field in a pattern is sugar for discarding that field, so it is legal only when the omitted field is `Free`. Linear payloads must be bound and consumed explicitly.

> Trace: D38, D98, D205, D206
> Covers: Kyokai patterns support nested union and record structure, use contextual `ignore`, reject `_`, reject guards, and forbid hidden discard of linear values.

## Generators

[Rikona Kurasaki / Mjoyufull]
A generator is a named iterator declaration. It can pause, but it does not open the door to async, stackful coroutines, or opaque return types.

```ebnf
generator declaration = generator header, [where clause], guarded declaration suffix, ";";
generator definition = generator header, [where clause], guarded declaration suffix, "is", block, "qed", ";";
generator header = "generator", type name, [generic parameters], "(", [parameter list], ")", ":", type;
yield statement = "yield", expression, ";";
```

`yield` is legal only inside a generator body. A `public` or `internal` generator definition exposes the generator's source-level contract in the derived interface, and that same definition creates the nominal linear iterator type and constructor function according to the generator chapter.

> Trace: D32, D118, D193, D198, D249
> Covers: Kyokai has named stackless pull generators with `yield`, nominal linear iterator types, explicit destruction for suspended state, and no general coroutine or async surface.

## Inline Tests

[Rikona Kurasaki / Mjoyufull]
An inline test is a module-private test-build declaration. Its description is a static string literal. A pure test has no parameters. An authority-bearing test spells its capability parameters after `with`; no parameter is inserted by the compiler.

```ebnf
test declaration = "test", static string literal, [test capability clause], "is", block, "qed", ";";
test capability clause = "with", "(", [parameter list], ")";
```

`public test`, `internal test`, and `opaque test` are compile-time errors. Test declarations do not enter the compiler-derived `.koi` interface. Their bodies use ordinary statement grammar and ordinary control-flow restrictions; in particular, a test body is not a generator body, taskgroup, loop, or `build` expression merely because the test harness owns its execution.

> Trace: D28, D137
> Covers: Inline tests use `test "description" [with (...)] is ... qed;`, remain module-private and test-only, expose no derived-interface declaration, and receive only source-declared authority.

## Grammar Forms Not In Kyokai

[Rikona Kurasaki / Mjoyufull]
The grammar intentionally rejects several shapes that would make the language bigger without making programs clearer: tuple syntax, class declarations, inheritance syntax, exceptions, `try/catch`, wildcard imports, block-local imports, macro definitions, pipeline `|>`, body-level target `when`, pattern guards, `_` discard patterns, `Drop` declarations, implicit destructor hooks, general `async`/`await`, and safe module-level mutable globals.

> Trace: D47, D62, D108, D123, D147, D156, D205, D207, D208
> Covers: Kyokai's grammar enforces the accepted non-goals instead of leaving forbidden mechanisms as unclassified parser gaps.

## Configuration And Construction Grammar

The following productions extend the grammar:

```ebnf
configuration rejection declaration = "compile_error", "(", expression, ")", ";" ;
build expression = "build", type, "do", { statement }, "build", ";" ;
produce statement = "produce", expression, ";" ;
```

`compile_error(message);` is legal only at declaration scope and in compile-time-only declaration-guard positions admitted by `when`. Its argument is an ordinary expression whose required static type is `StaticString`; the grammar does not restrict the argument to literal syntax. Reaching it during selected compilation emits the stable `compile_error` diagnostic with the source span and exact static-text message. It is not a runtime statement and has no value.

> Trace: D467
> Covers: Selected configuration rejection has one protected compile-time grammar form.

`build T do ... build;` is an expression. The outer grammar does not require a
direct `produce` statement. Typed control-flow analysis proves that every
reachable normal path executes exactly one compatible `produce expr;`
targeting the nearest enclosing build expression. Production may occur inside
branches. A path with zero, duplicate, or incompatible production is rejected.
Abnormal or diverging exits follow their ordinary cleanup and failure rules and
do not produce a hidden result. General uninitialized declarations such as
`let x;` are illegal. Partial record values, omitted fields, hidden defaults,
and double initialization are illegal.

> Trace: D500, D610
> Covers: Multi-line construction is explicit grammar; branch-local production is legal, and typed control flow proves exactly one compatible result on every reachable normal path.

## Cycle Rejection Grammar

Import cycles and workspace package dependency cycles are illegal. The grammar has no cycle-breaking declaration, recursive import group, signature knot, or alternate package-cycle syntax.

> Trace: D433-D434
> Covers: Module and package cycles are rejected rather than hidden behind a second recursive-module mechanism.
