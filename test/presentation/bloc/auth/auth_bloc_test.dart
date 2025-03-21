import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:seek_challenge/core/error/failures.dart';
import 'package:seek_challenge/core/usecases/usecase.dart';
import 'package:seek_challenge/domain/entities/user.dart';
import 'package:seek_challenge/domain/usecases/auth/authenticate_biometric.dart';
import 'package:seek_challenge/domain/usecases/auth/verify_pin.dart';
import 'package:seek_challenge/presentation/bloc/auth/auth_bloc.dart';

@GenerateMocks([
  AuthenticateWithBiometrics,
  CheckBiometricAvailability,
  VerifyPin,
  SavePin,
  GetUserInfo,
])
import 'auth_bloc_test.mocks.dart';

void main() {
  late AuthBloc bloc;
  late MockAuthenticateWithBiometrics mockAuthenticateWithBiometrics;
  late MockCheckBiometricAvailability mockCheckBiometricAvailability;
  late MockVerifyPin mockVerifyPin;
  late MockSavePin mockSavePin;
  late MockGetUserInfo mockGetUserInfo;

  setUp(() {
    mockAuthenticateWithBiometrics = MockAuthenticateWithBiometrics();
    mockCheckBiometricAvailability = MockCheckBiometricAvailability();
    mockVerifyPin = MockVerifyPin();
    mockSavePin = MockSavePin();
    mockGetUserInfo = MockGetUserInfo();

    bloc = AuthBloc(
      authenticateWithBiometrics: mockAuthenticateWithBiometrics,
      checkBiometricAvailability: mockCheckBiometricAvailability,
      verifyPin: mockVerifyPin,
      savePin: mockSavePin,
      getUserInfo: mockGetUserInfo,
    );
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state should be AuthInitial', () {
    expect(bloc.state, equals(AuthInitial()));
  });

  group('CheckBiometricSupportEvent', () {
    final tIsSupported = true;

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, BiometricSupportState] when biometric support check is successful',
      build: () {
        when(mockCheckBiometricAvailability(any))
            .thenAnswer((_) async => Right(tIsSupported));
        return bloc;
      },
      act: (bloc) => bloc.add(CheckBiometricSupportEvent()),
      expect: () => [
        AuthLoading(),
        BiometricSupportState(isSupported: tIsSupported),
      ],
      verify: (_) {
        verify(mockCheckBiometricAvailability(NoParams()));
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] when biometric support check fails',
      build: () {
        when(mockCheckBiometricAvailability(any))
            .thenAnswer((_) async => const Left(PlatformFailure(message: 'Error')));
        return bloc;
      },
      act: (bloc) => bloc.add(CheckBiometricSupportEvent()),
      expect: () => [
        AuthLoading(),
        const AuthError(message: 'Error'),
      ],
      verify: (_) {
        verify(mockCheckBiometricAvailability(NoParams()));
      },
    );
  });

  group('AuthenticateBiometricEvent', () {
    const tIsAuthenticated = true;

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthenticatedState] when biometric authentication is successful',
      build: () {
        when(mockAuthenticateWithBiometrics(any))
            .thenAnswer((_) async => const Right(tIsAuthenticated));
        return bloc;
      },
      act: (bloc) => bloc.add(AuthenticateBiometricEvent()),
      expect: () => [
        AuthLoading(),
        AuthenticatedState(),
      ],
      verify: (_) {
        verify(mockAuthenticateWithBiometrics(NoParams()));
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, BiometricFailedState] when biometric authentication fails',
      build: () {
        when(mockAuthenticateWithBiometrics(any))
            .thenAnswer((_) async => const Right(false));
        return bloc;
      },
      act: (bloc) => bloc.add(AuthenticateBiometricEvent()),
      expect: () => [
        AuthLoading(),
        BiometricFailedState(),
      ],
      verify: (_) {
        verify(mockAuthenticateWithBiometrics(NoParams()));
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] when biometric authentication throws',
      build: () {
        when(mockAuthenticateWithBiometrics(any))
            .thenAnswer((_) async => const Left(AuthenticationFailure(message: 'Error')));
        return bloc;
      },
      act: (bloc) => bloc.add(AuthenticateBiometricEvent()),
      expect: () => [
        AuthLoading(),
        const AuthError(message: 'Error'),
      ],
      verify: (_) {
        verify(mockAuthenticateWithBiometrics(NoParams()));
      },
    );
  });

  group('VerifyPinEvent', () {
    const tPin = '1234';
    const tIsVerified = true;

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthenticatedState] when PIN verification is successful',
      build: () {
        when(mockVerifyPin(any))
            .thenAnswer((_) async => const Right(tIsVerified));
        return bloc;
      },
      act: (bloc) => bloc.add(const VerifyPinEvent(pin: tPin)),
      expect: () => [
        AuthLoading(),
        AuthenticatedState(),
      ],
      verify: (_) {
        verify(mockVerifyPin(const PinParams(pin: tPin)));
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, PinVerificationFailedState] when PIN verification fails',
      build: () {
        when(mockVerifyPin(any))
            .thenAnswer((_) async => const Right(false));
        return bloc;
      },
      act: (bloc) => bloc.add(const VerifyPinEvent(pin: tPin)),
      expect: () => [
        AuthLoading(),
        PinVerificationFailedState(),
      ],
      verify: (_) {
        verify(mockVerifyPin(const PinParams(pin: tPin)));
      },
    );
  });

  group('LoadUserInfoEvent', () {
    final tUser = User(
      id: '1',
      hasSetupBiometric: true,
      hasSetupPin: true,
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, UserInfoLoadedState] when loading user info is successful',
      build: () {
        when(mockGetUserInfo(any))
            .thenAnswer((_) async => Right(tUser));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadUserInfoEvent()),
      expect: () => [
        AuthLoading(),
        UserInfoLoadedState(user: tUser),
      ],
      verify: (_) {
        verify(mockGetUserInfo(NoParams()));
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] when loading user info fails',
      build: () {
        when(mockGetUserInfo(any))
            .thenAnswer((_) async => const Left(StorageFailure(message: 'Error')));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadUserInfoEvent()),
      expect: () => [
        AuthLoading(),
        const AuthError(message: 'Error'),
      ],
      verify: (_) {
        verify(mockGetUserInfo(NoParams()));
      },
    );
  });
}
