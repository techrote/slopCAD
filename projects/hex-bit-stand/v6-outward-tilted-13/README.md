# v6 — outward-tilted dense 13-pocket stand

A splayed-pocket derivative of `v5-dense-contoured-13`.

## Geometry

- Capacity: **13 bits**
- Centre pocket: **vertical**
- Outer ring: **12 pockets tilted 10° radially outward**
- Functional pocket size: **7.0 mm flat-to-flat**
- Pocket depth/floor relationship: **12 mm / 1 mm**
- Mouth lead-in: **0.6 mm high**, opening to **8.2 mm AF**
- Original dense lattice pitch at the pocket floor: **8.8 mm**
- Outer-mouth radial displacement at the top: **2.116 mm**
- Overall envelope: approximately **53.0 × 34.75 × 13.0 mm**

The bottom centres of the twelve tilted pockets remain on the original v5 lattice.
The pocket axes then diverge outward with height. This is deliberate: tilting around
the top-mouth centres would make the dense pockets converge beneath the surface
and intersect one another.

The contoured body follows the splayed pocket positions through height, reducing
unnecessary material while retaining the faceted wall treatment.

## Lower lip

This version inherits the current softened lower-lip treatment:

- **2.1 mm** full-height flared lip
- **0.4 × 0.4 mm 45°** bottom-edge chamfer
- **0.9 mm** return-to-main-wall blend

## Printing

Designed around a **0.6 mm nozzle** and intended to print without supports.

The 10° internal pocket walls are shallow relative to vertical and should not
require support. Near the 1 mm floor, the tilted 7 mm shafts project to roughly
7.11 mm in a horizontal slice, leaving about **1.69 mm** minimum web on the
original 8.8 mm lattice.

A variable-width/Arachne-style perimeter generator remains preferable.

## Files

- `hex_bit_stand_outward_tilted_13_v6.scad` — parametric source
- `hex_bit_stand_outward_tilted_13_v6.stl` — printable mesh
