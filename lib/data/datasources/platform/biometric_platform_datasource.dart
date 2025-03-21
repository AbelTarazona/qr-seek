import 'package:seek_challenge/pigeon.g.dart';

abstract class BiometricPlatformDatasource {
  /// Verifica si el dispositivo tiene capacidades biométricas
  Future<bool> isBiometricAvailable();

  /// Autentica al usuario usando biometría
  Future<BiometricAuthResult> authenticateWithBiometrics();
}

class BiometricPlatformDatasourceImpl implements BiometricPlatformDatasource {
  final BiometricAuthApi _biometricAuthApi;

  BiometricPlatformDatasourceImpl(this._biometricAuthApi);

  @override
  Future<bool> isBiometricAvailable() async {
    try {
      return await _biometricAuthApi.isBiometricAvailable();
    } catch (e) {
      throw Exception('Error al verificar la disponibilidad biométrica: $e');
    }
  }

  @override
  Future<BiometricAuthResult> authenticateWithBiometrics() async {
    try {
      return await _biometricAuthApi.authenticateWithBiometrics();
    } catch (e) {
      throw Exception('Error en la autenticación biométrica: $e');
    }
  }
}
