import 'package:equatable/equatable.dart';

class QRScan extends Equatable {
  final int? id;
  final String content;
  final String format;
  final DateTime timestamp;

  const QRScan({
    this.id,
    required this.content,
    required this.format,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [id, content, format, timestamp];
}