let run_one label path =
  let (ok, msg) = Verifier.verify_seal_from_file path in
  Printf.printf "\n=== %s ===\n%s\n" label msg;
  ok

let () =
  let valid = "data/test_sealed_valid.json" in
  let tampered = "data/test_sealed_valid_TAMPERED.json" in

  let ok_valid = run_one "UNTAMPERED (expected PASS)" valid in
  let ok_tampered = run_one "TAMPERED (expected FAIL)" tampered in

  if ok_valid && (not ok_tampered) then (
    print_endline "\n✅ MVP demo: PASS (untampered verified, tampered detected)";
    exit 0
  ) else (
    print_endline "\n❌ MVP demo: FAIL (unexpected verification behaviour)";
    Printf.printf "valid_ok=%b tampered_ok=%b\n" ok_valid ok_tampered;
    exit 2
  )
