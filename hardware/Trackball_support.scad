// Trackball support for optic flow sensors
//v1.1
// For easy preview, change the sphere $fn to 30 (line 52)


$fn = 30;
echo(version=version());
Trackball_support(diameter=44, height="low", inlet=false); //44

module Trackball_support(diameter=44, height="low", inlet=true){
//
// Height: "low", "high"
// Inlet: true, false, "only".
//     
// ------------------------------------------
    
    // Optic flow sensor
    outer_dims = [2.7,24,24];
    slit_width = 20;
    center2sensor = 5;
    
    // How much of the ball should be covered
    cover = height=="low" ? 1/3 : 1/2;
    base_height = 10;
    sensor_space = 15;
    side_pad = sensor_space+(2*outer_dims[0]);
    slit_height = 10;
    slit_translate = -(diameter*cover);
    airhole_dia = 3;
    
    
    // Some calculations to make the octagon correctly sized
    rad = (diameter+2*side_pad)/2;
    a = rad * (2*sqrt(2)-2);
    rc = a / (sqrt(2-sqrt(2)));
    s2s_diam = rc * 2;
    

// ---------------------------------------------    
    
    
    
    // ##### Make the trackball base #####
    
    if(inlet != "only"){
        difference(){
            rotate([0,0,360/16])
            difference(){
                translate([0,0,diameter/2]) 
                cylinder(h=diameter, d=s2s_diam, $fn=8, center=true);
                translate([0,0,base_height+(diameter/2)]) 
                #sphere(d=diameter, $fn=360);
                translate([0,0,(diameter/2)+base_height+(diameter*cover)])
                cylinder(h=diameter, d=s2s_diam+1, $fn=8, center=true);
                cylinder(h=diameter*5, d=airhole_dia, center=true);
            }
            
            
            
            
            
            
    // ##### Make slits for OF sensor #####
            
            for (i=[0 : 90 : 359]){
                rotate([0,0,i]){
                #translate([(diameter/2)+sensor_space+(outer_dims[0]/2),0,diameter*cover+base_height+center2sensor])
                cube(outer_dims, center=true);
                translate([(diameter/2)+sensor_space+outer_dims[0]+5,0,diameter*cover+base_height+center2sensor])
                cube([10,slit_width,outer_dims[2]], center=true);
                }
            }
        }
    }


    // ##### Inlet piece for attaching tube #####
    
    if (inlet==true || inlet == "only"){
        
        inlet_diam_inner = 6;
        inlet_diam_outer = inlet_diam_inner + 5;
        brim_diam = inlet_diam_outer + 15;
        
        translate ([diameter*1.3,0])
        difference(){
            union(){
                cylinder(h=20,d=inlet_diam_outer, $fn=30);
                cylinder(h=2, d=brim_diam);
            }
            cylinder(h=40,d=inlet_diam_inner, $fn=30);
        }
    }
}
