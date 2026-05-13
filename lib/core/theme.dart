import 'package:flutter/material.dart';

class NoctosTheme {
  NoctosTheme._();

  static const _seed = Color(0xFF6E5B3F); // warm amber, low-blue
  static const _surfaceDim = Color(0xFF14110D);
  static const _surface = Color(0xFF1B1815);
  static const _onSurface = Color(0xFFE9DDC9);
  static const _muted = Color(0xFFB8A98F);

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.dark,
    ).copyWith(
      surface: _surface,
      surfaceContainerLowest: _surfaceDim,
      surfaceContainer: const Color(0xFF22201C),
      surfaceContainerHigh: const Color(0xFF2A2723),
      onSurface: _onSurface,
      onSurfaceVariant: _muted,
      primary: const Color(0xFFD9B68A),
      onPrimary: const Color(0xFF38240A),
      secondary: const Color(0xFFB89881),
      tertiary: const Color(0xFFA68A6B),
    );
    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      scaffoldBackgroundColor: scheme.surfaceContainerLowest,
      textTheme: _textTheme(scheme.onSurface),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surfaceContainerLowest,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainer,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainer,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      listTileTheme: ListTileThemeData(
        tileColor: scheme.surfaceContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outline.withValues(alpha: 0.2),
        space: 1,
        thickness: 1,
      ),
    );
  }

  static TextTheme _textTheme(Color onSurface) {
    return TextTheme(
      displayLarge: TextStyle(color: onSurface, fontWeight: FontWeight.w300, fontSize: 48),
      headlineMedium: TextStyle(color: onSurface, fontWeight: FontWeight.w500, fontSize: 24),
      titleLarge: TextStyle(color: onSurface, fontWeight: FontWeight.w600, fontSize: 20),
      titleMedium: TextStyle(color: onSurface, fontWeight: FontWeight.w500, fontSize: 16),
      bodyLarge: TextStyle(color: onSurface, fontSize: 16, height: 1.4),
      bodyMedium: TextStyle(color: onSurface, fontSize: 14, height: 1.4),
      labelLarge: TextStyle(color: onSurface, fontSize: 14, fontWeight: FontWeight.w600),
    );
  }
}
