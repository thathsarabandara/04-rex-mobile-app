import 'package:flutter/material.dart';
import '../../../widgets/premium_widgets.dart';

class EmergencyControlScreen extends StatelessWidget {
  const EmergencyControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Emergency Controls', 
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.textTheme.titleMedium?.color),
          ),
          const SizedBox(height: 24),
          _buildEStopBtn(context, 'EMERGENCY STOP', Icons.dangerous_rounded, Colors.red.shade700, 90),
          const SizedBox(height: 24),
          _buildBigBtn(context, 'Disable Motors', Icons.block_rounded, Colors.orange.shade700),
          const SizedBox(height: 16),
          _buildBigBtn(context, 'Disable AI Systems', Icons.psychology_alt_rounded, Colors.amber.shade800),
          const SizedBox(height: 16),
          _buildBigBtn(context, 'Shutdown Robot Unit', Icons.power_settings_new_rounded, Colors.deepPurple.shade600),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildEStopBtn(BuildContext context, String label, IconData icon, Color color, double height) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BouncingCard(
      onTap: () {},
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: isDark ? color.withValues(alpha: 0.15) : color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color, width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: isDark ? 0.25 : 0.12),
              blurRadius: 20,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 12),
            Text(
              label, 
              style: TextStyle(
                color: color, 
                fontSize: 20, 
                fontWeight: FontWeight.w900, 
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBigBtn(BuildContext context, String label, IconData icon, Color color) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BouncingCard(
      onTap: () {},
      child: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: isDark ? theme.cardColor : color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: isDark ? theme.dividerColor : color.withValues(alpha: 0.12), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label, 
                style: TextStyle(
                  color: theme.textTheme.titleMedium?.color, 
                  fontSize: 16, 
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 14, color: theme.dividerColor),
          ],
        ),
      ),
    );
  }
}
