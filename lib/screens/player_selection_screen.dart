import 'package:flutter/material.dart';
import '../theme/genji_theme.dart';
import '../widgets/genji_widgets.dart';
import '../painters/board_painter.dart';
import 'gameplay_screen.dart';

/// Player Selection — matches reference: top tiles + mode rows + board.
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
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top two tiles (Computer / 2-Player) like reference
                    Row(
                      children: [
                        Expanded(
                          child: _topTile(
                            'Computer',
                            Icons.computer_rounded,
                            widget.vsComputer || _players == 0,
                            () {
                              // already vs computer if entered that way
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _topTile(
                            '2-Player',
                            Icons.person_rounded,
                            !widget.vsComputer && _players == 2,
                            () => setState(() => _players = 2),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (!widget.vsComputer) ...[
                      _modeRow(
                        '2-Player',
                        Icons.group_rounded,
                        _players == 2,
                        () => setState(() => _players = 2),
                      ),
                      _modeRow(
                        '3-Player',
                        Icons.groups_rounded,
                        _players == 3,
                        () => setState(() => _players = 3),
                      ),
                      _modeRow(
                        '4-Player',
                        Icons.groups_rounded,
                        _players == 4,
                        () => setState(() => _players = 4),
                      ),
                    ] else
                      _modeRow(
                        'Computer',
                        Icons.computer_rounded,
                        true,
                        null,
                      ),
                    const SizedBox(height: 16),
                    // Ludo board selector row
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.04),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: GenjiTheme.gold.withOpacity(0.35),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.grid_view_rounded,
                                color: GenjiTheme.goldLight, size: 28),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Ludo board',
                                style: TextStyle(
                                  color: GenjiTheme.parchment,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            // mini board previews
                            ...List.generate(4, (i) {
                              final selected = _boardTheme == i;
                              return GestureDetector(
                                onTap: () =>
                                    setState(() => _boardTheme = i),
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  margin: const EdgeInsets.only(left: 6),
                                  decoration: BoxDecoration(
                                    color: boardThemes[i].cellFill,
                                    borderRadius:
                                        BorderRadius.circular(6),
                                    border: Border.all(
                                      color: selected
                                          ? GenjiTheme.goldLight
                                          : GenjiTheme.gold
                                              .withOpacity(0.3),
                                      width: selected ? 2 : 1,
                                    ),
                                  ),
                                ),
                              );
                            }),
                            const SizedBox(width: 4),
                            Icon(Icons.chevron_right_rounded,
                                color: GenjiTheme.muted),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
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
            // bottom nav like reference
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF0A0C14),
                border: Border(
                  top: BorderSide(
                    color: GenjiTheme.gold.withOpacity(0.25),
                  ),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.home_rounded,
                        color: GenjiTheme.muted, size: 26),
                    Icon(Icons.grid_view_rounded,
                        color: GenjiTheme.goldLight, size: 26),
                    Icon(Icons.emoji_events_rounded,
                        color: GenjiTheme.muted, size: 26),
                    Icon(Icons.person_rounded,
                        color: GenjiTheme.muted, size: 26),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topTile(
      String title, IconData icon, bool selected, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: selected
                ? [
                    const Color(0xFF2A2E42),
                    const Color(0xFF1C2034),
                  ]
                : [
                    const Color(0xFF1E2238),
                    const Color(0xFF151828),
                  ],
          ),
          border: Border.all(
            color: selected
                ? GenjiTheme.gold.withOpacity(0.6)
                : const Color(0xFF4A5068).withOpacity(0.5),
            width: selected ? 1.8 : 1.2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                color: selected
                    ? GenjiTheme.goldLight
                    : GenjiTheme.parchment.withOpacity(0.85),
                size: 30),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                color: GenjiTheme.parchment,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _modeRow(
      String title, IconData icon, bool selected, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected
              ? GenjiTheme.gold.withOpacity(0.12)
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
              child: Text(
                title,
                style: const TextStyle(
                  color: GenjiTheme.parchment,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
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
}
