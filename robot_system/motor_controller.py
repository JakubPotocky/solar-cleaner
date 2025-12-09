import pigpio
import sys
import signal

class MotorController:
    def __init__(self, pwm_pin, dir1_pin, dir2_pin, frequency=20000):
        self.pwm_pin = pwm_pin
        self.dir1_pin = dir1_pin
        self.dir2_pin = dir2_pin
        self.frequency = frequency

        self.pi = pigpio.pi()
        if not self.pi.connected:
            print("Failed to connect to pigpio daemon")
            sys.exit(1)

        self._setup_pins()

    def _setup_pins(self):
        # Configure pins
        for pin in [self.pwm_pin, self.dir1_pin, self.dir2_pin]:
            self.pi.set_mode(pin, pigpio.OUTPUT)

        # PWM frequency
        self.pi.set_PWM_frequency(self.pwm_pin, self.frequency)
        self.stop()

    def set_speed(self, speed):
        """
        speed is an integer from -255 to +255
        """
        speed = max(-255, min(255, speed))  # clamp

        if speed > 0:
            self.pi.write(self.dir1_pin, 1)
            self.pi.write(self.dir2_pin, 0)
        elif speed < 0:
            self.pi.write(self.dir1_pin, 0)
            self.pi.write(self.dir2_pin, 1)
        else:
            self.stop()
            return

        self.pi.set_PWM_dutycycle(self.pwm_pin, abs(speed))

    def stop(self):
        self.pi.set_PWM_dutycycle(self.pwm_pin, 0)
        self.pi.write(self.dir1_pin, 0)
        self.pi.write(self.dir2_pin, 0)

    def cleanup(self):
        self.stop()
        self.pi.stop()
