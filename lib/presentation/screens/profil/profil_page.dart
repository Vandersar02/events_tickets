import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final TextEditingController nameController =
      TextEditingController(text: "John Doe");
  final TextEditingController emailController =
      TextEditingController(text: "john.doe@example.com");
  final TextEditingController phoneController =
      TextEditingController(text: "0123456789");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Profil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Nom
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nom',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),

            // Email
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),

            // Téléphone
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Téléphone',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),

            // Bouton de sauvegarde
            ElevatedButton(
              onPressed: () {
                // Gérer la sauvegarde des informations
                final name = nameController.text;
                final email = emailController.text;
                final phone = phoneController.text;
                // Ici, tu peux enregistrer ces données à l'aide d'une API ou d'une base de données
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Informations enregistrées avec succès!')),
                );
              },
              child: const Text('Sauvegarder'),
            ),
          ],
        ),
      ),
    );
  }
}
