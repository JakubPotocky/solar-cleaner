import logging
import signal
import sys
import time

from motor_controller import MotorController
from robot_controller import RobotController
from mqtt_handler import MqttClientHandler

BROKER = "192.168.137.121"
PORT = 1883
TOPIC = "robot-movement"

logging.basicConfig(level=logging.INFO)

# Create two motors
motorA = MotorController(pwm_pin=13, dir1_pin=26, dir2_pin=16)
motorB = MotorController(pwm_pin=12, dir1_pin=23, dir2_pin=24)

# Robot logic
robot = RobotController(motorA, motorB)

# MQTT handler
mqtt_handler = MqttClientHandler(BROKER, PORT, TOPIC, robot)
mqtt_handler.start()

def shutdown(signum=None, frame=None):
    print("\nShutting down...")
    mqtt_handler.stop()
    motorA.cleanup()
    motorB.cleanup()
    sys.exit(0)

signal.signal(signal.SIGINT, shutdown)
signal.signal(signal.SIGTERM, shutdown)

print("System running. Waiting for MQTT messages...")

while True:
    time.sleep(1)
