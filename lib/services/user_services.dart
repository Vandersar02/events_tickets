import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<DocumentSnapshot> getUserData() async {
    String uid = _auth.currentUser!.uid;
    return _firestore.collection('users').doc(uid).get();
  }

  Future<void> updateUserPreferences(List<String> preferences) async {
    String uid = _auth.currentUser!.uid;
    await _firestore.collection('users').doc(uid).update({
      'preferences': preferences,
    });
  }
}
