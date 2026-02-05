let debug_domain domain_file =
  match Basic_float.Yaml_parser.load_domain_from_file domain_file with
  | Error e -> Printf.printf "Error: %s\n" (match e with ConfigError msg -> msg | ParseError msg -> msg | _ -> "Unknown")
  | Ok domain ->
      Printf.printf "Domain: %s\n" domain.name;
      Printf.printf "Boundaries:\n";
      List.iteri (fun i b ->
        Printf.printf "  %d: %.6f to %.6f -> %s\n" i b.Basic_float.Types.lower b.upper b.category
      ) domain.boundaries;
      Printf.printf "Testing value 0.04:\n";
      List.iteri (fun i b ->
        let matches = 0.04 >= b.lower && 0.04 <= b.upper in
        Printf.printf "  Boundary %d: 0.04 >= %.6f && 0.04 <= %.6f = %b\n" i b.lower b.upper matches
      ) domain.boundaries

let () = debug_domain "domains/basel_iii_capital_adequacy.yaml"
