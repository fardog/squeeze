include <../lib/params.scad>;
use <../lib/utils.scad>;

caddy_width = filter_width - tolerance;
caddy_height = filter_thickness - tolerance;
caddy_depth = filter_width + filter_offset + front_grill_fin_thickness / 2;
caddy_vec = [caddy_width, caddy_depth];
caddy_front_set = caddy_depth - filter_width;
caddy_handle_offset = caddy_width / 2 - caddy_handle_width / 2;

module caddy_profile() {
    union() {
        square([caddy_width, caddy_depth / 2]);
        roundrect(caddy_vec, 2);
    }
}

union() {
    linear_extrude(height=caddy_height)
        union() {
            // base
            difference() {
                caddy_profile();
                offset(r=-caddy_thickness)
                    caddy_profile();
            }
            // front set
            square([caddy_width, caddy_front_set]);
        }
    // handle
    difference() {
        // handle body
        linear_extrude(height=caddy_height)
            translate([caddy_handle_offset, -caddy_handle_depth, 0])
                square([caddy_handle_width, caddy_handle_depth]);
        // grip cutouts
        translate([caddy_handle_offset, -caddy_handle_grip_width, caddy_height-caddy_handle_grip_depth])
            linear_extrude(height=caddy_handle_grip_depth) {
                for (i = [0:1:caddy_handle_grip_count]) {
                    translate([0, i*(-caddy_handle_grip_width-caddy_handle_grip_depth), 0])
                        square([caddy_handle_width, caddy_handle_grip_width]);
                }
            }
    }
    // clip
    translate([caddy_handle_offset + caddy_handle_width, adapter_thickness, caddy_height])
        rotate([0, -90, 0])
            linear_extrude(height=caddy_handle_width)
                polygon([[0, 0], [0, caddy_clip_depth], [caddy_clip_height, caddy_clip_offset]]);
}
