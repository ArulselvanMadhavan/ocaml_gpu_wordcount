open Ctypes

module Types (F : TYPE) = struct
  open F

  let futhark_success = constant "FUTHARK_SUCCESS" int
  let futhark_program_error = constant "FUTHARK_PROGRAM_ERROR" int
  let futhark_out_of_memory = constant "FUTHARK_OUT_OF_MEMORY" int
end
