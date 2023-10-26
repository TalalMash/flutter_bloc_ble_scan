part of 'ble_device_scan.dart';

StreamSubscription<BlueScanResult>? _scanResultSubscription;

final StreamController<List<BlocScanResult>> _scanResultController =
    StreamController<List<BlocScanResult>>.broadcast();

List<BlueScanResult> currentList = [];
List<BlocScanResult> blocList = [];

void _handleScanResults() {
  _scanResultSubscription = QuickBlue.scanResultStream.listen((device) {
    final deviceIndex =
        currentList.indexWhere((d) => d.deviceId == device.deviceId);

    if (device.rssi > rssiThreshold) {
      if (deviceIndex == -1) {
        currentList.add((device));
      } else {
        currentList[deviceIndex] = device;
      }
    } else if (deviceIndex != -1) {
      currentList.removeAt(deviceIndex);
    }

    List<BlocScanResult> blocList = currentList.map((element) {
      return BlocScanResult(element.manufacturerData, element.rssi);
    }).toList();
    _scanResultController.add(blocList);
  });
}
