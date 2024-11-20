import 'package:events_ticket/data/models/ticket_model.dart';
import 'package:events_ticket/presentation/screens/qr_code/ticket_qr_code_page.dart';
import 'package:events_ticket/presentation/screens/tickets/components/empty_tickets_view.dart';
import 'package:events_ticket/presentation/screens/tickets/components/ticket_event_card.dart';
import 'package:flutter/material.dart';

class TicketsTab extends StatelessWidget {
  const TicketsTab({super.key, required this.tickets});

  final List<TicketModel> tickets;

  @override
  Widget build(BuildContext context) {
    if (tickets.isEmpty) {
      return const EmptyTicketsView();
    }
    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        final ticket = tickets[index];
        return ticketEventCard(
          ticket: ticket,
          buttonText: "View E-Ticket",
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TicketQRCodePage(),
              ),
            );
          },
        );
      },
    );
  }
}
