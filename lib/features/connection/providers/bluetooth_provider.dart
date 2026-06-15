import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothState {
  final bool isScanning;
  final List<ScanResult> scanResults;
  final BluetoothDevice? connectedDevice;
  final bool isConnected;
  final BluetoothCharacteristic? writeCharacteristic;
  final String? error;
  final BluetoothAdapterState adapterState;
  final List<BluetoothDevice> systemDevices;

  BluetoothState({
    this.isScanning = false,
    this.scanResults = const [],
    this.connectedDevice,
    this.isConnected = false,
    this.writeCharacteristic,
    this.error,
    this.adapterState = BluetoothAdapterState.unknown,
    this.systemDevices = const [],
  });

  BluetoothState copyWith({
    bool? isScanning,
    List<ScanResult>? scanResults,
    BluetoothDevice? connectedDevice,
    bool? isConnected,
    BluetoothCharacteristic? writeCharacteristic,
    String? error,
    BluetoothAdapterState? adapterState,
    List<BluetoothDevice>? systemDevices,
  }) {
    return BluetoothState(
      isScanning: isScanning ?? this.isScanning,
      scanResults: scanResults ?? this.scanResults,
      connectedDevice: connectedDevice ?? this.connectedDevice,
      isConnected: isConnected ?? this.isConnected,
      writeCharacteristic: writeCharacteristic ?? this.writeCharacteristic,
      error: error,
      adapterState: adapterState ?? this.adapterState,
      systemDevices: systemDevices ?? this.systemDevices,
    );
  }
}

class BluetoothNotifier extends Notifier<BluetoothState> {
  StreamSubscription<List<ScanResult>>? _scanSubscription;
  StreamSubscription<BluetoothConnectionState>? _connectionStateSubscription;

  // UUIDs defined in ESP32 firmware
  static const String serviceUuid = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
  static const String characteristicUuid = "beb5483e-36e1-4688-b7f5-ea07361b26a8";

  @override
  BluetoothState build() {
    final adapterSubscription = FlutterBluePlus.adapterState.listen((adapterState) {
      state = state.copyWith(adapterState: adapterState);
    });

    final connectionSubscription = FlutterBluePlus.events.onConnectionStateChanged.listen((event) {
      if (event.connectionState == BluetoothConnectionState.disconnected) {
        if (state.connectedDevice?.id == event.device.id) {
          state = state.copyWith(
            connectedDevice: null,
            isConnected: false,
            writeCharacteristic: null,
          );
        }
      }
    });

    ref.onDispose(() {
      _scanSubscription?.cancel();
      _connectionStateSubscription?.cancel();
      adapterSubscription.cancel();
      connectionSubscription.cancel();
    });
    return BluetoothState(adapterState: FlutterBluePlus.adapterStateNow);
  }

  Future<bool> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();

    return statuses[Permission.bluetoothScan] == PermissionStatus.granted &&
        statuses[Permission.bluetoothConnect] == PermissionStatus.granted;
  }

  Future<void> startScan() async {
    bool hasPermissions = await requestPermissions();
    if (!hasPermissions) {
      state = state.copyWith(error: "Bluetooth permissions denied");
      return;
    }

    state = state.copyWith(isScanning: true, scanResults: []);

    try {
      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 5),
        androidUsesFineLocation: false,
      );

      _scanSubscription?.cancel();
      _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
        state = state.copyWith(scanResults: results);
      });

      // Keep track of scanning state from library
      FlutterBluePlus.isScanning.listen((scanning) {
        if (!scanning && state.isScanning) {
          state = state.copyWith(isScanning: false);
        }
      });
    } catch (e) {
      state = state.copyWith(isScanning: false, error: e.toString());
    }
  }

  Future<void> stopScan() async {
    await FlutterBluePlus.stopScan();
    state = state.copyWith(isScanning: false);
  }

  Future<void> connect(BluetoothDevice device) async {
    state = state.copyWith(isScanning: false);
    await stopScan();

    try {
      await device.connect(
        license: License.nonprofit,
        autoConnect: false,
      );
      
      _connectionStateSubscription?.cancel();
      _connectionStateSubscription = device.connectionState.listen((connState) async {
        if (connState == BluetoothConnectionState.connected) {
          // Discover services
          List<BluetoothService> services = await device.discoverServices();
          BluetoothCharacteristic? targetChar;

          for (var s in services) {
            if (s.uuid.toString().toLowerCase() == serviceUuid) {
              for (var c in s.characteristics) {
                if (c.uuid.toString().toLowerCase() == characteristicUuid) {
                  targetChar = c;
                  break;
                }
              }
            }
          }

          state = state.copyWith(
            connectedDevice: device,
            isConnected: true,
            writeCharacteristic: targetChar,
          );
        } else if (connState == BluetoothConnectionState.disconnected) {
          state = state.copyWith(
            connectedDevice: null,
            isConnected: false,
            writeCharacteristic: null,
          );
        }
      });
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> disconnect() async {
    if (state.connectedDevice != null) {
      await state.connectedDevice!.disconnect();
    }
    _connectionStateSubscription?.cancel();
    state = state.copyWith(
      connectedDevice: null,
      isConnected: false,
      writeCharacteristic: null,
    );
  }

  Future<void> writeCommand(String command) async {
    final char = state.writeCharacteristic;
    if (char != null) {
      try {
        final formattedCommand = command.endsWith('\n') ? command : '$command\n';
        await char.write(formattedCommand.codeUnits, withoutResponse: false);
      } catch (e) {
        state = state.copyWith(error: "Write failed: ${e.toString()}");
      }
    }
  }
}

final bluetoothProvider = NotifierProvider<BluetoothNotifier, BluetoothState>(() {
  return BluetoothNotifier();
});
