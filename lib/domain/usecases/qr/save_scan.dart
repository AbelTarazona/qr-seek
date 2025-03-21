import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:seek_challenge/core/error/failures.dart';
import 'package:seek_challenge/core/usecases/usecase.dart';
import 'package:seek_challenge/domain/entities/qr_scan.dart';
import 'package:seek_challenge/domain/repositories/qr_scan_repository.dart';

class SaveScan implements UseCase<QRScan, ScanParams> {
  final QRScanRepository repository;

  SaveScan(this.repository);

  @override
  Future<Either<Failure, QRScan>> call(ScanParams params) {
    return repository.saveScan(params.scan);
  }
}

class ScanParams extends Equatable {
  final QRScan scan;

  const ScanParams({required this.scan});

  @override
  List<Object> get props => [scan];
}

class StartScanner implements UseCase<void, NoParams> {
  final QRScanRepository repository;

  StartScanner(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.startScanner();
  }
}

class StopScanner implements UseCase<void, NoParams> {
  final QRScanRepository repository;

  StopScanner(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.stopScanner();
  }
}