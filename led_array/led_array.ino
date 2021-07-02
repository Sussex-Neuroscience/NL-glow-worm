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
Serial.begin(115200);
// Initialise the Adafruit TLC driver 
tlc.begin();

pinMode(oe, OUTPUT);
digitalWrite(oe, LOW);


  
tlc.write();  

 // Setup callbacks for SerialCommand commands
  sCmd.addCommand("test",    test_leds);          // Tests leds 
  sCmd.addCommand("task1",   task1);         // do task 1
  sCmd.addCommand("HELLO", sayHello);        // Echos the string argument back
  sCmd.addCommand("P",     processCommand);  // Converts two arguments to integers and echos them back
  sCmd.setDefaultHandler(unrecognized);      // Handler for command that isn't matched  (says "What?")
  Serial.println("Ready");

}

void loop() {
  sCmd.readSerial();     // We don't do much, just process serial commands


}

void test_leds(){

    for (int i=0; i<=8; i++){
      tlc.setPWM(i,4095);  
      tlc.write();
      delay(wait);
      tlc.setPWM(i,0);  
      tlc.write();
      delay(wait);

  
    }//end for

   
  }//end test_leds

void task1(){
  int trials = 10;
  //turn all leds off
  for (int i=0; i<9; i++){
      tlc.setPWM(i,0);  
    }//end for
  tlc.write();

  delay(1000*60*5);//wait 5 min

  for (int i=0; i<trials; i++){
    tlc.setPWM(6,0);//the board starts counting leds from 0
    tlc.setPWM(2,4095);//the board starts counting leds from 0
    tlc.write();


    delay(1000*60);

    tlc.setPWM(2,0);//the board starts counting leds from 0
    tlc.setPWM(6,4095);//the board starts counting leds from 0
    tlc.write();

    delay(1000*60);
  }//end for
}//end task1


void sayHello() {
  char *arg;
  arg = sCmd.next();    // Get the next argument from the SerialCommand object buffer
  if (arg != NULL) {    // As long as it existed, take it
    Serial.print("Hello ");
    Serial.println(arg);
  }
  else {
    Serial.println("Hello, whoever you are");
  }
}

void processCommand() {
  int aNumber;
  char *arg;

  Serial.println("We're in processCommand");
  arg = sCmd.next();
  if (arg != NULL) {
    aNumber = atoi(arg);    // Converts a char string to an integer
    Serial.print("First argument was: ");
    Serial.println(aNumber);
  }
  else {
    Serial.println("No arguments");
  }

  arg = sCmd.next();
  if (arg != NULL) {
    aNumber = atol(arg);
    Serial.print("Second argument was: ");
    Serial.println(aNumber);
  }
  else {
    Serial.println("No second argument");
  }
}

// This gets set as the default handler, and gets called when no other command matches.
void unrecognized(const char *command) {
  Serial.println("What?");
}
