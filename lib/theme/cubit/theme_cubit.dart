import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeInitial());
  void loadTheme() async {
    emit(ThemeLoading());
    await SharedPreferences.getInstance().then((prefs) {
      final themeMode = prefs.getString('themeMode') ?? 'ThemeMode.system';
      emit(ThemeLoaded(
          ThemeMode.values.firstWhere((e) => e.toString() == themeMode)));
    });
  }

  void setThemeMode(ThemeMode themeMode) async {
    emit(ThemeLoading());
    await SharedPreferences.getInstance().then((prefs) {
      prefs.setString('themeMode', themeMode.toString());
      emit(ThemeLoaded(themeMode));
    });
  }
}
