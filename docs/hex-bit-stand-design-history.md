# Hex bit stand design history

The hex bit stand has evolved through fourteen committed design iterations.

## v1 — 16-pocket grid

The initial design established the basic fit and print constraints: 7.0 mm AF pockets, 12 mm depth, a 0.6 mm lead-in, and a substantial top chamfer. It used a simple 4 × 4 rectangular grid and a 6 mm floor.

## v2 — hex-pattern layout

The layout changed to a 4–5–4 staggered cluster and the floor was reduced to 1 mm. This removed a large amount of unnecessary material while retaining easy-access 7.0 mm AF pockets.

## v3 — contoured body

The rectangular outer block was replaced with a body derived from the outer pocket envelope. A flared foot, recessed waist band, and contoured top chamfer added visual character without requiring supports.

## v4 — dense 51-pocket stand

Capacity increased from 13 to 51 pockets using a 6–7–8–9–8–7–6 lattice. Centre pitch was reduced to 8.8 mm, leaving 1.8 mm between the functional 7.0 mm pocket sections and 0.6 mm at the very top of adjacent 8.2 mm lead-ins.

## v5 — dense contoured 13-pocket stand

The compact 4–5–4 format was combined with v4's 8.8 mm dense lattice. The lower lip was then revised after physical handling feedback: its full-height section was increased by 1.2 mm and a 0.4 mm × 0.4 mm 45° chamfer was added around the bottom perimeter.

The same lower-lip comfort revision was backported to the contoured v3 and v4 sources.

## v6 — outward-tilted dense 13-pocket stand

The compact dense layout was adapted so the centre pocket remains vertical while the twelve surrounding pockets tilt **10° radially outward**. To prevent the dense pocket shafts from converging and intersecting below the surface, the v5 floor-centre lattice is retained and each tilted axis splays outward as it rises. The outer mouth centres therefore move about **2.12 mm outward** at the top. The body contour follows that splay through height, and the softened lower-lip treatment is retained.

Physical testing confirmed that the outward-splayed arrangement works well with long driver bits. The horizontally generated mouth chamfers intersect the rotated tilted shafts with a visible rotational mismatch; that accidental scalloped detail was retained as a deliberate feature in later tilted variants.

## v7 — material-efficient dense 51-pocket stand

The v4 high-capacity geometry was revisited for lower material use. Each pocket now has a **5.6 mm circular through-hole** through its 1 mm floor, leaving 0.7 mm support at the middle of each 7 mm hex flat. The old continuous outer waist recess was removed and replaced by separate recessed panels on all **16 planar wall faces**. Each panel keeps a **1 mm border**, cuts **1.2 mm** into the wall, and uses a **50° taper**. The result remains a single watertight solid and reduces CAD solid volume by about **8.9%** relative to the current v4 baseline.

## v8 — tiered-tilt 19-pocket stand

The successful v6 concept was expanded into a true radius-2 hexagonal lattice: **1 centre + 6 inner-ring + 12 outer-ring pockets**. The centre remains vertical, the inner ring tilts **4° outward**, and the outer ring tilts **8° outward**. This produces a much squarer footprint of roughly **53.37 × 50.79 mm** (about **1.05:1**) while keeping a compact 19-bit capacity.

Pocket pitch is **9.0 mm**. The mouth chamfer was enlarged to **1.2 mm high / 8.5 mm AF**, leaving a nominal **0.5 mm top web** before the splay increases separation. The mouth chamfers deliberately remain globally oriented while the tilted shaft hexes rotate into radial local frames, preserving and strengthening the rotationally misaligned/scalloped appearance seen on the printed v6.

A physical v8 print confirmed the two-angle arrangement: with bits inserted, the 4°/8° splay is visually clear and provides useful separation, while the empty stand does not look conspicuously tilted.

## v9 — effect-plate tiered-tilt 19-pocket stand

v9 keeps the proven v8 **0° / 4° / 8°** tilt scheme and near-square footprint while refining both the wall treatment and print orientation.

The continuous waist groove is removed and replaced by v7-style recessed panels on the **18 actual convex outer-wall facets**. Each panel keeps a **1 mm edge border**, uses the same **1.2 mm recess depth** as v7, and tapers inward at **50°**.

The mouth geometry enforces a deliberate **15° rotational mismatch** by using 30° shaft hexes and 45° horizontal mouth hexes. Slicer inspection showed that this can create an undesirable inward lip on the vertical centre pocket because its lower 7 mm chamfer profile is itself rotated relative to the shaft.

v9 also experimented with circular pocket-floor reliefs for effect-plate printing. Slicer inspection showed that the intended pocket-base transition was not expressed cleanly enough.

## v10 — tapered-hex-floor effect-plate 19-pocket stand

v10 keeps the successful v8/v9 **0° / 4° / 8°** pocket splay and the v7-style inset wall panels, but revises the two problem areas found in the v9 slicer preview.

The centre lead-in now begins on the **exact 30° / 7 mm shaft profile** and twists only as it expands toward the **45° / 8.5 mm mouth**. This preserves the misaligned visual treatment while eliminating the potentially insertion-blocking 7 mm lip. The tilted rings retain the stronger scalloped v9 treatment that had already worked in physical testing.

The structural base increases from **1 mm to 2 mm** while retaining the full **12 mm pocket depth**, giving a 14 mm total stand height. At the bottom of every pocket, its exact horizontal hex cross-section is extruded downward for **1 mm with a 55° inward draft**. The resulting smaller hex profile then cuts straight through the remaining 1 mm of base.

For the vertical centre pocket, the 55° taper offsets each face inward by about **1.428 mm**, producing a nominal through-hole of about **4.14 mm AF**. For tilted pockets, the source analytically derives the exact affine/sheared horizontal cross-section of the tilted shaft and offsets that polygon inward by the same amount, so the taper meets the pocket floor without a ledge.

This creates a much cleaner self-supporting cavity for **top-face-down effect-plate printing** while retaining a true hexagonal through-hole instead of the v9 circular relief.

## v11 — tiered-tilt 37-pocket stand

v11 expands the proven v10 radius-2 design into a **radius-3 hexagonal lattice** with **37 pockets**: 1 centre, 6 in ring 1, 12 in ring 2, and 18 in the new outer ring.

The tilt bands are now **0° / 4° / 8° / 12°**. The new 18-pocket outer ring tilts **12° radially outward**, shifting its mouth centres about **2.55 mm outward** over the 12 mm pocket height. Even at 12°, the 7 mm shaft's horizontal projection leaves roughly **1.84 mm** of floor-level web on the 9 mm lattice.

The v10 2 mm base, exact 55° tapered hex floor reliefs, corrected centre lead-in, effect-plate orientation, misaligned/scalloped mouth treatment, lower-lip chamfer, and per-face wall panels are retained.

The larger radius-3 outline produces **42 actual outer-wall facets**, including several shorter facets. The wall-panel system therefore keeps the v10 **1.2 mm nominal recess depth** but adaptively reduces depth only on the shortest facets to preserve at least a **0.5 mm back-flat**.

The overall envelope is approximately **72.84 × 67.77 × 14.0 mm**, maintaining a near-square **1.08:1** footprint despite nearly doubling the v10 pocket count.

## v12 — clean-wall tiered-tilt 37-pocket stand

Physical printing of v11 exposed a poor interaction between the **42 short pocket-following wall facets** and the adaptive tapered-panel logic. Several short faces produced narrow triangular residuals that sliced as thin, poorly supported towers and printed badly.

v12 removes that workaround rather than tuning it. The radius-3 pocket envelope is **convexified before the outer-wall offset**, filling the shallow notches between outer-ring pockets and reducing the shell to **24 longer wall faces**. The nominal outer margin increases from **3.0 mm to 3.6 mm**.

Every face can now use the same full **1.2 mm-deep / 50° tapered inset panel** with a 1 mm border. The shortest new face is about **6.78 mm**, still leaving roughly **1.92 mm of back-flat** after the taper, so the adaptive short-face depth logic and its triangular remnants are removed entirely.

Pocket count, **0° / 4° / 8° / 12°** tilt bands, 2 mm base, 55° tapered hex floor reliefs, corrected centre lead-in, effect-plate orientation, and mouth-chamfer geometry are unchanged. The cleaner shell increases CAD solid volume by about **5.3%** versus v11, an intentional trade for substantially more robust side-wall printing.

The envelope grows slightly to approximately **74.04 × 68.04 × 14.0 mm**.

## v13 — lip-edge panel 37-pocket stand

Physical evaluation of v12 showed the cleaned-up 24-face shell printing well, but the recessed wall panels still retained a visible horizontal strip between their lower edge and the flared lower lip.

v13 turns each wall recess into an **open-bottom pocket** that extends directly to the **upper edge of the lower lip at z = 2.10 mm**. The 1 mm lower border and corresponding bottom taper are removed, while the **1 mm side/top borders**, **1.2 mm recess depth**, and **50° side/top taper** remain unchanged.

A small **0.05 mm boolean overlap** carries the opening just into the lip boundary to prevent a residual shelf. All pocket, tilt, floor-relief, outer-shell, and effect-plate geometry is otherwise unchanged from v12.
 
## v14 — tiered-tilt 61-pocket stand

v14 expands the v13 radius-3 architecture by one complete hexagonal ring. The result is a **radius-4 lattice with 61 pockets**: 1 centre, 6 in ring 1, 12 in ring 2, 18 in ring 3, and **24 in the new ring 4**.

The tilt bands are now **0° / 4° / 8° / 12° / 16°**. The 16° outer ring shifts its mouth centres about **3.44 mm outward** over the 12 mm pocket depth. Even at this angle, the tilted 7 mm shaft projection leaves roughly **1.72 mm of floor-level web** on the 9 mm lattice.

The outer shell keeps the v13 convex clean-wall architecture and open-bottom lip-edge recesses. The larger body resolves to **30 clean wall faces** with the same **3.6 mm nominal margin**, **1 mm side/top panel borders**, **1.2 mm recess depth**, and **50° side/top taper**. The shortest face remains about **6.77 mm**, leaving roughly **1.91 mm of back-flat**, so no adaptive short-facet geometry is required.

Chamfer handling changes slightly for the steeper ring. The global mouth hex is rotated to **0°** against the centre shaft's **30°** orientation, giving the maximum distinct **30° phase mismatch** at the centre; tilted shaft frames then produce naturally varying apparent misalignment around the rings. The mouth remains **8.5 mm AF**, while chamfer height is fixed at **1.15 mm**. With the 16° splay, this keeps the steepest radial side of the bed-facing chamfer at about **69.9° from the build plane**, inside the agreed ~70° experimental ceiling.

The v10–v13 **2 mm base**, **1 mm-high / 55° tapered hex floor exits**, corrected centre lead-in, effect-plate orientation, softened lower lip, and open-bottom side-panel treatment are retained.

The validated envelope is approximately **93.55 × 85.22 × 14.0 mm**.

## Common dimensions

- Functional hex pocket: **7.0 mm flat-to-flat**
- Pocket depth: **12.0 mm**
- Primary nozzle target: **0.6 mm**
- Most early/current vertical designs use a **0.6 mm / 8.2 mm AF** lead-in; v8–v10 use **1.2 mm / 8.5 mm AF**
- v10 base thickness: **2.0 mm**; earlier compact variants generally use **1.0 mm**
