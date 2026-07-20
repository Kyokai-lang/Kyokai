# Reference Products And Workload Evidence

[Rikona Kurasaki / Mjoyufull]
> ProofTrace: SPEC-PROJECT-06-REFERENCE-PRODUCTS-AND-WORKLOADS
> Covers: This project chapter defines the official reference products and cross-phase workloads used to pressure Kyokai's public surfaces without treating those products as language or standard-library semantics.

After the native Kyokai toolchain, the first organization-owned reference
product is a maintained long-lived Poller server. It uses only public language,
standard-library, package, capability, allocator, network, and Poller surfaces.
It covers HTTP Core, WebSocket, configuration, structured logs, metrics,
deadlines, cancellation, bounded queues, overload, and graceful shutdown.
Simulation, load, soak, malformed-input, slow-client, dependency-failure,
injected-OOM, restart, upgrade, and security-boundary evidence accompanies it.
The product is not whole-language conformance and cannot alter semantics by
precedent.

Kyokai adopts no official game engine. SDL3 is the first serious raw game and
systems Bridge workload; raylib is the first small beginner game surface after
its own admission. Engine integrations identify whether they use a C ABI,
native plugin, generated binding, embedded host, process protocol, or a recorded
combination. Their contracts publish callbacks, affinity, lifetime, reload,
allocation, failure, authority, targets, assets, and packaging behavior. No
engine receives hidden garbage collection, shared ownership, backend, or source
semantics.

Reference games exercise 2D rendering, fixed-step simulation, frame arenas,
data-oriented/ECS and slot-map pressure, input, audio, save/load, asset reload,
profiling, and deterministic replay. Godot and Unity experiments remain
separately identified project work until admitted through the ordinary process.

Each cross-phase workload has an owner, exact revision, dependency and target
identity, authority and resource budgets, execution cadence, evidence class,
known exclusions, and claim ceiling. A workload can expose a defect or motivate
a D-point. It cannot decide a new rule by becoming popular or difficult to
change.

> Trace: D600-D601, D620, D623
> Covers: Maintained workloads test the combined design throughout development while retaining a narrower evidence class than conformance.
