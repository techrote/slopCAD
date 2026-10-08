# v18 — continuous-web 169-pocket stand

Local-only expansion of the actual v17 127-pocket model. The new seventh ring contains **42 pockets tilted 28° radially outward**. No GitHub calls or publication were made while preparing this version.

## Print files and orientation

**Use `hex_bit_stand_continuous_web_169_v18_face_down.stl` for effect-plate printing.** It is already rotated so the normal pocket-opening face is on the bed at Z = 0. Do not flip it again. The maximum envelope is **165.55 × 148.26 × 14.00 mm**, before any slicer brim or skirt.

`hex_bit_stand_continuous_web_169_v18.stl` is the identical part in its upright/use orientation for inspection. The SCAD defaults to that upright orientation.

`v18_fifteen_pocket_test_face_down.stl` is a smaller, **already face-down** test section. It contains all eight tilt bands, a symmetry-equivalent instance of the narrowest 24°/28° pair, and adjacent three-pocket junctions at the exact production coordinates. Its exterior is simplified; it does not validate the complete side-wall panel treatment. Its envelope is approximately **88.74 × 23.24 × 14.00 mm**.

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
| New ring 7 | 42 | 28° |
| Total | **169** | |

The 28° outer axes move **6.381 mm radially outward** from their centre positions at the pocket floor to the top, over 12 mm of vertical height.

| Feature | v18 |
|---|---|
| Functional hex size, measured perpendicular to its axis | **7.0 mm AF** |
| Floor-centre lattice pitch | **9.90 mm** |
| Aligned entrance profile size, before horizontal projection | **8.5 mm AF** |
| Entrance chamfer vertical height | **1.15 mm** |
| Main pocket vertical depth | **12.0 mm** |
| Base zone thickness | **2.0 mm** |
| Floor transition | 1 mm downward taper, **55° from vertical**, then smaller hex exit |
| Nominal vertical-centre exit AF | **4.144 mm** |
| Nominal outer-wall margin | **3.8 mm** |
| Side-panel reference-plane top/side borders | **1.3 mm** |
| Side-panel depth and taper | **1.2 mm**, **50°**; open down to the lower lip |
| Bottom-edge chamfer | **0.4 mm** |

The aligned entrance and shaft share the same phase; the former rotationally misaligned/scalloped entrance treatment is **not** reintroduced. All shafts retain the lattice-aligned roll before their outward tilt. A horizontal cut through a tilted pocket is slightly stretched radially, so 7 mm and 8.5 mm are not statements of horizontal AF in every direction.

The convex wall, softened lower lip, lip-edge side recesses, 2 mm base and tapered hex exits are retained from v17. The only changes to the main source parameters are ring count, the additional tilt-band value, and pitch. The coupon selection expands accordingly.

## Why pitch increased

Adding the 28° ring at v17's **9.65 mm** spacing would leave a narrowest top-face web of only **1.222 mm**. That violates the **1.3 mm minimum actual top/bottom surface-ligament rule**.

Pitch is therefore increased to **9.90 mm**, which gives a measured top-face web of **1.472 mm**. This preserves a useful margin rather than barely clearing the limit. Pocket sizes are not shrunk to obtain it.

The rule concerns in-plane solid material remaining after all cuts and tilted projections, not nominal pitch minus AF. It is separate from the retained 2 mm base zone and the 1 mm-tall straight exit section.

An independent analytical sweep checked 9.65, 9.75, 9.80, 9.85, 9.90 and 9.95 mm. A deliberately underspaced, fully rendered 9.65 mm model was rejected by the same mesh validator with `FAIL: top web < 1.3 mm`. Only the temporary source's pitch guard was relaxed; the minimum-width measurement rule remained enabled. That negative control never replaced the production models.

## Measured geometric validation

These are measurements of the exported upright STL, not just source dimensions:

| Check | Result |
|---|---:|
| Minimum top-face inter-pocket web | **1.472 mm** |
| Minimum top opening to exterior material | **1.948 mm** |
| Minimum underside inter-exit web | **4.961 mm** |
| Minimum underside exit to exterior material | **5.714 mm** |
| Additional horizontal sections checked | **83** |
| Minimum exterior-wall clearance across those sections | **1.891 mm** |
| Pockets independently checked for position, outward direction, tilt and normal-axis AF | **169** |
| Connected watertight positive-volume solids | **1** |
| Through-holes | **169**, Euler characteristic **−336** |
| Maximum face-down vertex difference after rotation / float32 export | **0.0000039 mm** |
| Maximum coupon/full-model hole-outline difference across 11 depths | **0.0000582 mm** |

Both exposed surfaces and all 83 sampled sections remain connected after their boundaries are eroded inward by **0.65 mm**, half the minimum web width. Every sampled section also passes the inter-opening and exterior-wall clearance checks. These sampled section checks are not a formal proof over every possible cross-section.

The steepest measured entrance-chamfer face, when printing face down, is **51.79° from vertical** (vertical wall = 0°; unsupported horizontal ceiling = 90°). This remains below the previously supplied 60° soft limit, so the 1.15 mm chamfer height does not need reducing for the 28° ring. This check concerns entrance faces only, not every external side-panel or lip surface.

CAD solid volume is **141.68 cm³**. Actual filament quantity depends on slicing. The verified supplied v17 record reports 102.83 cm³; the increase reflects another 42 pockets, wider spacing and the larger body, rather than a same-capacity efficiency comparison.

**All listed geometric checks passed. v18 has not been sliced with the owner's printer profile or physically printed here.** Geometric clearance does not guarantee seam placement, adhesion, surface quality or extrusion continuity in a particular slicer profile.

## Rebuild and validate

Environment used: **OpenSCAD 2021.01**, Python **3.13.5**, NumPy **2.3.5**, Shapely **2.1.2**, Trimesh **4.11.1**, NetworkX **3.6.1**. OpenSCAD is a separate system dependency; the Python validation dependencies are pinned in `requirements-validation.txt`.

```sh
python -m pip install -r requirements-validation.txt
python build.py
```

On Windows, supply the console executable when it is not on PATH:

```powershell
python build.py --openscad "C:\Program Files\OpenSCAD\openscad.com"
```

The build helper exports the upright model, derives its exact face-down rigid transform, exports the coupon, runs the mesh and export validators, and refreshes `validation_summary.json` and the file manifest. Each subprocess has an explicit timeout. It does not regenerate narrative documentation, baseline provenance, regression comparison records or preview images.

The build steps can also be checked separately:

```sh
python validate.py
python validate_exports.py
python check_spacing.py
```

The spacing check renders its negative control in a temporary directory and does not overwrite production models. Direct SCAD exports are also available:

```sh
openscad -o v18_upright.stl hex_bit_stand_continuous_web_169_v18.scad
openscad -D 'print_face_down=true' -o v18_face_down.stl hex_bit_stand_continuous_web_169_v18.scad
openscad -D 'export_part="coupon"' -D 'print_face_down=true' -o v18_coupon.stl hex_bit_stand_continuous_web_169_v18.scad
```

`render_previews.py` renders the actual STL using OpenSCAD. It additionally requires Pillow (tested **12.3.0**) and uses `xvfb-run` when available on headless Linux. It only crops the uniform background; no geometry is invented or altered for the previews.

## Package contents and integrity

The package contains both full-model orientations, the coupon, standalone SCAD, build/validation tools, exact-mesh previews, full and summary validation records, export checks, spacing checks, regression comparisons, provenance and later-publication notes.

The actual v17 packet was verified before derivation: all **29** entries in its `SHA256SUMS` matched, and the eight corresponding mounted attachments matched the packet bytes. `evidence/source_changes.patch` records this revision against that verified v17 source. The seven functional geometry modules were checked unchanged; the data now selects seven rings instead of six.

`SHA256SUMS` records all supplied file bytes except itself. Rebuilding may change STL triangle ordering and byte hashes without changing geometry; rerun the geometry validators and refresh hashes. The ZIP checksum is supplied separately.

Everything is local and ready for later publication. No repository state was read or changed for this version.
