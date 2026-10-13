import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/genji_theme.dart';
import '../widgets/genji_widgets.dart';
import 'player_selection_screen.dart';

/// Online Multiplayer — matchmaking (demo: falls back to vs Computer).
class OnlineScreen extends StatefulWidget {
  const OnlineScreen({super.key});

  @override
  State<OnlineScreen> createState() => _OnlineScreenState();
}

class _OnlineScreenState extends State<OnlineScreen> {
  bool _searching = false;
  int _dots = 0;
  Timer? _t;

  @override
  void dispose() {
    _t?.cancel();
    super.dispose();
  }

  void _findMatch() {
    setState(() => _searching = true);
    _t = Timer.periodic(
        const Duration(milliseconds: 500),
        (_) => setState(() => _dots = (_dots + 1) % 4));
    // demo: after a few seconds, offer practice vs Genji AI
    Timer(const Duration(seconds: 4), () {
      if (!mounted) return;
      _t?.cancel();
      setState(() => _searching = false);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: GenjiTheme.bgCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side:
                const BorderSide(color: GenjiTheme.gold),
          ),
          title: Text('No warriors found',
              style:
                  GenjiTheme.titleGold.copyWith(fontSize: 20)),
          content: const Text(
            'Online servers are in demo mode. Practice against Genji AI meanwhile?',
            style: GenjiTheme.body,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Later',
                  style:
                      TextStyle(color: GenjiTheme.muted)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) =>
                        const PlayerSelectionScreen(
                            vsComputer: true),
                  ),
                );
              },
              child: const Text('Practice vs AI',
                  style: TextStyle(
                      color: GenjiTheme.goldLight)),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: GenjiTheme.bgGradient),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ScreenHeader(
                title: 'Online Multiplayer'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: GenjiTheme.gold,
                            width: 2.5),
                        boxShadow: [
                          BoxShadow(
                            color: GenjiTheme.gold
                                .withOpacity(0.4),
                            blurRadius: 28,
                          ),
                        ],
                      ),
                      child: const Icon(
                          Icons.public_rounded,
                          size: 56,
                          color: GenjiTheme.goldLight),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _searching
                          ? 'Searching${'.' * _dots}'
                          : 'Find worthy opponents',
                      style: GenjiTheme.titleGold
                          .copyWith(fontSize: 24),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Matchmaking pairs you with warriors of equal skill across the realm.',
                      textAlign: TextAlign.center,
                      style: GenjiTheme.bodyMuted,
                    ),
                    const SizedBox(height: 28),
                    GoldButton(
                      label: _searching
                          ? 'Searching...'
                          : 'Find Match',
                      onTap:
                          _searching ? null : _findMatch,
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
}
