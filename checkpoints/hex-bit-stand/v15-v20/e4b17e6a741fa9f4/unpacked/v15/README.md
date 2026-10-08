# v15 — continuous-web 61-pocket stand

A first-layer reliability revision of v14, based on the owner's sliced and printed representative section. The intended effect-plate orientation is **top face down**.

## What changed

The deliberately misaligned mouth chamfers are removed. Every entrance follows its own shaft without a rotational step or a scalloped union of two differently rotated cutters. Shaft hexes now share the lattice-aligned orientation before tilting; they no longer acquire an extra tangential rotation around the stand. The actual axis angles remain **0° / 4° / 8° / 12° / 16°**.

Pitch increases from **9.0 to 9.3 mm**, keeping the useful **8.5 mm mouth** rather than shrinking the entrances. Functional shaft size remains **7.0 mm AF normal to the shaft axis**. The aligned mouths are horizontal intersections of those tilted profiles, so their on-bed outline is slightly stretched radially.

The new design rule is **at least 1.3 mm of actual solid ligament on the top and bottom surfaces**. This is an in-plane material-width requirement, not permission to use 1.3 mm nominal pitch-minus-AF when rotations or projections make the real gap smaller. A demonstrated 0.5 mm extrusion width is not evidence that a 0.5 mm exposed junction will form a reliable finish.

The v14 STL's narrowest top-face gap measured about **0.024 mm**. Simply aligning a chamfer to the previous radially rotated shaft would not resolve every vertex-to-vertex bottleneck. Aligning the shaft roll with the lattice is part of this correction.

## Dimensions and retained features

| Feature | v15 |
|---|---|
| Capacity | 61: 1 centre + 6 + 12 + 18 + 24 |
| Tilt bands | 0° / 4° / 8° / 12° / 16° |
| Shaft AF, perpendicular to axis | 7.0 mm |
| Floor-centre pitch | 9.3 mm |
| Aligned mouth AF, perpendicular-profile equivalent | 8.5 mm |
| Mouth chamfer height | 1.15 mm |
| Main pocket vertical depth | 12.0 mm |
| Structural base zone | 2.0 mm |
| Floor transition | 1 mm downward taper, 55° from vertical, then hex exit |
| Nominal centre exit AF | 4.144 mm |
| Overall envelope | 96.35 × 87.70 × 14.00 mm |
| Nominal outer-wall margin | 3.8 mm (was 3.6 mm) |
| Side-panel top/side reference-plane borders | 1.3 mm (were 1.0 mm) |
| Side panels | 1.2 mm depth; 50° side/top taper; open to the lower lip |

The convex wall and softened lower lip remain. Panel positions are derived from the current parameters, rather than a hard-coded perimeter. Width changes must be revalidated; simple assertions are not a substitute for measuring the exported geometry.

## Measured validation

Measurements are from the exported STL, not only from source dimensions.

| Check | Result |
|---|---:|
| Minimum top-face inter-pocket web | **1.424 mm** |
| Minimum top-face pocket-to-outer-edge material | **2.399 mm** |
| Minimum underside inter-exit web | **4.937 mm** |
| Minimum underside exit-to-outer-edge material | **6.037 mm** |
| Additional horizontal sections checked | **83** |
| Pockets independently checked for tilt and normal-axis AF | **61** |
| Watertight, positive-volume connected components | **1** |
| Through-hole topology | 61 holes; Euler characteristic −120 |

Both exposed surfaces remain connected after erosion by half the minimum web width (0.65 mm). Every sampled section also passes the 1.3 mm inter-pocket and exterior-wall clearance checks. The normal-axis AF check independently confirms that the 7 mm bit fit was not enlarged or shrunk to obtain clearance.

CAD solid volume is about **49.86 cm³**, versus **44.60 cm³** for the supplied v14 STL: approximately **11.8% more solid-model volume**. Actual filament consumption is slicer-dependent. This is an intentional trade for wider continuous face-down junctions.

**Geometric validation passed. A slicer preview and physical print of v15 are still required; this is not a claim that all seam or extrusion artifacts have been eliminated.**

## Export and test

The default source/STL orientation is upright for inspection. For the effect-plate export:

```sh
openscad -D 'print_face_down=true' -o v15_face_down.stl hex_bit_stand_continuous_web_61_v15.scad
```

A nine-pocket coupon uses the exact production pocket positions and all five tilt bands, including the narrowest ring-3/ring-4 pair and adjacent three-pocket junctions. Its outside is simplified and does not test the full side-panel treatment:

```sh
openscad -D 'export_part="coupon"' -D 'print_face_down=true' -o v15_test_face_down.stl hex_bit_stand_continuous_web_61_v15.scad
```

To rebuild and validate the full upright mesh:

```sh
python -m pip install -r requirements-validation.txt
openscad -o hex_bit_stand_continuous_web_61_v15.stl hex_bit_stand_continuous_web_61_v15.scad
python validate.py
```

`validate.py` exits nonzero for inadequate surface webs, a disconnected thin-web core, missing/intersecting pockets, incorrect tilt/AF or invalid mesh topology. It writes a detailed `validation.json`. GitHub Actions runs this geometry check independently of the STL-regeneration workflow.

## Files

- `hex_bit_stand_continuous_web_61_v15.scad` — self-contained parameterised source, including coupon/orientation options.
- `hex_bit_stand_continuous_web_61_v15.stl` — full upright mesh.
- `validate.py` — exported-mesh surface, section, tilt and fit checks.
- `requirements-validation.txt` — validation dependencies.

See the [current printing/design rules](../../../docs/printing.md). Older revisions remain historical and are not retroactively certified against the 1.3 mm rule.
