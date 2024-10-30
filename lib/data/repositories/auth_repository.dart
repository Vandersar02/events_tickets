import 'package:events_ticket/services/users_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SessionManager _sessionManager = SessionManager();

  // Vérification si l'utilisateur existe dans Firestore
  Future<bool> userExists(String uid) async {
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(uid).get();
    return userDoc.exists;
  }

  // Inscription avec email et mot de passe
  Future<User?> signUpWithEmail(
      String email, String password, String name) async {
    try {
      // Vérifier si l'utilisateur existe déjà
      var existingUser = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      if (existingUser.docs.isNotEmpty) {
        throw Exception("L' utilisateur existe déjà");
      }

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set(
          {
            // 'username': username,
            'email': email,
            'uid': user.uid,
            'isAdmin': false, // Statut par défaut
            'preferences': [], // Préférences vides par défaut
            'createdAt': FieldValue.serverTimestamp(),
          },
        );
      }

      await _sessionManager.saveUserLogin();

      return user;
    } catch (e) {
      throw Exception("Erreur d'inscription : $e");
    }
  }

  // Connexion avec email et mot de passe
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _sessionManager.saveUserLogin();

      return userCredential.user;
    } catch (e) {
      throw Exception("Erreur de connexion : $e");
    }
  }

  // Authentification Google
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      // Vérification dans Firestore
      bool exists = await userExists(user!.uid);
      if (!exists) {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': googleUser.displayName,
          'email': googleUser.email,
          'isAdmin': false, // Statut par défaut
          'preferences': [], // Préférences vides par défaut
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      await _sessionManager.saveUserLogin();

      return user;
    } catch (e) {
      throw Exception("Erreur d'authentification Google : $e");
    }
  }

  // Authentification Apple (iOS uniquement)
  Future<User?> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final OAuthCredential oauthCredential =
          OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(oauthCredential);
      User? user = userCredential.user;

      // Vérification dans Firestore
      bool exists = await userExists(user!.uid);
      if (!exists) {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': "${appleCredential.givenName} ${appleCredential.familyName}",
          'email': appleCredential.email,
          'isAdmin': false,
          'preferences': [],
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      await _sessionManager.saveUserLogin();

      return user;
    } catch (e) {
      throw Exception("Erreur d'authentification Apple : $e");
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();

    // Supprime la session de l'utilisateur
    await _sessionManager.logoutUser();
  }

  // Récupérer l'utilisateur actuel
  User? get currentUser => _auth.currentUser;
}
