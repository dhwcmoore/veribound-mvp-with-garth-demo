# VeriBound: Responding to Industry Feedback

**A runnable demo addressing concerns about formal verification in software engineering**

---

## Running This Demo in GitHub Codespaces

No local setup required. Everything runs in your browser.

### Step 1: Open a Codespace

1. Click the green **Code** button at the top of this page
2. Select the **Codespaces** tab
3. Click **Create codespace on main**
4. Wait about 60 seconds for the environment to load

### Step 2: Install OCaml and Dependencies

In the Codespace terminal, run:
```bash
sudo apt-get update
sudo apt-get install -y opam
opam init --disable-sandboxing --yes
eval $(opam env)
opam install dune digestif yojson --yes
eval $(opam env)
```

This takes about 2-3 minutes.

### Step 3: Build and Run the Demo
```bash
dune build
dune exec ./test/demo_garth_response.exe
```

---

## What You Will See

The demo addresses six concerns about formal verification, point by point:
```
╔══════════════════════════════════════════════════════════════╗
║  VeriBound: Responding to Industry Feedback                  ║
║  Addressing Each Point from Garth's Email                    ║
╚══════════════════════════════════════════════════════════════╝
```

### Point 1: Pure Code Isolation

**Concern:** "Most programming languages have no way of isolating side-effect free pure code that could be proven."

**What the demo shows:**
```
  classify_value 7.5 in [6.0, 8.0]:
    Call 1: Adequate
    Call 2: Adequate
    Identical: true (referential transparency)

  compute_seal_hash:
    Call 1: 69cfefde2461876ac4bc...
    Call 2: 69cfefde2461876ac4bc...
    Identical: true (deterministic)
```

**Explanation:** OCaml's type system enforces purity. A function with signature `float -> string option` cannot perform IO, network calls, or mutation. The compiler rejects code that tries. The demo proves this by calling the same functions twice and showing identical results. This is referential transparency: pure functions always return the same output for the same input.

---

### Point 2: Cost of Mathematical Proofs

**Concern:** "It's expensive / time-consuming to do mathematical proofs."

**What the demo shows:**
```
  Basel III Capital Adequacy boundaries:
    1. Mutual Exclusion (no overlaps):    ✓ VERIFIED
    2. Complete Coverage (no gaps):       ✓ VERIFIED
    3. Classification Soundness (unique): ✓ VERIFIED

  Verification time: 0.000004000 seconds
```

**Explanation:** The cited blog discusses proving arbitrary program behavior, which is indeed impractical. VeriBound proves something far more specific: three properties of boundary configurations. These have algebraic structure that makes proofs tractable.

Analogy: Proving all possible chess games is intractable. Proving that bishops always stay on their starting color is trivial. VeriBound proves "bishop-level" properties.

---

### Point 3: Target Domains

**Concern:** "There may be some domains where it might be worth it (nuclear power, cars, satellites)."

**What the demo shows:**
```
  FINANCIAL (Basel III, CCAR, FRTB, MiFID2, AML, LCR/NSFR)
    Market: Global banks spend ~$270B/year on compliance
    Pain: Classification errors trigger regulatory action

  MEDICAL (blood pressure, diabetes, clinical trials, pharma dosing)
    Market: FDA 510(k) submissions require validated boundaries
    Pain: Wrong classification = patient harm, lawsuits, recalls

  NUCLEAR (reactor protection, radiation limits, emergency levels)
    Market: NRC requires formal verification for safety systems
    Pain: Boundary errors can cause reactor incidents
```

**Explanation:** Exactly right. Those ARE the target domains. These "niche" markets have mandatory compliance requirements and catastrophic failure costs. Combined market exceeds $50B annually.

---

### Point 4: OCaml is a Niche Language

**Concern:** "OCaml is a niche of a niche... close to 0% adoption."

**What the demo shows:**
```
  Jane Street Capital
    - $500B+ assets under management
    - Entire trading infrastructure in OCaml
    - Reason: Trading bugs cost millions per second

  Coq/Rocq Proof Assistant (written in OCaml)
    - CompCert: verified C compiler (Airbus uses it)
    - seL4: verified operating system kernel
```

**Explanation:** OCaml is niche precisely because it's used where correctness is non-negotiable and bugs cost millions. The Coq proof assistant extracts verified code to OCaml. This is why VeriBound uses it. The concepts port to any language; OCaml is the reference implementation.

---

### Point 5: Complement Testing, Don't Replace It

**Concern:** "'The next generation will be proven, not tested' is hard to agree with."

**What the demo shows:**
```
  TESTING EXCELS AT:
    - Catching business logic bugs
    - Integration verification
    - Regression detection

  TESTING CANNOT:
    - Guarantee mathematical correctness of boundaries
    - Prove no gaps exist in classification ranges
    - Handle IEEE 754 floating-point edge cases exhaustively
```

**Explanation:** Fair criticism. The marketing was too aggressive. VeriBound complements testing. Tests catch business logic bugs. VeriBound certifies boundaries are mathematically sound. Together: correctness AND compliance.

The IEEE 754 example: Testing Basel III's 4.5% threshold with 4.4%, 4.5%, 4.6% misses edge cases like 4.499999999999999%. Exhaustive testing needs 10^15 test cases. One proof covers all of them.

---

### Point 6: Microsecond Performance

**Concern:** "Microseconds are very short and very few useful, complicated things run in microseconds."

**What the demo shows:**
```
  Measured performance (10,000 iterations each):

  Boundary classification            0.04 µs
  SHA256 seal computation            0.85 µs
  Seal verification                  0.83 µs
```

**Explanation:** VeriBound does one focused thing: classify a value against a small set of boundaries. That SHOULD be fast.

Why it matters: A bank processing 10M transactions/day at 1µs/check = 10 seconds total. At 1ms/check = 2.8 hours. VeriBound enables inline compliance checking, not batch processing after the fact.

---

### Live Demo: Tamper Detection

**What the demo shows:**
```
  Original report: {"status":"PASS","cet1_ratio":0.075}
  Seal hash:       076e0135ba7647b4c800...

  Verify original: ✓ VALID
  Verify tampered: ✗ TAMPERED
```

**Explanation:** VeriBound seals compliance reports with cryptographic hashes. Any modification is detectable. Auditors can independently verify that sealed reports haven't been modified.

---

## Additional Commands to Try

After running the main demo, you can explore the CLI tool:
```bash
# Show example Basel III input format
dune exec ./bin/veribound.exe -- sample basel

# Create input file and seal it
dune exec ./bin/veribound.exe -- sample basel > /tmp/basel_input.json
dune exec ./bin/veribound.exe -- seal basel /tmp/basel_input.json

# List the sealed report that was created
ls results/

# Verify it (replace TIMESTAMP with actual filename from ls output)
dune exec ./bin/veribound.exe -- verify results/basel_report_sealed_TIMESTAMP.json

# Create a tampered copy
dune exec ./bin/veribound.exe -- tamper results/basel_report_sealed_TIMESTAMP.json

# Watch verification fail on the tampered copy
dune exec ./bin/veribound.exe -- verify results/basel_report_sealed_TIMESTAMP_TAMPERED.json
```

---

## Repository Structure
```
veribound-mvp-with-garth-demo/
├── domains/           # YAML boundary definitions
│   ├── basel_iii_capital_adequacy.yaml
│   ├── blood_pressure.yaml
│   ├── nuclear_reactor_protection.yaml
│   └── ... (20+ regulatory domains)
├── src/               # Core verification engine
├── test/
│   └── demo_garth_response.ml   # The main demo
├── bin/               # CLI tool
└── docs/              # Additional documentation
```

---

## The Value Proposition

**VeriBound delivers compliance you can prove to auditors.**

1. Define regulatory boundaries in YAML (directly from regulations)
2. VeriBound verifies: no overlaps, no gaps, unique classification
3. Classify values against proven boundaries in microseconds
4. Seal results cryptographically for audit trail

This is not "prove any arbitrary program correct."  
This is "prove your compliance boundaries are mathematically sound."

---

## Contact

Duston Moore, PhD  
Independent Researcher  
Edmonton, Alberta

I welcome the opportunity to demonstrate VeriBound in person.
