import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeClass {
  ThemeClass();

  static ThemeData lightTheme = ThemeData(
    fontFamily: 'San Francisco',
    scaffoldBackgroundColor: Colors.grey[250],
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.greenAccent[400],
    ),
    // Main text color.
    primaryColor: Colors.black,
    // Top-most sliver color.
    secondaryHeaderColor: Colors.black,
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
    fontFamily: 'San Francisco',
    scaffoldBackgroundColor: Colors.black54,
    colorScheme: const ColorScheme.dark(),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.greenAccent[400],
    ),
    primaryColor: Colors.black,
    secondaryHeaderColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[800],
    ),
    buttonTheme: const ButtonThemeData(
      textTheme: ButtonTextTheme.accent,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      elevation: 20,
      type: BottomNavigationBarType.fixed,
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
