import 'package:cloud_firestore/cloud_firestore.dart';

class MessagingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  Future<void> sendMessage(
      String senderId, String receiverId, String messageText) async {
    await _firestore.collection('messages').add({
      'senderId': senderId,
      'receiverId': receiverId,
      'messageText': messageText,
      'timestamp': FieldValue.serverTimestamp(),
      'messageType': 'text',
    });
  }

  Stream<QuerySnapshot> getMessages(String senderId, String receiverId) {
    return _firestore
        .collection('messages')
        .where('senderId', isEqualTo: senderId)
        .where('receiverId', isEqualTo: receiverId)
        .orderBy('timestamp')
        .snapshots();
  }

  Stream<QuerySnapshot> getGroupMessages(String groupId) {
    return _firestore
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
}
