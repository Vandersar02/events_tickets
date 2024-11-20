import 'dart:io';

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
  final TextEditingController locationController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final TextEditingController vipPriceController = TextEditingController();
  final TextEditingController economyPriceController = TextEditingController();

  DateTime? startDate;
  DateTime? endDate;
  DateTime? ticketDeadline;

  // Dropdown Options
  final List<String> payoutMethods = ["Bank Transfer", "Mobile Payment"];
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

  // Placeholder method for saving to database
  Future<void> _saveEventToDatabase() async {
    // // Build an event object from the form fields
    // final Map<String, dynamic> eventData = {
    //   'title': titleController.text,
    //   'event_type': eventTypeController.text,
    //   'address': addressController.text,
    //   'about': aboutController.text,
    //   'start_at': startDate?.toIso8601String(),
    //   'end_at': endDate?.toIso8601String(),
    //   'deadline': ticketDeadline?.toIso8601String(),
    //   'vip_price': double.tryParse(vipPriceController.text),
    //   'economy_price': double.tryParse(economyPriceController.text),
    //   'payout_method': selectedPayoutMethod,
    //   'is_available': true,
    //   'organizer_id': "12345", // Replace with actual user/organizer ID
    //   'cover_img': _selectedImage?.path, // Add image path
    // };

    // Call save event function from database service
    try {
      // await saveEventToSupabase(eventData);
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

            _buildTextField(controller: titleController, label: "Event Name"),
            _buildTextField(
                controller: eventTypeController, label: "Event Type"),
            _buildTextField(
              controller: locationController,
              label: "Add Location",
              hintText: "e.g., City, Venue",
            ),
            _buildTextField(
              controller: addressController,
              label: "Add Location Details",
              hintText: "e.g., Full Address",
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
            _buildTextField(
              controller: aboutController,
              label: "About Event",
              isMultiLine: true,
            ),

            // Tickets and Payment Section
            const Text('Tickets and Payment',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildTextField(
                controller: vipPriceController,
                label: "Ticket Price for VIP",
                inputType: TextInputType.number),
            _buildTextField(
                controller: economyPriceController,
                label: "Ticket Price for Economy",
                inputType: TextInputType.number),
            _buildDropdownField(
              label: "Payout Method",
              value: selectedPayoutMethod,
              items: payoutMethods,
              onChanged: (value) =>
                  setState(() => selectedPayoutMethod = value),
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

  Widget _buildTextField({
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
