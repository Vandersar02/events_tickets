import 'package:events_ticket/core/services/tickets/tickets_services.dart';
import 'package:events_ticket/data/models/event_model.dart';
import 'package:events_ticket/data/models/ticket_model.dart';
// import 'package:events_ticket/data/models/ticket_types_model.dart';
import 'package:events_ticket/presentation/screens/tickets/components/tickets_tab.dart';
import 'package:flutter/material.dart';

class TicketsPage extends StatefulWidget {
  const TicketsPage({super.key});

  @override
  State<TicketsPage> createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  // Exemple de liste de tickets dynamique
  final List<TicketModel> tickets = [];

  @override
  void initState() {
    super.initState();
    fetchTickets();
  }

  void fetchTickets() async {
    final response = await TicketsServices().getUserTickets(userId);
    setState(() {
      tickets.clear();
      tickets.addAll(response);
    });
  }

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
