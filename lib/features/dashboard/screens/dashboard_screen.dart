import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../widgets/premium_widgets.dart';

class EssentialStatusCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String value;
  final String subtitle;
  final Color color;
  final VoidCallback? onTap;

  const EssentialStatusCard({
    super.key,
    required this.title,
    required this.icon,
    required this.value,
    required this.subtitle,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BouncingCard(
      onTap: onTap ?? () {},
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.7),
              color,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 15, offset: const Offset(0, 8))
          ],
        ),
        child: Stack(
          children: [
            // Abstract glass patterns
            Positioned(
              right: -20,
              bottom: -20,
              child: Icon(icon, size: 90, color: Colors.white.withValues(alpha: 0.15)),
            ),
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 100, height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
                        ),
                        child: Icon(icon, size: 20, color: Colors.white),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          subtitle,
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    value, 
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5)
                  ),
                  const SizedBox(height: 2),
                  Text(
                    title, 
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.8)), 
                    overflow: TextOverflow.ellipsis
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          Positioned(
            top: 0, left: 0, right: 0, height: 420,
            child: CustomPaint(painter: HeaderWavePainter()),
          ),
          
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    'Good Evening, Thathsara',
                                    style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.5),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.waving_hand_rounded, color: Colors.amber, size: 16),
                              ],
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Smart Home Robot ',
                              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -0.5, height: 1.2),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.circle, color: Color(0xFF10B981), size: 10),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text('Robot Online • Last sync 5 sec ago', style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 13), overflow: TextOverflow.ellipsis),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildHeaderIcon(
                            Icons.notifications_none_rounded, 
                            hasBadge: true, 
                            onTap: () {},
                          ),
                          const SizedBox(width: 8),
                          _buildHeaderIcon(Icons.settings_rounded),
                          const SizedBox(width: 8),
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.white.withValues(alpha: 0.2),
                            child: const Icon(Icons.person, color: Colors.white, size: 20),
                          ),
                        ],
                      )
                    ],
                  ),
                ),                
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 30, offset: Offset(0, -10))],
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(top: 32, bottom: 60),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: SlideFade(
                                animation: _animController,
                                delay: 0.1,
                                child: _buildEssentialStatusCards(),
                              ),
                            ),
                            const SizedBox(height: 32),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: SlideFade(
                                animation: _animController,
                                delay: 0.2,
                                child: _buildComputeCards(),
                              ),
                            ),
                            const SizedBox(height: 32),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: SlideFade(
                                animation: _animController,
                                delay: 0.3,
                                child: _buildSensorCards(),
                              ),
                            ),
                            const SizedBox(height: 32),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: SlideFade(
                                animation: _animController,
                                delay: 0.4,
                                child: _buildConnectivityCards(),
                              ),
                            ),
                            const SizedBox(height: 32),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: SlideFade(
                                animation: _animController,
                                delay: 0.5,
                                child: _buildLatestEvents(),
                              ),
                            ),
                            const SizedBox(height: 32),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: SlideFade(
                                animation: _animController,
                                delay: 0.6,
                                child: _buildQuickActions(),
                              ),
                            ),
                            const SizedBox(height: 32),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: SlideFade(
                                animation: _animController,
                                delay: 0.7,
                                child: _buildAiInsights(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderIcon(IconData icon, {bool hasBadge = false, VoidCallback? onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          IconButton(icon: Icon(icon, color: Colors.white), onPressed: onTap ?? () {}),
          if (hasBadge)
            Positioned(
              top: 10, right: 10,
              child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle)),
            ),
        ],
      ),
    );
  }

  Widget _buildEssentialStatusCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Essential Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1D2939))),
        const SizedBox(height: 12),
        Row(
          children: [
            const Expanded(child: EssentialStatusCard(title: 'Battery', icon: Icons.battery_charging_full_rounded, value: '82%', subtitle: 'Discharging', color: Colors.green)),
            const SizedBox(width: 16),
            const Expanded(child: EssentialStatusCard(title: 'Temp', icon: Icons.thermostat_rounded, value: '37°C', subtitle: 'Core', color: Colors.orange)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Expanded(child: EssentialStatusCard(title: 'Speed', icon: Icons.speed_rounded, value: '1.2m/s', subtitle: 'Moving', color: Colors.blue)),
            const SizedBox(width: 16),
            const Expanded(child: EssentialStatusCard(title: 'Mode', icon: Icons.explore_rounded, value: 'Patrol', subtitle: 'Active', color: Colors.purple)),
          ],
        ),
      ],
    );
  }

  Widget _buildComputeCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Compute', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1D2939))),
        const SizedBox(height: 12),
        Row(
          children: [
            const Expanded(child: EssentialStatusCard(title: 'CPU Usage', icon: Icons.memory_rounded, value: '45%', subtitle: 'Normal', color: Colors.blue)),
            const SizedBox(width: 16),
            const Expanded(child: EssentialStatusCard(title: 'Memory', icon: Icons.storage_rounded, value: '60%', subtitle: '1.2 / 2.0 GB', color: Colors.purple)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Expanded(child: EssentialStatusCard(title: 'Camera FPS', icon: Icons.videocam_rounded, value: '24 fps', subtitle: 'Stable', color: Colors.green)),
            const SizedBox(width: 16),
            Expanded(child: Container()), // Empty space for alignment
          ],
        ),
      ],
    );
  }

  Widget _buildSensorCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Sensors', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1D2939))),
        const SizedBox(height: 12),
        Row(
          children: [
            const Expanded(child: EssentialStatusCard(title: 'LIDAR', icon: Icons.radar_rounded, value: 'Healthy', subtitle: 'Scanning', color: Colors.teal)),
            const SizedBox(width: 16),
            const Expanded(child: EssentialStatusCard(title: 'Ultrasonic', icon: Icons.waves_rounded, value: 'Healthy', subtitle: 'Array Active', color: Colors.cyan)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Expanded(child: EssentialStatusCard(title: 'IMU', icon: Icons.screen_rotation_rounded, value: 'Calibrate', subtitle: 'Required', color: Colors.orange)),
            const SizedBox(width: 16),
            Expanded(child: Container()), // Empty space for alignment
          ],
        ),
      ],
    );
  }

  Widget _buildConnectivityCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Connectivity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1D2939))),
        const SizedBox(height: 12),
        Row(
          children: [
            const Expanded(child: EssentialStatusCard(title: 'WiFi', icon: Icons.wifi_rounded, value: 'Strong', subtitle: '-45 dBm', color: Colors.indigo)),
            const SizedBox(width: 16),
            const Expanded(child: EssentialStatusCard(title: 'Cloud', icon: Icons.cloud_done_rounded, value: 'Synced', subtitle: '2s ago', color: Colors.blue)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Expanded(child: EssentialStatusCard(title: 'MQTT', icon: Icons.compare_arrows_rounded, value: '32 ms', subtitle: 'Broker Connected', color: Colors.purple)),
            const SizedBox(width: 16),
            const Expanded(child: EssentialStatusCard(title: 'BLE', icon: Icons.bluetooth_rounded, value: 'Fair', subtitle: '-72 dBm', color: Colors.orange)),
          ],
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
              _buildEventTile(Icons.person_rounded, 'Person detected', 'Unknown individual in Sector 4', '2 mins ago', Colors.blue),
              const Divider(height: 1, color: Color(0xFFF1F5F9)),
              _buildEventTile(Icons.brightness_low_rounded, 'Low light detected', 'Night vision mode activated', '15 mins ago', Colors.orange),
              const Divider(height: 1, color: Color(0xFFF1F5F9)),
              _buildEventTile(Icons.check_circle_rounded, 'Patrol completed', 'Routine check finished safely', '1 hour ago', Colors.green),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEventTile(IconData icon, String title, String subtitle, String time, Color color) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF1D2939))),
      subtitle: Text(subtitle, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
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
            _buildActionIcon(Icons.map_rounded, 'Map Area', Colors.blue),
            _buildActionIcon(Icons.directions_walk_rounded, 'Follow Me', Colors.purple),
            _buildActionIcon(Icons.volume_up_rounded, 'Broadcast', Colors.green),
            _buildActionIcon(Icons.build_rounded, 'Diagnostics', Colors.grey.shade700),
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
