import 'package:events_ticket/data/models/event_model.dart';
import 'package:events_ticket/presentation/screens/home/components/validate_booking_event.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventDetailsPage extends StatelessWidget {
  final EventModel? event;

  const EventDetailsPage({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    // Formatting dates
    final startDateFormatted =
        DateFormat('EEE, MMM d, yyyy h:mm a').format(event!.startAt);
    final endDateFormatted =
        DateFormat('EEE, MMM d, yyyy h:mm a').format(event!.endAt);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Event Details"),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                event!.coverImg ?? "https://via.placeholder.com/150",
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            // Event Title
            Text(
              event!.title.toString(),
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),

            // Event Type (Category) Chip
            if (event!.eventTypeFromDB != null)
              Chip(
                label: Text(event!.eventTypeFromDB!.title.toString()),
                backgroundColor: Colors.deepPurple[50],
                labelStyle: TextStyle(color: Colors.deepPurple[700]),
              ),
            const SizedBox(height: 16),

            // Event Date Range
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.calendar_today, color: Colors.deepPurple),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Starts: $startDateFormatted\nEnds: $endDateFormatted',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Event Location
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on, color: Colors.deepPurple),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    event!.address ?? "Location not specified",
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // About the Event
            const Text(
              "About Event",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              event!.about ??
                  "No additional details are available for this event.",
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(height: 16),
            // Organizer Info
            Row(
              children: [
                const Icon(Icons.person, color: Colors.deepPurple),
                const SizedBox(width: 8),
                Text(
                  "Organized by: ${event!.organizerIdFromDB!.name}",
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 60),

            // Ticket Purchase Button
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ValidateBookingEventScreen(
                      event: event,
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      event!.isAvailable ? Colors.deepPurple : Colors.grey,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: Text(
                  event!.isAvailable ? "Book Now" : "Unavailable",
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
