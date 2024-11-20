import 'package:flutter/material.dart';

class EmptyTicketsView extends StatelessWidget {
  const EmptyTicketsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.event_busy, size: 100, color: Colors.grey),
          const SizedBox(height: 20),
          const Text(
            'No Tickets Found',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Browse and purchase tickets to see them here.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/');
            },
            child: const Text('Browse Events'),
          ),
        ],
      ),
    );
  }
}
