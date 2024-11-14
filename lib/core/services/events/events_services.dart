import 'package:events_ticket/data/models/events.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventsServices {
  final supabase = Supabase.instance.client;

  // Fonction pour créer un nouvel événement en utilisant le modèle Event
  Future<void> createEvent(Event event) async {
    try {
      final response = await supabase.from('events').insert(event.toJson());

      if (response.error != null) {
        print(
            "Erreur lors de la création de l'événement: ${response.error!.message}");
      }
    } catch (error) {
      print("Erreur lors de la création de l'événement: $error");
    }
  }
}
