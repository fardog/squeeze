include <../../lib/params.scad>;
use <../../lib/utils.scad>;

$fn=50;

total_height = led_strip_screw_head * 2 + led_strip_screw_offset * 2;
total_width = total_height*2 + led_strip_width/2 + led_strip_screw_offset;
screw_offset = led_strip_width/2 + led_strip_screw_offset + led_strip_screw_radius;

module through_profile() {
    linear_extrude(led_strip_depth)
        roundrect([total_width, total_height], 3, center=true);
}

module left_screw_translate() {
    translate([-screw_offset, 0, 0])
        children();
}

module right_screw_translate() {
    translate([screw_offset, 0, 0])
        children();
}

module outer() {
    union() {
        difference() {
            through_profile();
            left_screw_translate()
                screw(
                    r=led_strip_screw_radius,
                    l=led_strip_depth,
                    head=led_strip_screw_head,
                    cap=led_strip_screw_inset
                );
            right_screw_translate()
                screw(
                    r=led_strip_screw_radius,
                    l=led_strip_depth,
                    head=led_strip_screw_head,
                    cap=led_strip_screw_inset
                );
        }
    }
}

module inner() {
    union() {
        difference() {
            union() {
                through_profile();
            }
            left_screw_translate()
                screw(
                    r=led_strip_screw_radius,
                    l=led_strip_depth,
                    head=led_strip_nut_head,
                    cap=led_strip_nut_inset,
                    head_fn=6
                );
            right_screw_translate()
                screw(
                    r=led_strip_screw_radius,
                    l=led_strip_depth,
                    head=led_strip_nut_head,
                    cap=led_strip_nut_inset,
                    head_fn=6
                );
            linear_extrude(led_strip_cutout)
                square([led_strip_width, total_width], center=true);
        }
    }
}

module drill_guide() {
    difference() {
        through_profile();
        cylinder(r=led_strip_screw_radius, h=led_strip_depth);
        left_screw_translate()
            cylinder(r=led_strip_screw_radius, h=led_strip_depth);
        right_screw_translate()
            cylinder(r=led_strip_screw_radius, h=led_strip_depth);
        linear_extrude(led_strip_cutout)
            square([led_strip_width, total_width], center=true);
    }
}
