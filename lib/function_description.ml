open Ctypes
module Types = Types_generated

module Functions (F : FOREIGN) = struct
  open F

  let futhark_get_tuning_param_count =
    foreign "futhark_get_tuning_param_count" (void @-> returning int)

  let futhark_context_config_new = foreign "futhark_context_config_new" (void @-> returning Types.Futhark_context_config.t)

  let futhark_context_config_free = foreign "futhark_context_config_free" (Types.Futhark_context_config.t @-> returning void)
end
