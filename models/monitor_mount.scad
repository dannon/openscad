/* Monitor Top Mount - Ring Light & Webcam Stand
 * Simple upside-down J clip that hooks over monitor top
 */

/* [Monitor Dimensions] */
// Thickness at top of monitor
monitor_thickness = 26;
// Thickness at bottom of back (where curve ends)
monitor_thickness_bottom = 34;

/* [Mount Dimensions] */
// Width of the mount (along monitor edge)
width = 60;
// How far down the front lip extends
front_lip = 4;
// How far down the back extends
back_depth = 35;
// Wall thickness
wall = 2.5;
// Top bar thickness (extra beef)
top_thickness = 5;

/* [Ring Light Peg] */
// Peg diameter
peg_diameter = 5.25;
// Peg height
peg_height = 10;

/* [Print Settings] */
// Clearance for fit
clearance = 0.3;
$fn = 64;

// Calculated
inner = monitor_thickness + clearance;
total_depth = wall + inner + wall;  // front wall + gap + back wall
back_slope = monitor_thickness_bottom - monitor_thickness;  // 8mm outward

module monitor_mount() {
    // Simple upside-down J profile, extruded for width

    // Top bar (thicker)
    cube([total_depth, top_thickness, width]);

    // Front lip
    cube([wall, top_thickness + front_lip, width]);

    // Back drop with slope
    translate([total_depth - wall, 0, 0])
        sloped_back();

    // Ring light peg on top, towards back for balance
    // Extends through full top thickness + 0.2mm
    translate([total_depth - wall/2, top_thickness + 0.2, width/2])
        rotate([90, 0, 0])
            cylinder(d=peg_diameter, h=peg_height + top_thickness + 0.2);
}

module sloped_back() {
    // Back wall that slopes outward as it goes down
    hull() {
        // Top of back (aligned with top bar)
        cube([wall, top_thickness + 0.01, width]);

        // Bottom of back (sloped outward)
        translate([back_slope, top_thickness + back_depth - wall, 0])
            cube([wall, wall, width]);
    }
}

// Render in print orientation (top facing up)
rotate([-90, 0, 0])
    monitor_mount();

// PRINT: Flat on bed, no supports needed
