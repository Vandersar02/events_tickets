import 'package:events_ticket/core/utils/encryption_utils.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:image_picker/image_picker.dart';
// import 'dart:io';

// Secret Key for encryption (should be kept secret) 32 characters for AES-256
const secretKey = "mySuperSecretKey1234567890123456";

class TicketQRCodePage extends StatelessWidget {
  const TicketQRCodePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Example ticket data
    String qrCodeData = "event_id=12345|user_id=67890|ticket_type_id=abcd";

    // Generate the secure QR data
    String secureQrData =
        EncryptionUtils.generateSignedAndEncryptedQrData(qrCodeData, secretKey);

    // Function to pick image or video
    Future<void> pickMedia(BuildContext context) async {
      final picker = ImagePicker();

      // Show options to the user
      final selectedOption = await showModalBottomSheet<String>(
        context: context,
        builder: (BuildContext ctx) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Pick Image from Gallery'),
                  onTap: () => Navigator.pop(ctx, 'gallery_image'),
                ),
                ListTile(
                  leading: const Icon(Icons.video_library),
                  title: const Text('Pick Video from Gallery'),
                  onTap: () => Navigator.pop(ctx, 'gallery_video'),
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Take a Photo'),
                  onTap: () => Navigator.pop(ctx, 'camera_photo'),
                ),
                ListTile(
                  leading: const Icon(Icons.videocam),
                  title: const Text('Record a Video'),
                  onTap: () => Navigator.pop(ctx, 'camera_video'),
                ),
              ],
            ),
          );
        },
      );

      if (selectedOption == null) return;

      XFile? file;

      // Handle the user's choice
      switch (selectedOption) {
        case 'gallery_image':
          file = await picker.pickImage(source: ImageSource.gallery);
          break;
        case 'gallery_video':
          file = await picker.pickVideo(source: ImageSource.gallery);
          break;
        case 'camera_photo':
          file = await picker.pickImage(source: ImageSource.camera);
          break;
        case 'camera_video':
          file = await picker.pickVideo(source: ImageSource.camera);
          break;
      }

      if (file != null) {
        // Do something with the selected file
        print('File selected: ${file.path}');
        // Example: Update state or upload file
      } else {
        print('No file selected.');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("E-Ticket"),
        centerTitle: true,
        // leading: const Icon(Icons.arrow_back),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: () {
              pickMedia(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // QR Code
              Center(
                child: QrImageView(
                  data: secureQrData,
                  version: QrVersions.auto,
                  size: 250.0,
                ),
              ),
              const SizedBox(height: 20.0),

              // Event details
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 6.0),
                elevation: 8,
                child: const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Event",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          Text("National Music Festival",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold))
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Time",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          Text("Monday, Dec 24 · 18.00 - 23.00 PM",
                              style: TextStyle(fontSize: 12))
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Location",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          Text("Grand Park, New York City, US",
                              style: TextStyle(fontSize: 12))
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Organizer",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          Text("World of Music", style: TextStyle(fontSize: 12))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20.0),

              // Ticket Information
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 4,
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("1 Seat (Economy)",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          Text("\$50.00", style: TextStyle(fontSize: 14))
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Price",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          Text("\$50.00", style: TextStyle(fontSize: 14))
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Tax",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          Text("\$5.00", style: TextStyle(fontSize: 14))
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          Text("\$55.00", style: TextStyle(fontSize: 14))
                        ],
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20.0),

              // Payment Information
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 4,
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Payment Methods",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          Text("Moncash", style: TextStyle(fontSize: 14))
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Order ID",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          Text("5457383979", style: TextStyle(fontSize: 14))
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Status",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          Text("Paid",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.green))
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20.0),

              // Download Ticket Button
              ElevatedButton(
                onPressed: () {
                  // Action to download the ticket
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Download Ticket",
                    style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
