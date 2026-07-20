#!/usr/bin/env bash
set -euo pipefail

opam switch create kyokai-bootstrap 4.13.0
eval "$(opam env --switch=kyokai-bootstrap --set-switch)"
opam install --deps-only -y .

make
make -C standard
