import 'package:flutter/material.dart';
import 'services/store.dart';
import 'services/sound_service.dart';
import 'theme/genji_theme.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GameStore().init();
  SoundService().enabled = GameStore().soundOn;
  runApp(const LudoGenjiApp());
}

class LudoGenjiApp extends StatelessWidget {
  const LudoGenjiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LUDO GENJI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: GenjiTheme.bgDeep,
        colorScheme: ColorScheme.fromSeed(
          seedColor: GenjiTheme.gold,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
