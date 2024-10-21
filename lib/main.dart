import 'package:events_ticket/config/routes/app_routes.dart';
import 'package:events_ticket/data/providers/theme_providers.dart';
import 'package:events_ticket/presentation/screens/auth/connect_screen.dart';
import 'package:events_ticket/presentation/screens/entryPoint/entry_point.dart';
import 'package:events_ticket/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Préserve l'écran de splash jusqu'à ce que les initialisations soient complètes
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Forcer l'orientation en portrait uniquement
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    // DeviceOrientation.portraitDown,
  ]);

  // Initialisation de Firebase avec les options spécifiques à la plateforme
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Retrait de l'écran de splash une fois que Firebase est initialisé
  FlutterNativeSplash.remove();

  // Lancement de l'application avec un fournisseur de changement de thème
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

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
      themeMode: themeProvider.themeMode,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRoutes.generateRoute,
      initialRoute: AppRoutes.onboarding,
      // initialRoute: AppRoutes.entryPoint,
      // home: AuthCheck(), // Utilisation d'AuthCheck pour la redirection
    );
  }
}

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return FutureBuilder(
      future: _checkIfOnboardingSeen(),
      builder: (context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        bool hasSeenOnboarding = snapshot.data!;

        // Si l'utilisateur est déjà connecté
        if (user != null) {
          return const EntryPoint();
        }

        // Si l'utilisateur n'a pas encore vu l'onboarding
        if (!hasSeenOnboarding) {
          return const OnboardingScreen();
        }

        // Sinon, redirige vers l'écran de connexion
        return const LoginScreen();
      },
    );
  }

  // Vérifie si l'utilisateur a déjà vu l'onboarding
  Future<bool> _checkIfOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('hasSeenOnboarding') ?? false;
  }
}
