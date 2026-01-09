import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum AppThemeMode { light, dark }

class ThemeState extends Equatable {
  final ThemeMode themeMode;
  final AppThemeMode appThemeMode;

  const ThemeState({
    required this.themeMode,
    required this.appThemeMode,
  });

  const ThemeState.initial()
      : themeMode = ThemeMode.light,
        appThemeMode = AppThemeMode.light;

  ThemeState copyWith({
    ThemeMode? themeMode,
    AppThemeMode? appThemeMode,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      appThemeMode: appThemeMode ?? this.appThemeMode,
    );
  }

  @override
  List<Object?> get props => [themeMode, appThemeMode];
}
