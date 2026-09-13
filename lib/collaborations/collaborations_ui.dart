import 'package:flutter/material.dart';

class CollaborationsUI extends StatefulWidget {
  const CollaborationsUI({super.key});

  @override
  State<CollaborationsUI> createState() => _CollaborationsUIState();
}

class _CollaborationsUIState extends State<CollaborationsUI> {
  bool hasVoted = false;

  // Fake members for UI/testing only.
  // Replace this list with real backend vote/member data later.
  final List<_TestVoter> _testVoters = const [
    _TestVoter(name: 'Revanth', username: '@Revanth'),
    _TestVoter(name: 'Anirudh', username: '@Anirudh'),
    _TestVoter(name: 'Sandeep', username: '@Sandeep'),
    _TestVoter(name: 'Lokesh', username: '@Lokesh'),
    _TestVoter(name: 'Hruthik', username: '@Hruthik'),
    _TestVoter(name: 'Dhanush', username: '@Dhanush'),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildComingSoonSection(),
                    _buildCommunityVotingSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      height: 72,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(
          bottom: BorderSide(
            color: scheme.surfaceContainerHighest,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.close_rounded,
              color: scheme.onSurface,
              size: 22,
            ),
            tooltip: 'Back',
          ),
          Expanded(
            child: Center(
              child: Text(
                'Collaborations',
                style: TextStyle(
                  color: scheme.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildComingSoonSection() {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 17,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: scheme.outlineVariant,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0D000000),
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Text(
              'Coming Soon',
              style: TextStyle(
                color: scheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: scheme.outlineVariant,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 24,
                  left: 24,
                  child: _buildBackgroundCircle(75),
                ),
                Positioned(
                  right: 24,
                  bottom: 24,
                  child: _buildBackgroundCircle(90),
                ),
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: scheme.surface,
                    border: Border.all(
                      color: scheme.surface,
                      width: 5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.10),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/screen12.png',
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Center(
                        child: Icon(
                          Icons.groups_rounded,
                          size: 54,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 60,
                  right: 65,
                  child: _buildFloatingIcon(Icons.add_rounded),
                ),
                Positioned(
                  bottom: 58,
                  left: 65,
                  child: _buildFloatingIcon(
                    Icons.auto_awesome_rounded,
                  ),
                ),
                Positioned(
                  top: 72,
                  left: 72,
                  child: _buildDot(),
                ),
                Positioned(
                  bottom: 72,
                  right: 72,
                  child: _buildDot(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Collaborations Coming Soon',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: scheme.onSurface,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Vote for ideas and help shape what '
              'comes next in our creative ecosystem '
              'if 1000+ votes reach we build it.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: scheme.onSurfaceVariant,
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 64),
        ],
      ),
    );
  }

  Widget _buildCommunityVotingSection() {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Text(
            'COMMUNITY VOTING',
            style: TextStyle(
              color: scheme.onSurfaceVariant,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 32),

          // Test-only member list replaces the fake global vote count.
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 10),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: scheme.outlineVariant,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Recent voters',
                        style: TextStyle(
                          color: scheme.onSurface,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'Test data',
                        style: TextStyle(
                          color: scheme.onSurfaceVariant,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Sample community members shown for UI testing.',
                  style: TextStyle(
                    color: scheme.onSurfaceVariant,
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 12),
                ..._testVoters.map(_buildVoterTile),
              ],
            ),
          ),

          const SizedBox(height: 36),
          Material(
            color: hasVoted
                ? scheme.surfaceContainerHighest
                : scheme.primary,
            borderRadius: BorderRadius.circular(999),
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () {
                setState(() {
                  hasVoted = !hasVoted;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      hasVoted
                          ? Icons.check_rounded
                          : Icons.how_to_vote_rounded,
                      size: 18,
                      color: hasVoted
                          ? scheme.onSurface
                          : scheme.onPrimary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      hasVoted ? 'Voted' : 'Vote',
                      style: TextStyle(
                        color: hasVoted
                            ? scheme.onSurface
                            : scheme.onPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 64),
        ],
      ),
    );
  }

  Widget _buildVoterTile(_TestVoter voter) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 21,
            backgroundColor: scheme.primaryContainer,
            child: Text(
              voter.name.substring(0, 1),
              style: TextStyle(
                color: scheme.onPrimaryContainer,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  voter.name,
                  style: TextStyle(
                    color: scheme.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  voter.username,
                  style: TextStyle(
                    color: scheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.check_circle_rounded,
            size: 20,
            color: scheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundCircle(double size) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildFloatingIcon(IconData icon) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: scheme.surface,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(
        icon,
        size: 20,
        color: scheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildDot() {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: scheme.outlineVariant,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _TestVoter {
  final String name;
  final String username;

  const _TestVoter({
    required this.name,
    required this.username,
  });
}
