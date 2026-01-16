// Curtain Rod Stand - Flat Bracket Style
// Flat piece against window frame with half-circle cutout for rod
// PRINT: Flat on bed, no supports needed

/* [Rod Dimensions] */
rod_diameter = 30;       // 3cm rod diameter (mm)
rod_clearance = 1;       // Extra space around rod

/* [Stand Dimensions] */
// Bottom of U at 165mm, so stand_height = 165 + rod_radius
stand_height = 165 + (30 + 1)/2;  // ~180.5mm, puts bottom of U at 165mm
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
cup_extension = 10;  // How far cup extends forward from main plane

union() {
    // Main flat vertical piece
    translate([-stand_width/2, 0, 0])
        cube([stand_width, thickness, stand_height - rod_r]);

    // Extended cup area at top
    difference() {
        // Cup block extending forward
        translate([-stand_width/2, 0, stand_height - rod_r - thickness])
            cube([stand_width, thickness + cup_extension, rod_r + thickness]);

        // Semicircle cutout
        translate([0, -1, stand_height])
            rotate([-90, 0, 0])
                cylinder(r=rod_r, h=thickness + cup_extension + 2);
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
