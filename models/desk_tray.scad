// Parametric Desk Tray
// A simple divided tray for small items
// PRINT: Flat on bed, no supports needed

use <../../lib/rounded_box.scad>

/* [Tray Dimensions] */
width = 80;       // Overall width
depth = 60;       // Overall depth
height = 20;      // Wall height

/* [Dividers] */
dividers_x = 1;   // Number of vertical dividers
dividers_y = 0;   // Number of horizontal dividers

/* [Print Settings] */
wall = 2;         // Wall thickness
corner_r = 3;     // Corner radius
$fn = 32;         // Circle resolution

// Derived values
inner_w = width - 2*wall;
inner_d = depth - 2*wall;
cell_w = inner_w / (dividers_x + 1);
cell_d = inner_d / (dividers_y + 1);

// Main tray body
rounded_box([width, depth, height], r=corner_r, wall=wall);

// Vertical dividers (along Y axis)
if (dividers_x > 0) {
    for (i = [1:dividers_x]) {
        translate([wall + i * cell_w - wall/2, wall, wall])
            cube([wall, inner_d, height - wall]);
    }
}

// Horizontal dividers (along X axis)
if (dividers_y > 0) {
    for (i = [1:dividers_y]) {
        translate([wall, wall + i * cell_d - wall/2, wall])
            cube([inner_w, wall, height - wall]);
    }
}

// Print info
echo(str("Tray size: ", width, "x", depth, "x", height, "mm"));
echo(str("Cells: ", dividers_x + 1, " x ", dividers_y + 1));
echo(str("Cell size: ", cell_w, "x", cell_d, "mm"));
