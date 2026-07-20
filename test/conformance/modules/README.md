# Modules Conformance Lane

This lane contains package-rooted single-file `.kyo` module discovery, retired `.kai` rejection, derived-interface inputs, import graph construction, visibility, module-name/path matching, and cycle diagnostics.

Current status: the Phase 3 package-rooted source-loading and local derived-interface slice is implemented. Supporting host tests live in `test/host/frontend/KyokaiSourceFileTest.ml`, `test/host/frontend/KyokaiInterfaceValidationTest.ml`, and `test/host/frontend/KyokaiPackageSourceTest.ml`. The implementation-gated fixtures cover package discovery, generated `.koi` rejection, module-name/path mismatch, executable-entry validation, retired `.kai` rejection, and a local private-type interface leak. Import resolution, module cycles, cross-module visibility, `.koi`, and public conformance remain open.
