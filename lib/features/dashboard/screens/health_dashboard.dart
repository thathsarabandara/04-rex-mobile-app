import 'package:flutter/material.dart';

class HealthDashboard extends StatelessWidget {
  const HealthDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHealthSection(context, 'Compute', [
            _buildMetricBar(context, 'CPU Usage', 0.45, '45%', Colors.blue),
            _buildMetricBar(context, 'Memory Usage', 0.60, '60%', Colors.purple),
            _buildMetricBar(context, 'Camera FPS', 0.80, '24 fps', Colors.green),
          ]),
          const SizedBox(height: 24),
          _buildHealthSection(context, 'Communication', [
            _buildStatusRow(context, 'Network Quality', 'Excellent', Colors.green),
            _buildStatusRow(context, 'MQTT Status', 'Connected', Colors.green),
            _buildStatusRow(context, 'BLE Status', 'Active', Colors.blue),
          ]),
          const SizedBox(height: 24),
          _buildHealthSection(context, 'Sensors', [
            _buildStatusRow(context, 'LIDAR', 'Healthy', Colors.green),
            _buildStatusRow(context, 'Ultrasonic Array', 'Healthy', Colors.green),
            _buildStatusRow(context, 'IMU', 'Requires Calibration', Colors.orange),
          ]),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildHealthSection(BuildContext context, String title, List<Widget> children) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title, 
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.textTheme.titleMedium?.color),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: theme.dividerColor),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildMetricBar(BuildContext context, String label, double value, String textValue, Color color) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label, 
                style: TextStyle(fontWeight: FontWeight.w600, color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.8)),
              ),
              Text(textValue, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: value,
            backgroundColor: color.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(BuildContext context, String label, String status, Color color) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label, 
            style: TextStyle(fontWeight: FontWeight.w600, color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.8)),
          ),
          Row(
            children: [
              Icon(Icons.circle, size: 10, color: color),
              const SizedBox(width: 6),
              Text(status, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
            ],
          )
        ],
      ),
    );
  }
}
