// import 'dart:async';
// import 'package:flutter_application_1/repo/ble_device_scan.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:quick_blue/quick_blue.dart';

// class DeviceBloc extends Cubit<List<BlueScanResult>> {
//   final BluetoothRepository _bluetoothRepository = BluetoothRepository();

//   DeviceBloc() : super([]) {
//     _bluetoothRepository.scanResults.listen((devices) {
//       emit(devices);
//     });
//   }
//   void startScanning() async {
//     await _bluetoothRepository.startScanning();
//   }

//   void stopScanning() async {
//     await _bluetoothRepository.stopScanning();
//   }

//   @override
//   Future<void> close() {
//     stopScanning();
//     return super.close();
//   }
// }
