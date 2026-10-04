// Effect-plate tiered-tilt hex-bit stand, v14
// Derived from v13-lip-edge-panels-37.
//
// v14 expansion:
// - radius-4 / 61-pocket cluster: 1 + 6 + 12 + 18 + 24
// - adds a fourth tilted ring at 16 degrees outward
// - keeps v13 lip-edge wall recesses and v10/v13 tapered hex floor reliefs
// - fixes the mouth chamfer height at 1.15 mm to keep the worst 16-degree-ring
//   bed-facing taper at about 70 degrees
// - changes the global mouth-hex rotation to 0 degrees, giving a deliberate
//   30-degree mismatch to the 30-degree shaft hex at the centre while leaving
//   naturally varied misalignment around the tilted rings
//
// v13 side-pocket tweak:
// - extends every outer-wall inset pocket down to the upper edge of the flared lower lip
// - removes the bottom 1 mm border and bottom taper from those inset pockets
// - retains 1 mm side/top borders, 1.2 mm depth, and 50-degree side/top taper
// - pocket/tilt/floor geometry is unchanged from v12
//
// v12 wall cleanup:
// - replaces the 42-facet pocket-following side perimeter with a convex 24-face shell
// - increases nominal wall margin from 3.0 mm to 3.6 mm
// - removes adaptive short-facet panel depth and its narrow triangular remnants
// - restores a uniform 1.2 mm / 50-degree recessed panel on every wall face
//
// 61 pockets in a radius-4 hex cluster:
//   centre = 0 degrees
//   ring 1 = 4 degrees
//   ring 2 = 8 degrees
//   ring 3 = 12 degrees
//   ring 4 = 16 degrees
//
// v11 preserves the v10 floor/mouth geometry and adds a third tilted ring:
// - keep v7-style individual outer-wall inset panels; no continuous waist groove
// - retain deliberately misaligned/scalloped chamfers on all tilted rings
// - centre pocket lead-in starts aligned to the shaft, eliminating its insertion-blocking lip
// - increase structural base thickness to 2.0 mm
// - replace round floor reliefs with tapered HEX floor transitions:
//   full pocket footprint at z=2 mm -> 55-degree inward taper to z=1 mm ->
//   smaller hexagonal through-hole to the underside
// - intended for normal or top-face-down effect-plate printing
//
// Designed for a 0.6 mm nozzle; nominal top web remains 0.5 mm.
// Units: millimetres.

$fn = 48;

// ---------- Pocket geometry ----------
hex_flat_to_flat = 7.0;
pocket_depth = 12.0;
base_thickness = 2.0;
pocket_mouth_chamfer_h = 1.15;
pocket_mouth_flat_to_flat = 8.5;

// Deliberate global mouth rotation. Shaft hex is 30 degrees; mouth hex is 0 degrees.
// At the centre this is the maximum distinct 30-degree phase offset, putting
// chamfer points on the shaft-flat midlines. Tilted shaft frames rotate radially,
// so the visible mismatch naturally varies around the rings.
shaft_hex_rotation = 30.0;
mouth_hex_rotation = 0.0;

pitch = 9.0;
inner_tilt_degrees = 4.0;
middle_tilt_degrees = 8.0;
third_tilt_degrees = 12.0;
outer_tilt_degrees = 16.0;
centre_epsilon = 0.001;

// ---------- Upside-down / effect-plate floor relief ----------
// Fusion-style construction: make the base 2 mm thick, then taper the bottom
// of each pocket downward by 1 mm with a 55-degree inward draft. The resulting
// smaller hex face is cut straight through the remaining 1 mm of base.
floor_taper_h = 1.0;
floor_taper_degrees = 55.0;
floor_taper_inset = floor_taper_h * tan(floor_taper_degrees);
floor_hole_flat_to_flat = hex_flat_to_flat - 2*floor_taper_inset;
floor_hole_r = floor_hole_flat_to_flat / sqrt(3);
floor_boolean_overlap = 0.03; // avoid coplanar/zero-area boolean remnants

// ---------- Contoured body ----------
wall_margin = 3.6;
body_h = pocket_depth + base_thickness; // 14.0 mm total
foot_flare = 0.6;
lower_edge_chamfer = 0.4;
top_chamfer_inset = 1.2;

z0 = 0.00;
z_lower_chamfer_top = lower_edge_chamfer;
z_foot_top = 2.10;
z_foot_blend = 3.00;
z_chamfer_start = 12.20;
z_top = body_h;

// ---------- v7-style face panels ----------
panel_border = 1;
panel_depth = 1.2;
panel_taper_degrees = 50;
panel_taper_run = panel_depth * tan(panel_taper_degrees);
panel_front_outset = 1.5; // deliberately crosses the sloped wall
panel_bottom_overlap = 0.05; // guarantees the recess cleanly meets the lip edge
panel_bottom_z = z_foot_top - panel_bottom_overlap;

// ---------- Derived ----------
hex_r = hex_flat_to_flat / sqrt(3);
mouth_hex_r = pocket_mouth_flat_to_flat / sqrt(3);
minimum_top_web_unshifted = pitch - pocket_mouth_flat_to_flat;
minimum_straight_web_unshifted = pitch - hex_flat_to_flat;
outer_floor_projected_af = hex_flat_to_flat / cos(outer_tilt_degrees);
minimum_floor_horizontal_web = pitch - outer_floor_projected_af;
floor_support_at_flats = floor_taper_inset;

function ring_index(q, r) = max(abs(q), abs(r), abs(q + r));
function tilt_for_ring(ring) =
    ring == 0 ? 0 :
    ring == 1 ? inner_tilt_degrees :
    ring == 2 ? middle_tilt_degrees :
    ring == 3 ? third_tilt_degrees :
                outer_tilt_degrees;
function radial_shift_at_z(z, ring) =
    ring == 0 ? 0 :
    max(0, min(body_h - base_thickness, z - base_thickness)) * tan(tilt_for_ring(ring));

function centre_x(q, r) = pitch * (q + r/2);
function centre_y(q, r) = pitch * sqrt(3)/2 * r;

module shaft_hex_2d(r) {
    rotate(shaft_hex_rotation) circle(r=r, $fn=6);
}

module mouth_hex_2d(r) {
    rotate(mouth_hex_rotation) circle(r=r, $fn=6);
}

// Body outline intentionally retains the v8 30-degree hex orientation.
// The 3 mm body margin / 1.8 mm top rim fully contains the 45-degree mouth hexes,
// while preserving the proven tiered-tilt silhouette and useful wall-facet sizes.
module body_hex_2d(r) {
    rotate(shaft_hex_rotation) circle(r=r, $fn=6);
}

module pocket_cluster_2d(z) {
    union() {
        for (q=[-4:4])
            for (r=[-4:4]) {
                ring=ring_index(q,r);
                if (ring <= 4) {
                    x0=centre_x(q,r);
                    y0=centre_y(q,r);
                    radius=sqrt(x0*x0+y0*y0);
                    shift=radial_shift_at_z(z,ring);
                    x=radius < centre_epsilon ? x0 : x0 + shift*x0/radius;
                    y=radius < centre_epsilon ? y0 : y0 + shift*y0/radius;
                    translate([x,y]) body_hex_2d(mouth_hex_r);
                }
            }
    }
}

module body_profile_2d(z, extra=0) {
    // Convexify the pocket envelope before offsetting it. This fills the shallow
    // notches between outer-ring pockets and produces longer, cleaner wall faces.
    // It costs a little extra material but avoids the short-facet triangular
    // panel remnants that printed poorly in v11.
    offset(delta=wall_margin+extra)
        hull() {
            pocket_cluster_2d(z);
        }
}

module profile_slice(z, extra, thickness=0.03) {
    translate([0,0,z]) linear_extrude(height=thickness) body_profile_2d(z,extra);
}

module loft_segment(z1, extra1, z2, extra2) {
    hull() {
        profile_slice(z1,extra1);
        profile_slice(z2-0.03,extra2);
    }
}

module styled_body() {
    union() {
        loft_segment(z0, foot_flare-lower_edge_chamfer,
                     z_lower_chamfer_top, foot_flare);
        loft_segment(z_lower_chamfer_top, foot_flare,
                     z_foot_top, foot_flare);
        loft_segment(z_foot_top, foot_flare, z_foot_blend, 0);

        // Plain main wall: v8's continuous waist cut is intentionally removed.
        loft_segment(z_foot_blend, 0, z_chamfer_start, 0);

        loft_segment(z_chamfer_start, 0, z_top, -top_chamfer_inset);
    }
}

module shaft_hex_prism(r,h) { linear_extrude(height=h) shaft_hex_2d(r); }
module mouth_hex_prism(r,h) { linear_extrude(height=h) mouth_hex_2d(r); }

module centre_pocket() {
    translate([0,0,base_thickness])
        shaft_hex_prism(hex_r, pocket_depth-pocket_mouth_chamfer_h+0.08);

    // Centre-pocket correction: start the chamfer on the exact shaft profile so
    // there is no 7 mm rotated lip constricting bit insertion. The upper mouth
    // remains at the deliberate 0-degree orientation, so the chamfer still
    // twists/misaligns visually as it expands.
    hull() {
        translate([0,0,body_h-pocket_mouth_chamfer_h])
            shaft_hex_prism(hex_r,0.03);
        translate([0,0,body_h-0.01])
            mouth_hex_prism(mouth_hex_r,0.04);
    }
}

module outward_axis_frame(x0,y0,tilt_degrees) {
    radius=sqrt(x0*x0+y0*y0);
    ux=x0/radius; uy=y0/radius;
    s=sin(tilt_degrees); c=cos(tilt_degrees);

    xx=-uy; xy=ux; xz=0;
    yx=-c*ux; yy=-c*uy; yz=s;
    zx=s*ux; zy=s*uy; zz=c;

    multmatrix([
        [xx,yx,zx,x0],
        [xy,yy,zy,y0],
        [xz,yz,zz,base_thickness],
        [0,0,0,1]
    ]) children();
}

module tilted_shaft(x0,y0,tilt_degrees) {
    axis_length=(body_h-base_thickness)/cos(tilt_degrees);
    intersection() {
        outward_axis_frame(x0,y0,tilt_degrees)
            translate([0,0,-2]) shaft_hex_prism(hex_r,axis_length+6);
        translate([-100,-100,base_thickness])
            cube([200,200,body_h-base_thickness+10]);
    }
}

module tilted_mouth_leadin(x0,y0,ring) {
    radius=sqrt(x0*x0+y0*y0);
    ux=x0/radius; uy=y0/radius;
    z_low=body_h-pocket_mouth_chamfer_h;
    shift_low=radial_shift_at_z(z_low,ring);
    shift_top=radial_shift_at_z(body_h,ring);
    x_low=x0+shift_low*ux; y_low=y0+shift_low*uy;
    x_top=x0+shift_top*ux; y_top=y0+shift_top*uy;

    hull() {
        translate([x_low,y_low,z_low]) mouth_hex_prism(hex_r,0.03);
        translate([x_top,y_top,body_h-0.01]) mouth_hex_prism(mouth_hex_r,0.04);
    }
}

module tilted_pocket(x0,y0,ring) {
    union() {
        tilted_shaft(x0,y0,tilt_for_ring(ring));
        tilted_mouth_leadin(x0,y0,ring);
    }
}

// Exact Fusion-style tapered floor transition for normal or inverted printing.
//
// For tilted pockets the horizontal floor cross-section is an affine/sheared
// hex, not a regular 7 mm hex. We derive that exact cross-section from the shaft
// frame, then use OpenSCAD offset(delta=-inset) to create the lower profile.
// Over a 1 mm vertical drop, a 1.428 mm inward edge offset corresponds to the
// requested 55-degree inward draft on every edge. The offset profile is then
// cut straight through the remaining 1 mm of base as a hexagonal through-hole.
module floor_footprint_2d(x0,y0,ring) {
    if (ring == 0) {
        translate([x0,y0]) shaft_hex_2d(hex_r);
    } else {
        radius=sqrt(x0*x0+y0*y0);
        ux=x0/radius;
        uy=y0/radius;
        c=cos(tilt_for_ring(ring));

        // Exact horizontal slice of the tilted infinite hex prism at its
        // z=base_thickness origin. Tangential dimension is unchanged; radial
        // dimension is stretched by 1/cos(tilt).
        multmatrix([
            [-uy, -ux/c, 0, x0],
            [ ux, -uy/c, 0, y0],
            [  0,     0, 1,  0],
            [  0,     0, 0,  1]
        ]) shaft_hex_2d(hex_r);
    }
}

module floor_upper_cut_profile_2d(x0,y0,ring) {
    offset(delta=floor_boolean_overlap)
        floor_footprint_2d(x0,y0,ring);
}

module floor_lower_profile_2d(x0,y0,ring) {
    // Apply the same boolean overlap to both profiles so the taper's actual
    // edge-to-edge inset remains exactly floor_taper_inset.
    offset(delta=-floor_taper_inset + floor_boolean_overlap)
        floor_footprint_2d(x0,y0,ring);
}

module floor_relief(x0,y0,ring) {
    // Straight smaller hex through the lower 1 mm of the 2 mm base.
    translate([0,0,-0.05])
        linear_extrude(height=base_thickness-floor_taper_h+0.10)
            floor_lower_profile_2d(x0,y0,ring);

    // Exact pocket-floor footprint at z=2 mm tapered to its inward-offset
    // counterpart at z=1 mm.
    hull() {
        translate([0,0,base_thickness-floor_taper_h-0.02])
            linear_extrude(height=0.03)
                floor_lower_profile_2d(x0,y0,ring);
        translate([0,0,base_thickness-0.01])
            linear_extrude(height=0.04)
                floor_upper_cut_profile_2d(x0,y0,ring);
    }
}

module all_pockets_and_floor_reliefs() {
    union() {
        for (q=[-4:4])
            for (r=[-4:4]) {
                ring=ring_index(q,r);
                if (ring <= 4) {
                    x0=centre_x(q,r); y0=centre_y(q,r);
                    if (ring == 0) centre_pocket();
                    else tilted_pocket(x0,y0,ring);
                    floor_relief(x0,y0,ring);
                }
            }
    }
}

// 30 uniform tapered panel cutters on the convex radius-4 outer shell.
// The points represent the mid-height wall profile with the 3.6 mm margin.
// The shortest face remains about 6.77 mm, leaving about
// 1.91 mm of back-flat after the full 1.2 mm / 50-degree taper;
// no adaptive triangular workaround is needed.
wall_profile_points = [
    [-0.000000, -41.290246],
    [-9.486628, -41.226975],
    [-19.794607, -41.059385],
    [-25.661167, -37.672325],
    [-30.960293, -28.829148],
    [-35.758402, -20.645123],
    [-40.446922, -12.397826],
    [-45.455774, -3.387060],
    [-45.455774, 3.387060],
    [-40.446922, 12.397826],
    [-35.758402, 20.645123],
    [-30.960293, 28.829148],
    [-25.661167, 37.672325],
    [-19.794607, 41.059385],
    [-9.486628, 41.226975],
    [0.000000, 41.290246],
    [9.486628, 41.226975],
    [19.794607, 41.059385],
    [25.661167, 37.672325],
    [30.960293, 28.829148],
    [35.758402, 20.645123],
    [40.446922, 12.397826],
    [45.455774, 3.387060],
    [45.455774, -3.387060],
    [40.446922, -12.397826],
    [35.758402, -20.645123],
    [30.960293, -28.829148],
    [25.661167, -37.672325],
    [19.794607, -41.059385],
    [9.486628, -41.226975]
];

module wall_face_panel(p0, p1) {
    dx=p1[0]-p0[0];
    dy=p1[1]-p0[1];
    face_length=sqrt(dx*dx+dy*dy);
    ux=dx/face_length;
    uy=dy/face_length;

    // Shapely's convex-hull list here is clockwise.
    // Interior normal is therefore the right-hand normal.
    nx=uy;
    ny=-ux;

    opening_length=face_length-2*panel_border;

    // Open-bottom recess: it starts directly at the upper edge of the flared
    // lower lip instead of keeping the former 1 mm bottom border. The back
    // surface starts at the same Z, so only the side and top edges retain the
    // 50-degree taper. This makes the pocket visually/physically terminate at
    // the lip edge with no floating shelf beneath it.
    opening_bottom=panel_bottom_z;
    opening_top=z_chamfer_start-panel_border;
    opening_height=opening_top-opening_bottom;

    inner_length=opening_length-2*panel_taper_run;
    inner_height=opening_height-panel_taper_run; // top taper only; bottom remains open

    assert(opening_length > 0, "Face too short for 1 mm panel border");
    assert(inner_length >= 1.8-0.001, "Face panel back flat below 1.8 mm");
    assert(inner_height > 1.0, "Face panel leaves too little vertical back flat");
    assert(abs(panel_bottom_z-z_foot_top) <= panel_bottom_overlap+0.001,
           "Panel bottom should meet the upper edge of the lower lip");

    multmatrix([
        [ux,nx,0,p0[0]],
        [uy,ny,0,p0[1]],
        [0,0,1,0],
        [0,0,0,1]
    ])
        hull() {
            // Opening plate extends well outside the sloped wall and begins
            // just below the lip's upper edge to eliminate any residual shelf.
            translate([panel_border, -panel_front_outset, opening_bottom])
                cube([opening_length, panel_front_outset+0.05, opening_height]);

            // Recess floor. Side edges and the top retain the 50-degree taper;
            // the bottom stays at opening_bottom so the pocket is open to the lip.
            translate([panel_border+panel_taper_run, panel_depth-0.02, opening_bottom])
                cube([inner_length,0.04,inner_height]);
        }
}

module all_wall_face_panels() {
    for (i=[0:len(wall_profile_points)-1]) {
        p0=wall_profile_points[i];
        p1=wall_profile_points[(i+1)%len(wall_profile_points)];
        wall_face_panel(p0,p1);
    }
}

module stand() {
    difference() {
        styled_body();
        union() {
            all_pockets_and_floor_reliefs();
            all_wall_face_panels();
        }
    }
}

// ---------- Sanity checks ----------
assert(1+6+12+18+24 == 61, "Radius-4 hex lattice must contain 61 pockets");
assert(abs(inner_tilt_degrees-4.0)<0.001, "Inner ring must remain 4 degrees");
assert(abs(middle_tilt_degrees-8.0)<0.001, "Middle ring must remain 8 degrees");
assert(abs(third_tilt_degrees-12.0)<0.001, "Third ring must remain 12 degrees");
assert(abs(outer_tilt_degrees-16.0)<0.001, "Outer ring must remain 16 degrees");
assert(abs(abs(mouth_hex_rotation-shaft_hex_rotation)-30.0)<0.001,
       "Centre mouth should retain the deliberate 30-degree shaft/mouth mismatch");
assert(abs(floor_taper_h-1.0)<0.001,
       "Floor taper should remain 1 mm high");
assert(abs(floor_taper_degrees-55.0)<0.001,
       "Floor taper should remain 55 degrees");
assert(floor_hole_flat_to_flat > 4.0,
       "55-degree taper leaves an unexpectedly small hex through-hole");
assert(floor_support_at_flats > 1.4,
       "Taper should retain substantial support at the pocket flats");
assert(minimum_top_web_unshifted >= 0.5-0.001,
       "Nominal top web is below the demonstrated 0.5 mm printable width");
assert(pocket_mouth_chamfer_h <= 1.15+0.001,
       "v14 chamfer height is capped for the 16-degree outer ring");
assert(minimum_straight_web_unshifted >= 2.0-0.001,
       "Straight pocket web is below 2 mm");
assert(panel_border == 1.0, "Face-panel border should remain 1 mm");
assert(abs(panel_taper_degrees-50.0)<0.001,
       "Face-panel taper should remain 50 degrees");
assert(panel_depth == 1.2,
       "Panel depth should remain the uniform v7/v10 1.2 mm");
assert(wall_margin == 3.6,
       "v14 radius-4 shell uses a 3.6 mm nominal outer margin");
assert(panel_bottom_z <= z_foot_top+0.001,
       "Inset pockets must extend to the upper edge of the lower lip");
assert(lower_edge_chamfer > 0 && lower_edge_chamfer <= foot_flare,
       "Lower-edge chamfer must fit within the flared foot");

stand();
