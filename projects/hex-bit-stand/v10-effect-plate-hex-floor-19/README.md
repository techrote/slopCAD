# v10 — effect-plate tiered-tilt 19-pocket stand, tapered hex floor

A refinement of `v9-effect-plate-19` based on slicer inspection.

## Pocket layout

- **19 pockets** in a radius-2 hexagonal cluster
- centre pocket: **vertical**
- 6-pocket inner ring: **4° radially outward**
- 12-pocket outer ring: **8° radially outward**
- functional pocket: **7.0 mm AF**
- pitch: **9.0 mm**
- overall envelope: approximately **53.37 × 50.79 × 14.0 mm**

The additional 1 mm of height comes from increasing the structural base from
1 mm to **2 mm** while retaining the 12 mm pocket depth.

## Centre-pocket chamfer correction

v9 applied the full 15° rotational mismatch at the bottom of every mouth
chamfer. On the vertical centre pocket that could create an inward lip at the
7 mm transition and potentially catch a bit during insertion.

v10 starts the centre lead-in on the **exact 30° shaft profile**, then twists to
the **45° / 8.5 mm AF mouth** over the 1.2 mm lead-in height. The centre still
has the deliberately misaligned visual treatment, but the entrance cannot
constrict below the 7 mm functional pocket.

The tilted inner/outer rings retain the stronger scalloped/misaligned v9 mouth
geometry that worked well in physical testing.

## Tapered hex floor relief

The v9 circular relief is replaced with the Fusion-style construction proposed
after slicer inspection:

1. Start with a **2.0 mm base**.
2. At the horizontal bottom footprint of each 7 mm pocket, taper the cavity
   downward for **1.0 mm** with a **55° inward draft**.
3. Cut the resulting smaller **hexagonal profile** straight through the
   remaining 1 mm of base.

For the centre pocket, a 55° draft over 1 mm offsets every hex face inward by
about **1.428 mm**, producing a nominal through-hole of about **4.14 mm AF**.

For tilted pockets the floor footprint is not approximated as a regular hex.
The OpenSCAD source analytically derives the **exact horizontal cross-section of
the tilted hex shaft**, offsets that polygon inward by the same 1.428 mm, and
uses the result as the through-hole. This removes the floor ledge while keeping
the requested draft angle on each face.

A 0.03 mm boolean overlap is applied equally to the upper and lower cutter
profiles to avoid coplanar zero-area remnants; it does not change the 55° taper.

## Effect-plate printing

The geometry is intended to support **top-face-down printing** on carbon,
holographic, or other effect plates. In that orientation the pocket floor
narrows progressively into the through-hole rather than terminating in a broad
horizontal bridge.

## Outer-wall styling

Carried over from v9/v7:

- no continuous waist groove
- separate inset panel on each of the **18 convex wall facets**
- **1.0 mm border**
- **1.2 mm recess depth**
- **50° taper**
- softened lower lip and **0.4 mm lower-edge chamfer** retained

## Validation

The generated STL is a **single connected watertight volume**.

## Files

- `hex_bit_stand_effect_plate_19_v10.scad` — parametric OpenSCAD source
- `hex_bit_stand_effect_plate_19_v10.stl` — printable mesh
