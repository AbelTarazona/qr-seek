import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:seek_challenge/core/error/failures.dart';
import 'package:seek_challenge/core/usecases/usecase.dart';
import 'package:seek_challenge/domain/entities/qr_scan.dart';
import 'package:seek_challenge/domain/repositories/qr_scan_repository.dart';

class GetAllScans implements UseCase<List<QRScan>, NoParams> {
  final QRScanRepository repository;

  GetAllScans(this.repository);

  @override
  Future<Either<Failure, List<QRScan>>> call(NoParams params) {
    return repository.getAllScans();
  }
}

class GetScanById implements UseCase<QRScan, ScanIdParams> {
  final QRScanRepository repository;

  GetScanById(this.repository);

  @override
  Future<Either<Failure, QRScan>> call(ScanIdParams params) {
    return repository.getScanById(params.id);
  }
}

class DeleteScan implements UseCase<bool, ScanIdParams> {
  final QRScanRepository repository;

  DeleteScan(this.repository);

  @override
  Future<Either<Failure, bool>> call(ScanIdParams params) {
    return repository.deleteScan(params.id);
  }
}

class ScanIdParams extends Equatable {
  final int id;

  const ScanIdParams({required this.id});

  @override
  List<Object> get props => [id];
}
