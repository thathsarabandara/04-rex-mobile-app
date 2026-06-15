import 'package:flutter/material.dart';

class ObjectDetectionScreen extends StatelessWidget {
  const ObjectDetectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Live Stream & Detection', 
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.textTheme.titleMedium?.color),
          ),
          const SizedBox(height: 16),
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
              image: const DecorationImage(
                image: AssetImage('REX-47.png'),
                fit: BoxFit.cover,
                opacity: 0.5,
              ),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Stack(
              children: [
                _buildBoundingBox(50, 50, 100, 150, 'Person', '98%', Colors.green),
                _buildBoundingBox(180, 120, 60, 80, 'Chair', '85%', Colors.blue),
                _buildBoundingBox(260, 160, 30, 40, 'Bottle', '72%', Colors.orange),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Detected Objects Log', 
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.textTheme.titleMedium?.color),
          ),
          const SizedBox(height: 12),
          _buildLogItem(context, 'Person', '98%', Colors.green),
          _buildLogItem(context, 'Chair', '85%', Colors.blue),
          _buildLogItem(context, 'Bottle', '72%', Colors.orange),
          _buildLogItem(context, 'Dog', '91%', Colors.purple),
          _buildLogItem(context, 'Cat', '88%', Colors.pink),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildBoundingBox(double left, double top, double width, double height, String label, String conf, Color color) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 2),
          color: color.withValues(alpha: 0.2),
        ),
        child: Align(
          alignment: Alignment.topLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            color: color,
            child: Text('$label $conf', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  Widget _buildLogItem(BuildContext context, String label, String confidence, Color color) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.crop_free, color: color, size: 20),
              const SizedBox(width: 12),
              Text(
                label, 
                style: TextStyle(fontWeight: FontWeight.bold, color: theme.textTheme.titleMedium?.color),
              ),
            ],
          ),
          Text(confidence, style: TextStyle(color: color, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}
