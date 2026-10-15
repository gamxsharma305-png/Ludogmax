import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/game.dart';
import '../theme/genji_theme.dart';
import '../services/store.dart';
import '../services/sound_service.dart';
import '../widgets/genji_widgets.dart';
import '../painters/board_painter.dart';
import 'game_over_screen.dart';

/// Full Ludo gameplay: dice, tokens, capture, AI, turns.
class GameplayScreen extends StatefulWidget {
  final int numPlayers;
  final bool vsComputer;
  final int boardTheme;

  const GameplayScreen({
    super.key,
    required this.numPlayers,
    required this.vsComputer,
    required this.boardTheme,
  });

  @override
  State<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen>
    with SingleTickerProviderStateMixin {
  late LudoGame game;
  final random = Random();
  int displayDice = 6;
  bool rolling = false;
  bool inputLocked = true;
  String banner = '';
  String? taunt;
  late AnimationController _glow;
  Timer? _aiTimer;
  // Step-by-step token animation (Ludo King style): while a token moves,
  // BoardPainter paints it at _animProgress instead of its real progress.
  // Game state only changes when game.moveToken() runs after the animation.
  String? _animTokenKey;
  int? _animProgress;

  @override
  void initState() {
    super.initState();
    game = LudoGame(widget.numPlayers);
    _glow = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
    Future.delayed(const Duration(milliseconds: 600), _startTurn);
  }

  @override
  void dispose() {
    _glow.dispose();
    _aiTimer?.cancel();
    super.dispose();
  }

  String _playerName(int p) {
    if (widget.vsComputer) {
      return p == 0 ? GameStore().username : 'Genji AI';
    }
    return 'Player ${p + 1}';
  }

  bool get _isAiTurn => widget.vsComputer && game.turn != 0;

  void _startTurn() {
    if (!mounted || game.gameOver) return;
    SoundService().play('turn');
    setState(() {
      inputLocked = _isAiTurn;
      banner = '${_playerName(game.turn)}\'s turn';
    });
    if (_isAiTurn) {
      _aiTimer?.cancel();
      _aiTimer = Timer(
          const Duration(milliseconds: 1100), _aiRoll);
    } else {
      setState(() => inputLocked = false);
    }
  }

  // ---------- human ----------
  void _humanRoll() {
    if (inputLocked || rolling || game.dice != null) return;
    _animateRoll().then((_) => _afterRoll(isAi: false));
  }

  Future<void> _animateRoll() async {
    SoundService().play('dice');
    setState(() {
      rolling = true;
      inputLocked = true;
    });
    final t = Timer.periodic(
        const Duration(milliseconds: 80),
        (_) => setState(
            () => displayDice = 1 + random.nextInt(6)));
    await Future.delayed(const Duration(milliseconds: 650));
    t.cancel();
    if (mounted) {
      setState(() => rolling = false);
    }
  }

  void _afterRoll({required bool isAi}) {
    if (!mounted) return;
    final d = game.rollDice(random);
    setState(() => displayDice = d);
    if (d == 6 && game.sixStreak < 3) {
      SoundService().play('six');
    }

    if (game.sixStreak >= 3) {
      setState(() => banner = 'Three sixes! Turn skipped.');
      _delayed(const Duration(milliseconds: 1200), () {
        game.nextTurn();
        _startTurn();
      });
      return;
    }
    if (game.movable.isEmpty) {
      setState(() => banner = 'No move possible.');
      _delayed(const Duration(milliseconds: 1100), () {
        game.nextTurn();
        _startTurn();
      });
      return;
    }
    if (game.movable.length == 1) {
      _delayed(const Duration(milliseconds: 700),
          () => _doMove(game.movable.first));
      return;
    }
    setState(() {
      banner =
          '${_playerName(game.turn)}: tap a glowing token';
      inputLocked = false;
    });
    if (isAi) {
      _delayed(const Duration(milliseconds: 800), () {
        if (mounted && !game.gameOver) {
          _doMove(game.chooseAiMove());
        }
      });
    }
  }

  /// Moves [token] with a Ludo King style step-by-step animation, then
  /// applies the real game move (captures, win check, extra turns).
  Future<void> _doMove(int token) async {
    if (!mounted || game.gameOver) return;
    // Lock input for the whole animation so nothing can interrupt it.
    setState(() => inputLocked = true);

    // --- Visual step-by-step animation (game state untouched) ---
    final startProg = game.progress[game.turn][token];
    final diceVal = game.dice ?? 1;
    final endProg =
        startProg == -1 ? 0 : (startProg + diceVal).clamp(0, 56);
    _animTokenKey = '${game.turn}:$token';
    _animProgress = startProg;
    if (mounted) setState(() {});
    if (startProg == -1) {
      // Leaving base: hop from the base spot onto the start cell.
      await Future.delayed(const Duration(milliseconds: 200));
      if (!mounted) return;
      _animProgress = 0;
      SoundService().play('move');
      if (mounted) setState(() {});
      await Future.delayed(const Duration(milliseconds: 150));
    } else {
      // Walk one cell at a time, ~180ms per step, with a sound per step.
      for (var step = startProg + 1; step <= endProg; step++) {
        await Future.delayed(const Duration(milliseconds: 180));
        if (!mounted) return;
        _animProgress = step;
        SoundService().play('move');
        if (mounted) setState(() {});
      }
    }
    // Animation done — clear the visual override before the real move.
    _animTokenKey = null;
    _animProgress = null;

    // --- Real game move (unchanged original logic) ---
    if (!mounted || game.gameOver) return;
    final res = game.moveToken(token);
    SoundService().play(res.captured ? 'capture' : 'move');
    setState(() {
      inputLocked = true;
      if (res.captured) {
        banner = '${_playerName(game.turn)} captures!';
        taunt = _taunts[random.nextInt(_taunts.length)];
      } else {
        taunt = null;
      }
    });
    if (res.won) {
      _delayed(const Duration(milliseconds: 900), _finish);
      return;
    }
    _delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;
      if (res.extraTurn) {
        setState(() {
          banner =
              '${_playerName(game.turn)} rolls again!';
          game.dice = null;
          game.movable = [];
          inputLocked = _isAiTurn;
          taunt = null;
        });
        if (_isAiTurn) {
          _aiTimer?.cancel();
          _aiTimer = Timer(
              const Duration(milliseconds: 900), _aiRoll);
        }
      } else {
        setState(() => taunt = null);
        game.nextTurn();
        _startTurn();
      }
    });
  }

  // ---------- AI ----------
  void _aiRoll() {
    if (!mounted || game.gameOver) return;
    _animateRoll().then((_) => _afterRoll(isAi: true));
  }

  void _delayed(Duration d, VoidCallback fn) {
    Timer(d, () {
      if (mounted) fn();
    });
  }

  void _finish() {
    final wonByHuman =
        !widget.vsComputer || game.winnerIndex == 0;
    if (wonByHuman) SoundService().play('win');
    GameStore().recordResult(won: wonByHuman, draw: false);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => GameOverScreen(
          winnerName: _playerName(game.winnerIndex!),
          winnerTeam: game.teams[game.winnerIndex!],
          humanWon: wonByHuman,
        ),
      ),
    );
  }

  // ---------- tap handling ----------
  List<int>? _tokenCell(int team, int token, int prog) {
    if (prog == -1) return BoardGeo.baseSpots[team][token];
    if (prog >= 56) return null;
    if (prog >= 51) return BoardGeo.homeCols[team][prog - 51];
    return BoardGeo.path[game.trackPos(team, prog)];
  }

  void _onBoardTap(TapDownDetails d, double boardPx) {
    if (inputLocked ||
        game.gameOver ||
        game.dice == null ||
        game.movable.isEmpty) return;
    if (_isAiTurn) return;
    final s = boardPx / 15;
    final col = (d.localPosition.dx / s).floor();
    final row = (d.localPosition.dy / s).floor();
    final team = game.currentTeam;
    for (final t in game.movable) {
      final cell =
          _tokenCell(team, t, game.progress[game.turn][t]);
      if (cell != null && cell[0] == row && cell[1] == col) {
        _doMove(t);
        return;
      }
    }
  }

  void _quit() {
    _aiTimer?.cancel();
    Navigator.of(context).popUntil((r) => r.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final movableKeys = <String>{
      for (final t in game.movable) '${game.turn}:$t'
    };
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: GenjiTheme.bgGradient),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, cons) {
              final boardPx =
                  (cons.maxWidth - 20).clamp(280.0, 430.0);
              return SingleChildScrollView(
                child: Column(
                  children: [
                    _topBar(),
                    _playerStrip(),
                    const SizedBox(height: 6),
                    // banner
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20),
                      child: Text(
                        banner,
                        style: GenjiTheme.titleGold
                            .copyWith(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // board
                    Center(
                      child: GestureDetector(
                        onTapDown: (d) =>
                            _onBoardTap(d, boardPx),
                        child: AnimatedBuilder(
                          animation: _glow,
                          builder: (_, __) => CustomPaint(
                            size: Size(boardPx, boardPx),
                            painter: BoardPainter(
                              game: game,
                              boardTheme: widget.boardTheme,
                              movableKeys: movableKeys,
                              glow: _glow.value,
                              animTokenKey: _animTokenKey,
                              animProgress: _animProgress,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (taunt != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius:
                                BorderRadius.circular(16),
                            border: Border.all(
                                color: GenjiTheme.gold
                                    .withOpacity(0.4)),
                          ),
                          child: Text('💬 $taunt',
                              style: GenjiTheme.bodyMuted),
                        ),
                      ),
                    const SizedBox(height: 10),
                    _controls(),
                    const SizedBox(height: 16),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _topBar() {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.home_rounded,
                color: GenjiTheme.goldLight),
            onPressed: _quit,
            tooltip: 'Home',
          ),
          IconButton(
            icon: const Icon(Icons.pause_rounded,
                color: GenjiTheme.goldLight),
            onPressed: () => showDialog(
              context: context,
              builder: (_) => _pauseDialog(),
            ),
            tooltip: 'Pause',
          ),
          const Spacer(),
          Text('LUDO GENJI',
              style: GenjiTheme.titleGold.copyWith(fontSize: 18)),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline_rounded,
                color: GenjiTheme.goldLight),
            onPressed: () => setState(() => taunt =
                _taunts[random.nextInt(_taunts.length)]),
            tooltip: 'Chat',
          ),
          IconButton(
            icon: const Icon(Icons.menu_rounded,
                color: GenjiTheme.goldLight),
            onPressed: () => showDialog(
              context: context,
              builder: (_) => _pauseDialog(),
            ),
            tooltip: 'Menu',
          ),
        ],
      ),
    );
  }

  Widget _pauseDialog() {
    return AlertDialog(
      backgroundColor: GenjiTheme.bgCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: GenjiTheme.gold),
      ),
      title: Text('Paused',
          style: GenjiTheme.titleGold.copyWith(fontSize: 22)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GoldButton(
              label: 'Resume',
              onTap: () => Navigator.of(context).pop()),
          const SizedBox(height: 10),
          GoldButton(label: 'Quit to Hub', onTap: _quit),
        ],
      ),
    );
  }

  Widget _playerStrip() {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(widget.numPlayers, (p) {
          final team = game.teams[p];
          final home =
              game.progress[p].where((e) => e == 56).length;
          final active = game.turn == p && !game.gameOver;
          return Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: active
                  ? GenjiTheme.teamColor(team).withOpacity(0.25)
                  : Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: active
                    ? GenjiTheme.teamColor(team)
                    : GenjiTheme.gold.withOpacity(0.25),
                width: active ? 2 : 1,
              ),
            ),
            child: Column(
              children: [
                _miniToken(team),
                const SizedBox(height: 2),
                Text(
                  _playerName(p).split(' ').first,
                  style: const TextStyle(
                      color: GenjiTheme.parchment,
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                ),
                Text('$home/4',
                    style: GenjiTheme.bodyMuted
                        .copyWith(fontSize: 10)),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _miniToken(int team) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: GenjiTheme.teamColor(team),
        border:
            Border.all(color: GenjiTheme.goldLight, width: 2),
      ),
    );
  }

  Widget _controls() {
    final canRoll = !inputLocked &&
        !_isAiTurn &&
        !rolling &&
        game.dice == null &&
        !game.gameOver;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Tappable dice (Ludo King style) — no Roll Dice button.
          GestureDetector(
            onTap: canRoll ? _humanRoll : null,
            child: DiceWidget(
                value: displayDice, rolling: rolling, size: 80),
          ),
          const SizedBox(height: 8),
          Text(
            canRoll
                ? 'Dice par tap karo'
                : _playerName(game.turn),
            style: GenjiTheme.bodyMuted,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  static const _taunts = [
    'Victory favors the bold!',
    'The dice obey no master.',
    'A true Genji never retreats!',
    'Your tokens tremble before me.',
    'Fortune smiles on the brave.',
    'Checkmate... er, checkers!',
  ];
}
