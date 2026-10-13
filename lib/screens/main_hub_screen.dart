import 'package:flutter/material.dart';
import '../theme/genji_theme.dart';
import '../services/store.dart';
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

/// The Ludo Genji Main Hub — central control for all modes.
class MainHubScreen extends StatefulWidget {
  const MainHubScreen({super.key});

  @override
  State<MainHubScreen> createState() => _MainHubScreenState();
}

class _MainHubScreenState extends State<MainHubScreen> {
  @override
  Widget build(BuildContext context) {
    final store = GameStore();
    final tiles = [
      _Tile('Computer', Icons.computer_rounded,
          'AI ke khilaf khelo', () {
        _go(const PlayerSelectionScreen(vsComputer: true));
      }),
      _Tile('Pass and Play', Icons.people_rounded,
          'Ek phone, doston ke saath', () {
        _go(const PlayerSelectionScreen(vsComputer: false));
      }),
      _Tile('Online Multiplayer', Icons.public_rounded,
          'Duniya bhar ke khiladi', () {
        _go(const OnlineScreen());
      }),
      _Tile('Tournaments', Icons.emoji_events_rounded,
          'Bracket aur inaam', () {
        _go(const TournamentsScreen());
      }),
      _Tile('Leaderboard', Icons.leaderboard_rounded,
          'Sabse upar kaun?', () {
        _go(const StatsScreen());
      }),
      _Tile('Shop', Icons.store_rounded, 'Frames aur boards',
          () {
        _go(const ShopScreen());
      }),
      _Tile('Daily Spin', Icons.casino_rounded,
          'Roz ka inaam chakkar', () {
        _go(const SpinScreen());
      }),
      _Tile('Rewards', Icons.card_giftcard_rounded,
          'Daily rewards lo', () {
        _go(const RewardsScreen());
      }),
      _Tile('Settings', Icons.settings_rounded,
          'Sound, profile, reset', () {
        _go(const SettingsScreen());
      }),
    ];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: GenjiTheme.bgGradient),
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // top bar
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => _go(const AvatarScreen())
                          .then((_) => setState(() {})),
                      child: AvatarCircle(
                        avatarIndex: store.avatarIndex,
                        frameIndex: store.frameIndex,
                        size: 52,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ludo Genji',
                            style: GenjiTheme.titleGold
                                .copyWith(fontSize: 22),
                          ),
                          Text(
                            store.username,
                            style: GenjiTheme.bodyMuted,
                          ),
                        ],
                      ),
                    ),
                    CoinPill(coins: store.coins),
                  ],
                ),
                const SizedBox(height: 16),
                // Genji Pro banner
                GestureDetector(
                  onTap: () =>
                      _go(const ProScreen()).then((_) => setState(() {})),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF3B2A10),
                          Color(0xFF1A2038)
                        ],
                      ),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                          color: GenjiTheme.gold, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(14),
                            border: Border.all(
                                color: GenjiTheme.goldLight),
                          ),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(13),
                            child: Image.asset(
                              'assets/pro/genji_pro_knight.png',
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(
                                      Icons
                                          .auto_awesome_rounded,
                                      color:
                                          GenjiTheme.goldLight,
                                      size: 30),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Genji Pro',
                                style: TextStyle(
                                  fontFamily:
                                      GenjiTheme.fontFell,
                                  color: GenjiTheme.goldLight,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'AI assistant + premium rewards',
                                style: GenjiTheme.bodyMuted,
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: GenjiTheme.goldLight,
                            size: 18),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // 3x3 grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.92,
                  ),
                  itemCount: tiles.length,
                  itemBuilder: (_, i) =>
                      _hubTile(context, tiles[i]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _go(Widget page) {
    return Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => page));
  }

  Widget _hubTile(BuildContext context, _Tile tile) {
    return GestureDetector(
      onTap: tile.onTap,
      child: OrnateCard(
        padding: const EdgeInsets.all(10),
        radius: 16,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: GenjiTheme.goldGradient,
                boxShadow: [
                  BoxShadow(
                    color: GenjiTheme.gold.withOpacity(0.4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Icon(tile.icon,
                  color: const Color(0xFF1A1206), size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              tile.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: GenjiTheme.parchment,
                fontWeight: FontWeight.bold,
                fontSize: 12.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              tile.subtitle,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: GenjiTheme.muted, fontSize: 10),
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
  final String subtitle;
  final VoidCallback onTap;
  _Tile(this.title, this.icon, this.subtitle, this.onTap);
}
