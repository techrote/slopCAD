# v17 — continuous-web 127-pocket stand

Local-only expansion of the actual v16 91-pocket model. The new sixth ring contains **36 pockets tilted 24° radially outward**. No GitHub calls or publication were made while preparing this version.

## Download / print orientation

**Use `hex_bit_stand_continuous_web_127_v17_face_down.stl` for effect-plate printing.** It is already rotated with the normal pocket-opening face on the bed at Z = 0. Do not flip it again. Its maximum envelope is **140.98 × 126.78 × 14.00 mm**, before any slicer brim or skirt.

`hex_bit_stand_continuous_web_127_v17.stl` is the identical part in its upright/use orientation for inspection. The SCAD defaults to that upright orientation.

`v17_thirteen_pocket_test_face_down.stl` is a smaller, **already face-down** test section. It contains all seven tilt bands, the narrowest 20°/24° pair, and adjacent three-pocket junctions at the exact production coordinates. The exterior is simplified; this coupon does not validate the complete side-wall panel treatment. Its envelope is **76.14 × 23.03 × 14.00 mm**.

## Layout and dimensions

| Band | Pocket count | Outward tilt |
|---|---:|---:|
| Centre | 1 | 0° |
| Ring 1 | 6 | 4° |
| Ring 2 | 12 | 8° |
| Ring 3 | 18 | 12° |
| Ring 4 | 24 | 16° |
| Ring 5 | 30 | 20° |
| New ring 6 | 36 | 24° |
| Total | 127 | |

| Feature | v17 |
|---|---|
| Floor-centre pitch | **9.65 mm**, increased from 9.45 mm |
| Functional shaft fit | **7.0 mm AF normal to the tilted axis** |
| Aligned mouth profile | **8.5 mm AF before horizontal-plane projection** |
| Mouth chamfer vertical height | **1.15 mm**, unchanged |
| Main pocket vertical depth | **12.0 mm**, unchanged |
| Structural base zone | **2.0 mm**, unchanged |
| Floor transition | **1 mm downward / 55° from vertical**, then a hex through-exit |
| Nominal centre exit size | **4.144 mm AF** |
| New outer axis displacement | **5.343 mm outward** over the 12 mm vertical pocket height |
| Outer-wall margin | **3.8 mm**, unchanged |
| Side-panel top/side reference-plane border | **1.3 mm**, unchanged |
| Side panels | **1.2 mm recess / 50° side and top taper**, open to the lower lip |
| Lower lip | Previous softened lip and **0.4 mm lower-edge chamfer** retained |

The main pockets still use the v15/v16 lattice-aligned roll and minimal rotation from vertical. There is **no deliberately misaligned entrance**. Pocket and mouth outlines remain aligned with one another, including on the new ring. Because a tilted prism intersects a horizontal plane obliquely, its on-bed hex is slightly elongated; the normal-axis bit fit is not enlarged to produce clearance.

## Why the spacing changes

With six rings at the old **9.45 mm pitch**, the exported negative-control mesh has only **1.250 mm** at its narrowest top-face junction. The 1.3 mm validator rejects that mesh. Merely adding a new ring at the old pitch would therefore repeat the under-width problem.

A 9.55 mm pitch would clear 1.3 mm only narrowly (about 1.350 mm analytically). The selected **9.65 mm** pitch instead produces an exported gap of **1.450 mm**, retaining a margin comparable to v15/v16 rather than targeting the exact threshold. Existing pocket angles remain unchanged; their floor centres move slightly because the pitch increases uniformly.

The surface rule remains **at least 1.3 mm of actual in-plane solid material between openings and at the outside rim**, after projections, offsets and Boolean operations. Nominal pitch minus AF is not an adequate substitute for measuring the model. This rule does not forbid a chamfer from terminating in an edge; it applies to finite material webs and rims, not the mathematical edge of a taper.

## Exported geometry checks

Results below are measured on the supplied **upright STL**. The binary face-down export is separately checked against every vertex of the rigidly rotated upright mesh.

| Check | Result |
|---|---:|
| Minimum top-face inter-pocket web | **1.450 mm** |
| Minimum top-face opening-to-exterior material | **2.131 mm** |
| Minimum underside inter-exit web | **4.950 mm** |
| Minimum underside exit-to-exterior material | **5.847 mm** |
| Additional horizontal sections checked | **83** |
| Pockets independently checked for position, outward direction, tilt and normal-axis AF | **127** |
| Connected watertight positive-volume solids | **1** |
| Through-holes | **127**, Euler characteristic **−252** |
| Maximum face-down vertex difference after rotation / float32 export | **0.0000036 mm** |
| Maximum coupon/full-model hole-outline difference across 11 depths | **0.0000594 mm** |

Both exposed surfaces and all 83 sampled sections remain connected after their boundaries are eroded by **0.65 mm** (half the minimum width). Every sampled section also clears the inter-opening and exterior-wall width checks. This is a set of measured section checks, not a formal proof over every possible cross-section.

The aligned entrance bevels were also measured directly: their steepest face-down overhang is approximately **49.22° from vertical** (vertical wall = 0°, horizontal unsupported ceiling = 90°). The existing 1.15 mm chamfer height therefore does not need reducing for the 24° ring. This measurement concerns the pocket entrances, not every external lip or side-panel surface.

The CAD solid volume is **102.83 cm³**. Actual filament quantity depends on slicing. The supplied v16 record reports 72.91 cm³; this increase mostly reflects the additional 36 pockets and larger stand, and is not a comparison of material efficiency per pocket under identical geometry.

**All listed geometric checks passed. v17 has not been sliced with the owner's printer profile or physically printed here.** The coupon provides a smaller first-layer and new-angle trial; geometric clearance does not eliminate all seam, extrusion or adhesion artifacts.

## Build and validate

Tested with **OpenSCAD 2021.01**, Python **3.13.5**, NumPy **2.3.5**, Shapely **2.1.2**, Trimesh **4.11.1**, and NetworkX **3.6.1**. OpenSCAD is a separate system dependency; Python packages are pinned in `requirements-validation.txt`.

```sh
python -m pip install -r requirements-validation.txt
python build.py
```

On Windows, point to the console executable when it is not on PATH:

```powershell
python build.py --openscad "C:\Program Files\OpenSCAD\openscad.com"
```

The build exports the full upright part, derives the exact face-down rigid transform, exports the face-down coupon, runs the mesh and export validators, and refreshes the validation records and file manifest. Each subprocess has an explicit timeout. It does not regenerate previews or narrative documentation.

To rerun the independent spacing sweep and intentionally undersized exported-mesh control:

```sh
python check_spacing.py
```

The negative control is created in a temporary directory and never overwrites the production models. Its expected failure is `FAIL: top web < 1.3 mm`.

Direct OpenSCAD exports are also supported:

```sh
openscad -o v17_upright.stl hex_bit_stand_continuous_web_127_v17.scad
openscad -D 'print_face_down=true' -o v17_face_down.stl hex_bit_stand_continuous_web_127_v17.scad
openscad -D 'export_part="coupon"' -D 'print_face_down=true' -o v17_coupon.stl hex_bit_stand_continuous_web_127_v17.scad
```

`render_previews.py` produces exact STL previews through OpenSCAD. It additionally requires Pillow (tested **12.3.0**) and uses `xvfb-run` when available on headless Linux. It only crops the renderer's uniform background; no geometry or appearance is invented.

## Package contents and integrity

The package contains both full-model orientations, the test coupon, standalone SCAD source, build/validation tools, previews, `validation.json`, `validation_summary.json`, `export_validation.json`, `spacing_checks.json`, `regression_checks.json`, provenance, and publication notes. `evidence/source_changes.patch` records the narrow geometry change from the verified v16 source.

`SHA256SUMS` records supplied file bytes. Rebuilding with OpenSCAD may change STL triangle ordering and therefore byte hashes without changing the part; the geometric validator should be rerun and the manifest refreshed. The ZIP checksum is provided separately next to the bundle.
