open Ctypes
module Types = Types_generated

module Functions (F : FOREIGN) = struct
  open F

  let futhark_get_tuning_param_count =
    foreign "futhark_get_tuning_param_count" (void @-> returning int)
end
