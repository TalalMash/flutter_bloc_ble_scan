part of 'quick_ble_bloc.dart';

@immutable
sealed class DeviceBlocEvent {
  const DeviceBlocEvent();
}

final class DeviceBlocStarted extends DeviceBlocEvent {
  const DeviceBlocStarted({required this.deviceList});
  final List<BlueScanResult> deviceList;
}

final class DeviceBlocPaused extends DeviceBlocEvent {}

final class DeviceBlocResumed extends DeviceBlocEvent {}
