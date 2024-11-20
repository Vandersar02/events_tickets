import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:events_ticket/core/services/payment/mon_cash_services.dart';
import 'package:events_ticket/data/models/event_model.dart';

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
    // final createdAtFormatted = DateFormat('EEE, MMM d, yyyy').format(event.createdAt);

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
              child: Image.asset(
                event!.coverImg ?? "https://via.placeholder.com/150",
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            // Event Title
            Text(
              event!.title,
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),

            // Event Type (Category) Chip
            if (event!.eventType != null)
              Chip(
                label: Text(event!.eventType!),
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

            // Event Availability
            Text(
              event!.isAvailable
                  ? "This event is currently available for registration."
                  : "This event is no longer available.",
              style: TextStyle(
                color: event!.isAvailable ? Colors.green : Colors.redAccent,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),

            // Organizer Info
            Row(
              children: [
                const Icon(Icons.person, color: Colors.deepPurple),
                const SizedBox(width: 8),
                Text(
                  "Organized by: ${event!.organizerId}",
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Ticket Purchase Button
            Center(
              child: ElevatedButton(
                onPressed: event!.isAvailable
                    ? () async {
                        // Payment Logic with MonCash
                        final accessToken = await getAccessToken();
                        if (accessToken != null) {
                          // Assume ticket price is dynamic or fixed, for now $100
                          await initiatePayment(
                              "336216631", "50936973307", 100.0);
                          await confirmPayment(
                              "336216631", "50936973307", 100.0);
                          await checkPaymentStatus(reference: "336216631");
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Failed to retrieve access token'),
                            ),
                          );
                        }
                      }
                    : null, // Disable button if not available
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
                  event!.isAvailable ? "Register Now" : "Unavailable",
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
