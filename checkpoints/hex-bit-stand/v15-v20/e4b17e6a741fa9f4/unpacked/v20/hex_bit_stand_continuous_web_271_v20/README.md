# v20 — continuous-web 271-pocket stand

Local-only expansion of the supplied and hash-verified **v19 continuous-web 217-pocket stand**. This adds a ninth ring containing **54 new pockets at 36° outward**. The aligned entrances, lattice-aligned shaft roll and **1.3 mm actual surface-width requirement** are retained.

## Printable files

- **`hex_bit_stand_continuous_web_271_v20_face_down.stl`** — full model already oriented for top-face-down effect-plate printing. Do not flip it again.
- **`v20_nineteen_pocket_test_face_down.stl`** — 19-pocket representative coupon, already face-down. It includes all ten tilt bands and a tightest 32°/36° pair with neighbouring three-pocket junctions.
- **`hex_bit_stand_continuous_web_271_v20.stl`** — full model in its upright/use orientation for inspection.
- **`hex_bit_stand_continuous_web_271_v20.scad`** — standalone editable OpenSCAD source with full-model/coupon and orientation switches.

The coupon uses exact production coordinates and cavities, but a simplified 2 mm exterior rather than the full side-panel treatment. Its envelope is **117.17 × 23.85 × 14.00 mm**. It does not substitute for testing the full stand's side walls or large-bed adhesion.

## Layout and dimensions

| Region | Pockets | Outward tilt |
|---|---:|---:|
| Centre | 1 | 0° |
| Ring 1 | 6 | 4° |
| Ring 2 | 12 | 8° |
| Ring 3 | 18 | 12° |
| Ring 4 | 24 | 16° |
| Ring 5 | 30 | 20° |
| Ring 6 | 36 | 24° |
| Ring 7 | 42 | 28° |
| Ring 8 | 48 | 32° |
| **New ring 9** | **54** | **36°** |
| **Total** | **271** | |

| Feature | v20 |
|---|---|
| Full envelope in supplied orientation | **221.62 × 197.46 × 14.00 mm** |
| Shaft size, normal to its axis | **7.0 mm AF** |
| Floor-centre pitch | **10.55 mm**, increased from 10.20 mm |
| Aligned entrance profile before horizontal projection | **8.5 mm AF** |
| Entrance chamfer vertical height | **1.15 mm** |
| Main pocket vertical depth | **12.0 mm** |
| Base zone | **2.0 mm** |
| Floor transition | **1 mm / 55° from vertical**, then smaller hex through-exit |
| Nominal centre exit AF | **4.144 mm** |
| Nominal outer-wall margin | **4.1 mm**, increased from 3.8 mm |
| Side-panel reference-plane side/top borders | **1.3 mm** |
| Panel recess | **1.2 mm**, with **50°** side/top taper and open to the lower lip |
| Outward reach of side-panel cutting solids | **3.0 mm**, increased from 2.0 mm |
| Lower-edge chamfer | **0.4 mm** |

The new ring axes move **8.719 mm radially outward** over the main pocket height. All prior rings keep their tilt angles; increasing pitch moves their floor centres slightly farther apart. The shaft and entrance dimensions are not reduced to obtain clearance.

The aligned hexes retain the same phase throughout each entrance. A horizontal section is stretched radially by the tilt, so the quoted 7 mm and 8.5 mm profiles are not horizontal AF dimensions in every direction. The discarded rotationally misaligned/scalloped chamfers are not reintroduced.

## Build-plate placement

The full model is **221.62 mm wide in the supplied orientation**, before any skirt or brim. Check the usable print area rather than only a printer's nominal bed size.

A **15° rotation around Z**, keeping the supplied face-down side on the plate, gives a **215.71 × 215.71 mm** bounding rectangle. This is a rigid rotation, not scaling. It may help on a square bed, but does not include clearance for a skirt, brim, clips or excluded bed regions. The measured rotation envelopes are in `placement.json`.

## Changes needed for the ninth ring

**Spacing.** At v19's 10.20 mm pitch, the new 32°/36° junction measures only **1.155 mm** across its narrowest top web. This fails the 1.3 mm rule. A 10.55 mm pitch gives **1.505 mm**, preserving useful margin without shrinking the entrance. `check_spacing.py` compares an independent analytical pitch sweep with the actual mesh and confirms that a rendered old-spacing model is rejected by the same validator.

**Exterior wall.** At the old 3.8 mm outer margin, the extra splay approaches the back of the side recesses too closely: targeted sections measure as little as **1.155 mm**. Increasing the margin to 4.1 mm gives **1.455 mm** at the same targeted sections. `check_margin.py` renders and rejects the old-margin control; it leaves production files untouched.

**Cutter reach.** An initial trial retained the old 2 mm outward reach of the side cutters. At 36°, several cutter openings no longer reached beyond the upper part of the splayed shell. Horizontal inspection detected 48 additional enclosed recess outlines at z=10.5 and 10.7 mm. Extending the cutting solids outward to 3 mm removes these thin exterior cover skins without deepening the retained 1.2 mm recess. The final mesh has only the intended 271 pocket holes at every checked section. A source assertion also checks outward reach against the upper-wall displacement.

The rule remains **at least 1.3 mm of actual in-plane material width**, after all cuts and projections. This is distinct from the 2 mm base zone and its 1 mm exit/taper sections. A nominal pitch-minus-AF figure is not used as a substitute for geometry measurements.

## Exported-mesh validation

| Measurement | Result |
|---|---:|
| Minimum top-face inter-pocket web | **1.505 mm** |
| Minimum top opening to outside edge | **1.738 mm** |
| Minimum underside inter-exit web | **4.953 mm** |
| Minimum underside exit to outside edge | **5.652 mm** |
| Regular additional horizontal sections | **83** |
| Minimum exterior wall in those sections | **1.458 mm** |
| Additional targeted side-panel sections | **10** |
| Minimum exterior wall in targeted sections | **1.455 mm** |
| Pockets checked for position, outward direction, tilt and normal-axis AF | **271** |
| Connected watertight positive-volume solids | **1** |
| Through-holes / Euler characteristic | **271 / −540** |
| Maximum tilt measurement error | **0.0000114°** |
| Maximum normal-axis AF error | **0.00000477 mm** |
| Maximum face-down transform/export vertex error | **0.000000477 mm** |

Both exposed surfaces and all 83 regular sections remain connected after erosion by **0.65 mm**, half the minimum web width. The validator measures all opening pairs, not just assumed nearest neighbours. These finite sampled checks are not a formal proof over every possible cross-section.

The entrance-chamfer maximum measured overhang is **56.88° from vertical** in the face-down orientation: a vertical face is 0°, an unsupported horizontal ceiling is 90°. It remains below the supplied 60° soft limit, so entrance height is unchanged. This measurement covers the entrance bevels, not all exterior lip/panel surfaces.

The external top rim grows enough at 36° to include a 0.01 mm-tall vertical export cap. The validator now identifies entrance triangles by their full ruled-segment endpoints, so it does not count those unrelated cap faces as entrance bevels. It still requires exactly six triangulated bevels per pocket. All-pairs checks were vectorized without changing the acceptance criteria; scalar/vectorized distances were cross-checked on the supplied v19 mesh.

Seven inherited geometry modules are byte-for-byte unchanged; `regression_checks.json` and `evidence/source_changes.patch` record the exact source changes. All 271 functional shaft measurements and the coupon/full-model comparisons pass. The coupon cavities match the full mesh over 11 checked heights, including the entrance and hex floor exits.

CAD solid volume is **259.90 cm³**. The supplied v19 volume was 192.06 cm³; the increase includes 54 additional pockets, wider spacing and a larger exterior wall, not a same-capacity efficiency comparison. Filament consumption depends on slicing.

**Geometric checks passed. No v20 printer-profile slicing or physical printing was performed here.** Seam placement, extrusion continuity, effect-plate finish, adhesion and strength still require print testing.

## Rebuild and test

Tested with OpenSCAD **2021.01**, Python **3.13.5**, NumPy **2.3.5**, Shapely **2.1.2**, Trimesh **4.11.1** and NetworkX **3.6.1**. OpenSCAD is a separate dependency. The Python requirements are pinned in `requirements-validation.txt`.

```sh
python -m pip install -r requirements-validation.txt
python build.py
python check_spacing.py
python check_margin.py
```

On Windows, supply the OpenSCAD console executable when it is not on PATH:

```powershell
python build.py --openscad "C:\Program Files\OpenSCAD\openscad.com"
```

The build helper exports the full mesh and coupon as **binary STL**, preserving coordinate precision at the larger footprint. It creates the rigidly transformed face-down mesh, runs both geometry/export validators, and refreshes the summary and checksum manifest. Each subprocess has a timeout. It does not regenerate narrative documentation, historical evidence, previews, or spacing/margin controls.

Direct export examples:

```sh
openscad --export-format binstl -o v20_upright.stl hex_bit_stand_continuous_web_271_v20.scad
openscad --export-format binstl -D 'print_face_down=true' -o v20_face_down.stl hex_bit_stand_continuous_web_271_v20.scad
openscad --export-format binstl -D 'export_part="coupon"' -D 'print_face_down=true' -o v20_coupon.stl hex_bit_stand_continuous_web_271_v20.scad
```

`render_previews.py` renders the actual upright STL in OpenSCAD and crops only uniform background. It additionally needs Pillow (tested 12.3.0) and uses `xvfb-run` on headless Linux when available. The perspective/top/underside previews were inspected after rendering.

## Provenance and later publication

The actual supplied v19 packet was used, not recreated from a chat description. All **31 checksum entries** in that packet were verified, and **9 corresponding mounted attachments** matched its bytes. These are baseline integrity checks, not a new physical acceptance claim for v19.

The packet contains both full-model orientations, the coupon, source, build/check tools, exact-STL previews, complete and summary geometry reports, negative controls, regression/provenance records and `PUBLICATION_NOTES.md`.

`SHA256SUMS` covers the delivered files other than itself. The ZIP has a separate checksum sidecar. Changes to exports or documentation require refreshing the manifest; triangle order may change after rebuilding without changing geometry.

**Everything remains local. No GitHub calls, writes, comments or workflow actions were performed for v20.**
