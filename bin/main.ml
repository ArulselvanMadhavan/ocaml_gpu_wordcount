open Ocaml_gpu_wordcount

let () =
  let i = C.Function.futhark_get_tuning_param_count () in
  let ctx = C.Function.futhark_context_config_new () in
  C.Function.futhark_context_config_free ctx;
  Printf.printf "Futhark param count:%d\n" i
