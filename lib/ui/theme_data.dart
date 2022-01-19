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
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0)),
            primary: Colors.greenAccent[400],
            textStyle:
                const TextStyle(fontSize: 15, fontFamily: 'Times New Roman')),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.zero),
      ));

  static ThemeData darkTheme = ThemeData(
      fontFamily: 'Times New Roman',
      scaffoldBackgroundColor: Colors.black,
      colorScheme: const ColorScheme.dark(),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
      ));
}
