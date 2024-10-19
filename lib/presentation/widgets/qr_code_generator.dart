import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

// Secret Key for encryption (should be kept secret) 32 characters for AES-256
const secretKey = "mySuperSecretKey1234567890123456";

// Function to generate encrypted data with signature
String generateSignedAndEncryptedQrData(String ticketData, String secretKey) {
  // Step 1: Create a signature using SHA-256
  var bytes = utf8.encode(ticketData + secretKey);
  var signature = sha256.convert(bytes).toString(); // Generate SHA-256 hash

  // Step 2: Encrypt the data with AES
  final key = encrypt.Key.fromUtf8(secretKey);
  final iv = encrypt.IV.fromLength(16); // Initialization Vector for AES
  final encrypter = encrypt.Encrypter(encrypt.AES(key));

  // Combine ticketData with the signature
  final combinedData = ticketData + "|signature=" + signature;
  final encrypted = encrypter.encrypt(combinedData, iv: iv);

  return encrypted.base64; // Return the encrypted data in base64
}

class TicketQRCodePage extends StatelessWidget {
  const TicketQRCodePage({super.key});
  @override
  Widget build(BuildContext context) {
    // Example ticket data
    String ticketData = "event_id=12345|user_id=67890|ticket_id=abcd";

    // Generate the secure QR data
    String secureQrData =
        generateSignedAndEncryptedQrData(ticketData, secretKey);

    return Scaffold(
      appBar: AppBar(title: const Text("QR Code Generator")),
      body: Center(
        child: QrImageView(
          data: secureQrData,
          version: QrVersions.auto,
          size: 250.0,
        ),
      ),
    );
  }
}
