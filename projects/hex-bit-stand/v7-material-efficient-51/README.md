# v7 — material-efficient dense 51-pocket stand

A material-reduction derivative of `v4-dense-51`.

## Changes from v4

- **5.6 mm circular through-hole** through the 1 mm floor beneath every bit pocket.
- The old continuous recessed waist/indent around the outside is removed.
- Each of the **16 actual planar outer-wall faces** gets its own recessed panel.
- Each panel starts **1.0 mm from every face edge**.
- Panel recess depth: **1.2 mm**.
- Panel side taper: **50°**, narrowing into the wall.
- The softened lower lip and 0.4 mm lower-edge chamfer are retained.

## Core geometry

- Capacity: **51 bits**
- Layout: **6–7–8–9–8–7–6**
- Functional pocket: **7.0 mm AF**
- Pocket depth: **12.0 mm**
- Base thickness: **1.0 mm**
- Pocket pitch: **8.8 mm**
- Overall envelope: approximately **84.6 × 62.12 × 13.0 mm**

The 5.6 mm floor hole leaves **0.7 mm of support at the middle of each hex flat**,
so a nominal 1/4-inch bit cannot simply fall through the floor opening.

## Why the panel depth is 1.2 mm

The vertical v4 wall resolves into 16 planar faces. With a 1 mm border, the
shortest face still leaves enough room for a 50° tapered recess at 1.2 mm depth.
At the portions nearest the straight 7 mm pockets, this retains about **1.8 mm**
of wall — three 0.6 mm extrusion widths.

## Material comparison

CAD solid volume is approximately:

- current v4 baseline: **28.69 cm³**
- this v7 variant: **26.13 cm³**

That is about **8.9% less solid-model volume** despite removing the
old waist groove. Actual filament savings depend on slicer perimeter/infill
settings.

## Printing

Designed for a **0.6 mm nozzle** and intended to remain support-free.

The floor-relief holes start at the build plate, so they require no bridging.
The 50° recessed-panel transitions are intended to remain printable in the
normal base-down orientation.

## Files

- `hex_bit_stand_material_efficient_51_v7.scad` — parametric source
- `hex_bit_stand_material_efficient_51_v7.stl` — printable mesh
