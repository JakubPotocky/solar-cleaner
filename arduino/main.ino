#include <Servo.h>

Servo myServo;

// Motor pin definitions
const int motor1_in  = 2;
const int motor1_out = 3;

const int motor2_in  = 4;
const int motor2_out = 5;

const int motor3_in  = 9;
const int motor3_out = 10;

const int motor4_in  = 11;
const int motor4_out = 12;

// Function to run a motor forward
void motorForward(int inPin, int outPin, int speed) {
  analogWrite(inPin, speed); 
  analogWrite(outPin, 0);
}

// Function to run a motor backward
void motorBackward(int inPin, int outPin, int speed) {
  analogWrite(inPin, 0);
  analogWrite(outPin, speed);
}

// Function to stop a motor
void motorStop(int inPin, int outPin) {
  analogWrite(inPin, 0);
  analogWrite(outPin, 0);
}

void setup() {
  // Set motor pins as output
  pinMode(motor1_in, OUTPUT);
  pinMode(motor1_out, OUTPUT);

  pinMode(motor2_in, OUTPUT);
  pinMode(motor2_out, OUTPUT);

  pinMode(motor3_in, OUTPUT);
  pinMode(motor3_out, OUTPUT);

  pinMode(motor4_in, OUTPUT);
  pinMode(motor4_out, OUTPUT);

  // Attach the servo to pin 6
  myServo.attach(6);
}

void loop() {

  // Example pattern for motors & servo

  // Motor 1 forward at full speed
  motorForward(motor1_in, motor1_out, 255);
  delay(2000);
  motorStop(motor1_in, motor1_out);

  // Motor 2 backward at half speed
  motorBackward(motor2_in, motor2_out, 255);
  delay(2000);
  motorStop(motor2_in, motor2_out);

  // Motor 3 forward at full speed
  motorForward(motor3_in, motor3_out, 255);
  delay(2000);
  motorStop(motor3_in, motor3_out);

  // Motor 4 backward at full speed
  motorBackward(motor4_in, motor4_out, 255);
  delay(2000);
  motorStop(motor4_in, motor4_out);

  // Servo motion example
  myServo.write(0);
  delay(1000);
  myServo.write(90);
  delay(1000);
  myServo.write(180);
  delay(1000);
}
