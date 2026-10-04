# CAD work in slopCAD

Read the relevant project's README and `docs/printing.md` before creating or revising an FDM part. Reconcile live repository state and retain unrelated projects/index entries.

## Current manufacturing rule

Default to **at least 1.3 mm actual solid feature width on intended top/bottom faces**, including bed-contact faces in inverted orientations. Measure in-plane ligaments between complete final cut boundaries and from cavities to exterior edges. Do not confuse extrusion capability with reliable surface-feature size. Tilt projections, hex rotation, cutter unions and chamfer intersections must be included; nominal pitch minus AF is not sufficient. Smaller features require explicit owner approval.

For new hex-bit-stand revisions use the v15 exported-mesh checks as a starting point. Check exact exposed faces and neighbouring layer sections, connectivity, through-hole count, functional AF normal to each axis, and tilt. OpenSCAD returning success or a watertight STL alone is not manufacturing acceptance. Fail on CGAL/render errors even if an STL was emitted.

## Revision and evidence handling

Keep historical designs intact unless the user explicitly requests a backport. A historical model is not automatically certified against a later design rule. Keep source and STL in sync; add new variants to the root and project indexes. Do not claim a GitHub write, CI pass, slice result or physical print result without the corresponding evidence.

Keep generated bit-stand previews and redundant ZIPs out of Git; the owner prefers actual printed-part photographs for repository illustrations. Preserve source, printable models, validation code and relevant design notes.
