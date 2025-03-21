import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seek_challenge/core/usecases/usecase.dart';
import 'package:seek_challenge/domain/entities/user.dart';
import 'package:seek_challenge/domain/usecases/auth/authenticate_biometric.dart';
import 'package:seek_challenge/domain/usecases/auth/verify_pin.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthenticateWithBiometrics authenticateWithBiometrics;
  final CheckBiometricAvailability checkBiometricAvailability;
  final VerifyPin verifyPin;
  final SavePin savePin;
  final GetUserInfo getUserInfo;

  AuthBloc({
    required this.authenticateWithBiometrics,
    required this.checkBiometricAvailability,
    required this.verifyPin,
    required this.savePin,
    required this.getUserInfo,
  }) : super(AuthInitial()) {
    on<CheckBiometricSupportEvent>(_onCheckBiometricSupport);
    on<AuthenticateBiometricEvent>(_onAuthenticateBiometric);
    on<VerifyPinEvent>(_onVerifyPin);
    on<SavePinEvent>(_onSavePin);
    on<LoadUserInfoEvent>(_onLoadUserInfo);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onCheckBiometricSupport(
    CheckBiometricSupportEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await checkBiometricAvailability(NoParams());

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (isSupported) => emit(BiometricSupportState(isSupported: isSupported)),
    );
  }

  Future<void> _onAuthenticateBiometric(
    AuthenticateBiometricEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await authenticateWithBiometrics(NoParams());

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (isAuthenticated) {
        if (isAuthenticated) {
          emit(AuthenticatedState());
        } else {
          emit(BiometricFailedState());
        }
      },
    );
  }

  Future<void> _onVerifyPin(
    VerifyPinEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await verifyPin(PinParams(pin: event.pin));

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (isVerified) {
        if (isVerified) {
          emit(AuthenticatedState());
        } else {
          emit(PinVerificationFailedState());
        }
      },
    );
  }

  Future<void> _onSavePin(
    SavePinEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await savePin(PinParams(pin: event.pin));

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (isSuccess) {
        if (isSuccess) {
          emit(PinSavedState());
        } else {
          emit(AuthError(message: 'No se pudo guardar el PIN'));
        }
      },
    );
  }

  Future<void> _onLoadUserInfo(
    LoadUserInfoEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await getUserInfo(NoParams());

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(UserInfoLoadedState(user: user)),
    );
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthInitial());
  }
}
