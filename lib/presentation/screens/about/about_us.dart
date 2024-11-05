import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
        centerTitle: true,
        backgroundColor: const Color(0xFF7553F6), // Personnalisez la couleur
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Who We Are",
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
            ),
            const SizedBox(height: 10),
            const Text(
              "We are a leading company in event management, dedicated to providing "
              "the best experiences for event organizers and attendees alike.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              "Our Mission",
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Our mission is to simplify event management and bring people together "
              "through unforgettable experiences. We strive to provide a platform "
              "that is reliable, innovative, and accessible to all.",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
