// Piggy Bank Twist-Lock Plug
// All measurements in mm

// Main dimensions (from measurements)
primary_cylinder_dia = 33.6;
lip_dia = 39.0;
tab_span = 38.1;  // total diameter across tabs
total_height = 7.9;

// Measured dimensions
lip_height = 1.0;           // height of the lip (at top/open end)
wall_thickness = 2.0;       // wall thickness
floor_thickness = 1.5;      // bottom floor thickness (at closed end with tabs)

// Tab dimensions
tab_width = 5.2;            // width of each tab
tab_height = 2.0;           // height/thickness of tabs (adjust as needed)
tab_extension = (tab_span - primary_cylinder_dia) / 2;  // how far tabs extend beyond cylinder

// Yin-yang divider
divider_thickness = 2.5;
divider_height = total_height - floor_thickness;  // fills interior from floor to top

$fn = 100;  // smoothness

module main_body() {
    // Main cylinder (full height)
    cylinder(h = total_height, d = primary_cylinder_dia);
    
    // Lip/flange at the TOP (open end)
    translate([0, 0, total_height - lip_height])
        cylinder(h = lip_height, d = lip_dia);
}

module tabs() {
    // Two tabs on opposite sides at the BOTTOM (closed end, insertion end)
    for (angle = [0, 180]) {
        rotate([0, 0, angle])
            translate([primary_cylinder_dia/2, 0, 0])
                // Tab shape - rounded rectangle extending outward
                hull() {
                    cylinder(h = tab_height, d = tab_width);
                    translate([(tab_span - primary_cylinder_dia)/2 - tab_width/2, 0, 0])
                        cylinder(h = tab_height, d = tab_width);
                }
    }
}

module hollow_interior() {
    // Hollow out from the top, leaving floor at bottom
    translate([0, 0, floor_thickness])
        cylinder(h = total_height, d = primary_cylinder_dia - wall_thickness * 2);
}

module yinyang_divider() {
    // Creates the S-curve divider inside
    // The divider follows a sine-wave-like path across the diameter
    
    inner_dia = primary_cylinder_dia - wall_thickness * 2;
    curve_radius = inner_dia / 4;
    
    translate([0, 0, floor_thickness]) {
        // S-curve made from two arcs
        linear_extrude(height = divider_height) {
            // Central straight connector
            translate([0, 0, 0])
                square([divider_thickness, inner_dia/2], center = true);
            
            // Top arc (curves right)
            translate([0, inner_dia/4, 0])
                difference() {
                    circle(r = curve_radius + divider_thickness/2);
                    circle(r = curve_radius - divider_thickness/2);
                    translate([-curve_radius - divider_thickness, 0, 0])
                        square([curve_radius * 2 + divider_thickness * 2, curve_radius * 2 + divider_thickness * 2]);
                }
            
            // Bottom arc (curves left)
            translate([0, -inner_dia/4, 0])
                difference() {
                    circle(r = curve_radius + divider_thickness/2);
                    circle(r = curve_radius - divider_thickness/2);
                    translate([-curve_radius - divider_thickness, -curve_radius * 2 - divider_thickness * 2, 0])
                        square([curve_radius * 2 + divider_thickness * 2, curve_radius * 2 + divider_thickness * 2]);
                }
        }
    }
}

module yinyang_divider_v2() {
    // Alternative cleaner S-curve implementation
    inner_dia = primary_cylinder_dia - wall_thickness * 2;
    curve_radius = inner_dia / 4;
    
    translate([0, 0, floor_thickness]) {
        linear_extrude(height = divider_height) {
            // Use offset to create thickness around a path
            offset(r = divider_thickness/2) {
                offset(r = -divider_thickness/2) {
                    union() {
                        // Top semicircle (right side)
                        translate([0, curve_radius, 0])
                            difference() {
                                circle(r = curve_radius);
                                translate([-curve_radius*2, -curve_radius, 0])
                                    square([curve_radius*2, curve_radius*2]);
                                circle(r = curve_radius - divider_thickness);
                            }
                        
                        // Bottom semicircle (left side)  
                        translate([0, -curve_radius, 0])
                            difference() {
                                circle(r = curve_radius);
                                translate([0, -curve_radius, 0])
                                    square([curve_radius*2, curve_radius*2]);
                                circle(r = curve_radius - divider_thickness);
                            }
                        
                        // Connecting line segments
                        translate([-divider_thickness/2, -curve_radius*2])
                            square([divider_thickness, curve_radius]);
                        translate([-divider_thickness/2, curve_radius])
                            square([divider_thickness, curve_radius]);
                    }
                }
            }
        }
    }
}

module simple_s_divider() {
    // Simplified S-curve using hull operations
    inner_dia = primary_cylinder_dia - wall_thickness * 2;
    inner_radius = inner_dia / 2;
    segment_radius = inner_radius / 2;
    
    translate([0, 0, floor_thickness]) {
        linear_extrude(height = divider_height) {
            // Create S-shape with three hull segments
            
            // Top segment: from top-center curving to right-middle
            hull() {
                translate([0, inner_radius - 1, 0])
                    circle(d = divider_thickness);
                translate([segment_radius, segment_radius/2, 0])
                    circle(d = divider_thickness);
            }
            
            // Middle segment: S-curve through center
            hull() {
                translate([segment_radius, segment_radius/2, 0])
                    circle(d = divider_thickness);
                translate([-segment_radius, -segment_radius/2, 0])
                    circle(d = divider_thickness);
            }
            
            // Bottom segment: from left-middle to bottom-center
            hull() {
                translate([-segment_radius, -segment_radius/2, 0])
                    circle(d = divider_thickness);
                translate([0, -inner_radius + 1, 0])
                    circle(d = divider_thickness);
            }
        }
    }
}

// Notch in the lip (visible in images - seems to be a registration/alignment feature)
module lip_notch() {
    notch_width = 4;
    notch_depth = 3;
    
    translate([lip_dia/2 - notch_depth, -notch_width/2, 0])
        cube([notch_depth + 1, notch_width, lip_height]);
}

// Final assembly
module piggybank_plug() {
    difference() {
        union() {
            main_body();
            tabs();
        }
        hollow_interior();
        // Optional: add notch for alignment
        // rotate([0, 0, 90]) lip_notch();
    }
    
    // Add the S-curve divider
    simple_s_divider();
}

// Render the plug
piggybank_plug();

// Optional: Preview cross-section (uncomment to see internal structure)
// difference() {
//     piggybank_plug();
//     translate([0, -50, -1])
//         cube([100, 100, 20]);
// }
