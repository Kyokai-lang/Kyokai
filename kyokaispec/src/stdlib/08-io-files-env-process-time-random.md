# I/O, Files, Environment, Process, Time, Random, And Network

[Rikona Kurasaki / Mjoyufull]
> ProofTrace: SPEC-STDLIB-08-IO-FILES-ENV-PROCESS-TIME-RANDOM
> Covers: This chapter is registered in the public ProofTrace evidence graph; registration does not claim implementation, conformance, or theorem completion.

The outside world is not a global variable Kyokai forgot to name. Files, terminals, clocks, entropy, processes, sockets, and the environment are authority. Authority moves through values.

> Trace: D48, D67, D171-D173, D211-D212, D255
> Covers: External-world stdlib APIs are capability-gated and do not use ambient authority.

## Capability Surface

Authority-bearing APIs require explicit capability values. `RootCapability` is minted only by runtime bootstrap for entrypoints that request it. Safe code derives narrower capabilities from root or receives them as parameters; imports do not grant authority.

> Trace: D48, D162, D211, D255
> Covers: Runtime bootstrap, not imports, is the root of safe authority.

| Capability | Governs | Borrow Shape | Notes | Trace |
| --- | --- | --- | --- | --- |
| `FileCapability` | Filesystem namespace and handle creation. | `&!` for namespace observation, handle creation, and namespace mutation. Operations over an already-open handle use that handle's declared borrow shape. | Relative paths require explicit `Directory` handles. | D171 |
| `EnvCapability` | Environment variable reads/writes/removal. | `&!` because the environment is mutable process state. | No global `getenv`. | D67 |
| `ProcessCapability` | Child process spawning, process handles, exit status. | `&!` for spawning/control. | Arguments use OS strings, not raw text by accident. | D85, D211 |
| `TerminalCapability` | Terminal streams and interactive terminal control. | `&!` for observation/control. | Ordinary streams use `Readable`/`Writable` handles. | D66, D211 |
| `WallClockCapability` | Civil or system time that can move backward. | `&!` for observable host time. | Pure `Duration` arithmetic is ungated. | D403 |
| `MonotonicClockCapability` | Monotonic instants used by deadlines. | `&!` for observable host time. | Deadline APIs use monotonic time unless their names explicitly state wall-clock scheduling. | D403 |
| `SleepCapability` | Blocking delay against a named clock source. | `&!` for suspension authority. | Sleep contracts name overshoot, interruption, and cancellation. | D403 |
| `EntropyCapability` | OS entropy and secure random source construction. | `&!` because entropy source state is external. | Deterministic PRNGs are separate seeded values. | D231, D421 |
| `NetworkCapability` | Socket creation, connect, bind, listen, accept, send, receive, shutdown, and socket options. | `&!` for creation and external mutation. | Narrow connect/listen/socket authority values are admitted. | D85, D211-D212, D411 |
| `ResolverCapability` | DNS and name resolution. | `&!` for resolver observation and cache state. | Numeric address parsing needs no authority. | D411 |
| `SignalCapability` | Signal notification watchers. | `&!` for registration. | Synchronous fault signals remain runtime-fatal. | D95-D96, D256 |

> Trace: D48, D66-D67, D85, D95-D96, D162, D171, D211-D212, D231, D255-D256, D403, D411, D421
> Covers: Common external capabilities split filesystem, terminal, wall clock, monotonic clock, sleep, entropy, network, resolver, process, environment, and signal authority explicitly.

## Filesystem And Streams

`File` and `Directory` are linear handles. Opening, creating, renaming, removing, metadata lookup, permission changes, symlink operations, and directory traversal require `FileCapability` or an explicit `Directory` handle with the necessary authority. Ordinary failures return `Result[..., IoError]`.

> Trace: D66, D171, D212
> Covers: Filesystem authority and failures are explicit.

`Readable` and `Writable` are byte-stream protocols. They do not imply filesystem authority and do not secretly allocate. A stream implementation states whether operations block, whether partial reads/writes occur, whether deadlines are supported, and what error type is returned.

> Trace: D66, D85, D91
> Covers: Stream protocols separate byte transfer from authority and blocking behavior.

| API Family | Ownership | Allocation | Failure | Capabilities | Platform | Edge Cases | Tests | Trace |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| File open/create | Borrows capability and path/base directory; returns linear handle. | Handle allocation internal; path conversions take allocator. | `IoError` for host I/O refusal, `PathError` for rejected path representation, and `AllocError` exactly when an explicitly allocating conversion is selected. | `FileCapability` or `Directory`. | Target filesystem rules documented. | missing path, permission denial, symlinks, races, unsupported kind. | positive/negative target tests. | D171, D212 |
| File read/write | Mutably borrows handle and buffer/sink. | None unless helper allocates output buffer. | `IoError`; partial progress stated. | Authority carried by handle. | Blocking and short read/write rules documented. | EOF, closed handle, interrupted operation, partial write. | short I/O, close, error injection. | D66, D85, D91 |
| Directory traversal | Linear iterator or explicit cursor. | Allocator explicit for owned entries. | `IoError`, `AllocError`. | Directory handle. | Ordering deterministic only if contract says sorted. | concurrent mutation, permission denial, symlink loops. | platform fixtures and property checks. | D77, D83, D171 |

> Trace: D66, D77, D83, D85, D91, D171, D212
> Covers: File and stream APIs publish ownership, allocation, failure, capability, platform, edge cases, and tests.

## Atomic File Updates And Locks

Atomic-update APIs use filesystem or narrowed directory authority. Kyokai does not mint a separate atomic-update capability. The admitted surface includes temp files, temp directories, atomic writes, file replacement, no-follow open, and advisory locks. Replacement requires authority to the containing directory plus create, write, and replace authority for the selected path.

Durability policy is one of `best-effort`, `file-synced`, `file-and-directory-synced`, or `target-unsupported`. Symlink-follow policy is explicit. A cross-filesystem replacement returns an error; it never silently copies and deletes while claiming atomic replacement. File locks are advisory unless the selected target contract says otherwise. A lock guard is `Linear`, and consuming its release operation ends the lock lifetime. A metadata-check-then-open API states its TOCTOU exposure or uses handle-relative and no-follow forms where the target admits them.

| Family | Authority | Ownership | Failure state | Target facts |
| --- | --- | --- | --- | --- |
| Temp file or directory | Filesystem capability or narrowed directory handle. | Returns a linear handle and named cleanup obligation. | Path, permission, resource, collision, and raw OS mapping. | Temp-root policy, permission model, and no-follow support. |
| Atomic write or replace | Containing-directory create/write/replace authority. | Consumes or returns temp handle according to the recovery record. | Written prefix, temp path, cleanup result, cross-filesystem rejection, durability failure. | Rename/replace atomicity class and sync support. |
| Advisory lock | File handle or narrowed lock authority. | Returns a linear lock guard. | Unsupported target, contention, timeout, stale-lock policy, and raw OS mapping. | Advisory or stronger lock class. |

> Trace: D402, D410
> Covers: Atomic file updates, temporary resources, sync policy, no-follow policy, TOCTOU boundaries, and lock lifetime are explicit.

## Environment

Environment APIs require `EnvCapability`. `getEnv` returns `Optional` for absence. `setEnv` and `removeEnv` return `Result` because host rejection is a recoverable result. Keys and values use OS-string aware contracts where the target cannot promise UTF-8.

> Trace: D30-D30a, D67
> Covers: Environment access is capability-gated and absence is ordinary data.

Environment names and values use the nominal target-native types `EnvName` and `EnvValue`. Process arguments use the separate nominal target-native type `ArgText`. None of these types is an alias for `String`, `OsString`, or `Path`. Conversion to UTF-8 text is explicit and chooses one named mode: strict conversion returns an encoding error, lossy conversion records replacement, and target-rendered conversion produces display-only text that is not accepted as an environment name, environment value, argument, package identity, cache identity, or path identity.

Child-process environment construction chooses exactly one visible builder mode: inherit none, inherit all, inherit selected names, or set an exact map. A builder can then apply explicit set or remove operations when its mode admits overlays. The selected base mode and overlays are source-visible values or manifest/tool configuration; no spawn API silently inherits the parent environment.

Secret arguments and environment values use secret-marked wrappers at construction. Diagnostics, machine reports, verbose command output, failure hooks, docs examples, and audit output render a redaction marker instead of ordinary display for those wrappers. The selected target contract states argument encoding, environment-name encoding, environment-value encoding, invalid native representation behavior, embedded-NUL rejection, Windows environment-name case behavior, Unix byte behavior, and child-process quoting rules.

> Trace: D409
> Covers: Argument and environment values are nominal target-native values; conversion, inheritance, secret redaction, and target-specific process encoding are explicit.

There is no global ambient environment lookup. If a function reads `$HOME`, its parameters or captured values show the authority.

> Trace: D67, D211
> Covers: Environment dependence is visible at API boundaries.

## Process

Process spawning requires `ProcessCapability`. Child arguments use `ArgText`; environment builder operations use `EnvName` and `EnvValue`. Standard input/output/error are explicit handles. Spawn and setup errors are returned before a successfully started child handle exists.

A started child is represented by a linear handle. Waiting returns structured `ProcessStatus`, not a raw integer and not parent `panic` or TPOE. `ProcessStatus` distinguishes normal exit code, signal or host termination, core-dump flag where exposed, timeout kill, cancellation kill, exec failure reported after spawn where the target exposes that state, stopped or continued states where exposed, and a target-unknown raw status. Raw target status is preserved for diagnostics.

Cleaning a live child handle requires one explicit policy: wait, terminate then wait, detach where supported, or error. Supervision APIs operate on `ProcessStatus` and never convert child failure into parent abnormal termination automatically. Target contracts record status capabilities, signal mapping, exit-code width, and unsupported states.

> Trace: D30-D30a, D66, D77, D84-D85, D211, D417
> Covers: Process APIs separate spawn/setup failure from child status, preserve target status detail, and require an explicit live-child cleanup policy.

## Time

`Duration` is a pure value type. `Instant` is monotonic timestamp data. Arithmetic and comparison on `Duration` and `Instant` are pure where they do not observe a clock. Wall-clock reads require wall-clock authority. Monotonic reads and deadlines require monotonic-clock authority. Blocking delay requires sleep authority and names its clock source.

Deadlines use monotonic time unless an API name explicitly states wall-clock scheduling. Sleep APIs state resolution, overshoot, interruption, cancellation interaction, overflow behavior, blocking behavior, and target unsupportedness. Tests inject fake wall and monotonic clocks through explicit fixtures; they do not mutate host global time.

Time-zone data is explicit data rather than ambient host locale. Civil-time formatting, parsing, and conversion contracts name the time-zone database source, version, allocation behavior, and invalid or ambiguous local-time handling. Public capability requirements appear in docs, audit output, and `.koi`.

> Trace: D83, D85, D91, D211, D403
> Covers: Pure duration arithmetic, wall-clock reads, monotonic deadlines, sleep, time-zone data, and fake-clock testing are separate explicit contracts.

## Random

Entropy reads require `EntropyCapability` and return recoverable domain errors for target unsupportedness, temporary unavailability, interruption, permission, resource exhaustion, and raw target error data. Secure random construction records entropy source, reseed policy, blocking or unavailable behavior, target support, algorithm identity, audit status, and failure behavior. Key, nonce, token, salt, and secret constructors accept only admitted crypto-grade sources.

Deterministic pseudo-random generators are separate named values with explicit seeds. Their contracts record algorithm name and version, state size, width behavior, endianness, replay scope, and output-sequence compatibility. They never silently seed from time, PID, thread ID, addresses, uninitialized memory, environment, or ambient host state.

> Trace: D83, D220, D231, D421
> Covers: Entropy, secure randomness, and deterministic replay generators are distinct APIs with explicit authority and seed behavior.

## Network

Pure numeric socket-address parsing requires no authority. DNS and name resolution require `ResolverCapability`. Socket creation, connect, bind, listen, accept, send, receive, shutdown, and socket-option mutation require `NetworkCapability` or a narrower connect, listen, or socket authority. Socket and listener handles are linear by default. Multi-task access uses explicit brokers, channels, or synchronization wrappers; raw I/O is not silently shared by runtime locks.

Every admitted I/O operation belongs to a visible family: blocking, try/nonblocking, deadline/until, or poller-backed. For operation verb `verb`, the public naming pattern is `verbBlocking`, `tryVerb`, `verbUntil(deadline)`, and `verbPoll(poller, token)`. The admitted socket verbs are `connect`, `accept`, `read`, `write`, `send`, and `receive`, producing names such as `connectBlocking`, `tryConnect`, `connectUntil(deadline)`, and `connectPoll(poller, token)`. Cancellation is cooperative through `CancellationToken` and poller readiness. Kyokai does not add an implicit async runtime or forced syscall interruption.

TLS is separate from sockets. TLS configuration names certificate store, verification policy, randomness source, time source, resolver/network authority, and failure behavior. Tests can inject fake resolvers and loopback-only network authority. Audit reports resolver, outbound-connect, listener, raw-socket, TLS, and broader network requirements separately.

> Trace: D91, D93, D100-D101, D117, D211-D212, D236, D260, D411, D473
> Covers: Networking splits address parsing, DNS, socket authority, blocking mode, readiness, deadline, cancellation, TLS, broker sharing, test injection, and audit facts explicitly.

## Why This Shape

[Rikona Kurasaki / Mjoyufull]
The operating system is too powerful to be treated like background weather. Kyokai makes the handle visible, the capability visible, the path base visible, the block visible, and the failure visible.

> Trace: D67, D85, D171, D211-D212
> Covers: External-world APIs expose authority and failure instead of hiding them in globals.

## External-World Contract Matrix

| Family | Authority | Blocking and cancellation | Failure and partial state | Target contract |
| --- | --- | --- | --- | --- |
| Args and environment | `EnvCapability` for host observation or mutation. Startup arguments arrive as explicit values. | Host access contract states whether any operation blocks. | Absence, mutation rejection, secret-redaction state, portable OS category, raw target code. | Process and environment encoding class. |
| File update | Filesystem capability or narrowed directory handle. | Flush and sync steps are named. | Temp path, written prefix, cleanup result, atomicity class, portable OS category, raw target code. | Rename, replace, no-follow, sync, and advisory-lock support. |
| Process | `ProcessCapability` plus linear child handle after spawn. | Wait, timeout, cancellation, terminate, and detach behavior are named. | Spawn/setup error or structured `ProcessStatus`. | Signal map, exit-code range, and exposed status states. |
| Time | Wall-clock, monotonic-clock, or sleep capability according to operation. | Sleep and deadline cancellation are named. | Unsupported clock, interruption, overflow, ambiguous civil time. | Clock resolution, timezone data, and scheduling support. |
| Entropy | `EntropyCapability` or narrowed secure random source. | Blocking and unavailable policy are named. | Unsupported, unavailable, interrupted, permission, resource, and raw target code. | Host entropy class. |
| Network | Resolver capability, network capability, narrowed socket authority, socket/listener handle, or poll registration. | Blocking, readiness, deadline, cancellation, and partial progress are named. | `NetError`, DNS/TLS errors, peer close, partial transfer, portable OS category, raw target code. | Socket, resolver, TLS, and poller support. |
| Terminal | Terminal capability or terminal handle. | Prompt EOF/cancellation and raw-mode cleanup are named. | Unsupported terminal feature or I/O result. | Console kind and terminal-feature facts. |

> Trace: D398-D404, D408-D411, D417, D421-D422, D452, D457, D473, D492
> Covers: External-world APIs expose authority, blocking, cancellation, partial progress, target support, raw error detail, and cleanup behavior by family.

## Time, Locale, Trust, And Protocol Datasets

Civil-time, locale, public-suffix, MIME, certificate-root, revocation, and other externally maintained behavioral data use named dataset providers. A provider record contains dataset class, version, digest, source/provenance, license, target scope, compatibility effect, freshness/expiry policy, offline behavior, cache identity, and update authority.

Host-observed datasets are reported as target facts and do not silently impersonate toolchain-shipped data. Network-updated providers verify their declared signature or provenance rule before activation. Failure preserves the previous verified dataset and returns a typed update result. Runtime lookup never performs a hidden background refresh.

> Trace: D404, D421, D549
> Covers: Time, locale, trust, suffix, and MIME behavior remains versioned, auditable, offline-defined, and explicit about network updates.
