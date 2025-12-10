import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttTestPage extends StatefulWidget {
  const MqttTestPage({super.key});

  @override
  State<MqttTestPage> createState() => _MqttTestPageState();
}

class _MqttTestPageState extends State<MqttTestPage> {
  late MqttServerClient client;
  String status = "Not connected";

  static const host = "192.168.137.121";
  static const port = 1883;
  static const topic = "robot-movement";

  @override
  void initState() {
    super.initState();

    client = MqttServerClient.withPort(host, "flutter", port);
    client.logging(on: true);

    client.keepAlivePeriod = 20;
    client.secure = false;
    client.useWebSocket = false;

    client.setProtocolV311();
    client.onDisconnected = _onDisconnected;
    client.onConnected = () {
      setState(() {
        status = 'Connected (callback)';
      });
    };
    client.onSubscribed = (String topic) {
      setState(() {
        status = 'Subscribed to $topic';
      });
    };
    client.pongCallback = () {
      // keepalive ping response
      // ignore: avoid_print
      print('Ping response received');
    };
  }

  void _onDisconnected() {
    setState(() {
      status = "Disconnected";
    });
  }

  Future<void> connect() async {
    setState(() => status = "Connecting...");

    // Don't set a Will QoS/topic here unless you also set a will topic and payload.
    // HiveMQ rejects CONNECTs with a Will flag but no will topic (Invalid will-topic/flag combination).
    final msg = MqttConnectMessage()
      .withClientIdentifier('flutter-${DateTime.now().millisecondsSinceEpoch}')
      .startClean();

    client.connectionMessage = msg;

    try {
      await client.connect("jakub", "jakub");

      final state = client.connectionStatus?.state;
      final code = client.connectionStatus?.returnCode;
      setState(() => status = 'Finished connect: state=$state returnCode=$code');

      if (state == MqttConnectionState.connected) {
        client.subscribe(topic, MqttQos.atLeastOnce);
      } else {
        setState(() => status = 'Failed: returnCode=$code state=$state');
        client.disconnect();
      }
    } catch (e, st) {
      setState(() => status = "Connect exception: $e");
      // ignore: avoid_print
      print('Connect exception: $e\n$st');
      client.disconnect();
    }
  }

  void sendTestMessage() {
    if (client.connectionStatus?.state != MqttConnectionState.connected) {
      setState(() => status = "Cannot send: not connected");
      return;
    }

    final builder = MqttClientPayloadBuilder();
    builder.addString("motor1:+10");

    client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);

    setState(() => status = "Sent message: motor1:+10");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("MQTT TEST")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Status: $status"),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: connect,
              child: const Text("Connect"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: sendTestMessage,
              child: const Text("Send Test Message"),
            ),
          ],
        ),
      ),
    );
  }
}
