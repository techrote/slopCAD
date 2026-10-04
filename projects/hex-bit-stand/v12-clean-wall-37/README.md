# v12 — clean-wall tiered-tilt 37-pocket stand

A side-wall cleanup of `v11-tiered-tilt-37`, prompted by physical printing of the adaptive short-facet panel geometry.

## What changed

- Pocket layout and tilt remain unchanged: **37 pockets**, with **0° / 4° / 8° / 12°** tilt bands.
- The outer shell no longer follows every shallow notch between outer-ring pockets.
- The pocket envelope is now **convexified before the wall offset**, producing **24 longer, cleaner wall faces** instead of 42 short/alternating facets.
- Nominal outer wall margin increases from **3.0 mm to 3.6 mm**.
- Every wall face now uses the same full **1.2 mm-deep / 50° tapered inset panel**.
- The adaptive short-face depth logic and its narrow triangular residuals are removed entirely.

The shortest new wall face is about **6.78 mm**, leaving about **1.92 mm of back-flat** after the 1 mm borders and full 1.2 mm / 50° taper. There is therefore no need for the small triangular compromise geometry that printed poorly on v11.

## Retained geometry

- **37 pockets**: centre + 6 + 12 + 18
- tilt bands: **0° / 4° / 8° / 12°**
- **7.0 mm AF** functional pockets
- **9.0 mm** pitch
- **1.2 mm / 8.5 mm AF** misaligned mouth chamfers
- **2.0 mm base**
- **1 mm-high / 55°** tapered hex floor reliefs
- corrected centre lead-in
- effect-plate / top-face-down printing support
- softened lower lip and **0.4 mm** lower edge chamfer

## Envelope

Approximately **74.04 × 68.04 × 14.0 mm**.

The cleaner shell adds roughly **5.3% CAD solid volume** versus v11. This is an intentional trade: slightly more material for substantially more printable side-wall geometry.

## Files

- `hex_bit_stand_tiered_tilt_37_v12.scad` — parametric source
- `hex_bit_stand_tiered_tilt_37_v12.stl` — printable mesh
