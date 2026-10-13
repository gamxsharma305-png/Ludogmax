import 'package:flutter/material.dart';

/// LUDO GENJI visual identity: dark fantasy, gold trim, crimson CTAs.
class GenjiTheme {
  // Backgrounds
  static const bgDeep = Color(0xFF0A0C16);
  static const bgMid = Color(0xFF12162A);
  static const bgCard = Color(0xFF1A2038);

  static LinearGradient get bgGradient => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF0A0C16), Color(0xFF141A33), Color(0xFF0A0C16)],
      );

  // Gold
  static const gold = Color(0xFFC9A227);
  static const goldLight = Color(0xFFE8C15A);
  static const goldDark = Color(0xFF8A6D1B);

  static LinearGradient get goldGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [goldLight, gold, goldDark],
      );

  // Accents
  static const crimson = Color(0xFFB91C1C);
  static const crimsonLight = Color(0xFFDC2626);
  static const magicBlue = Color(0xFF3B82F6);
  static const parchment = Color(0xFFF5EFE0);
  static const muted = Color(0xFF9AA3C0);

  static LinearGradient get crimsonGradient => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [crimsonLight, crimson],
      );

  // Teams (classic ludo, tuned for dark theme)
  static const teamRed = Color(0xFFD32F2F);
  static const teamGreen = Color(0xFF388E3C);
  static const teamYellow = Color(0xFFF9A825);
  static const teamBlue = Color(0xFF1976D2);

  static Color teamColor(int team) {
    switch (team) {
      case 0:
        return teamRed;
      case 1:
        return teamGreen;
      case 2:
        return teamYellow;
      default:
        return teamBlue;
    }
  }

  static String teamName(int team) {
    switch (team) {
      case 0:
        return 'Crimson';
      case 1:
        return 'Emerald';
      case 2:
        return 'Golden';
      default:
        return 'Azure';
    }
  }

  // Typography
  static const String fontFell = 'IM Fell English';

  static const TextStyle titleGold = TextStyle(
    fontFamily: fontFell,
    color: goldLight,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.2,
  );

  static const TextStyle heading = TextStyle(
    fontFamily: fontFell,
    color: parchment,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle body = TextStyle(
    color: parchment,
    fontSize: 14,
  );

  static const TextStyle bodyMuted = TextStyle(
    color: muted,
    fontSize: 13,
  );
}
