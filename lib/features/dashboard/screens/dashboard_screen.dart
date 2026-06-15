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
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return BouncingCard(
      onTap: onTap ?? () {},
      child: Container(
        height: 125,
        decoration: BoxDecoration(
          color: isLight 
              ? Color.alphaBlend(color.withValues(alpha: 0.18), Colors.white) 
              : color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isLight 
                ? Color.alphaBlend(color.withValues(alpha: 0.35), Colors.white) 
                : color.withValues(alpha: 0.3),
            width: 1.2,
          ),
          boxShadow: isLight
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.1),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -10,
              bottom: -10,
              child: Icon(
                icon, 
                size: 80, 
                color: color.withValues(alpha: isLight ? 0.08 : 0.08),
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
                          color: isLight 
                              ? Color.alphaBlend(color.withValues(alpha: 0.25), Colors.white) 
                              : color.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(icon, size: 18, color: color),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isLight 
                              ? Color.alphaBlend(color.withValues(alpha: 0.22), Colors.white) 
                              : color.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 10, 
                            fontWeight: FontWeight.bold, 
                            color: color,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    value, 
                    style: TextStyle(
                      fontSize: 24, 
                      fontWeight: FontWeight.w800, 
                      color: theme.textTheme.titleLarge?.color, 
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    title, 
                    style: TextStyle(
                      fontSize: 12, 
                      fontWeight: FontWeight.w600, 
                      color: theme.textTheme.bodySmall?.color,
                    ), 
                    overflow: TextOverflow.ellipsis,
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
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isLight = theme.brightness == Brightness.light;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: 0, left: 0, right: 0, height: 380,
            child: CustomPaint(painter: HeaderWavePainter(isDark: isDark)),
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
                                    style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.2),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(Icons.waving_hand_rounded, color: Colors.amber, size: 16),
                              ],
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Smart Home Robot',
                              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -0.5, height: 1.2),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.circle, color: Color(0xFF10B981), size: 10),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Robot Online • Last sync 5 sec ago', 
                                    style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13), 
                                    overflow: TextOverflow.ellipsis,
                                  ),
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
                            onTap: () => context.go('/notifications'),
                          ),
                          const SizedBox(width: 8),
                          _buildHeaderIcon(
                            Icons.settings_rounded,
                            onTap: () => context.go('/profile'),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => context.go('/profile'),
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.white.withValues(alpha: 0.25),
                              child: const Icon(Icons.person, color: Colors.white, size: 20),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),                
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                      boxShadow: [
                        BoxShadow(
                          color: isLight 
                              ? Colors.black.withValues(alpha: 0.05) 
                              : Colors.black.withValues(alpha: 0.3), 
                          blurRadius: 24, 
                          offset: const Offset(0, -8),
                        )
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(top: 32, bottom: 90),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: SlideFade(
                                animation: _animController,
                                delay: 0.1,
                                child: _buildEssentialStatusCards(context),
                              ),
                            ),
                            const SizedBox(height: 32),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: SlideFade(
                                animation: _animController,
                                delay: 0.2,
                                child: _buildComputeCards(context),
                              ),
                            ),
                            const SizedBox(height: 32),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: SlideFade(
                                animation: _animController,
                                delay: 0.3,
                                child: _buildSensorCards(context),
                              ),
                            ),
                            const SizedBox(height: 32),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: SlideFade(
                                animation: _animController,
                                delay: 0.4,
                                child: _buildConnectivityCards(context),
                              ),
                            ),
                            const SizedBox(height: 32),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: SlideFade(
                                animation: _animController,
                                delay: 0.5,
                                child: _buildLatestEvents(context),
                              ),
                            ),
                            const SizedBox(height: 32),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: SlideFade(
                                animation: _animController,
                                delay: 0.6,
                                child: _buildQuickActions(context),
                              ),
                            ),
                            const SizedBox(height: 32),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: SlideFade(
                                animation: _animController,
                                delay: 0.7,
                                child: _buildAiInsights(context),
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

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Text(
      title, 
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        letterSpacing: -0.2,
      ),
    );
  }

  Widget _buildEssentialStatusCards(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, 'Essential Status'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: EssentialStatusCard(
                title: 'Battery', 
                icon: Icons.battery_charging_full_rounded, 
                value: '82%', 
                subtitle: 'Discharging', 
                color: Colors.green,
                onTap: () => context.go('/analytics'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: EssentialStatusCard(
                title: 'Temp', 
                icon: Icons.thermostat_rounded, 
                value: '37°C', 
                subtitle: 'Core', 
                color: Colors.orange,
                onTap: () => context.go('/analytics'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: EssentialStatusCard(
                title: 'Speed', 
                icon: Icons.speed_rounded, 
                value: '1.2m/s', 
                subtitle: 'Moving', 
                color: Colors.blue,
                onTap: () => context.go('/control'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: EssentialStatusCard(
                title: 'Mode', 
                icon: Icons.explore_rounded, 
                value: 'Patrol', 
                subtitle: 'Active', 
                color: Colors.purple,
                onTap: () => context.go('/control'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildComputeCards(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, 'Compute'),
        const SizedBox(height: 12),
        const Row(
          children: [
            Expanded(child: EssentialStatusCard(title: 'CPU Usage', icon: Icons.memory_rounded, value: '45%', subtitle: 'Normal', color: Colors.blue)),
            const SizedBox(width: 16),
            Expanded(child: EssentialStatusCard(title: 'Memory', icon: Icons.storage_rounded, value: '60%', subtitle: '1.2 / 2.0 GB', color: Colors.purple)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Expanded(child: EssentialStatusCard(title: 'Camera FPS', icon: Icons.videocam_rounded, value: '24 fps', subtitle: 'Stable', color: Colors.green)),
            const SizedBox(width: 16),
            Expanded(child: Container()), 
          ],
        ),
      ],
    );
  }

  Widget _buildSensorCards(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, 'Sensors'),
        const SizedBox(height: 12),
        const Row(
          children: [
            Expanded(child: EssentialStatusCard(title: 'LIDAR', icon: Icons.radar_rounded, value: 'Healthy', subtitle: 'Scanning', color: Colors.teal)),
            const SizedBox(width: 16),
            Expanded(child: EssentialStatusCard(title: 'Ultrasonic', icon: Icons.waves_rounded, value: 'Healthy', subtitle: 'Array Active', color: Colors.cyan)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Expanded(child: EssentialStatusCard(title: 'IMU', icon: Icons.screen_rotation_rounded, value: 'Calibrate', subtitle: 'Required', color: Colors.orange)),
            const SizedBox(width: 16),
            Expanded(child: Container()), 
          ],
        ),
      ],
    );
  }

  Widget _buildConnectivityCards(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, 'Connectivity'),
        const SizedBox(height: 12),
        const Row(
          children: [
            Expanded(child: EssentialStatusCard(title: 'WiFi', icon: Icons.wifi_rounded, value: 'Strong', subtitle: '-45 dBm', color: Colors.indigo)),
            const SizedBox(width: 16),
            Expanded(child: EssentialStatusCard(title: 'Cloud', icon: Icons.cloud_done_rounded, value: 'Synced', subtitle: '2s ago', color: Colors.blue)),
          ],
        ),
        const SizedBox(height: 16),
        const Row(
          children: [
            Expanded(child: EssentialStatusCard(title: 'MQTT', icon: Icons.compare_arrows_rounded, value: '32 ms', subtitle: 'Broker Connected', color: Colors.purple)),
            const SizedBox(width: 16),
            Expanded(child: EssentialStatusCard(title: 'BLE', icon: Icons.bluetooth_rounded, value: 'Fair', subtitle: '-72 dBm', color: Colors.orange)),
          ],
        ),
      ],
    );
  }

  Widget _buildLatestEvents(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, 'Latest Events'),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: theme.dividerColor),
          ),
          child: Column(
            children: [
              _buildEventTile(context, Icons.person_rounded, 'Person detected', 'Unknown individual in Sector 4', '2 mins ago', Colors.blue),
              const Divider(height: 1),
              _buildEventTile(context, Icons.brightness_low_rounded, 'Low light detected', 'Night vision mode activated', '15 mins ago', Colors.orange),
              const Divider(height: 1),
              _buildEventTile(context, Icons.check_circle_rounded, 'Patrol completed', 'Routine check finished safely', '1 hour ago', Colors.green),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEventTile(BuildContext context, IconData icon, String title, String subtitle, String time, Color color) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        title, 
        style: TextStyle(
          fontWeight: FontWeight.w700, 
          fontSize: 14, 
          color: theme.textTheme.titleMedium?.color,
        ),
      ),
      subtitle: Text(
        subtitle, 
        style: TextStyle(
          color: theme.textTheme.bodySmall?.color, 
          fontSize: 12,
        ),
      ),
      trailing: Text(
        time, 
        style: TextStyle(
          color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6), 
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, 'Quick Actions'),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.85,
          children: [
            _buildActionIcon(context, Icons.explore_rounded, 'Start Patrol', Colors.indigo, () => context.go('/control')),
            _buildActionIcon(context, Icons.home_rounded, 'Return Home', Colors.teal, () {}),
            _buildActionIcon(context, Icons.stop_circle_rounded, 'Stop Robot', Colors.red, () => context.go('/control')),
            _buildActionIcon(context, Icons.shield_rounded, 'Security', Colors.orange, () => context.go('/vision')),
            _buildActionIcon(context, Icons.map_rounded, 'Map Area', Colors.blue, () => context.go('/control')),
            _buildActionIcon(context, Icons.directions_walk_rounded, 'Follow Me', Colors.purple, () {}),
            _buildActionIcon(context, Icons.volume_up_rounded, 'Broadcast', Colors.green, () => context.go('/assistant')),
            _buildActionIcon(context, Icons.build_rounded, 'Diagnostics', themeBrandColor(context), () => context.go('/analytics')),
          ],
        ),
      ],
    );
  }

  Color themeBrandColor(BuildContext context) {
    return Theme.of(context).colorScheme.primary;
  }

  Widget _buildActionIcon(BuildContext context, IconData icon, String label, Color color, VoidCallback onTap) {
    final theme = Theme.of(context);
    return BouncingCard(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label, 
            style: TextStyle(
              fontSize: 10, 
              fontWeight: FontWeight.w600, 
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
            ), 
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildAiInsights(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final secondary = theme.colorScheme.secondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, 'AI Insights'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                primary.withValues(alpha: 0.08), 
                secondary.withValues(alpha: 0.08),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: primary.withValues(alpha: 0.2)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.auto_awesome_rounded, color: primary, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'No unusual activity detected.', 
                      style: TextStyle(
                        fontWeight: FontWeight.bold, 
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Battery usage increased by 12% compared to yesterday.', 
                      style: TextStyle(
                        color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7), 
                        fontSize: 13, 
                        height: 1.4,
                      ),
                    ),
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
