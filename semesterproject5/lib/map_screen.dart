import 'package:flutter/material.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Solar Panel Map'),
        content: const Text(
          'This map shows all solar panel sections.\n\n'
          '• Tap a section to see its power output\n'
          '• Compare real output with ideal values\n'
          '• Send a cleaning robot if efficiency drops\n\n'
          'Sections with lower output usually require maintenance or cleaning.',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _showPanelDialog(BuildContext context, String sectionName, int output) {
    const int idealOutput = 105;
    final double efficiency = output / idealOutput;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(sectionName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current performance',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 12),

            _statRow('Power output', '$output W'),
            _statRow('Ideal output', '$idealOutput W'),

            const SizedBox(height: 12),

            LinearProgressIndicator(
              value: efficiency.clamp(0, 1),
              minHeight: 8,
              backgroundColor: Colors.grey.shade300,
            ),
            const SizedBox(height: 8),

            Text(
              'Efficiency: ${(efficiency * 100).toStringAsFixed(1)}%',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          FilledButton.icon(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cleaning robot dispatched')),
              );
            },
            icon: const Icon(Icons.cleaning_services),
            label: const Text('Send cleaner'),
          ),
        ],
      ),
    );
  }

  Widget _statRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _panelArea({
    required BuildContext context,
    required double left,
    required double top,
    required double width,
    required double height,
    required String name,
    required int output,
  }) {
    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: () => _showPanelDialog(context, name, output),
        splashColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
        highlightColor: Theme.of(context).colorScheme.primary.withOpacity(0.08),
        child: Container(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double overallEfficiency = 0.78; // demo value

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ---- HEADER CARD ----
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Solar Field Overview',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                    icon: const Icon(Icons.info_outline),
                    onPressed: () => _showInfoDialog(context),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ---- MAP ----
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        'assets/panels.jpg',
                        fit: BoxFit.contain,
                      ),
                    ),

                    // ---- INTERACTIVE PANEL SECTIONS (UNCHANGED) ----
                    _panelArea(
                      context: context,
                      left: 200,
                      top: 20,
                      width: 260,
                      height: 70,
                      name: 'Panel Section A',
                      output: 62,
                    ),
                    _panelArea(
                      context: context,
                      left: 200,
                      top: 110,
                      width: 260,
                      height: 70,
                      name: 'Panel Section B',
                      output: 67,
                    ),
                    _panelArea(
                      context: context,
                      left: 200,
                      top: 190,
                      width: 260,
                      height: 70,
                      name: 'Panel Section C',
                      output: 85,
                    ),
                    _panelArea(
                      context: context,
                      left: 200,
                      top: 270,
                      width: 260,
                      height: 80,
                      name: 'Panel Section D',
                      output: 85,
                    ),
                    _panelArea(
                      context: context,
                      left: 20,
                      top: 210,
                      width: 170,
                      height: 80,
                      name: 'Panel Section E',
                      output: 88,
                    ),
                    _panelArea(
                      context: context,
                      left: 20,
                      top: 300,
                      width: 170,
                      height: 80,
                      name: 'Panel Section F',
                      output: 98,
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ---- EFFICIENCY GAUGE ----
          _efficiencyGauge(overallEfficiency),

          const SizedBox(height: 16),

          // ---- SUMMARY CARDS ----
          Row(
            children: [
              _summaryCard('Avg Output', '82 W', Icons.flash_on),
              const SizedBox(width: 8),
              _summaryCard('Below Ideal', '3', Icons.warning),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _summaryCard('Total Sections', '6', Icons.grid_view),
              const SizedBox(width: 8),
              _summaryCard('Last Clean', '2 days ago', Icons.cleaning_services),
            ],
          ),
          const SizedBox(height: 24),

          _startCleaningButton(context),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  /* @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: AspectRatio(
            aspectRatio: 1,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/panels.jpg',
                    fit: BoxFit.contain,
                  ),
                ),

                // ---- INTERACTIVE PANEL SECTIONS ----
                _panelArea(
                  context: context,
                  left: 200,
                  top: 20,
                  width: 260,
                  height: 70,
                  name: 'Panel Section A',
                  output: 62,
                ),
                _panelArea(
                  context: context,
                  left: 200,
                  top: 110,
                  width: 260,
                  height: 70,
                  name: 'Panel Section B',
                  output: 67,
                ),
                _panelArea(
                  context: context,
                  left: 200,
                  top: 190,
                  width: 260,
                  height: 70,
                  name: 'Panel Section C',
                  output: 85,
                ),
                _panelArea(
                  context: context,
                  left: 200,
                  top: 270,
                  width: 260,
                  height: 80,
                  name: 'Panel Section D',
                  output: 85,
                ),
                _panelArea(
                  context: context,
                  left: 20,
                  top: 210,
                  width: 170,
                  height: 80,
                  name: 'Panel Section E',
                  output: 88,
                ),
                _panelArea(
                  context: context,
                  left: 20,
                  top: 300,
                  width: 170,
                  height: 80,
                  name: 'Panel Section F',
                  output: 98,
                ),
              ],
            ),
          ),
        ),

        // ---- HEADER CARD ----
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Card(
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Solar Field Overview',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                    icon: const Icon(Icons.info_outline),
                    onPressed: () => _showInfoDialog(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }*/
}

Widget _summaryCard(String label, String value, IconData icon) {
  return Expanded(
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, size: 22),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _efficiencyGauge(double efficiency) {
  final color = efficiency >= 0.8
      ? Colors.green
      : efficiency >= 0.6
      ? Colors.orange
      : Colors.red;

  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Overall Efficiency',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: 120,
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: efficiency,
                  strokeWidth: 10,
                  color: color,
                  backgroundColor: Colors.grey.shade300,
                ),
                Text(
                  '${(efficiency * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            efficiency >= 0.8
                ? 'Optimal performance'
                : efficiency >= 0.6
                ? 'Moderate performance'
                : 'Maintenance recommended',
            style: TextStyle(color: color),
          ),
        ],
      ),
    ),
  );
}

Widget _startCleaningButton(BuildContext context) {
  return FilledButton.icon(
    onPressed: () {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Global cleaning sequence started')),
      );
    },
    icon: const Icon(Icons.cleaning_services),
    label: const Text('Start Cleaning'),
    style: FilledButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 16),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
  );
}
