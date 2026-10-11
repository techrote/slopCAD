# SweepHex 80 XL — 6 mm vortex fan guard

Unprinted size variant of the physically printed and installed [SweepHex 140 XL](../sweephex-140-xl/), preserving the same flat large-aperture swept-hex design language and anticlockwise vortex direction.

## Files

| File | Purpose |
| --- | --- |
| [3MF](sweephex80_xl_chamfered.3mf) | Slicer-ready mesh, millimetres |
| [STL](sweephex80_xl_chamfered.stl) | Printable watertight mesh |
| [DXF](sweephex80_xl_chamfered.dxf) | Mid-plane and face profiles on named layers |
| [JSON](sweephex80_xl_chamfered.json) | Exact settings, measurements and mesh validation |
| [OpenSCAD wrapper](sweephex80_xl_chamfered.scad) | Imports the committed STL |
| [Shared parametric generator](../sweephex_family_generator.py) | Authoritative source for the 120/92/80/60 mm variants |

## Dimensions

| Parameter | Value |
| --- | ---: |
| Overall size | **80 × 80 × 6 mm** |
| Mounting-hole pitch | **71.5 × 71.5 mm** |
| Through-hole diameter | **Ø4.7 mm** |
| Main swept airflow apertures | **17** |
| Mid-plane projected open fraction | **54.2%** |
| Sweep | **105° anticlockwise** at r = 43.429 mm, +Z view |
| Airflow-aperture chamfer | **1 × 1 mm**, both broad faces |
| Nominal middle web | **3.3 mm** |
| Nominal broad-face airflow web | **1.3 mm** |
| Nominal face ligament at nearest mount/outer edge | **1.30 mm** |

The main aperture radius is deliberately kept at 13.6 mm across the family rather than scaling all holes down. This keeps the compact variants open and visually related to the printed 140 XL instead of turning the smaller guards into dense restrictive meshes.

### Compact-frame bevel accommodation

Airflow apertures retain the full 1 mm × 45° bevel. Standard mounting positions leave much less material between a bolt hole and the outer edge on compact fan frames, so the **outer-face and mounting-hole XY bevel widths are reduced locally by preset** while the bevel height remains 1 mm. This preserves at least about 1.3 mm nominal material at the nearest mount-to-edge section and is no more demanding to print than the 45° airflow bevel.

- outer face bevel width: **0.1 mm**
- mounting-hole bevel width: **0.5 mm**

A full 1 mm outer bevel plus full 1 mm screw-hole bevel is geometrically incompatible with the standard 80 mm mounting pitch and Ø4.7 mm bore because those bevels overlap.

## Printing and qualification

Print either broad face on the bed with supports disabled. Suggested starting point for a 0.6 mm nozzle: 0.20–0.24 mm layers and adaptive 0.60–0.72 mm line widths. The mesh is a single watertight component with consistent winding; generated topology has Euler number **-40**.

**Physical status:** not yet printed or fit-tested. Mounting pitch follows the nominal square-fan standard for this size, but individual fan housings should still be checked before relying on exact screw/head clearance. No airflow or acoustic improvement is claimed.
