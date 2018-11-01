include <lib/params.scad>;
use <lib/utils.scad>;

module duct($fn=50) {
    translate([60, 60, 0])
        difference() {
            circle(d=inch_to_mm(4), $fn=$fn);
            offset(r=-adapter_thickness)
                circle(d=inch_to_mm(4), $fn=$fn);
        }
}

module triangle_inset(side_length=30) {
    hull() {
        difference() {
            polygon(points=[[0, 0], [0, side_length], [side_length,0]]);
            polygon(points=[[0, 0], [0, 10], [10,0]]);
        }
        translate([5, 5])
            circle(r=5);
    }
}

module triangle_insets(side_length=30) {
    triangle_inset(side_length);
    translate([120, 0, 0]) rotate([0, 0, 90]) triangle_inset(side_length);
    translate([0, 120, 0]) rotate([0, 0, 270]) triangle_inset(side_length);
    translate([120, 120, 0]) rotate([0, 0, 180]) triangle_inset(side_length);
}

module cone_partial(offset_amount=0) {
    hull() {
        translate([30, 30, 30])
            scale([0.5, 0.5, 1])
                linear_extrude(height=30)
                    offset(r=offset_amount)
                        profile();
        translate([0, 0, -1])
            linear_extrude(height=1)
                offset(r=offset_amount)
                    profile();
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
            profile();
            offset(r=-adapter_thickness)
                profile();
        }
    }
}

base_offset = filter_thickness + (rear_grill_thickness * 2) + tolerance;

difference() {
    union() {
        difference() {
            union() {
                linear_extrude(height=base_offset) {
                    union() {
                        base_adapter();
                    }
                }
                translate([0, 0, base_offset])
                    adapter();

                translate([0, 0, base_offset])
                    linear_extrude(height=70)
                        duct();
            }
            translate([60, 60, 30])
                linear_extrude(height=70)
                        circle(d=inch_to_mm(4)-(adapter_thickness*2), $fn=50);
            translate([0, 0, base_offset])
                adapter_cut();
        }
        intersection() {
            translate([0, 0, base_offset])
                cone_partial();
            translate([0, 0, base_offset])
                linear_extrude(height=100)
                    triangle_insets();
        }
    }
    linear_extrude(height=60)
        fan_mount_points(grill_screw_size/2);
    translate([0, 0, base_offset])
        linear_extrude(height=grill_screw_inset)
            fan_mount_points(fan_case_screw_radius);
    translate([0, 0, base_offset + 5])
        linear_extrude(height=100)
            fan_mount_points(5.6/2);
}
