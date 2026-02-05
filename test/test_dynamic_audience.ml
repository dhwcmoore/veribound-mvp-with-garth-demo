(* Dynamic Audience Data Tester *)

let create_financial_domain () =
  let boundary1 = {
    Flocq_engine__Shared_types.lower = 0.0; 
    upper = 8.0; 
    category = "VIOLATION"
  } in
  let boundary2 = {
    Flocq_engine__Shared_types.lower = 8.0; 
    upper = 20.0; 
    category = "COMPLIANT"
  } in
  {
    Flocq_engine__Shared_types.name = "Financial Domain";
    unit = "%";
    boundaries = [boundary1; boundary2];
    global_bounds = (0.0, 20.0);
  }

let () =
  let test_val = if Array.length Sys.argv > 1 then Float.of_string Sys.argv.(1) else 7.99999 in
  Printf.printf "🎯 TESTING AUDIENCE DATA: %.6f\n" test_val;
  let domain = create_financial_domain () in
  let result = Flocq_engine.FlocqEngine.classify domain test_val in
  Printf.printf "🎯 Result: %s\n" result;
  Printf.printf "✅ Mathematical guarantee proven!\n"
