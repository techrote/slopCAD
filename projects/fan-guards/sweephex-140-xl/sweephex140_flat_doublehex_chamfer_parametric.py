#!/usr/bin/env python3
"""SweepHex 140-F / XL, double-width hexes, real 1x1 mm chamfers.

One-piece, flat 140x140x6 mm fan guard. 43+ warped large hex openings
(+four 4.7mm bolt holes) extend into square corners, and every through-hole
rim and the outside perimeter are beveled on both large faces, at 45 degrees.
Outer 4 vertical square corners also carry 1 mm XY chamfers.

The bevel shell is built from exact 2D Shapely geometry using constrained
triangulation for the bevel bands, guaranteeing each aperture is fully open,
not a painted/textured bevel. The contour at z=0 and 6 is the exact inward
1 mm offset from the middle z=1..5 profile. The resulting 45 degree bevels
should print without supports on a well calibrated FDM printer.

Requirements: numpy, shapely>=2.1, trimesh, ezdxf (only DXF).
Run: python sweephex140_flat_doublehex_chamfer_parametric.py
Command line: --hex-radius 13.6 --bevel 1.0 --web-half 1.6 --twist 105
Units: millimetres. As viewed looking at top (+Z), positive twist is CCW.
"""
from __future__ import annotations

from dataclasses import dataclass, asdict, replace
import argparse
import json
import math
from pathlib import Path

import numpy as np
import trimesh
from shapely import constrained_delaunay_triangles, unary_union
from shapely.geometry import Point, Polygon, box


@dataclass(frozen=True)
class Settings:
    overall_side: float = 140.0
    total_depth: float = 6.0
    chamfer: float = 1.0
    corner_xy_chamfer: float = 1.0
    fan_mount_pitch: float = 124.5
    mounting_hole_diameter: float = 4.7
    mount_solid_keepout_radius: float = 6.35
    square_frame_width: float = 3.2
    hex_tile_circumradius: float = 13.6  # exactly 2 x the preceding 6.8 mm
    half_web_width: float = 1.6  # nominal 3.2 mm webs, for double-sided bevel
    anticlockwise_sweep_degrees_at_reference: float = 105.0
    sweep_reference_radius: float = 76.0
    sweep_exponent: float = 1.2
    hex_edge_samples: int = 12
    min_aperture_area_mm2: float = 18.0
    mounting_circle_quadrant_segments: int = 48
    bevel_corner_quadrant_segments: int = 6


DEFAULTS = Settings()


def mount_centres(s: Settings):
    half=s.fan_mount_pitch/2
    return [(x*half,y*half) for x in (-1,1) for y in (-1,1)]


def swirl(x,y,s:Settings):
    r=np.hypot(x,y)
    dtheta=math.radians(s.anticlockwise_sweep_degrees_at_reference)*np.power(
        r/s.sweep_reference_radius,s.sweep_exponent)
    ang=np.arctan2(y,x)+dtheta
    return r*np.cos(ang),r*np.sin(ang)


def aperture_polygons(s:Settings):
    half=s.overall_side/2
    allowed=box(-half+s.square_frame_width,-half+s.square_frame_width,
                half-s.square_frame_width,half-s.square_frame_width)
    keepouts=[Point(x,y).buffer(s.mount_solid_keepout_radius,quad_segs=48)
              for x,y in mount_centres(s)]
    allowed=allowed.difference(unary_union(keepouts))

    R=s.hex_tile_circumradius
    px=math.sqrt(3)*R;py=1.5*R
    generated_radius=math.sqrt(2)*half+R+6
    n=int(math.ceil(generated_radius/min(px,py)))+2
    vertices=np.column_stack((np.cos(np.deg2rad(np.arange(7)*60+30)),
                              np.sin(np.deg2rad(np.arange(7)*60+30))))*R
    frac=np.arange(s.hex_edge_samples)/s.hex_edge_samples
    boundary=np.vstack([(1-t)*vertices[k]+t*vertices[k+1]
                        for k in range(6) for t in frac])
    holes=[]
    for row in range(-n,n+1):
        for col in range(-n,n+1):
            cx=px*(col+row/2);cy=py*row
            if math.hypot(cx,cy)>generated_radius: continue
            X,Y=swirl(boundary[:,0]+cx,boundary[:,1]+cy,s)
            raw=Polygon(np.column_stack((X,Y)))
            if not raw.is_valid: raise RuntimeError(f'Invalid warped hex {cx},{cy}')
            # Erosion AFTER distortion controls the true XY web thickness.
            raw=raw.buffer(-s.half_web_width,join_style='round',quad_segs=8)
            if raw.is_empty: continue
            clipped=raw.intersection(allowed)
            if clipped.geom_type=='Polygon': pieces=[clipped]
            else: pieces=list(getattr(clipped,'geoms',[]))
            for p in pieces:
                if (p.geom_type=='Polygon' and p.is_valid and
                    p.area>=s.min_aperture_area_mm2 and not p.interiors):
                    holes.append(p)
    return holes


def outline(s:Settings):
    h=s.overall_side/2;c=s.corner_xy_chamfer
    return Polygon([(-h+c,-h),(h-c,-h),(h,-h+c),(h,h-c),
                    (h-c,h),(-h+c,h),(-h,h-c),(-h,-h+c)])


def construct_profiles(s:Settings):
    if (s.total_depth <= 2*s.chamfer or s.chamfer<=0 or
        s.half_web_width <= s.chamfer or s.square_frame_width <=2*s.chamfer or
        s.hex_tile_circumradius<=0):
        raise ValueError('Infeasible 1 mm chamfer/web/frame dimensions')
    holes=aperture_polygons(s)
    screw_holes=[Point(x,y).buffer(s.mounting_hole_diameter/2,quad_segs=s.mounting_circle_quadrant_segments)
                 for x,y in mount_centres(s)]
    middle=outline(s).difference(unary_union(holes+screw_holes))
    if middle.geom_type!='Polygon' or not middle.is_valid:
        raise RuntimeError(f'Middle slice not one polygon: {middle.geom_type}')
    face=middle.buffer(-s.chamfer,quad_segs=s.bevel_corner_quadrant_segments,join_style='round')
    if face.geom_type!='Polygon' or not face.is_valid:
        raise RuntimeError(f'Chamfer left disconnected/split geometry: {face.geom_type}')
    expected_holes=len(holes)+4
    if len(middle.interiors)!=expected_holes or len(face.interiors)!=expected_holes:
        raise RuntimeError(f'Chamfer deleted an opening: expected {expected_holes},'
                           f' got {len(middle.interiors)} / {len(face.interiors)}')
    band=middle.difference(face)
    if band.is_empty or not band.is_valid or not band.area>0:
        raise RuntimeError('No bevel band constructed')
    return middle,face,band,holes


def triangulate(p):
    """Return CCW ordered constraint-respecting XY triangles."""
    collection=constrained_delaunay_triangles(p)
    if collection.is_empty: raise RuntimeError('Empty constrained triangulation')
    for tri in collection.geoms:
        coords=np.asarray(tri.exterior.coords[:3],dtype=np.float64)
        if len(coords)!=3: continue
        signed=(coords[1,0]-coords[0,0])*(coords[2,1]-coords[0,1])-(coords[1,1]-coords[0,1])*(coords[2,0]-coords[0,0])
        if signed<0: coords[[1,2]]=coords[[2,1]]
        if abs(signed)>1e-12: yield coords


def contour_vertices(p):
    for ring in [p.exterior,*p.interiors]:
        yield np.asarray(ring.coords[:-1],dtype=np.float64)


def build_mesh(s:Settings,middle:Polygon,face:Polygon,band):
    # Spatial coordinate welding means caps, bevels, and 4mm vertical walls
    # share precisely the same polygon vertices and have no T seams.
    vertices=[];faces=[];lookup={}
    def vertex(xy,z):
        p=(round(float(xy[0]),9),round(float(xy[1]),9),round(float(z),9))
        k=lookup.get(p)
        if k is None:
            k=len(vertices);lookup[p]=k;vertices.append(p)
        return k
    def triangle(points,z,reverse=False):
        inds=[vertex(pt,v) for pt,v in zip(points,z)]
        if reverse:inds.reverse()
        if len(set(inds))==3:faces.append(tuple(inds))

    lo=s.chamfer;hi=s.total_depth-s.chamfer;H=s.total_depth

    # The entire z=0/6 top/bottom flats are the true offset face profile.
    for t in triangulate(face):
        triangle(t,[0.,0.,0.],reverse=True)
        triangle(t,[H,H,H])

    # The fillet band is P_middle \ P_face. Every triangulated vertex
    # belongs to exactly one of those 2D contours; assign the proper height.
    face_xy={tuple(round(float(v),9) for v in p)
             for ring in contour_vertices(face) for p in ring}
    mid_xy={tuple(round(float(v),9) for v in p)
            for ring in contour_vertices(middle) for p in ring}
    overlap=face_xy.intersection(mid_xy)
    if overlap:raise RuntimeError('Coincident face and middle ring points')
    for t in triangulate(band):
        zones=[]
        for pt in t:
            key=(round(float(pt[0]),9),round(float(pt[1]),9))
            if key in face_xy:zones.append(0)
            elif key in mid_xy:zones.append(1)
            else: raise RuntimeError(f'Bevel triangle unclassified point: {key}')
        triangle(t,[0. if b==0 else lo for b in zones],reverse=True)
        triangle(t,[H if b==0 else hi for b in zones])

    # Vertical straight walls at nominal aperture dimensions z=1..5.
    for ring in contour_vertices(middle):
        n=len(ring)
        for i in range(n):
            a=ring[i];b=ring[(i+1)%n]
            u=vertex(a,lo);v=vertex(b,lo)
            U=vertex(a,hi);V=vertex(b,hi)
            # Polygon returned by GEOS difference is CW outside, CCW for holes.
            # Reverse the wire direction here to orient 3D normals outward.
            if u!=v:
                faces.append((u,V,v));faces.append((u,U,V))

    mesh=trimesh.Trimesh(vertices=np.asarray(vertices),faces=np.asarray(faces),process=True,validate=False)
    parts=mesh.split(only_watertight=False)
    check={'watertight':bool(mesh.is_watertight),
           'consistent_winding':bool(mesh.is_winding_consistent),
           'components':len(parts),
           'volume_mm3':float(mesh.volume),
           'bounds_mm':mesh.bounds.tolist(),
           'vertices':len(mesh.vertices),'faces':len(mesh.faces),
           'euler_number':int(mesh.euler_number)}
    if not check['watertight'] or not check['consistent_winding'] or len(parts)!=1 or mesh.volume<=0:
        raise RuntimeError('3D watertight mesh check FAILED: '+json.dumps(check))
    if not np.allclose(mesh.extents,[s.overall_side,s.overall_side,s.total_depth],atol=1e-4):
        raise RuntimeError('Incorrect mesh bounds: '+str(mesh.extents))
    return mesh,check


def create_dxf(s:Settings,middle:Polygon,face:Polygon,output:Path):
    try:import ezdxf
    except ImportError: return False
    d=ezdxf.new('R2010');d.header['$INSUNITS']=4
    d.layers.new('MID_OUTER',dxfattribs={'color':7})
    d.layers.new('MID_OPENINGS',dxfattribs={'color':4})
    d.layers.new('FACE_OUTER',dxfattribs={'color':3})
    d.layers.new('FACE_OPENINGS',dxfattribs={'color':2})
    ms=d.modelspace()
    for geom,tag_o,tag_h in [(middle,'MID_OUTER','MID_OPENINGS'),(face,'FACE_OUTER','FACE_OPENINGS')]:
        for tag,ring in [(tag_o,geom.exterior)]+[(tag_h,r) for r in geom.interiors]:
            ms.add_lwpolyline(list(ring.coords[:-1]),close=True,dxfattribs={'layer':tag})
    d.saveas(output);return True


def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--out',type=Path,default=Path(__file__).with_name('sweephex140_flat_doublehex_chamfer1.stl'))
    ap.add_argument('--hex-radius',type=float,default=DEFAULTS.hex_tile_circumradius)
    ap.add_argument('--web-half',type=float,default=DEFAULTS.half_web_width)
    ap.add_argument('--twist',type=float,default=DEFAULTS.anticlockwise_sweep_degrees_at_reference)
    ap.add_argument('--bevel',type=float,default=DEFAULTS.chamfer)
    args=ap.parse_args()
    s=replace(DEFAULTS,hex_tile_circumradius=args.hex_radius,half_web_width=args.web_half,
              anticlockwise_sweep_degrees_at_reference=args.twist,chamfer=args.bevel)
    args.out.parent.mkdir(parents=True,exist_ok=True)
    print('Computing enlarged hexagonal openings, keeping mounting keepouts...',flush=True)
    middle,face,band,holes=construct_profiles(s)
    print('Openings:',len(holes),'plus 4 mounting; open middle area %0.1f%%'%
          ((1-middle.area/(s.overall_side*s.overall_side))*100),flush=True)
    print('Generating constrained-triangulated 1 mm face chamfers...',flush=True)
    m,validation=build_mesh(s,middle,face,band)
    m.export(args.out)
    import trimesh.exchange.threemf as tmf
    args.out.with_suffix('.3mf').write_bytes(tmf.export_3MF(m))
    create_dxf(s,middle,face,args.out.with_suffix('.dxf'))
    metrics={'hex_apertures':len(holes),'mount_holes':4,
             'hex_nominal_circumradius_mm':s.hex_tile_circumradius,
             'nominal_hex_across_flats_unwarped_mm':math.sqrt(3)*s.hex_tile_circumradius-2*s.half_web_width,
             'legacy_nominal_hex_across_flats_mm':math.sqrt(3)*6.8-2*0.85,
             'midplane_open_fraction_full_square':float(1-middle.area/(s.overall_side*s.overall_side)),
             'face_open_fraction_full_square':float(1-face.area/(s.overall_side*s.overall_side)),
             'volume_mm3':m.volume,
             'estimated_PLA_grams_at_1p24':float(m.volume/1000*1.24),
             'supports_required':'no, printing either broad face down; 45-degree underside bevels',
             'chamfer':'1 mm x 45 degrees, both large faces, all through-openings including bolts and outer outline',
             'corner_vertical_chamfer_mm':s.corner_xy_chamfer,
             'swirl':'105 degrees CCW at 76 mm radius as viewed from z-positive',
             'mount_centres_mm':mount_centres(s),
             'midplane_hole_count':len(middle.interiors),
             'face_hole_count':len(face.interiors)}
    args.out.with_suffix('.json').write_text(json.dumps({
        'settings':asdict(s),'measurements':metrics,'validation':validation},indent=2))
    print('Checks:',json.dumps(validation,indent=2))
    print('Done:',args.out,flush=True)

if __name__=='__main__':main()
