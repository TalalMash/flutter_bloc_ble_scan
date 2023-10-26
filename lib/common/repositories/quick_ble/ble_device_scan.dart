import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:quick_blue/quick_blue.dart';
import 'package:flutter_draft/common/constants/constants.dart';

import 'models/bloc_scan_result.dart';

part 'ble_scan_results.dart';

class BluetoothRepository {
  Stream<List<BlocScanResult>> get scanResults => _scanResultController.stream;
  Stream<bool> get scanFinished => _scanFinishedController.stream;
  final Stream<AvailabilityState> _availabilitySubscription =
      QuickBlue.availabilityChangeStream;

  final _scanFinishedController = StreamController<bool>.broadcast();
  Timer? _scanTimeout;
  bool _bluetoothReady = false;
  final _bluetoothReadyController = StreamController<bool>.broadcast();

  Future<void> platformInterfaceInit() async {
    _availabilitySubscription.listen((AvailabilityState state) async {
      switch (state) {
        case AvailabilityState.poweredOn:
          {
            _bluetoothReadyController.add(true);
            print("powered on");
          }
        case AvailabilityState.poweredOff:
          {
            _bluetoothReadyController.add(false);
            print("powered off");
          }
        case AvailabilityState.resetting:
          // TODO: Handle this case.
          break;
        case AvailabilityState.unauthorized:
          // TODO: Handle this case.
          break;
        case AvailabilityState.unknown:
          // TODO: Handle this case.
          break;
        case AvailabilityState.unsupported:
          // TODO: Handle this case.
          break;
      }
    });
  }

  Future<void> startScan() async {
    blocList.clear();
    currentList.clear();
    if (await Permission.locationWhenInUse.request().isGranted) {
      _bluetoothReady = await QuickBlue.isBluetoothAvailable();
      if (_bluetoothReady) {
        print("DONE + ${_bluetoothReady}");
        QuickBlue.startScan();
        _handleScanResults();
        _scanTimeout =
            Timer(const Duration(seconds: scanInterval), () => stopScan());
      }
    }
  }

  Future<void> stopScan() async {
    QuickBlue.stopScan();
    _scanTimeout?.cancel();
    _scanFinishedController.add(true);
    _scanResultSubscription?.cancel();
  }
}
