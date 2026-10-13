import 'package:flutter/material.dart';
import '../theme/genji_theme.dart';
import '../widgets/genji_widgets.dart';
import '../painters/board_painter.dart';
import 'gameplay_screen.dart';

/// Player Selection — mode rows + Ludo Board thumbnails.
class PlayerSelectionScreen extends StatefulWidget {
  final bool vsComputer;
  const PlayerSelectionScreen({super.key, required this.vsComputer});

  @override
  State<PlayerSelectionScreen> createState() =>
      _PlayerSelectionScreenState();
}

class _PlayerSelectionScreenState
    extends State<PlayerSelectionScreen> {
  int _players = 2;
  int _boardTheme = 0;

  @override
  void initState() {
    super.initState();
    if (widget.vsComputer) _players = 2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: GenjiTheme.bgGradient),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ScreenHeader(title: 'Player Selection'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Game Mode',
                        style: GenjiTheme.heading.copyWith(
                            fontSize: 17)),
                    const SizedBox(height: 10),
                    if (widget.vsComputer)
                      _modeRow('Computer', 'Genji AI ke khilaf',
                          Icons.computer_rounded, true, null)
                    else ...[
                      _modeRow('2-Player', 'Do yoddha aamne-saamne',
                          Icons.group_rounded, _players == 2,
                          () => setState(() => _players = 2)),
                      _modeRow('3-Player', 'Teenon ka sangram',
                          Icons.groups_rounded, _players == 3,
                          () => setState(() => _players = 3)),
                      _modeRow('4-Player', 'Mahayudh — chaaron',
                          Icons.groups_rounded, _players == 4,
                          () => setState(() => _players = 4)),
                    ],
                    const SizedBox(height: 22),
                    Text('Ludo Board',
                        style: GenjiTheme.heading.copyWith(
                            fontSize: 17)),
                    const SizedBox(height: 10),
                    GridView.builder(
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.05,
                      ),
                      itemCount: boardThemes.length,
                      itemBuilder: (_, i) =>
                          _boardThumb(i),
                    ),
                    const SizedBox(height: 24),
                    GoldButton(
                      label: 'Start Battle',
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => GameplayScreen(
                              numPlayers: _players,
                              vsComputer: widget.vsComputer,
                              boardTheme: _boardTheme,
                            ),
                          ),
                        );
                      },
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

  Widget _modeRow(String title, String sub, IconData icon,
      bool selected, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected
              ? GenjiTheme.gold.withOpacity(0.14)
              : Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? GenjiTheme.gold
                : GenjiTheme.gold.withOpacity(0.25),
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon,
                color: selected
                    ? GenjiTheme.goldLight
                    : GenjiTheme.muted,
                size: 26),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: GenjiTheme.parchment,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  Text(sub, style: GenjiTheme.bodyMuted),
                ],
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle_rounded,
                  color: GenjiTheme.goldLight),
          ],
        ),
      ),
    );
  }

  Widget _boardThumb(int i) {
    final selected = _boardTheme == i;
    return GestureDetector(
      onTap: () => setState(() => _boardTheme = i),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? GenjiTheme.goldLight
                : GenjiTheme.gold.withOpacity(0.25),
            width: selected ? 3 : 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(color: boardThemes[i].cellFill),
              Center(
                child: Text(
                  boardThemes[i].name,
                  style:
                      GenjiTheme.titleGold.copyWith(fontSize: 18),
                ),
              ),
              if (selected)
                const Positioned(
                  top: 6,
                  right: 6,
                  child: Icon(Icons.check_circle_rounded,
                      color: GenjiTheme.goldLight, size: 22),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
