#!/usr/bin/env bash
set -euo pipefail

opam switch create austral 4.13.0
eval "$(opam env --switch=austral --set-switch)"
opam install --deps-only -y .

make
make -C standard
