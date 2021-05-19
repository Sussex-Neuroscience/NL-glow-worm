// Trackball support for optic flow sensors
//v1.1
// For easy preview, change the sphere $fn to 30 (line 52)


$fn = 30;
echo(version=version());
Trackball_support(diameter=44, height="low", inlet=false, preview=false); //44
function add(v, k) = [for (v=v) v+k];

module sensor_slot(){
    
    translate([-sens_outer_dims[2]/2, -sens_outer_dims[1]/2, -5])
    rotate([0,90,0])
    difference(){
        cube(sens_outer_dims);
        translate([-4,1,1])
        cube([sens_board_dims[0], sens_board_dims[1], (2/3)*sens_board_dims[2]]);
        translate([0,3,0]) cube([sens_board_dims[0],20,sens_board_dims[2]+0.8]);
    }
}

module Trackball_support(diameter=44, height="low", inlet=true, preview=false){
//
// Height: "low", "high"
// Inlet: true, false, "only".
//     
// ------------------------------------------
    
    // Optic flow sensor
    outer_dims = [2.7,24,24];
    slit_width = 20;
    center2sensor = 5;
    sens_board_dims = [10,24.2,3.2];
    sens_outer_dims = add(sens_board_dims, 2);
    extra_depth = 3.5;
    
    // How much of the ball should be covered
    cover = height=="low" ? 1/3 : 1/2;
    pre_fn = preview==false ? 360 : 30;
    base_height = 20;
    sensor_space = 20;
    side_pad = sensor_space+outer_dims[0]-0.1;
    slit_height = 10;
    slit_translate = -(diameter*cover);
    airhole_dia = 3;
    airhole_height = 10;
    hose_diam = 9.8;
    hose_thread_length = 10;
    
    
    
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
                #sphere(d=diameter, $fn=pre_fn);
                translate([0,0,(diameter/2)+base_height+(diameter*cover)])
                cylinder(h=diameter, d=s2s_diam+1, $fn=8, center=true);
                union(){
                    translate([0,0,diameter/2+airhole_height-(airhole_dia/2)]) 
                    cylinder(h=diameter, d=airhole_dia, center=true);
                    translate([0,0,airhole_height]) rotate([360*3/16,90,0]) translate([0,0,s2s_diam/2])
                    cylinder(h=s2s_diam, d=airhole_dia, center=true);
                    translate([0,0,airhole_height]) rotate([360*1.5/8,90,0])  
                    translate([0,0,rad-hose_thread_length/2])
                    #cylinder(h=hose_thread_length, d=hose_diam, center=true, $fn=pre_fn);
                }
            }
            
            // Here we're just removing excess... maybe, maybe not???
            for (i=[0 : 45 : 134]){
                rotate([0,0,i]){
                    translate([-diameter, diameter/1.5,0])
                    #cube([diameter*2,diameter*2,base_height+diameter*cover]);
                }
            }
            
            
            
            // ##### Make slits for OF sensor #####
            
            for (i=[90 : 90 : 180]){
                rotate([0,0,i]){
                    translate([-diameter/2-sensor_space,0,diameter/2+base_height])
                    translate([-sens_outer_dims[2]/2, -sens_outer_dims[1]/2, -5])
                    rotate([0,90,0]){
                        translate([-4,1,1])
                        cube([sens_board_dims[0], sens_board_dims[1], (2/3)*sens_board_dims[2]]);
                        translate([0,3,0]) 
                        cube([sens_board_dims[0],20,sens_outer_dims[2]]);
                    }
                }
            }
        }
                   
            for (i=[90 : 90 : 180]){
                rotate([0,0,i]){
                    translate([-diameter/2-sensor_space,0,diameter/2+base_height])
                    translate([-sens_outer_dims[2]/2, -sens_outer_dims[1]/2, -5])
                    rotate([0,90,0])
                    difference(){
                        cube(sens_outer_dims);
                        translate([-4,1,1])
                        cube([sens_board_dims[0], sens_board_dims[1], (2/3)*sens_board_dims[2]]);
                        translate([0,3,0]) 
                        cube([sens_board_dims[0],20,sens_outer_dims[2]]);
                    }
                    cube([sens_board_dims[0], sens_board_dims[1], (2/3)*sens_board_dims[2]]);
                    translate([0,3,0]) 
                    cube([sens_board_dims[0],20,sens_board_dims[2]+extra_depth]);
                }
            }
//                #translate([(diameter/2)+sensor_space+(outer_dims[0]/2),0,diameter*cover+base_height+center2sensor])
//                cube(outer_dims, center=true);
//                translate([(diameter/2)+sensor_space+outer_dims[0]+5,0,diameter*cover+base_height+center2sensor])
//                cube([10,slit_width,outer_dims[2]], center=true);
//                }
//            }
//        }
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
