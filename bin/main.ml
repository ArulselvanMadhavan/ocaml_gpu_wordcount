open Ocaml_gpu_wordcount

let load_file filename =
  let fd = Unix.openfile filename [Unix.O_RDONLY] 0o666 in
  let genarray = Unix.map_file fd ~pos:0L Bigarray.int8_unsigned Bigarray.c_layout false [|-1|] in
  let u8_array1 = Bigarray.array1_of_genarray genarray in
  let result = Ctypes.bigarray_start Ctypes_static.Array1 u8_array1 in
  let u8ptr = Ctypes.coerce (Ctypes.ptr Ctypes.int) (Ctypes.ptr Ctypes.uint8_t) result in  
  Bigarray.Array1.dim u8_array1, u8ptr
    
let () =
  let device_name = Option.fold ~none:"Apple M1" ~some:Fun.id @@ Sys.getenv_opt "OPENCL_DEVICE" in
  Printf.printf "%s\n" device_name;
      (* futhark_context_config_set_device(cfg, getenv("OPENCL_DEVICE")); *)
  let cfg = C.Function.futhark_context_config_new () in
  C.Function.futhark_context_config_set_device cfg device_name;
  let ctx = C.Function.futhark_context_new cfg in
  let _arr = C.Function.futhark_new_u8_1d ctx in
  let size, data_ptr = load_file "huge.txt" in
  let arr =
    C.Function.futhark_new_u8_1d ctx data_ptr
      (Int64.of_int size)
  in
  let chars = Ctypes.allocate Ctypes.int32_t Int32.zero in
  let words = Ctypes.allocate Ctypes.int32_t Int32.zero in
  let lines = Ctypes.allocate Ctypes.int32_t Int32.zero in
  let start = Unix.gettimeofday () in
  let result = C.Function.futhark_entry_wc ctx chars words lines arr in
  let stop = Unix.gettimeofday () in
  Printf.printf "Execution time: %fs\n%!" (stop -. start);
  let _ = C.Function.futhark_free_u8_1d ctx arr in
  C.Function.futhark_context_free ctx;
  C.Function.futhark_context_config_free cfg;
  let results = List.map Ctypes.( !@ ) [ chars; words; lines ] in
  List.iter (fun i -> Printf.printf "%d\n" @@ Int32.to_int i) results;
  Printf.printf "Futhark param count:%d\n" result
