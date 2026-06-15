import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../widgets/premium_widgets.dart';

class RobotsScreen extends StatefulWidget {
  const RobotsScreen({super.key});

  @override
  State<RobotsScreen> createState() => _RobotsScreenState();
}

class _RobotsScreenState extends State<RobotsScreen> with TickerProviderStateMixin {
  late AnimationController _animController;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _tabController = TabController(length: 2, vsync: this);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _tabController.dispose();
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
                        'My Robots',
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
                SlideFade(
                  animation: _animController,
                  delay: 0.1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.black.withValues(alpha: 0.25) : Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        indicator: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: isLight ? 0.04 : 0.25), 
                              blurRadius: 10, 
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        dividerColor: Colors.transparent,
                        labelColor: primary,
                        unselectedLabelColor: Colors.white.withValues(alpha: 0.9),
                        labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                        tabs: const [
                          Tab(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.public_rounded, size: 20), SizedBox(width: 8), Text('Internet')])),
                          Tab(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.bluetooth_rounded, size: 20), SizedBox(width: 8), Text('Local BLE')])),
                        ],
                      ),
                    ),
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
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildInternetTab(context),
                          _buildBleTab(context),
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

  Widget _buildInternetTab(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 120),
      itemCount: 2,
      itemBuilder: (context, index) {
        final isOnline = index == 0;
        return SlideFade(
          animation: _animController,
          delay: 0.2 + (index * 0.1),
          child: _buildRobotCard(
            context: context,
            name: index == 0 ? 'REX-47 Alpha' : 'REX-47 Beta',
            isOnline: isOnline,
            battery: isOnline ? '87%' : '12%',
            signal: isOnline ? 'Strong' : 'None',
            lastActive: isOnline ? 'Active Now' : '2 days ago',
            type: 'Cloud Connected',
          ),
        );
      },
    );
  }

  Widget _buildBleTab(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    final primary = theme.colorScheme.primary;

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 120),
      children: [
        SlideFade(
          animation: _animController,
          delay: 0.2,
          child: BouncingCard(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: primary.withValues(alpha: isLight ? 0.06 : 0.12),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: primary.withValues(alpha: isLight ? 0.15 : 0.3)),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.cardColor, 
                      shape: BoxShape.circle, 
                      boxShadow: [
                        BoxShadow(
                          color: primary.withValues(alpha: isLight ? 0.08 : 0.2), 
                          blurRadius: 20,
                        )
                      ],
                    ),
                    child: Icon(Icons.bluetooth_searching_rounded, size: 40, color: primary),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Scanning for Robots...', 
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.w900, 
                      color: theme.textTheme.titleMedium?.color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ensure your robot is powered on and in pairing mode.', 
                    textAlign: TextAlign.center, 
                    style: TextStyle(
                      fontSize: 13, 
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        SlideFade(
          animation: _animController,
          delay: 0.3,
          child: Text(
            'Discovered Devices', 
            style: TextStyle(
              fontSize: 18, 
              fontWeight: FontWeight.w900, 
              color: theme.textTheme.titleMedium?.color,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SlideFade(
          animation: _animController,
          delay: 0.4,
          child: _buildBleDeviceCard(context, 'REX-47 LOCAL', 'RSSI: -45 dBm'),
        ),
        SlideFade(
          animation: _animController,
          delay: 0.5,
          child: _buildBleDeviceCard(context, 'REX-47-V2', 'RSSI: -68 dBm'),
        ),
      ],
    );
  }

  Widget _buildBleDeviceCard(BuildContext context, String name, String signal) {
    final theme = Theme.of(context);
    return BouncingCard(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.dividerColor),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: theme.scaffoldBackgroundColor, borderRadius: BorderRadius.circular(16)),
              child: Icon(Icons.bluetooth_rounded, color: theme.colorScheme.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: theme.textTheme.titleMedium?.color)),
                  const SizedBox(height: 4),
                  Text(signal, style: TextStyle(fontSize: 12, color: theme.textTheme.bodySmall?.color)),
                ],
              ),
            ),
            _buildActionButton(context, 'Connect', Icons.link_rounded, theme.colorScheme.primary, Colors.white, () {}, hasBorder: false, isSmall: true),
          ],
        ),
      ),
    );
  }

  Widget _buildRobotCard({
    required BuildContext context,
    required String name, 
    required bool isOnline, 
    required String battery, 
    required String signal, 
    required String lastActive, 
    required String type,
  }) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    final primary = theme.colorScheme.primary;
    final secondary = theme.colorScheme.secondary;

    return BouncingCard(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: theme.dividerColor, width: 1.0),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isOnline 
                      ? [
                          primary.withValues(alpha: isLight ? 0.08 : 0.15), 
                          secondary.withValues(alpha: isLight ? 0.08 : 0.15),
                        ] 
                      : [
                          theme.dividerColor.withValues(alpha: 0.5), 
                          theme.dividerColor,
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -20, bottom: -20,
                    child: Icon(
                      Icons.precision_manufacturing_rounded, 
                      size: 120, 
                      color: (isOnline ? primary : theme.disabledColor).withValues(alpha: 0.08),
                    ),
                  ),
                  Center(
                    child: Icon(Icons.smart_toy_rounded, size: 64, color: isOnline ? primary : theme.disabledColor),
                  ),
                  Positioned(
                    top: 16, right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isLight ? 0.04 : 0.2), 
                            blurRadius: 8, 
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8, height: 8,
                            decoration: BoxDecoration(color: isOnline ? const Color(0xFF10B981) : theme.disabledColor, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isOnline ? 'ONLINE' : 'OFFLINE', 
                            style: TextStyle(
                              color: isOnline ? const Color(0xFF10B981) : theme.disabledColor, 
                              fontSize: 10, 
                              fontWeight: FontWeight.w900, 
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16, left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.scaffoldBackgroundColor.withValues(alpha: 0.8), 
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: theme.dividerColor, width: 0.5),
                      ),
                      child: Text(
                        type, 
                        style: TextStyle(
                          color: theme.textTheme.bodySmall?.color, 
                          fontSize: 10, 
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name, 
                    style: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.w900, 
                      color: theme.textTheme.titleMedium?.color, 
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStat(context, Icons.battery_charging_full_rounded, battery),
                      _buildStat(context, Icons.wifi_rounded, signal),
                      _buildStat(context, Icons.history_rounded, lastActive),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          context,
                          'Control',
                          Icons.gamepad_rounded,
                          isOnline ? primary : theme.dividerColor,
                          isOnline ? Colors.white : theme.disabledColor,
                          () { if (isOnline) context.go('/control'); },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildActionButton(
                          context,
                          'Details',
                          Icons.settings_rounded,
                          theme.cardColor,
                          theme.textTheme.bodyMedium?.color ?? Colors.grey,
                          () {},
                          hasBorder: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(BuildContext context, IconData icon, String value) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 16, color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7)),
        const SizedBox(width: 6),
        Text(
          value, 
          style: TextStyle(
            fontSize: 13, 
            fontWeight: FontWeight.bold, 
            color: theme.textTheme.bodyMedium?.color,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, 
    String label, 
    IconData icon, 
    Color bgColor, 
    Color textColor, 
    VoidCallback onTap, {
    bool hasBorder = false, 
    bool isSmall = false,
  }) {
    final theme = Theme.of(context);
    return BouncingCard(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: isSmall ? 8 : 12, horizontal: isSmall ? 16 : 0),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: hasBorder ? Border.all(color: theme.dividerColor) : null,
          boxShadow: bgColor != Colors.white && bgColor != theme.cardColor && bgColor != theme.dividerColor
              ? [BoxShadow(color: bgColor.withValues(alpha: 0.2), blurRadius: 12, offset: const Offset(0, 4))] 
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor, size: isSmall ? 14 : 18),
            const SizedBox(width: 8),
            Text(
              label, 
              style: TextStyle(
                color: textColor, 
                fontSize: isSmall ? 12 : 14, 
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
