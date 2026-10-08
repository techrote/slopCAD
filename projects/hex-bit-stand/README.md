# Hex bit stand

A family of workshop organizers for standard 1/4-inch hex driver bits, developed through printed prototypes.

## Current design target

Functional pockets are **7.0 mm AF normal to the bit axis**, with **12 mm main pocket depth** and a **0.6 mm nozzle** as the primary FDM target. New top/bottom faces must retain **at least 1.3 mm of actual solid ligament** after all cuts, projections and chamfers. Read [the current design/printing rules](../../docs/printing.md); historical thin-web variants are not certified against this newer minimum.

## Versions

| Version | Capacity | Layout | Main change |
|---|---:|---|---|
| [v1](v1-grid-16/) | 16 | 4 × 4 grid | Initial rectangular stand |
| [v2](v2-hex-pattern-13/) | 13 | 4–5–4 | Staggered hex-pocket layout and 1 mm base |
| [v3](v3-contoured-13/) | 13 | 4–5–4 | Body follows the pocket cluster; faceted outer-wall styling |
| [v4](v4-dense-51/) | 51 | 6–7–8–9–8–7–6 | Dense honeycomb packing and high capacity |
| [v5](v5-dense-contoured-13/) | 13 | dense 4–5–4 | Compact v3-style stand using v4 pocket spacing and softened lower lip |
| [v6](v6-outward-tilted-13/) | 13 | dense 4–5–4 | Centre pocket vertical; 12 outer pockets tilted 10° outward |
| [v7](v7-material-efficient-51/) | 51 | 6–7–8–9–8–7–6 | 5.6 mm floor reliefs plus individual 50° tapered outer-wall panels |
| [v8](v8-tiered-tilt-19/) | 19 | radius-2 hex | Centre vertical; 6 inner pockets at 4° and 12 outer pockets at 8°; larger misaligned chamfers |
| [v9](v9-effect-plate-19/) | 19 | radius-2 hex | Universal misaligned chamfers, inset wall panels, and round floor reliefs |
| [v10](v10-effect-plate-hex-floor-19/) | 19 | radius-2 hex | Corrected centre lead-in; 2 mm base with 55° tapered hex floor reliefs |
| [v11](v11-tiered-tilt-37/) | 37 | radius-3 hex | Adds an 18-pocket outer ring tilted 12° outward |
| [v12](v12-clean-wall-37/) | 37 | radius-3 hex | Convex clean-wall shell removes short-facet triangular artifacts |
| [v13](v13-lip-edge-panels-37/) | 37 | radius-3 hex | Wall recesses extend to the lower lip |
| [v14](v14-tiered-tilt-61/) | 61 | radius-4 hex | Historical 16° outer-ring / misaligned-mouth experiment; first-layer pinch points found |
| [v15](v15-continuous-web-61/) | 61 | radius-4 hex | Aligned mouths/shaft roll, 9.3 mm pitch, measured 1.424 mm top web and exported-mesh validation |
| [v16](v16-continuous-web-91/) | 91 | radius-5 hex | Adds 30 pockets at 20°; pitch 9.45 mm; measured 1.433 mm minimum top web |
| [v17](v17-continuous-web-127/) | 127 | radius-6 hex | Adds 36 pockets at 24°; pitch 9.65 mm; measured 1.450 mm minimum top web |
| [v18](v18-continuous-web-169/) | 169 | radius-7 hex | Adds 42 pockets at 28°; pitch 9.90 mm; measured 1.472 mm minimum top web |
| [v19](v19-continuous-web-217/) | 217 | radius-8 hex | Adds 48 pockets at 32°; pitch 10.20 mm; measured 1.493 mm minimum top web |
| [v20](v20-continuous-web-271/) | 271 | radius-9 hex | Adds 54 pockets at 36°; pitch 10.55 mm, 4.1 mm wall margin; measured 1.505 mm minimum top web |

**v15 established the continuous-web production rule and was subsequently physically printed successfully. v16–v20 extend that same aligned-mouth architecture ring by ring through 36°, with pitch increased only as required to keep actual exposed-surface ligaments above 1.3 mm. v20 is the largest prepared/published variant at 271 pockets.** v13 remains the 37-pocket historical lineage; v10 the compact effect-plate lineage; v4/v7 the high-capacity vertical lineage.

Earlier contoured designs received a taller lower lip and 0.4 mm bottom-edge chamfer. Each version folder contains its source, printable STL and notes. Prior printed success does not automatically certify a variant against newly introduced manufacturing rules.

## Original bundles and supplementary tools

The v15–v20 sources and upright models were already published; v15 also includes its validator and requirements, and v16–v20 include compact validation summaries. The original bundles below add the original face-down exports, representative coupons, fuller reports and each version's own supporting tools and evidence. Existing source and STL files remain unchanged.

| Version | Original ZIP | Matched source, tools and fuller evidence | Coupon |
|---|---|---|---:|
| v15 | [hex_bit_stand_v15_bundle.zip](https://github.com/techrote/slopCAD/blob/787cfcae9664eae1e94f732b54b8df4c9cdaca3e/checkpoints/hex-bit-stand/v15-v20/e4b17e6a741fa9f4/originals/hex_bit_stand_v15_bundle.zip) | [Original bundle files](https://github.com/techrote/slopCAD/tree/787cfcae9664eae1e94f732b54b8df4c9cdaca3e/checkpoints/hex-bit-stand/v15-v20/e4b17e6a741fa9f4/unpacked/v15); [full geometry report](https://github.com/techrote/slopCAD/blob/787cfcae9664eae1e94f732b54b8df4c9cdaca3e/checkpoints/hex-bit-stand/v15-v20/e4b17e6a741fa9f4/unpacked/v15/validation.json) | 9 pockets |
| v16 | [hex_bit_stand_v16_91_pocket_bundle.zip](https://github.com/techrote/slopCAD/blob/787cfcae9664eae1e94f732b54b8df4c9cdaca3e/checkpoints/hex-bit-stand/v15-v20/e4b17e6a741fa9f4/originals/hex_bit_stand_v16_91_pocket_bundle.zip) | [Original bundle files](https://github.com/techrote/slopCAD/tree/787cfcae9664eae1e94f732b54b8df4c9cdaca3e/checkpoints/hex-bit-stand/v15-v20/e4b17e6a741fa9f4/unpacked/v16/hex_bit_stand_continuous_web_91_v16); [full geometry report](https://github.com/techrote/slopCAD/blob/787cfcae9664eae1e94f732b54b8df4c9cdaca3e/checkpoints/hex-bit-stand/v15-v20/e4b17e6a741fa9f4/unpacked/v16/hex_bit_stand_continuous_web_91_v16/validation.json) | 11 pockets |
| v17 | [hex_bit_stand_v17_127_pocket_bundle.zip](https://github.com/techrote/slopCAD/blob/787cfcae9664eae1e94f732b54b8df4c9cdaca3e/checkpoints/hex-bit-stand/v15-v20/e4b17e6a741fa9f4/originals/hex_bit_stand_v17_127_pocket_bundle.zip) | [Original bundle files](https://github.com/techrote/slopCAD/tree/787cfcae9664eae1e94f732b54b8df4c9cdaca3e/checkpoints/hex-bit-stand/v15-v20/e4b17e6a741fa9f4/unpacked/v17/hex_bit_stand_continuous_web_127_v17); [full geometry report](https://github.com/techrote/slopCAD/blob/787cfcae9664eae1e94f732b54b8df4c9cdaca3e/checkpoints/hex-bit-stand/v15-v20/e4b17e6a741fa9f4/unpacked/v17/hex_bit_stand_continuous_web_127_v17/validation.json) | 13 pockets |
| v18 | [hex_bit_stand_v18_169_pocket_bundle.zip](https://github.com/techrote/slopCAD/blob/787cfcae9664eae1e94f732b54b8df4c9cdaca3e/checkpoints/hex-bit-stand/v15-v20/e4b17e6a741fa9f4/originals/hex_bit_stand_v18_169_pocket_bundle.zip) | [Original bundle files](https://github.com/techrote/slopCAD/tree/787cfcae9664eae1e94f732b54b8df4c9cdaca3e/checkpoints/hex-bit-stand/v15-v20/e4b17e6a741fa9f4/unpacked/v18/hex_bit_stand_continuous_web_169_v18); [full geometry report](https://github.com/techrote/slopCAD/blob/787cfcae9664eae1e94f732b54b8df4c9cdaca3e/checkpoints/hex-bit-stand/v15-v20/e4b17e6a741fa9f4/unpacked/v18/hex_bit_stand_continuous_web_169_v18/validation.json) | 15 pockets |
| v19 | [hex_bit_stand_v19_217_pocket_bundle.zip](https://github.com/techrote/slopCAD/blob/787cfcae9664eae1e94f732b54b8df4c9cdaca3e/checkpoints/hex-bit-stand/v15-v20/e4b17e6a741fa9f4/originals/hex_bit_stand_v19_217_pocket_bundle.zip) | [Original bundle files](https://github.com/techrote/slopCAD/tree/787cfcae9664eae1e94f732b54b8df4c9cdaca3e/checkpoints/hex-bit-stand/v15-v20/e4b17e6a741fa9f4/unpacked/v19/hex_bit_stand_continuous_web_217_v19); [full geometry report](https://github.com/techrote/slopCAD/blob/787cfcae9664eae1e94f732b54b8df4c9cdaca3e/checkpoints/hex-bit-stand/v15-v20/e4b17e6a741fa9f4/unpacked/v19/hex_bit_stand_continuous_web_217_v19/validation.json) | 17 pockets |
| v20 | [hex_bit_stand_v20_271_pocket_bundle.zip](https://github.com/techrote/slopCAD/blob/787cfcae9664eae1e94f732b54b8df4c9cdaca3e/checkpoints/hex-bit-stand/v15-v20/e4b17e6a741fa9f4/originals/hex_bit_stand_v20_271_pocket_bundle.zip) | [Original bundle files](https://github.com/techrote/slopCAD/tree/787cfcae9664eae1e94f732b54b8df4c9cdaca3e/checkpoints/hex-bit-stand/v15-v20/e4b17e6a741fa9f4/unpacked/v20/hex_bit_stand_continuous_web_271_v20); [full geometry report](https://github.com/techrote/slopCAD/blob/787cfcae9664eae1e94f732b54b8df4c9cdaca3e/checkpoints/hex-bit-stand/v15-v20/e4b17e6a741fa9f4/unpacked/v20/hex_bit_stand_continuous_web_271_v20/validation.json) | 19 pockets |

Read the [preservation record](https://github.com/techrote/slopCAD/blob/787cfcae9664eae1e94f732b54b8df4c9cdaca3e/checkpoints/hex-bit-stand/v15-v20/e4b17e6a741fa9f4/PRESERVATION.md) for exact identities, original manifests and source lineage. The original v15–v19 ZIP hashes match values recorded inside later original bundles; v20's ZIP SHA-256 was newly observed during preservation because no earlier expected digest was recovered. Original previews and ZIPs are preserved in this historical checkpoint under the owner's explicit archive request; this does not change active repository illustrations.

### Use one complete archived toolset at a time

Download the required version's original ZIP and extract a **separate writable copy**. v15 is a flat ZIP: its extraction directory is the working directory. For v16–v20, enter the single `hex_bit_stand_continuous_web_<pocket-count>_v<version>/` directory inside the extraction. Each version's original README and scripts belong with that version's source, meshes and metadata. The published upright STLs have different byte identities from the original bundle STLs; preservation neither replaces them nor claims a semantic mesh equivalence or difference.

Use Python with that bundle's `requirements-validation.txt`; keep the Python environment **outside** the bundle directory. v15 requires NumPy 2.3.5, Shapely 2.1.2, Trimesh 4.11.1, NetworkX `>=3.4,<4` and SciPy `>=1.14,<2`. v16–v20 pin the first three versions and NetworkX 3.6.1. OpenSCAD is a separate dependency for rebuilding: the later bundles record OpenSCAD 2021.01 and Python 3.13.5 as the original tested environment.

The version-specific READMEs document the commands and working directories. `validate.py` inspects the matched saved mesh and writes `validation.json`; v16–v20 also include `validate_exports.py` and `build.py`. The build helpers overwrite exports, reports and checksums, so they belong in the writable copy. `check_spacing.py` in v17–v20 and `check_margin.py` in v20 render temporary negative controls and update their reports. OpenSCAD must be on PATH or selected through the relevant tool's `--openscad` option. The v17–v20 preview helper also requires Pillow (the original notes record 12.3.0), which is not in the validation requirements; rendering needs a graphical display or `xvfb-run` on headless Linux. No preview command is needed to access the preserved images.

These commands were reviewed statically for their existing inputs, dependencies and output locations; the historical bundle studies were not rerun to create replacement evidence. Original measurements remain bounded software/geometry evidence. The separately recorded v15 print history does not establish physical acceptance of v16–v20 or certify other historical variants against a later manufacturing rule.
