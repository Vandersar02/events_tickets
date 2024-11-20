import 'package:events_ticket/data/models/ticket_model.dart';
import 'package:events_ticket/presentation/screens/tickets/components/tickets_tab.dart';
import 'package:flutter/material.dart';

class TicketsPage extends StatefulWidget {
  const TicketsPage({super.key});

  @override
  State<TicketsPage> createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  // Exemple de liste de tickets dynamique
  final List<TicketModel> tickets = [
    TicketModel(
      id: "3129bdkjpw8sboiusn8nnklsoi2ps74",
      ticketTypeId: "Pol Party",
      orderId: "Sun 11/24/2024",
      state: "pending",
      paymentMethod: "Virtual",
      createdAt: DateTime.now(),
    ),
    TicketModel(
      id: "3129bdkjpw8sboiusn8nnklsoi2ps74",
      ticketTypeId: "Pol Party",
      orderId: "Pol Party",
      state: "completed",
      paymentMethod: "Virtual",
      createdAt: DateTime.now(),
    ),
    TicketModel(
      id: "3129bdkjpw8sboiusn8nnklsoi2ps74",
      ticketTypeId: "Pol Party",
      orderId: "Pol Party",
      state: "cancelled",
      paymentMethod: "Virtual",
      createdAt: DateTime.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFF7553F6),
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Tickets',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          bottom: const TabBar(
            labelStyle: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Completed'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TicketsTab(
              tickets:
                  tickets.where((ticket) => ticket.state == 'pending').toList(),
            ),
            TicketsTab(
              tickets: tickets
                  .where((ticket) => ticket.state == 'completed')
                  .toList(),
            ),
            TicketsTab(
              tickets: tickets
                  .where((ticket) => ticket.state == 'cancelled')
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
