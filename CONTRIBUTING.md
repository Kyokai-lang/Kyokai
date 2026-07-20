# Contributing to Kyokai

Thank you for your interest in contributing to Kyokai. Kyokai is an explicit systems programming language built around ownership boundaries, authority boundaries, and no hidden semantics.

Whether you are here to improve the compiler, write standard library code, improve diagnostics, or write documentation, we welcome your help.

## Communication

- [GitHub Issues](https://github.com/kyokai-lang/kyokai/issues)
- [Discussions](https://github.com/kyokai-lang/kyokai/discussions)

## Project Governance and Proposals

Kyokai is a maintainer-led project with an administered-member governance model. Public language evolution happens through proposals.

Before contributing new language semantics, syntax, toolchain behavior, or standard library APIs:

1. Check `kyokaidecided.md` and `kyokaispec/` to see if the behavior is already decided.
2. Read the workflow rules in [`PROJECT_STANDARDS.md`](PROJECT_STANDARDS.md).
3. If the behavior requires a decision, open a proposal using the template in `PROJECT_STANDARDS.md`; a proposal may live in its PR/MR or in the public temporary-holding section of `Kyokaishape.md`.

For details on who has the authority to ack proposals and write accepted decisions, please see our [`MEMBERS.md`](MEMBERS.md) roster.

## How to Contribute

### 1. Code Standards
All compiler, runtime, and standard library code must follow the [`CODE_STANDARDS.md`](CODE_STANDARDS.md) handbook. This includes rules on handling state, error modeling (TPOE), linear invariants, capability tracking, and test expectations.

### 2. Specification Writing
If your proposal is accepted, or if you are extracting already-decided shape into the formal specification, follow the [`docs/contributing/spec-writing.md`](docs/contributing/spec-writing.md) guide.

### 3. Compiler Diagnostics
Improving compiler error messages is one of the highest-impact ways to contribute. Kyokai prioritizes clear, structured diagnostics that explain the *rule* being violated, not just the parser symptom. If you encounter an unhelpful error message, please open an issue even if you don't have time to fix the code yourself.

### 4. Standard Library
Kyokai's standard library requires explicit semantic contracts. Contributions to the `standard/` tree must include tests, explicit capability requirements, allocation behavior, and failure modes as documented in the standard library admission rules.

### 5. Tests
Kyokai requires executable evidence for language rules. PRs that modify semantics, typing, or runtime behavior must include corresponding tests.

Ownership, cleanup, aliasing, concurrency, lowering, or capability changes must also add or update the relevant `examples/adversarial/` case when the rule can be exercised as a workload. An implementation discovery that exposes missing or contradictory normative text must be recorded under the implementation-finding workflow before the PR is accepted; the named reviewer owns its disposition, but only a maintainer can accept the resulting D-point.

- To run the test suite locally:
```bash
./run-tests.sh
```

## Pull Requests

1. Target the `dev` branch for implementation work. Target `main` only for docs-only changes.
2. Follow the relevant PR checklists in `PROJECT_STANDARDS.md`.
3. Provide a clear summary of what changed, why it changed, and how it was tested.
4. If your PR implements an accepted proposal, link the D-point and the relevant spec section.

## Development Environment

The bootstrap compiler is currently written in OCaml. Active Kyokai compiler
code belongs in `compiler/`; classified inherited passes remain in `lib/` until
their transition disposition is executed. The final compiler and toolchain are
written in Kyokai after the D592a self-host entry threshold. See
[README.md](README.md) for the current build and test commands.
