class Event {
  final DateTime date;
  final String title;
  final String location;
  final String imageUrl;
  final bool isFree;
  final int attendeesCount;
  final String category;
  final int ticketsAvailable;
  final int ticketsSold;
  final double revenue;
  final String? description;
  final List<Map<String, dynamic>> reviews;

  Event({
    required this.date,
    required this.title,
    required this.location,
    required this.imageUrl,
    this.isFree = false,
    this.attendeesCount = 0,
    required this.category,
    required this.ticketsAvailable,
    this.ticketsSold = 0,
    this.revenue = 0.0,
    this.description,
    this.reviews = const [],
  });
}

final List<Event> events = [
  Event(
    date: DateTime.parse("2023-06-01 23:00:00"),
    title: "National Music Festival",
    location: "Delmas 105",
    imageUrl: "assets/images/event1.jpg",
    isFree: true,
    attendeesCount: 100,
    category: "Music",
    ticketsAvailable: 500,
    ticketsSold: 350,
    revenue: 15000.0,
    description: "An annual festival celebrating the best in national music.",
    reviews: [
      {"user": "Alice", "comment": "Amazing festival!", "rating": 4.5},
      {"user": "Bob", "comment": "Loved the performances!", "rating": 4.0},
    ],
  ),
  Event(
    date: DateTime.parse("2023-06-03 22:00:00"),
    title: "Art Workshop",
    location: "Catalpa 8A, Delmas 75",
    imageUrl: "assets/images/event2.jpg",
    isFree: false,
    attendeesCount: 50,
    category: "Art",
    ticketsAvailable: 100,
    ticketsSold: 50,
    revenue: 2500.0,
    description: "A workshop exploring contemporary art techniques.",
    reviews: [
      {
        "user": "Clara",
        "comment": "Inspiring and well-organized!",
        "rating": 5.0
      },
      {"user": "David", "comment": "Great learning experience.", "rating": 4.5},
    ],
  ),
  Event(
    date: DateTime.parse("2023-06-05 20:00:00"),
    title: "Music Concert",
    location: "Petion-Ville",
    imageUrl: "assets/images/event3.jpg",
    isFree: false,
    attendeesCount: 200,
    category: "Music",
    ticketsAvailable: 300,
    ticketsSold: 200,
    revenue: 10000.0,
    description: "A live concert featuring top music artists.",
    reviews: [
      {"user": "Emma", "comment": "Fantastic concert!", "rating": 5.0},
      {"user": "Frank", "comment": "Great atmosphere.", "rating": 4.0},
    ],
  ),
];
