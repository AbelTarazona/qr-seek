import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:seek_challenge/core/error/failures.dart';

/// Un caso de uso abstracto que define la estructura básica para todos los casos de uso.
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Clase de parámetros para casos de uso que no requieren parámetros.
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}