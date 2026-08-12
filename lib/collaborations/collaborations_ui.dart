
import 'package:flutter/material.dart';

class CollaborationsUI extends StatefulWidget {
  const CollaborationsUI({super.key});

  @override
  State<CollaborationsUI> createState() => _CollaborationsUIState();
}

class _CollaborationsUIState extends State<CollaborationsUI> {
  bool hasVoted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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

  // ============================================================
  // HEADER
  // ============================================================


Widget _buildHeader() {
  return Container(
    height: 72,
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 8),
    decoration: const BoxDecoration(
      color: Color(0xFFF9F9F9),
      border: Border(
        bottom: BorderSide(
          color: Color(0xFFE8E8E8),
          width: 1,
        ),
      ),
    ),
    child: Row(
      children: [
        // ========================================================
        // BACK BUTTON
        // ========================================================

        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF1A1C1C),
            size: 22,
          ),
          tooltip: 'Back',
        ),

        // ========================================================
        // CENTERED TITLE
        // ========================================================

        const Expanded(
          child: Center(
            child: Text(
              'Collaborations',
              style: TextStyle(
                color: Colors.orange,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        // Keeps title centered relative to the back button.
        const SizedBox(
          width: 48,
        ),
      ],
    ),
  );
}



  // ============================================================
  // COMING SOON SECTION
  // ============================================================

  Widget _buildComingSoonSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        32,
        16,
        0,
      ),
      child: Column(
        children: [
          // ------------------------------------------------------
          // COMING SOON BADGE
          // ------------------------------------------------------

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 17,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F3F4),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: const Color(0xFFCFC4C5),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0D000000),
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: const Text(
              'Coming Soon',
              style: TextStyle(
                color: Color(0xFF5E5E5E),
                fontSize: 12,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // ------------------------------------------------------
          // MAIN COLLABORATION CARD
          // ------------------------------------------------------

          Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              color: const Color(0xFFF6F6F7),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFE5E5E5),
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background decoration
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

                // ------------------------------------------------
                // ONLY IMAGE ON THIS SCREEN
                // ------------------------------------------------

                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.white,
                      width: 5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: 0.10,
                        ),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/screen12.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Small plus decoration
                Positioned(
                  top: 60,
                  right: 65,
                  child: _buildFloatingIcon(
                    Icons.add_rounded,
                  ),
                ),

                // Small sparkle decoration
                Positioned(
                  bottom: 58,
                  left: 65,
                  child: _buildFloatingIcon(
                    Icons.auto_awesome_rounded,
                  ),
                ),

                // Small decorative dots
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

          // ------------------------------------------------------
          // TITLE
          // ------------------------------------------------------

          const Text(
            'Collaborations Coming Soon',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF1A1C1C),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          // ------------------------------------------------------
          // DESCRIPTION
          // ------------------------------------------------------

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Vote for ideas and help shape what '
              'comes next in our creative ecosystem'
              ' if 1000+ votes reach we build it.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF5E5E5E),
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

  // ============================================================
  // COMMUNITY VOTING
  // ============================================================

  Widget _buildCommunityVotingSection() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      children: [
        const Text(
          'COMMUNITY VOTING',
          style: TextStyle(
            color: Color(0xFF5E5E5E),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.6,
          ),
        ),

        const SizedBox(height: 32),

        // ------------------------------------------------------
        // COMMUNITY VOTE COUNT CARD
        // ------------------------------------------------------

        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 28,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFF6F6F7),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFE5E5E5),
            ),
          ),
          child: Column(
            children: [
              // Vote count
              Text(
                '1,248',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF1A1C1C),
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 6),

              // Vote count label
              const Text(
                'PEOPLE VOTED',
                style: TextStyle(
                  color: Color(0xFF5E5E5E),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),

              const SizedBox(height: 16),

              // Supporting message
              const Text(
                'Your vote helps shape what AnimeClip builds next.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF5E5E5E),
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 36),

        // ------------------------------------------------------
        // VOTE BUTTON
        // ------------------------------------------------------

        Material(
          color: hasVoted
              ? const Color(0xFFEEEEEE)
              : Colors.black,
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
                        ? const Color(0xFF1A1C1C)
                        : Colors.white,
                  ),

                  const SizedBox(width: 8),

                  Text(
                    hasVoted ? 'Voted' : 'Vote',
                    style: TextStyle(
                      color: hasVoted
                          ? const Color(0xFF1A1C1C)
                          : Colors.white,
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

  // ============================================================
  // BACKGROUND CIRCLE
  // ============================================================

  Widget _buildBackgroundCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFFEDEDEF),
        shape: BoxShape.circle,
      ),
    );
  }

  // ============================================================
  // FLOATING ICON
  // ============================================================

  Widget _buildFloatingIcon(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.06,
            ),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(
        icon,
        size: 20,
        color: const Color(0xFF5E5E5E),
      ),
    );
  }

  // ============================================================
  // DECORATIVE DOT
  // ============================================================

  Widget _buildDot() {
    return Container(
      width: 10,
      height: 10,
      decoration: const BoxDecoration(
        color: Color(0xFFD1D1D3),
        shape: BoxShape.circle,
      ),
    );
  }

  // ============================================================
  // VOTE CHOICE
  // ============================================================

}

