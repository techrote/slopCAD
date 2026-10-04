# Printing notes and current design rules

The primary hex-bit-stand target is a **0.6 mm nozzle**. Version-specific orientation and validation instructions take precedence over the early generic base-down notes.

## Minimum top/bottom feature width — 1.3 mm

From v15 onward, use **1.3 mm as the minimum actual solid ligament/feature width on top and bottom faces**, especially the visible face printed directly against an effect plate. This is an in-plane width requirement, not a redefinition of layer height or a statement that every Z-thickness must equal 1.3 mm.

Include material between complete pocket mouths, multi-pocket junctions, exit holes and the exterior perimeter. Account for tilt projection, hex orientation, all cutter unions and intersections, and chamfer geometry. Do not substitute nominal `pitch - flat_to_flat` for actual polygon-to-polygon measurement.

A nozzle's ability to extrude a 0.5 mm line does not make a 0.5 mm face junction a reliable design target. In the owner's v14 representative-section test, interrupted first-layer paths and seams coincided with thin junctions, producing visible gaps and blips. Measuring the supplied v14 STL found top-face gaps down to about **0.024 mm**.

The v15 correction uses aligned shaft/mouth profiles, lattice-aligned shaft roll and 9.3 mm pitch. Its exported top face has **1.424 mm minimum inter-pocket web**; the underside has **4.937 mm** between exits. It also checks the exterior rim and 83 intermediate sections. See [v15](../projects/hex-bit-stand/v15-continuous-web-61/).

A geometry pass is not a guarantee of seam-free toolpaths or a successful physical print. Inspect the first layers in the actual slicer and use a representative section/coupon before committing to the full part. Any new exception below 1.3 mm needs explicit owner agreement.

## Orientation and fit

Early vertical stands were developed base-down. The later effect-plate variants are intended to be printed **top-face-down**, so the broad pocket-opening face contacts the plate. v15 provides `print_face_down=true` and an optional nine-pocket test coupon in its source.

The functional hex pocket is **7.0 mm AF measured perpendicular to the bit axis**. A horizontal slice of a tilted pocket is slightly stretched; do not mistake that projection for changed bit clearance. Revalidate surface ligaments after changing pocket size, pitch, orientation or entrance dimensions.

The historical 0.24–0.30 mm layer-height and 3–4 perimeter suggestions were starting points, not confirmed settings for every version. The owner's slicer profile and representative print remain the manufacturing authority.

## Historical thin-web experiments

v4/v7 used nominal 0.6 mm mouth webs; several later variants used nominal 0.5 mm spacing estimates. These remain in Git as design history and are **not** certified against the current 1.3 mm minimum. The newer rule supersedes those assumptions for future designs and revisions; it does not silently modify the earlier STLs.
