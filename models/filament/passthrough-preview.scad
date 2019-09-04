include <../lib/params.scad>;
use <lib/passthrough.scad>;

$fn=50;

inner();
translate([0, 0, -case_thickness])
    rotate([0, 180, 0])
        outer();
