# Adversarial Kyokai Workloads

This tree contains programs designed to expose wrong compiler behavior and to
put pressure on Kyokai's ownership, cleanup, failure, concurrency, and
application-boundary rules.

These are not polished tutorials. A case can be deliberately awkward, rejected,
resource-hungry, or implementation-gated. Its job is to make one semantic claim
observable and to say exactly which compiler, target, and native toolchain
provider were tested.

Each case lives in its own directory and contains:

- `case.toml`, following [SCHEMA.md](SCHEMA.md);
- `README.md`, explaining the pressure and the failure it can detect;
- `src/`, containing the Kyokai source;
- `expected/`, containing stable diagnostics or normalized observations when
  the case needs them;
- `data/`, only when bounded local input is part of the test.

The initial families are arena allocation, ECS storage, generational handles,
scene graphs, intrusive structures, retained callbacks, linear-container
iteration, transactional asset loading, job ownership, and hot reload. A
family directory is created with its first real or implementation-gated case,
not as an empty promise.

Passing a case is evidence for that case and its recorded environment. It is
not a claim that the compiler is conforming or that the language is proved.
Private compiler hooks and unreviewed unsafe escapes disqualify a case from
safe-language evidence.
