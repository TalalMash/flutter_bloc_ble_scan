import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_draft/repo/ble_device_scan.dart';
import 'package:meta/meta.dart';
import 'package:quick_blue/quick_blue.dart';

part 'device_bloc_event.dart';
part 'device_bloc_state.dart';

class DeviceBloc extends Bloc<DeviceBlocEvent, DeviceBlocState> {
  final BluetoothRepository _bleRepo;
  StreamSubscription<List<BlueScanResult>>? _repoSubscription;
  static final List<BlueScanResult> _deviceList = [];

  DeviceBloc({required BluetoothRepository bleRepo})
      : _bleRepo = bleRepo,
        super(DeviceBlocInitial(_deviceList)) {
    _bleRepo.startScan();
    on<DeviceBlocStarted>(_onStarted);
    on<DeviceBlocPaused>(_onPause);
    on<DeviceBlocResumed>(_onResume);
  }

  void _onPause(DeviceBlocPaused event, Emitter<DeviceBlocState> emit) {
    emit(const DeviceBlocStart([]));
    _bleRepo.stopScan();
  }

  void _onResume(DeviceBlocResumed event, Emitter<DeviceBlocState> emit) {
    _bleRepo.startScan();
  }

  @override
  Future<void> close() {
    _repoSubscription?.cancel();
    _bleRepo.stopScan();
    return super.close();
  }

  void _onStarted(DeviceBlocStarted event, Emitter<DeviceBlocState> emit) {
    emit(DeviceBlocStart(event.deviceList));
    _repoSubscription?.cancel();
    _repoSubscription = _bleRepo.scanResults
        .listen((devices) => add(DeviceBlocStarted(deviceList: devices)));
  }
}
