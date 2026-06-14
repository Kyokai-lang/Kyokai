# Crypto Policy

[Rikona Kurasaki / Mjoyufull]
> ProofTrace: SPEC-STDLIB-10-CRYPTO-POLICY
> Covers: This chapter is registered in the public ProofTrace evidence graph; registration does not claim implementation, conformance, or theorem completion.

Cryptography is not where Kyokai gets to show off. It is where the language has to be humble, strict, and boring in the places boring keeps people alive.

> Trace: D231
> Covers: `Kyokai.Crypto` admits only externally specified, vector-tested, side-channel-explicit cryptographic APIs.

## Admission Rule

`Kyokai.Crypto` includes only named modern algorithms, modes, protocols, key derivation functions, hashes, MACs, signatures, password hashing schemes, and random constructions with external specifications, published vectors, and documented security properties. Kyokai does not invent cryptographic primitives for the standard library.

> Trace: D229, D231
> Covers: Crypto admission requires external specification and rejects invented primitives.

Deprecated, broken, legacy, or compatibility-only cryptography is permitted only in explicitly named compatibility modules with warning metadata. Compatibility crypto is not imported by ordinary prelude-like surfaces and is never presented as the modern default.

> Trace: D229, D231, D243
> Covers: Legacy crypto is isolated and warned.

## Implementation Policy

FFI-backed crypto is admitted when its admission record identifies a mature reviewed library and shows that wrapping that library provides stronger evidence than a fresh native implementation. Native Kyokai crypto is admitted only with review evidence appropriate to the primitive's risk, official or de facto standard test vectors, documented side-channel claims, and conformance tests for every tooling-observable claim. Neither implementation strategy receives default preference without that evidence record.

> Trace: D230-D231
> Covers: Crypto can be FFI-backed or native only when the trust evidence fits the risk.

Pure Kyokai memory safety is not a crypto audit. A native implementation must still address timing behavior, cache behavior when the algorithm uses those facts, key erasure, randomness quality, algorithm agility, invalid-input handling, and misuse resistance.

> Trace: D85, D231
> Covers: Crypto contracts include side-channel and misuse concerns beyond ordinary memory safety.

## API Contract Fields

Every crypto API family publishes the common stdlib contract fields plus crypto-specific fields: specification name/version, security level or intended use, key/nonce/IV rules, randomness source, side-channel claim, zeroization behavior, algorithm availability, test-vector source, review status, and misuse warnings.

> Trace: D85, D229, D231
> Covers: Crypto APIs have additional mandatory contract fields.

| API Family | Ownership | Allocation | Failure | Capabilities | Linearity | Tests | Trace |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Random/entropy | Mutably borrows `EntropyCapability`. | Output buffers borrowed; owned bytes require allocator. | Entropy failure returns typed error. | `EntropyCapability`. | No secret duplication unless the API contract explicitly admits a named copy operation. | OS failure injection, statistical sanity, and vectors for every admitted deterministic construction. | D231 |
| Symmetric encryption | Borrows or consumes key/nonce/message by contract. | Output buffer explicit; owned output uses allocator. | Authentication failure is data; invalid sizes are typed errors or TPOE as stated. | RNG only for APIs that create nonces/keys. | Keys and secret buffers are linear where ownership matters. | official vectors, tamper tests, nonce misuse diagnostics. | D229, D231 |
| Hash/MAC/KDF | State values own internal context. | Streaming state allocation explicit. | Invalid parameters typed; impossible states rejected by type or TPOE. | RNG only for salt/key generation helpers. | Secret keys/password material has cleanup contract. | official vectors, streaming/chunking equivalence. | D229, D231 |
| Public-key signatures/KEM | Keys are owned values or borrowed views by contract. | Encoded forms take allocator if owned. | Verification failure is data, not fatal. | RNG for generation/signing where algorithm requires it. | Private keys are linear or explicitly copy-restricted. | official vectors, malformed input, serialization round trips. | D229, D231 |
| Compatibility crypto | Same fields as stable crypto. | Same. | Same. | Same. | Same. | Legacy vectors plus warning metadata tests. | D231, D243 |

> Trace: D85, D229, D231, D243
> Covers: Crypto API families publish ownership, allocation, failure, capability, linearity, and tests.

## Secret Material

Secret keys, private keys, passwords, seeds, and intermediate secret buffers must state their ownership and cleanup contract. If an API promises zeroization, the promise is part of the public contract and must be preserved by backend lowering. If an API cannot guarantee zeroization on a target, it must not claim that guarantee on that target.

> Trace: D73, D85, D228, D231
> Covers: Secret cleanup guarantees are explicit and backend-preserved when promised.

Secret material must not be formatted through ordinary `Displayable` in a way that leaks the secret. Diagnostic rendering for secret-bearing values is redacted unless a deliberately unsafe or test-only API states otherwise.

> Trace: D40, D85, D231
> Covers: Formatting does not accidentally expose secrets.

## Randomness And Nonces

APIs that generate keys, nonces, IVs, salts, or random protocol values must take the required randomness capability explicitly or accept an explicit deterministic test generator in test-only surfaces. Nonce reuse behavior, caller-supplied nonce contracts, and generated nonce storage are specified per algorithm.

> Trace: D83, D220, D231
> Covers: Crypto randomness and deterministic tests are distinct and explicit.

## Why This Shape

[Rikona Kurasaki / Mjoyufull]
RIIK does not mean pretending a fresh implementation is wise because it is ours. In crypto, pride gets people hurt. Kyokai can wrap mature libraries, and it can write native code when the evidence is real, but the spec never lets confidence stand in for proof.

> Trace: D230-D231
> Covers: Crypto policy keeps native ambition subordinate to external standards, vectors, side-channel contracts, and review.

## Entropy, Advisories, And Minimum-Safe Versions

Secure random APIs receive `EntropyCapability` or an admitted narrowed secure-random value. Deterministic PRNGs and test fixtures never satisfy secure-random parameters. Crypto admission records state entropy source, reseed policy, blocking or unavailable behavior, algorithm identity, target support, review status, and failure mapping.

Security advisories record identifier, affected modules and versions, severity vocabulary, patched versions, minimum safe version when one exists, source links, and publication authority. Compatibility modules for legacy crypto carry warnings and are excluded from preferred imports. Patch policy does not silently rewrite dependency resolution; audit reports advisory state and explicit project policy decides whether affected versions are rejected.

> Trace: D421, D431
> Covers: Crypto entropy, deterministic-test separation, advisory metadata, patch policy, and minimum-safe versions are explicit.

## Trust And Revocation Dataset Providers

Certificate roots, revocation lists, transparency metadata, algorithm-policy datasets, and similar security inputs are provider-backed behavioral datasets. Crypto and TLS APIs name the selected provider identity and its freshness, expiry, signature/provenance, offline, cache, and update contract. A provider update requires explicit filesystem or network authority according to the operation.

An expired, unavailable, malformed, or unverifiable dataset produces the provider's named failure. It does not silently disable verification, accept an untrusted peer, or replace the active verified dataset. Toolchain, target-observed, and application-bundled providers remain distinct in audit and reproducibility output.

> Trace: D231, D404, D421, D549
> Covers: Security datasets fail closed and retain explicit provider identity instead of inheriting ambient host trust state without record.
