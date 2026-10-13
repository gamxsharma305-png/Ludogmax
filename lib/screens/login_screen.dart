import 'package:flutter/material.dart';
import '../theme/genji_theme.dart';
import '../services/store.dart';
import '../widgets/genji_widgets.dart';
import 'main_hub_screen.dart';

/// Log in to LUDO GENJI — "Begin Your Quest" starts the journey.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  void _login() {
    final name = _email.text.trim();
    if (name.isNotEmpty && name.contains('@')) {
      GameStore().username = name.split('@').first;
    }
    GameStore().loggedIn = true;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainHubScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: GenjiTheme.bgGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 48),
                Center(
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                          color: GenjiTheme.gold, width: 2.5),
                      boxShadow: [
                        BoxShadow(
                          color:
                              GenjiTheme.gold.withOpacity(0.4),
                          blurRadius: 28,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(21),
                      child: Image.asset(
                        'assets/icon/ludo_genji_icon.png',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: GenjiTheme.bgCard,
                          alignment: Alignment.center,
                          child: Text('L',
                              style: GenjiTheme.titleGold
                                  .copyWith(fontSize: 54)),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'Log in to Ludo Genji',
                    style: GenjiTheme.titleGold.copyWith(fontSize: 30),
                  ),
                ),
                const SizedBox(height: 28),
                OrnateCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Log in to Ludo Genji',
                        style: GenjiTheme.heading.copyWith(fontSize: 17),
                      ),
                      const SizedBox(height: 16),
                      _field(
                        controller: _email,
                        hint: 'Email',
                        icon: Icons.mail_outline_rounded,
                      ),
                      const SizedBox(height: 12),
                      _field(
                        controller: _pass,
                        hint: 'Password',
                        icon: Icons.lock_outline_rounded,
                        obscure: _obscure,
                        suffix: IconButton(
                          icon: Icon(
                            _obscure
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                            color: GenjiTheme.muted,
                          ),
                          onPressed: () =>
                              setState(() => _obscure = !_obscure),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Forgot password?',
                            style: TextStyle(
                                color: GenjiTheme.goldLight,
                                fontSize: 13),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      GoldButton(
                        label: 'Begin Your Quest',
                        onTap: _login,
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: TextButton(
                          onPressed: _login,
                          child: const Text(
                            'Continue as Guest',
                            style: TextStyle(
                                color: GenjiTheme.muted,
                                fontSize: 13),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: GenjiTheme.parchment),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            const TextStyle(color: GenjiTheme.muted, fontSize: 14),
        prefixIcon:
            Icon(icon, color: GenjiTheme.goldLight, size: 20),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.black.withOpacity(0.35),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: GenjiTheme.gold.withOpacity(0.35)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: GenjiTheme.gold, width: 1.5),
        ),
      ),
    );
  }
}
