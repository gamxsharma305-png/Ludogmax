import 'dart:math';
import 'package:flutter/material.dart';
import '../models/game.dart';
import '../theme/genji_theme.dart';

/// Board geometry on a 15x15 grid. Cells as (row, col).
class BoardGeo {
  /// The 52-cell main track, clockwise from red start.
  static const List<List<int>> path = [
    [6, 1], [6, 2], [6, 3], [6, 4], [6, 5], //
    [5, 6], [4, 6], [3, 6], [2, 6], [1, 6], [0, 6], //
    [0, 7], [0, 8], //
    [1, 8], [2, 8], [3, 8], [4, 8], [5, 8], //
    [6, 9], [6, 10], [6, 11], [6, 12], [6, 13], [6, 14], //
    [7, 14], [8, 14], //
    [8, 13], [8, 12], [8, 11], [8, 10], [8, 9], //
    [9, 8], [10, 8], [11, 8], [12, 8], [13, 8], [14, 8], //
    [14, 7], [14, 6], //
    [13, 6], [12, 6], [11, 6], [10, 6], [9, 6], //
    [8, 5], [8, 4], [8, 3], [8, 2], [8, 1], [8, 0], //
    [7, 0], [6, 0],
  ];

  /// Home columns (progress 51..55) per team.
  static const List<List<List<int>>> homeCols = [
    [[7, 1], [7, 2], [7, 3], [7, 4], [7, 5]], // red
    [[1, 7], [2, 7], [3, 7], [4, 7], [5, 7]], // green
    [[7, 13], [7, 12], [7, 11], [7, 10], [7, 9]], // yellow
    [[13, 7], [12, 7], [11, 7], [10, 7], [9, 7]], // blue
  ];

  /// Token resting spots inside each 6x6 base.
  static const List<List<List<int>>> baseSpots = [
    [[1, 1], [1, 4], [4, 1], [4, 4]], // red
    [[1, 10], [1, 13], [4, 10], [4, 13]], // green
    [[10, 10], [10, 13], [13, 10], [13, 13]], // yellow
    [[10, 1], [10, 4], [13, 1], [13, 4]], // blue
  ];

  /// Base panel top-left (row, col).
  static const List<List<int>> baseOrigin = [
    [0, 0], [0, 9], [9, 9], [9, 0]
  ];
}

/// Board color themes (player selection thumbnails).
class BoardThemeData {
  final String name;
  final Color cellFill;
  final Color cellEdge;
  const BoardThemeData(this.name, this.cellFill, this.cellEdge);
}

const List<BoardThemeData> boardThemes = [
  BoardThemeData('Royal', Color(0xFF232842), Color(0xFF3A4370)),
  BoardThemeData('Crimson', Color(0xFF3A1F28), Color(0xFF6B3040)),
  BoardThemeData('Ocean', Color(0xFF1B2B45), Color(0xFF2E4A73)),
  BoardThemeData('Emerald', Color(0xFF1D3327), Color(0xFF33573F)),
];

/// Paints the full 15x15 Ludo board + tokens.
class BoardPainter extends CustomPainter {
  final LudoGame game;
  final int boardTheme;
  final Set<String> movableKeys; // "player:token"
  final double glow; // 0..1 pulse for movable tokens
  // Step-by-step animation override (Ludo King style): when set, the token
  // with key "player:token" is painted at [animProgress] instead of its
  // real game progress. Game state itself is untouched until moveToken().
  final String? animTokenKey;
  final int? animProgress;

  BoardPainter({
    required this.game,
    required this.boardTheme,
    required this.movableKeys,
    this.glow = 0,
    this.animTokenKey,
    this.animProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 15;
    final theme = boardThemes[boardTheme];

    // board background
    final bgPaint = Paint()..color = const Color(0xFF0D1020);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(s * 0.6)),
      bgPaint,
    );

    // gold outer frame
    final framePaint = Paint()
      ..shader = GenjiTheme.goldGradient
          .createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.18;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(s * 0.09, s * 0.09, size.width - s * 0.18,
              size.height - s * 0.18),
          Radius.circular(s * 0.55)),
      framePaint,
    );

    _drawBases(canvas, s);
    _drawTrack(canvas, s, theme);
    _drawHomeCols(canvas, s);
    _drawCenter(canvas, s);
    _drawTokens(canvas, s);
  }

  Offset _c(int r, int c, double s) =>
      Offset((c + 0.5) * s, (r + 0.5) * s);

  void _drawBases(Canvas canvas, double s) {
    for (var t = 0; t < 4; t++) {
      final o = BoardGeo.baseOrigin[t];
      final rect = Rect.fromLTWH(
          o[1] * s, o[0] * s, 6 * s, 6 * s);
      final team = GenjiTheme.teamColor(t);
      // panel
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect.deflate(s * 0.15),
            Radius.circular(s * 0.5)),
        Paint()..color = team.withOpacity(0.16),
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect.deflate(s * 0.15),
            Radius.circular(s * 0.5)),
        Paint()
          ..color = GenjiTheme.gold.withOpacity(0.55)
          ..style = PaintingStyle.stroke
          ..strokeWidth = s * 0.09,
      );
      // token resting circles
      for (final spot in BoardGeo.baseSpots[t]) {
        canvas.drawCircle(
          _c(spot[0], spot[1], s),
          s * 0.42,
          Paint()..color = const Color(0xFF12162A),
        );
        canvas.drawCircle(
          _c(spot[0], spot[1], s),
          s * 0.42,
          Paint()
            ..color = team.withOpacity(0.5)
            ..style = PaintingStyle.stroke
            ..strokeWidth = s * 0.07,
        );
      }
    }
  }

  void _drawTrack(Canvas canvas, double s, BoardThemeData theme) {
    for (var i = 0; i < 52; i++) {
      final cell = BoardGeo.path[i];
      final rect = Rect.fromLTWH(
          cell[1] * s + s * 0.04, cell[0] * s + s * 0.04,
          s * 0.92, s * 0.92);
      final isStart = i % 13 == 0;
      final isSafe = LudoGame.safeCells.contains(i);
      final team = GenjiTheme.teamColor((i ~/ 13) % 4);

      final fill = Paint()
        ..color = isStart ? team : theme.cellFill;
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(s * 0.18)),
        fill,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(s * 0.18)),
        Paint()
          ..color = isSafe
              ? GenjiTheme.gold.withOpacity(0.8)
              : theme.cellEdge
          ..style = PaintingStyle.stroke
          ..strokeWidth = s * 0.05,
      );
      if (isSafe && !isStart) {
        _drawStar(canvas, _c(cell[0], cell[1], s), s * 0.26,
            GenjiTheme.goldLight);
      }
      if (isStart) {
        _drawStar(canvas, _c(cell[0], cell[1], s), s * 0.26,
            Colors.white.withOpacity(0.9));
      }
    }
  }

  void _drawHomeCols(Canvas canvas, double s) {
    for (var t = 0; t < 4; t++) {
      final team = GenjiTheme.teamColor(t);
      for (final cell in BoardGeo.homeCols[t]) {
        final rect = Rect.fromLTWH(
            cell[1] * s + s * 0.04, cell[0] * s + s * 0.04,
            s * 0.92, s * 0.92);
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, Radius.circular(s * 0.18)),
          Paint()..color = team.withOpacity(0.75),
        );
      }
    }
  }

  void _drawCenter(Canvas canvas, double s) {
    final cx = 7.5 * s, cy = 7.5 * s;
    final half = 1.5 * s;
    final tris = [
      [GenjiTheme.teamRed, Offset(cx - half, cy), Offset(cx, cy - half)],
      [GenjiTheme.teamGreen, Offset(cx, cy - half), Offset(cx + half, cy)],
      [GenjiTheme.teamYellow, Offset(cx + half, cy), Offset(cx, cy + half)],
      [GenjiTheme.teamBlue, Offset(cx, cy + half), Offset(cx - half, cy)],
    ];
    for (final t in tris) {
      final path = Path()
        ..moveTo(cx, cy)
        ..lineTo((t[1] as Offset).dx, (t[1] as Offset).dy)
        ..lineTo((t[2] as Offset).dx, (t[2] as Offset).dy)
        ..close();
      canvas.drawPath(path, Paint()..color = (t[0] as Color));
      canvas.drawPath(
          path,
          Paint()
            ..color = GenjiTheme.gold.withOpacity(0.7)
            ..style = PaintingStyle.stroke
            ..strokeWidth = s * 0.06);
    }
    // gold seal in middle
    canvas.drawCircle(
        Offset(cx, cy), s * 0.32, Paint()..color = GenjiTheme.gold);
    canvas.drawCircle(Offset(cx, cy), s * 0.32,
        Paint()..color = const Color(0xFF0A0C16));
    _drawStar(canvas, Offset(cx, cy), s * 0.22, GenjiTheme.goldLight);
  }

  void _drawTokens(Canvas canvas, double s) {
    // group tokens by cell for stacking
    final Map<String, List<List<int>>> byCell = {};
    for (var p = 0; p < game.numPlayers; p++) {
      final team = game.teams[p];
      for (var t = 0; t < 4; t++) {
        var prog = game.progress[p][t];
        // Animation override: paint the animating token at its
        // in-flight position instead of its real game progress.
        if ('$p:$t' == animTokenKey && animProgress != null) {
          prog = animProgress!;
        }
        final key = _cellKey(team, t, prog);
        byCell.putIfAbsent(key, () => []).add([p, t, team, prog]);
      }
    }
    byCell.forEach((key, list) {
      for (var i = 0; i < list.length; i++) {
        final e = list[i];
        var center = _tokenCenter(e[2], e[1], e[3], s);
        if (list.length > 1) {
          final ox = (i % 2 == 0 ? -1 : 1) * s * 0.18;
          final oy = (i < 2 ? -1 : 1) * s * 0.18;
          center = center.translate(ox, oy);
        }
        final movable = movableKeys.contains('${e[0]}:${e[1]}');
        _drawToken(canvas, center, s * (movable ? 0.36 : 0.32),
            GenjiTheme.teamColor(e[2]), movable);
      }
    });
  }

  String _cellKey(int team, int token, int prog) {
    if (prog == -1) return 'base:$team:$token';
    if (prog >= 56) return 'home:$team:$token';
    if (prog >= 51) return 'hc:$team:$prog';
    return 't:${game.trackPos(team, prog)}';
  }

  Offset _tokenCenter(int team, int token, int prog, double s) {
    if (prog == -1) {
      final spot = BoardGeo.baseSpots[team][token];
      return _c(spot[0], spot[1], s);
    }
    if (prog >= 56) {
      // finished: cluster around the center seal
      const dx = [-0.55, 0.55, -0.55, 0.55];
      const dy = [-0.55, -0.55, 0.55, 0.55];
      return Offset(
          (7.5 + dx[token]) * s, (7.5 + dy[token]) * s);
    }
    if (prog >= 51) {
      final cell = BoardGeo.homeCols[team][prog - 51];
      return _c(cell[0], cell[1], s);
    }
    final cell = BoardGeo.path[game.trackPos(team, prog)];
    return _c(cell[0], cell[1], s);
  }

  /// Ludo King style token: white outer border, glossy radial-gradient
  /// body, inner gold ring, specular highlight. Movable tokens get a
  /// pulsing gold ring around them.
  void _drawToken(
      Canvas canvas, Offset c, double r, Color team, bool movable) {
    if (movable) {
      // Pulsing gold ring around movable tokens.
      canvas.drawCircle(
        c,
        r + 3 + glow * 4,
        Paint()
          ..color = GenjiTheme.goldLight.withOpacity(0.55 + glow * 0.3),
      );
    }
    // Soft drop shadow (token sits above the board).
    canvas.drawCircle(
        c.translate(2, 3.5),
        r * 0.95,
        Paint()..color = Colors.black.withOpacity(0.4));
    // White outer border (classic Ludo King token edge).
    canvas.drawCircle(c, r + 1.5, Paint()..color = Colors.white);
    // Body — radial gradient, bright at top-left, deeper at bottom-right.
    final grad = RadialGradient(
      colors: [
        Colors.white.withOpacity(0.6),
        team.withOpacity(0.85),
        team,
        team.withOpacity(0.85),
      ],
      stops: const [0.0, 0.3, 0.65, 1.0],
      center: const Alignment(-0.45, -0.45),
      radius: 1.15,
    );
    canvas.drawCircle(
        c,
        r,
        Paint()
          ..shader = grad.createShader(Rect.fromCircle(center: c, radius: r)));
    // Inner gold ring for the ornate Genji finish.
    canvas.drawCircle(
        c,
        r * 0.78,
        Paint()
          ..color = GenjiTheme.goldLight.withOpacity(0.9)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5);
    // Glossy specular highlight (top-left, like light on a pawn).
    canvas.drawCircle(
        c.translate(-r * 0.3, -r * 0.35),
        r * 0.2,
        Paint()..color = Colors.white.withOpacity(0.85));
    // Small center dot for depth.
    canvas.drawCircle(
        c, r * 0.16, Paint()..color = Colors.white.withOpacity(0.3));
  }

  void _drawStar(Canvas canvas, Offset c, double r, Color color) {
    final path = Path();
    for (var i = 0; i < 10; i++) {
      final rr = i.isEven ? r : r * 0.45;
      final a = -pi / 2 + i * pi / 5;
      final p = Offset(c.dx + rr * cos(a), c.dy + rr * sin(a));
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    path.close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant BoardPainter old) => true;
}

