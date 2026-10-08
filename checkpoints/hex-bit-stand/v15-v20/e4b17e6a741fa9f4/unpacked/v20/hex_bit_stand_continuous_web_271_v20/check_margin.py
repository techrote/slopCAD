#!/usr/bin/env python3
"""Confirm the inherited 3.8 mm outer margin is insufficient for the 36 degree ring.

Renders a temporary old-margin model. The production model is left untouched.
The same 1.3 mm mesh validator must reject it for exterior-wall clearance.
"""
from __future__ import annotations
import argparse
import hashlib
import json
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import trimesh
from validate import require, settings, slice_surface, surface_metrics

HERE=Path(__file__).resolve().parent
STEM='hex_bit_stand_continuous_web_271_v20'

def main() -> int:
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--openscad',default=shutil.which('openscad.com') or shutil.which('openscad'))
    args=parser.parse_args()
    if not args.openscad:
        parser.error('OpenSCAD is required for the negative control.')
    source=HERE/(STEM+'.scad')
    cfg=settings(source)
    text=source.read_text()
    require(text.count('wall_margin = 4.1;')==1,'Could not locate the production margin parameter')
    candidate=text.replace('wall_margin = 4.1;','wall_margin = 3.8;')
    with tempfile.TemporaryDirectory(prefix='hex_v20_margin_') as tmp:
        folder=Path(tmp)
        scad=folder/'old_margin.scad'; mesh=folder/'old_margin.stl'
        scad.write_text(candidate)
        proc=subprocess.run([args.openscad,'--export-format','binstl','-o',str(mesh),str(scad)],
                            capture_output=True,text=True,timeout=240)
        (HERE/'evidence/negative_margin_build.log').write_text(proc.stdout+proc.stderr)
        require(proc.returncode==0,'Negative-margin mesh did not render')
        trial=trimesh.load_mesh(mesh,process=True)
        production=trimesh.load_mesh(HERE/(STEM+'.stl'),process=True)
        # Probe near the upper end of the flat backs of the recessed side panels.
        zs=[9.1,9.2,9.3,9.4,9.45,9.47,9.5,9.6,9.7,9.8]
        rows=[]
        for z in zs:
            a=surface_metrics(slice_surface(trial,z,271),1.3,271)
            b=surface_metrics(slice_surface(production,z,271),1.3,271)
            rows.append({'z_mm':z,'old_margin_wall_mm':a['minimum_pocket_to_exterior_mm'],
                         'new_margin_wall_mm':b['minimum_pocket_to_exterior_mm']})
        negative=subprocess.run([sys.executable,str(HERE/'validate.py'),'--source',str(scad),
                                 '--mesh',str(mesh),'--output',str(folder/'validation.json')],
                                capture_output=True,text=True,timeout=120)
        reason=(negative.stdout+negative.stderr).strip()
        require(negative.returncode==1 and
                ('Thin external wall' in reason or 'Narrow neck' in reason),
                'Old margin was not rejected for the expected local wall weakness: '+reason)
        require(min(row['old_margin_wall_mm'] for row in rows)<1.3,'Old-margin witness is not below 1.3 mm')
        require(min(row['new_margin_wall_mm'] for row in rows)>=1.3,'New-margin witness fails')
        result={'status':'PASS','production_source_sha256':hashlib.sha256(text.encode()).hexdigest(),
                'negative_control_source_sha256':hashlib.sha256(candidate.encode()).hexdigest(),
                'inherited_margin_mm':3.8,'production_margin_mm':cfg['wall_margin'],
                'witness_sections':rows,'validator_returncode':negative.returncode,
                'validator_output':reason,'rejected_as_expected':True,
                'note':'Only wall_margin changed; 36 degree tilt, 10.55 mm pitch, 3 mm cutter reach and 1.3 mm width rule retained.'}
    (HERE/'margin_checks.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result,indent=2))
    return 0

if __name__=='__main__':
    try:
        raise SystemExit(main())
    except (ValueError,OSError,subprocess.SubprocessError) as error:
        print('Margin check failed:',error,file=sys.stderr)
        raise SystemExit(1)
