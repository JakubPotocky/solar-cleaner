import RPi.GPIO as GPIO
import time

PWM_PIN = 13
DIR_PIN = 26
#BRAKE_PIN = 24

GPIO.setmode(GPIO.BCM)
GPIO.setup(PWM_PIN, GPIO.OUT)
GPIO.setup(DIR_PIN, GPIO.OUT)
#GPIO.setup(BRAKE_PIN, GPIO.OUT)

pwm = GPIO.PWM(PWM_PIN, 20000)  # 20 kHz
pwm.start(0)

# Forward direction
GPIO.output(DIR_PIN, GPIO.HIGH)
#GPIO.output(BRAKE_PIN, GPIO.LOW)

# Drive motor at 50% speed
pwm.ChangeDutyCycle(50)
time.sleep(3)

# Stop
pwm.ChangeDutyCycle(0)
GPIO.cleanup()