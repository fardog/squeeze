include <../lib/params.scad>;
use <../lib/utils.scad>;

screw_case_offset = (fan_case - fan_screw_distance) / 2 * sqrt(2);
triangle_side_length = (screw_case_offset + fan_case_socket_cap_radius + adapter_thickness) * sqrt(2);

duct_mm_diameter = inch_to_mm(adapter_duct_in);
upper_adapter_size = (duct_mm_diameter / sqrt(2)) - adapter_thickness * 2;

$fn=50;

module duct() {
    amt = fan_case / 2;
    translate([amt, amt, 0])
        difference() {
            circle(d=inch_to_mm(adapter_duct_in));
            offset(r=-adapter_thickness)
                circle(d=inch_to_mm(adapter_duct_in));
        }
}

module triangle_inset(side_length=triangle_side_length) {
    hull() {
        difference() {
            polygon(points=[[0, 0], [0, side_length], [side_length,0]]);
            polygon(points=[[0, 0], [0, 10], [10,0]]);
        }
        translate([fan_case_radius, fan_case_radius])
            circle(r=fan_case_radius);
    }
}

module triangle_insets(side_length=triangle_side_length) {
    triangle_inset(side_length);
    translate([fan_case, 0, 0]) rotate([0, 0, 90]) triangle_inset(side_length);
    translate([0, fan_case, 0]) rotate([0, 0, 270]) triangle_inset(side_length);
    translate([fan_case, fan_case, 0]) rotate([0, 0, 180]) triangle_inset(side_length);
}

module cone_partial(offset_amount=0) {
    upper = (fan_case + adapter_thickness - upper_adapter_size) / 2;
    hull() {
        translate([upper, upper, adapter_height])
            linear_extrude(height=adapter_height)
                offset(r=offset_amount)
                    resize([upper_adapter_size, upper_adapter_size])
                        adapter_profile();
        translate([0, 0, -1])
            linear_extrude(height=1)
                offset(r=offset_amount)
                    adapter_profile();
    }
}

module adapter() {
    difference() {
        cone_partial();
        cone_partial(offset_amount=-adapter_thickness);
    }
}

module adapter_cut() {
    cone_partial(offset_amount=-adapter_thickness);
}

module base_adapter() {
    union() {
        difference() {
            adapter_profile();
            offset(r=-adapter_thickness)
                adapter_profile();
        }
    }
}

module adapter_profile() {
    offset(r=adapter_thickness)
        profile();
}

base_offset = filter_thickness + (rear_grill_thickness * 2);

difference() {
    // adapter body
    union() {
        // adapter base, taper, cylinder
        difference() {
            // adapter base, taper
            union() {
                linear_extrude(height=base_offset) {
                    union() {
                        base_adapter();
                    }
                }
                translate([0, 0, base_offset])
                    adapter();

                translate([0, 0, base_offset])
                    linear_extrude(height=adapter_duct_height)
                        duct();
            }
            // adapter cylinder
            translate([fan_case / 2, fan_case / 2, adapter_height])
                linear_extrude(height=adapter_duct_height)
                    circle(d=inch_to_mm(adapter_duct_in)-(adapter_thickness*2));
            // adapter taper cutout
            translate([0, 0, base_offset])
                adapter_cut();
        }
        // adapter taper insets
        intersection() {
            translate([0, 0, base_offset])
                cone_partial();
            translate([0, 0, base_offset])
                linear_extrude(height=adapter_duct_height)
                    triangle_insets();
        }
        // base taper insets
        intersection() {
            linear_extrude(height=adapter_duct_height)
                triangle_insets();
            linear_extrude(height=base_offset) 
                profile();
        }

    }
    // screw cuts
    linear_extrude(height=adapter_duct_height)
        fan_mount_points(grill_screw_size/2);
    // socket cap screw insets
    translate([0, 0, base_offset + 5])
        linear_extrude(height=adapter_duct_height)
            fan_mount_points(fan_case_socket_cap_radius);
}
