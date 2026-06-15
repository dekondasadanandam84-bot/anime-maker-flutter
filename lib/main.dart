import 'package:flutter/material.dart';

void main() => runApp(const AnimeMakerApp());

// ---------------------------------------------------------------------------
// APP ROOT
// ---------------------------------------------------------------------------
class AnimeMakerApp extends StatelessWidget {
  const AnimeMakerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anime Maker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const HomeDashboardScreen(),
    );
  }
}

// ---------------------------------------------------------------------------
// HOME DASHBOARD
// ---------------------------------------------------------------------------
class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  int _selectedNavIndex = 1; // 1 = Projects (default tab)

  void _onNavTap(int index) => setState(() => _selectedNavIndex = index);

  void _onCreatePressed() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const CreateProjectSheet(),
    );
  }

  void _onProfilePressed() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ProfileScreen()),
    );
  }

  void _onGoProPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const GoProScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final topPadding = mq.padding.top;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 600;
          final horizontalPadding = isWide ? 32.0 : 16.0;

          return Column(
            children: [
              SizedBox(height: topPadding > 0 ? 0 : 8),
              _TopBar(
                horizontalPadding: horizontalPadding,
                titleFontSize: isWide ? 28 : 22,
                onProfileTap: _onProfilePressed,
                onGoProTap: _onGoProPressed,
              ),
              const Divider(height: 1, thickness: 1),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  16,
                  horizontalPadding,
                  8,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Your creations',
                    style: TextStyle(
                      fontSize: isWide ? 16 : 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _EmptyCreationsView(
                  isWide: isWide,
                  onCreateTap: _onCreatePressed,
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: _AnimeBottomNavBar(
          selectedIndex: _selectedNavIndex,
          onTap: _onNavTap,
          onCreateTap: _onCreatePressed,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// TOP BAR — profile | "ANIME MAKER" | Go Pro
// ---------------------------------------------------------------------------
class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.horizontalPadding,
    required this.titleFontSize,
    required this.onProfileTap,
    required this.onGoProTap,
  });

  final double horizontalPadding;
  final double titleFontSize;
  final VoidCallback onProfileTap;
  final VoidCallback onGoProTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 12,
      ),
      child: Row(
        children: [
          TapScale(
            onTap: onProfileTap,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.deepPurple.shade50,
              child: Icon(
                Icons.person_outline,
                color: Colors.deepPurple.shade400,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'ANIME MAKER',
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 1.4,
                  color: Colors.deepPurple.shade700,
                ),
              ),
            ),
          ),
          TapScale(
            onTap: onGoProTap,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.deepPurple.shade100),
              ),
              child: Text(
                'Go Pro',
                style: TextStyle(
                  color: Colors.deepPurple.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// EMPTY STATE — "You haven't created a project yet"
// ---------------------------------------------------------------------------
class _EmptyCreationsView extends StatelessWidget {
  const _EmptyCreationsView({
    required this.isWide,
    required this.onCreateTap,
  });

  final bool isWide;
  final VoidCallback onCreateTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.movie_creation_outlined,
              size: isWide ? 96 : 72,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              "You haven't created a project yet",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isWide ? 18 : 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Tap the + Create button below to get started',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isWide ? 14 : 13,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 20),
            TapScale(
              onTap: onCreateTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, color: Colors.white, size: 18),
                    SizedBox(width: 6),
                    Text(
                      'Create',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
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

// ---------------------------------------------------------------------------
// TAP SCALE ANIMATION — reusable wrapper for tap feedback
// ---------------------------------------------------------------------------
class TapScale extends StatefulWidget {
  const TapScale({super.key, required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  State<TapScale> createState() => _TapScaleState();
}

class _TapScaleState extends State<TapScale> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _scale = 0.92),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// BOTTOM NAV BAR — Collaboration | Projects | (+Create FAB) | Earn Credits
// ---------------------------------------------------------------------------
class _NavSlotData {
  const _NavSlotData({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
}

class _AnimeBottomNavBar extends StatelessWidget {
  const _AnimeBottomNavBar({
    required this.selectedIndex,
    required this.onTap,
    required this.onCreateTap,
  });

  final int selectedIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onCreateTap;

  // Index 2 is reserved for the center FAB (not a selectable tab).
  static const List<_NavSlotData?> _slots = [
    _NavSlotData(
      icon: Icons.groups_outlined,
      activeIcon: Icons.groups,
      label: 'Collaboration',
    ),
    _NavSlotData(
      icon: Icons.folder_outlined,
      activeIcon: Icons.folder,
      label: 'Projects',
    ),
    null,
    _NavSlotData(
      icon: Icons.workspace_premium_outlined,
      activeIcon: Icons.workspace_premium,
      label: 'Earn Credits',
    ),
  ];

  double _indicatorAlignX(int index) => -1 + (index + 0.5) * 0.5;

  @override
  Widget build(BuildContext context) {
    const barHeight = 64.0;
    const fabSize = 60.0;

    return SizedBox(
      height: barHeight + (fabSize / 2),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: barHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Stack(
              children: [
                AnimatedAlign(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOut,
                  alignment: Alignment(_indicatorAlignX(selectedIndex), -1),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Container(
                      width: 28,
                      height: 3,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: List.generate(_slots.length, (index) {
                    final slot = _slots[index];
                    if (slot == null) {
                      return const Expanded(child: SizedBox());
                    }
                    final selected = index == selectedIndex;
                    return Expanded(
                      child: TapScale(
                        onTap: () => onTap(index),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 14),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                selected ? slot.activeIcon : slot.icon,
                                color: selected
                                    ? Colors.deepPurple
                                    : Colors.grey.shade500,
                                size: 24,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                slot.label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: selected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: selected
                                      ? Colors.deepPurple
                                      : Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            child: TapScale(
              onTap: onCreateTap,
              child: Container(
                width: fabSize,
                height: fabSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.deepPurple,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 28),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// CREATE PROJECT SHEET — manga / anime / background picker
// ---------------------------------------------------------------------------
class CreateProjectSheet extends StatelessWidget {
  const CreateProjectSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Create new project',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 16),
            _CreateOptionTile(
              icon: Icons.menu_book_outlined,
              title: 'Manga book',
              subtitle: 'Create comic panels and pages',
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const MangaCreatorScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _CreateOptionTile(
              icon: Icons.theaters_outlined,
              title: 'Anime',
              subtitle: 'Animate your characters and scenes',
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const AnimeCreatorScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _CreateOptionTile(
              icon: Icons.landscape_outlined,
              title: 'Background',
              subtitle: 'Design reusable scene backgrounds',
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const BackgroundCreatorScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateOptionTile extends StatelessWidget {
  const _CreateOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TapScale(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade50,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.white,
              child: Icon(icon, color: Colors.deepPurple),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// PROFILE SCREEN
// ---------------------------------------------------------------------------
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(child: Text('Profile / account settings')),
    );
  }
}

// ---------------------------------------------------------------------------
// MANGA / ANIME / BACKGROUND CREATOR PLACEHOLDERS
// ---------------------------------------------------------------------------
class MangaCreatorScreen extends StatelessWidget {
  const MangaCreatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manga book')),
      body: const Center(child: Text('Manga panel / page editor')),
    );
  }
}

class AnimeCreatorScreen extends StatelessWidget {
  const AnimeCreatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Anime')),
      body: const Center(child: Text('Animation timeline')),
    );
  }
}

class BackgroundCreatorScreen extends StatelessWidget {
  const BackgroundCreatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Background')),
      body: const Center(child: Text('Background creation canvas')),
    );
  }
}

// ---------------------------------------------------------------------------
// GO PRO / PAYWALL
// ---------------------------------------------------------------------------
class GoProScreen extends StatelessWidget {
  const GoProScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Go Pro')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 600;
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: isWide ? 480 : 360),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.workspace_premium,
                      size: isWide ? 80 : 64,
                      color: Colors.deepPurple,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Unlock Anime Maker Pro',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isWide ? 22 : 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Unlimited projects, cloud sync to Google Drive, '
                      'and exclusive brushes & templates.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const _ProFeatureRow(
                      icon: Icons.cloud_done_outlined,
                      label: 'Cloud backup to Google Drive',
                    ),
                    const _ProFeatureRow(
                      icon: Icons.all_inclusive,
                      label: 'Unlimited manga, anime & background projects',
                    ),
                    const _ProFeatureRow(
                      icon: Icons.brush_outlined,
                      label: 'Exclusive brushes, fonts & templates',
                    ),
                    const _ProFeatureRow(
                      icon: Icons.block_outlined,
                      label: 'No watermark on exports',
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: TapScale(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Center(
                            child: Text(
                              'Upgrade to Pro',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProFeatureRow extends StatelessWidget {
  const _ProFeatureRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }
}