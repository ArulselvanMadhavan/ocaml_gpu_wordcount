open Ocaml_gpu_wordcount

let () =
  let i = C.Function.futhark_get_tuning_param_count () in
  let cfg = C.Function.futhark_context_config_new () in
  let ctx = C.Function.futhark_context_new cfg in
  let _arr = C.Function.futhark_new_u8_1d ctx in
  let f c = Char.code c |> Unsigned.UInt8.of_int in
  let char_arr = Array.map f @@ Base.String.to_array "example from futhark\nline2\nline3\n" in
  (* Array.iter (fun c -> Printf.printf "%d|" (Unsigned.UInt8.to_int c)) char_arr;
   * print_endline "done"; *)
  (* Char.code *)
  let data_ptr =
    Ctypes.CArray.start
    @@ Ctypes.CArray.of_list Ctypes.uint8_t
    @@ Array.to_list char_arr
  in
  let arr = C.Function.futhark_new_u8_1d ctx data_ptr (Int64.of_int @@ Array.length char_arr) in
  let chars = Ctypes.allocate Ctypes.int32_t Int32.zero in
  let words = Ctypes.allocate Ctypes.int32_t Int32.zero in
  let lines = Ctypes.allocate Ctypes.int32_t Int32.zero in
  let result = C.Function.futhark_entry_wc ctx chars words lines arr in
  let _ = C.Function.futhark_free_u8_1d ctx arr in
  C.Function.futhark_context_free ctx;
  C.Function.futhark_context_config_free cfg;
  let results = List.map Ctypes.(!@) [chars;words;lines] in
  List.iter (fun i -> Printf.printf "%d\n" @@ Int32.to_int i) results;
  Printf.printf "Futhark param count:%d|%d\n" i result
