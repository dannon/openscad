// Rounded Box Library
// Parametric rounded rectangular boxes for enclosures, trays, etc.

// Solid rounded box (filled)
module rounded_cube(size, r=2) {
    x = size[0];
    y = size[1];
    z = size[2];

    hull() {
        for (dx = [r, x-r])
            for (dy = [r, y-r])
                translate([dx, dy, 0])
                    cylinder(h=z, r=r);
    }
}

// Hollow rounded box (tray/container)
// size: [width, depth, height] outer dimensions
// r: corner radius
// wall: wall thickness
// bottom: bottom thickness (defaults to wall)
module rounded_box(size, r=2, wall=2, bottom=undef) {
    x = size[0];
    y = size[1];
    z = size[2];
    b = bottom == undef ? wall : bottom;

    // Ensure inner radius doesn't go negative
    inner_r = max(0.1, r - wall);

    difference() {
        rounded_cube(size, r);
        translate([wall, wall, b])
            rounded_cube([x - 2*wall, y - 2*wall, z], inner_r);
    }
}

// Rounded box with lid lip
// Creates a box with a stepped edge for a friction-fit lid
module rounded_box_with_lip(size, r=2, wall=2, lip_height=3, lip_inset=1.2) {
    x = size[0];
    y = size[1];
    z = size[2];
    inner_r = max(0.1, r - wall);

    difference() {
        rounded_cube(size, r);

        // Main cavity
        translate([wall, wall, wall])
            rounded_cube([x - 2*wall, y - 2*wall, z], inner_r);

        // Lip cutout
        translate([wall - lip_inset, wall - lip_inset, z - lip_height])
            rounded_cube([x - 2*wall + 2*lip_inset, y - 2*wall + 2*lip_inset, lip_height + 1], inner_r);
    }
}

// Lid for rounded_box_with_lip
// tolerance: gap for fit (positive = looser)
module rounded_lid(size, r=2, wall=2, lip_height=3, lip_inset=1.2, tolerance=0.15) {
    x = size[0];
    y = size[1];
    inner_r = max(0.1, r - wall);

    lid_thickness = wall;
    insert_height = lip_height - 0.5;

    // Outer lid surface
    rounded_cube([x, y, lid_thickness], r);

    // Insert portion
    translate([wall - lip_inset + tolerance, wall - lip_inset + tolerance, lid_thickness - 0.01])
        rounded_cube([
            x - 2*wall + 2*lip_inset - 2*tolerance,
            y - 2*wall + 2*lip_inset - 2*tolerance,
            insert_height
        ], max(0.1, inner_r - tolerance));
}

// Example usage (uncomment to preview)
// rounded_box([60, 40, 25], r=3, wall=2);
// translate([70, 0, 0]) rounded_box_with_lip([60, 40, 25], r=3);
// translate([70, 50, 0]) rounded_lid([60, 40, 25], r=3);
