import 'dart:async';
import 'package:bloc_event_transformers/bloc_event_transformers.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_draft/common/repositories/quick_ble/models/bloc_scan_result.dart';
import 'package:flutter_draft/common/repositories/quick_ble/quick_ble.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_draft/common/common.dart';

part 'quick_ble_event.dart';
part 'quick_ble_state.dart';

class DeviceBloc extends Bloc<DeviceBlocEvent, DeviceBlocState> {
  final BluetoothRepository _bleRepo;
  StreamSubscription<List<BlocScanResult>>? _scanResultSubscription;
  StreamSubscription<bool>? _scanStatusSubscription;
  static final List<BlocScanResult> _deviceList = [];
  static const bool _scanStatus = false;

  DeviceBloc({required BluetoothRepository bleRepo})
      : _bleRepo = bleRepo,
        super(DeviceBlocScanResults(_deviceList, _scanStatus)) {
    _bleRepo.platformInterfaceInit();
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
    add(const DeviceBlocScanUpdates(deviceList: [], scanStatus: false));
    _bleRepo.startScan();
    _scanResultSubscription = _bleRepo.scanResults
        .throttleTime(const Duration(seconds: 2))
        .listen(
          (devices) => add(
              DeviceBlocScanUpdates(deviceList: devices, scanStatus: false)),
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
