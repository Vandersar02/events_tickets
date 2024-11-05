import 'package:flutter/material.dart';

class SocialScreen extends StatelessWidget {
  const SocialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Supprime la flèche de retour
        backgroundColor: const Color(0xFF7553F6),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Social network'),
          ],
        ),
      ),
      body: const SafeArea(
        bottom: false,
        child: SocialFeedScreen(),
      ),
    );
  }
}

class SocialFeedScreen extends StatelessWidget {
  const SocialFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      children: [
        // Stories Section
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            children: [
              _buildStoryTile("Add Story", "assets/add_story.png", true),
              _buildStoryTile("Samera", "assets/images/event2.jpg"),
              _buildStoryTile("Julien", "assets/images/event1.jpg"),
              _buildStoryTile("Mariane", "assets/images/event3.jpg"),
            ],
          ),
        ),

        const SizedBox(height: 5),

        // Posts Section
        _buildPostCard(
          userName: "Jemma Ray",
          timeAgo: "19 hours ago",
          imageUrl: "assets/images/event1.jpg",
          likes: 4200,
          comments: 273,
        ),
        _buildPostCard(
          userName: "Eric Ray",
          timeAgo: "20 hours ago",
          imageUrl: "assets/images/event2.jpg",
          likes: 2900,
          comments: 133,
        ),
        _buildPostCard(
          userName: "Jung Taekwoon",
          timeAgo: "1 day ago",
          imageUrl: "assets/images/event2.jpg",
          likes: 20200,
          comments: 908,
        ),
      ],
    );
  }

  Widget _buildStoryTile(String name, String imageUrl,
      [bool isAddStory = false]) {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(imageUrl),
                child: isAddStory
                    ? const Icon(Icons.add, color: Colors.white, size: 24)
                    : null,
              ),
              if (!isAddStory)
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.orange, width: 3),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            name,
            style: const TextStyle(color: Colors.black, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard({
    required String userName,
    required String timeAgo,
    required String imageUrl,
    required int likes,
    required int comments,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(imageUrl),
              radius: 24,
            ),
            title: Text(
              userName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(timeAgo),
            trailing: IconButton(
              icon: const Icon(Icons.more_horiz),
              onPressed: () {},
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imageUrl,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.favorite, color: Colors.red),
                    const SizedBox(width: 4),
                    Text('$likes'),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.comment, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text('$comments Comments'),
                  ],
                ),
                Icon(Icons.share, color: Colors.grey),
              ],
            ),
          ),
          const Divider(color: Colors.grey),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(imageUrl),
                  radius: 14,
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Add a comment...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
