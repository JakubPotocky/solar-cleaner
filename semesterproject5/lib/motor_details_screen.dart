import 'package:flutter/material.dart';

class MotorDetailsScreen extends StatelessWidget {
  final String motorName;

  const MotorDetailsScreen({super.key, required this.motorName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(motorName),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // STATUS
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Status',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Chip(
                      label: Text(
                        'Operational',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.green,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            _specCard('Speed', '1200 RPM', Icons.speed),
            _specCard('Temperature', '40 °C', Icons.thermostat),
            _specCard('Current', '5.8 A', Icons.electric_bolt),

            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Technical Specifications',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 12),
                    _SpecRow(label: 'Voltage', value: '24 V'),
                    _SpecRow(label: 'Power', value: '120 W'),
                    _SpecRow(label: 'Torque', value: '1.6 Nm'),
                    _SpecRow(label: 'Manufacturer', value: 'Bosch'),
                    _SpecRow(label: 'Duty Cycle', value: 'Continuous'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _specCard(String label, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 32),
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
}

class _SpecRow extends StatelessWidget {
  final String label;
  final String value;

  const _SpecRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
