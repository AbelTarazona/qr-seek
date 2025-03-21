part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class CheckBiometricSupportEvent extends AuthEvent {}

class AuthenticateBiometricEvent extends AuthEvent {}

class VerifyPinEvent extends AuthEvent {
  final String pin;

  const VerifyPinEvent({required this.pin});

  @override
  List<Object> get props => [pin];
}

class SavePinEvent extends AuthEvent {
  final String pin;

  const SavePinEvent({required this.pin});

  @override
  List<Object> get props => [pin];
}

class LoadUserInfoEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {}
