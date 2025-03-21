part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object> get props => [message];
}

class BiometricSupportState extends AuthState {
  final bool isSupported;

  const BiometricSupportState({required this.isSupported});

  @override
  List<Object> get props => [isSupported];
}

class AuthenticatedState extends AuthState {}

class BiometricFailedState extends AuthState {}

class PinVerificationFailedState extends AuthState {}

class PinSavedState extends AuthState {}

class UserInfoLoadedState extends AuthState {
  final User user;

  const UserInfoLoadedState({required this.user});

  @override
  List<Object> get props => [user];
}
