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
hook_thickness = 5;      // Thickness of hook material (matches lip height)
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
    rib_count = 12;          // Number of vertical ribs (every 30°)
    rib_angle = 15;          // Angular width of each rib (degrees)
    bottom_ring = 10;        // Solid ring at bottom
    top_ring = 10;           // Solid ring at top (below lip)

    // Bottom solid ring
    difference() {
        cylinder(d=outer_d, h=bottom_ring);
        translate([0, 0, -1])
            cylinder(d=inner_d, h=bottom_ring + 2);
    }

    // Bottom floor with straight spoke ribs
    spoke_width = 5;
    spoke_height = 5;
    for (i = [0:5]) {  // 6 ribs = 12 spokes (each crosses full diameter)
        rotate([0, 0, i * 30])
            translate([-inner_r, -spoke_width/2, 0])
                cube([inner_d, spoke_width, spoke_height]);
    }

    // Top solid ring
    translate([0, 0, sleeve_height - top_ring])
    difference() {
        cylinder(d=outer_d, h=top_ring);
        translate([0, 0, -1])
            cylinder(d=inner_d, h=top_ring + 2);
    }

    // Double helix spiral bands (replaces vertical ribs)
    helix_height = sleeve_height - top_ring - bottom_ring;
    helix_turns = 1.5;        // Number of full rotations
    helix_width = 5;          // Width of spiral band
    helix_segments = 60;      // Smoothness

    // First double helix (clockwise)
    for (offset = [0, 180]) {
        rotate([0, 0, offset])
            translate([0, 0, bottom_ring])
                helix_band(helix_height, helix_turns, helix_width, helix_segments);
    }

    // Second double helix (counter-clockwise) - criss-cross pattern
    for (offset = [90, 270]) {
        rotate([0, 0, offset])
            translate([0, 0, bottom_ring])
                helix_band(helix_height, -helix_turns, helix_width, helix_segments);
    }

    // 8 vertical ribs every 45°
    rib_width = 5;
    for (angle = [0, 45, 90, 135, 180, 225, 270, 315]) {
        rotate([0, 0, angle])
            translate([inner_r, -rib_width/2, bottom_ring])
                cube([wall, rib_width, helix_height]);
    }
}

module helix_band(height, turns, band_width, segments) {
    // Create a helix by hulling successive segments
    seg_height = height / segments;
    seg_angle = (turns * 360) / segments;

    for (i = [0:segments-1]) {
        hull() {
            // Current segment - flush with wall surface
            rotate([0, 0, i * seg_angle])
                translate([inner_r, 0, i * seg_height])
                    rotate([0, 90, 0])
                        cylinder(d=band_width, h=wall, $fn=16);

            // Next segment
            rotate([0, 0, (i+1) * seg_angle])
                translate([inner_r, 0, (i+1) * seg_height])
                    rotate([0, 90, 0])
                        cylinder(d=band_width, h=wall, $fn=16);
        }
    }
}

module lip_ring() {
    // Flared lip with consistent thickness
    difference() {
        union() {
            // Main flange - less taper, stays thick at edge
            cylinder(r1=outer_r, r2=lip_outer_r, h=wall*2);

            // Thicken the outer edge
            translate([0, 0, 0])
                difference() {
                    cylinder(r=lip_outer_r, h=wall*2);
                    translate([0, 0, -1])
                        cylinder(r=lip_outer_r - wall*2, h=wall*2 + 2);
                }
        }
        // Hollow for bottle
        translate([0, 0, -1])
            cylinder(d=inner_d, h=wall*2 + 2);
    }

    // Reinforcement ribs from hooks to sleeve body
    for (i = [0:hook_count-1]) {
        rotate([0, 0, i * 360/hook_count])
            hook_rib();
    }
}

module hook_rib() {
    // Radial rib connecting hook area to main body
    rib_width = hook_width;

    translate([0, -rib_width/2, 0])
        linear_extrude(height=wall*2)
            polygon([
                [outer_r - wall, 0],
                [outer_r - wall, rib_width],
                [lip_outer_r, rib_width/2 + hook_width/2],
                [lip_outer_r, rib_width/2 - hook_width/2]
            ]);
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
