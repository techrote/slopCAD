# v16 — continuous-web 91-pocket bit stand

A local-only expansion of the physically successful **v15 continuous-web 61-pocket stand**. It adds one complete ring without reverting to the earlier misaligned/scalloped entrances.

**Ready-to-print orientation:** the source supports `print_face_down=true` for effect-plate printing.

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

The new outer axes shift **4.368 mm radially outward** between the main pocket floor and the top face.

## Spacing

With the old **9.30 mm** pitch, the extra 20° ring produces a minimum exported top-face web of only **1.283 mm**, below the required 1.3 mm. The printable v16 therefore uses **9.45 mm** pitch.

The v16 exported mesh measures **1.433 mm** at the tightest top junction. Chamfers follow the shaft phase continuously, with no intentional rotational mismatch.

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

The **1.3 mm minimum top/bottom material-width rule remains in force**. It refers to actual in-plane solid ligaments and surface connectivity after cuts, not simply nominal pitch minus flat-to-flat size.

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

Both exposed surfaces and all sampled sections remain connected after erosion by **0.65 mm**, half the required minimum width.

**Scope:** geometric validation only. The owner's physical success report applies to v15; v16 was not physically accepted when prepared.

## Files

- `hex_bit_stand_continuous_web_91_v16.scad` — self-contained parametric source.
- `hex_bit_stand_continuous_web_91_v16.stl` — canonical upright STL generated from the source.
- `validation_summary.json` — compact measured validation record.
