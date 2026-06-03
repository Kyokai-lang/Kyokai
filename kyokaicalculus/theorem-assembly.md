# Theorem P/Q Paper Proof

**Status:** `paper-proven` Gate-B assembly  
**Assembles:** L1-L40 into Theorem P and Theorem Q  
**Depends on:** `lemmas.md`, `source-expression-proof.md`, `frame-typing-proof.md`, `close-and-witness-proof.md`, `call-entry-proof.md`, `primitive-admission-proof.md`, `equivariance-proof.md`

## 1. Claim Boundary

This file is the maintained paper proof for the first sequential theorem boundary.
It names which derivation package supplies each lemma family, then closes the final
L38-L40, Theorem P, and Theorem Q composition cases.

The theorem boundary remains `lambda_K-seq` only. Excluded features remain excluded
exactly as listed in `scope.md` and `deviation.md`.

## 2. Package Dependency Graph

| Package | Primary obligation |
| --- | --- |
| `source-expression-proof.md` | Source-control induction, structural contexts, canonical values, slots, branches, borrows, environment agreement, capability origin, and freshness. |
| `frame-typing-proof.md` | Closed continuation typing, pending obligations, pop readiness, structural frame carrier extraction, and intrinsic TPOE carrier accounting. |
| `close-and-witness-proof.md` | Exact lexical close, direct-parent resumption, witness-layer pop, writer-chain isolation, and close-specific renaming. |
| `call-entry-proof.md` | Checked `phi`, pre-argument `pi`, freshened `psi`, realized call layer, owned-argument carrier transfer, parameter discharge, and result bridging. |
| `primitive-admission-proof.md` | Totality, footprint, and progress/preservation premises for consuming, checked, borrow-access, and attenuation primitives. |
| `equivariance-proof.md` | Sort-preserving runtime finite-renaming cases, distinct from binder alpha-equivalence and one-step fresh-choice equivalence. |

## 3. L1-L40 Route Matrix

| Lemma | Derivation owner | Assembly use | Closure check |
| --- | --- | --- | --- |
| L1 | `source-expression-proof.md` Sections 2 and 8.1 | unrestricted context closure | token contraction copies one lease identity only |
| L2 | `source-expression-proof.md` Sections 2 and 8.2 | ordinary exact-use paths | no rule weakens or contracts `Gamma_l` |
| L3 | `source-expression-proof.md` Sections 2 and 8.3 | sequential premise composition | every ordered premise consumes the previous post-state |
| L4 | `source-expression-proof.md` Sections 2 and 8.4 | branch join closure | every ordinary arm returns one identical post-state |
| L5 | `source-expression-proof.md` Sections 3 and 8.5 | runtime inversion | mutable token typing remains separate from usable access |
| L6 | `source-expression-proof.md` Sections 3 and 8.6 | fresh linear slot insertion | slots store runtime types uniformly |
| L7 | `source-expression-proof.md` Sections 3 and 8.6 | arbitrary linear movement | sums move as one runtime carrier |
| L8 | `source-expression-proof.md` Section 8.6 and `primitive-admission-proof.md` | visible named discharge | no structural destructor fallback exists |
| L9 | `frame-typing-proof.md` Section 4 | ordinary local exit | pending live slot is typable; pop requires tombstone |
| L10 | `frame-typing-proof.md` Section 6 | carrier partition | every frame constructor has one structural extraction clause |
| L11 | `frame-typing-proof.md` Sections 6-7 | ordinary and terminal carrier accounting | TPOE snapshots erased control/frame carriers in `A` |
| L12 | `source-expression-proof.md` Section 4 | branch carrier preservation | stored source arms contain no runtime owner value |
| L13-L19 | `source-expression-proof.md` Sections 5 and 8.7 | borrow lifecycle and usable access | retained writers, suspension, and access predicates align |
| L20-L23 | `close-and-witness-proof.md` | lexical close and witness locality | close removes exact local facts and resumes direct parents only |
| L24-L25 | `source-expression-proof.md` Sections 6 and 8.8 | environment and payload transfer | inert tombstone references cannot become typed current uses |
| L26 | `frame-typing-proof.md` Sections 2-8 | continuation typing | frame typing and readiness remain separate judgments |
| L27-L30 | `call-entry-proof.md` | deterministic checked invocation | path certificates survive caller-slot movement; params discharge at pop |
| L31 | `frame-typing-proof.md` Section 7 and `primitive-admission-proof.md` | intrinsic terminal classification | terminal typing is not predecessor reachability |
| L32-L34 | `source-expression-proof.md` Sections 7 and 8.9 and `primitive-admission-proof.md` | checked failure and capability origin | possible TPOE is not `Never`; capability creation stays closed |
| L35 | `source-expression-proof.md` Section 8.9 | binder alpha-equivalence | source binder renaming remains capture avoiding |
| L36-L37 | `source-expression-proof.md` Section 8.9 and `equivariance-proof.md` | fresh-choice and runtime-renaming closure | all relation-local commuting cases compose |
| L38 | Sections 4-5 below | unique decomposition | source control and returned control select exactly one family |
| L39 | Section 6 below | ordinary preservation | every ordinary rule routes to one package derivation |
| L40 | Section 7 below | terminal preservation | failure transitions preserve intrinsic terminal invariants |

## 4. L38 Unique Decomposition

**Lemma L38.** If `WT(C)` and `C` is not an ordinary final configuration, then
exactly one transition family applies, modulo `fresh_step_equiv` for freshly minted
runtime identities.

The proof splits on the intrinsic control form in `WT(C)`.

### 4.1 Evaluated Source Control

Let:

```text
C = <Sigma,B,I,Xi,eval(e,eta),K>
```

Invert `WT-Eval`. We obtain one source derivation:

```text
Delta;Rho;Gamma_f;Gamma_l |- e : T => Rho';Gamma_l'
Delta;Sigma_t;Xi_t;B;I |- eta agrees Gamma_f;Gamma_l
lease_bridge(Rho,B,I,eta)
Delta;Sigma_t;Xi_t;B;I |- K : runtime_type(I,T) => tau_out
machine_invariants(Sigma,B,I,Xi,eval(e,eta),K)
```

Now invert the final syntactic constructor of `e`. The grammar in
`syntax-and-statics.md` is disjoint, so the constructor selects one row below.

| Source constructor | Inverted typing facts | Unique transition family |
| --- | --- | --- |
| `nil`, booleans, integer literal | literal rule has no dynamic premise | `E-Literal` |
| `x` | `x:T in Gamma_f` | `E-Var-Free`; a linear `x` has no variable rule and must appear under `move`, borrow, consumption, or attenuation |
| `let x:T=e1 in e2` | universe of `T` is fixed | `E-Let-Eval`; the returned-control frame later selects `E-Let-Free` or `E-Let-Linear` |
| `seq e1 e2` | `e1 : Unit` and `e2` starts from `e1` post-state | `E-Seq-Eval` |
| `move x` | `eta(x)=slot(ell)`, live slot, `unborrowed(B,ell)` from agreement and source premise | `E-Move` |
| `consume[op] x` | admitted consuming declaration and live unborrowed slot | `E-Consume`; admission excludes missing `consume_op` |
| `region rho in e` | `fresh_region(Rho,rho)` and witness extension premise | `E-Region-Enter`, unique modulo fresh runtime `r` |
| `borrow[rho,b] x` | active mapped region, `fresh_lease`, `no_writer` | `E-Borrow`, unique modulo fresh lease `beta` |
| `mut_borrow[rho,b] x` | active mapped region, `fresh_lease`, `unborrowed` | `E-MutBorrow`, unique modulo fresh lease `beta` |
| `reborrow[rho,b] x` | parent mutable token is usable and child region is nested | `E-Reborrow`, unique modulo fresh lease `beta_child` |
| `read_reborrow[rho,b] x` | same parent facts, child mode read | `E-Read-Reborrow`, unique modulo fresh lease `beta_child` |
| `read_access[op] x` | admitted read access plus usable read/write token | the matching read-access family; immutable and mutable token shapes are disjoint |
| `write_access[op] x` | admitted write access plus usable mutable token | `E-Write-Access` |
| `if e0 then e1 else e2` | `e0 : Bool`; branch post-states equal | `E-If-Eval` |
| `inject tag e0` | tag declared in the sum | `E-Inject-Eval` |
| `case e0 of ...` | exhaustive sum arms | `E-Case-Eval` |
| `call f[phi](args)` | checked `phi`, source-ordered argument list | `E-Call-Zero` if `args=[]`, otherwise `E-Call-Start`; list length is decidable |
| `check e else tpoe` | `e : Bool` | `E-Check-Eval` |
| `checked[op](args)` | admitted checked primitive with `Free` arguments/results | zero-argument `E-Checked-Zero-Ok` or `E-Checked-Zero-Fail` if `args=[]`; otherwise `E-Checked-Start` |
| `attenuate x as k` | admitted attenuation, live unborrowed capability slot | `E-Attenuate`, unique modulo fresh weaker resource identity |

Primitive rows are total because `primitive-admission-proof.md` proves that a name
cannot enter `Delta` unless its runtime relation is total on admitted typed inputs.
Fresh rows are unique modulo L36. No two source rows overlap because no source term
has two top constructors.

### 4.2 Returned Runtime Control

Let:

```text
C = <Sigma,B,I,Xi,ret(w),K>
```

Invert `WT-Ret`. We obtain runtime value typing for `w`, continuation typing
`K : tau => tau_out`, readiness `ready(w,K)`, and machine invariants. If `K=halt`,
then `C` is ordinary final and L38 does not require a step. Otherwise invert the top
frame. Frame constructors are disjoint, and readiness supplies the exact immediate
premise.

| Top frame | Readiness inversion | Unique transition family |
| --- | --- | --- |
| `let_bind(x,T,e,eta)` | universe of `T` fixed | `E-Let-Free` or `E-Let-Linear`; universes are disjoint |
| `end_linear(ell)` | `Xi(ell)=moved(tau)` | `E-End-Linear` |
| `seq_next(e,eta)` | `w=nil` | `E-Seq-Next` |
| `if_select(e1,e2,eta)` | `w=true` or `w=false` | exactly one of `E-If-True` or `E-If-False` by boolean canonical forms |
| `inject_value(tag)` | no additional premise | `E-Inject-Return` |
| `case_select(arms,eta)` | `w=inject tag payload` and arm exists | `E-Case-Select`; tags are unique in a closed sum |
| `region_end(rho,r,I_entry)` | closable top region, non-escaping `w`, witness pop | `E-Region-Exit` |
| `call_args(...,pending,...)` | either `pending=e::tail` or `pending=[]` | `E-Call-Next` or `E-Call-Enter`; list cases are disjoint |
| `call_return(...)` | all owned parameters moved, `B=B_entry`, result bridge | `E-Call-Return` |
| `checked_args(...,pending,...)` | either `pending=e::tail` or `pending=[]` | `E-Checked-Next`, `E-Checked-Ok`, or `E-Checked-Fail`; total `ok` selects success/failure |
| `check_result` | `w=true` or `w=false` | `E-Check-True` or `E-Check-False` |

No frame row overlaps another because the frame constructors are distinct. The only
success/failure split uses admitted total boolean predicates or canonical booleans.
Therefore decomposition is unique modulo fresh identity choice.

## 5. L39 Ordinary Preservation

**Lemma L39.** If `WT(C)` and `C --> C'` by an ordinary transition, then `WT(C')`.

The proof is by the L38-selected transition family.

| Transition family | Preservation derivation |
| --- | --- |
| Literals and unrestricted variables | L1, L5, and environment agreement give runtime value typing; `K` already expects that type. |
| `E-Let-Eval`, `E-Seq-Eval`, `E-If-Eval`, `E-Inject-Eval`, `E-Case-Eval`, `E-Check-Eval` | Push one frame typed by `frame-typing-proof.md`; source premises from inversion of the original typing derivation become frame premises. Carrier accounting is unchanged because pushed frames hold source syntax or no owner value. |
| `E-Let-Free` | Runtime value typing for `w` and `T:Free` extend environment agreement by L24; continuation type follows from `F-Let-Free`. |
| `E-Let-Linear` | L6 creates one fresh matching slot; L11 transfers carriers from `ret(w)` into that slot; `F-End-Linear-Pending` types body evaluation while the slot is live. |
| `E-End-Linear` | Readiness gives `Xi(ell)=moved(tau)`; popping the frame preserves `K` typing and carrier accounting because tombstones carry no owner. |
| `E-Move` | L7 tombstones one live unborrowed slot and returns the same arbitrary linear value; owner bijection moves carriers from slot component to control component. |
| `E-Consume` | L8 and primitive admission consume exactly declared owners, tombstone the slot, return `Unit`, and preserve unrelated store/slot/borrow/witness facts. |
| `E-Seq-Next` | Readiness gives `w=nil`; frame typing supplies the second expression derivation under the correct post-state. |
| Branch selection | L4 and L12 show selected branch is typed under the captured post-state and that discarded source syntax carries no owner. |
| Injection and case payload binding | Canonical sum inversion plus L25 type the selected payload. Linear payloads use L6 and `end_linear`; `Free` payloads extend `Gamma_f`. |
| Region entry | Fresh runtime region and witness layer preserve `WF(B,Xi)`, `WF_I`, and `K` typing modulo L36. |
| Region exit | L20-L23 close exactly local leases, reject returned local tokens, restore witness layer, and preserve writer-chain isolation. |
| Direct borrow | L14 or L15 extends `B` with one fresh lease and returns a typed `Free` token connected to the referent slot. |
| Reborrow | L17 or L18 atomically adds the child lease, suspends the parent, preserves `WF`, and returns the child token. |
| Borrow access | L16, L19, and primitive admission preserve owner carriers, slot type, witness state, and borrow topology while returning the admitted `Free` result or `Unit`. |
| Calls | L27-L30 and `call-entry-proof.md` cover path materialization, argument-frame carrier accounting, deterministic `instantiate_call`, owned-parameter binding, pending parameter obligations, exact return discharge, `B` restoration, witness restoration, and result bridging. |
| Checked primitive success | Primitive admission gives total `result` of the admitted `Free` type and preserves all machine state. |
| Attenuation | L33-L34 and primitive admission replace exactly one strong capability carrier with one fresh weaker carrier and record the accepted origin edge. |
| Fresh runtime choices | L36 and L37 transport typing and invariants across the selected fresh identity names. |

Every ordinary target re-establishes `Delta |- Sigma ok`, `Delta;Sigma_t;B |- Xi ok`,
`WF(B,Xi)`, witness well-formedness, environment agreement for evaluated control,
continuation typing, readiness for returned control when applicable, and the ordinary
carrier bijection. Hence `WT(C')`.

## 6. L40 Defined-Failure Preservation

**Lemma L40.** If `WT(C)` and `C --> C_t` by a first-core failure transition, then
`WT_TPOE(C_t)`.

The first core has exactly three failure families:

```text
E-Check-False
E-Checked-Zero-Fail
E-Checked-Fail
```

For each family the transition computes:

```text
A = abandoned_owners(control,K)
```

before erasing `K`. By L11, every live owner in the predecessor is in exactly one
of these places:

1. a live slot in `Xi`;
2. the current returned/control value;
3. an evaluated value field inside a continuation frame.

The failure transition changes no `Sigma`, `B`, `I`, or `Xi` entry. It removes the
ordinary control and stack, and records the owners from cases 2 and 3 in `A`.
Therefore `terminal_owners(Xi,A)` contains exactly the predecessor live resources
that remain live in `Sigma`, with no duplicates. Store typing, slot typing, lease
well-formedness, witness well-formedness, and capability-origin facts are inherited
unchanged. Primitive admission supplies the checked-failure reason shape for checked
primitives; canonical boolean inversion supplies `contract_false` for failed checks.
Thus the intrinsic terminal rule `WT_TPOE` applies.

This argument is not a reachability shortcut: `WT_TPOE` rechecks the terminal store,
slot, lease, witness, origin, and carrier invariants directly.

## 7. Theorem P

**Theorem P.** If `WT(C)` and `C --> C'`, then exactly one of the following holds:

1. `C'` is an ordinary configuration and `WT(C')`;
2. `C' = tpoe<q,Sigma,B,I,Xi,A>` and `WT_TPOE(C')`.

Proof. Invert the selected transition. The dynamic rules have two target syntactic
classes: ordinary machine configurations and terminal TPOE configurations. These
classes are disjoint. Ordinary rules are covered by L39. Failure rules are covered by
L40. No ordinary rule targets TPOE and no failure rule targets ordinary control.
Therefore exactly one branch holds.

## 8. Theorem Q

**Theorem Q.** If `WT(C)`, then exactly one of the following holds modulo
`fresh_step_equiv`:

1. `ordinary_final(C)`;
2. there exists one ordinary successor `C'` with `C --> C'`;
3. there exists one terminal successor `C_t` with `C --> C_t` and `WT_TPOE(C_t)`.

Proof. Split on the intrinsic control form.

If `C=<Sigma,B,I,Xi,ret(w),halt>`, then `ordinary_final(C)` holds. No step rule has
`halt` as a nonempty frame, so neither successor branch applies.

Otherwise, L38 gives exactly one selected transition family modulo fresh identity
choice. If the selected family is ordinary, branch 2 holds and branch 3 is excluded by
target syntax. If the selected family is one of the three failure families, L40 gives
`WT_TPOE` for the unique terminal target, so branch 3 holds and branch 2 is excluded
by target syntax. Primitive totality prevents a typed primitive configuration from
lacking a selected success/failure branch. Readiness prevents returned control from
being stuck at a frame whose immediate premises are not met. Therefore the three
cases are exhaustive and mutually exclusive.

TPOE itself is not a premise configuration for Theorem Q. It is a terminal successor
classified by `WT_TPOE`.

## 9. Evidence Boundary

This paper proof establishes `paper-proven` evidence for the narrow `lambda_K-seq`
theorem only. It does not prove compiler implementation, conformance, backend
lowering, unsafe/FFI wrappers, concurrency, standard-library algorithms, package
management, hosted services, or whole-core Lean mechanization. The executable runner
and narrow Lean artifact remain supporting evidence, not substitutes for this proof.
