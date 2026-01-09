import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudz/core/local_database/local_database_service.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final LocalDatabaseService _localDatabase;

  ThemeBloc(this._localDatabase) : super(const ThemeState.initial()) {
    on<LoadThemeEvent>(_onLoadTheme);
    on<ToggleThemeEvent>(_onToggleTheme);
    on<SetThemeEvent>(_onSetTheme);

    // Load theme on initialization
    add(const LoadThemeEvent());
  }

  Future<void> _onLoadTheme(
    LoadThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    final savedTheme = _localDatabase.getTheme();
    if (savedTheme != null) {
      final isDark = savedTheme == 'dark';
      emit(ThemeState(
        themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
        appThemeMode: isDark ? AppThemeMode.dark : AppThemeMode.light,
      ));
    }
  }

  Future<void> _onToggleTheme(
    ToggleThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    final isDark = state.themeMode == ThemeMode.dark;
    final newThemeMode = isDark ? ThemeMode.light : ThemeMode.dark;
    final newAppThemeMode = isDark ? AppThemeMode.light : AppThemeMode.dark;

    emit(ThemeState(
      themeMode: newThemeMode,
      appThemeMode: newAppThemeMode,
    ));

    // Save to local storage
    await _localDatabase.saveTheme(isDark ? 'light' : 'dark');
  }

  Future<void> _onSetTheme(
    SetThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    final isDark = event.themeMode == AppThemeMode.dark;
    emit(ThemeState(
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      appThemeMode: event.themeMode,
    ));

    // Save to local storage
    await _localDatabase.saveTheme(isDark ? 'dark' : 'light');
  }

  bool get isDarkMode => state.themeMode == ThemeMode.dark;
}
