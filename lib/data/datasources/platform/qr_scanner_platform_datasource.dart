import 'dart:async';

import 'package:seek_challenge/data/models/qr_scan_model.dart';
import 'package:seek_challenge/pigeon.g.dart';

abstract class QRScannerPlatformDatasource {
  /// Inicia el escáner de códigos QR nativo
  Future<void> startScanner();

  /// Detiene el escáner de códigos QR nativo
  Future<void> stopScanner();

  /// Stream para recibir los resultados del escaneo en tiempo real
  Stream<QRScanModel> get scanStream;
}

class QRScannerPlatformDatasourceImpl implements QRScannerPlatformDatasource, QRScannerFlutterApi {
  final QRScannerApi _qrScannerApi;
  final _scanStreamController = StreamController<QRScanModel>.broadcast();

  QRScannerPlatformDatasourceImpl(this._qrScannerApi) {
    QRScannerFlutterApi.setUp(this);
  }

  @override
  Future<void> startScanner() async {
    try {
      await _qrScannerApi.startScanner();
    } catch (e) {
      throw Exception('Error al iniciar el escáner QR: $e');
    }
  }

  @override
  Future<void> stopScanner() async {
    try {
      await _qrScannerApi.stopScanner();
    } catch (e) {
      throw Exception('Error al detener el escáner QR: $e');
    }
  }

  @override
  Stream<QRScanModel> get scanStream => _scanStreamController.stream;

  @override
  void onQRCodeDetected(QRScanResult result) {
    if (result.content != null && result.format != null && result.timestamp != null) {
      final qrScan = QRScanModel(
        content: result.content!,
        format: result.format!,
        timestamp: DateTime.fromMillisecondsSinceEpoch(
          int.parse(result.timestamp!),
        ),
      );
      _scanStreamController.add(qrScan);
    }
  }

  void dispose() {
    _scanStreamController.close();
  }
}