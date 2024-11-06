// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<void> addUserToFirestore(User user, String name) async {
//     await _firestore.collection('users').doc(user.uid).set(
//       {
//         'name': name,
//         'email': user.email,
//         'profilePictureUrl': '',
//         'isOnline': true,
//         "isOrganizer": false,
//         "isActive": true,
//         "createdAt": FieldValue.serverTimestamp(),
//         "lastActive": null,
//         "preferences": [],
//         "groups": [],
//         "chatRooms": []
//       },
//     );
//   }

//   Future<DocumentSnapshot> getUserData(String uid) async {
//     return await _firestore.collection('users').doc(uid).get();
//   }

//   Future<void> updateUserOnlineStatus(String uid, bool isOnline) async {
//     await _firestore
//         .collection('users')
//         .doc(uid)
//         .update({'isOnline': isOnline});
//   }

//   Future<void> deleteUser(String uid) async {
//     await _firestore.collection('users').doc(uid).delete();
//   }

//   Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
//     await _firestore.collection('users').doc(uid).update(data);
//   }

//   Future<void> updateUserProfilePicture(
//       String uid, String profilePictureUrl) async {
//     await FirebaseFirestore.instance
//         .collection('users')
//         .doc(uid)
//         .update({'profilePictureUrl': profilePictureUrl});
//   }

//   Future<void> updateUserName(String uid, String name) async {
//     await FirebaseFirestore.instance
//         .collection('users')
//         .doc(uid)
//         .update({'name': name});
//   }

//   Future<void> updateUserEmail(String uid, String email) async {
//     await FirebaseFirestore.instance
//         .collection('users')
//         .doc(uid)
//         .update({'email': email});
//   }

//   Future<void> updateUserPreferences(List<String> preferences) async {
//     String uid = _auth.currentUser!.uid;
//     await _firestore.collection('users').doc(uid).update({
//       'preferences': preferences,
//     });
//   }
// }
