import 'package:flutter/material.dart';
import '../theme/genji_theme.dart';
import '../services/store.dart';
import '../services/sound_service.dart';
import '../widgets/genji_widgets.dart';

/// Rewards — 7-day daily reward track.
class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  static const _days = [100, 150, 200, 300, 400, 600, 1000];

  @override
  Widget build(BuildContext context) {
    final store = GameStore();
    final claimed = store.rewardDay; // 0..7 claimed count
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: GenjiTheme.bgGradient),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScreenHeader(
              title: 'Rewards',
              actions: [CoinPill(coins: store.coins)],
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Claim your daily tribute, warrior!',
                      textAlign: TextAlign.center,
                      style: GenjiTheme.titleGold
                          .copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: 7,
                      itemBuilder: (_, i) {
                        final done = i < claimed;
                        final isNext = i == claimed;
                        return GestureDetector(
                          onTap: isNext
                              ? () => _claim(i)
                              : null,
                          child: OrnateCard(
                            padding:
                                const EdgeInsets.all(10),
                            radius: 14,
                            child: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Text('Day ${i + 1}',
                                    style:
                                        GenjiTheme.bodyMuted),
                                const SizedBox(height: 6),
                                Icon(
                                  done
                                      ? Icons
                                          .check_circle_rounded
                                      : Icons
                                          .card_giftcard_rounded,
                                  color: done
                                      ? GenjiTheme.magicBlue
                                      : isNext
                                          ? GenjiTheme.goldLight
                                          : GenjiTheme.muted,
                                  size: 34,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '🪙 ${_days[i]}',
                                  style: TextStyle(
                                    color: isNext
                                        ? GenjiTheme.goldLight
                                        : GenjiTheme.parchment,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      claimed >= 7
                          ? 'Week complete! Resets tomorrow.'
                          : 'Day ${claimed + 1} reward is ready to claim.',
                      textAlign: TextAlign.center,
                      style: GenjiTheme.bodyMuted,
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

  void _claim(int day) {
    final store = GameStore();
    store.coins = store.coins + _days[day];
    store.rewardDay = day + 1 >= 7 ? 0 : day + 1;
    SoundService().play('six');
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              '+${_days[day]} coins claimed! 🎉')),
    );
  }
}
