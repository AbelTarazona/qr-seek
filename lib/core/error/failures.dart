import 'package:equatable/equatable.dart';

/// Clase base para todos los tipos de fallos en la aplicación
abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object> get props => [message];
}

// Fallos específicos
class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

class DatabaseFailure extends Failure {
  const DatabaseFailure({required super.message});
}

class PlatformFailure extends Failure {
  const PlatformFailure({required super.message});
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure({required super.message});
}

class StorageFailure extends Failure {
  const StorageFailure({required super.message});
}

class CameraFailure extends Failure {
  const CameraFailure({required super.message});
}
