// Contoured hex-bit stand, v3
// 13 pockets in a 4-5-4 hexagonal lattice.
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

pitch_x = 10.2;
pitch_y = 9.0;

// ---------- Contoured body ----------
// Nominal material around the widest part of the pocket mouths.
wall_margin = 3.0;            // five 0.6 mm nozzle widths

body_h = pocket_depth + base_thickness; // 13 mm total

// Side-wall styling. All horizontal changes are multiples of 0.6 mm.
foot_flare = 0.6;             // subtle lower plinth
lower_edge_chamfer = 0.4;      // soften bottom perimeter with a 45-degree chamfer
waist_inset = 0.6;            // shallow recessed accent band
top_chamfer_inset = 1.2;      // 2 nozzle widths at the top edge

// Z stations for faceted/tapered wall profile.
z0 = 0.00;
z_lower_chamfer_top = lower_edge_chamfer;
z_foot_top = 2.10;             // +1.20 mm lip height
z_foot_blend = 3.00;           // retain 0.90 mm return-to-wall blend
z_waist_start = 7.20;
z_waist_low = 8.00;
z_waist_high = 8.50;
z_waist_end = 9.30;
z_chamfer_start = 11.20;
z_top = body_h;

// ---------- Derived ----------
hex_r = hex_flat_to_flat / sqrt(3);
mouth_hex_r = pocket_mouth_flat_to_flat / sqrt(3);

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

// Body outline follows the union of the outermost pocket mouths.
// `extra` modifies the nominal wall margin for styling transitions.
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
        // Taller flared base/plinth with a softened bottom edge.
        loft_segment(z0, foot_flare - lower_edge_chamfer,
                     z_lower_chamfer_top, foot_flare);
        loft_segment(z_lower_chamfer_top, foot_flare,
                     z_foot_top, foot_flare);
        loft_segment(z_foot_top, foot_flare, z_foot_blend, 0);

        // Main wall.
        loft_segment(z_foot_blend, 0, z_waist_start, 0);

        // Shallow recessed faceted belt around the outer wall.
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

module bit_pocket() {
    // Straight 7.0 mm AF section begins exactly 1.0 mm above the print bed.
    translate([0, 0, base_thickness])
        hex_prism(hex_r, pocket_depth - pocket_mouth_chamfer_h + 0.08);

    // 0.6 mm lead-in taper. Functional pocket below remains 7.0 mm AF.
    hull() {
        translate([0, 0, body_h - pocket_mouth_chamfer_h])
            hex_prism(hex_r, 0.03);
        translate([0, 0, body_h + 0.03])
            hex_prism(mouth_hex_r, 0.03);
    }
}

module all_pockets() {
    for (ri = [0 : len(row_counts)-1]) {
        count = row_counts[ri];
        y = (ri - (len(row_counts)-1)/2) * pitch_y;
        for (ci = [0 : count-1]) {
            x = (ci - (count-1)/2) * pitch_x;
            translate([x, y, 0])
                bit_pocket();
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
assert(lower_edge_chamfer > 0 && lower_edge_chamfer <= foot_flare,
       "Lower-edge chamfer must fit within the flared foot");
assert(abs(z_lower_chamfer_top - lower_edge_chamfer) < 0.001,
       "Lower-edge chamfer is intended to remain 45 degrees");
assert(total_pockets >= 12, "Stand must hold at least 12 bits");
assert(body_h - pocket_depth == base_thickness,
       "Pocket depth/base thickness relationship is inconsistent");
assert(base_thickness >= 1.0,
       "Base thickness below 1.0 mm is not recommended");
assert(wall_margin - top_chamfer_inset >= 1.8,
       "Top rim should remain at least 1.8 mm wide for a 0.6 mm nozzle");
assert(wall_margin - waist_inset >= 1.8,
       "Waist band leaves too little material around pocket mouths");
assert(pocket_mouth_flat_to_flat >= hex_flat_to_flat,
       "Pocket mouth must not be smaller than the straight pocket");

stand();
