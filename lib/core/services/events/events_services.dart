import 'package:events_ticket/data/models/event_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

class EventsServices {
  final supabase = Supabase.instance.client;

  // Fonction pour créer un nouvel événement en utilisant le modèle Event
  Future<void> createEvent(EventModel event) async {
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

  Future<void> updateUserField(
      String userId, String fieldName, dynamic value) async {
    try {
      final Map<String, dynamic> updateData = {fieldName: value};

      // Met à jour la colonne spécifiée dans la base de données
      await supabase.from('events').update(updateData).eq('user_id', userId);
    } catch (error) {
      debugPrint(
          "Erreur lors de la mise à jour de la colonne $fieldName: $error");
    }
  }

  Future<List<EventModel>> fetchAllEventsByPreferences(
      List<String> preferenceIds) async {
    try {
      final response = await supabase
          .from('events')
          .select('*')
          .inFilter('event_type', preferenceIds)
          .eq('is_available', true)
          .order('start_at', ascending: true);
      return (response as List)
          .map((data) => EventModel.fromJson(data as Map<String, dynamic>))
          .toList();
    } catch (error) {
      debugPrint(
          "Erreur lors de la récupération de tous les événements : $error");
      return [];
    }
  }

  Future<List<EventModel>> fetchFreeEvent(List<String> preferenceIds) async {
    try {
      final response = await supabase
          .from('events')
          .select('*, tickets: ticket_types(price)')
          .inFilter('event_type', preferenceIds)
          .eq('is_available', true)
          .eq('tickets.price', 0)
          .order('start_at', ascending: true);
      return (response as List)
          .map((data) => EventModel.fromJson(data as Map<String, dynamic>))
          .toList();
    } catch (error) {
      debugPrint(
          "Erreur lors de la récupération de tous les événements : $error");
      return [];
    }
  }
}
