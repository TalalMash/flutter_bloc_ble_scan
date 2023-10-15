import 'dart:async';
import 'package:quick_blue/quick_blue.dart';
import 'package:flutter_application_1/constants/constants.dart';

part 'ble_scan_results.dart';

class BluetoothRepository {
  Stream<List<BlueScanResult>> get scanResults => _scanResultController.stream;

  Future<void> startScan() async {
    QuickBlue.stopScan();
    await QuickBlue.startScan();
    _scanResultSubscription?.cancel();
    _handleScanResults();
  }

  Future<void> stopScan() async {
    _scanResultSubscription?.cancel();
    QuickBlue.stopScan();
  }
}
