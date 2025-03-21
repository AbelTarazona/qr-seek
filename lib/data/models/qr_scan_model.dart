import 'package:seek_challenge/domain/entities/qr_scan.dart';

class QRScanModel extends QRScan {
  const QRScanModel({
    super.id,
    required super.content,
    required super.format,
    required super.timestamp,
  });

  factory QRScanModel.fromJson(Map<String, dynamic> json) {
    return QRScanModel(
      id: json['id'],
      content: json['content'],
      format: json['format'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'format': format,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory QRScanModel.fromEntity(QRScan scan) {
    return QRScanModel(
      id: scan.id,
      content: scan.content,
      format: scan.format,
      timestamp: scan.timestamp,
    );
  }
}
