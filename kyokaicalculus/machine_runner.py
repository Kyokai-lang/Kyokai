#!/usr/bin/env python3
# kyokai:prooftrace id=CALC-LAMBDA-K-SEQ
"""Execute the Gate-B lambda_K-seq machine slice used by regression review.

This is supporting executable evidence for selected high-risk transitions. It is not a
proof, a complete interpreter, or a replacement for the paper derivations.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from typing import TypeAlias

from model_tests import (
    BorrowState,
    PrimitiveRegistry,
    ResourceStore,
    SlotStore,
    Value,
    inject,
    mutate_borrow,
    observe_borrow,
    own,
    owner_ids,
    read_ref,
    run_checked_add,
    value_regions,
    write_ref,
)


@dataclass(frozen=True)
class ReturnValue:
    value: Value


@dataclass(frozen=True)
class Var:
    name: str


@dataclass(frozen=True)
class LetLinear:
    name: str
    type_name: str
    value: Expression
    body: Expression


@dataclass(frozen=True)
class LetFree:
    name: str
    value: Expression
    body: Expression


@dataclass(frozen=True)
class Move:
    name: str


@dataclass(frozen=True)
class Consume:
    operation: str
    name: str


@dataclass(frozen=True)
class If:
    condition: Expression
    when_true: Expression
    when_false: Expression


@dataclass(frozen=True)
class Seq:
    first: Expression
    second: Expression


@dataclass(frozen=True)
class Region:
    name: str
    body: Expression


@dataclass(frozen=True)
class Borrow:
    region: str
    lease: str
    owner: str


@dataclass(frozen=True)
class MutBorrow:
    region: str
    lease: str
    owner: str


@dataclass(frozen=True)
class Reborrow:
    region: str
    lease: str
    parent: str


@dataclass(frozen=True)
class ReadReborrow:
    region: str
    lease: str
    parent: str


@dataclass(frozen=True)
class ReadAccess:
    operation: str
    token: str


@dataclass(frozen=True)
class WriteAccess:
    operation: str
    token: str


@dataclass(frozen=True)
class Inject:
    tag: str
    payload: Expression


@dataclass(frozen=True)
class CaseArm:
    tag: str
    name: str
    type_name: str
    linear: bool
    body: Expression


@dataclass(frozen=True)
class Case:
    scrutinee: Expression
    arms: tuple[CaseArm, ...]


@dataclass(frozen=True)
class Call:
    function: str
    arguments: tuple[Expression, ...]


@dataclass(frozen=True)
class Checked:
    operation: str
    arguments: tuple[Expression, ...]


@dataclass(frozen=True)
class Attenuate:
    owner: str
    weak_kind: str


@dataclass(frozen=True)
class CheckTrue:
    pass


@dataclass(frozen=True)
class CheckFalse:
    pass


Expression: TypeAlias = (
    ReturnValue
    | Var
    | LetLinear
    | LetFree
    | Move
    | Consume
    | If
    | Seq
    | Region
    | Borrow
    | MutBorrow
    | Reborrow
    | ReadReborrow
    | ReadAccess
    | WriteAccess
    | Inject
    | Case
    | Call
    | Checked
    | Attenuate
    | CheckTrue
    | CheckFalse
)


@dataclass(frozen=True)
class FreeValue:
    value: Value


@dataclass(frozen=True)
class LinearSlot:
    slot: str


Binding: TypeAlias = FreeValue | LinearSlot
Environment: TypeAlias = dict[str, Binding]


@dataclass(frozen=True)
class Eval:
    expression: Expression
    environment: Environment


@dataclass(frozen=True)
class Ret:
    value: Value


Control: TypeAlias = Eval | Ret


@dataclass(frozen=True)
class LetBind:
    name: str
    type_name: str | None
    body: Expression
    environment: Environment


@dataclass(frozen=True)
class EndLinear:
    slot: str


@dataclass(frozen=True)
class IfSelect:
    when_true: Expression
    when_false: Expression
    environment: Environment


@dataclass(frozen=True)
class SeqNext:
    expression: Expression
    environment: Environment


@dataclass(frozen=True)
class RegionEnd:
    region: str


@dataclass(frozen=True)
class InjectValue:
    tag: str


@dataclass(frozen=True)
class CaseSelect:
    arms: tuple[CaseArm, ...]
    environment: Environment


@dataclass(frozen=True)
class CallArgs:
    function: str
    done: tuple[Value, ...]
    pending: tuple[Expression, ...]
    environment: Environment


@dataclass(frozen=True)
class CallReturn:
    parameter_slots: tuple[str, ...]


@dataclass(frozen=True)
class CheckResult:
    pass


@dataclass(frozen=True)
class CheckedArgs:
    operation: str
    done: tuple[Value, ...]
    pending: tuple[Expression, ...]
    environment: Environment


Frame: TypeAlias = (
    LetBind
    | EndLinear
    | IfSelect
    | SeqNext
    | RegionEnd
    | InjectValue
    | CaseSelect
    | CallArgs
    | CallReturn
    | CheckResult
    | CheckedArgs
)


@dataclass(frozen=True)
class Formal:
    name: str
    type_name: str
    linear: bool


@dataclass(frozen=True)
class Declaration:
    formals: tuple[Formal, ...]
    body: Expression


@dataclass(frozen=True)
class TerminalTpoe:
    reason: str
    live_slots: tuple[Value, ...]
    abandoned_owners: tuple[str, ...]


@dataclass
class Machine:
    resources: ResourceStore
    slots: SlotStore
    borrows: BorrowState
    declarations: dict[str, Declaration]
    control: Control
    stack: list[Frame] = field(default_factory=list)
    next_slot: int = 0
    next_resource: int = 0

    def fresh_slot(self, prefix: str) -> str:
        while True:
            candidate = f"{prefix}-{self.next_slot}"
            self.next_slot += 1
            if candidate not in self.slots.entries:
                return candidate

    def fresh_resource(self, prefix: str) -> str:
        while True:
            candidate = f"{prefix}-{self.next_resource}"
            self.next_resource += 1
            if candidate not in self.resources.live and candidate not in self.resources.consumed:
                return candidate


def slot_binding(environment: Environment, name: str) -> str:
    binding = environment[name]
    assert isinstance(binding, LinearSlot)
    return binding.slot


def free_binding(environment: Environment, name: str) -> Value:
    binding = environment[name]
    assert isinstance(binding, FreeValue)
    return binding.value


def live_slot_values(slots: SlotStore) -> list[Value]:
    return [
        value
        for state, _, value in slots.entries.values()
        if state == "live" and value is not None
    ]


def frame_values(stack: list[Frame]) -> list[Value]:
    values: list[Value] = []
    for frame in stack:
        if isinstance(frame, (CallArgs, CheckedArgs)):
            values.extend(frame.done)
    return values


def control_values(control: Control) -> list[Value]:
    if isinstance(control, Ret):
        return [control.value]
    return []


def owner_multiset(values: list[Value]) -> list[str]:
    return [resource for value in values for resource in owner_ids(value)]


def assert_ordinary_carrier_bijection(machine: Machine) -> None:
    machine.borrows.assert_well_formed(machine.slots)
    values = live_slot_values(machine.slots) + control_values(machine.control)
    values += frame_values(machine.stack)
    owners = owner_multiset(values)
    assert len(owners) == len(set(owners))
    assert set(machine.resources.live) == set(owners)


def terminalize(machine: Machine, reason: str) -> TerminalTpoe:
    abandoned = owner_multiset(control_values(machine.control) + frame_values(machine.stack))
    live_slots = tuple(live_slot_values(machine.slots))
    terminal_owners = owner_multiset(list(live_slots)) + abandoned
    assert len(terminal_owners) == len(set(terminal_owners))
    assert set(machine.resources.live) == set(terminal_owners)
    return TerminalTpoe(reason, live_slots, tuple(abandoned))


def enter_call(machine: Machine, function: str, arguments: tuple[Value, ...]) -> None:
    declaration = machine.declarations[function]
    assert len(arguments) == len(declaration.formals)
    environment: Environment = {}
    parameter_slots: list[str] = []
    for formal, argument in zip(declaration.formals, arguments, strict=True):
        if not formal.linear:
            environment[formal.name] = FreeValue(argument)
            continue
        slot = machine.fresh_slot(f"parameter-{formal.name}")
        machine.slots.bind(slot, formal.type_name, argument)
        environment[formal.name] = LinearSlot(slot)
        parameter_slots.append(slot)
    machine.stack.append(CallReturn(tuple(parameter_slots)))
    machine.control = Eval(declaration.body, environment)


def step(machine: Machine) -> str | TerminalTpoe:
    control = machine.control
    if isinstance(control, Eval):
        expression = control.expression
        environment = control.environment
        if isinstance(expression, ReturnValue):
            machine.control = Ret(expression.value)
            return "E-Value"
        if isinstance(expression, Var):
            machine.control = Ret(free_binding(environment, expression.name))
            return "E-Var-Free"
        if isinstance(expression, LetLinear):
            machine.stack.append(
                LetBind(expression.name, expression.type_name, expression.body, environment)
            )
            machine.control = Eval(expression.value, environment)
            return "E-Let-Eval"
        if isinstance(expression, LetFree):
            machine.stack.append(LetBind(expression.name, None, expression.body, environment))
            machine.control = Eval(expression.value, environment)
            return "E-Let-Eval"
        if isinstance(expression, Move):
            machine.control = Ret(
                machine.slots.move(slot_binding(environment, expression.name), machine.borrows)
            )
            return "E-Move"
        if isinstance(expression, Consume):
            machine.slots.consume(
                expression.operation,
                slot_binding(environment, expression.name),
                machine.borrows,
                machine.resources,
            )
            machine.control = Ret(None)
            return "E-Consume"
        if isinstance(expression, If):
            machine.stack.append(IfSelect(expression.when_true, expression.when_false, environment))
            machine.control = Eval(expression.condition, environment)
            return "E-If-Eval"
        if isinstance(expression, Seq):
            machine.stack.append(SeqNext(expression.second, environment))
            machine.control = Eval(expression.first, environment)
            return "E-Seq-Eval"
        if isinstance(expression, Region):
            machine.borrows.push(expression.name)
            machine.stack.append(RegionEnd(expression.name))
            machine.control = Eval(expression.body, environment)
            return "E-Region-Enter"
        if isinstance(expression, Borrow):
            slot = slot_binding(environment, expression.owner)
            machine.borrows.add_read(expression.lease, expression.region, slot)
            machine.control = Ret(read_ref(expression.region, expression.lease, slot))
            return "E-Borrow"
        if isinstance(expression, MutBorrow):
            slot = slot_binding(environment, expression.owner)
            machine.borrows.add_write(expression.lease, expression.region, slot)
            machine.control = Ret(write_ref(expression.region, expression.lease, slot))
            return "E-MutBorrow"
        if isinstance(expression, Reborrow):
            parent = free_binding(environment, expression.parent)
            _, _, parent_lease, _ = parent
            machine.borrows.reborrow_write(parent_lease, expression.lease, expression.region)
            machine.control = Ret(write_ref(expression.region, expression.lease, parent[3]))
            return "E-Reborrow"
        if isinstance(expression, ReadReborrow):
            parent = free_binding(environment, expression.parent)
            _, _, parent_lease, _ = parent
            machine.borrows.reborrow_read(parent_lease, expression.lease, expression.region)
            machine.control = Ret(read_ref(expression.region, expression.lease, parent[3]))
            return "E-Read-Reborrow"
        if isinstance(expression, ReadAccess):
            machine.control = Ret(
                observe_borrow(
                    free_binding(environment, expression.token), machine.slots, machine.borrows
                )
            )
            return "E-Read-Access"
        if isinstance(expression, WriteAccess):
            mutate_borrow(
                free_binding(environment, expression.token), machine.slots, machine.borrows
            )
            machine.control = Ret(None)
            return "E-Write-Access"
        if isinstance(expression, Inject):
            machine.stack.append(InjectValue(expression.tag))
            machine.control = Eval(expression.payload, environment)
            return "E-Inject-Eval"
        if isinstance(expression, Case):
            machine.stack.append(CaseSelect(expression.arms, environment))
            machine.control = Eval(expression.scrutinee, environment)
            return "E-Case-Eval"
        if isinstance(expression, Call):
            if not expression.arguments:
                enter_call(machine, expression.function, ())
                return "E-Call-Zero"
            first, *pending = expression.arguments
            machine.stack.append(CallArgs(expression.function, (), tuple(pending), environment))
            machine.control = Eval(first, environment)
            return "E-Call-Start"
        if isinstance(expression, Checked):
            if not expression.arguments:
                result = checked_result(expression.operation, ())
                if result is None:
                    return terminalize(machine, f"checked_failure({expression.operation})")
                machine.control = Ret(result)
                return "E-Checked-Zero-Ok"
            first, *pending = expression.arguments
            machine.stack.append(CheckedArgs(expression.operation, (), tuple(pending), environment))
            machine.control = Eval(first, environment)
            return "E-Checked-Start"
        if isinstance(expression, Attenuate):
            slot = slot_binding(environment, expression.owner)
            value = machine.slots.move(slot, machine.borrows)
            assert value[0] == "own"
            child = machine.fresh_resource("attenuated")
            machine.resources.attenuate(value[1], child, expression.weak_kind)
            machine.control = Ret(own(child))
            return "E-Attenuate"
        assert isinstance(expression, (CheckTrue, CheckFalse))
        machine.stack.append(CheckResult())
        machine.control = Ret(isinstance(expression, CheckTrue))
        return "E-Check-Eval"

    assert isinstance(control, Ret)
    assert machine.stack
    frame = machine.stack.pop()
    if isinstance(frame, LetBind):
        if frame.type_name is None:
            body_environment = dict(frame.environment)
            body_environment[frame.name] = FreeValue(control.value)
            machine.control = Eval(frame.body, body_environment)
            return "E-Let-Free"
        slot = machine.fresh_slot(f"local-{frame.name}")
        machine.slots.bind(slot, frame.type_name, control.value)
        body_environment = dict(frame.environment)
        body_environment[frame.name] = LinearSlot(slot)
        machine.stack.append(EndLinear(slot))
        machine.control = Eval(frame.body, body_environment)
        return "E-Let-Linear"
    if isinstance(frame, EndLinear):
        assert not machine.slots.is_live(frame.slot)
        return "E-End-Linear"
    if isinstance(frame, IfSelect):
        assert isinstance(control.value, bool)
        expression = frame.when_true if control.value else frame.when_false
        machine.control = Eval(expression, frame.environment)
        return "E-If-True" if control.value else "E-If-False"
    if isinstance(frame, SeqNext):
        assert control.value is None
        machine.control = Eval(frame.expression, frame.environment)
        return "E-Seq-Next"
    if isinstance(frame, RegionEnd):
        assert frame.region not in value_regions(control.value)
        machine.borrows.close(frame.region)
        return "E-Region-Exit"
    if isinstance(frame, InjectValue):
        machine.control = Ret(inject(frame.tag, control.value))
        return "E-Inject-Return"
    if isinstance(frame, CaseSelect):
        assert isinstance(control.value, tuple) and control.value[0] == "inject"
        _, tag, payload = control.value
        arm = next(arm for arm in frame.arms if arm.tag == tag)
        body_environment = dict(frame.environment)
        if arm.linear:
            slot = machine.fresh_slot(f"payload-{arm.name}")
            machine.slots.bind(slot, arm.type_name, payload)
            body_environment[arm.name] = LinearSlot(slot)
            machine.stack.append(EndLinear(slot))
        else:
            body_environment[arm.name] = FreeValue(payload)
        machine.control = Eval(arm.body, body_environment)
        return "E-Case-Select"
    if isinstance(frame, CallArgs):
        done = frame.done + (control.value,)
        if frame.pending:
            first, *pending = frame.pending
            machine.stack.append(CallArgs(frame.function, done, tuple(pending), frame.environment))
            machine.control = Eval(first, frame.environment)
            return "E-Call-Next"
        enter_call(machine, frame.function, done)
        return "E-Call-Enter"
    if isinstance(frame, CallReturn):
        for slot in frame.parameter_slots:
            assert not machine.slots.is_live(slot)
        return "E-Call-Return"
    if isinstance(frame, CheckedArgs):
        done = frame.done + (control.value,)
        if frame.pending:
            first, *pending = frame.pending
            machine.stack.append(
                CheckedArgs(frame.operation, done, tuple(pending), frame.environment)
            )
            machine.control = Eval(first, frame.environment)
            return "E-Checked-Next"
        result = checked_result(frame.operation, done)
        if result is None:
            return terminalize(machine, f"checked_failure({frame.operation})")
        machine.control = Ret(result)
        return "E-Checked-Ok"
    assert isinstance(frame, CheckResult)
    assert isinstance(control.value, bool)
    if control.value:
        machine.control = Ret(None)
        return "E-Check-True"
    return terminalize(machine, "contract_false")


def checked_result(operation: str, arguments: tuple[Value, ...]) -> Value | None:
    PrimitiveRegistry.standard().require_checked(operation)
    if operation == "checked_true":
        assert not arguments
        return True
    if operation == "checked_false":
        assert not arguments
        return None
    assert operation == "checked_add"
    assert len(arguments) == 2
    status, result = run_checked_add(
        PrimitiveRegistry.standard(), arguments[0], arguments[1], -128, 127
    )
    return result if status == "ok" else None


def run_to_completion(machine: Machine) -> tuple[list[str], TerminalTpoe | None]:
    trace: list[str] = []
    while True:
        assert_ordinary_carrier_bijection(machine)
        if isinstance(machine.control, Ret) and not machine.stack:
            return trace, None
        outcome = step(machine)
        if isinstance(outcome, TerminalTpoe):
            if outcome.reason == "contract_false":
                trace.append("E-Check-False")
            elif outcome.reason == "checked_failure(checked_false)":
                trace.append("E-Checked-Zero-Fail")
            else:
                trace.append("E-Checked-Fail")
            return trace, outcome
        trace.append(outcome)


def declarations() -> dict[str, Declaration]:
    return {
        "consume_file": Declaration(
            (Formal("file", "Resource[file]", True),),
            Consume("release_resource", "file"),
        ),
        "noop": Declaration((), ReturnValue(None)),
        "two_args": Declaration(
            (
                Formal("file", "Resource[file]", True),
                Formal("flag", "Bool", False),
            ),
            ReturnValue(None),
        ),
        "consume_file_flag": Declaration(
            (
                Formal("file", "Resource[file]", True),
                Formal("flag", "Bool", False),
            ),
            Consume("release_resource", "file"),
        ),
        "identity_file": Declaration(
            (Formal("file", "Resource[file]", True),),
            Move("file"),
        ),
    }


def test_linear_let_pending_obligation() -> None:
    slots = SlotStore()
    slots.bind("source-file", "Resource[file]", own("a"))
    machine = Machine(
        ResourceStore(live={"a": ("Resource[file]", "ordinary")}),
        slots,
        BorrowState(),
        declarations(),
        Eval(
            LetLinear(
                "file", "Resource[file]", Move("source"), Consume("release_resource", "file")
            ),
            {"source": LinearSlot("source-file")},
        ),
    )
    trace, terminal = run_to_completion(machine)
    assert terminal is None
    assert trace == ["E-Let-Eval", "E-Move", "E-Let-Linear", "E-Consume", "E-End-Linear"]
    assert not machine.resources.live


def test_branch_selection_keeps_one_slot_carrier() -> None:
    slots = SlotStore()
    slots.bind("file", "Resource[file]", own("a"))
    machine = Machine(
        ResourceStore(live={"a": ("Resource[file]", "ordinary")}),
        slots,
        BorrowState(),
        declarations(),
        Eval(
            If(
                ReturnValue(True),
                Consume("release_resource", "file"),
                Consume("release_resource", "file"),
            ),
            {"file": LinearSlot("file")},
        ),
    )
    trace, terminal = run_to_completion(machine)
    assert terminal is None
    assert trace == ["E-If-Eval", "E-Value", "E-If-True", "E-Consume"]
    assert not machine.resources.live


def test_arbitrary_linear_sum_moves_as_one_carrier() -> None:
    slots = SlotStore()
    value = inject("Some", own("a"))
    slots.bind("optional-file", "Optional[Resource[file]]", value)
    machine = Machine(
        ResourceStore(live={"a": ("Resource[file]", "ordinary")}),
        slots,
        BorrowState(),
        declarations(),
        Eval(Move("file"), {"file": LinearSlot("optional-file")}),
    )
    trace, terminal = run_to_completion(machine)
    assert terminal is None
    assert trace == ["E-Move"]
    assert machine.control == Ret(value)


def test_owned_call_parameter_pending_obligation() -> None:
    slots = SlotStore()
    slots.bind("caller-file", "Resource[file]", own("a"))
    machine = Machine(
        ResourceStore(live={"a": ("Resource[file]", "ordinary")}),
        slots,
        BorrowState(),
        declarations(),
        Eval(Call("consume_file", (Move("file"),)), {"file": LinearSlot("caller-file")}),
    )
    trace, terminal = run_to_completion(machine)
    assert terminal is None
    assert trace == ["E-Call-Start", "E-Move", "E-Call-Enter", "E-Consume", "E-Call-Return"]
    assert not machine.resources.live


def test_nested_tpoe_snapshots_erased_frame_carrier() -> None:
    slots = SlotStore()
    slots.bind("caller-file", "Resource[file]", own("a"))
    machine = Machine(
        ResourceStore(live={"a": ("Resource[file]", "ordinary")}),
        slots,
        BorrowState(),
        declarations(),
        Eval(Call("two_args", (Move("file"), CheckFalse())), {"file": LinearSlot("caller-file")}),
    )
    trace, terminal = run_to_completion(machine)
    assert trace == ["E-Call-Start", "E-Move", "E-Call-Next", "E-Check-Eval", "E-Check-False"]
    assert terminal == TerminalTpoe("contract_false", (), ("a",))


def test_mutable_reborrow_access_closes_before_owner_consumption() -> None:
    slots = SlotStore()
    slots.bind("file", "Resource[file]", own("a"))
    machine = Machine(
        ResourceStore(live={"a": ("Resource[file]", "ordinary")}),
        slots,
        BorrowState(),
        declarations(),
        Eval(
            Seq(
                Region(
                    "outer",
                    LetFree(
                        "parent",
                        MutBorrow("outer", "parent", "file"),
                        Seq(
                            Region(
                                "inner",
                                LetFree(
                                    "child",
                                    Reborrow("inner", "child", "parent"),
                                    WriteAccess("mutate", "child"),
                                ),
                            ),
                            WriteAccess("mutate", "parent"),
                        ),
                    ),
                ),
                Consume("release_resource", "file"),
            ),
            {"file": LinearSlot("file")},
        ),
    )
    trace, terminal = run_to_completion(machine)
    assert terminal is None
    assert trace == [
        "E-Seq-Eval",
        "E-Region-Enter",
        "E-Let-Eval",
        "E-MutBorrow",
        "E-Let-Free",
        "E-Seq-Eval",
        "E-Region-Enter",
        "E-Let-Eval",
        "E-Reborrow",
        "E-Let-Free",
        "E-Write-Access",
        "E-Region-Exit",
        "E-Seq-Next",
        "E-Write-Access",
        "E-Region-Exit",
        "E-Seq-Next",
        "E-Consume",
    ]
    assert not machine.resources.live
    assert not machine.borrows.regions
    assert not machine.borrows.leases


def test_read_reborrow_access_closes_before_owner_consumption() -> None:
    slots = SlotStore()
    slots.bind("file", "Resource[file]", own("a"))
    machine = Machine(
        ResourceStore(live={"a": ("Resource[file]", "ordinary")}),
        slots,
        BorrowState(),
        declarations(),
        Eval(
            Seq(
                Region(
                    "outer",
                    LetFree(
                        "parent",
                        MutBorrow("outer", "parent", "file"),
                        Region(
                            "inner",
                            LetFree(
                                "child",
                                ReadReborrow("inner", "child", "parent"),
                                LetFree("seen", ReadAccess("observe", "child"), ReturnValue(None)),
                            ),
                        ),
                    ),
                ),
                Consume("release_resource", "file"),
            ),
            {"file": LinearSlot("file")},
        ),
    )
    trace, terminal = run_to_completion(machine)
    assert terminal is None
    assert trace == [
        "E-Seq-Eval",
        "E-Region-Enter",
        "E-Let-Eval",
        "E-MutBorrow",
        "E-Let-Free",
        "E-Region-Enter",
        "E-Let-Eval",
        "E-Read-Reborrow",
        "E-Let-Free",
        "E-Let-Eval",
        "E-Read-Access",
        "E-Let-Free",
        "E-Value",
        "E-Region-Exit",
        "E-Region-Exit",
        "E-Seq-Next",
        "E-Consume",
    ]
    assert not machine.resources.live
    assert not machine.borrows.regions
    assert not machine.borrows.leases


def test_checked_primitive_success() -> None:
    machine = Machine(
        ResourceStore(),
        SlotStore(),
        BorrowState(),
        declarations(),
        Eval(Checked("checked_add", (ReturnValue(20), ReturnValue(22))), {}),
    )
    trace, terminal = run_to_completion(machine)
    assert terminal is None
    assert trace == ["E-Checked-Start", "E-Value", "E-Checked-Next", "E-Value", "E-Checked-Ok"]
    assert machine.control == Ret(42)


def test_checked_primitive_failure_snapshots_outer_frame_carrier() -> None:
    slots = SlotStore()
    slots.bind("caller-file", "Resource[file]", own("a"))
    machine = Machine(
        ResourceStore(live={"a": ("Resource[file]", "ordinary")}),
        slots,
        BorrowState(),
        declarations(),
        Eval(
            Call(
                "two_args",
                (Move("file"), Checked("checked_add", (ReturnValue(127), ReturnValue(1)))),
            ),
            {"file": LinearSlot("caller-file")},
        ),
    )
    trace, terminal = run_to_completion(machine)
    assert trace == [
        "E-Call-Start",
        "E-Move",
        "E-Call-Next",
        "E-Checked-Start",
        "E-Value",
        "E-Checked-Next",
        "E-Value",
        "E-Checked-Fail",
    ]
    assert terminal == TerminalTpoe("checked_failure(checked_add)", (), ("a",))


def test_capability_attenuation_transfers_one_owner() -> None:
    slots = SlotStore()
    slots.bind("root", "Capability[filesystem_root]", own("root"))
    machine = Machine(
        ResourceStore(live={"root": ("filesystem_root", "initial")}),
        slots,
        BorrowState(),
        declarations(),
        Eval(
            LetLinear(
                "child",
                "Capability[filesystem_subtree]",
                Attenuate("root", "filesystem_subtree"),
                Consume("release_resource", "child"),
            ),
            {"root": LinearSlot("root")},
        ),
    )
    trace, terminal = run_to_completion(machine)
    assert terminal is None
    assert trace == ["E-Let-Eval", "E-Attenuate", "E-Let-Linear", "E-Consume", "E-End-Linear"]
    assert not machine.resources.live
    assert machine.resources.consumed["root"] == ("filesystem_root", "initial")


def test_direct_read_borrow_access_closes_before_owner_consumption() -> None:
    slots = SlotStore()
    slots.bind("file", "Resource[file]", own("a"))
    machine = Machine(
        ResourceStore(live={"a": ("Resource[file]", "ordinary")}),
        slots,
        BorrowState(),
        declarations(),
        Eval(
            Seq(
                Region(
                    "read-scope",
                    LetFree(
                        "read-token",
                        Borrow("read-scope", "read", "file"),
                        LetFree(
                            "seen", ReadAccess("observe", "read-token"), ReturnValue(None)
                        ),
                    ),
                ),
                Consume("release_resource", "file"),
            ),
            {"file": LinearSlot("file")},
        ),
    )
    trace, terminal = run_to_completion(machine)
    assert terminal is None
    assert trace == [
        "E-Seq-Eval",
        "E-Region-Enter",
        "E-Let-Eval",
        "E-Borrow",
        "E-Let-Free",
        "E-Let-Eval",
        "E-Read-Access",
        "E-Let-Free",
        "E-Value",
        "E-Region-Exit",
        "E-Seq-Next",
        "E-Consume",
    ]
    assert not machine.resources.live


def test_case_selected_linear_payload_is_consumed_once() -> None:
    slots = SlotStore()
    slots.bind("optional-file", "Optional[Resource[file]]", inject("Some", own("a")))
    machine = Machine(
        ResourceStore(live={"a": ("Resource[file]", "ordinary")}),
        slots,
        BorrowState(),
        declarations(),
        Eval(
            Case(
                Move("optional"),
                (
                    CaseArm(
                        "Some",
                        "file",
                        "Resource[file]",
                        True,
                        Consume("release_resource", "file"),
                    ),
                    CaseArm("None", "unit", "Unit", False, ReturnValue(None)),
                ),
            ),
            {"optional": LinearSlot("optional-file")},
        ),
    )
    trace, terminal = run_to_completion(machine)
    assert terminal is None
    assert trace == ["E-Case-Eval", "E-Move", "E-Case-Select", "E-Consume", "E-End-Linear"]
    assert not machine.resources.live


def test_successful_contract_check_returns_unit() -> None:
    machine = Machine(
        ResourceStore(), SlotStore(), BorrowState(), declarations(), Eval(CheckTrue(), {})
    )
    trace, terminal = run_to_completion(machine)
    assert terminal is None
    assert trace == ["E-Check-Eval", "E-Check-True"]
    assert machine.control == Ret(None)


def test_zero_argument_call_enters_and_returns() -> None:
    machine = Machine(
        ResourceStore(), SlotStore(), BorrowState(), declarations(), Eval(Call("noop", ()), {})
    )
    trace, terminal = run_to_completion(machine)
    assert terminal is None
    assert trace == ["E-Call-Zero", "E-Value", "E-Call-Return"]
    assert machine.control == Ret(None)


def test_zero_argument_checked_primitive_succeeds() -> None:
    machine = Machine(
        ResourceStore(),
        SlotStore(),
        BorrowState(),
        declarations(),
        Eval(Checked("checked_true", ()), {}),
    )
    trace, terminal = run_to_completion(machine)
    assert terminal is None
    assert trace == ["E-Checked-Zero-Ok"]
    assert machine.control == Ret(True)


def test_injection_and_case_linear_payload_transfer() -> None:
    slots = SlotStore()
    slots.bind("file", "Resource[file]", own("a"))
    arms = (
        CaseArm(
            "Some",
            "selected",
            "Resource[file]",
            True,
            Consume("release_resource", "selected"),
        ),
        CaseArm("None", "unit", "Unit", False, ReturnValue(None)),
    )
    machine = Machine(
        ResourceStore(live={"a": ("Resource[file]", "ordinary")}),
        slots,
        BorrowState(),
        declarations(),
        Eval(
            LetLinear(
                "optional",
                "Optional[Resource[file]]",
                Inject("Some", Move("file")),
                Case(Move("optional"), arms),
            ),
            {"file": LinearSlot("file")},
        ),
    )
    trace, terminal = run_to_completion(machine)
    assert terminal is None
    assert trace == [
        "E-Let-Eval",
        "E-Inject-Eval",
        "E-Move",
        "E-Inject-Return",
        "E-Let-Linear",
        "E-Case-Eval",
        "E-Move",
        "E-Case-Select",
        "E-Consume",
        "E-End-Linear",
        "E-End-Linear",
    ]
    assert not machine.resources.live


def test_case_free_payload_binds_without_owner_slot() -> None:
    arms = (
        CaseArm("Some", "flag", "Bool", False, Var("flag")),
        CaseArm("None", "unit", "Unit", False, ReturnValue(None)),
    )
    machine = Machine(
        ResourceStore(),
        SlotStore(),
        BorrowState(),
        declarations(),
        Eval(Case(Inject("None", ReturnValue(None)), arms), {}),
    )
    trace, terminal = run_to_completion(machine)
    assert terminal is None
    assert trace == [
        "E-Case-Eval",
        "E-Inject-Eval",
        "E-Value",
        "E-Inject-Return",
        "E-Case-Select",
        "E-Value",
    ]
    assert machine.control == Ret(None)


def test_free_variable_round_trip() -> None:
    machine = Machine(
        ResourceStore(),
        SlotStore(),
        BorrowState(),
        declarations(),
        Eval(LetFree("flag", ReturnValue(True), Var("flag")), {}),
    )
    trace, terminal = run_to_completion(machine)
    assert terminal is None
    assert trace == ["E-Let-Eval", "E-Value", "E-Let-Free", "E-Var-Free"]
    assert machine.control == Ret(True)


def test_zero_argument_checked_primitive_failure() -> None:
    machine = Machine(
        ResourceStore(),
        SlotStore(),
        BorrowState(),
        declarations(),
        Eval(Checked("checked_false", ()), {}),
    )
    trace, terminal = run_to_completion(machine)
    assert trace == ["E-Checked-Zero-Fail"]
    assert terminal == TerminalTpoe("checked_failure(checked_false)", (), ())


def test_false_branch_selection_keeps_one_slot_carrier() -> None:
    slots = SlotStore()
    slots.bind("file", "Resource[file]", own("a"))
    machine = Machine(
        ResourceStore(live={"a": ("Resource[file]", "ordinary")}),
        slots,
        BorrowState(),
        declarations(),
        Eval(
            If(
                ReturnValue(False),
                Consume("release_resource", "file"),
                Consume("release_resource", "file"),
            ),
            {"file": LinearSlot("file")},
        ),
    )
    trace, terminal = run_to_completion(machine)
    assert terminal is None
    assert trace == ["E-If-Eval", "E-Value", "E-If-False", "E-Consume"]
    assert not machine.resources.live


def test_direct_mutable_borrow_write_closes_before_owner_consumption() -> None:
    slots = SlotStore()
    slots.bind("file", "Resource[file]", own("a"))
    machine = Machine(
        ResourceStore(live={"a": ("Resource[file]", "ordinary")}),
        slots,
        BorrowState(),
        declarations(),
        Eval(
            Seq(
                Region(
                    "write-scope",
                    LetFree(
                        "write-token",
                        MutBorrow("write-scope", "write", "file"),
                        WriteAccess("mutate", "write-token"),
                    ),
                ),
                Consume("release_resource", "file"),
            ),
            {"file": LinearSlot("file")},
        ),
    )
    trace, terminal = run_to_completion(machine)
    assert terminal is None
    assert trace == [
        "E-Seq-Eval",
        "E-Region-Enter",
        "E-Let-Eval",
        "E-MutBorrow",
        "E-Let-Free",
        "E-Write-Access",
        "E-Region-Exit",
        "E-Seq-Next",
        "E-Consume",
    ]
    assert not machine.resources.live


def test_direct_mutable_borrow_read_closes_before_owner_consumption() -> None:
    slots = SlotStore()
    slots.bind("file", "Resource[file]", own("a"))
    machine = Machine(
        ResourceStore(live={"a": ("Resource[file]", "ordinary")}),
        slots,
        BorrowState(),
        declarations(),
        Eval(
            Seq(
                Region(
                    "write-scope",
                    LetFree(
                        "write-token",
                        MutBorrow("write-scope", "write", "file"),
                        LetFree(
                            "seen",
                            ReadAccess("observe", "write-token"),
                            ReturnValue(None),
                        ),
                    ),
                ),
                Consume("release_resource", "file"),
            ),
            {"file": LinearSlot("file")},
        ),
    )
    trace, terminal = run_to_completion(machine)
    assert terminal is None
    assert trace == [
        "E-Seq-Eval",
        "E-Region-Enter",
        "E-Let-Eval",
        "E-MutBorrow",
        "E-Let-Free",
        "E-Let-Eval",
        "E-Read-Access",
        "E-Let-Free",
        "E-Value",
        "E-Region-Exit",
        "E-Seq-Next",
        "E-Consume",
    ]
    assert not machine.resources.live


def test_multi_argument_call_enters_after_source_ordered_evaluation() -> None:
    slots = SlotStore()
    slots.bind("caller-file", "Resource[file]", own("a"))
    machine = Machine(
        ResourceStore(live={"a": ("Resource[file]", "ordinary")}),
        slots,
        BorrowState(),
        declarations(),
        Eval(
            Call("consume_file_flag", (Move("file"), ReturnValue(True))),
            {"file": LinearSlot("caller-file")},
        ),
    )
    trace, terminal = run_to_completion(machine)
    assert terminal is None
    assert trace == [
        "E-Call-Start",
        "E-Move",
        "E-Call-Next",
        "E-Value",
        "E-Call-Enter",
        "E-Consume",
        "E-Call-Return",
    ]
    assert not machine.resources.live


def test_owned_call_return_transfers_parameter_carrier() -> None:
    slots = SlotStore()
    slots.bind("caller-file", "Resource[file]", own("a"))
    machine = Machine(
        ResourceStore(live={"a": ("Resource[file]", "ordinary")}),
        slots,
        BorrowState(),
        declarations(),
        Eval(Call("identity_file", (Move("file"),)), {"file": LinearSlot("caller-file")}),
    )
    trace, terminal = run_to_completion(machine)
    assert terminal is None
    assert trace == ["E-Call-Start", "E-Move", "E-Call-Enter", "E-Move", "E-Call-Return"]
    assert machine.control == Ret(own("a"))


def test_region_exit_rejects_returned_local_borrow() -> None:
    slots = SlotStore()
    slots.bind("file", "Resource[file]", own("a"))
    machine = Machine(
        ResourceStore(live={"a": ("Resource[file]", "ordinary")}),
        slots,
        BorrowState(),
        declarations(),
        Eval(
            Region("read-scope", Borrow("read-scope", "read", "file")),
            {"file": LinearSlot("file")},
        ),
    )
    assert_ordinary_carrier_bijection(machine)
    assert step(machine) == "E-Region-Enter"
    assert_ordinary_carrier_bijection(machine)
    assert step(machine) == "E-Borrow"
    assert_ordinary_carrier_bijection(machine)
    try:
        step(machine)
    except AssertionError:
        return
    raise AssertionError("region exit accepted a returned local borrow token")


def main() -> None:
    tests = [
        test_linear_let_pending_obligation,
        test_branch_selection_keeps_one_slot_carrier,
        test_arbitrary_linear_sum_moves_as_one_carrier,
        test_owned_call_parameter_pending_obligation,
        test_nested_tpoe_snapshots_erased_frame_carrier,
        test_mutable_reborrow_access_closes_before_owner_consumption,
        test_read_reborrow_access_closes_before_owner_consumption,
        test_checked_primitive_success,
        test_checked_primitive_failure_snapshots_outer_frame_carrier,
        test_capability_attenuation_transfers_one_owner,
        test_direct_read_borrow_access_closes_before_owner_consumption,
        test_case_selected_linear_payload_is_consumed_once,
        test_successful_contract_check_returns_unit,
        test_zero_argument_call_enters_and_returns,
        test_zero_argument_checked_primitive_succeeds,
        test_injection_and_case_linear_payload_transfer,
        test_case_free_payload_binds_without_owner_slot,
        test_free_variable_round_trip,
        test_zero_argument_checked_primitive_failure,
        test_false_branch_selection_keeps_one_slot_carrier,
        test_direct_mutable_borrow_write_closes_before_owner_consumption,
        test_direct_mutable_borrow_read_closes_before_owner_consumption,
        test_multi_argument_call_enters_after_source_ordered_evaluation,
        test_owned_call_return_transfers_parameter_carrier,
        test_region_exit_rejects_returned_local_borrow,
    ]
    for test in tests:
        test()
    print(f"lambda_K-seq executable machine slice: {len(tests)} traces passed")


if __name__ == "__main__":
    main()
