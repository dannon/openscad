// Laundry Basket Handle
// Through-hole mount with snap-fit retention
// PRINT: Flat on bed, handle arch facing up. Supports needed for the arch.

/* [Mounting - Measure Your Basket] */
hole_diameter = 12;      // Diameter of holes in basket (mm)
hole_spacing = 130;      // Center-to-center distance between holes (mm)
rim_thickness = 4;       // Thickness of basket rim/wall (mm)

/* [Handle Dimensions] */
grip_height = 35;        // How high the handle rises above the rim
grip_width = 25;         // Width of the grip section
grip_thickness = 12;     // Thickness of grip (front to back)

/* [Pin Settings] */
pin_length = 18;         // Total length of mounting pin
pin_clearance = 0.3;     // Gap for fit (increase if too tight)
barb_height = 2;         // Height of retention barb
barb_angle = 45;         // Angle of barb slope

/* [Print Settings] */
wall = 3;                // Structural wall thickness
$fn = 48;

// Derived dimensions
pin_diameter = hole_diameter - pin_clearance;
base_width = hole_spacing + grip_width;
base_depth = grip_thickness;
base_height = wall;

// Main assembly
union() {
    // Base plate that sits against the basket
    base_plate();

    // Mounting pins with retention barbs
    translate([grip_width/2, base_depth/2, -pin_length + 0.01])
        mounting_pin();
    translate([base_width - grip_width/2, base_depth/2, -pin_length + 0.01])
        mounting_pin();

    // Handle arch
    translate([base_width/2, base_depth/2, base_height])
        handle_arch();
}

module base_plate() {
    // Rounded rectangular base
    hull() {
        for (x = [grip_width/2, base_width - grip_width/2])
            translate([x, base_depth/2, 0])
                cylinder(d=grip_width, h=base_height);
    }
}

module mounting_pin() {
    // Main pin shaft
    cylinder(d=pin_diameter, h=pin_length);

    // Retention barb ring at the bottom
    translate([0, 0, 0])
        barb_ring();

    // Chamfer at tip for easy insertion
    translate([0, 0, 0])
        cylinder(d1=pin_diameter - 2, d2=pin_diameter, h=2);
}

module barb_ring() {
    // Angled barb that snaps past the hole
    barb_diameter = pin_diameter + barb_height * 2;

    translate([0, 0, rim_thickness + 1]) {
        // Sloped entry side
        cylinder(d1=pin_diameter, d2=barb_diameter, h=barb_height);
        // Flat retention side
        translate([0, 0, barb_height])
            cylinder(d1=barb_diameter, d2=pin_diameter, h=barb_height/2);
    }
}

module handle_arch() {
    // Ergonomic arch handle
    arch_length = hole_spacing - grip_width;

    // Create arch profile and sweep it
    rotate([90, 0, 0])
    linear_extrude(height=grip_thickness, center=true)
        handle_profile(arch_length, grip_height, grip_width);
}

module handle_profile(length, height, width) {
    // 2D profile of the handle arch
    r = width / 2;

    hull() {
        // Left mounting point
        translate([-length/2, 0])
            circle(d=width);
        // Right mounting point
        translate([length/2, 0])
            circle(d=width);
        // Top of arch
        translate([0, height - r])
            circle(d=width);
    }
}

// Print info
echo(str("Handle spans: ", base_width, "mm"));
echo(str("Pin diameter: ", pin_diameter, "mm (for ", hole_diameter, "mm holes)"));
echo(str("Grip height above rim: ", grip_height, "mm"));
echo(str("Recommend printing with supports for the arch"));
