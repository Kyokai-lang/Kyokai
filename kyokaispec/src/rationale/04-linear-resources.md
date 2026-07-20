# Linear Resources Rationale

[Rikona Kurasaki / Mjoyufull]
> ProofTrace: SPEC-RATIONALE-04-LINEAR-RESOURCES
> Covers: This chapter is registered in the public ProofTrace evidence graph; registration does not claim implementation, conformance, or theorem completion.

The inherited resource argument is still the center of Kyokai. A file handle, pointer, lock guard, channel endpoint, process handle, directory handle, pinned object, generator, or capability has a life. It is created, used, transferred, split if the API permits that, and finally consumed. The bug appears when that life is only a story in the programmer's head.

> Trace: D2, D6, D77, D89, D194
> Covers: Linear values encode resource lifecycles in the type system and checker rather than in comments or habit.

## Why Linear, Not Just Analysis

[Rikona Kurasaki / Mjoyufull]
Static analysis can find bugs, but a moving pile of heuristics is not the same thing as a type rule a programmer can learn. Kyokai follows Austral in wanting a fixed, teachable rule: a linear owner is used exactly once, and a type that contains linear state becomes linear unless a closed built-in rule says otherwise.

> Trace: D6, D77, D194
> Covers: Universe classification and exactly-once use are static type/checker rules.

That does not make every resource easy. It makes the hard parts visible. When a value moves, the old place is unusable. When a container stores linear elements, the container must explain how those elements are consumed. When a loop might consume a value zero or many times, the checker refuses unless the loop form proves the path.

> Trace: D77, D89/D199, D205-D206
> Covers: Moves, containers, patterns, and loops preserve exactly-once ownership.

## Borrows Are Not Owners

[Rikona Kurasaki / Mjoyufull]
Borrowing is how Kyokai lets code look like code instead of a ceremony of passing owners in circles. A borrow gives temporary access and then ends. It does not become a second owner, and it does not let mutation happen through the wall while some other view still lives.

> Trace: D6, D14, D187/D238-D240
> Covers: Borrow types are non-owning references with explicit mutable and immutable forms.

Named regions exist only when an API needs to relate borrowed lifetimes, such as returning a view tied to an input. Anonymous regions cover local borrows. This keeps borrow syntax visible without making every simple function carry a lifetime ledger in public.

> Trace: D6, D14
> Covers: Anonymous regions are complete source types and named regions express API relationships.

## Cleanup Is Source

[Rikona Kurasaki / Mjoyufull]
Kyokai does not smuggle cleanup through a destructor. If cleanup matters, the source says it. `defer` and `errdefer` are not hidden destructors; they are visible statements with checker state and exact exit-path behavior. A resource can also be consumed by an explicit close, destroy, release, drain, or surrender API.

> Trace: D2, D2a/D2b/D207, D246
> Covers: Cleanup uses visible constructs and explicit consuming APIs, not compiler-inserted ordinary-scope destructors.

This is less convenient in the small and cleaner in the large. A reader can see when a resource leaves the room. A compiler can prove it. A standard-library contract can say what happens if cleanup fails, if early exit happens, or if a linear buffer still contains values.

> Trace: D77, D85, D146, D229
> Covers: Linear cleanup obligations extend through stdlib contracts, channels, iterators, and containers.

## Stable Address And Pinning

[Rikona Kurasaki / Mjoyufull]
Moves are as-if bytewise relocation. That is simple until a value points into itself or external code remembers its address. Kyokai names the stable-address boundary instead of pretending ordinary ownership also means ordinary address permanence. `PinBox[T]` and pinned types carry that promise.

> Trace: D89/D199, D89a/D89b
> Covers: Safe self-reference requires explicit stable-address/pinning rules.

## Strict Linearity Without Affine Escape Hatches

[Rikona Kurasaki / Mjoyufull]
Strict linearity creates pressure where ordinary languages hide work: a new field changes cleanup paths, a graph needs ownership that does not form a pointer fog, a branch join exposes mismatched states, a collection cannot hand out a moved element and leave a hole behind, and a test still needs teardown after an assertion panics. Kyokai keeps the rule and attacks the pressure directly.

The language and stdlib answer with immutable borrows for observation, nominal authority bundles, generational handles, slot maps, transactional builders, named recovery records, hole-free removal APIs, linear drains, explicit early release, fixture cleanup scopes, and callback classes that distinguish repeated reads, repeated mutation, one-shot capture consumption, and state-machine stepping. The toolchain answers with join tables, resource-flow explanations, constructor migrations, cleanup insertion when one explicit repair exists, and ordered checklists when user intent is not unique.

None of this grants affine discard. No tool inserts hidden cleanup, allocation, authority, default values, or branch behavior. The improvement is that the compiler explains the proof it is asking the programmer to finish.

> Trace: D488-D500
> Covers: Strict-linearity ergonomics come from explicit APIs, checked elaboration, and tooling assistance rather than weakening exactly-once ownership.
