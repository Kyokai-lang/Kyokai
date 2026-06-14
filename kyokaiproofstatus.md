# Kyokai ProofTrace Status

This file is generated from `kyokaiproofstatus.toml`. Do not edit it manually.
ProofTrace records keep specification, implementation, conformance, and proof state separate.
A registered chapter or boundary does not imply that Kyokai implements or proves it.

Schema version: `1`.

| ID | Kind | Scope | Spec | Implementation | Conformance | Proof | Proof Required | Owner |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `BOOTSTRAP-BORROW-DESUGAR` | `inherited-bootstrap-boundary` | `Inherited Austral borrow-desugaring boundary` | `planned` | `inherited-bootstrap` | `none` | `intended-by-spec` | `yes` | `borrow-lowering` |
| `BOOTSTRAP-C-BACKEND` | `inherited-bootstrap-boundary` | `Inherited Austral generated-C boundary under the D530 one-backend architecture` | `planned` | `inherited-bootstrap` | `none` | `intended-by-spec` | `yes` | `backend-c` |
| `BOOTSTRAP-COMPILER-PIPELINE` | `inherited-bootstrap-boundary` | `Inherited Austral compiler orchestration boundary` | `planned` | `inherited-bootstrap` | `none` | `intended-by-spec` | `yes` | `compiler-pipeline` |
| `BOOTSTRAP-E2E-RUNNER` | `harness-boundary` | `Inherited end-to-end compiler test runner` | `planned` | `inherited-bootstrap` | `none` | `intended-by-spec` | `no` | `test-harness` |
| `BOOTSTRAP-LINEARITY-CHECK` | `inherited-bootstrap-boundary` | `Inherited Austral linearity-check boundary` | `planned` | `inherited-bootstrap` | `none` | `intended-by-spec` | `yes` | `linearity-checker` |
| `BOOTSTRAP-RUNTIME-PRELUDE` | `inherited-bootstrap-boundary` | `Inherited Austral runtime prelude and compiler built-ins` | `planned` | `inherited-bootstrap` | `none` | `intended-by-spec` | `yes` | `runtime-bootstrap` |
| `BOOTSTRAP-STDLIB` | `inherited-bootstrap-boundary` | `Inherited Austral standard-library source tree` | `planned` | `inherited-bootstrap` | `none` | `intended-by-spec` | `yes` | `stdlib-bootstrap` |
| `CALC-LAMBDA-K-SEQ` | `proof-boundary` | `lambda_K-seq paper theorem target` | `specified` | `prototype` | `none` | `paper-proven` | `yes` | `lambda_K-seq` |
| `CALC-LEAN-OWNER-SLOT-SPOT` | `proof-artifact` | `Twenty-five named owner-slot, layered-witness, lease-close, call-transfer, path-certificate, and intrinsic-TPOE representation spot theorems` | `specified` | `prototype` | `none` | `mechanically-proven` | `yes` | `lambda_K-mech` |
| `FRONTEND-KYOKAI-INTERFACE-VALIDATION` | `frontend-scaffold-boundary` | `Phase 3 semantic validation of compiler-derived module interfaces for public/internal visibility leaks, opaque representation hiding, and rejection of private opaque declarations` | `specified` | `prototype` | `planned` | `intended-by-spec` | `yes` | `frontend-semantics` |
| `FRONTEND-KYOKAI-LEXICAL-TOKENS` | `frontend-scaffold-boundary` | `Isolated Kyokai lexical token scaffold for source-byte diagnostics, comments, ASCII identifiers, reserved keywords, punctuation, numeric boundaries, literal families, comptime embed builtins, and targeted inherited-form rejection` | `specified` | `prototype` | `planned` | `intended-by-spec` | `yes` | `frontend-lexing` |
| `FRONTEND-KYOKAI-PACKAGE-SOURCE-DISCOVERY` | `frontend-scaffold-boundary` | `Phase 3 Kyokai package-source discovery, workspace member expansion, dependency manifest parsing, and isolated source-set loading scaffold for package manifest validation, explicit module roots, canonical containment rejection, executable target selection, one-.kyo-per-module discovery, public/internal derived-interface extraction, selected executable-entry shebang policy, retired-.kai rejection, generated-artifact rejection, inherited-extension rejection, module-declaration checks, package source skeleton parsing, explicit workspace member loading, and duplicate workspace package-name rejection` | `specified` | `prototype` | `planned` | `intended-by-spec` | `no` | `frontend-source-loading` |
| `FRONTEND-KYOKAI-SOURCE-ROLES` | `frontend-scaffold-boundary` | `Kyokai frontend source-file classifier for one handwritten .kyo role, rejected retired .kai and inherited .aui/.aum paths, rejected .koi artifacts, and executable-entry source-byte preparation` | `specified` | `prototype` | `planned` | `intended-by-spec` | `no` | `frontend-source-loading` |
| `FRONTEND-KYOKAI-SOURCE-TEXT` | `frontend-scaffold-boundary` | `Isolated Kyokai source-byte contract scaffold for UTF-8 validation, BOM rejection, newline validation, scalar-column diagnostics, and manifest-selected executable-entry shebang handling` | `specified` | `prototype` | `planned` | `intended-by-spec` | `yes` | `frontend-source-loading` |
| `FRONTEND-KYOKAI-SURFACE-PARSER` | `frontend-scaffold-boundary` | `Isolated Kyokai surface parser scaffold for the single .kyo source-file start symbol, imports, module boundaries, public/internal/private-by-default visibility, opaque record/union modifiers, top-level definition skeletons, declaration names, structured Type/Free/Linear/Index/Region generic parameters, function signature summaries, named and applied types, anonymous and named-region borrow types, bare function-pointer types, record summaries, union summaries, semantic terminators, and stable parser spans` | `specified` | `prototype` | `planned` | `intended-by-spec` | `yes` | `frontend-parsing` |
| `PACKAGE-LOCKFILE-SCAFFOLD` | `package-manager-scaffold-boundary` | `Deterministic Kyokai lockfile scaffold using the final D528 [lock], [[root]], [[package]], and [[edge]] record families, with workspace graph rendering, strict parse, repair-as-normalized-render, duplicate package rejection, root reference validation, and edge reference validation` | `specified` | `prototype` | `planned` | `intended-by-spec` | `no` | `package-resolution` |
| `PACKAGE-RESOLVER-GRAPH-SCAFFOLD` | `package-manager-scaffold-boundary` | `Final-model package resolver graph scaffold for workspace package instances, workspace dependency edges, deterministic instance and edge IDs, duplicate workspace package rejection, unknown workspace dependency rejection, cycle rejection, and explicit unsupported-lane diagnostics for Git and indexed package dependencies` | `specified` | `prototype` | `planned` | `intended-by-spec` | `no` | `package-resolution` |
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
| `SPEC-RATIONALE-09-BACKEND-CHOICE` | `spec-chapter` | `kyokaispec/src/rationale/09-backend-choice.md` | `specified` | `planned` | `none` | `intended-by-spec` | `no` | `spec-maintainers` |
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
| `SPEC-STDLIB-12-APPLICATION-INTEGRATION-CONTRACTS` | `spec-chapter` | `kyokaispec/src/stdlib/12-application-integration-contracts.md` | `specified` | `planned` | `none` | `intended-by-spec` | `yes` | `spec-maintainers` |
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
| `SPEC-TOOLCHAIN-12-CAPABILITY-DENY-POLICY` | `spec-chapter` | `kyokaispec/src/toolchain/12-capability-deny-policy.md` | `specified` | `planned` | `none` | `intended-by-spec` | `no` | `spec-maintainers` |
| `SPEC-TOOLCHAIN-13-APPLICATION-INTEGRATION-AND-DEPLOYMENT` | `spec-chapter` | `kyokaispec/src/toolchain/13-application-integration-and-deployment.md` | `specified` | `planned` | `none` | `intended-by-spec` | `no` | `spec-maintainers` |
| `TOOL-CONFORMANCE-FIXTURE-CHECKER` | `conformance-scaffold-boundary` | `Conformance fixture metadata checker for required fixture fields, lane placement, input paths, status labels, and ProofTrace references` | `specified` | `prototype` | `planned` | `intended-by-spec` | `no` | `conformance-infrastructure` |
| `TOOL-CONFORMANCE-FIXTURE-RUNNER` | `conformance-scaffold-boundary` | `Prototype conformance fixture runner for executing implementation-gated parser, module, and package fixture scaffolds through an explicit Dune-built compiler-stage frontend/package probe` | `specified` | `prototype` | `planned` | `intended-by-spec` | `no` | `conformance-infrastructure` |
| `TOOL-KYOKAI-CLI-SCAFFOLD` | `toolchain-cli-boundary` | `Bootstrap Kyokai public command scaffold for `kyokai --version`, `kyokai check --conformance-fixture <id>`, and `kyokai check <package-or-workspace-root>` over implementation-gated fixture metadata and the current source/package loading scaffold` | `specified` | `prototype` | `planned` | `intended-by-spec` | `no` | `toolchain-cli` |
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

Scope: Inherited Austral generated-C boundary under the D530 one-backend architecture

Spec artifacts: `kyokaispec/src/language/17-memory-layout-and-backend-contract.md`

Implementation artifacts: `lib/CodeGen.ml`

Test artifacts: `none`

Proof artifacts: `none`

No-proof reason: `not-applicable`

Exclusions: The inherited generator is bootstrap code. It does not establish the D531 C11 subset, D532 compiler admission, D533 source-map/debug contract, D534 performance gates, D535 external-tool evidence, D536 profile mapping, generated-C UB closure, or preservation.

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

### `FRONTEND-KYOKAI-INTERFACE-VALIDATION`

Scope: Phase 3 semantic validation of compiler-derived module interfaces for public/internal visibility leaks, opaque representation hiding, and rejection of private opaque declarations

Spec artifacts: `kyokaispec/src/language/04-modules-and-visibility.md`, `kyokaispec/src/language/05-declarations.md`, `kyokaispec/src/language/06-type-system.md`

Implementation artifacts: `lib/compiler/frontend/semantic/KyokaiInterfaceValidation.ml`, `lib/compiler/package/manifest/KyokaiPackageSource.ml`

Test artifacts: `test/host/frontend/KyokaiInterfaceValidationTest.ml`, `test/conformance/modules/rejected-private-type-leak/fixture.toml`

Proof artifacts: `none`

No-proof reason: `not-applicable`

Exclusions: This prototype validates local declaration visibility through parsed function, record, and union type summaries. Imported-name resolution, type aliases, typeclasses, instances, contracts, final AST checking, .koi serialization, and whole-program semantic checking remain excluded.

### `FRONTEND-KYOKAI-LEXICAL-TOKENS`

Scope: Isolated Kyokai lexical token scaffold for source-byte diagnostics, comments, ASCII identifiers, reserved keywords, punctuation, numeric boundaries, literal families, comptime embed builtins, and targeted inherited-form rejection

Spec artifacts: `kyokaispec/src/language/02-lexical-syntax.md`, `kyokaispec/src/toolchain/05-diagnostics.md`

Implementation artifacts: `lib/compiler/frontend/lexer/KyokaiLexicalToken.ml`, `lib/compiler/frontend/lexer/KyokaiLexicalToken.mli`

Test artifacts: `test/host/frontend/KyokaiLexicalTokenTest.ml`

Proof artifacts: `none`

No-proof reason: `not-applicable`

Exclusions: This prototype is isolated from the inherited lexer and parser. It validates ordinary source input, consumes role-prepared source when requested, and tokenizes the accepted string, raw-string, code-point, and byte literal families. Documentation attachment, parser integration, diagnostic-schema integration, formatter integration, exhaustive conformance fixtures, and Kyokai lexical conformance remain open.

### `FRONTEND-KYOKAI-PACKAGE-SOURCE-DISCOVERY`

Scope: Phase 3 Kyokai package-source discovery, workspace member expansion, dependency manifest parsing, and isolated source-set loading scaffold for package manifest validation, explicit module roots, canonical containment rejection, executable target selection, one-.kyo-per-module discovery, public/internal derived-interface extraction, selected executable-entry shebang policy, retired-.kai rejection, generated-artifact rejection, inherited-extension rejection, module-declaration checks, package source skeleton parsing, explicit workspace member loading, and duplicate workspace package-name rejection

Spec artifacts: `kyokaispec/src/toolchain/01-manifest-package-workspace.md`, `kyokaispec/src/toolchain/02-module-resolution-and-koi.md`, `kyokaispec/src/language/04-modules-and-visibility.md`

Implementation artifacts: `lib/compiler/package/manifest/KyokaiPackageSource.ml`, `lib/compiler/package/manifest/KyokaiPackageSource.mli`

Test artifacts: `test/host/frontend/KyokaiPackageSourceTest.ml`

Proof artifacts: `none`

No-proof reason: `tooling-service-behavior`

Exclusions: This prototype handles one package manifest, one explicit module root, canonical containment rejection, dependency syntax parsing, target selection, one-.kyo-per-module discovery, selected-target entry definition checks, selected executable-entry shebang policy, public/internal declaration extraction for later .koi production, retired-.kai rejection, and explicit workspace-member loading. It does not implement Git/index solving, all graph-changing lockfile modes, workspace profile inheritance, profile/target-triple filtering, generated-source admission, inherited-loader wiring, full final AST construction, expression/type parsing, semantic export validation, .koi serialization, package-index behavior, full public command semantics, or conformance-backed status.

### `FRONTEND-KYOKAI-SOURCE-ROLES`

Scope: Kyokai frontend source-file classifier for one handwritten .kyo role, rejected retired .kai and inherited .aui/.aum paths, rejected .koi artifacts, and executable-entry source-byte preparation

Spec artifacts: `kyokaispec/src/language/02-lexical-syntax.md`, `kyokaispec/src/language/04-modules-and-visibility.md`, `kyokaispec/src/toolchain/02-module-resolution-and-koi.md`

Implementation artifacts: `lib/compiler/frontend/source/KyokaiSourceFile.ml`, `lib/compiler/frontend/source/KyokaiSourceFile.mli`

Test artifacts: `test/host/frontend/KyokaiSourceFileTest.ml`

Proof artifacts: `none`

No-proof reason: `generated-artifact-plumbing`

Exclusions: This prototype classifies individual source paths and selects source-byte shebang policy for a caller-provided executable-entry fact. It deliberately defines no public CLI encoding for source sets. It is not wired into manifest discovery, module loading, executable-target discovery, parsing, .koi generation, or package conformance, and it does not change lambda_K-seq.

### `FRONTEND-KYOKAI-SOURCE-TEXT`

Scope: Isolated Kyokai source-byte contract scaffold for UTF-8 validation, BOM rejection, newline validation, scalar-column diagnostics, and manifest-selected executable-entry shebang handling

Spec artifacts: `kyokaispec/src/language/02-lexical-syntax.md`, `kyokaispec/src/toolchain/05-diagnostics.md`

Implementation artifacts: `lib/compiler/frontend/source/KyokaiSourceText.ml`, `lib/compiler/frontend/source/KyokaiSourceText.mli`

Test artifacts: `test/host/frontend/KyokaiSourceTextTest.ml`

Proof artifacts: `none`

No-proof reason: `not-applicable`

Exclusions: This prototype validates source bytes, receives role-gated shebang policy from the source-role scaffold, and can feed the isolated Kyokai lexical scanner. It is not wired into the inherited lexer, manifest loader, executable-target discovery, parser, formatter, or conformance runner. Display-width columns remain a later toolchain presentation layer.

### `FRONTEND-KYOKAI-SURFACE-PARSER`

Scope: Isolated Kyokai surface parser scaffold for the single .kyo source-file start symbol, imports, module boundaries, public/internal/private-by-default visibility, opaque record/union modifiers, top-level definition skeletons, declaration names, structured Type/Free/Linear/Index/Region generic parameters, function signature summaries, named and applied types, anonymous and named-region borrow types, bare function-pointer types, record summaries, union summaries, semantic terminators, and stable parser spans

Spec artifacts: `kyokaispec/src/language/02-lexical-syntax.md`, `kyokaispec/src/language/03-grammar.md`, `kyokaispec/src/language/05-declarations.md`, `kyokaispec/src/toolchain/05-diagnostics.md`

Implementation artifacts: `lib/compiler/frontend/parser/KyokaiSurfaceParser.ml`, `lib/compiler/frontend/parser/KyokaiSurfaceParser.mli`

Test artifacts: `test/host/frontend/KyokaiSurfaceParserTest.ml`, `test/conformance/parser/function-signature-summary/fixture.toml`, `test/conformance/parser/structured-reference-and-fnptr/fixture.toml`, `test/conformance/parser/record-summary/fixture.toml`, `test/conformance/parser/union-summary/fixture.toml`

Proof artifacts: `none`

No-proof reason: `not-applicable`

Exclusions: This prototype is isolated from the inherited Menhir parser and compiler loader. It parses the one-file module skeleton, declaration visibility and opacity, declaration boundaries, declaration names, structured function-signature summaries, named/applied/borrow/function-pointer type references, structured record summaries, and structured union summaries after Kyokai source-file, source-byte, and lexical scaffolds. Const-generic arguments, associated-type projections, complete generic constraints, final declaration ASTs, expression bodies, D238 elaboration, documentation attachment, diagnostic-schema integration, .koi serialization, and parser conformance remain excluded.

### `PACKAGE-LOCKFILE-SCAFFOLD`

Scope: Deterministic Kyokai lockfile scaffold using the final D528 [lock], [[root]], [[package]], and [[edge]] record families, with workspace graph rendering, strict parse, repair-as-normalized-render, duplicate package rejection, root reference validation, and edge reference validation

Spec artifacts: `kyokaispec/src/toolchain/01-manifest-package-workspace.md`, `kyokaispec/src/toolchain/03-cli.md`, `kyokaispec/src/toolchain/09-reproducibility-incremental-builds.md`

Implementation artifacts: `lib/compiler/package/lockfile/KyokaiPackageLockfile.ml`, `lib/compiler/package/lockfile/KyokaiPackageLockfile.mli`

Test artifacts: `test/host/frontend/KyokaiPackageLockfileTest.ml`, `test/conformance/packages/workspace-lockfile-graph/fixture.toml`

Proof artifacts: `none`

No-proof reason: `tooling-service-behavior`

Exclusions: This prototype renders, parses, validates, and repairs a deterministic lockfile subset for workspace package graphs. It does not implement graph-changing resolver modes, selected package updates, Git source hash validation, indexed package source records, package-index snapshot verification, feature resolution, yanks/advisories/capability-deny policy validation, lockfile merge repair from two graph inputs, package commands, public CLI execution, or conformance-backed evidence.

### `PACKAGE-RESOLVER-GRAPH-SCAFFOLD`

Scope: Final-model package resolver graph scaffold for workspace package instances, workspace dependency edges, deterministic instance and edge IDs, duplicate workspace package rejection, unknown workspace dependency rejection, cycle rejection, and explicit unsupported-lane diagnostics for Git and indexed package dependencies

Spec artifacts: `kyokaispec/src/toolchain/01-manifest-package-workspace.md`, `kyokaispec/src/toolchain/10-package-index-semver-releases-ci.md`

Implementation artifacts: `lib/compiler/package/resolver/KyokaiPackageResolution.ml`, `lib/compiler/package/resolver/KyokaiPackageResolution.mli`

Test artifacts: `test/host/frontend/KyokaiPackageResolutionTest.ml`

Proof artifacts: `none`

No-proof reason: `tooling-service-behavior`

Exclusions: This prototype constructs final-model package instances and dependency edges for explicitly loaded workspace packages only. It rejects Git and indexed dependencies as unsupported resolver lanes instead of resolving them. It does not fetch packages, read package indexes, solve version constraints, apply yanks/advisories/capability-deny policies, select features, read or write lockfiles, produce .koi artifacts, run package graph commands, execute a public CLI command, or provide conformance-backed evidence.

### `TOOL-CONFORMANCE-FIXTURE-CHECKER`

Scope: Conformance fixture metadata checker for required fixture fields, lane placement, input paths, status labels, and ProofTrace references

Spec artifacts: `test/conformance/SCHEMA.md`, `kyokaispec/src/toolchain/07-testing-coverage-bench.md`

Implementation artifacts: `toolchain/conformance/check_fixtures.py`, `Makefile`

Test artifacts: `test/conformance/parser/accepted-source-skeleton/fixture.toml`, `test/conformance/modules/package-source-discovery/fixture.toml`

Proof artifacts: `none`

No-proof reason: `bootstrap-harness`

Exclusions: This checker validates fixture metadata and paths only. It does not execute Kyokai compiler commands, does not validate expected diagnostics, and does not make implementation-gated fixtures count as conformance evidence.

### `TOOL-CONFORMANCE-FIXTURE-RUNNER`

Scope: Prototype conformance fixture runner for executing implementation-gated parser, module, and package fixture scaffolds through an explicit Dune-built compiler-stage frontend/package probe

Spec artifacts: `test/conformance/SCHEMA.md`, `kyokaispec/src/toolchain/07-testing-coverage-bench.md`

Implementation artifacts: `toolchain/conformance/stage_runner/KyokaiConformanceStage.ml`, `toolchain/conformance/stage_runner/KyokaiConformanceStageLib.ml`, `toolchain/conformance/stage_runner/dune`, `Makefile`, `toolchain/conformance/run_fixtures.py`

Test artifacts: `test/conformance/parser/accepted-source-skeleton/fixture.toml`, `test/conformance/parser/rejected-inherited-comment/fixture.toml`, `test/conformance/parser/source-span-skeleton/fixture.toml`, `test/conformance/parser/function-signature-summary/fixture.toml`, `test/conformance/parser/record-summary/fixture.toml`, `test/conformance/parser/union-summary/fixture.toml`, `test/conformance/modules/package-source-discovery/fixture.toml`, `test/conformance/modules/rejected-executable-entry-missing/fixture.toml`, `test/conformance/modules/rejected-generated-koi/fixture.toml`, `test/conformance/modules/rejected-retired-kai/fixture.toml`, `test/conformance/modules/rejected-module-name-mismatch/fixture.toml`, `test/conformance/packages/workspace-lockfile-graph/fixture.toml`

Proof artifacts: `none`

No-proof reason: `bootstrap-harness`

Exclusions: This runner executes the current implementation-gated parser, module, and package fixture scaffolds through a Dune-built compiler-stage OCaml probe and compares machine-readable expected-result fields for supported fixtures. It reports implementation-gated passes as supporting evidence only. It does not implement the public kyokai check command, active conformance status, full diagnostic-code matching, Git or indexed dependency execution, type checking, linearity checking, runtime execution, backend execution, property testing, fuzzing, or release conformance reporting.

### `TOOL-KYOKAI-CLI-SCAFFOLD`

Scope: Bootstrap Kyokai public command scaffold for `kyokai --version`, `kyokai check --conformance-fixture <id>`, and `kyokai check <package-or-workspace-root>` over implementation-gated fixture metadata and the current source/package loading scaffold

Spec artifacts: `kyokaispec/src/toolchain/03-cli.md`, `test/conformance/SCHEMA.md`

Implementation artifacts: `bin/kyokai.ml`, `bin/dune`, `toolchain/conformance/stage_runner/KyokaiConformanceStageLib.ml`

Test artifacts: `test/conformance/parser/accepted-source-skeleton/fixture.toml`

Proof artifacts: `none`

No-proof reason: `bootstrap-harness`

Exclusions: This scaffold exposes a narrow Kyokai command identity for version output, conformance-fixture execution, and source/package loading only. It does not implement semantic kyokai check/build/run behavior, full diagnostic-code matching, package graph commands, type checking, linearity checking, backend execution, active conformance status, release reporting, or installed-toolchain behavior.

### `TOOL-PROOFTRACE-CHECKER`

Scope: ProofTrace registry validation and generated public status board

Spec artifacts: `kyokaispec/src/appendices/d-formalization-roadmap.md`

Implementation artifacts: `toolchain/prooftrace/check_prooftrace.py`, `kyokaiproofstatus.toml`, `kyokaiproofstatus.md`, `Makefile`, `.github/workflows/build-and-test.yml`

Test artifacts: `toolchain/prooftrace/check_prooftrace.py`

Proof artifacts: `none`

No-proof reason: `generated-artifact-plumbing`

Exclusions: Registry validation checks evidence metadata consistency. It does not prove the referenced language rules or implementations.
