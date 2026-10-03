// Material-efficient dense 51-pocket hex-bit stand, v7
// Derived from v4-dense-51.
//
// Changes from v4:
// - 5.6 mm through-hole in the 1 mm floor beneath every bit pocket
// - continuous recessed waist/belt removed
// - every nominal vertical outer-wall face gets its own tapered recessed panel
//   with a 1.0 mm border, 1.2 mm cut depth, and 50 degree inward taper
//
// Designed for a 0.6 mm nozzle and support-free FDM printing.
// Units: millimetres.

$fn = 48;

// ---------- Pocket layout ----------
row_counts = [6, 7, 8, 9, 8, 7, 6];
total_pockets = 51;

hex_flat_to_flat = 7.0;
pocket_depth = 12.0;
base_thickness = 1.0;
pocket_mouth_chamfer_h = 0.6;
pocket_mouth_flat_to_flat = 8.2;

pitch = 8.8;
pitch_x = pitch;
pitch_y = pitch * sqrt(3) / 2;

// New floor relief.
floor_relief_diameter = 5.6;

// ---------- Contoured body ----------
wall_margin = 2.4;
body_h = pocket_depth + base_thickness;

foot_flare = 0.6;
lower_edge_chamfer = 0.4;
top_chamfer_inset = 0.6;

// The old continuous waist groove is intentionally absent.
z0 = 0.00;
z_lower_chamfer_top = lower_edge_chamfer;
z_foot_top = 1.80;
z_foot_blend = 2.40;
z_chamfer_start = body_h - top_chamfer_inset;
z_top = body_h;

// ---------- Per-face recessed panels ----------
// Fusion-style interpretation:
// sketch on each wall face -> offset border inward 1 mm -> tapered cut.
// The cutter narrows as it enters the body, creating a chamfered recess.
panel_border = 1.0;
panel_depth = 1.2;
panel_taper_degrees = 50.0;
panel_plate_thickness = 0.04;
panel_taper_run = panel_depth * tan(panel_taper_degrees);

// Exact nominal vertical-wall perimeter extracted from the generated v4 wall.
// These are the 16 actual planar faces, listed counter-clockwise.
// The faces exist from z_foot_blend to z_chamfer_start.
wall_profile_points = [
    [37.300000, -11.373800],
    [41.700000, -3.752760],
    [41.700000, 3.752760],
    [37.300000, 11.373800],
    [28.500000, 26.615800],
    [22.000000, 30.368600],
    [-22.000000, 30.368600],
    [-28.500000, 26.615800],
    [-37.300000, 11.373800],
    [-41.700000, 3.752760],
    [-41.700000, -3.752760],
    [-37.300000, -11.373800],
    [-28.500000, -26.615800],
    [-22.000000, -30.368600],
    [22.000000, -30.368600],
    [28.500000, -26.615800]
];

// ---------- Derived ----------
hex_r = hex_flat_to_flat / sqrt(3);
mouth_hex_r = pocket_mouth_flat_to_flat / sqrt(3);
minimum_top_web = pitch - pocket_mouth_flat_to_flat;
minimum_straight_web = pitch - hex_flat_to_flat;
floor_ring_at_flats = (hex_flat_to_flat - floor_relief_diameter) / 2;

module pocket_hex_2d(r) {
    rotate(30)
        circle(r = r, $fn = 6);
}

module pocket_cluster_2d() {
    union() {
        for (ri = [0 : len(row_counts)-1]) {
            count = row_counts[ri];
            y = (ri - (len(row_counts)-1)/2) * pitch_y;
            for (ci = [0 : count-1]) {
                x = (ci - (count-1)/2) * pitch_x;
                translate([x, y])
                    pocket_hex_2d(mouth_hex_r);
            }
        }
    }
}

module body_profile_2d(extra = 0) {
    offset(delta = wall_margin + extra)
        pocket_cluster_2d();
}

module profile_slice(z, extra, thickness = 0.03) {
    translate([0, 0, z])
        linear_extrude(height = thickness)
            body_profile_2d(extra);
}

module loft_segment(z1, extra1, z2, extra2) {
    hull() {
        profile_slice(z1, extra1);
        profile_slice(z2 - 0.03, extra2);
    }
}

module styled_body() {
    union() {
        // Softened lower lip retained from the current v4.
        loft_segment(z0, foot_flare - lower_edge_chamfer,
                     z_lower_chamfer_top, foot_flare);
        loft_segment(z_lower_chamfer_top, foot_flare,
                     z_foot_top, foot_flare);
        loft_segment(z_foot_top, foot_flare, z_foot_blend, 0);

        // Plain vertical wall: no continuous waist/indent.
        loft_segment(z_foot_blend, 0, z_chamfer_start, 0);

        // 0.6 mm 45-degree top chamfer.
        loft_segment(z_chamfer_start, 0, z_top, -top_chamfer_inset);
    }
}

module hex_prism(r, h) {
    linear_extrude(height = h)
        pocket_hex_2d(r);
}

module bit_pocket() {
    translate([0, 0, base_thickness])
        hex_prism(hex_r, pocket_depth - pocket_mouth_chamfer_h + 0.08);

    hull() {
        translate([0, 0, body_h - pocket_mouth_chamfer_h])
            hex_prism(hex_r, 0.03);
        translate([0, 0, body_h + 0.03])
            hex_prism(mouth_hex_r, 0.04);
    }
}

module floor_relief_hole() {
    // Pass completely through the 1 mm floor and slightly into the pocket.
    translate([0, 0, -0.05])
        cylinder(d = floor_relief_diameter, h = base_thickness + 0.10, $fn = 48);
}

module all_pockets_and_floor_reliefs() {
    for (ri = [0 : len(row_counts)-1]) {
        count = row_counts[ri];
        y = (ri - (len(row_counts)-1)/2) * pitch_y;
        for (ci = [0 : count-1]) {
            x = (ci - (count-1)/2) * pitch_x;
            translate([x, y, 0]) {
                bit_pocket();
                floor_relief_hole();
            }
        }
    }
}

// A single tapered panel cutter for one counter-clockwise wall-profile edge.
module wall_face_panel(p0, p1) {
    dx = p1[0] - p0[0];
    dy = p1[1] - p0[1];
    face_length = sqrt(dx*dx + dy*dy);

    ux = dx / face_length;
    uy = dy / face_length;

    // Left-hand normal points into this counter-clockwise polygon.
    nx = -uy;
    ny = ux;

    panel_height = z_chamfer_start - z_foot_blend;
    opening_length = face_length - 2*panel_border;
    opening_height = panel_height - 2*panel_border;
    inner_length = opening_length - 2*panel_taper_run;
    inner_height = opening_height - 2*panel_taper_run;

    assert(opening_length > 0,
           "A wall face is too short for the requested 1 mm panel border");
    assert(inner_length > 0.25,
           "Panel depth/taper leaves too little flat area on a short wall face");
    assert(inner_height > 0.25,
           "Panel depth/taper leaves too little flat area vertically");

    // Local X = along face, local Y = inward, local Z = global Z.
    multmatrix([
        [ux, nx, 0, p0[0]],
        [uy, ny, 0, p0[1]],
        [ 0,  0, 1, 0],
        [ 0,  0, 0, 1]
    ])
        hull() {
            // Slightly straddles the actual face to guarantee a clean boolean.
            translate([panel_border,
                       -panel_plate_thickness/2,
                       z_foot_blend + panel_border])
                cube([opening_length,
                      panel_plate_thickness,
                      opening_height]);

            // Recess floor; 50-degree taper shrinks the cut on all four sides.
            translate([panel_border + panel_taper_run,
                       panel_depth - panel_plate_thickness/2,
                       z_foot_blend + panel_border + panel_taper_run])
                cube([inner_length,
                      panel_plate_thickness,
                      inner_height]);
        }
}

module all_wall_face_panels() {
    for (i = [0 : len(wall_profile_points)-1]) {
        p0 = wall_profile_points[i];
        p1 = wall_profile_points[(i+1) % len(wall_profile_points)];
        wall_face_panel(p0, p1);
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
assert(total_pockets == 51,
       "This variant is specifically the dense 51-pocket stand");
assert(abs((body_h - pocket_depth) - base_thickness) < 0.001,
       "Pocket depth/base thickness relationship is inconsistent");
assert(floor_relief_diameter < hex_flat_to_flat,
       "Floor relief must remain smaller than the functional hex pocket");
assert(floor_ring_at_flats >= 0.7 - 0.001,
       "5.6 mm floor hole should retain at least 0.7 mm at the pocket flats");
assert(minimum_top_web >= 0.6 - 0.001,
       "Top web between adjacent pocket mouths is below one 0.6 mm line");
assert(minimum_straight_web >= 1.8 - 0.001,
       "Straight pocket web is below three 0.6 mm lines");
assert(panel_border == 1.0,
       "Wall-panel border is intended to remain exactly 1 mm");
assert(abs(panel_taper_degrees - 50.0) < 0.001,
       "Wall-panel taper is intended to remain 50 degrees");
assert(panel_depth < wall_margin,
       "Panel recess must not consume the full nominal outer-wall margin");
assert(lower_edge_chamfer > 0 && lower_edge_chamfer <= foot_flare,
       "Lower-edge chamfer must fit within the flared foot");

stand();
