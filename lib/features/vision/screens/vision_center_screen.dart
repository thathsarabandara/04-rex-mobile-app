import 'package:flutter/material.dart';
import '../../../widgets/premium_widgets.dart';
import 'object_detection_screen.dart';
import 'face_recognition_screen.dart';
import 'intruder_detection_screen.dart';
import 'tracking_center_screen.dart';
import 'scene_understanding_screen.dart';
import 'gesture_recognition_screen.dart';

class VisionCenterScreen extends StatefulWidget {
  const VisionCenterScreen({super.key});

  @override
  State<VisionCenterScreen> createState() => _VisionCenterScreenState();
}

class _VisionCenterScreenState extends State<VisionCenterScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _animController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
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
          // 1. Organic wave gradient background header
          Positioned(
            top: 0, left: 0, right: 0, height: 350,
            child: CustomPaint(painter: HeaderWavePainter(isDark: isDark)),
          ),
          
          // 2. Content Layout
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header Row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Vision AI Center',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Intelligent perception modules',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Scrollable Capsule Styled TabBar
                SlideFade(
                  animation: _animController,
                  delay: 0.1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
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
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
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
                        labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
                        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                        tabs: const [
                          Tab(text: 'Detection'),
                          Tab(text: 'Faces'),
                          Tab(text: 'Intruder'),
                          Tab(text: 'Tracking'),
                          Tab(text: 'Scene'),
                          Tab(text: 'Gestures'),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Bottom Content Sheet
                Expanded(
                  child: SlideFade(
                    animation: _animController,
                    delay: 0.2,
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
                          children: const [
                            ObjectDetectionScreen(),
                            FaceRecognitionScreen(),
                            IntruderDetectionScreen(),
                            TrackingCenterScreen(),
                            SceneUnderstandingScreen(),
                            GestureRecognitionScreen(),
                          ],
                        ),
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
