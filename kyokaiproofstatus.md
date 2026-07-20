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
| `FRONTEND-KYOKAI-CONTROL-FLOW-VALIDATION` | `frontend-scaffold-boundary` | `Phase 3 context validation for loop exits, result-propagation loop exits, generator yield, build produce, and structured spawn placement` | `specified` | `prototype` | `planned` | `intended-by-spec` | `yes` | `frontend-semantics` |
| `FRONTEND-KYOKAI-INTERFACE-VALIDATION` | `frontend-scaffold-boundary` | `Phase 3 semantic validation of compiler-derived module interfaces for public/internal visibility leaks, opaque representation hiding, and rejection of private opaque declarations` | `specified` | `prototype` | `planned` | `intended-by-spec` | `yes` | `frontend-semantics` |
| `FRONTEND-KYOKAI-LEXICAL-TOKENS` | `frontend-scaffold-boundary` | `Kyokai Phase 3 lexical boundary for source-byte diagnostics, comments, ASCII identifiers, contextual and reserved words, punctuation, numeric boundaries, literal families, comptime embed builtins, and targeted inherited-form rejection` | `specified` | `prototype` | `planned` | `intended-by-spec` | `yes` | `frontend-lexing` |
| `FRONTEND-KYOKAI-PACKAGE-SOURCE-DISCOVERY` | `frontend-scaffold-boundary` | `Phase 3 Kyokai package-source discovery, workspace member expansion, dependency manifest parsing, and composed frontend loading for package manifest validation, explicit module roots, canonical containment rejection, executable target selection, one-.kyo-per-module discovery, public/internal derived-interface extraction, selected executable-entry shebang policy, retired-.kai rejection, generated-artifact rejection, inherited-extension rejection, module-declaration checks, explicit workspace member loading, and duplicate workspace package-name rejection` | `specified` | `prototype` | `planned` | `intended-by-spec` | `no` | `frontend-source-loading` |
| `FRONTEND-KYOKAI-PHASE3-PIPELINE` | `frontend-boundary` | `Sole Phase 3 composition from Kyokai source text through parsing, structural control-flow validation, local interface validation, and derived-interface declarations` | `specified` | `prototype` | `planned` | `intended-by-spec` | `yes` | `frontend-pipeline` |
| `FRONTEND-KYOKAI-SOURCE-ROLES` | `frontend-scaffold-boundary` | `Kyokai frontend source-file classifier for one handwritten .kyo role, rejected retired .kai and inherited .aui/.aum paths, rejected .koi artifacts, and executable-entry source-byte preparation used by package loading` | `specified` | `prototype` | `planned` | `intended-by-spec` | `no` | `frontend-source-loading` |
| `FRONTEND-KYOKAI-SOURCE-TEXT` | `frontend-scaffold-boundary` | `Kyokai source-byte contract for UTF-8 validation, BOM rejection, newline validation, scalar-column diagnostics, and manifest-selected executable-entry shebang handling` | `specified` | `prototype` | `planned` | `intended-by-spec` | `yes` | `frontend-source-loading` |
| `FRONTEND-KYOKAI-SURFACE-AST` | `frontend-boundary` | `Span-carrying Phase 3 surface AST for imports, declarations, types, expressions, patterns, and statements` | `specified` | `prototype` | `planned` | `intended-by-spec` | `yes` | `frontend-ast` |
| `FRONTEND-KYOKAI-SURFACE-PARSER` | `frontend-scaffold-boundary` | `Kyokai Phase 3 surface parser for the single .kyo source-file start symbol, imports, module boundaries, declaration visibility, span-carrying declarations, types, expressions, patterns, statements, inline tests with explicit capability parameters, and semantic terminators` | `specified` | `prototype` | `planned` | `intended-by-spec` | `yes` | `frontend-parsing` |
| `PACKAGE-LOCKFILE-SCAFFOLD` | `package-manager-scaffold-boundary` | `Deterministic Kyokai lockfile scaffold using the final D528 [lock], [[root]], [[package]], and [[edge]] record families, with workspace graph rendering, strict parse, repair-as-normalized-render, duplicate package rejection, root reference validation, and edge reference validation` | `specified` | `prototype` | `planned` | `intended-by-spec` | `no` | `package-resolution` |
| `PACKAGE-RESOLVER-GRAPH-SCAFFOLD` | `package-manager-scaffold-boundary` | `Final-model package resolver graph scaffold for workspace package instances, workspace dependency edges, deterministic instance and edge IDs, duplicate workspace package rejection, unknown workspace dependency rejection, cycle rejection, and explicit unsupported-lane diagnostics for Git and indexed package dependencies` | `specified` | `prototype` | `planned` | `intended-by-spec` | `no` | `package-resolution` |
| `SPEC-APPENDICES-A-LICENSE` | `spec-chapter` | `kyokaispec/src/project/04-project-licensing.md` | `specified` | `planned` | `none` | `intended-by-spec` | `no` | `spec-maintainers` |
| `SPEC-APPENDICES-C-AUSTRAL-DIFFERENCES` | `spec-chapter` | `kyokaispec/src/appendices/c-austral-differences.md` | `specified` | `planned` | `none` | `intended-by-spec` | `no` | `spec-maintainers` |
| `SPEC-APPENDICES-D-FORMALIZATION-ROADMAP` | `spec-chapter` | `kyokaispec/src/project/03-formalization-roadmap.md` | `specified` | `planned` | `none` | `intended-by-spec` | `no` | `spec-maintainers` |
| `SPEC-APPENDICES-E-GOVERNANCE` | `spec-chapter` | `kyokaispec/src/project/01-governance.md` | `specified` | `planned` | `none` | `intended-by-spec` | `no` | `spec-maintainers` |
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
| `SPEC-PROJECT-00-BOUNDARY` | `spec-chapter` | `kyokaispec/src/project/00-project-boundary.md` | `specified` | `planned` | `none` | `intended-by-spec` | `no` | `spec-maintainers` |
| `SPEC-PROJECT-02-DECISION-TRACEABILITY` | `spec-chapter` | `kyokaispec/src/project/02-decision-traceability.md` | `specified` | `planned` | `none` | `intended-by-spec` | `no` | `spec-maintainers` |
| `SPEC-PROJECT-05-ADMISSION-AND-CHANGE-CONTROL` | `spec-chapter` | `kyokaispec/src/project/05-admission-and-change-control.md` | `specified` | `planned` | `none` | `intended-by-spec` | `no` | `spec-maintainers` |
| `SPEC-PROJECT-06-REFERENCE-PRODUCTS-AND-WORKLOADS` | `spec-chapter` | `kyokaispec/src/project/06-reference-products-and-workloads.md` | `specified` | `planned` | `none` | `intended-by-spec` | `no` | `spec-maintainers` |
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
| `TOOL-CONFORMANCE-FIXTURE-RUNNER` | `conformance-scaffold-boundary` | `Phase 3 fixture runner for executing implementation-gated parser, module, and package cases through the built `kyokai internal conformance-fixture` boundary` | `specified` | `prototype` | `planned` | `intended-by-spec` | `no` | `conformance-infrastructure` |
| `TOOL-KYOKAI-CLI-SCAFFOLD` | `toolchain-cli-boundary` | `Bootstrap Kyokai command boundary for `kyokai --version` plus explicitly internal `frontend-check` and `conformance-fixture` probes` | `specified` | `prototype` | `planned` | `intended-by-spec` | `no` | `toolchain-cli` |
| `TOOL-PHASE3-IDENTITY-CHECK` | `infrastructure-boundary` | `Phase 3 check for Kyokai package and binary identity, internal fixture commands, active compiler ownership, public-path registration, and complete inherited-module transition classification` | `specified` | `implemented` | `none` | `intended-by-spec` | `no` | `compiler-transition` |
| `TOOL-PROOFTRACE-CHECKER` | `infrastructure-boundary` | `ProofTrace registry validation and generated public status board` | `specified` | `implemented` | `none` | `intended-by-spec` | `no` | `prooftrace-tooling` |
| `TOOL-SPEC-CLAUSE-EXTRACTION` | `infrastructure-boundary` | `D577 clause extraction registry validation and generated review sheets for the complete accepted boundary through D635` | `specified` | `implemented` | `none` | `intended-by-spec` | `no` | `spec-extraction-tooling` |

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

Proof artifacts: `kyokaicalculus/paper-proof.md`, `kyokaicalculus/close-and-witness-proof.md`, `kyokaicalculus/call-entry-proof.md`, `kyokaicalculus/primitive-admission-proof.md`, `kyokaicalculus/frame-typing-proof.md`, `kyokaicalculus/source-expression-proof.md`, `kyokaicalculus/equivariance-proof.md`, `kyokaicalculus/theorem-assembly.md`, `kyokaicalculus/reviews/lambda-k-seq-maintainer-review-2026-07-12.md`

No-proof reason: `not-applicable`

Exclusions: The paper proof is narrow to the sequential lambda_K-seq theorem assembled in kyokaicalculus/theorem-assembly.md. Its D581 packet is identified author/lead review by Rikona Kurasaki / Mjoyufull (@mjoyufull), not community or independent qualified-human review. Concurrency, unsafe/FFI, backend lowering, stdlib admission, compiler conformance, toolchain behavior, package management, hosted services, and whole-core Lean mechanization remain excluded from this theorem. The twenty-five executable whole-machine traces and twenty-five Lean spot theorems support the proof but do not replace or mechanically prove Theorem P or Theorem Q.

### `CALC-LEAN-OWNER-SLOT-SPOT`

Scope: Twenty-five named owner-slot, layered-witness, lease-close, call-transfer, path-certificate, and intrinsic-TPOE representation spot theorems

Spec artifacts: `kyokaicalculus/claim-tiers.md`

Implementation artifacts: `kyokaicalculus/lean/KyokaiCalculusSpot.lean`

Test artifacts: `kyokaicalculus/lean/KyokaiCalculusSpot.lean`

Proof artifacts: `kyokaicalculus/lean/KyokaiCalculusSpot.lean`, `kyokaicalculus/lean/lean-toolchain`, `kyokaicalculus/lean/lakefile.toml`

No-proof reason: `not-applicable`

Exclusions: This narrow Lean artifact does not mechanically establish L1-L40, Theorem P, Theorem Q, compiler correctness, backend correctness, or whole-language soundness.

### `FRONTEND-KYOKAI-CONTROL-FLOW-VALIDATION`

Scope: Phase 3 context validation for loop exits, result-propagation loop exits, generator yield, build produce, and structured spawn placement

Spec artifacts: `kyokaispec/src/language/09-expressions-and-evaluation.md`, `kyokaispec/src/language/10-statements-and-control-flow.md`, `kyokaispec/src/language/15-concurrency.md`

Implementation artifacts: `compiler/frontend/semantic/KyokaiControlFlowValidation.ml`, `compiler/package/manifest/KyokaiPackageSource.ml`

Test artifacts: `test/host/frontend/KyokaiControlFlowValidationTest.ml`

Proof artifacts: `none`

No-proof reason: `not-applicable`

Exclusions: This prototype validates structural statement context only. It does not resolve labels, prove divergence, type Result propagation, check refutability or exhaustiveness, enforce deferred-body nonlocal-exit restrictions, account for linear payloads, or establish ownership and cleanup correctness.

### `FRONTEND-KYOKAI-INTERFACE-VALIDATION`

Scope: Phase 3 semantic validation of compiler-derived module interfaces for public/internal visibility leaks, opaque representation hiding, and rejection of private opaque declarations

Spec artifacts: `kyokaispec/src/language/04-modules-and-visibility.md`, `kyokaispec/src/language/05-declarations.md`, `kyokaispec/src/language/06-type-system.md`

Implementation artifacts: `compiler/frontend/semantic/KyokaiInterfaceValidation.ml`, `compiler/package/manifest/KyokaiPackageSource.ml`

Test artifacts: `test/host/frontend/KyokaiInterfaceValidationTest.ml`, `test/conformance/modules/rejected-private-type-leak/fixture.toml`

Proof artifacts: `none`

No-proof reason: `not-applicable`

Exclusions: This Phase 3 boundary validates local declaration visibility over the span-carrying surface AST and the declaration forms represented there. Imported-name resolution, cross-module visibility, complete typeclass and instance semantics, contract typing, .koi serialization, and whole-program semantic checking remain excluded.

### `FRONTEND-KYOKAI-LEXICAL-TOKENS`

Scope: Kyokai Phase 3 lexical boundary for source-byte diagnostics, comments, ASCII identifiers, contextual and reserved words, punctuation, numeric boundaries, literal families, comptime embed builtins, and targeted inherited-form rejection

Spec artifacts: `kyokaispec/src/language/02-lexical-syntax.md`, `kyokaispec/src/toolchain/05-diagnostics.md`

Implementation artifacts: `compiler/frontend/lexer/KyokaiLexicalToken.ml`, `compiler/frontend/lexer/KyokaiLexicalToken.mli`

Test artifacts: `test/host/frontend/KyokaiLexicalTokenTest.ml`, `test/conformance/parser/rejected-inherited-comment/fixture.toml`, `test/conformance/parser/rejected-inherited-form-matrix/fixture.toml`

Proof artifacts: `none`

No-proof reason: `not-applicable`

Exclusions: This Phase 3 boundary is independent of the inherited Austral lexer and feeds the active Kyokai surface parser. It tokenizes the represented literal, keyword, punctuation, comment, and identifier surface and rejects the named inherited forms. Complete documentation attachment, released diagnostic-code integration, formatter integration, exhaustive public fixtures, and Kyokai lexical conformance remain open.

### `FRONTEND-KYOKAI-PACKAGE-SOURCE-DISCOVERY`

Scope: Phase 3 Kyokai package-source discovery, workspace member expansion, dependency manifest parsing, and composed frontend loading for package manifest validation, explicit module roots, canonical containment rejection, executable target selection, one-.kyo-per-module discovery, public/internal derived-interface extraction, selected executable-entry shebang policy, retired-.kai rejection, generated-artifact rejection, inherited-extension rejection, module-declaration checks, explicit workspace member loading, and duplicate workspace package-name rejection

Spec artifacts: `kyokaispec/src/toolchain/01-manifest-package-workspace.md`, `kyokaispec/src/toolchain/02-module-resolution-and-koi.md`, `kyokaispec/src/language/04-modules-and-visibility.md`

Implementation artifacts: `compiler/package/manifest/KyokaiPackageSource.ml`, `compiler/package/manifest/KyokaiPackageSource.mli`

Test artifacts: `test/host/frontend/KyokaiPackageSourceTest.ml`

Proof artifacts: `none`

No-proof reason: `tooling-service-behavior`

Exclusions: This Phase 3 boundary handles one package manifest, an explicit module root, canonical containment, dependency syntax, target selection, one-.kyo-per-module discovery, selected-entry checks, role-sensitive source preparation, the composed Phase 3 frontend, local interface validation, retired-.kai rejection, and explicit workspace-member loading. It does not implement Git/index solving, graph-changing lockfile modes, workspace profile inheritance, profile/target-triple filtering, generated-source admission, cross-module semantic export validation, .koi serialization, package-index behavior, the public check/build/run commands, or conformance-backed status.

### `FRONTEND-KYOKAI-PHASE3-PIPELINE`

Scope: Sole Phase 3 composition from Kyokai source text through parsing, structural control-flow validation, local interface validation, and derived-interface declarations

Spec artifacts: `kyokaispec/src/language/02-lexical-syntax.md`, `kyokaispec/src/language/03-grammar.md`, `kyokaispec/src/language/04-modules-and-visibility.md`

Implementation artifacts: `compiler/frontend/KyokaiFrontend.ml`, `compiler/frontend/KyokaiFrontend.mli`, `compiler/package/manifest/KyokaiPackageSource.ml`

Test artifacts: `test/host/frontend/KyokaiFrontendTest.ml`, `test/host/frontend/KyokaiPackageSourceTest.ml`, `test/conformance/parser/accepted-source-skeleton/fixture.toml`, `test/conformance/parser/rejected-inherited-form-matrix/fixture.toml`

Proof artifacts: `none`

No-proof reason: `not-applicable`

Exclusions: This boundary ends before name resolution, cross-module visibility, typing, elaboration, ownership, .koi production, and lowering. Current fixture execution is supporting evidence, not conformance-backed status.

### `FRONTEND-KYOKAI-SOURCE-ROLES`

Scope: Kyokai frontend source-file classifier for one handwritten .kyo role, rejected retired .kai and inherited .aui/.aum paths, rejected .koi artifacts, and executable-entry source-byte preparation used by package loading

Spec artifacts: `kyokaispec/src/language/02-lexical-syntax.md`, `kyokaispec/src/language/04-modules-and-visibility.md`, `kyokaispec/src/toolchain/02-module-resolution-and-koi.md`

Implementation artifacts: `compiler/frontend/source/KyokaiSourceFile.ml`, `compiler/frontend/source/KyokaiSourceFile.mli`

Test artifacts: `test/host/frontend/KyokaiSourceFileTest.ml`

Proof artifacts: `none`

No-proof reason: `generated-artifact-plumbing`

Exclusions: This Phase 3 boundary classifies source paths and selects source-byte shebang policy from the manifest-selected executable entry before the active Kyokai frontend runs. It defines no public CLI encoding for source sets, produces no .koi artifact, grants no package conformance status, and does not change lambda_K-seq.

### `FRONTEND-KYOKAI-SOURCE-TEXT`

Scope: Kyokai source-byte contract for UTF-8 validation, BOM rejection, newline validation, scalar-column diagnostics, and manifest-selected executable-entry shebang handling

Spec artifacts: `kyokaispec/src/language/02-lexical-syntax.md`, `kyokaispec/src/toolchain/05-diagnostics.md`

Implementation artifacts: `compiler/frontend/source/KyokaiSourceText.ml`, `compiler/frontend/source/KyokaiSourceText.mli`

Test artifacts: `test/host/frontend/KyokaiSourceTextTest.ml`

Proof artifacts: `none`

No-proof reason: `not-applicable`

Exclusions: This Phase 3 boundary validates source bytes and receives role-gated shebang policy from package discovery before feeding the active Kyokai lexer and parser. It does not replace the inherited bootstrap compiler outside the active Kyokai frontend, implement formatter recovery, define released diagnostic codes, provide display-width presentation, or make implementation-gated fixtures conformance evidence.

### `FRONTEND-KYOKAI-SURFACE-AST`

Scope: Span-carrying Phase 3 surface AST for imports, declarations, types, expressions, patterns, and statements

Spec artifacts: `kyokaispec/src/language/03-grammar.md`, `kyokaispec/src/language/05-declarations.md`, `kyokaispec/src/language/09-expressions-and-evaluation.md`, `kyokaispec/src/language/10-statements-and-control-flow.md`

Implementation artifacts: `compiler/frontend/ast/KyokaiSurfaceAst.ml`, `compiler/frontend/ast/KyokaiSurfaceAst.mli`

Test artifacts: `test/host/frontend/KyokaiSurfaceParserTest.ml`, `test/host/frontend/KyokaiFrontendTest.ml`

Proof artifacts: `none`

No-proof reason: `not-applicable`

Exclusions: The surface AST records syntax and source origin only. Resolution, typing, D238 elaboration, ownership, .koi encoding, and backend IR are separate later boundaries.

### `FRONTEND-KYOKAI-SURFACE-PARSER`

Scope: Kyokai Phase 3 surface parser for the single .kyo source-file start symbol, imports, module boundaries, declaration visibility, span-carrying declarations, types, expressions, patterns, statements, inline tests with explicit capability parameters, and semantic terminators

Spec artifacts: `kyokaispec/src/language/02-lexical-syntax.md`, `kyokaispec/src/language/03-grammar.md`, `kyokaispec/src/language/05-declarations.md`, `kyokaispec/src/toolchain/05-diagnostics.md`, `kyokaispec/src/toolchain/07-testing-coverage-bench.md`

Implementation artifacts: `compiler/frontend/parser/KyokaiSurfaceParser.ml`, `compiler/frontend/parser/KyokaiSurfaceParser.mli`

Test artifacts: `test/host/frontend/KyokaiSurfaceParserTest.ml`, `test/host/frontend/KyokaiControlFlowValidationTest.ml`, `test/conformance/parser/function-signature-summary/fixture.toml`, `test/conformance/parser/structured-reference-and-fnptr/fixture.toml`, `test/conformance/parser/record-summary/fixture.toml`, `test/conformance/parser/union-summary/fixture.toml`, `test/conformance/parser/inline-test-summary/fixture.toml`, `test/conformance/parser/rejected-inherited-form-matrix/fixture.toml`, `test/conformance/parser/rejected-extra-syntax-matrix/fixture.toml`

Proof artifacts: `none`

No-proof reason: `not-applicable`

Exclusions: This Phase 3 parser replaces the inherited interface/body parser on the active Kyokai source path and produces the span-carrying surface AST consumed by KyokaiFrontend. Name and type resolution, D238 elaboration, ownership checking, test discovery and lowering, complete documentation attachment, released diagnostic codes, .koi serialization, formatter CST/recovery needs, and parser conformance remain excluded.

### `PACKAGE-LOCKFILE-SCAFFOLD`

Scope: Deterministic Kyokai lockfile scaffold using the final D528 [lock], [[root]], [[package]], and [[edge]] record families, with workspace graph rendering, strict parse, repair-as-normalized-render, duplicate package rejection, root reference validation, and edge reference validation

Spec artifacts: `kyokaispec/src/toolchain/01-manifest-package-workspace.md`, `kyokaispec/src/toolchain/03-cli.md`, `kyokaispec/src/toolchain/09-reproducibility-incremental-builds.md`

Implementation artifacts: `compiler/package/lockfile/KyokaiPackageLockfile.ml`, `compiler/package/lockfile/KyokaiPackageLockfile.mli`

Test artifacts: `test/host/frontend/KyokaiPackageLockfileTest.ml`, `test/conformance/packages/workspace-lockfile-graph/fixture.toml`

Proof artifacts: `none`

No-proof reason: `tooling-service-behavior`

Exclusions: This prototype renders, parses, validates, and repairs a deterministic lockfile subset for workspace package graphs. It does not implement graph-changing resolver modes, selected package updates, Git source hash validation, indexed package source records, package-index snapshot verification, feature resolution, yanks/advisories/capability-deny policy validation, lockfile merge repair from two graph inputs, package commands, public CLI execution, or conformance-backed evidence.

### `PACKAGE-RESOLVER-GRAPH-SCAFFOLD`

Scope: Final-model package resolver graph scaffold for workspace package instances, workspace dependency edges, deterministic instance and edge IDs, duplicate workspace package rejection, unknown workspace dependency rejection, cycle rejection, and explicit unsupported-lane diagnostics for Git and indexed package dependencies

Spec artifacts: `kyokaispec/src/toolchain/01-manifest-package-workspace.md`, `kyokaispec/src/toolchain/10-package-index-semver-releases-ci.md`

Implementation artifacts: `compiler/package/resolver/KyokaiPackageResolution.ml`, `compiler/package/resolver/KyokaiPackageResolution.mli`

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

Scope: Phase 3 fixture runner for executing implementation-gated parser, module, and package cases through the built `kyokai internal conformance-fixture` boundary

Spec artifacts: `test/conformance/SCHEMA.md`, `kyokaispec/src/toolchain/07-testing-coverage-bench.md`

Implementation artifacts: `toolchain/conformance/stage_runner/KyokaiConformanceStage.ml`, `toolchain/conformance/stage_runner/KyokaiConformanceStageLib.ml`, `toolchain/conformance/stage_runner/dune`, `Makefile`, `toolchain/conformance/run_fixtures.py`

Test artifacts: `test/conformance/parser/accepted-source-skeleton/fixture.toml`, `test/conformance/parser/rejected-inherited-comment/fixture.toml`, `test/conformance/parser/source-span-skeleton/fixture.toml`, `test/conformance/parser/function-signature-summary/fixture.toml`, `test/conformance/parser/record-summary/fixture.toml`, `test/conformance/parser/union-summary/fixture.toml`, `test/conformance/modules/package-source-discovery/fixture.toml`, `test/conformance/modules/rejected-executable-entry-missing/fixture.toml`, `test/conformance/modules/rejected-generated-koi/fixture.toml`, `test/conformance/modules/rejected-retired-kai/fixture.toml`, `test/conformance/modules/rejected-module-name-mismatch/fixture.toml`, `test/conformance/packages/workspace-lockfile-graph/fixture.toml`

Proof artifacts: `none`

No-proof reason: `bootstrap-harness`

Exclusions: This runner executes all current implementation-gated parser, module, and package fixtures through the built Kyokai binary's internal fixture command and compares machine-readable expected-result fields. It reports those passes as supporting evidence only. It does not implement the public kyokai check command, active conformance status, released diagnostic-code matching, Git or indexed dependency execution, type checking, linearity checking, runtime/backend execution, property testing, fuzzing, or release conformance reporting.

### `TOOL-KYOKAI-CLI-SCAFFOLD`

Scope: Bootstrap Kyokai command boundary for `kyokai --version` plus explicitly internal `frontend-check` and `conformance-fixture` probes

Spec artifacts: `kyokaispec/src/toolchain/03-cli.md`, `test/conformance/SCHEMA.md`

Implementation artifacts: `bin/kyokai.ml`, `bin/dune`, `toolchain/conformance/stage_runner/KyokaiConformanceStageLib.ml`

Test artifacts: `test/conformance/parser/accepted-source-skeleton/fixture.toml`, `toolchain/identity/check_phase3_identity.py`

Proof artifacts: `none`

No-proof reason: `bootstrap-harness`

Exclusions: The frontend and fixture probes are internal bootstrap commands. They do not implement or reserve the public kyokai check/build/run contracts, full diagnostic-code matching, package graph commands, type checking, linearity checking, backend execution, active conformance status, release reporting, or installed-toolchain behavior.

### `TOOL-PHASE3-IDENTITY-CHECK`

Scope: Phase 3 check for Kyokai package and binary identity, internal fixture commands, active compiler ownership, public-path registration, and complete inherited-module transition classification

Spec artifacts: `phase.md`, `CODE_STANDARDS.md`, `docs/compiler-pipeline-inventory.md`, `docs/compiler-transition-inventory.toml`

Implementation artifacts: `toolchain/identity/check_phase3_identity.py`, `Makefile`

Test artifacts: `toolchain/identity/check_phase3_identity.py`

Proof artifacts: `none`

No-proof reason: `bootstrap-harness`

Exclusions: This check validates repository identity and ownership metadata. It does not establish language conformance, self-hosting, backend correctness, or completion of later compiler phases.

### `TOOL-PROOFTRACE-CHECKER`

Scope: ProofTrace registry validation and generated public status board

Spec artifacts: `kyokaispec/src/project/03-formalization-roadmap.md`

Implementation artifacts: `toolchain/prooftrace/check_prooftrace.py`, `kyokaiproofstatus.toml`, `kyokaiproofstatus.md`, `Makefile`, `.github/workflows/build-and-test.yml`

Test artifacts: `toolchain/prooftrace/check_prooftrace.py`

Proof artifacts: `none`

No-proof reason: `generated-artifact-plumbing`

Exclusions: Registry validation checks evidence metadata consistency. It does not prove the referenced language rules or implementations.

### `TOOL-SPEC-CLAUSE-EXTRACTION`

Scope: D577 clause extraction registry validation and generated review sheets for the complete accepted boundary through D635

Spec artifacts: `kyokaispec/src/project/01-governance.md`, `kyokaispec/src/project/02-decision-traceability.md`

Implementation artifacts: `toolchain/spec/check_clause_extraction.py`, `toolchain/spec/bootstrap_pre_d558_registry.py`, `kyokaispec/extraction/pre-d558.toml`, `kyokaispec/extraction/pre-d558-review.md`, `kyokaispec/extraction/d558-d625.toml`, `kyokaispec/extraction/d558-d625-review.md`, `kyokaispec/extraction/d627-d635.toml`, `kyokaispec/extraction/d627-d635-review.md`, `Makefile`, `kyokaispec/Makefile`, `CI/linux-bootstrap.sh`, `.github/workflows/spec-integrity.yml`

Test artifacts: `toolchain/spec/check_clause_extraction.py`

Proof artifacts: `none`

No-proof reason: `generated-artifact-plumbing`

Exclusions: The checker establishes extraction-record completeness and stale-view detection for the pre-D558, D558-D625, and D627-D635 registries. It does not establish implementation, conformance, admission, service readiness, workload evidence, or proof; semantic fidelity remains a human review duty.
