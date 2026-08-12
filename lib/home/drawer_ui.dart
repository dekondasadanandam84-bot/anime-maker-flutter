import 'package:flutter/material.dart';
import 'package:flutter_application_1/home/home_controller.dart';
import 'package:flutter_application_1/core/app_media.dart';

class DrawerUI extends StatelessWidget {
  final HomeController controller = const HomeController();
  const DrawerUI({super.key});

  @override
  Widget build(BuildContext context) {
    AppMedia.init(context);
    const Color dividerColor = Color(0xFFEAEAEA);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            //================ HEADER =================//
            SizedBox(
              height: AppMedia.h(64),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Center(
                    child: Text(
                      "AnimeClip",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -.3,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Positioned(
                    right: AppMedia.w(16),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.grey,
                        size: 26,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, thickness: 1, color: dividerColor),

            Expanded(
              child: SingleChildScrollView(
                padding: AppMedia.symmetric(horizontal: 24, vertical: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //================ QUICK ACTIONS =================//
                    Row(
                      children: [
                        Expanded(
                          child: _QuickActionCard(
                            icon: Icons.settings,
                            color: Colors.blue,
                            title: "Settings",
                            onTap: () => controller.openSettings(context),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _QuickActionCard(
                            icon: Icons.dashboard_customize,
                            color: Colors.purple,
                            onTap: () => controller.openTemplates(context),
                            title: "Templates",
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _QuickActionCard(
                            icon: Icons.school,
                            color: Colors.green,
                            title: "Tutorials",
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    //================ MENU =================//
                    _MenuTile(
                  icon: Icons.diamond_rounded,
                  iconColor: Colors.indigo,
                  title: "Go Plus",
                  onTapDown: () {
                  const HomeController().openGoPlus(context);
                  },
                ),

                    const Divider(color: dividerColor, height: 1),

                    _MenuTile(
  icon: Icons.group_rounded,
  iconColor: Colors.orange,
  title: "Collaborations",
  onTapDown: () {
    controller.openCollaborations(context);
  },
),

                    const Divider(color: dividerColor, height: 1),

                    _MenuTile(
  icon: Icons.monetization_on_rounded,
  iconColor: Colors.amber,
  title: "Earn Coins",
  onTapDown: () {
    controller.openEarnCoins(context);
  },
),

                    const Divider(color: dividerColor, height: 1),

                    _MenuTile(
  icon: Icons.public,
  iconColor: Colors.blue,
  title: "Follow Us",
  onTapDown: () {
    controller.openFollowUs(context);
  },
),

                    const Divider(color: dividerColor, height: 1),

                    _MenuTile(
  icon: Icons.info,
  iconColor: Colors.teal,
  title: "About Us",
  onTapDown: () {
    controller.openAbout(context);
  },
),
                    const Divider(color: dividerColor, height: 1),

                    const _MenuTile(
                      icon: Icons.help_center,
                      iconColor: Colors.green,
                      title: "Help & Guide",
                    ),

                    const Divider(color: dividerColor, height: 1),

                    const _AccountTile(),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            const Divider(height: 1, thickness: 1, color: dividerColor),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Text(
                "Version 1.0.0",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final VoidCallback? onTap;

  const _QuickActionCard({
    required this.icon,
    required this.color,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppMedia.r(18)),
      child: Container(
        height: AppMedia.h(100),
        width: AppMedia.w(100),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppMedia.r(18)),
          border: Border.all(color: const Color(0xFFEAEAEA)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x11000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: AppMedia.icon(34)),

            const SizedBox(height: 10),

            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppMedia.sp(12),
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback? onTapDown;

  const _MenuTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.onTapDown,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTapDown: (_) {
        onTapDown?.call();
      },
      child: SizedBox(
        height: 60,
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 26,
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountTile extends StatelessWidget {
  const _AccountTile();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Color(0xFFE3F2FD),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: Colors.blue, size: 20),
          ),
          const SizedBox(width: 18),
          const Expanded(
            child: Text(
              "Account",
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}
