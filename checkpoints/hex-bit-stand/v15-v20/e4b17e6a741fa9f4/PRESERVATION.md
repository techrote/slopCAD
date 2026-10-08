# Preservation record: hex-bit stand v15–v20

This checkpoint preserves the complete six supplied design bundles, including their original ZIP bytes and every unpacked member. It supplements the versions already published in `projects/hex-bit-stand/`. It records historical CAD work and its evidence; it adds no design changes or new manufacturing acceptance.

## Archive identity and contents

The canonical payload ID is `e4b17e6a741fa9f4`. It is the first 16 hexadecimal characters of SHA-256 over the exact UTF-8 [PAYLOAD-MANIFEST.json](PAYLOAD-MANIFEST.json) bytes, including the final line feed. The full digest is `e4b17e6a741fa9f4d080789a982517b2eb3131f1ae6ecdf3a6a3e029b344211a`. This manifest binds the relative paths, Git modes, sizes, SHA-256 digests and Git blob IDs of **178 original payload files: six exact ZIPs plus 172 original ZIP members**. It is a newly created family manifest, distinct from the original manifests inside five bundles.

The complete checkpoint has **181 files**: those 178 original payload files and three new records (`PAYLOAD-MANIFEST.json`, this note, and [PRESERVATION-MANIFEST.json](PRESERVATION-MANIFEST.json)). The preservation manifest has 180 file records, excluding itself. Its additional metadata records packet authentication, provenance fields and the read-only comparison with the published projects. None of these new records is inserted into an original bundle or its original checksum boundary.

| Version | Stand / coupon pockets | Exact original ZIP | Complete original working directory | Original checksum records | Member paths absent from published version |
|---|---:|---|---|---:|---:|
| v15 | 61 / 9 | [hex_bit_stand_v15_bundle.zip](originals/hex_bit_stand_v15_bundle.zip) | [14 members](unpacked/v15/) | not supplied | 9 |
| v16 | 91 / 11 | [hex_bit_stand_v16_91_pocket_bundle.zip](originals/hex_bit_stand_v16_91_pocket_bundle.zip) | [24 members](unpacked/v16/hex_bit_stand_continuous_web_91_v16/) | 23 | 20 |
| v17 | 127 / 13 | [hex_bit_stand_v17_127_pocket_bundle.zip](originals/hex_bit_stand_v17_127_pocket_bundle.zip) | [30 members](unpacked/v17/hex_bit_stand_continuous_web_127_v17/) | 29 | 26 |
| v18 | 169 / 15 | [hex_bit_stand_v18_169_pocket_bundle.zip](originals/hex_bit_stand_v18_169_pocket_bundle.zip) | [33 members](unpacked/v18/hex_bit_stand_continuous_web_169_v18/) | 32 | 29 |
| v19 | 217 / 17 | [hex_bit_stand_v19_217_pocket_bundle.zip](originals/hex_bit_stand_v19_217_pocket_bundle.zip) | [32 members](unpacked/v19/hex_bit_stand_continuous_web_217_v19/) | 31 | 28 |
| v20 | 271 / 19 | [hex_bit_stand_v20_271_pocket_bundle.zip](originals/hex_bit_stand_v20_271_pocket_bundle.zip) | [39 members](unpacked/v20/hex_bit_stand_continuous_web_271_v20/) | 38 | 35 |

The v15 ZIP is flat. The other ZIPs retain their original enclosing directory under each `unpacked/vNN/` prefix. Every original member is preserved as a regular file with original Unix mode and Git mode `100644`, including all 25 Python scripts. No executable bit has been added. Original ZIP permissions, timestamps and compression metadata remain available inside the exact ZIP bytes. All original member names are retained without renaming.

## Authentication and version lineage

All six expected sizes, complete ZIP CRC checks and safe-path inventories passed. There are no duplicate member paths, case collisions, traversal paths, symlinks or special files. All **153 records** in the five original `SHA256SUMS` files matched their original members: 23 for v16, 29 for v17, 32 for v18, 31 for v19 and 38 for v20. Those five checksum files remain byte-exact. The supplied v15 archive has no full `SHA256SUMS`; its 14 members are newly bound by the family manifest, and successor provenance corroborates the original v15 bundle and selected input identities.

| ZIP | Bytes | SHA-256 of exact supplied ZIP | Historical expected digest source |
|---|---:|---|---|
| v15 | 410,733 | `1cb35443ed51a46e1889aa9614e9ae29fa72ca99b306920c9790f196e6cdd4da` | [inputs["hex_bit_stand_v15_bundle.zip"].sha256](unpacked/v16/hex_bit_stand_continuous_web_91_v16/provenance.json) |
| v16 | 547,313 | `0fdd36023ca42ab27d33a00bd1ce3d76872451d24a51a4bd35f526f6ba3ebadc` | [inputs["hex_bit_stand_v16_91_pocket_bundle.zip"].sha256](unpacked/v17/hex_bit_stand_continuous_web_127_v17/provenance.json) |
| v17 | 624,410 | `c952f683a98fd67bf5e5cc5ae35bf105fd31257255feeb46b4b9da1773d4865f` | [baseline_bundle_sha256](unpacked/v18/hex_bit_stand_continuous_web_169_v18/provenance.json) |
| v18 | 758,968 | `7f759eb77d535d7c63099a113acca554a4773be0de49054effe289a37a4f4d67` | [baseline_packet_sha256](unpacked/v19/hex_bit_stand_continuous_web_217_v19/provenance.json) |
| v19 | 921,464 | `6015d540ae8ae7c909c620001ff9ca3b9d1b3562322c765a26590d355632f2f4` | [baseline_bundle_sha256](unpacked/v20/hex_bit_stand_continuous_web_271_v20/provenance.json) |
| v20 | 999,219 | `7ac15056dee612e4b7c32347174cf1e0ab2041858b138ea380ff023c9939c4ae` | newly observed; no earlier expected ZIP digest recovered |

The five historical expected ZIP digests are read from the untouched successor `provenance.json` files linked above and match the supplied bytes. The accompanying prior-file records in v16/v17 provenance and v18–v20 baseline receipts also match the corresponding earlier bundle members. These are artifact lineage records. They do not establish a historical Git parent. Only the v20 whole-ZIP digest lacks a recovered historical expected value; it is explicitly newly observed.

The supplied originals were recovered from these file identities, all at version 0:

| Bundle | Source file identity | Version |
|---|---|---:|
| v15 | `libfile_a3e6a31116588191836efc1415a4fa9d` | 0 |
| v16 | `libfile_106f765a60a8819185c72e71b6670e95` | 0 |
| v17 | `libfile_fcfaed426bb08191a17a0f7c8317388a` | 0 |
| v18 | `libfile_89dfb8c000948191919a4551e9b79966` | 0 |
| v19 | `libfile_4cdf55a197588191b362bc92122dfc87` | 0 |
| v20 | `libfile_f643dc9758608191b9d0e8160c7baa21` | 0 |

## Evidence retained and comparison with published work

The archive includes all six source models, 18 original STL files, 16 original PNG previews, full validation reports, coupon/export reports where supplied, requirements and all supplied scripts. The v17–v20 source-change patches are preserved as inert evidence. Original PNG chunk checksums and dimensions and STL serialization record counts were checked without altering files or evaluating geometry. There are six ASCII STL files and twelve binary STL files; the v20 upright STL is binary. No STL was converted, repaired or regenerated.

The read-only comparison is pinned to [published commit e844f8dfcd64](https://github.com/techrote/slopCAD/commit/e844f8dfcd6457cf70f3b51b9f2efc52c73a5c96), tree `1535c1026ac151ce11a78ede30c5c49e3386686a`. The six active project directories already contain 25 corresponding file paths: five in v15 and four in each later version. **147 original member paths** are absent from those scoped projects, as broken down above. The six original ZIPs were also absent. This is an archival evidence gap; the six designs themselves were already published.

Four original v15 member contents exactly match the published blobs: source, README, validator and requirements. Thirteen other published text copies differ only by an omitted final line feed. The v16 published README is abridged. The v20 published SCAD adds a publication comment and omits its final line feed; the reviewed code lines are unchanged. All six published upright STL blobs differ from their corresponding original member bytes. Five have the same byte length; the v20 repository copy is larger than its binary original. Byte differences and ASCII/binary representation alone establish neither geometric equivalence nor a geometric defect. No geometry comparison was performed, and the active source/STL files are preserved independently of this checkpoint.

The complete per-path comparison and static toolset review are embedded in the preservation manifest. Current documentation can link each complete matching archived source, mesh and toolset. These artifacts are retained as versioned sets; compatibility with a different published STL or another version's validator has not been established. A future authorized rerun should use a disposable writable extraction of the exact matching bundle, its original working directory and a Python environment outside that directory: the historical build scripts recursively hash files below their directory and overwrite outputs. The original v17–v20 preview scripts additionally require Pillow and a display or `xvfb-run`. This publication did not install dependencies or run any archived program.

## Historical scope and publication boundary

Historical READMEs, provenance, local-only publication statements, tool instructions, validation claims and failures are retained verbatim. In particular, the negative spacing controls are retained for v16–v20; v20 also retains the negative margin control and rejected short side-cutter reach. Timeout and later completion records remain historical evidence. A deliberately rejected control is not a printable release. The v20 bundle includes its placement, margin, regression, face-classification and source-change evidence alongside the complete original tools.

The original 1.3 mm actual solid-feature-width rule and the reported mesh/export measurements remain bounded by their recorded methods. The v16 provenance attributes v15 physical success to an owner report. This archive adds no new geometry-validation run, slicer-profile result, physical-print result or owner acceptance for any version. No archived script, build, validator, negative-control experiment or patch was executed or applied during preservation.

The checkpoint is an additive archive on branch `checkpoint/hex-bit-stand-v15-v20-e4b17e6a741fa9f4`, using the reconciled live commit above as its publication parent. This parent is not represented as the original CAD creation base. Archive paths are outside the active project paths and do not match either existing automatic workflow trigger. Current documentation harmonization is separate from this archive; an archival byte check does not certify the CAD.

The owner's explicit archive request authorizes preserving the original ZIPs and generated previews here as a task-specific exception to the usual repository exclusion. They remain historical checkpoint assets, without replacing active project illustrations or changing the general policy. Original historical notes stating the earlier exclusion remain intact for provenance.
