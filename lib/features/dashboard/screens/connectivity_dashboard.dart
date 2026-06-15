import 'package:flutter/material.dart';

class ConnectivityDashboard extends StatelessWidget {
  const ConnectivityDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildConnectionCard(context, 'WiFi Signal', Icons.wifi_rounded, 'Strong', '-45 dBm', Colors.green),
          const SizedBox(height: 16),
          _buildConnectionCard(context, 'Cloud Connection', Icons.cloud_done_rounded, 'Synced', 'Last update: 2s ago', Colors.blue),
          const SizedBox(height: 16),
          _buildConnectionCard(context, 'MQTT Latency', Icons.compare_arrows_rounded, '32 ms', 'Broker: tcp://broker.hivemq.com', Colors.purple),
          const SizedBox(height: 16),
          _buildConnectionCard(context, 'WebSocket Latency', Icons.sync_alt_rounded, '45 ms', 'Stream Active', Colors.teal),
          const SizedBox(height: 16),
          _buildConnectionCard(context, 'BLE Strength', Icons.bluetooth_rounded, 'Fair', '-72 dBm', Colors.orange),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildConnectionCard(BuildContext context, String title, IconData icon, String status, String detail, Color color) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? theme.cardColor : color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? theme.dividerColor : color.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03), 
            blurRadius: 10, 
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title, 
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: theme.textTheme.titleMedium?.color),
                ),
                const SizedBox(height: 4),
                Text(
                  detail, 
                  style: TextStyle(fontSize: 13, color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7)),
                ),
              ],
            ),
          ),
          Text(status, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: color)),
        ],
      ),
    );
  }
}
