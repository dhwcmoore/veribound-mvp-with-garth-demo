#!/bin/bash
echo "🚀 VeriBound Live Demonstration"
echo "=============================="
echo ""
echo "Building system..."
dune build
echo ""
echo "Running demonstration..."
dune exec ./demo_veribound.exe
echo ""
echo "Generated files:"
ls -la demo_*.json results/ 2>/dev/null | head -10
echo ""
echo "VeriBound: Formal verification meets regulatory compliance"
