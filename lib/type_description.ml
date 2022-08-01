module Voidp (T : sig
  val name : string
end) : sig
  type t [@@deriving sexp_of]

  val t : t Ctypes.typ
  val t_opt : t option Ctypes.typ
end = struct
  type t = unit Ctypes.ptr

  let t = Ctypes.(ptr void)
  let t_opt = Ctypes.(ptr_opt void)

  let sexp_of_t t =
    [%sexp
      (T.name : Base.String.t),
        (Ctypes.raw_address_of_ptr t : Base.Nativeint.Hex.t)]
end

module Types (F : Ctypes.TYPE) = struct
  open F

  module Futhark_context_config = Voidp (struct
    let name = "futhark_context_config"
  end)

  let futhark_success = constant "FUTHARK_SUCCESS" int
  let futhark_program_error = constant "FUTHARK_PROGRAM_ERROR" int
  let futhark_out_of_memory = constant "FUTHARK_OUT_OF_MEMORY" int
end
