import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SettingsState extends Equatable {
  final ThemeMode themeMode;
  final Locale locale;

  const SettingsState(this.themeMode, this.locale);

  @override
  List<Object> get props => [themeMode, locale];
}

class SettingsInitial extends SettingsState {
  const SettingsInitial(ThemeMode themeMode, Locale locale)
    : super(themeMode, locale);
}
