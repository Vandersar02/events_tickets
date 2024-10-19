import 'package:flutter/material.dart';

class TicketsPage extends StatefulWidget {
  const TicketsPage({super.key});

  @override
  State<TicketsPage> createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Tickets'),
            ],
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Upcoming'),
              Tab(text: 'Completed'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            UpcomingTab(),
            CompletedTab(),
            CancelledTab(),
          ],
        ),
      ),
    );
  }
}

Widget eventCard({
  required String imageUrl,
  required String title,
  required String date,
  required String location,
  required String status,
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
            child: Image.asset(
              imageUrl,
              height: 70,
              width: 70,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  date,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 5),
                Text(
                  location,
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
                  color: status == 'Cancelled' ? Colors.red : Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: onPressed,
                child: Text(buttonText),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class UpcomingTab extends StatelessWidget {
  const UpcomingTab({
    super.key,
    this.events = const [],
  });
  final List<dynamic> events; // Empty list to simulate no tickets

  @override
  Widget build(BuildContext context) {
    return
        // events.isEmpty
        //     ? const EmptyTicketsView() // Show empty tickets view when no events
        //     :

        ListView(
      padding: const EdgeInsets.all(15),
      children: [
        eventCard(
          imageUrl: 'assets/images/event2.jpg',
          title: 'National Music Festival',
          date: 'Mon, Dec 24 • 18:00 - 23:00 PM',
          location: 'Grand Park, New York',
          status: 'Paid',
          buttonText: 'View E-Ticket',
          onPressed: () {},
        ),
        eventCard(
          imageUrl: 'assets/images/event2.jpg',
          title: 'Art & Mural Workshop',
          date: 'Wed, Dec 27 • 14:00 - 16:00 PM',
          location: 'Central Art, Washington',
          status: 'Paid',
          buttonText: 'View E-Ticket',
          onPressed: () {},
        ),
      ],
    );
  }
}

class CompletedTab extends StatelessWidget {
  const CompletedTab({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(15),
      children: [
        eventCard(
          imageUrl: 'assets/images/event2.jpg',
          title: 'Art & Painting Training',
          date: 'Wed, Dec 26 • 18:00 - 21:00 PM',
          location: 'Central Art, Washington',
          status: 'Completed',
          buttonText: 'View E-Ticket',
          onPressed: () {},
        ),
        eventCard(
          imageUrl: 'assets/images/event2.jpg',
          title: 'DJ & Music Concert',
          date: 'Tue, Dec 30 • 19:00 - 22:00 PM',
          location: 'New Avenue, Los Angeles',
          status: 'Completed',
          buttonText: 'Leave a Review',
          onPressed: () {},
        ),
      ],
    );
  }
}

class CancelledTab extends StatelessWidget {
  const CancelledTab({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(15),
      children: [
        eventCard(
          imageUrl: 'assets/images/event2.jpg',
          title: 'Traditional Dance Festival',
          date: 'Tue, Dec 16 • 18:00 - 22:00 PM',
          location: 'New Avenue, Los Angeles',
          status: 'Cancelled',
          buttonText: 'View E-Ticket',
          onPressed: () {},
        ),
        eventCard(
          imageUrl: 'assets/images/event2.jpg',
          title: 'Painting Workshops',
          date: 'Sun, Dec 23 • 19:00 - 23:00 PM',
          location: 'Grand Park, Los Angeles',
          status: 'Cancelled',
          buttonText: 'View E-Ticket',
          onPressed: () {},
        ),
      ],
    );
  }
}

class EmptyTicketsView extends StatelessWidget {
  const EmptyTicketsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Image.asset(
            'assets/images/empty.jpg', // Make sure the image path is correct
            height: 200, // Set image size as needed
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Empty Tickets',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Looks like you don't have a ticket yet. Start searching for events now by clicking the button below.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/');
          },
          style: ElevatedButton.styleFrom(
            // primary: Colors.purple, // Customize the button color
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
          ),
          child: const Text(
            'Find Events',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
