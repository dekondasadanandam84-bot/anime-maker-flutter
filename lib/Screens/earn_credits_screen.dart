import 'package:flutter/material.dart';

class EarnCreditsScreen extends StatefulWidget {
  final VoidCallback onBack;
  const EarnCreditsScreen({
  super.key,
  required this.onBack,
});

  @override
  State<EarnCreditsScreen> createState() => _EarnCreditsScreenState();
}

class _EarnCreditsScreenState extends State<EarnCreditsScreen> {
  int totalCredits = 0;

  int creditsToday = 0;

  static const int rewardPerAd = 5;
  static const int maxDailyCredits = 100;
  
  

  void watchAd() {
    // 🚫 DAILY LIMIT CHECK
if (creditsToday >= maxDailyCredits) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Limit Reached"),
        content: const Text(
          "You have reached today's limit of 100 credits.",
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
  return;
}
    // 🎬 REWARD LOGIC
    setState(() {
      totalCredits += rewardPerAd;
      creditsToday += rewardPerAd;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("+5 Credits Earned 🎉"),
      ),
    );
  }

 @override
Widget build(BuildContext context) {
  return LayoutBuilder(
    builder: (context, constraints) {
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: constraints.maxHeight,
          ),
          child: IntrinsicHeight(
            child: Column(
              children: [
                const Spacer(),

                const Text(
                  "Earn Credits",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 24),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Total Credits",
                        style: TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "$totalCredits",
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Today: $creditsToday / $maxDailyCredits",
                        style: const TextStyle(color: Colors.white70),
                      ),
                      Text(
                        "Per Ad: +$rewardPerAd",
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: watchAd,
                    icon: const Icon(Icons.play_circle),
                    label: const Text("Watch Ad to Earn Credits"),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      );
    },
  );
}
}