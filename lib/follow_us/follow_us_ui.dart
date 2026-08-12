import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/app_media.dart';
import 'follow_us_controller.dart';

/// AnimeClip Follow Us screen.
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
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    AppMedia.init(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const _FollowUsAppBar(),
            const Divider(height: 1, thickness: 1, color: Color(0xFFEAEAEA)),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  AppMedia.w(16),
                  AppMedia.h(20),
                  AppMedia.w(16),
                  AppMedia.h(28),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _FollowUsHeader(),
                    SizedBox(height: AppMedia.h(20)),
                    const _PremiumCommunityPrompt(),
                    SizedBox(height: AppMedia.h(28)),
                    const _OfficialPlatformsHeader(),
                    SizedBox(height: AppMedia.h(14)),
                    ...FollowUsController.platforms.map(
                      (platform) => Padding(
                        padding: EdgeInsets.only(bottom: AppMedia.h(10)),
                        child: SocialPlatformCard(
                          data: platform,
                          state: controller.stateFor(platform.platform),
                          onFollow: () =>
                              controller.followPlatform(platform.platform),
                        ),
                      ),
                    ),
                    SizedBox(height: AppMedia.h(14)),
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

class _FollowUsAppBar extends StatelessWidget {
  const _FollowUsAppBar();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppMedia.h(58),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              tooltip: 'Back',
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_rounded,
                color: Colors.black87,
                size: AppMedia.icon(24),
              ),
            ),
          ),
          Text(
            'Follow Us',
            style: TextStyle(
              fontSize: AppMedia.sp(20),
              fontWeight: FontWeight.bold,
              color: Colors.blue,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _FollowUsHeader extends StatelessWidget {
  const _FollowUsHeader();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: AppMedia.w(42),
            height: AppMedia.w(42),
            decoration: BoxDecoration(
              color: const Color(0xFFF0ECFF),
              borderRadius: BorderRadius.circular(AppMedia.r(14)),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.groups_rounded,
              color: const Color(0xFF6D4AFF),
              size: AppMedia.icon(24),
            ),
          ),
          SizedBox(height: AppMedia.h(10)),
          Text(
            'Follow AnimeClip',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppMedia.sp(23),
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: -0.3,
            ),
          ),
          SizedBox(height: AppMedia.h(6)),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: AppMedia.w(290)),
            child: Text(
              'Stay connected with AnimeClip across our official platforms.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppMedia.sp(14),
                height: 1.35,
                color: const Color(0xFF4C4546),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumCommunityPrompt extends StatelessWidget {
  const _PremiumCommunityPrompt();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppMedia.w(16),
        vertical: AppMedia.h(14),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F3FF),
        borderRadius: BorderRadius.circular(AppMedia.r(16)),
        border: Border.all(color: const Color(0xFFE6DEFF)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppMedia.w(34),
            height: AppMedia.w(34),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppMedia.r(11)),
            ),
            alignment: Alignment.center,
            child: Text('✨', style: TextStyle(fontSize: AppMedia.sp(18))),
          ),
          SizedBox(width: AppMedia.w(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Be part of AnimeClip',
                  style: TextStyle(
                    fontSize: AppMedia.sp(14),
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1C1C),
                  ),
                ),
                SizedBox(height: AppMedia.h(4)),
                Text(
                  'Follow us for exclusive updates, creative tips, new features, and community announcements.',
                  style: TextStyle(
                    fontSize: AppMedia.sp(13),
                    height: 1.35,
                    color: const Color(0xFF4C4546),
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

class _OfficialPlatformsHeader extends StatelessWidget {
  const _OfficialPlatformsHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Official Platforms',
          style: TextStyle(
            fontSize: AppMedia.sp(20),
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: AppMedia.h(4)),
        Text(
          'Follow us for updates and announcements.',
          style: TextStyle(
            fontSize: AppMedia.sp(14),
            color: const Color(0xFF4C4546),
          ),
        ),
      ],
    );
  }
}

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
    final accentColor = Color(data.colorValue);
    final iconBackground = Color(data.iconBackgroundValue);

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: AppMedia.h(66)),
      padding: EdgeInsets.symmetric(
        horizontal: AppMedia.w(13),
        vertical: AppMedia.h(12),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(AppMedia.r(16)),
        border: Border.all(color: const Color(0xFFE2E2E2)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _PlatformIconBadge(
            platform: data.platform,
            backgroundColor: iconBackground,
            iconColor: accentColor,
          ),
          SizedBox(width: AppMedia.w(12)),
          Expanded(
            child: Text(
              data.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: AppMedia.sp(15),
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1C1C),
              ),
            ),
          ),
          SizedBox(width: AppMedia.w(10)),
          _PlatformFollowButton(
            label: state == SocialPlatformState.unavailable
                ? 'Retry'
                : data.actionLabel,
            color: accentColor,
            isLoading: state == SocialPlatformState.opening,
            onPressed: state == SocialPlatformState.opening ? null : onFollow,
          ),
        ],
      ),
    );
  }
}

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
      width: AppMedia.w(40),
      height: AppMedia.w(40),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppMedia.r(12)),
      ),
      alignment: Alignment.center,
      child: Icon(
        _iconForPlatform(platform),
        color: iconColor,
        size: AppMedia.icon(22),
      ),
    );
  }

  IconData _iconForPlatform(SocialPlatform platform) {
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
    return SizedBox(
      height: AppMedia.h(36),
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          disabledBackgroundColor: color.withValues(alpha: 0.75),
          disabledForegroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: AppMedia.w(15)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppMedia.r(11)),
          ),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: isLoading
            ? SizedBox(
                width: AppMedia.w(15),
                height: AppMedia.w(15),
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                label,
                style: TextStyle(
                  fontSize: AppMedia.sp(12),
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}

class _FollowUsFooter extends StatelessWidget {
  const _FollowUsFooter();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: AppMedia.h(12),
        bottom: AppMedia.h(4),
      ),
      child: Center(
        child: Column(
          children: [
            Text(
              'Stay Connected ❤️',
              style: TextStyle(
                fontSize: AppMedia.sp(14),
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(height: AppMedia.h(4)),
            Text(
              'Follow AnimeClip and never miss an update.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppMedia.sp(13),
                color: const Color(0xFF4C4546),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
