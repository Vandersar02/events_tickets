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
  @override
  void initState() {
    super.initState();
    controller.start();
    controller.barcodes.listen((barcodeCapture) {
      final barcode = barcodeCapture.barcodes.first;
      setState(() {
        qrCodeData = decryptAndVerifyQrDataReal(barcode.rawValue, secretKey);

        isValid =
            decryptAndVerifyQrDataReal(barcode.rawValue, secretKey) == null
                ? false
                : true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Scanner le QR Code')),
        // actions: [
        //   IconButton(
        //     icon: Icon(
        //       controller.value.torchEnabled ? Icons.flash_on : Icons.flash_off,
        //       color: controller.value.torchEnabled ? Colors.yellow : Colors.grey,
        //     ),
        //     onPressed: () => controller.toggleTorch(),
        //   ),
        //   IconButton(
        //     icon: Icon(
        //       controller.value.cameraFacing == CameraFacing.front
        //           ? Icons.camera_front
        //           : Icons.camera_rear,
        //     ),
        //     onPressed: () => controller.switchCamera(),
        //   ),
        // ],
      ),
      body: Column(
        children: [
          // Partie Scanner
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
          // Espace en bas
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
                        ? '$qrCodeData data is valid.'
                        : "QR Code is invalid or tampered with.",
                    style: TextStyle(
                        fontSize: 18,
                        color: isValid ? Colors.green : Colors.red),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Action Check-in
                      },
                      child: const Text("Check-in"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Action Check-out
                      },
                      child: const Text("Check-out"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Rescan button
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

// Function to decrypt and verify the QR data
bool decryptAndVerifyQrData(String? encryptedData, String secretKey) {
  final key = encrypt.Key.fromUtf8(secretKey);
  final iv = encrypt.IV.fromLength(16);
  final encrypter = encrypt.Encrypter(encrypt.AES(key));

  try {
    // Step 1: Decrypt the data
    final decrypted = encrypter.decrypt64((encryptedData).toString(), iv: iv);

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
