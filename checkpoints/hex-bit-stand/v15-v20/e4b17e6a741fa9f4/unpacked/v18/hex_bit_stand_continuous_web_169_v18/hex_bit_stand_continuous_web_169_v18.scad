// v18 - continuous-web, aligned-mouth 169-pocket bit stand.
// Extends v17 with a seventh ring: 42 pockets at 28 degrees outward.
// Units: mm. Functional shaft size is measured NORMAL to the tilted axis.
// Pocket axes: 0/4/8/12/16/20/24/28 degrees. Lattice-aligned shaft roll is retained.
// Pitch increases 9.65 -> 9.90 mm to retain the 1.3 mm minimum surface web.
// At 9.65 mm pitch the new ring-6/ring-7 top gap would be about 1.222 mm.
// The selected pitch gives about 1.472 mm; exported meshes must still be checked.
// Render and run validate.py after changing dimensions. Assertions alone are
// not a geometric clearance check. Default export is in the use orientation.

$fn = 48;
print_face_down = false;
export_part = "stand"; // "coupon" gives a fifteen-pocket first-layer test piece
min_surface_feature = 1.3;
ring_count = 7;
hex_flat_to_flat = 7.0;
pitch = 9.90;
base_thickness = 2.0;
pocket_depth = 12.0;
body_h = base_thickness + pocket_depth;
pocket_mouth_flat_to_flat = 8.5;
pocket_mouth_chamfer_h = 1.15;
shaft_hex_rotation = 30;
tilt_angles = [0, 4, 8, 12, 16, 20, 24, 28];
floor_taper_h = 1.0;
floor_taper_degrees = 55;
floor_taper_inset = floor_taper_h * tan(floor_taper_degrees);
wall_margin = 3.8;
foot_flare = 0.6;
lower_edge_chamfer = 0.4;
top_chamfer_inset = 1.2;
z_foot_top = 2.10;
z_foot_blend = 3.00;
z_chamfer_start = body_h - 1.8;
panel_border = 1.3;
panel_depth = 1.2;
panel_taper_degrees = 50;
panel_taper_run = panel_depth * tan(panel_taper_degrees);
panel_bottom_z = z_foot_top - 0.05;
panel_front_outset = 2.0;
eps = 0.01;

function cross2(a,b) = a[0]*b[1]-a[1]*b[0];
function ring(q,r) = max(abs(q),abs(r),abs(q+r));
function xy(q,r) = [pitch*(q+r/2),pitch*sqrt(3)*r/2];
function radial(q,r) = ring(q,r)==0 ? [0,0] : xy(q,r)/norm(xy(q,r));
function tilt(q,r) = tilt_angles[ring(q,r)];
function axis_xy(q,r,z) = xy(q,r)+(z-base_thickness)*tan(tilt(q,r))*radial(q,r);
function hex_points(af) = [for(k=[0:5])
    (af/sqrt(3))*[cos(shaft_hex_rotation+60*k),sin(shaft_hex_rotation+60*k)]];

// Minimal rotation from vertical to the outward axis: no tangential yaw.
// The exact horizontal slice is stretched by sec(tilt) only radially.
// All shaft hexes start in the same lattice-aligned roll before being tilted.
function projected_hex(q,r,af,z) = let(u=radial(q,r),c=cos(tilt(q,r)),p=axis_xy(q,r,z))
    [for(v=hex_points(af)) p+v+(1/c-1)*(v*u)*u];

// Miter offset of a convex CCW polygon. Keeps its vertex ordering, so all
// neighbouring profiles can form a single continuous, ledge-free cutter.
function offset_poly(p,d) = [for(i=[0:len(p)-1]) let(
    e0=p[i]-p[(i+len(p)-1)%len(p)],e1=p[(i+1)%len(p)]-p[i],
    n0=[e0[1],-e0[0]]/norm(e0),n1=[e1[1],-e1[0]]/norm(e1))
    p[i]+d*(n0+n1)/(1+n0*n1)];

// Numeric convex hull for parameter-derived panel positions; there is no
// stale hard-coded mid-height perimeter when pitch or wall margin changes.
function lex_lt(a,b) = a[0]<b[0] || (a[0]==b[0] && a[1]<b[1]);
function sort_xy(a) = len(a)<2 ? a : let(p=a[floor(len(a)/2)]) concat(
    sort_xy([for(x=a) if(lex_lt(x,p)) x]), [p],
    sort_xy([for(x=a) if(lex_lt(p,x)) x]));
function drop_last(a) = [for(i=[0:len(a)-1]) if(i<len(a)-1) a[i]];
function add_hull(s,p) = len(s)<2 ? concat(s,[p]) :
    cross2(s[len(s)-1]-s[len(s)-2],p-s[len(s)-1])<=0.000001 ?
    add_hull(drop_last(s),p) : concat(s,[p]);
function half_hull(a,i=0,s=[]) = i>=len(a) ? s : half_hull(a,i+1,add_hull(s,a[i]));
function convex_poly(p) = let(a=sort_xy(p),b=[for(i=[len(a)-1:-1:0]) a[i]])
    concat(drop_last(half_hull(a)),drop_last(half_hull(b)));

coords = [for(q=[-ring_count:ring_count]) for(r=[-ring_count:ring_count])
    if(ring(q,r)<=ring_count) [q,r]];
function shell_points(z) = [for(qr=coords) for(v=hex_points(pocket_mouth_flat_to_flat))
    axis_xy(qr[0],qr[1],max(base_thickness,z))+v];
function shell_poly(z,extra=0) = offset_poly(convex_poly(shell_points(z)),wall_margin+extra);
panel_profile = shell_poly((z_foot_blend+z_chamfer_start)/2);

// Closed polyhedron made from successive equally sized CCW sections.
// Faces follow OpenSCAD's clockwise-from-outside convention.
module ruled_cutter(profiles,zs) {
    n=len(profiles[0]); m=len(profiles);
    polyhedron(
        points=[for(j=[0:m-1]) for(p=profiles[j]) [p[0],p[1],zs[j]]],
        faces=concat(
            [for(i=[1:n-2]) [0,i,i+1]],
            [for(i=[1:n-2]) [(m-1)*n,(m-1)*n+i+1,(m-1)*n+i]],
            [for(j=[0:m-2]) for(i=[0:n-1]) each [
                [j*n+i,(j+1)*n+i,(j+1)*n+(i+1)%n],
                [j*n+i,(j+1)*n+(i+1)%n,j*n+(i+1)%n]]]),
        convexity=12);
}

module pocket(q,r) {
    floor=projected_hex(q,r,hex_flat_to_flat,base_thickness);
    bore=offset_poly(floor,-floor_taper_inset);
    mouth_start=body_h-pocket_mouth_chamfer_h;
    // Every section has exactly the same hex phase. A single ruled cavity
    // replaces the previous union of differently rotated shaft/chamfer cuts.
    // The top two sections extend the cut through the face without changing
    // the specified dimensions at either exterior surface.
    profiles=[bore,bore,floor,
        projected_hex(q,r,hex_flat_to_flat,mouth_start),
        projected_hex(q,r,pocket_mouth_flat_to_flat,body_h),
        projected_hex(q,r,pocket_mouth_flat_to_flat,body_h+eps)];
    ruled_cutter(profiles,[-eps,base_thickness-floor_taper_h,base_thickness,
                           mouth_start,body_h,body_h+eps]);
}

// Retain the convex contoured shell, softened foot and top outer chamfer.
module shell_slice(z,extra) {
    translate([0,0,z]) linear_extrude(height=eps) polygon(shell_poly(z,extra));
}
module shell_segment(z0,e0,z1,e1) {
    hull() { shell_slice(z0,e0); shell_slice(z1-eps,e1); }
}
module body() {
    union() {
        shell_segment(0,foot_flare-lower_edge_chamfer,lower_edge_chamfer,foot_flare);
        shell_segment(lower_edge_chamfer,foot_flare,z_foot_top,foot_flare);
        shell_segment(z_foot_top,foot_flare,z_foot_blend,0);
        shell_segment(z_foot_blend,0,z_chamfer_start,0);
        shell_segment(z_chamfer_start,0,body_h,-top_chamfer_inset);
    }
}

// v13 open-bottom styling retained. Top/side borders grow to 1.3 mm.
// Profile is CCW; the left normal points into the body. Depth and border
// refer to this mid-height reference plane (the body itself is splayed).
module panel(p0,p1) {
    v=p1-p0; l=norm(v); u=v/l; normal=[-u[1],u[0]];
    w=l-2*panel_border; h=z_chamfer_start-panel_border-panel_bottom_z;
    iw=w-2*panel_taper_run; ih=h-panel_taper_run;
    assert(iw>=min_surface_feature,"Panel back flat too narrow");
    assert(ih>=min_surface_feature,"Panel back flat too short");
    multmatrix([[u[0],normal[0],0,p0[0]], [u[1],normal[1],0,p0[1]],
                [0,0,1,0], [0,0,0,1]])
    hull() {
        translate([panel_border,-panel_front_outset,panel_bottom_z])
            cube([w,panel_front_outset+0.02,h]);
        translate([panel_border+panel_taper_run,panel_depth-eps,panel_bottom_z])
            cube([iw,2*eps,ih]);
    }
}
module stand() {
    difference() {
        body();
        for(qr=coords) pocket(qr[0],qr[1]);
        for(i=[0:len(panel_profile)-1])
            panel(panel_profile[i],panel_profile[(i+1)%len(panel_profile)]);
    }
}

assert(ring_count==7 && len(coords)==169,"Expected seven rings and 169 pockets");
assert(tilt_angles==[0,4,8,12,16,20,24,28],"Expected 0/4/8/12/16/20/24/28 deg tilt bands");
assert(min_surface_feature>=1.3,"No return to the experimental 0.5 mm webs");
assert(hex_flat_to_flat==7 && pitch>=9.90,"Revalidate changes to fit/spacing");
assert(pocket_mouth_flat_to_flat>=hex_flat_to_flat,"Mouth cannot constrict shaft");
assert(base_thickness>floor_taper_h,"Floor needs a through-bore section");
assert(hex_flat_to_flat-2*floor_taper_inset>4,"Bore collapsed");
assert(floor_taper_inset>=min_surface_feature,"Floor bearing band too narrow");
assert(panel_border>=min_surface_feature,"Panel border too narrow");
assert(wall_margin-top_chamfer_inset>=min_surface_feature,"Outer rim too narrow");
assert(panel_bottom_z>lower_edge_chamfer,"Preserve the lower lip");

// Coupon retains the exact production pocket coordinates/tilts and includes
// centre-to-ring-7 radial pairs plus adjacent three-pocket junctions. It has a
// simple 2 mm perimeter, not production side panels; use it for surface tests.
module coupon() {
    selected=[[0,0],[1,0],[2,0],[3,0],[4,0],[5,0],[6,0],[7,0],
              [0,1],[1,1],[2,1],[3,1],[4,1],[5,1],[6,1]];
    difference() {
        linear_extrude(height=body_h) offset(delta=2)
            hull() for(qr=selected)
                polygon(projected_hex(qr[0],qr[1],pocket_mouth_flat_to_flat,body_h));
        for(qr=selected) pocket(qr[0],qr[1]);
    }
}
module selected_part() {
    assert(export_part=="stand" || export_part=="coupon","Unknown export_part");
    if(export_part=="coupon") coupon(); else stand();
}
if(print_face_down) translate([0,0,body_h]) rotate([180,0,0]) selected_part();
else selected_part();
