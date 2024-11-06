import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:events_ticket/core/services/payment/mon_cash_services.dart';

class EventDetailsPage extends StatelessWidget {
  final String title, location, imageUrl;
  final DateTime date;
  final bool isFree;
  final int attendeesCount;

  const EventDetailsPage({
    super.key,
    required this.title,
    required this.date,
    required this.location,
    required this.imageUrl,
    required this.isFree,
    required this.attendeesCount,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormatted = DateFormat('EEE, MMM d, yyyy').format(date);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Event Details"),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Event Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(imageUrl),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Event Title
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),

            // Event Date and Location
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.deepPurple),
                const SizedBox(width: 8),
                Text(dateFormatted),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.deepPurple),
                const SizedBox(width: 8),
                Text(location),
              ],
            ),
            const SizedBox(height: 16),

            // About the Event
            const Text(
              "About Event",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
              style: TextStyle(color: Colors.grey[700]),
            ),

            const SizedBox(height: 16),

            // Buy Ticket Button
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final accessToken = await getAccessToken();
                  if (accessToken != null) {
                    // 1. Initier un paiement
                    await initiatePayment("336216631", "50938662809", 100.0);

                    // 2. Confirmer le paiement
                    await confirmPayment("336216631", "50938662809", 100.0);

                    // 3. Vérifier le statut du paiement
                    await checkPaymentStatus(reference: "336216631");
                  } else {
                    print('Failed to retrieve access token.');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text(
                  "Buy Ticket",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
