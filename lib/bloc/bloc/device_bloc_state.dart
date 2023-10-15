part of 'device_bloc_bloc.dart';

@immutable
sealed class DeviceBlocState extends Equatable {
  const DeviceBlocState(this.deviceList);
  final List<BlueScanResult> deviceList;

  @override
  List<Object> get props => [deviceList];
}

final class DeviceBlocInitial extends DeviceBlocState {
  const DeviceBlocInitial(super.deviceList);
}

final class DeviceBlocStart extends DeviceBlocState {
  const DeviceBlocStart(super.deviceList);
}

final class DeviceBlocStop extends DeviceBlocState {
  const DeviceBlocStop(super.deviceList);
}
