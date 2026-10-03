# Hex bit stand design history

The hex bit stand has evolved through nine committed design iterations.

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

The continuous waist groove is removed and replaced by v7-style recessed panels on the **18 actual convex outer-wall facets**. Each panel keeps a **1 mm edge border**, uses the same **1.2 mm recess depth** as v7, and tapers inward at **50°**. The shortest actual convex wall face still leaves about **3.5 mm** of back-flat width and roughly **1.8 mm** of nominal wall behind the recess.

The mouth geometry now enforces a deliberate **15° rotational mismatch on every pocket**: the functional shaft hexes use the 30° orientation while all horizontal mouth/chamfer hexes use 45°. This extends the scalloped transition to the centre pocket and to outer-ring edge-midpoint pockets that happened to align in v8.

For effect-plate printing, every pocket gains a **5.0 mm through-hole** in the 1 mm base. Instead of leaving a horizontal annular shelf, the cavity transitions over **1.0 mm** from a 7.0 mm circular opening to the 5.0 mm bore. When the stand is printed top-face-down, this creates an approximately **45° self-supporting transition at the hex flats**, avoiding a broad bridge while allowing the normal top surface to take a carbon, holographic, or other effect-plate texture.

## Common dimensions

- Functional hex pocket: **7.0 mm flat-to-flat**
- Pocket depth: **12.0 mm**
- Base thickness on current compact designs: **1.0 mm**
- Primary nozzle target: **0.6 mm**
- Most early/current vertical designs use a **0.6 mm / 8.2 mm AF** lead-in; v8/v9 use **1.2 mm / 8.5 mm AF**
