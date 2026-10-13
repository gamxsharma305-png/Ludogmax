import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/genji_theme.dart';
import '../services/store.dart';
import '../services/sound_service.dart';
import '../widgets/genji_widgets.dart';

/// Daily Spin — fortune wheel, once per day.
class SpinScreen extends StatefulWidget {
  const SpinScreen({super.key});

  @override
  State<SpinScreen> createState() => _SpinScreenState();
}

class _SpinScreenState extends State<SpinScreen>
    with SingleTickerProviderStateMixin {
  static const prizes = [50, 100, 200, 500, 100, 1000, 200, 50];
  late AnimationController _c;
  Tween<double>? _tween;
  double _angle = 0;
  bool _spinning = false;
  int? _won;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(seconds: 4));
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  bool get _canSpin {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    return GameStore().lastSpinDate != today;
  }

  void _spin() {
    if (_spinning || !_canSpin) return;
    SoundService().play('dice');
    final rand = Random();
    final target = rand.nextInt(prizes.length);
    final sweep = 2 * pi / prizes.length;
    // segment centers sit at (i+0.5)*sweep; rotate so target lands on top (-pi/2)
    final desired = -pi / 2 - (target + 0.5) * sweep;
    final delta = (desired - _angle) % (2 * pi);
    final total = 5 * 2 * pi + delta;
    _tween = Tween(begin: _angle, end: _angle + total);
    setState(() {
      _spinning = true;
      _won = null;
    });
    _c.reset();
    _c.forward().then((_) {
      final store = GameStore();
      store.coins = store.coins + prizes[target];
      store.lastSpinDate =
          DateTime.now().toIso8601String().substring(0, 10);
      SoundService().play('win');
      setState(() {
        _spinning = false;
        _won = prizes[target];
        _angle = _angle + total;
        _tween = null;
      });
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
            const ScreenHeader(title: 'Daily Spin'),
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Column(
                  children: [
                    Text(
                      _canSpin
                          ? 'Spin the wheel of fortune!'
                          : 'Come back tomorrow!',
                      style: GenjiTheme.titleGold
                          .copyWith(fontSize: 22),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        SizedBox(
                          width: 300,
                          height: 300,
                          child: AnimatedBuilder(
                            animation: _c,
                            builder: (_, __) =>
                                CustomPaint(
                              painter: SpinWheelPainter(
                                prizes: prizes,
                                angle: _tween != null
                                    ? _tween!.evaluate(_c)
                                    : _angle,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin:
                              const EdgeInsets.only(top: 6),
                          width: 0,
                          height: 0,
                          decoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                  width: 13,
                                  color: Colors.transparent),
                              right: BorderSide(
                                  width: 13,
                                  color: Colors.transparent),
                              top: BorderSide(
                                  width: 20,
                                  color:
                                      GenjiTheme.goldLight),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    if (_won != null)
                      Padding(
                        padding:
                            const EdgeInsets.only(bottom: 12),
                        child: Text(
                          '🎉 You won $_won coins!',
                          style: const TextStyle(
                            color: GenjiTheme.goldLight,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    GoldButton(
                      label: _spinning
                          ? 'Spinning...'
                          : (_canSpin
                              ? 'SPIN'
                              : 'Already claimed'),
                      onTap:
                          (_spinning || !_canSpin)
                              ? null
                              : _spin,
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
