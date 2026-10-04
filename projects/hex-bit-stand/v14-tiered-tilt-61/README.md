# v14 — tiered-tilt 61-pocket stand

A radius-4 expansion of `v13-lip-edge-panels-37`.

## Pocket layout

The stand contains **61 pockets** in five tilt bands:

- centre: **0°**
- ring 1 — 6 pockets: **4° outward**
- ring 2 — 12 pockets: **8° outward**
- ring 3 — 18 pockets: **12° outward**
- new ring 4 — 24 pockets: **16° outward**

The new outer ring moves about **3.44 mm radially outward** over the 12 mm pocket depth.
The 9 mm lattice still leaves approximately **1.72 mm of floor-level web** at the
16° ring after accounting for the tilted 7 mm shaft projection.

## Mouth chamfers

The deliberately irregular/misaligned chamfer treatment is retained and pushed a
little further:

- functional shaft hex orientation: **30°**
- global mouth/chamfer hex orientation: **0°**
- the centre pocket therefore has an exact **30° shaft/mouth phase offset**, putting
  the chamfer points on the shaft-flat midlines;
- tilted pockets inherit varying apparent offsets as their shaft frames rotate
  radially around the stand.

The mouth remains **8.5 mm AF**. Chamfer height is fixed at **1.15 mm** rather than
1.2 mm. On the 16° outer ring this limits the steepest radial side of the bed-facing
chamfer to about **69.9° from the build plane**, staying within the agreed ~70°
experimental ceiling while keeping the chamfer visually substantial.

## Effect-plate floor geometry

Carried over unchanged from v10–v13:

- **2.0 mm base**
- pocket bottom tapers inward for **1.0 mm at 55°**
- resulting smaller hex continues through the remaining 1 mm of base
- tilted pockets use the exact horizontal cross-section of their tilted shafts
- suitable for top-face-down printing on carbon/holographic/effect plates

## Outer wall

The v13 clean-wall/open-bottom panel treatment is retained:

- convex outer shell
- **3.6 mm nominal wall margin**
- **30 clean outer-wall faces**
- **1.0 mm side/top panel border**
- **1.2 mm recess depth**
- **50° side/top taper**
- recesses extend directly to the upper edge of the lower lip

The shortest wall face is about **6.77 mm**, still leaving about **1.91 mm of
back-flat** behind a full-depth panel, so no adaptive triangle/gusset geometry is
required.

## Envelope

Approximately **93.55 × 85.22 × 14.0 mm**.

## Validation

The generated STL is a **single connected watertight volume**.

## Files

- `hex_bit_stand_tiered_tilt_61_v14.scad` — parametric OpenSCAD source
- `hex_bit_stand_tiered_tilt_61_v14.stl` — printable mesh
