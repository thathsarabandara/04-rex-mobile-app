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
          _buildConnectionCard('WiFi Signal', Icons.wifi_rounded, 'Strong', '-45 dBm', Colors.green),
          const SizedBox(height: 16),
          _buildConnectionCard('Cloud Connection', Icons.cloud_done_rounded, 'Synced', 'Last update: 2s ago', Colors.blue),
          const SizedBox(height: 16),
          _buildConnectionCard('MQTT Latency', Icons.compare_arrows_rounded, '32 ms', 'Broker: tcp://broker.hivemq.com', Colors.purple),
          const SizedBox(height: 16),
          _buildConnectionCard('WebSocket Latency', Icons.sync_alt_rounded, '45 ms', 'Stream Active', Colors.teal),
          const SizedBox(height: 16),
          _buildConnectionCard('BLE Strength', Icons.bluetooth_rounded, 'Fair', '-72 dBm', Colors.orange),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildConnectionCard(String title, IconData icon, String status, String detail, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
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
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1D2939))),
                const SizedBox(height: 4),
                Text(detail, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
              ],
            ),
          ),
          Text(status, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: color)),
        ],
      ),
    );
  }
}
