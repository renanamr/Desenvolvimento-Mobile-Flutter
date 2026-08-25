import 'package:flutter/material.dart';

class DSGovTheme {
  // Paleta de Cores DS Gov (Padrão Digital de Governo)
  static const Color primary = Color(0xFF1351B4); // blue-warm-vivid-70
  static const Color primaryDark = Color(0xFF0C326F);
  static const Color background = Color(0xFFF8F8F8); // gray-warm-2
  static const Color surface = Colors.white;
  
  static const Color success = Color(0xFF168821); // green-cool-vivid-50
  static const Color warning = Color(0xFFFFCD07); // yellow-vivid-20
  static const Color error = Color(0xFFE52207);   // red-vivid-50
  static const Color info = Color(0xFF155BCB);    // blue-warm-vivid-60
  
  static const Color grayDark = Color(0xFF333333);
  static const Color grayMedium = Color(0xFF888888);
  static const Color grayLight = Color(0xFFE6E6E6);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: primaryDark,
        surface: background,
        error: error,
        onPrimary: Colors.white,
        onSurface: grayDark,
      ),
      scaffoldBackgroundColor: background,
      
      // Estilização da AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),

      // Estilização dos Botões
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Estilização dos Campos de Texto (Inputs)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        labelStyle: const TextStyle(color: grayDark),
        hintStyle: const TextStyle(color: grayMedium),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: grayLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: grayLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: error),
        ),
      ),

      // Estilização dos Cards
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
      ),

      // Tipografia
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: grayDark, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(color: grayDark, fontWeight: FontWeight.bold, fontSize: 18),
        bodyLarge: TextStyle(color: grayDark, fontSize: 16),
        bodyMedium: TextStyle(color: grayDark, fontSize: 14),
      ),
      
      // Estilização do ListTile (usado no histórico)
      listTileTheme: const ListTileThemeData(
        iconColor: primary,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: grayDark,
          fontSize: 16,
        ),
        subtitleTextStyle: TextStyle(
          color: grayMedium,
          fontSize: 14,
        ),
      ),

      // Estilização dos Diálogos
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: const TextStyle(
          color: primary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      // Estilização dos TextButtons (usados em diálogos)
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
