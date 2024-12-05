import 'dart:io';
import 'package:events_ticket/core/services/auth/users_manager.dart';
import 'package:events_ticket/core/services/events/events_services.dart';
import 'package:events_ticket/core/services/preferences/preferences_services.dart';
import 'package:events_ticket/data/models/event_model.dart';
import 'package:events_ticket/data/models/preference_model.dart';
import 'package:events_ticket/data/models/ticket_types_model.dart';
import 'package:events_ticket/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  // Controllers for each field
  final TextEditingController titleController = TextEditingController();
  final TextEditingController eventTypeController = TextEditingController();
  // final TextEditingController locationController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final TextEditingController vipPriceController = TextEditingController();
  final TextEditingController economyPriceController = TextEditingController();

  // Organizer
  final userId = SessionManager().getPreference("user_id").toString();

  DateTime? startDate;
  DateTime? endDate;
  DateTime? ticketDeadline;

  // Ticket list
  final List<Map<String, dynamic>> tickets = [];

  // Method to add a ticket
  void _addTicket() {
    setState(() {
      tickets.add({
        'type': '',
        'price': 0.0,
        'nAvailable': 0,
        'currency': 'USD', // Default currency
      });
    });
  }

  // Method to remove a ticket
  void _removeTicket(int index) {
    setState(() {
      tickets.removeAt(index);
    });
  }

  // Placeholder method for saving to database
  Future<void> _saveEventToDatabase() async {
    try {
      // Validate ticket entries
      if (tickets.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one ticket!')),
        );
        return;
      }

      // Convert tickets to TicketType objects
      final ticketTypes = tickets.map((ticket) {
        return TicketTypesModel(
          id: '', // Generated later
          eventId: EventModel(
              title: "",
              startAt: DateTime.now(),
              endAt: DateTime.now()), // Generated later
          type: ticket['type'],
          price: ticket['price'],
          nAvailable: ticket['nAvailable'],
          nSold: 0, // Default value
          currency: ticket['currency'],
        );
      }).toList();

      // Get event type ID
      final preferenceId = await PreferencesServices()
          .getPreferenceByTitle(eventTypeController.text);
      final id = preferenceId!.id;

      // Create the event object
      final EventModel eventData = EventModel(
        eventTypeFromDB: PreferencesModel(id: id),
        coverImg: _selectedImage?.path,
        address: addressController.text,
        about: aboutController.text,
        organizerIdFromDB: UserModel(userId: userId),
        isAvailable: true,
        title: titleController.text,
        deadline: ticketDeadline,
        startAt: startDate!,
        endAt: endDate!,
        ticketTypes: ticketTypes,
      );

      // Save the event
      await EventsServices().createEvent(eventData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event created successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create event: $e')),
      );
    }
  }

  // Dropdown Options
  final List<String> payoutMethods = ["virtual", "cash", "card"];
  String? selectedPayoutMethod;

  // Image picker variables
  File? _selectedImage;

  // Method to pick an image
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Date picker
// Date picker with validation
  Future<void> _pickDate(BuildContext context, bool isStartDate) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          // Ensure start date is not after end date
          if (endDate != null && pickedDate.isAfter(endDate!)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Start date cannot be after end date!'),
              ),
            );
          } else {
            startDate = pickedDate;
          }
        } else {
          // Ensure end date is not before start date
          if (startDate != null && pickedDate.isBefore(startDate!)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('End date cannot be before start date!'),
              ),
            );
          } else {
            endDate = pickedDate;
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Create New Event'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Picker Section
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: _selectedImage != null
                    ? Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: FileImage(_selectedImage!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey.shade300,
                        ),
                        child: const Center(
                          child: Icon(Icons.camera_alt,
                              size: 40, color: Colors.black54),
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 16),

            // Event Details Section
            const Text('Event Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            _buildTextFields(controller: titleController, label: "Event Name"),
            _buildTextFields(
                controller: eventTypeController, label: "Event Type"),
            // _buildTextFields(
            //   controller: locationController,
            //   label: "Add Location",
            //   hintText: "e.g., City, Venue",
            // ),
            _buildTextFields(
              controller: addressController,
              label: "Add Location Details",
              hintText: "e.g., Full Address",
            ),

            const SizedBox(height: 12),
            _buildTextFields(
              controller: aboutController,
              label: "About Event",
              isMultiLine: true,
            ),
            _buildDropdownField(
              label: "Payout Method",
              value: selectedPayoutMethod,
              items: payoutMethods,
              onChanged: (value) =>
                  setState(() => selectedPayoutMethod = value),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildDateButton(
                    label: "Start Date",
                    date: startDate,
                    onTap: () => _pickDate(context, true),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildDateButton(
                    label: "End Date",
                    date: endDate,
                    onTap: () => _pickDate(context, false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            const Text('Tickets',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // List of tickets
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                final ticket = tickets[index];
                return _buildTicketFields(ticket, index);
              },
            ),

            // Add ticket button
            TextButton.icon(
              onPressed: _addTicket,
              icon: const Icon(Icons.add),
              label: const Text("Add Ticket"),
            ),

            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  backgroundColor: Colors.blue.shade300,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: _saveEventToDatabase,
                child: const Text("Create New Event & Publish",
                    style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketFields(Map<String, dynamic> ticket, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              label: "Ticket Type",
              hintText: "e.g., VIP, Economy",
              onChanged: (value) => ticket['type'] = value,
            ),
            _buildTextField(
              label: "Price",
              hintText: "e.g., 50.0",
              inputType: TextInputType.number,
              onChanged: (value) =>
                  ticket['price'] = double.tryParse(value) ?? 0.0,
            ),
            _buildTextField(
              label: "Number Available",
              hintText: "e.g., 100",
              inputType: TextInputType.number,
              onChanged: (value) =>
                  ticket['nAvailable'] = int.tryParse(value) ?? 0,
            ),
            _buildTextField(
              label: "Currency",
              hintText: "e.g., USD",
              onChanged: (value) => ticket['currency'] = value,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _removeTicket(index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    String? hintText,
    TextInputType inputType = TextInputType.text,
    required ValueChanged<String> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        keyboardType: inputType,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFields({
    required TextEditingController controller,
    required String label,
    String? hintText,
    TextInputType inputType = TextInputType.text,
    bool isMultiLine = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        maxLines: isMultiLine ? 4 : 1,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                ))
            .toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildDateButton({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return OutlinedButton(
      onPressed: onTap,
      child:
          Text(date != null ? "${date.day}/${date.month}/${date.year}" : label),
    );
  }
}

void _showPaymentDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Paiement"),
      content: const Text(
        "Votre event a été créé avec succès !",
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
            Navigator.pop(context);
          },
          child: const Text("Confirmer"),
        ),
      ],
    ),
  );
}
