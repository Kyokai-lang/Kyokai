BIN := kyokai
SRC := $(shell find compiler lib bin toolchain -type f \( -name '*.ml' -o -name '*.mli' -o -name '*.mll' -o -name '*.mly' -o -name 'dune' -o -name '*.py' \)) lib/BuiltInModules.ml
PREFIX ?= /usr/local
BUILTINS_GENERATOR := toolchain/bootstrap/concat_builtins.py

.PHONY: all
all: $(BIN)

lib/BuiltInModules.ml: lib/builtin/*.aui lib/builtin/*.aum lib/prelude.h lib/prelude.c
	python3 $(BUILTINS_GENERATOR)

$(BIN): $(SRC)
	dune build
	cp _build/default/bin/kyokai.exe $(BIN)

.PHONY: test
test: $(BIN)
	dune runtest

.PHONY: install
install: $(BIN)
	install -D -m 755 $(BIN) $(PREFIX)/bin/$(BIN)

.PHONY: uninstall
uninstall:
	rm -f $(PREFIX)/bin/$(BIN)

.PHONY: clean
clean:
	rm -f $(BIN)
	rm -rf _build
	rm -f lib/BuiltInModules.ml

.PHONY: gate-b-model
gate-b-model:
	python3 kyokaicalculus/model_tests.py
	python3 kyokaicalculus/machine_runner.py

.PHONY: proofstatus
proofstatus:
	python3 toolchain/prooftrace/check_prooftrace.py --write

.PHONY: check-prooftrace
check-prooftrace:
	python3 toolchain/prooftrace/check_prooftrace.py --check

.PHONY: check-conformance-fixtures
check-conformance-fixtures:
	python3 toolchain/conformance/check_fixtures.py --check

.PHONY: check-phase3-identity
check-phase3-identity:
	python3 toolchain/identity/check_phase3_identity.py

.PHONY: clausestatus
clausestatus:
	python3 toolchain/spec/check_clause_extraction.py --write --registry kyokaispec/extraction/pre-d558.toml --report kyokaispec/extraction/pre-d558-review.md
	python3 toolchain/spec/check_clause_extraction.py --write
	python3 toolchain/spec/check_clause_extraction.py --write --registry kyokaispec/extraction/d627-d635.toml --report kyokaispec/extraction/d627-d635-review.md

.PHONY: check-clause-extraction
check-clause-extraction:
	python3 toolchain/spec/check_clause_extraction.py --check --registry kyokaispec/extraction/pre-d558.toml --report kyokaispec/extraction/pre-d558-review.md
	python3 toolchain/spec/check_clause_extraction.py --check
	python3 toolchain/spec/check_clause_extraction.py --check --registry kyokaispec/extraction/d627-d635.toml --report kyokaispec/extraction/d627-d635-review.md

.PHONY: check-spec-integrity
check-spec-integrity: check-clause-extraction check-prooftrace
	$(MAKE) -C kyokaispec check-sources

.PHONY: run-conformance-fixtures
run-conformance-fixtures: $(BIN) check-conformance-fixtures
	python3 toolchain/conformance/run_fixtures.py --check
