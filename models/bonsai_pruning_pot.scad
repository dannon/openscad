// Open-Air Pruning Bonsai Pot
// Rectangular training pot with air-pruning cones on all four walls and a
// slide-out drip tray built into the base.
//
// PRINT (pot):  upright on its base, NO supports. The ceiling over the tray
//               channel is a single ~77mm bridge -- 100% fan, slow bridge speed.
// PRINT (tray): flat on its floor, no supports.
// Print the two parts in separate jobs; side by side they overrun the A1 Mini bed.

use <../lib/rounded_box.scad>

/* [Part] */
part = "both";     // [pot, tray, both]
pull_out = 45;     // Preview only: how far the tray is pulled out in "both"

/* [Pot Size] */
pot_w = 150;       // Outer width (X) -- the tray pulls out of this face
pot_d = 110;       // Outer depth (Y)
soil_h = 65;       // Soil depth above the floor

/* [Drip Tray] */
tray_w = 76;       // Tray outer width -- this is the ceiling bridge span, keep <= 85
tray_len = 100;    // Tray outer length (Y)
tray_h = 14;       // Tray outer height
tray_wall = 1.8;
tray_floor = 1.6;
tray_clear = 0.5;  // Per-side sliding clearance
sag_gap = 1.2;     // Headroom under the pot floor to swallow bridge sag
plate_t = 3;       // Drawer face thickness
plate_over = 7;    // How far the drawer face laps onto the pot
tab_size = 7;      // Pull tab projection (also its height)
tab_w = 46;        // Pull tab width

/* [Air Pruning Cones] */
cone_base_r = 4.5; // Cone footprint on the wall
cone_out = 6;      // Cone projection from the wall
cone_tip_r = 1.4;
cone_hole_r = 1.9; // Air hole bored through the cone tip
cone_pitch_h = 12;
cone_pitch_v = 11;
cone_margin = 11;  // Keep cones this far off the corners

/* [Drainage] */
drain_r = 2.5;
drain_pitch = 11;
floor_slope = 4;   // Floor rise at the side walls -- runoff drains to the tray strip
wire_r = 2.2;      // Tie-down wire holes at the soil corners

/* [Print Settings] */
wall = 2.4;
floor_t = 2.6;
base_t = 2.0;      // Plate the tray slides on
chan_wall = 3;     // Walls of the tray channel
corner_r = 4;
rim_w = 3.5;       // Rim flare width
rim_h = 4;         // Rim flare height (45 deg, self supporting)
$fn = 32;

// ---- derived ----
cav_h   = tray_h + tray_clear + sag_gap;   // drawer cavity height
chan_w  = tray_w + 2 * tray_clear;         // drawer channel inner width
z_floor = base_t + cav_h;                  // underside of the pot floor
z_soil  = z_floor + floor_t;               // floor top, at the low (centre) point
total_h = z_soil + soil_h;
in_w    = pot_w - 2 * wall;
in_d    = pot_d - 2 * wall;
in_r    = max(0.6, corner_r - wall);
z_cone0 = z_soil + 7;
z_cone1 = total_h - rim_h - cone_out - 3;
void_x  = chan_w / 2 + chan_wall;
void_w  = (pot_w / 2 - wall) - void_x;

// Rounded slab centred on the origin in XY
module plate(w, d, h, r) {
    translate([-w/2, -d/2, 0])
        rounded_cube([w, d, h], r = min(r, min(w, d) / 2 - 0.01));
}

// ---------------------------------------------------------------- pot

module pot() {
    difference() {
        union() {
            difference() {
                union() {
                    plate(pot_w, pot_d, total_h, corner_r);
                    rim_flare();
                    cone_field_all(true);
                }
                soil_cavity();
                tray_channel();
                under_voids();
            }
            floor_ramps();
        }
        cone_field_all(false);
        drain_holes();
        wire_holes();
    }
}

// Cut above the floor; runs past the top so it opens the rim too
module soil_cavity() {
    translate([0, 0, z_soil])
        plate(in_w, in_d, soil_h + rim_h + 10, in_r);
}

// Flared lip -- stiffens the perforated walls and gives somewhere to grip
module rim_flare() {
    hull() {
        translate([0, 0, total_h - rim_h]) plate(pot_w, pot_d, 0.02, corner_r);
        translate([0, 0, total_h - 0.02])
            plate(pot_w + 2*rim_w, pot_d + 2*rim_w, 0.02, corner_r + rim_w);
    }
}

// Drawer bay, open through the front face, closed at the back
module tray_channel() {
    translate([-chan_w/2, -pot_d/2 - 1, base_t])
        cube([chan_w, pot_d - wall + 1, cav_h]);
}

// Open-bottomed pockets either side of the drawer -- saves filament and makes feet
module under_voids() {
    for (s = [-1, 1])
        translate([s > 0 ? void_x : -void_x - void_w, -(pot_d/2 - wall), -1])
            rounded_cube([void_w, pot_d - 2*wall, z_floor + 1], r = 3);
}

// Shallow ramps either side so runoff ends up over the tray, not the pockets
module floor_ramps() {
    for (s = [-1, 1])
        translate([0, in_d/2, z_soil])
            rotate([90, 0, 0])
                linear_extrude(height = in_d)
                    polygon([[s * chan_w/2, 0],
                             [s * in_w/2, 0],
                             [s * in_w/2, floor_slope]]);
}

// Drainage only over the drawer strip, so every drop lands in the tray
module drain_holes() {
    hx     = chan_w/2 - drain_r - 2;
    hy_lo  = -pot_d/2 + tray_wall + drain_r + 3;
    hy_hi  = -pot_d/2 + tray_len - tray_wall - drain_r - 3;
    nx     = floor(2 * hx / drain_pitch) + 1;
    ny     = floor((hy_hi - hy_lo) / drain_pitch) + 1;
    y0     = hy_lo + (hy_hi - hy_lo - (ny - 1) * drain_pitch) / 2;

    for (j = [0 : ny - 1]) {
        n = (j % 2 == 0) ? nx : nx - 1;
        if (n >= 1)
            for (i = [0 : n - 1])
                translate([-(n - 1) * drain_pitch/2 + i * drain_pitch,
                           y0 + j * drain_pitch,
                           z_floor - 1])
                    cylinder(h = floor_t + 2, r = drain_r);
    }
}

// Tie-down wire holes, over the open pockets so the twist tucks up out of the way
module wire_holes() {
    for (sx = [-1, 1], sy = [-1, 1])
        translate([sx * (in_w/2 - 9), sy * (in_d/2 - 9), z_floor - 1])
            cylinder(h = floor_t + floor_slope + 3, r = wire_r);
}

// ---- cones: local frame has the wall face on x=0, outward normal +X ----

module cone_bump() {
    hull() {
        translate([-1.2, 0, 0]) rotate([0, 90, 0])
            cylinder(h = 1.4, r = cone_base_r, $fn = 20);
        translate([cone_out, 0, cone_out]) sphere(r = cone_tip_r, $fn = 14);
    }
}

module cone_hole() {
    rotate([0, 45, 0]) translate([0, 0, -7])
        cylinder(h = 22, r = cone_hole_r, $fn = 16);
}

module cone_field(len, solid) {
    nrows = floor((z_cone1 - z_cone0) / cone_pitch_v) + 1;
    ncols = floor((len - 2 * cone_margin) / cone_pitch_h) + 1;

    if (nrows >= 1 && ncols >= 1)
        for (r = [0 : nrows - 1]) {
            n = (r % 2 == 0) ? ncols : ncols - 1;
            if (n >= 1)
                for (c = [0 : n - 1])
                    translate([0,
                               -(n - 1) * cone_pitch_h/2 + c * cone_pitch_h,
                               z_cone0 + r * cone_pitch_v])
                        if (solid) cone_bump(); else cone_hole();
        }
}

module cone_field_all(solid) {
    translate([ pot_w/2, 0, 0])                  cone_field(pot_d, solid);
    translate([-pot_w/2, 0, 0]) rotate([0,0,180]) cone_field(pot_d, solid);
    translate([0,  pot_d/2, 0]) rotate([0,0,90])  cone_field(pot_w, solid);
    translate([0, -pot_d/2, 0]) rotate([0,0,-90]) cone_field(pot_w, solid);
}

// ---------------------------------------------------------------- tray

module tray() {
    plate_w = chan_w + 2 * plate_over;
    difference() {
        union() {
            translate([-tray_w/2, -tray_len/2, 0])
                rounded_cube([tray_w, tray_len, tray_h], r = 2.5);
            translate([-plate_w/2, -tray_len/2 - plate_t, 0])
                rounded_cube([plate_w, plate_t, cav_h], r = 1.4);
            pull_tab();
        }
        translate([-tray_w/2 + tray_wall, -tray_len/2 + tray_wall, tray_floor])
            rounded_cube([tray_w - 2*tray_wall, tray_len - 2*tray_wall, tray_h], r = 1.5);
    }
}

// Wedge pull -- flat on top, 45 deg underneath so it prints off the face
module pull_tab() {
    translate([-tab_w/2, -tray_len/2 - plate_t, cav_h])
        rotate([0, 90, 0])
            linear_extrude(height = tab_w)
                polygon([[0, 0], [0, -tab_size], [tab_size, 0]]);
}

// ---------------------------------------------------------------- output

if (part == "pot")       pot();
else if (part == "tray") tray();
else {
    pot();
    translate([0, -pot_d/2 + tray_len/2 - pull_out, base_t]) tray();
}

echo(str("Pot footprint incl. cones: ", pot_w + 2*cone_out, " x ", pot_d + 2*cone_out, " mm"));
echo(str("Overall height: ", total_h, " mm"));
echo(str("Soil volume (approx): ", in_w * in_d * soil_h / 1000, " ml"));
echo(str("Tray capacity to 10mm: ", (tray_w - 2*tray_wall) * (tray_len - 2*tray_wall) * 10 / 1000, " ml"));
echo(str("Ceiling bridge span: ", chan_w, " mm"));
