import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class TeleopScreen extends StatefulWidget {
  const TeleopScreen({super.key});

  @override
  State<TeleopScreen> createState() => _TeleopScreenState();
}

class _TeleopScreenState extends State<TeleopScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Background
          Positioned.fill(
            child: Image.asset('assets/REX-47.png', fit: BoxFit.cover, opacity: const AlwaysStoppedAnimation(0.3)),
          ),
          
          // Top Bar
          Positioned(
            top: 16, left: 16, right: 16,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => context.pop(),
                ),
                const Spacer(),
                _buildStatusChip(Icons.battery_charging_full_rounded, '82%'),
                const SizedBox(width: 8),
                _buildStatusChip(Icons.signal_cellular_alt_rounded, 'Strong'),
                const SizedBox(width: 8),
                _buildStatusChip(Icons.psychology_rounded, 'AI Active'),
                const SizedBox(width: 8),
                _buildStatusChip(Icons.fiber_manual_record, 'REC', color: Colors.red),
              ],
            ),
          ),
          
          // Left Joystick
          Positioned(
            bottom: 32, left: 32,
            child: _buildVirtualJoystick('Move'),
          ),
          
          // Right Joystick
          Positioned(
            bottom: 32, right: 32,
            child: _buildVirtualJoystick('Pan / Tilt'),
          ),
          
          // Bottom Bar
          Positioned(
            bottom: 16, left: 0, right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildBottomBtn(Icons.stop_rounded, 'Stop', Colors.red),
                const SizedBox(width: 16),
                _buildBottomBtn(Icons.explore_rounded, 'Patrol', Colors.blue),
                const SizedBox(width: 16),
                _buildBottomBtn(Icons.directions_walk_rounded, 'Follow', Colors.green),
                const SizedBox(width: 16),
                _buildBottomBtn(Icons.home_rounded, 'Home', Colors.orange),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatusChip(IconData icon, String text, {Color color = Colors.white}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildVirtualJoystick(String label) {
    return Column(
      children: [
        Container(
          width: 120, height: 120,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
          ),
          child: Center(
            child: Container(
              width: 50, height: 50,
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.5), shape: BoxShape.circle),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildBottomBtn(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.8), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
