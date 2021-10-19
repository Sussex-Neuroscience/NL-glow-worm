---
title: "Trackball_Calibration"
author: "Sofia Fernandes"
date: "13/10/2021"
output: html_document
---


```
## Error in parse_block(g[-1], g[1], params.src, markdown_mode): Duplicate chunk label 'libraries and global variables', which has been used for the chunk:
## 
## library(dplyr)
## library(grid)
## library(gridExtra)
## library(ggpubr)
## library(tidyverse)
## library(tidyr)
## library(lubridate)
## library(ggplot2)
## library(REdaS)
## library(flextable)
## 
## 
## # ggplot theme
## theme <- theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
##         panel.background = element_blank(), axis.line = element_line(colour = "black"),
##         text = element_text(size=12),
##         axis.text = element_text(size=10),
##         legend.position = "none")
## 
## 
## # Ball radius and perimeter at equator
## ball_rad <- 25 # in mm
## real_distance <- 15*(2*pi*ball_rad)
## 
## 
## # Knit to md file
## knit(input="Trackball_calibration.rmd", output = "Trackball_calibration.md")
```

## Stepper motor program

The calibration was performed using a stepper motor, controlled by an Arduino Uno. A custom 3D printed ball, of the same diameter of the polystyrene ball (5 cm), was attached to the motor and positioned on top of the trackball support. 

The motor and ball were aligned with the mice to create a fictive reading for:

- rotation on top of the ball;

- translation forward (axis between the two mice);

- translation to the left (aligned with the mouse on the right);

- translation to the right (aligned with the mouse on the left).

The motor and ball rotated 360 degrees 15 times, each time with a different speeds, for each of the fictive readings.

## Variables

### Raw variables from the optical mice

The optical mice (Logitech M500) comprise an infrared LED, an image acquisition system (IAS) and a digital signal processor (DSP). The infrared LED light projected onto the trackball surface bounces back and is captured by the IAS, which consists in a sensor that records, in this case, around 60 images per second. As the ball near the mouse moves, these images change and this change is processed by the DPS in order to determine the direction and magnitude of the movement. Thus, the raw data obtained from the optical mice, recorded by the Arduino Due and Bonsai are:

- **x displacement:** specifies the relative change in pixels (dots/counts) between the current and previous frames, in the horizontal axis;

- **y displacement:** specifies the relative change in pixels (dots/counts) between the current and previous frames,in the vertical axis;

- **Time:** number of microseconds that have passed from the moment the program was uploaded into Arduino.

These raw values are essentially distances, in pixel units, and each frame has an associated time.

### Specific experimental variables

The variable time was normalized to start at zero, converted to seconds (not shown), and used for merging the the data from the two mice to the nearest value. The time difference between frames calculated:

- **Time difference:** time difference between the current frame and the previous. 

For this particular set-up, the insect is tethered on top of the trackball facing a particular direction. As the animal turns, the ball rotates underneath it and this movement is captured by changes in the horizontal axis of the optical mice sensors. If the animal turns 360 degrees, the ball moves the correspondent value on the opposite direction. Thus, the x displacement values, in pixel units, correspond to the full perimeter of the ball at the equator level, at which the sensors are placed.

The variables calculated from the x displacement were:

- **Rotation linear displacement:** the negative of the mean x displacement value of the two mice;

- **Angular displacement:** Rotation linear displacement divided by the ball radius and multiplied by 180/pi to obtain this angle in degrees (this also corresponds to instant heading or facing angle);

- **Cumulative angular displacement:** sum of angular displacement of current and all previous frames;

- **Rotation linear velocity:** Rotation linear displacement divided by the time difference;

- **Angular velocity:** angular displacement divided by the time difference.

As the insect walks forwards on top of the ball, the movement is captured by the changed in the vertical axis of the optical mice sensors. Because the mice were orthogonal to each other, the y displacement from one mouse (the left) was taken as x and the y displacement from the other mouse as y and the forward velocity calculated as the hypotenuse between the two sides. Either mouse's y displacement could correspond to x or y.

The variables calculated from the y displacement were:

- **Forward displacement:** the squared root of the sum of the square of the y displacement from one mouse and the square of the y displacement of the other;

- **Cumulative forward displacement:** sum of forward displacement of current and all previous frames;

- **Forward velocity:** forward displacement divided by the time difference.

Lastly, the error between the two mice was calculated as the difference between their x displacement values, which should be the same if no error occurred.




```r
# Set working directory
workdir_path <- "C:/Users/asd27/Desktop/Trackball calibration/Calibration_15Rot_difSpeed/R"
setwd(workdir_path)


# Merge mice by nearest time numeric

#### Rotation
LeftMouse1_Rotation <- read.csv("LeftMouse1_Rotation.csv", header = TRUE)
RightMouse2_Rotation <- read.csv("RightMouse2_Rotation.csv", header = TRUE)

## convert to data.table by reference
require(data.table)
setDT(LeftMouse1_Rotation) 
setDT(RightMouse2_Rotation)      

setkey(LeftMouse1_Rotation, Time_normalized_seconds)    ## set the column to perform the join on
setkey(RightMouse2_Rotation, Time_normalized_seconds)    ## same as above

merged_Rotation <- LeftMouse1_Rotation[RightMouse2_Rotation, roll='nearest']

# Add time difference between frame i and the next; this will correspond to the angular velocity in frame i
# So between frame i and i+1 the velocity was i

merged_Rotation <- merged_Rotation %>% mutate(Time_difference = 0)

for (i in 1:nrow(merged_Rotation)){
  merged_Rotation$Time_difference[i] = merged_Rotation$Time_normalized_seconds[i+1]-merged_Rotation$Time_normalized_seconds[i]
}

merged_Rotation <- merged_Rotation %>% 
  select(c(-X, -i.X, Time, -i.Time)) %>%
  mutate(LeftMouse1_x = as.numeric(LeftMouse1_x),
         RightMouse2_x = as.numeric(RightMouse2_x),
         Rotation_linear_displacement = -(LeftMouse1_x + RightMouse2_x)/2,
         Angular_displacement = Rotation_linear_displacement/ball_rad * 180/pi,
         Rotation_linear_velocity = Rotation_linear_displacement * Time_difference,
         Angular_velocity = Angular_displacement * Time_difference,
         Forward_displacement = sqrt(LeftMouse1_y^2 + RightMouse2_y^2),
         Forward_velocity = Forward_displacement / Time_difference,
        # Translation_angle = rad2deg(atan(RightMouse2_y/LeftMouse1_y)),
         Mice_x_error = LeftMouse1_x - RightMouse2_x)

# Cumulative angular distance (cumulative heading)
merged_Rotation <- merged_Rotation %>% mutate(Cumulative_angular_displacement = 0)

for (i in 2:nrow(merged_Rotation)){
  merged_Rotation$Cumulative_angular_displacement[i] <- merged_Rotation$Angular_displacement[i] + merged_Rotation$Cumulative_angular_displacement[i-1]
  merged_Rotation$Cumulative_forward_displacement[i] <- merged_Rotation$Forward_displacement[i] + merged_Rotation$Cumulative_forward_displacement[i-1]
}
                          


### Translation forwards
LeftMouse1_TranslationForwards <- read.csv("LeftMouse1_TranslationForwards.csv", header = TRUE)
RightMouse2_TranslationForwards <- read.csv("RightMouse2_TranslationForwards.csv", header = TRUE)

## convert to data.table by reference
require(data.table)
setDT(LeftMouse1_TranslationForwards) 
setDT(RightMouse2_TranslationForwards)      

setkey(LeftMouse1_TranslationForwards, Time_normalized_seconds)    ## set the column to perform the join on
setkey(RightMouse2_TranslationForwards, Time_normalized_seconds)    ## same as above

merged_TranslationForwards <- LeftMouse1_TranslationForwards[RightMouse2_TranslationForwards, roll='nearest']

# Add time difference between frame i and the next; this will correspond to the angular velocity in frame i
# So between frame i and i+1 the velocity was i

merged_TranslationForwards <- merged_TranslationForwards %>% mutate(Time_difference = 0)

for (i in 1:nrow(merged_TranslationForwards)){
  merged_TranslationForwards$Time_difference[i] = merged_TranslationForwards$Time_normalized_seconds[i+1]-merged_TranslationForwards$Time_normalized_seconds[i]
}

merged_TranslationForwards <- merged_TranslationForwards %>% 
  select(c(-X, -i.X, Time, -i.Time)) %>%
  mutate(LeftMouse1_x = as.numeric(LeftMouse1_x),
         RightMouse2_x = as.numeric(RightMouse2_x),
         Rotation_linear_displacement = -(LeftMouse1_x + RightMouse2_x)/2,
         Angular_displacement = Rotation_linear_displacement/ball_rad * 180/pi,
         Rotation_linear_velocity = Rotation_linear_displacement * Time_difference,
         Angular_velocity = Angular_displacement * Time_difference,
         Forward_displacement = sqrt(LeftMouse1_y^2 + RightMouse2_y^2),
         Forward_velocity = Forward_displacement / Time_difference,
        # Translation_angle = rad2deg(atan(RightMouse2_y/LeftMouse1_y)),
         Mice_x_error = LeftMouse1_x - RightMouse2_x)

# Cumulative angular distance (cumulative heading)
merged_TranslationForwards <- merged_TranslationForwards %>% mutate(Cumulative_angular_displacement = 0)

for (i in 2:nrow(merged_TranslationForwards)){
  merged_TranslationForwards$Cumulative_angular_displacement[i] <- merged_TranslationForwards$Angular_displacement[i] + merged_TranslationForwards$Cumulative_angular_displacement[i-1]
  merged_TranslationForwards$Cumulative_forward_displacement[i] <- merged_TranslationForwards$Forward_displacement[i] + merged_TranslationForwards$Cumulative_forward_displacement[i-1]
}



#### Translation to the left (right mouse picks up)
LeftMouse1_TranslationToLeft <- read.csv("LeftMouse1_TranslationToLeft.csv", header = TRUE)
RightMouse2_TranslationToLeft <- read.csv("RightMouse2_TranslationToLeft.csv", header = TRUE)

## convert to data.table by reference
require(data.table)
setDT(LeftMouse1_TranslationToLeft) 
setDT(RightMouse2_TranslationToLeft)      

setkey(LeftMouse1_TranslationToLeft, Time_normalized_seconds)    ## set the column to perform the join on
setkey(RightMouse2_TranslationToLeft, Time_normalized_seconds)    ## same as above

merged_TranslationToLeft <- LeftMouse1_TranslationToLeft[RightMouse2_TranslationToLeft, roll='nearest']

# Add time difference between frame i and the next; this will correspond to the angular velocity in frame i
# So between frame i and i+1 the velocity was i

merged_TranslationToLeft <- merged_TranslationToLeft %>% mutate(Time_difference = 0)

for (i in 1:nrow(merged_TranslationToLeft)){
  merged_TranslationToLeft$Time_difference[i] = merged_TranslationToLeft$Time_normalized_seconds[i+1]-merged_TranslationToLeft$Time_normalized_seconds[i]
}

merged_TranslationToLeft <- merged_TranslationToLeft %>% 
  select(c(-X, -i.X, Time, -i.Time)) %>%
  mutate(LeftMouse1_x = as.numeric(LeftMouse1_x),
         RightMouse2_x = as.numeric(RightMouse2_x),
         Rotation_linear_displacement = -(LeftMouse1_x + RightMouse2_x)/2,
         Angular_displacement = Rotation_linear_displacement/ball_rad * 180/pi,
         Rotation_linear_velocity = Rotation_linear_displacement * Time_difference,
         Angular_velocity = Angular_displacement * Time_difference,
         Forward_displacement = sqrt(LeftMouse1_y^2 + RightMouse2_y^2),
         Forward_velocity = Forward_displacement / Time_difference,
        # Translation_angle = rad2deg(atan(RightMouse2_y/LeftMouse1_y)),
         Mice_x_error = LeftMouse1_x - RightMouse2_x)

# Cumulative angular distance (cumulative heading)
merged_TranslationToLeft <- merged_TranslationToLeft %>% mutate(Cumulative_angular_displacement = 0)

for (i in 2:nrow(merged_TranslationToLeft)){
  merged_TranslationToLeft$Cumulative_angular_displacement[i] <- merged_TranslationToLeft$Angular_displacement[i] + merged_TranslationToLeft$Cumulative_angular_displacement[i-1]
  merged_TranslationToLeft$Cumulative_forward_displacement[i] <- merged_TranslationToLeft$Forward_displacement[i] + merged_TranslationToLeft$Cumulative_forward_displacement[i-1]
}



### Translation to the right (left mouse picks up)
LeftMouse1_TranslationToRight <- read.csv("LeftMouse1_TranslationToRight.csv", header = TRUE)
RightMouse2_TranslationToRight <- read.csv("RightMouse2_TranslationToRight.csv", header = TRUE)

## convert to data.table by reference
require(data.table)
setDT(LeftMouse1_TranslationToRight) 
setDT(RightMouse2_TranslationToRight)      

setkey(LeftMouse1_TranslationToRight, Time_normalized_seconds)    ## set the column to perform the join on
setkey(RightMouse2_TranslationToRight, Time_normalized_seconds)    ## same as above

merged_TranslationToRight <- LeftMouse1_TranslationToRight[RightMouse2_TranslationToRight, roll='nearest']

# Add time difference between frame i and the next; this will correspond to the angular velocity in frame i
# So between frame i and i+1 the velocity was i

merged_TranslationToRight <- merged_TranslationToRight %>% mutate(Time_difference = 0)

for (i in 1:nrow(merged_TranslationToRight)){
  merged_TranslationToRight$Time_difference[i] = merged_TranslationToRight$Time_normalized_seconds[i+1]-merged_TranslationToRight$Time_normalized_seconds[i]
}

merged_TranslationToRight <- merged_TranslationToRight %>% 
  select(c(-X, -i.X, Time, -i.Time)) %>%
  mutate(LeftMouse1_x = as.numeric(LeftMouse1_x),
         RightMouse2_x = as.numeric(RightMouse2_x),
         Rotation_linear_displacement = -(LeftMouse1_x + RightMouse2_x)/2,
         Angular_displacement = Rotation_linear_displacement/ball_rad * 180/pi,
         Rotation_linear_velocity = Rotation_linear_displacement * Time_difference,
         Angular_velocity = Angular_displacement * Time_difference,
         Forward_displacement = sqrt(LeftMouse1_y^2 + RightMouse2_y^2),
         Forward_velocity = Forward_displacement / Time_difference,
        # Translation_angle = rad2deg(atan(RightMouse2_y/LeftMouse1_y)),
         Mice_x_error = LeftMouse1_x - RightMouse2_x)

# Cumulative angular distance (cumulative heading)
merged_TranslationToRight <- merged_TranslationToRight %>% mutate(Cumulative_angular_displacement = 0)

for (i in 2:nrow(merged_TranslationToRight)){
  merged_TranslationToRight$Cumulative_angular_displacement[i] <- merged_TranslationToRight$Angular_displacement[i] + merged_TranslationToRight$Cumulative_angular_displacement[i-1]
  merged_TranslationToRight$Cumulative_forward_displacement[i] <- merged_TranslationToRight$Forward_displacement[i] + merged_TranslationToRight$Cumulative_forward_displacement[i-1]
}
```


## Calibration factor

The calibration factor was calculated by dividing the real distance moved, which corresponded to 15 times the perimeter of the ball at the equator, by the mouse recorded total distance (x displacement and y displacement).



```r
# Calibration factor for rotation
rotation_linear_displacement_recorded <- sum(merged_Rotation$Rotation_linear_displacement[1:nrow(merged_Rotation)-1])
calibration_factor_rotation <- abs(real_distance/rotation_linear_displacement_recorded)


# Calibration factor for translation forwards
translation_forwards_distance_recorded <- sum(merged_TranslationForwards$Forward_displacement[1:nrow(merged_TranslationForwards)-1])
calibration_factor_translation_forwards <- real_distance/translation_forwards_distance_recorded


# Calibration factor for translation to left
translation_toleft_distance_recorded <- sum(merged_TranslationToLeft$Forward_displacement[1:nrow(merged_TranslationToLeft)-1])
calibration_factor_translation_toleft <- real_distance/translation_toleft_distance_recorded


# Calibration factor for translation to right
translation_toright_distance_recorded <- sum(merged_TranslationToRight$Forward_displacement[1:nrow(merged_TranslationToRight)-1])
calibration_factor_translation_toright <- real_distance/translation_toright_distance_recorded


calibration_table <- data.table(Direction = c("Rotation", "Translation forwards", "Translation to left", "Translation to right"), Calibration_factor = c(calibration_factor_rotation, calibration_factor_translation_forwards, calibration_factor_translation_toleft, calibration_factor_translation_toright))

calibration_factor_mean <- mean(calibration_table$Calibration_factor)
calibration_factor_sd <- sd(calibration_table$Calibration_factor)

table1 <- flextable(calibration_table)
table1 <- fontsize(table1, part = "body", size = 8)
table1 <- colformat_double(x = table1)
table1
```


<div class="tabwid"><style>.cl-18371c94{border-collapse:collapse;}.cl-1822df40{font-family:'Arial';font-size:11pt;font-weight:normal;font-style:normal;text-decoration:none;color:rgba(0, 0, 0, 1.00);background-color:transparent;}.cl-1822df41{font-family:'Arial';font-size:8pt;font-weight:normal;font-style:normal;text-decoration:none;color:rgba(0, 0, 0, 1.00);background-color:transparent;}.cl-18232d74{margin:0;text-align:left;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);padding-bottom:3pt;padding-top:3pt;padding-left:3pt;padding-right:3pt;line-height: 1;background-color:transparent;}.cl-18232d75{margin:0;text-align:right;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);padding-bottom:3pt;padding-top:3pt;padding-left:3pt;padding-right:3pt;line-height: 1;background-color:transparent;}.cl-1824b28e{width:54pt;background-color:transparent;vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-1824b28f{width:54pt;background-color:transparent;vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-1824b290{width:54pt;background-color:transparent;vertical-align: middle;border-bottom: 2pt solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-1824b291{width:54pt;background-color:transparent;vertical-align: middle;border-bottom: 2pt solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-1824b292{width:54pt;background-color:transparent;vertical-align: middle;border-bottom: 2pt solid rgba(0, 0, 0, 1.00);border-top: 2pt solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-1824b293{width:54pt;background-color:transparent;vertical-align: middle;border-bottom: 2pt solid rgba(0, 0, 0, 1.00);border-top: 2pt solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}</style><table class='cl-18371c94'><thead><tr style="overflow-wrap:break-word;"><td class="cl-1824b293"><p class="cl-18232d74"><span class="cl-1822df40">Direction</span></p></td><td class="cl-1824b292"><p class="cl-18232d75"><span class="cl-1822df40">Calibration_factor</span></p></td></tr></thead><tbody><tr style="overflow-wrap:break-word;"><td class="cl-1824b28e"><p class="cl-18232d74"><span class="cl-1822df41">Rotation</span></p></td><td class="cl-1824b28f"><p class="cl-18232d75"><span class="cl-1822df41">0.03</span></p></td></tr><tr style="overflow-wrap:break-word;"><td class="cl-1824b28e"><p class="cl-18232d74"><span class="cl-1822df41">Translation forwards</span></p></td><td class="cl-1824b28f"><p class="cl-18232d75"><span class="cl-1822df41">0.03</span></p></td></tr><tr style="overflow-wrap:break-word;"><td class="cl-1824b28e"><p class="cl-18232d74"><span class="cl-1822df41">Translation to left</span></p></td><td class="cl-1824b28f"><p class="cl-18232d75"><span class="cl-1822df41">0.03</span></p></td></tr><tr style="overflow-wrap:break-word;"><td class="cl-1824b291"><p class="cl-18232d74"><span class="cl-1822df41">Translation to right</span></p></td><td class="cl-1824b290"><p class="cl-18232d75"><span class="cl-1822df41">0.03</span></p></td></tr></tbody></table></div>

**Table 1: Calibration factors for each direction.** Calibration factors were very similar between the four conditions.


The mean calibration factor was 0.0291947 +/- 7.773015 &times; 10<sup>-4</sup>.

# Error between mice readings

Because x velocity of each mouse should be the same, the error between mice readings was calculated as the difference between the x velocity of one and the other. This was calculated for each direction.


```r
# Histogram of error between mice - rotation
hist_error_rotation <- ggplot(merged_Rotation, aes(x = Mice_x_error))+
  geom_histogram() +
  scale_y_continuous(expand = c(0,0)) +
  ylab("N frames rotation") +
  theme


# Histogram of error between mice - translation forwards
hist_error_translationforwards <- ggplot(merged_TranslationForwards, aes(x = Mice_x_error))+
  geom_histogram() +
  scale_y_continuous(expand = c(0,0)) +
  ylab("N frames translation forwards") +
  theme


# Histogram of error between mice - translation to the left
hist_error_translationtoleft <- ggplot(merged_TranslationToLeft, aes(x = Mice_x_error))+
  geom_histogram() +
  scale_y_continuous(expand = c(0,0)) +
  ylab("N frames translation left") +
  theme


# Histogram of error between mice - translation to the right
hist_error_translationtoright <- ggplot(merged_TranslationToRight, aes(x = Mice_x_error))+
  geom_histogram() +
  scale_y_continuous(expand = c(0,0)) +
  ylab("N frames translation right") +
  theme

ggarrange(hist_error_rotation, hist_error_translationforwards, 
          hist_error_translationtoleft, hist_error_translationtoright,
          ncol = 2, nrow = 2)
```

![plot of chunk error between x mice histograms](figure/error between x mice histograms-1.png)

**Figure 1: Histograms of the error between the two mice x velocities.** A) Rotation has the largest errors between mice, as it also has the largest x values. B) Translation forwards, C) translation to left and D) translation to right have much lower error. In all cases, error is roughly centered around zero.

**Note: what cut-off error between mice to use for excluding frames?** 


















```
## Error in ggplot(merged_QS_GW62, aes(x = Mice_x_error)): object 'merged_QS_GW62' not found
```




```
## Error in ggplot(merged_QS_GW62, aes(x = Time_normalized, y = Angular_displacement)): object 'merged_QS_GW62' not found
```

```
## Error in ggplot(merged_QS_GW62, aes(x = Time_normalized, y = Forward_displacement)): object 'merged_QS_GW62' not found
```

```
## Error in ggplot(merged_QS_GW62, aes(x = Time_normalized, y = Cumulative_angular_displacement)): object 'merged_QS_GW62' not found
```

```
## Error in ggplot(merged_QS_GW62, aes(x = Time_normalized, y = Cumulative_forward_displacement)): object 'merged_QS_GW62' not found
```










