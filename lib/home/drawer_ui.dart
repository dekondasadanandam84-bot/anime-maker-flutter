import 'package:flutter/material.dart';
import 'package:flutter_application_1/home/home_controller.dart';
import 'package:flutter_application_1/core/app_media.dart';

class DrawerUI extends StatelessWidget {
  final HomeController controller = const HomeController();

  const DrawerUI({super.key});

  @override
  Widget build(BuildContext context) {
    AppMedia.init(context);

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            //================ HEADER =================//
            SizedBox(
              height: AppMedia.h(64),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: Text(
                      'AnimeClip',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -.3,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Positioned(
                    right: AppMedia.w(16),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close_rounded,
                        color: colorScheme.onSurfaceVariant,
                        size: 26,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Divider(
              height: 1,
              thickness: 1,
              color: colorScheme.outlineVariant,
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: AppMedia.symmetric(
                  horizontal: 24,
                  vertical: 28,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //================ QUICK ACTIONS =================//
                    SizedBox(
                      height: 100,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _QuickActionCard(
                              icon: '⚙️',
                              color: Colors.blue,
                              title: 'Settings',
                              onTap: () =>
                                  controller.openSettings(context),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _QuickActionCard(
                              icon: '🎨',
                              color: Colors.purple,
                              title: 'Templates',
                              onTap: () =>
                                  controller.openTemplates(context),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _QuickActionCard(
                              icon: '🎓',
                              color: Colors.green,
                              title: 'Tutorials',
                              onTap: () =>
                                  controller.openTutorials(context),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    //================ MENU =================//
                    _MenuTile(
                      icon: '💎',
                      iconColor: Colors.indigo,
                      title: 'Go Plus',
                      onTapDown: () {
                        const HomeController().openGoPlus(context);
                      },
                    ),

                    Divider(
                      color: colorScheme.outlineVariant,
                      height: 1,
                    ),

                    _MenuTile(
                      icon: '🤝',
                      iconColor: Colors.orange,
                      title: 'Collaborations',
                      onTapDown: () {
                        controller.openCollaborations(context);
                      },
                    ),

                    Divider(
                      color: colorScheme.outlineVariant,
                      height: 1,
                    ),

                    _MenuTile(
                      icon: '🪙',
                      iconColor: Colors.amber,
                      title: 'Earn Coins',
                      onTapDown: () {
                        controller.openEarnCoins(context);
                      },
                    ),

                    Divider(
                      color: colorScheme.outlineVariant,
                      height: 1,
                    ),

                    _MenuTile(
                      icon: '🌐',
                      iconColor: Colors.blue,
                      title: 'Follow Us',
                      onTapDown: () {
                        controller.openFollowUs(context);
                      },
                    ),

                    Divider(
                      color: colorScheme.outlineVariant,
                      height: 1,
                    ),

                    _MenuTile(
                      icon: 'ℹ️',
                      iconColor: Colors.teal,
                      title: 'About Us',
                      onTapDown: () {
                        controller.openAbout(context);
                      },
                    ),

                    Divider(
                      color: colorScheme.outlineVariant,
                      height: 1,
                    ),

                    _MenuTile(
                      icon: '💡',
                      iconColor: Colors.green,
                      title: 'Help & Guide',
                      onTapDown: () {
                        controller.openHelpGuide(context);
                      },
                    ),

                    Divider(
                      color: colorScheme.outlineVariant,
                      height: 1,
                    ),

                    _AccountTile(
                      controller: controller,
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            Divider(
              height: 1,
              thickness: 1,
              color: colorScheme.outlineVariant,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                'Version 1.0.0',
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String icon;
  final Color color;
  final String title;
  final VoidCallback? onTap;

  const _QuickActionCard({
    required this.icon,
    required this.color,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(
        AppMedia.r(18),
      ),
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 100,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(
            AppMedia.r(18),
          ),
          border: Border.all(
            color: colorScheme.outlineVariant,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(
                alpha: 0.06,
              ),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 6,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 36,
              height: 36,
              child: Center(
                child: Text(
                  icon,
                  style: const TextStyle(
                    fontSize: 24,
                    height: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppMedia.sp(12),
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final String icon;
  final Color iconColor;
  final String title;
  final VoidCallback? onTapDown;

  const _MenuTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.onTapDown,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTapDown: (_) {
        onTapDown?.call();
      },
      child: SizedBox(
        height: 60,
        child: Row(
          children: [
            SizedBox(
              width: 30,
              height: 30,
              child: Center(
                child: Text(
                  icon,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 25,
                    height: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountTile extends StatelessWidget {
  final HomeController controller;

  const _AccountTile({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => controller.openAccounts(context),
      child: SizedBox(
        height: 60,
        child: Row(
          children: [
            Container(
              width: 37,
              height: 37,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: const SizedBox(
                width: 36,
                height: 36,
                child: Center(
                  child: Text(
                    '👤',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                'Account',
                style: TextStyle(
                  fontSize: 16,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}