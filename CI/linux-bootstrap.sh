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
    run_in_nix './run-tests.sh'
}

run_clean_check() {
    make clean
    test ! -f kyokai
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
