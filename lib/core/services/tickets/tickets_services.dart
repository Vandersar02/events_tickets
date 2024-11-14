import 'package:events_ticket/core/utils/encryption_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TicketsServices {
  final supabase = Supabase.instance.client;

  // Fonction pour acheter un ticket
  Future<void> buyTicket(
      String userId, String ticketTypeId, String orderId) async {
    try {
      final ticket = {
        'user_id': userId,
        'ticket_type_id': ticketTypeId,
        'order_id': orderId,
        'state': 'pending',
        'payment_method': 'virtual',
      };

      final response =
          await supabase.from('tickets').insert(ticket).select().single();

      print("Ticket créé avec succès: ${response['id']}");
    } catch (error) {
      print("Erreur lors de l'achat du ticket: $error");
    }
  }

  // Fonction pour annuler un ticket
  Future<void> cancelTicket(String ticketId) async {
    try {
      final response = await supabase
          .from('tickets')
          .update({
            'state': 'cancelled',
          })
          .eq('id', ticketId)
          .select()
          .single();

      print("Ticket annulé: ${response['id']}");
    } catch (error) {
      print("Erreur lors de l'annulation du ticket: $error");
    }
  }

  // Fonction pour scanner un ticket
  Future<void> scanTicket(String ticketId) async {
    try {
      final response = await supabase
          .from('tickets')
          .update({
            'state': 'completed',
            'scanned_at': DateTime.now().toIso8601String(),
            'is_scanned': true,
          })
          .eq('id', ticketId)
          .select()
          .single();

      print("Ticket scanné avec succès: ${response['id']}");
    } catch (error) {
      print("Erreur lors du scan du ticket: $error");
    }
  }

  // Fonction pour vérifier la validité du ticket en utilisant l'orderId
  Future<bool> verifyTicketWithOrderId(String orderId) async {
    final response = await supabase
        .from('tickets')
        .select('secret_key, state')
        .eq('order_id', orderId)
        .single();

    if (response.isEmpty) {
      return false; // Ticket non trouvé ou erreur dans la requête
    }

    final ticketData = response;
    // final secretKey = ticketData['secret_key'];
    final ticketState = ticketData['state'];

    if (ticketState == 'cancelled') {
      return false; // Ticket annulé, non valide
    }

    // Ici, tu peux effectuer des vérifications supplémentaires (par exemple, expiration du ticket)
    return true; // Ticket valide
  }

  // Fonction pour obtenir un ticket spécifique
  Future<Map<String, dynamic>?> getTicket(String ticketId) async {
    try {
      final response =
          await supabase.from('tickets').select().eq('id', ticketId).single();

      return response;
    } catch (error) {
      print("Erreur lors de la récupération du ticket: $error");
      return null;
    }
  }

  // Fonction pour obtenir tous les tickets d'un utilisateur
  Future<List<Map<String, dynamic>>> getUserTickets(String userId) async {
    try {
      final response =
          await supabase.from('tickets').select().eq('user_id', userId);

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      print(
          "Erreur lors de la récupération des tickets de l'utilisateur: $error");
      return [];
    }
  }

  // Fonction pour générer un QR Code pour un ticket
  Future<String> generateQRCode(String ticketId) async {
    try {
      String qrCodeData = EncryptionUtils.generateSignedAndEncryptedQrData(
          ticketId, "secretKey");

      await supabase
          .from('tickets')
          .update({
            'qrcode_data': qrCodeData,
          })
          .eq('id', ticketId)
          .select()
          .single();

      return qrCodeData;
    } catch (error) {
      print("Erreur lors de la génération du QR Code: $error");
      return "";
    }
  }

  // Fonction pour vérifier la validité du ticket en utilisant le code QR
  Future<bool> verifyTicketWithQrCode(String qrCode) async {
    final response = await supabase
        .from('tickets')
        .select('secret_key, state')
        .eq('qr_code', qrCode)
        .single();

    if (response.isEmpty) {
      return false; // Ticket non trouvé ou erreur dans la requête
    }

    final ticketData = response;
    // final secretKey = ticketData['secret_key'];
    final ticketState = ticketData['state'];

    if (ticketState == 'cancelled') {
      return false; // Ticket annulé, non valide
    }
    return true;
  }
}
