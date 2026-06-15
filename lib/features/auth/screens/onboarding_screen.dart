import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../widgets/premium_widgets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _animController;

  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Live Teleoperation Core',
      'description': 'Low-latency WebSocket + MQTT control system enabling real-time robot driving, camera steering, and emergency override from mobile or web.',
      'image': 'assets/live.png',
    },
    {
      'title': 'Multi-Sensor Telemetry Pipeline',
      'description': 'Stream and visualize real-time data from ultrasonic, IMU, IR, temperature, and battery sensors with synchronized event logging.',
      'image': 'assets/sensor.png',
    },
    {
      'title': 'Vision Intelligence System',
      'description': 'GPU-accelerated computer vision pipeline for object detection, face recognition, and tracking using real-time camera feeds.',
      'image': 'assets/vision.png',
    },
    {
      'title': 'Agentic Decision Engine',
      'description': 'Event-driven AI system that interprets sensor inputs, generates action plans, and executes tool-based robotic commands autonomously.',
      'image': 'assets/agentic.png',
    },
    {
      'title': 'Secure Robot Pairing',
      'description': 'Cryptographic device binding using robot ID, JWT authentication, and secure pairing workflow to prevent unauthorized control.',
      'image': 'assets/secure.png',
    },
    {
      'title': 'Cloud Hybrid Control',
      'description': 'Hybrid execution model where time-critical controls run locally on ESP32 while AI inference and planning run on GPU-backed cloud or laptop server.',
      'image': 'assets/cloud.png',
    },
    {
      'title': 'Event & Safety Monitoring',
      'description': 'Real-time anomaly detection system tracking intrusions, falls, motion events, and system failures with instant alert propagation.',
      'image': 'assets/monitering.png',
    }
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
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isLight = theme.brightness == Brightness.light;
    final primary = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: 0, left: 0, right: 0, height: size.height * 0.65,
            child: CustomPaint(painter: HeaderWavePainter(isDark: isDark)),
          ),
          
          Positioned(
            bottom: 0, left: 0, right: 0,
            height: size.height * 0.4,
            child: Container(
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(48), topRight: Radius.circular(48)),
                border: Border(
                  top: BorderSide(
                    color: isLight ? Colors.white : const Color(0xFF3B2E60),
                    width: 2.0,
                  ),
                ),
                boxShadow: [
                  // Deep soft diffused ambient shadow
                  BoxShadow(
                    color: isLight 
                        ? Colors.black.withValues(alpha: 0.08) 
                        : Colors.black.withValues(alpha: 0.5), 
                    blurRadius: 32, 
                    offset: const Offset(0, -16),
                  ),
                  // Crisp top bevel reflection highlight
                  BoxShadow(
                    color: isLight 
                        ? Colors.white.withValues(alpha: 0.9) 
                        : const Color(0xFF6366F1).withValues(alpha: 0.2), 
                    blurRadius: 4, 
                    offset: const Offset(0, -3),
                  ),
                  // Soft inner depth shadow
                  BoxShadow(
                    color: isLight 
                        ? Colors.black.withValues(alpha: 0.02) 
                        : Colors.black.withValues(alpha: 0.25), 
                    blurRadius: 10, 
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: TextButton(
                      onPressed: () => context.go('/welcome'),
                      child: const Text('Skip', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                      _animController.forward(from: 0);
                    },
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Expanded(
                            flex: 55,
                            child: Center(
                              child: SlideFade(
                                animation: _animController,
                                delay: 0.1,
                                child: Container(
                                  padding: const EdgeInsets.all(40),
                                  child: Image(
                                    image: AssetImage(_pages[index]['image'] as String),
                                    height: 400,
                                    width: 400,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          
                          Expanded(
                            flex: 32,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 32.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SlideFade(
                                    animation: _animController,
                                    delay: 0.2,
                                    child: Text(
                                      _pages[index]['title'] as String,
                                      style: TextStyle(
                                        fontSize: 26, 
                                        fontWeight: FontWeight.w900, 
                                        color: theme.textTheme.titleLarge?.color, 
                                        letterSpacing: -1,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  SlideFade(
                                    animation: _animController,
                                    delay: 0.3,
                                    child: Text(
                                      _pages[index]['description'] as String,
                                      style: TextStyle(
                                        fontSize: 14, 
                                        color: theme.textTheme.bodySmall?.color, 
                                        height: 1.5,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: List.generate(
                          _pages.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(right: 8),
                            height: 8,
                            width: _currentPage == index ? 24 : 8,
                            decoration: BoxDecoration(
                              color: _currentPage == index ? primary : theme.dividerColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      BouncingCard(
                        onTap: () {
                          if (_currentPage == _pages.length - 1) {
                            context.go('/welcome');
                          } else {
                            _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOutCubic);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          decoration: BoxDecoration(
                            color: primary,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: primary.withValues(alpha: 0.25), 
                                blurRadius: 20, 
                                offset: const Offset(0, 8),
                              )
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _currentPage == _pages.length - 1 ? 'Start' : 'Next',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
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
