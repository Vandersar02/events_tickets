import 'package:events_ticket/data/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.user,
    required this.onTap,
  });

  final VoidCallback onTap;
  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.white24,
          radius: 24,
          child: Icon(
            CupertinoIcons.person,
            color: Colors.white,
            size: 28,
          ),
        ),
        title: Text(
          user?.name ?? "John Doe",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: const Text(
          "Simple User",
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
