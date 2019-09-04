include <../../lib/params.scad>;
use <../../lib/utils.scad>;

$fn=50;

inlet_pass = inlet_outer_radius*2+filament_radius*2;

module through_profile() {
    linear_extrude(through_base_depth)
        square([through_base_width, through_base_height], center=true);
}

module inlet_profile() {
    translate([0, inlet_inner_radius/2])
        intersection() {
            union() {
                square([inlet_outer_radius, inlet_length]);
                translate([inlet_outer_radius, inlet_length])
                    circle(r=inlet_outer_radius);
                translate([inlet_inner_radius, 0])
                    circle(r=inlet_inner_radius);
            }
            translate([0, -inlet_inner_radius/2])
                square([inlet_outer_radius, inlet_length+inlet_outer_radius+inlet_inner_radius]);
        }
}

module inlet() {
    difference() {
        rotate_extrude(r=360)
            translate([filament_radius, 0])
                rotate([0, 0, inlet_angle])
                    inlet_profile();
        translate([0, 0, -inlet_inner_radius])
            cylinder(d=inlet_pass*2, h=inlet_inner_radius);
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
                screw(
                    r=through_base_screw_radius,
                    l=through_base_depth,
                    head=through_base_screw_head,
                    cap=through_base_screw_inset
                );
            right_screw_translate()
                screw(
                    r=through_base_screw_radius,
                    l=through_base_depth,
                    head=through_base_screw_head,
                    cap=through_base_screw_inset
                );
            // inlet cutout
            cylinder(
                d=inlet_pass,
                h=through_base_depth
            );
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
                screw(
                    r=through_base_screw_radius,
                    l=through_base_depth,
                    head=through_base_nut_head,
                    cap=through_base_nut_inset,
                    head_fn=6
                );
            right_screw_translate()
                screw(
                    r=through_base_screw_radius,
                    l=through_base_depth,
                    head=through_base_nut_head,
                    cap=through_base_nut_inset,
                    head_fn=6
                );
            translate([0, 0, -case_thickness])
                cylinder(
                    d=through_base_fitting_d,
                    h=through_base_depth + case_thickness
                );
        }
    }
}

module drill_guide() {
    difference() {
        through_profile();
        cylinder(r=through_base_screw_radius, h=through_base_depth);
        left_screw_translate()
            cylinder(r=through_base_screw_radius, h=through_base_depth);
        right_screw_translate()
            cylinder(r=through_base_screw_radius, h=through_base_depth);
    }
}
