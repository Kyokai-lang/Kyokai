# Frame Typing And Intrinsic TPOE Derivation Package

**Status:** `paper-proven` Gate-B frame-typing derivation package  
**Discharges in the maintained proof:** frame-local cases of L9-L11, L26, L31, and L38-L40  
**Depends on:** `syntax-and-statics.md`, `dynamics.md`, `lemmas.md`

## 1. Claim Boundary

This package expands the frame-local derivations for the sequential first core. It
records
the repaired intrinsic judgments needed to review three previously failing cases:
linear local execution, owned call-parameter execution, and TPOE after an outer
frame has already received a linear carrier.

The accepted language rule remains unchanged. Ordinary completion requires visible
linear discharge. TPOE is immediate hard termination with no user cleanup. The
proof machine therefore keeps live obligations during ordinary body execution and
records erased carriers at terminal TPOE without pretending to clean them up.

## 2. Closed Frame Judgment

The frame judgment is:

```text
Delta; Sigma_t; Xi_t; B; I |- K : tau_in => tau_out
```

It means that a returned runtime value of `tau_in` can be processed by stack `K`
toward `tau_out` or intrinsic typed TPOE. The separate top-frame readiness judgment
is:

```text
Delta; Sigma_t; Xi_t; B; I |- ready(w,K)
```

Frame typing records the continuing obligation. Readiness proves that one concrete
returned value and current runtime state satisfy the immediate pop or dispatch
premises. Conflating these judgments would require a linear local or owned
parameter to be consumed before its body begins.

## 3. Pending Linear Obligations

The helper relations are total structural predicates:

```text
local_obligation(Xi,ell,tau)
  iff Xi(ell)=live(tau,w) for one w or Xi(ell)=moved(tau)

parameter_obligations(Xi,[])
parameter_obligations(Xi,ell::ells)
  iff local_obligation(Xi,ell,tau)
      and parameter_obligations(Xi,ells)
      and ell notin ells

all_moved(Xi,[])
all_moved(Xi,ell::ells)
  iff Xi(ell)=moved(tau)
      and all_moved(Xi,ells)
      and ell notin ells
```

`local_obligation` and `parameter_obligations` admit a live slot only while its body
is still executing. `all_moved` is stronger and appears at ordinary pop readiness.
A TPOE transition does not need `all_moved`: it abandons ordinary continuation
processing entirely.

## 4. Linear Let Derivation

Assume `E-Let-Linear` receives `ret(w)` with `w:runtime_type(I,T)` and `T:Linear`.
It chooses fresh `ell`, stores `Xi(ell)=live(runtime_type(I,T),w)`, extends `eta`
with `x |-> slot(ell)`, and evaluates the body under:

```text
end_linear(ell)::K
```

The successor stack types by `F-End-Linear-Pending` because
`local_obligation(Xi,ell,runtime_type(I,T))` holds through the new live entry. The
body is allowed to move or consume `x`. Once the body returns, `Ready-End-Linear`
permits `E-End-Linear` only when:

```text
Xi(ell)=moved(runtime_type(I,T))
```

Therefore the body-evaluation successor is intrinsically typable and ordinary exit
still rejects a live local. L2 supplies the source exact-use premise; the runtime
ready rule enforces its pop-time witness.

## 5. Owned Call-Parameter Derivation

Assume `E-Call-Enter` realizes checked arguments and `bind_call_args` creates fresh
owned parameter slots:

```text
param_slots = [ell_1,...,ell_n]
Xi(ell_i)=live(runtime_type(I_f,psi(T_i)),w_i)
```

The callee executes under:

```text
call_return(param_slots,B_entry,I_entry,I_formal,psi,phi,pi,U)::K
```

The successor stack types by `F-Call-Return-Pending` because
`parameter_obligations(Xi,param_slots)` accepts each fresh live slot. Callee source
linearity then moves or visibly consumes every owned parameter. When the callee
returns `w`, `Ready-Call-Return` permits `E-Call-Return` only if:

```text
all_moved(Xi,param_slots)
B=B_entry
return_witness(I,I_entry,I_formal)
result_bridge(Sigma_t,Xi_t,B,I,I_entry,psi,phi,U,w)
```

The pending rule keeps call entry typable. The ready rule enforces exact discharge,
borrow-graph restoration, witness restoration, and result bridging at the ordinary
return boundary.

## 6. Structural Carrier Extraction

Carrier extraction is a total recursion over machine syntax. Most frames contain
only source syntax, slot references, or witnesses and therefore contribute no
runtime owner carrier. The evaluated argument frames contribute their `done` values:

| Frame | `frame_values` contribution |
| --- | --- |
| `halt` | `[]` |
| `let_bind`, `end_linear`, `seq_next`, `if_select`, `inject_value`, `case_select`, `region_end`, `call_return`, `check_result` | recursive tail only |
| `call_args(...,done,...)` | `done` followed by recursive tail |
| `checked_args(...,done,...)` | `done` followed by recursive tail |

Ordinary carrier accounting is:

```text
owners_machine(Xi,control,K)
  = owners_values(slot_values(Xi) ++ control_values(control) ++ frame_values(K))
```

A linear carrier can move from slot to returned control, from returned control into
`call_args.done`, or from `call_args.done` into fresh parameter slots. Each selected
ordinary transition removes it from one source carrier before installing it in one
target carrier.

## 7. Intrinsic TPOE Carrier Accounting

Immediate TPOE erases `K`. A continuation frame can already contain an evaluated
linear value, so terminal syntax retains one proof-facing snapshot:

```text
tpoe<q,Sigma,B,I,Xi,A>
A = abandoned_owners(control,K)
```

where:

```text
abandoned_owners(control,K)
  = owners_values(control_values(control) ++ frame_values(K))

terminal_owners(Xi,A)
  = owners_values(slot_values(Xi)) multiset-union A
```

`WT_TPOE` requires `terminal_carrier_bijection(Sigma,Xi,A)`. `A` is not observable
source state, cleanup work, or a resumable continuation. It preserves the accounting
invariant while honoring immediate hard termination.

For the counterexample shape:

```text
call f[phi](move x, check false else tpoe)
```

argument evaluation first moves `own[a]` into `call_args.done`. The failing check
computes `A={a}` before erasing that frame. The terminal state therefore accounts
for `a` exactly once.

## 8. Frame-Local Decomposition Table

| Top frame | Readiness premise | Selected transition | Ordinary preservation fact |
| --- | --- | --- | --- |
| `halt` | none beyond typed `w` | ordinary final | no successor |
| `let_bind` with `T:Free` | free binding admitted | `E-Let-Free` | environment extends without owner carrier |
| `let_bind` with `T:Linear` | fresh slot exists | `E-Let-Linear` | returned carrier moves into one live local slot |
| `end_linear(ell)` | `Xi(ell)=moved(tau)` | `E-End-Linear` | tombstone remains; frame pops |
| `seq_next` | `w=nil` | `E-Seq-Next` | source-ordered evaluation continues |
| `if_select` | canonical boolean | `E-If-True` or `E-If-False` | discarded branch syntax carries no owner |
| `inject_value` | typed payload | `E-Inject` | injection wraps the same carrier |
| `case_select` | declared runtime tag | `E-Case-Select` | selected payload binding preserves one carrier |
| `region_end` | closable region and non-escape | `E-Region-Exit` | exact close and witness pop preserve unrelated facts |
| `call_args` with pending tail | one returned argument | `E-Call-Next` | carrier moves into `done` exactly once |
| `call_args` with empty pending tail | defined checked instantiation | `E-Call-Enter` | `bind_call_args` transfers owned carriers into fresh parameter slots |
| `call_return` | `all_moved`, graph restoration, witness restoration, result bridge | `E-Call-Return` | owned obligations are discharged before frame pop |
| `checked_args` with pending tail | one returned `Free` argument | `E-Checked-Next` | source-ordered evaluation continues |
| `checked_args` with empty pending tail | total admitted `ok` relation | `E-Checked-Ok` or `E-Checked-Fail` | success preserves state; failure snapshots erased carriers |
| `check_result` | canonical boolean | `E-Check-True` or `E-Check-False` | failure snapshots erased carriers |

The expression-control half of L38 remains a separate induction over source typing.
The table closes the continuation-frame half: once `WT-Ret` supplies one typed value,
closed frame typing plus readiness select exactly one row modulo fresh identity
choice.

## 9. Executable Evidence

`machine_runner.py` executes twenty-five complete traces:

1. a linear let whose live local obligation remains typable during its body and is
   consumed before `E-End-Linear`;
2. branch selection whose selected arm consumes the one slot carrier without copying
   it into either stored source branch;
3. movement of one injected optional resource as an arbitrary linear sum carrier;
4. an owned call argument whose fresh parameter slot remains typable during callee
   execution and is consumed before `E-Call-Return`;
5. a nested contract TPOE after one earlier owned call argument moved into
   `call_args.done`, proving the executable terminal snapshot accounts for the erased
   frame carrier;
6. a mutable reborrow whose child access closes before parent access resumes and the
   owner is consumed;
7. a read reborrow whose child observation closes before the owner is consumed;
8. a successful source-ordered checked primitive;
9. a failed checked primitive under an outer `call_args.done` owner carrier, proving
   checked TPOE takes the same intrinsic abandoned-owner snapshot path;
10. one-way capability attenuation from a strong owner to one fresh weaker owner,
    followed by visible named consumption;
11. direct immutable-borrow access followed by lexical close and owner consumption;
12. selected linear-sum payload binding, visible consumption, and payload-slot discharge;
13. a successful contract check returning `Unit`;
14. zero-argument call entry and return;
15. zero-argument checked-primitive success;
16. explicit injection followed by selected linear-payload case discharge;
17. free-payload case binding without an owner slot;
18. unrestricted variable lookup after free binding;
19. zero-argument checked-primitive TPOE;
20. false-arm branch selection with one owner carrier;
21. direct mutable-borrow write access followed by lexical close and owner consumption;
22. direct mutable-borrow read access followed by lexical close and owner consumption;
23. source-ordered successful multi-argument call entry with one owned and one `Free`
    argument;
24. owned call return transferring one parameter carrier back to returned control; and
25. dynamic rejection when one returned local borrow token attempts to cross its
    region close.

`model_tests.py` retains the broader forty-nine spot checks. These artifacts support
theorem review. They support, but do not replace, the paper proof.

## 10. Composition Result

This package supplies the frame-local L9-L11, L26, L31, and L38-L40 cases consumed by `theorem-assembly.md`. The final Theorem P/Q proof composes it with the source-expression, close/witness, call-entry, primitive-admission, and equivariance packages.
