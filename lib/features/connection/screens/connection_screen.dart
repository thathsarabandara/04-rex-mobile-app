import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' hide BluetoothState;
import '../providers/bluetooth_provider.dart';
import '../../../widgets/premium_widgets.dart';

class ConnectionScreen extends ConsumerStatefulWidget {
  const ConnectionScreen({super.key});

  @override
  ConsumerState<ConnectionScreen> createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends ConsumerState<ConnectionScreen> with TickerProviderStateMixin {
  late AnimationController _animController;
  late AnimationController _scanController;

  // State Variables
  String _connectionType = 'BLE'; // 'BLE' or 'INTERNET'
  bool _isConnecting = false;

  // Form Controllers
  final _brokerController = TextEditingController(text: 'mqtt.rex-command.net');
  final _portController = TextEditingController(text: '1883');
  final _robotIdController = TextEditingController(text: 'REX-47-ALPHA');

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _animController.forward();

    _scanController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();

    // Automatically request permissions and scan for devices on startup
    Future.microtask(() => _startBleScan());
  }

  @override
  void dispose() {
    _animController.dispose();
    _scanController.dispose();
    _brokerController.dispose();
    _portController.dispose();
    _robotIdController.dispose();
    super.dispose();
  }

  void _toggleConnection(BluetoothState bleState) {
    if (bleState.isConnected) {
      ref.read(bluetoothProvider.notifier).disconnect();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Disconnected from REX-47')),
      );
    } else {
      if (_connectionType == 'INTERNET') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('MQTT internet simulation active.')),
        );
      }
    }
  }

  void _startBleScan() {
    ref.read(bluetoothProvider.notifier).startScan();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isLight = theme.brightness == Brightness.light;
    final primary = theme.colorScheme.primary;
    final bleState = ref.watch(bluetoothProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Header Background Wave
          Positioned(
            top: 0, left: 0, right: 0, height: 260,
            child: CustomPaint(painter: HeaderWavePainter(isDark: isDark)),
          ),
          
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Row(
                    children: [
                      BouncingCard(
                        onTap: () {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.go('/dashboard');
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                          ),
                          child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Robot Link',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            'Configure connection protocol',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Main Connection Panel Sheet
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
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1. Connection Status Card
                            _buildStatusCard(bleState, isLight, primary),
                            const SizedBox(height: 24),

                            // 2. Protocol Mode Tabs
                            _buildProtocolTabs(bleState, primary, isLight),
                            const SizedBox(height: 24),

                            // 3. Dynamic Configuration Section
                            if (_connectionType == 'BLE')
                              _buildBleSection(bleState, primary, isLight)
                            else
                              _buildInternetSection(bleState, primary, isLight),

                            const SizedBox(height: 32),

                            // 4. Action Button
                            if (_connectionType == 'INTERNET' || bleState.isConnected)
                              _buildConnectActionButton(bleState, primary),
                            const SizedBox(height: 80),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatusCard(BluetoothState bleState, bool isLight, Color primary) {
    final isConnected = bleState.isConnected;
    Color cardColor = isConnected 
        ? Colors.green 
        : (_isConnecting ? Colors.orange : Colors.grey);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isLight ? Colors.white : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isLight ? cardColor.withValues(alpha: 0.25) : cardColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: cardColor.withValues(alpha: isLight ? 0.08 : 0.15),
            blurRadius: 16,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Row(
        children: [
          // Status Ring Indicator
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cardColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isConnected 
                  ? Icons.link_rounded 
                  : (_isConnecting ? Icons.sync_rounded : Icons.link_off_rounded),
              color: cardColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isConnected 
                      ? 'CONNECTED' 
                      : (_isConnecting ? 'ESTABLISHING LINK...' : 'DISCONNECTED'),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    color: cardColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isConnected 
                      ? 'Active link to ${bleState.connectedDevice?.name.isNotEmpty == true ? bleState.connectedDevice!.name : "REX-47"}' 
                      : 'Pair with your REX-47 robot to start control',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          if (isConnected)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Active',
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.w800, fontSize: 11),
              ),
            )
        ],
      ),
    );
  }

  Widget _buildProtocolTabs(BluetoothState bleState, Color primary, bool isLight) {
    final isConnected = bleState.isConnected;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isLight ? Colors.black.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (!isConnected && !_isConnecting) {
                  setState(() => _connectionType = 'BLE');
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _connectionType == 'BLE' ? Theme.of(context).cardColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: _connectionType == 'BLE'
                      ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))]
                      : [],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bluetooth_rounded,
                      color: _connectionType == 'BLE' ? primary : Colors.grey,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Local BLE',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        color: _connectionType == 'BLE' 
                            ? Theme.of(context).textTheme.titleMedium?.color 
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (!isConnected && !_isConnecting) {
                  setState(() => _connectionType = 'INTERNET');
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _connectionType == 'INTERNET' ? Theme.of(context).cardColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: _connectionType == 'INTERNET'
                      ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))]
                      : [],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_rounded,
                      color: _connectionType == 'INTERNET' ? primary : Colors.grey,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Internet Cloud',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        color: _connectionType == 'INTERNET' 
                            ? Theme.of(context).textTheme.titleMedium?.color 
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBleSection(BluetoothState bleState, Color primary, bool isLight) {
    if (bleState.adapterState == BluetoothAdapterState.off) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            const Icon(Icons.bluetooth_disabled_rounded, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            const Text(
              'Bluetooth is turned off',
              style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please turn on Bluetooth in your device settings to scan for nearby REX-47 devices.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red, fontSize: 13),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Nearby BLE Devices',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            if (bleState.isScanning)
              RotationTransition(
                turns: _scanController,
                child: Icon(Icons.sync_rounded, color: primary, size: 20),
              )
            else
              TextButton.icon(
                onPressed: _startBleScan,
                icon: const Icon(Icons.search_rounded, size: 16),
                label: const Text('Scan'),
                style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
              )
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: isLight ? Colors.white : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isLight 
                  ? Color.alphaBlend(primary.withValues(alpha: 0.1), Colors.white)
                  : Theme.of(context).dividerColor,
            ),
          ),
          child: bleState.scanResults.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Center(
                    child: Text(
                      'No devices found. Tap Scan to search.',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ),
                )
              : Column(
                  children: bleState.scanResults.map((result) {
                    final device = result.device;
                    final isThisConnected = bleState.connectedDevice?.id == device.id;
                    final name = device.platformName.isNotEmpty 
                        ? device.platformName 
                        : (device.name.isNotEmpty ? device.name : 'Unknown Device');
                    
                    return ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isThisConnected ? Icons.bluetooth_connected_rounded : Icons.bluetooth_rounded, 
                          color: primary, 
                          size: 18,
                        ),
                      ),
                      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      subtitle: Text('Signal strength: ${result.rssi} dBm', style: const TextStyle(fontSize: 12)),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isThisConnected 
                              ? primary.withValues(alpha: 0.12) 
                              : Colors.black.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isThisConnected ? 'CONNECTED' : 'CONNECT',
                          style: TextStyle(
                            color: isThisConnected ? primary : Colors.grey,
                            fontWeight: FontWeight.w800,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      onTap: () async {
                        if (!isThisConnected && !_isConnecting) {
                          setState(() => _isConnecting = true);
                          await ref.read(bluetoothProvider.notifier).connect(device);
                          if (mounted) {
                            setState(() => _isConnecting = false);
                          }
                        }
                      },
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }

  Widget _buildInternetSection(BluetoothState bleState, Color primary, bool isLight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Cloud Broker Settings',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 16),
        _buildTextField('Broker Endpoint / Address', _brokerController, Icons.dns_rounded, bleState.isConnected),
        const SizedBox(height: 12),
        _buildTextField('Broker Port', _portController, Icons.settings_ethernet_rounded, bleState.isConnected),
        const SizedBox(height: 12),
        _buildTextField('Robot Client ID', _robotIdController, Icons.fingerprint_rounded, bleState.isConnected),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, bool isConnected) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          enabled: !isConnected && !_isConnecting,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20),
            filled: true,
            fillColor: isLight 
                ? Color.alphaBlend(Colors.black.withValues(alpha: 0.02), Colors.white) 
                : theme.cardColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: theme.dividerColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: theme.dividerColor.withValues(alpha: 0.5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: theme.colorScheme.primary),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildConnectActionButton(BluetoothState bleState, Color primary) {
    final isConnected = bleState.isConnected;
    return Column(
      children: [
        BouncingCard(
          onTap: _isConnecting ? null : () => _toggleConnection(bleState),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: isConnected ? Colors.red : primary,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: (isConnected ? Colors.red : primary).withValues(alpha: 0.35),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                )
              ],
            ),
            child: Center(
              child: _isConnecting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                    )
                  : Text(
                      isConnected ? 'Disconnect Device' : 'Connect to Robot',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.2,
                      ),
                    ),
            ),
          ),
        ),
        if (!context.canPop()) ...[
          const SizedBox(height: 24),
          TextButton(
            onPressed: () => context.go('/dashboard'),
            child: Text(
              isConnected ? 'Continue to Dashboard' : 'Skip to Dashboard',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
