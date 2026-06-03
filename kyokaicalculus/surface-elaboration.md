# Surface Elaboration Obligations

**Status:** `intended-by-spec` contract map  
**Gate:** K-E open

The surface language is larger than `lambda_K-seq`. A construct counts as
elaboration only when lowering exposes the full semantic operation without
adding behavior. A construct that needs new rules extends the calculus.

| Surface construct | Explicit treatment | Proof boundary |
| --- | --- | --- |
| UFCS receiver syntax | Ordinary function call with resolved callable identity. | Elaborates into core call. |
| Auto-borrow | Explicit lexical region plus immutable or mutable borrow node. | Elaborates only when the completion registry has one tautological choice. |
| Auto-reborrow | Explicit `reborrow` node and suspension region. | Elaborates into core reborrow. |
| Mutable-to-immutable access | Explicit `read_reborrow` node and suspension region. | Elaborates into core read reborrow. |
| Surface `drop;` | Close the current explicit borrow scope at the written statement. | Core region-frame end is the proof-facing close point; surface conformance must preserve the written lexical boundary. |
| Implicit `Unit` completion | Explicit `Unit` result at body end. | Elaborates into core value completion. |
| `Never` lift | Closed coercion from a statically diverging form. | Does not apply to possible TPOE. |
| `require` | Entry `check condition else tpoe`. | Elaborates into checked core form. |
| `ensure` | Return-slot observation followed by `check condition else tpoe` before caller delivery. | Needs explicit return-slot mapping. |
| `old` | Entry snapshot over admitted `Free` observation data. | Needs explicit snapshot mapping; no linear copy. |
| `let...else` | Candidate lowering uses `case` with a non-continuing rejection arm. | Later cleanup/control-flow mapping must define the source early exit before this counts as elaboration. |
| `or return` | Candidate lowering uses `case Result` with a visible `Err` return arm. | Later cleanup/control-flow mapping must define the source return exit before this counts as elaboration. |
| Checked arithmetic and bounds checks | Checked primitive with terminal `tpoe` failure. | Elaborates into core checked form. |
| Branch join | Explicit compatibility check over every normally continuing arm. | Core obligation; no hidden pass-through or discard. |
| `build` expression | Field-initialization state machine; value becomes usable only after every required field is initialized exactly once. | Later initialization-state extension, not a primitive `lambda_K-seq` term. |
| `defer`, `errdefer`, and `panic` | Cleanup registration and exit-category semantics. | `lambda_K-cleanup` extension. |

Every compiler-inserted completion records its source span, inserted node,
local static preconditions, effect bound, diagnostic label, and conformance
case. Every elaborated call retains its checked `phi` witness. Runtime uses
that witness and does not repeat generic, region, lease, or path inference. No insertion adds allocation, blocking, authority acquisition, cleanup,
I/O, task spawn, dynamic loading, side effects, or a new control-flow choice.

The runtime proof bridge is explicit. A whole-owner source path resolves to
the unique owner slot named by the runtime environment. Surface field paths,
partial moves, and mutable `Free` places do not inherit that rule by analogy;
their later extension must define place resolution, invalidation, and
reinitialization directly.

## First-Core Completion Records

| Completion | Source condition | Inserted core term | Local proof obligation | Effect bound |
| --- | --- | --- | --- | --- |
| UFCS receiver syntax | Name resolution selects one receiver-callable first-order function. | `call f[phi](receiver, args...)` | The receiver evaluates before the remaining arguments, and the selected identity is the same identity ordinary call syntax would use. | Call sugar adds no effect beyond the selected function call. |
| Auto-borrow | One expected borrow parameter and one addressable linear-owner place leave exactly one accepted borrow mode. | Wrap the selected call-owned extent as `region rho in call f[phi](..., borrow[rho,b] place, ...)` or `region rho in call f[phi](..., mut_borrow[rho,b] place, ...)`. | Fresh static atoms `rho` and `b`; runtime identities are minted through `I`; ordinary direct-borrow premises; no escape beyond inserted frame. | Adds only lease creation and lexical lease close. |
| Auto-reborrow | Expected parameter is mutable borrow and supplied value is a usable mutable-borrow token. | Wrap the selected call-owned extent as `region rho in call f[phi](..., reborrow[rho,b] token, ...)`. | Fresh static atoms `rho` and `b`; parent lease is unsuspended; inserted child region is nested; parent resumes at close. | Adds only suspension, child lease, and lexical close. |
| Mutable-to-immutable read access | Expected parameter is immutable borrow and supplied value is a usable mutable-borrow token. | Wrap the selected call-owned extent as `region rho in call f[phi](..., read_reborrow[rho,b] token, ...)`. | Fresh static atoms `rho` and `b`; parent lease is unsuspended; inserted child read region is nested; parent resumes at close. | Adds only suspension, child read lease, and lexical close. |
| Surface `drop;` | The programmer closes the current borrow scope explicitly. | End the corresponding elaborated `region rho in ...` extent at the written statement. | The selected scope is the innermost currently open surface borrow scope; every lease created in that scope closes together; nested child scopes must already be closed; outer scopes remain active. | Adds only the written lexical close. |
| Implicit `Unit` completion | A body with declared `Unit` result reaches accepted fallthrough. | Explicit `nil`. | No linear obligation remains live at fallthrough. | Adds no runtime effect. |
| `require` | Contract elaboration is at function entry after admitted entry observations exist. | `check condition else tpoe`. | Condition has type `Bool`; failed evaluation is terminal TPOE. | Adds the specified contract check and possible terminal TPOE only. |
| Checked arithmetic or bounds check | Surface operation is one of the accepted checked operations. | `checked[op](args...)`. | `Delta(op)` names successful result type and total `ok` predicate. | Adds specified checked evaluation and possible terminal TPOE only. |
| Branch join | `if`, exhaustive `case`, or lowered sugar has more than one normal continuation. | `T-If` or `T-Case` common `Rho_j; Gamma_lj` post-state. | Every normally completing arm has the same owner and lease state. Terminal arms have no fake join state. | Adds no runtime operation. |

The auto-borrow rows define a smallest call-owned lexical extent, not an
implementation-chosen lifetime. An inserted frame begins immediately before
the borrow-producing argument use and closes immediately after the selected
call no longer needs that temporary access. The first-core rows apply only to
linear-owner places represented in `Gamma_l`. Auto-borrowing a mutable `Free`
place is owned by the later place-state extension and cannot be claimed from
these rules. If a surface construct requires a longer relationship, it writes
or infers an ordinary explicit region under the region rules; the completion
does not guess a wider lifetime.

## Later Surface Obligations

| Surface construct | Required later artifact | Reason it is not discharged by `lambda_K-seq` |
| --- | --- | --- |
| `ensure` | Return-slot elaboration record and tests. | The first core has no explicit return-slot form. |
| `old` | Entry-snapshot elaboration record and tests. | Snapshot admission and `Free` observation boundaries need their own rule table. |
| `let...else`, `or return` | Surface lowering examples and control-flow conformance tests. | Core `case` and dynamic terminal-TPOE outcomes exist, but source-level early-return completion needs the later cleanup/control-flow mapping. |
| `build` | Initialization-state extension. | The first core has no records or partially initialized values. |
| `defer`, `errdefer`, `panic` | `lambda_K-cleanup`. | Cleanup registration and exit-category selection are new dynamic state. |
