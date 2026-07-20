# Implementation Findings Not In The Normative Specification

**Status:** no open records; registry/generator scaffold
**Machine source:** `toolchain/findings/registry.toml`

This is the public human view of implementation findings that need repair,
routing, research, or a new decision. It is not a second specification and it
does not authorize the compiler to choose semantics.

A pull request can carry and resolve a finding without opening a duplicate
issue. Before merge, the named reviewer records its class, owner, authority,
next action, and disposition in the machine registry. A semantic candidate is
also given a D-point proposal in the pull request or the temporary-holding
section of `Kyokaishape.md`; the finding then records that D-point ID.

The closed classes are `DEFECT`, `AUTHORIZED_KNOWN_ISSUE`,
`DPOINT_CANDIDATE`, `XP_CANDIDATE`, `RESEARCH`, `DIRECTION`, and `REJECTED`.
Only the lead maintainer authorizes known-issue commitment, D-point acceptance,
XP acceptance, or rejection. A routed finding remains open until its named
resolution evidence exists.

The Phase 8 generator will replace the record table below from the machine
source and reject hand-written divergence.

| Finding | Repository/revision | Class | Owner | Reviewer | Status | Routed decision/XP | Resolution |
| --- | --- | --- | --- | --- | --- | --- | --- |
| _none_ | — | — | — | — | — | — | — |
