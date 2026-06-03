# Kyokai ProofTrace Status

This file is generated from `kyokaiproofstatus.toml`. Do not edit it manually.
ProofTrace records keep specification, implementation, conformance, and proof state separate.
A registered chapter or boundary does not imply that Kyokai implements or proves it.

Schema version: `1`.

| ID | Kind | Scope | Spec | Implementation | Conformance | Proof | Proof Required | Owner |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `BOOTSTRAP-BORROW-DESUGAR` | `inherited-bootstrap-boundary` | `Inherited Austral borrow-desugaring boundary` | `planned` | `inherited-bootstrap` | `none` | `intended-by-spec` | `yes` | `borrow-lowering` |
| `BOOTSTRAP-C-BACKEND` | `inherited-bootstrap-boundary` | `Inherited Austral C-backend generation boundary` | `planned` | `inherited-bootstrap` | `none` | `intended-by-spec` | `yes` | `backend-c` |
| `BOOTSTRAP-COMPILER-PIPELINE` | `inherited-bootstrap-boundary` | `Inherited Austral compiler orchestration boundary` | `planned` | `inherited-bootstrap` | `none` | `intended-by-spec` | `yes` | `compiler-pipeline` |
| `BOOTSTRAP-E2E-RUNNER` | `harness-boundary` | `Inherited end-to-end compiler test runner` | `planned` | `inherited-bootstrap` | `none` | `intended-by-spec` | `no` | `test-harness` |
| `BOOTSTRAP-LINEARITY-CHECK` | `inherited-bootstrap-boundary` | `Inherited Austral linearity-check boundary` | `planned` | `inherited-bootstrap` | `none` | `intended-by-spec` | `yes` | `linearity-checker` |
| `BOOTSTRAP-RUNTIME-PRELUDE` | `inherited-bootstrap-boundary` | `Inherited Austral runtime prelude and compiler built-ins` | `planned` | `inherited-bootstrap` | `none` | `intended-by-spec` | `yes` | `runtime-bootstrap` |
| `BOOTSTRAP-STDLIB` | `inherited-bootstrap-boundary` | `Inherited Austral standard-library source tree` | `planned` | `inherited-bootstrap` | `none` | `intended-by-spec` | `yes` | `stdlib-bootstrap` |
| `CALC-LAMBDA-K-SEQ` | `proof-boundary` | `lambda_K-seq paper theorem target` | `specified` | `prototype` | `none` | `paper-proven` | `yes` | `lambda_K-seq` |
| `CALC-LEAN-OWNER-SLOT-SPOT` | `proof-artifact` | `Twenty-five named owner-slot, layered-witness, lease-close, call-transfer, path-certificate, and intrinsic-TPOE representation spot theorems` | `specified` | `prototype` | `none` | `mechanically-proven` | `yes` | `lambda_K-mech` |
| `FRONTEND-KYOKAI-LEXICAL-TOKENS` | `frontend-scaffold-boundary` | `Isolated Kyokai lexical token scaffold for source-byte diagnostics, comments, ASCII identifiers, reserved keywords, punctuation, numeric boundaries, literal families, comptime embed builtins, and targeted inherited-form rejection` | `specified` | `prototype` | `planned` | `intended-by-spec` | `yes` | `frontend-lexing` |
| `FRONTEND-KYOKAI-SOURCE-ROLES` | `frontend-scaffold-boundary` | `Kyokai frontend source-role classifier for .kyo interfaces, .kai bodies, rejected .koi artifacts, and role-gated source-byte preparation` | `specified` | `prototype` | `planned` | `intended-by-spec` | `no` | `frontend-source-loading` |
| `FRONTEND-KYOKAI-SOURCE-TEXT` | `frontend-scaffold-boundary` | `Isolated Kyokai source-byte contract scaffold for UTF-8 validation, BOM rejection, newline validation, scalar-column diagnostics, and role-gated shebang handling` | `specified` | `prototype` | `planned` | `intended-by-spec` | `yes` | `frontend-source-loading` |
| `SPEC-APPENDICES-A-LICENSE` | `spec-chapter` | `kyokaispec/src/appendices/a-license.md` | `specified` | `planned` | `none` | `intended-by-spec` | `no` | `spec-maintainers` |
| `SPEC-APPENDICES-C-AUSTRAL-DIFFERENCES` | `spec-chapter` | `kyokaispec/src/appendices/c-austral-differences.md` | `specified` | `planned` | `none` | `intended-by-spec` | `no` | `spec-maintainers` |
| `SPEC-APPENDICES-D-FORMALIZATION-ROADMAP` | `spec-chapter` | `kyokaispec/src/appendices/d-formalization-roadmap.md` | `specified` | `planned` | `none` | `intended-by-spec` | `no` | `spec-maintainers` |
| `SPEC-LANGUAGE-00-INTRODUCTION` | `spec-chapter` | `kyokaispec/src/language/00-introduction.md` | `specified` | `planned` | `none` | `intended-by-spec` | `no` | `spec-maintainers` |
| `SPEC-LANGUAGE-01-GOALS-AND-NON-GOALS` | `spec-chapter` | `kyokaispec/src/language/01-goals-and-non-goals.md` | `specified` | `planned` | `none` | `intended-by-spec` | `yes` | `spec-maintainers` |
| `SPEC-LANGUAGE-02-LEXICAL-SYNTAX` | `spec-chapter` | `kyokaispec/src/language/02-lexical-syntax.md` | `specified` | `planned` | `none` | `intended-by-spec` | `yes` | `spec-maintainers` |
| `SPEC-LANGUAGE-03-GRAMMAR` | `spec-chapter` | `kyokaispec/src/language/03-grammar.md` | `specified` | `planned` | `none` | `intended-by-spec` | `yes` | `spec-maintainers` |
| `SPEC-LANGUAGE-04-MODULES-AND-VISIBILITY` | `spec-chapter` | `kyokaispec/src/language/04-modules-and-visibility.md` | `specified` | `planned` | `none` | `intended-by-spec` | `yes` | `spec-maintainers` |
| `SPEC-LANGUAGE-05-DECLARATIONS` | `spec-chapter` | `kyokaispec/src/language/05-declarations.md` | `specified` | `planned` | `none` | `intended-by-spec` | `yes` | `spec-maintainers` |
| `SPEC-LANGUAGE-06-TYPE-SYSTEM` | `spec-chapter` | `kyokaispec/src/language/06-type-system.md` | `specified` | `planned` | `none` | `intended-by-spec` | `yes` | `spec-maintainers` |
| `SPEC-LANGUAGE-07-GENERICS-AND-TYPECLASSES` | `spec-chapter` | `kyokaispec/src/language/07-generics-and-typeclasses.md` | `specified` | `planned` | `none` | `intended-by-spec` | `yes` | `spec-maintainers` |
| `SPEC-LANGUAGE-08-PATTERNS` | `spec-chapter` | `kyokaispec/src/language/08-patterns.md` | `specified` | `planned` | `none` | `intended-by-spec` | `yes` | `spec-maintainers` |
| `SPEC-LANGUAGE-09-EXPRESSIONS-AND-EVALUATION` | `spec-chapter` | `kyokaispec/src/language/09-expressions-and-evaluation.md` | `specified` | `planned` | `none` | `intended-by-spec` | `yes` | `spec-maintainers` |
| `SPEC-LANGUAGE-10-STATEMENTS-AND-CONTROL-FLOW` | `spec-chapter` | `kyokaispec/src/language/10-statements-and-control-flow.md` | `specified` | `planned` | `none` | `intended-by-spec` | `yes` | `spec-maintainers` |
| `SPEC-LANGUAGE-11-LINEARITY-BORROWING-AND-REGIONS` | `spec-chapter` | `kyokaispec/src/language/11-linearity-borrowing-and-regions.md` | `specified` | `planned` | `none` | `intended-by-spec` | `yes` | `spec-maintainers` |
| `SPEC-LANGUAGE-12-IMPLICIT-COMPLETIONS-AND-ELABORATION` | `spec-chapter` | `kyokaispec/src/language/12-implicit-completions-and-elaboration.md` | `specified` | `planned` | `none` | `intended-by-spec` | `yes` | `spec-maintainers` |
| `SPEC-LANGUAGE-13-CONTRACTS-AND-RUNTIME-FAILURE` | `spec-chapter` | `kyokaispec/src/language/13-contracts-and-runtime-failure.md` | `specified` | `planned` | `none` | `intended-by-spec` | `yes` | `spec-maintainers` |
| `SPEC-LANGUAGE-14-CAPABILITIES-AND-AUTHORITY` | `spec-chapter` | `kyokaispec/src/language/14-capabilities-and-authority.md` | `specified` | `planned` | `none` | `intended-by-spec` | `yes` | `spec-maintainers` |
| `SPEC-LANGUAGE-15-CONCURRENCY` | `spec-chapter` | `kyokaispec/src/language/15-concurrency.md` | `specified` | `planned` | `none` | `intended-by-spec` | `yes` | `spec-maintainers` |
| `SPEC-LANGUAGE-16-UNSAFE-FFI-AND-ABI` | `spec-chapter` | `kyokaispec/src/language/16-unsafe-ffi-and-abi.md` | `specified` | `planned` | `none` | `intended-by-spec` | `yes` | `spec-maintainers` |
| `SPEC-LANGUAGE-17-MEMORY-LAYOUT-AND-BACKEND-CONTRACT` | `spec-chapter` | `kyokaispec/src/language/17-memory-layout-and-backend-contract.md` | `specified` | `planned` | `none` | `intended-by-spec` | `yes` | `spec-maintainers` |
| `SPEC-LANGUAGE-18-BUILT-INS` | `spec-chapter` | `kyokaispec/src/language/18-built-ins.md` | `specified` | `planned` | `none` | `intended-by-spec` | `yes` | `spec-maintainers` |
| `SPEC-LANGUAGE-19-EXAMPLES` | `spec-chapter` | `kyokaispec/src/language/19-examples.md` | `specified` | `planned` | `none` | `intended-by-spec` | `no` | `spec-maintainers` |
| `SPEC-RATIONALE-00-RATIONALE-INDEX` | `spec-chapter` | `kyokaispec/src/rationale/00-rationale-index.md` | `specified` | `planned` | `none` | `intended-by-spec` | `no` | `spec-maintainers` |
| `SPEC-RATIONALE-01-LANGUAGE-DESIGN` | `spec-chapter` | `kyokaispec/src/rationale/01-language-design.md` | `specified` | `planned` | `none` | `intended-by-spec` | `no` | `spec-maintainers` |
| `SPEC-RATIONALE-02-SYNTAX` | `spec-chapter` | `kyokaispec/src/rationale/02-syntax.md` | `specified` | `planned` | `none` | `intended-by-spec` | `no` | `spec-maintainers` |
| `SPEC-RATIONALE-03-ERROR-HANDLING-AND-TPOE` | `spec-chapter` | `kyokaispec/src/rationale/03-error-handling-and-tpoe.md` | `specified` | `planned` | `none` | `intended-by-spec` | `no` | `spec-maintainers` |
| `SPEC-RATIONALE-04-LINEAR-RESOURCES` | `spec-chapter` | `kyokaispec/src/rationale/04-linear-resources.md` | `specified` | `planned` | `none` | `intended-by-spec` | `no` | `spec-maintainers` |
| `SPEC-RATIONALE-05-CAPABILITIES` | `spec-chapter` | `kyokaispec/src/rationale/05-capabilities.md` | `specified` | `planned` | `none` | `intended-by-spec` | `no` | `spec-maintainers` |
| `SPEC-RATIONALE-06-CONCURRENCY` | `spec-chapter` | `kyokaispec/src/rationale/06-concurrency.md` | `specified` | `planned` | `none` | `intended-by-spec` | `no` | `spec-maintainers` |
| `SPEC-RATIONALE-07-STDLIB-PHILOSOPHY` | `spec-chapter` | `kyokaispec/src/rationale/07-stdlib-philosophy.md` | `specified` | `planned` | `none` | `intended-by-spec` | `no` | `spec-maintainers` |
| `SPEC-RATIONALE-08-TOOLCHAIN-PHILOSOPHY` | `spec-chapter` | `kyokaispec/src/rationale/08-toolchain-philosophy.md` | `specified` | `planned` | `none` | `intended-by-spec` | `no` | `spec-maintainers` |
| `SPEC-STDLIB-00-STDLIB-OVERVIEW` | `spec-chapter` | `kyokaispec/src/stdlib/00-stdlib-overview.md` | `specified` | `planned` | `none` | `intended-by-spec` | `yes` | `spec-maintainers` |
| `SPEC-STDLIB-01-ADMISSION-CONTRACTS` | `spec-chapter` | `kyokaispec/src/stdlib/01-admission-contracts.md` | `specified` | `planned` | `none` | `intended-by-spec` | `yes` | `spec-maintainers` |
| `SPEC-STDLIB-02-CORE-RESULT-OPTIONAL-DISPLAY-ERROR` | `spec-chapter` | `kyokaispec/src/stdlib/02-core-result-optional-display-error.md` | `specified` | `planned` | `none` | `intended-by-spec` | `yes` | `spec-maintainers` |
| `SPEC-STDLIB-03-ALLOCATORS-AND-MEMORY-CONTAINERS` | `spec-chapter` | `kyokaispec/src/stdlib/03-allocators-and-memory-containers.md` | `specified` | `planned` | `none` | `intended-by-spec` | `yes` | `spec-maintainers` |
| `SPEC-STDLIB-04-TEXT-BYTES-PATHS-AND-STRINGS` | `spec-chapter` | `kyokaispec/src/stdlib/04-text-bytes-paths-and-strings.md` | `specified` | `planned` | `none` | `intended-by-spec` | `yes` | `spec-maintainers` |
| `SPEC-STDLIB-05-COLLECTIONS` | `spec-chapter` | `kyokaispec/src/stdlib/05-collections.md` | `specified` | `planned` | `none` | `intended-by-spec` | `yes` | `spec-maintainers` |
| `SPEC-STDLIB-06-ITERATORS-AND-GENERATORS` | `spec-chapter` | `kyokaispec/src/stdlib/06-iterators-and-generators.md` | `specified` | `planned` | `none` | `intended-by-spec` | `yes` | `spec-maintainers` |
| `SPEC-STDLIB-07-MATH-AND-NUMERICS` | `spec-chapter` | `kyokaispec/src/stdlib/07-math-and-numerics.md` | `specified` | `planned` | `none` | `intended-by-spec` | `yes` | `spec-maintainers` |
| `SPEC-STDLIB-08-IO-FILES-ENV-PROCESS-TIME-RANDOM` | `spec-chapter` | `kyokaispec/src/stdlib/08-io-files-env-process-time-random.md` | `specified` | `planned` | `none` | `intended-by-spec` | `yes` | `spec-maintainers` |
| `SPEC-STDLIB-09-CONCURRENCY-PRIMITIVES` | `spec-chapter` | `kyokaispec/src/stdlib/09-concurrency-primitives.md` | `specified` | `planned` | `none` | `intended-by-spec` | `yes` | `spec-maintainers` |
| `SPEC-STDLIB-10-CRYPTO-POLICY` | `spec-chapter` | `kyokaispec/src/stdlib/10-crypto-policy.md` | `specified` | `planned` | `none` | `intended-by-spec` | `yes` | `spec-maintainers` |
| `SPEC-STDLIB-11-TRANSITIONAL-FFI-TRACKING` | `spec-chapter` | `kyokaispec/src/stdlib/11-transitional-ffi-tracking.md` | `specified` | `planned` | `none` | `intended-by-spec` | `yes` | `spec-maintainers` |
| `SPEC-TOOLCHAIN-00-TOOLCHAIN-OVERVIEW` | `spec-chapter` | `kyokaispec/src/toolchain/00-toolchain-overview.md` | `specified` | `planned` | `none` | `intended-by-spec` | `no` | `spec-maintainers` |
| `SPEC-TOOLCHAIN-01-MANIFEST-PACKAGE-WORKSPACE` | `spec-chapter` | `kyokaispec/src/toolchain/01-manifest-package-workspace.md` | `specified` | `planned` | `none` | `intended-by-spec` | `no` | `spec-maintainers` |
| `SPEC-TOOLCHAIN-02-MODULE-RESOLUTION-AND-KOI` | `spec-chapter` | `kyokaispec/src/toolchain/02-module-resolution-and-koi.md` | `specified` | `planned` | `none` | `intended-by-spec` | `no` | `spec-maintainers` |
| `SPEC-TOOLCHAIN-03-CLI` | `spec-chapter` | `kyokaispec/src/toolchain/03-cli.md` | `specified` | `planned` | `none` | `intended-by-spec` | `no` | `spec-maintainers` |
| `SPEC-TOOLCHAIN-04-BUILD-PROFILES-TARGETS-LINKING` | `spec-chapter` | `kyokaispec/src/toolchain/04-build-profiles-targets-linking.md` | `specified` | `planned` | `none` | `intended-by-spec` | `no` | `spec-maintainers` |
| `SPEC-TOOLCHAIN-05-DIAGNOSTICS` | `spec-chapter` | `kyokaispec/src/toolchain/05-diagnostics.md` | `specified` | `planned` | `none` | `intended-by-spec` | `no` | `spec-maintainers` |
| `SPEC-TOOLCHAIN-06-FORMATTER` | `spec-chapter` | `kyokaispec/src/toolchain/06-formatter.md` | `specified` | `planned` | `none` | `intended-by-spec` | `no` | `spec-maintainers` |
| `SPEC-TOOLCHAIN-07-TESTING-COVERAGE-BENCH` | `spec-chapter` | `kyokaispec/src/toolchain/07-testing-coverage-bench.md` | `specified` | `planned` | `none` | `intended-by-spec` | `no` | `spec-maintainers` |
| `SPEC-TOOLCHAIN-08-DOCS-LSP-AUDIT` | `spec-chapter` | `kyokaispec/src/toolchain/08-docs-lsp-audit.md` | `specified` | `planned` | `none` | `intended-by-spec` | `no` | `spec-maintainers` |
| `SPEC-TOOLCHAIN-09-REPRODUCIBILITY-INCREMENTAL-BUILDS` | `spec-chapter` | `kyokaispec/src/toolchain/09-reproducibility-incremental-builds.md` | `specified` | `planned` | `none` | `intended-by-spec` | `no` | `spec-maintainers` |
| `SPEC-TOOLCHAIN-10-PACKAGE-INDEX-SEMVER-RELEASES-CI` | `spec-chapter` | `kyokaispec/src/toolchain/10-package-index-semver-releases-ci.md` | `specified` | `planned` | `none` | `intended-by-spec` | `no` | `spec-maintainers` |
| `SPEC-TOOLCHAIN-11-BUILD-GENERATION-AND-PLAYGROUND` | `spec-chapter` | `kyokaispec/src/toolchain/11-build-generation-and-playground.md` | `specified` | `planned` | `none` | `intended-by-spec` | `no` | `spec-maintainers` |
| `TOOL-PROOFTRACE-CHECKER` | `infrastructure-boundary` | `ProofTrace registry validation and generated public status board` | `specified` | `implemented` | `none` | `intended-by-spec` | `no` | `prooftrace-tooling` |

## Boundary Details

### `BOOTSTRAP-BORROW-DESUGAR`

Scope: Inherited Austral borrow-desugaring boundary

Spec artifacts: `kyokaispec/src/language/11-linearity-borrowing-and-regions.md`, `kyokaispec/src/language/12-implicit-completions-and-elaboration.md`

Implementation artifacts: `lib/DesugarBorrows.ml`

Test artifacts: `none`

Proof artifacts: `none`

No-proof reason: `not-applicable`

Exclusions: The inherited desugaring pass is bootstrap code and is not a Kyokai conformance claim.

### `BOOTSTRAP-C-BACKEND`

Scope: Inherited Austral C-backend generation boundary

Spec artifacts: `kyokaispec/src/language/17-memory-layout-and-backend-contract.md`

Implementation artifacts: `lib/CodeGen.ml`

Test artifacts: `none`

Proof artifacts: `none`

No-proof reason: `not-applicable`

Exclusions: The inherited generator is bootstrap code. Backend UB closure and preservation evidence remain open.

### `BOOTSTRAP-COMPILER-PIPELINE`

Scope: Inherited Austral compiler orchestration boundary

Spec artifacts: `kyokaispec/src/toolchain/00-toolchain-overview.md`

Implementation artifacts: `lib/Compiler.ml`

Test artifacts: `none`

Proof artifacts: `none`

No-proof reason: `not-applicable`

Exclusions: The inherited pass pipeline is bootstrap code. This marker does not claim Kyokai conformance or proof coverage.

### `BOOTSTRAP-E2E-RUNNER`

Scope: Inherited end-to-end compiler test runner

Spec artifacts: `kyokaispec/src/toolchain/07-testing-coverage-bench.md`

Implementation artifacts: `test-programs/runner.py`

Test artifacts: `none`

Proof artifacts: `none`

No-proof reason: `bootstrap-harness`

Exclusions: Running inherited fixtures does not upgrade a Kyokai rule to conformance-backed.

### `BOOTSTRAP-LINEARITY-CHECK`

Scope: Inherited Austral linearity-check boundary

Spec artifacts: `kyokaispec/src/language/11-linearity-borrowing-and-regions.md`

Implementation artifacts: `lib/LinearityCheck.ml`

Test artifacts: `none`

Proof artifacts: `none`

No-proof reason: `not-applicable`

Exclusions: The inherited checker is not evidence that accepted Kyokai linearity, borrowing, and cleanup rules are implemented.

### `BOOTSTRAP-RUNTIME-PRELUDE`

Scope: Inherited Austral runtime prelude and compiler built-ins

Spec artifacts: `kyokaispec/src/language/16-unsafe-ffi-and-abi.md`, `kyokaispec/src/language/17-memory-layout-and-backend-contract.md`

Implementation artifacts: `lib/prelude.c`, `lib/prelude.h`, `lib/builtin/Memory.aui`, `lib/builtin/Memory.aum`, `lib/builtin/Pervasive.aui`, `lib/builtin/Pervasive.aum`

Test artifacts: `none`

Proof artifacts: `none`

No-proof reason: `not-applicable`

Exclusions: These inherited runtime and built-in files are bootstrap code. Their existence does not establish Kyokai runtime, unsafe-wrapper, ABI, or backend conformance.

### `BOOTSTRAP-STDLIB`

Scope: Inherited Austral standard-library source tree

Spec artifacts: `kyokaispec/src/stdlib/00-stdlib-overview.md`, `kyokaispec/src/stdlib/01-admission-contracts.md`

Implementation artifacts: `standard/src/Bounded.aui`, `standard/src/Bounded.aum`, `standard/src/Box.aui`, `standard/src/Box.aum`, `standard/src/Buffer.aui`, `standard/src/Buffer.aum`, `standard/src/Equality.aui`, `standard/src/Equality.aum`, `standard/src/IO/IO.aui`, `standard/src/IO/IO.aum`, `standard/src/IO/Terminal.aui`, `standard/src/IO/Terminal.aum`, `standard/src/Order.aui`, `standard/src/Order.aum`, `standard/src/String.aui`, `standard/src/String.aum`, `standard/src/StringBuilder.aui`, `standard/src/StringBuilder.aum`, `standard/src/Tuples.aui`, `standard/src/Tuples.aum`

Test artifacts: `none`

Proof artifacts: `none`

No-proof reason: `not-applicable`

Exclusions: The inherited Austral standard-library modules are bootstrap inputs. They are not admitted Kyokai stdlib APIs and do not satisfy Kyokai stdlib conformance or proof requirements.

### `CALC-LAMBDA-K-SEQ`

Scope: lambda_K-seq paper theorem target

Spec artifacts: `kyokaicalculus/scope.md`, `kyokaicalculus/syntax-and-statics.md`, `kyokaicalculus/dynamics.md`, `kyokaicalculus/lemmas.md`

Implementation artifacts: `kyokaicalculus/model_tests.py`, `kyokaicalculus/machine_runner.py`

Test artifacts: `kyokaicalculus/model_tests.py`, `kyokaicalculus/machine_runner.py`

Proof artifacts: `kyokaicalculus/paper-proof.md`, `kyokaicalculus/close-and-witness-proof.md`, `kyokaicalculus/call-entry-proof.md`, `kyokaicalculus/primitive-admission-proof.md`, `kyokaicalculus/frame-typing-proof.md`, `kyokaicalculus/source-expression-proof.md`, `kyokaicalculus/equivariance-proof.md`, `kyokaicalculus/theorem-assembly.md`

No-proof reason: `not-applicable`

Exclusions: The paper proof is narrow to the sequential lambda_K-seq theorem assembled in kyokaicalculus/theorem-assembly.md. Concurrency, unsafe/FFI, backend lowering, stdlib admission, compiler conformance, toolchain behavior, package management, hosted services, and whole-core Lean mechanization remain excluded from this theorem. The twenty-five executable whole-machine traces and twenty-five Lean spot theorems support the proof but do not replace or mechanically prove Theorem P or Theorem Q.

### `CALC-LEAN-OWNER-SLOT-SPOT`

Scope: Twenty-five named owner-slot, layered-witness, lease-close, call-transfer, path-certificate, and intrinsic-TPOE representation spot theorems

Spec artifacts: `kyokaicalculus/claim-tiers.md`

Implementation artifacts: `kyokaicalculus/lean/KyokaiCalculusSpot.lean`

Test artifacts: `kyokaicalculus/lean/KyokaiCalculusSpot.lean`

Proof artifacts: `kyokaicalculus/lean/KyokaiCalculusSpot.lean`, `kyokaicalculus/lean/lean-toolchain`, `kyokaicalculus/lean/lakefile.toml`

No-proof reason: `not-applicable`

Exclusions: This narrow Lean artifact does not mechanically establish L1-L40, Theorem P, Theorem Q, compiler correctness, backend correctness, or whole-language soundness.

### `FRONTEND-KYOKAI-LEXICAL-TOKENS`

Scope: Isolated Kyokai lexical token scaffold for source-byte diagnostics, comments, ASCII identifiers, reserved keywords, punctuation, numeric boundaries, literal families, comptime embed builtins, and targeted inherited-form rejection

Spec artifacts: `kyokaispec/src/language/02-lexical-syntax.md`, `kyokaispec/src/toolchain/05-diagnostics.md`

Implementation artifacts: `lib/KyokaiLexicalToken.ml`, `lib/KyokaiLexicalToken.mli`

Test artifacts: `test/KyokaiLexicalTokenTest.ml`

Proof artifacts: `none`

No-proof reason: `not-applicable`

Exclusions: This prototype is isolated from the inherited lexer and parser. It validates ordinary source input, consumes role-prepared source when requested, and tokenizes the accepted string, raw-string, code-point, and byte literal families. Documentation attachment, parser integration, diagnostic-schema integration, formatter integration, exhaustive conformance fixtures, and Kyokai lexical conformance remain open.

### `FRONTEND-KYOKAI-SOURCE-ROLES`

Scope: Kyokai frontend source-role classifier for .kyo interfaces, .kai bodies, rejected .koi artifacts, and role-gated source-byte preparation

Spec artifacts: `kyokaispec/src/language/02-lexical-syntax.md`, `kyokaispec/src/language/04-modules-and-visibility.md`, `kyokaispec/src/toolchain/02-module-resolution-and-koi.md`

Implementation artifacts: `lib/KyokaiSourceFile.ml`, `lib/KyokaiSourceFile.mli`

Test artifacts: `test/KyokaiSourceFileTest.ml`

Proof artifacts: `none`

No-proof reason: `generated-artifact-plumbing`

Exclusions: This prototype classifies individual source paths and selects source-byte shebang policy for a caller-provided executable-entry fact. It deliberately defines no public CLI encoding for source sets. It is not wired into manifest discovery, module loading, executable-target discovery, parsing, .koi generation, or package conformance, and it does not change lambda_K-seq.

### `FRONTEND-KYOKAI-SOURCE-TEXT`

Scope: Isolated Kyokai source-byte contract scaffold for UTF-8 validation, BOM rejection, newline validation, scalar-column diagnostics, and role-gated shebang handling

Spec artifacts: `kyokaispec/src/language/02-lexical-syntax.md`, `kyokaispec/src/toolchain/05-diagnostics.md`

Implementation artifacts: `lib/KyokaiSourceText.ml`, `lib/KyokaiSourceText.mli`

Test artifacts: `test/KyokaiSourceTextTest.ml`

Proof artifacts: `none`

No-proof reason: `not-applicable`

Exclusions: This prototype validates source bytes, receives role-gated shebang policy from the source-role scaffold, and can feed the isolated Kyokai lexical scanner. It is not wired into the inherited lexer, manifest loader, executable-target discovery, parser, formatter, or conformance runner. Display-width columns remain a later toolchain presentation layer.

### `TOOL-PROOFTRACE-CHECKER`

Scope: ProofTrace registry validation and generated public status board

Spec artifacts: `kyokaispec/src/appendices/d-formalization-roadmap.md`

Implementation artifacts: `tools/check_prooftrace.py`, `kyokaiproofstatus.toml`, `kyokaiproofstatus.md`, `Makefile`, `.github/workflows/build-and-test.yml`

Test artifacts: `tools/check_prooftrace.py`

Proof artifacts: `none`

No-proof reason: `generated-artifact-plumbing`

Exclusions: Registry validation checks evidence metadata consistency. It does not prove the referenced language rules or implementations.
