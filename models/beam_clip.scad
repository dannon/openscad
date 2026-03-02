// Beam clip for holding lightweight string lights
// PRINT: Flat on bed, no supports

/* [Beam Dimensions] */
inner_width = 171;   // gap between sides (beam width)
side_height = 30;    // height of vertical walls
clip_length = 8;     // inward lip at top

/* [Clip Settings] */
depth = 10;          // extrusion depth
wall = 2.5;          // wall thickness

module beam_clip() {
    linear_extrude(depth) {
        // Bottom
        square([inner_width + 2 * wall, wall]);

        // Left side
        translate([0, 0])
            square([wall, wall + side_height + wall]);

        // Right side
        translate([inner_width + wall, 0])
            square([wall, wall + side_height + wall]);

        // Left clip lip
        translate([0, side_height + wall])
            square([clip_length + wall, wall]);

        // Right clip lip
        translate([inner_width + wall - clip_length, side_height + wall])
            square([clip_length + wall, wall]);
    }
}

beam_clip();
