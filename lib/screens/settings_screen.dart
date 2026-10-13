import 'package:flutter/material.dart';
import '../theme/genji_theme.dart';
import '../services/store.dart';
import '../services/sound_service.dart';
import '../widgets/genji_widgets.dart';

/// Settings — sound, profile, reset.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final store = GameStore();
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: GenjiTheme.bgGradient),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ScreenHeader(title: 'Settings'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Column(
                  children: [
                    OrnateCard(
                      child: Column(
                        children: [
                          _toggle(
                            'Sound Effects',
                            Icons.volume_up_rounded,
                            store.soundOn,
                            (v) {
                              setState(
                                  () => store.soundOn = v);
                              SoundService().enabled = v;
                              if (v) {
                                SoundService().play('click');
                              }
                            },
                          ),
                          Divider(
                              color: Colors.white
                                  .withOpacity(0.08)),
                          _row('App Version',
                              '1.0.0 — Ludo Genji Pro Master',
                              Icons.info_outline_rounded),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    OrnateCard(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.stretch,
                        children: [
                          Text('Danger Zone',
                              style: GenjiTheme.heading
                                  .copyWith(
                                      fontSize: 16,
                                      color: GenjiTheme
                                          .crimsonLight)),
                          const SizedBox(height: 10),
                          GoldButton(
                            label: 'Reset All Progress',
                            fontSize: 16,
                            onTap: () => showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                backgroundColor:
                                    GenjiTheme.bgCard,
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                          18),
                                  side: const BorderSide(
                                      color: GenjiTheme
                                          .gold),
                                ),
                                title: Text(
                                    'Reset everything?',
                                    style: GenjiTheme
                                        .titleGold
                                        .copyWith(
                                            fontSize: 20)),
                                content: const Text(
                                  'Coins, stats, avatar — sab kuch reset ho jayega.',
                                  style: GenjiTheme.body,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(
                                                context)
                                            .pop(),
                                    child: const Text(
                                        'Cancel',
                                        style: TextStyle(
                                            color: GenjiTheme
                                                .muted)),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await store
                                          .resetAll();
                                      if (context
                                          .mounted) {
                                        Navigator.of(
                                                context)
                                            .popUntil((r) =>
                                                r.isFirst);
                                      }
                                    },
                                    child: const Text(
                                        'Reset',
                                        style: TextStyle(
                                            color: GenjiTheme
                                                .crimsonLight)),
                                  ),
                                ],
                              ),
                            ),
                          ),
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

  Widget _toggle(String title, IconData icon, bool value,
      ValueChanged<bool> onChanged) {
    return Row(
      children: [
        Icon(icon, color: GenjiTheme.goldLight),
        const SizedBox(width: 12),
        Expanded(
          child: Text(title,
              style: const TextStyle(
                  color: GenjiTheme.parchment,
                  fontWeight: FontWeight.w600)),
        ),
        Switch(
            value: value,
            onChanged: onChanged,
            activeColor: GenjiTheme.gold),
      ],
    );
  }

  Widget _row(String title, String sub, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: GenjiTheme.goldLight),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      color: GenjiTheme.parchment,
                      fontWeight: FontWeight.w600)),
              Text(sub, style: GenjiTheme.bodyMuted),
            ],
          ),
        ),
      ],
    );
  }
}
