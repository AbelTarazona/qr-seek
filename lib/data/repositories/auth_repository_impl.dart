import 'package:dartz/dartz.dart';
import 'package:seek_challenge/core/error/failures.dart';
import 'package:seek_challenge/data/datasources/local/auth_local_datasource.dart';
import 'package:seek_challenge/data/datasources/platform/biometric_platform_datasource.dart';
import 'package:seek_challenge/domain/entities/user.dart';
import 'package:seek_challenge/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final BiometricPlatformDatasource _platformDatasource;
  final AuthLocalDatasource _localDatasource;

  AuthRepositoryImpl(this._platformDatasource, this._localDatasource);

  @override
  Future<Either<Failure, bool>> checkBiometricAvailability() async {
    try {
      final isAvailable = await _platformDatasource.isBiometricAvailable();
      return Right(isAvailable);
    } catch (e) {
      return Left(PlatformFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> authenticateWithBiometrics() async {
    try {
      final result = await _platformDatasource.authenticateWithBiometrics();

      if (result.success == true) {
        await _localDatasource.updateBiometricSetup(true);
        return const Right(true);
      } else {
        return Right(false);
      }
    } catch (e) {
      return Left(AuthenticationFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> verifyPin(String pin) async {
    try {
      final isValid = await _localDatasource.verifyPin(pin);
      return Right(isValid);
    } catch (e) {
      return Left(AuthenticationFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> savePin(String pin) async {
    try {
      final result = await _localDatasource.savePin(pin);
      return Right(result);
    } catch (e) {
      return Left(StorageFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getUser() async {
    try {
      final user = await _localDatasource.getUser();
      return Right(user);
    } catch (e) {
      return Left(StorageFailure(message: e.toString()));
    }
  }
}