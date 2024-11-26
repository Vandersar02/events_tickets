import 'package:events_ticket/presentation/screens/auth/components/forgot_password.dart';
import 'package:events_ticket/presentation/screens/auth/sign_in_screen.dart';
import 'package:events_ticket/presentation/screens/auth/sign_up_screen.dart';
import 'package:events_ticket/presentation/screens/auth/user_information.dart';
import 'package:events_ticket/presentation/screens/entryPoint/entry_point.dart';
import 'package:events_ticket/presentation/screens/onboarding/onboarding_screen.dart';
// import 'package:events_ticket/presentation/screens/qr_code/ticket_qr_code_page.dart';
import 'package:flutter/material.dart';

// Classe contenant les routes de l'application
class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signUp = '/signUp';
  static const String userInformation = '/user-information';
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
      case userInformation:
        return MaterialPageRoute(
            builder: (_) =>
                const UserInformationScreen()); // Route pour l'écran de l'information de l'utilisateur
      // case ticket:
      //   return MaterialPageRoute(
      //       builder: (_) =>
      //           const TicketQRCodePage()); // Route pour l'écran du ticket
      case forgetPassword:
        return MaterialPageRoute(
          builder: (_) => ForgotPasswordScreen(),
        );
      default:
        return MaterialPageRoute(
            builder: (_) =>
                const SignInScreen()); // Route par défaut renvoyant à l'écran de connexion
    }
  }
}
