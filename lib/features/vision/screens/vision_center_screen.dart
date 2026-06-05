import 'package:flutter/material.dart';
import 'object_detection_screen.dart';
import 'face_recognition_screen.dart';
import 'intruder_detection_screen.dart';
import 'tracking_center_screen.dart';
import 'scene_understanding_screen.dart';
import 'gesture_recognition_screen.dart';

class VisionCenterScreen extends StatelessWidget {
  const VisionCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Vision Center', style: TextStyle(color: Color(0xFF1D2939), fontWeight: FontWeight.w900, fontSize: 24, letterSpacing: -0.5)),
              Text('Module 3', style: TextStyle(color: Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.w500)),
            ],
          ),
          bottom: const TabBar(
            isScrollable: true,
            labelColor: Color(0xFF8B5CF6),
            unselectedLabelColor: Color(0xFF64748B),
            indicatorColor: Color(0xFF8B5CF6),
            indicatorWeight: 3,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: 'Detection'),
              Tab(text: 'Faces'),
              Tab(text: 'Intruder'),
              Tab(text: 'Tracking'),
              Tab(text: 'Scene'),
              Tab(text: 'Gestures'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ObjectDetectionScreen(),
            FaceRecognitionScreen(),
            IntruderDetectionScreen(),
            TrackingCenterScreen(),
            SceneUnderstandingScreen(),
            GestureRecognitionScreen(),
          ],
        ),
      ),
    );
  }
}
