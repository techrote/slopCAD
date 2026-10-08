# Publication notes — v20 continuous-web 271-pocket stand

## Current state

Completed locally, not published. The user explicitly deferred GitHub publication because the connector write path was unavailable. This turn made no GitHub calls and did not test that path.

Source artifact: `hex_bit_stand_continuous_web_271_v20.scad`.
Proposed future destination: `projects/hex-bit-stand/v20-continuous-web-271/` in `techrote/slopCAD`.

## Scope

Radius 9, 271 pockets, 0° through 36° in 4° steps. Retain 7 mm normal-axis shaft AF, aligned 8.5 mm entrances, 12 mm pocket depth, 2 mm base, 55° tapered hex exits and the open-bottom side-panel style. Pitch is 10.55 mm, nominal wall margin is 4.1 mm, and the outward cutter reach is 3 mm.

## Verified locally

- One connected watertight solid, 271 through-holes, Euler characteristic −540.
- Actual top/bottom widths pass the 1.3 mm rule.
- All 271 shaft positions, tilt magnitudes/directions and AF measurements pass.
- 83 regular horizontal sections and 10 targeted side-panel sections were checked.
- Face-down transform equivalence and the 19-pocket coupon comparison pass.
- Old-spacing and old-margin rendered negative controls are rejected for the intended reasons.
- Exact-STL previews were rendered and inspected.

No slicer profile, physical print or GitHub CI run is claimed. The main footprint is **221.62 × 197.46 mm**; an in-plane 15° rotation gives approximately **215.71 × 215.71 mm**, without skirt/brim clearance.

## Before publishing

Read the actual current repository state and instructions first. Do not assume that v16–v19 have been published; those revisions were also supplied locally in this conversation. Preserve intervening work and existing indexes.

Upload the verified source, intended STL artifacts, README and relevant validation/build tools. Update the root/project index and design history to describe the new ring and the spacing/wall-reach changes. Avoid overwriting previous variants. Keep synthetic previews out of Git unless the user's real-photo preference has changed.

Decide how the new validator fits the current build workflow only after reading that workflow. This packet does not modify or invoke any repository workflow. Do not label local tests as repository CI.

After publication, read back the actual tree/commit and source identity before reporting success. Use `SHA256SUMS` and `provenance.json` to preserve exact local artifact identities. No remote checkpoint SHA is available for v20 yet.
