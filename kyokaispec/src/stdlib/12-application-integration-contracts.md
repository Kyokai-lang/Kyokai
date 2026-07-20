# Application And Platform Integration Contracts

[Rikona Kurasaki / Mjoyufull]
> ProofTrace: SPEC-STDLIB-12-APPLICATION-INTEGRATION-CONTRACTS
> Covers: This chapter specifies common ownership, identity, testing, data, server, terminal, native, mobile, embedded, accelerator, and data-integration contracts. It does not claim that a framework, provider, board, SDK, or runtime implementation has been admitted.

Application integrations must preserve Kyokai's ownership, authority, allocation, failure, and cleanup rules. This chapter defines the common contracts for retained callbacks, terminal state, queued cancellation, device-owned buffers, and other boundaries where a framework or platform can outlive or obscure an ordinary source-level operation.

> Trace: D540, D542-D543, D546, D549-D556
> Covers: Application-domain ergonomics use shared explicit ownership and tool contracts without adding hidden ownership, authority, allocation, dispatch, or failure semantics.

## Framework State Owners, Handles, And Views

A framework-owned mutable graph has a nominal `Linear` owner. A safe externally stored identity is a nominal `Free` handle whose representation contains, or is equivalent to, an owner identity, slot identity, and generation. Safe source cannot construct, decompose, or alter those identity components unless the handle type's admitted API exposes a checked operation for that purpose.

A handle owns no payload and grants no authority. Reading through a handle requires an immutable borrow of the matching owner. Mutation through a handle requires an exclusive borrow of the matching owner or an admitted disjoint-splitting operation. The returned view is region-bound to that borrow. A mutable view also ends when the owner's declared mutation epoch ends.

Removal invalidates the current generation. A generation counter that cannot represent another distinct generation retires the slot permanently. It does not wrap. Lookup classifies wrong owner, unknown slot, stale generation, removed entry, and retired slot as named recoverable failures. Compaction and owner movement preserve logical handle identity.

An admitted owner/container contract states:

- whether iteration and mutation can overlap;
- which disjoint views can coexist;
- which operations advance the mutation epoch;
- how nested views are rejected or split;
- how `Linear` payload removal returns, transfers, or consumes the payload;
- whether any stable external identifier exists separately from the runtime handle.

A generic handle is not serializable persistent identity. Serialization of a domain identity uses a separate nominal stable identifier and an explicit resolution operation. A task can receive a handle as data, but access still requires the matching owner, a capability-bearing service, or an immutable snapshot transferred under the concurrency rules.

> Trace: D374, D490, D540
> Covers: Long-lived framework identity uses checked owner-qualified handles and scoped views instead of stored borrows or hidden shared ownership.

## Heterogeneous Composition

Known alternatives use closed nominal unions and exhaustive dispatch. A manifest-declared component set can generate a closed union and static dispatch registry through the generated-API projection protocol.

A separately compiled or foreign component uses a nominal opaque `Linear` handle and an explicit operation table. The safe wrapper records concrete type identity, operation-table or ABI identity, owner and destruction operation, capability requirements, compatibility version, and failure behavior. A compatibility digest rejects mismatches; it is not evidence of memory safety.

A downcast is a checked operation returning a named failure. Allocation, destruction, serialization, task transfer, hot reload, and version negotiation are explicit. Erased storage remains unsafe internally until a wrapper admission proves layout, alignment, lifetime, aliasing, callback, and destruction obligations.

Kyokai has no general trait object, existential value, universal erased container, hidden runtime dictionary, or implicit allocation for heterogeneous composition. A standard reusable erased container requires its own admission record.

> Trace: D82, D499, D542
> Covers: Runtime variation uses unions, generated closed registries, or audited opaque foreign boundaries without reopening dynamic trait dispatch.

## Callback Contracts

The language-level callback classes remain `CallableRead`, `CallableMut`, `CallableOnce`, and `CallableState[S]`. Framework terms such as handler, renderer, reducer, completion, and teardown are parameter or API names. They do not create new callable classes.

Every retained or foreign callback parameter records callable class, arity, capture restrictions, storage duration, thread or executor affinity, reentrancy, cancellation, retry, replacement, return, failure, and teardown behavior. Distinct contracts use distinct actual types or entry points. Generated adapters preserve capture, ownership, source, affinity, unsafe-wrapper, and callable-class provenance.

Documentation and Analysis Server hover expose the domain name and the underlying callback facts. A capture diagnostic points at the capture expression or captured binding. The framework declaration and generated adapter are related locations unless their contract is the defect.

Kyokai requires no framework callback-role registry. A framework can provide one as an ordinary documented tool or library surface.

> Trace: D493-D494, D504, D543
> Covers: Framework callback DX reuses the accepted callable model and diagnostics instead of creating duplicate language semantics.

## Test Fakes And Simulators

The standard test foundation contains deterministic clock, random, filesystem, loopback network, terminal, process-result, and fault-injection fixtures. Each fixture has a nominal stateful model, an explicit test capability bundle, and `Linear` teardown.

An API accepts a narrow service record or static typeclass parameter when substitutability is part of that API's production design. This chapter does not require every effectful API to be abstracted for mocking. Leaf operations receive the narrowest real or simulated handle needed by their contract.

Fault scripts can model short reads, short writes, partial progress, cancellation races, timeouts, disconnects, allocation failure, malformed data, unavailable services, and target errors. Virtual time and task simulation preserve structured-concurrency, ownership, cancellation, and join obligations. Call recording and expectation order are fixture features and have no language semantics.

A generated client can include a matching fake when its generator result records the generated service contract. Simulator success proves only the declared model. Target, protocol, browser, database, cloud, or device conformance requires a real-system lane. Generic service graphs report compile-time and code-size measurements in their admission evidence.

> Trace: D137, D442, D494, D541, D546
> Covers: Deterministic testing uses explicit state and authority without runtime mocking containers or false conformance claims.

## Runtime Dataset Providers

Every behavioral dataset uses one provider class:

| Provider class | Identity rule | Update rule |
| --- | --- | --- |
| Compile-time pinned | Exact data version and digest are build inputs. | Changes require an explicit source/toolchain update. |
| Toolchain-shipped versioned | Toolchain compatibility identity names the dataset version and digest. | Updated by an explicit verified toolchain installation. |
| Target-provided observed | Runtime or tool inspection reports the target provider identity. | The target controls updates; reproducibility is not claimed without a pinned identity. |
| Application-bundled | Package or application artifacts carry the version and digest. | Updated by an explicit package/application build. |
| Explicit network-updated | Provider, signature, freshness, cache, and network authority are declared. | Updated only by the named network-capable operation. |

Unicode algorithms use a pinned named Unicode version. Civil-time APIs use an explicitly selected pinned/application tzdb provider or an observed target provider and expose its identity. Hosted certificate validation uses an observed target trust-root provider unless the application selects a bundled provider. Revocation and other online security information state online/offline policy, freshness, expiry, cache, and unavailable-data behavior. Public-suffix, MIME, locale, and similar datasets each declare their own provider class.

Importing, parsing, checking, building, and ordinary execution do not download datasets silently. Deterministic tests pin exact fixtures. Embedded subsets, application overrides, licenses, caches, compatibility effects, and target divergence are recorded in the provider contract.

> Trace: D404, D421, D549
> Covers: Reproducibility and security use visible dataset identity and update authority instead of an undifferentiated host-or-bundled rule.

## Browser Foundation

A browser target supplies generated Web-IDL raw bindings and admitted safe wrappers. Raw browser bindings remain unsafe until wrapper admission covers foreign object retention, callback entry, exceptions, target absence, teardown, and glue provenance.

Browser authority is represented by explicit handles for network, storage, clipboard, workers, media, UI, and other target services. DOM identity and listener registration use framework owners and handles. Listener removal consumes or updates the registration owner according to its API contract. Browser GC retention never creates a managed Kyokai reference.

Typed form extraction, fetch bodies, streams, workers, and service workers state ownership, allocation, buffering, backpressure, cancellation, blocking, failure, and target behavior. CSS modules and assets are declared generated/build inputs with hashes and source provenance. Browser conformance lanes cover DOM behavior, accessibility trees, CSP compatibility, source maps, and JavaScript/WebAssembly glue.

SSR, hydration, partial hydration, islands, reactive state, and HMR are framework/generator protocols. Hydration artifacts carry structural identity. A mismatch is diagnosed and classified; the runtime does not silently replace arbitrary state. HMR names state boundaries and migration compatibility. Browser integration adds no browser-specific source syntax, hidden exception model, implicit allocation model, or second dependency graph.

> Trace: D540-D541, D550
> Covers: Browser usability is a generated target and framework surface while core Kyokai semantics remain unchanged.

## Servers, Protocols, Databases, And Observability

The first-party server foundation includes poller transport, HTTP/1.1, HTTP/2, streaming bodies, typed routing and extraction, graceful taskgroup shutdown, deterministic server tests, structured logs, traces, metrics, database contracts, and explicit TLS providers. HTTP/3 and QUIC require separately admitted provider contracts.

Every server API states request allocator or arena behavior, body ownership, connection drain and reuse, buffering, backpressure, cancellation, timeout, partial progress, and cancellation-safe write behavior. Middleware uses static composition, generated closed registries, or the audited opaque boundary defined above. TLS trust and revocation use the dataset-provider rules.

Database drivers and pools record connection ownership, allocator behavior, capacity, waiter fairness, cancellation, health checking, transaction state, isolation, rollback, and authority. Migration records identify schema preimage, applied steps, transaction guarantees, partial application, recovery, and resulting schema identity. A migration is called atomic only when the provider contract proves that all selected operations roll back together.

Logs, traces, and metrics share typed field, context, and redaction rules. Trace and baggage context is an explicit immutable value transferred through handlers and task creation. It grants no capability. Secret providers, proxy-header trust, ALPN, hot reload, container entrypoints, and serverless adapters are explicit integration records.

> Trace: D310, D402, D413, D421, D542, D549, D551
> Covers: Server DX is cohesive while allocation, backpressure, cancellation, telemetry context, database recovery, and security providers remain visible.

## Command-Line And Terminal Applications

An explicit command schema can generate argument parsing, subcommands, validation, help, shell completion, and man pages. The schema is input to the generated-API projection protocol; command annotations and CLI-specific language syntax do not exist.

Configuration layering reports every selected source and precedence decision. Human, structured, color, pager, prompt, and secret-input behavior follows the CLI output contract and observed terminal facts. Raw mode, alternate screen, cursor state, clipboard, terminal-image protocols, and related state use `Linear` guards.

Structured exits follow ordinary cleanup rules. Restoration attempts after panic, TPOE, signal, or runtime-fatal termination are target/runtime best effort and are not described as infallible. A TUI uses explicit application state and frame rendering. Layout and widgets support deterministic snapshots, event replay, virtual clocks, background messages, focus, and accessibility metadata supported by the target.

Grapheme segmentation and display width use a named runtime dataset. Windows ConPTY, key events, terminfo or terminal queries, remote terminals, multiplexers, redirected streams, clipboard, and terminal images have target records and explicit degradation. Plugin commands and embedded resources remain subject to package, capability, provenance, and generated-source rules.

> Trace: D503, D541, D549, D552
> Covers: CLI and TUI applications receive one batteries-included library workflow without a mandatory framework or language special case.

## Native GUI, Graphics, Games, Audio, And Media

The common native-application substrate records main-thread application lifetime; `Linear` windows, surfaces, graphics devices, audio devices, and media resources; state owners and handles; callback contracts; accessibility; text shaping and IME; input; clocks; assets; inspection; source maps; preview authority; and packaging facts.

Retained and immediate frameworks both use explicit state owners. Declarative UI is a generator/framework protocol, not source syntax. Graphics contracts state frame ownership, resource transitions, synchronization, presentation, device loss, frame-graph identity, shader reflection, and failure behavior.

An audio callback contract states real-time allocation, blocking, locking, thread, authority, panic/TPOE, and failure restrictions. Media pipelines use nominal state machines and record codec, license, provider, buffering, backpressure, seek, cancellation, and teardown behavior. Hot reload preserves state only under an explicit compatibility contract. Preview tooling uses declared authority and the shared Analysis Server and generator facts.

No named GUI, game, audio, or media framework is admitted by this chapter. Each official framework or Bridge entry satisfies the normal admission record.

> Trace: D529, D540-D543, D548, D553
> Covers: Common lifecycle and ownership rules exist without freezing one native framework into the language.

## Mobile Platforms

Android integration uses the NDK plus generated audited JNI/Kotlin adapters. Apple-platform integration uses generated audited C, Objective-C, and Swift adapters. A support record names OS versions, architectures, SDK versions, simulator/device classes, compilers, linkers, debug formats, and packaging tools.

Adapters state ARC or GC retention, native ownership, foreign-object identity, callback thread entry, exception translation, teardown, and source mapping. Platform exceptions do not unwind through safe Kyokai frames. UI-thread affinity, lifecycle, suspension, process death, restoration, links, notifications, sensors, permissions, and background execution use nominal state machines and explicit capabilities.

Process death discards volatile process state and does not promise destructor execution. Permission revocation is an event or recoverable failure according to the API contract. Simulator and device tests are separate lanes. Store metadata and credentials are packaging inputs and have no source-language semantics.

This chapter does not select a mobile UI framework or hot-reload runtime.

> Trace: D541, D547-D548, D554
> Covers: Mobile support is an audited platform boundary rather than an unsupported claim that C ABI access is sufficient.

## Embedded And Firmware

An embedded target or board record names CPU, ABI, memory map, startup objects, linker layout, interrupt model, clocks, peripherals, atomics, TLS, volatile/MMIO behavior, probe/debug transport, fatal hooks, boot identity, and packaging identity.

SVD/PAC-style generated register declarations remain unsafe. An admitted HAL proves register access, ownership, volatile behavior, aliasing, reset state, interrupt interaction, and target facts. Interrupt priority and nesting, DMA ownership, pinning, cache coherency, multicore sharing, peripheral sharing, power states, and memory order are explicit contracts.

No-heap and static-allocation configurations use admitted containers and storage plans. Poll and state-machine executors are libraries and cannot introduce a hidden async runtime. Flash, probe, simulator, QEMU, compressed-log, hardware-in-loop, and on-device test operations are tool adapters. Bootloaders, secure boot, OTA, rollback, firmware images, and fatal hooks are board and packaging contracts.

A device description is an input to generation, not proof that the generated access is safe. Board and HAL support claims require admission and conformance records.

> Trace: D335, D430, D541, D548, D555
> Covers: Embedded correctness includes the board, startup, interrupt, DMA, debug, and packaging boundaries.

## Accelerators, ML, Numerics, And Data

Accelerator APIs expose device, queue or stream, memory, buffer, kernel or shader module, event, synchronization, and completion-token ownership. Device transfer, synchronization, allocation, dtype conversion, layout conversion, fallback, and host blocking are explicit operations.

Shader and kernel reflection and compilation use the generated-API projection protocol with target, provider, cache, diagnostic, and source-map identity. Vulkan, WebGPU/SPIR-V, CUDA, HIP, and other providers are separately admitted target or Bridge contracts.

Tensor APIs record shape, strides, layout, dtype, aliases and views, dynamic dimensions, allocator, device placement, and autodiff tape ownership when an admitted library implements autodiff. Numerical providers record algorithms, mixed precision, target behavior, and error contracts.

Columnar values, dataframe/query plans, Arrow-compatible exchange, and DLPack-compatible tensor exchange state ownership transfer, release operations, buffer lifetime, alignment, mutability, device, copying, and allocator behavior. Python exchange states copy/zero-copy behavior, object lifetime, GIL and thread entry, exception translation, and shutdown behavior. Notebook kernels, distributed collectives, device loss, profiling, and remote accelerators are explicit lanes.

Kyokai has no universal tensor type, implicit device dispatch, implicit transfer, built-in autodiff, or GPU kernel language under this chapter. Such language semantics require a separate D-point.

> Trace: D529, D541-D542, D556
> Covers: Compute and data interoperability stays explicit and does not smuggle another compiler backend or universal runtime into Kyokai.

## Admission And Conformance

Every framework, protocol, database, SDK, terminal extension, GUI toolkit, board, HAL, accelerator, numerical provider, data interface, or foreign runtime admitted as official Kyokai surface records:

- public modules and admission state;
- ownership, allocation, capability, failure, blocking, cancellation, and invalidation contracts;
- supported target/provider matrix and unsupported behavior;
- unsafe and FFI boundaries;
- dataset and generated-source identities;
- license, provenance, update, and security policy;
- deterministic fixture tests and real-system conformance lanes;
- source-map, debugger, audit, and documentation support.

An integration remains absent until its admission record exists. Naming a candidate in rationale, a plan, or this chapter does not make it supported.

> Trace: D85, D229-D232, D499, D529, D540-D556
> Covers: Common integration contracts do not overclaim actual framework or provider support.

## Frameworks Obey Language Rules

[Rikona Kurasaki / Mjoyufull]
Framework code crosses the same ownership and authority boundaries as lower-level library code, often with longer-lived callbacks and more external state. Its contracts must therefore identify retained ownership, cleanup, device and process authority, terminal restoration, foreign-runtime behavior, and failure recovery rather than treating those facts as framework internals.

## First-Party Web Protocol Foundation

RFC-family `Uri` and WHATWG `WebUrl` are different types; parsing either is
pure. Kyokai-maintained HTTP Core defines RFC 9110 semantics, structured
headers, methods and status, streaming Linear bodies, limits, and strict HTTP/1
framing with request-smuggling rejection. HTTP/2 and HTTP/3 require separate
first-party admission.

Client redirect, retry, cookie, proxy, decompression, authentication, pooling,
and cache policies are explicit. Non-idempotent work is never silently retried.
Server packages expose budgets, deadlines, backpressure, overload, graceful
shutdown, fatal isolation, and direct Poller integration without a hidden
executor. WebSocket is a complete first-party protocol module. OpenAPI and JSON
Schema are first-party; Protobuf, FlatBuffers, Cap'n Proto, and similar systems
use generated packages or Bridges with recorded provenance.

Interoperability suites, deterministic fuzz replay, and the maintained Poller
server workload are admission evidence.

> Trace: D594
> Covers: The first-party web story owns protocol semantics and hostile framing without importing hidden scheduling, retry, or authority.

## Database Placement

SQLite is the first high-priority official Bridge. Bundled and system forms
have distinct admission identity, library version, compile flags, thread mode,
extension policy, and update owner. Connections are Linear. Statements,
bindings, row views, and transactions state their parent lifetime,
invalidation, cancellation, callback re-entry, and indeterminate-outcome rules.
Extension loading is disabled by default and requires authority plus an
allowlist.

PostgreSQL and MySQL native-protocol clients are first-party packages composed
from explicit sockets, Poller, DNS, TLS, clocks, cancellation, and observability.
Native client-library Bridges may coexist under separate identities. Pools are
ordinary explicit-lifetime packages; parameters are typed; errors retain raw
provider codes and portable categories. Migrations, ORMs, and query builders
cannot hide authority, transactions, allocation, or unbounded loading.

> Trace: D595
> Covers: Database integration preserves provider identity and transaction state instead of disguising them behind one universal data layer.
