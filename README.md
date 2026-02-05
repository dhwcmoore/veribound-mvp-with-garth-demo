# VeriBound MVP (OCaml)

## Build

opam install . --deps-only --yes
dune build

## Basel demo (seal + verify)

# show an example input format
dune exec ./bin/veribound.exe -- sample basel > data/basel_input.json

# create a sealed report (writes to results/)
dune exec ./bin/veribound.exe -- seal basel data/basel_input.json

# verify a sealed report
ls -lt results | head -n 5
dune exec ./bin/veribound.exe -- verify results/<sealed_report>.json

## What “verify” means

Verification checks that the SHA256 hash matches the embedded results content.
If results is modified without updating seal_hash, verification fails.
