import pigpio
import time

PWM_PIN = 13   # PWM pin
DIR_PIN = 26   # Direction pin
FREQ = 20000   # 20 kHz

# Connect to pigpio daemon
pi = pigpio.pi()
if not pi.connected:
    print("Failed to connect to pigpio daemon")
    exit(1)

# Set pin modes
pi.set_mode(PWM_PIN, pigpio.OUTPUT)
pi.set_mode(DIR_PIN, pigpio.OUTPUT)

# Set PWM frequency
pi.set_PWM_frequency(PWM_PIN, FREQ)

# Forward direction
pi.write(DIR_PIN, 1)

# 50% duty cycle (range is 0–255)
pi.set_PWM_dutycycle(PWM_PIN, 128)
time.sleep(3)

# Stop
pi.set_PWM_dutycycle(PWM_PIN, 0)

pi.stop()
