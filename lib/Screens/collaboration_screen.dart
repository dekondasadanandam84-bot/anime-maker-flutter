import 'package:flutter/material.dart';

class CollaborationScreen extends StatefulWidget {

  final VoidCallback onBack;
  const CollaborationScreen({
  super.key,
  required this.onBack,
});

  @override
  State<CollaborationScreen> createState() =>
      _CollaborationScreenState();
}

class _CollaborationScreenState
    extends State<CollaborationScreen> {
  int votes = 0;
  bool hasVoted = false;

  List<String> votedUsers = [];
  

  void vote() {
    if (hasVoted) return;

    setState(() {
      votes++;
      hasVoted = true;
      votedUsers.add("You");
    });
  }

  @override
Widget build(BuildContext context) {
  return Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.groups,
            size: 90,
            color: Colors.blueAccent,
          ),

          const SizedBox(height: 15),

          const Text(
            "Collaboration Coming Soon",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            "Vote to unlock this feature",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 25),

          Text(
            "Total Votes: $votes",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          ElevatedButton.icon(
            onPressed: hasVoted ? null : vote,
            icon: const Icon(Icons.thumb_up),
            label: Text(
              hasVoted ? "Already Voted" : "Vote Now",
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            "Users who voted:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          votedUsers.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "No votes yet",
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: votedUsers.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(votedUsers[index]),
                    );
                  },
                ),

          const SizedBox(height: 20),

          const Text(
            "If votes reach 1000+ target, we will build it 🚀",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    ),
  );
}
}