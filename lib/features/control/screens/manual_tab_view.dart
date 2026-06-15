import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../connection/providers/bluetooth_provider.dart';
import '../../../widgets/premium_widgets.dart';

class ManualTabView extends ConsumerStatefulWidget {
  const ManualTabView({super.key});

  @override
  ConsumerState<ManualTabView> createState() => _ManualTabViewState();
}

class _ManualTabViewState extends ConsumerState<ManualTabView> {
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
    final isLight = theme.brightness == Brightness.light;
    final primary = theme.colorScheme.primary;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Live Camera Preview Card
          _buildCameraPreview(isLight, primary),
          const SizedBox(height: 20),

          // 2. Connection Info & Arm Enable Toggles
          _buildControlPanelHeader(isLight, primary),
          const SizedBox(height: 24),

          // 3. Dynamic Interactive Joysticks
          _buildJoysticksArea(isLight, primary),
          const SizedBox(height: 24),

          // 4. Sliders (Velocity & Sensitivity) & Emergency Halt Button
          _buildSlidersSection(isLight, primary),
          const SizedBox(height: 24),

          // 5. Optics & Sensors
          _buildOpticsSection(isLight, primary),
          const SizedBox(height: 24),

          // 6. NLP Directives (Voice Command)
          _buildNlpSection(isLight, primary),
          const SizedBox(height: 24),

          // 7. Execution Log
          _buildExecutionLog(isLight, primary),
          const SizedBox(height: 24),

          // 8. Quick Mode Stats
          _buildQuickStats(isLight, primary),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildCameraPreview(bool isLight, Color primary) {
    return BouncingCard(
      onTap: () => context.push('/teleop'),
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          color: Colors.black87,
          image: const DecorationImage(
            image: AssetImage('REX-47.png'),
            fit: BoxFit.cover,
            opacity: 0.35,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isLight ? 0.08 : 0.25),
              blurRadius: 20,
              offset: const Offset(0, 8),
            )
          ],
          border: Border.all(
            color: isLight 
                ? Color.alphaBlend(primary.withValues(alpha: 0.15), Colors.white) 
                : Colors.white12,
            width: 1.5,
          ),
        ),
        child: Stack(
          children: [
            // Live Badge
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.fiber_manual_record, color: Colors.white, size: 12),
                    SizedBox(width: 4),
                    Text(
                      'LIVE HUD',
                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
            ),
            
            // Full Screen Action Button
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white30, width: 2),
                ),
                child: const Icon(Icons.fullscreen_rounded, color: Colors.white, size: 36),
              ),
            ),

            const Positioned(
              bottom: 16,
              right: 16,
              child: Text(
                'Tap for full-screen landscape HUD',
                style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlPanelHeader(bool isLight, Color primary) {
    final bleState = ref.watch(bluetoothProvider);
    final isConnected = bleState.isConnected;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLight ? Colors.white : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isLight ? Colors.black.withValues(alpha: 0.05) : Colors.white10,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isLight ? 0.03 : 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          // Row 1: Connection Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.bluetooth_connected_rounded,
                    color: isConnected ? Colors.green : Colors.grey,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isConnected 
                        ? 'Connected: ${bleState.connectedDevice?.platformName ?? "REX-47"}' 
                        : 'Disconnected',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ],
              ),
              BouncingCard(
                onTap: () => context.push('/connection'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Configure',
                    style: TextStyle(color: primary, fontWeight: FontWeight.w800, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 24, thickness: 1),
          // Row 2: Arm Enable Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Robotic Arm Control',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Enable dual joystick arm module',
                    style: TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                ],
              ),
              Switch.adaptive(
                value: _armEnabled,
                activeColor: primary,
                onChanged: (val) {
                  setState(() {
                    _armEnabled = val;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJoysticksArea(bool isLight, Color primary) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
        decoration: BoxDecoration(
          color: isLight 
              ? Color.alphaBlend(primary.withValues(alpha: 0.03), Colors.white) 
              : Theme.of(context).cardColor.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: isLight ? Colors.black.withValues(alpha: 0.04) : Colors.white.withValues(alpha: 0.05),
          ),
        ),
        child: _armEnabled
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Smaller Mobility Joystick to fit all 3
                  VirtualJoystick(
                    label: 'MOBILITY',
                    icon: Icons.open_with_rounded,
                    size: 95,
                    onDrag: _sendJoystickCommand,
                  ),
                  // Arm Joystick 1 (Base/Shoulder)
                  VirtualJoystick(
                    label: 'ARM J1 (B/S)',
                    icon: Icons.precision_manufacturing_rounded,
                    size: 95,
                    color: primary,
                  ),
                  // Arm Joystick 2 (Elbow/Gripper)
                  VirtualJoystick(
                    label: 'ARM J2 (E/G)',
                    icon: Icons.join_right_rounded,
                    size: 95,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Full sized Mobility Joystick
                  VirtualJoystick(
                    label: 'MOBILITY (CAR)',
                    icon: Icons.open_with_rounded,
                    size: 130,
                    onDrag: _sendJoystickCommand,
                  ),
                  // Full sized Camera Joystick
                  VirtualJoystick(
                    label: 'CAMERA (PAN/TILT)',
                    icon: Icons.videocam_rounded,
                    size: 130,
                    onDrag: _sendGimbalCommand,
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildQuickStats(bool isLight, Color primary) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2.2,
      children: [
        _buildStatTile('Mode', 'MANUAL', Icons.sports_esports_rounded, Colors.blue, isLight),
        _buildStatTile('Battery', '82%', Icons.battery_charging_full_rounded, Colors.green, isLight),
      ],
    );
  }

  Widget _buildStatTile(String label, String value, IconData icon, Color color, bool isLight) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isLight 
            ? Color.alphaBlend(color.withValues(alpha: 0.12), Colors.white) 
            : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isLight 
              ? Color.alphaBlend(color.withValues(alpha: 0.25), Colors.white) 
              : Colors.white10,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSlidersSection(bool isLight, Color primary) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isLight ? Colors.white : theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isLight ? Colors.black.withValues(alpha: 0.05) : Colors.white10,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isLight ? 0.03 : 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.tune_rounded, size: 20, color: primary),
              const SizedBox(width: 8),
              const Text(
                'Velocity & Gimbal Tuning',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Velocity Limit Slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Velocity Limit', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${_velocityLimit.round()}%',
                  style: TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ),
            ],
          ),
          Slider(
            value: _velocityLimit,
            min: 0,
            max: 100,
            onChanged: (val) {
              setState(() {
                _velocityLimit = val;
              });
            },
          ),

          // Gimbal Sensitivity Slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Gimbal Sensitivity', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.indigo.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${_gimbalSensitivity.round()}%',
                  style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ),
            ],
          ),
          Slider(
            value: _gimbalSensitivity,
            min: 0,
            max: 100,
            activeColor: Colors.indigo,
            onChanged: (val) {
              setState(() {
                _gimbalSensitivity = val;
              });
            },
          ),
          const SizedBox(height: 8),

          // EMERGENCY HALT Button
          BouncingCard(
            onTap: () {
              ref.read(bluetoothProvider.notifier).writeCommand("ESTOP");
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('EMERGENCY HALT ACTIVATED! Robot Stopped.'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.redAccent.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.gpp_bad_rounded, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'EMERGENCY HALT',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOpticsSection(bool isLight, Color primary) {
    final theme = Theme.of(context);
    final buttons = [
      {'icon': Icons.swap_horizontal_circle_outlined, 'label': 'Pan Gimbal'},
      {'icon': Icons.swap_vertical_circle_outlined, 'label': 'Tilt Gimbal'},
      {'icon': Icons.zoom_in_rounded, 'label': 'Digital Zoom'},
      {'icon': Icons.camera_alt_rounded, 'label': 'Capture Frame'},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isLight ? Colors.white : theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isLight ? Colors.black.withValues(alpha: 0.05) : Colors.white10,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isLight ? 0.03 : 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.videocam_rounded, size: 20, color: primary),
              const SizedBox(width: 8),
              const Text(
                'Optics & Sensors',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: buttons.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.3,
            ),
            itemBuilder: (context, idx) {
              final btn = buttons[idx];
              return BouncingCard(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${btn['label']} Triggered.')),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isLight ? Colors.grey[50] : Colors.white.withValues(alpha: 0.02),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isLight ? Colors.black.withValues(alpha: 0.05) : Colors.white12,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(btn['icon'] as IconData, size: 18, color: primary),
                      const SizedBox(width: 8),
                      Text(
                        btn['label'] as String,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          BouncingCard(
            onTap: () {
              setState(() {
                _recordingActive = !_recordingActive;
              });
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: _recordingActive ? Colors.redAccent : Colors.black87,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _recordingActive ? Icons.stop_circle_rounded : Icons.fiber_manual_record_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _recordingActive ? 'Stop Stream Recording' : 'Initiate Stream Recording',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildNlpSection(bool isLight, Color primary) {
    final theme = Theme.of(context);
    final list = [
      '"Initiate patrol sequence"',
      '"Halt all movement"',
      '"Return to dock"',
      '"Scan perimeter"'
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isLight ? Colors.white : theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isLight ? Colors.black.withValues(alpha: 0.05) : Colors.white10,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isLight ? 0.03 : 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.mic_rounded, size: 20, color: primary),
              const SizedBox(width: 8),
              const Text(
                'NLP Directives',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Issue vocal commands via edge intelligence:',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: list.map((item) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isLight ? Colors.grey[50] : Colors.white.withValues(alpha: 0.02),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isLight ? Colors.black.withValues(alpha: 0.04) : Colors.white12,
                  ),
                ),
                child: Text(
                  item,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.grey),
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }

  Widget _buildExecutionLog(bool isLight, Color primary) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isLight ? Colors.white : theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isLight ? Colors.black.withValues(alpha: 0.05) : Colors.white10,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isLight ? 0.03 : 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.history_edu_rounded, size: 20, color: primary),
              const SizedBox(width: 8),
              const Text(
                'Execution Log',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            children: _executionLogs.map((log) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isLight ? Colors.grey[50] : Colors.white.withValues(alpha: 0.01),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isLight ? Colors.black.withValues(alpha: 0.03) : Colors.white12,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          log['cmd']!,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          log['time']!,
                          style: const TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                    const Row(
                      children: [
                        Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 16),
                        SizedBox(width: 4),
                        Text(
                          'Executed',
                          style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}

class VirtualJoystick extends StatefulWidget {
  final String label;
  final IconData icon;
  final double size;
  final Color? color;
  final ValueChanged<Offset>? onDrag;

  const VirtualJoystick({
    super.key,
    required this.label,
    required this.icon,
    this.size = 120.0,
    this.color,
    this.onDrag,
  });

  @override
  State<VirtualJoystick> createState() => _VirtualJoystickState();
}

class _VirtualJoystickState extends State<VirtualJoystick> {
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = widget.color ?? theme.colorScheme.primary;
    final double joystickRadius = (widget.size / 2) - 10;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
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
                    color: isDark ? Colors.black12 : Colors.white,
                    border: Border.all(
                      color: isDark ? Colors.white24 : Colors.black.withValues(alpha: 0.08),
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Center Icon
                      Center(
                        child: Icon(
                          widget.icon,
                          color: Colors.grey.withValues(alpha: 0.3),
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
        ),
        const SizedBox(height: 8),
        Text(
          widget.label,
          style: TextStyle(
            fontSize: widget.size * 0.085,
            fontWeight: FontWeight.w900,
            color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
