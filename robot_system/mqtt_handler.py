import logging
import paho.mqtt.client as mqtt

class MqttClientHandler:
    def __init__(self, broker, port, topic, robot_controller):
        self.broker = broker
        self.port = port
        self.topic = topic
        self.robot_controller = robot_controller

        self.client = mqtt.Client(client_id="motor-controller", clean_session=False)

        self.client.on_connect = self._on_connect
        self.client.on_message = self._on_message
        self.client.on_disconnect = self._on_disconnect

        self.client.reconnect_delay_set(min_delay=1, max_delay=120)

    def _on_connect(self, client, userdata, flags, rc):
        if rc == 0:
            logging.info("Connected!")
            client.subscribe(self.topic, qos=1)
            logging.info(f"Subscribed to {self.topic}")
        else:
            logging.error(f"Failed to connect: {rc}")

    def _on_message(self, client, userdata, msg):
        payload = msg.payload.decode(errors="replace")
        print(f"[MQTT] Received: {payload}")
        self.robot_controller.handle_command(payload)

    def _on_disconnect(self, client, userdata, rc):
        if rc != 0:
            logging.warning("Unexpected disconnection. Reconnecting...")
        else:
            logging.info("Disconnected cleanly.")

    def start(self):
        try:
            self.client.connect(self.broker, self.port, keepalive=60)
        except Exception as e:
            logging.error(f"MQTT connection error: {e}")
            sys.exit(1)

        self.client.loop_start()

    def stop(self):
        self.client.loop_stop()
        self.client.disconnect()
