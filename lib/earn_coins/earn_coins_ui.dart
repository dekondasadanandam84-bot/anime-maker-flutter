import 'dart:async';

import 'package:flutter/material.dart';

/// AnimeClip Earn Coins screen.
///
/// TEST MODE:
/// - "Watch Ad" simulates a completed rewarded ad.
/// - Each reward can be completed once per daily cycle.
/// - Each completed reward adds 10 coins.
/// - Rewards unlock strictly in order: 1 -> 2 -> ... -> 10.
/// - The daily reward cycle resets at 4:00 AM.
/// - No real ad SDK or backend reward logic is used here.
class EarnCoinsUI extends StatefulWidget {
  final int totalCoins;
  final int todayCoins;
  final int dailyCoinLimit;
  final int weeklyCoins;
  final int weeklyGoal;
  final int weeklyBonus;
  final bool weeklyBonusClaimed;

  final int completedRewardCount;
  final int availableRewardNumber;

  final List<WeeklyDayStatus> weeklyDayStatuses;

  /// Kept for compatibility with the existing controller integration.
  final bool isRewardAdLoading;
  final VoidCallback? onWatchAvailableReward;
  final VoidCallback? onClaimWeeklyBonus;

  const EarnCoinsUI({
    super.key,
    this.totalCoins = 0,
    this.todayCoins = 0,
    this.dailyCoinLimit = 100,
    this.weeklyCoins = 0,
    this.weeklyGoal = 700,
    this.weeklyBonus = 30,
    this.weeklyBonusClaimed = false,
    this.completedRewardCount = 0,
    this.availableRewardNumber = 1,
    this.weeklyDayStatuses = const [
      WeeklyDayStatus.locked,
      WeeklyDayStatus.locked,
      WeeklyDayStatus.locked,
      WeeklyDayStatus.locked,
      WeeklyDayStatus.locked,
      WeeklyDayStatus.locked,
      WeeklyDayStatus.locked,
    ],
    this.isRewardAdLoading = false,
    this.onWatchAvailableReward,
    this.onClaimWeeklyBonus,
  });

  @override
  State<EarnCoinsUI> createState() => _EarnCoinsUIState();
}

class _EarnCoinsUIState extends State<EarnCoinsUI> {
  late int _totalCoins;
  late int _todayCoins;
  late int _weeklyCoins;
  late int _completedRewardCount;
  late int _availableRewardNumber;
  late bool _weeklyBonusClaimed;

  bool _isRewardAdLoading = false;
  Timer? _resetTimer;

  @override
  void initState() {
    super.initState();

    _totalCoins = widget.totalCoins;
    _todayCoins = widget.todayCoins;
    _weeklyCoins = widget.weeklyCoins;
    _completedRewardCount = widget.completedRewardCount.clamp(0, 10);
    _availableRewardNumber =
        widget.availableRewardNumber.clamp(0, 10);
    _weeklyBonusClaimed = widget.weeklyBonusClaimed;

    // Keep test state consistent when the screen is first opened.
    _syncRewardState();
    _scheduleNextReset();
  }

  @override
  void dispose() {
    _resetTimer?.cancel();
    super.dispose();
  }

  void _syncRewardState() {
    final completed = _completedRewardCount.clamp(0, 10);

    if (completed >= 10) {
      _availableRewardNumber = 0;
    } else {
      _availableRewardNumber = completed + 1;
    }

    _completedRewardCount = completed;
  }

  DateTime _nextResetAt() {
    final now = DateTime.now();

    DateTime reset = DateTime(
      now.year,
      now.month,
      now.day,
      4,
    );

    if (!now.isBefore(reset)) {
      reset = reset.add(const Duration(days: 1));
    }

    return reset;
  }

  void _scheduleNextReset() {
    _resetTimer?.cancel();

    final delay = _nextResetAt().difference(DateTime.now());

    _resetTimer = Timer(delay, () {
      if (!mounted) return;

      setState(() {
        _todayCoins = 0;
        _completedRewardCount = 0;
        _availableRewardNumber = 1;
      });

      _scheduleNextReset();
    });
  }

  Future<void> _watchFakeReward() async {
    if (_isRewardAdLoading) return;
    if (_completedRewardCount >= 10) return;
    if (_availableRewardNumber != _completedRewardCount + 1) {
      _syncRewardState();
    }

    final rewardNumber = _availableRewardNumber;

    setState(() {
      _isRewardAdLoading = true;
    });

    // Fake ad-completion delay for testing only.
    await Future<void>.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;

    setState(() {
      _isRewardAdLoading = false;

      // Give the reward only once for the current reward number.
      if (_completedRewardCount == rewardNumber - 1) {
        _completedRewardCount = rewardNumber;

        _todayCoins = (_todayCoins + 10).clamp(
          0,
          widget.dailyCoinLimit,
        );

        _totalCoins += 10;
        _weeklyCoins += 10;

        _syncRewardState();
      }
    });

    // Still call the existing callback so a future controller can
    // observe/replace this test behavior without changing the UI API.
    widget.onWatchAvailableReward?.call();

    if (!mounted) return;

    final message = _completedRewardCount >= 10
        ? 'Reward 10 completed! Daily rewards reset at 4:00 AM.'
        : 'Reward $rewardNumber completed! Reward ${rewardNumber + 1} unlocked. +10 coins';

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: const Duration(milliseconds: 2200),
          content: Text(message),
        ),
      );
  }

  void _claimWeeklyBonus() {
    if (_weeklyBonusClaimed) return;
    if (_weeklyCoins < widget.weeklyGoal) return;

    setState(() {
      _weeklyBonusClaimed = true;
      _totalCoins += widget.weeklyBonus;
    });

    widget.onClaimWeeklyBonus?.call();

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Weekly bonus claimed! +${widget.weeklyBonus} coins',
          ),
        ),
      );
  }

  List<WeeklyDayStatus> _buildTestWeeklyStatuses() {
    final statuses = List<WeeklyDayStatus>.filled(
      7,
      WeeklyDayStatus.locked,
    );

    final completedDays =
        (_weeklyCoins ~/ 100).clamp(0, 7);

    for (var i = 0; i < completedDays; i++) {
      statuses[i] = WeeklyDayStatus.completed;
    }

    if (completedDays < 7) {
      statuses[completedDays] = WeeklyDayStatus.current;
    }

    return statuses;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = screenWidth < 360 ? 16.0 : 20.0;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        centerTitle: true,
        title: Text(
          'Earn Coins',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            8,
            horizontalPadding,
            32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              WalletBalanceCard(
                totalCoins: _totalCoins,
                todayCoins: _todayCoins,
                dailyCoinLimit: widget.dailyCoinLimit,
              ),
              const SizedBox(height: 18),
              DailyEarningCard(
                todayCoins: _todayCoins,
                dailyCoinLimit: widget.dailyCoinLimit,
              ),
              const SizedBox(height: 18),
              WeeklyGoalCard(
                weeklyCoins: _weeklyCoins,
                weeklyGoal: widget.weeklyGoal,
                weeklyBonus: widget.weeklyBonus,
                weeklyDayStatuses: _buildTestWeeklyStatuses(),
              ),
              const SizedBox(height: 18),
              DailyRewardsSection(
                completedRewardCount: _completedRewardCount,
                availableRewardNumber: _availableRewardNumber,
                isRewardAdLoading: _isRewardAdLoading,
                onWatchAvailableReward:
                    _watchFakeReward,
              ),
              const SizedBox(height: 18),
              WeeklyBonusCard(
                weeklyCoins: _weeklyCoins,
                weeklyGoal: widget.weeklyGoal,
                weeklyBonus: widget.weeklyBonus,
                claimed: _weeklyBonusClaimed,
                onClaim: _claimWeeklyBonus,
              ),
              const SizedBox(height: 18),
              const HowItWorksSection(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Presentation state for one day in the seven-day weekly tracker.
enum WeeklyDayStatus {
  completed,
  current,
  locked,
}

class WalletBalanceCard extends StatelessWidget {
  final int totalCoins;
  final int todayCoins;
  final int dailyCoinLimit;

  const WalletBalanceCard({
    super.key,
    required this.totalCoins,
    required this.todayCoins,
    required this.dailyCoinLimit,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final progress = dailyCoinLimit <= 0
        ? 0.0
        : (todayCoins / dailyCoinLimit).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scheme.primary,
            scheme.primaryContainer,
            scheme.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withValues(alpha: .22),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              _WalletIcon(),
              Spacer(),
              _WalletLabel(),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            'Total Coins',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              '$totalCoins',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 42,
                height: 1,
                fontWeight: FontWeight.w900,
                letterSpacing: -1.2,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Keep earning with daily rewards',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '$todayCoins / $dailyCoinLimit today',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: Colors.white.withValues(alpha: 0.24),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _WalletIcon extends StatelessWidget {
  const _WalletIcon();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: scheme.onPrimary.withValues(alpha: .18),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: scheme.onPrimary.withValues(alpha: .24),
        ),
      ),
      child: Icon(
        Icons.account_balance_wallet_rounded,
        color: scheme.onPrimary,
        size: 25,
      ),
    );
  }
}

class _WalletLabel extends StatelessWidget {
  const _WalletLabel();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: scheme.onPrimary.withValues(alpha: .16),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            color: scheme.onPrimary,
            size: 15,
          ),
          const SizedBox(width: 5),
          Text(
            'AnimeClip Wallet',
            style: TextStyle(
              color: scheme.onPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class DailyEarningCard extends StatelessWidget {
  final int todayCoins;
  final int dailyCoinLimit;

  const DailyEarningCard({
    super.key,
    required this.todayCoins,
    required this.dailyCoinLimit,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final progress = dailyCoinLimit <= 0
        ? 0.0
        : (todayCoins / dailyCoinLimit).clamp(0.0, 1.0);
    final dailyGoalCompleted = todayCoins >= dailyCoinLimit;
    final remainingCoins =
        (dailyCoinLimit - todayCoins).clamp(0, dailyCoinLimit);

    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            icon: Icons.today_rounded,
            title: 'Today\'s Earnings',
            subtitle: 'Earn up to 100 coins every day',
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$todayCoins',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: scheme.onSurface,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(
                  ' / $dailyCoinLimit coins',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
              const Spacer(),
              _StatusPill(
                label: dailyGoalCompleted
                    ? 'Completed'
                    : '$remainingCoins left',
                icon: dailyGoalCompleted
                    ? Icons.check_circle_rounded
                    : Icons.bolt_rounded,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 9,
              backgroundColor: scheme.primaryContainer,
              valueColor:
                  AlwaysStoppedAnimation<Color>(scheme.primary),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            dailyGoalCompleted
                ? 'You reached today\'s earning limit.'
                : 'Complete the rewards below to keep earning.',
            style: TextStyle(
              color: scheme.onSurfaceVariant,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class WeeklyGoalCard extends StatelessWidget {
  final int weeklyCoins;
  final int weeklyGoal;
  final int weeklyBonus;
  final List<WeeklyDayStatus> weeklyDayStatuses;

  const WeeklyGoalCard({
    super.key,
    required this.weeklyCoins,
    required this.weeklyGoal,
    required this.weeklyBonus,
    required this.weeklyDayStatuses,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final progress = weeklyGoal <= 0
        ? 0.0
        : (weeklyCoins / weeklyGoal).clamp(0.0, 1.0);
    final goalReached = weeklyCoins >= weeklyGoal;
    final remainingCoins =
        (weeklyGoal - weeklyCoins).clamp(0, weeklyGoal);

    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            icon: Icons.calendar_month_rounded,
            title: 'Weekly Goal',
            subtitle: 'Build your progress throughout the week',
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Text(
                  '$weeklyCoins / $weeklyGoal',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    color: scheme.onSurface,
                  ),
                ),
              ),
              _StatusPill(
                label: goalReached
                    ? 'Goal reached'
                    : '$remainingCoins left',
                icon: goalReached
                    ? Icons.emoji_events_rounded
                    : Icons.flag_rounded,
              ),
            ],
          ),
          const SizedBox(height: 11),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 9,
              backgroundColor: scheme.primaryContainer,
              valueColor:
                  AlwaysStoppedAnimation<Color>(scheme.secondary),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Icon(
                Icons.card_giftcard_rounded,
                size: 18,
                color: scheme.secondary,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  'Reach the goal to unlock +$weeklyBonus bonus coins',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          WeeklyDayTracker(statuses: weeklyDayStatuses),
        ],
      ),
    );
  }
}

class WeeklyDayTracker extends StatelessWidget {
  final List<WeeklyDayStatus> statuses;

  const WeeklyDayTracker({
    super.key,
    required this.statuses,
  });

  static const dayLabels = [
    'D1',
    'D2',
    'D3',
    'D4',
    'D5',
    'D6',
    'D7',
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(dayLabels.length, (index) {
        final status = index < statuses.length
            ? statuses[index]
            : WeeklyDayStatus.locked;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index == dayLabels.length - 1 ? 0 : 5,
            ),
            child: WeeklyDayItem(
              label: dayLabels[index],
              status: status,
            ),
          ),
        );
      }),
    );
  }
}

class WeeklyDayItem extends StatelessWidget {
  final String label;
  final WeeklyDayStatus status;

  const WeeklyDayItem({
    super.key,
    required this.label,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final completed = status == WeeklyDayStatus.completed;
    final current = status == WeeklyDayStatus.current;

    final background = completed
        ? scheme.tertiaryContainer
        : current
            ? scheme.primaryContainer
            : scheme.surfaceContainerLow;

    final foreground = completed
        ? scheme.tertiary
        : current
            ? scheme.primary
            : scheme.onSurfaceVariant;

    final icon = completed
        ? Icons.check_circle_rounded
        : current
            ? Icons.bolt_rounded
            : Icons.lock_rounded;

    return Container(
      height: 47,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: current
              ? scheme.primary.withValues(alpha: 0.45)
              : Colors.transparent,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 15, color: foreground),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: foreground,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class DailyRewardsSection extends StatelessWidget {
  final int completedRewardCount;
  final int availableRewardNumber;
  final bool isRewardAdLoading;
  final VoidCallback? onWatchAvailableReward;

  const DailyRewardsSection({
    super.key,
    required this.completedRewardCount,
    required this.availableRewardNumber,
    required this.isRewardAdLoading,
    required this.onWatchAvailableReward,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final safeCompletedCount =
        completedRewardCount.clamp(0, 10);
    final safeAvailableNumber =
        availableRewardNumber.clamp(0, 10);
    final allCompleted = safeCompletedCount >= 10;

    return _SectionCard(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _SectionHeader(
              icon: Icons.redeem_rounded,
              title: 'Daily Rewards',
              subtitle: '10 rewards × 10 coins',
            ),
          ),
          const SizedBox(height: 17),
          ...List.generate(10, (index) {
            final rewardNumber = index + 1;
            final rewardCompleted =
                rewardNumber <= safeCompletedCount;
            final rewardAvailable =
                rewardNumber == safeAvailableNumber &&
                    !rewardCompleted &&
                    safeAvailableNumber != 0;

            return Padding(
              padding: EdgeInsets.only(
                bottom: rewardNumber == 10 ? 0 : 9,
              ),
              child: DailyRewardCard(
                rewardNumber: rewardNumber,
                status: rewardCompleted
                    ? DailyRewardStatus.completed
                    : rewardAvailable
                        ? DailyRewardStatus.available
                        : DailyRewardStatus.locked,
                isLoading:
                    rewardAvailable && isRewardAdLoading,
                onWatch:
                    rewardAvailable ? onWatchAvailableReward : null,
              ),
            );
          }),
          const SizedBox(height: 12),

          // Daily reset is intentionally placed directly below Reward 10.
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 11,
            ),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: scheme.outlineVariant,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.refresh_rounded,
                  size: 18,
                  color: scheme.primary,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    allCompleted
                        ? 'All 10 rewards completed. Daily rewards refresh at 4:00 AM.'
                        : 'Daily rewards refresh at 4:00 AM. Completed rewards reset then.',
                    style: TextStyle(
                      color: scheme.onSurfaceVariant,
                      fontSize: 10.5,
                      height: 1.35,
                      fontWeight: FontWeight.w700,
                    ),
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

enum DailyRewardStatus {
  available,
  completed,
  locked,
}

class DailyRewardCard extends StatelessWidget {
  final int rewardNumber;
  final DailyRewardStatus status;
  final bool isLoading;
  final VoidCallback? onWatch;

  const DailyRewardCard({
    super.key,
    required this.rewardNumber,
    required this.status,
    required this.isLoading,
    required this.onWatch,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final rewardCompleted =
        status == DailyRewardStatus.completed;
    final rewardAvailable =
        status == DailyRewardStatus.available;

    final background = rewardCompleted
        ? scheme.tertiaryContainer
        : rewardAvailable
            ? scheme.primaryContainer
            : scheme.surfaceContainerLow;

    final border = rewardCompleted
        ? scheme.tertiaryContainer
        : rewardAvailable
            ? scheme.primaryContainer
            : scheme.surfaceContainerHighest;

    final iconBackground = rewardCompleted
        ? scheme.tertiaryContainer
        : rewardAvailable
            ? scheme.primaryContainer
            : scheme.surfaceContainerHighest;

    final iconColor = rewardCompleted
        ? scheme.tertiary
        : rewardAvailable
            ? scheme.primary
            : scheme.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              rewardCompleted
                  ? Icons.check_rounded
                  : rewardAvailable
                      ? Icons.play_arrow_rounded
                      : Icons.lock_rounded,
              color: iconColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reward $rewardNumber',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  rewardCompleted
                      ? 'Completed'
                      : rewardAvailable
                          ? 'Watch an ad to earn 10 coins'
                          : 'Complete Reward ${rewardNumber - 1} first',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (rewardCompleted)
            const RewardStateIndicator(
              label: 'Done',
              icon: Icons.check_circle_rounded,
            )
          else if (rewardAvailable)
            WatchRewardButton(
              loading: isLoading,
              onPressed: onWatch,
            )
          else
            const RewardStateIndicator(
              label: 'Locked',
              icon: Icons.lock_rounded,
            ),
        ],
      ),
    );
  }
}

class WatchRewardButton extends StatelessWidget {
  final bool loading;
  final VoidCallback? onPressed;

  const WatchRewardButton({
    super.key,
    required this.loading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return FilledButton(
      onPressed: loading ? null : onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        disabledBackgroundColor:
            scheme.primary.withValues(alpha: 0.45),
        disabledForegroundColor: scheme.onSurfaceVariant,
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        minimumSize: const Size(0, 38),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: loading
          ? SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor:
                    AlwaysStoppedAnimation<Color>(
                  scheme.onPrimary,
                ),
              ),
            )
          : const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.ondemand_video_rounded,
                  size: 16,
                ),
                SizedBox(width: 5),
                Text(
                  'Watch Ad',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
    );
  }
}

class RewardStateIndicator extends StatelessWidget {
  final String label;
  final IconData icon;

  const RewardStateIndicator({
    super.key,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final completed = label == 'Done';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color:
              completed ? scheme.tertiary : scheme.onSurfaceVariant,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: completed
                ? scheme.tertiary
                : scheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class WeeklyBonusCard extends StatelessWidget {
  final int weeklyCoins;
  final int weeklyGoal;
  final int weeklyBonus;
  final bool claimed;
  final VoidCallback? onClaim;

  const WeeklyBonusCard({
    super.key,
    required this.weeklyCoins,
    required this.weeklyGoal,
    required this.weeklyBonus,
    required this.claimed,
    required this.onClaim,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final goalReached = weeklyCoins >= weeklyGoal;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: scheme.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: scheme.secondaryContainer,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              Icons.card_giftcard_rounded,
              color: scheme.secondary,
              size: 25,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Weekly Bonus',
                  style: TextStyle(
                    color: scheme.onSecondaryContainer,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  claimed
                      ? 'Bonus claimed for this week'
                      : goalReached
                          ? 'Your +$weeklyBonus bonus is ready!'
                          : 'Reach $weeklyGoal coins to unlock +$weeklyBonus',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: scheme.onSecondaryContainer,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (claimed)
            Icon(
              Icons.check_circle_rounded,
              color: scheme.tertiary,
            )
          else
            FilledButton(
              onPressed: goalReached ? onClaim : null,
              style: FilledButton.styleFrom(
                backgroundColor: scheme.secondary,
                disabledBackgroundColor:
                    scheme.secondaryContainer,
                foregroundColor: scheme.onPrimary,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
              child: Text(
                goalReached ? 'Claim' : '+$weeklyBonus',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _SectionHeader(
            icon: Icons.info_outline_rounded,
            title: 'How It Works',
            subtitle: 'Simple, sequential, and transparent',
          ),
          SizedBox(height: 17),
          HowItWorksStep(
            number: '1',
            icon: Icons.ondemand_video_rounded,
            title: 'Watch a reward ad',
            description:
                'Start with the next available reward.',
          ),
          HowItWorksDivider(),
          HowItWorksStep(
            number: '2',
            icon: Icons.monetization_on_rounded,
            title: 'Receive 10 coins',
            description:
                'In test mode, the reward is simulated after the ad completes.',
          ),
          HowItWorksDivider(),
          HowItWorksStep(
            number: '3',
            icon: Icons.lock_open_rounded,
            title: 'Unlock the next reward',
            description:
                'Rewards must be completed in order.',
          ),
          HowItWorksDivider(),
          HowItWorksStep(
            number: '4',
            icon: Icons.emoji_events_rounded,
            title: 'Complete the weekly goal',
            description:
                'Reach 700 weekly coins and claim the extra 30-coin bonus.',
          ),
        ],
      ),
    );
  }
}

class HowItWorksStep extends StatelessWidget {
  final String number;
  final IconData icon;
  final String title;
  final String description;

  const HowItWorksStep({
    super.key,
    required this.number,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: scheme.primaryContainer,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(
            icon,
            size: 18,
            color: scheme.primary,
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$number. $title',
                style: TextStyle(
                  color: scheme.onSurface,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                description,
                style: TextStyle(
                  color: scheme.onSurfaceVariant,
                  fontSize: 10.5,
                  height: 1.35,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class HowItWorksDivider extends StatelessWidget {
  const HowItWorksDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 17,
        top: 8,
        bottom: 8,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: 1,
          height: 13,
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _SectionCard({
    required this.child,
    this.padding = const EdgeInsets.all(18),
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: scheme.outlineVariant,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .035),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 39,
          height: 39,
          decoration: BoxDecoration(
            color: scheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: scheme.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: scheme.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: scheme.onSurfaceVariant,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String label;
  final IconData icon;

  const _StatusPill({
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 13,
            color: scheme.primary,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: scheme.onSurfaceVariant,
              fontSize: 9.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
