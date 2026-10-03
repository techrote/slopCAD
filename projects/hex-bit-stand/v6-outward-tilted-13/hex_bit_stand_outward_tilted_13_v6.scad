// Dense contoured hex-bit stand, outward-tilted variant v6
// Derived from repository v5-dense-contoured-13.
// Centre pocket remains vertical. The twelve outer pockets point 10 degrees
// radially away from the centre of the stand.
// Designed for a 0.6 mm nozzle and support-free FDM printing.
// Units: millimetres.

$fn = 48;

// ---------- Pocket layout ----------
row_counts = [4, 5, 4];
total_pockets = 13;

hex_flat_to_flat = 7.0;
pocket_depth = 12.0;
base_thickness = 1.0;
pocket_mouth_chamfer_h = 0.6;
pocket_mouth_flat_to_flat = 8.2;

pitch = 8.8;
pitch_x = pitch;
pitch_y = pitch * sqrt(3) / 2;

// Twelve outer pockets are tilted; the centre pocket is vertical.
outer_tilt_degrees = 10.0;
centre_epsilon = 0.001;

// ---------- Contoured body ----------
wall_margin = 3.0;
body_h = pocket_depth + base_thickness;

// Retain the softened lower lip and v5/v6 wall styling.
foot_flare = 0.6;
lower_edge_chamfer = 0.4;
waist_inset = 0.6;
top_chamfer_inset = 1.2;

// Z stations.
z0 = 0.00;
z_lower_chamfer_top = lower_edge_chamfer;
z_foot_top = 2.10;
z_foot_blend = 3.00;
z_waist_start = 7.20;
z_waist_low = 8.00;
z_waist_high = 8.50;
z_waist_end = 9.30;
z_chamfer_start = 11.20;
z_top = body_h;

// ---------- Derived ----------
hex_r = hex_flat_to_flat / sqrt(3);
mouth_hex_r = pocket_mouth_flat_to_flat / sqrt(3);
minimum_top_web_unshifted = pitch - pocket_mouth_flat_to_flat;
minimum_straight_web_unshifted = pitch - hex_flat_to_flat;
top_radial_shift = (body_h - base_thickness) * tan(outer_tilt_degrees);
axis_length_to_top = (body_h - base_thickness) / cos(outer_tilt_degrees);
floor_projected_af = hex_flat_to_flat / cos(outer_tilt_degrees);
minimum_floor_horizontal_web = pitch - floor_projected_af;

function radial_shift_at_z(z) =
    max(0, min(body_h - base_thickness, z - base_thickness))
    * tan(outer_tilt_degrees);

module pocket_hex_2d(r) {
    rotate(30)
        circle(r = r, $fn = 6);
}

// The body follows the splayed pocket centres as height increases.
// This avoids filling the whole top-envelope footprint with unnecessary plastic.
module pocket_cluster_2d(z) {
    shift = radial_shift_at_z(z);

    union() {
        for (ri = [0 : len(row_counts)-1]) {
            count = row_counts[ri];
            y0 = (ri - (len(row_counts)-1)/2) * pitch_y;

            for (ci = [0 : count-1]) {
                x0 = (ci - (count-1)/2) * pitch_x;
                r0 = sqrt(x0*x0 + y0*y0);

                x = r0 < centre_epsilon ? x0 : x0 + shift * x0 / r0;
                y = r0 < centre_epsilon ? y0 : y0 + shift * y0 / r0;

                translate([x, y])
                    pocket_hex_2d(mouth_hex_r);
            }
        }
    }
}

module body_profile_2d(z, extra = 0) {
    offset(delta = wall_margin + extra)
        pocket_cluster_2d(z);
}

module profile_slice(z, extra, thickness = 0.03) {
    translate([0, 0, z])
        linear_extrude(height = thickness)
            body_profile_2d(z, extra);
}

module loft_segment(z1, extra1, z2, extra2) {
    hull() {
        profile_slice(z1, extra1);
        profile_slice(z2 - 0.03, extra2);
    }
}

module styled_body() {
    union() {
        // 0.4 mm 45-degree softened lower edge and taller flared lip.
        loft_segment(z0, foot_flare - lower_edge_chamfer,
                     z_lower_chamfer_top, foot_flare);
        loft_segment(z_lower_chamfer_top, foot_flare,
                     z_foot_top, foot_flare);
        loft_segment(z_foot_top, foot_flare, z_foot_blend, 0);

        loft_segment(z_foot_blend, 0, z_waist_start, 0);

        // Recessed faceted belt.
        loft_segment(z_waist_start, 0, z_waist_low, -waist_inset);
        loft_segment(z_waist_low, -waist_inset, z_waist_high, -waist_inset);
        loft_segment(z_waist_high, -waist_inset, z_waist_end, 0);

        // Upper wall and top chamfer.
        loft_segment(z_waist_end, 0, z_chamfer_start, 0);
        loft_segment(z_chamfer_start, 0, z_top, -top_chamfer_inset);
    }
}

module hex_prism(r, h) {
    linear_extrude(height = h)
        pocket_hex_2d(r);
}

// Original vertical centre pocket.
module centre_pocket() {
    translate([0, 0, base_thickness])
        hex_prism(hex_r, pocket_depth - pocket_mouth_chamfer_h + 0.08);

    hull() {
        translate([0, 0, body_h - pocket_mouth_chamfer_h])
            hex_prism(hex_r, 0.03);
        translate([0, 0, body_h + 0.03])
            hex_prism(mouth_hex_r, 0.03);
    }
}

// Transform local +Z into the upward/outward pocket axis.
// The local origin is the pocket axis at the 1 mm floor.
module outward_axis_frame(x0, y0) {
    r0 = sqrt(x0*x0 + y0*y0);
    ux = x0 / r0;
    uy = y0 / r0;

    s = sin(outer_tilt_degrees);
    c = cos(outer_tilt_degrees);

    // Local X is tangential around the stand centre.
    xx = -uy;
    xy =  ux;
    xz =  0;

    // Local Y = axis × local-X, making a right-handed basis.
    yx = -c * ux;
    yy = -c * uy;
    yz =  s;

    // Local Z is the 10-degree outward/upward pocket axis.
    zx = s * ux;
    zy = s * uy;
    zz = c;

    multmatrix([
        [xx, yx, zx, x0],
        [xy, yy, zy, y0],
        [xz, yz, zz, base_thickness],
        [ 0,  0,  0, 1]
    ])
        children();
}

// 7.0 mm AF shaft, clipped at z=1 mm so every pocket retains the full floor.
module tilted_shaft(x0, y0) {
    intersection() {
        outward_axis_frame(x0, y0)
            translate([0, 0, -2.0])
                hex_prism(hex_r, axis_length_to_top + 6.0);

        translate([-100, -100, base_thickness])
            cube([200, 200, body_h - base_thickness + 10]);
    }
}

// Keep the familiar 0.6 mm-high lead-in, but centre it on the tilted axis.
// The mouth itself is horizontal and 8.2 mm AF for easy insertion.
module tilted_mouth_leadin(x0, y0) {
    r0 = sqrt(x0*x0 + y0*y0);
    ux = x0 / r0;
    uy = y0 / r0;

    z_low = body_h - pocket_mouth_chamfer_h;
    shift_low = radial_shift_at_z(z_low);
    shift_top = radial_shift_at_z(body_h);

    x_low = x0 + shift_low * ux;
    y_low = y0 + shift_low * uy;
    x_top = x0 + shift_top * ux;
    y_top = y0 + shift_top * uy;

    hull() {
        translate([x_low, y_low, z_low])
            hex_prism(hex_r, 0.03);
        translate([x_top, y_top, body_h - 0.01])
            hex_prism(mouth_hex_r, 0.04);
    }
}

module outer_pocket(x0, y0) {
    union() {
        tilted_shaft(x0, y0);
        tilted_mouth_leadin(x0, y0);
    }
}

module all_pockets() {
    for (ri = [0 : len(row_counts)-1]) {
        count = row_counts[ri];
        y0 = (ri - (len(row_counts)-1)/2) * pitch_y;

        for (ci = [0 : count-1]) {
            x0 = (ci - (count-1)/2) * pitch_x;
            r0 = sqrt(x0*x0 + y0*y0);

            if (r0 < centre_epsilon)
                centre_pocket();
            else
                outer_pocket(x0, y0);
        }
    }
}

module stand() {
    difference() {
        styled_body();
        all_pockets();
    }
}

// ---------- Sanity checks ----------
assert(total_pockets == 13,
       "This variant is specifically the dense 13-pocket stand");
assert(abs(outer_tilt_degrees - 10.0) < 0.001,
       "Outer-ring tilt must remain 10 degrees");
assert(top_radial_shift > 2.0 && top_radial_shift < 2.2,
       "Unexpected outer-mouth displacement for the 10-degree splay");
assert(lower_edge_chamfer > 0 && lower_edge_chamfer <= foot_flare,
       "Lower-edge chamfer must fit within the flared foot");
assert(abs(z_lower_chamfer_top - lower_edge_chamfer) < 0.001,
       "Lower-edge chamfer is intended to remain 45 degrees");
assert(abs((body_h - pocket_depth) - base_thickness) < 0.001,
       "Pocket depth/base thickness relationship is inconsistent");
assert(base_thickness >= 1.0,
       "Base thickness below 1.0 mm is not recommended");
assert(minimum_top_web_unshifted >= 0.6 - 0.001,
       "Base v5 mouth spacing must remain at least one 0.6 mm line");
assert(minimum_straight_web_unshifted >= 1.8 - 0.001,
       "Base v5 straight pocket spacing must remain three 0.6 mm lines");
assert(minimum_floor_horizontal_web >= 1.6,
       "Tilted floor projection leaves too little horizontal web");
assert(wall_margin - top_chamfer_inset >= 1.8 - 0.001,
       "Top outer rim should remain at least three 0.6 mm lines wide");
assert(pocket_mouth_flat_to_flat >= hex_flat_to_flat,
       "Pocket mouth must not be smaller than the straight pocket");

stand();
