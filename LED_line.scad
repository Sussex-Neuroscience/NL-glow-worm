// intersection.scad - Example for intersection() usage in OpenSCAD

echo(version=version());

module LED_line()

    difference(){
        difference(){
            cylinder (h = 5, d = 65, $fn=200);
            translate([0, 0, -0.5])
            cylinder (h = 6, d = 60, $fn=200);
        }
        translate([0, -36, -0.5])
        cube(100, 62);
    }
translate([0,-5,0]) cylinder(h = 30, d = 5, $fn=200);
translate([0,5,0]) cylinder(h = 30, d = 5, $fn=200);

//translate([21,0,0])
//rotate([0,90,0])
//cylinder(h = 5, d = 2, $fn=200)

LED_line();

