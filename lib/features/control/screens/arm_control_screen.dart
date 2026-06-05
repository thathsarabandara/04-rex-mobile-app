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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Robotic Arm Control', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1D2939))),
          const SizedBox(height: 16),
          _buildSlider('Joint 1 (Base)', j1, 0, 180, (v) => setState(() => j1 = v)),
          _buildSlider('Joint 2 (Shoulder)', j2, 0, 180, (v) => setState(() => j2 = v)),
          _buildSlider('Joint 3 (Elbow)', j3, -90, 90, (v) => setState(() => j3 = v)),
          _buildSlider('Joint 4 (Wrist)', j4, 0, 180, (v) => setState(() => j4 = v)),
          _buildSlider('Gripper', gripper, 0, 100, (v) => setState(() => gripper = v)),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildSlider(String label, double value, double min, double max, ValueChanged<double> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('${value.toStringAsFixed(0)}°', style: const TextStyle(color: Color(0xFF8B5CF6), fontWeight: FontWeight.bold)),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            activeColor: const Color(0xFF8B5CF6),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
