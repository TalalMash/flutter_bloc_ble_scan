import 'package:flutter_draft/common/common.dart';

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
    // context.read<DeviceBloc>().add(DeviceBlocScanStarted());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      //TODO replace this with applifcycle bloc
      context.read<DeviceBloc>().add(DeviceBlocScanStopped());
    } else if (state == AppLifecycleState.resumed) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Devices'),
      ),
      body: Center(
        child: BlocBuilder<DeviceBloc, DeviceBlocState>(
          builder: (context, state) {
            return ListView.builder(
              itemCount: state.deviceList.length,
              itemBuilder: (context, index) {
                final device = state.deviceList[index];
                return ListTile(
                  title: Text(device.manufacturerData.toString()),
                  subtitle: Text("Signal: ${device.rssi.toString()}"),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            child: const Icon(Icons.brightness_6),
            onPressed: () => context.read<ThemeCubit>().toggleTheme(),
          ),
          FloatingActionButton(
            child: const Icon(Icons.play_arrow),
            onPressed: () =>
                context.read<DeviceBloc>().add(DeviceBlocScanStarted()),
          ),
          FloatingActionButton(
            child: const Icon(Icons.stop),
            onPressed: () =>
                context.read<DeviceBloc>().add(DeviceBlocScanStopped()),
          )
        ],
      ),
    );
  }
}
