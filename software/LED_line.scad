// This is a 9 cm diameter semicircular LED array that 
// fits 9 typical LEDs with 5 mm diameter
// equally spaced between each other
// with two holders on the side for attaching it to a frame

echo(version=version());
module LED_line()

// circular array  - 9 cm diameter

difference(){
   difference(){
        difference(){
        cylinder (h = 10, d = 94, $fn=200);
        translate([0, 0, -0.5]){cylinder (h = 11, d = 90, $fn=200);}
        }
        translate([5, -47, -0.5]){cube([120, 120, 120]);}
    }

// holes for LEDs
  // center  
   translate([-46,0,5]){sphere(d = 6, $fn = 50);}

  // side 1 
   translate([-42.498,17.603,5]){sphere(d = 6, $fn = 50);} 
   translate([-32.5269,32.5269,5]){sphere(d = 6, $fn = 50);} 
   translate([-17.603,42.498,5]){sphere(d = 6, $fn = 50);} 
   translate([0,46,5]){sphere(d = 6, $fn = 50);} 
   
  // side 2 
   translate([-42.498,-17.603,5]){sphere(d = 6, $fn = 50);} 
   translate([-32.5269,-32.5269,5]){sphere(d = 6, $fn = 50);} 
   translate([-17.603,-42.498,5]){sphere(d = 6, $fn = 50);} 
   translate([0,-46,5]){sphere(d = 6, $fn = 50);}    
}    

    
// holders    
difference(){
    translate([5,-80.5,0]){cube([2,36,10]);}
    translate([6,-48,5]){rotate([90,0,0]){cylinder(d = 4, h = 30, $fn = 50);}
}}

difference(){
    translate([5,44.5,0]){cube([2,36,10]);}
    translate([6,78,5]){rotate([90,0,0]){cylinder(d = 4, h = 30, $fn = 50);}}
//} 
}










LED_line();