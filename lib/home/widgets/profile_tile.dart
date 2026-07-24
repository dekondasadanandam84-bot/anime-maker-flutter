import 'package:flutter/material.dart';

class ProfileTile extends StatelessWidget {
  final String name;
  final bool isActive;

  const ProfileTile({
    super.key,
    required this.name,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.deepPurple.shade100
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isActive
              ? Colors.deepPurple
              : Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.deepPurple.shade200,
            child: const Icon(
              Icons.person,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}