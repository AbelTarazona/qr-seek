import 'package:dartz/dartz.dart';
import 'package:seek_challenge/core/error/failures.dart';
import 'package:seek_challenge/domain/entities/user.dart';

abstract class AuthRepository {
  /// Verifica si el dispositivo tiene capacidades biométricas
  Future<Either<Failure, bool>> checkBiometricAvailability();

  /// Autentica al usuario usando biometría
  Future<Either<Failure, bool>> authenticateWithBiometrics();

  /// Verifica el PIN de respaldo
  Future<Either<Failure, bool>> verifyPin(String pin);

  /// Guarda un nuevo PIN de respaldo
  Future<Either<Failure, bool>> savePin(String pin);

  /// Obtiene el estado de autenticación del usuario
  Future<Either<Failure, User>> getUser();
}