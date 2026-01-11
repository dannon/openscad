// Curtain Rod Stand - Flat Bracket Style
// Flat piece against window frame with half-circle cutout for rod
// PRINT: Flat on bed, no supports needed

/* [Rod Dimensions] */
rod_diameter = 30;       // 3cm rod diameter (mm)
rod_clearance = 1;       // Extra space around rod

/* [Stand Dimensions] */
// Bottom of U at 70mm, so stand_height = 70 + rod_radius
stand_height = 70 + (30 + 1)/2;  // ~85.5mm, puts bottom of U at 70mm
stand_width = 40;        // Width of the flat piece
thickness = 8;          // 8mm thick

/* [Foot Dimensions] */
foot_depth = 10;         // How far foot extends forward
foot_height = 8;         // Same as thickness

/* [Print Settings] */
$fn = 64;

// Derived
rod_r = (rod_diameter + rod_clearance) / 2;

// Main assembly
union() {
    // Main flat vertical piece with semicircle cutout
    difference() {
        // Flat rectangle
        translate([-stand_width/2, 0, 0])
            cube([stand_width, thickness, stand_height]);

        // Semicircle cutout at top
        translate([0, -1, stand_height])
            rotate([-90, 0, 0])
                cylinder(r=rod_r, h=thickness + 2);
    }

    // Foot extending forward (same direction as rod), full width
    translate([-stand_width/2, thickness, 0])
        cube([stand_width, foot_depth, foot_height]);
}

// Info
echo(str("Stand height: ", stand_height, "mm (", stand_height/25.4, "\")"));
echo(str("Rod cutout diameter: ", rod_r*2, "mm"));
echo(str("Thickness: ", thickness, "mm"));
echo(str("Foot depth: ", foot_depth, "mm"));
