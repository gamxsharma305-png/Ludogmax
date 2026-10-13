import 'package:flutter/material.dart';
import '../theme/genji_theme.dart';
import '../services/store.dart';
import '../widgets/genji_widgets.dart';

/// Shop — avatar frames and board themes for coins.
class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  static const _frames = [
    ('Golden Royal', 0, 0),
    ('Arcane Blue', 1, 300),
    ('Blood Ruby', 2, 500),
    ('Shadow Violet', 3, 800),
    ('Storm Teal', 4, 1200),
    ('Sunset Amber', 5, 1500),
  ];

  static const _frameColors = [
    GenjiTheme.gold,
    GenjiTheme.magicBlue,
    GenjiTheme.crimsonLight,
    Color(0xFF9D4EDD),
    Color(0xFF2EC4B6),
    Color(0xFFFF9F1C),
  ];

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
              title: 'Shop',
              actions: [CoinPill(coins: store.coins)],
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch,
                  children: [
                    Text('Avatar Frames',
                        style: GenjiTheme.heading
                            .copyWith(fontSize: 17)),
                    const SizedBox(height: 10),
                    GridView.builder(
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: _frames.length,
                      itemBuilder: (_, i) {
                        final f = _frames[i];
                        final owned = store.ownedFrames
                            .contains('${f.$2}');
                        final equipped =
                            store.frameIndex == f.$2;
                        return OrnateCard(
                          padding:
                              const EdgeInsets.all(10),
                          radius: 14,
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color:
                                          _frameColors[i],
                                      width: 3),
                                ),
                                child: Icon(
                                    Icons.person_rounded,
                                    color: _frameColors[i],
                                    size: 28),
                              ),
                              const SizedBox(height: 6),
                              Text(f.$1,
                                  textAlign:
                                      TextAlign.center,
                                  style: const TextStyle(
                                      color: GenjiTheme
                                          .parchment,
                                      fontSize: 11,
                                      fontWeight:
                                          FontWeight.bold)),
                              const SizedBox(height: 6),
                              _actionBtn(
                                label: equipped
                                    ? 'Equipped'
                                    : owned
                                        ? 'Equip'
                                        : '🪙 ${f.$3}',
                                enabled:
                                    !equipped &&
                                        (owned ||
                                            store.coins >=
                                                f.$3),
                                onTap: () =>
                                    _onFrame(i, owned),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Boards are unlocked from Player Selection.',
                      style: GenjiTheme.bodyMuted,
                      textAlign: TextAlign.center,
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

  void _onFrame(int i, bool owned) async {
    final store = GameStore();
    final f = _frames[i];
    if (owned) {
      setState(() => store.frameIndex = f.$2);
      return;
    }
    if (store.coins < f.$3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Not enough coins!')),
      );
      return;
    }
    store.coins = store.coins - (f.$3 as int);
    await store.addOwnedFrame('${f.$2}');
    setState(() => store.frameIndex = f.$2);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('${f.$1} purchased!')),
      );
    }
  }

  Widget _actionBtn(
      {required String label,
      required bool enabled,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Opacity(
        opacity: enabled ? 1 : 0.45,
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            gradient: enabled
                ? GenjiTheme.goldGradient
                : null,
            color: enabled ? null : Colors.white10,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF1A1206),
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ),
      ),
    );
  }
}
