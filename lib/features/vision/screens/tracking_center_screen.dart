import 'package:flutter/material.dart';

class TrackingCenterScreen extends StatelessWidget {
  const TrackingCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Active Tracking', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1D2939))),
          const SizedBox(height: 16),
          _buildTrackItem('Person 1', 'Tracking', '95%', Colors.green),
          _buildTrackItem('Pet (Dog)', 'Lost', '12%', Colors.red),
          _buildTrackItem('Object (Box)', 'Tracking', '88%', Colors.blue),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildTrackItem(String target, String status, String confidence, Color color) {
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
            child: Icon(Icons.my_location, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(target, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text('Status: $status', style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('Confidence', style: TextStyle(color: Colors.grey, fontSize: 10)),
              Text(confidence, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          )
        ],
      ),
    );
  }
}
