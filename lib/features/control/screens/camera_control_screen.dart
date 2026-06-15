import 'package:flutter/material.dart';
import '../../../widgets/premium_widgets.dart';

class CameraControlScreen extends StatelessWidget {
  const CameraControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Camera Controls', 
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.textTheme.titleMedium?.color),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.4,
            children: [
              _buildBtn(context, Icons.arrow_upward_rounded, 'Tilt Up', Colors.indigo),
              _buildBtn(context, Icons.arrow_downward_rounded, 'Tilt Down', Colors.indigo),
              _buildBtn(context, Icons.arrow_back_rounded, 'Pan Left', Colors.teal),
              _buildBtn(context, Icons.arrow_forward_rounded, 'Pan Right', Colors.teal),
              _buildBtn(context, Icons.zoom_in_rounded, 'Zoom In', Colors.blue),
              _buildBtn(context, Icons.zoom_out_rounded, 'Zoom Out', Colors.blue),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Vision Settings', 
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.textTheme.titleMedium?.color),
          ),
          const SizedBox(height: 16),
          SwitchListTile.adaptive(
            title: Text(
              'IR Light', 
              style: TextStyle(fontWeight: FontWeight.bold, color: theme.textTheme.titleMedium?.color),
            ),
            subtitle: Text(
              'Enable infrared illumination',
              style: TextStyle(color: theme.textTheme.bodySmall?.color),
            ),
            value: true,
            activeColor: primary,
            onChanged: (v) {},
          ),
          SwitchListTile.adaptive(
            title: Text(
              'Night Mode', 
              style: TextStyle(fontWeight: FontWeight.bold, color: theme.textTheme.titleMedium?.color),
            ),
            subtitle: Text(
              'Enhance low-light visibility',
              style: TextStyle(color: theme.textTheme.bodySmall?.color),
            ),
            value: false,
            activeColor: primary,
            onChanged: (v) {},
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildBtn(BuildContext context, IconData icon, String label, Color color) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BouncingCard(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? theme.cardColor : color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isDark ? theme.dividerColor : color.withValues(alpha: 0.12), width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label, 
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 14, 
                color: theme.textTheme.titleMedium?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
