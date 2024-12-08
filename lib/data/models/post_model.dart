import 'package:events_ticket/data/models/event_model.dart';
import 'package:events_ticket/data/models/user_model.dart';

class PostModel {
  final String postId;
  final String? mediaUrl;
  final DateTime? createdAt;
  final EventModel? event;
  final UserModel? user;
  final List<String> likes;

  PostModel({
    required this.postId,
    this.mediaUrl,
    this.createdAt,
    this.event,
    this.user,
    this.likes = const [],
  });

  // Conversion des données depuis la base de données (JSON) en modèle PostModel
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      postId: json['id'] as String,
      mediaUrl: json['media_url'] as String?,
      createdAt:
          json['posted_at'] != null ? DateTime.parse(json['posted_at']) : null,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      event: EventModel.fromJson(json['event'] as Map<String, dynamic>),
      likes: (json['likes'] as List<dynamic>? ?? [])
          .map((like) => like as String)
          .toList(),
    );
  }

  // Conversion du modèle PostModel en JSON pour l'envoi vers la base de données
  Map<String, dynamic> toJson() {
    return {
      'id': postId,
      'media_url': mediaUrl,
      'posted_by': user!.userId,
      'posted_at': createdAt?.toIso8601String(),
    };
  }
}
