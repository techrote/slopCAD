#!/usr/bin/env python3
from pathlib import Path
import json
import numpy as np
import trimesh

ROOT = Path(__file__).resolve().parent
SIZES = (120, 92, 80, 60)

for size in SIZES:
    d = ROOT / f"sweephex-{size}-xl"
    stem = f"sweephex{size}_xl_chamfered"
    meta = json.loads((d / f"{stem}.json").read_text())
    expected = meta["validation"]
    measurements = meta["measurements"]
    expected_genus = measurements["hex_apertures"] + measurements["mount_holes"]
    expected_euler = 2 - 2 * expected_genus
    assert expected["euler_number"] == expected_euler

    for suffix in ("stl", "3mf"):
        mesh = trimesh.load(d / f"{stem}.{suffix}", force="mesh", process=True)
        assert mesh.is_watertight and mesh.is_winding_consistent
        assert len(mesh.split(only_watertight=False)) == 1
        assert np.allclose(mesh.extents, [size, size, 6.0], atol=1e-4)
        assert mesh.euler_number == expected_euler
        assert abs(mesh.volume - expected["volume_mm3"]) / expected["volume_mm3"] < 1e-6

    print(f"{size} mm: PASS ({measurements['hex_apertures']} airflow apertures + 4 mounts)")
