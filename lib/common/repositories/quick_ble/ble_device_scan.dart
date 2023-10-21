import 'dart:async';
import 'package:quick_blue/quick_blue.dart';
import 'package:flutter_draft/common/constants/constants.dart';

part 'ble_scan_results.dart';

class BluetoothRepository {
  Stream<List<BlueScanResult>> get scanResults => _scanResultController.stream;
  Stream<bool> get scanFinished => _scanFinishedController.stream;
  final _scanFinishedController = StreamController<bool>.broadcast();

  Future<void> startScan() async {
    currentList.clear();
    await QuickBlue.startScan();
    _handleScanResults();
    await Future.delayed(const Duration(seconds: scanInterval), () {
      stopScan();
      _scanFinishedController.add(true);
    });
  }

  Future<void> stopScan() async {
    QuickBlue.stopScan();
    _scanResultSubscription?.cancel();
  }
}
