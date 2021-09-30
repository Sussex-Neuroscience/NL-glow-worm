/*
 Mouse velocity recordings

 Shows the output of a USB Mouse connected to
 the Native USB port on an Arduino Due Board.

 The readings from the USB Mouse are read and
 printed every loop, without depending on the
 the movement of the mouse.

 There is a default delay in getting the USB Mouse
 readings using MouseController/USBHost. To cancel
 this delay, change the hidboot file according to
 following link:

 https://forum.arduino.cc/t/usbhost-usb-task-takes-5-secs-after-a-few-calls/611456


  This file is used to get the x,y velocity recordings
  for one optical mouse, connected by an Arduino Due to
  a USB port. It is meant to be used together with MouseController_2
  which does the same for a second mouse connected to another port.

Before uploading this to the Arduino Due:
1. Go to Tools, Boards Manager and install Arduino SAM Boards
2. Go to Tools, Manage Libraries and install USBHost

 */

// Require mouse control library
#include <MouseController.h>

// Initialize USB Controller
USBHost usb;

// Attach mouse controller to USB
MouseController mouse(usb);

// Initialize variables
int deltaX, deltaY;

// Cancel variables for mouse button press
boolean leftButton = false;
boolean middleButton = false;
boolean rightButton = false;


void setup() {
  Serial.begin(9600);
 
}

void loop() {
  
      usb.Task();

      deltaX = mouse.getXChange();
      deltaY = mouse.getYChange();
      
      
      Serial.print(deltaX);
      Serial.print(",");
      Serial.print(deltaY);
      Serial.print(",");
      Serial.println(micros());


}
