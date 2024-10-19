// class EventData {
//   final String name;
//   final String location;
//   final DateTime date;
//   final int ticketsAvailable;
//   final int ticketsSold;

//   EventData({
//     required this.name,
//     required this.location,
//     required this.date,
//     required this.ticketsAvailable,
//     this.ticketsSold = 0,
//   });
// }

class Event {
  final DateTime date;
  final String title, location, imageUrl;
  final bool isFree;
  final int attendeesCount;
  final String category;

  Event({
    required this.date,
    required this.title,
    required this.location,
    required this.imageUrl,
    this.isFree = false,
    this.attendeesCount = 0,
    required this.category,
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
  ),
  Event(
    date: DateTime.parse("2023-06-03 22:00:00"),
    title: "Art Workshop",
    location: "Catalpa 8A, Delmas 75",
    imageUrl: "assets/images/event2.jpg",
    isFree: true,
    attendeesCount: 50,
    category: "Art",
  ),
  Event(
    date: DateTime.parse("2023-06-05 20:00:00"),
    title: "Music Concert",
    location: "Petion-Ville",
    imageUrl: "assets/images/event3.jpg",
    attendeesCount: 200,
    isFree: false,
    category: "Music",
  ),
];

final List<Event> popularEvents = [
  events[0],
  events[1],
  Event(
    date: DateTime.parse("2023-06-06 18:00:00"),
    title: "Art Exhibit",
    location: "Petion-Ville Art Gallery",
    imageUrl: "assets/images/event2.jpg",
    isFree: true,
    attendeesCount: 300,
    category: "Art",
  ),
  Event(
    date: DateTime.parse("2023-06-07 21:00:00"),
    title: "Jazz Night",
    location: "Delmas Jazz Club",
    imageUrl: "assets/images/event1.jpg",
    isFree: false,
    attendeesCount: 120,
    category: "Music",
  ),
];
