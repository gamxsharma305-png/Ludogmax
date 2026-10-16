import 'package:flutter/material.dart';
import '../theme/genji_theme.dart';
import '../services/store.dart';
import '../services/sound_service.dart';
import '../widgets/genji_widgets.dart';
import 'player_selection_screen.dart';
import 'avatar_screen.dart';
import 'pro_screen.dart';
import 'stats_screen.dart';
import 'spin_screen.dart';
import 'shop_screen.dart';
import 'rewards_screen.dart';
import 'tournaments_screen.dart';
import 'settings_screen.dart';
import 'online_screen.dart';

/// The Ludo Genji Main Hub — EXACT match to reference image:
/// 2-column stone-tile grid, gold borders, Pro banner, 4-icon bottom nav.
class MainHubScreen extends StatefulWidget {
  const MainHubScreen({super.key});

  @override
  State<MainHubScreen> createState() => _MainHubScreenState();
}

class _MainHubScreenState extends State<MainHubScreen> {
  int _bottomIndex = 0;

  @override
  Widget build(BuildContext context) {
    final tiles = [
      _Tile('Computer', Icons.computer_rounded, () {
        _go(const PlayerSelectionScreen(vsComputer: true));
      }),
      _Tile('Pass and Play', Icons.casino_rounded, () {
        _go(const PlayerSelectionScreen(vsComputer: false));
      }),
      _Tile('Online\nMultiplayer', Icons.groups_rounded, () {
        _go(const OnlineScreen());
      }),
      _Tile('Tournaments', Icons.emoji_events_rounded, () {
        _go(const TournamentsScreen());
      }),
      _Tile('Leaderboard', Icons.leaderboard_rounded, () {
        _go(const StatsScreen());
      }),
      _Tile('Shop', Icons.storefront_rounded, () {
        _go(const ShopScreen());
      }),
      _Tile('Daily Spin', Icons.autorenew_rounded, () {
        _go(const SpinScreen());
      }),
      _Tile('Rewards', Icons.card_giftcard_rounded, () {
        _go(const RewardsScreen());
      }),
      _Tile('Settings', Icons.settings_rounded, () {
        _go(const SettingsScreen());
      }),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0A0C16),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0D101F),
              Color(0xFF0A0C16),
              Color(0xFF080A12),
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Top title bar — "Ludo Genji" centered, gear top-right.
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
                child: Row(
                  children: [
                    const Spacer(),
                    Text(
                      'Ludo Genji',
                      style: GenjiTheme.titleGold.copyWith(
                        fontSize: 28,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => _go(const SettingsScreen()),
                      child: const Icon(
                        Icons.settings_rounded,
                        color: GenjiTheme.goldLight,
                        size: 26,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // 2-COLUMN stone-tile grid (reference layout).
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 1.35,
                    ),
                    itemCount: tiles.length,
                    itemBuilder: (_, i) => _stoneTile(tiles[i]),
                  ),
                ),
              ),
              // Pro membership banner — dark maroon + gold emblem.
              GestureDetector(
                onTap: () =>
                    _go(const ProScreen()).then((_) => setState(() {})),
                child: Container(
                  margin: const EdgeInsets.fromLTRB(16, 6, 16, 12),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFF3D1A1A),
                        Color(0xFF2A1212),
                        Color(0xFF1A0E0E),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: GenjiTheme.gold.withOpacity(0.6),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Ornate emblem — Pro knight image, gold ring fallback.
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: GenjiTheme.gold, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: GenjiTheme.gold.withOpacity(0.4),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/pro/genji_pro_knight.png',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFE8C15A),
                                    Color(0xFF8A6D1B)
                                  ],
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  'G',
                                  style: TextStyle(
                                    color: Color(0xFF1A1206),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    fontFamily: 'IM Fell English',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ludo Genji Pro',
                              style: TextStyle(
                                fontFamily: GenjiTheme.fontFell,
                                color: GenjiTheme.goldLight,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Membership Benefits',
                              style: GenjiTheme.bodyMuted
                                  .copyWith(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: GenjiTheme.goldLight.withOpacity(0.9),
                        size: 26,
                      ),
                    ],
                  ),
                ),
              ),
              // Bottom navigation — 4 icons (reference): Home, Grid, Heart, Person.
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF080A12),
                  border: Border(
                    top: BorderSide(
                      color: GenjiTheme.gold.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _navItem(Icons.home_rounded, 0, () {}),
                      _navItem(Icons.grid_view_rounded, 1, () {
                        // Grid = main hub (already here).
                        setState(() => _bottomIndex = 1);
                      }),
                      _navItem(Icons.favorite_rounded, 2, () {
                        _go(const RewardsScreen());
                      }),
                      _navItem(Icons.person_rounded, 3, () {
                        _go(const AvatarScreen())
                            .then((_) => setState(() {}));
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, int index, VoidCallback onTap) {
    final active = _bottomIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() => _bottomIndex = index);
        onTap();
      },
      child: Icon(
        icon,
        color: active ? GenjiTheme.goldLight : GenjiTheme.muted,
        size: 28,
      ),
    );
  }

  Future<void> _go(Widget page) {
    return Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => page));
  }

  /// Stone-textured tile — EXACT reference match:
  /// dark slate-stone gradient, warm GOLD border, parchment icon + label.
  Widget _stoneTile(_Tile tile) {
    return GestureDetector(
      onTap: () {
        SoundService().play('click');
        tile.onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          // Layered stone gradient: dark slate with warm undertones.
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2E3247),
              Color(0xFF22263A),
              Color(0xFF1A1E2E),
              Color(0xFF141726),
            ],
            stops: [0.0, 0.4, 0.75, 1.0],
          ),
          // Warm GOLD border (reference has amber-gold, not gray).
          border: Border.all(
            color: const Color(0xFFB8860B).withOpacity(0.75),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
            // Top highlight — stone edge catching light.
            BoxShadow(
              color: Colors.white.withOpacity(0.06),
              blurRadius: 2,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Subtle stone texture: faint diagonal streaks.
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: CustomPaint(
                  painter: _StoneTexturePainter(),
                ),
              ),
            ),
            // Icon + label centered.
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    tile.icon,
                    color: const Color(0xFFF5EFE0).withOpacity(0.92),
                    size: 38,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    tile.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFFF5EFE0),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      height: 1.15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Paints faint stone-grain streaks over a tile for the rough slate look.
class _StoneTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..strokeWidth = 1.0;
    // Diagonal streaks.
    for (var i = 0; i < 8; i++) {
      final y = size.height * (i / 8);
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y + size.height * 0.15),
        paint,
      );
    }
    // Darker patches for stone variation.
    final dark = Paint()..color = Colors.black.withOpacity(0.08);
    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.3),
      size.width * 0.25,
      dark,
    );
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.7),
      size.width * 0.3,
      dark,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Tile {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  _Tile(this.title, this.icon, this.onTap);
}
