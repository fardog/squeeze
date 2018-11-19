include <lib/params.scad>;
use <lib/utils.scad>;

$fn=50;

circle_offset = power_supply_cable_pass_width - power_supply_cable_pass_height * 2;
total_depth = power_supply_cable_pass_depth + power_supply_cable_pass_overhang_depth;

module profile() {
    hull() {
        circle(d=power_supply_cable_pass_height);
        translate([circle_offset, 0, 0])
            circle(d=power_supply_cable_pass_height);
    }
}


difference() {
    union() {
        linear_extrude(power_supply_cable_pass_overhang_depth)
            offset(power_supply_cable_pass_overhang/2)
                profile();
        translate([0, 0, power_supply_cable_pass_depth])
            linear_extrude(power_supply_cable_pass_depth)
            offset(power_supply_cable_pass_thickness/2)
                    profile();
    }
    linear_extrude(total_depth)
        profile();
}
