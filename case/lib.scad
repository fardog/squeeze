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
