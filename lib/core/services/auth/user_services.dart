import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadFile(File file, String fileName) async {
    try {
      Reference ref = _storage.ref().child('user_images/$fileName');
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask;
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> addUserToFirestore(
      User user, String name, String? profilePictureUrl) async {
    await _firestore.collection('users').doc(user.uid).set(
      {
        'name': name,
        'email': user.email,
        'profilePictureUrl': profilePictureUrl ?? '',
        'isOnline': true,
      },
    );

    Future<DocumentSnapshot> getUserData(String uid) async {
      return await _firestore.collection('users').doc(uid).get();
    }

    Future<void> updateUserPreferences(List<String> preferences) async {
      String uid = _auth.currentUser!.uid;
      await _firestore.collection('users').doc(uid).update({
        'preferences': preferences,
      });
    }

    Future<void> sendMessage(
        String senderId, String receiverId, String messageText) async {
      await FirebaseFirestore.instance.collection('messages').add({
        'senderId': senderId,
        'receiverId': receiverId,
        'messageText': messageText,
        'timestamp': FieldValue.serverTimestamp(),
        'messageType': 'text',
      });
    }

    Future<void> sendImage(
        String senderId, String receiverId, String imageUrl) async {
      await FirebaseFirestore.instance.collection('messages').add({
        'senderId': senderId,
        'receiverId': receiverId,
        'imageUrl': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
        'messageType': 'image',
      });
    }

    Stream<QuerySnapshot> getMessages(String senderId, String receiverId) {
      return FirebaseFirestore.instance
          .collection('messages')
          .where('senderId', isEqualTo: senderId)
          .where('receiverId', isEqualTo: receiverId)
          .orderBy('timestamp')
          .snapshots();
    }

    Stream<QuerySnapshot> getGroupMessages(String groupId) {
      return FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots();
    }

    Future<void> deleteMessage(String messageId) async {
      await FirebaseFirestore.instance
          .collection('messages')
          .doc(messageId)
          .delete();
    }

    Future<void> deleteUser(String uid) async {
      await FirebaseFirestore.instance.collection('users').doc(uid).delete();
    }

    Future<void> updateUserOnlineStatus(String uid, bool isOnline) async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'isOnline': isOnline});
    }

    Future<void> updateUserProfilePicture(
        String uid, String profilePictureUrl) async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'profilePictureUrl': profilePictureUrl});
    }

    Future<void> updateUserName(String uid, String name) async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'name': name});
    }

    Future<void> updateUserEmail(String uid, String email) async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'email': email});
    }

    Future<void> updateUserIsOnline(String uid, bool isOnline) async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'isOnline': isOnline});
    }

    Future<void> purchaseTicket(
        String userId, String eventId, String qrCodeData) async {
      final ticketId =
          FirebaseFirestore.instance.collection('tickets').doc().id;

      await FirebaseFirestore.instance.collection('tickets').doc(ticketId).set({
        'eventId': eventId,
        'userId': userId,
        'qrCodeData': qrCodeData,
        'purchaseDate': FieldValue.serverTimestamp(),
        'isScanned': false,
      });

      await FirebaseFirestore.instance
          .collection('events')
          .doc(eventId)
          .update({
        'ticketsSold': FieldValue.increment(1),
      });
    }

    Future<bool> validateTicket(
        String encryptedData, String decryptedData) async {
      final ticketQuery = await FirebaseFirestore.instance
          .collection('tickets')
          .where('qrCodeData', isEqualTo: encryptedData)
          .get();

      if (ticketQuery.docs.isEmpty) {
        return false;
      }

      final ticket = ticketQuery.docs.first;
      if (ticket['isScanned']) {
        return false; // Ticket déjà scanné
      }

      await FirebaseFirestore.instance
          .collection('tickets')
          .doc(ticket.id)
          .update({
        'isScanned': true,
        'scannedAt': FieldValue.serverTimestamp(),
      });

      return true; // Ticket validé avec succès
    }
  }
}
