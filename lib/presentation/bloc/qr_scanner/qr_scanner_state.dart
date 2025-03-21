part of 'qr_scanner_bloc.dart';

sealed class QrScannerState extends Equatable {
  const QrScannerState();

  @override
  List<Object?> get props => [];
}

class QRScannerInitial extends QrScannerState {}

class QRScannerLoading extends QrScannerState {}

class QRScannerError extends QrScannerState {
  final String message;

  const QRScannerError({required this.message});

  @override
  List<Object> get props => [message];
}

class ScannerActiveState extends QrScannerState {}

class ScannerInactiveState extends QrScannerState {}

class QRCodeDetectedState extends QrScannerState {
  final QRScan scan;

  const QRCodeDetectedState({required this.scan});

  @override
  List<Object> get props => [scan];
}

class ScanSavedState extends QrScannerState {
  final QRScan scan;

  const ScanSavedState({required this.scan});

  @override
  List<Object> get props => [scan];
}

class ScansLoadedState extends QrScannerState {
  final List<QRScan> scans;

  const ScansLoadedState({required this.scans});

  @override
  List<Object> get props => [scans];
}
