#!/usr/bin/env python3
"""Check the face-down STL and the seventeen-pocket coupon against the full v19 mesh.

Run after `python validate.py`. Only geometric checks are performed; no slicer or
physical printer is used. Requires the same dependencies as validate.py.
"""
from __future__ import annotations
import hashlib
import json
from pathlib import Path

import numpy as np
from shapely.geometry import Polygon
import trimesh

from validate import require, settings, flat_surface, slice_surface, surface_metrics

HERE = Path(__file__).resolve().parent
STEM = "hex_bit_stand_continuous_web_217_v19"
COUPON = "v19_seventeen_pocket_test_face_down.stl"


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> None:
    cfg = settings(HERE / (STEM + ".scad"))
    H = cfg["height"]
    minimum = cfg["min_surface_feature"]
    upright_path = HERE / (STEM + ".stl")
    down_path = HERE / (STEM + "_face_down.stl")
    coupon_path = HERE / COUPON
    transform = np.array([[1, 0, 0, 0], [0, -1, 0, 0],
                          [0, 0, -1, H], [0, 0, 0, 1]], dtype=float)
    full = trimesh.load_mesh(upright_path, process=True)
    down = trimesh.load_mesh(down_path, process=True)
    require(down.is_watertight and down.is_volume, "Face-down STL is not a closed positive volume")
    require(len(down.split(only_watertight=False)) == 1 and down.euler_number == -432,
            "Face-down STL has incorrect topology")
    reference = full.copy()
    reference.apply_transform(transform)
    # The binary export preserves triangle order. Check all exported vertices,
    # not just bounds/volume, allowing binary STL float32 rounding.
    require(reference.triangles.shape == down.triangles.shape, "Face-down face count mismatch")
    face_error = float(np.abs(reference.triangles - down.triangles).max())
    require(face_error < 1e-5, "Face-down STL differs from the rigidly rotated full model")
    require(abs(down.bounds[0, 2]) < 1e-6 and abs(down.bounds[1, 2] - H) < 1e-6,
            "Face-down model is not on the bed")
    down_metrics = surface_metrics(flat_surface(down, 0, -1), minimum, 217)
    require(down_metrics["minimum_inter_pocket_web_mm"] >= minimum,
            "Face-down bed-contact surface violates web width")
    require(down_metrics["connected_after_half_minimum_erosion"], "Face-down surface has a thin neck")

    coupon = trimesh.load_mesh(coupon_path, process=True)
    require(coupon.is_watertight and coupon.is_volume, "Coupon is not a closed positive volume")
    require(len(coupon.split(only_watertight=False)) == 1 and coupon.euler_number == -32,
            "Coupon must have seventeen through-holes and one connected solid")
    require(abs(coupon.bounds[0, 2]) < 1e-6, "Coupon is not on the bed")
    coupon_extents = coupon.extents.tolist()
    coupon.apply_transform(transform)  # same transform is its own inverse
    top = surface_metrics(flat_surface(coupon, H, 1), minimum, 17)
    bottom = surface_metrics(flat_surface(coupon, 0, -1), minimum, 17)
    for metrics in (top, bottom):
        require(metrics["minimum_inter_pocket_web_mm"] >= minimum, "Coupon web below minimum")
        require(metrics["minimum_pocket_to_exterior_mm"] >= minimum, "Coupon perimeter below minimum")
        require(metrics["connected_after_half_minimum_erosion"], "Coupon has a thin surface neck")

    # Match complete hole outlines at several depths to the full production
    # model. This checks exact pitch, tilt, entry and hex-exit geometry together.
    qrs = [(q, 0) for q in range(9)] + [(q, 1) for q in range(8)]
    max_outline_error = 0.0
    zs = [0.05, 0.5, 1.5, 2.05, 3.0, 7.0, 11.0, 12.9, 13.5, 13.8, 13.999]
    for z in zs:
        full_holes = [Polygon(h) for h in slice_surface(full, z, 217).interiors]
        test_holes = [Polygon(h) for h in slice_surface(coupon, z, 17).interiors]
        used = set()
        for h in test_holes:
            i = min(range(len(full_holes)), key=lambda j: h.centroid.distance(full_holes[j].centroid))
            used.add(i)
            max_outline_error = max(max_outline_error, h.hausdorff_distance(full_holes[i]))
        require(len(used) == 17, "Coupon matching is not one-to-one")
    require(max_outline_error < 0.00025, "Coupon hole geometry differs from full model")
    require(top["minimum_inter_pocket_web_mm"] <= down_metrics["minimum_inter_pocket_web_mm"] + 0.00025,
            "Coupon does not exercise the full-model worst top gap")
    report = {
        "status": "PASS",
        "scope": "Face-down rigid-transform equivalence; seventeen-pocket coupon geometry and its match to the full model. Not toolpath or physical validation.",
        "face_down": {"sha256": sha(down_path), "maximum_vertex_difference_after_rotation_mm": face_error,
                      "envelope_mm": down.extents.tolist(), "bed_contact_face": down_metrics,
                      "watertight": True, "connected_components": 1, "through_holes": 217},
        "coupon": {"sha256": sha(coupon_path), "pocket_count": 17,
                   "axial_coordinates": qrs, "tilt_bands_degrees": cfg["tilt_angles"],
                   "envelope_mm": coupon_extents, "volume_mm3": float(coupon.volume),
                   "watertight": True, "connected_components": 1,
                   "top_face": top, "bottom_face": bottom,
                   "full_model_comparison_z_mm": zs,
                   "maximum_hole_outline_difference_mm": max_outline_error,
                   "contains_worst_28_32_degree_pair": True,
                   "limitation": "Simplified perimeter; does not test production side-wall panels."}
    }
    (HERE / "export_validation.json").write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
