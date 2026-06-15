import 'package:flutter/material.dart';
import '../../../widgets/premium_widgets.dart';

class AutomationScreen extends StatefulWidget {
  const AutomationScreen({super.key});

  @override
  State<AutomationScreen> createState() => _AutomationScreenState();
}

class _AutomationScreenState extends State<AutomationScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  final List<Map<String, dynamic>> _routines = [
    {
      'title': 'Auto Recharge',
      'description': 'Return to dock when battery is below 20%',
      'icon': Icons.battery_charging_full_rounded,
      'color': Colors.green,
      'isEnabled': true,
    },
    {
      'title': 'Night Security Patrol',
      'description': 'Patrol living room sector from 11 PM to 5 AM',
      'icon': Icons.security_rounded,
      'color': Colors.indigo,
      'isEnabled': true,
    },
    {
      'title': 'Intruder Alert Broadcast',
      'description': 'Play voice message and sound alarm if unknown person is spotted',
      'icon': Icons.notifications_active_rounded,
      'color': Colors.red,
      'isEnabled': false,
    },
    {
      'title': 'Eco Mode Scheduling',
      'description': 'Enable low power state when inactive for 15 mins',
      'icon': Icons.eco_rounded,
      'color': Colors.teal,
      'isEnabled': false,
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
                        'Automation',
                        style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1.0),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.add_rounded, color: Colors.white),
                          onPressed: () {},
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
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(24, 32, 24, 120),
                        children: [
                          SlideFade(
                            animation: _animController,
                            delay: 0.1,
                            child: _buildCreationCard(context),
                          ),
                          const SizedBox(height: 24),
                          SlideFade(
                            animation: _animController,
                            delay: 0.2,
                            child: Text(
                              'Active Routines',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _routines.length,
                            itemBuilder: (context, index) {
                              final routine = _routines[index];
                              return SlideFade(
                                animation: _animController,
                                delay: 0.25 + (index * 0.08),
                                child: _buildRoutineCard(context, routine, index),
                              );
                            },
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

  Widget _buildCreationCard(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final secondary = theme.colorScheme.secondary;

    return BouncingCard(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              primary.withValues(alpha: 0.08),
              secondary.withValues(alpha: 0.08),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: primary.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.cardColor,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.bolt_rounded, size: 28, color: primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create Quick Rule', 
                    style: TextStyle(
                      fontWeight: FontWeight.w800, 
                      fontSize: 16, 
                      color: theme.textTheme.titleMedium?.color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Set trigger and action recipes for REX.', 
                    style: TextStyle(
                      fontSize: 12, 
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 14, color: primary),
          ],
        ),
      ),
    );
  }

  Widget _buildRoutineCard(BuildContext context, Map<String, dynamic> routine, int index) {
    final theme = Theme.of(context);
    final iconColor = routine['color'] as Color;

    return Container(
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
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(routine['icon'] as IconData, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  routine['title'] as String,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: theme.textTheme.titleMedium?.color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  routine['description'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.textTheme.bodySmall?.color,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Switch.adaptive(
            value: routine['isEnabled'] as bool,
            activeColor: theme.colorScheme.primary,
            onChanged: (val) {
              setState(() {
                _routines[index]['isEnabled'] = val;
              });
            },
          ),
        ],
      ),
    );
  }
}
