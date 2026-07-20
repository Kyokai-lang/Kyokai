# Lexer Conformance Lane

This lane contains accepted and rejected source-byte and lexical-token fixtures: UTF-8, BOM rejection, newline normalization, comments, identifiers, reserved words, operators, punctuation, numeric literals, string/raw/code-point/byte literals, and rejected inherited spellings.

Current status: the Phase 3 source-byte and lexical boundaries are implemented and exercised by `test/host/frontend/KyokaiSourceTextTest.ml`, `test/host/frontend/KyokaiLexicalTokenTest.ml`, and the implementation-gated rejection matrices under `parser/`. Dedicated public lexer fixtures and released diagnostic codes remain open; these results are supporting implementation evidence, not conformance.
