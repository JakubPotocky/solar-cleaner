import logging
import signal
import sys
import time
import paho.mqtt.client as mqtt

BROKER = "192.168.137.121"
PORT = 1883
TOPIC = "robot-movement"
CLIENT_ID = "mqtt-subscriber"

logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")

def on_connect(client, userdata, flags, rc):
    if rc == 0:
        logging.info(f"Connected to {BROKER}:{PORT}!")
        client.subscribe(TOPIC, qos = 1)
        logging.info(f"Subscribed to topic: {TOPIC}")
    else:
        logging.error(f"Failed to connect, return code {rc}")

def on_message(client, userdata, msg):
    try:
        payload = msg.payload.decode(errors = "replace")
    except Exception:
        payload = "<binary>"
    print(f"Recieved on {msg.topic}: {payload}")

def on_disconnect(client, userdata, rc):
    if rc != 0:
        logging.warning(f"Unexpected disconnection {rc}. Reconnecting...")
    else:
        logging.info("Clean disconnection.")

client = mqtt.Client(client_id = CLIENT_ID, clean_session = False)
client.on_connect = on_connect
client.on_message = on_message
client.on_disconnect = on_disconnect

client.reconnect_delay_set(min_delay = 1, max_delay = 120)

def shutdown(signum,frame):
    logging.info(f"Shutting down (signal {signum})...")
    try:
        client.disconnect()
    except Exception:
        pass
    time.sleep(0.2)
    sys.exit(0)

signal.signal(signal.SIGINT, shutdown)
signal.signal(signal.SIGTERM, shutdown)

try:
    client.connect(BROKER, PORT, keepalive = 60)
except Exception as e:
    logging.error(f"Could not connect to MQTT Broker:{e}")
    sys.exit(1)

client.loop_forever()