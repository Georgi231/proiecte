#include <Wire.h>
#include <BH1750.h>

BH1750 lightMeter;
int lightSensorTreshold = 1000;

int ledPinR = 10;
int ledPinG = 9;
int ledPinB = 11;

int potPinR = A0;
int potPinG = A1;
int potPinB = A2;

int buttonPin = 7;

int redValue = 0;
int greenValue = 0;
int blueValue = 0;
int lightValue = 0;

bool onOff = LOW;
int buttonState;
int lastButtonState = LOW;  // the previous reading from the input pin

// the following variables are unsigned longs because the time, measured in
// milliseconds, will quickly become a bigger number than can be stored in an int.
unsigned long lastDebounceTime = 0;  // the last time the output pin was toggled
unsigned long debounceDelay = 20;    // the debounce time; increase if the output flickers

void setup() {
  Serial.begin(9600);
  pinMode(ledPinR, OUTPUT);
  pinMode(ledPinG, OUTPUT);
  pinMode(ledPinB, OUTPUT);
  pinMode(buttonPin, INPUT);

  Wire.begin();
  lightMeter.begin();
}

void loop() {
  buttonDebounce();
  Serial.println(onOff);
  if (onOff == HIGH) {
//    Serial.println("System is ready");
    redValue = analogRead(potPinR) / 4;
    greenValue = analogRead(potPinG) / 4;
    blueValue = analogRead(potPinB) / 4;
    lightValue = lightMeter.readLightLevel();

    if (lightValue > lightSensorTreshold) {
      if (redValue < greenValue && redValue < blueValue) {
        analogWrite(ledPinR, 0);
      }
      else if (greenValue < redValue && greenValue < blueValue) {
        analogWrite(ledPinG, 0);
      }
      else {
        analogWrite(ledPinB, 0);
      }
    } else {
      analogWrite(ledPinR, redValue);
      analogWrite(ledPinG, greenValue);
      analogWrite(ledPinB, blueValue);
    }

    //displayRGBValues();
  } else {
    analogWrite(ledPinR, 255);
    analogWrite(ledPinG, 255);
    analogWrite(ledPinB, 255);
  }
}

void buttonDebounce() {
  int reading = digitalRead(buttonPin);
  // If the switch changed, due to noise or pressing:
  if (reading != lastButtonState) {
    // reset the debouncing timer
    lastDebounceTime = millis();
  }

  if ((millis() - lastDebounceTime) > debounceDelay) {
    // whatever the reading is at, it's been there for longer than the debounce
    // delay, so take it as the actual current state:

    // if the button state has changed:
    if (reading != buttonState) {
      buttonState = reading;

      // only toggle the LED if the new button state is HIGH
      if (buttonState == HIGH) {
        onOff = !onOff;
      }
    }
  }
  lastButtonState = reading;
}

void displayRGBValues() {
  Serial.print("RGB(");
  Serial.print(redValue / 4);
  Serial.print(",");
  Serial.print(greenValue / 4);
  Serial.print(",");
  Serial.print(blueValue / 4);
  Serial.println(")");
}