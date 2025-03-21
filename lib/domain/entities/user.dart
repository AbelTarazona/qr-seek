import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final bool hasSetupBiometric;
  final bool hasSetupPin;

  const User({
    required this.id,
    required this.hasSetupBiometric,
    required this.hasSetupPin,
  });

  @override
  List<Object> get props => [id, hasSetupBiometric, hasSetupPin];
}
