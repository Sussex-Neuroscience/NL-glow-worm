//  MOUNT
//  Built the mount for the desired bolt type and number of cavities. Choose orientation relative to mount (0 for aligned, 1 for perpendicular)
mount("M3",2,1, bearing="pillow");
module mount(bolt, cav, orient, bearing=false)
{ 
    
//    Assign variables
    if (bolt=="M4") {
        base_w = 10;
        base_l = 45;
        base_h = 1.5;
        trap_w = 2.8;
        trap_l = 10;
        trap_h = 10;
        hole_r = 1.6;
        gap=3.3;
        bearing_D = 22;
        bearing_d = 7;
        bearing_w = 8;
        
        
        // Generate the primitive with M4 specs
        mountPrim(base_w, base_l, base_h, trap_w, trap_l, trap_h, gap, hole_r, cav, orient, bearing);
        
    } else if (bolt=="M3"){
        base_w = 10;
        base_l = 45;
        base_h = 1.5;
        trap_w = 2.9;
        trap_l = 10;
        trap_h = 10;
        hole_r = 1.6;
        gap=3.3;
        bearing_D = 22;
        bearing_d = 10; //actually 8, but giving some extra room
        bearing_w = 7;
        
        // Generate the primitive with M3 specs
        mountPrim(base_w, base_l, base_h, trap_w, trap_l, trap_h, gap, hole_r, cav, orient, bearing, bearing_D, bearing_d, bearing_w);
    }
}
    

// Primitive mount without specifications
module mountPrim(base_w, base_l, base_h, 
                 trap_w, trap_l, trap_h, 
                 gap, hole_r, cav, orient, bearing, bearing_D, bearing_d, bearing_w)
{
// Value needed to position pedestals away from edge
init_space = (base_w-gap-2*trap_w)/2;   
tot_trap_w = cav*gap+cav*trap_w+trap_w;
    
    
    difference(){
        union(){
            translate([0,base_w/2,0])
            hull(){
                translate([base_w/2,0,0]) cylinder(h=base_h, d=base_w);
                translate([base_l-base_w/2,0,0]) cylinder(h=base_h, d=base_w);
            }
            //cube([base_l,base_w,base_h]); // Base
            if (bearing==false){
                if(orient==0){
                    translate([(base_l-tot_trap_w)/2,init_space,0]) 
                    rotate([0,0,orient*90])
                    pedestal(base_l, base_h, trap_w, 
                                trap_l, trap_h, gap, 
                                cav, hole_r, init_space);
                
                } else if (orient==1){
                    rotate([0,0,orient*90]) translate([0,-(base_l+tot_trap_w)/2,0]) 
                    pedestal(base_l, base_h, trap_w, 
                            trap_l, trap_h, gap, 
                            cav, hole_r, init_space);
                }
            }
            
            // Make ball pearing pedestal
            else if (bearing==true){
                translate([base_l/2,base_w/2,((bearing_D+init_space)/2+base_h*2)/2])
                bearing(base_h, base_w, bearing_D+init_space, bearing_d+init_space, bearing_w+init_space);
            }
            
            else if (bearing=="pillow"){
                translate([base_l/2,base_h,((bearing_D+init_space)/2+base_h*2)/2])
                pillow_bearing(base_h, base_w, bearing_D+init_space, bearing_d+init_space, bearing_w+init_space);
            }
        }   
        
//      Holes in base
        for (i=[0,1]){
            translate([5+(i*(base_l-10)),5,-1]) cylinder(r=hole_r,h=3,$fn=20);
        }
    }
}


// Pedestal module
module pedestal(base_l, base_h, trap_w, trap_l, trap_h, gap, cav, hole_r, init_space)
{
    width= cav*gap+cav*trap_w+trap_w;
    difference(){
        union(){
            cube([trap_l,width,base_h+(trap_h-(trap_l/2))-2]);
                
    //          Make piedestals
            for (i = [0:cav]){
                translate([trap_l/2,i*trap_w+i*gap,0])  
                rotate([-90,180,0]) 
                hull(){
                    trap(trap_w, trap_l, trap_h);
                    translate([0,trap_h,0])
                    cylinder(r=trap_l/2,h=trap_w,center=false,$fn=200);
                }
            }
        }
        translate([trap_l/2,width,trap_l]) rotate([90,90,0]) 
        cylinder(r=hole_r,h=width,$fn=20);  
    }
}


//      Basic polygon used to make the curvatures
module  trap(trap_w, trap_l, trap_h)
{ // Assign variables
            
//     Make the shape
    linear_extrude(height = trap_w, center=false, convexity = 10, twist = 0, $fn = 20) 
    polygon(
        points = [
            [-trap_l/2,0],
            [-trap_l/2,1],
            [0,trap_h],
            [trap_l/2,1],
            [trap_l/2,0]],
        paths = [
            [0,1,2,3,4]]
           );
}

module bearing(base_h, base_w, bearing_D, bearing_d, bearing_w){
    
    difference(){
        union(){
            cube([bearing_D+2*base_h,base_w,bearing_D/2+base_h*2], center=true);
            rotate([90,0,0]) translate([0,bearing_D/4+base_h,0])
            cylinder(h=base_w, d=bearing_D+2*base_h, center=true);
        }
        rotate([90,0,0]) translate([0,bearing_D/4+base_h,-base_h/2]) 
        #cylinder(h=bearing_w+base_h, d=bearing_D, $fn=30, center=true);
        rotate([90,0,0]) 
        translate([0,bearing_D/4+base_h,(base_w-bearing_w)/2]) 
        cylinder(h=bearing_w, d=bearing_D-2*base_h, $fn=30, center=true);
    }
}
    
 module pillow_bearing(base_h, base_w, bearing_D, bearing_d, bearing_w, hole_r){
    difference(){
         #union(){
            cube([bearing_D+2*base_h,base_h*2,bearing_D/2+base_h*2], center=true);
            rotate([90,0,0]) translate([0,bearing_D/4+base_h,0])
            cylinder(h=base_h*2, d=bearing_D+2*base_h, center=true);
        }
        rotate([90,0,0]) translate([0,6+base_h,0]) cylinder(r=8,h=base_w,$fn=20, center=true);
    }
}