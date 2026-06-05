import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'arm_control_screen.dart';
import 'camera_control_screen.dart';
import 'patrol_control_screen.dart';
import 'emergency_control_screen.dart';
import '../../../widgets/premium_widgets.dart';

class ControlCenterScreen extends StatelessWidget {
  const ControlCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Control Center', style: TextStyle(color: Color(0xFF1D2939), fontWeight: FontWeight.w900, fontSize: 24, letterSpacing: -0.5)),
              Text('Module 2', style: TextStyle(color: Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.w500)),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: ElevatedButton.icon(
                onPressed: () => context.push('/teleop'),
                icon: const Icon(Icons.screen_rotation_rounded, size: 18),
                label: const Text('Teleop Mode'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5CF6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
            )
          ],
          bottom: const TabBar(
            isScrollable: true,
            labelColor: Color(0xFF8B5CF6),
            unselectedLabelColor: Color(0xFF64748B),
            indicatorColor: Color(0xFF8B5CF6),
            indicatorWeight: 3,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: 'Arm'),
              Tab(text: 'Camera'),
              Tab(text: 'Patrol'),
              Tab(text: 'Emergency'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ArmControlScreen(),
            CameraControlScreen(),
            PatrolControlScreen(),
            EmergencyControlScreen(),
          ],
        ),
      ),
    );
  }
}
