part of 'ble_device_scan.dart';

StreamSubscription<BlueScanResult>? _scanResultSubscription;

final StreamController<List<BlueScanResult>> _scanResultController =
    StreamController<List<BlueScanResult>>.broadcast();

List<BlueScanResult> currentList = [];

void _handleScanResults() {
  _scanResultSubscription = QuickBlue.scanResultStream.listen((device) {
    final deviceIndex =
        currentList.indexWhere((d) => d.deviceId == device.deviceId);

    if (device.rssi > rssiThreshold) {
      if (deviceIndex == -1) {
        currentList.add(device);
      } else {
        currentList[deviceIndex] = device;
      }
    } else if (deviceIndex != -1) {
      currentList.removeAt(deviceIndex);
    }
    _scanResultController.add(currentList.toList());
  });
}
