import 'package:supabase_flutter/supabase_flutter.dart';

class TicketsTypeServices {
  final supabase = Supabase.instance.client;

  // Fonction pour créer un type de ticket pour un événement
  Future<void> createTicketType(String eventId, String type, double price,
      int nAvailable, String currency) async {
    try {
      final ticketType = {
        'event_id': eventId,
        'type': type,
        'price': price,
        'n_available': nAvailable,
        'currency': currency,
      };

      final response = await supabase
          .from('ticket_types')
          .insert(ticketType)
          .select()
          .single();

      print("Type de ticket créé avec succès: ${response['id']}");
    } catch (error) {
      print("Erreur lors de la création du type de ticket: $error");
    }
  }

  // Fonction pour obtenir tous les types de tickets pour un événement
  Future<List<Map<String, dynamic>>> getEventTicketTypes(String eventId) async {
    try {
      final response =
          await supabase.from('ticket_types').select().eq('event_id', eventId);

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      print("Erreur lors de la récupération des types de tickets: $error");
      return [];
    }
  }

  // Fonction pour acheter un ticket (mettre à jour le nombre de tickets disponibles et vendus)
  Future<void> buyTicket(String ticketTypeId) async {
    try {
      // Récupérer le type de ticket pour obtenir n_available et n_sold
      final ticketType = await supabase
          .from('ticket_types')
          .select('n_available, n_sold')
          .eq('id', ticketTypeId)
          .single();

      int nAvailable = ticketType['n_available'];
      int nSold = ticketType['n_sold'];

      if (nAvailable > 0) {
        // Mettre à jour le nombre de tickets disponibles et vendus
        await supabase.from('ticket_types').update({
          'n_available': nAvailable - 1,
          'n_sold': nSold + 1,
        }).eq('id', ticketTypeId);

        print("Ticket acheté avec succès pour le type: $ticketTypeId");
      } else {
        print("Aucun ticket disponible pour ce type.");
      }
    } catch (error) {
      print("Erreur lors de l'achat du ticket: $error");
    }
  }

  // Fonction pour mettre à jour les informations d'un type de ticket
  Future<void> updateTicketType(String ticketTypeId,
      {String? type, double? price, int? nAvailable, String? currency}) async {
    try {
      final updatedFields = <String, dynamic>{};

      if (type != null) updatedFields['type'] = type;
      if (price != null) updatedFields['price'] = price;
      if (nAvailable != null) updatedFields['n_available'] = nAvailable;
      if (currency != null) updatedFields['currency'] = currency;

      final response = await supabase
          .from('ticket_types')
          .update(updatedFields)
          .eq('id', ticketTypeId)
          .select()
          .single();

      print("Type de ticket mis à jour avec succès: ${response['id']}");
    } catch (error) {
      print("Erreur lors de la mise à jour du type de ticket: $error");
    }
  }
}
