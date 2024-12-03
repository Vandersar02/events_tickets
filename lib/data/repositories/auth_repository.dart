import 'package:events_ticket/core/services/auth/user_services.dart';
import 'package:events_ticket/core/services/auth/users_manager.dart';
import 'package:events_ticket/data/models/user_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final String webClientId = dotenv.get("webClientId");
  final String iosClientId = dotenv.get("iosClientId");

  final supabase = Supabase.instance.client;
  User? currentUser;
  String? errorMessage;

  void createUserInDb(User? currentUser) async {
    //  Todo: check if it's really the correct logic to get the info
    final userModel = UserModel(
      userId: currentUser!.id,
      name:
          currentUser.userMetadata?['name'] ?? currentUser.email?.split('@')[0],
      email: currentUser.email.toString(),
      profilePictureUrl: currentUser.userMetadata?['picture'] ?? '',
      dateOfBirth: currentUser.userMetadata?['avatar_url'] ?? '',
      gender: currentUser.userMetadata?['gender'] ?? '',
      phoneNumber: currentUser.phone ?? '',
      lastActive: DateTime.now(),
      createdAt: DateTime.now(),
    );
    await UserServices().createUserInDatabase(userModel);
  }

  // Inscription avec email et mot de passe
  Future<void> signUpWithEmail(String email, String password) async {
    try {
      await supabase.auth.signUp(email: email, password: password);

      currentUser = supabase.auth.currentUser;
      print("Current user: $currentUser");

      if (currentUser != null) {
        bool userExists =
            await UserServices().getUserData(currentUser!.id) != null;
        print("User exists: $userExists");

        if (!userExists) {
          print("User doesn't exist");
          createUserInDb(currentUser!);
        }
        print(
            "The User Metadata is: ${UserServices().getUserData(currentUser!.id)}");

        await SessionManager().savePreference("user_id", currentUser!.id);
      }
    } catch (e) {
      print("Erreur lors de l\'inscription:: $e");
      errorMessage = 'Erreur lors de l\'inscription: $e';
    }
  }

  // Connexion avec email et mot de passe
  Future<void> signInWithEmail(String email, String password) async {
    try {
      await supabase.auth.signInWithPassword(email: email, password: password);
      currentUser = supabase.auth.currentUser;
      print("Current user: $currentUser");

      if (currentUser != null) {
        bool userExists =
            await UserServices().getUserData(currentUser!.id) != null;
        print("User exists: $userExists");
        if (!userExists) {
          print("User doesn't exist");
          errorMessage = 'Compte introuvable, veuillez vous inscrire d\'abord.';
          await supabase.auth.signOut();
          return;
        }
        print("UserMedata: ${currentUser?.userMetadata}\n\n\n");
        print(
            "The User Metadata is: ${UserServices().getUserData(currentUser!.id)}");
        await SessionManager().savePreference("user_id", currentUser!.id);
      }
    } catch (e) {
      print("Erreur lors de la connexion:: $e");
      errorMessage = 'Erreur lors de la connexion: $e';
    }
  }

  // Connexion avec Google
  Future<void> signInWithGoogle({bool isSignIn = false}) async {
    try {
      final googleSignIn = GoogleSignIn(
        clientId: iosClientId,
        serverClientId: webClientId,
      );
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        print("Error: googleUser is null");
        errorMessage = 'Connexion annulée par l\'utilisateur.';
        return;
      }

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (idToken == null || accessToken == null) {
        print(
            "Error: idToken:{$idToken} or accessToken:{$accessToken} is null");
        errorMessage = 'Erreur lors de la récupération des tokens Google.';
        return;
      }

      await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      currentUser = supabase.auth.currentUser;
      if (currentUser != null) {
        bool userExists =
            await UserServices().getUserData(currentUser!.id) != null;
        print("User exists: $userExists");

        if (isSignIn && !userExists) {
          print("User doesn't exist");
          errorMessage = 'Aucun compte associé à cette adresse Google.';
          await supabase.auth.signOut();
          return;
        }

        if (!isSignIn && userExists) {
          print("User already exists");
          errorMessage = 'Un compte existe déjà avec cet email Google.';
          await supabase.auth.signOut();
          return;
        }

        if (!userExists) {
          print("User doesn't exist");
          createUserInDb(currentUser!);
        }
        print("The User Metadata is: ${currentUser?.userMetadata}");
        await SessionManager().savePreference("user_id", currentUser!.id);
      }
    } catch (e) {
      print("Erreur inattendue lors de la connexion avec Google:: $e");
      errorMessage = 'Erreur inattendue lors de la connexion avec Google: $e';
    }
  }

  // Déconnexion de l'utilisateur
  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
      await SessionManager().removePreference("has_seen_onboarding");
      await SessionManager().removePreference("user_id");
      currentUser = null;
    } catch (e) {
      errorMessage = 'Erreur lors de la déconnexion : $e';
    }
  }
}
