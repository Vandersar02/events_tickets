import 'package:events_ticket/core/utils/encryption_utils.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

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
        qrCodeData = EncryptionUtils.decryptAndVerifyQrDataReal(
            barcode.rawValue, secretKey);
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
          // QR code scanner section
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

          //ticket details
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
                  // display the ticket data if valid
                  Text(
                    isValid
                        ? '$qrCodeData'
                        : "Le QR Code est invalide ou a été altéré.",
                    style: TextStyle(
                        fontSize: 18,
                        color: isValid ? Colors.green : Colors.red),
                  ),
                if (isScanning) const CircularProgressIndicator(),

                // button to check-in or check-out the ticket
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: isValid
                          ? () {
                              // Action Check-in
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Check-in effectué!')),
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
                                const SnackBar(
                                    content: Text('Check-out effectué!')),
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
