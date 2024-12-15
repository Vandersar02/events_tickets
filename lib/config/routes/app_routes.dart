import 'package:events_ticket/presentation/screens/auth/components/forgot_password.dart';
import 'package:events_ticket/presentation/screens/auth/sign_in_screen.dart';
import 'package:events_ticket/presentation/screens/auth/sign_up_screen.dart';
import 'package:events_ticket/presentation/screens/auth/user_information.dart';
import 'package:events_ticket/presentation/screens/entryPoint/entry_point.dart';
import 'package:events_ticket/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signUp = '/signUp';
  static const String userInformation = '/userInformation';
  static const String entryPoint = '/entryPoint';
  static const String forgetPassword = '/forgetPassword';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case onboarding:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
        );
      case login:
        return MaterialPageRoute(
          builder: (_) => const SignInScreen(),
        );
      case signUp:
        return MaterialPageRoute(
          builder: (_) => const SignUpScreen(),
        );
      case entryPoint:
        return MaterialPageRoute(
          builder: (_) => const EntryPoint(),
        );
      case userInformation:
        final args = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => UserInformationScreen(userUuid: args),
        );
      case forgetPassword:
        return MaterialPageRoute(
          builder: (_) => ForgotPasswordScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const SignInScreen(),
        );
    }
  }
}
