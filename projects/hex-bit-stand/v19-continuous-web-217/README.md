# v19 — continuous-web 217-pocket stand

Local-only expansion of the verified v18 169-pocket model. The new eighth ring contains **48 pockets tilted 32° radially outward**. No GitHub calls or publication were made while preparing this version.

## Print files and orientation

**Use `hex_bit_stand_continuous_web_217_v19_face_down.stl` for effect-plate printing.** It is already rotated so the normal pocket-opening face sits on the bed at Z = 0. Do not flip it again. Its maximum envelope is **192.05 × 171.50 × 14.00 mm**, before any slicer skirt or brim; check the available bed area including those additions.

`hex_bit_stand_continuous_web_217_v19.stl` is the identical part in upright/use orientation for inspection. The SCAD defaults to that orientation.

`v19_seventeen_pocket_test_face_down.stl` is the **already face-down** test coupon. It contains all nine tilt bands, a symmetry-equivalent tightest 28°/32° pair, and adjacent three-pocket junctions at the exact production coordinates. Its exterior is simplified and does not validate the complete side-panel treatment. The coupon measures **102.36 × 23.52 × 14.00 mm** and has approximately **21.61 cm³** CAD solid volume.

## Geometry

| Location | Pockets | Outward tilt from vertical |
|---|---:|---:|
| Centre | 1 | 0° |
| Ring 1 | 6 | 4° |
| Ring 2 | 12 | 8° |
| Ring 3 | 18 | 12° |
| Ring 4 | 24 | 16° |
| Ring 5 | 30 | 20° |
| Ring 6 | 36 | 24° |
| Ring 7 | 42 | 28° |
| New ring 8 | 48 | 32° |
| Total | **217** | |

The new outer axes move **7.498 mm radially outward** from their pocket-floor centres to the top over 12 mm of vertical height. All earlier rings retain their tilt angles.

| Feature | v19 |
|---|---|
| Functional hex, measured perpendicular to its axis | **7.0 mm AF** |
| Floor-centre lattice pitch | **10.20 mm** |
| Aligned entrance equivalent profile, before horizontal projection | **8.5 mm AF** |
| Entrance chamfer vertical height | **1.15 mm** |
| Main pocket vertical depth | **12.0 mm** |
| Base zone thickness | **2.0 mm** |
| Floor transition | **1 mm / 55° from vertical**, then smaller hex through-exit |
| Nominal centre exit AF | **4.144 mm** |
| Nominal outer-wall margin | **3.8 mm** |
| Side-panel reference-plane top/side borders | **1.3 mm** |
| Side-panel depth and taper | **1.2 mm / 50°**, open down to the lower lip |
| Bottom-edge chamfer | **0.4 mm** |

The aligned entrance and shaft retain the same phase. The former rotationally misaligned/scalloped chamfers are **not** reintroduced. The shaft roll is lattice-aligned before tilting; a horizontal slice is stretched radially, so 7 mm and 8.5 mm are not horizontal AF dimensions in every direction.

The convex wall, softened lower lip, lip-edge side recesses, base and tapered hex exits are inherited from v18. The only primary parameter changes are ring count, one additional tilt band and pitch. The coupon selection expands from 15 to 17 pockets. Seven geometry-generating modules are byte-for-byte unchanged from the verified v18 source; see `regression_checks.json`.

## Why pitch increased

Adding the 32° ring at the previous **9.90 mm pitch** would leave a narrowest top-face web of only **1.193 mm**. This fails the **1.3 mm minimum actual top/bottom surface-width rule**.

Pitch is increased to **10.20 mm**, giving **1.493 mm** measured web. The entrances are not shrunk. This maintains a useful margin above the minimum instead of barely passing it.

The rule is the actual in-plane material remaining after cuts and tilted projections, not nominal pitch-minus-AF. It is separate from the retained 2 mm base zone and the 1 mm-tall straight exit section.

An independent analytical sweep checked 9.90, 10.00, 10.05, 10.10, 10.15, 10.20 and 10.25 mm pitch. A completely rendered temporary 9.90 mm model was rejected by the same mesh validator with `FAIL: top web < 1.3 mm`. Only its source pitch guard was relaxed; the minimum-width rule stayed enabled. This negative control never replaced the production files.

## Measured geometric validation

Measurements below are from the exported upright STL:

| Check | Result |
|---|---:|
| Minimum top-face inter-pocket web | **1.493 mm** |
| Minimum top opening to outside edge | **1.714 mm** |
| Minimum underside inter-exit web | **4.965 mm** |
| Minimum underside exit to outside edge | **5.551 mm** |
| Additional horizontal sections checked | **83** |
| Minimum exterior-wall clearance across sampled sections | **1.551 mm** |
| Pockets checked for position, direction, tilt and normal-axis AF | **217** |
| Connected watertight positive-volume solids | **1** |
| Through-holes / Euler characteristic | **217 / −432** |
| Maximum tilt measurement error | **0.000259°** |
| Maximum normal-axis AF error | **0.0000859 mm** |
| Face-down vertex difference after rotation and binary export | **0.0000038 mm** |
| Maximum coupon/full-model hole-outline difference over 11 depths | **0.0000625 mm** |

Both exposed surfaces and all 83 sampled sections remain connected after their boundaries are eroded inward by **0.65 mm**, half the minimum web width. Every sampled section passes the inter-opening and exterior-wall clearance checks. These sampled checks are not a formal proof over every possible cross-section.

The steepest measured entrance-chamfer face is **54.35° from vertical** in the face-down print orientation: vertical wall = 0°, unsupported horizontal ceiling = 90°. This remains below the supplied 60° soft limit, so the chamfer height needs no reduction. The measurement covers entrance faces only, not every side-panel or lip surface.

CAD solid volume is **192.06 cm³**. The verified supplied v18 report gives **141.68 cm³**; the difference includes 48 additional pockets, wider spacing and a larger body, and is not a same-capacity efficiency comparison. Filament quantity depends on the slicer settings.

**All listed geometric checks passed. v19 has not been sliced with the owner's printer profile or physically printed here.** Geometry checks do not guarantee seam placement, adhesion, surface finish or continuous extrusion with a particular printer/slicer profile.

## Rebuild and validate

Tested environment: **OpenSCAD version 2021.01**, Python **3.13.5**, NumPy **2.3.5**, Shapely **2.1.2**, Trimesh **4.11.1**, NetworkX **3.6.1**. OpenSCAD is a separate dependency; the Python validator dependencies are pinned in `requirements-validation.txt`.

```sh
python -m pip install -r requirements-validation.txt
python build.py
```

On Windows, supply the console executable when it is not on PATH:

```powershell
python build.py --openscad "C:\Program Files\OpenSCAD\openscad.com"
```

The build helper exports the upright model, derives the face-down rigid transform, exports the coupon, runs the mesh/export validators and refreshes `validation_summary.json` and `SHA256SUMS`. Each subprocess has a timeout. It does not regenerate narrative documentation, baseline provenance, regression records, spacing checks or previews.

Separate checks:

```sh
python validate.py
python validate_exports.py
python check_spacing.py
```

The spacing check uses a temporary directory for its negative control and leaves the production models untouched. Direct OpenSCAD exports:

```sh
openscad -o v19_upright.stl hex_bit_stand_continuous_web_217_v19.scad
openscad -D 'print_face_down=true' -o v19_face_down.stl hex_bit_stand_continuous_web_217_v19.scad
openscad -D 'export_part="coupon"' -D 'print_face_down=true' -o v19_coupon.stl hex_bit_stand_continuous_web_217_v19.scad
```

`render_previews.py` renders the actual upright STL using OpenSCAD. It additionally requires Pillow (tested **12.3.0**) and uses `xvfb-run` on headless Linux when available. It only crops uniform background; no geometry is fabricated for the previews. The perspective, top and underside previews were visually inspected.

## Package and integrity

The package contains both full-model orientations, the coupon, standalone SCAD, build and validation tools, exact-STL previews, full/summary validation records, export and spacing checks, regression/provenance records and later-publication notes.

Before derivation, all **32 entries** in the actual v18 packet's `SHA256SUMS` were verified. Its **9 corresponding mounted attachments** also matched the packet bytes. `evidence/source_changes.patch` records the minimal SCAD changes against that verified baseline.

`SHA256SUMS` covers all supplied files except itself. Rebuilding can change triangle order and file hashes without changing geometry; rerun validators and refresh hashes. A separate sidecar checksum covers the ZIP itself.

Everything is local for later publication. No repository state was read or changed in this revision.