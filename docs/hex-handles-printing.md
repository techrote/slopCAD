# Hex handles — printing and installation notes

These notes apply to the compact handles under `project/hex-handles/`. They are separate from the hex-bit-stand printing notes because the handles have different strength, fit, and assembly constraints.

## Orientation

Print V1 with the **hex socket opening directly on the build plate** and the tail pointing upward.

This orientation:

- keeps the shaft axis aligned with the layer stack
- gives the socket mouth direct dimensional support from the bed
- lets the internal tapered roof close toward the small vent without a broad horizontal bridge
- places the rounded tail at the top of the print

The accepted V1 geometry was developed around a printer capable of approximately **65° overhangs from vertical**; its checked non-bed downward-facing maximum was approximately **61.83°**.

## Socket fit

The CAD socket is **6.4 mm flat-to-flat** for a nominal 1/4-inch / 6.35 mm hex shaft.

That **0.05 mm nominal per-side clearance is small**. Real fit depends strongly on:

- XY calibration
- first-layer/elephant-foot compensation
- filament shrinkage
- slicer line-width behaviour
- the actual extension shaft dimensions

Before committing a full handle or using epoxy, generate the source's `socket_coupon` output and test the actual shaft. Adjust `socket_af` if required.

## Slicer checks

Before printing a modified version:

1. inspect the first few layers around the hex mouth for elephant-foot intrusion;
2. inspect both epoxy reservoirs to make sure no support material or slicer artefact blocks the shaft path;
3. confirm the socket-to-vent roof is being printed as successive supported perimeters rather than a broad bridge;
4. verify the tail vent remains open to the outside;
5. recheck overhangs after changing the exterior envelope or axial section positions.

Internal supports are not intended.

## Strength

No torque rating is claimed. For a working tool handle, use a material and print strategy appropriate to the expected load. Increasing perimeter count is generally more useful to this shell-like part than relying only on high sparse infill.

The **26 mm metal shaft is intentionally embedded through most of the 32 mm handle** to reduce the length of unsupported printed material that could otherwise shear along a layer interface.

## Epoxy installation

For permanent installation:

1. dry-fit the shaft and verify full seating;
2. remove it and confirm the **2.4 mm tail vent** is clear;
3. apply a controlled amount of suitable epoxy inside the socket/reservoir region;
4. insert the shaft slowly while keeping the handle oriented so displaced air and excess adhesive can escape through the vent;
5. wipe away expelled adhesive before it cures;
6. leave the assembly undisturbed for the adhesive manufacturer's full cure time.

The two enlarged internal waist regions are intended to form mechanical epoxy keys around the shaft without narrowing the 6.4 mm insertion path.

## Surface finishing

The repository CAD intentionally omits the fine surface texture visible on earlier physical handles. Apply decorative/traction texture only after the functional CAD is complete, and avoid modifying the socket, vent, mouth, or shaft-seating surfaces.
