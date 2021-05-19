use </Users/roaldarbol/Documents/sussex/github/NL-glow-worm/hardware/mount.scad>;

base_w = 10;
base_l = 40;
base_h = 1.5;
trap_w = 2.8;
trap_l = 10;
trap_h = 10;
hole_r = 1.6;
gap=3.3;
init_space = (base_w-gap-2*trap_w)/2;   
cav=1;
tot_trap_w = cav*gap+cav*trap_w+trap_w;

// Use: Bolt, number of gaps, orientation (0:1)
mount("M3",1,0);