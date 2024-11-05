// import 'package:events_ticket/core/services/auth/auth_services.dart';
// import 'package:events_ticket/core/services/auth/users_manager.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/foundation.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';

// class AuthRepository with ChangeNotifier {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final SessionManager _sessionManager = const SessionManager();
//   User? currentUser;
//   String? errorMessage = '';

//   Future<bool> userExists(String uid) async {
//     try {
//       DocumentSnapshot userDoc =
//           await _firestore.collection('users').doc(uid).get();
//       return userDoc.exists;
//     } catch (e) {
//       debugPrint(
//           "Erreur lors de la vérification de l'existence de l'utilisateur: $e");
//       return false;
//     }
//   }

//   Future<void> signUpWithEmail(
//       String email, String password, String name) async {
//     try {
//       var existingUser = await _firestore
//           .collection('users')
//           .where('email', isEqualTo: email)
//           .get();
//       if (existingUser.docs.isNotEmpty) {
//         throw Exception("L'utilisateur existe déjà");
//       }

//       UserCredential userCredential = await _auth
//           .createUserWithEmailAndPassword(email: email, password: password);
//       User? user = userCredential.user;

//       if (user != null) {
//         await AuthService().addUserToFirestore(user, name);
//         await _sessionManager.saveUserLogin();
//         currentUser = user;
//         notifyListeners();
//       }
//     } catch (e) {
//       errorMessage = "Erreur d'inscription : $e";
//       notifyListeners();
//       rethrow;
//     }
//   }

//   Future<void> signInWithEmail(String email, String password) async {
//     try {
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//           email: email, password: password);
//       await _sessionManager.saveUserLogin();
//       currentUser = userCredential.user;
//       notifyListeners();
//     } catch (e) {
//       errorMessage = "Erreur de connexion : $e";
//       notifyListeners();
//       rethrow;
//     }
//   }

//   Future<void> signInWithGoogle() async {
//     try {
//       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//       if (googleUser == null) return;

//       final GoogleSignInAuthentication googleAuth =
//           await googleUser.authentication;
//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       UserCredential userCredential =
//           await _auth.signInWithCredential(credential);
//       User? user = userCredential.user;

//       if (user != null) {
//         if (!await userExists(user.uid)) {
//           await AuthService().addUserToFirestore(
//               user, googleUser.displayName ?? "Utilisateur");
//         }
//         await _sessionManager.saveUserLogin();
//         currentUser = user;
//         notifyListeners();
//       }
//     } catch (e) {
//       errorMessage = "Erreur avec Google Sign-In : $e";
//       notifyListeners();
//       rethrow;
//     }
//   }

//   Future<void> signInWithApple() async {
//     try {
//       final appleCredential = await SignInWithApple.getAppleIDCredential(
//         scopes: [
//           AppleIDAuthorizationScopes.email,
//           AppleIDAuthorizationScopes.fullName
//         ],
//       );

//       final OAuthCredential oauthCredential =
//           OAuthProvider("apple.com").credential(
//         idToken: appleCredential.identityToken,
//         accessToken: appleCredential.authorizationCode,
//       );

//       UserCredential userCredential =
//           await _auth.signInWithCredential(oauthCredential);
//       User? user = userCredential.user;

//       if (user != null) {
//         if (!await userExists(user.uid)) {
//           final fullName =
//               "${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}"
//                   .trim();
//           await AuthService().addUserToFirestore(
//               user, fullName.isNotEmpty ? fullName : "Utilisateur Apple");
//         }
//         await _sessionManager.saveUserLogin();
//         currentUser = user;
//         notifyListeners();
//       }
//     } catch (e) {
//       errorMessage = "Erreur avec Apple Sign-In : $e";
//       notifyListeners();
//       rethrow;
//     }
//   }

//   Future<void> signOut() async {
//     try {
//       await _auth.signOut();
//       await _sessionManager.logoutUser();
//       currentUser = null;
//       notifyListeners();
//     } catch (e) {
//       errorMessage = "Erreur lors de la déconnexion : $e";
//       notifyListeners();
//       rethrow;
//     }
//   }
// }
