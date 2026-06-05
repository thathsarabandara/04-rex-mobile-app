import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainShell extends StatefulWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/dashboard')) return 0;
    if (location.startsWith('/control')) return 1;
    if (location.startsWith('/vision')) return 2;
    if (location.startsWith('/assistant')) return 3;
    if (location.startsWith('/automation')) return 4;
    if (location.startsWith('/analytics')) return 5;
    if (location.startsWith('/notifications')) return 6;
    if (location.startsWith('/profile')) return 7;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0: context.go('/dashboard'); break;
      case 1: context.go('/control'); break;
      case 2: context.go('/vision'); break; // Will create later
      case 3: context.go('/assistant'); break; // Will create later
      case 4: context.go('/automation'); break; // Will create later
      case 5: context.go('/analytics'); break; // Will create later
      case 6: context.go('/notifications'); break; // Will create later
      case 7: context.go('/profile'); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFFF8FAFC),
      body: widget.child,
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          height: 64,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 10)),
            ],
            border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  _buildNavItem(Icons.dashboard_outlined, Icons.dashboard_rounded, 'Dashboard', 0, selectedIndex, context),
                  _buildNavItem(Icons.gamepad_outlined, Icons.gamepad_rounded, 'Control', 1, selectedIndex, context),
                  _buildNavItem(Icons.videocam_outlined, Icons.videocam_rounded, 'Vision', 2, selectedIndex, context),
                  _buildNavItem(Icons.smart_toy_outlined, Icons.smart_toy_rounded, 'Assistant', 3, selectedIndex, context),
                  _buildNavItem(Icons.auto_awesome_outlined, Icons.auto_awesome_rounded, 'Automation', 4, selectedIndex, context),
                  _buildNavItem(Icons.bar_chart_outlined, Icons.bar_chart_rounded, 'Analytics', 5, selectedIndex, context),
                  _buildNavItem(Icons.notifications_outlined, Icons.notifications_rounded, 'Alerts', 6, selectedIndex, context),
                  _buildNavItem(Icons.person_outline_rounded, Icons.person_rounded, 'Profile', 7, selectedIndex, context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, IconData activeIcon, String label, int index, int selectedIndex, BuildContext context) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index, context),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: EdgeInsets.symmetric(horizontal: isSelected ? 16 : 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF8B5CF6).withValues(alpha: 0.1) : Colors.transparent, // Purple theme
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon, 
              color: isSelected ? const Color(0xFF8B5CF6) : const Color(0xFF94A3B8), 
              size: 24,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(color: Color(0xFF8B5CF6), fontWeight: FontWeight.w800, fontSize: 13, letterSpacing: -0.2),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
