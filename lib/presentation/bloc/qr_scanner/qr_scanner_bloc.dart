import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seek_challenge/core/usecases/usecase.dart';
import 'package:seek_challenge/domain/entities/qr_scan.dart';
import 'package:seek_challenge/domain/repositories/qr_scan_repository.dart';
import 'package:seek_challenge/domain/usecases/qr/get_all_scans.dart';
import 'package:seek_challenge/domain/usecases/qr/save_scan.dart';

part 'qr_scanner_event.dart';
part 'qr_scanner_state.dart';

class QrScannerBloc extends Bloc<QrScannerEvent, QrScannerState> {
  final StartScanner startScanner;
  final StopScanner stopScanner;
  final SaveScan saveScan;
  final GetAllScans getAllScans;
  final GetScanById getScanById;
  final DeleteScan deleteScan;
  final QRScanRepository repository;

  late StreamSubscription<QRScan> _scanSubscription;

  QrScannerBloc({
    required this.startScanner,
    required this.stopScanner,
    required this.saveScan,
    required this.getAllScans,
    required this.getScanById,
    required this.deleteScan,
    required this.repository,
  }) : super(QRScannerInitial()) {
    on<StartScannerEvent>(_onStartScanner);
    on<StopScannerEvent>(_onStopScanner);
    on<SaveScanEvent>(_onSaveScan);
    on<LoadScansEvent>(_onLoadScans);
    on<DeleteScanEvent>(_onDeleteScan);
    on<QRCodeDetectedEvent>(_onQRCodeDetected);

    // Suscribirse al stream de escaneos
    _scanSubscription = repository.scanStream.listen((scan) {
      add(QRCodeDetectedEvent(scan: scan));
    });
  }

  Future<void> _onStartScanner(
      StartScannerEvent event,
      Emitter<QrScannerState> emit,
      ) async {
    emit(QRScannerLoading());
    final result = await startScanner(NoParams());

    result.fold(
          (failure) => emit(QRScannerError(message: failure.message)),
          (_) => emit(ScannerActiveState()),
    );
  }

  Future<void> _onStopScanner(
      StopScannerEvent event,
      Emitter<QrScannerState> emit,
      ) async {
    final result = await stopScanner(NoParams());

    result.fold(
          (failure) => emit(QRScannerError(message: failure.message)),
          (_) => emit(ScannerInactiveState()),
    );
  }

  Future<void> _onQRCodeDetected(
      QRCodeDetectedEvent event,
      Emitter<QrScannerState> emit,
      ) async {
    emit(QRCodeDetectedState(scan: event.scan));
    // Automáticamente guardar el escaneo
    add(SaveScanEvent(scan: event.scan));
  }

  Future<void> _onSaveScan(
      SaveScanEvent event,
      Emitter<QrScannerState> emit,
      ) async {
    emit(QRScannerLoading());
    final result = await saveScan(ScanParams(scan: event.scan));

    result.fold(
          (failure) => emit(QRScannerError(message: failure.message)),
          (savedScan) => emit(ScanSavedState(scan: savedScan)),
    );
  }

  Future<void> _onLoadScans(
      LoadScansEvent event,
      Emitter<QrScannerState> emit,
      ) async {
    emit(QRScannerLoading());
    final result = await getAllScans(NoParams());

    result.fold(
          (failure) => emit(QRScannerError(message: failure.message)),
          (scans) => emit(ScansLoadedState(scans: scans)),
    );
  }

  Future<void> _onDeleteScan(
      DeleteScanEvent event,
      Emitter<QrScannerState> emit,
      ) async {
    emit(QRScannerLoading());
    final result = await deleteScan(ScanIdParams(id: event.id));

    result.fold(
          (failure) => emit(QRScannerError(message: failure.message)),
          (isDeleted) {
        if (isDeleted) {
          add(LoadScansEvent());
        } else {
          emit(QRScannerError(message: 'No se pudo eliminar el escaneo'));
        }
      },
    );
  }

  @override
  Future<void> close() {
    _scanSubscription.cancel();
    return super.close();
  }
}
