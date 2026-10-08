# v16 — continuous-web 91-pocket bit stand

A local-only expansion of the physically successful **v15 continuous-web 61-pocket stand**. It adds one complete ring without reverting to the earlier misaligned/scalloped entrances.

**Ready-to-print orientation:** `hex_bit_stand_continuous_web_91_v16_face_down.stl` already places the normal top surface at Z = 0 for effect-plate printing. Do not flip that file again.

## Pocket layout

| Band | Pockets | Outward tilt |
|---|---:|---:|
| Centre | 1 | 0° |
| Ring 1 | 6 | 4° |
| Ring 2 | 12 | 8° |
| Ring 3 | 18 | 12° |
| Ring 4 | 24 | 16° |
| **New ring 5** | **30** | **20°** |
| **Total** | **91** | |

The new outer axes shift **4.368 mm radially outward** between the main pocket floor and the top face. The underlying axial-grid rows contain **6–7–8–9–10–11–10–9–8–7–6** pockets.

## Small spacing adjustment

With the old **9.30 mm** pitch, the extra 20° ring produces a minimum exported top-face web of only **1.283 mm**, below the required 1.3 mm. The printable v16 therefore uses **9.45 mm** pitch: an increase of **0.15 mm**, preserving approximately the same narrowest top web as v15 rather than operating exactly at the limit.

The v16 exported mesh measures **1.433 mm** at the tightest top junction. This is a measured in-plane solid gap between the actual tilted opening outlines, not the nominal pitch minus flat-to-flat size. Chamfers follow the shaft phase continuously, with no intentional rotational mismatch.

## Dimensions and retained geometry

| Feature | v16 |
|---|---|
| Overall envelope, upright | **118.025 × 106.630 × 14.00 mm** |
| Functional shaft size, perpendicular to its axis | **7.0 mm flat-to-flat** |
| Floor-centre pitch | **9.45 mm** |
| Aligned mouth profile, normal-axis AF equivalent | **8.5 mm** |
| Mouth lead-in height | **1.15 mm** |
| Main pocket vertical depth | **12.0 mm** |
| Structural base zone | **2.0 mm** |
| Floor transition | **1 mm downward, 55° from vertical, then a hex exit** |
| Nominal centre underside exit | **4.144 mm AF** |
| Nominal outer-wall margin | **3.8 mm** |
| Side-panel top/side reference-plane borders | **1.3 mm** |
| Side panels | **1.2 mm recess, 50° side/top taper, open to the lower lip** |
| Bottom-edge chamfer | **0.4 mm** |

The same minimal rotation from vertical to each outward axis is retained. Thus the hex roll starts lattice-aligned before tilt. The horizontal pocket outlines are the exact projections of normal-axis hex profiles, not larger replacement pockets. Floor exits are offset from each pocket's actual horizontal floor footprint.

The outer shell remains convex. Panel positions are calculated from the current shell; no old fixed perimeter coordinates or adaptive triangular panel remnants are introduced. Source assertions protect basic parameters, but the mesh-based validation remains essential.

The **1.3 mm minimum top/bottom material-width rule remains in force**. Here it means actual in-plane solid ligaments and surface connectivity after the cuts. It does not mean that a taper's mathematical edge must itself have a 1.3 mm flat, or that the lower 1 mm through-bore section must be thickened axially.

## Exported-mesh validation

| Check | Result |
|---|---:|
| Minimum top-face inter-pocket web | **1.433 mm** |
| Minimum top-face opening-to-outer-edge material | **2.285 mm** |
| Minimum underside inter-exit web | **4.941 mm** |
| Minimum underside exit-to-outer-edge material | **5.953 mm** |
| Additional horizontal sections checked | **83** |
| Pockets checked for angle, radial direction, position and normal-axis AF | **91** |
| Watertight positive-volume connected components | **1** |
| Through-hole topology | **91 holes; Euler characteristic −180** |

Both exposed surfaces and all sampled sections remain connected after erosion by **0.65 mm**, half the required minimum width. Every sampled section passes the 1.3 mm cavity-to-cavity and cavity-to-exterior clearance checks. Individual shaft checks also confirm one-to-one pocket matching, rather than accidentally measuring the same pocket more than once.

The face-down export is checked against the exact rigid transform of the validated upright mesh. Its maximum vertex difference is **0.000002 mm**, attributable to binary STL float32 precision.

The generalized validator also re-passes the supplied v15 parent. A separate private five-ring/9.30 mm-pitch negative control is correctly rejected for its **1.283 mm top web**. The failing control is not included among the printable files. See `regression_checks.json`.

**Scope:** geometric validation, not a claim that this new 20° ring has already been sliced or physically printed. The supplied photo and owner report establish physical success for v15, not v16. No new slicer profile, G-code or physical test was generated.

## Material comparison

CAD solid volume is **72.91 cm³**, versus **49.86 cm³** for the actual retained v15 STL. That is approximately **46.2% more solid-model volume** for **49.2% more pockets**. These are geometric volumes, not filament-weight predictions; slicer infill and perimeter choices affect actual material use.

## Eleven-pocket test coupon

`v16_eleven_pocket_test_face_down.stl` uses **the production positions, profiles and tilts**, including all six bands, a tight 16°/20° pair and adjacent three-pocket junctions. It is already face-down.

The coupon is about **64.39 × 22.85 × 14.00 mm**, with a CAD solid volume of **12.51 cm³**. Its eleven cavities were compared to the full model at eleven heights; the maximum outline difference was **0.000059 mm**. It exercises the same **1.433 mm** minimum top-web condition.

The coupon has a simplified exterior and does **not** test the full production side-wall panels. It is optional; the full stand is also supplied ready for slicing.

## Rebuild

The OpenSCAD source defaults to upright/use orientation for inspection. Parameters `print_face_down=true` and `export_part="coupon"` are available for direct exports.

With OpenSCAD installed and Python 3.11 or newer:

```sh
python -m pip install -r requirements-validation.txt
python build.py
```

Supply `--openscad` with the executable path if it is not on PATH. The build creates the upright STL, a rigidly transformed face-down STL and the face-down coupon, then runs both validation scripts. Each subprocess has a finite timeout. Previews and this narrative snapshot are not rebuilt automatically.

To recheck existing delivered files without rebuilding:

```sh
python validate.py
python validate_exports.py
```

## Files and provenance

- `hex_bit_stand_continuous_web_91_v16_face_down.stl`: full stand, effect-plate orientation.
- `hex_bit_stand_continuous_web_91_v16.stl`: full stand, upright.
- `v16_eleven_pocket_test_face_down.stl`: optional smaller test.
- `hex_bit_stand_continuous_web_91_v16.scad`: self-contained parametric source.
- `validate.py`, `validate_exports.py`, `build.py`, `requirements-validation.txt`: build and checks.
- `validation.json`, `validation_summary.json`, `export_validation.json`, `regression_checks.json`: measured records.
- `perspective.png`, `top.png`: renders of the actual exported upright mesh.
- `provenance.json`, `PUBLICATION_NOTES.md`, `SHA256SUMS`: parent identities, local-only handoff and hashes.

The source and STL were derived from the actual supplied v15 artifacts; both parent files matched the SHA-256 values in their retained validation report. All previous revisions are unchanged. **Nothing was published to GitHub.**
