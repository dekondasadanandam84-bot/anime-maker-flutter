import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/app_media.dart';
import 'package:flutter_application_1/home/home_controller.dart';

class DrawerUI extends StatelessWidget {
  final HomeController controller = const HomeController();

  const DrawerUI({super.key});

  @override
  Widget build(BuildContext context) {
    AppMedia.init(context);

    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isLandscape =
              MediaQuery.orientationOf(context) == Orientation.landscape;

          // Landscape drawer = exactly half the available width.
          // Portrait drawer = full available width.
          final drawerWidth = isLandscape
              ? constraints.maxWidth * 0.5
              : constraints.maxWidth;

          final headerHeight = isLandscape ? 56.0 : 64.0;
          final headerFontSize = isLandscape ? 18.0 : 22.0;
          final contentHorizontalPadding =
              isLandscape ? 20.0 : 24.0;
          final contentVerticalPadding =
              isLandscape ? 20.0 : 28.0;
          final quickActionsBottomSpacing =
              isLandscape ? 28.0 : 40.0;
          final versionVerticalPadding =
              isLandscape ? 14.0 : 24.0;

          return Stack(
            fit: StackFit.expand,
            children: [
              // ==========================================================
              // OUTSIDE AREA
              // Home UI remains visible behind this area.
              // ==========================================================

              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    color: Colors.black.withValues(
                      alpha: 0.18,
                    ),
                  ),
                ),
              ),

              // ==========================================================
              // DRAWER
              // ==========================================================

              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: drawerWidth,
                  height: double.infinity,
                  child: Material(
                    color: colorScheme.surface,
                    elevation: 18,
                    shadowColor: colorScheme.shadow.withValues(
                      alpha: 0.25,
                    ),
                    child: SafeArea(
                      child: Column(
                        children: [
                          // ==================================================
                          // HEADER
                          // ==================================================

                          SizedBox(
                            height: headerHeight,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal:
                                          isLandscape ? 48 : 56,
                                    ),
                                    child: Text(
                                      'AnimeClip',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: headerFontSize,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: -.3,
                                        color:
                                            colorScheme.onSurface,
                                      ),
                                    ),
                                  ),
                                ),

                                // Close button at the left corner.
                                Positioned(
                                  left: 4,
                                  child: SizedBox(
                                    width: 48,
                                    height: 48,
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints:
                                          const BoxConstraints(
                                        minWidth: 48,
                                        minHeight: 48,
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      tooltip: 'Close',
                                      icon: Icon(
                                        Icons.close_rounded,
                                        color: colorScheme
                                            .onSurfaceVariant,
                                        size: isLandscape
                                            ? 23
                                            : 26,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            height: 1,
                            width: double.infinity,
                            color: colorScheme.outlineVariant,
                          ),

                          // ==================================================
                          // SCROLLABLE CONTENT
                          // ==================================================

                          Expanded(
                            child: SingleChildScrollView(
                              physics:
                                  const BouncingScrollPhysics(),
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    contentHorizontalPadding,
                                vertical:
                                    contentVerticalPadding,
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  // ==========================================
                                  // SPECIAL QUICK ACTIONS
                                  // ==========================================

                                  SizedBox(
                                    height:
                                        isLandscape ? 80 : 100,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: _QuickActionCard(
                                            icon:
                                                Icons.settings_rounded,
                                            color: Colors.blue,
                                            title: 'Settings',
                                            compact:
                                                isLandscape,
                                            onTap: () {
                                              controller
                                                  .openSettings(
                                                context,
                                              );
                                            },
                                          ),
                                        ),

                                        const SizedBox(
                                          width: 16,
                                        ),

                                        Expanded(
                                          child: _QuickActionCard(
                                            icon:
                                                Icons.palette_rounded,
                                            color:
                                                Colors.purple,
                                            title: 'Templates',
                                            compact:
                                                isLandscape,
                                            onTap: () {
                                              controller
                                                  .openTemplates(
                                                context,
                                              );
                                            },
                                          ),
                                        ),

                                        const SizedBox(
                                          width: 16,
                                        ),

                                        Expanded(
                                          child: _QuickActionCard(
                                            icon:
                                                Icons.school_rounded,
                                            color: Colors.green,
                                            title: 'Tutorials',
                                            compact:
                                                isLandscape,
                                            onTap: () {
                                              controller
                                                  .openTutorials(
                                                context,
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(
                                    height:
                                        quickActionsBottomSpacing,
                                  ),

                                  // ==========================================
                                  // MENU
                                  // ==========================================

                                  _MenuTile(
                                    icon: Icons.diamond_rounded,
                                    iconColor: Colors.indigo,
                                    title: 'Go Plus',
                                    onTap: () {
                                      controller.openGoPlus(
                                        context,
                                      );
                                    },
                                    compact: isLandscape,
                                  ),

                                  _menuDivider(
                                    colorScheme,
                                  ),

                                  _MenuTile(
                                    icon:
                                        Icons.handshake_rounded,
                                    iconColor: Colors.orange,
                                    title: 'Collaborations',
                                    onTap: () {
                                      controller
                                          .openCollaborations(
                                        context,
                                      );
                                    },
                                    compact: isLandscape,
                                  ),

                                  _menuDivider(
                                    colorScheme,
                                  ),

                                  _MenuTile(
                                    icon: Icons
                                        .monetization_on_rounded,
                                    iconColor: Colors.amber,
                                    title: 'Earn Coins',
                                    onTap: () {
                                      controller.openEarnCoins(
                                        context,
                                      );
                                    },
                                    compact: isLandscape,
                                  ),

                                  _menuDivider(
                                    colorScheme,
                                  ),

                                  _MenuTile(
                                    icon: Icons.public_rounded,
                                    iconColor: Colors.blue,
                                    title: 'Follow Us',
                                    onTap: () {
                                      controller.openFollowUs(
                                        context,
                                      );
                                    },
                                    compact: isLandscape,
                                  ),

                                  _menuDivider(
                                    colorScheme,
                                  ),

                                  _MenuTile(
                                    icon: Icons.info_rounded,
                                    iconColor: Colors.teal,
                                    title: 'About Us',
                                    onTap: () {
                                      controller.openAbout(
                                        context,
                                      );
                                    },
                                    compact: isLandscape,
                                  ),

                                  _menuDivider(
                                    colorScheme,
                                  ),

                                  _MenuTile(
                                    icon:
                                        Icons.lightbulb_rounded,
                                    iconColor: Colors.green,
                                    title: 'Help & Guide',
                                    onTap: () {
                                      controller
                                          .openHelpGuide(
                                        context,
                                      );
                                    },
                                    compact: isLandscape,
                                  ),

                                  _menuDivider(
                                    colorScheme,
                                  ),

                                  _AccountTile(
                                    controller: controller,
                                    compact: isLandscape,
                                  ),

                                  const SizedBox(
                                    height: 32,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // ==================================================
                          // VERSION — INSIDE DRAWER
                          // ==================================================

                          Container(
                            height: 1,
                            width: double.infinity,
                            color: colorScheme.outlineVariant,
                          ),

                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical:
                                  versionVerticalPadding,
                            ),
                            child: Text(
                              'Version 1.0.0',
                              style: TextStyle(
                                fontSize:
                                    isLandscape ? 10 : 12,
                                color: colorScheme
                                    .onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _menuDivider(ColorScheme colorScheme) {
    return Divider(
      color: colorScheme.outlineVariant,
      height: 1,
      thickness: 1,
    );
  }
}

// ============================================================================
// QUICK ACTION CARD
// ============================================================================

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final VoidCallback? onTap;
  final bool compact;

  const _QuickActionCard({
    required this.icon,
    required this.color,
    required this.title,
    this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final cardHeight = compact ? 80.0 : 100.0;
    final iconSize = compact ? 21.0 : 25.0;
    final titleFontSize = compact ? 10.0 : 12.0;
    final radius = compact ? 14.0 : 18.0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(
        AppMedia.r(radius),
      ),
      child: Container(
        height: cardHeight,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(
            AppMedia.r(radius),
          ),
          border: Border.all(
            color: colorScheme.outlineVariant,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(
                alpha: 0.06,
              ),
              blurRadius: compact ? 6 : 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(
          vertical: compact ? 5 : 7,
          horizontal: compact ? 4 : 6,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: color,
            ),

            SizedBox(
              height: compact ? 3 : 5,
            ),

            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: titleFontSize,
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// MENU TILE
// ============================================================================

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback? onTap;
  final bool compact;

  const _MenuTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final tileHeight = compact ? 50.0 : 60.0;
    final iconSize = compact ? 21.0 : 24.0;
    final textSize = compact ? 13.0 : 16.0;
    final chevronSize = compact ? 20.0 : 24.0;
    final gap = compact ? 14.0 : 18.0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        height: tileHeight,
        child: Row(
          children: [
            SizedBox(
              width: 30,
              height: 30,
              child: Center(
                child: Icon(
                  icon,
                  color: iconColor,
                  size: iconSize,
                ),
              ),
            ),

            SizedBox(width: gap),

            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: textSize,
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            Icon(
              Icons.chevron_right_rounded,
              color: colorScheme.onSurfaceVariant,
              size: chevronSize,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// ACCOUNT TILE
// ============================================================================

class _AccountTile extends StatelessWidget {
  final HomeController controller;
  final bool compact;

  const _AccountTile({
    required this.controller,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final tileHeight = compact ? 50.0 : 60.0;
    final avatarSize = compact ? 34.0 : 37.0;
    final iconSize = compact ? 19.0 : 22.0;
    final textSize = compact ? 13.0 : 16.0;
    final gap = compact ? 14.0 : 18.0;
    final chevronSize = compact ? 20.0 : 24.0;

    return InkWell(
      onTap: () => controller.openAccounts(context),
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        height: tileHeight,
        child: Row(
          children: [
            Container(
              width: avatarSize,
              height: avatarSize,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.person_rounded,
                color: colorScheme.primary,
                size: iconSize,
              ),
            ),

            SizedBox(width: gap),

            Expanded(
              child: Text(
                'Account',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: textSize,
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            Icon(
              Icons.chevron_right_rounded,
              color: colorScheme.onSurfaceVariant,
              size: chevronSize,
            ),
          ],
        ),
      ),
    );
  }
}