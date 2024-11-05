import 'package:events_ticket/presentation/screens/auth/components/forgot_password.dart';
import 'package:events_ticket/presentation/screens/auth/sign_in_screen.dart';
import 'package:events_ticket/presentation/screens/auth/sign_up_screen.dart';
import 'package:events_ticket/presentation/screens/entryPoint/entry_point.dart';
import 'package:events_ticket/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:events_ticket/presentation/screens/qr_code/qr_code_generator.dart';
import 'package:flutter/material.dart';

// Classe contenant les routes de l'application
class AppRoutes {
  // Définition des noms de route en tant que constantes
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signUp = '/signUp';
  static const String entryPoint = '/entryPoint';
  static const String eventList = '/events';
  static const String eventDetails = '/event-details';
  static const String ticket = '/ticket';
  static const String socialFeed = '/social';
  static const String postDetails = '/post-details';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String checkout = '/checkout';
  static const String payment = '/payment';
  static const String orderDetails = '/order-details';
  static const String address = '/address';
  static const String forgetPassword = '/forgetPassword';

  // Méthode qui génère une route en fonction du nom donné
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Vérification du nom de la route et renvoi de la bonne page
    switch (settings.name) {
      case onboarding:
        return MaterialPageRoute(
            builder: (_) =>
                const OnboardingScreen()); // Route pour l'écran d'accueil
      case login:
        return MaterialPageRoute(
            builder: (_) =>
                const SignInScreen()); // Route pour l'écran de connexion
      case signUp:
        return MaterialPageRoute(
            builder: (_) =>
                const SignUpScreen()); // Route pour l'écran d'inscription
      case entryPoint:
        return MaterialPageRoute(
            builder: (_) =>
                const EntryPoint()); // Route pour le point d'entrée de l'application
      // Les routes suivantes sont commentées mais elles pourraient être activées avec des écrans correspondants
      // case eventList:
      //   return MaterialPageRoute(builder: (_) => EventListScreen()); // Route pour la liste des événements
      // case eventDetails:
      //   var eventId = settings.arguments as String;
      //   return MaterialPageRoute(builder: (_) => EventDetailsScreen(eventId: eventId)); // Route pour les détails d'un événement
      case ticket:
        return MaterialPageRoute(
            builder: (_) =>
                const TicketQRCodePage()); // Route pour l'écran du ticket
      case forgetPassword:
        return MaterialPageRoute(
          builder: (_) => ForgotPasswordScreen(),
        );
      // case socialFeed:
      //   return MaterialPageRoute(builder: (_) => SocialFeedScreen()); // Route pour le fil d'actualité social
      // case postDetails:
      //   var postId = settings.arguments as String;
      //   return MaterialPageRoute(builder: (_) => PostDetailScreen(postId: postId)); // Route pour les détails d'un post social
      default:
        return MaterialPageRoute(
            builder: (_) =>
                const SignInScreen()); // Route par défaut renvoyant à l'écran de connexion
    }
  }
}
