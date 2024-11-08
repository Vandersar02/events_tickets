import 'package:flutter/material.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Us"),
        centerTitle: true,
        backgroundColor: const Color(0xFF7553F6), // Personnalisez la couleur
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Get in Touch",
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
            ),
            const SizedBox(height: 10),
            const Text(
              "If you have any questions, feel free to contact us through the following methods:",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const ListTile(
              leading: Icon(Icons.email, color: Color(0xFF7553F6)),
              title: Text("Email"),
              subtitle: Text("contact@example.com"),
            ),
            const ListTile(
              leading: Icon(Icons.phone, color: Color(0xFF7553F6)),
              title: Text("Phone"),
              subtitle: Text("+1 (123) 456-7890"),
            ),
            const ListTile(
              leading: Icon(Icons.location_on, color: Color(0xFF7553F6)),
              title: Text("Address"),
              subtitle: Text("123 Event St, Cityville, Country"),
            ),
          ],
        ),
      ),
    );
  }
}
