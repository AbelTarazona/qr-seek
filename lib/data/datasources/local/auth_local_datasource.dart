import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:seek_challenge/data/models/user_model.dart';

abstract class AuthLocalDatasource {
  /// Obtiene la información del usuario autenticado
  Future<UserModel> getUser();

  /// Guarda un PIN de respaldo
  Future<bool> savePin(String pin);

  /// Verifica un PIN de respaldo
  Future<bool> verifyPin(String pin);

  /// Actualiza el estado de la configuración biométrica
  Future<bool> updateBiometricSetup(bool hasSetup);
}

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  final FlutterSecureStorage _secureStorage;

  // Claves para el almacenamiento seguro
  static const String _userKey = 'user_info';
  static const String _pinKey = 'backup_pin';

  // ID de usuario por defecto
  static const String _defaultUserId = 'default_user';

  AuthLocalDatasourceImpl(this._secureStorage);

  @override
  Future<UserModel> getUser() async {
    try {
      final userJson = await _secureStorage.read(key: _userKey);

      if (userJson != null) {
        return UserModel.fromJson(json.decode(userJson));
      } else {
        // Crear usuario por defecto si no existe
        final defaultUser = UserModel(
          id: _defaultUserId,
          hasSetupBiometric: false,
          hasSetupPin: false,
        );

        // Guardar usuario por defecto
        await _secureStorage.write(
          key: _userKey,
          value: json.encode(defaultUser.toJson()),
        );

        return defaultUser;
      }
    } catch (e) {
      throw Exception('Error al obtener información del usuario: $e');
    }
  }

  @override
  Future<bool> savePin(String pin) async {
    try {
      await _secureStorage.write(key: _pinKey, value: pin);

      // Actualizar el estado del usuario
      final user = await getUser();
      final updatedUser = UserModel(
        id: user.id,
        hasSetupBiometric: user.hasSetupBiometric,
        hasSetupPin: true,
      );

      await _secureStorage.write(
        key: _userKey,
        value: json.encode(updatedUser.toJson()),
      );

      return true;
    } catch (e) {
      throw Exception('Error al guardar el PIN: $e');
    }
  }

  @override
  Future<bool> verifyPin(String pin) async {
    try {
      final savedPin = await _secureStorage.read(key: _pinKey);
      return savedPin == pin;
    } catch (e) {
      throw Exception('Error al verificar el PIN: $e');
    }
  }

  @override
  Future<bool> updateBiometricSetup(bool hasSetup) async {
    try {
      final user = await getUser();
      final updatedUser = UserModel(
        id: user.id,
        hasSetupBiometric: hasSetup,
        hasSetupPin: user.hasSetupPin,
      );

      await _secureStorage.write(
        key: _userKey,
        value: json.encode(updatedUser.toJson()),
      );

      return true;
    } catch (e) {
      throw Exception('Error al actualizar configuración biométrica: $e');
    }
  }
}