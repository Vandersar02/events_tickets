import 'package:events_ticket/data/models/ticket_model.dart';
import 'package:flutter/material.dart';

Widget ticketEventCard({
  required TicketModel ticket,
  required String buttonText,
  required VoidCallback onPressed,
}) {
  return Card(
    elevation: 4,
    margin: const EdgeInsets.symmetric(vertical: 10),
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              ticket.ticketTypeId.eventId!.coverImg!,
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // TODO: Have to check for the TITLE  event
                  ticket.ticketTypeId.eventId!.title.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  // TODO: Have to check for the DATE  event
                  ticket.ticketTypeId.eventId!.startAt.toString(),
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 5),
                Text(
                  // TODO: Have to check for the LOCATION  event
                  ticket.ticketTypeId.eventId!.address.toString(),
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: ticket.state == 'cancelled'
                      ? Colors.red
                      : ticket.state == 'pending'
                          ? Colors.orange
                          : Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  ticket.state[0].toUpperCase() +
                      ticket.state.substring(1).toLowerCase(),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                ),
                child: Text(buttonText, style: const TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
