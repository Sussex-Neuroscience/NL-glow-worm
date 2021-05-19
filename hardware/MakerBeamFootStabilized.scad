//CUSTOMIZER VARIABLES

/* [Basic_Parameters] */

// end cap thickness, in mm
end_depth = 3.0;    // [1:0.1:10]

// slot tab length, in mm
tab_width = 30.0;    // [2:0.1:20]

// foot length (can be zero), in mm
foot_length = 30.0;    // [0:1:20]

// foot height, in mm
foot_height = 10.0;    // [2:0.5:20]

// Bolt diameter (can be zero), in mm
bolt_diameter = 3.0;    // [0:0.1:20]

// fillet radius, in mm
fillet_radius = 0.0;    // [1:0.1:20]

// hole radius (can be zero), in mm
hole_radius = 1.2;    // [0:0.1:20]

// Makerbeam slot diameter for tight fit, in mm
slot_diameter = 2.8;    // [2:0.1:20]
// varies between 2.8 and 3.1 on different pieces!

// Makerbeam slot distance to edge for tight fit, in mm
tab_height = 2.6;    // [2:0.1:20]

// Makerbeam size, in mm
rail_size = 10;   // [10:50]

//CUSTOMIZER VARIABLES END


// Sanity checks
if( end_depth <= 0 || tab_width <= 0
    || rail_size <= 0 || slot_diameter <= 0)
{
    echo("<B>Error: Missing important parameters</B>");
}


// z depth
main_depth= end_depth;
fillet_size= fillet_radius;


// our object, translated to be flat on xy plane for easy STL generation
translate([0,0,main_depth/2])
    end_cap();

module end_cap(){

    main_width= rail_size;
    main_height= rail_size;
    bolt_length= main_depth+tab_width+5;

    difference() {
      union() {
 
        // the main block
        cube([main_width,main_height,main_depth],center = true);

        // tabs to grip the rail
        tab_dist= main_width/2 - tab_height/2;
        tab_offset= main_depth/2 + tab_width/2;
        translate([tab_dist,0,tab_offset])
          cube([tab_height,slot_diameter,tab_width], center = true);
        translate([-tab_dist,0,tab_offset])
          cube([tab_height,slot_diameter,tab_width], center = true);
        translate([0,tab_dist,tab_offset])
          cube([slot_diameter,tab_height,tab_width], center = true);
        translate([0,-tab_dist,tab_offset])
          cube([slot_diameter,tab_height,tab_width], center = true);
 
        // side pieces to help stabilize the rail on a table
        if (foot_length > 0 && foot_height > 0) {
            for (i=[45,135])
                rotate([0,0,i])
                hull(){
                translate([(main_width/2+foot_length),(main_height-foot_height)/2,-main_depth/2])
                  cylinder(main_depth,foot_height/2,foot_height/2,$fn=16);
                translate([-(main_width/2+foot_length),(main_height-foot_height)/2,-main_depth/2])
                  cylinder(main_depth,foot_height/2,foot_height/2,$fn=16);
                }
              
            // hacky fillet for strength of foot joint
            difference() {
              translate([main_width/2+fillet_size/2,main_height/2-foot_height-fillet_size/2,0])
                cube([fillet_size,fillet_size,main_depth],center = true);
              translate([main_width/2+fillet_size,main_height/2-foot_height-fillet_size,-main_depth/2-1])
                cylinder(main_depth+2,fillet_size,fillet_size,$fn=16);
            }
            difference() {
              translate([-(main_width/2+fillet_size/2),main_height/2-foot_height-fillet_size/2,0])
                cube([fillet_size,fillet_size,main_depth],center = true);
              translate([-(main_width/2+fillet_size),main_height/2-foot_height-fillet_size,-main_depth/2-1])
                cylinder(main_depth+2,fillet_size,fillet_size,$fn=16);
            }
         }
      }

    // optional holes to reduce material usage, allow a little more give on tabs
    if (hole_radius > 0) {
       hole_offset = main_width/2.5 - hole_radius/2;
       translate([hole_offset,hole_offset,-3])
         cylinder(bolt_length,hole_radius,hole_radius);
       translate([-hole_offset,hole_offset,-3])
         cylinder(bolt_length,hole_radius,hole_radius);
       translate([hole_offset,-hole_offset,-3])
         cylinder(bolt_length,hole_radius,hole_radius);
       translate([-hole_offset,-hole_offset,-3])
         cylinder(bolt_length,hole_radius,hole_radius);
    }

    // hacky fillet to remove sharp corners from top
    corner_x= main_width/2-fillet_size/2;
    corner_y=main_height/2-fillet_size/2;
    cyl_x= main_width/2-fillet_size;
    cyl_y= main_height/2-fillet_size;
    difference() {
      translate([corner_x,-corner_y,0])
        cube([fillet_size,fillet_size,main_depth],center = true);
      translate([cyl_x,-cyl_y,-main_depth/2])
        cylinder(main_depth,fillet_size,fillet_size,$fn=16);
    }
    difference() {
      translate([-corner_x,-corner_y,0])
        cube([fillet_size,fillet_size,main_depth],center = true);
      translate([-cyl_x,-cyl_y,-main_depth/2])
        cylinder(main_depth,fillet_size,fillet_size,$fn=16);
    }
    
    // if no foot, then fillet all 4 corners
   if (foot_length <= 0 || foot_height < 0) {
        difference() {
          translate([corner_x,corner_y,0])
            cube([fillet_size,fillet_size,main_depth],center = true);
          translate([cyl_x,cyl_y,-main_depth/2])
            cylinder(main_depth,fillet_size,fillet_size,$fn=16);
        }
        difference() {
          translate([-corner_x,corner_y,0])
            cube([fillet_size,fillet_size,main_depth],center = true);
          translate([-cyl_x,cyl_y,-main_depth/2])
            cylinder(main_depth,fillet_size,fillet_size,$fn=16);
        }
   }

    // optional hole in center for bolt, also reduces material use
    if (bolt_diameter > 0) {
       bolt_rad= (bolt_diameter+1)/2;
       translate([0,0,-3])
         cylinder(bolt_length,bolt_rad,bolt_rad);
    }
    
    translate([0,0,-1.5]) #hull(){
    translate([0,0,2])cylinder(h=0.1, d=bolt_diameter, $fn=30);
    cylinder(h=0.1, d=bolt_diameter*2, $fn=30);
}
  }

}
