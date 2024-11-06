import 'package:events_ticket/config/routes/app_routes.dart';
import 'package:events_ticket/data/providers/theme_providers.dart';
import 'package:events_ticket/data/repositories/auth_repository.dart';
import 'package:events_ticket/presentation/screens/auth/sign_in_screen.dart';
import 'package:events_ticket/presentation/screens/entryPoint/entry_point.dart';
import 'package:events_ticket/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:events_ticket/core/services/auth/users_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );

  await Supabase.initialize(
    url: "https://naujkknzedkdcmmjlvrr.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5hdWpra256ZWRrZGNtbWpsdnJyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzA1NDgwNTUsImV4cCI6MjA0NjEyNDA1NX0.SlbuNISfQs9RIvMJGD-HO87ATHyQTKRA08c0Zhjk-Fc",
  );

  FlutterNativeSplash.remove();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => AuthRepository()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Event Ticket',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeProvider.themeMode,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRoutes.generateRoute,
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  Future<bool> _getHasSeenOnboarding() async {
    return await SessionManager().hasSeenOnboarding();
  }

  Future<bool> _getIsUserLoggedIn() async {
    return await SessionManager().isUserLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([_getIsUserLoggedIn(), _getHasSeenOnboarding()]),
      builder: (context, AsyncSnapshot<List<bool>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          final isLoggedIn = snapshot.data![0];
          final hasSeenOnboarding = snapshot.data![1];

          if (isLoggedIn) {
            return const EntryPoint(); // User is logged in, navigate to main page
          } else if (hasSeenOnboarding) {
            return const SignInScreen(); // User has seen onboarding, navigate to login
          } else {
            return const OnboardingScreen(); // User hasn't seen onboarding, navigate to onboarding
          }
        } else {
          return const Center(child: Text("Erreur lors de la vérification"));
        }
      },
    );
  }
}
