# LUDO GENJI ♞

Dark-fantasy magical Ludo game — **Ludo Genji Pro Master** edition.

## Features
- **Splash** — Ludo Genji Pro Master branding with gold emblem
- **Login** — "Begin Your Quest" entry
- **Main Hub** — 9 game tiles: Computer, Pass and Play, Online Multiplayer,
  Tournaments, Leaderboard, Shop, Daily Spin, Rewards, Settings + Genji Pro banner
- **Player Selection** — Computer / 2P / 3P / 4P + 4 board themes
- **Full Ludo gameplay** — classic rules: roll 6 to leave base, captures,
  safe star cells, extra turns, exact roll to finish, 3-sixes forfeit
- **Genji AI** — computer opponent with capture-first heuristics
- **Player Avatar** — 6 fantasy avatars, 6 frames, username (default: Avanr)
- **Genji Pro** — $4.99 weekly / $39.99 annual AI assistant (demo purchase)
- **Statistics & Leaderboard** — wins/losses/draws, Global/Local tabs
- **Daily Spin, Shop, Rewards, Tournaments, Settings** — coins economy

## Build (APK)
Online APK builder (Flutter mode) par zip upload karo — gradle wrapper included hai.

Ya local:
```
flutter pub get
flutter build apk --release
```

## Project structure
- `lib/models/game.dart` — Ludo rules engine + AI
- `lib/painters/board_painter.dart` — 15x15 custom-painted board
- `lib/screens/` — 16 screens
- `lib/theme/`, `lib/widgets/`, `lib/services/` — theme, shared widgets, prefs store
- `assets/` — icon, 6 avatars, Genji Pro knight art, IM Fell English font (OFL)

Package: `com.gamx.ludogenji`

## Sound effects (Oct 13)
7 synthesized WAVs in `assets/sounds/` — click, dice rattle, token-move chirp,
capture sweep, six sparkle, win fanfare, turn chime — via `audioplayers ^5.2.1`
(Flutter >=3.10 compatible). Pooled `SoundService` (4 players) wired into
GoldButton, gameplay, spin wheel, rewards; Settings toggle controls it.
