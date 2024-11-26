import 'package:events_ticket/core/services/tickets/tickets_type_services.dart';
import 'package:events_ticket/data/models/event_model.dart';
import 'package:events_ticket/data/models/ticket_types_model.dart';
import 'package:flutter/material.dart';
// import 'package:events_ticket/core/services/payment/mon_cash_services.dart';

class ValidateBookingEventScreen extends StatefulWidget {
  const ValidateBookingEventScreen({super.key, required this.event});
  final EventModel? event;

  @override
  State<ValidateBookingEventScreen> createState() =>
      _ValidateBookingEventScreenState();
}

class _ValidateBookingEventScreenState
    extends State<ValidateBookingEventScreen> {
  EventModel? event;
  String selectedTicketType = 'Standard'; // Ticket type selection
  int ticketQuantity = 1; // Default ticket quantity
  bool isPaidEvent = false;
  double? ticketPrice, totalPrice;

  // Ticket options
  List<TicketTypesModel>? ticketTypes;

  void _updateTotalPrice() {
    setState(() {
      if (ticketPrice != null) {
        totalPrice = ticketPrice! * ticketQuantity;
      } else {
        totalPrice = 0.0;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Appelle la méthode pour charger les tickets
    _loadTicketTypes();
  }

  Future<void> _loadTicketTypes() async {
    if (widget.event != null) {
      try {
        final fetchedTickets = await TicketsTypeServices()
            .getEventTicketTypes(widget.event!.id.toString());
        setState(() {
          print("Fetched tickets: $fetchedTickets");
          ticketTypes = fetchedTickets;
          if (ticketTypes != null && ticketTypes!.isNotEmpty) {
            ticketPrice = ticketTypes!.first.price;
            isPaidEvent = ticketTypes!.any((ticket) => ticket.price > 0.0);
            selectedTicketType =
                "${ticketTypes!.first.type}-${ticketTypes!.first.price}";
            _updateTotalPrice();
          } else {
            isPaidEvent = false;
            ticketPrice = 0.0;
            totalPrice = 0.0;
          }
          event = widget.event;
        });
      } catch (e) {
        print("Erreur lors du chargement des types de tickets : $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF515DFF),
        title: const Text('Réserver l\' événement'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: _buildTicketsDetails(),
      ),
    );
  }

  Widget _buildTicketsDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Event details section
        _buildEventDetails(),

        const SizedBox(height: 20),

        // Ticket selection
        const Text(
          "Sélectionnez votre type de ticket :",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownButton<String>(
          value: ticketTypes != null && ticketTypes!.isNotEmpty
              ? selectedTicketType
              : null,
          items: ticketTypes != null
              ? ticketTypes!.map((ticket) {
                  final uniqueValue = "${ticket.type}-${ticket.price}";
                  return DropdownMenuItem<String>(
                    value: uniqueValue,
                    child: Text(
                        "${ticket.type} - ${ticket.price.toStringAsFixed(2)} ${ticket.currency}"),
                  );
                }).toList()
              : [],
          onChanged: (value) {
            if (value != null) {
              setState(() {
                selectedTicketType = value;
                ticketPrice = ticketTypes!
                    .firstWhere((element) =>
                        "${element.type}-${element.price}" == value)
                    .price;
                _updateTotalPrice();
              });
            }
          },
        ),

        const SizedBox(height: 16),

        // Ticket quantity
        const Text(
          "Quantité de tickets :",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: ticketQuantity > 1
                  ? () {
                      setState(() {
                        ticketQuantity--;
                        _updateTotalPrice();
                      });
                    }
                  : null,
            ),
            Text(
              ticketQuantity.toString(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                setState(() {
                  ticketQuantity++;
                  _updateTotalPrice();
                });
              },
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Display price
        if (isPaidEvent)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Prix total :",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "${totalPrice!.toStringAsFixed(2)} ",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),

        const SizedBox(height: 30),

        // Payment button
        Center(
          child: ElevatedButton(
            onPressed: () {
              // Perform booking or payment logic
              if (isPaidEvent) {
                // Navigate to payment screen or show payment dialog
                _showPaymentDialog(context);
              } else {
                // Free event - directly confirm the booking
                _confirmBooking();
              }
            },
            child: Text(
                isPaidEvent ? "Procéder au paiement" : "Réserver gratuitement"),
          ),
        ),
      ],
    );
  }

  Widget _buildEventDetails() {
    if (event == null) {
      return const Text(
        "Les détails de l'événement ne sont pas disponibles.",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Détails de l'événement",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          "Nom de l'événement : ${event!.title}",
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 4),
        Text(
          "Date : ${event!.startAt}",
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 4),
        Text(
          "Lieu : ${event!.address ?? 'Non spécifié'}",
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 4),
        Text(
          "Description : ${event!.about ?? 'Pas de description disponible.'}",
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  void _showPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Paiement"),
        content: const Text(
          "Souhaitez-vous confirmer votre paiement et réserver vos tickets ?",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: const Text("Annuler"),
          ),
          TextButton(
            onPressed: () {
              // ? () async {
              //     // Payment Logic with MonCash
              //     final accessToken = await getAccessToken();
              //     letsTry();
              //     if (accessToken != null) {
              //       // Assume ticket price is dynamic or fixed, for now $100
              //       await initiatePayment(
              //           "336216631", "50936973307", 100.0);
              //       await confirmPayment(
              //           "336216631", "50936973307", 100.0);
              //       await checkPaymentStatus(reference: "336216631");
              //     } else {
              //       ScaffoldMessenger.of(context).showSnackBar(
              //         const SnackBar(
              //           content: Text('Failed to retrieve access token'),
              //         ),
              //       );
              //     }
              //   }
              // : null, // Disable button if not available

              Navigator.pop(context);
              _confirmBooking();
            },
            child: const Text("Confirmer"),
          ),
        ],
      ),
    );
  }

  void _confirmBooking() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Votre réservation a été confirmée avec succès !"),
        backgroundColor: Colors.green,
      ),
    );
  }
}
