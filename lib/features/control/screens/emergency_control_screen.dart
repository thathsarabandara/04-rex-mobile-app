import 'package:flutter/material.dart';

class EmergencyControlScreen extends StatelessWidget {
  const EmergencyControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Emergency Controls', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1D2939))),
          const SizedBox(height: 24),
          _buildEStopBtn('EMERGENCY STOP', Icons.dangerous, Colors.red.shade700, 100),
          const SizedBox(height: 24),
          _buildBigBtn('Disable Motors', Icons.block, Colors.orange.shade700),
          const SizedBox(height: 16),
          _buildBigBtn('Disable AI', Icons.psychology_alt, Colors.amber.shade700),
          const SizedBox(height: 16),
          _buildBigBtn('Shutdown Robot', Icons.power_settings_new, Colors.deepPurple.shade700),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildEStopBtn(String label, IconData icon, Color color, double height) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, color: Colors.white, size: 40),
      label: Text(label, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 1)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: Size(double.infinity, height),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 8,
        shadowColor: color.withValues(alpha: 0.5),
      ),
    );
  }

  Widget _buildBigBtn(String label, IconData icon, Color color) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, color: Colors.white, size: 28),
      label: Text(label, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(double.infinity, 70),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
