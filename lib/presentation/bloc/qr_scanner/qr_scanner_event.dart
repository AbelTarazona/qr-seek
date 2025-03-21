part of 'qr_scanner_bloc.dart';

sealed class QrScannerEvent extends Equatable {
  const QrScannerEvent();

  @override
  List<Object?> get props => [];
}

class StartScannerEvent extends QrScannerEvent {}

class StopScannerEvent extends QrScannerEvent {}

class QRCodeDetectedEvent extends QrScannerEvent {
  final QRScan scan;

  const QRCodeDetectedEvent({required this.scan});

  @override
  List<Object> get props => [scan];
}

class SaveScanEvent extends QrScannerEvent {
  final QRScan scan;

  const SaveScanEvent({required this.scan});

  @override
  List<Object> get props => [scan];
}

class LoadScansEvent extends QrScannerEvent {}

class DeleteScanEvent extends QrScannerEvent {
  final int id;

  const DeleteScanEvent({required this.id});

  @override
  List<Object> get props => [id];
}