(*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *)
open! IStd
module Invalidation = PulseInvalidation
module Trace = PulseTrace
module ValueHistory = PulseValueHistory

type t =
  | AddressOfCppTemporary of Var.t * ValueHistory.t
  | AddressOfStackVariable of Var.t * Location.t * ValueHistory.t
  | Closure of Typ.Procname.t
  | Constant of Const.t
  | Invalid of Invalidation.t Trace.t
  | MustBeValid of unit Trace.t
  | StdVectorReserve
  | WrittenTo of unit Trace.t
[@@deriving compare]

module Attributes : sig
  include PrettyPrintable.PPUniqRankSet with type elt = t

  val get_address_of_stack_variable : t -> (Var.t * Location.t * ValueHistory.t) option

  val get_closure_proc_name : t -> Typ.Procname.t option

  val get_constant : t -> Const.t option

  val get_invalid : t -> Invalidation.t Trace.t option

  val get_must_be_valid : t -> unit Trace.t option

  val get_written_to : t -> unit Trace.t option

  val is_modified : t -> bool

  val is_std_vector_reserved : t -> bool
end
