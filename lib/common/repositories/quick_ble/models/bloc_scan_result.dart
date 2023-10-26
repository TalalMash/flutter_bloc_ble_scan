import 'dart:typed_data';

class BlocScanResult {
  final Uint8List? manufacturerData;
  final String name;
  final String deviceId;
  final int rssi;

  BlocScanResult(
    this.manufacturerData,
    this.name,
    this.deviceId,
    this.rssi,
  );
}
