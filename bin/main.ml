open Ocaml_gpu_wordcount

let () =
  let i = C.Function.futhark_get_tuning_param_count () in
  Printf.printf "Futhark param count:%d\n" i
