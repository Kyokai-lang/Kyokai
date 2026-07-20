# D627-D635 Clause Extraction Review

This file is generated from `kyokaispec/extraction/d627-d635.toml` by
`toolchain/spec/check_clause_extraction.py`. Do not edit it manually.

The checker verifies inventory closure, accepted-source identity, destination
existence, exact-name tripwires, supersession edges, and trace-row coverage.
It does not replace semantic review or claim implementation, conformance,
admission, operational readiness, or proof.

Review class: `lead-maintainer-directed-extraction`.
Reviewer: Rikona Kurasaki / Mjoyufull.
Review date: `2026-07-20`.
Accepted cutoff: `D635`.
Reviewed revision: `working tree accepted through D635`.

The lead maintainer explicitly accepted the adversarial, versioning, native-provider, diagnostic, finding, and umbrella cluster and directed normal decision-to-spec processing. The checker verifies mechanical clause closure without claiming implementation, conformance, admission, operational readiness, or independent review.

## Checked Projections

The registry also checks the public traceability, maturity, and Gate-A
views named below. A stale projection fails the same check as a stale
generated review.

| Kind | Path | Checked terms |
| --- | --- | ---: |
| `traceability` | `kyokaispec/src/project/02-decision-traceability.md` | 2 |
| `maturity` | `Kyokaishape.md` | 1 |
| `maturity` | `kyokaidecided.md` | 1 |
| `gate` | `phase.md` | 2 |

## Decision Summary

| Decision | State | Live clauses | Source lines | Source SHA-256 | Proof impact |
| --- | --- | ---: | --- | --- | --- |
| `D627` | `complete` | 7 | `9771-9805` | `6113337cb4680cd2300bdbcbe8034f690217201017abf3073a6a3213e6f171b0` | `NO_SEMANTIC_IMPACT` |
| `D628` | `complete` | 3 | `9806-9851` | `4911db0684cf5e7672f8ea62db7cb752fe682a8f35ebb8e1d589758b4393f18e` | `MAPPING_ONLY` |
| `D629` | `complete` | 3 | `9806-9851` | `4911db0684cf5e7672f8ea62db7cb752fe682a8f35ebb8e1d589758b4393f18e` | `NO_SEMANTIC_IMPACT` |
| `D630` | `complete` | 3 | `9806-9851` | `4911db0684cf5e7672f8ea62db7cb752fe682a8f35ebb8e1d589758b4393f18e` | `MAPPING_ONLY` |
| `D631` | `complete` | 8 | `9852-9900` | `f91fd60a70da5998c2e397820f4e7f93d2692a0efd45984e7bcae45b89634128` | `NO_SEMANTIC_IMPACT` |
| `D632` | `complete` | 8 | `9852-9900` | `f91fd60a70da5998c2e397820f4e7f93d2692a0efd45984e7bcae45b89634128` | `NO_SEMANTIC_IMPACT` |
| `D633` | `complete` | 7 | `9901-9924` | `b7ee6cfa553d636801b544698b80182780aa77860eebb4775c019c87a322298b` | `NO_SEMANTIC_IMPACT` |
| `D634` | `complete` | 5 | `9925-9959` | `b6c881c776518f4334909ee633dd2c6038c48457441a2dbaea5ff2802662e5d1` | `NO_SEMANTIC_IMPACT` |
| `D635` | `complete` | 4 | `9960-9983` | `5a4375e2aec6798912bc1e3897c4c8a1ab2294cdbca099113d6054f4d6d58aed` | `NO_SEMANTIC_IMPACT` |

## D627

Accepted source heading: `### D627: Adversarial And Wrong-Semantics Workload Corpus` at `kyokaidecided.md:9771-9805`.

Accepted-source SHA-256: `6113337cb4680cd2300bdbcbe8034f690217201017abf3073a6a3213e6f171b0`.

Destinations: `kyokaispec/src/toolchain/07-testing-coverage-bench.md`, `examples/adversarial/README.md`, `examples/adversarial/SCHEMA.md`.

Proof impact: `NO_SEMANTIC_IMPACT`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D627.syntax-api` | `syntax-api` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D627.static` | `static` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D627.dynamic` | `dynamic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D627.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D627.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D627.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D627.failure` | `failure` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d627-d635.toml`, `kyokaispec/extraction/d627-d635-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D627.artifact` | `artifact` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d627-d635.toml`, `kyokaispec/extraction/d627-d635-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D627.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d627-d635.toml`, `kyokaispec/extraction/d627-d635-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D627.compatibility` | `compatibility` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D627.target` | `target` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d627-d635.toml`, `kyokaispec/extraction/d627-d635-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D627.example` | `example` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d627-d635.toml`, `kyokaispec/extraction/d627-d635-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D627.illegal-form` | `illegal-form` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d627-d635.toml`, `kyokaispec/extraction/d627-d635-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D627.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d627-d635.toml`, `kyokaispec/extraction/d627-d635-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D628

Accepted source heading: `### D628-D630: Public Knowledge, Specification, Calculus, And Proof Versioning` at `kyokaidecided.md:9806-9851`.

Accepted-source SHA-256: `4911db0684cf5e7672f8ea62db7cb752fe682a8f35ebb8e1d589758b4393f18e`.

Destinations: `kyokaispec/src/project/01-governance.md`, `PROJECT_STANDARDS.md`.

Proof impact: `MAPPING_ONLY`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D628.syntax-api` | `syntax-api` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D628.static` | `static` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D628.dynamic` | `dynamic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D628.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D628.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D628.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D628.failure` | `failure` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D628.artifact` | `artifact` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d627-d635.toml`, `kyokaispec/extraction/d627-d635-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D628.diagnostic` | `diagnostic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D628.compatibility` | `compatibility` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d627-d635.toml`, `kyokaispec/extraction/d627-d635-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D628.target` | `target` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D628.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D628.illegal-form` | `illegal-form` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D628.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d627-d635.toml`, `kyokaispec/extraction/d627-d635-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D629

Accepted source heading: `### D628-D630: Public Knowledge, Specification, Calculus, And Proof Versioning` at `kyokaidecided.md:9806-9851`.

Accepted-source SHA-256: `4911db0684cf5e7672f8ea62db7cb752fe682a8f35ebb8e1d589758b4393f18e`.

Destinations: `kyokaispec/src/project/01-governance.md`, `kyokaispec/spec-version.toml`, `PROJECT_STANDARDS.md`.

Proof impact: `NO_SEMANTIC_IMPACT`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D629.syntax-api` | `syntax-api` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D629.static` | `static` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D629.dynamic` | `dynamic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D629.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D629.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D629.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D629.failure` | `failure` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D629.artifact` | `artifact` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d627-d635.toml`, `kyokaispec/extraction/d627-d635-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D629.diagnostic` | `diagnostic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D629.compatibility` | `compatibility` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d627-d635.toml`, `kyokaispec/extraction/d627-d635-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D629.target` | `target` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D629.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D629.illegal-form` | `illegal-form` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D629.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d627-d635.toml`, `kyokaispec/extraction/d627-d635-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D630

Accepted source heading: `### D628-D630: Public Knowledge, Specification, Calculus, And Proof Versioning` at `kyokaidecided.md:9806-9851`.

Accepted-source SHA-256: `4911db0684cf5e7672f8ea62db7cb752fe682a8f35ebb8e1d589758b4393f18e`.

Destinations: `kyokaispec/src/project/03-formalization-roadmap.md`, `kyokaispec/src/project/01-governance.md`.

Proof impact: `MAPPING_ONLY`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D630.syntax-api` | `syntax-api` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D630.static` | `static` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D630.dynamic` | `dynamic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D630.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D630.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D630.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D630.failure` | `failure` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D630.artifact` | `artifact` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d627-d635.toml`, `kyokaispec/extraction/d627-d635-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D630.diagnostic` | `diagnostic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D630.compatibility` | `compatibility` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d627-d635.toml`, `kyokaispec/extraction/d627-d635-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D630.target` | `target` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D630.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D630.illegal-form` | `illegal-form` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D630.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d627-d635.toml`, `kyokaispec/extraction/d627-d635-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D631

Accepted source heading: `### D631-D632: Bleedring Native Compiler Providers And Selection` at `kyokaidecided.md:9852-9900`.

Accepted-source SHA-256: `f91fd60a70da5998c2e397820f4e7f93d2692a0efd45984e7bcae45b89634128`.

Destinations: `kyokaispec/src/toolchain/04-build-profiles-targets-linking.md`.

Proof impact: `NO_SEMANTIC_IMPACT`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D631.syntax-api` | `syntax-api` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d627-d635.toml`, `kyokaispec/extraction/d627-d635-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D631.static` | `static` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D631.dynamic` | `dynamic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D631.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D631.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D631.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D631.failure` | `failure` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d627-d635.toml`, `kyokaispec/extraction/d627-d635-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D631.artifact` | `artifact` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d627-d635.toml`, `kyokaispec/extraction/d627-d635-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D631.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d627-d635.toml`, `kyokaispec/extraction/d627-d635-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D631.compatibility` | `compatibility` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d627-d635.toml`, `kyokaispec/extraction/d627-d635-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D631.target` | `target` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d627-d635.toml`, `kyokaispec/extraction/d627-d635-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D631.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D631.illegal-form` | `illegal-form` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d627-d635.toml`, `kyokaispec/extraction/d627-d635-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D631.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d627-d635.toml`, `kyokaispec/extraction/d627-d635-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D632

Accepted source heading: `### D631-D632: Bleedring Native Compiler Providers And Selection` at `kyokaidecided.md:9852-9900`.

Accepted-source SHA-256: `f91fd60a70da5998c2e397820f4e7f93d2692a0efd45984e7bcae45b89634128`.

Destinations: `kyokaispec/src/toolchain/04-build-profiles-targets-linking.md`.

Proof impact: `NO_SEMANTIC_IMPACT`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D632.syntax-api` | `syntax-api` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d627-d635.toml`, `kyokaispec/extraction/d627-d635-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D632.static` | `static` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D632.dynamic` | `dynamic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D632.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D632.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D632.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D632.failure` | `failure` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d627-d635.toml`, `kyokaispec/extraction/d627-d635-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D632.artifact` | `artifact` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d627-d635.toml`, `kyokaispec/extraction/d627-d635-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D632.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d627-d635.toml`, `kyokaispec/extraction/d627-d635-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D632.compatibility` | `compatibility` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d627-d635.toml`, `kyokaispec/extraction/d627-d635-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D632.target` | `target` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d627-d635.toml`, `kyokaispec/extraction/d627-d635-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D632.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D632.illegal-form` | `illegal-form` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d627-d635.toml`, `kyokaispec/extraction/d627-d635-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D632.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d627-d635.toml`, `kyokaispec/extraction/d627-d635-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D633

Accepted source heading: `### D633: Diagnostic And Error Code Registry` at `kyokaidecided.md:9901-9924`.

Accepted-source SHA-256: `b7ee6cfa553d636801b544698b80182780aa77860eebb4775c019c87a322298b`.

Destinations: `kyokaispec/src/toolchain/05-diagnostics.md`, `toolchain/diagnostics/registry.toml`.

Proof impact: `NO_SEMANTIC_IMPACT`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D633.syntax-api` | `syntax-api` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d627-d635.toml`, `kyokaispec/extraction/d627-d635-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D633.static` | `static` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D633.dynamic` | `dynamic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D633.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D633.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D633.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D633.failure` | `failure` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d627-d635.toml`, `kyokaispec/extraction/d627-d635-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D633.artifact` | `artifact` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d627-d635.toml`, `kyokaispec/extraction/d627-d635-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D633.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d627-d635.toml`, `kyokaispec/extraction/d627-d635-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D633.compatibility` | `compatibility` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d627-d635.toml`, `kyokaispec/extraction/d627-d635-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D633.target` | `target` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D633.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D633.illegal-form` | `illegal-form` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d627-d635.toml`, `kyokaispec/extraction/d627-d635-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D633.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d627-d635.toml`, `kyokaispec/extraction/d627-d635-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D634

Accepted source heading: `### D634: Implementation Findings And Release Review` at `kyokaidecided.md:9925-9959`.

Accepted-source SHA-256: `b6c881c776518f4334909ee633dd2c6038c48457441a2dbaea5ff2802662e5d1`.

Destinations: `kyokaispec/src/project/01-governance.md`, `PROJECT_STANDARDS.md`, `notinnormativespec.md`, `toolchain/findings/registry.toml`.

Proof impact: `NO_SEMANTIC_IMPACT`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D634.syntax-api` | `syntax-api` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D634.static` | `static` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D634.dynamic` | `dynamic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D634.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D634.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D634.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D634.failure` | `failure` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d627-d635.toml`, `kyokaispec/extraction/d627-d635-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D634.artifact` | `artifact` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d627-d635.toml`, `kyokaispec/extraction/d627-d635-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D634.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d627-d635.toml`, `kyokaispec/extraction/d627-d635-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D634.compatibility` | `compatibility` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d627-d635.toml`, `kyokaispec/extraction/d627-d635-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D634.target` | `target` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D634.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D634.illegal-form` | `illegal-form` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D634.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d627-d635.toml`, `kyokaispec/extraction/d627-d635-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## D635

Accepted source heading: `### D635: Umbrella D-Points And Public Temporary Holding` at `kyokaidecided.md:9960-9983`.

Accepted-source SHA-256: `5a4375e2aec6798912bc1e3897c4c8a1ab2294cdbca099113d6054f4d6d58aed`.

Destinations: `kyokaispec/src/project/01-governance.md`, `PROJECT_STANDARDS.md`, `Kyokaishape.md`.

Proof impact: `NO_SEMANTIC_IMPACT`.

| Clause ID | Obligation | Extraction state | Evidence |
| --- | --- | --- | --- |
| `D635.syntax-api` | `syntax-api` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D635.static` | `static` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D635.dynamic` | `dynamic` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D635.ownership` | `ownership` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D635.borrow` | `borrow` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D635.capability` | `capability` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D635.failure` | `failure` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D635.artifact` | `artifact` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d627-d635.toml`, `kyokaispec/extraction/d627-d635-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D635.diagnostic` | `diagnostic` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d627-d635.toml`, `kyokaispec/extraction/d627-d635-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D635.compatibility` | `compatibility` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d627-d635.toml`, `kyokaispec/extraction/d627-d635-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |
| `D635.target` | `target` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D635.example` | `example` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D635.illegal-form` | `illegal-form` | `not-applicable-with-reason` | The accepted decision creates no independent obligation in this category; applicability was reviewed against the accepted source. |
| `D635.conformance` | `conformance` | `complete` | accepted digest; destinations; exact-name/rejection tripwires; maintainer-directed review; `kyokaispec/extraction/d627-d635.toml`, `kyokaispec/extraction/d627-d635-review.md`, `kyokaispec/src/project/02-decision-traceability.md` |

## Maturity Result

Every required D627-D635 decision is clause-complete. This batch satisfies D577's clause-evidence condition for `SPEC_EXTRACTED`. Together with the checked pre-D558 and D558-D625 registries, Gate A is closed through D635. This does not upgrade implementation, conformance, admission, service, workload, or proof state.
