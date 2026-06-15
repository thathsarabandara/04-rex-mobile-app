import 'package:flutter/material.dart';

class GestureRecognitionScreen extends StatelessWidget {
  const GestureRecognitionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Supported Gestures', 
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.textTheme.titleMedium?.color),
          ),
          const SizedBox(height: 16),
          _buildGestureCard(context, 'Open Palm', 'Move Forward', Icons.pan_tool_rounded, Colors.blue),
          _buildGestureCard(context, 'Closed Fist', 'Stop', Icons.back_hand_rounded, Colors.red),
          _buildGestureCard(context, 'Thumbs Up', 'Acknowledge', Icons.thumb_up_rounded, Colors.green),
          _buildGestureCard(context, 'Swipe Left', 'Turn Left', Icons.swipe_left_rounded, Colors.purple),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildGestureCard(BuildContext context, String gesture, String action, IconData icon, Color color) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
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
                Text(
                  gesture, 
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: theme.textTheme.titleMedium?.color),
                ),
                Text(
                  'Action: $action', 
                  style: TextStyle(color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6), fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
