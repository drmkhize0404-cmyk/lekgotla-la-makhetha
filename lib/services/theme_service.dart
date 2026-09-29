import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppColorPalette {
  heritageGold,
  roseGrace,
  darkObsidian,
  africanEmerald,
  sapphireBlue,
  forestWhisper,
  whitePearl,
  sunsetAmber,
  oceanBreeze,
  lavenderDream,
  peachBlush,
}

class ThemeService {
  static final ThemeService _instance = ThemeService._internal();
  factory ThemeService() => _instance;
  ThemeService._internal();

  static const String _paletteKey = 'makhetha_selected_palette';

  final ValueNotifier<AppColorPalette> currentPalette =
      ValueNotifier<AppColorPalette>(AppColorPalette.heritageGold);

  Future<void> initTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedName = prefs.getString(_paletteKey);
      if (savedName != null) {
        currentPalette.value = AppColorPalette.values.firstWhere(
          (p) => p.name == savedName,
          orElse: () => AppColorPalette.heritageGold,
        );
      }
    } catch (_) {}
  }

  Future<void> setPalette(AppColorPalette palette) async {
    currentPalette.value = palette;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_paletteKey, palette.name);
    } catch (_) {}
  }

  ThemeData getThemeData(AppColorPalette palette) {
    final bool isDark = palette == AppColorPalette.darkObsidian;
    final Color primaryColor = getPaletteColor(palette);

    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: isDark ? const Color(0xFF080C15) : const Color(0xFFFBF8F5),
      cardColor: isDark ? const Color(0xFF111827) : Colors.white,
      dividerColor: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0),
      colorScheme: isDark
          ? ColorScheme.dark(
              primary: primaryColor,
              secondary: const Color(0xFF3B82F6),
              surface: const Color(0xFF111827),
            )
          : ColorScheme.light(
              primary: primaryColor,
              secondary: const Color(0xFFD97706),
              surface: Colors.white,
            ),
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? const Color(0xFF080C15) : Colors.white,
        foregroundColor: isDark ? Colors.white : const Color(0xFF26180B),
        elevation: 0,
      ),
      textTheme: GoogleFonts.interTextTheme(
        isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme,
      ),
    );
  }

  static String getPaletteName(AppColorPalette palette) {
    switch (palette) {
      case AppColorPalette.heritageGold:
        return "Royal Heritage Gold (Default)";
      case AppColorPalette.roseGrace:
        return "Rose Grace & Champagne";
      case AppColorPalette.darkObsidian:
        return "Midnight Obsidian & Gold";
      case AppColorPalette.africanEmerald:
        return "African Emerald";
      case AppColorPalette.sapphireBlue:
        return "Sapphire Twilight";
      case AppColorPalette.forestWhisper:
        return "Forest Whisper";
      case AppColorPalette.whitePearl:
        return "White Pearl & Teal";
      case AppColorPalette.sunsetAmber:
        return "Sunset Amber";
      case AppColorPalette.oceanBreeze:
        return "Ocean Breeze";
      case AppColorPalette.lavenderDream:
        return "Lavender Dream";
      case AppColorPalette.peachBlush:
        return "Peach Blush";
    }
  }

  static Color getPaletteColor(AppColorPalette palette) {
    switch (palette) {
      case AppColorPalette.heritageGold:
        return const Color(0xFFB45309);
      case AppColorPalette.roseGrace:
        return const Color(0xFF881337);
      case AppColorPalette.darkObsidian:
        return const Color(0xFFF59E0B);
      case AppColorPalette.africanEmerald:
        return const Color(0xFF064E3B);
      case AppColorPalette.sapphireBlue:
        return const Color(0xFF1D4ED8);
      case AppColorPalette.forestWhisper:
        return const Color(0xFF4C1D95);
      case AppColorPalette.whitePearl:
        return const Color(0xFF0F766E);
      case AppColorPalette.sunsetAmber:
        return const Color(0xFFF97316);
      case AppColorPalette.oceanBreeze:
        return const Color(0xFF0284C7);
      case AppColorPalette.lavenderDream:
        return const Color(0xFF7C3AED);
      case AppColorPalette.peachBlush:
        return const Color(0xFFEA580C);
    }
  }
}