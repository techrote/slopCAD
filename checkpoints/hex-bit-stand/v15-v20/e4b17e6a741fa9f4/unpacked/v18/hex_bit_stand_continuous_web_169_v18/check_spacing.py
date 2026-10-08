#!/usr/bin/env python3
"""Independent planar spacing check and an exported-mesh negative control.

Builds a temporary 9.65 mm-pitch model and confirms that the retained 1.3 mm
surface-width validator rejects it. The printable production files are not edited.
"""
from __future__ import annotations
import argparse, hashlib, json, math, shutil, subprocess, sys, tempfile
from pathlib import Path
import numpy as np
from shapely.geometry import Polygon
import trimesh
from validate import require, settings, flat_surface, surface_metrics

HERE=Path(__file__).resolve().parent
STEM='hex_bit_stand_continuous_web_169_v18'

def planar_gap(pitch: float, ring_count: int=7) -> dict:
    angles=np.radians(30+np.arange(6)*60)
    vertices=8.5/math.sqrt(3)*np.column_stack([np.cos(angles),np.sin(angles)])
    polygons=[]
    qrs=[]
    for q in range(-ring_count,ring_count+1):
        for r in range(-ring_count,ring_count+1):
            k=max(abs(q),abs(r),abs(q+r))
            if k>ring_count:
                continue
            t=math.radians(4*k)
            origin=pitch*np.array([q+r/2,math.sqrt(3)*r/2])
            u=origin/np.linalg.norm(origin) if k else np.zeros(2)
            centre=origin+12*math.tan(t)*u
            # Independent form of the plane intersection of a tilted regular hex.
            A=np.eye(2)+(1/math.cos(t)-1)*np.outer(u,u)
            polygons.append(Polygon(centre+vertices@A.T))
            qrs.append((q,r))
    gap,i,j=min((p.distance(o),i,j) for i,p in enumerate(polygons)
                for j,o in enumerate(polygons) if j>i)
    return {'pitch_mm':pitch,'minimum_top_gap_mm':float(gap),
            'limiting_pair_axial_coordinates':[qrs[i],qrs[j]]}

def main() -> int:
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--openscad',default=shutil.which('openscad.com') or shutil.which('openscad'))
    args=parser.parse_args()
    if not args.openscad:
        parser.error('OpenSCAD is required for the negative control.')
    source=HERE/(STEM+'.scad')
    cfg=settings(source)
    sweep=[planar_gap(p) for p in (9.65,9.75,9.80,9.85,9.90,9.95)]
    selected=planar_gap(cfg['pitch'])
    full=trimesh.load_mesh(HERE/(STEM+'.stl'),process=True)
    observed=surface_metrics(flat_surface(full,cfg['height'],1),cfg['min_surface_feature'],169)
    require(abs(observed['minimum_inter_pocket_web_mm']-selected['minimum_top_gap_mm'])<0.0002,
            'Analytic and actual exported-model spacing disagree')
    text=source.read_text()
    old=text.replace('pitch = 9.90;','pitch = 9.65;').replace('pitch>=9.90','pitch>=9.65')
    require(old!=text,'Failed to form old-spacing negative control')
    with tempfile.TemporaryDirectory(prefix='hex_v18_spacing_') as folder:
        temp=Path(folder)
        negsource=temp/'old_spacing.scad'
        negmesh=temp/'old_spacing.stl'
        negsource.write_text(old)
        proc=subprocess.run([args.openscad,'-o',str(negmesh),str(negsource)],
                            capture_output=True,text=True,timeout=90)
        require(proc.returncode==0,'Old-spacing mesh failed to render, not a useful negative control')
        (HERE/'evidence/negative_spacing_build.log').write_text(proc.stdout+proc.stderr)
        measured=surface_metrics(flat_surface(trimesh.load_mesh(negmesh),14,1),1.3,169)
        validation=subprocess.run([sys.executable,str(HERE/'validate.py'),
                                   '--source',str(negsource),'--mesh',str(negmesh),
                                   '--output',str(temp/'negative_validation.json')],
                                  capture_output=True,text=True,timeout=60)
        reason=(validation.stdout+validation.stderr).strip()
        require(validation.returncode==1 and 'top web < 1.3 mm' in reason,
                'Negative control was not rejected for top-web width')
        require(abs(measured['minimum_inter_pocket_web_mm']-sweep[0]['minimum_top_gap_mm'])<0.0002,
                'Old-spacing analytic and exported gaps disagree')
        result={'status':'PASS','source_sha256':hashlib.sha256(source.read_bytes()).hexdigest(),
                'pitch_sweep_analytic':sweep,
                'selected_pitch_mesh_gap_mm':observed['minimum_inter_pocket_web_mm'],
                'negative_control':{'pitch_mm':9.65,'source_sha256':hashlib.sha256(old.encode()).hexdigest(),
                                    'mesh_gap_mm':measured['minimum_inter_pocket_web_mm'],
                                    'validator_returncode':validation.returncode,'validator_output':reason,
                                    'rejected_as_expected':True},
                'note':'Only the pitch guard was relaxed in the temporary negative source; the 1.3 mm measurement rule remained enabled.'}
    (HERE/'spacing_checks.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result,indent=2))
    return 0

if __name__=='__main__':
    raise SystemExit(main())
