import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bugun_ne_yiyelim/constants/app_constants.dart';

class AppTheme {
  // Ana renkler
  static const Color primaryColor =
      Color(0xFFE65100); // Koyu turuncu (yemek için)
  static const Color errorColor = Color(0xFFC62828); // Koyu kırmızı
  static const Color textLightColor = Color(0xFF757575);
  static const Color backgroundColor =
      Color(0xFFFAFAFA); // Açık gri arka plan rengi

  // Mod renkleri - Daha soft ve modern tonlar
  static const Map<String, Color> modeColors = {
    AppConstants.modeNormal: Color(0xFFE65100), // Koyu turuncu
    AppConstants.modeSports: Color(0xFF2E7D32), // Koyu yeşil
    AppConstants.modeDiet: Color(0xFFF9A825), // Amber tonu
    AppConstants.modeCulture: Color(0xFF6A1B9A), // Koyu mor
  };

  // Gradient renkleri
  static Map<String, List<Color>> modeGradients = {
    AppConstants.modeNormal: [
      const Color(0xFFE65100),
      const Color(0xFFEF6C00),
    ],
    AppConstants.modeSports: [
      const Color(0xFF2E7D32),
      const Color(0xFF388E3C),
    ],
    AppConstants.modeDiet: [
      const Color(0xFFF9A825),
      const Color(0xFFFBC02D),
    ],
    AppConstants.modeCulture: [
      const Color(0xFF6A1B9A),
      const Color(0xFF7B1FA2),
    ],
  };

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      error: errorColor,
      background: Colors.grey[50]!,
      surface: Colors.white,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: primaryColor,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    cardTheme: CardTheme(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.resolveWith<TextStyle>((states) {
          return const TextStyle(fontSize: 14);
        }),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      elevation: 8,
      backgroundColor: Colors.white,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey[400],
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
    ),
  );
}
