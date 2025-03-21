import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:seek_challenge/core/error/failures.dart';
import 'package:seek_challenge/data/datasources/local/qr_scan_local_datasource.dart';
import 'package:seek_challenge/data/datasources/platform/qr_scanner_platform_datasource.dart';
import 'package:seek_challenge/data/models/qr_scan_model.dart';
import 'package:seek_challenge/domain/entities/qr_scan.dart';
import 'package:seek_challenge/domain/repositories/qr_scan_repository.dart';

class QRScanRepositoryImpl implements QRScanRepository {
  final QRScannerPlatformDatasource _platformDatasource;
  final QRScanLocalDatasource _localDatasource;

  // StreamController para transmitir los resultados de escaneo
  final _scanStreamController = StreamController<QRScan>.broadcast();

  QRScanRepositoryImpl(this._platformDatasource, this._localDatasource) {
    // Suscribirse al stream de la plataforma para recibir escaneos
    _platformDatasource.scanStream.listen((scan) {
      _scanStreamController.add(scan);
    });
  }

  @override
  Future<Either<Failure, void>> startScanner() async {
    try {
      await _platformDatasource.startScanner();
      return const Right(null);
    } catch (e) {
      return Left(PlatformFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> stopScanner() async {
    try {
      await _platformDatasource.stopScanner();
      return const Right(null);
    } catch (e) {
      return Left(PlatformFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, QRScan>> saveScan(QRScan scan) async {
    try {
      final qrScanModel = QRScanModel.fromEntity(scan);
      final savedScan = await _localDatasource.saveScan(qrScanModel);
      return Right(savedScan);
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<QRScan>>> getAllScans() async {
    try {
      final scans = await _localDatasource.getAllScans();
      return Right(scans);
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, QRScan>> getScanById(int id) async {
    try {
      final scan = await _localDatasource.getScanById(id);
      return Right(scan);
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteScan(int id) async {
    try {
      final result = await _localDatasource.deleteScan(id);
      return Right(result);
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Stream<QRScan> get scanStream => _scanStreamController.stream;

  void dispose() {
    _scanStreamController.close();
  }
}