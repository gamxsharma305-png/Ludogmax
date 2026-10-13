import 'package:flutter/material.dart';
import '../theme/genji_theme.dart';
import '../services/store.dart';
import '../widgets/genji_widgets.dart';

/// Tournaments — competitive brackets (demo data, coin entry).
class TournamentsScreen extends StatefulWidget {
  const TournamentsScreen({super.key});

  @override
  State<TournamentsScreen> createState() =>
      _TournamentsScreenState();
}

class _TournamentsScreenState
    extends State<TournamentsScreen> {
  static const _tournaments = [
    ('Bronze Clash', 100, 500, '12/16 warriors', '2h left'),
    ('Silver Siege', 300, 1500, '8/16 warriors', '5h left'),
    ('Golden Crown', 1000, 5000, '5/8 warriors', '1d left'),
    ('Genji Masters', 2500, 15000, '3/8 warriors', '3d left'),
  ];

  final _joined = <int>{};

  @override
  Widget build(BuildContext context) {
    final store = GameStore();
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: GenjiTheme.bgGradient),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScreenHeader(
              title: 'Tournaments',
              actions: [CoinPill(coins: store.coins)],
            ),
            Expanded(
              child: ListView.separated(
                padding:
                    const EdgeInsets.fromLTRB(20, 8, 20, 24),
                itemCount: _tournaments.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: 12),
                itemBuilder: (_, i) {
                  final t = _tournaments[i];
                  final joined = _joined.contains(i);
                  return OrnateCard(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                gradient:
                                    GenjiTheme.goldGradient,
                                borderRadius:
                                    BorderRadius.circular(
                                        12),
                              ),
                              child: const Icon(
                                  Icons.emoji_events_rounded,
                                  color: Color(0xFF1A1206)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                children: [
                                  Text(t.$1,
                                      style:
                                          GenjiTheme.heading
                                              .copyWith(
                                                  fontSize:
                                                      17)),
                                  Text(
                                      '${t.$4} • ${t.$5}',
                                      style:
                                          GenjiTheme.bodyMuted),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _pill('Entry 🪙${t.$2}'),
                            const SizedBox(width: 8),
                            _pill('Prize 🪙${t.$3}'),
                            const Spacer(),
                            GestureDetector(
                              onTap: joined
                                  ? null
                                  : () => _join(i),
                              child: Opacity(
                                opacity:
                                    joined ? 0.5 : 1,
                                child: Container(
                                  padding: const EdgeInsets
                                      .symmetric(
                                          horizontal: 18,
                                          vertical: 9),
                                  decoration: BoxDecoration(
                                    gradient: GenjiTheme
                                        .crimsonGradient,
                                    borderRadius:
                                        BorderRadius.circular(
                                            10),
                                    border: Border.all(
                                        color:
                                            GenjiTheme.gold),
                                  ),
                                  child: Text(
                                    joined
                                        ? 'Joined'
                                        : 'Join',
                                    style: const TextStyle(
                                      color: GenjiTheme
                                          .parchment,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pill(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: GenjiTheme.gold.withOpacity(0.4)),
      ),
      child: Text(label,
          style: const TextStyle(
              color: GenjiTheme.goldLight,
              fontSize: 12,
              fontWeight: FontWeight.bold)),
    );
  }

  void _join(int i) {
    final store = GameStore();
    final entry = _tournaments[i].$2 as int;
    if (store.coins < entry) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Not enough coins!')),
      );
      return;
    }
    store.coins = store.coins - entry;
    setState(() => _joined.add(i));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              'Joined ${_tournaments[i].$1}! Good luck, warrior! ⚔️')),
    );
  }
}
