import 'package:flutter/material.dart';

abstract class Theme {
  static final _primaryDefault = Color(0xFF3F559E); 

  static final defaultTheme = ThemeData(
    primaryColor: _primaryDefault,
    scaffoldBackgroundColor: Color(0xFFFAFAFA),
    cardColor: Colors.white,
    inputDecorationTheme: InputDecorationTheme(
      fillColor: _primaryDefault,
      focusColor: _primaryDefault,
    ),
    accentColor: _primaryDefault,
    primaryIconTheme: IconThemeData(
      color: _primaryDefault,
    ),
    bottomAppBarColor: _primaryDefault,
    buttonColor: _primaryDefault,
    indicatorColor: _primaryDefault,
    splashColor: _primaryDefault,
    cursorColor: _primaryDefault,
    appBarTheme: AppBarTheme(
      color: _primaryDefault,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    bottomAppBarTheme: BottomAppBarTheme(
      color: _primaryDefault,
    ),
    iconTheme: IconThemeData(
      color: _primaryDefault,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: _primaryDefault,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _primaryDefault,
    ),
    toggleButtonsTheme: ToggleButtonsThemeData(
      color: _primaryDefault,
    ),
  );

  static Color primary = Color(0xFF825EE4);
  static Color secondary = Color(0xFFFFCD00);
  static Color tertiary = Color(0xFFF5E1A4);
  static Color primaryContrast = Colors.white;
  static Color primaryLight = primary.withOpacity(0.36);
  static Color primaryOpacity = Color(0xFFccbef4);
}