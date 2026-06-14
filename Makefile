BIN := austral
SRC := $(shell find lib bin toolchain -type f \( -name '*.ml' -o -name '*.mli' -o -name '*.mll' -o -name '*.mly' -o -name 'dune' -o -name '*.py' \)) lib/BuiltInModules.ml
PREFIX ?= /usr/local

.PHONY: all
all: $(BIN)

lib/BuiltInModules.ml: lib/builtin/*.aui lib/builtin/*.aum lib/prelude.h lib/prelude.c
	python3 concat_builtins.py

$(BIN): $(SRC)
	dune build
	cp _build/default/bin/austral.exe $(BIN)

.PHONY: test
test: $(BIN)
	dune runtest

.PHONY: install
install: $(BIN)
	install -D -m 755 austral $(PREFIX)/bin/austral

.PHONY: uninstall
uninstall:
	sudo rm $(PREFIX)/bin/austral

.PHONY: clean
clean:
	rm -f $(BIN); rm -rf _build; rm -f lib/BuiltInModules.ml

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

.PHONY: run-conformance-fixtures
run-conformance-fixtures: check-conformance-fixtures
	dune exec --display=quiet ./toolchain/conformance/stage_runner/KyokaiConformanceStage.exe -- --check
