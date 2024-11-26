import 'package:events_ticket/data/models/event_model.dart';
import 'package:events_ticket/presentation/screens/events/create_events_screen.dart';
import 'package:events_ticket/presentation/screens/events/event_dashboard.dart';
import 'package:events_ticket/presentation/screens/qr_code/qr_scanner_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventManagementPage extends StatefulWidget {
  final List<EventModel> events; // List of events provided by the user

  const EventManagementPage({super.key, required this.events});

  @override
  State<EventManagementPage> createState() => _EventManagementPageState();
}

class _EventManagementPageState extends State<EventManagementPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<EventModel> upcomingEvents;
  late List<EventModel> pastEvents;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Filter events into upcoming and past categories based on the current date
    DateTime now = DateTime.now();
    upcomingEvents =
        widget.events.where((event) => event.createdAt.isAfter(now)).toList();
    pastEvents =
        widget.events.where((event) => event.createdAt.isBefore(now)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organizer Portal'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Upcoming (${upcomingEvents.length})'),
            Tab(text: 'Past Events (${pastEvents.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          EventListView(events: upcomingEvents, isUpcoming: true),
          EventListView(events: pastEvents, isUpcoming: false),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateEventScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class EventListView extends StatelessWidget {
  final List<EventModel> events;
  final bool isUpcoming;

  const EventListView(
      {super.key, required this.events, required this.isUpcoming});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return EventCard(
          event: event,
          isUpcoming: isUpcoming,
        );
      },
    );
  }
}

class EventCard extends StatelessWidget {
  final EventModel event;
  final bool isUpcoming;

  const EventCard({super.key, required this.event, required this.isUpcoming});

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat('EEE, MMM d, yyyy').format(event.createdAt);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(event.coverImg.toString(),
                      height: 150, width: double.infinity, fit: BoxFit.cover),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      formattedDate, // Displaying the formatted date
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              event.title.toString(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Chip(
                  label: Text(
                    event.eventTypeFromDB!.title.toString(),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                const SizedBox(width: 8),
                // Text(
                //   '${event.attendeesCount} people going', // Displaying attendeesCount correctly
                //   style: const TextStyle(color: Colors.grey),
                // ),
                const Spacer(),
                const Icon(Icons.bookmark_border),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  event.address.toString(),
                  style: const TextStyle(color: Colors.blueGrey),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDashboardPage(
                          event: event,
                        ),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    side: const BorderSide(color: Colors.blueAccent),
                  ),
                  child: const Text('See Reviews'),
                ),
                IconButton(
                  icon: Icon(
                    Icons.qr_code,
                    color: isUpcoming ? Colors.blueAccent : Colors.grey,
                  ),
                  onPressed: isUpcoming
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    QRScannerScreen(event: event)),
                          );
                        }
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
