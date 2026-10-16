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

/// The Ludo Genji Main Hub — reference layout: stone tiles + Pro banner.
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
      _Tile('Leaderboard', Icons.emoji_events_outlined, () {
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
      backgroundColor: const Color(0xFF0D0F1A),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0D0F1A),
              Color(0xFF12152A),
              Color(0xFF0A0C16),
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Top title bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Row(
                  children: [
                    const Spacer(),
                    Text(
                      'Ludo Genji',
                      style: GenjiTheme.titleGold.copyWith(
                        fontSize: 26,
                        letterSpacing: 1.4,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => _go(const SettingsScreen()),
                      child: Icon(
                        Icons.settings_rounded,
                        color: GenjiTheme.goldLight.withOpacity(0.85),
                        size: 26,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // 3x3 stone grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.95,
                    ),
                    itemCount: tiles.length,
                    itemBuilder: (_, i) => _stoneTile(tiles[i]),
                  ),
                ),
              ),
              // Pro membership banner
              GestureDetector(
                onTap: () =>
                    _go(const ProScreen()).then((_) => setState(() {})),
                child: Container(
                  margin: const EdgeInsets.fromLTRB(14, 4, 14, 10),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF4A2C0A),
                        Color(0xFF2A1A08),
                        Color(0xFF1A1208),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: GenjiTheme.gold.withOpacity(0.7),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: GenjiTheme.gold.withOpacity(0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: GenjiTheme.goldGradient,
                          border: Border.all(
                              color: GenjiTheme.goldLight, width: 1.5),
                        ),
                        child: const Center(
                          child: Text(
                            'LG',
                            style: TextStyle(
                              color: Color(0xFF1A1206),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
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
                                fontSize: 16,
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
                        color: GenjiTheme.goldLight.withOpacity(0.8),
                      ),
                    ],
                  ),
                ),
              ),
              // Bottom navigation
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF0A0C14),
                  border: Border(
                    top: BorderSide(
                      color: GenjiTheme.gold.withOpacity(0.25),
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
                      _navItem(Icons.emoji_events_rounded, 1, () {
                        _go(const TournamentsScreen());
                      }),
                      _navItem(Icons.person_rounded, 2, () {
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

  /// Stone-textured tile matching the reference screenshots.
  Widget _stoneTile(_Tile tile) {
    return GestureDetector(
      onTap: () {
        SoundService().play('click');
        tile.onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2A2E42),
              Color(0xFF1C2034),
              Color(0xFF151828),
            ],
          ),
          border: Border.all(
            color: const Color(0xFF4A5068).withOpacity(0.7),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.55),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.04),
              blurRadius: 1,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              tile.icon,
              color: GenjiTheme.parchment.withOpacity(0.9),
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              tile.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: GenjiTheme.parchment,
                fontWeight: FontWeight.w600,
                fontSize: 13,
                height: 1.15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tile {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  _Tile(this.title, this.icon, this.onTap);
}
