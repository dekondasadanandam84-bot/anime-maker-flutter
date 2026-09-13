import 'package:flutter/material.dart';

// ============================================================================
// GO PLUS UI
// ============================================================================

class GoPlusUI extends StatefulWidget {
  const GoPlusUI({super.key});

  @override
  State<GoPlusUI> createState() => _GoPlusUIState();
}

class _GoPlusUIState extends State<GoPlusUI> {
  String selectedPlan = 'yearly';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHero(),

                    const SizedBox(height: 8),

                    _buildBenefits(),

                    const SizedBox(height: 8),

                    _buildFreeUsersCard(),

                    const SizedBox(height: 8),

                    _buildPricing(),

                    const SizedBox(height: 8),

                    _buildGoPlusButton(),

                    _buildFooter(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // HEADER
  // ==========================================================================


Widget _buildHeader() {
  return SizedBox(
    height: 48,
    width: double.infinity,
    child: Align(
      alignment: Alignment.topLeft,
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.close_rounded,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          size: 26,
        ),
      ),
    ),
  );
}



  // ==========================================================================
  // HERO
  // ==========================================================================

  Widget _buildHero() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
        top: 8,
        bottom: 24,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.asset(
          'assets/screen11.png',
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (
            BuildContext context,
            Object error,
            StackTrace? stackTrace,
          ) {
            return Container(
              height: 180,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Icon(
                  Icons.image_outlined,
                  size: 48,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ==========================================================================
  // BENEFITS
  // ==========================================================================

  Widget _buildBenefits() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BenefitTile(
          icon: Icons.cloud_sync_outlined,
          title: 'Cloud Sync',
          description:
              'Sync projects across all your devices seamlessly.',
        ),

        _BenefitTile(
          icon: Icons.cloud_outlined,
          title: 'Unlimited Cloud Projects',
          description:
              'Store as many animations as you want.',
        ),

        _BenefitTile(
          icon: Icons.backup_outlined,
          title: 'Manual Backup',
          description:
              'Back up projects to File Manager or Google Drive.',
        ),

        _BenefitTile(
          icon: Icons.block_outlined,
          title: 'Ads Free',
          description:
              'Enjoy an uninterrupted creative workflow.',
        ),

        _BenefitTile(
          icon: Icons.brush_outlined,
          title: 'Premium Brushes',
          description:
              'Access exclusive professional drawing tools.',
        ),

        _BenefitTile(
          icon: Icons.text_fields_outlined,
          title: 'Premium Fonts',
          description:
              'Unlock the full typography library for your clips.',
          bottomPadding: false,
        ),
      ],
    );
  }

  // ==========================================================================
  // FREE USERS
  // ==========================================================================

  Widget _buildFreeUsersCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
        bottom: 32,
      ),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.30),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.only(
              right: 12,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.info_outline,
              size: 18,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),

          Expanded(
            child: Text(
              'Free users can create unlimited local projects.\n'
              'Manual backup is available to File Manager and Google Drive.\n'
              'Earn Coins to unlock premium brushes and fonts for 12 hours.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 12,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // PRICING
  // ==========================================================================

  Widget _buildPricing() {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            children: [
              Expanded(
                child: _PlanCard(
                  title: 'Yearly',
                  price: '₹799',
                  period: '/year',
                  selected: selectedPlan == 'yearly',
                  onTap: () {
                    setState(() {
                      selectedPlan = 'yearly';
                    });
                  },
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: _PlanCard(
                  title: 'Monthly',
                  price: '₹99',
                  period: '/month',
                  selected: selectedPlan == 'monthly',
                  onTap: () {
                    setState(() {
                      selectedPlan = 'monthly';
                    });
                  },
                ),
              ),
            ],
          ),

          // BEST VALUE BADGE
          Positioned(
            top: -10,
            left: 44,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 9,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                'BEST VALUE',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.surface,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // GO PLUS BUTTON
  // ==========================================================================

  Widget _buildGoPlusButton() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 32,
      ),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                debugPrint(
                  'Selected plan: $selectedPlan',
                );

                // Purchase logic will be connected later.
              },
              borderRadius: BorderRadius.circular(999),
              child: Ink(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurface,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x12000000),
                      blurRadius: 16,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Go Plus',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.surface,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            'Cancel anytime',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // FOOTER
  // ==========================================================================

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 41,
        bottom: 32,
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              bottom: 16,
            ),
            child: Text(
              'Your cloud projects remain available for 30 days after\n'
              'your Plus access ends. Ensure you download important\n'
              'files locally.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              // Restore purchase logic later.
            },
            child: Padding(
              padding: EdgeInsets.only(
                bottom: 16,
              ),
              child: Text(
                'Restore Purchase',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Privacy Policy',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Text(
                  '•',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ),

              Text(
                'Terms of Use',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// PLAN CARD
// ============================================================================

class _PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final String period;
  final bool selected;
  final VoidCallback onTap;

  const _PlanCard({
    required this.title,
    required this.price,
    required this.period,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 180,
        ),
        curve: Curves.easeOut,

        padding: const EdgeInsets.symmetric(
          vertical: 18,
        ),

        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),

          // SELECTED PLAN = PINK BORDER
          border: Border.all(
            color: selected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outlineVariant,
            width: selected ? 2.5 : 1,
          ),

          // SELECTED PLAN = PINK SHADOW
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : const [],
        ),

        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              price,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              period,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// BENEFIT TILE
// ============================================================================

class _BenefitTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool bottomPadding;

  const _BenefitTile({
    required this.icon,
    required this.title,
    required this.description,
    this.bottomPadding = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: bottomPadding ? 16 : 0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.only(
              right: 16,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 22,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  description,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 14,
                    height: 1.35,
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
