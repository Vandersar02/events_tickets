import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

final supabase = Supabase.instance.client;

class ProfilePageState extends State<ProfilePage> {
  final TextEditingController nameController = TextEditingController(text: "");
  final TextEditingController emailController = TextEditingController(text: "");
  final TextEditingController phoneController = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    supabase.auth.onAuthStateChange.listen((data) {
      setState(() {
        nameController.text =
            data.session?.user.userMetadata!['name'] ?? "John Doe";
        emailController.text =
            data.session?.user.email ?? "john.doe@example.com";
        phoneController.text =
            data.session?.user.userMetadata!['phone'] ?? "0123456789";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Nom
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
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
                labelText: 'Phone',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),

            // Bouton de sauvegarde
            ElevatedButton(
              onPressed: () {
                // Gérer la sauvegarde des informations
                // final name = nameController.text;
                // final email = emailController.text;
                // final phone = phoneController.text;
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
