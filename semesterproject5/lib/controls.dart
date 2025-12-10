import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class Controls extends StatefulWidget {
  const Controls({Key? key, this.title = 'Flutter control app'}) : super(key: key);

  final String title;

  @override
  State<Controls> createState() => _ControlsState();
}

class _ControlsState extends State<Controls> {
  // Simple state to demonstrate control actions
  String _carState = 'Stopped';
  int _armPosition = 0; // arbitrary units
  String _lastAction = 'None';

  // MQTT
  late MqttServerClient _client;
  bool _isConnected = false;

  static const String host = '192.168.137.121';
  static const int port = 1883;
  static const String topic = 'robot-movement';

  @override
  void initState() {
    super.initState();

  _client = MqttServerClient.withPort(host, 'flutter_client', port);

  _client.logging(on: true);
  _client.keepAlivePeriod = 20;
  _client.secure = false;       // IMPORTANT on Android
  _client.useWebSocket = false; // Force raw TCP
  _client.onDisconnected = _onDisconnected;

  _client.onConnected = () {
    setState(() {
      _isConnected = true;
      _lastAction = 'Connected to MQTT';
    });
  };

  _client.onSubscribed = (String topic) {
    setState(() {
      _lastAction = 'Subscribed to $topic';
    });
  };

  _client.pongCallback = () {
    // ignore: avoid_print
    print('MQTT ping response');
  };

  _client.setProtocolV311(); // Many brokers require v3.1.1
  }

  Future<void> _connectMQTT() async {
  setState(() => _lastAction = "Connecting to MQTT...");
  try {
    // Do not set Will QoS/topic unless you also set a Will topic and payload.
    final connMessage = MqttConnectMessage()
        .withClientIdentifier('flutter_client_${DateTime.now().millisecondsSinceEpoch}')
        .startClean(); // clean session

    _client.connectionMessage = connMessage;

    // Connect without credentials (HiveMQ CE often allows anonymous by default)
    await _client.connect();

    final state = _client.connectionStatus?.state;
    final code = _client.connectionStatus?.returnCode;

    if (state == MqttConnectionState.connected) {
      setState(() {
        _isConnected = true;
        _lastAction = 'Connected (returnCode=$code)';
      });
      _client.subscribe(topic, MqttQos.atLeastOnce);
    } else {
      setState(() {
        _lastAction = 'Connection failed: state=$state returnCode=$code';
      });
      _client.disconnect();
    }
  } catch (e, st) {
    setState(() {
      _lastAction = 'MQTT Error: $e';
    });
    // ignore: avoid_print
    print('MQTT connect exception: $e\n$st');
    _client.disconnect();
  }
}

  void _onDisconnected() {
    setState(() {
      _isConnected = false;
      _lastAction = "Disconnected from MQTT";
    });
  }

  void _publish(String message) {
    if (!_isConnected) return;

    final builder = MqttClientPayloadBuilder();
    builder.addString(message);

    _client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }

  // ---- BUTTON LOGIC ----

  void _moveCar(String action) {
    if (!_isConnected) return;

    setState(() {
      _carState = action;
      _lastAction = 'Car: $action';
    });

    switch (action) {
      case 'Forward':
        _publish("motor1:+10");
        break;
      case 'Back':
        _publish("motor1:-10");
        break;
      case 'Left':
        _publish("motor2:-10");
        break;
      case 'Right':
        _publish("motor2:+10");
        break;
      case 'Stopped':
        _publish("motor1:0");
        _publish("motor2:0");
        break;
    }
  }

  void _moveArm(int delta) {
    if (!_isConnected) return;

    setState(() {
      _armPosition += delta;
      _lastAction = 'Arm: ${delta > 0 ? 'Up' : 'Down'}';
    });

    // motor3 controls arm
    _publish("motor3:${delta > 0 ? '+10' : '-10'}");
  }

  Widget _buildCircleButton(IconData icon, VoidCallback onPressed) {
    return SizedBox(
      width: 64,
      height: 64,
      child: ElevatedButton(
        onPressed: _isConnected ? onPressed : null,
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(12),
        ),
        child: Icon(icon, size: 28),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // MQTT CONNECT BUTTON
            ElevatedButton(
              onPressed: _isConnected ? null : _connectMQTT,
              child: Text(_isConnected ? "Connected" : "Connect to MQTT"),
            ),
            const SizedBox(height: 16),

            // ARM CONTROL
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Arm Control', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildCircleButton(Icons.arrow_upward, () => _moveArm(1)),
                        const SizedBox(width: 16),
                        _buildCircleButton(Icons.arrow_downward, () => _moveArm(-1)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text('Arm position: $_armPosition'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // MOVEMENT CONTROL
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Movement Controls', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    Center(child: _buildCircleButton(Icons.arrow_upward, () => _moveCar('Forward'))),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildCircleButton(Icons.arrow_back, () => _moveCar('Left')),
                        SizedBox(
                          width: 64,
                          height: 64,
                          child: ElevatedButton(
                            onPressed: _isConnected ? () => _moveCar('Stopped') : null,
                            style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                            child: const Text('Stop'),
                          ),
                        ),
                        _buildCircleButton(Icons.arrow_forward, () => _moveCar('Right')),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Center(child: _buildCircleButton(Icons.arrow_downward, () => _moveCar('Back'))),
                    const SizedBox(height: 8),
                    Text('Car state: $_carState'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // LAST ACTION
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Last action: $_lastAction'),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _lastAction = 'None';
                        });
                      },
                      child: const Text('Clear'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
