/* [Tray Dimensions] */
tray_width = 45;
tray_length = 180;
tray_height = 20;

/* [Trough] */
trough_width = 40;
trough_depth = 15;

/* [Print Settings] */
wall = 2.5;
corner_radius = 3;
$fn = 48;

// PRINT: Flat on bed, no supports

module rounded_rect(w, l, h, r) {
    hull() {
        for (x = [r, w - r])
            for (y = [r, l - r])
                translate([x, y, 0])
                    cylinder(r = r, h = h);
    }
}

difference() {
    // Outer shell
    rounded_rect(tray_width, tray_length, tray_height, corner_radius);

    // Inner trough - centered in width, inset from ends
    trough_x = (tray_width - trough_width) / 2;
    trough_y = wall;
    translate([trough_x, trough_y, tray_height - trough_depth])
        rounded_rect(trough_width, tray_length - wall * 2, trough_depth + 1, corner_radius - 1);
}
