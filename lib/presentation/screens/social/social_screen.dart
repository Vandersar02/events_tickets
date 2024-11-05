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
        child: SocialBody(),
      ),
    );
  }
}

class SocialBody extends StatelessWidget {
  const SocialBody({super.key});
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 10),
          StoriesSection(),
          Divider(),
          FeedSection(),
        ],
      ),
    );
  }
}

class StoriesSection extends StatelessWidget {
  const StoriesSection({super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10, // Number of stories
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: const AssetImage('assets/images/event2.jpg'),
                ),
                const SizedBox(height: 4),
                Text('User $index'),
              ],
            ),
          );
        },
      ),
    );
  }
}

class FeedSection extends StatelessWidget {
  const FeedSection({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5, // Number of posts
      itemBuilder: (context, index) {
        return const PostWidget();
      },
    );
  }
}

class PostWidget extends StatelessWidget {
  const PostWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Post Header
        const ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage('assets/images/event2.jpg'),
          ),
          title: Text('username'),
          subtitle: Text('Location'),
          trailing: Icon(Icons.more_vert),
        ),

        // Post Image
        Container(
          height: 300,
          width: double.infinity,
          color: Colors.grey[300],
          child: Image.asset(
            'assets/images/event2.jpg',
            fit: BoxFit.cover,
          ),
        ),

        // Post Actions
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {},
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.comment_bank_outlined),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.favorite_border_sharp),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),

        // Likes and Caption
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Liked by user1 and 123 others',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              RichText(
                text: const TextSpan(
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: 'username ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: 'Here is the caption of the post...'),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'View all 10 comments',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 4),
              const Text(
                '2 hours ago',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
