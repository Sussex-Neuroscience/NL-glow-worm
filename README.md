# NL-glow-worm
A tracking and stimulation system for glow worms

## Aims
This set-up was design to investigate male glow-worms attraction to a stimulus that mimics the females' glow. The aim was to be able to do so in tethered animals, whose behavior could be recorded at all times. Furthermore, we intended to have the ability to fully control the stimulus position relative to the glow-worm, as well as other characteristics such as intensity (brightness) and the duration of presentation.


## Methodology

The tracking system was designed for tethered male glow-worms. Insects were fixed on top of a walking platform, which consisted in a light polystyrene ball that seated on top of a cup shape structure. The cup was perforated at the centre, allowing for air flow to be pumped through. Thus, the light ball was supported by an air cushion and could, with very little friction, rotate as the glow-worm walked. The movements of the ball, and thus the fictive path of the glow-worm, were recorded by two optical mice sensors, placed close to the ball and orthogonally to each other. The optical mice x and y velocities were recorded by a computer, and were then analyzed in terms of translational and angular distance and velocity. 

The stimulus consisted on LEDs with similar wavelength as the female glow, displayed as an array that surrounded ~ 180° of the insect's lateral visual field. The LEDs were attached to a controller and their intensity and duration of presentation controlled and recorded.

![Trackball schematics](figures/Trackball_set-up_general_whitebackground.png)

**Figure 1: Schematics of trackball and stimulation set-up for glow-worms.** A tethered male glow-worm walks on top of a polystyrene ball supported by an air cushion which seats on a custom 3D printed support (gray). As the insect walks, the ball moves beneath it and its movements are recorded by two optical mice sensors (dark green). Each optical mouse is connected to an Arduino Due, in turn connected to a USB port. The glow-worm is presented with light stimuli through LEDs (light green) fixed to a custom 3D printed array (yellow) that surrounds ~ 180° of the insect's lateral visual field. The LEDs are attached to a controller, in turn connected to a USB port.


### Tethering 

Individual male glow-worms were tethered in a fixed position, not being allowed to rotate by themselves on top of the ball nor adjust their height (Figure 2A). The following material was needed for tethering:

- **Tube:** small tube (SIZE) glued to the wings, around the insect's center of mass, with rapid (5 seconds) UV glue. The tube was kept at all times and attached to the experimental apparatus for experiments.

- **Pipette tip and syringe:** cut pipette tip (SIZE) glued to the bent tip of a long syringe (SIZE), where the insect's tube could attach to.

- **Micromanipulator:** where the other end of the syringe could attach to, for allowing the experimenter to adjust the position and height of the insect on top of the ball.



### Trackball and support

The trackball system was composed of the following materials (Figure 2B,C):

- **Trackball:** polystyrene ball (5 cm diameter).

- **Support:** custom 3D printed structure (![Trackball support scad](software/Trackball_support_5cm.scad)).

- **Pump, regulator and system of tubes and connectors:** the air flow was generated by a pump, regulated at about X lpm, and channeled to the support through a system of tubes od various sizes, ending with a specific connector that fits the model of the support.


![Trackball support](figures/Trackball_support_tethering_new.png)

**Figure 2: Detailed scheme of tethering and trackball support.** A) Male glow-worm with a tube glued to its wings, attached to the pipette tip glued to the bent end of the syringe. The syringe was attached to the micromanipulator for experiments (not shown). B) Photograph and C) Open Scad sketch of the trackball support with the real and fictive ball visible. The air flow entered through the connector on the side and passed through the opening at the center of the cup. The optical mice were fixed to the support through the portrusions on two ortogonal sides. The indents at the bottom of the support allowed for it to be mounted on a frame that kept it stable (not visible).



### Movement recordings

The walking behaviour of glow-worms was inferred by recordings of the trackball's movement. These recordings were acquired using the following hardware and software:

**Hardware**

- **Optic flow sensors:** two optical mice's (M500 Logitech) sensors and relevant circuits were detached from the remaining parts. Each was attached to a side of the trackball support, orthogonal to each other, with the sensor at the level of the ball’s equator (Figure 2B).

- **Arduino Due:** each optical mouse was connected to one Arduino Due, which in turn connected to a USB port on a computer.

**Additional recordings** 

- **Infra-red camera:** placed above the set-up and connected to the same computer via USB.  


**Software**

- **Arduino IDE (v1.8.15):** for recording the x and y velocities of the optical mice, at ~ 60 fps (![Mouse recorder arduino](software/MouseController_1.ino)).

- **Bonsai (Lopes et al., 2015):** for saving the information from the Arduinos and camera, with a time stamp per frame, in a .csv file each (![Bonsai mouse and cam](software/OneCam_TwoMouse.bonsai)).


<!-- ![Bonsai mice and cam](figures/Bonsai_mice_cam.png)

**Figure 3: Bonsai project workflow for mice and camera.** -->


### Stimulus 

A light stimulus was presented to the fixed glow-worm using the following:

**Hardware**

- **LEDs:** wavelength 555 nm; 5 mm diameter.

- **LED array:** custom 3D printed semicircular structure fitting up to 9 LEDs (![LED array scad](software/LED_line.scad); Figure 3A), placed around the trackball apparatus.

- **LED controller:** custom-printed circuit board which accommodates the microcontroller, the LED driver and up to 24 LED channels (Figure 3B). You can find more detailed information on [BadenLab/LED-Zappelin](https://github.com/BadenLab/LED-Zappelin).

**Software**

- **Arduino IDE (v1.8.15):** for setting and recording the LEDs' intensity and duration (![LED array arduino](software/LED_array_intensity_baseline.ino)).

- **Bonsai (Lopes et al., 2015):** for saving the LED information and a time stamp per frame in a .csv file (![Bonsai LEDs](software/LED.bonsai)).


![LED array and controller](figures/LED_array_controller.png)

**Figure 3: LED array and controller.** A) custom 3D printed array for fitting LEDs, with two side structures for mounting it on the same frame as the trackball support, arround it (not shown). B) Custom-printed circuit board which accommodates the microcontroller, the LED driver and up to 24 LED channels. 


<!-- ![LED bonsai](figures/LED_bonsai.png)


**Figure 5: Bonsai project workflow for LEDs.** -->

You can find the list of hardware and software ![here](hardware/List_material.xlsx).

## Data analysis

### Raw variables from the optical mice

The optical mice (Logitech M500) comprise an infrared LED, an image acquisition system (IAS) and a digital signal processor (DSP). The infrared LED light projected onto the trackball surface bounces back and is captured by the IAS, which consists in a sensor that records, in this case, around 60 images per second. As the ball near the mouse moves, these images change and this change iss processed by the DPS in order to determine the direction and magnitude of the movement. Thus, the raw data obtained from the optical mice, recorded by the Arduino Due and Bonsai, were:

- **x displacement:** specifies the relative change in pixels (dots/counts) between the current and previous frames, in the horizontal axis;

- **y displacement:** specifies the relative change in pixels (dots/counts) between the current and previous frames, in the vertical axis;

- **Time:** number of microseconds that have passed from the moment the program was uploaded into the Arduino Due.

These raw values were essentially distances, in pixel units, and each frame had an associated time.

### Specific experimental variables

The variable time was normalized to start at zero, converted to seconds (not shown), and used for merging the the data from the two mice to the nearest value. The **time difference** between frames was calculated as the difference between the current frame and the previous. 

For this particular set-up, the insect was tethered on top of the trackball facing a particular direction. As the animal turned, the ball rotated underneath it and this movement was captured by changes in the horizontal axis of the optical mice sensors. If the animal turned 360 degrees, the ball moved the correspondent value on the opposite direction. Thus, the x displacement values, in pixel units, corresponded to the full perimeter of the ball at the equator level, at which the sensors were placed (Figure 4A).

The variables calculated from the x displacement were:

- **Mean x displacement:** the negative of the mean x displacement value of the two mice;

- **Angular displacement:** Mean x displacement divided by the ball radius and multiplied by 180/pi to obtain the angle in degrees (this also corresponds to instant heading or facing angle);

- **Cumulative angular displacement:** sum of angular displacement of current and all previous frames;

- **x velocity:** Mean x displacement divided by the time difference;

- **Angular velocity:** angular displacement divided by the time difference.

As the insect walked forwards on top of the ball, the movement was captured by the changes in the vertical axis of the optical mice sensors. Because the mice were orthogonal to each other, the y displacement from one mouse (the left) was taken as x and the y displacement from the other mouse as y. The forward velocity was calculated as the hypotenuse between the two sides (Figure 4B). Either mouse's y displacement could correspond to x or y.

The variables calculated from the y displacement were:

- **Forward displacement:** the squared root of the sum of the square of the y displacement from one mouse and the square of the y displacement of the other;

- **Cumulative forward displacement:** sum of forward displacement of current and all previous frames;

- **Forward velocity:** forward displacement divided by the time difference.

Lastly, the error between the two mice was calculated as the difference between their x displacement values, which should be the same if no error occurred.


![Mice variables](figures/Mice_variables.png)

**Figure 4: Movement direction and corresponding variables from optical mice.** A) Turning movement corresponds to rotation of the ball on the horizontal axis of the optical mice and, consequently, change in their x displacement values. The x displacement from both mice should have the same value if no recording error occured. B) Walking forward corresponds to rotation of the ball on the vertical axis of the optical mice and, consequently, change in their y displacement values. C) The real forward displacement is a combination of the y displacement values from both mice which, because they are ortogonal to each other, can be calculated as the hypotenuse between the two vectors.


## Calibration of the optical mice

### Stepper motor program

The calibration was performed using a stepper motor, controlled by an Arduino Uno. A custom 3D printed ball, of the same diameter of the polystyrene ball (5 cm), was attached to the motor and positioned on top of the trackball support (Figure 5). 

The motor and ball were aligned with the mice to create a fictive reading for:

- rotation on top of the ball (Figure 4A);

- translation forward (axis between the two mice; Figure 4B);

- translation to the left (aligned with the mouse on the right);

- translation to the right (aligned with the mouse on the left).

The motor and ball rotated 360 degrees 15 times, each time with a different speeds, for each of the fictive readings.


### Calibration factor

The calibration factor was calculated by dividing the real distance moved, which corresponded to 15 times the perimeter of the ball at the equator (2 * pi * ball radius), by the mouse recorded total distance (x displacement and y displacement).

![Calibration](calibration_data/Trackball_calibration.Rmd)



### Error between mice readings

Because x velocity of each mouse should be the same, the error between mice readings was calculated as the difference between the x velocity of one and the other. This was calculated for each direction.







**Table 1: Calibration factors for each direction.** Calibration factors were very similar between the four conditions.










<!--information/link dump:  
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
https://www.researchgate.net/profile/Hansjuergen-Dahmen/publication/313776075_Naturalistic_path_integration_of_Cataglyphis_desert_ants_on_an_air-cushioned_lightweight_spherical_treadmill/links/5992c053458515a8a24bdb66/Naturalistic-path-integration-of-Cataglyphis-desert-ants-on-an-air-cushioned-lightweight-spherical-treadmill.pdf -->
