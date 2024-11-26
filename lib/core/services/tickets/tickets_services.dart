// import 'dart:ffi';
import 'package:events_ticket/core/utils/encryption_utils.dart';
import 'package:events_ticket/data/models/ticket_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TicketsServices {
  final supabase = Supabase.instance.client;

  // Fonction pour acheter un ticket
  Future<void> buyTicket(
      String userId, String ticketTypeId, String orderId) async {
    try {
      // Check availability of the ticket type
      final ticketType = await supabase
          .from('ticket_types')
          .select('n_available')
          .eq('id', ticketTypeId)
          .single();

      if (ticketType.isEmpty || ticketType['n_available'] <= 0) {
        print("Aucun ticket disponible pour ce type.");
        return;
      }

      // Insert new ticket
      final ticket = {
        'user_id': userId,
        'ticket_type_id': ticketTypeId,
        'order_id': orderId,
        'state': 'pending',
        'payment_method': 'virtual',
      };

      final response =
          await supabase.from('tickets').insert(ticket).select().single();

      // Update ticket type availability
      await supabase.from('ticket_types').update({
        'n_available': ticketType['n_available'] - 1,
        'n_sold': ticketType['n_sold'] + 1,
      }).eq('id', ticketTypeId);

      print("Ticket acheté avec succès: ${response['id']}");
    } catch (error) {
      print("Erreur lors de l'achat du ticket: $error");
    }
  }

  // Fonction pour annuler un ticket
  Future<void> cancelTicket(String ticketId) async {
    try {
      final ticket = await supabase
          .from('tickets')
          .select('ticket_type_id, state')
          .eq('id', ticketId)
          .single();

      if (ticket.isEmpty || ticket['state'] == 'cancelled') {
        print("Le ticket est déjà annulé ou introuvable.");
        return;
      }

      // final ticketTypeId = ticket['ticket_type_id'];

      // Update ticket state
      await supabase
          .from('tickets')
          .update({'state': 'cancelled'}).eq('id', ticketId);

      //// Update availability of the ticket type
      // await supabase.from('ticket_types').update({
      //   'n_available': supabase
      //           .from('ticket_types')
      //           .select('n_available')
      //           .eq('id', ticketTypeId) + 1,
      //   'n_sold':supabase.from('ticket_types').select('n_sold').eq('id', ticketTypeId) - 1,
      // }).eq('id', ticketTypeId);

      print("Ticket annulé avec succès.");
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
  Future<List<TicketModel>> getUserTickets(String userId,
      {int limit = 20, int offset = 0}) async {
    try {
      final response = await supabase
          .from('tickets')
          .select(
              '*, ticket_type:ticket_type_id(*, event:events!ticket_types_eventId_fkey(*))')
          .eq('user_id', userId)
          .range(offset, offset + limit - 1);

      print(response.first["ticket_type"]);

      return response
          .map<TicketModel>((json) => TicketModel.fromJson(json))
          .toList();
    } catch (error) {
      print("Erreur lors de la récupération des tickets: $error");
      return [];
    }
  }

  // Fonction pour générer un QR Code pour un ticket
  Future<String> generateQRCode(
      Map<String, dynamic> dataForEncrypted, String ticketId) async {
    try {
      String qrCodeData =
          EncryptionUtils.generateSignedAndEncryptedQrDataFromMap(
              dataForEncrypted, "secretKey");

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
