include <params.scad>;
use <lib.scad>;

filter_width = fan_screw_distance - fan_case_screw_radius * 2;
filter_offset = (fan_case - filter_width) / 2;
total_height = front_grill_thickness * 2 + filter_thickness;
grill_width = floor(filter_width / front_grill_fin_spacing) * front_grill_fin_spacing;
grill_offset = filter_width - grill_width;
grill_start = grill_offset - front_grill_fin_thickness / 2;

module square_grill() {
    translate([filter_offset, filter_offset])
    difference() {
        square(filter_width);
        union() {
            for (i = [grill_start:front_grill_fin_spacing:grill_width]) {
                translate([i, 0, 0])
                    square([front_grill_fin_thickness, filter_width]);
            }
        }
    }
}

difference() {
    union() {
        linear_extrude(height=total_height)
            difference() {
                profile();
                square_grill();
            }
        translate([0, 0, total_height])
            linear_extrude(height=grill_screw_inset)
                fan_mount_points(tol(fan_case_screw_radius));
    }
    translate([filter_offset, 0, front_grill_thickness])
        linear_extrude(height=filter_thickness)
            square([filter_width, filter_width + filter_offset + front_grill_fin_thickness / 2]);
    linear_extrude(height=total_height + grill_screw_inset)
        fan_mount_points(grill_screw_size/2);
}
