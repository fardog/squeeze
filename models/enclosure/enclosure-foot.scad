include <../lib/params.scad>;
use <../lib/utils.scad>;

$fn=50;

difference() {
    cylinder(r1=foot_lower_radius, r2=foot_upper_radius, h=foot_height);
    cylinder(r=foot_lower_radius-foot_inset_radius, h=foot_inset_depth);
    union() {
        translate([0, 0, foot_inset_depth])
            cylinder(r=foot_screw_head_radius+tolerance, h=foot_screw_inset);
        cylinder(r=foot_screw_radius+tolerance, h=foot_height);
    }
}
