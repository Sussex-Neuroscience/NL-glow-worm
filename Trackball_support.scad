//module TrackBallSupport (h1,r1,z,r2,r3,a,a2,h2,r4,h3){
$fn = 30;
echo(version=version());

module Trackball_support(diameter=45, height="low", inlet=true){
//
// Height: "low", "high"
// Inlet: true, false, "only".
//  
    
    // How much of the ball should be covered
    cover = height=="low" ? 1/3 : 1/2;
    base_height = 10;
    side_pad = 15;
    slit_height = 10;
    slit_translate = -(diameter*cover);
    airhole_dia = 3;
    

    // Make the trackball base
    if(inlet != "only"){
        difference(){
            rotate([0,0,360/16])
            translate([0,0,(base_height+diameter)/2])
            difference(){
                cylinder(h=diameter+base_height, d=diameter+side_pad, $fn=8, center=true);
                sphere(d=diameter, $fn=360);
                translate([0,0,(base_height+(diameter*cover))/2]){
                cylinder(h=diameter, d=diameter+side_pad+1, $fn=8, center=true);}
                cylinder(h=diameter*5, d=airhole_dia, center=true);
            }
            
    // Make slits for add-ons
            for (i=[0 : 90 : 359]){
                rotate([0,0,i]){
                translate([(diameter+side_pad*1.1)/2,0,(base_height+diameter*cover)/2])
                cube([side_pad,3,10], center=true);
                translate([(diameter+side_pad/5)/2,0,(base_height+diameter*cover)/2])
                cube([2,15,10], center=true);
                    
//                translate([(diameter+side_pad/5)/2,4.75,(base_height+diameter*cover)/2])
//                rotate([0,90,0])
//                    cylinder(h=4, d=3);
                }
            }
    // Make slits for mounts (upside down version of above)
            for (i=[45 : 90 : 359]){
                rotate([0,0,i]){
                translate([(diameter+side_pad*1.1)/2,0,base_height/2])
                cube([side_pad,3,10], center=true);
                translate([(diameter+side_pad/5)/2,0,base_height/2])
                cube([2,15,10], center=true);
                }
            }
        }
    }


    // Inlet piece for attaching tube
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

   
Trackball_support(diameter=100, height="high", inlet=false); //45
