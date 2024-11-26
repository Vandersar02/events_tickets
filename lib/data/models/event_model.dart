import 'package:events_ticket/core/services/auth/users_manager.dart';
import 'package:events_ticket/core/services/events/events_services.dart';
import 'package:events_ticket/core/services/preferences/preferences_services.dart';
import 'package:events_ticket/data/models/preference_model.dart';
import 'package:events_ticket/data/models/ticket_types_model.dart';
import 'package:events_ticket/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final String userId = SessionManager().userId;
final supabase = Supabase.instance.client;

Future<List<PreferencesModel>> preferencesResponse() async =>
    await PreferencesServices().getUserPreferences(userId);

Future<List<EventModel>> fetchRecommendedEvents() async {
  try {
    final List<PreferencesModel> preferences = await preferencesResponse();
    if (preferences.isEmpty) {
      debugPrint("Aucune préférence trouvée pour l'utilisateur $userId.");
      return [];
    }
    final eventsResponse = await EventsServices()
        .fetchEventsWithDetails(preferences.map((e) => e.id).toList());
    return eventsResponse;
  } catch (error) {
    debugPrint(
        "Erreur lors de la récupération des événements recommandés : $error");
    return [];
  }
}

Future<List<EventModel>> fetchFreeEvents() async {
  try {
    // Fetch recommended events
    final eventsList = await fetchRecommendedEvents();

    // Filter events where at least one ticket has a price of 0
    final freeEvents = eventsList
        .where((event) => event.ticketTypes.any((ticket) => ticket.price == 0))
        .toList();
    return freeEvents;
  } catch (error) {
    debugPrint(
        "Erreur lors de la récupération des événements gratuits : $error");
    return [];
  }
}

Future<List<EventModel>> fetchNewestEvents() async {
  try {
    // Fetch recommended events
    final eventsList = await fetchRecommendedEvents();

    // Filter events created in the last 5 days and are available
    final recentEvents = eventsList.where((event) {
      final now = DateTime.now();
      return event.isAvailable &&
          event.createdAt.isAfter(now.subtract(const Duration(days: 5)));
    }).toList();

    // Sort by creation date in descending order
    recentEvents.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return recentEvents;
  } catch (error) {
    debugPrint(
        "Erreur lors de la récupération des nouveaux événements : $error");
    return [];
  }
}

Future<List<EventModel>> fetchOrganizerEvents(String userId) async {
  try {
    final eventsResponse =
        await EventsServices().fetchAllEventByOrganizerId(userId);

    return (eventsResponse as List)
        .map((data) => EventModel.fromJson(data as Map<String, dynamic>))
        .toList();
  } catch (error) {
    debugPrint(
        "Erreur lors de la récupération des événements recommandés : $error");
    return [];
  }
}

class EventModel {
  final String? id;
  final String? eventTypeId;
  final String? organizerId;
  final String? coverImg;
  final String? address;
  final String? about;
  final String? title;
  final DateTime? deadline;
  final DateTime startAt;
  final DateTime endAt;
  final DateTime createdAt;
  final bool isAvailable;
  final List<TicketTypesModel> ticketTypes;
  final PreferencesModel? eventTypeFromDB;
  final UserModel? organizerIdFromDB;

  EventModel({
    this.id,
    this.eventTypeId,
    this.coverImg,
    this.address,
    this.about,
    this.organizerId,
    this.title,
    this.deadline,
    required this.startAt,
    required this.endAt,
    DateTime? createdAt,
    bool? isAvailable,
    this.ticketTypes = const [],
    this.eventTypeFromDB,
    this.organizerIdFromDB,
  })  : createdAt = createdAt ?? DateTime.now(),
        isAvailable = isAvailable ?? false;

  // Calculer la disponibilité totale des tickets
  int get totalTicketsRemaining =>
      ticketTypes.fold(0, (sum, ticket) => sum + ticket.nAvailable);

  // Conversion JSON -> Modèle
  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] as String?,
      eventTypeId: json['event_type'] as String?,
      organizerId: json['organizer_id'] as String?,
      coverImg: json['cover_img'] as String?,
      address: json['address'] as String?,
      about: json['about'] as String?,
      title: json['title'] as String?,
      deadline:
          json['deadline'] != null ? DateTime.tryParse(json['deadline']) : null,
      startAt: DateTime.parse(json['start_at']),
      endAt: DateTime.parse(json['end_at']),
      createdAt: DateTime.parse(json['created_at']),
      isAvailable: json['is_available'] as bool,
      ticketTypes: (json['ticket_types'] as List<dynamic>? ?? [])
          .map((ticket) =>
              TicketTypesModel.fromJson(ticket as Map<String, dynamic>))
          .toList(),
      eventTypeFromDB: json['event_preferences'] != null
          ? PreferencesModel.fromMap(
              json['event_preferences'] as Map<String, dynamic>)
          : null,
      organizerIdFromDB: json['organizer'] != null
          ? UserModel.fromJson(json['organizer_id'] as Map<String, dynamic>)
          : null,
    );
  }

  // Conversion Modèle -> JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event_type': eventTypeId,
      'organizer': organizerId,
      'cover_img': coverImg,
      'address': address,
      'about': about,
      'title': title,
      'deadline': deadline?.toIso8601String(),
      'start_at': startAt.toIso8601String(),
      'end_at': endAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'is_available': isAvailable,
      'ticket_types': ticketTypes.map((ticket) => ticket.toJson()).toList(),
    };
  }
}
