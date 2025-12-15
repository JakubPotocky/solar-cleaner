import 'package:flutter/material.dart';

class PumpScreen extends StatefulWidget {
  const PumpScreen({super.key});

  @override
  State<PumpScreen> createState() => _PumpScreenState();
}

class _PumpScreenState extends State<PumpScreen> {
  bool _isOperational = true;
  bool _isVerifying = false;

  double _waterLevel = 72; // %
  double _pressure = 3.4; // bar

  Future<void> _verifyPump() async {
    setState(() {
      _isVerifying = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isVerifying = false;
      _isOperational = true; // demo: always passes
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pump verification successful'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _statusTile(String label, String value, IconData icon) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // STATUS CARD
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Pump Status',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Chip(
                    label: Text(
                      _isOperational ? 'Operational' : 'Error',
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor:
                        _isOperational ? Colors.green : Colors.red,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          _statusTile(
            'Water Level',
            '${_waterLevel.toStringAsFixed(0)} %',
            Icons.water_drop,
          ),

          _statusTile(
            'Pressure',
            '${_pressure.toStringAsFixed(1)} bar',
            Icons.speed,
          ),

          const SizedBox(height: 24),

          // VERIFY BUTTON
          FilledButton.icon(
            onPressed: _isVerifying ? null : _verifyPump,
            icon: _isVerifying
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check_circle),
            label: Text(_isVerifying ? 'Verifying...' : 'Verify Pump'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}
