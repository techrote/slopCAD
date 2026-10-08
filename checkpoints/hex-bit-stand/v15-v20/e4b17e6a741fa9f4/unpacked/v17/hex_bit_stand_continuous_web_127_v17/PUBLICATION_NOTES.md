# Later publication — v17

Status: LOCAL_ONLY. No GitHub operations were attempted for this version.

Suggested destination when publication is requested:
`projects/hex-bit-stand/v17-continuous-web-127/`

The direct parent is the local v16 bundle, not a newly fetched Git branch. Verify live repository state before creating any files; v16 itself was also prepared locally for later publication. v17's SCAD is self-contained and does not import a file from v16.

Preserve the new SCAD, README and upright STL, plus build and validation scripts/results as appropriate. The face-down STL and coupon are useful downloadable artifacts. The existing preference is to keep generated CAD previews out of Git and add real printed-part photos later. Do not commit the redundant ZIP merely as a replacement for its editable contents.

Update the root contents index, hex-bit stand index and design history without overwriting unrelated work. Retain the 1.3 mm actual exposed-surface width rule. Do not describe this version as physically accepted: only the local geometric/export checks have been performed. No printer-profile G-code has been produced.

The user's requested change is ring 6, 36 pockets at 24 degrees, 127 total. The justified companion change is common pitch 9.45 -> 9.65 mm. Existing 0/4/8/12/16/20 degree bands, functional fit, aligned mouths, base/exit and wall styling parameters are retained.

Read `provenance.json`, `SHA256SUMS` and the validation records before publishing. A previous reported remote SHA is not evidence of the current remote state.
