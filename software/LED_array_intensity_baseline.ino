
// Initialise the LED controler
// For more information on the LED controler go to https://github.com/BadenLab/LED-Zappelin

#include <SPI.h>                            // Include the arduino serial port interface library
#include "Adafruit_TLC5947.h"               // Include the Adafruit TLC5947 libvrary. For better result one may change the number of channel defined in the Adafruit_TLC5947.cpp library
#include <SerialCommand.h> //library to tokenize serial commands  

#define   nDriver         1
#define   data           18             // SPI connection, DIN connected to pin MOSI/18
#define   clock           5             // SPI connection, CLK connected to pin SCK/5
#define   latch          21             // SPI connection, LAT connected to pin 21
#define   oe             25            // Optional feature to prevent LED to light up when powering up the TLC board connected to pin A1/DAC1
//const int      pSyncOut      =   26;    // Trigger channel must be connected to pin A0/DAC2
//const int      pBlank        =   36;    // Blanking signal channel must be connected to pin A4/36


SerialCommand sCmd;     // The demo SerialCommand object


Adafruit_TLC5947 tlc = Adafruit_TLC5947(nDriver, clock, data, latch);

int wait=500;

void setup() {
  
  // put your setup code here, to run once:


// Initialise the serial communication with PC
Serial.begin(9600);
// Initialise the Adafruit TLC driver 
tlc.begin();

pinMode(oe, OUTPUT);
digitalWrite(oe, LOW);

 
tlc.write();  
}


// Exemple experiment with two alternating LEDs, increasing in brightness

void loop() {

  int trials = 5;
  const int led_array[] = {4,5}; //LEDs number; note: the board starts counting leds from 0
  int led = led_array[random(0,2)]; //randomize which LED is first to be turned on
  const int brightness[] = {1,10,100,1000,4000}; //brightness levels

 // Print "Ready" at start of the experiment
 // and LED and Brightness = 0
 
      Serial.println("Ready");
      Serial.print(0); 
      Serial.print(";");
      Serial.print(0);
      Serial.print(";");
      Serial.println(micros());

  //turn all leds off
  for (int i=0; i<9; i++){
      tlc.setPWM(i,0);  
    }//end for
  tlc.write();
  delay(1000*60*5);//wait 5 min
      Serial.print(0);
      Serial.print(";");
      Serial.print(0);
      Serial.print(";");
      Serial.println(micros());

  // for loop quick switch + increase intensity every trial    
  for (int i=0; i<trials; i++){
      int bright = brightness[i];

  //turn all leds off
  for (int i=0; i<9; i++){
      tlc.setPWM(i,0);  
    }//end for
  tlc.write();
  
          tlc.setPWM(led,bright);
          tlc.write();
          delay(1000*20);
          Serial.print(led);
          Serial.print(";");
          Serial.print(bright);
          Serial.print(";");
          Serial.println(micros());


  
                if (led == 5) {
                          tlc.setPWM(4,bright);
                          tlc.write();
                           tlc.setPWM(led,0);
                           tlc.write();
                           delay(1000*20);
                            Serial.print(4);
                            Serial.print(";");
                            Serial.print(bright);
                            Serial.print(";");
                            Serial.println(micros());
                      }
                
                    
                      else if (led == 4){

                            tlc.setPWM(5,bright);
                            tlc.write();
                             tlc.setPWM(led,0);
                             tlc.write();
                             delay(1000*20);                            
                              Serial.print(5);
                              Serial.print(";");
                              Serial.print(bright);
                              Serial.print(";");
                              Serial.println(micros());
                      }

}//end for
 
// Turn both LEDs off

  tlc.setPWM(5,0);
  tlc.write();
  tlc.setPWM(4,0);
  tlc.write();
      Serial.print(0);
      Serial.print(";");
      Serial.print(0);
      Serial.print(";");
      Serial.println(micros());
  delay(1000*60);
      Serial.println("Over");
      delay(1000*60*5);

}
