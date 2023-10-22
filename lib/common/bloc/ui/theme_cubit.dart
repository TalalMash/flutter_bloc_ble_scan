import 'package:flutter_draft/common/common.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(_lightTheme);
  static final _lightTheme = ThemeData.light(useMaterial3: true);
  static final _darkTheme = ThemeData.dark(useMaterial3: true);

  void toggleTheme() {
    emit(state.brightness == Brightness.dark ? _lightTheme : _darkTheme);
  }
}
