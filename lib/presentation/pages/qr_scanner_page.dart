import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? _ctrl;
  bool _hasScanned = false;

  @override
  void reassemble() {
    super.reassemble();
    // Necessário para hot reload com câmera ativa
    if (Platform.isAndroid) _ctrl?.pauseCamera();
    _ctrl?.resumeCamera();
  }

  void _onQRViewCreated(QRViewController controller) {
    _ctrl = controller;
    controller.scannedDataStream.listen((barcode) {
      if (_hasScanned) return;
      final code = barcode.code;
      if (code != null && code.isNotEmpty && mounted) {
        _hasScanned = true;
        _ctrl?.pauseCamera();
        Navigator.pop(context, code);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final scanArea = MediaQuery.of(context).size.width * 0.72;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          QRView(
            key:              _qrKey,
            onQRViewCreated:  _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor:  Colors.greenAccent,
              borderRadius: 12,
              borderLength: 36,
              borderWidth:  8,
              cutOutSize:   scanArea,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white, size: 28),
                  ),
                  const Expanded(
                    child: Text(
                      'Aponte para o QR Code do contentor',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
