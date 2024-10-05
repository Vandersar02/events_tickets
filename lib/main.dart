import 'package:events_ticket/config/routes/app_routes.dart';
import 'package:events_ticket/data/providers/theme_providers.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

// Fonction principale qui exécute l'application
void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Préserve l'écran de splash jusqu'à ce que les initialisations soient complètes
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialisation de Firebase avec les options spécifiques à la plateforme
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Retrait de l'écran de splash une fois que Firebase est initialisé
  FlutterNativeSplash.remove();

  // Lancement de l'application avec un fournisseur de changement de thème
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(), // Fournisseur du thème
      child: const MyApp(),
    ),
  );
}

// Classe principale de l'application qui définit le widget racine
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Accès au fournisseur de thème pour gérer le mode clair/sombre
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Event Ticket',
      theme: ThemeData.light(), // Thème clair par défaut
      darkTheme: ThemeData.dark(), // Thème sombre
      themeMode:
          themeProvider.themeMode, // Gestion dynamique du mode clair/sombre
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRoutes
          .generateRoute, // Génération des routes en fonction de leur nom
      initialRoute: AppRoutes
          .onboarding, // Route initiale vers l'écran d'accueil (onboarding)
    );
  }
}
