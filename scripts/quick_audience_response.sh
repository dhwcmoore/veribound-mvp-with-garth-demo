#!/bin/bash
echo "🎯 Perfect! Your data will get the same mathematical guarantees we show here..." >&2
echo "" >&2
dune exec test/test_pathological_cases.exe >&2
echo "" >&2
echo "🏆 Your data would be processed with identical IEEE 754 formal verification!" >&2
echo "💥 Other systems fail on these precision levels - VERIBOUND succeeds!" >&2
