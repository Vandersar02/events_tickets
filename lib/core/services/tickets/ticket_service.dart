import 'package:cloud_firestore/cloud_firestore.dart';

class TicketService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> purchaseTicket(
      String userId, String eventId, String qrCodeData) async {
    final ticketId = _firestore.collection('tickets').doc().id;
    await _firestore.collection('tickets').doc(ticketId).set({
      'eventId': eventId,
      'userId': userId,
      'qrCodeData': qrCodeData,
      'purchaseDate': FieldValue.serverTimestamp(),
      'isScanned': false,
    });

    await _firestore.collection('events').doc(eventId).update({
      'ticketsSold': FieldValue.increment(1),
    });
  }

  Future<bool> validateTicket(String encryptedData) async {
    final ticketQuery = await _firestore
        .collection('tickets')
        .where('qrCodeData', isEqualTo: encryptedData)
        .get();

    if (ticketQuery.docs.isEmpty) return false;

    final ticket = ticketQuery.docs.first;
    if (ticket['isScanned']) return false;

    await _firestore.collection('tickets').doc(ticket.id).update({
      'isScanned': true,
      'scannedAt': FieldValue.serverTimestamp(),
    });

    return true;
  }
}
