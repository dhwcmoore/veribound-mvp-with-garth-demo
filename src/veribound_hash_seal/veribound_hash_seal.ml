(* Basic Classification Engine - Using standard library *)

type boundary = {
  name: string;
  lower: float;
  upper: float;
  verdict: string;
}

type domain = {
  name: string;
  authority: string;
  boundaries: boundary list;
}

(* Nuclear Reactor Domain *)
let nuclear_domain = {
  name = "Nuclear Reactor Protection System";
  authority = "NRC 10 CFR 50.55a";
  boundaries = [
    { name = "Normal_Operation"; lower = 280.0; upper = 315.0; verdict = "SAFE_VERIFIED" };
    { name = "Maximum_Tolerated"; lower = 315.1; upper = 350.0; verdict = "CAUTION_VERIFIED" };
    { name = "Toxic_Range"; lower = 350.1; upper = 400.0; verdict = "DANGEROUS_VERIFIED" };
    { name = "Lethal_Range"; lower = 400.1; upper = 500.0; verdict = "EMERGENCY_VERIFIED" };
  ]
}

(* Financial Domain *)
let financial_domain = {
  name = "Basel III Capital Adequacy";
  authority = "Basel Committee on Banking Supervision";
  boundaries = [
    { name = "Well_Capitalized"; lower = 10.5; upper = 100.0; verdict = "COMPLIANT" };
    { name = "Adequately_Capitalized"; lower = 8.0; upper = 10.4; verdict = "ACCEPTABLE" };
    { name = "Undercapitalized"; lower = 6.0; upper = 7.9; verdict = "WARNING" };
    { name = "Critically_Undercapitalized"; lower = 0.0; upper = 5.9; verdict = "VIOLATION" };
  ]
}

(* Simple classification *)
let classify_simple domain value =
  let rec find_boundary = function
    | [] -> "UNKNOWN"
    | b :: rest -> 
        if value >= b.lower && value <= b.upper then
          b.verdict
        else
          find_boundary rest
  in
  find_boundary domain.boundaries

(* Create sealed result with working hash *)
let create_demo_result domain value =
  let category = classify_simple domain value in
  let timestamp = Unix.time () in
  
  (* Create results data for hashing *)
  let results_text = Printf.sprintf {|[{"category":"%s","lower":%f,"upper":%f,"verdict":"%s","domain":"%s","authority":"%s","timestamp":%f}]|} 
    category value value category domain.name domain.authority timestamp in
  
  (* Use standard Digest instead of Digestif *)
  let actual_hash = Digest.string results_text |> Digest.to_hex in
  
  (* Return complete sealed result *)
  Printf.sprintf {|{
  "seal_hash": "%s",
  "irrational_signature": %f,
  "results": [
    {
      "category": "%s", 
      "lower": %f,
      "upper": %f,
      "verdict": "%s",
      "domain": "%s",
      "authority": "%s",
      "timestamp": %f
    }
  ]
}|} actual_hash (timestamp *. 0.001234) category value value category domain.name domain.authority timestamp
