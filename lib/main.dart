import 'package:flutter_draft/common/common.dart';
import 'package:quick_blue/quick_blue.dart';

void main() {
  Bloc.observer = AppBlocObserver();
  runApp(const MyApp());
  QuickBlue.availabilityChangeStream.listen((state) {
    debugPrint('Bluetooth state: ${state.toString()}');
  });
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
