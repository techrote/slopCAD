#!/usr/bin/env python3
"""Validate the exported v19 STL, including exact planar first/last surfaces.

Requires Python 3.11+, numpy, shapely, trimesh and networkx. No rtree required.
The source must be the v19 SCAD matching the supplied upright/use-oriented mesh.
This is geometric validation, not a claim about a particular slicer's toolpaths.
"""
from __future__ import annotations
import argparse
import ast
import hashlib
import itertools
import json
import math
from pathlib import Path
import re
import sys

import numpy as np
import shapely
from shapely.geometry import Polygon
from shapely.ops import unary_union
import trimesh


def require(ok: bool, message: str) -> None:
    if not ok:
        raise ValueError(message)


def settings(path: Path) -> dict:
    text = path.read_text(encoding="utf-8")
    names = ("min_surface_feature", "ring_count", "hex_flat_to_flat", "pitch",
             "base_thickness", "pocket_depth", "pocket_mouth_flat_to_flat",
             "pocket_mouth_chamfer_h", "floor_taper_h", "floor_taper_degrees",
             "shaft_hex_rotation", "tilt_angles", "panel_border", "wall_margin")
    result = {}
    for name in names:
        match = re.search(rf"^\s*{name}\s*=\s*([^;]+);", text, re.M)
        require(match is not None, f"Missing source parameter {name}")
        result[name] = ast.literal_eval(match.group(1))
    result["height"] = result["base_thickness"] + result["pocket_depth"]
    return result


def flat_surface(mesh: trimesh.Trimesh, z: float, sign: int) -> Polygon:
    sel = ((np.abs(mesh.face_normals[:, 2] - sign) < 1e-7) &
           (np.abs(mesh.triangles_center[:, 2] - z) < 1e-5))
    faces = [Polygon(t[:, :2]) for t in mesh.triangles[sel]]
    require(bool(faces), f"No exterior planar faces at z={z}")
    poly = unary_union(faces)
    require(poly.geom_type == "Polygon" and poly.is_valid,
            f"Disconnected or invalid exterior surface at z={z}")
    return poly


def slice_surface(mesh: trimesh.Trimesh, z: float, expected_holes: int = 217) -> Polygon:
    section = mesh.section(plane_normal=[0, 0, 1], plane_origin=[0, 0, z])
    require(section is not None, f"Empty section at z={z}")
    rings = [Polygon(p[:, :2]) for p in section.discrete]
    require(all(p.is_valid for p in rings), f"Invalid section at z={z}")
    rings.sort(key=lambda p: p.area, reverse=True)
    require(len(rings) == expected_holes + 1, f"Expected exterior plus {expected_holes} holes at z={z}")
    outer, holes = rings[0], rings[1:]
    require(all(outer.contains(p) for p in holes), f"Open/misplaced cavity at z={z}")
    require(all(a.disjoint(b) for a, b in itertools.combinations(holes, 2)),
            f"Intersecting cavities at z={z}")
    return Polygon(outer.exterior, [p.exterior for p in holes])


def surface_metrics(poly: Polygon, minimum: float, expected_holes: int = 217) -> dict:
    holes = [Polygon(h) for h in poly.interiors]
    require(len(holes) == expected_holes, f"Expected {expected_holes} holes on the surface")
    pairs = [(a.distance(b), i, j) for i, a in enumerate(holes)
             for j, b in enumerate(holes) if j > i]
    gap, i, j = min(pairs)
    rim = min(poly.exterior.distance(p) for p in holes)
    core = poly.buffer(-minimum / 2)
    return {
        "minimum_inter_pocket_web_mm": float(gap),
        "minimum_pocket_to_exterior_mm": float(rim),
        "narrowest_pair_centres_xy_mm": [list(holes[k].centroid.coords[0]) for k in (i, j)],
        "connected_after_half_minimum_erosion": bool(core.geom_type == "Polygon" and not core.is_empty),
        "hole_count": len(holes),
        "surface_area_mm2": float(poly.area),
    }


def analyse(mesh_path: Path, source_path: Path) -> dict:
    c = settings(source_path)
    R = int(c["ring_count"])
    expected_holes = 1 + 3 * R * (R + 1)
    require(len(c["tilt_angles"]) == R + 1, "Missing or extra tilt bands")
    require(c["tilt_angles"] == list(range(0, 4 * R + 1, 4)), "Incorrect tilt progression")
    minimum = float(c["min_surface_feature"])
    require(minimum >= 1.3, "The 1.3 mm rule must not be weakened")
    mesh = trimesh.load_mesh(mesh_path, process=True)
    require(isinstance(mesh, trimesh.Trimesh), "Not a triangle mesh")
    require(mesh.is_watertight and mesh.is_volume, "Mesh is not a closed positive volume")
    require(len(mesh.split(only_watertight=False)) == 1, "Disconnected mesh components")
    require(mesh.euler_number == 2 - 2 * expected_holes, "Unexpected through-hole topology")
    require(abs(mesh.bounds[0, 2]) < 1e-5 and abs(mesh.bounds[1, 2] - c["height"]) < 1e-5,
            "Mesh must be in upright/use orientation, z=0 to body height")

    top = surface_metrics(flat_surface(mesh, c["height"], 1), minimum, expected_holes)
    bottom = surface_metrics(flat_surface(mesh, 0, -1), minimum, expected_holes)
    for name, metrics in (("top", top), ("bottom", bottom)):
        require(metrics["minimum_inter_pocket_web_mm"] >= minimum - 0.001, f"{name} web < 1.3 mm")
        require(metrics["minimum_pocket_to_exterior_mm"] >= minimum - 0.001, f"{name} outer rim < 1.3 mm")
        require(metrics["connected_after_half_minimum_erosion"], f"{name} has a sub-minimum neck")

    # Actual mesh: 0.2 mm layers throughout plus dense checks at both exposed
    # surfaces, at the floor transitions and at the entrance-chamfer break.
    zs = np.unique(np.r_[np.arange(0.1, c["height"], 0.2),
        0.001, 0.05, 0.25, 0.5, 0.999, 1.001, 1.999, 2.001,
        c["height"]-c["pocket_mouth_chamfer_h"],
        c["height"]-0.5, c["height"]-0.25, c["height"]-0.05, c["height"]-0.001])
    rows = []
    for z in zs:
        metrics = surface_metrics(slice_surface(mesh, float(z), expected_holes), minimum, expected_holes)
        require(metrics["minimum_inter_pocket_web_mm"] >= minimum - 0.001, f"Thin web at z={z}")
        require(metrics["minimum_pocket_to_exterior_mm"] >= minimum - 0.001, f"Thin external wall at z={z}")
        require(metrics["connected_after_half_minimum_erosion"], f"Narrow neck at z={z}")
        rows.append({"z_mm": float(z), **metrics})

    # Independent checks of true tilt and 7 mm AF fit from two shaft sections.
    qrs = [(q, r) for q in range(-R, R + 1) for r in range(-R, R + 1)
           if max(abs(q), abs(r), abs(q+r)) <= R]
    at3 = [Polygon(p) for p in slice_surface(mesh, 3, expected_holes).interiors]
    at11 = [Polygon(p) for p in slice_surface(mesh, 11, expected_holes).interiors]
    angle_errors, af_errors = [], []
    centre_errors, direction_errors = [], []
    matched3, matched11 = set(), set()
    ring_records = []
    angles = np.radians(np.arange(3)*60 + c["shaft_hex_rotation"]-30)
    flat_normals = np.column_stack([np.cos(angles), np.sin(angles)])
    for q, r in qrs:
        ring = max(abs(q), abs(r), abs(q+r))
        degrees = c["tilt_angles"][ring]
        a = math.radians(degrees)
        origin = c["pitch"]*np.array([q+r/2, math.sqrt(3)*r/2])
        u = origin / np.linalg.norm(origin) if ring else np.zeros(2)
        expected = [origin + (z-c["base_thickness"])*math.tan(a)*u for z in (3, 11)]
        ps = [min(holes, key=lambda p: np.linalg.norm(np.array(p.centroid.coords[0])-point))
              for holes, point in zip((at3, at11), expected)]
        matched3.add(next(i for i, p in enumerate(at3) if p is ps[0]))
        matched11.add(next(i for i, p in enumerate(at11) if p is ps[1]))
        centres = [np.array(p.centroid.coords[0]) for p in ps]
        centre_errors.extend(float(np.linalg.norm(measured - target)) for measured, target in zip(centres, expected))
        displacement = centres[1] - centres[0]
        expected_displacement = 8 * math.tan(a) * u
        direction_errors.append(float(np.linalg.norm(displacement - expected_displacement)))
        measured = math.degrees(math.atan2(np.linalg.norm(centres[1]-centres[0]), 8))
        angle_errors.append(abs(measured-degrees))
        # Undo horizontal sec(theta) projection to recover normal-axis hex AF.
        inv = np.eye(2)+(math.cos(a)-1)*np.outer(u, u)
        local = (np.asarray(ps[0].exterior.coords) - centres[0]) @ inv.T
        widths = np.ptp(local @ flat_normals.T, axis=0)
        af_errors.extend(abs(widths-c["hex_flat_to_flat"]))
        ring_records.append({"q": q, "r": r, "ring": ring,
                             "specified_tilt_degrees": degrees, "measured_tilt_degrees": measured,
                             "normal_axis_AF_mm": widths.tolist()})
    require(len(matched3) == expected_holes and len(matched11) == expected_holes, "Pocket matching is not one-to-one")
    require(max(centre_errors) < 0.002, "Pocket centres do not match the specified lattice and splay")
    require(max(direction_errors) < 0.002, "Pocket axis is not radially outward")
    require(max(angle_errors) < 0.005, "Pocket tilt differs from its specified ring angle")
    require(max(af_errors) < 0.002, "Normal-axis pocket fit or hex roll changed unexpectedly")

    # For top-face-down printing, normals which point upward in use orientation
    # become downward-facing. Report entrance overhang relative to VERTICAL
    # (0 degrees vertical, 90 degrees horizontal), not relative to the bed plane.
    ztri = mesh.triangles[:, :, 2]
    entrance_mask = ((ztri.min(axis=1) >= c["height"] - c["pocket_mouth_chamfer_h"] - 0.0001) &
                     (ztri.max(axis=1) <= c["height"] + 0.0001) &
                     (np.ptp(ztri, axis=1) > 0.0001))
    entrance_normals = mesh.face_normals[entrance_mask]
    require(len(entrance_normals) == expected_holes * 12,
            "Expected six triangulated continuous bevel faces per pocket")
    overhangs = np.degrees(np.arcsin(np.clip(entrance_normals[:, 2], -1, 1)))
    require(float(overhangs.max()) <= 70.0, "Entrance bevel exceeds experimental 70-degree ceiling")

    return {
        "status": "PASS", "validation_scope": "Geometry; slicer toolpaths and physical print acceptance pending",
        "source_sha256": hashlib.sha256(source_path.read_bytes()).hexdigest(),
        "mesh_sha256": hashlib.sha256(mesh_path.read_bytes()).hexdigest(),
        "settings": c,
        "mesh": {"watertight": True, "positive_volume": True, "connected_components": 1,
                 "euler_number": int(mesh.euler_number), "triangles": int(len(mesh.faces)),
                 "envelope_mm": mesh.extents.tolist(), "volume_mm3": float(mesh.volume)},
        "top_face": top, "bottom_face": bottom,
        "sampled_sections": {"count": len(rows),
            "minimum_inter_pocket_web_mm": min(x["minimum_inter_pocket_web_mm"] for x in rows),
            "minimum_pocket_to_exterior_mm": min(x["minimum_pocket_to_exterior_mm"] for x in rows),
            "all_connected_after_half_minimum_erosion": True},
        "functional_checks": {"pockets_checked": len(qrs), "maximum_tilt_error_degrees": float(max(angle_errors)),
                              "maximum_normal_AF_error_mm": float(max(af_errors)),
                              "maximum_centre_error_mm": max(centre_errors),
                              "maximum_radial_displacement_error_mm": max(direction_errors),
                              "one_to_one_pocket_assignment": True},
        "entrance_chamfer_checks": {
            "triangles_checked": int(len(entrance_normals)),
            "maximum_overhang_from_vertical_degrees": float(overhangs.max()),
            "minimum_overhang_from_vertical_degrees": float(overhangs.min()),
            "under_60_degree_soft_limit": bool(overhangs.max() <= 60),
            "angle_definition": "Face-down print: vertical = 0 degrees; horizontal unsupported ceiling = 90 degrees.",
            "scope": "Entrance chamfer faces only, not all external side-panel surfaces."},
        "dependencies": {"numpy": np.__version__, "shapely": shapely.__version__, "trimesh": trimesh.__version__},
        "sections": rows,
        "pocket_measurements": ring_records,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    here = Path(__file__).resolve().parent
    parser.add_argument("--source", type=Path, default=here/"hex_bit_stand_continuous_web_217_v19.scad")
    parser.add_argument("--mesh", type=Path, default=here/"hex_bit_stand_continuous_web_217_v19.stl")
    parser.add_argument("--output", type=Path, default=here/"validation.json")
    args = parser.parse_args()
    try:
        report = analyse(args.mesh, args.source)
        args.output.write_text(json.dumps(report, indent=2)+"\n", encoding="utf-8")
        print(json.dumps({k: v for k, v in report.items() if k not in ("sections", "pocket_measurements")}, indent=2))
        return 0
    except (ValueError, OSError, KeyError) as exc:
        print(f"FAIL: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
