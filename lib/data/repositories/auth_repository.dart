import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:events_ticket/core/services/auth/user_services.dart';
import 'package:events_ticket/core/services/auth/users_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthRepository {
  final String webClientId =
      '496831178944-8lfhmpqr2e0c03ogvhj13bujo9mc83ef.apps.googleusercontent.com';
  final String iosClientId =
      '496831178944-ogtf55eote1lmvtgg19rhmmqcvoim75r.apps.googleusercontent.com';
  final supabase = Supabase.instance.client;
  User? currentUser;
  String? errorMessage;

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
          await UserServices().createUserInDatabase(currentUser!);
        }
        print("The User Metadata is: ${currentUser?.userMetadata}");
        await SessionManager().savePreference("user_id", currentUser!.id);
      }
    } catch (e) {
      print("Error: $e");
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
        print("The User Metadata is: ${currentUser?.userMetadata}");
        await SessionManager().savePreference("user_id", currentUser!.id);
      }
    } catch (e) {
      print("Error: $e");
      errorMessage = 'Erreur lors de la connexion: $e';
    }
  }

  // Connexion avec Google
  Future<void> signInWithGoogle({bool isSignIn = false}) async {
    try {
      final googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        print("Error: googleUser is null");
        errorMessage = 'Connexion annulée par l\'utilisateur.';
        return;
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      final accessToken = googleAuth.accessToken;

      if (idToken == null || accessToken == null) {
        print("Error: idToken or accessToken is null");
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
          await UserServices().createUserInDatabase(currentUser!);
        }
        print("The User Metadata is: ${currentUser?.userMetadata}");
        await SessionManager().savePreference("user_id", currentUser!.id);
      }
    } catch (e) {
      print("Error: $e");
      errorMessage = 'Erreur inattendue lors de la connexion avec Google: $e';
    }
  }

  // Connexion avec Apple
  Future<void> signInWithApple({bool isSignIn = false}) async {
    try {
      final rawNonce = supabase.auth.generateRawNonce();
      final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );

      if (credential.identityToken == null) {
        errorMessage = 'Erreur lors de la connexion avec Apple';
        return;
      }

      await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: credential.identityToken!,
        nonce: rawNonce,
      );

      currentUser = supabase.auth.currentUser;
      if (currentUser != null) {
        bool userExists =
            await UserServices().getUserData(currentUser!.id) != null;

        if (isSignIn && !userExists) {
          errorMessage = 'Aucun compte associé à cette adresse Apple.';
          await supabase.auth.signOut();
          return;
        }

        if (!isSignIn && userExists) {
          errorMessage = 'Un compte existe déjà avec cet identifiant Apple.';
          await supabase.auth.signOut();
          return;
        }

        if (!userExists) {
          await UserServices().createUserInDatabase(currentUser!);
        }

        print("The User Metadata is: ${currentUser?.userMetadata}");
        await SessionManager().savePreference("user_id", currentUser!.id);
      }
    } catch (e) {
      errorMessage = 'Erreur inattendue lors de la connexion avec Apple: $e';
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
