#!/usr/bin/env bash
# Part of the Austral project, under the Apache License v2.0 with LLVM Exceptions.
# See LICENSE file for details.
#
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

set -euxo pipefail

# Build the Kyokai bootstrap executable.
make
# Run inherited and Kyokai host tests through the aggregate Dune alias.
make test
# Check the Phase 3 identity and transition boundary.
make check-phase3-identity
# Validate and execute the implementation-gated Kyokai fixtures.
make run-conformance-fixtures
# Keep the accepted spec and evidence projections synchronized.
make check-spec-integrity
# Retain the executable evidence for the closed narrow Gate-B paper scope.
make gate-b-model
