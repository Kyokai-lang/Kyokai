# Adversarial Case Record

Every `case.toml` uses this logical schema. The checked TOML schema and runner
are added with the first executable Kyokai-native case.

```toml
schema = "kyokai-adversarial-case-1"
id = "ADV-<FAMILY>-NNNN"
title = "short stable title"
class = "accept" # accept | reject | defined_failure | runtime_observation |
                 # generated_c_structure | differential | stress | design_pressure
owner = "name or project role"
status = "implementation-gated" # implementation-gated | runnable | admitted
cadence = "pr"                   # pr | nightly | release | manual

spec_clauses = []
conformance_cases = []
required_maturity = []
required_xps = []

[environment]
targets = []
c_toolchain_contracts = []
c_toolchain_providers = []

[authority]
ceiling = []

[allocation]
policy = "explicit case-specific statement"

[expect]
outcome = "pass"
diagnostic_codes = []
observations = []

[budget]
wall_time_ms = 0
memory_bytes = 0
processes = 0
threads = 0

[evidence]
detects = []
known_gaps = []
```

Design-pressure cases also record cleanup distance, duplicated cleanup,
non-local redesign, checker-only API distortion, unsafe or private escapes,
diagnostic usefulness, and reusable abstractions. These fields describe the
case; they do not vote on language semantics.
