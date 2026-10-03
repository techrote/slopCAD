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

**v5 is the compact vertical-pocket baseline; v6 is its splayed-pocket variant; v4 is the high-capacity baseline; v7 is the material-efficiency experiment.**

The contoured v3/v4 designs have also received the v5 comfort-lip treatment: the lower flare is 1.2 mm taller and the bottom perimeter has a 0.4 mm 45° chamfer.

Each version folder contains the OpenSCAD source, printable STL, and version-specific notes.
