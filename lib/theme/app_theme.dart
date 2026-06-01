import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ─── DARK THEME COLORS ─────────────────────────────────────
  static const Color background = Color(0xFF111424);
  static const Color surface = Color(0xFF1E2235);
  static const Color surfaceHighlight = Color(0xFF282D45);

  // ─── LIGHT THEME COLORS (warm beige/cream) ─────────────────
  static const Color lightBackground = Color(0xFFFFF8EC);
  static const Color lightSurface = Color(0xFFFFF1DB);
  static const Color lightSurfaceHighlight = Color(0xFFE8DCC8);

  // Accents
  static const Color cyanAccent = Color(0xFF00E5FF);
  static const Color purpleAccent = Color(0xFFD500F9);
  static const Color pinkAccent = Color(0xFFFF4081);
  static const Color goldAccent = Color(0xFFFFD700);

  // Light theme accents (warm tones)
  static const Color lightPrimary = Color(0xFF546B41);
  static const Color lightSecondary = Color(0xFF99AD7A);
  static const Color lightAccent = Color(0xFFDCCCAC);
  static const Color lightWarm = Color(0xFFA68A5B);

  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF9E9E9E);
  static const Color lightTextPrimary = Color(0xFF2D2D2D);
  static const Color lightTextSecondary = Color(0xFF7A7A7A);

  // ─── DARK THEME ────────────────────────────────────────────
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: cyanAccent,
      canvasColor: background,
      fontFamily: GoogleFonts.outfit().fontFamily,
      textTheme: TextTheme(
        displayLarge: GoogleFonts.outfit(color: textPrimary, fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.outfit(color: textPrimary, fontWeight: FontWeight.bold),
        bodyLarge: GoogleFonts.outfit(color: textPrimary),
        bodyMedium: GoogleFonts.inter(color: textSecondary),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: 1.2,
        ),
        iconTheme: const IconThemeData(color: textPrimary),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: background,
        selectedItemColor: cyanAccent,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: surfaceHighlight,
        contentTextStyle: TextStyle(color: Colors.white),
      ),
    );
  }

  // ─── LIGHT THEME ───────────────────────────────────────────
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBackground,
      primaryColor: lightPrimary,
      canvasColor: lightBackground,
      fontFamily: GoogleFonts.outfit().fontFamily,
      textTheme: TextTheme(
        displayLarge: GoogleFonts.outfit(color: lightTextPrimary, fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.outfit(color: lightTextPrimary, fontWeight: FontWeight.bold),
        bodyLarge: GoogleFonts.outfit(color: lightTextPrimary),
        bodyMedium: GoogleFonts.inter(color: lightTextSecondary),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: lightBackground,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: lightTextPrimary,
          letterSpacing: 1.2,
        ),
        iconTheme: const IconThemeData(color: lightTextPrimary),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: lightBackground,
        selectedItemColor: lightPrimary,
        unselectedItemColor: lightTextSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: lightPrimary,
        contentTextStyle: const TextStyle(color: Colors.white),
      ),
    );
  }

  // ─── Adaptive color helpers ────────────────────────────────
  static Color bg(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? background : lightBackground;

  static Color srf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? surface : lightSurface;

  static Color srfH(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? surfaceHighlight : lightSurfaceHighlight;

  static Color txt(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? textPrimary : lightTextPrimary;

  static Color txtSec(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? textSecondary : lightTextSecondary;

  static Color accent1(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? cyanAccent : lightPrimary;

  static Color accent2(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? purpleAccent : lightSecondary;

  static Color accent3(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? pinkAccent : lightWarm;
}
