import 'package:flutter/material.dart';

class SceneUnderstandingScreen extends StatelessWidget {
  const SceneUnderstandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('AI Scene Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1D2939))),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [const Color(0xFF8B5CF6), const Color(0xFFC084FC)]),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: const Color(0xFF8B5CF6).withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10))],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.auto_awesome, color: Colors.white, size: 32),
                SizedBox(height: 16),
                Text('Living room occupied.', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('• Two persons detected.\n• Door is closed.\n• Lighting is optimal.', style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.5)),
              ],
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
