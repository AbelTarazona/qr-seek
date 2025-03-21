// Mocks generated by Mockito 5.4.4 from annotations
// in seek_challenge/test/presentation/bloc/auth/auth_bloc_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:dartz/dartz.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:seek_challenge/core/error/failures.dart' as _i6;
import 'package:seek_challenge/core/usecases/usecase.dart' as _i7;
import 'package:seek_challenge/domain/entities/user.dart' as _i9;
import 'package:seek_challenge/domain/repositories/auth_repository.dart' as _i2;
import 'package:seek_challenge/domain/usecases/auth/authenticate_biometric.dart'
    as _i4;
import 'package:seek_challenge/domain/usecases/auth/verify_pin.dart' as _i8;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeAuthRepository_0 extends _i1.SmartFake
    implements _i2.AuthRepository {
  _FakeAuthRepository_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeEither_1<L, R> extends _i1.SmartFake implements _i3.Either<L, R> {
  _FakeEither_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [AuthenticateWithBiometrics].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthenticateWithBiometrics extends _i1.Mock
    implements _i4.AuthenticateWithBiometrics {
  MockAuthenticateWithBiometrics() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.AuthRepository get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeAuthRepository_0(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i2.AuthRepository);

  @override
  _i5.Future<_i3.Either<_i6.Failure, bool>> call(_i7.NoParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue: _i5.Future<_i3.Either<_i6.Failure, bool>>.value(
            _FakeEither_1<_i6.Failure, bool>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i5.Future<_i3.Either<_i6.Failure, bool>>);
}

/// A class which mocks [CheckBiometricAvailability].
///
/// See the documentation for Mockito's code generation for more information.
class MockCheckBiometricAvailability extends _i1.Mock
    implements _i4.CheckBiometricAvailability {
  MockCheckBiometricAvailability() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.AuthRepository get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeAuthRepository_0(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i2.AuthRepository);

  @override
  _i5.Future<_i3.Either<_i6.Failure, bool>> call(_i7.NoParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue: _i5.Future<_i3.Either<_i6.Failure, bool>>.value(
            _FakeEither_1<_i6.Failure, bool>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i5.Future<_i3.Either<_i6.Failure, bool>>);
}

/// A class which mocks [VerifyPin].
///
/// See the documentation for Mockito's code generation for more information.
class MockVerifyPin extends _i1.Mock implements _i8.VerifyPin {
  MockVerifyPin() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.AuthRepository get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeAuthRepository_0(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i2.AuthRepository);

  @override
  _i5.Future<_i3.Either<_i6.Failure, bool>> call(_i8.PinParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue: _i5.Future<_i3.Either<_i6.Failure, bool>>.value(
            _FakeEither_1<_i6.Failure, bool>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i5.Future<_i3.Either<_i6.Failure, bool>>);
}

/// A class which mocks [SavePin].
///
/// See the documentation for Mockito's code generation for more information.
class MockSavePin extends _i1.Mock implements _i8.SavePin {
  MockSavePin() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.AuthRepository get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeAuthRepository_0(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i2.AuthRepository);

  @override
  _i5.Future<_i3.Either<_i6.Failure, bool>> call(_i8.PinParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue: _i5.Future<_i3.Either<_i6.Failure, bool>>.value(
            _FakeEither_1<_i6.Failure, bool>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i5.Future<_i3.Either<_i6.Failure, bool>>);
}

/// A class which mocks [GetUserInfo].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetUserInfo extends _i1.Mock implements _i4.GetUserInfo {
  MockGetUserInfo() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.AuthRepository get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeAuthRepository_0(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i2.AuthRepository);

  @override
  _i5.Future<_i3.Either<_i6.Failure, _i9.User>> call(_i7.NoParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue: _i5.Future<_i3.Either<_i6.Failure, _i9.User>>.value(
            _FakeEither_1<_i6.Failure, _i9.User>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i5.Future<_i3.Either<_i6.Failure, _i9.User>>);
}
