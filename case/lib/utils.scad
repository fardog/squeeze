include <params.scad>;

function tol(val) = val - tolerance;

module cone(r, angle, invert=false) {
    h = tan(angle / 2) * r;
    if (invert) {
        cylinder(r1=r,r2=0,h=h, $fn=20); 
    } else {
        cylinder(r1=0,r2=r,h=h, $fn=20); 
    }
}

module profile($fn=20) {
    minkowski() {
        translate([fan_case_radius, fan_case_radius, 0])
            square(fan_case - fan_case_radius * 2);
        circle(fan_case_radius, $fn);
    }
}

module fan_mount_points(radius, $fn=20) {
    offset = (fan_case - fan_screw_distance) / 2;
    translate([offset, offset, 0]) {
        circle(radius, $fn);
        translate([fan_screw_distance, 0, 0])
            circle(radius, $fn);
        translate([fan_screw_distance, fan_screw_distance, 0])
            circle(radius, $fn);
        translate([0, fan_screw_distance, 0])
            circle(radius, $fn);
    }
}

module square_grill(width, height, fin_width, fin_count) {
    fin_spacing = width / fin_count;
    difference() {
        square(width);
        union() {
            for (i = [0:1:fin_count]) {
                translate([(i + 1) * fin_spacing - (fin_spacing / 2) - (fin_width / 2), 0, 0])
                    square([fin_width, height]);
            }
        }
    }
}

function inch_to_mm(inches) = inches * 25.4;
