import 'package:events_ticket/data/models/event_model.dart';
import 'package:events_ticket/data/models/user_model.dart';

class TicketTypesModel {
  final String id;
  final String type;
  final double price;
  final int nAvailable;
  final int nSold;
  final EventModel? eventId;
  final UserModel? organizerId;
  final String currency;

  TicketTypesModel({
    required this.id,
    this.eventId,
    this.organizerId,
    required this.type,
    required this.price,
    required this.nAvailable,
    required this.nSold,
    required this.currency,
  });

  // Conversion des données depuis la base de données (JSON) en modèle TicketType
  factory TicketTypesModel.fromJson(Map<String, dynamic> json) {
    return TicketTypesModel(
      id: json['id'] ?? "",
      type: json['type'] ?? "",
      price: json['price'] ?? 0.0,
      nAvailable: json['n_available'] ?? 0,
      nSold: json['n_sold'] ?? 0,
      currency: json['currency'] ?? "",
      eventId: EventModel.fromJson(json['event'] as Map<String, dynamic>),
    );
  }

  // Conversion du modèle TicketType en JSON pour l'envoi vers la base de données
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event_id': eventId!.id,
      'type': type,
      'price': price,
      'n_available': nAvailable,
      'n_sold': nSold,
      'currency': currency,
    };
  }
}
