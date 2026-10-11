#!/usr/bin/env python3
"""Structural/file checks for the published SweepHex 140 XL model."""
import json
from pathlib import Path
import numpy as np
import trimesh
import ezdxf
from PIL import Image

HERE = Path(__file__).resolve().parent
STEM = 'sweephex140_flat_doublehex_chamfer1'
meta = json.loads((HERE / (STEM + '.json')).read_text())
assert meta['measurements']['hex_apertures'] == 43
assert meta['measurements']['midplane_hole_count'] == 47
assert meta['measurements']['face_hole_count'] == 47

for suffix in ('.stl', '.3mf'):
    obj = trimesh.load(HERE / (STEM + suffix), force='mesh', process=True)
    assert isinstance(obj, trimesh.Trimesh), (suffix, type(obj))
    assert obj.is_watertight, suffix
    assert obj.is_winding_consistent, suffix
    assert len(obj.split(only_watertight=False)) == 1, suffix
    assert obj.euler_number == -92, (suffix, obj.euler_number)
    np.testing.assert_allclose(obj.extents, [140, 140, 6], atol=0.001)
    np.testing.assert_allclose(obj.volume, 44279.7084, rtol=0.0001)
    print(f'{suffix}: {len(obj.faces):,} faces, volume {obj.volume:.2f} mm³, watertight')

dxf = ezdxf.readfile(HERE / (STEM + '.dxf'))
for layer in ('MID_OUTER', 'MID_OPENINGS', 'FACE_OUTER', 'FACE_OPENINGS'):
    assert layer in dxf.layers, layer
assert (HERE / (STEM + '.scad')).read_text().count('import(') >= 1
for name in ('printed-front.jpg', 'printed-oblique.jpg'):
    with Image.open(HERE / 'assets' / name) as im:
        im.verify()
    with Image.open(HERE / 'assets' / name) as im:
        assert im.width >= 1000 and im.height >= 950, name
print('DXF profiles, SCAD wrapper and two resized photos: PASS')
