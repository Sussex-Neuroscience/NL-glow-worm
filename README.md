# NL-glow-worm
A tracking and stimulation system for glow worms

### Aims
This set-up was design to investigate male glow-worms attraction to a stimulus that mimics the female’s glow. The aim was to be able to do so in tethered animals, whose behavior can be recorded at all times. Furthermore, we intended to have the ability to fully control the stimulus position relative to the glow-worm, as well as other characteristics such as intensity (brightness) and the duration of presentation.


## Set-up schematics

### General description
In summary, the set-up consists in a tethered male glow-worm, walking on top of polystyrene ball supported by an air cushion. As the insect walks, the ball moves beneath it and its movements are recorded by two optical mice sensors, placed close to the ball and orthogonally to each other. Each optical mouse is connected to an Arduino Due, in turn connected to a USB port. The optical mice x and y velocities are recorded by the computer, which are then analyzed in terms of translational and angular velocities.
The stimulus consists on LEDs with similar wavelength as the female glow, displayed as an array that surrounds ~ 180° of the insect visual field. The LEDs are attached to a controller and their intensity and duration of presentation can be controlled and recorded.



![Trackball_set-up_general](/Sussex-Neuroscience/NL-glow-worm/figures/Trackball_set-up_general.pdf)


**Figure 1:** Scheme and photo of whole set-up










information/link dump:  
https://www.adafruit.com/product/1356  
https://www.mouser.co.uk/ProductDetail/Lumex/SSL-LX5093PGD?qs=%2Fha2pyFaduh%252BeY3QLiqc1szK7GoZblk1b%252BVpa99b7ZsXu%2FBD2FbvvA%3D%3D  

https://scanbox.org/2014/04/23/ball-tracking/comment-page-1/  


https://www.bidouille.org/files/hack/mousecam/Understanding%20Optical%20Mice%20White%20Paper.pdf  

https://www.bidouille.org/files/hack/mousecam/Optical_Flow_OPT.pdf  

note on work in progress:


26/04/2021
Seems mouse sensors using for optical flow detection are extremelly hard to come by in small quantities. I started [this thread](https://forum.openhardware.science/t/tracking-movement-with-a-computer-mouse-help/2834) on the GOSH Forum and some people have chipped in with ideas/suggestions and resources.

In the meantime I bought a cheap Ebay mouse to take it apart and see if we could learn something from the parts/components and if it would work as well on styrofoam spheres.

## SCAD Files
Contains the trackball support SCAD file. Current version has slits for mounts. Parameters:

`diameter` Diameter of the ball. Defaults to 44mm.
 - Glow worms: 44mm
 - Beetles: 100mm
 - Wood ants: 44mm  
`height="high"/"low"` Determines if 1/2 or 1/3 of the ball is covered.  
`inlet=true/false/"only"` Whether to include an inlet which can be glued underneath the holder. 

Currently the space thickness of the sides may need to be increased to make better room for the slits.

Also scad file for LED array (LED_line) - half circunfrence, 6 cm inner diameter, 0.5 cm thickness; with two rods to glue on the side for holding and rotating if needed (0.5 cm diam, 3 cm long)

## Trackball program
A small standalone program which reads the movement of the cursor (motion in x controls rotational motion (orientation angle), changes in y translational movement). Stop the script with SPACE. Ideally integrate two ortogonal optical mouse. 

Note: Tracking ball movement with camera also possible (see links bellow for FicTrac)


## Previous studies with trackballs:

- FicTrac paper for tracking ball motion with a camera:
https://www.researchgate.net/profile/Gavin-Taylor-2/publication/260044337_FicTrac_A_visual_method_for_tracking_spherical_motion_and_generating_fictive_animal_paths/links/5daa3b78299bf111d4be68c9/FicTrac-A-visual-method-for-tracking-spherical-motion-and-generating-fictive-animal-paths.pdf

https://www.biorxiv.org/content/10.1101/2021.04.29.442008v1.full.pdf

https://www.dropbox.com/sh/5tcplzvkufx8qrj/AAAbGobTdm5zj6f1vsMPDctEa (out of date - have not found current software)

- Trackball for ants (no stimulus):
https://www.researchgate.net/profile/Hansjuergen-Dahmen/publication/313776075_Naturalistic_path_integration_of_Cataglyphis_desert_ants_on_an_air-cushioned_lightweight_spherical_treadmill/links/5992c053458515a8a24bdb66/Naturalistic-path-integration-of-Cataglyphis-desert-ants-on-an-air-cushioned-lightweight-spherical-treadmill.pdf
