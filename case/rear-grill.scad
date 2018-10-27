include <params.scad>;
use <lib.scad>;

module profile($fn=20) {
    minkowski() {
        translate([fan_case_radius, fan_case_radius, 0])
            square(fan_case - fan_case_radius * 2);
        circle(fan_case_radius, $fn);
    }
}

module screws(radius, $fn=20) {
    offset = (fan_case - fan_screw_distance) / 2;
    translate([offset, offset, 0]) {
        circle(radius, $fn);
        translate([fan_screw_distance, 0, 0])
            circle(radius, $fn);
        translate([fan_screw_distance, fan_screw_distance, 0])
            circle(radius, $fn);
        translate([0, fan_screw_distance, 0])
            circle(radius, $fn);
    }
}

module insets(r, angle, invert=true) {
    offset = (fan_case - fan_screw_distance) / 2;
    translate([offset, offset, 0]) {
        cone(r, angle, invert);
        translate([fan_screw_distance, 0, 0])
            cone(r, angle, invert);
        translate([fan_screw_distance, fan_screw_distance, 0])
            cone(r, angle, invert);
        translate([0, fan_screw_distance, 0])
            cone(r, angle, invert);
    }
}

module grill($fn=50) {
    difference() {
        difference() {
            circle(grill_radius);
            for(i = [grill_radius:-grill_fin_offset:grill_fin_offset + 1]) {
                difference() {
                    circle(i + grill_fin_thickness, $fn);
                    circle(i, $fn);
                }
            }
        }
        circle(grill_fin_offset - grill_fin_thickness, $fn);

        for(i = [0:grill_fin_degrees:360]) {
            rotate(i)
                translate([-grill_fin_thickness / 2, 0, 0])
                    square([grill_fin_thickness, grill_radius]);
        }
    }
}

difference() {
    union() {
        linear_extrude(height=rear_grill_thickness) {
            difference() {
                profile();
                translate([fan_case / 2, fan_case / 2, 0])
                    grill();
            }
        }
        translate([0, 0, rear_grill_thickness])
            linear_extrude(height=grill_screw_inset)
                screws(tol(fan_case_screw_radius));
    }
    linear_extrude(height=rear_grill_thickness + grill_screw_inset)
        screws(grill_screw_radius);
    insets(fan_case_screw_head_radius, fan_case_screw_head_angle);
}


