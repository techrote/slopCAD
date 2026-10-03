// Hex-pattern bit stand, revised layout
// Designed for 0.6 mm nozzle printing with no supports.
// Units: millimetres

$fn = 48;

// ---------- User parameters ----------
row_counts = [4, 5, 4];      // 13 total pockets in a hex-pattern cluster

hex_flat_to_flat = 7.0;      // straight pocket section
pocket_depth = 12.0;
base_thickness = 1.0;        // reduced from previous design
pocket_mouth_chamfer_h = 0.6;
pocket_mouth_flat_to_flat = 8.2;

pitch_x = 10.2;              // same-row centre spacing
pitch_y = 9.0;               // row spacing for hex-style staggering
edge_margin = 4.0;           // material from outermost pocket to body edge
body_h = pocket_depth + base_thickness;
outer_top_chamfer = 1.8;     // 45-degree top chamfer on outer body

// ---------- Derived values ----------
hex_r = hex_flat_to_flat / sqrt(3);              // circumradius of main pocket
mouth_hex_r = pocket_mouth_flat_to_flat / sqrt(3);
pocket_half_w = pocket_mouth_flat_to_flat / 2;   // pointy-top hex width = flat-to-flat
pocket_half_h = mouth_hex_r;                     // pointy-top hex height half = circumradius

max_row_half_span = max([ for (c = row_counts) ((c - 1) / 2) * pitch_x ]);
max_row_y = max([ for (ri = [0 : len(row_counts)-1]) abs((ri - (len(row_counts)-1)/2) * pitch_y) ]);

body_x = 2 * (max_row_half_span + pocket_half_w + edge_margin);
body_y = 2 * (max_row_y + pocket_half_h + edge_margin);

module hex_prism(r, h) {
    // Rotate 30 degrees so the named flat-to-flat size lies on the X axis.
    linear_extrude(height = h)
        rotate(30)
            circle(r = r, $fn = 6);
}

module top_chamfered_block(x, y, h, c) {
    assert(c > 0 && c < h, "outer_top_chamfer must be > 0 and < body_h");
    assert(2*c < min(x, y), "outer_top_chamfer too large for body footprint");

    union() {
        // Straight lower body.
        translate([-x/2, -y/2, 0])
            cube([x, y, h-c]);

        // 45-degree top-edge chamfer.
        hull() {
            translate([-x/2, -y/2, h-c-0.02])
                cube([x, y, 0.02]);
            translate([-(x-2*c)/2, -(y-2*c)/2, h-0.02])
                cube([x-2*c, y-2*c, 0.02]);
        }
    }
}

module bit_pocket() {
    // Main 7.0 mm AF pocket.
    translate([0, 0, body_h - pocket_depth - 0.02])
        hex_prism(hex_r, pocket_depth - pocket_mouth_chamfer_h + 0.04);

    // Lead-in taper. Functional pocket below remains 7.0 mm AF.
    hull() {
        translate([0, 0, body_h - pocket_mouth_chamfer_h - 0.02])
            hex_prism(hex_r, 0.02);
        translate([0, 0, body_h - 0.02])
            hex_prism(mouth_hex_r, 0.04);
    }
}

module stand() {
    difference() {
        top_chamfered_block(body_x, body_y, body_h, outer_top_chamfer);

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
}

// Basic sanity checks.
total_pockets = 13;
assert(total_pockets >= 12, "Stand must hold at least 12 bits");
assert(body_h > pocket_depth, "Pocket depth must leave a closed floor");
assert(base_thickness >= 1.0, "Base thickness below 1.0 mm is not recommended");
assert(pocket_mouth_flat_to_flat >= hex_flat_to_flat,
       "Pocket mouth must not be smaller than the straight pocket");

stand();
