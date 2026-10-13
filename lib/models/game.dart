import 'dart:math';

/// Classic Ludo rules engine.
///
/// Teams: 0=red, 1=green, 2=yellow, 3=blue (turn order).
/// Token progress: -1 = base, 0..50 = main track, 51..55 = home column,
/// 56 = finished (home triangle).
class LudoGame {
  final int numPlayers;
 final List<int> teams;
  final List<List<int>> progress; // [player][token]
  int turn = 0;
  int? dice;
  int sixStreak = 0;
  List<int> movable = [];
  int? winnerIndex;

  /// Track indices (0..51) that are safe from capture.
  static const List<int> safeCells = [0, 8, 13, 21, 26, 34, 39, 47];

  LudoGame(this.numPlayers)
      : teams = numPlayers == 2 ? [0, 2] : List.generate(numPlayers, (i) => i),
        progress =
            List.generate(numPlayers, (_) => List.filled(4, -1));

  int get currentTeam => teams[turn];
  bool get gameOver => winnerIndex != null;

  int startOffset(int team) => (team * 13) % 52;

  /// Main-track cell 0..51 for a token with progress 0..50.
  int trackPos(int team, int prog) => (startOffset(team) + prog) % 52;

  /// Roll the dice. Sets [dice] and [movable].
  /// Third consecutive six = no move, turn passes (classic rule).
  int rollDice(Random random) {
    final d = 1 + random.nextInt(6);
    dice = d;
    if (d == 6) {
      sixStreak++;
      if (sixStreak >= 3) {
        movable = [];
        return d;
      }
    }
    movable = _movableTokens(d);
    return d;
  }

  List<int> _movableTokens(int d) {
    final res = <int>[];
    for (var i = 0; i < 4; i++) {
      if (_canMove(turn, i, d)) res.add(i);
    }
    return res;
  }

  bool _canMove(int player, int token, int d) {
    final p = progress[player][token];
    if (p == -1) return d == 6;
    if (p >= 56) return false;
    return p + d <= 56;
  }

  /// Move [token] of the current player. Returns what happened.
  MoveResult moveToken(int token) {
    final d = dice!;
    var p = progress[turn][token];
    p = (p == -1) ? 0 : p + d;
    progress[turn][token] = p;

    var captured = false;
    if (p <= 50) {
      final pos = trackPos(currentTeam, p);
      if (!safeCells.contains(pos)) {
        for (var q = 0; q < numPlayers; q++) {
          if (q == turn) continue;
          for (var j = 0; j < 4; j++) {
            final qp = progress[q][j];
            if (qp >= 0 &&
                qp <= 50 &&
                trackPos(teams[q], qp) == pos) {
              progress[q][j] = -1;
              captured = true;
            }
          }
        }
      }
    }

    var won = false;
    if (progress[turn].every((e) => e == 56)) {
      winnerIndex = turn;
      won = true;
    }

    final extraTurn = !won && (d == 6 || captured);
    return MoveResult(captured: captured, won: won, extraTurn: extraTurn);
  }

  void nextTurn() {
    turn = (turn + 1) % numPlayers;
    dice = null;
    movable = [];
    sixStreak = 0;
  }

  /// Simple computer AI: capture > leave base > safe/closest home.
  int chooseAiMove() {
    final d = dice!;
    final team = currentTeam;
    for (final t in movable) {
      final np = progress[turn][t] == -1 ? 0 : progress[turn][t] + d;
      if (np <= 50) {
        final pos = trackPos(team, np);
        if (!safeCells.contains(pos) && _wouldCapture(turn, pos)) return t;
      }
    }
    for (final t in movable) {
      if (progress[turn][t] == -1) return t;
    }
    var best = movable.first;
    var bestScore = -1000000;
    for (final t in movable) {
      final np = progress[turn][t] + d;
      var score = np;
      if (np <= 50) {
        final pos = trackPos(team, np);
        if (safeCells.contains(pos)) score += 30;
        if (_inDanger(turn, np)) score -= 25;
      } else {
        score += 40;
      }
      if (score > bestScore) {
        bestScore = score;
        best = t;
      }
    }
    return best;
  }

  bool _wouldCapture(int player, int pos) {
    for (var q = 0; q < numPlayers; q++) {
      if (q == player) continue;
      for (var j = 0; j < 4; j++) {
        final qp = progress[q][j];
        if (qp >= 0 && qp <= 50 && trackPos(teams[q], qp) == pos) {
          return true;
        }
      }
    }
    return false;
  }

  bool _inDanger(int player, int newProg) {
    if (newProg > 50) return false;
    final pos = trackPos(teams[player], newProg);
    if (safeCells.contains(pos)) return false;
    for (var q = 0; q < numPlayers; q++) {
      if (q == player) continue;
      for (var j = 0; j < 4; j++) {
        final qp = progress[q][j];
        if (qp < 0 || qp > 50) continue;
        final dist = (pos - trackPos(teams[q], qp) + 52) % 52;
        if (dist >= 1 && dist <= 6) return true;
      }
    }
    return false;
  }
}

class MoveResult {
  final bool captured;
  final bool won;
  final bool extraTurn;
  const MoveResult(
      {required this.captured, required this.won, required this.extraTurn});
}
