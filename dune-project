(lang dune 2.1)
(using menhir 2.0)

(name kyokai)
(version 0.2.0)

(package
 (name kyokai)
 (synopsis "The bootstrap compiler and toolchain for Kyokai")
 (description "The bootstrap compiler and toolchain for the Kyokai systems programming language.")
 (license GPL-3.0-or-later)
 (depends
  (ppxlib (>= 0.25.1))
  (ppx_deriving (= 5.2.1))
  (ppx_sexp_conv (= v0.15.0))
  (sexplib (= v0.15.1))
  (ounit2 (= 2.2.7))
  (menhir (= 20220210))
  (zarith (= 1.12))
  (yojson (= 2.1.0))))

(generate_opam_files)
