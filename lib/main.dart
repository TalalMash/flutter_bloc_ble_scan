import 'package:flutter/material.dart';
import 'package:flutter_draft/repo/ble_device_scan.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_draft/bloc/bloc/device_bloc_bloc.dart';
// import 'package:quick_blue/quick_blue.dart';

void main() {
  Bloc.observer = AppBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => BluetoothRepository(),
      child: BlocProvider(
        create: (context) => DeviceBloc(
            bleRepo: RepositoryProvider.of<BluetoothRepository>(context)),
        child: const MaterialApp(
          home: DeviceListScreen(),
        ),
      ),
    );
  }
}

class DeviceListScreen extends StatefulWidget {
  const DeviceListScreen({super.key});

  @override
  DeviceListScreenState createState() => DeviceListScreenState();
}

class DeviceListScreenState extends State<DeviceListScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      context.read<DeviceBloc>().add(DeviceBlocPaused());
    } else if (state == AppLifecycleState.resumed) {
      context.read<DeviceBloc>().add(DeviceBlocResumed());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Devices'),
      ),
      body: BlocBuilder<DeviceBloc, DeviceBlocState>(
        builder: (context, state) {
          context
              .read<DeviceBloc>()
              .add(DeviceBlocStarted(deviceList: state.deviceList));
          return ListView.builder(
            itemCount: state.deviceList.length,
            itemBuilder: (context, index) {
              final device = state.deviceList[index];
              return ListTile(
                title: Text(
                    "${device.name.toString()} - ${device.deviceId.toString()}"),
                subtitle: Text("Signal: ${device.rssi.toString()}"),
              );
            },
          );
        },
      ),
    );
  }
}

/// Custom [BlocObserver] that observes all bloc and cubit state changes.
class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (bloc is Cubit) debugPrint(change.toString());
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    debugPrint(transition.toString());
  }
}
