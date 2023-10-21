import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:quick_blue/quick_blue.dart';
import 'package:flutter_draft/common/constants/constants.dart';

part 'ble_scan_results.dart';

class BluetoothRepository {
  Stream<List<BlueScanResult>> get scanResults => _scanResultController.stream;

  Future<void> startScan() async {
    currentList.clear();
    await QuickBlue.startScan();
    _handleScanResults();
    await Future.delayed(const Duration(seconds: scanInterval), () {
      stopScan();
      debugPrint("Scan completed");
    });
  }

  Future<void> stopScan() async {
    QuickBlue.stopScan();
    _scanResultSubscription?.cancel();
  }
}
