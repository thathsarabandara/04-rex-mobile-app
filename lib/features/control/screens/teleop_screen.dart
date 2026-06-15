import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../connection/providers/bluetooth_provider.dart';
import '../../../widgets/premium_widgets.dart';

class TeleopScreen extends ConsumerStatefulWidget {
  const TeleopScreen({super.key});

  @override
  ConsumerState<TeleopScreen> createState() => _TeleopScreenState();
}

class _TeleopScreenState extends ConsumerState<TeleopScreen> {
  bool _armEnabled = false;
  double _velocityLimit = 50.0;
  double _gimbalSensitivity = 50.0;
  bool _recordingActive = false;

  double _panAngle = 90.0;
  double _tiltAngle = 90.0;
  DateTime? _lastJoystickSend;
  DateTime? _lastGimbalSend;

  final List<Map<String, String>> _executionLogs = [
    {'cmd': 'Forward 50cm', 'status': 'executed', 'time': '2m ago'},
    {'cmd': 'Turn Left 90°', 'status': 'executed', 'time': '3m ago'},
    {'cmd': 'Take Photo', 'status': 'executed', 'time': '5m ago'},
  ];

  @override
  void initState() {
    super.initState();
    // Force Landscape orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    // Restore default portrait-first orientations
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _sendJoystickCommand(Offset offset) {
    final bleState = ref.read(bluetoothProvider);
    if (!bleState.isConnected) return;

    final now = DateTime.now();
    if (_lastJoystickSend == null || 
        now.difference(_lastJoystickSend!) > const Duration(milliseconds: 80) || 
        offset == Offset.zero) {
      _lastJoystickSend = now;
      
      final scale = _velocityLimit / 100.0;
      final x = offset.dx * scale;
      final y = -offset.dy * scale; // Invert Y so forward is positive
      
      ref.read(bluetoothProvider.notifier).writeCommand("M:${x.toStringAsFixed(2)}:${y.toStringAsFixed(2)}");
    }
  }

  void _sendGimbalCommand(Offset offset) {
    final bleState = ref.read(bluetoothProvider);
    if (!bleState.isConnected) return;

    final now = DateTime.now();
    if (_lastGimbalSend == null || 
        now.difference(_lastGimbalSend!) > const Duration(milliseconds: 100)) {
      _lastGimbalSend = now;
      
      final sensitivity = _gimbalSensitivity / 50.0; // 0 to 2
      _panAngle = (_panAngle + offset.dx * 8 * sensitivity).clamp(0.0, 180.0);
      _tiltAngle = (_tiltAngle - offset.dy * 8 * sensitivity).clamp(0.0, 180.0);
      
      ref.read(bluetoothProvider.notifier).writeCommand("J:0:${_panAngle.round()}");
      Future.delayed(const Duration(milliseconds: 30), () {
        ref.read(bluetoothProvider.notifier).writeCommand("J:1:${_tiltAngle.round()}");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final bleState = ref.watch(bluetoothProvider);
    final isConnected = bleState.isConnected;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Full-screen Camera Stream Background
          Positioned.fill(
            child: Image.asset(
              'REX-47.png',
              fit: BoxFit.cover,
              opacity: const AlwaysStoppedAnimation(0.4),
            ),
          ),
          
          // 2. HUD Top Control Bar
          Positioned(
            top: 16, left: 24, right: 24,
            child: Row(
              children: [
                BouncingCard(
                  onTap: () => context.pop(),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: const Icon(Icons.close_rounded, color: Colors.white, size: 22),
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'REX-47 HUD',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                const Spacer(),
                
                // Status Pills
                _buildHudStatusChip(Icons.battery_charging_full_rounded, '82%', Colors.green),
                const SizedBox(width: 8),
                _buildHudStatusChip(
                  Icons.bluetooth_connected_rounded,
                  isConnected ? 'LINK OK' : 'LINK LOST',
                  isConnected ? Colors.blue : Colors.grey,
                ),
                const SizedBox(width: 8),
                _buildHudStatusChip(Icons.fiber_manual_record, 'REC', Colors.red),
                const SizedBox(width: 8),
                BouncingCard(
                  onTap: () => _showHudSettingsSheet(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.tune_rounded, color: Colors.amber, size: 14),
                        SizedBox(width: 6),
                        Text(
                          'TUNING',
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 3. Left Controls: Mobility Joystick
          Positioned(
            left: 32,
            bottom: 40,
            child: _buildJoystickWrapper(
              label: 'MOBILITY',
              icon: Icons.open_with_rounded,
              size: 130,
              color: Colors.white,
              onDrag: _sendJoystickCommand,
            ),
          ),

          // 4. Right Controls: Camera Joystick + Dual Arm Joystick Module
          Positioned(
            right: 32,
            bottom: 40,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Arm Toggle Control Button
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BouncingCard(
                      onTap: () {
                        setState(() {
                          _armEnabled = !_armEnabled;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _armEnabled ? primary : Colors.black87,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _armEnabled ? Colors.white : Colors.white24,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: (_armEnabled ? primary : Colors.black).withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: const Icon(
                          Icons.precision_manufacturing_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _armEnabled ? 'Arm: ON' : 'Arm: OFF',
                      style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
                const SizedBox(width: 24),

                // Animated Right Joysticks Container
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: Row(
                    children: [
                      // Camera Joystick
                      _buildJoystickWrapper(
                        label: 'CAMERA',
                        icon: Icons.videocam_rounded,
                        size: 110,
                        color: Colors.white,
                        onDrag: _sendGimbalCommand,
                      ),
                      
                      // Arm Joystick 1 (Base/Shoulder) - only shown when enabled
                      if (_armEnabled) ...[
                        const SizedBox(width: 20),
                        _buildJoystickWrapper(
                          label: 'ARM J1 (B/S)',
                          icon: Icons.precision_manufacturing_rounded,
                          size: 110,
                          color: primary,
                        ),
                      ],

                      // Arm Joystick 2 (Elbow/Gripper) - only shown when enabled
                      if (_armEnabled) ...[
                        const SizedBox(width: 20),
                        _buildJoystickWrapper(
                          label: 'ARM J2 (E/G)',
                          icon: Icons.join_right_rounded,
                          size: 110,
                          color: theme.colorScheme.secondary,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 5. Center Bottom Action Buttons
          Positioned(
            bottom: 24, left: 0, right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildActionBtn(Icons.stop_circle_rounded, 'STOP', Colors.red, () {
                  if (isConnected) {
                    ref.read(bluetoothProvider.notifier).writeCommand("M:0.0:0.0");
                  }
                }),
                const SizedBox(width: 12),
                _buildActionBtn(Icons.explore_rounded, 'PATROL', Colors.blue, () {}),
                const SizedBox(width: 12),
                _buildActionBtn(Icons.home_rounded, 'HOME', Colors.orange, () {}),
                const SizedBox(width: 12),
                _buildActionBtn(Icons.warning_amber_rounded, 'EMERGENCY', const Color(0xFF990000), () {
                  if (isConnected) {
                    ref.read(bluetoothProvider.notifier).writeCommand("ESTOP");
                  }
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHudStatusChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }

  Widget _buildJoystickWrapper({
    required String label,
    required IconData icon,
    required double size,
    required Color color,
    ValueChanged<Offset>? onDrag,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        HudVirtualJoystick(
          icon: icon,
          size: size,
          color: color,
          onDrag: onDrag,
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildActionBtn(IconData icon, String label, Color color, VoidCallback onTap) {
    return BouncingCard(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white24),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showHudSettingsSheet(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFF151515),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                border: Border(
                  top: BorderSide(color: Colors.white24, width: 1.5),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('HUD SPEED & TUNING', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900)),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, color: Colors.white70),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('VELOCITY LIMIT', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                    Slider(
                      value: _velocityLimit,
                      min: 0,
                      max: 100,
                      activeColor: primary,
                      inactiveColor: Colors.white10,
                      onChanged: (val) {
                        setModalState(() {
                          _velocityLimit = val;
                        });
                        setState(() {
                          _velocityLimit = val;
                        });
                      },
                    ),

                    const SizedBox(height: 8),
                    const Text('GIMBAL SENSITIVITY', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                    Slider(
                      value: _gimbalSensitivity,
                      min: 0,
                      max: 100,
                      activeColor: Colors.indigoAccent,
                      inactiveColor: Colors.white10,
                      onChanged: (val) {
                        setModalState(() {
                          _gimbalSensitivity = val;
                        });
                        setState(() {
                          _gimbalSensitivity = val;
                        });
                      },
                    ),

                    const SizedBox(height: 16),
                    const Text('OPTICS & NLP SYSTEM DIRECTIVES', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: BouncingCard(
                            onTap: () {
                              setModalState(() {
                                _recordingActive = !_recordingActive;
                              });
                              setState(() {
                                _recordingActive = !_recordingActive;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _recordingActive ? Colors.red : Colors.white10,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.white24),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(_recordingActive ? Icons.stop_rounded : Icons.circle_rounded, color: Colors.white, size: 16),
                                  const SizedBox(width: 8),
                                  Text(
                                    _recordingActive ? 'REC ON' : 'REC OFF',
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: BouncingCard(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Listening for voice directives...')),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.white24),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.mic_rounded, color: Colors.white, size: 16),
                                  SizedBox(width: 8),
                                  Text(
                                    'VOICE CMD',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('SYSTEM EXECUTION LOGS', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Column(
                      children: _executionLogs.map((log) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(log['cmd']!, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                              Text(log['time']!, style: const TextStyle(color: Colors.white38, fontSize: 10)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class HudVirtualJoystick extends StatefulWidget {
  final IconData icon;
  final double size;
  final Color color;
  final ValueChanged<Offset>? onDrag;

  const HudVirtualJoystick({
    super.key,
    required this.icon,
    required this.size,
    required this.color,
    this.onDrag,
  });

  @override
  State<HudVirtualJoystick> createState() => _HudVirtualJoystickState();
}

class _HudVirtualJoystickState extends State<HudVirtualJoystick> {
  Offset _dragPosition = Offset.zero;

  void _updateDrag(DragUpdateDetails details, Size size, double joystickRadius) {
    final center = Offset(size.width / 2, size.height / 2);
    final localPosition = details.localPosition - center;
    
    double distance = localPosition.distance;
    if (distance > joystickRadius) {
      _dragPosition = localPosition * (joystickRadius / distance);
    } else {
      _dragPosition = localPosition;
    }

    setState(() {});

    if (widget.onDrag != null) {
      widget.onDrag!(Offset(_dragPosition.dx / joystickRadius, _dragPosition.dy / joystickRadius));
    }
  }

  void _resetDrag() {
    setState(() {
      _dragPosition = Offset.zero;
    });

    if (widget.onDrag != null) {
      widget.onDrag!(Offset.zero);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double joystickRadius = (widget.size / 2) - 10;
    final primary = widget.color;

    return Container(
      width: widget.size,
      height: widget.size,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);
          return GestureDetector(
            onPanUpdate: (details) => _updateDrag(details, size, joystickRadius),
            onPanEnd: (_) => _resetDrag(),
            onPanCancel: () => _resetDrag(),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black45,
                border: Border.all(
                  color: Colors.white24,
                  width: 2.5,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  )
                ],
              ),
              child: Stack(
                children: [
                  // Center Icon
                  Center(
                    child: Icon(
                      widget.icon,
                      color: Colors.white24,
                      size: widget.size * 0.28,
                    ),
                  ),
                  // Thumb Handle
                  Positioned(
                    left: (size.width / 2 - (widget.size * 0.22)) + _dragPosition.dx,
                    top: (size.height / 2 - (widget.size * 0.22)) + _dragPosition.dy,
                    child: Container(
                      width: widget.size * 0.44,
                      height: widget.size * 0.44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [primary, primary.withValues(alpha: 0.8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: primary.withValues(alpha: 0.35),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          )
                        ],
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.drag_indicator_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
