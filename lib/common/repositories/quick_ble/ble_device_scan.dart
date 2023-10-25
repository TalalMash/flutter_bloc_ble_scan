import 'dart:async';
import 'package:quick_blue/quick_blue.dart';
import 'package:flutter_draft/common/constants/constants.dart';

part 'ble_scan_results.dart';

class BluetoothRepository {
  Stream<List<BlueScanResult>> get scanResults => _scanResultController.stream;
  Stream<bool> get scanFinished => _scanFinishedController.stream;
  StreamSubscription<AvailabilityState>? _availabilitySubscription;

  final _scanFinishedController = StreamController<bool>.broadcast();
  late Timer _scanTimeout;

  Future<void> startScan() async {
    currentList.clear();
    QuickBlue.availabilityChangeStream.listen((state) async {
      if (state == AvailabilityState.poweredOn &&
          await QuickBlue.isBluetoothAvailable()) {
        QuickBlue.startScan();
        print("Scan STARTED");
      }
    });
    _handleScanResults();
    _scanTimeout =
        Timer(const Duration(seconds: scanInterval), () => stopScan());
  }

  Future<void> stopScan() async {
    QuickBlue.stopScan();
    _scanTimeout.cancel();
    _scanFinishedController.add(true);
    _scanResultSubscription?.cancel();
    _availabilitySubscription?.cancel();
  }
}
