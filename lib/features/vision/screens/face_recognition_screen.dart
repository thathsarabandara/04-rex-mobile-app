import 'package:flutter/material.dart';

class FaceRecognitionScreen extends StatelessWidget {
  const FaceRecognitionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Live Face Tracking', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1D2939))),
          const SizedBox(height: 16),
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
              image: const DecorationImage(
                image: AssetImage('assets/REX-47.png'),
                fit: BoxFit.cover,
                opacity: 0.3,
              ),
            ),
            child: Stack(
              children: [
                _buildFaceBox(80, 40, 'Thathsara', Colors.green),
                _buildFaceBox(220, 60, 'Unknown', Colors.red),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Known Faces', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1D2939))),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.5,
            children: [
              _buildFaceChip('Thathsara', true),
              _buildFaceChip('Mother', true),
              _buildFaceChip('Father', true),
              _buildFaceChip('Guest', true),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Unknown / Flagged', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1D2939))),
          const SizedBox(height: 12),
          _buildFaceChip('Unknown Person', false),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildFaceBox(double left, double top, String name, Color color) {
    return Positioned(
      left: left, top: top,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.face, color: Colors.white, size: 16),
            const SizedBox(width: 4),
            Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildFaceChip(String name, bool known) {
    final color = known ? Colors.green : Colors.red;
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(known ? Icons.check_circle : Icons.warning_rounded, color: color, size: 18),
          const SizedBox(width: 8),
          Text(name, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}
