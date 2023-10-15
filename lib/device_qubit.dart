import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_blue/quick_blue.dart';
import 'constants/constants.dart';

class DeviceBloc extends Cubit<List<BlueScanResult>> {
  DeviceBloc() : super([]);
  StreamSubscription<BlueScanResult>? _scanResultSubscription;

  void startScanning() {
    _scanResultSubscription?.cancel();
    _handleScanResults();
    QuickBlue.startScan();
  }

  void _handleScanResults() {
    emit([]);
    _scanResultSubscription = QuickBlue.scanResultStream.listen((device) {
      final currentList = List<BlueScanResult>.from(state);
      final deviceIndex =
          currentList.indexWhere((d) => d.deviceId == device.deviceId);

      if (device.rssi > rssiThreshold) {
        if ((deviceIndex == -1)) {
          currentList.add(device);
        } else {
          currentList[deviceIndex] = device;
        }
      } else if (deviceIndex != -1) {
        currentList.removeAt(deviceIndex);
      }
      emit(currentList);
    });
  }

  void stopScanning() {
    _scanResultSubscription?.cancel();
    QuickBlue.stopScan();
  }

  @override
  Future<void> close() {
    stopScanning();
    return super.close();
  }
}
