import 'package:seek_challenge/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.hasSetupBiometric,
    required super.hasSetupPin,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      hasSetupBiometric: json['hasSetupBiometric'],
      hasSetupPin: json['hasSetupPin'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hasSetupBiometric': hasSetupBiometric,
      'hasSetupPin': hasSetupPin,
    };
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      hasSetupBiometric: user.hasSetupBiometric,
      hasSetupPin: user.hasSetupPin,
    );
  }
}
