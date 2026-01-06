// Yeti Kids 12oz Bottle Sleeve
// Drop-in sleeve with flared lip and 3 hooks to grip elastic loop
// PRINT: Upright. Hooks need supports.

/* [Bottle Dimensions] */
bottle_diameter = 76;    // Yeti kids bottle diameter (mm)
sleeve_height = 115;     // Height of main sleeve body (~4.5")

/* [Fit Adjustments] */
clearance = 1.5;         // Gap between bottle and sleeve (easy drop-in)
wall = 2.5;              // Wall thickness

/* [Lip Settings] */
lip_width = 10;          // How far lip extends outward

/* [Hook Settings] */
hook_count = 3;          // Number of hooks
hook_width = 12;         // Width of each hook (circumferential)
hook_drop = 12;          // How far hooks extend down
hook_thickness = 4;      // Thickness of hook material
elastic_gap = 8;         // Gap for elastic (thickness of elastic)

/* [Print Settings] */
$fn = 64;

// Derived dimensions
inner_d = bottle_diameter + clearance * 2;
outer_d = inner_d + wall * 2;
inner_r = inner_d / 2;
outer_r = outer_d / 2;
lip_outer_r = outer_r + lip_width;

// Main assembly
union() {
    // Main sleeve body
    sleeve_body();

    // Flat flared lip at top
    translate([0, 0, sleeve_height])
        lip_ring();

    // 3 hooks hanging from lip
    for (i = [0:hook_count-1]) {
        rotate([0, 0, i * 360/hook_count])
            translate([0, 0, sleeve_height])
                hanging_hook();
    }
}

module sleeve_body() {
    difference() {
        cylinder(d=outer_d, h=sleeve_height);
        translate([0, 0, -1])
            cylinder(d=inner_d, h=sleeve_height + 2);
    }
}

module lip_ring() {
    // Simple flat flared lip
    difference() {
        cylinder(r1=outer_r, r2=lip_outer_r, h=wall*2);
        translate([0, 0, -1])
            cylinder(d=inner_d, h=wall*2 + 2);
    }
}

module hanging_hook() {
    // Individual rounded hook that hangs down to grip elastic
    // Position at outer edge of lip, flush with top surface

    hook_angle = (hook_width / lip_outer_r) * (180/PI);  // Arc in degrees

    // Position so top of hook is flush with top of lip
    translate([0, 0, wall*2 - hook_thickness/2])
    rotate([0, 0, -hook_angle/2])
    rotate_extrude(angle=hook_angle)
    translate([lip_outer_r - hook_thickness/2, 0])
        hook_profile_2d();
}

module hook_profile_2d() {
    // 2D profile of hook - extends OUT then curves DOWN
    // Like a little awning/overhang
    t = hook_thickness;

    hook_out = 5;    // How far hook extends outward
    hook_down = 5;   // How far hook drops
    hook_in = 2;     // How far hook curls back inward

    // Horizontal extension outward from lip
    hull() {
        circle(d=t);
        translate([hook_out, 0])
            circle(d=t);
    }

    // Vertical drop
    hull() {
        translate([hook_out, 0])
            circle(d=t);
        translate([hook_out, -hook_down])
            circle(d=t);
    }

    // Inward curl at bottom (grips under elastic)
    hull() {
        translate([hook_out, -hook_down])
            circle(d=t);
        translate([hook_out - hook_in, -hook_down])
            circle(d=t);
    }
}

// Info
echo(str("Inner diameter: ", inner_d, "mm (bottle: ", bottle_diameter, "mm)"));
echo(str("Outer diameter: ", outer_d, "mm"));
echo(str("Lip diameter: ", lip_outer_r * 2, "mm"));
echo(str("Sleeve height: ", sleeve_height, "mm"));
echo(str("Hook drop: ", hook_drop, "mm"));
echo(str("Elastic gap: ", elastic_gap, "mm"));
