import 'package:flutter/material.dart';
import '../theme/genji_theme.dart';
import '../services/store.dart';
import '../widgets/genji_widgets.dart';

/// Player Statistics + Leaderboard (Global / Local).
class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  int _tab = 0; // 0 global, 1 local

  static const _global = [
    ['अस्वई', 5210, 1],
    ['DragonLord', 4875, 2],
    ['KnightRider', 4320, 3],
    ['Avanr', 3980, 4],
    ['MageQueen', 3650, 5],
    ['SilentArcher', 3310, 6],
    ['IronDwarf', 2980, 7],
  ];

  static const _local = [
    ['Avanr', 3980, 1],
    ['Raja99', 2870, 2],
    ['Priya', 2540, 3],
    ['Arjun', 2210, 4],
    ['Neha', 1980, 5],
  ];

  @override
  Widget build(BuildContext context) {
    final s = GameStore();
    final rows = _tab == 0 ? _global : _local;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: GenjiTheme.bgGradient),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ScreenHeader(title: 'Player Statistics'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // player card
                    OrnateCard(
                      child: Row(
                        children: [
                          AvatarCircle(
                            avatarIndex: s.avatarIndex,
                            frameIndex: s.frameIndex,
                            size: 64,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(s.username,
                                    style:
                                        GenjiTheme.heading.copyWith(
                                            fontSize: 19)),
                                if (s.isPro)
                                  const Text('⚔️ Genji Pro',
                                      style: TextStyle(
                                          color: GenjiTheme
                                              .goldLight,
                                          fontSize: 12,
                                          fontWeight:
                                              FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    // stat row
                    Row(
                      children: [
                        _statBox('${s.wins}', 'Wins',
                            GenjiTheme.goldLight),
                        const SizedBox(width: 10),
                        _statBox('${s.losses}', 'Losses',
                            GenjiTheme.crimsonLight),
                        const SizedBox(width: 10),
                        _statBox('${s.draws}', 'Draws',
                            GenjiTheme.magicBlue),
                      ],
                    ),
                    const SizedBox(height: 18),
                    // tabs
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color:
                            Colors.black.withOpacity(0.35),
                        borderRadius:
                            BorderRadius.circular(14),
                        border: Border.all(
                            color: GenjiTheme.gold
                                .withOpacity(0.35)),
                      ),
                      child: Row(
                        children: [
                          _tabBtn(0, 'Global'),
                          _tabBtn(1, 'Local'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // leaderboard
                    OrnateCard(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8),
                      child: Column(
                        children: [
                          for (final r in rows)
                            _row(r[0] as String,
                                r[1] as int, r[2] as int),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statBox(String v, String label, Color c) {
    return Expanded(
      child: Container(
        padding:
            const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: GenjiTheme.gold.withOpacity(0.35)),
        ),
        child: Column(
          children: [
            Text(v,
                style: TextStyle(
                    color: c,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: GenjiTheme.fontFell)),
            Text(label, style: GenjiTheme.bodyMuted),
          ],
        ),
      ),
    );
  }

  Widget _tabBtn(int i, String label) {
    final sel = _tab == i;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tab = i),
        child: Container(
          padding:
              const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            gradient: sel ? GenjiTheme.goldGradient : null,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: sel
                  ? const Color(0xFF1A1206)
                  : GenjiTheme.muted,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(String name, int score, int rank) {
    final medal = ['🥇', '🥈', '🥉'];
    final isMe = name == GameStore().username;
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isMe
            ? GenjiTheme.gold.withOpacity(0.12)
            : Colors.transparent,
        border: Border(
          bottom: BorderSide(
              color: Colors.white.withOpacity(0.06)),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 34,
            child: Text(
              rank <= 3 ? medal[rank - 1] : '$rank',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                color: isMe
                    ? GenjiTheme.goldLight
                    : GenjiTheme.parchment,
                fontWeight:
                    isMe ? FontWeight.bold : FontWeight.normal,
                fontSize: 15,
              ),
            ),
          ),
          Text(
            '$score',
            style: const TextStyle(
                color: GenjiTheme.goldLight,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
