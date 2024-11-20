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
  final MobileScannerController controller = MobileScannerController();
  String? qrCodeData;
  bool isValid = false;
  bool isScanning = true;
  int scanCount = 0; // Nombre total de scans
  final List<String> scanHistory = []; // Historique des scans

  @override
  void initState() {
    super.initState();
    controller.start();
    controller.barcodes.listen((barcodeCapture) {
      if (isScanning) {
        final barcode = barcodeCapture.barcodes.first;
        final decryptedData = EncryptionUtils.decryptAndVerifyQrDataReal(
          barcode.rawValue,
          secretKey,
        );

        setState(() {
          qrCodeData = decryptedData;
          isValid = qrCodeData != null;
          isScanning = false;

          // Mise à jour des statistiques
          if (isValid) {
            scanCount++;
            scanHistory.insert(
                0, qrCodeData!); // Ajouter au début de l'historique
            if (scanHistory.length > 5) {
              scanHistory.removeLast(); // Limiter à 5 scans
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Scanner le QR Code')),
        actions: [
          IconButton(
            icon: Icon(isScanning ? Icons.pause : Icons.play_arrow),
            onPressed: () {
              setState(() {
                isScanning = !isScanning;
                if (isScanning) {
                  controller.start();
                } else {
                  controller.stop();
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Section scanner
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

          // Section informations et actions
          Container(
            padding: const EdgeInsets.all(16.0),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Informations sur le QR code
                if (qrCodeData != null)
                  Text(
                    isValid
                        ? 'QR Code valide : $qrCodeData'
                        : "Le QR Code est invalide ou altéré.",
                    style: TextStyle(
                      fontSize: 16,
                      color: isValid ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                const SizedBox(height: 16),

                // Statistiques
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Nombre de scans : $scanCount",
                      style: const TextStyle(fontSize: 16),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          scanCount = 0;
                          scanHistory.clear();
                        });
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text("Réinitialiser"),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Historique des scans
                if (scanHistory.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Historique des derniers scans :",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ...scanHistory.map((scan) => Text(
                            "- $scan",
                            style: const TextStyle(fontSize: 14),
                          )),
                    ],
                  ),

                const SizedBox(height: 24),

                // Actions (Check-in, Check-out, Rescan)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: isValid
                          ? () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Check-in effectué!'),
                                ),
                              );
                            }
                          : null,
                      child: const Text("Check-in"),
                    ),
                    ElevatedButton(
                      onPressed: isValid
                          ? () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Check-out effectué!'),
                                ),
                              );
                            }
                          : null,
                      child: const Text("Check-out"),
                    ),
                    ElevatedButton(
                      onPressed: () {
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
