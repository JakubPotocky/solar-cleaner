import pigpio
import time

# BCM numbers, not physical pin numbers
PWM_PIN = 13    # physical 33
DIR_PIN = 26    # physical 37
DIR_PIN2 = 16   # physical 36

FREQ = 20000    # 20 kHz

# Connect to pigpio daemon
pi = pigpio.pi()
if not pi.connected:
    print("Failed to connect to pigpio daemon")
    exit(1)

# Set pin modes
pi.set_mode(PWM_PIN, pigpio.OUTPUT)
pi.set_mode(DIR_PIN, pigpio.OUTPUT)
pi.set_mode(DIR_PIN2, pigpio.OUTPUT)

# Set PWM frequency
pi.set_PWM_frequency(PWM_PIN, FREQ)

# Example: forward direction (DIR = 1, DIR2 = 0)
pi.write(DIR_PIN, 1)
pi.write(DIR_PIN2, 0)

# 50% duty cycle (range is 0–255)
pi.set_PWM_dutycycle(PWM_PIN, 128)
time.sleep(3)

# Stop
pi.set_PWM_dutycycle(PWM_PIN, 0)

pi.stop()
