import 'package:flutter/material.dart';

class TrackingCenterScreen extends StatelessWidget {
  const TrackingCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Active Tracking', 
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.textTheme.titleMedium?.color),
          ),
          const SizedBox(height: 16),
          _buildTrackItem(context, 'Person 1', 'Tracking', '95%', Colors.green),
          _buildTrackItem(context, 'Pet (Dog)', 'Lost', '12%', Colors.red),
          _buildTrackItem(context, 'Object (Box)', 'Tracking', '88%', Colors.blue),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildTrackItem(BuildContext context, String target, String status, String confidence, Color color) {
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
            child: Icon(Icons.my_location, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  target, 
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: theme.textTheme.titleMedium?.color),
                ),
                Text(
                  'Status: $status', 
                  style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Confidence', 
                style: TextStyle(color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6), fontSize: 10),
              ),
              Text(
                confidence, 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: theme.textTheme.titleMedium?.color),
              ),
            ],
          )
        ],
      ),
    );
  }
}
