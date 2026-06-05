import 'package:flutter/material.dart';

class CameraControlScreen extends StatelessWidget {
  const CameraControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Camera Controls', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1D2939))),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: [
              _buildBtn(Icons.arrow_upward_rounded, 'Tilt Up'),
              _buildBtn(Icons.arrow_downward_rounded, 'Tilt Down'),
              _buildBtn(Icons.arrow_back_rounded, 'Pan Left'),
              _buildBtn(Icons.arrow_forward_rounded, 'Pan Right'),
              _buildBtn(Icons.zoom_in_rounded, 'Zoom In'),
              _buildBtn(Icons.zoom_out_rounded, 'Zoom Out'),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Vision Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1D2939))),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('IR Light', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Enable infrared illumination'),
            value: true,
            activeColor: const Color(0xFF8B5CF6),
            onChanged: (v) {},
          ),
          SwitchListTile(
            title: const Text('Night Mode', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Enhance low-light visibility'),
            value: false,
            activeColor: const Color(0xFF8B5CF6),
            onChanged: (v) {},
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildBtn(IconData icon, String label) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: const TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF8B5CF6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
