import 'package:shared_preferences/shared_preferences.dart';

/// Local persistence: profile, coins, stats, settings.
class GameStore {
  static final GameStore _i = GameStore._internal();
  factory GameStore() => _i;
  GameStore._internal();

  late SharedPreferences _prefs;
  bool _ready = false;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _ready = true;
    // seed reference stats on first run
    if (!_prefs.containsKey('wins')) {
      await _prefs.setInt('wins', 38);
      await _prefs.setInt('losses', 10);
      await _prefs.setInt('draws', 2);
      await _prefs.setInt('coins', 1000);
    }
    if (!_prefs.containsKey('username')) {
      await _prefs.setString('username', 'Avanr');
    }
  }

  bool get ready => _ready;

  String get username => _prefs.getString('username') ?? 'Avanr';
  set username(String v) => _prefs.setString('username', v);

  int get avatarIndex => _prefs.getInt('avatarIndex') ?? 0;
  set avatarIndex(int v) => _prefs.setInt('avatarIndex', v);

  int get frameIndex => _prefs.getInt('frameIndex') ?? 0;
  set frameIndex(int v) => _prefs.setInt('frameIndex', v);

  int get coins => _prefs.getInt('coins') ?? 1000;
  set coins(int v) => _prefs.setInt('coins', v);

  int get wins => _prefs.getInt('wins') ?? 0;
  int get losses => _prefs.getInt('losses') ?? 0;
  int get draws => _prefs.getInt('draws') ?? 0;

  Future<void> recordResult({required bool won, required bool draw}) async {
    if (draw) {
      await _prefs.setInt('draws', draws + 1);
    } else if (won) {
      await _prefs.setInt('wins', wins + 1);
      coins = coins + 200;
    } else {
      await _prefs.setInt('losses', losses + 1);
      coins = coins + 25;
    }
  }

  bool get isPro => _prefs.getBool('isPro') ?? false;
  set isPro(bool v) => _prefs.setBool('isPro', v);

  bool get loggedIn => _prefs.getBool('loggedIn') ?? false;
  set loggedIn(bool v) => _prefs.setBool('loggedIn', v);

  bool get soundOn => _prefs.getBool('soundOn') ?? true;
  set soundOn(bool v) => _prefs.setBool('soundOn', v);

  String? get lastSpinDate => _prefs.getString('lastSpinDate');
  set lastSpinDate(String? v) {
    if (v == null) {
      _prefs.remove('lastSpinDate');
    } else {
      _prefs.setString('lastSpinDate', v);
    }
  }

  int get rewardDay => _prefs.getInt('rewardDay') ?? 0;
  set rewardDay(int v) => _prefs.setInt('rewardDay', v);

  List<String> get ownedFrames =>
      _prefs.getStringList('ownedFrames') ?? ['0'];
  Future<void> addOwnedFrame(String id) async {
    final l = ownedFrames;
    if (!l.contains(id)) {
      l.add(id);
      await _prefs.setStringList('ownedFrames', l);
    }
  }

  Future<void> resetAll() async {
    await _prefs.clear();
    await init();
  }
}

const List<String> avatarAssets = [
  'assets/avatars/avatar_knight.png',
  'assets/avatars/avatar_sorceress.png',
  'assets/avatars/avatar_archer.png',
  'assets/avatars/avatar_dwarf.png',
  'assets/avatars/avatar_mage.png',
  'assets/avatars/avatar_dragon.png',
];

const List<String> avatarNames = [
  'Knight',
  'Sorceress',
  'Archer',
  'Dwarf King',
  'Dark Mage',
  'Dragon',
];
