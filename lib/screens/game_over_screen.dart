import 'package:flutter/material.dart';
import '../theme/genji_theme.dart';
import '../services/store.dart';
import '../widgets/genji_widgets.dart';

/// Victory screen after a finished battle.
class GameOverScreen extends StatelessWidget {
  final String winnerName;
  final int winnerTeam;
  final bool humanWon;

  const GameOverScreen({
    super.key,
    required this.winnerName,
    required this.winnerTeam,
    required this.humanWon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: GenjiTheme.bgGradient),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: GenjiTheme.goldGradient,
                      boxShadow: [
                        BoxShadow(
                          color:
                              GenjiTheme.gold.withOpacity(0.5),
                          blurRadius: 36,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(
                        Icons.emoji_events_rounded,
                        size: 64,
                        color: Color(0xFF1A1206)),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    humanWon ? 'VICTORY!' : 'DEFEAT',
                    style: GenjiTheme.titleGold.copyWith(
                      fontSize: 44,
                      color: humanWon
                          ? GenjiTheme.goldLight
                          : GenjiTheme.muted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$winnerName conquers the board!',
                    textAlign: TextAlign.center,
                    style: GenjiTheme.heading.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    humanWon
                        ? '+200 coins earned'
                        : '+25 coins for the effort',
                    style: const TextStyle(
                        color: GenjiTheme.goldLight,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 28),
                  GoldButton(
                    label: 'Back to Hub',
                    onTap: () => Navigator.of(context)
                        .popUntil((r) => r.isFirst),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
