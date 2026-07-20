# Kyokai Conformance Fixture Schema

Conformance fixtures are public executable evidence only after a lane has a runner that reads this schema and reports pass, fail, skip, and implementation-gated results separately. A lane without such a runner is planned corpus material, not evidence.

Every fixture must state these fields in lane metadata before it can count as conformance evidence:

| Field | Meaning |
| --- | --- |
| `id` | Stable fixture identifier. |
| `lane` | One conformance lane under `test/conformance/`. |
| `status` | `active`, `implementation-gated`, `spec-gated`, or `historical`. |
| `spec` | Public spec path and section or accepted D-point mechanics. |
| `edition` | Source edition, normally `2026` for first-edition fixtures. |
| `inputs` | Source, manifest, lockfile, target, package-index, generated-artifact, or stdin inputs. |
| `command` | Tool command or compiler stage exercised by the runner. |
| `expect` | Accepted success, rejected diagnostic, runtime result, artifact shape, or deterministic output. |
| `expected_outcome` | Machine-readable outcome: `accept`, `reject`, `run`, or `artifact`. |
| `expected_stage` | Machine-readable compiler/tool stage that owns the expected result, such as `parser`, `lexer`, `package-source`, `package-target`, or `package-lockfile`. |
| `expected_code` | Stable machine-readable result code for the accepted or rejected behavior. |
| `expected_facts` | Stable facts the runner compares with the implementation result, such as selected module, target, diagnostic subject, package edge, or artifact class. |
| `targets` | Target assumptions or `host-independent`. |
| `prooftrace` | Related ProofTrace record when the fixture exercises a registered boundary. |

A skipped fixture is not a pass. A host OCaml unit test is not conformance evidence until it is represented through a lane runner or explicitly listed as supporting-only evidence in ProofTrace.

The Phase 3 internal runner consumes this schema for the current parser, module, and package fixtures. `status = "implementation-gated"` means the runner executes the fixture through `kyokai internal conformance-fixture` and compares the machine-readable expected result, but the result stays separate from conformance-backed evidence. A fixture becomes conformance evidence only after the relevant public command or accepted compiler stage checks the same expected result contract, the fixture status is updated, and the related ProofTrace record moves to `conformance-backed`.
