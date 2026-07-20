(*
   Part of the Austral project, under the Apache License v2.0 with LLVM Exceptions.
   See LICENSE file for details.

   SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
*)
(** Sources of the inherited builtin modules and prelude, injected into OCaml
    source by [toolchain/bootstrap/concat_builtins.py]. *)

(** Source code of the Austral.Pervasive interface file. *)
val pervasive_interface_source: string
(** Source code of the Austral.Pervasive body file. *)
val pervasive_body_source: string

(** Source code of the Austral.Memory interface file. *)
val memory_interface_source: string
(** Source code of the Austral.Memory body file. *)
val memory_body_source: string

(** Source code of prelude.h *)
val prelude_h: string
(** Source code of prelude.c *)
val prelude_c: string
