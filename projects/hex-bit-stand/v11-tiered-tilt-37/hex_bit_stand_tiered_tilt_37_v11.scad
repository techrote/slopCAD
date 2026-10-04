// Effect-plate tiered-tilt hex-bit stand, v11
// Derived from v10-effect-plate-hex-floor-19.
//
// 37 pockets in a radius-3 hex cluster:
//   centre = 0 degrees
//   ring 1 = 4 degrees
//   ring 2 = 8 degrees
//   ring 3 = 12 degrees
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
pocket_mouth_chamfer_h = 1.2;
pocket_mouth_flat_to_flat = 8.5;

// Deliberate global mouth rotation. Shaft hex is 30 degrees; mouth hex is 45 degrees.
// This produces a 15-degree equivalent mismatch for centre, corner, and edge-ring pockets.
shaft_hex_rotation = 30.0;
mouth_hex_rotation = 45.0;

pitch = 9.0;
inner_tilt_degrees = 4.0;
middle_tilt_degrees = 8.0;
outer_tilt_degrees = 12.0;
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
wall_margin = 3.0;
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
min_panel_back_flat = 0.5; // target printer has demonstrated ~0.5 mm line capability

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
        for (q=[-3:3])
            for (r=[-3:3]) {
                ring=ring_index(q,r);
                if (ring <= 3) {
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
    offset(delta=wall_margin+extra) pocket_cluster_2d(z);
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
    // remains at the deliberate 45-degree orientation, so the chamfer still
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
        for (q=[-3:3])
            for (r=[-3:3]) {
                ring=ring_index(q,r);
                if (ring <= 3) {
                    x0=centre_x(q,r); y0=centre_y(q,r);
                    if (ring == 0) centre_pocket();
                    else tilted_pocket(x0,y0,ring);
                    floor_relief(x0,y0,ring);
                }
            }
    }
}

// 42 tapered panel cutters on the actual radius-3 outer-wall facets.
// The tiered-tilt shell grows outward with height; each cutter therefore
// starts 1.5 mm outside a representative mid-height face before tapering
// 1.2 mm into the wall. This keeps the opening connected to the exterior
// across the whole sloped facet rather than creating buried voids.
wall_profile_points = [
    [-30.874744, -6.821724],
    [-35.440317, -4.185789],
    [-35.440317, 4.185789],
    [-30.874744, 6.821724],
    [-30.874744, 12.369641],
    [-26.149795, 15.097591],
    [-26.149795, 20.553492],
    [-21.345158, 23.327450],
    [-21.345158, 28.599320],
    [-14.095158, 32.785109],
    [-9.529585, 30.149174],
    [-4.724949, 32.923133],
    [0.000000, 30.195182],
    [4.724949, 32.923133],
    [9.529585, 30.149174],
    [14.095158, 32.785109],
    [21.345158, 28.599320],
    [21.345158, 23.327450],
    [26.149795, 20.553492],
    [26.149795, 15.097591],
    [30.874744, 12.369641],
    [30.874744, 6.821724],
    [35.440317, 4.185789],
    [35.440317, -4.185789],
    [30.874744, -6.821724],
    [30.874744, -12.369641],
    [26.149795, -15.097591],
    [26.149795, -20.553492],
    [21.345158, -23.327450],
    [21.345158, -28.599320],
    [14.095158, -32.785109],
    [9.529585, -30.149174],
    [4.724949, -32.923133],
    [0.000000, -30.195182],
    [-4.724949, -32.923133],
    [-9.529585, -30.149174],
    [-14.095158, -32.785109],
    [-21.345158, -28.599320],
    [-21.345158, -23.327450],
    [-26.149795, -20.553492],
    [-26.149795, -15.097591],
    [-30.874744, -12.369641]
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

    panel_height=z_chamfer_start-z_foot_blend;
    opening_length=face_length-2*panel_border;
    opening_height=panel_height-2*panel_border;

    // Radius 3 creates several shorter contour facets. Preserve the v10
    // 1.2 mm nominal recess where possible, but locally reduce depth just
    // enough to retain at least a 0.5 mm back-flat on short faces.
    max_depth_for_face=(opening_length-min_panel_back_flat)/(2*tan(panel_taper_degrees));
    local_depth=min(panel_depth,max_depth_for_face);
    local_taper_run=local_depth*tan(panel_taper_degrees);
    inner_length=opening_length-2*local_taper_run;
    inner_height=opening_height-2*local_taper_run;

    assert(opening_length > min_panel_back_flat, "Face too short for panel border");
    assert(local_depth > 0.5, "Adaptive panel depth collapsed too far");
    assert(inner_length >= min_panel_back_flat-0.001, "Face panel back flat below 0.5 mm");
    assert(inner_height > 1.0, "Face panel leaves too little vertical back flat");

    multmatrix([
        [ux,nx,0,p0[0]],
        [uy,ny,0,p0[1]],
        [0,0,1,0],
        [0,0,0,1]
    ])
        hull() {
            // Opening plate extends well outside the sloped wall.
            translate([panel_border, -panel_front_outset,
                       z_foot_blend+panel_border])
                cube([opening_length, panel_front_outset+0.05, opening_height]);

            // Recess floor; 50-degree taper shrinks all four edges.
            translate([panel_border+local_taper_run, local_depth-0.02,
                       z_foot_blend+panel_border+local_taper_run])
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
assert(1+6+12+18 == 37, "Radius-3 hex lattice must contain 37 pockets");
assert(abs(inner_tilt_degrees-4.0)<0.001, "Inner ring must remain 4 degrees");
assert(abs(middle_tilt_degrees-8.0)<0.001, "Middle ring must remain 8 degrees");
assert(abs(outer_tilt_degrees-12.0)<0.001, "Outer ring must remain 12 degrees");
assert(abs(mouth_hex_rotation-shaft_hex_rotation-15.0)<0.001,
       "Tilted-pocket mouths and the centre upper mouth should retain the 15-degree offset");
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
assert(minimum_straight_web_unshifted >= 2.0-0.001,
       "Straight pocket web is below 2 mm");
assert(panel_border == 1.0, "Face-panel border should remain 1 mm");
assert(abs(panel_taper_degrees-50.0)<0.001,
       "Face-panel taper should remain 50 degrees");
assert(panel_depth == 1.2,
       "Panel depth chosen to keep useful back-flat on the short radius-3 facets");
assert(lower_edge_chamfer > 0 && lower_edge_chamfer <= foot_flare,
       "Lower-edge chamfer must fit within the flared foot");

stand();
