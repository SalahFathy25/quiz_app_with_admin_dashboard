import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/logic/settings/settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit()
    : super(const SettingsInitial(ThemeMode.system, Locale('en')));

  void changeTheme(ThemeMode themeMode) {
    emit(SettingsInitial(themeMode, state.locale));
  }

  void changeLocale(Locale locale) {
    emit(SettingsInitial(state.themeMode, locale));
  }
}
