import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:seek_challenge/data/datasources/local/auth_local_datasource.dart';
import 'package:seek_challenge/data/datasources/local/qr_scan_local_datasource.dart';
import 'package:seek_challenge/data/datasources/platform/biometric_platform_datasource.dart';
import 'package:seek_challenge/data/datasources/platform/qr_scanner_platform_datasource.dart';
import 'package:seek_challenge/data/repositories/auth_repository_impl.dart';
import 'package:seek_challenge/data/repositories/qr_scan_repository_impl.dart';
import 'package:seek_challenge/domain/repositories/auth_repository.dart';
import 'package:seek_challenge/domain/repositories/qr_scan_repository.dart';
import 'package:seek_challenge/domain/usecases/auth/authenticate_biometric.dart';
import 'package:seek_challenge/domain/usecases/auth/verify_pin.dart';
import 'package:seek_challenge/domain/usecases/qr/get_all_scans.dart';
import 'package:seek_challenge/domain/usecases/qr/save_scan.dart';
import 'package:seek_challenge/pigeon.g.dart';
import 'package:seek_challenge/presentation/bloc/auth/auth_bloc.dart';
import 'package:seek_challenge/presentation/bloc/qr_scanner/qr_scanner_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - QR Scanner
  // Bloc
  sl.registerFactory(
        () => QrScannerBloc(
      startScanner: sl(),
      stopScanner: sl(),
      saveScan: sl(),
      getAllScans: sl(),
      getScanById: sl(),
      deleteScan: sl(),
      repository: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => StartScanner(sl()));
  sl.registerLazySingleton(() => StopScanner(sl()));
  sl.registerLazySingleton(() => SaveScan(sl()));
  sl.registerLazySingleton(() => GetAllScans(sl()));
  sl.registerLazySingleton(() => GetScanById(sl()));
  sl.registerLazySingleton(() => DeleteScan(sl()));

  // Repository
  sl.registerLazySingleton<QRScanRepository>(
        () => QRScanRepositoryImpl(sl(), sl()),
  );

  // Data sources
  sl.registerLazySingleton<QRScannerPlatformDatasource>(
        () => QRScannerPlatformDatasourceImpl(sl()),
  );
  sl.registerLazySingleton<QRScanLocalDatasource>(
        () => QRScanLocalDatasourceImpl(),
  );

  //! Features - Authentication
  // Bloc
  sl.registerFactory(
        () => AuthBloc(
      authenticateWithBiometrics: sl(),
      checkBiometricAvailability: sl(),
      verifyPin: sl(),
      savePin: sl(),
      getUserInfo: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => AuthenticateWithBiometrics(sl()));
  sl.registerLazySingleton(() => CheckBiometricAvailability(sl()));
  sl.registerLazySingleton(() => VerifyPin(sl()));
  sl.registerLazySingleton(() => SavePin(sl()));
  sl.registerLazySingleton(() => GetUserInfo(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(sl(), sl()),
  );

  // Data sources
  sl.registerLazySingleton<BiometricPlatformDatasource>(
        () => BiometricPlatformDatasourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthLocalDatasource>(
        () => AuthLocalDatasourceImpl(sl()),
  );

  //! Core
  sl.registerLazySingleton(() => const FlutterSecureStorage());

  //! External
  // API generadas por Pigeon
  sl.registerLazySingleton(() => QRScannerApi());
  sl.registerLazySingleton(() => BiometricAuthApi());
}
