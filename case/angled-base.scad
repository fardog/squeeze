include <lib/params.scad>;
use <lib/utils.scad>;

case_length = fan_case + tolerance + base_retainer_thickness;
base_cut_angle = atan((base_height - base_cut_offset) / case_length);
base_length = (cos(base_cut_angle) * case_length) - base_retainer_thickness - tolerance;

vent_cutout = base_height / 2;
base_retainer_offset = base_retainer_inset * 2 + (tolerance + base_retainer_thickness);

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
        // retainer
        translate([0, 0, base_cut_offset])
            rotate([base_cut_angle, 0, 0])
                union() {
                    // retainer wall
                    linear_extrude(height=10)
                        base_retainer();
                    // retainer floor
                    difference() {
                        // profile
                        linear_extrude(height=base_retainer_thickness)
                            offset(r=tolerance+base_retainer_thickness)
                                profile();
                        // center cut
                        linear_extrude(height=base_retainer_thickness)
                            translate([base_retainer_inset, 0, 0])
                                offset(r=tolerance)
                                    square([case_length - base_retainer_offset, case_length]);
                    }
                }
        // reiser
        difference() {
            // reiser wall
            linear_extrude(height=base_height)
                base_riser();
            // reiser angle cut
            translate([0, 0, base_cut_offset])
                rotate([base_cut_angle, 0, 0])
                    linear_extrude(height=base_height)
                        offset(tolerance + base_retainer_thickness)
                            square([fan_case, fan_case + vent_cutout]);
        }
    }
    // front vent cutout
    translate([base_retainer_inset, case_length - base_retainer_offset, 0])
        cube([case_length - base_retainer_offset, vent_cutout, base_height - base_retainer_inset]);
}
