# Printing notes

These models are intended for ordinary FDM printing with a **0.6 mm nozzle** and no supports.

## Suggested baseline

- Orientation: flat base on the build plate
- Nozzle: 0.6 mm
- Layer height: 0.24–0.30 mm
- Perimeters: 3–4
- Supports: none
- Use normal elephant-foot compensation if dimensional fit is important

For the 1 mm-base versions, choose layer heights that produce a sensible number of bottom layers and ensure the first layer is well calibrated.

## Pocket fit

The functional pocket is **7.0 mm flat-to-flat**, giving clearance over a nominal 1/4-inch (6.35 mm) driver bit. Printer calibration, material shrinkage, and elephant foot can affect fit.

If internal features print undersize, increase the OpenSCAD `hex_flat_to_flat` parameter by roughly 0.1–0.2 mm before exporting a new STL.

## Dense v4 notes

v4 intentionally uses a minimum **0.6 mm web at the very top of adjacent lead-ins**. A modern variable-width/Arachne-style perimeter generator is preferable. The straight 7.0 mm pocket region retains **1.8 mm** between neighbouring pockets.
