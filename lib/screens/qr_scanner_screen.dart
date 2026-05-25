import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../providers/ticket_provider.dart';
import '../models/ticket.dart';
import '../utils/constants.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool isScanning = true;
  bool isTorchOn = false;
  Ticket? scannedTicket;

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (!isScanning) return;

    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      final String? rawValue = barcode.rawValue;
      if (rawValue != null) {
        isScanning = false;
        cameraController.stop();
        _findTicket(rawValue);
        break;
      }
    }
  }

  void _findTicket(String qrCode) async {
    final ticketProvider = Provider.of<TicketProvider>(context, listen: false);

    try {
      final ticket = ticketProvider.tickets.firstWhere(
        (t) => t.qrCode == qrCode,
      );
      setState(() {
        scannedTicket = ticket;
      });
    } catch (e) {
      setState(() {
        scannedTicket = null;
      });
      _showResult('Ticket Not Found', false);
    }
  }

  void _confirmVerification() async {
    if (scannedTicket == null) return;

    if (scannedTicket!.status == TicketStatus.verified) {
      _showResult('Ticket Already Verified!', false);
      return;
    }

    if (scannedTicket!.isExpired) {
      _showResult('Ticket Expired! Show time has passed.', false);
      return;
    }

    final ticketProvider = Provider.of<TicketProvider>(context, listen: false);
    await ticketProvider.markAsVerified(scannedTicket!.id!);

    _showResult(
        '✓ TICKET VERIFIED!\n\n'
        'Movie: ${scannedTicket!.movieTitle}\n'
        'Seat: ${scannedTicket!.seatNumber}\n\n'
        'Enjoy the movie! 🎬',
        true);
  }

  void _showResult(String message, bool isValid) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBlack,
        title: Text(
          isValid ? '✓ VERIFIED' : '✗ INVALID',
          style: TextStyle(color: isValid ? Colors.green : Colors.red),
        ),
        content: Text(message, style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetScanner();
            },
            child: const Text('Scan Again',
                style: TextStyle(color: AppColors.primaryRed)),
          ),
        ],
      ),
    );
  }

  void _resetScanner() {
    setState(() {
      isScanning = true;
      scannedTicket = null;
    });
    cameraController.start();
  }

  void _toggleTorch() {
    setState(() {
      isTorchOn = !isTorchOn;
    });
    cameraController.toggleTorch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Scan Ticket QR Code'),
        backgroundColor: AppColors.primaryRed,
        actions: [
          IconButton(
            icon: Icon(isTorchOn ? Icons.flash_on : Icons.flash_off),
            onPressed: _toggleTorch,
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: _onDetect,
          ),
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryRed, width: 3),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Position QR code inside the red frame',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          if (scannedTicket != null && !isScanning)
            Positioned(
              bottom: 120,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardBlack,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primaryRed),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          scannedTicket!.status == TicketStatus.verified
                              ? Icons.check_circle
                              : Icons.pending,
                          color: scannedTicket!.statusColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Status: ${scannedTicket!.statusText}',
                          style: TextStyle(
                            color: scannedTicket!.statusColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      scannedTicket!.movieTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Seat: ${scannedTicket!.seatNumber}'),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: scannedTicket!.status == TicketStatus.pending
                            ? _confirmVerification
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryRed,
                        ),
                        child: Text(
                          scannedTicket!.status == TicketStatus.pending
                              ? 'CONFIRM VERIFICATION'
                              : 'ALREADY ${scannedTicket!.statusText}',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
