import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_draft/common/repositories/quick_ble/quick_ble.dart';
import 'package:quick_blue/quick_blue.dart';
import 'package:flutter_draft/common/common.dart';

part 'quick_ble_event.dart';
part 'quick_ble_state.dart';

class DeviceBloc extends Bloc<DeviceBlocEvent, DeviceBlocState> {
  final BluetoothRepository _bleRepo;
  StreamSubscription<List<BlueScanResult>>? _scanResultSubscription;
  StreamSubscription<bool>? _scanStatusSubscription;
  static final List<BlueScanResult> _deviceList = [];
  static const bool _scanStatus = false;

  DeviceBloc({required BluetoothRepository bleRepo})
      : _bleRepo = bleRepo,
        super(DeviceBlocScanResults(_deviceList, _scanStatus)) {
    on<DeviceBlocScanUpdates>(
      (_, emit) => emit(DeviceBlocScanResults(_.deviceList, _.scanStatus)),
    );
    on<DeviceBlocScanStopped>(_onScanStop);
    on<DeviceBlocScanStarted>(_onScanStart);
  }

  void _onScanStop(_, emit) {
    _bleRepo.stopScan();
    _scanResultSubscription?.cancel();
    _scanStatusSubscription?.cancel();
  }

  void _onScanStart(_, emit) {
    _bleRepo.startScan();
    _onScanStop;
    _scanResultSubscription = _bleRepo.scanResults.listen(
      (devices) =>
          add(DeviceBlocScanUpdates(deviceList: devices, scanStatus: false)),
    );
    _scanStatusSubscription = _bleRepo.scanFinished.listen((status) {
      add(DeviceBlocScanUpdates(
          deviceList: state.deviceList, scanStatus: status));
    });
  }

  @override
  Future<void> close() {
    _onScanStop;
    return super.close();
  }
}
