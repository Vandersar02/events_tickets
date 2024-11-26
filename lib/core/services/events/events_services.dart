import 'package:events_ticket/core/services/tickets/tickets_type_services.dart';
import 'package:events_ticket/data/models/event_model.dart';
import 'package:events_ticket/data/models/preference_model.dart';
import 'package:events_ticket/data/models/user_model.dart';
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

  Future<List<EventModel>> fetchEventsWithDetails(
      List<String> preferenceIds) async {
    try {
      // Fetch events with related details
      final response = await supabase
          .from('events')
          .select(
              '*, event_type: preferences(*), organizer:users!events_organizer_id_fkey(*)')
          .inFilter('event_type', preferenceIds)
          .eq('is_available', true)
          .order('start_at', ascending: true);

      if (response.isEmpty) {
        return [];
      }

      // Iterate over each event and fetch its tickets
      final List<EventModel> events = [];
      for (var eventData in response) {
        final eventsTicketsTypes = await TicketsTypeServices()
            .getEventTicketTypes(eventData['id'] as String);
        print(eventData['id']);

        // Create the EventModel object for each event
        final event = EventModel(
          id: eventData['id'] as String,
          eventTypeFromDB: PreferencesModel.fromMap(
              eventData['event_type'] as Map<String, dynamic>? ?? {}),
          organizerIdFromDB: UserModel.fromJson(
              eventData['organizer'] as Map<String, dynamic>? ?? {}),
          coverImg: eventData['cover_img'] as String?,
          address: eventData['address'] as String?,
          about: eventData['about'] as String?,
          title: eventData['title'] as String,
          deadline: eventData['deadline'] != null
              ? DateTime.parse(eventData['deadline'])
              : null,
          startAt: DateTime.parse(eventData['start_at']),
          endAt: DateTime.parse(eventData['end_at']),
          createdAt: DateTime.parse(eventData['created_at']),
          isAvailable: eventData['is_available'] as bool,
          ticketTypes: eventsTicketsTypes,
        );

        events.add(event);
      }

      return events;
    } catch (error) {
      print("Error fetching events: $error");
      return [];
    }
  }

  Future<List<EventModel>> fetchAllEventByOrganizerId(String userId) async {
    try {
      // Fetch events with related details
      final response = await supabase
          .from('events')
          .select(
              '*, event_preferences: preferences(*), organizer:users!events_organizer_id_fkey(*)')
          .eq('organizer_id', userId)
          .eq('is_available', true)
          .order('start_at', ascending: true);

      if (response.isEmpty) {
        return [];
      }

      // Iterate over each event and fetch its tickets
      final List<EventModel> events = [];
      for (var eventData in response) {
        final eventsTicketsTypes = await TicketsTypeServices()
            .getEventTicketTypes(eventData['id'] as String);

        // Create the EventModel object for each event
        final event = EventModel(
          id: eventData['id'] as String,
          eventTypeFromDB: PreferencesModel.fromMap(
              eventData['event_preferences'] as Map<String, dynamic>? ?? {}),
          organizerIdFromDB: UserModel.fromJson(
              eventData['organizer'] as Map<String, dynamic>? ?? {}),
          coverImg: eventData['cover_img'] as String?,
          address: eventData['address'] as String?,
          about: eventData['about'] as String?,
          title: eventData['title'] as String,
          deadline: eventData['deadline'] != null
              ? DateTime.parse(eventData['deadline'])
              : null,
          startAt: DateTime.parse(eventData['start_at']),
          endAt: DateTime.parse(eventData['end_at']),
          createdAt: DateTime.parse(eventData['created_at']),
          isAvailable: eventData['is_available'] as bool,
          ticketTypes: eventsTicketsTypes,
        );

        events.add(event);
      }

      return events;
    } catch (error) {
      print("Error fetching events: $error");
      return [];
    }
  }
}
