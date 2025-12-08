import pigpio
import time
import signal
import sys

# BCM numbers (NOT physical pins)
PWM_PIN_A = 13    # physical 33
DIR_PIN_A = 26    # physical 37
DIR_PIN2_A = 16   # physical 36

PWM_PIN_B = 12    # physical 33
DIR_PIN_B = 23    # physical 37
DIR_PIN2_B = 14   # physical 36

FREQ = 20000    # 20 kHz

# Graceful exit on Ctrl+C
def cleanup(signum, frame):
    print("\nStopping motor...")
    pi.set_PWM_dutycycle(PWM_PIN_A, 0)
    pi.write(DIR_PIN_A, 0)
    pi.write(DIR_PIN2_A, 0)
    pi.set_PWM_dutycycle(PWM_PIN_B, 0)
    pi.write(DIR_PIN_B, 0)
    pi.write(DIR_PIN2_B, 0)
    pi.stop()
    sys.exit(0)

signal.signal(signal.SIGINT, cleanup)

# Connect to pigpio daemon
pi = pigpio.pi()
if not pi.connected:
    print("Failed to connect to pigpio daemon")
    sys.exit(1)

# Set pin modes
pi.set_mode(PWM_PIN_A, pigpio.OUTPUT)
pi.set_mode(DIR_PIN_A, pigpio.OUTPUT)
pi.set_mode(DIR_PIN2_A, pigpio.OUTPUT)

pi.set_mode(PWM_PIN_B, pigpio.OUTPUT)
pi.set_mode(DIR_PIN_B, pigpio.OUTPUT)
pi.set_mode(DIR_PIN2_B, pigpio.OUTPUT)

# Set PWM frequency
pi.set_PWM_frequency(PWM_PIN_A, FREQ)
pi.set_PWM_frequency(PWM_PIN_B, FREQ)

# Set direction (example: forward)
pi.write(DIR_PIN_A, 1)
pi.write(DIR_PIN2_A, 0)

pi.write(DIR_PIN_B, 1)
pi.write(DIR_PIN2_B, 0)

# Max speed (255 = 100%)
pi.set_PWM_dutycycle(PWM_PIN_A, 255)
pi.set_PWM_dutycycle(PWM_PIN_B, 255)

print("Motor running at full speed. Press Ctrl + C to stop.")

# Keep running forever
while True:
    time.sleep(1)
