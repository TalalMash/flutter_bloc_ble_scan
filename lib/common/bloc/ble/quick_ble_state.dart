part of 'quick_ble_bloc.dart';

@immutable
sealed class DeviceBlocState extends Equatable {
  const DeviceBlocState(this.deviceList, this.scanStatus);
  final List<BlocScanResult> deviceList;
  final bool scanStatus;

  @override
  List<Object> get props => [deviceList, scanStatus];
}

final class DeviceBlocScanResults extends DeviceBlocState {
  const DeviceBlocScanResults(super.deviceList, super.scanStatus);
}
