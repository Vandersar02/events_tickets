import 'package:events_ticket/core/utils/encryption_utils.dart';
import 'package:events_ticket/data/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:intl/intl.dart';

class QRScannerScreen extends StatefulWidget {
  final EventModel event;

  const QRScannerScreen({super.key, required this.event});

  @override
  QRScannerScreenState createState() => QRScannerScreenState();
}

class QRScannerScreenState extends State<QRScannerScreen> {
  final MobileScannerController controller = MobileScannerController();
  Map<String, dynamic>? qrCodeData;
  bool isValid = false;
  bool isScanning = true;
  int scanCount = 0;
  final List<Map<String, String>> scanHistory = []; // Historique structuré

  @override
  void initState() {
    super.initState();
    String secretKey = widget.event.id!.substring(0, 32);
    controller.start();

    controller.barcodes.listen((barcodeCapture) {
      if (isScanning) {
        final barcode = barcodeCapture.barcodes.first;
        final decryptedData = EncryptionUtils.decryptAndVerifyQrDataToMap(
          barcode.rawValue,
          secretKey,
        );

        setState(() {
          qrCodeData = decryptedData;
          isValid = qrCodeData != null;
          isScanning = false;

          if (isValid) {
            scanCount++;
            scanHistory.insert(0, {
              "data": qrCodeData.toString(),
              "time": DateFormat('HH:mm:ss').format(DateTime.now()),
            });
            if (scanHistory.length > 10) {
              scanHistory.removeLast();
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
                if (qrCodeData != null) ...[
                  const Text(
                    "Informations extraites du QR Code :",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: qrCodeData!["name"] ?? "",
                    decoration: const InputDecoration(labelText: "Nom"),
                  ),
                  TextFormField(
                    initialValue: qrCodeData!["class"] ?? "",
                    decoration:
                        const InputDecoration(labelText: "Type de Ticket"),
                  ),
                  TextFormField(
                    initialValue: qrCodeData!["event"] ?? widget.event.title,
                    decoration: const InputDecoration(labelText: "Événement"),
                  ),
                  const SizedBox(height: 16),
                ],
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
                if (scanHistory.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Historique des scans :",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ...scanHistory.map(
                        (scan) => Text(
                          "- ${scan["time"]}: ${scan["data"]}",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 24),
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
