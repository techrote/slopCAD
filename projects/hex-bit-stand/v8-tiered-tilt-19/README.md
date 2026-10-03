# v8 — tiered-tilt 19-pocket stand

A larger, squarer derivative of the successful outward-tilted 13-pocket design.

## Layout

This version uses a true radius-2 hexagonal lattice:

- **1 centre pocket** — vertical
- **6 inner-ring pockets** — **4° radially outward**
- **12 outer-ring pockets** — **8° radially outward**
- **19 pockets total**

The resulting footprint is approximately **53.37 × 50.79 × 13.0 mm**, for an XY aspect ratio of about **1.05:1**.

## Pocket geometry

- Functional pocket: **7.0 mm flat-to-flat**
- Pocket depth: **12.0 mm**
- Base thickness: **1.0 mm**
- Centre pitch: **9.0 mm**
- Enlarged mouth chamfer: **1.2 mm high**, opening to **8.5 mm AF**
- Nominal top web before splay: **0.5 mm**
- Straight-section web: **2.0 mm**

The mouth chamfers are deliberately **not rotationally aligned with the tilted shafts**. The tilted shaft hexes rotate into their radial local frames while the horizontal mouth chamfers retain the common global orientation. This preserves the asymmetric/scalloped visual effect discovered on v6 rather than correcting it away.

## Splay

Across the 12 mm height from the pocket floor to the top:

- inner ring shifts outward approximately **0.84 mm**
- outer ring shifts outward approximately **1.69 mm**

The centre pocket remains vertical.

## Outer body

The body follows the splayed pocket positions through height and retains the established styling:

- softened lower lip
- **0.4 mm** lower-edge chamfer
- recessed faceted waist band
- contoured upper wall and top chamfer

## Validation

The generated STL is a **single connected watertight volume**.

## Files

- `hex_bit_stand_tiered_tilt_19_v8.scad` — parametric source
- `hex_bit_stand_tiered_tilt_19_v8.stl` — printable mesh
