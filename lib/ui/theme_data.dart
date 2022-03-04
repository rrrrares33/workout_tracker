import 'package:flutter/material.dart';

class ThemeClass {
  static ThemeData lightTheme = ThemeData(
    fontFamily: 'Times New Roman',
    scaffoldBackgroundColor: Colors.grey[250],
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.grey,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      // 4
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
          primary: Colors.greenAccent[400],
          textStyle: const TextStyle(fontSize: 15, fontFamily: 'Times New Roman')),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.zero),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      elevation: 20,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white70,
      unselectedItemColor: Colors.black87,
      selectedItemColor: Colors.greenAccent[400],
      selectedIconTheme: IconThemeData(
        size: 25,
        color: Colors.greenAccent[400],
      ),
      unselectedIconTheme: const IconThemeData(
        size: 17.5,
      ),
      showSelectedLabels: true,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    fontFamily: 'Times New Roman',
    scaffoldBackgroundColor: Colors.black54,
    colorScheme: const ColorScheme.dark(),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[800],
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      elevation: 20,
      backgroundColor: Colors.black,
      unselectedItemColor: Colors.grey,
      selectedItemColor: Colors.greenAccent[400],
      selectedIconTheme: IconThemeData(
        size: 30,
        color: Colors.greenAccent[400],
      ),
      unselectedIconTheme: const IconThemeData(
        size: 25,
      ),
      showSelectedLabels: true,
    ),
  );
}
