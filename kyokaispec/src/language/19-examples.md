# Examples

[Rikona Kurasaki / Mjoyufull]
> ProofTrace: SPEC-LANGUAGE-19-EXAMPLES
> Covers: This chapter is registered in the public ProofTrace evidence graph; registration does not claim implementation, conformance, or theorem completion.

Examples are not decoration. They are the street-level view of the rules. A spec can name a thousand doors, but an example shows which key is in whose hand when the program walks through one.

The examples here use one `.kyo` source file per module, per-declaration `public`/`internal` visibility, `seal;`, `qed;`, `build;`, `fi;`, `od;`, `esac;`, `Result`, `Optional`, explicit capabilities, explicit allocators, and contracts. They are small on purpose: each one shows the rule it is standing on instead of trying to be a whole application.

> Trace: D52, D78, D86, D155, D537, D538
> Covers: Examples use the current single-file Kyokai source model with per-declaration visibility and demonstrate rules from the language chapters rather than inherited Austral syntax.

Unless an example declares a helper locally, imported names come from the standard-library contract spec. Those modules are named to make authority, allocation, startup, I/O, and memory surfaces visible; they are not a hidden prelude. An exported declaration carries a `public` marker; an unmarked declaration is module-private.

> Trace: D24, D44, D85, D152, D214, D229, D538
> Covers: Example imports are explicit and do not imply pervasive standard-library injection, and exports are marked `public`.

## Minimal Hosted Program

`App/Main.kyo`:

```kyokai
import Kyokai.Capability (RootCapability, surrenderRoot);
import Kyokai.Memory (Span);
import Kyokai.Process (ExitCode, ExitSuccess);

module App.Main is
    function main(root: RootCapability, args: &[Span[String]]): ExitCode is
        surrenderRoot(root);
        return ExitSuccess;
    qed;
seal;
```

The module is one file. `main` carries no visibility marker: the runtime startup contract selects the entry function by name, not by import, so it does not need `public`. The body surrenders the linear root authority before returning the zero-payload `ExitSuccess` constructor as a bare constructor without parentheses. The unused `args` binding still shows how hosted startup passes arguments instead of making them ambient.

> Trace: D48/D162, D52, D78, D84, D211, D255, D537, D538
> Covers: Hosted startup calls `main(root, args)`, a module is one source file, the entry function needs no visibility marker, and command-line arguments are explicit parameters rather than global functions.

## Contracts And Checked Arithmetic

```kyokai
module Math.Small is
    public function factorial(n: Nat64): Nat64
        require n <= 20n64;
        ensure result >= 1n64;
    is
        var acc: Nat64 := 1n64;
        var i: Nat64 := 1n64;

        while i <= n do
            acc := acc * i;
            i := i + 1n64;
        od;

        return acc;
    qed;
seal;
```

The precondition keeps the multiplication inside the range promised by the function. If the caller violates it, the result is TPOE. If the implementation overflows anyway, that is also TPOE; integer arithmetic does not fall through into C signed-overflow folklore. The signature and its contracts are the part of the derived interface a caller checks against, so they are written once in the one source file.

> Trace: D53, D75, D84, D140, D142, D210, D537
> Covers: Function contracts are always checked, integer arithmetic is same-type and checked, contract failure is not recoverable data, and the signature plus contracts form the derived interface.

## Result Propagation

```kyokai
import Kyokai.Text (ParseError, OutOfRange, parseNat64);

module Parse.Port is
    public function parsePort(text: &[String]): Result[Nat16, ParseError] is
        let wide: Nat64 := parseNat64(text) or return;

        if wide > 65535n64 then
            return Err(OutOfRange);
        fi;

        return Ok(wide.toNat16());
    qed;
seal;
```

`or return` is attached to a `let` statement. It is not an expression operator. The successful path binds the `Ok` payload, and the failure path returns `Err` with the same error type. The narrowing conversion is written by name.

> Trace: D15/D15a, D24, D37, D69, D119, D210
> Covers: `Result` propagation is statement sugar over `Result`, performs no implicit error conversion, and numeric narrowing is explicit.

## Optional And Exhaustive Case

```kyokai
module Lookup.Env is
    public union LookupError: Free is
        case Missing;
        case Empty;
    build;

    public function requireValue(value: Optional[StaticString]): Result[StaticString, LookupError] is
        case value of
            when Some(text) do
                if text.isEmpty() then
                    return Err(Empty);
                fi;

                return Ok(text);
            when None do
                return Err(Missing);
        esac;
    qed;
seal;
```

The `case` is exhaustive over `Some` and `None`. The `StaticString` inside `Some` is ordinary `Free` data, so the branch can inspect it and return it without ownership ceremony. There is no null sentinel and no fallthrough match failure. `LookupError` is `public` because it appears in a `public` function's signature.

> Trace: D24, D38/D205/D206, D71, D98, D194, D195, D538
> Covers: Optional is a built-in sum family, case analysis is exhaustive, payload handling follows the payload universe, and a type named in a public signature is itself public.

## Records And Unions

```kyokai
module Net.Endpoint is
    public record Endpoint: Free is
        host: StaticString;
        port: Nat16;
    build;

    public union ConnectPlan: Free is
        case Disabled;
        case Direct(Endpoint);
        case ViaProxy is
            proxy: Endpoint;
            destination: Endpoint;
    build;

    public function describe(plan: ConnectPlan): StaticString is
        case plan of
            when Disabled do
                return static "disabled";
            when Direct(ep) do
                return ep.host;
            when ViaProxy { proxy, destination: ignore } do
                return proxy.host;
        esac;
    qed;
seal;
```

Record fields are named. Union constructors use bare, single-payload, and named-field forms. The discard pattern is `ignore`, not `_`, and it is legal here because the discarded field is `Free`. `Endpoint` and `ConnectPlan` are `public` because `describe` exposes them; their fields and variants are public API because neither type is marked `opaque`.

> Trace: D35, D38/D205/D206, D54, D65, D120, D194, D539
> Covers: Record and union construction/pattern forms are named, static strings are explicit, discards use contextual `ignore`, and a non-`opaque` public type exposes its representation.

## Opaque Representation

```kyokai
import Kyokai.Text (ValidationError, TooLong, asStaticText);

module Names.UserId is
    public opaque record UserId: Free is
        raw: StaticString;
    build;

    public function makeUserId(text: StaticString): Result[UserId, ValidationError] is
        if text.byteLength() > 64index then
            return Err(TooLong);
        fi;

        return Ok(UserId(raw: text));
    qed;

    public function userIdText(id: &[UserId]): StaticString is
        return asStaticText(id);
    qed;
seal;
```

`UserId` is `public opaque record`, so importers see the name and its `Free` universe but never the `raw` field. They cannot construct, destructure, or inspect it; they enter only through `makeUserId`, which validates, and read it only through `userIdText`. Inside this module the `raw` field is fully visible, which is how the constructor and accessor work. This is the single-file replacement for the old "declare the type in the interface, hide the record in the body" pattern.

> Trace: D17, D466, D539
> Covers: `opaque` exports a type's nominal identity and universe while sealing its representation, validated construction returns recoverable errors, and accessors are named.

## Borrowing And Explicit Cleanup

```kyokai
import Kyokai.Alloc (Allocator, AllocError);
import Kyokai.Memory (Buffer, destroyBuffer, push);

module Buffers.Sum is
    public function makePair(alloc: &![Allocator], left: Nat8, right: Nat8): Result[Buffer[Nat8], AllocError] is
        let buf: Buffer[Nat8] := Buffer.new(alloc, 2index) or return;
        errdefer destroyBuffer(buf);

        push(&!buf, left) or return;
        push(&!buf, right) or return;

        return Ok(buf);
    qed;
seal;
```

The allocator is a visible mutable borrow. The buffer is linear. `errdefer` owns the cleanup path until the success path returns the buffer. The two `push` calls are fallible and keep allocation failure as `Result` data.

> Trace: D2/D2a/D2b, D14, D15/D15a, D44, D74, D195, D246, D250-D251
> Covers: Allocation is explicit, linear buffers need explicit cleanup or return, and `or return` is a structured error exit for `errdefer`.

## Formatting Without A Prelude

```kyokai
import Kyokai.Alloc (Allocator, AllocError);
import Kyokai.Format (format);

module Messages.Greeting is
    public function greeting(alloc: &![Allocator], name: &[String]): Result[String, AllocError] is
        return format(alloc, static "hello, {}", name);
    qed;
seal;
```

`format` takes an allocator because it creates an owned `String`. The template is a `StaticString`, checked at compile time, and the argument must satisfy the formatting protocol. Allocation failure is returned.

> Trace: D40, D40a, D44, D74, D102, D120
> Covers: Allocating formatting is explicit, compile-time checked, and fallible.

## Capability-gated Output

```kyokai
import Kyokai.Capability (RootCapability, surrenderRoot);
import Kyokai.Console (ConsoleCapability, consoleFromRoot, surrenderConsole, writeFmt);
import Kyokai.Memory (Span);
import Kyokai.Process (ExitCode, ExitFailure, ExitSuccess);

module App.Print is
    function main(root: RootCapability, args: &[Span[String]]): ExitCode is
        defer surrenderRoot(root);

        let Ok(console) := consoleFromRoot(&!root) else Err(ignore) do
            return ExitFailure;
        fi;
        defer surrenderConsole(console);

        let Ok(nil) := writeFmt(&!console, static "args: {}", args.length()) else Err(ignore) do
            return ExitFailure;
        fi;

        return ExitSuccess;
    qed;
seal;
```

Production output goes through capability-bearing APIs. The root and console capabilities are surrendered through visible cleanup. Each fallible call is handled with `let...else` because this function returns `ExitCode`, not `Result`. `writeFmt` writes to a capability-bearing stream and returns an explicit I/O result. As the entry function, `main` needs no visibility marker. The example does not use `debug`, because debug instrumentation is profile-sensitive and outside ordinary program output.

> Trace: D15a, D40/D40a/D102, D48/D162, D66, D85, D211, D233, D255, D538
> Covers: I/O authority is explicit, formatted stream output is fallible, `let...else` handles non-Result entrypoint exits, the entry function needs no marker, and debug output is not the production console API.

## Structured Spawn Shape

```kyokai
import Kyokai.Process (ThreadSpawnError);

module Workers.OneShot is
    public function runOnce(): Result[Unit, ThreadSpawnError] is
        taskgroup do
            spawn [] do
                debug static "worker started";
            od else err do
                return Err(err);
            fi;
        join;

        return Ok(nil);
    qed;
seal;
```

The child has an explicit empty capture list. Spawn failure is ordinary `ThreadSpawnError` handled at the spawn site before any child begins. `join;` is the visible blocking boundary, and the child does not produce a hidden join value.

> Trace: D88/D235/D252, D168, D233
> Covers: Structured spawn is capture-explicit, fallible, joined by `join;`, and uses explicit data transport if a child result is needed.

## Layout Introspection And In-Place Constants

```kyokai
module Wire.Header is
    public extern record Header is
        tag: Nat32;
        length: Nat32;
    build;

    public constant HeaderSize: Index := comptime sizeOf(Header);
    public constant LengthOffset: Index := comptime offsetOf(Header, length);
seal;
```

The constants are compile-time layout facts, defined in place because there is no separate body file. Because `Header` is an `extern record`, the facts come from the selected target C ABI contract, not ordinary Kyokai record layout and not backend guessing.

> Trace: D18/D18a, D20a, D42, D80, D537
> Covers: Layout introspection is compile-time-only, follows the declared layout class, and constants are defined in place in the one source file.

## Negative Examples

This is rejected because `Ok` is protected by the language:

```kyokai
let Ok: Nat8 := 1n8;
```

The diagnostic must report that a protected built-in constructor word cannot be rebound.

> Trace: D24, D60, D214
> Covers: Built-in constructor words cannot be shadowed by local bindings.

This is rejected because `module body` is the retired two-file header:

```kyokai
module body App.Main is
    function main(root: RootCapability, args: &[Span[String]]): ExitCode is
        return ExitSuccess;
    qed;
seal;
```

A module is one `.kyo` source file written `module App.Main is ... seal;`. The diagnostic names the single-file model and the retired `module body` header.

> Trace: D537
> Covers: The two-file `module body` header is rejected in favor of the single-file `module` header.

This is rejected because `private` is not written explicitly:

```kyokai
module Demo.Vis is
    private function helper(): Unit is
        return nil;
    qed;
seal;
```

Module-private is the unmarked default, so `helper` is private by writing no marker. The diagnostic names the omit-the-marker rule.

> Trace: D538
> Covers: Private is the unmarked default; writing `private` explicitly is rejected with a guiding diagnostic.

This is rejected because `_` is not a Kyokai discard pattern:

```kyokai
case maybeName of
    when Some(_) do
        return true;
    when None do
        return false;
esac;
```

The programmer writes `ignore` in pattern position, and only when the discarded value may legally be ignored.

> Trace: D38/D205/D206
> Covers: Discard syntax is contextual `ignore`, not underscore.

This is rejected because raw FFI cannot pass a linear Kyokai value by value:

```kyokai
foreign "C" is
    function sendString(text: String): Int32;
mon;
```

A safe wrapper must convert through an explicit C string or byte boundary, state ownership, and live in an unsafe module with an unsafe contract.

> Trace: D20/D20a, D30/D30a, D68, D242, D245
> Covers: Raw C ABI boundaries do not understand Kyokai linear ownership or text invariants.

This is rejected because `String` does not have direct indexing syntax:

```kyokai
let first: Nat8 := name[0index];
```

Text code must choose a named API whose contract says whether it is working in bytes, Unicode scalar values, grapheme clusters, or another domain.

> Trace: D30/D30a, D36/D106/D132
> Covers: Text indexing is not hidden behind byte indexing syntax.

This is rejected because allocation has no hidden default allocator:

```kyokai
let msg: String := format(static "value: {}", n);
```

The allocating form is `format(alloc, template, args...)`, and allocation failure is a `Result`.

> Trace: D40, D44, D74, D250-D251
> Covers: Fresh owned allocation requires an explicit allocator and explicit failure handling.

This is rejected inherited Austral syntax:

```austral
module body Example is
    function main(): ExitCode is
        return ExitSuccess();
    end;
end module body.
```

Kyokai uses one `.kyo` file per module, `module ... is ... seal;`, `qed;` for function bodies, per-declaration `public`/`internal` visibility, and bare zero-payload constructors.

> Trace: D5, D9, D52, D65, D537
> Covers: Kyokai examples use current single-file Kyokai syntax rather than inherited Austral terminators and the two-file forms.

## Example Status And CI Metadata

Repository examples carry one implementation status: `accepted`, `experimental`, `implementation-pending`, or `archived`. An accepted repository example states edition, target, profile, admitted C-toolchain contract when build output is exercised, package requirements, capability requirements, external-tool requirements, expected command, and expected result. It enters compile/check CI when its required implementation exists. A runnable accepted repository example enters execution CI when its declared target and capability fixture exist.

A documentation example carries a separate documentation role: `conformance`, `illustrative`, `historical`, `aspirational`, or `negative`. `conformance` examples are expected to check or run under their declared toolchain contract. `negative` examples are expected to produce their declared diagnostic. `illustrative`, `historical`, and `aspirational` examples are never treated as current compiler-conformance evidence. `kyokai doc --check-examples` validates syntax, imports, feature labels, target and capability requirements, maturity labels, and the admitted execution lane for every documentation example.

`examples/demo/` contains the tour-style runnable example set. `examples/all/` contains aggregate compile/check coverage across basics, ownership, borrowing, capabilities, allocators, text, formatting, files, paths, networking, brokers, poller loops, FFI wrappers, packages, workspaces, tests, diagnostics, generated C, and real tools.

An example is illustrative evidence. The normative chapter remains the authority. Every example that demonstrates a rule links the owning spec section and carries the declared status rather than pretending implementation support exists.

> Trace: D406-D407, D511
> Covers: Example taxonomy, metadata, CI classification, and the distinction between illustration and normative authority are explicit.
