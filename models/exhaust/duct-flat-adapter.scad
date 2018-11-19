include <../lib/params.scad>;
use <../lib/utils.scad>;

duct_mm_diameter = inch_to_mm(adapter_duct_in);
upper_adapter_size = (duct_mm_diameter / sqrt(2)) - adapter_thickness * 2;
$fn=50;

module cone_partial(offset_amount=0) {
    upper = (fan_case + adapter_thickness + tolerance - upper_adapter_size) / 2;
    hull() {
        translate([upper, upper, adapter_height])
            linear_extrude(height=adapter_height)
                offset(r=offset_amount)
                    resize([upper_adapter_size, upper_adapter_size])
                        roundrect([fan_case, fan_case], r=fan_case_radius);
        translate([0, 0, 0])
            linear_extrude(height=10)
                offset(r=offset_amount)
                    roundrect([fan_case, fan_case], r=fan_case_radius);
    }
}

difference() {
    union() {
        linear_extrude(height=flat_adapter_duct_height)
            circle(d=duct_mm_diameter);
        translate([-fan_case/2, -fan_case/2, 0])
            cone_partial();
    }
    linear_extrude(height=flat_adapter_duct_height)
        circle(d=duct_mm_diameter-adapter_thickness*2);
    translate([-fan_case/2, -fan_case/2, 0])
        union() {
            linear_extrude(height=50)
                fan_mount_points(radius=flat_adapter_screw_radius);
            translate([0, 0, 3]) {
                linear_extrude(height=50)
                    fan_mount_points(radius=flat_adapter_screw_head_radius);
            }
        }
}
