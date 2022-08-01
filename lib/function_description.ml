open Ctypes
module Types = Types_generated

module Functions (F : FOREIGN) = struct
  open F

  let futhark_get_tuning_param_count =
    foreign "futhark_get_tuning_param_count" (void @-> returning int)

  let futhark_context_config_new =
    foreign "futhark_context_config_new"
      (void @-> returning Types.Futhark_context_config.t)

  let futhark_context_config_free =
    foreign "futhark_context_config_free"
      (Types.Futhark_context_config.t @-> returning void)

  let futhark_context_new =
    foreign "futhark_context_new"
      (Types.Futhark_context_config.t @-> returning Types.Futhark_context.t)

  let futhark_context_free =
    foreign "futhark_context_free" (Types.Futhark_context.t @-> returning void)

  let futhark_new_u8_1d =
    foreign "futhark_new_u8_1d"
      (Types.Futhark_context.t @-> ptr uint8_t @-> int64_t
      @-> returning Types.Futhark_u8_1d.t)

  let futhark_entry_wc =
    foreign "futhark_entry_wc"
      (Types.Futhark_context.t @-> ptr int32_t @-> ptr int32_t @-> ptr int32_t
     @-> Types.Futhark_u8_1d.t @-> returning int)

  let futhark_free_u8_1d =
    foreign "futhark_free_u8_1d"
      (Types.Futhark_context.t @-> Types.Futhark_u8_1d.t @-> returning int)
end
