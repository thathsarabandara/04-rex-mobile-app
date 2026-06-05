import 'package:flutter/material.dart';
import '../../../widgets/premium_widgets.dart';

class HealthDashboard extends StatelessWidget {
  const HealthDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHealthSection('Compute', [
            _buildMetricBar('CPU Usage', 0.45, '45%', Colors.blue),
            _buildMetricBar('Memory Usage', 0.60, '60%', Colors.purple),
            _buildMetricBar('Camera FPS', 0.80, '24 fps', Colors.green),
          ]),
          const SizedBox(height: 24),
          _buildHealthSection('Communication', [
            _buildStatusRow('Network Quality', 'Excellent', Colors.green),
            _buildStatusRow('MQTT Status', 'Connected', Colors.green),
            _buildStatusRow('BLE Status', 'Active', Colors.blue),
          ]),
          const SizedBox(height: 24),
          _buildHealthSection('Sensors', [
            _buildStatusRow('LIDAR', 'Healthy', Colors.green),
            _buildStatusRow('Ultrasonic Array', 'Healthy', Colors.green),
            _buildStatusRow('IMU', 'Requires Calibration', Colors.orange),
          ]),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildHealthSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1D2939))),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFF1F5F9)),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildMetricBar(String label, double value, String textValue, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF475467))),
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

  Widget _buildStatusRow(String label, String status, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF475467))),
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
