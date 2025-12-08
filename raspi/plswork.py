import pigpio
import time
import signal
import sys

# BCM numbers (NOT physical pins)
PWM_PIN = 12    # motor 1: 13 :: 12
DIR_PIN = 23    # motor 1: 26 :: 23
DIR_PIN2 = 24   # motor 1: 16 :: 24

FREQ = 20000    # 20 kHz

# Graceful exit on Ctrl+C
def cleanup(signum, frame):
    print("\nStopping motor...")
    pi.set_PWM_dutycycle(PWM_PIN, 0)
    pi.write(DIR_PIN, 0)
    pi.write(DIR_PIN2, 0)
    pi.stop()
    sys.exit(0)

signal.signal(signal.SIGINT, cleanup)

# Connect to pigpio daemon
pi = pigpio.pi()
if not pi.connected:
    print("Failed to connect to pigpio daemon")
    sys.exit(1)

# Set pin modes
pi.set_mode(PWM_PIN, pigpio.OUTPUT)
pi.set_mode(DIR_PIN, pigpio.OUTPUT)
pi.set_mode(DIR_PIN2, pigpio.OUTPUT)

# Set PWM frequency
pi.set_PWM_frequency(PWM_PIN, FREQ)

# Set direction (example: forward)
pi.write(DIR_PIN, 1)
pi.write(DIR_PIN2, 0)

# Max speed (255 = 100%)
pi.set_PWM_dutycycle(PWM_PIN, 255)

print("Motor running at full speed. Press Ctrl + C to stop.")

# Keep running forever
while True:
    time.sleep(1)
