import 'package:flutter/material.dart';

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

// Nouveau widget séparé pour la liste des posts
class SocialPostList extends StatelessWidget {
  const SocialPostList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10, // Exemple : 10 éléments
      itemBuilder: (context, index) {
        return buildPostCard(
          userName: index % 2 == 0 ? "Thanh Pham" : "Bruno From Happy New Year",
          timeAgo: index % 2 == 0 ? "2 hours ago" : "1 day ago",
          profilePictureUrl: index % 2 == 0
              ? "https://img.freepik.com/free-vector/professional-tiktok-profile-picture_742173-5866.jpg"
              : "https://img.freepik.com/free-photo/front-view-man-party-suit-bow-tie_23-2148331839.jpg",
          imageUrl: index % 2 == 0
              ? "https://img.freepik.com/free-psd/party-social-media-template_505751-3159.jpg"
              : "https://img.freepik.com/free-photo/front-view-man-party-suit-bow-tie_23-2148331839.jpg",
          likes: 125,
          comments: 20,
        );
      },
    );
  }

  // Ajout de la méthode buildPostCard ici
  Widget buildPostCard({
    required String userName,
    required String timeAgo,
    required String imageUrl,
    required String profilePictureUrl,
    required int likes,
    required int comments,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(profilePictureUrl),
              radius: 24,
            ),
            title: Text(userName,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(timeAgo),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(imageUrl,
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
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 8),
                    Text(comments.toString(),
                        style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 16),
                    const Icon(Icons.comment),
                    const SizedBox(width: 8),
                    Text(likes.toString(),
                        style: const TextStyle(fontSize: 14)),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// FutureBuilder<List<Post>>(
//   future: fetchPosts("popular"), // Replace "popular" with the selected tab's category
//   builder: (context, snapshot) {
//     if (snapshot.connectionState == ConnectionState.waiting) {
//       return const Center(child: CircularProgressIndicator());
//     } else if (snapshot.hasError) {
//       return const Center(child: Text("Failed to load posts"));
//     } else {
//       final posts = snapshot.data!;
//       return ListView.builder(
//         itemCount: posts.length,
//         itemBuilder: (context, index) {
//           final post = posts[index];
//           return buildPostCard(
//             userName: post.userName,
//             timeAgo: post.timeAgo,
//             imageUrl: post.imageUrl,
//             likes: post.likes,
//             comments: post.comments,
//           );
//         },
//       );
//     }
//   },
// );
