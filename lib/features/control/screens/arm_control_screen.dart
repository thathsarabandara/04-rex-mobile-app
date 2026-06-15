import 'package:flutter/material.dart';

class ArmControlScreen extends StatefulWidget {
  const ArmControlScreen({super.key});

  @override
  State<ArmControlScreen> createState() => _ArmControlScreenState();
}

class _ArmControlScreenState extends State<ArmControlScreen> {
  double j1 = 90;
  double j2 = 45;
  double j3 = 0;
  double j4 = 90;
  double gripper = 50;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Robotic Arm Control', 
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.textTheme.titleMedium?.color),
          ),
          const SizedBox(height: 16),
          _buildSlider(context, 'Joint 1 (Base)', j1, 0, 180, Colors.indigo, (v) => setState(() => j1 = v)),
          _buildSlider(context, 'Joint 2 (Shoulder)', j2, 0, 180, Colors.teal, (v) => setState(() => j2 = v)),
          _buildSlider(context, 'Joint 3 (Elbow)', j3, -90, 90, Colors.orange, (v) => setState(() => j3 = v)),
          _buildSlider(context, 'Joint 4 (Wrist)', j4, 0, 180, Colors.amber, (v) => setState(() => j4 = v)),
          _buildSlider(context, 'Gripper', gripper, 0, 100, Colors.purple, (v) => setState(() => gripper = v)),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildSlider(BuildContext context, String label, double value, double min, double max, Color color, ValueChanged<double> onChanged) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? theme.cardColor : color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? theme.dividerColor : color.withValues(alpha: 0.12), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label, 
                style: TextStyle(fontWeight: FontWeight.bold, color: theme.textTheme.titleMedium?.color),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${value.toStringAsFixed(0)}°', 
                  style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: color,
              inactiveTrackColor: color.withValues(alpha: 0.12),
              thumbColor: color,
              overlayColor: color.withValues(alpha: 0.15),
              trackHeight: 4,
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
