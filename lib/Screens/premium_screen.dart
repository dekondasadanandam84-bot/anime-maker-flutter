import 'package:flutter/material.dart';

class PremiumScreen extends StatelessWidget {
  final VoidCallback onBack;
  const PremiumScreen({
  super.key,
  required this.onBack,
});

  Widget planCard({
    required String title,
    required String price,
    required List<String> features,
    required String buttonText,
    required bool isCurrent,
    required bool isPremium,
    String? badge,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PREMIUM TITLE
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 6,
                horizontal: 10,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: isPremium
                    ? const LinearGradient(
                        colors: [
                          Colors.amber,
                          Colors.orange,
                        ],
                      )
                    : const LinearGradient(
                        colors: [
                          Colors.grey,
                          Colors.blueGrey,
                        ],
                      ),
              ),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // PRICE
            Text(
              price,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 10),

            // FEATURES
            ...features.map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 18,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(e)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            // BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    isCurrent ? null : () {},
                child: Text(buttonText),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
Widget build(BuildContext context) {
  return Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            "Anime Maker Plans",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 24),

          planCard(
            title: "FREE PLAN",
            price: "₹0 / Forever",
            isCurrent: true,
            isPremium: false,
            buttonText: "CURRENT PLAN",
            features: const [
              "Unlimited Local Projects",
              "Unlock premium brushes and fonts for 24 hours max 3 for each (via credits)",
              "Manual backup through file manager and google drive",
              "Includes 10 HD exports per month (credit-based)",
              "720p Export",
              "Watermark",
              "Basic Brushes",
              "Ads Supported",
            ],
          ),

          planCard(
            title: "PRO MONTHLY",
            price: "₹149 / MONTHLY",
            isCurrent: false,
            isPremium: true,
            buttonText: "SUBSCRIBE",
            features: const [
              "Unlimited Local Projects",
              "No Watermark",
              "Manual backup through file manager and google drive",
              "Premium Brushes",
              "Premium Fonts",
              "Ad Free",
            ],
          ),

          planCard(
            title: "PRO YEARLY",
            price: "₹699 / YEARLY",
            isCurrent: false,
            isPremium: true,
            buttonText: "SUBSCRIBE",
            features: const [
              "Unlimited Local Projects",
              "No Watermark",
              "Manual backup through file manager and google drive",
              "Premium Brushes",
              "Premium Fonts",
              "Ad Free",
              "Save ₹1089 per year",
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    ),
  );
}
}