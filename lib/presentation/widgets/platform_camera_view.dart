import 'package:flutter/material.dart';
import 'package:seek_challenge/pigeon.g.dart';

/// Un widget que muestra la vista previa de la cámara nativa
class PlatformCameraView extends StatefulWidget {
  const PlatformCameraView({super.key});

  @override
  State<PlatformCameraView> createState() => _PlatformCameraViewState();
}

class _PlatformCameraViewState extends State<PlatformCameraView> {
  final QRScannerApi _qrScannerApi = QRScannerApi();
  int? _textureId;
  double _previewWidth = 0;
  double _previewHeight = 0;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeCameraPreview();
  }

  Future<void> _initializeCameraPreview() async {
    try {
      setState(() {
        _loading = true;
        _error = null;
      });

      // Obtener la textura de la cámara del módulo nativo usando Pigeon
      final result = await _qrScannerApi.getCameraTexture();

      if (result.error != null) {
        setState(() {
          _loading = false;
          _error = result.error;
        });
        return;
      }

      setState(() {
        _textureId = result.textureId;
        _previewWidth = result.width ?? 0;
        _previewHeight = result.height ?? 0;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = e.toString();
      });
      debugPrint('Error al inicializar la vista previa de la cámara: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              'Error en la cámara',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _initializeCameraPreview,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (_textureId == null || _previewWidth == 0 || _previewHeight == 0) {
      return const Center(
        child: Text('No se pudo inicializar la cámara'),
      );
    }

    return Container(
      color: Colors.black,
      child: Center(
        child: AspectRatio(
          aspectRatio: _previewWidth / _previewHeight,
          child: Texture(
            textureId: _textureId!,
            filterQuality: FilterQuality.low,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Liberar la textura de la cámara
    _qrScannerApi.disposeCameraTexture();
    super.dispose();
  }
}
