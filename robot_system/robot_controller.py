class RobotController:
    """
    Maps MQTT commands to motors.
    """
    def __init__(self, motor1, motor2):
        self.motor1 = motor1
        self.motor2 = motor2

    def handle_command(self, cmd):
        """
        Commands look like:
        - motor1:+10
        - motor2:-50
        - motor1:0
        """
        if ":" not in cmd:
            print("Invalid command:", cmd)
            return

        motor_name, speed_str = cmd.split(":")
        speed = int(speed_str)

        if motor_name == "motor1":
            self.motor1.set_speed(speed)
        elif motor_name == "motor2":
            self.motor2.set_speed(speed)
        else:
            print("Unknown motor:", motor_name)
