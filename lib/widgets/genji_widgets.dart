import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/genji_theme.dart';
import '../services/store.dart';
import '../services/sound_service.dart';

/// Crimson button with gold trim — primary CTA style.
class GoldButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final double fontSize;
  final EdgeInsets padding;

  const GoldButton({
    super.key,
    required this.label,
    this.onTap,
    this.fontSize = 20,
    this.padding = const EdgeInsets.symmetric(vertical: 14),
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onTap == null ? 0.45 : 1,
      child: GestureDetector(
        onTap: onTap == null
            ? null
            : () {
                SoundService().play('click');
                onTap?.call();
              },
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            gradient: GenjiTheme.crimsonGradient,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: GenjiTheme.gold, width: 2),
            boxShadow: [
              BoxShadow(
                color: GenjiTheme.crimson.withOpacity(0.5),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GenjiTheme.titleGold.copyWith(
              fontSize: fontSize,
              color: GenjiTheme.parchment,
            ),
          ),
        ),
      ),
    );
  }
}

/// Dark ornate card with gold border.
class OrnateCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double radius;

  const OrnateCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius = 18,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E2440), Color(0xFF141832)],
        ),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
            color: GenjiTheme.gold.withOpacity(0.55), width: 1.5),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.45),
              blurRadius: 14,
              offset: const Offset(0, 6)),
        ],
      ),
      child: child,
    );
  }
}

/// Screen header with back button + gold serif title.
class ScreenHeader extends StatelessWidget {
  final String title;
  final List<Widget> actions;

  const ScreenHeader(
      {super.key, required this.title, this.actions = const []});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_rounded,
                  color: GenjiTheme.goldLight),
              onPressed: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: Text(
                title,
                style: GenjiTheme.titleGold.copyWith(fontSize: 24),
              ),
            ),
            ...actions,
          ],
        ),
      ),
    );
  }
}

/// Coin balance pill.
class CoinPill extends StatelessWidget {
  final int coins;
  const CoinPill({super.key, required this.coins});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.45),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: GenjiTheme.gold.withOpacity(0.6), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.monetization_on_rounded,
              color: GenjiTheme.goldLight, size: 18),
          const SizedBox(width: 6),
          Text(
            '$coins',
            style: const TextStyle(
              color: GenjiTheme.parchment,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

/// Player avatar with selectable ornate frame.
class AvatarCircle extends StatelessWidget {
  final int avatarIndex;
  final int frameIndex;
  final double size;

  const AvatarCircle({
    super.key,
    required this.avatarIndex,
    required this.frameIndex,
    this.size = 56,
  });

  @override
  Widget build(BuildContext context) {
    final frameColors = [
      GenjiTheme.gold,
      GenjiTheme.magicBlue,
      GenjiTheme.crimsonLight,
      const Color(0xFF9D4EDD),
      const Color(0xFF2EC4B6),
      const Color(0xFFFF9F1C),
    ];
    final fc = frameColors[frameIndex % frameColors.length];
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: fc, width: 3),
        boxShadow: [
          BoxShadow(
              color: fc.withOpacity(0.55),
              blurRadius: 12,
              spreadRadius: 1),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          avatarAssets[avatarIndex % avatarAssets.length],
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: GenjiTheme.bgCard,
            child: const Icon(Icons.person_rounded,
                color: GenjiTheme.goldLight),
          ),
        ),
      ),
    );
  }
}

/// Ludo dice with pips.
class DiceWidget extends StatelessWidget {
  final int value;
  final double size;
  final bool rolling;

  const DiceWidget({
    super.key,
    required this.value,
    this.size = 64,
    this.rolling = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
      turns: rolling ? 1 : 0,
      duration: const Duration(milliseconds: 450),
      child: AnimatedScale(
        scale: rolling ? 1.15 : 1.0,
        duration: const Duration(milliseconds: 225),
        child: CustomPaint(
          size: Size(size, size),
          painter: _DicePainter(value),
        ),
      ),
    );
  }
}

class _DicePainter extends CustomPainter {
  final int value;
  _DicePainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final r = size.width;
    // 3D drop shadow — bigger, offset down-right, soft (physical cube).
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(3, 6, r - 3, r - 3),
          Radius.circular(r * 0.22)),
      Paint()..color = Colors.black.withOpacity(0.5),
    );
    // ivory body with 3D gradient (bright top-left → darker bottom-right)
    final body = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, r, r), Radius.circular(r * 0.22));
    final grad = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        const Color(0xFFFFFFFF),
        const Color(0xFFFFFDF5),
        const Color(0xFFE8DCC0),
        const Color(0xFFD4C4A0),
      ],
      stops: const [0.0, 0.35, 0.75, 1.0],
    );
    canvas.drawRRect(
        body, Paint()..shader = grad.createShader(body.outerRect));
    // bevel: light top edge, dark bottom edge (3D cube feel)
    canvas.drawRRect(
      body,
      Paint()
        ..color = Colors.white.withOpacity(0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = r * 0.02,
    );
    // gold border
    canvas.drawRRect(
      body,
      Paint()
        ..color = GenjiTheme.gold
        ..style = PaintingStyle.stroke
        ..strokeWidth = r * 0.04,
    );
    // top-left gloss highlight (light hitting the cube face)
    final gloss = RRect.fromRectAndRadius(
        Rect.fromLTWH(r * 0.08, r * 0.05, r * 0.52, r * 0.3),
        Radius.circular(r * 0.15));
    canvas.drawRRect(
        gloss, Paint()..color = Colors.white.withOpacity(0.4));
    // pips — inset shadow + tiny highlight for 3D depth
    final pipShadow =
        Paint()..color = Colors.black.withOpacity(0.25);
    final pip = Paint()..color = const Color(0xFF7A1F1F);
    final pipGloss =
        Paint()..color = Colors.white.withOpacity(0.4);
    final o = r * 0.26;
    final c = r / 2;
    final pts = {
      1: [Offset(c, c)],
      2: [Offset(c - o, c - o), Offset(c + o, c + o)],
      3: [
        Offset(c - o, c - o),
        Offset(c, c),
        Offset(c + o, c + o)
      ],
      4: [
        Offset(c - o, c - o),
        Offset(c + o, c - o),
        Offset(c - o, c + o),
        Offset(c + o, c + o)
      ],
      5: [
        Offset(c - o, c - o),
        Offset(c + o, c - o),
        Offset(c, c),
        Offset(c - o, c + o),
        Offset(c + o, c + o)
      ],
      6: [
        Offset(c - o, c - o),
        Offset(c + o, c - o),
        Offset(c - o, c),
        Offset(c + o, c),
        Offset(c - o, c + o),
        Offset(c + o, c + o)
      ],
    };
    for (final p in pts[value.clamp(1, 6)]!) {
      // inset shadow (pip sits slightly into the face)
      canvas.drawCircle(p.translate(1, 1.5), r * 0.085, pipShadow);
      canvas.drawCircle(p, r * 0.085, pip);
      // tiny specular highlight on each pip
      canvas.drawCircle(
          p.translate(-r * 0.02, -r * 0.025),
          r * 0.02,
          pipGloss);
    }
  }

  @override
  bool shouldRepaint(covariant _DicePainter old) =>
      old.value != value;
}

/// Spinning prize wheel.
class SpinWheelPainter extends CustomPainter {
  final List<int> prizes;
  final double angle; // current rotation

  SpinWheelPainter({required this.prizes, required this.angle});

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2;
    final n = prizes.length;
    final sweep = 2 * pi / n;
    final colors = [
      const Color(0xFFB91C1C),
      const Color(0xFF1E2440),
    ];
    for (var i = 0; i < n; i++) {
      final paint = Paint()..color = colors[i % 2];
      canvas.drawArc(
          Rect.fromCircle(center: c, radius: r),
          angle + i * sweep,
          sweep,
          true,
          paint);
      // divider
      canvas.drawLine(
          c,
          c + Offset(cos(angle + i * sweep), sin(angle + i * sweep)) * r,
          Paint()
            ..color = GenjiTheme.gold
            ..strokeWidth = 2);
      // label
      final mid = angle + (i + 0.5) * sweep;
      final tp = TextPainter(
        text: TextSpan(
          text: '${prizes[i]}',
          style: const TextStyle(
              color: GenjiTheme.parchment,
              fontSize: 13,
              fontWeight: FontWeight.bold),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      final lp = c +
          Offset(cos(mid), sin(mid)) * r * 0.68 +
          Offset(-tp.width / 2, -tp.height / 2);
      tp.paint(canvas, lp);
    }
    // gold rim
    canvas.drawCircle(
        c,
        r,
        Paint()
          ..color = GenjiTheme.gold
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6);
    canvas.drawCircle(
        c,
        r * 0.14,
        Paint()
          ..shader = GenjiTheme.goldGradient
              .createShader(Rect.fromCircle(center: c, radius: r * 0.14)));
  }

  @override
  bool shouldRepaint(covariant SpinWheelPainter old) =>
      old.angle != angle;
}

