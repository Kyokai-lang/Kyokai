# Kyokai CI

This directory owns repository CI scripts and CI-facing maintenance notes.

GitHub Actions still requires workflow entry files under `.github/workflows/`, so those files should stay thin: they define triggers, runner images, third-party actions, artifacts, and then call scripts from this directory. Put build, test, proof, cleanup, and platform command sequences here instead of growing workflow YAML inline.

Current entry scripts:

- `linux-bootstrap.sh` runs the inherited Linux bootstrap lane through Nix.
- `macos-bootstrap.sh` runs the inherited macOS smoke lane through opam.

The active branch trigger is `main`. Do not reintroduce inherited default-branch triggers unless a compatibility branch is deliberately added.
