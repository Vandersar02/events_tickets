import 'package:events_ticket/config/routes/app_routes.dart';
import 'package:events_ticket/data/providers/theme_providers.dart';
import 'package:events_ticket/data/repositories/auth_repository.dart';
import 'package:events_ticket/presentation/screens/entryPoint/entry_point.dart';
// import 'package:events_ticket/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:events_ticket/core/services/auth/users_manager.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );

  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

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
      home: FutureBuilder<bool>(
        future: const SessionManager().isUserLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return snapshot.hasData && snapshot.data == true
              ? const EntryPoint()
              : const EntryPoint();
          // Todo: add onboarding screen
          // const OnboardingScreen();
        },
      ),
    );
  }
}
