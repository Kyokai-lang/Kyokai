SOURCES := spec.md \
           src/language/00-introduction.md \
           src/language/01-goals-and-non-goals.md \
           src/language/02-lexical-syntax.md \
           src/language/03-grammar.md \
           src/language/04-modules-and-visibility.md \
           src/language/05-declarations.md \
           src/language/06-type-system.md \
           src/language/07-generics-and-typeclasses.md \
           src/language/08-patterns.md \
           src/language/09-expressions-and-evaluation.md \
           src/language/10-statements-and-control-flow.md \
           src/language/11-linearity-borrowing-and-regions.md \
           src/language/12-implicit-completions-and-elaboration.md \
           src/language/13-contracts-and-runtime-failure.md \
           src/language/14-capabilities-and-authority.md \
           src/language/15-concurrency.md \
           src/language/16-unsafe-ffi-and-abi.md \
           src/language/17-memory-layout-and-backend-contract.md \
           src/language/18-built-ins.md \
           src/language/19-examples.md \
           src/toolchain/00-toolchain-overview.md \
           src/toolchain/01-manifest-package-workspace.md \
           src/toolchain/02-module-resolution-and-koi.md \
           src/toolchain/03-cli.md \
           src/toolchain/04-build-profiles-targets-linking.md \
           src/toolchain/05-diagnostics.md \
           src/toolchain/06-formatter.md \
           src/toolchain/07-testing-coverage-bench.md \
           src/toolchain/08-docs-lsp-audit.md \
           src/toolchain/09-reproducibility-incremental-builds.md \
           src/toolchain/10-package-index-semver-releases-ci.md \
           src/toolchain/11-build-generation-and-playground.md \
           src/toolchain/12-capability-deny-policy.md \
           src/toolchain/13-application-integration-and-deployment.md \
           src/stdlib/00-stdlib-overview.md \
           src/stdlib/01-admission-contracts.md \
           src/stdlib/02-core-result-optional-display-error.md \
           src/stdlib/03-allocators-and-memory-containers.md \
           src/stdlib/04-text-bytes-paths-and-strings.md \
           src/stdlib/05-collections.md \
           src/stdlib/06-iterators-and-generators.md \
           src/stdlib/07-math-and-numerics.md \
           src/stdlib/08-io-files-env-process-time-random.md \
           src/stdlib/09-concurrency-primitives.md \
           src/stdlib/10-crypto-policy.md \
           src/stdlib/11-transitional-ffi-tracking.md \
           src/stdlib/12-application-integration-contracts.md \
           src/rationale/00-rationale-index.md \
           src/rationale/01-language-design.md \
           src/rationale/02-syntax.md \
           src/rationale/03-error-handling-and-tpoe.md \
           src/rationale/04-linear-resources.md \
           src/rationale/05-capabilities.md \
           src/rationale/06-concurrency.md \
           src/rationale/07-stdlib-philosophy.md \
           src/rationale/08-toolchain-philosophy.md \
           src/rationale/09-backend-choice.md \
           src/project/00-project-boundary.md \
           src/project/01-governance.md \
           src/project/02-decision-traceability.md \
           src/project/03-formalization-roadmap.md \
           src/project/04-project-licensing.md \
           src/project/05-admission-and-change-control.md \
           src/project/06-reference-products-and-workloads.md \
           src/appendices/c-austral-differences.md \
           src/appendix-a.md

PANDOC_FLAGS := --standalone --embed-resources --section-divs --table-of-contents --toc-depth=3

OUTPUT_PDF := spec.pdf
OUTPUT_HTML := spec.html
PDF_ENGINE ?= pdflatex
PDF_ENGINE_NAME := $(notdir $(PDF_ENGINE))

.PHONY: default all pdf html check-sources check-clause-extraction check-pdf-engine clean

default: html

all: html pdf

pdf: check-pdf-engine $(OUTPUT_PDF)

html: $(OUTPUT_HTML)

check-clause-extraction:
	python3 ../toolchain/spec/check_clause_extraction.py --check --registry kyokaispec/extraction/pre-d558.toml --report kyokaispec/extraction/pre-d558-review.md
	python3 ../toolchain/spec/check_clause_extraction.py --check
	python3 ../toolchain/spec/check_clause_extraction.py --check --registry kyokaispec/extraction/d627-d635.toml --report kyokaispec/extraction/d627-d635-review.md

check-sources: check-clause-extraction
	@status=0; \
	for source in $(SOURCES); do \
		if [ ! -f "$$source" ]; then \
			echo "missing source: $$source"; \
			status=1; \
		fi; \
	done; \
	listed=$$(mktemp); \
	discovered=$$(mktemp); \
	trap 'rm -f "$$listed" "$$discovered"' EXIT HUP INT TERM; \
	printf '%s\n' $(filter src/%.md,$(SOURCES)) | LC_ALL=C sort > "$$listed"; \
	find src -type f -name '*.md' -print | LC_ALL=C sort > "$$discovered"; \
	duplicates=$$(uniq -d "$$listed"); \
	if [ -n "$$duplicates" ]; then \
		printf 'duplicate source entry: %s\n' $$duplicates; \
		status=1; \
	fi; \
	unlisted=$$(comm -13 "$$listed" "$$discovered"); \
	if [ -n "$$unlisted" ]; then \
		printf 'unlisted source: %s\n' $$unlisted; \
		status=1; \
	fi; \
	stale=$$(comm -23 "$$listed" "$$discovered"); \
	if [ -n "$$stale" ]; then \
		printf 'listed source outside current src tree: %s\n' $$stale; \
		status=1; \
	fi; \
	exit $$status

$(OUTPUT_HTML): Makefile $(SOURCES) | check-sources
	pandoc $(SOURCES) $(PANDOC_FLAGS) -t html -o $(OUTPUT_HTML)

check-pdf-engine:
	@command -v $(PDF_ENGINE) >/dev/null 2>&1 || { \
		echo "PDF engine '$(PDF_ENGINE)' not found."; \
		echo "Run 'make html' for the default HTML build, install $(PDF_ENGINE), or pass PDF_ENGINE=<engine> to make pdf."; \
		exit 1; \
	}; \
	case "$(PDF_ENGINE_NAME)" in \
		pdflatex|xelatex|lualatex) \
			if command -v kpsewhich >/dev/null 2>&1 && ! kpsewhich "$(PDF_ENGINE_NAME).fmt" >/dev/null 2>&1; then \
				echo "PDF engine '$(PDF_ENGINE)' is installed, but its TeX format/configuration is unavailable."; \
				echo "Repair the TeX installation, run 'make html', or pass a working PDF_ENGINE=<engine>."; \
				exit 1; \
			fi ;; \
	esac

$(OUTPUT_PDF): Makefile $(SOURCES) | check-sources
	pandoc $(SOURCES) $(PANDOC_FLAGS) -t latex --pdf-engine=$(PDF_ENGINE) -o $(OUTPUT_PDF)

clean:
	rm -f $(OUTPUT_PDF) $(OUTPUT_HTML)
