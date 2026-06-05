import 'package:flutter/material.dart';

class PatrolControlScreen extends StatelessWidget {
  const PatrolControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Patrol Routes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1D2939))),
          const SizedBox(height: 16),
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
              image: const DecorationImage(
                image: AssetImage('assets/REX-47.png'), // placeholder for map
                fit: BoxFit.cover,
                opacity: 0.2,
              ),
              border: Border.all(color: const Color(0xFFF1F5F9)),
            ),
            child: const Center(
              child: Text('Map Editor Placeholder', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Waypoints', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1D2939))),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, color: Color(0xFF8B5CF6)),
                label: const Text('Add Point', style: TextStyle(color: Color(0xFF8B5CF6))),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildWaypointTile('Point 1', 'Living Room', '0.0s'),
          _buildWaypointTile('Point 2', 'Kitchen', '5.0s'),
          _buildWaypointTile('Point 3', 'Hallway', '12.0s'),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildWaypointTile(String title, String location, String delay) {
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
          const Icon(Icons.location_on, color: Color(0xFF8B5CF6)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(location, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Text('Wait: $delay', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF475467))),
          const SizedBox(width: 8),
          const Icon(Icons.drag_handle, color: Colors.grey),
        ],
      ),
    );
  }
}
