import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:seek_challenge/core/error/failures.dart';
import 'package:seek_challenge/core/usecases/usecase.dart';
import 'package:seek_challenge/domain/repositories/auth_repository.dart';

class VerifyPin implements UseCase<bool, PinParams> {
  final AuthRepository repository;

  VerifyPin(this.repository);

  @override
  Future<Either<Failure, bool>> call(PinParams params) {
    return repository.verifyPin(params.pin);
  }
}

class SavePin implements UseCase<bool, PinParams> {
  final AuthRepository repository;

  SavePin(this.repository);

  @override
  Future<Either<Failure, bool>> call(PinParams params) {
    return repository.savePin(params.pin);
  }
}

class PinParams extends Equatable {
  final String pin;

  const PinParams({required this.pin});

  @override
  List<Object> get props => [pin];
}
