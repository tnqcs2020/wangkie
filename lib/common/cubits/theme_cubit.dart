import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const _kThemeKey = 'theme_mode';

  ThemeCubit() : super(ThemeMode.light) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool(_kThemeKey) ?? false;
    emit(isDarkMode ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> toggleTheme() async {
    final newTheme = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    emit(newTheme);
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_kThemeKey, newTheme == ThemeMode.dark);
  }
}
