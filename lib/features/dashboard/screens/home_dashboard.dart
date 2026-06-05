import 'package:flutter/material.dart';
import '../../../widgets/premium_widgets.dart';

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRobotStatusCard(),
          const SizedBox(height: 24),
          _buildLiveCameraPreview(),
          const SizedBox(height: 24),
          _buildLatestEvents(),
          const SizedBox(height: 24),
          _buildQuickActions(),
          const SizedBox(height: 24),
          _buildAiInsights(),
          const SizedBox(height: 100), // spacing for bottom nav
        ],
      ),
    );
  }

  Widget _buildRobotStatusCard() {
    return BouncingCard(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF8B5CF6),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: const Color(0xFF8B5CF6).withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10)),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.circle, color: Colors.greenAccent, size: 12),
                const SizedBox(width: 8),
                const Text('Robot Online', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                  child: const Text('Mode: Patrol', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12)),
                )
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatusItem(Icons.battery_charging_full_rounded, 'Battery', '82%'),
                _buildStatusItem(Icons.thermostat_rounded, 'Temp', '37°C'),
                _buildStatusItem(Icons.speed_rounded, 'Speed', '1.2m/s'),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12)),
      ],
    );
  }

  Widget _buildLiveCameraPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Live Camera', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1D2939))),
        const SizedBox(height: 12),
        BouncingCard(
          onTap: () {}, // Open full camera
          child: Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(20),
              image: const DecorationImage(
                image: AssetImage('assets/REX-47.png'), // placeholder
                fit: BoxFit.cover,
                opacity: 0.5,
              ),
            ),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 40),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLatestEvents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Latest Events', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1D2939))),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFF1F5F9)),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)],
          ),
          child: Column(
            children: [
              _buildEventTile(Icons.person_rounded, 'Person detected', '2 mins ago', Colors.blue),
              const Divider(height: 1, color: Color(0xFFF1F5F9)),
              _buildEventTile(Icons.brightness_low_rounded, 'Low light detected', '15 mins ago', Colors.orange),
              const Divider(height: 1, color: Color(0xFFF1F5F9)),
              _buildEventTile(Icons.check_circle_rounded, 'Patrol completed', '1 hour ago', Colors.green),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEventTile(IconData icon, String title, String time, Color color) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      trailing: Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1D2939))),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.85,
          children: [
            _buildActionIcon(Icons.explore_rounded, 'Start Patrol', Colors.indigo),
            _buildActionIcon(Icons.home_rounded, 'Return Home', Colors.teal),
            _buildActionIcon(Icons.stop_circle_rounded, 'Stop Robot', Colors.red),
            _buildActionIcon(Icons.shield_rounded, 'Security', Colors.orange),
          ],
        ),
      ],
    );
  }

  Widget _buildActionIcon(IconData icon, String label, Color color) {
    return BouncingCard(
      onTap: () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF1F5F9)),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4)],
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF475467)), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildAiInsights() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('AI Insights', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1D2939))),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [const Color(0xFF8B5CF6).withValues(alpha: 0.1), const Color(0xFFC084FC).withValues(alpha: 0.1)]),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF8B5CF6).withValues(alpha: 0.2)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.auto_awesome_rounded, color: Color(0xFF8B5CF6), size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('No unusual activity detected.', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1D2939))),
                    const SizedBox(height: 4),
                    Text('Battery usage increased by 12% compared to yesterday.', style: TextStyle(color: Colors.grey.shade700, fontSize: 13, height: 1.4)),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
