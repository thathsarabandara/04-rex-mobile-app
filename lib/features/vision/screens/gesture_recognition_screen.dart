import 'package:flutter/material.dart';

class GestureRecognitionScreen extends StatelessWidget {
  const GestureRecognitionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Supported Gestures', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1D2939))),
          const SizedBox(height: 16),
          _buildGestureCard('Open Palm', 'Move Forward', Icons.pan_tool_rounded, Colors.blue),
          _buildGestureCard('Closed Fist', 'Stop', Icons.back_hand_rounded, Colors.red),
          _buildGestureCard('Thumbs Up', 'Acknowledge', Icons.thumb_up_rounded, Colors.green),
          _buildGestureCard('Swipe Left', 'Turn Left', Icons.swipe_left_rounded, Colors.purple),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildGestureCard(String gesture, String action, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(gesture, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text('Action: $action', style: const TextStyle(color: Colors.grey, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
