import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/app_media.dart';
import 'follow_us_controller.dart';

/// AnimeClip Follow Us screen.
///
/// UI only; platform-opening logic belongs to FollowUsController.
class FollowUsUI extends StatefulWidget {
  const FollowUsUI({super.key});

  @override
  State<FollowUsUI> createState() => _FollowUsUIState();
}

class _FollowUsUIState extends State<FollowUsUI> {
  late final FollowUsController controller;

  @override
  void initState() {
    super.initState();
    controller = FollowUsController()..addListener(_refresh);
  }

  @override
  void dispose() {
    controller.removeListener(_refresh);
    controller.dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    AppMedia.init(context);

    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            const _FollowUsAppBar(),

            Container(
              height: 1,
              width: double.infinity,
              color: scheme.outlineVariant,
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  AppMedia.w(14),
                  AppMedia.h(14),
                  AppMedia.w(14),
                  AppMedia.h(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _FollowUsHeader(),

                    SizedBox(height: AppMedia.h(14)),

                    const _PremiumCommunityPrompt(),

                    SizedBox(height: AppMedia.h(20)),

                    const _OfficialPlatformsHeader(),

                    SizedBox(height: AppMedia.h(10)),

                    ...FollowUsController.platforms.map(
                      (platform) => Padding(
                        padding: EdgeInsets.only(
                          bottom: AppMedia.h(8),
                        ),
                        child: SocialPlatformCard(
                          data: platform,
                          state: controller.stateFor(
                            platform.platform,
                          ),
                          onFollow: () => controller.followPlatform(
                            platform.platform,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: AppMedia.h(8)),

                    const _FollowUsFooter(),
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

// ============================================================================
// TOP BAR
// ============================================================================

class _FollowUsAppBar extends StatelessWidget {
  const _FollowUsAppBar();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final width = MediaQuery.sizeOf(context).width;

    final titleSize = width < 360 ? 17.0 : 19.0;
    final iconSize = width < 360 ? 21.0 : 22.0;

    return SizedBox(
      height: 52,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 44,
              height: 44,
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 44,
                  minHeight: 44,
                ),
                onPressed: () => Navigator.pop(context),
                tooltip: 'Back',
                icon: Icon(
                  Icons.close_rounded,
                  color: scheme.onSurface,
                  size: iconSize,
                ),
              ),
            ),
          ),

          Positioned.fill(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 54),
                child: Text(
                  'Follow Us',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: titleSize,
                    fontWeight: FontWeight.bold,
                    color: scheme.primary,
                    letterSpacing: -0.15,
                    height: 1.1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// HEADER
// ============================================================================

class _FollowUsHeader extends StatelessWidget {
  const _FollowUsHeader();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        children: [
          Container(
            width: AppMedia.w(36),
            height: AppMedia.w(36),
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              borderRadius: BorderRadius.circular(
                AppMedia.r(11),
              ),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.groups_rounded,
              color: scheme.primary,
              size: AppMedia.icon(20),
            ),
          ),

          SizedBox(height: AppMedia.h(7)),

          Text(
            'Follow AnimeClip',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppMedia.sp(20),
              fontWeight: FontWeight.bold,
              color: scheme.onSurface,
              letterSpacing: -0.2,
              height: 1.15,
            ),
          ),

          SizedBox(height: AppMedia.h(4)),

          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: AppMedia.w(270),
            ),
            child: Text(
              'Connect with AnimeClip on our official platforms.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppMedia.sp(12),
                height: 1.3,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// COMMUNITY PROMPT
// ============================================================================

class _PremiumCommunityPrompt extends StatelessWidget {
  const _PremiumCommunityPrompt();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppMedia.w(12),
        vertical: AppMedia.h(10),
      ),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(
          AppMedia.r(13),
        ),
        border: Border.all(
          color: scheme.outlineVariant,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppMedia.w(30),
            height: AppMedia.w(30),
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(
                AppMedia.r(9),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              '✨',
              style: TextStyle(
                fontSize: AppMedia.sp(15),
              ),
            ),
          ),

          SizedBox(width: AppMedia.w(9)),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Be part of AnimeClip',
                  style: TextStyle(
                    fontSize: AppMedia.sp(13),
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),

                SizedBox(height: AppMedia.h(2)),

                Text(
                  'Get updates, tips, features, and community news.',
                  style: TextStyle(
                    fontSize: AppMedia.sp(11),
                    height: 1.3,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// OFFICIAL PLATFORMS HEADER
// ============================================================================

class _OfficialPlatformsHeader extends StatelessWidget {
  const _OfficialPlatformsHeader();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Official Platforms',
          style: TextStyle(
            fontSize: AppMedia.sp(17),
            fontWeight: FontWeight.bold,
            color: scheme.onSurface,
            height: 1.15,
          ),
        ),

        SizedBox(height: AppMedia.h(2)),

        Text(
          'Updates and announcements.',
          style: TextStyle(
            fontSize: AppMedia.sp(11),
            color: scheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// SOCIAL PLATFORM CARD
// ============================================================================

class SocialPlatformCard extends StatelessWidget {
  final SocialPlatformData data;
  final SocialPlatformState state;
  final VoidCallback? onFollow;

  const SocialPlatformCard({
    super.key,
    required this.data,
    required this.state,
    this.onFollow,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final accentColor = Color(data.colorValue);
    final iconBackground = Color(data.iconBackgroundValue);

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(
        minHeight: 56,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppMedia.w(10),
        vertical: AppMedia.h(7),
      ),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(
          AppMedia.r(13),
        ),
        border: Border.all(
          color: scheme.surfaceContainerHighest,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 280;

          return Row(
            children: [
              _PlatformIconBadge(
                platform: data.platform,
                backgroundColor: iconBackground,
                iconColor: accentColor,
              ),

              SizedBox(width: AppMedia.w(8)),

              Expanded(
                child: Text(
                  data.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: AppMedia.sp(13),
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurface,
                    height: 1.15,
                  ),
                ),
              ),

              SizedBox(width: AppMedia.w(6)),

              ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: compact ? 62 : 72,
                  maxWidth: compact ? 78 : 92,
                ),
                child: _PlatformFollowButton(
                  label: state == SocialPlatformState.unavailable
                      ? 'Retry'
                      : data.actionLabel,
                  color: accentColor,
                  isLoading:
                      state == SocialPlatformState.opening,
                  onPressed:
                      state == SocialPlatformState.opening
                          ? null
                          : onFollow,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ============================================================================
// PLATFORM ICON
// ============================================================================

class _PlatformIconBadge extends StatelessWidget {
  final SocialPlatform platform;
  final Color backgroundColor;
  final Color iconColor;

  const _PlatformIconBadge({
    required this.platform,
    required this.backgroundColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppMedia.w(34),
      height: AppMedia.w(34),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(
          AppMedia.r(10),
        ),
      ),
      alignment: Alignment.center,
      child: Icon(
        _iconForPlatform(platform),
        color: iconColor,
        size: AppMedia.icon(19),
      ),
    );
  }

  IconData _iconForPlatform(
    SocialPlatform platform,
  ) {
    switch (platform) {
      case SocialPlatform.youtube:
        return Icons.play_circle_filled_rounded;

      case SocialPlatform.instagram:
        return Icons.camera_alt_rounded;

      case SocialPlatform.facebook:
        return Icons.facebook;

      case SocialPlatform.whatsapp:
        return Icons.chat_rounded;
    }
  }
}

// ============================================================================
// FOLLOW BUTTON
// ============================================================================

class _PlatformFollowButton extends StatelessWidget {
  final String label;
  final Color color;
  final bool isLoading;
  final VoidCallback? onPressed;

  const _PlatformFollowButton({
    required this.label,
    required this.color,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 32,
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: color,
          foregroundColor: scheme.onPrimary,
          disabledBackgroundColor:
              color.withValues(alpha: 0.75),
          disabledForegroundColor:
              scheme.onSurfaceVariant,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 6,
          ),
          minimumSize: const Size(0, 32),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppMedia.r(9),
            ),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 13,
                height: 13,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(
                    scheme.onPrimary,
                  ),
                ),
              )
            : FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  maxLines: 1,
                  softWrap: false,
                  style: TextStyle(
                    fontSize: AppMedia.sp(10),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
      ),
    );
  }
}

// ============================================================================
// FOOTER
// ============================================================================

class _FollowUsFooter extends StatelessWidget {
  const _FollowUsFooter();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        top: AppMedia.h(6),
        bottom: AppMedia.h(2),
      ),
      child: Center(
        child: Column(
          children: [
            Text(
              'Stay Connected ❤️',
              style: TextStyle(
                fontSize: AppMedia.sp(12),
                fontWeight: FontWeight.w600,
                color: scheme.onSurface,
              ),
            ),

            SizedBox(height: AppMedia.h(2)),

            Text(
              'Never miss an AnimeClip update.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppMedia.sp(11),
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}