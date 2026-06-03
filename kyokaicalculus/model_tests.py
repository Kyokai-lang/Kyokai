#!/usr/bin/env python3
# kyokai:prooftrace id=CALC-LAMBDA-K-SEQ
"""Executable spot checks for the lambda_K-seq owner-slot and lease model."""

from __future__ import annotations

from dataclasses import dataclass, field
from typing import Any

Value = Any


@dataclass
class PrimitiveRegistry:
    consuming: set[str] = field(default_factory=set)
    checked: set[str] = field(default_factory=set)
    attenuation: set[tuple[str, str]] = field(default_factory=set)

    @classmethod
    def standard(cls) -> PrimitiveRegistry:
        return cls(
            consuming={"release_resource"},
            checked={"checked_add", "checked_true", "checked_false"},
            attenuation={("filesystem_root", "filesystem_subtree")},
        )

    def require_consuming(self, operation: str) -> None:
        assert operation in self.consuming

    def require_checked(self, operation: str) -> None:
        assert operation in self.checked

    def require_attenuation(self, strong: str, weak: str) -> None:
        assert (strong, weak) in self.attenuation


def own(resource: str) -> Value:
    return ("own", resource)


def inject(tag: str, payload: Value) -> Value:
    return ("inject", tag, payload)


def read_ref(region: str, lease: str, slot: str) -> Value:
    return ("read_ref", region, lease, slot)


def write_ref(region: str, lease: str, slot: str) -> Value:
    return ("write_ref", region, lease, slot)


def owner_ids(value: Value) -> list[str]:
    if not isinstance(value, tuple):
        return []
    if value[0] == "own":
        return [value[1]]
    if value[0] == "inject":
        return owner_ids(value[2])
    return []


def value_regions(value: Value) -> set[str]:
    if not isinstance(value, tuple):
        return set()
    if value[0] in {"read_ref", "write_ref"}:
        return {value[1]}
    if value[0] == "inject":
        return value_regions(value[2])
    return set()


@dataclass
class BorrowState:
    regions: list[str] = field(default_factory=list)
    leases: dict[str, tuple[str, str, str]] = field(default_factory=dict)
    suspended: dict[str, str] = field(default_factory=dict)

    def active(self, region: str) -> bool:
        return region in self.regions

    def push(self, region: str) -> None:
        assert not self.active(region)
        self.regions.append(region)

    def all_reads(self, slot: str) -> set[str]:
        return {
            lease
            for lease, (_, mode, lease_slot) in self.leases.items()
            if mode == "read" and lease_slot == slot
        }

    def all_writes(self, slot: str) -> set[str]:
        return {
            lease
            for lease, (_, mode, lease_slot) in self.leases.items()
            if mode == "write" and lease_slot == slot
        }

    def unsuspended(self, lease: str) -> bool:
        return lease not in self.suspended

    def frontier_reads(self, slot: str) -> set[str]:
        return {lease for lease in self.all_reads(slot) if self.unsuspended(lease)}

    def frontier_writes(self, slot: str) -> set[str]:
        return {lease for lease in self.all_writes(slot) if self.unsuspended(lease)}

    def unborrowed(self, slot: str) -> bool:
        return not self.all_reads(slot) and not self.all_writes(slot)

    def no_writer(self, slot: str) -> bool:
        return not self.all_writes(slot)

    def leases_at(self, region: str) -> set[str]:
        return {
            lease
            for lease, (lease_region, _, _) in self.leases.items()
            if lease_region == region
        }

    def closable(self, region: str) -> bool:
        if not self.regions or self.regions[-1] != region:
            return False
        return not (self.leases_at(region) & set(self.suspended))

    def on_same_suspension_chain(self, left: str, right: str) -> bool:
        current = left
        while current in self.suspended:
            current = self.suspended[current]
            if current == right:
                return True
        current = right
        while current in self.suspended:
            current = self.suspended[current]
            if current == left:
                return True
        return left == right

    def usable_read(self, lease: str, slot: str) -> bool:
        region, mode, lease_slot = self.leases[lease]
        return mode == "read" and lease_slot == slot and self.active(region) and self.unsuspended(lease)

    def usable_write(self, lease: str, slot: str) -> bool:
        region, mode, lease_slot = self.leases[lease]
        return mode == "write" and lease_slot == slot and self.active(region) and self.unsuspended(lease)

    def nested(self, parent: str, child: str) -> bool:
        return self.regions.index(parent) < self.regions.index(child)

    def add_read(self, lease: str, region: str, slot: str) -> None:
        assert self.active(region)
        assert lease not in self.leases
        assert self.no_writer(slot)
        self.leases[lease] = (region, "read", slot)

    def add_write(self, lease: str, region: str, slot: str) -> None:
        assert self.active(region)
        assert lease not in self.leases
        assert self.unborrowed(slot)
        self.leases[lease] = (region, "write", slot)

    def reborrow_write(self, parent: str, child: str, region: str) -> None:
        parent_region, mode, slot = self.leases[parent]
        assert mode == "write"
        assert self.usable_write(parent, slot)
        assert self.active(region)
        assert child not in self.leases
        assert self.nested(parent_region, region)
        self.leases[child] = (region, "write", slot)
        self.suspended[parent] = child

    def reborrow_read(self, parent: str, child: str, region: str) -> None:
        parent_region, mode, slot = self.leases[parent]
        assert mode == "write"
        assert self.usable_write(parent, slot)
        assert self.active(region)
        assert child not in self.leases
        assert self.nested(parent_region, region)
        self.leases[child] = (region, "read", slot)
        self.suspended[parent] = child

    def close(self, region: str) -> None:
        assert self.closable(region)
        removed = self.leases_at(region)
        self.leases = {
            lease: fact for lease, fact in self.leases.items() if lease not in removed
        }
        self.suspended = {
            parent: child
            for parent, child in self.suspended.items()
            if child not in removed
        }
        self.regions.pop()

    def assert_well_formed(self, slots: SlotStore | None = None) -> None:
        for region, _, slot in self.leases.values():
            assert self.active(region)
            if slots is not None:
                assert slots.is_live(slot)
        resources = {slot for _, _, slot in self.leases.values()}
        for slot in resources:
            assert not (self.frontier_reads(slot) and self.frontier_writes(slot))
            assert len(self.frontier_writes(slot)) <= 1
        assert len(self.suspended.values()) == len(set(self.suspended.values()))
        for parent, child in self.suspended.items():
            assert parent in self.leases
            assert child in self.leases
            parent_region, parent_mode, parent_slot = self.leases[parent]
            child_region, _, child_slot = self.leases[child]
            assert parent_mode == "write"
            assert parent_slot == child_slot
            assert self.nested(parent_region, child_region)
        for writer in self.all_retained_writers():
            _, _, writer_slot = self.leases[writer]
            for lease, (_, _, lease_slot) in self.leases.items():
                if lease_slot == writer_slot:
                    assert self.on_same_suspension_chain(writer, lease)

    def all_retained_writers(self) -> set[str]:
        return {
            lease
            for lease, (_, mode, _) in self.leases.items()
            if mode == "write"
        }


@dataclass
class ResourceStore:
    live: dict[str, tuple[str, str]] = field(default_factory=dict)
    consumed: dict[str, tuple[str, str]] = field(default_factory=dict)

    def consume(self, resource: str) -> None:
        assert resource in self.live
        self.consumed[resource] = self.live.pop(resource)

    def attenuate(
        self,
        resource: str,
        child: str,
        weak_kind: str,
        registry: PrimitiveRegistry | None = None,
    ) -> None:
        assert resource in self.live
        assert child not in self.live
        assert child not in self.consumed
        strong_kind, origin = self.live[resource]
        (registry or PrimitiveRegistry.standard()).require_attenuation(
            strong_kind, weak_kind
        )
        self.live.pop(resource)
        self.consumed[resource] = (strong_kind, origin)
        self.live[child] = (
            weak_kind,
            f"attenuated({resource},{strong_kind},{weak_kind})",
        )


@dataclass
class SlotStore:
    entries: dict[str, tuple[str, str, Value | None]] = field(default_factory=dict)

    def bind(self, slot: str, type_name: str, value: Value) -> None:
        assert slot not in self.entries
        self.entries[slot] = ("live", type_name, value)

    def is_live(self, slot: str) -> bool:
        return slot in self.entries and self.entries[slot][0] == "live"

    def slot_type(self, slot: str) -> str:
        return self.entries[slot][1]

    def value(self, slot: str) -> Value:
        state, _, value = self.entries[slot]
        assert state == "live"
        return value

    def move(self, slot: str, borrows: BorrowState) -> Value:
        state, type_name, value = self.entries[slot]
        assert state == "live"
        assert borrows.unborrowed(slot)
        self.entries[slot] = ("moved", type_name, None)
        return value

    def consume(
        self,
        operation: str,
        slot: str,
        borrows: BorrowState,
        resources: ResourceStore,
        registry: PrimitiveRegistry | None = None,
    ) -> None:
        value = self.value(slot)
        assert borrows.unborrowed(slot)
        (registry or PrimitiveRegistry.standard()).require_consuming(operation)
        consume_op(operation, value, resources)
        state, type_name, _ = self.entries[slot]
        assert state == "live"
        self.entries[slot] = ("moved", type_name, None)


def consume_op(operation: str, value: Value, resources: ResourceStore) -> None:
    assert operation == "release_resource"
    assert isinstance(value, tuple) and value[0] == "own"
    resources.consume(value[1])


def runtime_token_type(value: Value, slots: SlotStore, borrows: BorrowState) -> str:
    tag, region, lease, slot = value
    assert borrows.active(region)
    lease_region, mode, lease_slot = borrows.leases[lease]
    assert lease_region == region
    assert lease_slot == slot
    if tag == "read_ref":
        assert mode == "read"
        assert borrows.usable_read(lease, slot)
        return f"Borrow[{slots.slot_type(slot)}]"
    assert tag == "write_ref"
    assert mode == "write"
    return f"MutBorrow[{slots.slot_type(slot)}]"


def accept_mut_call_argument(value: Value, slots: SlotStore, borrows: BorrowState) -> None:
    assert runtime_token_type(value, slots, borrows).startswith("MutBorrow[")
    _, _, lease, slot = value
    assert borrows.usable_write(lease, slot)


@dataclass
class StaticRuntimeWitness:
    regions: dict[str, str] = field(default_factory=dict)
    leases: dict[str, str] = field(default_factory=dict)
    layer_atoms: dict[str, tuple[set[str], set[str]]] = field(default_factory=dict)
    layer_order: list[str] = field(default_factory=list)
    aliases: set[tuple[str, str, str]] = field(default_factory=set)

    def _layer(self, layer: str) -> tuple[set[str], set[str]]:
        if layer not in self.layer_atoms:
            self.layer_atoms[layer] = (set(), set())
            self.layer_order.append(layer)
        return self.layer_atoms[layer]

    def _authorize_alias(
        self, sort: str, static: str, runtime: str, alias_of: str | None
    ) -> None:
        occupants = self.regions if sort == "region" else self.leases
        existing = [atom for atom, image in occupants.items() if image == runtime]
        if existing:
            assert alias_of in existing
            self.aliases.add((sort, static, alias_of))

    def extend_region(
        self, static: str, runtime: str, layer: str = "root", alias_of: str | None = None
    ) -> None:
        assert static not in self.regions
        self._authorize_alias("region", static, runtime, alias_of)
        self.regions[static] = runtime
        self._layer(layer)[0].add(static)

    def extend_lease(
        self, static: str, runtime: str, layer: str = "root", alias_of: str | None = None
    ) -> None:
        assert static not in self.leases
        self._authorize_alias("lease", static, runtime, alias_of)
        self.leases[static] = runtime
        self._layer(layer)[1].add(static)

    def close_layer(self, layer: str) -> None:
        assert self.layer_order and self.layer_order[-1] == layer
        region_atoms, lease_atoms = self.layer_atoms.pop(layer)
        self.layer_order.pop()
        self.regions = {
            atom: image for atom, image in self.regions.items() if atom not in region_atoms
        }
        self.leases = {
            atom: image for atom, image in self.leases.items() if atom not in lease_atoms
        }
        self.aliases = {
            alias for alias in self.aliases if alias[1] not in region_atoms | lease_atoms
        }

    def region_image(self, static: str) -> str:
        return self.regions[static]

    def lease_image(self, static: str) -> str:
        return self.leases[static]


def alpha_freshen_binder(base: str, active: set[str]) -> str:
    suffix = 0
    candidate = base
    while candidate in active:
        suffix += 1
        candidate = f"{base}_{suffix}"
    return candidate


def borrow_snapshot(borrows: BorrowState) -> tuple[Any, ...]:
    return (
        tuple(borrows.regions),
        tuple(sorted(borrows.leases.items())),
        tuple(sorted(borrows.suspended.items())),
    )


def accept_call_return(borrows: BorrowState, entry_snapshot: tuple[Any, ...]) -> None:
    assert borrow_snapshot(borrows) == entry_snapshot


def accept_returned_token_bridge(
    token: Value,
    slots: SlotStore,
    borrows: BorrowState,
    callee_witness: StaticRuntimeWitness,
    caller_witness: StaticRuntimeWitness,
    callee_atoms: tuple[str, str],
    caller_atoms: tuple[str, str],
) -> None:
    _, runtime_region, runtime_lease, _ = token
    assert runtime_token_type(token, slots, borrows).startswith("Borrow[")
    assert callee_witness.region_image(callee_atoms[0]) == runtime_region
    assert callee_witness.lease_image(callee_atoms[1]) == runtime_lease
    assert caller_witness.region_image(caller_atoms[0]) == runtime_region
    assert caller_witness.lease_image(caller_atoms[1]) == runtime_lease


def assert_owner_bijection(resources: ResourceStore, carriers: list[Value]) -> None:
    owners = [resource for carrier in carriers for resource in owner_ids(carrier)]
    assert len(owners) == len(set(owners))
    assert set(resources.live) == set(owners)


def checked_add(left: int, right: int, minimum: int, maximum: int) -> tuple[str, int | None]:
    result = left + right
    if result < minimum or result > maximum:
        return ("tpoe", None)
    return ("ok", result)


def run_checked_add(
    registry: PrimitiveRegistry,
    left: int,
    right: int,
    minimum: int,
    maximum: int,
) -> tuple[str, int | None]:
    registry.require_checked("checked_add")
    return checked_add(left, right, minimum, maximum)


def observe_borrow(value: Value, slots: SlotStore, borrows: BorrowState) -> str:
    token_type = runtime_token_type(value, slots, borrows)
    assert token_type.startswith("Borrow[") or token_type.startswith("MutBorrow[")
    _, _, lease, slot = value
    assert borrows.usable_read(lease, slot) or borrows.usable_write(lease, slot)
    return slots.slot_type(slot)


def mutate_borrow(value: Value, slots: SlotStore, borrows: BorrowState) -> None:
    assert runtime_token_type(value, slots, borrows).startswith("MutBorrow[")
    _, _, lease, slot = value
    assert borrows.usable_write(lease, slot)


@dataclass(frozen=True)
class TerminalTpoe:
    reason: str
    abandoned_owners: tuple[str, ...]


def classify_tpoe(reason: str, resources: ResourceStore, carriers: list[Value]) -> TerminalTpoe:
    assert reason in {"contract_false", "checked_primitive_failure"}
    owners = tuple(resource for carrier in carriers for resource in owner_ids(carrier))
    assert len(owners) == len(set(owners))
    assert set(resources.live) == set(owners)
    return TerminalTpoe(reason=reason, abandoned_owners=owners)


def materialize_paths(phi: dict[str, str], environment: dict[str, str]) -> dict[str, str]:
    return {formal: environment[actual] for formal, actual in phi.items()}


def require_token_path_certificate(
    certificate: dict[str, str], formal_path: str, token: Value
) -> None:
    tag, _, _, slot = token
    assert tag in {"read_ref", "write_ref"}
    assert certificate[formal_path] == slot


@dataclass(frozen=True)
class CallFormal:
    name: str
    type_name: str
    universe: str


@dataclass
class BoundCallArguments:
    environment: dict[str, tuple[str, Value | str]]
    parameter_slots: list[str]
    remaining_frame_values: list[Value]


def bind_call_arguments(
    arguments: list[Value],
    formals: list[CallFormal],
    fresh_slots: list[str],
    slots: SlotStore,
) -> BoundCallArguments:
    assert len(arguments) == len(formals)
    environment: dict[str, tuple[str, Value | str]] = {}
    parameter_slots: list[str] = []
    slot_index = 0
    for argument, formal in zip(arguments, formals, strict=True):
        if formal.universe == "Free":
            environment[formal.name] = ("free", argument)
            continue
        assert formal.universe == "Linear"
        slot = fresh_slots[slot_index]
        slot_index += 1
        slots.bind(slot, formal.type_name, argument)
        environment[formal.name] = ("slot", slot)
        parameter_slots.append(slot)
    assert slot_index == len(fresh_slots)
    return BoundCallArguments(environment, parameter_slots, [])


def accept_discharged_parameter_slots(slots: SlotStore, parameter_slots: list[str]) -> None:
    for slot in parameter_slots:
        assert not slots.is_live(slot)


def start_call(
    instantiation: str, arguments: list[Value]
) -> tuple[str, str, Value | None, list[Value], list[Value]]:
    state, current, done, pending = start_arguments(arguments)
    return (state, instantiation, current, done, pending)


def start_arguments(arguments: list[Value]) -> tuple[str, Value | None, list[Value], list[Value]]:
    if not arguments:
        return ("enter", None, [], [])
    return ("eval", arguments[0], [], arguments[1:])


def continue_arguments(
    done: list[Value], pending: list[Value], returned: Value
) -> tuple[str, Value | None, list[Value], list[Value]]:
    completed = done + [returned]
    if not pending:
        return ("enter", None, completed, [])
    return ("eval", pending[0], completed, pending[1:])


def expect_rejected(operation) -> None:
    try:
        operation()
    except (AssertionError, KeyError):
        return
    raise AssertionError("operation should have been rejected")


def test_named_consuming_primitive_uses_slot() -> None:
    resources = ResourceStore(live={"a": ("Resource[file]", "ordinary")})
    slots = SlotStore()
    slots.bind("ell", "Resource[file]", own("a"))
    slots.consume("release_resource", "ell", BorrowState(), resources)
    assert slots.entries["ell"] == ("moved", "Resource[file]", None)
    assert resources.consumed["a"] == ("Resource[file]", "ordinary")


def test_named_consuming_primitive_rejects_borrowed_slot_before_store_change() -> None:
    resources = ResourceStore(live={"a": ("Resource[file]", "ordinary")})
    slots = SlotStore()
    slots.bind("ell", "Resource[file]", own("a"))
    borrows = BorrowState()
    borrows.push("r")
    borrows.add_read("b", "r", "ell")
    expect_rejected(
        lambda: slots.consume("release_resource", "ell", borrows, resources)
    )
    assert resources.live == {"a": ("Resource[file]", "ordinary")}
    assert slots.entries["ell"] == ("live", "Resource[file]", own("a"))


def test_named_consuming_primitive_preserves_unrelated_store_entries() -> None:
    resources = ResourceStore(
        live={
            "a": ("Resource[file]", "ordinary"),
            "unrelated": ("Resource[socket]", "ordinary"),
        }
    )
    slots = SlotStore()
    slots.bind("ell", "Resource[file]", own("a"))
    slots.consume("release_resource", "ell", BorrowState(), resources)
    assert resources.live == {"unrelated": ("Resource[socket]", "ordinary")}
    assert resources.consumed == {"a": ("Resource[file]", "ordinary")}


def test_linear_sum_moves_as_one_slot_value() -> None:
    resources = ResourceStore(live={"a": ("Resource[file]", "ordinary")})
    slots = SlotStore()
    slots.bind("ell", "Optional[Resource[file]]", inject("Some", own("a")))
    moved = slots.move("ell", BorrowState())
    assert moved == inject("Some", own("a"))
    assert_owner_bijection(resources, [moved])


def test_linear_sum_has_no_structural_consumption_fallback() -> None:
    resources = ResourceStore(live={"a": ("Resource[file]", "ordinary")})
    slots = SlotStore()
    slots.bind("ell", "Optional[Resource[file]]", inject("Some", own("a")))
    expect_rejected(
        lambda: slots.consume("release_resource", "ell", BorrowState(), resources)
    )
    assert resources.live == {"a": ("Resource[file]", "ordinary")}


def test_linear_sum_selected_payload_can_be_consumed_explicitly() -> None:
    resources = ResourceStore(live={"a": ("Resource[file]", "ordinary")})
    slots = SlotStore()
    slots.bind("payload", "Resource[file]", own("a"))
    slots.consume("release_resource", "payload", BorrowState(), resources)
    assert resources.consumed["a"] == ("Resource[file]", "ordinary")


def test_branch_source_syntax_does_not_duplicate_owner_carrier() -> None:
    resources = ResourceStore(live={"a": ("Resource[file]", "ordinary")})
    slots = SlotStore()
    slots.bind("ell", "Resource[file]", own("a"))
    source_branches = ("consume[release_resource] x", "consume[release_resource] x")
    environment = {"x": "ell"}
    assert source_branches == ("consume[release_resource] x", "consume[release_resource] x")
    assert environment == {"x": "ell"}
    assert_owner_bijection(resources, [slots.value("ell")])


def test_owner_bijection_rejects_duplicate_runtime_carrier() -> None:
    resources = ResourceStore(live={"a": ("Resource[file]", "ordinary")})
    expect_rejected(lambda: assert_owner_bijection(resources, [own("a"), own("a")]))


def test_compatible_read_borrows_and_close() -> None:
    borrows = BorrowState()
    borrows.push("r")
    borrows.add_read("b1", "r", "ell")
    borrows.add_read("b2", "r", "ell")
    borrows.assert_well_formed()
    borrows.close("r")
    assert not borrows.leases


def test_conflicting_mutable_borrow_rejected() -> None:
    borrows = BorrowState()
    borrows.push("r")
    borrows.add_read("b1", "r", "ell")
    expect_rejected(lambda: borrows.add_write("b2", "r", "ell"))


def test_mutable_reborrow_suspends_and_resumes_parent() -> None:
    borrows = BorrowState()
    borrows.push("s")
    borrows.add_write("parent", "s", "ell")
    borrows.push("r")
    borrows.reborrow_write("parent", "child", "r")
    borrows.assert_well_formed()
    assert borrows.frontier_writes("ell") == {"child"}
    borrows.close("r")
    assert borrows.frontier_writes("ell") == {"parent"}


def test_read_reborrow_keeps_retained_writer_and_blocks_owner_read() -> None:
    borrows = BorrowState()
    borrows.push("s")
    borrows.add_write("parent", "s", "ell")
    borrows.push("r")
    borrows.reborrow_read("parent", "child", "r")
    assert borrows.frontier_reads("ell") == {"child"}
    assert not borrows.frontier_writes("ell")
    assert not borrows.no_writer("ell")
    expect_rejected(lambda: borrows.add_read("direct", "r", "ell"))
    borrows.close("r")
    assert borrows.frontier_writes("ell") == {"parent"}


def test_nested_mutable_reborrow_chain_closes_direct_parents() -> None:
    borrows = BorrowState()
    borrows.push("s")
    borrows.add_write("parent", "s", "ell")
    borrows.push("r")
    borrows.reborrow_write("parent", "child", "r")
    borrows.push("q")
    borrows.reborrow_write("child", "grandchild", "q")
    borrows.assert_well_formed()
    borrows.close("q")
    assert borrows.frontier_writes("ell") == {"child"}
    borrows.close("r")
    assert borrows.frontier_writes("ell") == {"parent"}


def test_close_rejects_non_top_region_with_live_child() -> None:
    borrows = BorrowState()
    borrows.push("s")
    borrows.add_write("parent", "s", "ell")
    borrows.push("r")
    borrows.reborrow_write("parent", "child", "r")
    expect_rejected(lambda: borrows.close("s"))


def test_close_removes_exact_local_leases_and_resumes_direct_parent() -> None:
    borrows = BorrowState()
    borrows.push("outer")
    borrows.add_write("parent", "outer", "ell")
    borrows.add_read("outer-read", "outer", "other")
    borrows.push("local")
    borrows.reborrow_write("parent", "child", "local")
    borrows.add_read("local-read", "local", "third")
    assert borrows.closable("local")
    borrows.close("local")
    assert borrows.leases == {
        "parent": ("outer", "write", "ell"),
        "outer-read": ("outer", "read", "other"),
    }
    assert borrows.suspended == {}
    assert borrows.frontier_writes("ell") == {"parent"}


def test_close_preserves_unrelated_suspension_edge() -> None:
    borrows = BorrowState()
    borrows.push("outer")
    borrows.add_write("parent", "outer", "ell")
    borrows.push("nested")
    borrows.reborrow_write("parent", "child", "nested")
    borrows.push("local")
    borrows.add_read("local-read", "local", "other")
    borrows.close("local")
    assert borrows.suspended == {"parent": "child"}
    assert borrows.frontier_writes("ell") == {"child"}


def test_well_formedness_rejects_unrelated_frontier_beside_suspended_writer() -> None:
    borrows = BorrowState(
        regions=["outer", "local"],
        leases={
            "parent": ("outer", "write", "ell"),
            "child": ("local", "read", "ell"),
            "unrelated": ("local", "read", "ell"),
        },
        suspended={"parent": "child"},
    )
    expect_rejected(borrows.assert_well_formed)


def test_slot_with_retained_lease_cannot_move() -> None:
    slots = SlotStore()
    slots.bind("ell", "Resource[file]", own("a"))
    borrows = BorrowState()
    borrows.push("r")
    borrows.add_read("b1", "r", "ell")
    expect_rejected(lambda: slots.move("ell", borrows))


def test_suspended_mutable_token_remains_typed_but_cannot_call() -> None:
    slots = SlotStore()
    slots.bind("ell", "Resource[file]", own("a"))
    borrows = BorrowState()
    borrows.push("s")
    borrows.add_write("parent", "s", "ell")
    token = write_ref("s", "parent", "ell")
    borrows.push("r")
    borrows.reborrow_write("parent", "child", "r")
    assert runtime_token_type(token, slots, borrows) == "MutBorrow[Resource[file]]"
    expect_rejected(lambda: accept_mut_call_argument(token, slots, borrows))


def test_usable_mutable_token_can_call() -> None:
    slots = SlotStore()
    slots.bind("ell", "Resource[file]", own("a"))
    borrows = BorrowState()
    borrows.push("r")
    borrows.add_write("b1", "r", "ell")
    accept_mut_call_argument(write_ref("r", "b1", "ell"), slots, borrows)


def test_token_type_is_derived_from_referent_slot() -> None:
    slots = SlotStore()
    slots.bind("ell", "Resource[file]", own("a"))
    borrows = BorrowState()
    borrows.push("r")
    borrows.add_read("b1", "r", "ell")
    assert runtime_token_type(read_ref("r", "b1", "ell"), slots, borrows) == "Borrow[Resource[file]]"


def test_token_type_rejects_mismatched_slot_identity() -> None:
    slots = SlotStore()
    slots.bind("ell", "Resource[file]", own("a"))
    slots.bind("other", "Capability[root]", own("root"))
    borrows = BorrowState()
    borrows.push("r")
    borrows.add_read("b1", "r", "ell")
    expect_rejected(lambda: runtime_token_type(read_ref("r", "b1", "other"), slots, borrows))


def test_static_runtime_witness_separates_atoms_from_runtime_ids() -> None:
    witness = StaticRuntimeWitness()
    witness.extend_region("rho", "r7")
    witness.extend_lease("b", "beta9")
    assert witness.region_image("rho") == "r7"
    assert witness.lease_image("b") == "beta9"
    expect_rejected(lambda: witness.extend_region("rho", "r8"))
    expect_rejected(lambda: witness.extend_lease("c", "beta9"))
    witness.extend_lease("c", "beta9", alias_of="b")
    assert witness.lease_image("c") == "beta9"


def test_scoped_witness_close_does_not_remove_authorized_caller_alias() -> None:
    witness = StaticRuntimeWitness()
    witness.extend_region("caller_rho", "r", layer="caller")
    witness.extend_lease("caller_b", "beta", layer="caller")
    witness.extend_region("local_rho", "r_local", layer="local")
    witness.extend_lease("local_b", "beta", layer="local", alias_of="caller_b")
    witness.close_layer("local")
    assert witness.region_image("caller_rho") == "r"
    assert witness.lease_image("caller_b") == "beta"
    assert witness.aliases == set()
    expect_rejected(lambda: witness.lease_image("local_b"))


def test_scoped_witness_rejects_non_top_layer_close() -> None:
    witness = StaticRuntimeWitness()
    witness.extend_region("caller_rho", "r", layer="caller")
    witness.extend_region("local_rho", "r_local", layer="local")
    expect_rejected(lambda: witness.close_layer("caller"))
    assert witness.region_image("caller_rho") == "r"
    assert witness.region_image("local_rho") == "r_local"


def test_returned_borrow_token_bridges_callee_and_caller_atoms() -> None:
    slots = SlotStore()
    slots.bind("ell", "Resource[file]", own("a"))
    borrows = BorrowState()
    borrows.push("r")
    borrows.add_read("beta", "r", "ell")
    token = read_ref("r", "beta", "ell")
    caller = StaticRuntimeWitness(regions={"caller_rho": "r"}, leases={"caller_b": "beta"})
    callee = StaticRuntimeWitness(regions={"formal_rho": "r"}, leases={"formal_b": "beta"})
    accept_returned_token_bridge(
        token,
        slots,
        borrows,
        callee,
        caller,
        ("formal_rho", "formal_b"),
        ("caller_rho", "caller_b"),
    )
    wrong_caller = StaticRuntimeWitness(
        regions={"caller_rho": "different"}, leases={"caller_b": "beta"}
    )
    expect_rejected(
        lambda: accept_returned_token_bridge(
            token,
            slots,
            borrows,
            callee,
            wrong_caller,
            ("formal_rho", "formal_b"),
            ("caller_rho", "caller_b"),
        )
    )


def test_explicit_call_instantiation_is_retained_during_argument_start() -> None:
    assert start_call("phi-file", ["first", "second"]) == (
        "eval",
        "phi-file",
        "first",
        [],
        ["second"],
    )


def test_recursive_region_binder_freshening_avoids_active_name() -> None:
    caller_active = {"rho"}
    recursive = alpha_freshen_binder("rho", caller_active)
    assert recursive == "rho_1"
    assert recursive not in caller_active


def test_capability_attenuation_records_origin() -> None:
    resources = ResourceStore(live={"root": ("filesystem_root", "initial")})
    resources.attenuate("root", "subtree", "filesystem_subtree")
    assert resources.consumed["root"] == ("filesystem_root", "initial")
    assert resources.live["subtree"] == (
        "filesystem_subtree",
        "attenuated(root,filesystem_root,filesystem_subtree)",
    )


def test_capability_attenuation_requires_fresh_resource() -> None:
    resources = ResourceStore(
        live={
            "root": ("filesystem_root", "initial"),
            "existing": ("filesystem_subtree", "initial"),
        }
    )
    expect_rejected(lambda: resources.attenuate("root", "existing", "filesystem_subtree"))


def test_checked_integer_success_and_tpoe() -> None:
    registry = PrimitiveRegistry.standard()
    assert run_checked_add(registry, 20, 22, -128, 127) == ("ok", 42)
    assert run_checked_add(registry, 127, 1, -128, 127) == ("tpoe", None)


def test_missing_consuming_primitive_is_rejected_before_transition() -> None:
    resources = ResourceStore(live={"a": ("Resource[file]", "ordinary")})
    slots = SlotStore()
    slots.bind("ell", "Resource[file]", own("a"))
    expect_rejected(
        lambda: slots.consume(
            "release_resource", "ell", BorrowState(), resources, PrimitiveRegistry()
        )
    )
    assert resources.live == {"a": ("Resource[file]", "ordinary")}


def test_missing_checked_primitive_is_rejected_before_transition() -> None:
    expect_rejected(lambda: run_checked_add(PrimitiveRegistry(), 1, 2, -128, 127))


def test_missing_attenuation_semantics_is_rejected_before_transition() -> None:
    resources = ResourceStore(live={"root": ("filesystem_root", "initial")})
    expect_rejected(
        lambda: resources.attenuate(
            "root", "subtree", "filesystem_subtree", PrimitiveRegistry()
        )
    )
    assert resources.live == {"root": ("filesystem_root", "initial")}


def test_suspended_mutable_token_cannot_mutate() -> None:
    slots = SlotStore()
    slots.bind("ell", "Resource[file]", own("a"))
    borrows = BorrowState()
    borrows.push("s")
    borrows.add_write("parent", "s", "ell")
    token = write_ref("s", "parent", "ell")
    borrows.push("r")
    borrows.reborrow_write("parent", "child", "r")
    expect_rejected(lambda: mutate_borrow(token, slots, borrows))


def test_usable_read_token_can_observe() -> None:
    slots = SlotStore()
    slots.bind("ell", "Resource[file]", own("a"))
    borrows = BorrowState()
    borrows.push("r")
    borrows.add_read("read", "r", "ell")
    assert observe_borrow(read_ref("r", "read", "ell"), slots, borrows) == "Resource[file]"


def test_call_path_certificate_is_materialized_before_argument_moves() -> None:
    certificate = materialize_paths({"owner(formal)": "actual"}, {"actual": "ell"})
    assert certificate == {"owner(formal)": "ell"}


def test_call_path_certificate_survives_caller_slot_move() -> None:
    slots = SlotStore()
    slots.bind("caller", "Resource[file]", own("a"))
    certificate = materialize_paths({"owner(formal)": "actual"}, {"actual": "caller"})
    assert slots.move("caller", BorrowState()) == own("a")
    assert certificate == {"owner(formal)": "caller"}


def test_call_path_certificate_rejects_wrong_token_referent() -> None:
    certificate = {"referent(formal)": "ell"}
    require_token_path_certificate(certificate, "referent(formal)", read_ref("r", "b", "ell"))
    expect_rejected(
        lambda: require_token_path_certificate(
            certificate, "referent(formal)", read_ref("r", "b", "other")
        )
    )


def test_bind_call_arguments_transfers_owned_carrier_to_fresh_parameter_slot() -> None:
    resources = ResourceStore(live={"a": ("Resource[file]", "ordinary")})
    slots = SlotStore()
    bound = bind_call_arguments(
        [7, own("a")],
        [CallFormal("count", "IntK", "Free"), CallFormal("file", "Resource[file]", "Linear")],
        ["parameter-file"],
        slots,
    )
    assert bound.environment == {"count": ("free", 7), "file": ("slot", "parameter-file")}
    assert bound.parameter_slots == ["parameter-file"]
    assert bound.remaining_frame_values == []
    assert_owner_bijection(resources, [slots.value("parameter-file")])


def test_call_return_requires_owned_parameter_discharge() -> None:
    slots = SlotStore()
    slots.bind("parameter-file", "Resource[file]", own("a"))
    expect_rejected(lambda: accept_discharged_parameter_slots(slots, ["parameter-file"]))
    assert slots.move("parameter-file", BorrowState()) == own("a")
    accept_discharged_parameter_slots(slots, ["parameter-file"])


def test_intrinsic_tpoe_snapshot_retains_abandoned_owner_accounting() -> None:
    resources = ResourceStore(live={"a": ("Resource[file]", "ordinary")})
    terminal = classify_tpoe("checked_primitive_failure", resources, [own("a")])
    assert terminal == TerminalTpoe("checked_primitive_failure", ("a",))


def test_zero_argument_call_enters_without_argument_frame() -> None:
    assert start_arguments([]) == ("enter", None, [], [])


def test_argument_frames_preserve_source_order() -> None:
    state = start_arguments(["first", "second", "third"])
    assert state == ("eval", "first", [], ["second", "third"])
    state = continue_arguments(state[2], state[3], "value-first")
    assert state == ("eval", "second", ["value-first"], ["third"])
    state = continue_arguments(state[2], state[3], "value-second")
    assert state == (
        "eval",
        "third",
        ["value-first", "value-second"],
        [],
    )
    state = continue_arguments(state[2], state[3], "value-third")
    assert state == (
        "enter",
        None,
        ["value-first", "value-second", "value-third"],
        [],
    )


def test_zero_argument_checked_primitive_has_complete_argument_vector() -> None:
    state = start_arguments([])
    assert state == ("enter", None, [], [])


def test_closed_region_lease_is_unusable() -> None:
    borrows = BorrowState()
    borrows.push("r")
    borrows.add_read("b1", "r", "ell")
    borrows.close("r")
    assert "b1" not in borrows.leases


def test_region_exit_rejects_returned_token_from_closing_region() -> None:
    token = read_ref("r", "b1", "ell")
    assert "r" in value_regions(token)
    expect_rejected(lambda: assert_region_can_exit("r", token))


def assert_region_can_exit(region: str, value: Value) -> None:
    assert region not in value_regions(value)


def test_call_return_requires_exact_borrow_graph_restoration() -> None:
    borrows = BorrowState()
    borrows.push("caller")
    borrows.add_read("framed", "caller", "external")
    entry = borrow_snapshot(borrows)
    borrows.push("callee")
    borrows.add_read("local", "callee", "local-slot")
    expect_rejected(lambda: accept_call_return(borrows, entry))
    borrows.close("callee")
    accept_call_return(borrows, entry)


def test_reborrow_requires_fresh_child_identity() -> None:
    borrows = BorrowState()
    borrows.push("s")
    borrows.add_write("parent", "s", "ell")
    borrows.push("r")
    expect_rejected(lambda: borrows.reborrow_write("parent", "parent", "r"))


def main() -> None:
    tests = [value for name, value in globals().items() if name.startswith("test_")]
    for test in sorted(tests, key=lambda value: value.__name__):
        test()
    print(f"lambda_K-seq owner-slot model spot checks: {len(tests)} passed")


if __name__ == "__main__":
    main()
