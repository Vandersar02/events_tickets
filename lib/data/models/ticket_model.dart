import 'package:events_ticket/data/models/ticket_types_model.dart';

class TicketModel {
  final String id;
  final String? userId;
  final TicketTypesModel ticketTypeId;
  final String orderId;
  final String state;
  final String paymentMethod;
  final String? qrCodeData;
  final bool isScanned;
  final DateTime createdAt;
  final DateTime? scannedAt;

  TicketModel({
    required this.id,
    this.userId,
    required this.ticketTypeId,
    required this.orderId,
    required this.state,
    required this.paymentMethod,
    this.qrCodeData,
    this.isScanned = false,
    required this.createdAt,
    this.scannedAt,
  });

  // Conversion des données depuis la base de données (JSON) en modèle Ticket
  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      id: json['id'],
      userId: json['user_id'],
      ticketTypeId: TicketTypesModel.fromJson(
          json['ticket_type'] as Map<String, dynamic>),
      orderId: json['order_id'],
      qrCodeData: json['qrcode_data'],
      isScanned: json['is_scanned'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      scannedAt: json['scanned_at'] != null
          ? DateTime.parse(json['scanned_at'])
          : null,
      state: json['state'],
      paymentMethod: json['payment_method'],
    );
  }

  // Conversion du modèle Ticket en JSON pour l'envoi vers la base de données
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'ticket_type_id': ticketTypeId,
      'order_id': orderId,
      'state': state,
      'payment_method': paymentMethod,
      'qrcode_data': qrCodeData,
      'is_scanned': isScanned,
      'created_at': createdAt.toIso8601String(),
      'scanned_at': scannedAt?.toIso8601String(),
    };
  }
}
