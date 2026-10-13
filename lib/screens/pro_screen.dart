import 'package:flutter/material.dart';
import '../theme/genji_theme.dart';
import '../services/store.dart';
import '../widgets/genji_widgets.dart';

/// Genji Pro — magical AI assistant subscription.
class ProScreen extends StatefulWidget {
  const ProScreen({super.key});

  @override
  State<ProScreen> createState() => _ProScreenState();
}

class _ProScreenState extends State<ProScreen> {
  int _plan = 1; // 0 weekly, 1 annual

  static const _features = [
    'Genji Pro AI — magical move suggestions',
    'Premium rewards & exclusive boards',
    'Special gameplay guidance in every match',
    'Golden avatar frames & profile badge',
    'Ad-free royal experience',
  ];

  void _becomePro() {
    final price = _plan == 0 ? '\$4.99/week' : '\$39.99/year';
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: GenjiTheme.bgCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: GenjiTheme.gold),
        ),
        title: Text('Become Pro',
            style: GenjiTheme.titleGold.copyWith(fontSize: 22)),
        content: Text(
          'Activate Genji Pro ($price)?\n(Demo purchase — no real charge.)',
          style: GenjiTheme.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel',
                style: TextStyle(color: GenjiTheme.muted)),
          ),
          TextButton(
            onPressed: () {
              GameStore().isPro = true;
              Navigator.of(context).pop();
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text(
                        'Welcome to Genji Pro! ⚔️')),
              );
            },
            child: const Text('Confirm',
                style: TextStyle(color: GenjiTheme.goldLight)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPro = GameStore().isPro;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: GenjiTheme.bgGradient),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ScreenHeader(title: 'Genji Pro'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Text(
                        'Your AI Assistant to Conquer',
                        textAlign: TextAlign.center,
                        style: GenjiTheme.titleGold
                            .copyWith(fontSize: 26),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Center(
                      child: Container(
                        width: 190,
                        height: 190,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(24),
                          border: Border.all(
                              color: GenjiTheme.gold,
                              width: 2.5),
                          boxShadow: [
                            BoxShadow(
                              color: GenjiTheme.magicBlue
                                  .withOpacity(0.45),
                              blurRadius: 32,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(22),
                          child: Image.asset(
                            'assets/pro/genji_pro_knight.png',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                Container(
                              color: GenjiTheme.bgCard,
                              child: const Icon(
                                  Icons.smart_toy_rounded,
                                  size: 80,
                                  color:
                                      GenjiTheme.goldLight),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    OrnateCard(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          for (final f in _features)
                            Padding(
                              padding: const EdgeInsets
                                  .symmetric(vertical: 5),
                              child: Row(
                                children: [
                                  const Icon(
                                      Icons
                                          .check_circle_rounded,
                                      color:
                                          GenjiTheme.goldLight,
                                      size: 20),
                                  const SizedBox(width: 10),
                                  Expanded(
                                      child: Text(f,
                                          style:
                                              GenjiTheme.body)),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                            child: _planCard(
                                0, '\$4.99', 'Weekly', 'per week')),
                        const SizedBox(width: 12),
                        Expanded(
                            child: _planCard(1, '\$39.99',
                                'Annual', 'per year — save 35%')),
                      ],
                    ),
                    const SizedBox(height: 20),
                    GoldButton(
                      label: isPro
                          ? 'You are Pro ⚔️'
                          : 'Become Pro',
                      onTap: isPro ? null : _becomePro,
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

  Widget _planCard(
      int i, String price, String title, String sub) {
    final selected = _plan == i;
    return GestureDetector(
      onTap: () => setState(() => _plan = i),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected
              ? GenjiTheme.gold.withOpacity(0.14)
              : Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? GenjiTheme.goldLight
                : GenjiTheme.gold.withOpacity(0.3),
            width: selected ? 2.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(price,
                style: GenjiTheme.titleGold
                    .copyWith(fontSize: 26)),
            Text(title,
                style: const TextStyle(
                    color: GenjiTheme.parchment,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(sub,
                textAlign: TextAlign.center,
                style: GenjiTheme.bodyMuted
                    .copyWith(fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
