import 'package:flutter/material.dart';
import '../theme/genji_theme.dart';
import '../services/store.dart';
import 'login_screen.dart';
import 'main_hub_screen.dart';

/// Ludo Genji Pro Master — branding splash.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1400));
    _scale = CurvedAnimation(parent: _c, curve: Curves.elasticOut);
    _fade = CurvedAnimation(parent: _c, curve: Curves.easeIn);
    _c.forward();
    Future.delayed(const Duration(milliseconds: 2600), _go);
  }

  void _go() {
    if (!mounted) return;
    final next = GameStore().loggedIn
        ? const MainHubScreen()
        : const LoginScreen();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => next),
    );
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: GenjiTheme.bgGradient),
        child: SafeArea(
          child: Center(
            child: FadeTransition(
              opacity: _fade,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ScaleTransition(
                    scale: _scale,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                            color: GenjiTheme.gold, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: GenjiTheme.gold
                                .withOpacity(0.45),
                            blurRadius: 40,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(29),
                        child: Image.asset(
                          'assets/icon/ludo_genji_icon.png',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Container(
                            color: GenjiTheme.bgCard,
                            alignment: Alignment.center,
                            child: Text(
                              'L',
                              style: GenjiTheme.titleGold
                                  .copyWith(fontSize: 72),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'Ludo Genji',
                    style: GenjiTheme.titleGold.copyWith(
                      fontSize: 46,
                      shadows: [
                        Shadow(
                          color: GenjiTheme.gold.withOpacity(0.6),
                          blurRadius: 18,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Ludo Genji Pro Master',
                    style: GenjiTheme.heading.copyWith(
                      fontSize: 17,
                      color: GenjiTheme.muted,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 40),
                  const SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      color: GenjiTheme.gold,
                      strokeWidth: 3,
                    ),
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
