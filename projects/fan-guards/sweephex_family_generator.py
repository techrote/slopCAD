#!/usr/bin/env python3
"""Generate large-aperture SweepHex fan guards for 120, 92, 80 and 60 mm fans.

Derived from the physically printed SweepHex 140 XL geometry. Each variant keeps a
6 mm flat plate, strong anticlockwise radial sweep, nominal 3.3 mm mid-plane webs,
1 mm x 45 degree chamfers on all airflow apertures, and the fan size's standard
mounting pitch. The compact variants retain the 1 mm outside chamfer except for smooth local
relief around mounting bosses, while mount-hole face bevel width is reduced where
a full 1+1 mm pair would collide with standard mounting geometry.

Positive sweep is anticlockwise viewed from +Z / the presented face.
"""
from __future__ import annotations
from dataclasses import dataclass, asdict
from pathlib import Path
import argparse, json, math
import numpy as np
import trimesh
from shapely import constrained_delaunay_triangles, unary_union
from shapely.geometry import Point, Polygon, box

@dataclass(frozen=True)
class Settings:
    overall_side: float
    fan_mount_pitch: float
    outer_face_chamfer_xy: float
    mount_face_chamfer_xy: float
    mount_edge_face_ligament_min: float = 1.3
    total_depth: float = 6.0
    bevel_height: float = 1.0
    airflow_face_chamfer_xy: float = 1.0
    corner_xy_chamfer: float = 1.0
    mounting_hole_diameter: float = 4.7
    mount_solid_keepout_radius: float = 6.35
    square_frame_width: float = 3.3
    hex_tile_circumradius: float = 13.6
    half_web_width: float = 1.65
    anticlockwise_sweep_degrees_at_reference: float = 105.0
    sweep_reference_radius: float = 76.0
    sweep_exponent: float = 1.2
    hex_edge_samples: int = 12
    min_aperture_area_mm2: float = 18.0
    mounting_circle_quadrant_segments: int = 48
    bevel_corner_quadrant_segments: int = 6

PRESETS = {
    120: Settings(120.0, 105.0, 1.0, 1.0, sweep_reference_radius=76.0*120.0/140.0),
    92:  Settings(92.0, 82.5, 1.0, 0.8, sweep_reference_radius=76.0*92.0/140.0),
    80:  Settings(80.0, 71.5, 1.0, 0.5, sweep_reference_radius=76.0*80.0/140.0),
    60:  Settings(60.0, 50.0, 1.0, 0.9, sweep_reference_radius=76.0*60.0/140.0),
}

def mount_centres(s):
    h=s.fan_mount_pitch/2
    return [(x*h,y*h) for x in (-1,1) for y in (-1,1)]

def swirl(x,y,s):
    r=np.hypot(x,y)
    d=math.radians(s.anticlockwise_sweep_degrees_at_reference)*np.power(r/s.sweep_reference_radius,s.sweep_exponent)
    a=np.arctan2(y,x)+d
    return r*np.cos(a),r*np.sin(a)

def outline(s):
    h=s.overall_side/2;c=s.corner_xy_chamfer
    return Polygon([(-h+c,-h),(h-c,-h),(h,-h+c),(h,h-c),(h-c,h),(-h+c,h),(-h,h-c),(-h,-h+c)])

def aperture_polygons(s):
    half=s.overall_side/2
    allowed=box(-half+s.square_frame_width,-half+s.square_frame_width,half-s.square_frame_width,half-s.square_frame_width)
    keepouts=[Point(x,y).buffer(s.mount_solid_keepout_radius,quad_segs=48) for x,y in mount_centres(s)]
    allowed=allowed.difference(unary_union(keepouts))
    R=s.hex_tile_circumradius; px=math.sqrt(3)*R; py=1.5*R
    generated_radius=math.sqrt(2)*half+R+6
    n=int(math.ceil(generated_radius/min(px,py)))+2
    verts=np.column_stack((np.cos(np.deg2rad(np.arange(7)*60+30)),np.sin(np.deg2rad(np.arange(7)*60+30))))*R
    frac=np.arange(s.hex_edge_samples)/s.hex_edge_samples
    boundary=np.vstack([(1-t)*verts[k]+t*verts[k+1] for k in range(6) for t in frac])
    holes=[]
    for row in range(-n,n+1):
        for col in range(-n,n+1):
            cx=px*(col+row/2);cy=py*row
            if math.hypot(cx,cy)>generated_radius: continue
            X,Y=swirl(boundary[:,0]+cx,boundary[:,1]+cy,s)
            raw=Polygon(np.column_stack((X,Y)))
            if not raw.is_valid: raise RuntimeError(f'invalid warped cell at {cx},{cy}')
            raw=raw.buffer(-s.half_web_width,join_style='round',quad_segs=8)
            if raw.is_empty: continue
            clipped=raw.intersection(allowed)
            pieces=[clipped] if clipped.geom_type=='Polygon' else list(getattr(clipped,'geoms',[]))
            for p in pieces:
                if p.geom_type=='Polygon' and p.is_valid and p.area>=s.min_aperture_area_mm2 and not p.interiors:
                    holes.append(p)
    return holes

def construct_profiles(s):
    if s.total_depth<=2*s.bevel_height: raise ValueError('depth too small')
    if s.half_web_width<=s.airflow_face_chamfer_xy: raise ValueError('airflow chamfer consumes web')
    holes=aperture_polygons(s)
    mounts=[Point(x,y).buffer(s.mounting_hole_diameter/2,quad_segs=s.mounting_circle_quadrant_segments) for x,y in mount_centres(s)]
    mid_outer=outline(s)
    middle=mid_outer.difference(unary_union(holes+mounts))
    if middle.geom_type!='Polygon' or not middle.is_valid: raise RuntimeError('middle slice disconnected')
    # Keep the full 1 mm outside chamfer along the perimeter, but locally
    # relax that inset around compact mounting bosses. A full 1 mm outer
    # chamfer plus a full mounting-hole chamfer cannot coexist at the 80 mm
    # standard pitch while retaining the repository's 1.3 mm face ligament.
    face_outer=mid_outer.buffer(-s.outer_face_chamfer_xy,join_style='round',quad_segs=s.bevel_corner_quadrant_segments)
    mount_face_radius=s.mounting_hole_diameter/2+s.mount_face_chamfer_xy
    boss_face_radius=mount_face_radius+s.mount_edge_face_ligament_min
    boss_reliefs=unary_union([Point(x,y).buffer(boss_face_radius,quad_segs=s.mounting_circle_quadrant_segments)
                              for x,y in mount_centres(s)])
    face_outer=unary_union([face_outer,boss_reliefs]).intersection(mid_outer)
    if face_outer.geom_type!='Polygon' or not face_outer.is_valid:
        raise RuntimeError(f'outer face relief disconnected: {face_outer.geom_type}')
    face_holes=[h.buffer(s.airflow_face_chamfer_xy,join_style='round',quad_segs=s.bevel_corner_quadrant_segments) for h in holes]
    face_mounts=[Point(x,y).buffer(mount_face_radius,quad_segs=s.mounting_circle_quadrant_segments) for x,y in mount_centres(s)]
    face=face_outer.difference(unary_union(face_holes+face_mounts))
    if face.geom_type!='Polygon' or not face.is_valid: raise RuntimeError(f'face slice disconnected: {face.geom_type}')
    expected=len(holes)+4
    if len(middle.interiors)!=expected or len(face.interiors)!=expected:
        raise RuntimeError(f'opening count changed {len(middle.interiors)} / {len(face.interiors)} expected {expected}')
    if not middle.buffer(1e-8).contains(face): raise RuntimeError('face not contained in middle')
    band=middle.difference(face)
    if band.is_empty or not band.is_valid: raise RuntimeError('invalid bevel band')
    return middle,face,band,holes

def triangulate(p):
    c=constrained_delaunay_triangles(p)
    if c.is_empty: raise RuntimeError('empty triangulation')
    for tri in c.geoms:
        q=np.asarray(tri.exterior.coords[:3],dtype=np.float64)
        if len(q)!=3: continue
        signed=(q[1,0]-q[0,0])*(q[2,1]-q[0,1])-(q[1,1]-q[0,1])*(q[2,0]-q[0,0])
        if signed<0:q[[1,2]]=q[[2,1]]
        if abs(signed)>1e-12: yield q

def contour_vertices(p):
    for ring in [p.exterior,*p.interiors]: yield np.asarray(ring.coords[:-1],dtype=np.float64)

def build_mesh(s,middle,face,band):
    vertices=[];faces=[];lookup={}
    def vertex(xy,z):
        p=(round(float(xy[0]),9),round(float(xy[1]),9),round(float(z),9));k=lookup.get(p)
        if k is None:k=len(vertices);lookup[p]=k;vertices.append(p)
        return k
    def tri(points,z,reverse=False):
        inds=[vertex(pt,v) for pt,v in zip(points,z)]
        if reverse:inds.reverse()
        if len(set(inds))==3:faces.append(tuple(inds))
    lo=s.bevel_height;hi=s.total_depth-s.bevel_height;H=s.total_depth
    for t in triangulate(face):
        tri(t,[0,0,0],True);tri(t,[H,H,H])
    face_xy={tuple(round(float(v),9) for v in p) for ring in contour_vertices(face) for p in ring}
    mid_xy={tuple(round(float(v),9) for v in p) for ring in contour_vertices(middle) for p in ring}
    if face_xy.intersection(mid_xy): raise RuntimeError('coincident middle/face points')
    for t in triangulate(band):
        zones=[]
        for pt in t:
            key=(round(float(pt[0]),9),round(float(pt[1]),9))
            if key in face_xy:zones.append(0)
            elif key in mid_xy:zones.append(1)
            else:raise RuntimeError(f'unclassified bevel point {key}')
        tri(t,[0 if b==0 else lo for b in zones],True)
        tri(t,[H if b==0 else hi for b in zones])
    for ring in contour_vertices(middle):
        n=len(ring)
        for i in range(n):
            a=ring[i];b=ring[(i+1)%n]
            u=vertex(a,lo);v=vertex(b,lo);U=vertex(a,hi);V=vertex(b,hi)
            if u!=v: faces.extend([(u,V,v),(u,U,V)])
    mesh=trimesh.Trimesh(vertices=np.asarray(vertices),faces=np.asarray(faces),process=True,validate=False)
    parts=mesh.split(only_watertight=False)
    check={'watertight':bool(mesh.is_watertight),'consistent_winding':bool(mesh.is_winding_consistent),'components':len(parts),'volume_mm3':float(mesh.volume),'bounds_mm':mesh.bounds.tolist(),'vertices':len(mesh.vertices),'faces':len(mesh.faces),'euler_number':int(mesh.euler_number)}
    if not check['watertight'] or not check['consistent_winding'] or len(parts)!=1 or mesh.volume<=0: raise RuntimeError('mesh validation failed '+json.dumps(check))
    if not np.allclose(mesh.extents,[s.overall_side,s.overall_side,s.total_depth],atol=1e-4): raise RuntimeError('wrong bounds '+str(mesh.extents))
    return mesh,check

def create_dxf(middle,face,path):
    import ezdxf
    d=ezdxf.new('R2010');d.header['$INSUNITS']=4
    for name,color in [('MID_OUTER',7),('MID_OPENINGS',4),('FACE_OUTER',3),('FACE_OPENINGS',2)]: d.layers.new(name,dxfattribs={'color':color})
    ms=d.modelspace()
    for geom,outer,holes in [(middle,'MID_OUTER','MID_OPENINGS'),(face,'FACE_OUTER','FACE_OPENINGS')]:
        ms.add_lwpolyline(list(geom.exterior.coords[:-1]),close=True,dxfattribs={'layer':outer})
        for r in geom.interiors: ms.add_lwpolyline(list(r.coords[:-1]),close=True,dxfattribs={'layer':holes})
    d.saveas(path)

def generate(size,outdir):
    s=PRESETS[size];outdir=Path(outdir);outdir.mkdir(parents=True,exist_ok=True)
    stem=f'sweephex{size}_xl_chamfered'
    middle,face,band,holes=construct_profiles(s)
    mesh,validation=build_mesh(s,middle,face,band)
    stl=outdir/(stem+'.stl');mesh.export(stl)
    import trimesh.exchange.threemf as tmf
    (outdir/(stem+'.3mf')).write_bytes(tmf.export_3MF(mesh))
    create_dxf(middle,face,outdir/(stem+'.dxf'))
    edge_mid=s.overall_side/2-s.fan_mount_pitch/2-s.mounting_hole_diameter/2
    global_edge_face=edge_mid-s.outer_face_chamfer_xy-s.mount_face_chamfer_xy
    edge_face=max(global_edge_face,s.mount_edge_face_ligament_min)
    local_outer_inset=max(0.0,edge_mid-s.mount_face_chamfer_xy-edge_face)
    metrics={
      'fan_size_mm':size,'hex_apertures':len(holes),'mount_holes':4,
      'midplane_open_fraction_full_square':float(1-middle.area/(s.overall_side*s.overall_side)),
      'face_open_fraction_full_square':float(1-face.area/(s.overall_side*s.overall_side)),
      'mount_edge_ligament_midplane_mm':edge_mid,'mount_edge_ligament_face_nominal_mm':edge_face,
      'outer_face_chamfer_xy_global_mm':s.outer_face_chamfer_xy,
      'mount_boss_local_outer_inset_mm':local_outer_inset,
      'nominal_midplane_web_mm':2*s.half_web_width,
      'nominal_face_web_between_airflow_apertures_mm':2*(s.half_web_width-s.airflow_face_chamfer_xy),
      'estimated_PLA_grams_at_1p24':float(mesh.volume/1000*1.24),
      'supports_required':'no; print either broad face down',
      'swirl':f'105 degrees CCW at {s.sweep_reference_radius:.3f} mm reference radius, +Z view',
      'mount_centres_mm':mount_centres(s),
      'note':'Airflow apertures and most of the perimeter retain 1x1 mm chamfers. The perimeter chamfer relaxes smoothly only around compact mounting bosses, and the mounting-hole bevel width is reduced where required to preserve at least the target face ligament.'}
    (outdir/(stem+'.json')).write_text(json.dumps({'settings':asdict(s),'measurements':metrics,'validation':validation},indent=2))
    (outdir/(stem+'.scad')).write_text(
        f'// SweepHex {size} XL OpenSCAD convenience wrapper.\n'
        '// The authoritative parametric source is ../sweephex_family_generator.py.\n'
        '// This wrapper imports the validated committed STL in millimetres.\n'
        f'import("{stem}.stl", convexity=10);\n')
    readme=f'''# SweepHex {size} XL — 6 mm vortex fan guard

Unprinted size variant of the physically printed and installed [SweepHex 140 XL](../sweephex-140-xl/), preserving the same flat large-aperture swept-hex design language and anticlockwise vortex direction.

## Files

| File | Purpose |
| --- | --- |
| [3MF]({stem}.3mf) | Slicer-ready mesh, millimetres |
| [STL]({stem}.stl) | Printable watertight mesh |
| [DXF]({stem}.dxf) | Mid-plane and face profiles on named layers |
| [JSON]({stem}.json) | Exact settings, measurements and mesh validation |
| [OpenSCAD wrapper]({stem}.scad) | Imports the committed STL |
| [Shared parametric generator](../sweephex_family_generator.py) | Authoritative source for the 120/92/80/60 mm variants |

## Dimensions

| Parameter | Value |
| --- | ---: |
| Overall size | **{size} × {size} × 6 mm** |
| Mounting-hole pitch | **{s.fan_mount_pitch} × {s.fan_mount_pitch} mm** |
| Through-hole diameter | **Ø{s.mounting_hole_diameter} mm** |
| Main swept airflow apertures | **{metrics['hex_apertures']}** |
| Mid-plane projected open fraction | **{metrics['midplane_open_fraction_full_square']*100:.1f}%** |
| Sweep | **105° anticlockwise** at r = {s.sweep_reference_radius:.3f} mm, +Z view |
| Airflow-aperture chamfer | **1 × 1 mm**, both broad faces |
| Nominal middle web | **{metrics['nominal_midplane_web_mm']:.1f} mm** |
| Nominal broad-face airflow web | **{metrics['nominal_face_web_between_airflow_apertures_mm']:.1f} mm** |
| Nominal face ligament at nearest mount/outer edge | **{metrics['mount_edge_ligament_face_nominal_mm']:.2f} mm** |

The main aperture radius is deliberately kept at 13.6 mm across the family rather than scaling all holes down. This keeps the compact variants open and visually related to the printed 140 XL instead of turning the smaller guards into dense restrictive meshes.

### Compact-frame bevel accommodation

Airflow apertures retain the full 1 mm × 45° bevel, and the outer perimeter also keeps its full 1 mm × 45° chamfer away from the mounting bosses. Standard mounting positions leave much less material between a bolt hole and the outer edge on compact fan frames, so the perimeter chamfer **relaxes only around each mounting boss** and the mounting-hole bevel width is reduced where necessary. This preserves at least about 1.3 mm nominal material at the nearest mount-to-edge section.

- normal outer perimeter chamfer width: **{s.outer_face_chamfer_xy} mm**
- local outer inset beside the mounting boss: **{metrics['mount_boss_local_outer_inset_mm']:.2f} mm**
- mounting-hole bevel width: **{s.mount_face_chamfer_xy} mm**

A full 1 mm outer bevel plus full 1 mm screw-hole bevel is geometrically incompatible with the standard 80 mm mounting pitch and Ø4.7 mm bore because those bevels overlap. The local relief preserves the visible 1 mm perimeter chamfer everywhere it fits instead of weakening the entire frame edge.

## Printing and qualification

Print either broad face on the bed with supports disabled. Suggested starting point for a 0.6 mm nozzle: 0.20–0.24 mm layers and adaptive 0.60–0.72 mm line widths. The mesh is a single watertight component with consistent winding; generated topology has Euler number **{validation['euler_number']}**.

**Physical status:** not yet printed or fit-tested. Mounting pitch follows the nominal square-fan standard for this size, but individual fan housings should still be checked before relying on exact screw/head clearance. No airflow or acoustic improvement is claimed.
'''
    (outdir/'README.md').write_text(readme)
    return metrics,validation

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--size',choices=['all','120','92','80','60'],default='all');ap.add_argument('--root',type=Path,default=Path(__file__).resolve().parent)
    a=ap.parse_args();sizes=PRESETS if a.size=='all' else [int(a.size)]
    for size in sizes:
      out=a.root/f'sweephex-{size}-xl'
      m,v=generate(size,out)
      print(size,'mm:',m['hex_apertures'],'apertures, mid open %.1f%%'%(m['midplane_open_fraction_full_square']*100),'face mount ligament %.3f mm'%m['mount_edge_ligament_face_nominal_mm'])
if __name__=='__main__':main()
