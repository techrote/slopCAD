# Hex bit stand

A family of support-free workshop organizers for standard 1/4-inch hex driver bits.

## Design target

- **7.0 mm flat-to-flat** functional hex pockets for easy insertion/removal
- **12 mm** pocket depth
- **0.6 mm nozzle** as the primary FDM target
- support-free printing
- progressively improved packing and material efficiency

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
| [v9](v9-effect-plate-19/) | 19 | radius-2 hex | v8 tilt geometry plus universal misaligned chamfers, inset wall panels, and round effect-plate floor reliefs |
| [v10](v10-effect-plate-hex-floor-19/) | 19 | radius-2 hex | v9 refinement: centre lead-in corrected; 2 mm base with 1 mm / 55° tapered hex floor reliefs and hex through-holes |
| [v11](v11-tiered-tilt-37/) | 37 | radius-3 hex | v10 geometry expanded with an 18-pocket outer ring tilted 12° outward |
| [v12](v12-clean-wall-37/) | 37 | radius-3 hex | Convex 24-face outer shell and uniform inset panels remove v11's short-facet triangular artifacts |
| [v13](v13-lip-edge-panels-37/) | 37 | radius-3 hex | v12 wall recesses become open-bottom pockets extending directly to the upper edge of the lower lip |

**v5 is the compact vertical-pocket baseline; v6 proves the outward-splay concept; v8 develops it into a near-square 19-pocket two-angle stand; v10 is the compact effect-plate refinement; v13 is the current 37-pocket / 12° outer-ring design with cleaned-up wall geometry and lip-edge recesses. v4 is the high-capacity baseline; v7 is the material-efficiency experiment.**

The contoured v3/v4 designs have also received the v5 comfort-lip treatment: the lower flare is 1.2 mm taller and the bottom perimeter has a 0.4 mm 45° chamfer.

Each version folder contains the OpenSCAD source, printable STL, and version-specific notes.
