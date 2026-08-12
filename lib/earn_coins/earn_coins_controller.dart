import 'dart:async';

import 'package:flutter/foundation.dart';

import 'earn_coins_ui.dart';

/// AnimeClip Earn Coins business/controller layer.
///
/// Responsibilities:
/// - Owns lifetime, daily, and weekly coin state.
/// - Controls the strict 10-reward daily sequence.
/// - Awards coins only after a successful reward-ad completion.
/// - Controls weekly goal and one-time weekly bonus.
/// - Handles daily and weekly reset state.
/// - Exposes presentation state for [EarnCoinsUI].
///
/// This controller intentionally does NOT build widgets or contain UI layout.
class EarnCoinsController extends ChangeNotifier {
  // ---------------------------------------------------------------------------
  // AnimeClip reward configuration
  // ---------------------------------------------------------------------------

  static const int rewardCoinValue = 10;
  static const int dailyRewardCount = 10;
  static const int dailyCoinLimit = rewardCoinValue * dailyRewardCount;

  static const int weeklyGoal = 700;
  static const int weeklyBonus = 30;

  static const Duration dailyCycle = Duration(days: 1);
  static const Duration weeklyCycle = Duration(days: 7);

  // ---------------------------------------------------------------------------
  // Persistent/session state
  // ---------------------------------------------------------------------------

  int _totalCoins = 0;
  int _todayCoins = 0;
  int _weeklyCoins = 0;

  int _completedRewardCount = 0;

  bool _weeklyBonusClaimed = false;
  bool _isRewardAdLoading = false;

  DateTime _dailyCycleStartedAt;
  DateTime _weeklyCycleStartedAt;

  /// Prevents accidental duplicate reward processing.
  bool _rewardCompletionBeingProcessed = false;

  /// Optional callback used by the app's ad layer.
  ///
  /// The callback must return true only when the reward ad was completed
  /// successfully. Returning false means no coins are awarded.
  Future<bool> Function()? _rewardAdRunner;

  EarnCoinsController({
  int totalCoins = 0,
  int todayCoins = 0,
  int weeklyCoins = 0,
  int completedRewardCount = 0,
  this._weeklyBonusClaimed = false,
  DateTime? dailyCycleStartedAt,
  DateTime? weeklyCycleStartedAt,
  this._rewardAdRunner,
})  : _totalCoins = _safeNonNegative(totalCoins),
      _todayCoins = _safeNonNegative(todayCoins),
      _weeklyCoins = _safeNonNegative(weeklyCoins),
      _completedRewardCount =
          completedRewardCount.clamp(0, dailyRewardCount),
      _dailyCycleStartedAt =
          dailyCycleStartedAt ?? DateTime.now(),
      _weeklyCycleStartedAt =
          weeklyCycleStartedAt ?? DateTime.now() {
  _normalizeState();
}

  // ---------------------------------------------------------------------------
  // Public read-only state
  // ---------------------------------------------------------------------------

  int get totalCoins => _totalCoins;

  int get todayCoins => _todayCoins;

  int get weeklyCoins => _weeklyCoins;

  int get completedRewardCount => _completedRewardCount;

  bool get weeklyBonusClaimed => _weeklyBonusClaimed;

  bool get isRewardAdLoading => _isRewardAdLoading;

  bool get isDailyLimitReached => _todayCoins >= dailyCoinLimit;

  bool get isWeeklyGoalReached => _weeklyCoins >= weeklyGoal;

  int get remainingDailyCoins =>
      (dailyCoinLimit - _todayCoins).clamp(0, dailyCoinLimit);

  int get remainingWeeklyCoins =>
      (weeklyGoal - _weeklyCoins).clamp(0, weeklyGoal);

  double get dailyProgress {
    if (dailyCoinLimit <= 0) return 0;
    return (_todayCoins / dailyCoinLimit).clamp(0.0, 1.0);
  }

  double get weeklyProgress {
    if (weeklyGoal <= 0) return 0;
    return (_weeklyCoins / weeklyGoal).clamp(0.0, 1.0);
  }

  /// The next daily reward that can be watched.
  ///
  /// Returns 0 when all ten rewards are completed or the daily limit is reached.
  int get availableRewardNumber {
    if (isDailyLimitReached) return 0;
    if (_completedRewardCount >= dailyRewardCount) return 0;
    return _completedRewardCount + 1;
  }

  bool get canWatchReward =>
      !_isRewardAdLoading &&
      !_rewardCompletionBeingProcessed &&
      availableRewardNumber > 0;

  bool get canClaimWeeklyBonus =>
      isWeeklyGoalReached && !_weeklyBonusClaimed;

  /// Coins the user will have after claiming the weekly bonus.
  int get projectedCoinsAfterWeeklyBonus =>
      _totalCoins + (canClaimWeeklyBonus ? weeklyBonus : 0);

  // ---------------------------------------------------------------------------
  // Controller configuration
  // ---------------------------------------------------------------------------

  /// Connects the controller to the application's rewarded-ad implementation.
  ///
  /// The ad implementation must:
  /// - show the rewarded ad;
  /// - return true after the ad has been successfully completed;
  /// - return false when the ad fails, is skipped, dismissed early, or cannot
  ///   be completed.
  void setRewardAdRunner(Future<bool> Function() runner) {
    _rewardAdRunner = runner;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Reward sequence
  // ---------------------------------------------------------------------------

  /// Starts the currently available daily reward.
  ///
  /// Coins are NOT added when the ad starts.
  /// Coins are awarded only when the configured ad runner returns true.
  Future<bool> watchAvailableReward() async {
    if (!canWatchReward) return false;

    _prepareForCurrentDate();

    if (!canWatchReward) return false;

    final runner = _rewardAdRunner;

    // The controller cannot safely award coins without a successful ad result.
    if (runner == null) {
      return false;
    }

    _isRewardAdLoading = true;
    _rewardCompletionBeingProcessed = true;
    notifyListeners();

    bool adCompleted = false;

    try {
      adCompleted = await runner();
    } catch (_) {
      adCompleted = false;
    } finally {
      _isRewardAdLoading = false;
    }

    if (!adCompleted) {
      _rewardCompletionBeingProcessed = false;
      notifyListeners();
      return false;
    }

    final awarded = _completeSuccessfulReward();

    _rewardCompletionBeingProcessed = false;
    notifyListeners();

    return awarded;
  }

  /// Completes the available reward after the ad layer has already confirmed
  /// successful completion.
  ///
  /// This method is useful when the application's ad service delivers its
  // ignore: unintended_html_in_doc_comment
  /// completion event through a callback rather than a Future<bool>.
  bool completeRewardAfterSuccessfulAd() {
    if (!canWatchReward) return false;

    _prepareForCurrentDate();

    if (!canWatchReward) return false;

    final awarded = _completeSuccessfulReward();
    notifyListeners();
    return awarded;
  }

  bool _completeSuccessfulReward() {
    if (_completedRewardCount >= dailyRewardCount) return false;
    if (_todayCoins >= dailyCoinLimit) return false;

    _completedRewardCount += 1;

    _todayCoins += rewardCoinValue;
    _weeklyCoins += rewardCoinValue;
    _totalCoins += rewardCoinValue;

    _normalizeState();
    return true;
  }

  // ---------------------------------------------------------------------------
  // Weekly bonus
  // ---------------------------------------------------------------------------

  /// Claims the +30 weekly bonus once the 700-coin weekly goal is reached.
  ///
  /// The bonus affects lifetime [totalCoins] only. It does not increase
  /// today's 100-coin earning limit and does not count toward [weeklyCoins].
  bool claimWeeklyBonus() {
    _prepareForCurrentDate();

    if (!canClaimWeeklyBonus) return false;

    _weeklyBonusClaimed = true;
    _totalCoins += weeklyBonus;

    notifyListeners();
    return true;
  }

  // ---------------------------------------------------------------------------
  // Daily cycle
  // ---------------------------------------------------------------------------

  /// Checks whether a new day has started and resets daily reward progress.
  ///
  /// Lifetime coins and weekly progress are preserved.
  bool checkDailyReset([DateTime? now]) {
    final currentTime = now ?? DateTime.now();

    if (!_isSameCalendarDay(_dailyCycleStartedAt, currentTime)) {
      _resetDailyState(currentTime);
      notifyListeners();
      return true;
    }

    return false;
  }

  /// Explicitly starts a new daily reward cycle.
  ///
  /// This is primarily useful for persistence/bootstrap code or testing.
  void resetDailyProgress([DateTime? now]) {
    final currentTime = now ?? DateTime.now();
    _resetDailyState(currentTime);
    notifyListeners();
  }

  void _resetDailyState(DateTime currentTime) {
    _todayCoins = 0;
    _completedRewardCount = 0;
    _dailyCycleStartedAt = currentTime;
    _isRewardAdLoading = false;
    _rewardCompletionBeingProcessed = false;
  }

  // ---------------------------------------------------------------------------
  // Weekly cycle
  // ---------------------------------------------------------------------------

  /// Checks whether the current weekly cycle has expired.
  ///
  /// Weekly progress and the weekly bonus claim state reset together.
  /// Lifetime [totalCoins] is preserved.
  bool checkWeeklyReset([DateTime? now]) {
    final currentTime = now ?? DateTime.now();

    if (currentTime.isBefore(_weeklyCycleStartedAt)) {
      return false;
    }

    final elapsed = currentTime.difference(_weeklyCycleStartedAt);

    if (elapsed >= weeklyCycle) {
      _resetWeeklyState(currentTime);
      notifyListeners();
      return true;
    }

    return false;
  }

  /// Explicitly starts a new weekly cycle.
  void resetWeeklyProgress([DateTime? now]) {
    final currentTime = now ?? DateTime.now();
    _resetWeeklyState(currentTime);
    notifyListeners();
  }

  void _resetWeeklyState(DateTime currentTime) {
    _weeklyCoins = 0;
    _weeklyBonusClaimed = false;
    _weeklyCycleStartedAt = currentTime;
  }

  // ---------------------------------------------------------------------------
  // Lifecycle / synchronization
  // ---------------------------------------------------------------------------

  /// Checks both daily and weekly boundaries.
  ///
  /// Call this when the Earn Coins screen becomes visible or when the app
  /// returns to the foreground.
  void refreshCycleState([DateTime? now]) {
    final currentTime = now ?? DateTime.now();

    var changed = false;

    if (!_isSameCalendarDay(_dailyCycleStartedAt, currentTime)) {
      _resetDailyState(currentTime);
      changed = true;
    }

    if (!currentTime.isBefore(_weeklyCycleStartedAt) &&
        currentTime.difference(_weeklyCycleStartedAt) >= weeklyCycle) {
      _resetWeeklyState(currentTime);
      changed = true;
    }

    if (changed) {
      notifyListeners();
    }
  }

  // ---------------------------------------------------------------------------
  // Persistence helpers
  // ---------------------------------------------------------------------------

  /// Returns the controller state in a storage-friendly map.
  ///
  /// The storage implementation belongs outside this controller.
  Map<String, dynamic> toMap() {
    return {
      'totalCoins': _totalCoins,
      'todayCoins': _todayCoins,
      'weeklyCoins': _weeklyCoins,
      'completedRewardCount': _completedRewardCount,
      'weeklyBonusClaimed': _weeklyBonusClaimed,
      'dailyCycleStartedAt': _dailyCycleStartedAt.toIso8601String(),
      'weeklyCycleStartedAt': _weeklyCycleStartedAt.toIso8601String(),
    };
  }

  /// Restores state previously produced by [toMap].
  ///
  /// Invalid or missing values fall back to safe defaults.
  void restoreFromMap(Map<String, dynamic> data) {
    _totalCoins = _readInt(data['totalCoins']);
    _todayCoins = _readInt(data['todayCoins']);
    _weeklyCoins = _readInt(data['weeklyCoins']);

    _completedRewardCount = _readInt(
      data['completedRewardCount'],
    ).clamp(0, dailyRewardCount);

    _weeklyBonusClaimed = data['weeklyBonusClaimed'] == true;

    _dailyCycleStartedAt =
        _readDateTime(data['dailyCycleStartedAt']) ?? DateTime.now();

    _weeklyCycleStartedAt =
        _readDateTime(data['weeklyCycleStartedAt']) ?? DateTime.now();

    _normalizeState();
    refreshCycleState();
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // UI state adapter
  // ---------------------------------------------------------------------------

  /// Converts controller state into the exact data expected by [EarnCoinsUI].
  ///
  /// This keeps the UI independent from business calculations.
  EarnCoinsUI buildUI({
    VoidCallback? onWatchAvailableReward,
    VoidCallback? onClaimWeeklyBonus,
  }) {
    return EarnCoinsUI(
      totalCoins: totalCoins,
      todayCoins: todayCoins,
      dailyCoinLimit: dailyCoinLimit,
      weeklyCoins: weeklyCoins,
      weeklyGoal: weeklyGoal,
      weeklyBonus: weeklyBonus,
      weeklyBonusClaimed: weeklyBonusClaimed,
      completedRewardCount: completedRewardCount,
      availableRewardNumber: availableRewardNumber,
      weeklyDayStatuses: weeklyDayStatuses,
      isRewardAdLoading: isRewardAdLoading,
      onWatchAvailableReward: onWatchAvailableReward,
      onClaimWeeklyBonus: onClaimWeeklyBonus,
    );
  }

  /// Seven-day presentation state for the weekly tracker.
  ///
  /// This is intentionally presentation data; the controller remains the
  /// single source of truth for weekly progress.
  List<WeeklyDayStatus> get weeklyDayStatuses {
    if (_weeklyCoins <= 0) {
      return List<WeeklyDayStatus>.filled(
        7,
        WeeklyDayStatus.locked,
      );
    }

    final completedDays = (_weeklyCoins ~/ dailyCoinLimit).clamp(0, 7);
    final remainder = _weeklyCoins % dailyCoinLimit;

    return List.generate(7, (index) {
      if (index < completedDays) {
        return WeeklyDayStatus.completed;
      }

      if (index == completedDays && (remainder > 0 || completedDays == 0)) {
        return WeeklyDayStatus.current;
      }

      return WeeklyDayStatus.locked;
    });
  }

  // ---------------------------------------------------------------------------
  // Internal validation
  // ---------------------------------------------------------------------------

  void _prepareForCurrentDate() {
    final now = DateTime.now();

    var changed = false;

    if (!_isSameCalendarDay(_dailyCycleStartedAt, now)) {
      _resetDailyState(now);
      changed = true;
    }

    if (!now.isBefore(_weeklyCycleStartedAt) &&
        now.difference(_weeklyCycleStartedAt) >= weeklyCycle) {
      _resetWeeklyState(now);
      changed = true;
    }

    if (changed) {
      notifyListeners();
    }
  }

  void _normalizeState() {
    _totalCoins = _safeNonNegative(_totalCoins);

    _todayCoins = _todayCoins.clamp(0, dailyCoinLimit);
    _weeklyCoins = _safeNonNegative(_weeklyCoins);
    _completedRewardCount =
        _completedRewardCount.clamp(0, dailyRewardCount);

    // Each completed daily reward represents exactly 10 daily coins.
    final maximumRewardsFromCoins = _todayCoins ~/ rewardCoinValue;
    if (_completedRewardCount > maximumRewardsFromCoins) {
      _completedRewardCount = maximumRewardsFromCoins;
    }

    // Prevent a partially completed reward state from existing in the normal
    // reward sequence.
    _todayCoins = _completedRewardCount * rewardCoinValue;

    if (_completedRewardCount >= dailyRewardCount) {
      _todayCoins = dailyCoinLimit;
    }

    if (_weeklyCoins > weeklyGoal && weeklyGoal > 0) {
      _weeklyCoins = weeklyGoal;
    }

    if (_weeklyBonusClaimed && !isWeeklyGoalReached) {
      _weeklyBonusClaimed = false;
    }
  }

  static bool _isSameCalendarDay(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  static int _safeNonNegative(int value) {
    return value < 0 ? 0 : value;
  }

  static int _readInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static DateTime? _readDateTime(dynamic value) {
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
