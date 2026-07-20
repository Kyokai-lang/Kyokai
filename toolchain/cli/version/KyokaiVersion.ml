(*
   Part of the Kyokai project.

   SPDX-License-Identifier: GPL-3.0-or-later
*)

(** Version of the Kyokai bootstrap compiler and toolchain. *)

type version = int * int * int

let version : version = (0, 2, 0)

let version_string : string =
  let major, minor, patch = version in
  Printf.sprintf "%d.%d.%d" major minor patch
