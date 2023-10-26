import 'dart:async';
import 'package:quick_blue/quick_blue.dart';
import 'package:flutter_draft/common/constants/constants.dart';

part 'ble_scan_results.dart';

class BluetoothRepository {
  Stream<List<BlueScanResult>> get scanResults => _scanResultController.stream;
  Stream<bool> get scanFinished => _scanFinishedController.stream;
  final Stream<AvailabilityState> _availabilitySubscription =
      QuickBlue.availabilityChangeStream;

  final _scanFinishedController = StreamController<bool>.broadcast();
  Timer? _scanTimeout;
  bool _bluetoothReady = false;
  final _bluetoothReadyController = StreamController<bool>.broadcast();

  Future<void> deviceBLEStatusNotifier() async {
    _availabilitySubscription.listen((AvailabilityState state) async {
      switch (state) {
        case AvailabilityState.poweredOn:
          {
            _bluetoothReadyController.add(true);
          }
        case AvailabilityState.poweredOff:
          {
            _bluetoothReadyController.add(false);
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
    currentList.clear();
    _bluetoothReady = await QuickBlue.isBluetoothAvailable();
    if (_bluetoothReady) {
      print("DONE + ${_bluetoothReady}");
      QuickBlue.startScan();
      _handleScanResults();
      _scanTimeout =
          Timer(const Duration(seconds: scanInterval), () => stopScan());
    }
  }

  Future<void> stopScan() async {
    QuickBlue.stopScan();
    _scanTimeout?.cancel();
    _scanFinishedController.add(true);
    _scanResultSubscription?.cancel();
  }
}
