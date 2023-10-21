part of 'quick_ble_bloc.dart';

@immutable
sealed class DeviceBlocState extends Equatable {
  const DeviceBlocState(this.deviceList);
  final List<BlueScanResult> deviceList;

  @override
  List<Object> get props => [deviceList];
}

final class DeviceBlocScanResults extends DeviceBlocState {
  const DeviceBlocScanResults(super.deviceList);
}
