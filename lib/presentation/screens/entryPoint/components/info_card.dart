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
    // Extraire prénom et nom
    final fullName = user?.name ?? "John Doe";
    final nameParts = fullName.split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts.first : "John";
    final lastName =
        nameParts.length > 1 ? nameParts.sublist(1).join(' ') : "Doe";

    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.white24,
          radius: 24,
          backgroundImage: user?.profilePictureUrl != null &&
                  user!.profilePictureUrl.isNotEmpty
              ? NetworkImage(user!.profilePictureUrl) as ImageProvider
              : null,
          child:
              user?.profilePictureUrl == null || user!.profilePictureUrl.isEmpty
                  ? const Icon(
                      CupertinoIcons.person,
                      color: Colors.white,
                      size: 28,
                    )
                  : null,
        ),
        title: Text(
          lastName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          firstName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
