import 'package:flutter_draft/common/common.dart';
import 'package:flutter_draft/common/repositories/quick_ble/quick_ble.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => BluetoothRepository(),
      child: BlocProvider(
        create: (context) => DeviceBloc(
            bleRepo: RepositoryProvider.of<BluetoothRepository>(context)),
        child: MaterialApp(
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: ThemeMode.system,
          home: const DeviceListScreen(),
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
    context.read<DeviceBloc>().add(DeviceBlocScanStarted());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      context.read<DeviceBloc>().add(DeviceBlocScanStopped());
    } else if (state == AppLifecycleState.resumed) {
      context.read<DeviceBloc>().add(DeviceBlocScanStarted());
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
          return ListView.builder(
            itemCount: state.deviceList.length,
            itemBuilder: (context, index) {
              final device = state.deviceList[index];
              return ListTile(
                title: Text("${device.manufacturerDataHead.toString()}"),
                subtitle: Text("Signal: ${device.rssi.toString()}"),
              );
            },
          );
        },
      ),
    );
  }
}
