import pigpio
import time
import signal
import sys

# Motor A – BCM numbers
PWM_PIN_A  = 13   # physical 33
DIR_PIN_A  = 26   # physical 37
DIR_PIN2_A = 16   # physical 36

# Motor B – BCM numbers
PWM_PIN_B  = 12   # physical 32
DIR_PIN_B  = 23   # physical 16
DIR_PIN2_B = 14   # physical 8

FREQ = 20000  # 20 kHz

# Connect to pigpio daemon
pi = pigpio.pi()
if not pi.connected:
    print("Failed to connect to pigpio daemon")
    sys.exit(1)

def cleanup(signum=None, frame=None):
    print("\nStopping motors...")
    # Motor A
    pi.set_PWM_dutycycle(PWM_PIN_A, 0)
    pi.write(DIR_PIN_A, 0)
    pi.write(DIR_PIN2_A, 0)
    # Motor B
    pi.set_PWM_dutycycle(PWM_PIN_B, 0)
    pi.write(DIR_PIN_B, 0)
    pi.write(DIR_PIN2_B, 0)
    pi.stop()
    sys.exit(0)

signal.signal(signal.SIGINT, cleanup)

# Set pin modes
for pin in [PWM_PIN_A, DIR_PIN_A, DIR_PIN2_A, PWM_PIN_B, DIR_PIN_B, DIR_PIN2_B]:
    pi.set_mode(pin, pigpio.OUTPUT)

# Set PWM frequency
pi.set_PWM_frequency(PWM_PIN_A, FREQ)
pi.set_PWM_frequency(PWM_PIN_B, FREQ)

# Set direction (forward on both motors)
pi.write(DIR_PIN_A, 1)
pi.write(DIR_PIN2_A, 0)

pi.write(DIR_PIN_B, 1)
pi.write(DIR_PIN2_B, 0)

# Max speed (255 = 100%)
pi.set_PWM_dutycycle(PWM_PIN_A, 255)
pi.set_PWM_dutycycle(PWM_PIN_B, 255)

print("Motors running at full speed. Press Ctrl + C to stop.")

try:
    while True:
        time.sleep(1)
except Exception as e:
    print("Error:", e)
    cleanup()
