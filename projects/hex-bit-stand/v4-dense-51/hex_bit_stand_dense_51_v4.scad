// Dense contoured hex-bit stand, v4
// 51 pockets in a compact 6-7-8-9-8-7-6 triangular/hexagonal lattice.
// Designed for a 0.6 mm nozzle and support-free FDM printing.
// Units: millimetres.

$fn = 48;

// ---------- Pocket layout ----------
row_counts = [6, 7, 8, 9, 8, 7, 6];
total_pockets = 51;

hex_flat_to_flat = 7.0;       // functional pocket size
pocket_depth = 12.0;
base_thickness = 1.0;
pocket_mouth_chamfer_h = 0.6;
pocket_mouth_flat_to_flat = 8.2;

// Nearest-neighbour spacing on a true triangular lattice.
// 8.8 mm pitch leaves a single 0.6 mm extrusion-width web at the very top
// of the 8.2 mm AF lead-in, widening to 1.8 mm (three nozzle widths)
// through the 7.0 mm AF straight pocket section.
pitch = 8.8;
pitch_x = pitch;
pitch_y = pitch * sqrt(3) / 2;

// ---------- Contoured body ----------
// The body outline is an offset of the actual outer pocket cluster,
// so it follows the honeycomb instead of enclosing it in a rectangle.
wall_margin = 2.4;             // four 0.6 mm nozzle widths
body_h = pocket_depth + base_thickness; // 13.0 mm

// Side-wall styling, all based on 0.6 mm nozzle increments.
foot_flare = 0.6;              // small lower plinth
waist_inset = 0.6;             // recessed accent belt
top_chamfer_inset = 0.6;       // 45 degree top-edge chamfer

// Z stations for the faceted wall profile.
z0 = 0.00;
z_foot_top = 0.60;
z_foot_blend = 1.20;
z_waist_start = 7.00;
z_waist_low = 7.60;
z_waist_high = 8.20;
z_waist_end = 8.80;
z_chamfer_start = body_h - top_chamfer_inset; // 45 degree
z_top = body_h;

// ---------- Derived ----------
hex_r = hex_flat_to_flat / sqrt(3);
mouth_hex_r = pocket_mouth_flat_to_flat / sqrt(3);
minimum_top_web = pitch - pocket_mouth_flat_to_flat;
minimum_straight_web = pitch - hex_flat_to_flat;

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
                // Alternating odd/even row counts naturally stagger by half a pitch.
                x = (ci - (count-1)/2) * pitch_x;
                translate([x, y])
                    pocket_hex_2d(mouth_hex_r);
            }
        }
    }
}

// Body outline follows the union of the outermost pocket mouths.
// `extra` modifies the nominal margin for the side-wall styling.
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
        // Low 0.6 mm flared foot, then return to the main contour.
        loft_segment(z0, foot_flare, z_foot_top, foot_flare);
        loft_segment(z_foot_top, foot_flare, z_foot_blend, 0);

        // Main faceted wall.
        loft_segment(z_foot_blend, 0, z_waist_start, 0);

        // Recessed 0.6 mm belt gives the wall a machined/tool-organizer look.
        loft_segment(z_waist_start, 0, z_waist_low, -waist_inset);
        loft_segment(z_waist_low, -waist_inset, z_waist_high, -waist_inset);
        loft_segment(z_waist_high, -waist_inset, z_waist_end, 0);

        // Upper wall and true 45 degree top-edge chamfer.
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
assert(total_pockets >= 48 && total_pockets <= 56,
       "Capacity should remain around four times the original 13 pockets");
assert(abs((body_h - pocket_depth) - base_thickness) < 0.001,
       "Pocket depth/base thickness relationship is inconsistent");
assert(base_thickness >= 1.0,
       "Base thickness below 1.0 mm is not recommended");
assert(minimum_top_web >= 0.6 - 0.001,
       "Top web between adjacent pocket mouths is below one 0.6 mm line");
assert(minimum_straight_web >= 1.8,
       "Straight pocket web is too thin");
assert(wall_margin - top_chamfer_inset >= 1.8 - 0.001,
       "Top outer rim should remain at least three 0.6 mm lines wide");
assert(wall_margin - waist_inset >= 1.8 - 0.001,
       "Waist band leaves too little outer-wall material");
assert(pocket_mouth_flat_to_flat >= hex_flat_to_flat,
       "Pocket mouth must not be smaller than the straight pocket");

stand();
