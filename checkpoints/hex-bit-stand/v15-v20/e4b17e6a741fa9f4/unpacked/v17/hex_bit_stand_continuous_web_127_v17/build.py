#!/usr/bin/env python3
"""Build and validate all v17 printable meshes. OpenSCAD must be installed."""
from __future__ import annotations
import argparse
import hashlib
import json
from pathlib import Path
import shutil
import subprocess
import sys

import numpy as np
import trimesh

from validate import settings

HERE = Path(__file__).resolve().parent
STEM = "hex_bit_stand_continuous_web_127_v17"


def run(command: list[str], timeout: int = 240) -> None:
    subprocess.run(command, cwd=HERE, check=True, timeout=timeout)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--openscad", default=shutil.which("openscad.com") or shutil.which("openscad"),
                        help="OpenSCAD executable path, when not found on PATH")
    args = parser.parse_args()
    if not args.openscad:
        parser.error("OpenSCAD is not on PATH. Supply --openscad with the executable path.")
    try:
        run([args.openscad, "-o", STEM + ".stl", STEM + ".scad"])
        mesh = trimesh.load_mesh(HERE / (STEM + ".stl"), process=True)
        height = settings(HERE / (STEM + ".scad"))["height"]
        mesh.apply_transform(np.array([[1, 0, 0, 0], [0, -1, 0, 0],
                                       [0, 0, -1, height], [0, 0, 0, 1]], dtype=float))
        mesh.export(HERE / (STEM + "_face_down.stl"), file_type="stl")
        run([args.openscad, "--export-format", "binstl", "-D", 'export_part="coupon"',
             "-D", "print_face_down=true", "-o", "v17_thirteen_pocket_test_face_down.stl", STEM + ".scad"])
        run([sys.executable, "validate.py"])
        run([sys.executable, "validate_exports.py"])
        report = json.loads((HERE / "validation.json").read_text())
        (HERE / "validation_summary.json").write_text(json.dumps(
            {k: v for k, v in report.items() if k not in ("sections", "pocket_measurements")}, indent=2) + "\n")
        manifest = []
        for file in sorted(HERE.rglob("*")):
            if file.is_file() and "__pycache__" not in file.parts and file.name != "SHA256SUMS":
                manifest.append(hashlib.sha256(file.read_bytes()).hexdigest() + "  " + file.relative_to(HERE).as_posix())
        (HERE / "SHA256SUMS").write_text("\n".join(manifest) + "\n")
    except (OSError, ValueError, subprocess.SubprocessError) as exc:
        print(f"Build failed: {exc}", file=sys.stderr)
        return 1
    print("v17 meshes built and geometric checks passed. Previews and narrative documentation are not regenerated.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
