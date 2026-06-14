# Diagnostics

[Rikona Kurasaki / Mjoyufull]
> ProofTrace: SPEC-TOOLCHAIN-05-DIAGNOSTICS
> Covers: This chapter is registered in the public ProofTrace evidence graph; registration does not claim implementation, conformance, or theorem completion.

Diagnostics are part of the language experience, but they are also part of the toolchain contract. A compiler that knows the rule but cannot say what went wrong has left the programmer outside in the rain with a locked door and a key that almost fits.

> Trace: D29
> Covers: Kyokai diagnostics are a normative toolchain surface, not a polish-only feature.

## Diagnostic Records

Every diagnostic has a stable code, severity, primary message, zero or more source spans, labels, notes, help records, suggestions, and related diagnostics. Diagnostic IDs have lifecycle states: `active`, `deprecated-alias`, and `removed-at-schema-boundary`. A released code is never reused for a different rule. Human rendering can improve without changing code identity, severity category, span meaning, suggestion semantics, suppression semantics, or JSON compatibility within the same diagnostic schema version.

> Trace: D29, D157, D414
> Covers: Diagnostics have stable structured identity, explicit lifecycle, and compatible human-text evolution.

Diagnostic codes are spelled `KYO-E0001` for errors, `KYO-W0001` for warnings, `KYO-L0001` for lints, `KYO-A0001` for audit findings, and `KYO-I0001` for informational notes that may appear as top-level records in machine output. A code is never reused for a different rule after release.

> Trace: D29, D150
> Covers: Diagnostic code namespaces are stable and rule-specific.

Severity is one of `error`, `warning`, `lint`, `audit`, or `info`. Errors prevent the command from succeeding. Warnings do not prevent success unless promoted by policy. Lints are style or maintainability diagnostics. Audit findings are risk/policy diagnostics from `kyokai audit` or audit-enabled commands. Info diagnostics never change command success.

> Trace: D29, D150
> Covers: Severity has fixed command-success behavior.

## Source Spans

A source span identifies a file, byte range, line range, column range, and source origin. The origin is one of `source`, `generated`, `embedded`, `koi`, `manifest`, `lockfile`, `target-spec`, or `command-line`. Byte ranges are over UTF-8 bytes in the exact input file after line-ending normalization rules from the lexical spec.

> Trace: D29, D52, D79, D83
> Covers: Diagnostics can point at source, generated files, artifacts, manifests, lockfiles, target specs, and flags.

A diagnostic with multiple relevant sites must mark exactly one primary span unless the error is genuinely source-less. Other spans are related spans. For example, an import collision has the import site as primary and the conflicting exported declarations as related spans.

> Trace: D29, D78, D214
> Covers: Multi-site errors remain navigable and deterministic.

If a diagnostic arises from a `.koi` artifact, the tool must report the artifact path and package identity. If the artifact records original source spans and the source is available, the diagnostic may also include original source locations as related spans. Missing source must not make the diagnostic lie about which artifact failed.

> Trace: D29, D79
> Covers: Artifact diagnostics name artifacts honestly and use source spans only when available.

## JSON Schema

`--message-format=json-lines` emits one UTF-8 JSON object per line. `--message-format=json` emits one versioned JSON report document whose diagnostic array carries the same record shape. Each diagnostic record has at least these keys:

```json
{
  "schema": "kyokai-diagnostic-v1",
  "code": "KYO-E0001",
  "severity": "error",
  "message": "short human message",
  "primary_span": null,
  "spans": [],
  "notes": [],
  "suggestions": [],
  "command": "check",
  "package": null
}
```

> Trace: D29, D225, D503
> Covers: Machine diagnostics use the same versioned record schema in JSON-document and JSON-lines lanes.

Unknown keys in a JSON diagnostic must be ignored by consumers. Removing a key, changing a key's meaning, changing a severity string, or reusing a code for a different rule requires a new schema version.

> Trace: D29, D157
> Covers: Diagnostic JSON evolves compatibly by schema version.

A suggestion has a stable fix ID, message, safety class, and edit set when edits exist. Safety class is `note-only`, `manual`, `maybe-applicable`, `machine-applicable`, or `machine-applicable-safe`. `kyokai fix` applies only `machine-applicable-safe` edits by default. A safe edit must preserve parseability and must change semantics only through the explicit repair described by the diagnostic.

> Trace: D25, D29, D414, D503
> Covers: Suggestions use stable fix IDs and distinguish notes, manual work, previews, machine edits, and validated safe automatic edits.

## Diagnostic Explanation Catalog

Every released diagnostic code has an explanation catalog entry shipped with the toolchain. The entry includes the code, severity, rule name, short explanation, longer explanation, common causes, zero or more worked examples, repair patterns, one suggestion-applicability record or an explicit `none`, related diagnostic codes, and links or local anchors to relevant spec chapters. The catalog is versioned with the diagnostic schema.

> Trace: D29, D267
> Covers: Diagnostic codes have first-party explanations that can be rendered offline and tied back to the spec.

`kyokai explain <code-or-category>` reads the local explanation catalog by default. It prints human text or versioned machine records according to `--message-format`. If the installed toolchain does not know the requested code, the command must say so without searching the network by default. Online documentation can mirror the same catalog, but the local toolchain remains the authority for the codes it emits.

> Trace: D29, D225, D267
> Covers: Explanation lookup works offline, matches the installed compiler version, and keeps online docs as mirrors rather than hidden authority.

## Automatic Fixes

A diagnostic carries edits only when the compiler can state the exact repair being offered. `machine-applicable-safe` means the edit passed the repair-specific validation required for default `kyokai fix`. `machine-applicable` means an edit set exists but requires explicit opt-in. `maybe-applicable` means the compiler can suggest a plausible candidate but cannot prove the intended repair. `manual` and `note-only` never apply edits.

> Trace: D25, D29, D267, D414, D485
> Covers: Automatic fixes are gated by a closed safety-class table rather than by a separate refactoring folklore layer.

`kyokai fix` applies only selected `machine-applicable-safe` suggestions by default. It must reject stale suggestions whose source spans no longer match the checked snapshot, reject overlapping edits unless the diagnostic engine has already merged them into one edit set, rerun parsing after edits, and format only the changed files through `kyokai fmt` rules. If validation fails, the command must leave the original files unchanged or restore them before reporting failure.

> Trace: D25, D29, D83, D267
> Covers: Safe fixes are snapshot-checked, overlap-checked, parse-checked, and formatter-integrated before file changes become visible.

## Diagnostic Policy

Kyokai has no separate `kyokai lint` command. Compiler-integrated advisory diagnostics flow through `check`, `build`, `test`, and the Analysis Server. Warnings are grouped by category. Required categories include `unused`, `style`, `compatibility`, `deprecated`, `unsafe-surface`, `capability-surface`, `ffi-surface`, `reproducibility`, and `toolchain`. The compiler may add categories only by documenting them in this spec or a compatible extension registry.

> Trace: D29, D150, D155
> Covers: Warnings and lints are categorized and not free-floating messages.

Project-level diagnostic policy lives in `kyokai.toml`. Source-level suppression is allowed only through explicit attributes or pragmas defined by the language spec. A suppression binds to diagnostic code or category and can include scope, expiry, reason, and policy source. Blanket suppression of all errors is illegal. The compiler-integrated `misclassified_failure` diagnostic reports a Tier-1 API that encodes programmer bugs, violated preconditions, impossible states, or invariant corruption as recoverable `Result`.

> Trace: D29, D155, D414, D455
> Covers: Diagnostic suppression is explicit, bounded, auditable, and paired with compiler-integrated failure-taxonomy checking rather than a separate lint frontend.

A suppression that matches no emitted diagnostic produces a warning unless the policy marks unused suppressions as allowed. This prevents dead suppressions from becoming old dust nobody remembers to clean.

> Trace: D29
> Covers: Suppression policy catches stale suppressions.

## Determinism

Given the same inputs, target, profile, and diagnostic policy, diagnostics must be emitted in a deterministic order. The order is by compiler phase, package dependency order, logical module name, source span, and code, unless a chapter gives a more specific order for a command.

> Trace: D29, D83
> Covers: Diagnostic ordering is reproducible.

Human rendering may use color, underlines, source excerpts, and terminal width. Those presentation choices must not change diagnostic JSON, command success, lockfiles, artifacts, or cache keys.

The canonical human renderer uses the semantic palette from the CLI chapter. Red is reserved for error and fatal lanes, cyan for success, gold for warning or authority-policy attention, and lavender for notes and structural emphasis. Severity words, diagnostic codes, labels, and source markers remain present in monochrome output; color is never the only severity or state signal.

> Trace: D29, D83
> Covers: Human diagnostic rendering is presentation-only.

## Required Quality

## Ownership-State Diagnostics

A linearity or borrow diagnostic reports the binding or projection path, current D348 state, previous state-changing span, attempted operation, and nearest legal action when one exists. Branch-join diagnostics print every normally completing arm and its resulting state. Partial-move diagnostics print the moved field set and the remaining live fields. Loop diagnostics identify `PendingLoopConsumption` and the zero-, one-, or repeated-iteration path that prevents exactly-once proof. Inserted borrow and reborrow diagnostics include the completion registry ID and insertion span.

> Trace: D29, D240, D348, D356
> Covers: Ownership errors expose checker state transitions instead of reporting only a generic use-after-move or borrow conflict.

A diagnostic must name the rule violated, the entity involved, the source location, and the nearest actionable correction when the compiler can know it. For ownership, borrow, capability, target, package, and `.koi` errors, the diagnostic must include enough related context that a user can find the other side of the conflict without reading compiler internals.

> Trace: D29, D78-D79, D137, D150
> Covers: Diagnostics for core Kyokai safety boundaries carry actionable context.

A diagnostic must not blame a later phase when an earlier rule is the true cause. A missing symbol caused by a hidden import collision reports the import collision. A link failure caused by an undeclared native dependency reports the undeclared dependency before invoking the linker when the tool can prove it.

> Trace: D29, D31, D78, D150
> Covers: Diagnostics point at the first meaningful rule violation.

## Why This Shape

[Rikona Kurasaki / Mjoyufull]
A good diagnostic does not flatter. It shows the wound, names the blade, and identifies the code that has to move. Kyokai needs that because a language with linear values, contracts, unsafe walls, and capabilities can become a maze if the compiler only says no.

> Trace: D29
> Covers: Kyokai diagnostic quality is required because the language's safety model must be teachable through errors.

## Stable Diagnostic, Redaction, And Explanation Contract

A structured diagnostic records schema version, stable diagnostic ID, severity, category, message key, rendered human message, primary span, related spans with roles, notes, explanation ID, fix IDs, source origin, target/profile/C-toolchain contract, policy facts, redaction facts, and external-tool raw-log artifact when present.

Stable IDs and JSON fields are compatibility surfaces. Human wording can improve while preserving semantic identity. A removed or repurposed ID is a compatibility change. A deprecated source surface emits its stable deprecation ID, replacement, compatibility horizon, and migration action.

Redaction is default-on for secret-marked values, environment values, process arguments, raw addresses, capability internals, tokens, keys, and foreign TLS error payloads that contain secrets. A diagnostic reports that redaction happened. Revealing protected content requires an explicit local policy and never appears in machine output by accident.

External-tool failures retain raw stdout, raw stderr, executable identity/version, normalized arguments after redaction, working directory class, environment-key names, exit category or signal, target, SDK/sysroot, input/output digests, generated location, source-map identity, and toolchain provenance. Human diagnostics summarize; artifacts preserve raw evidence.

Kyokai remaps an external C compiler, assembler, linker, debugger, sanitizer, coverage, or profiler location only when the authoritative source map proves the Kyokai span. Machine output retains both the Kyokai span and original generated/external location. A generated-C rejection after successful Kyokai checking is categorized as a code-generation defect, unsupported C-toolchain contract, native dependency error, or external-tool failure. It is never rewritten as a fabricated source type error.

`kyokai explain` exposes named compiler-backed modes: `linearity`, `borrow`, `defer`, `failure-flow`, `lowering`, `capability`, `target`, `koi`, `generated-c`, and `package-graph`. Explain output never changes program semantics. `kyokai fix` and Analysis Server code actions use the same fix IDs and closed safety classes: `note-only`, `manual`, `maybe-applicable`, `machine-applicable`, and `machine-applicable-safe`.

Branch-join diagnostics print each binding state per arm. Resource-flow assists print constructors, patterns, joins, cleanup obligations, fixtures, interfaces, `.koi` facts, downstream packages, and post-edit validation status.

> Trace: D302-D303, D316, D328, D333, D358, D368, D378-D380, D402, D404, D414, D420, D422, D427-D428, D444, D474, D482, D485, D488, D495, D503, D518
> Covers: Structured diagnostic identity, redaction, raw external logs, deprecations, explain modes, fix safety, branch joins, and resource-flow reporting are explicit.

## Application Integration Diagnostics

Integration diagnostics preserve the boundary that failed. Generator and projection failures identify request/result identity, output class, provenance, and transaction state. Migration failures identify plan identity, edit class, stale preimage, affected package/configuration, and recovery journal. Adapter, packaging, mobile, browser, and deployment failures identify the adapter/provider, target/profile, authority source, raw external-log artifact, source/projection map, and verification state.

Authority-denial diagnostics carry a requirement graph from the source declaration or package artifact to the denied capability and every policy source that contributed to the effective ceiling. A suggested repair is `machine-applicable-safe` only when it threads existing authority or applies a proven attenuation without changing the authority ceiling. Policy widening, new providers, dependency replacement, secret creation, and unsafe suppression are never machine-applicable repairs.

Framework-handle diagnostics distinguish wrong owner, unknown slot, stale generation, removed entry, retired slot, invalid mutation epoch, and illegal overlapping view. Callback diagnostics point at the captured binding or callback expression and preserve callable class, retention, affinity, reentrancy, cancellation, and generated-wrapper facts as related context.

> Trace: D540-D545, D547-D550, D552-D557
> Covers: Application-integration diagnostics report the true generator, migration, authority, handle, callback, adapter, packaging, target, or remote-service boundary instead of fabricating a source type error.
