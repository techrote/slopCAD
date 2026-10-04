# v11 — tiered-tilt 37-pocket effect-plate stand

A radius-3 expansion of `v10-effect-plate-hex-floor-19`.

## Pocket layout

- **37 pockets** total
- centre: **0°**
- 6-pocket ring 1: **4° outward**
- 12-pocket ring 2: **8° outward**
- 18-pocket ring 3: **12° outward**
- pitch: **9.0 mm**
- functional pocket: **7.0 mm AF**
- overall envelope: approximately **72.84 × 67.77 × 14.0 mm**
- footprint aspect ratio: approximately **1.08:1**

The outer 12° ring moves about **2.55 mm radially outward** over the 12 mm pocket height.

## Carried over from v10

- **2.0 mm structural base**
- **1.0 mm-high / 55° inward tapered hex floor transition**
- smaller hexagonal through-hole through the remaining 1 mm of base
- exact horizontal cross-section handling for tilted pocket floors
- corrected centre-pocket lead-in
- enlarged **1.2 mm / 8.5 mm AF** mouth chamfers
- deliberately misaligned/scalloped chamfers on the tilted rings
- no continuous waist groove
- individual **50° tapered wall inset panels**
- softened lower lip and **0.4 mm lower-edge chamfer**
- intended for normal or top-face-down effect-plate printing

## Wall-panel handling

The larger radius-3 contour resolves into **42 outer-wall facets**, including some
shorter than those on v10. Panel recess depth remains **1.2 mm nominal**. On the
shortest facets, depth is reduced only as much as necessary to retain at least a
**0.5 mm back-flat**, matching the demonstrated minimum printable line width.

## Spacing

At the 12° outer ring, the horizontal projection of the 7 mm shaft still leaves
about **1.84 mm** of floor-level web on the 9 mm lattice. The nominal mouth web
remains **0.5 mm** before outward splay increases the separation.

## Validation

The generated STL is a **single connected watertight volume**.

## Files

- `hex_bit_stand_tiered_tilt_37_v11.scad` — parametric OpenSCAD source
- `hex_bit_stand_tiered_tilt_37_v11.stl` — printable mesh
