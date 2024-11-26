import 'package:events_ticket/data/models/event_model.dart';
import 'package:flutter/material.dart';

class EventDashboardPage extends StatelessWidget {
  final EventModel event; // Use Event as the type

  const EventDashboardPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final dateFormatted =
        "${event.createdAt.day}/${event.createdAt.month}/${event.createdAt.year}";

    return Scaffold(
      appBar: AppBar(
        title: Text(event.title.toString()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Event Image, Name, and Date
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                event.coverImg.toString(),
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              event.title.toString(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              "$dateFormatted • ${event.address}",
              style: const TextStyle(color: Colors.grey),
            ),
            const Divider(height: 32),

            // Metrics Section
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MetricWidget(label: 'Tickets Sold', value: "30"),
                MetricWidget(label: 'Tickets Available', value: "30"),
                MetricWidget(label: 'Revenue', value: "30"),
              ],
            ),
            const Divider(height: 32),

            // Category and Event Summary
            Text(
              'Category: ${event.eventTypeFromDB!.title}',
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 10),
            Text(
              "Event Summary",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor),
            ),
            const SizedBox(height: 6),
            Text(
              event.about ?? "No description available.",
              style: const TextStyle(color: Colors.black87),
            ),
            const Divider(height: 32),
          ],
        ),
      ),
    );
  }
}

// Widget for displaying individual metrics
class MetricWidget extends StatelessWidget {
  final String label;
  final String value;

  const MetricWidget({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
