import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/pigeon.g.dart',
  dartOptions: DartOptions(),
  kotlinOut: 'android/app/src/main/kotlin/com/example/seek_challenge/Pigeon.g.kt',
  kotlinOptions: KotlinOptions(package: 'com.example.seek_challenge'),
  swiftOut: 'ios/Classes/Pigeon.g.swift',
  swiftOptions: SwiftOptions(),

  dartPackageName: 'com_example_seek_challenge',
))

class QRScanResult {
  String? content;
  String? format;
  String? timestamp;
}

class CameraTextureResult {
  int? textureId;
  double? width;
  double? height;
  String? error;
}

@HostApi()
abstract class QRScannerApi {
  void startScanner();
  void stopScanner();

  @async
  CameraTextureResult getCameraTexture();

  void disposeCameraTexture();
}

class BiometricAuthResult {
  bool? success;
  String? errorCode;
  String? errorMessage;
}

@HostApi()
abstract class BiometricAuthApi {
  @async
  BiometricAuthResult authenticateWithBiometrics();

  @async
  bool isBiometricAvailable();
}

@FlutterApi()
abstract class QRScannerFlutterApi {
  void onQRCodeDetected(QRScanResult result);
}