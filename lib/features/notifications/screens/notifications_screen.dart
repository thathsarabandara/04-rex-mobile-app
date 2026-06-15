import 'package:flutter/material.dart';
import '../../../widgets/premium_widgets.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  int _selectedFilterIndex = 0; // 0: All, 1: Critical, 2: Info

  final List<String> _filters = ['All', 'Critical', 'Info'];
  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'Person Detected',
      'body': 'Unknown individual spotted in Sector 4 (Living Room). Night vision active.',
      'time': '2 mins ago',
      'type': 'critical',
      'icon': Icons.person_rounded,
      'color': Colors.red,
    },
    {
      'title': 'Low Battery Alert',
      'body': 'Battery levels dropped to 22%. Preparing auto-recharge routing.',
      'time': '15 mins ago',
      'type': 'critical',
      'icon': Icons.battery_alert_rounded,
      'color': Colors.orange,
    },
    {
      'title': 'Patrol Completed',
      'body': 'Routine living room patrol finished safely. 0 alerts found.',
      'time': '1 hour ago',
      'type': 'info',
      'icon': Icons.check_circle_rounded,
      'color': Colors.green,
    },
    {
      'title': 'MQTT Broker Connected',
      'body': 'REX-47 has established a handshake with local MQTT gateway.',
      'time': '3 hours ago',
      'type': 'info',
      'icon': Icons.swap_horiz_rounded,
      'color': Colors.blue,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
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
    final primary = theme.colorScheme.primary;

    final filteredNotifications = _notifications.where((n) {
      if (_selectedFilterIndex == 0) return true;
      if (_selectedFilterIndex == 1) return n['type'] == 'critical';
      return n['type'] == 'info';
    }).toList();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: 0, left: 0, right: 0, height: 350,
            child: CustomPaint(painter: HeaderWavePainter(isDark: isDark)),
          ),
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Alerts Feed',
                        style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1.0),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.delete_sweep_rounded, color: Colors.white),
                          onPressed: () {
                            setState(() {
                              _notifications.clear();
                            });
                          },
                        ),
                      ),
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
                      child: Column(
                        children: [
                          // Filters
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                            child: Row(
                              children: List.generate(_filters.length, (index) {
                                final isSelected = _selectedFilterIndex == index;
                                return Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedFilterIndex = index;
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 4),
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      decoration: BoxDecoration(
                                        color: isSelected ? primary : theme.cardColor,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(color: isSelected ? primary : theme.dividerColor),
                                        boxShadow: isSelected 
                                            ? [BoxShadow(color: primary.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 4))] 
                                            : [],
                                      ),
                                      child: Center(
                                        child: Text(
                                          _filters[index],
                                          style: TextStyle(
                                            color: isSelected ? Colors.white : theme.textTheme.bodyMedium?.color,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),

                          // Notifications List
                          Expanded(
                            child: filteredNotifications.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.notifications_off_outlined, size: 64, color: theme.disabledColor),
                                        const SizedBox(height: 16),
                                        Text(
                                          'No alerts to display', 
                                          style: TextStyle(
                                            fontSize: 16, 
                                            fontWeight: FontWeight.bold, 
                                            color: theme.textTheme.bodySmall?.color,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : ListView.builder(
                                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
                                    itemCount: filteredNotifications.length,
                                    itemBuilder: (context, index) {
                                      final item = filteredNotifications[index];
                                      final color = item['color'] as Color;
                                      return SlideFade(
                                        animation: _animController,
                                        delay: 0.15 + (index * 0.08),
                                        child: Container(
                                          margin: const EdgeInsets.only(bottom: 16),
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: theme.cardColor,
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(color: theme.dividerColor),
                                          ),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: color.withValues(alpha: 0.1),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(item['icon'] as IconData, color: color, size: 20),
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(
                                                          item['title'] as String,
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 15,
                                                            color: theme.textTheme.titleMedium?.color,
                                                          ),
                                                        ),
                                                        Text(
                                                          item['time'] as String,
                                                          style: TextStyle(
                                                            fontSize: 11,
                                                            color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 6),
                                                    Text(
                                                      item['body'] as String,
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
                                                        height: 1.4,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ],
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
}
