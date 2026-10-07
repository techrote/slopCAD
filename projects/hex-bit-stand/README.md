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
