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
          _buildRobotStatusCard(context),
          const SizedBox(height: 24),
          _buildLiveCameraPreview(context),
          const SizedBox(height: 24),
          _buildLatestEvents(context),
          const SizedBox(height: 24),
          _buildQuickActions(context),
          const SizedBox(height: 24),
          _buildAiInsights(context),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildRobotStatusCard(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final secondary = theme.colorScheme.secondary;

    return BouncingCard(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [primary, secondary]),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: primary.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10)),
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

  Widget _buildLiveCameraPreview(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Live Camera', 
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.textTheme.titleMedium?.color),
        ),
        const SizedBox(height: 12),
        BouncingCard(
          onTap: () {},
          child: Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(20),
              image: const DecorationImage(
                image: AssetImage('REX-47.png'),
                fit: BoxFit.cover,
                opacity: 0.5,
              ),
              border: Border.all(color: theme.dividerColor),
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

  Widget _buildLatestEvents(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Latest Events', 
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.textTheme.titleMedium?.color),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: isDark ? theme.cardColor : primary.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isDark ? theme.dividerColor : primary.withValues(alpha: 0.08)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02), 
                blurRadius: 10,
              )
            ],
          ),
          child: Column(
            children: [
              _buildEventTile(context, Icons.person_rounded, 'Person detected', '2 mins ago', Colors.blue),
              Divider(height: 1, color: theme.dividerColor),
              _buildEventTile(context, Icons.brightness_low_rounded, 'Low light detected', '15 mins ago', Colors.orange),
              Divider(height: 1, color: theme.dividerColor),
              _buildEventTile(context, Icons.check_circle_rounded, 'Patrol completed', '1 hour ago', Colors.green),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEventTile(BuildContext context, IconData icon, String title, String time, Color color) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        title, 
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: theme.textTheme.titleMedium?.color),
      ),
      trailing: Text(
        time, 
        style: TextStyle(color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6), fontSize: 12),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions', 
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.textTheme.titleMedium?.color),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.85,
          children: [
            _buildActionIcon(context, Icons.explore_rounded, 'Start Patrol', Colors.indigo),
            _buildActionIcon(context, Icons.home_rounded, 'Return Home', Colors.teal),
            _buildActionIcon(context, Icons.stop_circle_rounded, 'Stop Robot', Colors.red),
            _buildActionIcon(context, Icons.shield_rounded, 'Security', Colors.orange),
          ],
        ),
      ],
    );
  }

  Widget _buildActionIcon(BuildContext context, IconData icon, String label, Color color) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BouncingCard(
      onTap: () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? theme.cardColor : color.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? theme.dividerColor : color.withValues(alpha: 0.15)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02), 
                  blurRadius: 4,
                )
              ],
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label, 
            style: TextStyle(
              fontSize: 10, 
              fontWeight: FontWeight.w600, 
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.8),
            ), 
            textAlign: TextAlign.center,
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
        Text(
          'AI Insights', 
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.textTheme.titleMedium?.color),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [primary.withValues(alpha: 0.1), secondary.withValues(alpha: 0.1)]),
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
                      style: TextStyle(fontWeight: FontWeight.bold, color: theme.textTheme.titleMedium?.color),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Battery usage increased by 12% compared to yesterday.', 
                      style: TextStyle(color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7), fontSize: 13, height: 1.4),
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
