import 'package:events_ticket/data/models/event_model.dart';
import 'package:events_ticket/presentation/screens/home/components/events_details_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.event,
    this.iconSrc = "assets/icons/calendar.svg",
    this.isFree = false,
    this.attendeesCount = 100,
  });

  final String iconSrc;
  final EventModel? event;
  final bool isFree;
  final int attendeesCount;

  @override
  Widget build(BuildContext context) {
    final dateFormatted =
        DateFormat('EEE, MMM d, yyyy').format(event!.createdAt);

    return GestureDetector(
      onTap: () {
        print(event!.id);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailsPage(event: event),
          ),
        );
      },
      child: Container(
        width: 280,
        decoration: BoxDecoration(
          color: const Color(0xFF515DFF),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image de l'événement
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Stack(
                children: [
                  // L'image en arrière-plan
                  Image.network(
                    event!.coverImg.toString(),
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),

                  // Badge "Free" en haut à gauche
                  if (isFree)
                    Positioned(
                      top: 8, // Position en haut
                      right: 8, // Position à gauche
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Free',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre de l'événement
                  Text(
                    event!.title.toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  // Date de l'événement
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: Colors.white70,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        dateFormatted,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Adresse
                      Text(
                        event!.address.toString(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (attendeesCount > 0)
                        // Étiquettes supplémentaires : Gratuit + Nombre de participants
                        Text(
                          '$attendeesCount Going',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
