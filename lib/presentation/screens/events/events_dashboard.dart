import 'package:flutter/material.dart';

class EventDashboardPage extends StatelessWidget {
  // Exemples de données d'événement (normalement elles proviendraient d'une base de données)
  final List<Map<String, dynamic>> events = [
    {
      'name': 'Festival de Musique',
      'location': 'Delmas 75',
      'date': DateTime(2024, 10, 10),
      'ticketsAvailable': 100,
      'ticketsSold': 50,
    },
    {
      'name': 'Atelier d\'art',
      'location': 'Petion-Ville',
      'date': DateTime(2024, 11, 05),
      'ticketsAvailable': 50,
      'ticketsSold': 20,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tableau de bord des événements"),
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return ListTile(
            title: Text(event['name']),
            subtitle: Text("${event['location']} - ${event['date']}"),
            trailing: Text(
              "${event['ticketsSold']}/${event['ticketsAvailable']} tickets vendus",
            ),
          );
        },
      ),
    );
  }
}
