open Yojson.Basic.Util

let verify_seal_from_file filename =
  try
    if String.length filename = 0 then
      (false, "❌ Empty filename provided")
    else if not (Sys.file_exists filename) then
      (false, Printf.sprintf "❌ File not found: %s" filename)
    else
      let json = Yojson.Basic.from_file filename in
      
      let extract_string_field field_name =
        match json |> member field_name with
        | `String s -> s
        | `Null -> failwith (Printf.sprintf "Missing required field: %s" field_name)
        | _ -> failwith (Printf.sprintf "Field '%s' is not a string" field_name)
      in
      
      let extract_float_field field_name =
        match json |> member field_name with
        | `Float f -> f
        | `Int i -> float_of_int i
        | `Null -> failwith (Printf.sprintf "Missing required field: %s" field_name)
        | _ -> failwith (Printf.sprintf "Field '%s' is not a number" field_name)
      in
      
      let extract_json_field field_name =
        let field = json |> member field_name in
        if field = `Null then failwith (Printf.sprintf "Missing required field: %s" field_name)
        else field
      in
      
      let embedded_hash = extract_string_field "seal_hash" in
      let irrational_signature = extract_float_field "irrational_signature" in
      let results_json = extract_json_field "results" in
      
      if String.length embedded_hash <> 64 then  (* MD5 is 32 chars, not 64 *)
        (false, "❌ Invalid hash format: expected 64-character SHA256 hex")
      else
        (* Use standard Digest *)
        let results_text = Yojson.Basic.to_string results_json in
        let computed_hash = Digestif.SHA256.digest_string results_text |> Digestif.SHA256.to_hex in
        
        if embedded_hash = computed_hash then
          (true, Printf.sprintf "✅ Verification successful\nFile: %s\nHash: %s\nSignature: %.16f"
            filename embedded_hash irrational_signature)
        else
          (false, Printf.sprintf "❌ Hash mismatch - content has been tampered with\nFile: %s\nExpected: %s\nComputed: %s\nSignature: %.16f"
            filename embedded_hash computed_hash irrational_signature)
  
  with
  | Sys_error msg ->
      (false, Printf.sprintf "❌ System error: %s" msg)
  | Yojson.Json_error msg ->
      (false, Printf.sprintf "❌ JSON parsing error: %s" msg)
  | Failure msg ->
      (false, Printf.sprintf "❌ %s" msg)
  | exn ->
      (false, Printf.sprintf "❌ Unexpected error: %s" (Printexc.to_string exn))
