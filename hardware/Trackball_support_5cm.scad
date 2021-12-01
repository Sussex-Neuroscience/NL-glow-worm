//module TrackBallSupport (h1,r1,z,r2,r3,a,a2,h2,r4,h3){

echo(version=version());
Trackball_support();

module Trackball_support(){



//------- Ball diameter - to change for specific ball size
    ball_diameter = 50;


//------- Other variables - optimized for optical mouse Logitech M500 - do not change unless using different sensor
    ball_to_edge = 5;
    support_cube = ball_diameter + (ball_to_edge*2);
    cup_size = support_cube + (ball_diameter/6);//1/3 of the ball

    mouse_piece_length_out = 5;
    mouse_piece_width = 3;
    mouse_piece_length = 16;
    mouse_to_top = 7;
    
//------- Base - optimized for fitting Makerbeam - do not change unless changing the set-up
    
    beam_width = 12;
    
    base_height = beam_width * 2;
    base_width = support_cube * 1.5;


difference(){ //for inlet

// Trackball support

translate([0,0,base_height]){
     difference(){ 
     difference(){
         translate([-support_cube/2,-support_cube/2,0]){cube(support_cube);}
         #translate([0,0,cup_size]){sphere(d=ball_diameter,$fn=200);} 
     }

 }
 }
 
 
// inlet for pump 
translate([0,0,base_height+10]){ 
 rotate([90,0,0]){
          translate([0,0,support_cube/2-9]){cylinder(h=10,d=9.8,$fn=30);}
          cylinder(h=support_cube/2+1,d=3, $fn=30);
          translate([0,-1.5,0]){rotate([-90,0,0]){cylinder(h=support_cube+1.5,d=3, $fn=30);}}
      }
  }
 }
 

// pieces for fitting mice  
  rotate([0,90,0]){translate([-(support_cube+base_height-mouse_to_top),-mouse_piece_length/2,support_cube/2]){cube([mouse_piece_width,mouse_piece_length,mouse_piece_length_out]);}}
  rotate([0,90,90]){translate([-(support_cube+base_height-mouse_to_top),-mouse_piece_length/2,support_cube/2]){cube([mouse_piece_width,mouse_piece_length,mouse_piece_length_out]);}}

 
// Base

difference(){

rotate([0,0,45]){
    difference(){
    
      translate([-base_width/2,-base_width/2,0]){cube([base_width,base_width,base_height]);}
  
      union(){
          rotate(90,0,0){translate([-(base_width/2),base_width/2-beam_width,beam_width/2]){cube([base_width,beam_width+0.1,beam_width]);}}
          rotate(90,0,0){translate([(-base_width/2),-base_width/2-0.1,beam_width/2]){cube([base_width,beam_width+0.1,beam_width]);}}
          rotate(0,90,0){translate([(-base_width/2),-base_width/2-0.1,beam_width/2]){cube([base_width,beam_width+0.1,beam_width]);}}
         rotate(0,90,0){translate([-(base_width/2),base_width/2-beam_width,beam_width/2]){cube([base_width,beam_width+0.1,beam_width]);}}
      
  }
  }
  }
  translate([-base_width/2,base_width/2,-1]){cube([base_width,base_width,base_height+1.5]);}
  translate([base_width/2,-base_width/2,-1]){cube([base_width,base_width,base_height+1.5]);}
  translate([-base_width*1.5,-base_width/2,-1]){cube([base_width,base_width,base_height+1.5]);}
  translate([-base_width/2,-base_width*1.5,-1]){cube([base_width,base_width,base_height+1.5]);}
} 

}


