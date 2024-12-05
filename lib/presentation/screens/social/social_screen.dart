import 'package:events_ticket/core/services/auth/users_manager.dart';
import 'package:events_ticket/core/services/post/post_services.dart';
import 'package:events_ticket/data/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SocialScreen extends StatelessWidget {
  const SocialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF7553F6),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Social network',
                style: TextStyle(fontSize: 22, color: Colors.white)),
          ],
        ),
      ),
      body: const SafeArea(
        bottom: false,
        child: SocialPostList(), // Utilisation correcte d'un widget distinct
      ),
    );
  }
}

final supabase = Supabase.instance.client;
final userId = SessionManager().getPreference("user_id");

class SocialPostList extends StatelessWidget {
  const SocialPostList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PostModel>>(
      future: PostServices().getAllPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(
              child: Text("Erreur lors du chargement des posts"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Aucun post disponible"));
        } else {
          final posts = snapshot.data!;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return PostCard(
                userName: post.user?.name ?? "Utilisateur inconnu",
                timeAgo:
                    "${post.createdAt?.difference(DateTime.now()).inHours.abs()} heures",
                profilePictureUrl: post.user?.profilePictureUrl ??
                    "https://via.placeholder.com/150",
                imageUrl: post.mediaUrl ?? "",
                event: post.event?.title ?? "",
                likes: post.likes,
                comments: 0,
                postedBy: post.user!.name!,
                currentUserId: userId.toString(),
              );
            },
          );
        }
      },
    );
  }
}

class PostCard extends StatefulWidget {
  final String userName;
  final String timeAgo;
  final String imageUrl;
  final String profilePictureUrl;
  final String event;
  final List<String> likes; // Liste des IDs des utilisateurs qui ont aimé
  final int comments;
  final String postedBy;
  final String currentUserId; // L'ID de l'utilisateur actuel

  const PostCard({
    super.key,
    required this.userName,
    required this.timeAgo,
    required this.imageUrl,
    required this.profilePictureUrl,
    required this.event,
    required this.likes,
    required this.comments,
    required this.postedBy,
    required this.currentUserId,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late bool isLiked;

  @override
  void initState() {
    super.initState();
    // Initialiser l'état selon la présence de l'utilisateur actuel dans la liste des likes
    isLiked = widget.likes.contains(widget.currentUserId);
  }

  void toggleLike() {
    setState(() {
      if (isLiked) {
        widget.likes.remove(widget.currentUserId);
      } else {
        widget.likes.add(widget.currentUserId);
      }
      isLiked = !isLiked;
    });

    // TODO : Ajouter une requête pour mettre à jour les likes dans la base de données.
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(widget.profilePictureUrl),
              radius: 24,
            ),
            title: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "${widget.postedBy.split(" ")[0]} ",
                    style: const TextStyle(color: Colors.black),
                  ),
                  const TextSpan(
                    text: "FROM ", // 'FROM' en majuscules et en gras
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: widget.event,
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            subtitle: Text(widget.timeAgo),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(widget.imageUrl,
                height: 200, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        isLiked
                            ? Icons.favorite
                            : Icons.favorite_border, // Changer l'icône
                        color: isLiked
                            ? Colors.red
                            : Colors.grey, // Changer la couleur
                      ),
                      onPressed: toggleLike, // Gérer l'événement
                    ),
                    const SizedBox(width: 8),
                    Text(widget.likes.length.toString(),
                        style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 20),
                    const Icon(Icons.comment),
                    const SizedBox(width: 8),
                    Text(widget.comments.toString(),
                        style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
