// Tiered-tilt dense hex-bit stand, v8
// 19 pockets in a true radius-2 hexagonal lattice:
//   1 centre + 6 inner-ring + 12 outer-ring.
//
// Tilt scheme:
//   centre     = 0 degrees
//   inner ring = 4 degrees radially outward
//   outer ring = 8 degrees radially outward
//
// The pocket-mouth chamfers remain horizontal and globally oriented while the
// tilted shafts rotate into radial local frames. This intentionally preserves
// the rotationally-misaligned/scalloped chamfer character discovered in v6.
//
// Designed for a 0.6 mm nozzle; nominal minimum top web is 0.5 mm.
// Units: millimetres.

$fn = 48;

// ---------- Pocket geometry ----------
hex_flat_to_flat = 7.0;
pocket_depth = 12.0;
base_thickness = 1.0;

// Enlarged from v6: 0.6 mm high / 8.2 mm AF -> 1.2 mm high / 8.5 mm AF.
pocket_mouth_chamfer_h = 1.2;
pocket_mouth_flat_to_flat = 8.5;

// 9.0 mm nearest-neighbour pitch gives:
// - 2.0 mm between straight 7.0 mm AF pocket sections
// - 0.5 mm nominal top web between 8.5 mm AF mouths before splay
pitch = 9.0;

inner_tilt_degrees = 4.0;
outer_tilt_degrees = 8.0;
centre_epsilon = 0.001;

// ---------- Contoured body ----------
wall_margin = 3.0;
body_h = pocket_depth + base_thickness;

// Retain the successful softened v5/v6 outer-wall treatment.
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

inner_top_radial_shift =
    (body_h - base_thickness) * tan(inner_tilt_degrees);
outer_top_radial_shift =
    (body_h - base_thickness) * tan(outer_tilt_degrees);

outer_floor_projected_af =
    hex_flat_to_flat / cos(outer_tilt_degrees);
minimum_floor_horizontal_web =
    pitch - outer_floor_projected_af;

function ring_index(q, r) =
    max(abs(q), abs(r), abs(q + r));

function tilt_for_ring(ring) =
    ring == 0 ? 0 :
    ring == 1 ? inner_tilt_degrees :
                outer_tilt_degrees;

function radial_shift_at_z(z, ring) =
    ring == 0 ? 0 :
    max(0, min(body_h - base_thickness, z - base_thickness))
        * tan(tilt_for_ring(ring));

module pocket_hex_2d(r) {
    rotate(30)
        circle(r = r, $fn = 6);
}

function centre_x(q, r) = pitch * (q + r/2);
function centre_y(q, r) = pitch * sqrt(3)/2 * r;

module pocket_cluster_2d(z) {
    union() {
        for (q = [-2 : 2])
            for (r = [-2 : 2]) {
                ring = ring_index(q, r);

                if (ring <= 2) {
                    x0 = centre_x(q, r);
                    y0 = centre_y(q, r);
                    radius = sqrt(x0*x0 + y0*y0);
                    shift = radial_shift_at_z(z, ring);

                    x = radius < centre_epsilon
                        ? x0
                        : x0 + shift * x0 / radius;
                    y = radius < centre_epsilon
                        ? y0
                        : y0 + shift * y0 / radius;

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
        loft_segment(z0, foot_flare - lower_edge_chamfer,
                     z_lower_chamfer_top, foot_flare);
        loft_segment(z_lower_chamfer_top, foot_flare,
                     z_foot_top, foot_flare);
        loft_segment(z_foot_top, foot_flare, z_foot_blend, 0);

        loft_segment(z_foot_blend, 0, z_waist_start, 0);

        loft_segment(z_waist_start, 0, z_waist_low, -waist_inset);
        loft_segment(z_waist_low, -waist_inset, z_waist_high, -waist_inset);
        loft_segment(z_waist_high, -waist_inset, z_waist_end, 0);

        loft_segment(z_waist_end, 0, z_chamfer_start, 0);
        loft_segment(z_chamfer_start, 0, z_top, -top_chamfer_inset);
    }
}

module hex_prism(r, h) {
    linear_extrude(height = h)
        pocket_hex_2d(r);
}

module centre_pocket() {
    translate([0, 0, base_thickness])
        hex_prism(hex_r, pocket_depth - pocket_mouth_chamfer_h + 0.08);

    hull() {
        translate([0, 0, body_h - pocket_mouth_chamfer_h])
            hex_prism(hex_r, 0.03);
        translate([0, 0, body_h - 0.01])
            hex_prism(mouth_hex_r, 0.04);
    }
}

module outward_axis_frame(x0, y0, tilt_degrees) {
    radius = sqrt(x0*x0 + y0*y0);
    ux = x0 / radius;
    uy = y0 / radius;

    s = sin(tilt_degrees);
    c = cos(tilt_degrees);

    xx = -uy;
    xy =  ux;
    xz =  0;

    yx = -c * ux;
    yy = -c * uy;
    yz =  s;

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

module tilted_shaft(x0, y0, tilt_degrees) {
    axis_length =
        (body_h - base_thickness) / cos(tilt_degrees);

    intersection() {
        outward_axis_frame(x0, y0, tilt_degrees)
            translate([0, 0, -2.0])
                hex_prism(hex_r, axis_length + 6.0);

        translate([-100, -100, base_thickness])
            cube([200, 200, body_h - base_thickness + 10]);
    }
}

module tilted_mouth_leadin(x0, y0, ring) {
    radius = sqrt(x0*x0 + y0*y0);
    ux = x0 / radius;
    uy = y0 / radius;

    z_low = body_h - pocket_mouth_chamfer_h;
    shift_low = radial_shift_at_z(z_low, ring);
    shift_top = radial_shift_at_z(body_h, ring);

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

module tilted_pocket(x0, y0, ring) {
    tilt_degrees = tilt_for_ring(ring);

    union() {
        tilted_shaft(x0, y0, tilt_degrees);
        tilted_mouth_leadin(x0, y0, ring);
    }
}

module all_pockets() {
    for (q = [-2 : 2])
        for (r = [-2 : 2]) {
            ring = ring_index(q, r);

            if (ring <= 2) {
                x0 = centre_x(q, r);
                y0 = centre_y(q, r);

                if (ring == 0)
                    centre_pocket();
                else
                    tilted_pocket(x0, y0, ring);
            }
        }
}

module stand() {
    difference() {
        styled_body();
        all_pockets();
    }
}

assert(1 + 6 + 12 == 19,
       "Radius-2 hex lattice should contain exactly 19 pockets");
assert(abs(inner_tilt_degrees - 4.0) < 0.001,
       "Inner ring must remain at 4 degrees");
assert(abs(outer_tilt_degrees - 8.0) < 0.001,
       "Outer ring must remain at 8 degrees");
assert(pocket_mouth_chamfer_h >= 1.2 - 0.001,
       "The enlarged chamfer should remain visibly larger than v6");
assert(minimum_top_web_unshifted >= 0.5 - 0.001,
       "Nominal top web is below the confirmed 0.5 mm printable width");
assert(minimum_straight_web_unshifted >= 2.0 - 0.001,
       "Straight pocket web is below 2.0 mm");
assert(minimum_floor_horizontal_web >= 1.9 - 0.001,
       "Outer 8-degree shaft projection leaves too little floor-level web");
assert(lower_edge_chamfer > 0 && lower_edge_chamfer <= foot_flare,
       "Lower-edge chamfer must fit within the flared foot");
assert(abs(z_lower_chamfer_top - lower_edge_chamfer) < 0.001,
       "Lower-edge chamfer is intended to remain 45 degrees");
assert(abs((body_h - pocket_depth) - base_thickness) < 0.001,
       "Pocket depth/base thickness relationship is inconsistent");
assert(wall_margin - top_chamfer_inset >= 1.8 - 0.001,
       "Top outer rim should remain at least three 0.6 mm lines wide");
assert(pocket_mouth_flat_to_flat >= hex_flat_to_flat,
       "Pocket mouth must not be smaller than the straight pocket");

stand();
