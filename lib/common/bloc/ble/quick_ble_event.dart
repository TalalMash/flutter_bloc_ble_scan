part of 'quick_ble_bloc.dart';

@immutable
sealed class DeviceBlocEvent {
  const DeviceBlocEvent();
}

final class DeviceBlocScanUpdates extends DeviceBlocEvent {
  const DeviceBlocScanUpdates({required this.deviceList});
  final List<BlueScanResult> deviceList;
}

final class DeviceBlocScanStopped extends DeviceBlocEvent {}

final class DeviceBlocScanStarted extends DeviceBlocEvent {}
