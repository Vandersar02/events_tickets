class Event {
  final String? eventType;
  final String organizerId;
  final String? coverImg;
  final String? address;
  final String? about;
  final String title;
  final DateTime? deadline;
  final DateTime startAt;
  final DateTime endAt;
  final DateTime createdAt;
  bool isAvailable;

  Event({
    this.eventType,
    required this.organizerId,
    this.coverImg,
    this.address,
    this.about,
    required this.title,
    this.deadline,
    required this.startAt,
    required this.endAt,
    DateTime? createdAt,
    bool? isAvailable,
  })  : createdAt = createdAt ?? DateTime.now(),
        isAvailable = isAvailable ?? false {
    // Calcul automatique de isAvailable
    this.isAvailable = _calculateIsAvailable();
  }

  // Fonction pour calculer automatiquement la disponibilité
  bool _calculateIsAvailable() {
    final now = DateTime.now();

    // Vérifie que la date actuelle est entre la date de début et de fin
    final isDuringEvent = now.isAfter(startAt) && now.isBefore(endAt);
    // Si une deadline est définie, vérifie que l'achat de tickets est encore possible
    final isBeforeDeadline = deadline == null || now.isBefore(deadline!);

    return isDuringEvent && isBeforeDeadline;
  }

  // Conversion des données depuis la base de données (JSON) en modèle Event
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      eventType: json['event_type'] as String?,
      organizerId: json['organizer_id'] as String,
      coverImg: json['cover_img'] as String?,
      address: json['address'] as String?,
      about: json['about'] as String?,
      title: json['title'] as String,
      deadline:
          json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
      startAt: DateTime.parse(json['start_at']),
      endAt: DateTime.parse(json['end_at']),
      createdAt: DateTime.parse(json['created_at']),
      isAvailable: json['is_available'] as bool,
    );
  }

  // Conversion du modèle Event en JSON pour l'envoi vers la base de données
  Map<String, dynamic> toJson() {
    return {
      'event_type': eventType,
      'organizer_id': organizerId,
      'cover_img': coverImg,
      'address': address,
      'about': about,
      'title': title,
      'deadline': deadline?.toIso8601String(),
      'start_at': startAt.toIso8601String(),
      'end_at': endAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'is_available': _calculateIsAvailable(), // recalculer isAvailable
    };
  }
}

final List<Event> events = [
  Event(
    eventType:
        "Music", // Id ou catégorie d'événement, pourrait être UUID d'une catégorie
    organizerId: "user123",
    coverImg: "assets/images/event1.jpg",
    address: "Delmas 105",
    about: "An annual festival celebrating the best in national music.",
    title: "National Music Festival",
    deadline: DateTime.parse("2023-06-01 20:00:00"),
    startAt: DateTime.parse("2023-06-01 23:00:00"),
    endAt: DateTime.parse("2023-06-02 02:00:00"),
    createdAt: DateTime.now(),
    isAvailable: true, // Calcul automatique dans le modèle
  ),
  Event(
    eventType: "Art",
    organizerId: "user456",
    coverImg: "assets/images/event2.jpg",
    address: "Catalpa 8A, Delmas 75",
    about: "A workshop exploring contemporary art techniques.",
    title: "Art Workshop",
    deadline: DateTime.parse("2023-06-03 18:00:00"),
    startAt: DateTime.parse("2023-06-03 22:00:00"),
    endAt: DateTime.parse("2023-06-03 23:30:00"),
    createdAt: DateTime.now(),
    isAvailable: true,
  ),
  Event(
    eventType: "Music",
    organizerId: "user789",
    coverImg: "assets/images/event3.jpg",
    address: "Petion-Ville",
    about: "A live concert featuring top music artists.",
    title: "Music Concert",
    deadline: DateTime.parse("2023-06-05 18:00:00"),
    startAt: DateTime.parse("2023-06-05 20:00:00"),
    endAt: DateTime.parse("2023-06-05 23:00:00"),
    createdAt: DateTime.now(),
    isAvailable: true,
  ),
];
