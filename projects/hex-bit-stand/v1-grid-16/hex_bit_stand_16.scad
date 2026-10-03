// 16-bit hex driver stand
// Designed for 0.6 mm nozzle printing with no supports.
// Units: millimetres

$fn = 48;

// ---------- User parameters ----------
columns = 4;
rows = 4;

hex_flat_to_flat = 7.0;       // straight pocket section
pocket_depth = 12.0;
pocket_mouth_chamfer_h = 0.6;
pocket_mouth_flat_to_flat = 8.2;

pitch_x = 10.8;               // 18 nozzle widths @ 0.6 mm
pitch_y = 10.8;

body_x = 52.8;                // 88 nozzle widths
body_y = 52.8;
body_h = 18.0;
outer_top_chamfer = 2.4;      // 4 nozzle widths; 45 degree

// ---------- Derived values ----------
hex_r = hex_flat_to_flat / sqrt(3);              // circumradius
mouth_hex_r = pocket_mouth_flat_to_flat / sqrt(3);

module hex_prism(r, h) {
    // Rotate 30 degrees so the named dimension is flat-to-flat on X/Y.
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
    // Main 7.0 mm AF pocket. Extend slightly upward to avoid coplanar artifacts.
    translate([0, 0, body_h - pocket_depth - 0.02])
        hex_prism(hex_r, pocket_depth - pocket_mouth_chamfer_h + 0.04);

    // 0.6 mm tall lead-in taper. The functional pocket below remains 7.0 mm AF.
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

        for (ix = [0 : columns-1])
            for (iy = [0 : rows-1]) {
                x = (ix - (columns-1)/2) * pitch_x;
                y = (iy - (rows-1)/2) * pitch_y;
                translate([x, y, 0])
                    bit_pocket();
            }
    }
}

// Basic sanity checks.
assert(columns * rows >= 12, "Stand must hold at least 12 bits");
assert(body_h > pocket_depth, "Pocket depth must leave a closed floor");
assert(pocket_mouth_flat_to_flat >= hex_flat_to_flat,
       "Pocket mouth must not be smaller than the straight pocket");

stand();
