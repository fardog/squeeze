include <../lib/params.scad>;
use <../lib/utils.scad>;

$fn=50;

through_base_width = 60;
through_base_height = 20;
through_base_depth = 5;
through_base_screw_offset = 10;
through_base_screw_radius = 1.5;
through_base_screw_head = 2.8;
through_base_screw_inset = 3;
case_thickness = 1;
case_through_radius = 6;

inlet_length = 10;
inlet_outer_radius = 3;
inlet_inner_radius = 2;

through_base = "both";

module through_profile() {
    linear_extrude(through_base_depth)
        square([through_base_width, through_base_height], center=true);
}

module inlet_profile() {
    translate([0, 1])
        intersection() {
            union() {
                square([inlet_outer_radius, inlet_length]);
                translate([3, 10])
                    circle(r=3);
                translate([2, 0])
                    circle(r=2);
            }
            translate([0, -1])
                square([3, 15]);
        }
}

module inlet() {
    difference() {
        rotate_extrude(r=360)
            translate([1, 0])
                rotate([0, 0, -20])
                    inlet_profile();
        translate([0, 0, -2])
            cylinder(d=10, h=2);
    }
}

module left_screw_translate() {
    translate([-through_base_width/2+through_base_screw_offset, 0, 0])
        children();
}

module right_screw_translate() {
    translate([through_base_width/2-through_base_screw_offset, 0, 0])
        children();
}

module inner() {
    union() {
        difference() {
            through_profile();
            left_screw_translate()
                screw(r=1.5, l=through_base_depth, head=2.8, cap=3);
            right_screw_translate()
                screw(r=1.5, l=through_base_depth, head=2.8, cap=3);
            // inlet cutout
            cylinder(d=8, h=through_base_depth);
        }
        inlet();
    }
}

module outer() {
    union() {
        difference() {
            union() {
                through_profile();
                translate([0, 0, -case_thickness])
                    cylinder(r=case_through_radius,h=through_base_depth+case_thickness);
            }
            left_screw_translate()
                screw(r=1.5, l=through_base_depth, head=3, cap=3, head_fn=6);
            right_screw_translate()
                screw(r=1.5, l=through_base_depth, head=3, cap=3, head_fn=6);
            translate([0, 0, -case_thickness])
                cylinder(d=5, h=through_base_depth + case_thickness);
        }
    }
}

if (through_base == "inner") {
    inner();
} else if (through_base == "outer") {
    outer();
} else if (through_base == "both") {
    inner();
    translate([0, 0, -case_thickness])
        rotate([0, 180, 0])
            outer();
}
