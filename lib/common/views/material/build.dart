import 'package:flutter_draft/common/common.dart';
import 'package:flutter_draft/common/repositories/quick_ble/quick_ble.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => ThemeCubit(),
        child: RepositoryProvider(
          create: (context) => BluetoothRepository(),
          child: BlocProvider(
            create: (context) => DeviceBloc(
                bleRepo: RepositoryProvider.of<BluetoothRepository>(context)),
            child: const AppView(),
          ),
        ));
  }
}

class AppView extends StatelessWidget {
  /// {@macro app_view}
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeData>(
      builder: (_, theme) {
        return MaterialApp(
          theme: theme,
          home: const DeviceListScreen(),
        );
      },
    );
  }
}
