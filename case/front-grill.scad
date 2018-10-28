include <params.scad>;
use <lib.scad>;

difference() {
    union() {
        linear_extrude(height=front_grill_thickness)
            difference() {
                profile();
                translate([filter_offset, filter_offset])
                    square_grill(filter_width, filter_width, front_grill_fin_thickness, front_grill_fin_spacing);
            }
        translate([0, 0, front_grill_thickness])
            linear_extrude(height=grill_screw_inset)
                fan_mount_points(tol(fan_case_screw_radius));
    }
    linear_extrude(height=front_grill_thickness + grill_screw_inset)
        fan_mount_points(grill_screw_size/2);
}
