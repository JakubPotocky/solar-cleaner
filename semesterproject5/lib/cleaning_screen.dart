import 'package:flutter/material.dart';

class CleaningScreen extends StatefulWidget {
  const CleaningScreen({super.key});

  @override
  State<CleaningScreen> createState() => _CleaningScreenState();
}

class _CleaningScreenState extends State<CleaningScreen> {
  bool _enabled = true;
  String _frequency = 'Weekly';
  TimeOfDay _time = const TimeOfDay(hour: 6, minute: 0);

  final List<Map<String, String>> _history = [
    {
      'date': 'Today, 06:01',
      'status': 'Completed',
      'note': 'Dust removed, efficiency improved',
    },
    {
      'date': '3 days ago, 06:02',
      'status': 'Completed',
      'note': 'Routine cleaning',
    },
    {
      'date': '7 days ago, 06:00',
      'status': 'Skipped',
      'note': 'Efficiency above threshold',
    },
  ];

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (picked != null) {
      setState(() => _time = picked);
    }
  }

  void _saveSchedule() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cleaning schedule saved')),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ---- RECURRING CLEANING ----
            _sectionTitle('Recurring Cleaning'),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    value: _enabled,
                    onChanged: (v) => setState(() => _enabled = v),
                    title: const Text('Enable recurring cleaning'),
                    subtitle: const Text(
                      'System will clean panels automatically',
                    ),
                  ),
                  const Divider(),
                  RadioListTile(
                    title: const Text('Daily'),
                    value: 'Daily',
                    groupValue: _frequency,
                    onChanged: (v) => setState(() => _frequency = v!),
                  ),
                  RadioListTile(
                    title: const Text('Weekly'),
                    value: 'Weekly',
                    groupValue: _frequency,
                    onChanged: (v) => setState(() => _frequency = v!),
                  ),
                  RadioListTile(
                    title: const Text('Monthly'),
                    value: 'Monthly',
                    groupValue: _frequency,
                    onChanged: (v) => setState(() => _frequency = v!),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.schedule),
                    title: Text(_time.format(context)),
                    subtitle: const Text('Preferred start time'),
                    trailing: TextButton(
                      onPressed: _pickTime,
                      child: const Text('Change'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ---- SAVE ----
            FilledButton.icon(
              onPressed: _saveSchedule,
              icon: const Icon(Icons.save),
              label: const Text('Save Schedule'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),

            const SizedBox(height: 32),

            // ---- HISTORY ----
            _sectionTitle('Cleaning History'),
            ..._history.map(
              (item) => Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ListTile(
                  leading: Icon(
                    item['status'] == 'Completed'
                        ? Icons.check_circle
                        : Icons.info,
                    color: item['status'] == 'Completed'
                        ? Colors.green
                        : Colors.orange,
                  ),
                  title: Text(item['date']!),
                  subtitle: Text(item['note']!),
                  trailing: Text(item['status']!),
                ),
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
