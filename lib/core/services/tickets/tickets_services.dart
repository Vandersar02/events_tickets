import 'package:events_ticket/core/services/auth/user_services.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TicketsServices {
  final supabase = Supabase.instance.client;

  Future<void> addUserTicketId(String userId, List<String> ticketIds) async {
    try {
      await supabase.from('tickets').update({
        'user_id': userId,
        'ticket_id': ticketIds,
      });
    } catch (error) {
      debugPrint(
          "Erreur lors de l'ajout des tickets dans la base de données: $error");
    }
  }

  // Ajoute un ticket à l'utilisateur
  Future<void> addUserTicket(String userId, String ticketId) async {
    try {
      final userData = await UserServices().getUserData(userId);
      if (userData != null) {
        List<dynamic> currentTickets = userData['tickets'];
        currentTickets.add(ticketId);

        await supabase
            .from('users')
            .update({'tickets': currentTickets}).eq('user_id', userId);
      }
    } catch (error) {
      debugPrint("Erreur lors de l'ajout du ticket à l'utilisateur: $error");
    }
  }

  Future<List<dynamic>> getAllTickets() async {
    final response = await supabase.from("tickets").select("*");
    return response;
  }

  Future<void> purchaseTicket(
      String userId, String eventId, String qrCodeData) async {
    await supabase.from("tickets").insert({
      "eventId": eventId,
      "userId": userId,
      "qrCodeData": qrCodeData,
      "purchaseDate": DateTime.now().toIso8601String(),
    });
  }

  Future<bool> validateTicket(String encryptedData) async {
    final ticketQuery =
        await supabase.from("tickets").select().eq("qrCodeData", encryptedData);

    if (ticketQuery.isEmpty) return false;

    final ticket = ticketQuery.first;
    if (ticket.keys.contains("id")) return true;

    await supabase
        .from("tickets")
        .update({"isValidated": true, "scanned_at": DateTime.now()});
    return true;
  }
}
