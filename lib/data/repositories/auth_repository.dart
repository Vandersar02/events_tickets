// import 'package:events_ticket/core/services/auth/auth_services.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:events_ticket/core/services/auth/users_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthRepository with ChangeNotifier {
  final webClientId =
      '496831178944-8lfhmpqr2e0c03ogvhj13bujo9mc83ef.apps.googleusercontent.com';
  final iosClientId =
      '496831178944-ogtf55eote1lmvtgg19rhmmqcvoim75r.apps.googleusercontent.com';
  final supabase = Supabase.instance.client;
  User? currentUser;
  String? errorMessage = '';

  // Méthode pour vérifier si un utilisateur existe dans la table `users`
  Future<bool> userExists(String userId) async {
    try {
      final response =
          await supabase.from('users').select().eq('id', userId).single();

      return response.isNotEmpty;
    } catch (error) {
      debugPrint(
          "Erreur lors de la vérification de l'existence de l'utilisateur: $error");
      return false;
    }
  }

  // Inscription par email et mot de passe
  Future<void> signUpWithEmail(String email, String password) async {
    final response = await supabase.auth.signUp(
      email: email,
      password: password,
    );

    if (response.user != null) {
      // await AuthService().createUserInDatabase(response.user!, email);
      await SessionManager().setUserLoggedIn(true);
      notifyListeners();
    }
  }

  // Connexion par email et mot de passe
  Future<void> signInWithEmail(String email, String password) async {
    final response = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.user != null) {
      await SessionManager().setUserLoggedIn(true);
      notifyListeners();
    }
  }

  // Connexion avec Google
  Future<void> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
    );

    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) throw 'No access token found';
    if (idToken == null) throw 'No id token found';

    await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: googleAuth.idToken!,
      accessToken: googleAuth.accessToken,
    );

    currentUser = supabase.auth.currentUser;
    if (currentUser != null && !await userExists(currentUser!.id)) {
      // await _authService.createUserInDatabase(user, user.email!);
      await SessionManager().setUserLoggedIn(true);
    }
  }

  // Connexion avec Apple
  Future<void> signInWithApple() async {
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
      throw 'Erreur d\'authentification Apple';
    }

    await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.apple,
      idToken: credential.identityToken!,
      nonce: rawNonce,
    );

    final user = supabase.auth.currentUser;
    if (user != null && !await userExists(user.id)) {
      // await AuthService().createUserInDatabase(user, user.email!);
    }
  }

  // Déconnexion de l'utilisateur
  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
      await SessionManager().clearSession();
      currentUser = null;
      notifyListeners();
    } catch (e) {
      errorMessage = "Erreur lors de la déconnexion : $e";
      notifyListeners();
      rethrow;
    }
  }
}
