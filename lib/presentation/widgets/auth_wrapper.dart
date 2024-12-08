import 'package:events_ticket/core/services/auth/users_manager.dart';
import 'package:events_ticket/presentation/screens/auth/sign_in_screen.dart';
import 'package:events_ticket/presentation/screens/auth/user_information.dart';
import 'package:events_ticket/presentation/screens/entryPoint/entry_point.dart';
import 'package:events_ticket/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';

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

  Future<bool> _getIsInfoUpdated() async {
    final isUpdated = await SessionManager().isInfoUpdated();
    print("isInfoUpdated: $isUpdated");
    return isUpdated;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait(
          [_getIsUserLoggedIn(), _getHasSeenOnboarding(), _getIsInfoUpdated()]),
      builder: (context, AsyncSnapshot<List<bool>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          final isLoggedIn = snapshot.data![0];
          final hasSeenOnboarding = snapshot.data![1];
          final isInfoUpdated = snapshot.data![2];

          if (isInfoUpdated) {
            print(
                "User has updated their information, navigating to entrypoint");
            return const EntryPoint(); // User has updated their information, navigate to entrypoint
          } else if (isLoggedIn) {
            print("User is logged in, navigating to user information");
            return const UserInformationScreen(); // User is logged in, navigate to user information
          } else if (hasSeenOnboarding) {
            print("User has seen onboarding, navigating to login");
            return const SignInScreen(); // User has seen onboarding, navigate to login
          } else {
            print("User hasn't seen onboarding, navigating to onboarding");
            return const OnboardingScreen(); // User hasn't seen onboarding, navigate to onboarding
          }
        } else {
          return const Center(child: Text("Erreur lors de la vérification"));
        }
      },
    );
  }
}
