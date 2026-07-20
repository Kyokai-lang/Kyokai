# Goals And Non-Goals

[Rikona Kurasaki / Mjoyufull]
> ProofTrace: SPEC-LANGUAGE-01-GOALS-AND-NON-GOALS
> Covers: This chapter is registered in the public ProofTrace evidence graph; registration does not claim implementation, conformance, or theorem completion.

Kyokai retains Austral's goals of linear resource safety, explicit modules, capability security, strict checking, and a restrained language model. It extends their scope with a normative toolchain, a batteries-included standard-library contract, explicit runtime-failure categories, and a stronger no-language-level-UB requirement. Every inherited goal that remains part of Kyokai is restated in this specification.

> Trace: D5, D86, D145, D155
> Covers: Kyokai is both a hard fork and a continuation of compatible Austral design goals, and the Kyokai spec must restate inherited rules directly so it stands alone as a full language specification.

[Rikona Kurasaki / Mjoyufull]
The first goal is fits-in-head simplicity. Borretti's Austral phrase still names the real test: a programmer can understand the language model from this specification without compiler archaeology or a second language manual. Kyokai is larger than Austral because it also specifies the toolchain and batteries-included standard library, so simplicity cannot mean smallness alone. It means few overlapping mechanisms, one explicit surface for each semantic job, and no silent second mechanism beneath the first.

> Trace: D5, D86, D87, D147
> Covers: Kyokai keeps the inherited simplicity goal while applying it to a larger self-contained language, toolchain, and stdlib spec; simplicity means low overlapping mechanism count and directly specified behavior, not dependence on Austral as an external manual.

[Rikona Kurasaki / Mjoyufull]
The second goal is readability. Borretti's Austral line is still clean: "We are not typists, we are programmers." Kyokai optimizes for code that can be read under pressure, even when that costs a few extra characters. Terminators, explicit borrows, explicit capabilities, explicit failure arms, and named construction all follow the same rule: the source shows the boundary that matters.

> Trace: D9, D11a, D14, D15, D15a, D35, D53, D145
> Covers: Kyokai keeps readability as a design goal and favors visible boundaries in syntax, ownership, construction, contracts, and failure handling.

The third goal is defined safe execution. A safe Kyokai program accepted by a conforming implementation must have specified language behavior. Runtime checks may fail, contracts may terminate, allocation may return explicit errors, and unsafe contracts may impose obligations, but safe source code must not fall through a gap where the language refuses to say what happens.

> Trace: D84, D87, D139, D143/D241, D228, D253, D262
> Covers: Kyokai rejects language-level undefined behavior for safe programs, defines panic/TPOE/fatal outcomes, requires backend lowering that preserves Kyokai semantics, and records formalization work as a required pre-`v1.0` obligation.

The fourth goal is explicit ownership. Linear values must be consumed exactly through visible language operations. Kyokai does not insert hidden destructors, hidden copies, hidden `Drop` calls, or invisible cleanup at ordinary scope exit. Cleanup helpers such as `defer` and `errdefer` are source-level control-flow constructs with explicit checker states and specified exit behavior.

> Trace: D2, D2b, D15, D15a, D87, D124, D207, D208, D227, D246
> Covers: Kyokai uses visible cleanup constructs, rejects implicit destruction, specifies defer and errdefer states and exit-path behavior, and keeps ownership effects explicit in source.

The fifth goal is explicit authority. Code does not receive ambient access to the machine merely because it exists in the process. Files, environment variables, process creation, randomness, wall-clock time, dynamic loading, unsafe operations, and similar authority-bearing operations must be reachable through explicit capabilities, handles, unsafe contracts, or standard-library APIs whose contracts say what authority is required.

> Trace: D45, D67, D95, D113a, D113b, D162, D171, D172, D173, D178, D211, D212, D245, D255, D256
> Covers: Kyokai uses capability values and sealed authority tokens, startup mints root authority explicitly, stdlib authority APIs require explicit capabilities, unsafe operations require audited unsafe contracts, and capabilities are not forgeable from raw bits.

[Rikona Kurasaki / Mjoyufull]
The sixth goal is correctness through mechanical aid. Human review matters, but tired people under schedule pressure cannot be the only line between a program and memory corruption, authority leaks, or broken resource lifetimes. Kyokai follows Austral's restraint here: type checking, linearity checking, capability checking, contracts, static assertions, runtime checks, and formalization all exist because the machine shoulders every rule it can check without making the language too tangled to implement or understand.

> Trace: D53, D84, D87, D143/D241, D145, D211, D229
> Covers: Kyokai uses mechanical checks for correctness and security while balancing those checks against implementability, specification clarity, and the no-language-UB contract.

The seventh goal is honest implicitness. Kyokai is not a language where every convenience is banned. It is a language where omitted operations are allowed only when the missing operation is forced by the surrounding program and does not add hidden control flow, allocation, or side effects. This permits ergonomics such as carefully bounded reborrows and implicit `Unit` completion while rejecting guesswork.

> Trace: D7b, D8, D12, D34, D46, D87, D187, D238, D239, D240
> Covers: Kyokai admits only tautological effect-neutral implicit completions, including selected borrow and inference conveniences, and checks those completions through a fixed elaboration pipeline.

[Rikona Kurasaki / Mjoyufull]
The eighth goal is maintainability. Stable module and package interfaces, versioned artifacts, explicit contracts, editions, and a governed standard-library surface keep implementation custom from becoming an undocumented compatibility requirement. New mechanisms must justify their maintenance and compatibility cost before admission.

> Trace: D78, D79, D85, D86, D105, D147, D155, D229
> Covers: Kyokai treats stable interfaces, explicit artifacts, editions, package/workspace boundaries, stdlib contracts, and public decision governance as maintainability requirements.

[Rikona Kurasaki / Mjoyufull]
The ninth goal is modularity. Kyokai retains Austral's interface-first checking: one module can type-check against another module's published surface without seeing its private implementation. A module has one `.kyo` source file, and the compiler derives the checked interface rather than requiring a second handwritten file. Per-declaration `public` and `internal` visibility, deterministic module resolution, and `.koi` artifacts complete that boundary.

> Trace: D17, D52, D78, D79, D179, D214
> Covers: Kyokai preserves Austral's module-interface/module-body separation while specifying file extensions, import forms, visibility, module resolution, and interface artifacts as Kyokai rules.

[Rikona Kurasaki / Mjoyufull]
The tenth goal is strictness with purpose. Kyokai rejects a program when a boundary is ambiguous, a resource has not been consumed, an import collision makes name resolution unstable, a contract fails, or target selection does not produce one legal declaration. Each rejection must identify the violated rule; strictness without an explainable rule is not a goal.

> Trace: D15a, D17, D19a, D53, D60, D78, D87, D214, D246
> Covers: Kyokai intentionally rejects ambiguous names, unresolved platform declarations, hidden resource disposal, and vague contracts at compile time or through specified failure paths.

The eleventh goal is production completeness. Kyokai must ship with its core calculus and compiler, package model, diagnostics, formatter, tests, documentation, LSP, audit support, reproducible builds, and a batteries-included systems standard library whose APIs have explicit contracts.

> Trace: D25, D26, D28, D29, D51, D78, D83, D85, D86, D136, D137, D148, D150, D152, D218, D219, D220, D221, D222, D225, D226, D229
> Covers: Kyokai commits to a normative toolchain spec, package/workspace behavior, diagnostics, formatting, testing, docs, LSP, audit, reproducibility, playground support, and a batteries-included stdlib with admission and contract requirements.

The twelfth goal is implementation honesty. The C backend remains important for bootstrap, reference behavior, inspection, and target bring-up, but C does not define Kyokai. Backend and target limitations must be written as backend or target contracts. They must not silently weaken the language or turn accepted safe Kyokai into C undefined behavior.

> Trace: D4, D31, D80, D139, D141, D149, D228
> Covers: Kyokai maintains one generated-C backend, treats optimizing C compilers as admitted external toolchains, and requires generated code and toolchain behavior to preserve Kyokai semantics explicitly.

The thirteenth goal is formal honesty. Kyokai may state intended invariants in prose while the proof work is still being built, but it must not pretend that prose has already discharged the proof burden. Before `v1.0`, Kyokai must produce a paper proof for the sequential ownership-and-borrowing core, with later mechanized proof work after self-hosting.

> Trace: D143/D241
> Covers: Kyokai requires a pre-`v1.0` paper proof for the sequential `lambda_K` core, keeps draft calculus artifacts at the explicit `intended-by-spec` evidence tier until review discharges their named theorems, and plans later mechanization after self-hosting.

Kyokai has the following normative non-goals:

1. No garbage collector.
2. No implicit destructors, `Drop`, or compiler-inserted cleanup calls at ordinary scope exit.
3. No exceptions or stack unwinding.
4. No runtime reflection.
5. No null pointers as an ordinary language value model.
6. No safe ambient global mutable state.
7. No inheritance or class-hierarchy object model.
8. No macro system or syntactic metaprogramming surface.
9. No erased trait-object or hidden runtime-dictionary polymorphism.
10. No competing second mechanism when one explicit mechanism already covers the semantic job.
11. No weakening of safety checks or analysis obligations merely to win compile-time benchmarks.
12. No language-level `async`/`await`, `Future`-style colored concurrency surface, or hidden executor model.

> Trace: D147
> Covers: Kyokai's non-goals are normative project boundaries, not soft preferences; reversing any listed boundary requires a new explicit public decision.

The non-goals are normative for this specification revision. No chapter can quietly cross one of the boundaries above. A later revision must either preserve the boundary, redesign a feature around an existing explicit mechanism, or amend the non-goal while stating the consequences.

> Trace: D147, D155
> Covers: Non-goals may change only through the explicit public decision process, and accepted behavior must remain traceable instead of drifting through adjacent spec edits.

## Evidence-Tier Honesty

Kyokai rejects slogans that hide the actual boundary. The language does not promise that every omitted operation is forbidden. It promises that each admitted implicit completion is closed, compiler-recorded, inspectable, effect-neutral under its rule, and checked after elaboration. Authority, allocation, cleanup, scheduling, dynamic loading, exception-like exits, and safe-code undefined behavior never appear through an unrecorded completion.

The no-language-UB contract is a `SafeCore` scope claim with evidence state `specified` in this document. Broader `SafeConcurrent`, `SafeFFIWrapped`, and `BackendConforming` claims name their own evidence states and artifacts. Compiler status, test status, proof status, and release status remain separate facts.

> Trace: D366-D367, D477-D487, D508
> Covers: Honest implicitness replaces obsolete zero-implicitness wording, and claim labels prevent spec intent from being presented as implementation, conformance, or proof evidence.
