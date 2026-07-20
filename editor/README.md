# Kyokai editor support

The inherited Austral editor bundles were moved to the private prior-art corpus
during Phase 3 because their file associations and grammar describe `.aui` and
`.aum`, not Kyokai. Shipping them under a Kyokai label would silently accept the
wrong language.

Official Kyokai editor bundles belong to the Analysis Server and editor work in
Phase 8. Until those bundles exist, editors should associate `*.kyo` with plain
text. The compiler remains the authority for syntax and diagnostics.
