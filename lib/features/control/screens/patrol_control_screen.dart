import 'package:flutter/material.dart';

class PatrolControlScreen extends StatelessWidget {
  const PatrolControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Patrol Routes', 
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.textTheme.titleMedium?.color),
          ),
          const SizedBox(height: 16),
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? Colors.black26 : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
              image: const DecorationImage(
                image: AssetImage('REX-47.png'),
                fit: BoxFit.cover,
                opacity: 0.15,
              ),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Center(
              child: Text(
                'Map Editor Placeholder', 
                style: TextStyle(color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7), fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Waypoints', 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.textTheme.titleMedium?.color),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: Icon(Icons.add, color: primary),
                label: Text('Add Point', style: TextStyle(color: primary, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildWaypointTile(context, 'Point 1', 'Living Room', '0.0s', Colors.indigo),
          _buildWaypointTile(context, 'Point 2', 'Kitchen', '5.0s', Colors.teal),
          _buildWaypointTile(context, 'Point 3', 'Hallway', '12.0s', Colors.orange),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildWaypointTile(BuildContext context, String title, String location, String delay, Color color) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? theme.cardColor : color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? theme.dividerColor : color.withValues(alpha: 0.12), width: 1.5),
      ),
      child: Row(
        children: [
          Icon(Icons.location_on, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title, 
                  style: TextStyle(fontWeight: FontWeight.bold, color: theme.textTheme.titleMedium?.color),
                ),
                Text(
                  location, 
                  style: TextStyle(color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6), fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            'Wait: $delay', 
            style: TextStyle(fontWeight: FontWeight.bold, color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.8)),
          ),
          const SizedBox(width: 8),
          Icon(Icons.drag_handle, color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.5)),
        ],
      ),
    );
  }
}
