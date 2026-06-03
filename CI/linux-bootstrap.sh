#!/usr/bin/env bash
set -euo pipefail

usage() {
    printf 'usage: %s {test|clean}\n' "$0" >&2
}

run_in_nix() {
    nix-shell --command "$1"
}

run_tests() {
    run_in_nix 'true'
    run_in_nix 'make'
    run_in_nix 'make test'
    run_in_nix 'make check-prooftrace'
    run_in_nix 'make gate-b-model'
    run_in_nix 'python test-programs/runner.py'
    run_in_nix 'bash run-examples.sh'
    run_in_nix 'make -C standard clean && make -C standard'
    run_in_nix './standard/test_bin'
}

run_clean_check() {
    make clean
    test ! -f austral
}

case "${1:-}" in
    test)
        run_tests
        ;;
    clean)
        run_clean_check
        ;;
    *)
        usage
        exit 2
        ;;
esac
