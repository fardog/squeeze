include <lib/params.scad>;
use <lib/utils.scad>;

total_height = front_grill_thickness + filter_thickness;

difference() {
    union() {
        linear_extrude(height=total_height)
            difference() {
                profile();
                translate([filter_offset, filter_offset])
                    square_grill(filter_width, filter_width, front_grill_fin_thickness, front_grill_fin_count);
            }
    }
    // filter insert
    translate([filter_offset, 0, front_grill_thickness])
        linear_extrude(height=filter_thickness)
            square([filter_width, filter_width + filter_offset + front_grill_fin_thickness / 2]);
    // screw holes
    linear_extrude(height=total_height)
        fan_mount_points(grill_screw_size/2);
    // inset screw points, bottom
    linear_extrude(height=grill_screw_inset)
        fan_mount_points(fan_case_screw_radius);
}
