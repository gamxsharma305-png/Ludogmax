import 'package:flutter/material.dart';
import '../theme/genji_theme.dart';
import '../services/store.dart';
import '../widgets/genji_widgets.dart';

/// Player Avatar — avatar grid, frames, username, save.
class AvatarScreen extends StatefulWidget {
  const AvatarScreen({super.key});

  @override
  State<AvatarScreen> createState() => _AvatarScreenState();
}

class _AvatarScreenState extends State<AvatarScreen> {
  late int _avatar;
  late int _frame;
  late TextEditingController _name;

  final frameColors = [
    GenjiTheme.gold,
    GenjiTheme.magicBlue,
    GenjiTheme.crimsonLight,
    const Color(0xFF9D4EDD),
    const Color(0xFF2EC4B6),
    const Color(0xFFFF9F1C),
  ];

  @override
  void initState() {
    super.initState();
    final s = GameStore();
    _avatar = s.avatarIndex;
    _frame = s.frameIndex;
    _name = TextEditingController(text: s.username);
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _save() {
    final s = GameStore();
    s.avatarIndex = _avatar;
    s.frameIndex = _frame;
    final n = _name.text.trim();
    if (n.isNotEmpty) s.username = n;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Avatar saved!')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: GenjiTheme.bgGradient),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ScreenHeader(title: 'Player Avatar'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          AvatarCircle(
                            avatarIndex: _avatar,
                            frameIndex: _frame,
                            size: 120,
                          ),
                          const SizedBox(height: 8),
                          Text('Avatar',
                              style: GenjiTheme.bodyMuted),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text('Username',
                        style: GenjiTheme.heading
                            .copyWith(fontSize: 16)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _name,
                      style: const TextStyle(
                          color: GenjiTheme.parchment),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor:
                            Colors.black.withOpacity(0.35),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: GenjiTheme.gold
                                  .withOpacity(0.35)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: GenjiTheme.gold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text('Avatar',
                        style: GenjiTheme.heading
                            .copyWith(fontSize: 16)),
                    const SizedBox(height: 10),
                    GridView.builder(
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                      ),
                      itemCount: avatarAssets.length,
                      itemBuilder: (_, i) => GestureDetector(
                        onTap: () =>
                            setState(() => _avatar = i),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(16),
                            border: Border.all(
                              color: _avatar == i
                                  ? GenjiTheme.goldLight
                                  : GenjiTheme.gold
                                      .withOpacity(0.25),
                              width: _avatar == i ? 3 : 1,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(14),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.asset(
                                  avatarAssets[i],
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __,
                                          ___) =>
                                      Container(
                                          color: GenjiTheme
                                              .bgCard),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    color: Colors.black
                                        .withOpacity(0.6),
                                    padding:
                                        const EdgeInsets
                                            .symmetric(
                                                vertical: 4),
                                    child: Text(
                                      avatarNames[i],
                                      textAlign:
                                          TextAlign.center,
                                      style:
                                          const TextStyle(
                                        color: GenjiTheme
                                            .parchment,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text('Frames',
                        style: GenjiTheme.heading
                            .copyWith(fontSize: 16)),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 72,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: frameColors.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(width: 12),
                        itemBuilder: (_, i) =>
                            GestureDetector(
                          onTap: () =>
                              setState(() => _frame = i),
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: frameColors[i],
                                width: _frame == i ? 4 : 2,
                              ),
                            ),
                            child: Center(
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: frameColors[i]
                                      .withOpacity(0.25),
                                ),
                                child: Icon(
                                    Icons.person_rounded,
                                    color: frameColors[i]),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    GoldButton(label: 'Save', onTap: _save),
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
