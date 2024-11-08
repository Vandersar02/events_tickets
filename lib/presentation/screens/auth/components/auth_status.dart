import 'package:flutter/material.dart';

class AuthStatusWidget extends StatelessWidget {
  final Future<void> authProcess;
  final String successMessage;
  final String errorMessage;

  const AuthStatusWidget({
    super.key,
    required this.authProcess,
    this.successMessage = "Connexion réussie !",
    this.errorMessage = "Échec de la connexion.",
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: authProcess,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // En cours de chargement
          return const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("Authentification en cours..."),
            ],
          );
        } else if (snapshot.hasError) {
          // Authentification échouée
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 40),
              const SizedBox(height: 16),
              Text(errorMessage, style: const TextStyle(color: Colors.red)),
            ],
          );
        } else {
          // Authentification réussie
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 40),
              const SizedBox(height: 16),
              Text(successMessage, style: const TextStyle(color: Colors.green)),
            ],
          );
        }
      },
    );
  }
}
