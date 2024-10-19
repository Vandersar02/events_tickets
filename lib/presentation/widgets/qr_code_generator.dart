import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketQRCodePage extends StatelessWidget {
  final String ticketData;

  const TicketQRCodePage({super.key, required this.ticketData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Code du billet"),
      ),
      body: Center(
        child: QrImageView(
          data: '1234567890',
          version: QrVersions.auto,
          size: 200.0,
        ),
      ),
    );
  }
}
