import 'package:flutter/material.dart';
// import 'package:mqtt_client/mqtt_client.dart';
// import 'package:mqtt_client/mqtt_server_client.dart';

class Controls extends StatefulWidget {
  const Controls({Key? key, this.title = 'Flutter control app'})
    : super(key: key);

  final String title;

  @override
  State<Controls> createState() => _ControlsState();
}

class _ControlsState extends State<Controls> {
  // ---------------- DEMO FLAG ----------------
  static const bool demoMode = true;
  // -------------------------------------------

  String _carState = 'Stopped';
  int _armPosition = 0;
  String _lastAction = 'None';

  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
  }

  // ---------------- FAKE CONNECT ----------------
  Future<void> _connectMQTT() async {
    setState(() {
      _lastAction = demoMode
          ? 'Demo mode: Connected to MQTT'
          : 'Connecting to MQTT...';
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isConnected = true;
      _lastAction = demoMode
          ? 'Demo mode: MQTT connected'
          : 'Connected to MQTT';
    });
  }

  // ---------------- FAKE PUBLISH ----------------
  void _publish(String message) {
    if (!_isConnected) return;

    if (demoMode) {
      // ignore: avoid_print
      print('[DEMO MQTT] $message');
      return;
    }
  }

  // ---------------- BUTTON LOGIC ----------------
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

    _publish("motor3:${delta > 0 ? '+10' : '-10'}");
  }

  // ---------------- UI HELPERS ----------------
  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _statusChip() {
    return Chip(
      avatar: Icon(
        _isConnected ? Icons.cloud_done : Icons.cloud_off,
        size: 18,
        color: _isConnected ? Colors.green : Colors.red,
      ),
      label: Text(
        _isConnected
            ? (demoMode ? 'Connected (Demo)' : 'Connected')
            : 'Disconnected',
      ),
    );
  }

  Widget _controlButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 72,
      height: 72,
      child: FilledButton(
        onPressed: _isConnected ? onPressed : null,
        style: FilledButton.styleFrom(shape: const CircleBorder()),
        child: Icon(icon, size: 30),
      ),
    );
  }

  // ---------------- BUILD ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // CONNECTION
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _statusChip(),
                    FilledButton.icon(
                      onPressed: _isConnected ? null : _connectMQTT,
                      icon: const Icon(Icons.power),
                      label: const Text('Connect'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ARM CONTROL
            _sectionTitle('Arm Control'),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _controlButton(
                          icon: Icons.keyboard_arrow_up,
                          onPressed: () => _moveArm(1),
                        ),
                        const SizedBox(width: 24),
                        _controlButton(
                          icon: Icons.keyboard_arrow_down,
                          onPressed: () => _moveArm(-1),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text('Position: $_armPosition'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // MOVEMENT
            _sectionTitle('Movement'),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _controlButton(
                      icon: Icons.arrow_upward,
                      onPressed: () => _moveCar('Forward'),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _controlButton(
                          icon: Icons.arrow_back,
                          onPressed: () => _moveCar('Left'),
                        ),
                        const SizedBox(width: 16),
                        FilledButton(
                          onPressed: _isConnected
                              ? () => _moveCar('Stopped')
                              : null,
                          style: FilledButton.styleFrom(
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                          ),
                          child: const Text('STOP'),
                        ),

                        const SizedBox(width: 16),
                        _controlButton(
                          icon: Icons.arrow_forward,
                          onPressed: () => _moveCar('Right'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _controlButton(
                      icon: Icons.arrow_downward,
                      onPressed: () => _moveCar('Back'),
                    ),
                    const SizedBox(height: 12),
                    Text('State: $_carState'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // LAST ACTION
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Last action: $_lastAction'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
