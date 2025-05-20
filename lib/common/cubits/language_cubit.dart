import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageCubit extends Cubit<Locale> {
  static const _kLanguageKey = 'language';

  LanguageCubit() : super(Locale('en')) {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final isEN = prefs.getBool(_kLanguageKey) ?? false;
    emit(Locale(isEN ? 'en' : 'vi'));
  }

  Future<void> changeLanguage() async {
    final newTheme = state == Locale('en') ? Locale('vi') : Locale('en');
    emit(newTheme);
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_kLanguageKey, newTheme == Locale('en'));
  }
}
