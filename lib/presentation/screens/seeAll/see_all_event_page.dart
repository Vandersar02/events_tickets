import 'package:events_ticket/data/models/event_model.dart';
import 'package:events_ticket/presentation/screens/home/components/event_card.dart';
import 'package:flutter/material.dart';

class SeeAllEventsPage extends StatelessWidget {
  final List<EventModel> events;
  final String title;

  const SeeAllEventsPage(
      {super.key, required this.events, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF515DFF),
        title: Text(title),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: GridView.builder(
            itemCount: events.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 0.65,
              mainAxisSpacing: 10,
              crossAxisSpacing: 5,
            ),
            itemBuilder: (context, index) {
              final event = events[index];
              return EventCard(
                event: event,
                isFree: title == 'Free Events',
              );
            },
          ),
        ),
      ),
    );
  }
}
