include <params.scad>;

function tol(val) = val - tolerance;

module cone(r, angle, invert=false) {
    h = tan((180 - angle) / 2) * r;
    translate([0, 0, -h]) {
        if (invert) {
                cylinder(r1=r,r2=0,h=h, $fn=20); 
        } else {
            cylinder(r1=0,r2=r,h=h, $fn=20); 
        }
    }
}

module roundrect(vect, r, center=false, $fn=20) {
    sq = len(vect) > 1
        ? [for (i = [0:1:len(vect)-1]) vect[i] - r * 2]
        : vect - r * 2;
    if (center) {
        translate([-(sq[0]+r*2)/2,-(sq[1]+r*2)/2])
        minkowski() {
            square(sq);
            translate([r, r])
                circle(r=r);
        }
    } else {
        minkowski() {
            square(sq);
            translate([r, r])
                circle(r=r);
        }
    }
}

module profile($fn=20) {
    minkowski() {
        translate([fan_case_radius, fan_case_radius, 0])
            square(fan_case - fan_case_radius * 2);
        circle(fan_case_radius, $fn=$fn);
    }
}

module fan_mount_points(radius, $fn=20) {
    offset = (fan_case - fan_screw_distance) / 2;
    translate([offset, offset, 0]) {
        circle(radius, $fn=$fn);
        translate([fan_screw_distance, 0, 0])
            circle(radius, $fn=$fn);
        translate([fan_screw_distance, fan_screw_distance, 0])
            circle(radius, $fn=$fn);
        translate([0, fan_screw_distance, 0])
            circle(radius, $fn=$fn);
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

module bushing(outer_r, inner_r, h) {
    linear_extrude(h)
        difference() {
            circle(r=outer_r);
            circle(r=inner_r);
        }
}

module screw_at_origin(r, d, l, head, head_d, cap, angle) {
    translate([0, 0, -l])
        screw(r, d, l, head, head_d, cap, angle);
}

module screw(r, d, l, head, head_d, cap, angle, fn=20, head_fn) {
    radius = r > 0 ? r : d / 2;
    head_r = head > 0 ? head : head_d / 2;
    hfn = head_fn ? head_fn : fn;

    union() {
        if (angle) {
            translate([0, 0, l])
                cone(head_r, angle, false);
        }
        linear_extrude(l)
            circle(r=radius, $fn=fn);
        if (cap > 0) {
            union() {
                translate([0, 0, l - cap])
                    linear_extrude(cap)
                        circle(r=head_r, $fn=hfn);
                translate([0, 0, l - cap - layer_height])
                    linear_extrude(layer_height)
                        square([radius * 2, head_r*2], center=true);
                translate([0, 0, l - cap - layer_height*2])
                    linear_extrude(layer_height)
                        square([radius * 2, radius*2], center=true);
            }
        }
    }
}

module inset_screw(r, d, l, head, head_d, cap, angle, inset, fn=20, head_fn) {
    screw_height = l - inset;
    head_r = head > 0 ? head : head_d / 2;

    union() {
        screw(
            r=r,
            d=d,
            l=screw_height,
            head=head_r,
            cap=cap,
            angle=angle,
            fn=fn,
            head_fn=head_fn
        );
        translate([0, 0, screw_height])
            linear_extrude(inset)
                circle(r=head_r, $fn=fn);
    }
}

function inch_to_mm(inches) = inches * 25.4;
