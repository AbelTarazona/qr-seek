import 'package:dartz/dartz.dart';
import 'package:seek_challenge/core/error/failures.dart';
import 'package:seek_challenge/core/usecases/usecase.dart';
import 'package:seek_challenge/domain/entities/user.dart';
import 'package:seek_challenge/domain/repositories/auth_repository.dart';

class AuthenticateWithBiometrics implements UseCase<bool, NoParams> {
  final AuthRepository repository;

  AuthenticateWithBiometrics(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return repository.authenticateWithBiometrics();
  }
}

class CheckBiometricAvailability implements UseCase<bool, NoParams> {
  final AuthRepository repository;

  CheckBiometricAvailability(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return repository.checkBiometricAvailability();
  }
}

class GetUserInfo implements UseCase<User, NoParams> {
  final AuthRepository repository;

  GetUserInfo(this.repository);

  @override
  Future<Either<Failure, User>> call(NoParams params) {
    return repository.getUser();
  }
}
