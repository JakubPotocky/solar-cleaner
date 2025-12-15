import 'package:flutter/material.dart';
import 'package:semesterproject5/controls.dart';
import 'package:semesterproject5/pump_screen.dart';
import 'package:semesterproject5/motor_details_screen.dart';
import 'package:semesterproject5/map_screen.dart';
import 'package:semesterproject5/cleaning_screen.dart';

class HomeScreen extends StatefulWidget {
  final String name;
  final bool demoMode;

  const HomeScreen({super.key, required this.name, required this.demoMode});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _select(int index) {
    setState(() => _selectedIndex = index);
    Navigator.of(context).maybePop();
  }

  Widget _buildDrawer() {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              selected: _selectedIndex == 0,
              onTap: () => _select(0),
            ),
            ListTile(
              leading: const Icon(Icons.memory),
              title: const Text('Motors'),
              selected: _selectedIndex == 1,
              onTap: () => _select(1),
            ),
            ListTile(
              leading: const Icon(Icons.water),
              title: const Text('Pump'),
              selected: _selectedIndex == 2,
              onTap: () => _select(2),
            ),
            ListTile(
              leading: const Icon(Icons.cleaning_services),
              title: const Text('Cleaning'),
              selected: _selectedIndex == 3,
              onTap: () => _select(3),
            ),

            ListTile(
              leading: const Icon(Icons.map),
              title: const Text('Map'),
              selected: _selectedIndex == 4,
              onTap: () => _select(4),
            ),
            ListTile(
              leading: const Icon(Icons.gamepad),
              title: const Text('Controls'),
              selected: _selectedIndex == 5,
              onTap: () => _select(5),
            ),

            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign out'),
              onTap: () => Navigator.of(context).popUntil((r) => r.isFirst),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      _DashboardScreen(name: widget.name, demoMode: widget.demoMode),
      const MotorsScreen(),
      const PumpScreen(),
      const CleaningScreen(),             
      const MapScreen(),
      const Controls(),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      drawer: _buildDrawer(),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: screens[_selectedIndex],
      ),
    );
  }
}

class _DashboardScreen extends StatelessWidget {
  final String name;
  final bool demoMode;

  const _DashboardScreen({required this.name, required this.demoMode});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Robot Status',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Uptime',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      const Text('48h 23m'),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Chip(
                        label: Text(
                          'Operational',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.green,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Temperature',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      const Text('42°C'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Summary',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      _SmallStat(label: 'Battery', value: '87%'),
                      _SmallStat(label: 'Last Update', value: '8:56 PM'),
                      _SmallStat(label: 'Mode', value: 'Auto'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallStat extends StatelessWidget {
  final String label;
  final String value;

  const _SmallStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value),
      ],
    );
  }
}

class MotorsScreen extends StatelessWidget {
  const MotorsScreen({super.key});

  Widget _motorCard(
    BuildContext context,
    String title,
    String speed,
    String temp,
    String current,
  ) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => MotorDetailsScreen(motorName: title),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Chip(
                    label: const Text(
                      'Operational',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.green,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _miniStat('Speed', speed),
                  _miniStat('Temp', temp),
                  _miniStat('Current', current),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final motors = [
      {
        'title': 'Motor 1 - Water Pump',
        'speed': '1200 RPM',
        'temp': '38°C',
        'current': '6.4A',
      },
      {
        'title': 'Motor 2 - Wheels',
        'speed': '2200 RPM',
        'temp': '42°C',
        'current': '4.4A',
      },
      {
        'title': 'Motor 3 - Arm Joint 1',
        'speed': '980 RPM',
        'temp': '41°C',
        'current': '4.1A',
      },
      {
        'title': 'Motor 4 - Arm Joint 2',
        'speed': '1050 RPM',
        'temp': '39°C',
        'current': '6.3A',
      },
      {
        'title': 'Motor 5 - Wheel rotation',
        'speed': '0 RPM',
        'temp': '39°C',
        'current': '2.3A',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: motors.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Motor Status',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          );
        }
        final m = motors[index - 1];
        return _motorCard(
          context,
          m['title']!,
          m['speed']!,
          m['temp']!,
          m['current']!,
        );
      },
    );
  }
}

Widget _miniStat(String label, String value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(color: Colors.grey)),
      const SizedBox(height: 4),
      Text(value),
    ],
  );
}
