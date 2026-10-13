import 'package:audioplayers/audioplayers.dart';

/// Pooled sound-effects player (short WAVs in assets/sounds/).
class SoundService {
  static final SoundService _i = SoundService._internal();
  factory SoundService() => _i;
  SoundService._internal();

  bool enabled = true;
  final List<AudioPlayer> _pool =
      List.generate(4, (_) => AudioPlayer());
  int _next = 0;

  Future<void> play(String name) async {
    if (!enabled) return;
    try {
      final p = _pool[_next];
      _next = (_next + 1) % _pool.length;
      await p.play(AssetSource('sounds/$name.wav'));
    } catch (_) {}
  }
}
