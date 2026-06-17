import 'package:flutter/material.dart';

class CollaborationScreen extends StatefulWidget {
  const CollaborationScreen({super.key});

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Collaboration"),
        centerTitle: true,
      ),

      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.groups,
                    size: 100,
                    color: Colors.blueAccent,
                  ),

                  const SizedBox(height: 20),

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
                    "Work together on anime projects in the future 🚀",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 25),

                  // VOTE COUNTER CARD
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Total Votes: $votes",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // VOTE BUTTON
                  ElevatedButton.icon(
                    onPressed: hasVoted ? null : vote,
                    icon: const Icon(Icons.thumb_up),
                    label: Text(
                      hasVoted ? "Already Voted" : "Vote for Collaboration",
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "Users who voted",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // VOTERS LIST
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade700),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: votedUsers.isEmpty
                        ? const Center(
                            child: Text(
                              "No votes yet",
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            itemCount: votedUsers.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: const Icon(Icons.person),
                                title: Text(votedUsers[index]),
                              );
                            },
                          ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "If votes reach 1000+ target, we will build it 🚀",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}