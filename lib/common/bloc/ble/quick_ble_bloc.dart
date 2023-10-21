import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_draft/common/repositories/quick_ble/quick_ble.dart';
import 'package:meta/meta.dart';
import 'package:quick_blue/quick_blue.dart';

part 'quick_ble_event.dart';
part 'quick_ble_state.dart';

class DeviceBloc extends Bloc<DeviceBlocEvent, DeviceBlocState> {
  final BluetoothRepository _bleRepo;
  StreamSubscription<List<BlueScanResult>>? _repoSubscription;
  static final List<BlueScanResult> _deviceList = [];

  DeviceBloc({required BluetoothRepository bleRepo})
      : _bleRepo = bleRepo,
        super(DeviceBlocScanResults(_deviceList)) {
    on<DeviceBlocScanUpdates>(
      (_, emit) => emit(DeviceBlocScanResults(_.deviceList)),
    );
    on<DeviceBlocScanStopped>(_onScanStop);
    on<DeviceBlocScanStarted>(_onScanStart);
  }

  void _onScanStop(_, emit) {
    _bleRepo.stopScan();
    _repoSubscription?.cancel();

    add(DeviceBlocScanUpdates(deviceList: _deviceList));
  }

  void _onScanStart(_, emit) {
    // Future.delayed(const Duration(milliseconds: 5500), () {
    _bleRepo.startScan();
    _repoSubscription?.cancel();
    _repoSubscription = _bleRepo.scanResults
        .listen((devices) => add(DeviceBlocScanUpdates(deviceList: devices)));
    // });
  }

  @override
  Future<void> close() {
    _repoSubscription?.cancel();
    _bleRepo.stopScan();
    return super.close();
  }
}
