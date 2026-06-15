import 'package:flutter/material.dart';
import '../../../widgets/premium_widgets.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  int _selectedFilterIndex = 0; // 0: Day, 1: Week, 2: Month

  final List<String> _filters = ['Day', 'Week', 'Month'];

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
                        'Analytics',
                        style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1.0),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.share_rounded, color: Colors.white),
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
                          // Filter Toggle Row
                          SlideFade(
                            animation: _animController,
                            delay: 0.1,
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
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      decoration: BoxDecoration(
                                        color: isSelected 
                                            ? primary 
                                            : theme.cardColor,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: isSelected ? primary : theme.dividerColor,
                                        ),
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
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                          const SizedBox(height: 28),

                          // Graph Card
                          SlideFade(
                            animation: _animController,
                            delay: 0.2,
                            child: _buildUsageGraphCard(context),
                          ),
                          const SizedBox(height: 28),

                          // Status list
                          SlideFade(
                            animation: _animController,
                            delay: 0.3,
                            child: Text(
                              'Operation Metrics',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          SlideFade(
                            animation: _animController,
                            delay: 0.4,
                            child: Row(
                              children: [
                                _buildMetricCard(context, 'Patrol Distance', '8.4 km', '2.1 km/day average', Icons.directions_walk_rounded, Colors.blue),
                                const SizedBox(width: 16),
                                _buildMetricCard(context, 'Active Hours', '14.2 hrs', 'System operational', Icons.access_time_rounded, Colors.purple),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          SlideFade(
                            animation: _animController,
                            delay: 0.5,
                            child: Row(
                              children: [
                                _buildMetricCard(context, 'Battery Health', '96%', 'Good performance', Icons.favorite_rounded, Colors.green),
                                const SizedBox(width: 16),
                                _buildMetricCard(context, 'Obstacles Avoided', '1,248', 'LIDAR triggered', Icons.radar_rounded, Colors.orange),
                              ],
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

  Widget _buildUsageGraphCard(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    final primary = theme.colorScheme.primary;

    // Simulated weekly bars
    final List<double> barHeights = [45, 75, 55, 90, 60, 40, 80];
    final List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Weekly Active Trend', 
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  fontSize: 16, 
                  color: theme.textTheme.titleMedium?.color,
                ),
              ),
              Icon(Icons.trending_up_rounded, color: Colors.green, size: 20),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '+12.4% uptime since last week', 
            style: TextStyle(
              fontSize: 12, 
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: 32),
          // Chart view
          SizedBox(
            height: 140,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(barHeights.length, (index) {
                final height = barHeights[index];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(
                        width: 14,
                        decoration: BoxDecoration(
                          color: index == 3 
                              ? primary 
                              : primary.withValues(alpha: isLight ? 0.15 : 0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.bottomCenter,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          height: height,
                          width: 14,
                          decoration: BoxDecoration(
                            color: index == 3 ? primary : primary.withValues(alpha: 0.65),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      days[index],
                      style: TextStyle(
                        fontSize: 11,
                        color: theme.textTheme.bodySmall?.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                );
              }),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMetricCard(BuildContext context, String title, String value, String subtitle, IconData icon, Color color) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: isLight ? 0.05 : 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: isLight ? 0.15 : 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 18, color: color),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: theme.textTheme.titleMedium?.color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10,
                color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
