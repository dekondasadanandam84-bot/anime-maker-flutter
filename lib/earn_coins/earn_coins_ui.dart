import 'package:flutter/material.dart';

/// AnimeClip Earn Coins screen.
///
/// Presentation layer only:
/// - Builds the Earn Coins interface.
/// - Receives screen data from the controller.
/// - Sends user actions back through callbacks.
/// - Contains no coin, reward, reset, ad, or weekly business logic.
class EarnCoinsUI extends StatelessWidget {
  final int totalCoins;
  final int todayCoins;
  final int dailyCoinLimit;
  final int weeklyCoins;
  final int weeklyGoal;
  final int weeklyBonus;
  final bool weeklyBonusClaimed;

  /// Number of daily rewards already completed.
  final int completedRewardCount;

  /// The next reward number that can be watched.
  /// `0` means there is currently no available reward.
  final int availableRewardNumber;

  /// Seven presentation states supplied by the controller.
  final List<WeeklyDayStatus> weeklyDayStatuses;

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
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = screenWidth < 360 ? 16.0 : 20.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: const Color(0xFFF8F8FC),
        centerTitle: true,
        title: const Text(
          'Earn Coins',
          style: TextStyle(
            color: Colors.amber,
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
                totalCoins: totalCoins,
                todayCoins: todayCoins,
                dailyCoinLimit: dailyCoinLimit,
              ),
              const SizedBox(height: 18),
              DailyEarningCard(
                todayCoins: todayCoins,
                dailyCoinLimit: dailyCoinLimit,
              ),
              const SizedBox(height: 18),
              WeeklyGoalCard(
                weeklyCoins: weeklyCoins,
                weeklyGoal: weeklyGoal,
                weeklyBonus: weeklyBonus,
                weeklyDayStatuses: weeklyDayStatuses,
              ),
              const SizedBox(height: 18),
              DailyRewardsSection(
                completedRewardCount: completedRewardCount,
                availableRewardNumber: availableRewardNumber,
                isRewardAdLoading: isRewardAdLoading,
                onWatchAvailableReward: onWatchAvailableReward,
              ),
              const SizedBox(height: 18),
              WeeklyBonusCard(
                weeklyCoins: weeklyCoins,
                weeklyGoal: weeklyGoal,
                weeklyBonus: weeklyBonus,
                claimed: weeklyBonusClaimed,
                onClaim: onClaimWeeklyBonus,
              ),
              const SizedBox(height: 18),
              const HowItWorksSection(),
              const SizedBox(height: 18),
              const DailyResetCard(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Presentation state for one day in the seven-day weekly tracker.
///
/// The controller decides which state applies. The UI only renders it.
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
    final progress = dailyCoinLimit <= 0
        ? 0.0
        : (todayCoins / dailyCoinLimit).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF7C3AED),
            Color(0xFF9B5CF6),
            Color(0xFFEC4899),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C3AED).withValues(alpha: .22),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _WalletIcon(),
              const Spacer(),
              const _WalletLabel(),
            ],
          ),
          const SizedBox(height: 22),
          const Text(
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
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
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
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .18),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white24),
      ),
      child: const Icon(
        Icons.account_balance_wallet_rounded,
        color: Colors.white,
        size: 25,
      ),
    );
  }
}

class _WalletLabel extends StatelessWidget {
  const _WalletLabel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .16),
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 15),
          SizedBox(width: 5),
          Text(
            'AnimeClip Wallet',
            style: TextStyle(
              color: Colors.white,
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
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1D1930),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(
                  ' / $dailyCoinLimit coins',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF777381),
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
              backgroundColor: const Color(0xFFEDEAF4),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF8B5CF6),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            dailyGoalCompleted
                ? 'You reached today\'s earning limit.'
                : 'Complete the rewards below to keep earning.',
            style: const TextStyle(
              color: Color(0xFF777381),
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
    final progress = weeklyGoal <= 0
        ? 0.0
        : (weeklyCoins / weeklyGoal).clamp(0.0, 1.0);
    final goalReached = weeklyCoins >= weeklyGoal;
    final remainingCoins = (weeklyGoal - weeklyCoins).clamp(0, weeklyGoal);

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
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1D1930),
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
              backgroundColor: const Color(0xFFEDEAF4),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFFF59E0B),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(
                Icons.card_giftcard_rounded,
                size: 18,
                color: Color(0xFFF59E0B),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  'Reach the goal to unlock +$weeklyBonus bonus coins',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF615C6C),
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

  static const dayLabels = ['D1', 'D2', 'D3', 'D4', 'D5', 'D6', 'D7'];

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
    final completed = status == WeeklyDayStatus.completed;
    final current = status == WeeklyDayStatus.current;

    final background = completed
        ? const Color(0xFFE9F9EF)
        : current
            ? const Color(0xFFF0E9FF)
            : const Color(0xFFF3F1F7);

    final foreground = completed
        ? const Color(0xFF16A34A)
        : current
            ? const Color(0xFF7C3AED)
            : const Color(0xFF9B96A5);

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
              ? const Color(0xFFBDA1F5)
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
    final safeCompletedCount = completedRewardCount.clamp(0, 10);
    final safeAvailableNumber = availableRewardNumber.clamp(0, 10);

    return _SectionCard(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: _SectionHeader(
              icon: Icons.redeem_rounded,
              title: 'Daily Rewards',
              subtitle: '10 rewards × 10 coins',
            ),
          ),
          const SizedBox(height: 17),
          ...List.generate(
  10,
  (index) {
    final rewardNumber = index + 1;
    final rewardCompleted = rewardNumber <= safeCompletedCount;
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
        isLoading: rewardAvailable && isRewardAdLoading,
        onWatch: rewardAvailable
            ? onWatchAvailableReward
            : null,
      ),
    );
  },
),
        ],
      ),
    );
  }
}

/// Presentation state for one daily reward.
///
/// The controller determines this state. The UI renders it.
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
    final rewardCompleted = status == DailyRewardStatus.completed;
    final rewardAvailable = status == DailyRewardStatus.available;

    final background = rewardCompleted
        ? const Color(0xFFF0FBF4)
        : rewardAvailable
            ? const Color(0xFFF5F0FF)
            : const Color(0xFFF7F6F9);

    final border = rewardCompleted
        ? const Color(0xFFD7F2DF)
        : rewardAvailable
            ? const Color(0xFFD9C8F8)
            : const Color(0xFFEAE8EE);

    final iconBackground = rewardCompleted
        ? const Color(0xFFDDF7E6)
        : rewardAvailable
            ? const Color(0xFFE8DEFF)
            : const Color(0xFFECEAF0);

    final iconColor = rewardCompleted
        ? const Color(0xFF16A34A)
        : rewardAvailable
            ? const Color(0xFF7C3AED)
            : const Color(0xFF9B96A5);

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
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF272331),
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
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF85808D),
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
    return FilledButton(
      onPressed: loading ? null : onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: const Color(0xFF7C3AED),
        foregroundColor: Colors.white,
        disabledBackgroundColor: const Color(0xFFB7A2DC),
        disabledForegroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        minimumSize: const Size(0, 38),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: loading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.ondemand_video_rounded, size: 16),
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
    final completed = label == 'Done';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: completed
              ? const Color(0xFF16A34A)
              : const Color(0xFF9B96A5),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: completed
                ? const Color(0xFF16A34A)
                : const Color(0xFF9B96A5),
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
    final goalReached = weeklyCoins >= weeklyGoal;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFF7E5A5)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0BF),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.card_giftcard_rounded,
              color: Color(0xFFD97706),
              size: 25,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Weekly Bonus',
                  style: TextStyle(
                    color: Color(0xFF3A3020),
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
                  style: const TextStyle(
                    color: Color(0xFF8A7751),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (claimed)
            const Icon(
              Icons.check_circle_rounded,
              color: Color(0xFF16A34A),
            )
          else
            FilledButton(
              onPressed: goalReached ? onClaim : null,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFF59E0B),
                disabledBackgroundColor: const Color(0xFFE5D9B8),
                foregroundColor: Colors.white,
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
        children: [
          const _SectionHeader(
            icon: Icons.info_outline_rounded,
            title: 'How It Works',
            subtitle: 'Simple, sequential, and transparent',
          ),
          const SizedBox(height: 17),
          const HowItWorksStep(
            number: '1',
            icon: Icons.ondemand_video_rounded,
            title: 'Watch a reward ad',
            description: 'Start with the next available reward.',
          ),
          const HowItWorksDivider(),
          const HowItWorksStep(
            number: '2',
            icon: Icons.monetization_on_rounded,
            title: 'Receive 10 coins',
            description:
                'Coins are added only after the ad completes successfully.',
          ),
          const HowItWorksDivider(),
          const HowItWorksStep(
            number: '3',
            icon: Icons.lock_open_rounded,
            title: 'Unlock the next reward',
            description: 'Rewards must be completed in order.',
          ),
          const HowItWorksDivider(),
          const HowItWorksStep(
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: const Color(0xFFF0E9FF),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(
            icon,
            size: 18,
            color: const Color(0xFF7C3AED),
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$number. $title',
                style: const TextStyle(
                  color: Color(0xFF292532),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                description,
                style: const TextStyle(
                  color: Color(0xFF85808D),
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
      padding: const EdgeInsets.only(left: 17, top: 8, bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: 1,
          height: 13,
          color: const Color(0xFFE4E0EA),
        ),
      ),
    );
  }
}

class DailyResetCard extends StatelessWidget {
  const DailyResetCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.refresh_rounded,
            color: Color(0xFF64748B),
            size: 20,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Reset',
                  style: TextStyle(
                    color: Color(0xFF334155),
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Daily reward progress resets each day. Your Total Coins are never removed by the reset.',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 10.5,
                    height: 1.35,
                    fontWeight: FontWeight.w600,
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

class _SectionCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _SectionCard({
    required this.child,
    this.padding = const EdgeInsets.all(18),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFECE9F1)),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 39,
          height: 39,
          decoration: BoxDecoration(
            color: const Color(0xFFF0E9FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF7C3AED),
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
                style: const TextStyle(
                  color: Color(0xFF26222E),
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF8A8592),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F1FA),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 13,
            color: const Color(0xFF7C3AED),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF625A70),
              fontSize: 9.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
