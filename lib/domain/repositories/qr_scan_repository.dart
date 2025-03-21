import 'package:dartz/dartz.dart';
import 'package:seek_challenge/core/error/failures.dart';
import 'package:seek_challenge/domain/entities/qr_scan.dart';

abstract class QRScanRepository {
  /// Inicia el escáner de códigos QR
  Future<Either<Failure, void>> startScanner();

  /// Detiene el escáner de códigos QR
  Future<Either<Failure, void>> stopScanner();

  /// Guarda un escaneo QR en la base de datos local
  Future<Either<Failure, QRScan>> saveScan(QRScan scan);

  /// Obtiene todos los escaneos guardados
  Future<Either<Failure, List<QRScan>>> getAllScans();

  /// Obtiene un escaneo por su ID
  Future<Either<Failure, QRScan>> getScanById(int id);

  /// Elimina un escaneo por su ID
  Future<Either<Failure, bool>> deleteScan(int id);

  /// Stream para recibir los resultados del escaneo en tiempo real
  Stream<QRScan> get scanStream;
}