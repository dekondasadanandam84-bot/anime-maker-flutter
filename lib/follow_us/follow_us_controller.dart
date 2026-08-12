import 'package:flutter/foundation.dart';

enum SocialPlatform { youtube, instagram, facebook, whatsapp }

enum SocialPlatformState { available, opening, unavailable }

class SocialPlatformData {
  final SocialPlatform platform;
  final String name;
  final String description;
  final int colorValue;
  final int iconBackgroundValue;
  final String actionLabel;

  const SocialPlatformData({
    required this.platform,
    required this.name,
    required this.description,
    required this.colorValue,
    required this.iconBackgroundValue,
    this.actionLabel = 'Follow',
  });
}

/// AnimeClip Follow Us business/controller layer.
///
/// Owns platform data and action state. Real URLs, deep-linking, browser
/// launching, and social APIs are intentionally left for the workflow phase.
class FollowUsController extends ChangeNotifier {
  static const List<SocialPlatformData> platforms = [
    SocialPlatformData(
      platform: SocialPlatform.youtube,
      name: 'YouTube',
      description: 'AnimeClip videos and tutorials',
      colorValue: 0xFFFF0000,
      iconBackgroundValue: 0xFFFFEBEB,
    ),
    SocialPlatformData(
      platform: SocialPlatform.instagram,
      name: 'Instagram',
      description: 'AnimeClip artwork and updates',
      colorValue: 0xFFC13584,
      iconBackgroundValue: 0xFFFCEAF3,
    ),
    SocialPlatformData(
      platform: SocialPlatform.facebook,
      name: 'Facebook',
      description: 'AnimeClip community updates',
      colorValue: 0xFF1877F2,
      iconBackgroundValue: 0xFFEAF2FF,
    ),
    SocialPlatformData(
      platform: SocialPlatform.whatsapp,
      name: 'WhatsApp',
      description: 'AnimeClip community notifications',
      colorValue: 0xFF25D366,
      iconBackgroundValue: 0xFFE9FAF0,
    ),
  ];

  SocialPlatform? _openingPlatform;
  final Set<SocialPlatform> _unavailablePlatforms = <SocialPlatform>{};

  SocialPlatform? get openingPlatform => _openingPlatform;

  bool isOpening(SocialPlatform platform) => _openingPlatform == platform;

  bool isUnavailable(SocialPlatform platform) =>
      _unavailablePlatforms.contains(platform);

  SocialPlatformState stateFor(SocialPlatform platform) {
    if (isOpening(platform)) return SocialPlatformState.opening;
    if (isUnavailable(platform)) return SocialPlatformState.unavailable;
    return SocialPlatformState.available;
  }

  Future<void> followPlatform(SocialPlatform platform) async {
    if (_openingPlatform != null || isUnavailable(platform)) return;

    _openingPlatform = platform;
    notifyListeners();

    try {
      // Future workflow:
      // 1. Try the platform's native app/deep link.
      // 2. Fall back to its web URL when necessary.
      // 3. Handle launch failures.
      await Future<void>.delayed(const Duration(milliseconds: 350));
    } finally {
      if (_openingPlatform == platform) {
        _openingPlatform = null;
        notifyListeners();
      }
    }
  }

  void setPlatformUnavailable(
    SocialPlatform platform, {
    bool unavailable = true,
  }) {
    if (unavailable) {
      _unavailablePlatforms.add(platform);
    } else {
      _unavailablePlatforms.remove(platform);
    }
    if (_openingPlatform == platform && unavailable) {
      _openingPlatform = null;
    }
    notifyListeners();
  }

  void resetPlatformState() {
    _openingPlatform = null;
    notifyListeners();
  }

  SocialPlatformData dataFor(SocialPlatform platform) {
    return platforms.firstWhere((item) => item.platform == platform);
  }
}
