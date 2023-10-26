import 'dart:typed_data';

class BlocScanResult {
  final Uint8List? manufacturerData;
  final int rssi;

  BlocScanResult(
    this.manufacturerData,
    this.rssi,
  );
}
