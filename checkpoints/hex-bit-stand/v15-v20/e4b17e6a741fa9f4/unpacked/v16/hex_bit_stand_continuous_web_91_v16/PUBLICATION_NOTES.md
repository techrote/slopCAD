# v16 publication handoff

Status: **local-only, not published**. No GitHub connector calls or remote mutations were made while preparing this packet.

Suggested future destination: `projects/hex-bit-stand/v16-continuous-web-91/` in `techrote/slopCAD`.

The parent is the supplied v15 continuous-web design. `provenance.json` identifies the exact parent source and mesh; it is not a claim about the current remote branch head.

For a later publication turn, read current repository instructions and live state first. Add this revision without overwriting earlier designs, add its index/design-history entries and preserve the 1.3 mm surface-width rule. The source, upright STL, README, validators and validation records are the core preservation set. The face-down stand and coupon are useful optional printable assets.

Generated render PNGs can remain outside Git, consistent with the existing preference to use real print photos in the repository. The bundle is a handoff convenience, not a requirement to commit a redundant ZIP. The supplied validation is local geometry evidence; there is no new GitHub CI run and no physical v16 acceptance yet.

The copied build logs in `evidence/` record this preparation. Rebuilding may change STL triangle ordering or byte hashes across tool versions; compare geometry and rerun checks rather than assuming byte-for-byte reproduction. Regenerate rendered previews after intentional source changes.
