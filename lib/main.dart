import 'package:events_ticket/config/routes/app_routes.dart';
import 'package:events_ticket/data/providers/theme_providers.dart';
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
    url: "",
    anonKey: "",
  );

  FlutterNativeSplash.remove();

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => ThemeProvider())],
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

// TODO: Remove the true value for testing
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  Future<bool> _getHasSeenOnboarding() async {
    return await SessionManager().hasSeenOnboarding();
    // return true;
  }

  Future<bool> _getIsUserLoggedIn() async {
    return await SessionManager().getPreference("user_id") != null;
    // return true;
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
