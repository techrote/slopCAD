# v13 — lip-edge panel 37-pocket stand

A small side-wall refinement of `v12-clean-wall-37` based on physical-print feedback.

## Change from v12

The 24 recessed outer-wall pockets now extend directly down to the **upper edge of the flared lower lip**.

Previously each recess retained a 1 mm lower border, which left the inset visually floating above the lip. v13 removes that bottom border and the corresponding bottom taper:

- panel opening begins at the lip edge (`z = 2.10 mm`), with a 0.05 mm boolean overlap to prevent a residual shelf;
- **1.0 mm side borders** retained;
- **1.0 mm top border** retained;
- **1.2 mm recess depth** retained;
- **50° side and top taper** retained;
- bottom of the recess is open to the lip edge rather than tapering upward.

This should make each wall cut read as a single pocket rising directly out of the lower lip and eliminate the flat strip underneath the recesses.

## Retained geometry

- **37 pockets**: centre + 6 + 12 + 18
- tilt bands: **0° / 4° / 8° / 12°**
- **7.0 mm AF** functional pockets
- **9.0 mm** pitch
- **1.2 mm / 8.5 mm AF** misaligned mouth chamfers
- **2.0 mm base**
- **1 mm-high / 55°** tapered hex floor reliefs
- corrected centre lead-in
- effect-plate / top-face-down print compatibility
- convex **24-face** clean outer shell
- **3.6 mm** nominal wall margin
- softened lower lip and **0.4 mm** bottom-edge chamfer

## Envelope

Approximately **74.04 × 68.04 × 14.0 mm**.

## Validation

The generated STL is a **single connected watertight volume**.

## Files

- `hex_bit_stand_tiered_tilt_37_v13.scad` — parametric source
- `hex_bit_stand_tiered_tilt_37_v13.stl` — printable mesh
