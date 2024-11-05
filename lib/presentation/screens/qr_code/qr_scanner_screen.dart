import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:convert';

const secretKey = "mySuperSecretKey1234567890123456";

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  QRScannerScreenState createState() => QRScannerScreenState();
}

class QRScannerScreenState extends State<QRScannerScreen> {
  MobileScannerController controller = MobileScannerController();
  String? qrCodeData;
  bool isValid = false;
  bool isScanning = true;

  @override
  void initState() {
    super.initState();
    controller.start();
    controller.barcodes.listen((barcodeCapture) {
      final barcode = barcodeCapture.barcodes.first;
      setState(() {
        qrCodeData = decryptAndVerifyQrDataReal(barcode.rawValue, secretKey);
        isValid = qrCodeData != null;
        isScanning = false; // Stop scanning after receiving a QR code
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Scanner le QR Code')),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Stack(
              children: [
                MobileScanner(controller: controller),
                Center(
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white54, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Alignez le QR Code ici",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 50.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: [
                if (qrCodeData != null)
                  Text(
                    isValid
                        ? '$qrCodeData'
                        : "Le QR Code est invalide ou a été altéré.",
                    style: TextStyle(
                        fontSize: 18,
                        color: isValid ? Colors.green : Colors.red),
                  ),
                if (isScanning) const CircularProgressIndicator(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: isValid
                          ? () {
                              // Action Check-in
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Check-in effectué!')),
                              );
                            }
                          : null,
                      child: const Text("Check-in"),
                    ),
                    ElevatedButton(
                      onPressed: isValid
                          ? () {
                              // Action Check-out
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Check-out effectué!')),
                              );
                            }
                          : null,
                      child: const Text("Check-out"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Rescan button
                        setState(() {
                          qrCodeData = null;
                          isValid = false;
                          isScanning = true;
                        });
                        controller.start();
                      },
                      child: const Text("Rescanner"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

// Function to decrypt and verify the signed data
String? decryptAndVerifyQrDataReal(String? encryptedData, String secretKey) {
  try {
    // Step 1: Extract IV and encrypted data
    final ivData = encryptedData!
        .substring(0, 24); // Assume que l'IV fait 16 octets encodés en base64
    final encryptedDataWithoutIv =
        encryptedData.substring(24); // Le reste est le message chiffré

    final iv = encrypt.IV.fromBase64(ivData);
    final key = encrypt.Key.fromUtf8(secretKey);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    // Step 2: Decrypt the data
    final decrypted = encrypter.decrypt64(encryptedDataWithoutIv, iv: iv);

    // Step 3: Separate ticketData and signature
    final parts = decrypted.split("|signature=");
    if (parts.length != 2) {
      return null; // Invalid data format
    }
    final ticketData = parts[0];
    final providedSignature = parts[1];

    // Step 4: Recalculate and verify the signature
    var bytes =
        utf8.encode(ticketData + secretKey); // Combine data and secret key
    var recalculatedSignature =
        sha256.convert(bytes).toString(); // Generate SHA-256 hash

    if (providedSignature == recalculatedSignature) {
      return ticketData; // Data is valid
    } else {
      return null; // Signature mismatch, data might be corrupted or tampered with
    }
  } catch (e) {
    print("Decryption or verification failed: $e");
    return null;
  }
}
