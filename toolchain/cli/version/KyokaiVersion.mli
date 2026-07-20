(*
   Part of the Kyokai project.

   SPDX-License-Identifier: GPL-3.0-or-later
*)

(** Version of the Kyokai bootstrap compiler and toolchain. *)

type version = int * int * int

val version : version

val version_string : string
