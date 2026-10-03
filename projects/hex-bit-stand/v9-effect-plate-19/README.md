# v9 — effect-plate tiered-tilt 19-pocket stand

A print-orientation/material-style derivative of `v8-tiered-tilt-19`.

## Pocket layout

- **19 pockets** in a radius-2 hexagonal cluster
- centre pocket: **vertical**
- 6-pocket inner ring: **4° radially outward**
- 12-pocket outer ring: **8° radially outward**
- functional pocket: **7.0 mm AF**
- pitch: **9.0 mm**
- overall envelope: approximately **53.37 × 50.79 × 13.0 mm**

## Deliberately misaligned mouth chamfers

v8's accidental scalloped mouth treatment is made explicit here.

- shaft hex orientation: **30°**
- mouth/chamfer hex orientation: **45°**
- deliberate equivalent rotational mismatch: **15° on every pocket**
- mouth lead-in: **1.2 mm high / 8.5 mm AF**

Using a fixed 15° offset means the centre pocket and the outer-ring edge-midpoint
pockets now show the same family of scalloped/misaligned transition as the
pockets that already exhibited it strongly in v8.

## Effect-plate / upside-down printing

Every pocket gets a **5.0 mm circular through-hole** in the 1 mm base.

The hole is not terminated by a flat annular shelf. Instead it transitions over
**1.0 mm** from 5.0 mm diameter to a 7.0 mm circular opening centred on the
pocket axis. At the hex flats that is approximately a **45° transition**.

This is intended to make top-face-down printing practical:

1. Rotate the model 180° so the normal pocket-opening/top surface sits on the build plate.
2. Use a textured/effect build plate for the exposed top surface.
3. The pocket cavities narrow into the 5 mm relief holes instead of closing with a broad bridge.

A 7 mm circle is inscribed within the 7 mm AF hex, so only roughly **0.54 mm**
corner slivers remain at the top of the floor transition. This is intentionally
compatible with the demonstrated ~0.5 mm line capability of the target printer.

The 5 mm bore leaves **1.0 mm support at the middle of each 7 mm hex flat**, so
1/4-inch bits remain captured and seat on the tapered transition rather than
falling through.

## Outer-wall styling

The continuous v8 waist groove is removed. In its place, the **18 actual convex
main-wall facets** each receive a separate v7-style inset panel:

- **1.0 mm border** from the facet edges
- **1.2 mm recess depth**
- **50° taper**

This matches the v7 panel depth. On the compact 19-pocket body the shortest actual convex
wall face still retains about **3.5 mm** of back-flat width, while leaving roughly
**1.8 mm** of nominal wall behind the recess.

The softened lower lip and 0.4 mm lower-edge chamfer are retained.

## Validation

The generated STL is a **single connected watertight volume**.

## Files

- `hex_bit_stand_effect_plate_19_v9.scad` — parametric OpenSCAD source
- `hex_bit_stand_effect_plate_19_v9.stl` — printable mesh
