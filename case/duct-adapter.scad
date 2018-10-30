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

module triangle_inset() {
    hull() {
        difference() {
            polygon(points=[[0, 0], [0, 30], [30,0]]);
            polygon(points=[[0, 0], [0, 10], [10,0]]);
        }
        translate([5, 5])
            circle(r=5);
    }
}

module triangle_insets() {
    triangle_inset();
    translate([120, 0, 0]) rotate([0, 0, 90]) triangle_inset();
    translate([0, 120, 0]) rotate([0, 0, 270]) triangle_inset();
    translate([120, 120, 0]) rotate([0, 0, 180]) triangle_inset();
}

module adapter() {
    difference() {
        hull() {
            translate([30, 30, 30])
                scale([0.5, 0.5, 1])
                    linear_extrude(height=30)
                        profile();
            translate([0, 0, -1])
                linear_extrude(height=1)
                    profile();
        }
        hull() {
            translate([30, 30, 30])
                linear_extrude(height=30)
                    offset(r=-adapter_thickness)
                        scale([0.5, 0.5, 1])
                            profile();
            translate([0, 0, -1])
                linear_extrude(height=1)
                    offset(r=-adapter_thickness)
                        profile();
        }
    }
}

module adapter_cut() {
    hull() {
        translate([30, 30, 30])
            linear_extrude(height=30)
                offset(r=-adapter_thickness)
                    scale([0.5, 0.5, 1])
                        profile();
        translate([0, 0, -1])
            linear_extrude(height=1)
                offset(r=-adapter_thickness)
                    profile();
    }
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

difference() {
    union() {
        linear_extrude(height=20) {
            union() {
                base_adapter();
                triangle_insets();
            }
        }
        translate([0, 0, 20])
            adapter();

        translate([0, 0, 30])
            linear_extrude(height=70)
                duct();
    }
    translate([60, 60, 30])
        linear_extrude(height=70)
                circle(d=inch_to_mm(4)-(adapter_thickness*2), $fn=50);
    translate([0, 0, 20])
        adapter_cut();
}
