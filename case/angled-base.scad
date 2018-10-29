include <lib/params.scad>;
use <lib/utils.scad>;

case_length = fan_case + tolerance + base_retainer_thickness;
base_cut_angle = atan((base_height - base_cut_offset) / case_length);
base_length = (cos(base_cut_angle) * case_length) - base_retainer_thickness - tolerance;

module base_profile($fn=20) {
    minkowski() {
        translate([fan_case_radius, fan_case_radius, 0])
            square([fan_case - fan_case_radius * 2, base_length - fan_case_radius * 2]);
        circle(fan_case_radius, $fn);
    }
}

module base_riser() {
    difference() {
        offset(r=tolerance+base_retainer_thickness)
            base_profile();
        offset(r=tolerance)
            base_profile();
    }
}

module base_retainer() {
    difference() {
        offset(r=tolerance+base_retainer_thickness)
            profile();
        offset(r=tolerance)
            profile();
    }
}

difference() {
    union() {
        translate([0, 0, base_cut_offset])
            rotate([base_cut_angle, 0, 0])
                union() {
                    linear_extrude(height=10)
                        base_retainer();
                    difference() {
                        linear_extrude(height=2)
                            offset(r=tolerance+base_retainer_thickness)
                                profile();
                        linear_extrude(height=2)
                            translate([4, 0, 0])
                                square([case_length - 10, case_length]);
                    }
                }

        difference() {
            linear_extrude(height=base_height)
                base_riser();
            translate([0, 0, base_cut_offset])
                rotate([base_cut_angle, 0, 0])
                    linear_extrude(height=base_height)
                    offset(tolerance + base_retainer_thickness)
                        square([fan_case, fan_case + 20]);
        }
    }
    translate([4, case_length - 10, 0])
        cube([case_length - 10, 20, base_height - 4]);
}
