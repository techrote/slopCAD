// Effect-plate tiered-tilt hex-bit stand, v9
// Derived from v8-tiered-tilt-19.
//
// 19 pockets: centre vertical, 6 inner-ring at 4 degrees, 12 outer-ring at 8 degrees.
//
// v9 changes:
// - remove the continuous outer waist groove
// - add individually tapered inset panels to all 18 actual convex outer-wall facets
// - enforce a deliberate 15-degree pocket-mouth rotational mismatch on every pocket
// - add a 5.0 mm through-hole beneath every pocket
// - add a 1.0 mm-high floor transition from 7.0 mm circular opening to the 5.0 mm hole
//   so the model can be printed top-face-down on an effect plate with minimal bridging
//
// Designed for a 0.6 mm nozzle; nominal top web remains 0.5 mm.
// Units: millimetres.

$fn = 48;

// ---------- Pocket geometry ----------
hex_flat_to_flat = 7.0;
pocket_depth = 12.0;
base_thickness = 1.0;
pocket_mouth_chamfer_h = 1.2;
pocket_mouth_flat_to_flat = 8.5;

// Deliberate global mouth rotation. Shaft hex is 30 degrees; mouth hex is 45 degrees.
// This produces a 15-degree equivalent mismatch for centre, corner, and edge-ring pockets.
shaft_hex_rotation = 30.0;
mouth_hex_rotation = 45.0;

pitch = 9.0;
inner_tilt_degrees = 4.0;
outer_tilt_degrees = 8.0;
centre_epsilon = 0.001;

// ---------- Upside-down / effect-plate floor relief ----------
floor_relief_diameter = 5.0;
floor_relief_chamfer_h = 1.0;
floor_relief_top_diameter = hex_flat_to_flat; // 7 mm -> 5 mm over 1 mm ~= 45 deg at flats

// ---------- Contoured body ----------
wall_margin = 3.0;
body_h = pocket_depth + base_thickness;
foot_flare = 0.6;
lower_edge_chamfer = 0.4;
top_chamfer_inset = 1.2;

z0 = 0.00;
z_lower_chamfer_top = lower_edge_chamfer;
z_foot_top = 2.10;
z_foot_blend = 3.00;
z_chamfer_start = 11.20;
z_top = body_h;

// ---------- v7-style face panels ----------
panel_border = 1;
panel_depth = 1;
panel_taper_degrees = 50;
panel_taper_run = panel_depth * tan(panel_taper_degrees);
panel_front_outset = 1.5; // deliberately crosses the slightly sloped v8 wall

// ---------- Derived ----------
hex_r = hex_flat_to_flat / sqrt(3);
mouth_hex_r = pocket_mouth_flat_to_flat / sqrt(3);
minimum_top_web_unshifted = pitch - pocket_mouth_flat_to_flat;
minimum_straight_web_unshifted = pitch - hex_flat_to_flat;
outer_floor_projected_af = hex_flat_to_flat / cos(outer_tilt_degrees);
minimum_floor_horizontal_web = pitch - outer_floor_projected_af;
floor_support_at_flats = (hex_flat_to_flat - floor_relief_diameter) / 2;

function ring_index(q, r) = max(abs(q), abs(r), abs(q + r));
function tilt_for_ring(ring) = ring == 0 ? 0 : ring == 1 ? inner_tilt_degrees : outer_tilt_degrees;
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
// while preserving the proven v8 outer silhouette and useful wall-facet sizes.
module body_hex_2d(r) {
    rotate(shaft_hex_rotation) circle(r=r, $fn=6);
}

module pocket_cluster_2d(z) {
    union() {
        for (q=[-2:2])
            for (r=[-2:2]) {
                ring=ring_index(q,r);
                if (ring <= 2) {
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

    // Both lead-in slices use the deliberately rotated mouth hex.
    // The lower slice intersects the 30-degree shaft and creates the scalloped mismatch.
    hull() {
        translate([0,0,body_h-pocket_mouth_chamfer_h])
            mouth_hex_prism(hex_r,0.03);
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

// 5 mm through-hole plus an upside-down-print-friendly transition.
// The transition ends in a 7 mm circle one millimetre into the pocket.
// A 7 mm circle is inscribed in the 7 mm AF hex, so only ~0.54 mm corner slivers
// remain at that layer; those are within the demonstrated line-width capability.
module floor_relief(x0,y0,ring) {
    radius=sqrt(x0*x0+y0*y0);
    ux=radius < centre_epsilon ? 0 : x0/radius;
    uy=radius < centre_epsilon ? 0 : y0/radius;
    shift_top=ring == 0 ? 0 : floor_relief_chamfer_h*tan(tilt_for_ring(ring));
    x_top=x0+shift_top*ux;
    y_top=y0+shift_top*uy;

    union() {
        translate([x0,y0,-0.05])
            cylinder(d=floor_relief_diameter,h=base_thickness+0.10,$fn=48);

        hull() {
            translate([x0,y0,base_thickness-0.02])
                cylinder(d=floor_relief_diameter,h=0.03,$fn=48);
            translate([x_top,y_top,base_thickness+floor_relief_chamfer_h])
                cylinder(d=floor_relief_top_diameter,h=0.03,$fn=48);
        }
    }
}

module all_pockets_and_floor_reliefs() {
    union() {
        for (q=[-2:2])
            for (r=[-2:2]) {
                ring=ring_index(q,r);
                if (ring <= 2) {
                    x0=centre_x(q,r); y0=centre_y(q,r);
                    if (ring == 0) centre_pocket();
                    else tilted_pocket(x0,y0,ring);
                    floor_relief(x0,y0,ring);
                }
            }
    }
}

// 18 tapered panel cutters on the actual convex outer-wall faces.
// The v8 shell grows outward slightly with height; each cutter therefore
// starts 1.5 mm outside a representative mid-height face before tapering
// 1.0 mm into the wall. This keeps the opening connected to the exterior
// across the whole sloped facet rather than creating buried voids.
wall_profile_points = [
    [0, -24.817335],
    [-9.42865, -24.702479],
    [-16.67865, -20.51669],
    [-21.492443, -12.408668],
    [-26.107299, -4.185789],
    [-26.107299, 4.185789],
    [-21.492443, 12.408668],
    [-16.67865, 20.51669],
    [-9.42865, 24.702479],
    [0, 24.817335],
    [9.42865, 24.702479],
    [16.67865, 20.51669],
    [21.492443, 12.408668],
    [26.107299, 4.185789],
    [26.107299, -4.185789],
    [21.492443, -12.408668],
    [16.67865, -20.51669],
    [9.42865, -24.702479]
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
    inner_length=opening_length-2*panel_taper_run;
    inner_height=opening_height-2*panel_taper_run;

    assert(inner_length > 1.0, "Face panel leaves too little back flat");
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
            translate([panel_border+panel_taper_run, panel_depth-0.02,
                       z_foot_blend+panel_border+panel_taper_run])
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
assert(1+6+12 == 19, "Radius-2 hex lattice must contain 19 pockets");
assert(abs(inner_tilt_degrees-4.0)<0.001, "Inner ring must remain 4 degrees");
assert(abs(outer_tilt_degrees-8.0)<0.001, "Outer ring must remain 8 degrees");
assert(abs(mouth_hex_rotation-shaft_hex_rotation-15.0)<0.001,
       "All mouth chamfers should remain deliberately 15 degrees misaligned");
assert(floor_relief_diameter == 5.0, "Effect-plate relief hole should remain 5 mm");
assert(abs(floor_relief_chamfer_h-1.0)<0.001,
       "Floor relief transition should remain 1 mm high");
assert(floor_support_at_flats >= 1.0-0.001,
       "5 mm hole should leave 1 mm support at the 7 mm hex flats");
assert(minimum_top_web_unshifted >= 0.5-0.001,
       "Nominal top web is below the demonstrated 0.5 mm printable width");
assert(minimum_straight_web_unshifted >= 2.0-0.001,
       "Straight pocket web is below 2 mm");
assert(panel_border == 1.0, "Face-panel border should remain 1 mm");
assert(abs(panel_taper_degrees-50.0)<0.001,
       "Face-panel taper should remain 50 degrees");
assert(panel_depth == 1.0,
       "Panel depth chosen to keep useful back-flat on the short v8 facets");
assert(lower_edge_chamfer > 0 && lower_edge_chamfer <= foot_flare,
       "Lower-edge chamfer must fit within the flared foot");

stand();
