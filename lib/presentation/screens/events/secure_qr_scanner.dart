import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:convert';

class SecureQrScanner extends StatelessWidget {
  final String encryptedQrData; // Scanned encrypted QR data

  const SecureQrScanner({super.key, required this.encryptedQrData});

  @override
  Widget build(BuildContext context) {
    const secretKey = "mySuperSecretKey1234567890123456";
    bool isValid = decryptAndVerifyQrData(encryptedQrData, secretKey);

    return Scaffold(
      appBar: AppBar(title: Text("QR Code Scanner")),
      body: Center(
        child: Text(
          isValid
              ? "QR Code is valid!"
              : "QR Code is invalid or tampered with.",
          style: TextStyle(
              fontSize: 20, color: isValid ? Colors.green : Colors.red),
        ),
      ),
    );
  }
}

// Function to decrypt and verify the QR data
bool decryptAndVerifyQrData(String encryptedData, String secretKey) {
  final key = encrypt.Key.fromUtf8(secretKey);
  final iv = encrypt.IV.fromLength(16);
  final encrypter = encrypt.Encrypter(encrypt.AES(key));

  try {
    // Step 1: Decrypt the data
    final decrypted = encrypter.decrypt64(encryptedData, iv: iv);

    // Step 2: Separate ticket data from the signature
    var parts = decrypted.split("|signature=");
    if (parts.length != 2) return false;

    var ticketData = parts[0];
    var signature = parts[1];

    // Step 3: Recalculate the signature
    var bytes = utf8.encode(ticketData + secretKey);
    var recalculatedSignature = sha256.convert(bytes).toString();

    // Step 4: Compare the recalculated signature with the original one
    return recalculatedSignature == signature;
  } catch (e) {
    // If decryption or verification fails, return false
    return false;
  }
}
